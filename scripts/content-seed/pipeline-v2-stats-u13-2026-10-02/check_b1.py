import json,re
V=json.load(open("variants_b1.json")); S={s["key"]:s for s in json.load(open("seeds_b1.json"))}
tok=lambda t:set(re.findall(r"[a-z0-9.]+",t.lower()))
def txt(stem,ch): return stem+" "+" ".join(ch)
def vt(v): return txt(v["stem"],[v["correct"]["text"]]+[w["text"] for w in v["wrong"]])
def st(s): return txt((s["stimulus"] or "")+" "+s["stem"],[c["text"] for c in s["choices"]])
J=lambda a,b:len(tok(a)&tok(b))/len(tok(a)|tok(b))
bad=0
for v in V:
    ch=[v["correct"]]+v["wrong"]
    ok=len(v["wrong"])==3 and len({c["text"] for c in ch})==4 and all(c["rationale"].strip() for c in ch)
    ok&=not re.search(r"(^|\s)[A-D][\.\)]\s",v["stem"])
    ml=max(len(w["text"]) for w in v["wrong"])
    if len(v["correct"]["text"])>1.4*ml: ok=False;print("len",v["id"])
    j=J(vt(v),st(S[v["seed"]]))
    sib=[J(vt(v),vt(o)) for o in V if o is not v and o["seed"]==v["seed"]]
    if j>=.7 or any(x>=.7 for x in sib): ok=False
    if not ok: bad+=1;print("FAIL",v["id"],j,sib)
print(len(V),"bad",bad)
