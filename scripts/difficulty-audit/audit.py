#!/usr/bin/env python3
"""Read-only difficulty audit of published MCQs. Never writes to the database.

Usage:
  python3 audit.py --subject "AP Chemistry" --topics 3.1,3.2,3.3 --out OUT_DIR
  python3 audit.py --subject all --units 1-3 --out OUT_DIR          (all subjects, units 1 to 3)
  python3 audit.py --subject "AP Calculus AB" --out OUT_DIR --no-model   (fetch + duplicates only)

Steps: (1) fetch published MCQs with `supabase db query --linked` run from --workdir (default ~/supabase, which
links PRODUCTION; the query is a SELECT only). (2) two different-family models tier each item R1/R2/R3 and name
the misconception behind each distractor (cached by item hash). (3) semantic duplicate detection. (4) CSV outputs:
items.csv and summary.csv. Tiers are model judgements until calibrated against a subject-matter reader.
Needs AI_GATEWAY_API_KEY in the environment or in scripts/vercel-gateway-check/.env.local (never printed).
"""
import difflib,argparse,csv,hashlib,json,os,re,subprocess,sys,time,collections,concurrent.futures as cf,urllib.request,tempfile
HERE=os.path.dirname(os.path.abspath(__file__)); ROOT=os.path.abspath(os.path.join(HERE,"..",".."))
MODELS=["deepseek/deepseek-v4-pro","moonshotai/kimi-k3.1-pro"]
RUBRIC="""You are an expert AP teacher and item reviewer. Judge the COGNITIVE DEMAND of the multiple-choice question below, for a student preparing for the AP exam named in the header. Work the problem yourself first.
Tiers:
R1 = one-step recall or one-step substitution (a definition, name a term, plug into one formula once). Distractors are formula slips or implausible.
R2 = apply a method with a couple of steps, or choose/apply a procedure in a short context.
R3 = interpretation, multi-step reasoning, or misconception-driven reasoning where each wrong choice is a real student error; close to real AP exam difficulty.
Reply with ONLY a JSON object: {"tier":"R1|R2|R3","keyed_correct":true|false,"misconceptions":{"<letter>":"<the student error this wrong choice represents, or 'implausible'>"},"reason":"<=25 words"}
"keyed_correct" is whether the choice marked as correct really is the correct answer."""

def key():
    k=os.environ.get("AI_GATEWAY_API_KEY")
    if k: return k
    p=os.path.join(ROOT,"scripts","vercel-gateway-check",".env.local")
    if not os.path.exists(p):  # worktrees: fall back to the main checkout
        p=os.path.join(subprocess.check_output(["git","-C",ROOT,"rev-parse","--git-common-dir"],text=True).strip(),"..","scripts","vercel-gateway-check",".env.local")
    for l in open(p):
        m=re.match(r'\s*AI_GATEWAY_API_KEY\s*=\s*"?([^"\s]+)',l)
        if m: return m.group(1)
    sys.exit("no AI_GATEWAY_API_KEY")

def sql(a):
    w=[]
    if a.subject!="all": w.append("ep.exam_name='%s'"%a.subject.replace("'","''"))
    if a.topics: w.append("c.topic_code in (%s)"%",".join("'%s'"%t for t in a.topics.split(",")))
    if a.units:
        lo,_,hi=a.units.partition("-"); hi=hi or lo
        w.append("split_part(c.topic_code,'.',1)::int between %d and %d"%(int(lo),int(hi)))
    where=(" and "+" and ".join(w)) if w else ""
    return f"""select json_agg(x order by x.subject, split_part(x.topic,'.',1)::int, split_part(x.topic,'.',2)::int, x.content_key) j from (
select ep.exam_name subject, c.topic_code topic, ci.content_key, v.stimulus, v.stem,
 (select json_agg(json_build_object('k',m.choice_key,'t',m.choice_text,'c',m.is_correct) order by m.choice_key) from app.mcq_choices m where m.content_item_version_id=v.id) choices
from app.content_items ci join app.content_item_versions v on v.content_item_id=ci.id and v.status='published'
join app.content_item_cells c on c.content_item_version_id=v.id and c.is_primary and c.superseded_by is null
join app.exam_pack_versions p on p.id=ci.exam_pack_version_id join app.exam_packs ep on ep.id=p.exam_pack_id
where ci.status='published' and ci.item_type='mcq' and c.topic_code ~ '^[0-9]+[.][0-9]+$'{where}) x;"""

