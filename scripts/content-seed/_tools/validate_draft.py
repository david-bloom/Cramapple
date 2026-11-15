#!/usr/bin/env python3
"""Validate a source_draft.md (the seed/variant authoring format) before packaging. Read-only.
Usage: python3 validate_draft.py path/to/source_draft.md [--seeds N] [--per-seed 4]
Format: '## Seed N-3.<topic>-<A..>' then stem lines, 4 choices '- A. text' (the correct one wrapped in **...**),
'Check: ...', 'Rationales: B: ... C: ... D: ...' (one entry for each WRONG letter, none for the correct letter);
variants as '**N-3.<topic>-<A..>-v1.** stem text' then the same layout. Separate seeds with '---'."""
import re,sys,collections
def main(p):
    L=open(p).read().split("\n"); items=[];cur=None
    for l in L:
        ms=re.match(r"^## Seed (N-\d+\.\d+-[A-Z])\b",l); mv=re.match(r"^\*\*(N-\d+\.\d+-[A-Z]-v\d)\.\*\*\s*(.*)",l)
        if ms or mv:
            cur=dict(id=(ms or mv).group(1),stem=[mv.group(2)] if mv else [],ch=[],rat={},chk="");items.append(cur);continue
        if l.startswith("---"): cur=None
        if cur is None: continue
        c=re.match(r"^- (\*\*)?([A-D])\. (.*?)(\*\*)?$",l)
        if c: cur["ch"].append((c.group(2),c.group(3).rstrip("*").strip(),bool(c.group(1))));continue
        if l.startswith("Rationales:"):
            for k,t in re.findall(r"([A-D]): (.*?)(?= [A-D]: |$)",l[len("Rationales:"):].strip()): cur["rat"][k]=t.strip()
            continue
        if l.startswith("Check:"): cur["chk"]=l[6:].strip();continue
        if not cur["ch"] and l.strip() and not l.startswith("**Skill"): cur["stem"].append(l.strip())
    errs=[]
    for x in items:
        i=x["id"]
        if [c[0] for c in x["ch"]]!=list("ABCD"): errs.append((i,"needs exactly choices A,B,C,D in order"));continue
        if sum(c[2] for c in x["ch"])!=1: errs.append((i,"exactly one choice must be bold (correct)"));continue
        corr=[c[0] for c in x["ch"] if c[2]][0]
        if set(x["rat"])!=set("ABCD")-{corr}: errs.append((i,f"Rationales must cover exactly the wrong letters, have {sorted(x['rat'])}, correct is {corr}"))
        if len(x["chk"])<25: errs.append((i,"Check line missing or under 25 chars"))
        if not "".join(x["stem"]).strip(): errs.append((i,"empty stem"))
        for k,t in x["rat"].items():
            if len(t)<40: errs.append((i,f"rationale {k} under 40 chars"))
            t0=t[0].upper()+t[1:]
            if not (t0[0].isupper() or t0[0] in "(0123456789"): errs.append((i,f"rationale {k} must start with a letter or digit (not a symbol such as a minus sign): {t[:30]!r}"))
        if len(set(x["rat"].values()))!=len(x["rat"]): errs.append((i,"two rationales identical"))
        if len({c[1].lower() for c in x["ch"]})!=4: errs.append((i,"duplicate choice text"))
        for c in x["ch"]:
            if re.search(r"all of the|none of the|both [A-D] and|\\([A-D]\\)",c[1],re.I): errs.append((i,f"choice {c[0]} refers to other choices"))
        s=" ".join(x["stem"])
        if re.search(r"\\bN-\\d",s): errs.append((i,"stem contains an item id"))
    ids=[x["id"] for x in items]
    if len(set(ids))!=len(ids): errs.append(("*","duplicate item ids"))
    seeds=[i for i in ids if "-v" not in i]
    for sd in seeds:
        vs=[i for i in ids if i.startswith(sd+"-v")]
        if len(vs)!=3: errs.append((sd,f"seed has {len(vs)} variants, expected 3 (v1..v3)"))
    pos=collections.Counter(([c[0] for c in x["ch"] if c[2]] or ["?"])[0] for x in items)
    print(f"{len(items)} items, {len(seeds)} seeds; correct letters as written {dict(pos)} (rebalanced at build time)")
    for e in errs: print("ERROR",*e)
    print("OK" if not errs else f"{len(errs)} problems"); return 1 if errs else 0
if __name__=="__main__": sys.exit(main(sys.argv[1]))
