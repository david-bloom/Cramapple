import json,re,random,runpy,os
HERE=os.path.dirname(os.path.abspath(__file__))
X=runpy.run_path(os.path.join(HERE,"rationales_extra.py"))["X"]
P=runpy.run_path(os.path.join(HERE,"polished_rationales.py"))["P"]
import sys; sys.path.insert(0,HERE); import polish
it=json.load(open(os.path.join(HERE,"parsed.json")))
TITLE={
"2.1-A":"Compare groups by within-group percent, not counts","2.1-B":"Choose a display for groups of different sizes",
"2.2-A":"Association from conditional proportions in a two-way table","2.2-B":"Conditional probability from joint proportions",
"2.3-A":"Simulation design: waiting for the first success","2.3-B":"Estimate and reliability from simulation results",
"2.4-A":"Interpret a probability as a long-run proportion","2.4-B":"Complement rule with dice and coins",
"2.5-A":"Mutually exclusive versus independent from probabilities","2.5-B":"Addition rule with overlap, then the complement",
"2.6-A":"Independence from a two-way table","2.6-B":"Two draws without replacement",
"2.7-A":"Union of independent events","2.7-B":"At least one of several independent events",
"2.8-A":"Find the constant in a distribution, then a probability","2.8-B":"Recognize a valid probability distribution",
"2.9-A":"Mean and SD after a linear change Y = aX + b","2.9-B":"Expected net gain with a cost",
"2.10-A":"Is sampling without replacement approximately binomial","2.10-B":"Cumulative binomial probability (at least k)",
"2.11-A":"Percentile cutoff from a normal distribution","2.11-B":"Find the mean from a percentile",
"2.12-A":"Probability about a sample mean","2.12-B":"How sample size changes the SD of the sample mean"}
def keyof(i):
    m=re.match(r"N-(2\.\d+-[AB])(?:-v(\d))?$",i); fam,v=m.group(1),m.group(2)
    return (f"APSTATS-MCQ-SV-H-{fam}-v{v}" if v else f"APSTATS-MCQ-H-{fam}"),fam,v
MISSING=[]
def rationales(x):
    out={}
    notes=" ".join(x["notes"])
    segs={}
    for m in re.finditer(r"(?<![A-Za-z])([A-D])\s?[:=] (.*?)(?=(?<![A-Za-z])[A-D]\s?[:=] |$)",notes):
        t=m.group(2).strip().rstrip(".").strip()
        if t: segs.setdefault(m.group(1),t)
    chk=[n for n in x["notes"] if n.startswith("Check")]
    for c in x["choices"]:
        k=c["k"]
        r=X.get(x["id"],{}).get(k)
        if not r and not c["ok"] and k in segs: r=segs[k].rstrip(".")+"."
        if not r and c["ok"] and chk:
            body=re.split(r"\s(?<![A-Za-z])[A-D]\s?[:=] ",chk[0].replace("Check:","").strip())[0].strip()
            r="Correct: "+body
        if not r: MISSING.append((x["id"],k,c["ok"])); r="MISSING"
        r=re.sub(r"\s+"," ",r).strip()
        if not r.endswith((".",")")) and not r.endswith("?"): r+="."
        if not c["ok"]:
            r=P.get((x["id"],r)) or polish.r(x["id"],r) or r
        out[k]=r
    return out
# balance the correct-answer position (24 each of A-D), deterministic
rng=random.Random(20261110)
targets=list("ABCD")*24; rng.shuffle(targets)
rows=[]
for x,tg in zip(it,targets):
    key,fam,v=keyof(x["id"])
    rat=rationales(x)
    ch=[dict(old=c["k"],text=c["t"],ok=c["ok"],rat=rat[c["k"]]) for c in x["choices"]]
    if any(re.search(r"\b(above|below)\b.*\b(choice|option)|all of the\b|none of the\b|(?:^|\s)\([A-D]\)\s",c["text"]) for c in ch): raise SystemExit("cross-reference in "+x["id"])
    corr=[c for c in ch if c["ok"]][0]; others=[c for c in ch if not c["ok"]]
    pos="ABCD".index(tg); new=others[:pos]+[corr]+others[pos:]
    for i,c in enumerate(new): c["label"]="ABCD"[i]
    title=TITLE[fam]+(f" (variant {v})" if v else "")
    topic=fam.split("-")[0]
    stem="\n".join(l for l in x["stem_lines"] if l.strip())
    rows.append(dict(src_id=x["id"],content_key=key,seed=None if not v else f"APSTATS-MCQ-H-{fam}",family=fam,variant=v,topic=topic,title=title,stem=stem,key=tg,choices=[dict(label=c["label"],text=c["text"],is_correct=c["ok"],rationale=c["rat"]) for c in new]))
print('missing',MISSING)
assert not MISSING
BADSTART=[]
for r_ in rows:
    for c_ in r_["choices"]:
        t_=c_["rationale"]
        if not (t_[0].isupper() or t_[0] in "(−0123456789"): BADSTART.append((r_["src_id"],t_))
        assert len(t_)>=(25 if c_["is_correct"] else 40),(r_["src_id"],t_)
    assert len({c_["rationale"] for c_ in r_["choices"]})==4,r_["src_id"]
print('badstart',BADSTART)
assert not BADSTART
_by={r_["src_id"]:r_ for r_ in rows}
_by["N-2.2-B-v1"]["stem"]=_by["N-2.2-B-v1"]["stem"].replace("exercise habit and sleep.","exercise habit and sleep. The table gives the proportion of all adults in each category.",1)
_v1=_by["N-2.2-B-v1"]["stem"].split("\n")
_by["N-2.2-B-v2"]["stem"]="\n".join(_v1[:-1]+["Among adults who do not exercise regularly, what proportion sleep 8 or more hours?"])
assert not any("N-2." in r_["stem"] for r_ in rows)
assert len(rows)==96 and len({r["content_key"] for r in rows})==96
json.dump(rows,open(os.path.join(HERE,"items.json"),"w"),indent=1,ensure_ascii=False)
import collections
print(collections.Counter(r["key"] for r in rows),collections.Counter(r["topic"] for r in rows))
# spot-check
r=[r for r in rows if r["src_id"]=="N-2.6-A-v1"][0];print(r["stem"]);[print(c["label"],c["is_correct"],c["text"][:60],"|",c["rationale"][:80]) for c in r["choices"]]