def fetch(a):
    with tempfile.NamedTemporaryFile("w",suffix=".sql",delete=False) as f: f.write(sql(a)); p=f.name
    r=subprocess.run(["supabase","db","query","--linked","-f",p,"-o","json"],capture_output=True,text=True,cwd=a.workdir)
    if "{\n" not in r.stdout: sys.exit("query failed: "+(r.stderr or r.stdout)[-400:])
    out=r.stdout
    os.unlink(p); t=out[out.index("{\n"):]; d=json.JSONDecoder().raw_decode(t)[0]["rows"][0]["j"]
    return json.loads(d) if isinstance(d,str) else (d or [])

def load_file(a):
    out=[]
    for r in json.load(open(a.items_file)):
        out.append({"subject":a.subject_label,"topic":r["topic"],"content_key":r["content_key"],"stimulus":None,"stem":r["stem"],
                    "choices":[{"k":c["label"],"t":c["text"],"c":c["is_correct"]} for c in r["choices"]]})
    return out

def fam(k):
    k2=re.sub(r"-v\d+$","",k); k2=re.sub(r"-sv-","-",k2,flags=re.I); k2=re.sub(r"-SV-","-",k2); return k2.lower()

def norm(s):
    s=(s or "").lower(); s=re.sub(r"\\[()\[\]]","",s); s=s.replace("−","-").replace("′","'").replace("²","^2").replace("³","^3").replace("π","pi")
    s=re.sub(r"\\(?:left|right|,|;|!)","",s); s=re.sub(r"\\(?:dfrac|frac)","frac",s); s=re.sub(r"[{}\s$]","",s); return s
def sig(r): return (frozenset(norm(c["t"]) for c in r["choices"]), tuple(re.findall(r"-?\d+\.?\d*",norm((r["stimulus"] or "")+r["stem"]))))
def dups(items):
    out={}; byc=collections.defaultdict(list)
    for r in items: byc[sig(r)[0]].append(r)
    for g in byc.values():
        if len(g)<2: continue
        # same choice set: duplicate if the stem numbers/function text also match after normalisation
        for i,r in enumerate(g):
            for o in g[:i]:
                a=re.sub(r"(what is|find|if|the|\?|,|\.)","",norm(r["stem"])); b=re.sub(r"(what is|find|if|the|\?|,|\.)","",norm(o["stem"]))
                # same choice set AND near-identical question text (numbers alone are not enough: different functions can share answers)
                if a==b or difflib.SequenceMatcher(None,a,b).ratio()>=0.85: out.setdefault(r["content_key"],o["content_key"]); break
    return out

def prompt(r):
    ch="\n".join(f"{c['k']}. {c['t']}"+("   <- marked correct" if c["c"] else "") for c in r["choices"])
    return f"{RUBRIC}\n\nExam: {r['subject']}  Topic code: {r['topic']}\n\n{((r['stimulus'] or '')+chr(10)+r['stem']).strip()}\n\n{ch}"
def ihash(r): return hashlib.md5((r["subject"]+prompt(r)).encode()).hexdigest()[:16]
def call(model,r,k):
    body=json.dumps({"model":model,"messages":[{"role":"user","content":prompt(r)}],"max_tokens":6000}).encode(); err=""
    for _ in range(3):
        try:
            req=urllib.request.Request("https://ai-gateway.vercel.sh/v1/chat/completions",data=body,headers={"Authorization":"Bearer "+k,"Content-Type":"application/json"})
            t=json.load(urllib.request.urlopen(req,timeout=300))["choices"][0]["message"]["content"] or ""
            m=re.search(r"\{.*\}",t,re.S); j=json.loads(m.group(0)); assert j["tier"] in ("R1","R2","R3"); return j
        except Exception as e: err=str(e)[:100]; time.sleep(3)
    return {"tier":None,"error":err}

