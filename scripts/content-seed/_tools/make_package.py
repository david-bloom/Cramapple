#!/usr/bin/env python3
"""Build items.json and the Production load/publish/retire SQL for one subject batch (nothing is executed).
Usage: python3 make_package.py <folder> <config.json>
<folder> holds source_draft.md, retire_keys.json, seed_map.json (written by the author).
config.json: {"subject":"AP Physics 1","pack":"<exam_pack_version_id>","tsv":"<taxonomy_source_version>","prefix":"apphysics1-mcq-b2",
              "tag":"apphysics1_u3b_2026_11_12","date":"2026-11-12","label_req":{"3.1":[3],"3.2":[3]},"seed":20261201}
Keys are <prefix>-h-<topic>-<letter> (seed) and <prefix>-sv-h-<topic>-<letter>-v<k> (variant)."""
import json,os,re,random,sys,shutil
folder=os.path.abspath(sys.argv[1]); cfg=json.load(open(sys.argv[2]))
HERE=os.path.dirname(os.path.abspath(__file__)); CONTENT=os.path.dirname(HERE)
seedmap=json.load(open(f"{folder}/seed_map.json")); retire=json.load(open(f"{folder}/retire_keys.json"))["retire"]
L=open(f"{folder}/source_draft.md").read().split("\n"); items=[];cur=None
for l in L:
    ms=re.match(r"^## Seed (N-\d+\.\d+-[A-Z])\b",l); mv=re.match(r"^\*\*(N-\d+\.\d+-[A-Z]-v\d)\.\*\*\s*(.*)",l)
    if ms or mv:
        cur=dict(id=(ms or mv).group(1),stem=[mv.group(2)] if mv else [],ch=[],rat={},chk="",head=l if ms else "");items.append(cur);continue
    if l.startswith("---"): cur=None
    if cur is None: continue
    c=re.match(r"^- (\*\*)?([A-D])\. (.*?)(\*\*)?$",l)
    if c: cur["ch"].append(dict(k=c.group(2),t=c.group(3).rstrip("*").strip(),ok=bool(c.group(1))));continue
    if l.startswith("Rationales:"):
        for k,t in re.findall(r"([A-D]): (.*?)(?= [A-D]: |$)",l[len("Rationales:"):].strip()): cur["rat"][k]=t.strip()
        continue
    if l.startswith("Check:"): cur["chk"]=l[6:].strip();continue
    if not cur["ch"] and l.strip() and not l.startswith("**Skill"): cur["stem"].append(l.strip())
