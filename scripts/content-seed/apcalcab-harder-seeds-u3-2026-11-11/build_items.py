"""Parse source_draft.md into items.json (48 AP Statistics Unit 3 items). Deterministic."""
import re,json,random,os
HERE=os.path.dirname(os.path.abspath(__file__))
L=open(os.path.join(HERE,"source_draft.md")).read().split("\n")
TITLE={"3.1-A":"Product and chain rules with an unspecified function","3.1-B":"Interpret a composite rate with units",
"3.2-A":"Horizontal tangents of an implicit curve","3.2-B":"Vertical tangents and undefined slope",
"3.3-A":"Tangent line to an inverse function","3.3-B":"When an inverse function is not differentiable"}
items=[];cur=None
for l in L:
    ms=re.match(r"^## Seed (N-3\.\d+-[A-C])\b",l); mv=re.match(r"^\*\*(N-3\.\d+-[A-C]-v\d)\.\*\*\s*(.*)",l)
    if ms or mv:
        cur=dict(id=(ms or mv).group(1),stem=[mv.group(2)] if mv else [],ch=[],rat={},chk=""); items.append(cur); continue
    if l.startswith("---"): cur=None
    if cur is None: continue
    c=re.match(r"^- (\*\*)?([A-D])\. (.*?)(\*\*)?$",l)
    if c: cur["ch"].append(dict(k=c.group(2),t=c.group(3).rstrip("*").strip(),ok=bool(c.group(1)))); continue
    if l.startswith("Rationales:"):
        for k,t in re.findall(r"([A-D]): (.*?)(?= [A-D]: |$)",l[len("Rationales:"):].strip()): cur["rat"][k]=t.strip()
        continue
    if l.startswith("Check:"): cur["chk"]=l[6:].strip(); continue
    if not cur["ch"] and l.strip() and not l.startswith("**Skill"): cur["stem"].append(l.strip())
assert len(items)==24
rng=random.Random(20261114); targets=list("ABCD")*6; rng.shuffle(targets)
rows=[]
for x,tg in zip(items,targets):
    m=re.match(r"N-(3\.\d+-[A-C])(?:-v(\d))?$",x["id"]); fam,v=m.group(1),m.group(2)
    key=f"apcalcab-mcq-sv-h-{fam.lower()}-v{v}" if v else f"apcalcab-mcq-h-{fam.lower()}"
    assert len(x["ch"])==4 and sum(c["ok"] for c in x["ch"])==1,x["id"]
    ch=[]
    for c in x["ch"]:
        if c["ok"]:
            r="Correct: "+re.sub(r"\s+"," ",x["chk"]).rstrip(".")+"."
        else:
            r=x["rat"][c["k"]]; r=re.sub(r"\s+"," ",r).strip(); r=r[0].upper()+r[1:]
            if not r.endswith((".",")")): r+="."
        ch.append(dict(text=c["t"],ok=c["ok"],rat=r))
        assert len(r)>=(25 if c["ok"] else 40),(x["id"],r)
        assert r[0].isupper() or r[0] in "(0123456789",(x["id"],r)
        assert not re.search(r"\b(above|below)\b.*\b(choice|option)|all of the\b|none of the\b|(?:^|\s)\([A-D]\)\s",c["t"]),x["id"]
    assert len({c["rat"] for c in ch})==4,x["id"]
    corr=[c for c in ch if c["ok"]][0]; others=[c for c in ch if not c["ok"]]
    pos="ABCD".index(tg); new=others[:pos]+[corr]+others[pos:]
    stem="\n".join(s for s in x["stem"] if s.strip())
    assert "N-3." not in stem
    rows.append(dict(src_id=x["id"],content_key=key,seed=None if not v else f"apcalcab-mcq-h-{fam.lower()}",family=fam,variant=v,topic=fam.split("-")[0],
      title=TITLE[fam]+(f" (variant {v})" if v else ""),stem=stem,key=tg,
      choices=[dict(label="ABCD"[i],text=c["text"],is_correct=c["ok"],rationale=c["rat"]) for i,c in enumerate(new)]))
assert len({r["content_key"] for r in rows})==24
json.dump(rows,open(os.path.join(HERE,"items.json"),"w"),indent=1,ensure_ascii=False)
import collections
print(len(rows),collections.Counter(r["key"] for r in rows),sorted(collections.Counter(r["topic"] for r in rows).items(),key=lambda t:float(t[0])))