def main():
    ap=argparse.ArgumentParser(); ap.add_argument("--subject",default="all"); ap.add_argument("--topics"); ap.add_argument("--units"); ap.add_argument("--out",required=True)
    ap.add_argument("--workdir",default=os.path.expanduser("~/supabase")); ap.add_argument("--no-model",action="store_true"); ap.add_argument("--items-file",help="pre-publish check: a package items.json (stem/choices/content_key/topic) instead of the database"); ap.add_argument("--subject-label",default="Draft"); ap.add_argument("--workers",type=int,default=16); ap.add_argument("--models",default=",".join(MODELS)); a=ap.parse_args()
    os.makedirs(a.out,exist_ok=True); items=load_file(a) if a.items_file else fetch(a); print("fetched",len(items),"published MCQs")
    json.dump(items,open(os.path.join(a.out,"items.json"),"w"),indent=1,ensure_ascii=False)
    dd=dups(items); res={r["content_key"]:{} for r in items}
    if not a.no_model:
        k=key(); cache_p=os.path.join(a.out,"cache.json"); cache=json.load(open(cache_p)) if os.path.exists(cache_p) else {}
        jobs=[(m,r) for r in items for m in a.models.split(",") if not cache.get(f"{m}|{ihash(r)}",{}).get("tier")]
        print("model calls needed",len(jobs),"(cached",len(items)*len(a.models.split(","))-len(jobs),")")
        with cf.ThreadPoolExecutor(a.workers) as ex:
            for n,((m,r),j) in enumerate(zip(jobs,ex.map(lambda mr:call(mr[0],mr[1],k),jobs)),1):
                if j.get("tier"): cache[f"{m}|{ihash(r)}"]=j   # never cache a failed call
                if n%100==0: json.dump(cache,open(cache_p,"w")); print("progress",n,"of",len(jobs),flush=True)
        json.dump(cache,open(cache_p,"w"))
        for r in items:
            for m in a.models.split(","): res[r["content_key"]][m]=cache.get(f"{m}|{ihash(r)}",{"tier":None,"error":"no result"})
    rows=[]
    for r in items:
        rs=res[r["content_key"]]; tiers=[v.get("tier") for v in rs.values() if v.get("tier")]
        final=min(tiers) if tiers else ""; dis=len(set(tiers))>1
        kc=[v.get("keyed_correct") for v in rs.values() if "keyed_correct" in v]
        flags=[]
        if len(tiers)<len(a.models.split(",")) and not a.no_model: flags.append("model_missing")  # a tier from fewer models than requested is not a two-model rating
        if dis: flags.append("models_disagree")
        if any(x is False for x in kc): flags.append("key_disputed")
        if r["content_key"] in dd: flags.append("duplicate_of:"+dd[r["content_key"]])
        rows.append(dict(subject=r["subject"],topic=r["topic"],content_key=r["content_key"],family=fam(r["content_key"]),tier=final,tiers="/".join(tiers),flags="; ".join(flags),
            reason=" | ".join(v.get("reason","") for v in rs.values()),stem=((r["stimulus"] or "")+" "+r["stem"]).strip()[:300]))
    with open(os.path.join(a.out,"items.csv"),"w",newline="") as f:
        w=csv.DictWriter(f,fieldnames=list(rows[0])); w.writeheader(); w.writerows(rows)
    g=collections.defaultdict(list)
    for r in rows: g[(r["subject"],r["topic"])].append(r)
    with open(os.path.join(a.out,"summary.csv"),"w",newline="") as f:
        w=csv.writer(f); w.writerow(["subject","topic","mcqs","R1","R2","R3","r1_share","seed_families","r1_seed_families","duplicates","disputed_keys","disagreements"])
        for (s,t),v in g.items():
            c=collections.Counter(x["tier"] for x in v); fams=collections.defaultdict(list)
            for x in v: fams[x["family"]].append(x)
            r1f=sum(1 for fl in fams.values() if all(x["tier"]=="R1" for x in fl))
            w.writerow([s,t,len(v),c["R1"],c["R2"],c["R3"],round(c["R1"]/len(v),2),len(fams),r1f,sum("duplicate_of" in x["flags"] for x in v),sum("key_disputed" in x["flags"] for x in v),sum("models_disagree" in x["flags"] for x in v)])
    print("wrote",a.out)
if __name__=="__main__": main()