N=len(items); rng=random.Random(cfg.get("seed",20261201)); t=list("ABCD")*((N+3)//4); rng.shuffle(t); targets=t[:N]
rows=[]
for x,tg in zip(items,targets):
    m=re.match(r"N-(\d+\.\d+-[A-Z])(?:-v(\d))?$",x["id"]); fam,v=m.group(1),m.group(2); topic=fam.split("-")[0]
    key=f"{cfg['prefix']}-sv-h-{fam.lower()}-v{v}" if v else f"{cfg['prefix']}-h-{fam.lower()}"
    sm=seedmap.get(f"N-{fam}",{}); title=(sm.get("skill") or fam)[:120]+(f" (variant {v})" if v else "")
    assert len(x["ch"])==4 and sum(c["ok"] for c in x["ch"])==1,x["id"]
    ch=[]
    for c in x["ch"]:
        if c["ok"]: r="Correct: "+re.sub(r"\s+"," ",x["chk"]).rstrip(".")+"."
        else:
            r=re.sub(r"\s+"," ",x["rat"][c["k"]]).strip(); r=r[0].upper()+r[1:]
            if not r.endswith((".",")")): r+="."
        assert len(r)>=(25 if c["ok"] else 40),(x["id"],r)
        ch.append(dict(text=c["t"],ok=c["ok"],rat=r))
    assert len({c["rat"] for c in ch})==4,x["id"]
    corr=[c for c in ch if c["ok"]][0]; others=[c for c in ch if not c["ok"]]; pos="ABCD".index(tg); new=others[:pos]+[corr]+others[pos:]
    rows.append(dict(src_id=x["id"],content_key=key,family=fam,variant=v,topic=topic,title=title,stem="\n".join(s for s in x["stem"] if s.strip()),key=tg,
        choices=[dict(label="ABCD"[i],text=c["text"],is_correct=c["ok"],rationale=c["rat"]) for i,c in enumerate(new)]))
assert len({r["content_key"] for r in rows})==N
for r in rows: assert r["topic"].split(".")[0]==str(cfg.get("unit",3)) and r["topic"] in cfg["label_req"],("no label mapping for topic",r["topic"])
json.dump(rows,open(f"{folder}/items.json","w"),indent=1,ensure_ascii=False)
json.dump(retire,open(f"{folder}/superseded_keys.json","w"),indent=1)
# --- SQL package from the chemistry template
g=open(f"{CONTENT}/apchem-harder-seeds-u3-2026-11-11/gen_package.py").read()
reqcase="(case topic "+" ".join(f"when '{t}' then array{v}" for t,v in cfg["label_req"].items())+" end)::int[]"
U=cfg.get("unit",3)
tag=cfg["tag"]; stag=tag.replace("_","-"); d=cfg["date"]; dc=d.replace("-","")
R=[("c9ca46b2-b529-4ed3-9741-dddea455ab9b",cfg["pack"]),("cbe3116f-6ef5-410c-b535-e9fb711c4c2c",cfg["tsv"]),
 ("apchem_u3_harder_topic_2026_11_11",tag+"_topic"),("apchem_u3_harder_2026_11_11",tag),("apchem_u3_harder_po_approval",tag+"_po_approval"),
 ("apchem-u3-harder-labeling-2026-11-11",stag+"-labeling"),("cramapple-apchem-u3-harder-publish-20261111",f"cramapple-{stag}-publish-{dc}"),("cramapple-apchem-u3-harder-retire-20261111",f"cramapple-{stag}-retire-{dc}"),
 ("'apchem-mcq-sv-h-3.%'",f"'{cfg['prefix']}-sv-h-{U}.%'"),("'apchem-mcq-h-3.%'",f"'{cfg['prefix']}-h-{U}.%'"),("'2026-11-11'",f"'{d}'"),("2026-11-11",d),
 ("AP Chemistry harder seeds and variants (topics 3.1 to 3.3)",f"{cfg['subject']} Unit 3 harder seeds and variants (batch {tag})"),
 ("Chemistry Unit 3 (topics 3.x belong to unit 3; existing Unit 3 serving labels use required_units [3], primary_unit 3)",f"{cfg['subject']} Unit 3 (topics 3.x belong to unit 3; required_units set per topic from existing Unit 3 labels)"),
 ("the Chemistry taxonomy source version",f"the {cfg['subject']} taxonomy source version"),
 ("array[3]::int[] req, 3 pu",reqcase+f" req, {U} pu"),("req, 3, pu",f"req, {U}, pu"),("Unit 3 (topics 3.x","Unit "+str(U)+" (topics "+str(U)+".x"),
 ("AP Chemistry harder seeds and variants)",f"{cfg['subject']} harder seeds and variants)"),
 ("scripts/content-seed/apchem-harder-seeds-u3-2026-11-11","scripts/content-seed/"+os.path.basename(folder))]
for a,b in R: g=g.replace(a,b)
# The template's prose is not covered by its identifier substitutions. Keep the
# generated review note and taxonomy provenance truthful for every unit.
g=re.sub(r'^NOTE=.*$',
         'NOTE="'+cfg['subject']+f' Unit {U} harder seeds and variants (batch {tag}); owner-authorized production content release after the batch checks recorded in the status document. No subject-expert review is claimed."',
         g,flags=re.M)
g=g.replace(f"topics {U}.x belong to unit 3; required_units set per topic from existing Unit 3 labels",
            f"topics {U}.x belong to unit {U}; required_units set per topic from verified serving labels and taxonomy mapping")
g=re.sub(r"scripts/content-seed/apchem-harder-seeds-u3-\d{4}-\d{2}-\d{2}",
         "scripts/content-seed/"+os.path.basename(folder),g)
i=g.index("OLD=["); j=g.index("assert len(OLD)"); k=g.index("\n",j)
g=g[:i]+"OLD=json.load(open('superseded_keys.json'))\nNOLD=len(OLD)\nassert NOLD==len(set(OLD))"+g[k:]
# the topic guard must test the taxonomy itself, not existing content cells (a brand-new topic has no cells yet)
gi=g.index("if exists (select 1 from tgt t where not exists (select 1 from app.content_item_cells c join app.content_items ci2")
gj=g.index("end if;",gi)+len("end if;")
g=g[:gi]+"if exists (select 1 from tgt t where not exists (select 1 from app.taxonomy_topics tt where tt.taxonomy_source_version=t.tsv and tt.topic_code=t.topic)) then raise exception 'a topic code is not present in the taxonomy source version'; end if;"+g[gj:]
g=g.replace("<>12","<>{NOLD}").replace("expected 12 published","expected {NOLD} published")
g=g.replace("assert N==24","assert N==%d"%N).replace("<>24","<>{N}").replace("expected 24 draft","expected {N} draft")
g="\n".join(line.rstrip() for line in g.splitlines())+"\n"
open(f"{folder}/gen_package.py","w").write(g)
os.chdir(folder); os.system("python3 gen_package.py | head -2")
for path in ("publish.sql","publish_rehearsal.sql","retire_old.sql","retire_old_rehearsal.sql","verify_hashes.sql"):
    if os.path.exists(path):
        s=open(path).read(); open(path,"w").write("\n".join(line.rstrip() for line in s.splitlines())+"\n")
if not retire:
    for f in ("retire_old.sql","retire_old_rehearsal.sql"):
        if os.path.exists(f): os.remove(f)
print("package built:",N,"items,",len(retire),"retirements in",folder)
