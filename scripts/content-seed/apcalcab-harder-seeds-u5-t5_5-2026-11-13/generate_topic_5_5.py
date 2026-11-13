"""Compact author-in-session candidate-test questions for both Calculus packs."""
from pathlib import Path

H=Path(__file__).resolve().parent
out=["# AP Calculus AB and BC Unit 5 topic 5.5 — Candidates Test", "DRAFT. Author-in-session 2026-11-13. Identical content for separate AB and BC packs. CED FUN-4.A.3."]

def add(fam,skill,cases):
    assert len(cases)==4
    for i,(stem,ch,check,wrong) in enumerate(cases):
        assert len(ch)==4 and len(wrong)==3
        ident=f"N-5.5-{fam}"
        if i==0:out.extend(["---",f"## Seed {ident} (new) — Topic 5.5 Using the Candidates Test",f"**Skill:** {skill}","",stem,""])
        else:out.extend(["",f"**{ident}-v{i}.** {stem}",""])
        out.extend([f"- **A. {ch[0]}**",*[f"- {z}. {v}" for z,v in zip("BCD",ch[1:])],"",f"Check: {check}","Rationales: "+" ".join(f"{z}: {v}" for z,v in zip("BCD",wrong))])

def points(xs):return ", ".join(f"x={x}" for x in xs)

def f(x):return x*x*x-3*x

cases=[]
for L,R in [(-3,2),(-2,3),(-3,3),(-2,2)]:
    xs=[L,-1,1,R];values={x:f(x) for x in xs}
    hi=max(values.values());lo=min(values.values())
    maxat=[x for x in xs if values[x]==hi];minat=[x for x in xs if values[x]==lo]
    stem=f"For f(x)=x³−3x on the closed interval [{L},{R}], a student finds f'(x)=3x²−3. Which statement gives every absolute maximum and every absolute minimum on the interval?"
    ch=[f"The absolute maximum is {hi} at {points(maxat)}, and the absolute minimum is {lo} at {points(minat)}.",f"The absolute maximum is {lo} at {points(minat)}, and the absolute minimum is {hi} at {points(maxat)}.","Only x=−1 and x=1 need be compared because they are the zeros of f'.","The left endpoint is an absolute maximum and the right endpoint is an absolute minimum."]
    check=f"The candidates are the endpoints {L},{R} and derivative zeros −1,1. Their function values in that order are {f(L)},{f(R)},2,−2. Compare all values, retaining ties."
    wrong=["This reverses the meaning of largest and smallest candidate value.","The candidates test includes endpoints as well as interior critical points; an endpoint determines or ties an extremum here.","The left endpoint has a smaller value than the right endpoint here, so their proposed extremum types are reversed."]
    cases.append((stem,ch,check,wrong))
add("A","compare all endpoint and critical-point values, including ties",cases)

cases=[]
for a,m,L,R in [(1,-0.5,0,4),(2,0.5,-1,3),(-1,-0.5,-3,2),(0,0.5,-2,3)]:
    val=lambda x:abs(x-a)+m*x
    vals={x:val(x) for x in (L,a,R)};hi=max(vals.values());lo=min(vals.values())
    maxat=[x for x in (L,a,R) if vals[x]==hi]
    stem=f"The continuous function g(x)=|x−({a})|+({m})x is restricted to [{L},{R}]. Its derivative is undefined at x={a} and nonzero at all other interior points. Which conclusion follows from the candidates test?"
    ch=[f"The absolute minimum is {lo:g} at x={a}; the absolute maximum is {hi:g} at {points(maxat)}.","The derivative is undefined at the corner, so the absolute minimum must occur at one of the two endpoints.",f"The corner x={a} is the absolute maximum because a sharp point always exceeds nearby values.","The candidates test cannot be used because g is not differentiable at every interior point."]
    check=f"The only candidates are endpoint x={L}, corner x={a}, and endpoint x={R}; their values are {val(L):g},{val(a):g},{val(R):g}. The function is continuous on the closed interval."
    wrong=["An interior corner is a critical candidate when the derivative does not exist; it has the smallest evaluated value.","A corner can be a minimum; here both one-sided slopes point upward away from it.","Continuity on a closed interval permits the test; nondifferentiability adds the corner to the candidate list."]
    cases.append((stem,ch,check,wrong))
add("B","include a nondifferentiable interior point among candidates and compare values",cases)

cases=[]
for L,z,k,R,vals in [
    (0,1,3,5,(2,6,-1,4)),
    (-2,0,2,4,(7,3,0,4)),
    (0,2,3,6,(-4,-1,-4,2)),
    (-1,1,4,5,(1,6,-2,4)),
]:
    xs=[L,z,k,R];d=dict(zip(xs,vals));hi=max(vals);lo=min(vals)
    maxat=[x for x in xs if d[x]==hi];minat=[x for x in xs if d[x]==lo]
    stem=f"A function h is continuous on [{L},{R}]. Its only interior critical points are x={z}, where h'=0, and x={k}, where h' is undefined; h' is nonzero and defined everywhere else inside the interval. The measured values are h({L})={vals[0]}, h({z})={vals[1]}, h({k})={vals[2]}, and h({R})={vals[3]}. Which conclusion is justified?"
    ch=[f"The absolute maximum is {hi} at {points(maxat)}, and the absolute minimum is {lo} at {points(minat)}.",f"Both absolute extrema must occur at x={z}, the only place where h'=0.",f"The value at x={k} must be discarded because h' is undefined there.","The absolute extrema cannot be found without the formula for h between the listed points."]
    check=f"All candidates are {L},{z},{k},{R}; by hypothesis there are no other interior critical points. Their values are {vals}. The largest is {hi} and the smallest is {lo}; include ties."
    wrong=["A derivative zero is only one candidate, and one point cannot simultaneously have the listed largest and smallest values.","An undefined derivative at an interior point makes it a candidate; the corner has a smallest value here.","Continuity on the closed interval plus the exhaustive candidate list makes comparison of these four values sufficient."]
    cases.append((stem,ch,check,wrong))
add("C","interpret a finite candidate table with an undefined derivative and ties",cases)

src="\n\n".join(out)+"\n";(H/"source_draft.md").write_text(src)
B=H.parent/"apcalcbc-harder-seeds-u5-t5_5-2026-11-13";B.mkdir(exist_ok=True);(B/"source_draft.md").write_text(src)
for p in (H,B):
    import json
    json.dump({"N-5.5-A":{"skill":"compare endpoint and critical values"},"N-5.5-B":{"skill":"include nondifferentiable candidates"},"N-5.5-C":{"skill":"interpret exhaustive candidate tables"}},open(p/"seed_map.json","w"),indent=2)
    json.dump({"retire":[]},open(p/"retire_keys.json","w"),indent=2)
print("wrote 12 shared candidates-test questions")
