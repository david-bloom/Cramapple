"""Compact author-in-session concavity and domain questions for both Calculus packs."""
from pathlib import Path
import json

H=Path(__file__).resolve().parent
out=["# AP Calculus AB and BC Unit 5 topic 5.6 — Concavity over domains", "DRAFT. Author-in-session 2026-11-13. Identical content for separate AB and BC packs. CED FUN-4.A.4–6."]

def add(fam,skill,cases):
    assert len(cases)==4
    for i,(stem,ch,check,wrong) in enumerate(cases):
        assert len(ch)==4 and len(wrong)==3
        ident=f"N-5.6-{fam}"
        if i==0:out.extend(["---",f"## Seed {ident} (new) — Topic 5.6 Determining Concavity of Functions over Their Domains",f"**Skill:** {skill}","",stem,""])
        else:out.extend(["",f"**{ident}-v{i}.** {stem}",""])
        out.extend([f"- **A. {ch[0]}**",*[f"- {z}. {v}" for z,v in zip("BCD",ch[1:])],"",f"Check: {check}","Rationales: "+" ".join(f"{z}: {v}" for z,v in zip("BCD",wrong))])

cases=[]
for a,b,k in [(-2,1,1),(-3,2,-1),(0,4,2),(-1,3,-2)]:
    left="down" if k>0 else "up";right="up" if k>0 else "down"
    stem=f"A twice-differentiable function f on all real numbers has f''(x)={k}(x−({a}))²(x−({b})), where {a}<{b}. Which conclusion about concavity and inflection is justified?"
    ch=[f"The graph changes from concave {left} to concave {right} at x={b}; x={a} is not an inflection point.",f"Both x={a} and x={b} are inflection points because f'' is zero at each.",f"Neither x={a} nor x={b} can be an inflection point because f'' is zero there.",f"The graph changes from concave {right} to concave {left} at x={b}, and x={a} is not an inflection point."]
    check=f"The squared factor is nonnegative and does not change sign at {a}. The simple factor changes sign at {b}; f'' has sign {'negative then positive' if k>0 else 'positive then negative'} across that point."
    wrong=["A zero of the second derivative alone is insufficient; its sign does not change at the squared-factor root.","A sign change of f'' at the simple-factor root establishes an inflection point even though f'' is zero there.","This reverses the sign of f'' on either side of the simple-factor root."]
    cases.append((stem,ch,check,wrong))
add("A","test second-derivative signs at a repeated and a simple zero",cases)

cases=[]
for a,b,trends in [(-2,1,("decreasing","increasing","decreasing")),(-3,2,("increasing","decreasing","increasing")),(0,4,("decreasing","decreasing","increasing")),(-1,3,("increasing","increasing","decreasing"))]:
    con=["up" if t=="increasing" else "down" for t in trends]
    switch=[x for x,i in ((a,0),(b,1)) if con[i]!=con[i+1]]
    where=" and ".join(f"x={x}" for x in switch)
    stem=f"A function f is differentiable on all real numbers and f' is continuous. A graph of f' shows that f' is {trends[0]} on (−∞,{a}), {trends[1]} on ({a},{b}), and {trends[2]} on ({b},∞). No numerical values of f' are supplied. Which conclusion follows?"
    ch=[f"The graph of f is concave {con[0]}, then {con[1]}, then {con[2]} on those three intervals; its concavity changes at {where}.",f"The graph of f is increasing precisely on the intervals where f' is increasing, and decreasing where f' is decreasing.",f"The graph of f has local extrema at both x={a} and x={b}, because f' changes its increasing/decreasing trend there.","No concavity conclusion is possible without the numerical values of f' at the interval boundaries."]
    check=f"Concavity of f follows the trend of f': increasing means up, decreasing means down. The trend sequence is {', '.join(trends)}; only the stated changes in concavity are inflections."
    wrong=["Whether f increases depends on the sign of f', not whether f' itself rises or falls.","A local extremum of f requires a sign switch of f', which is not given by its increasing/decreasing trend alone.","The direction of change of f' suffices to infer concavity without knowing its numerical values."]
    cases.append((stem,ch,check,wrong))
add("B","infer concavity of f from monotonicity of f' without confusing sign and trend",cases)

cases=[]
for a,c,b,k in [(-2,0,3,1),(-3,-1,2,-1),(-1,1,4,2),(0,2,5,-2)]:
    outer="up" if k>0 else "down";inner="down" if k>0 else "up"
    stem=f"A function g is twice differentiable for all real x except x={c} and satisfies g''(x)={k}(x−({a}))(x−({b}))/(x−({c}))² on that domain, with {a}<{c}<{b}. The function has no value at x={c}. Which statement correctly describes concavity and inflection points?"
    ch=[f"g is concave {outer} for x<{a} and x>{b}, concave {inner} on ({a},{c}) and ({c},{b}), and has inflection points at x={a} and x={b} only.",f"g has inflection points at x={a}, x={c}, and x={b} because the displayed formula is zero or undefined at all three.",f"g is concave {inner} outside ({a},{b}) and concave {outer} between the roots because the squared denominator is negative there.",f"g has no inflection points because its domain is disconnected at x={c}."]
    check=f"The squared denominator is positive wherever defined. The numerator has sign {'positive, negative, positive' if k>0 else 'negative, positive, negative'} across {a},{b}; the gap at {c} is not a point on the graph."
    wrong=["An inflection point must lie on the graph; g is undefined at the domain gap.","A nonzero square is positive, so it does not reverse the numerator's sign pattern.","The domain gap does not prevent concavity from changing at the included points x=a and x=b."]
    cases.append((stem,ch,check,wrong))
add("C","separate true inflection points from a domain break in a rational second derivative",cases)

src="\n\n".join(out)+"\n";(H/"source_draft.md").write_text(src)
B=H.parent/"apcalcbc-harder-seeds-u5-t5_6-2026-11-13";B.mkdir(exist_ok=True);(B/"source_draft.md").write_text(src)
for p in (H,B):
    json.dump({"N-5.6-A":{"skill":"interpret multiplicity in f''"},"N-5.6-B":{"skill":"infer concavity from f' trends"},"N-5.6-C":{"skill":"exclude domain gaps from inflection points"}},open(p/"seed_map.json","w"),indent=2)
    json.dump({"retire":[]},open(p/"retire_keys.json","w"),indent=2)
print("wrote 12 shared concavity questions")
