"""Compact author-in-session second-derivative-test questions for AB and BC."""
from pathlib import Path
import json
H=Path(__file__).resolve().parent
out=["# AP Calculus AB and BC Unit 5 topic 5.7 — Second Derivative Test", "DRAFT. Author-in-session 2026-11-13. Identical content for separate AB and BC packs. CED FUN-4.A.7–8."]
def add(fam,skill,cases):
    assert len(cases)==4
    for i,(stem,ch,check,wrong) in enumerate(cases):
        assert len(ch)==4 and len(wrong)==3
        ident=f"N-5.7-{fam}"
        if i==0:out.extend(["---",f"## Seed {ident} (new) — Topic 5.7 Using the Second Derivative Test",f"**Skill:** {skill}","",stem,""])
        else:out.extend(["",f"**{ident}-v{i}.** {stem}",""])
        out.extend([f"- **A. {ch[0]}**",*[f"- {z}. {v}" for z,v in zip("BCD",ch[1:])],"",f"Check: {check}","Rationales: "+" ".join(f"{z}: {v}" for z,v in zip("BCD",wrong))])
cases=[]
for a,b,k in [(-2,1,1),(-3,2,-1),(0,4,2),(-1,3,-2)]:
    first="maximum" if k>0 else "minimum";second="minimum" if k>0 else "maximum"
    stem=f"A twice-differentiable function f has f'(x)={k}(x−({a}))(x−({b})) on an interval containing both zeros, with {a}<{b}. What does the second derivative test establish at the two critical points?"
    ch=[f"A local {first} at x={a} and a local {second} at x={b}.",f"A local {second} at x={a} and a local {first} at x={b}.","Both zeros are local minima because f' is zero at each.","The test is inconclusive at both points because f'' is not given directly."]
    check=f"Differentiating gives f''(x)={k}(2x−({a})−({b})). Thus f''({a})={k*(a-b)} and f''({b})={k*(b-a)}; their opposite signs classify the two extrema."
    wrong=["This reverses the signs of f'' at the two critical points.","A zero of f' only identifies a candidate; the opposite second-derivative signs yield opposite types.","f'' can be calculated by differentiating the given f', so the test is conclusive at both points."]
    cases.append((stem,ch,check,wrong))
add("A","differentiate a factored first derivative and classify two critical points",cases)
cases=[]
for a,k,power,kind in [(1,1,4,"minimum"),(-2,-1,4,"maximum"),(3,1,3,"neither"),(-1,-1,5,"neither")]:
    stem=f"For g(x)={k}(x−({a}))^{power}, a student finds g'({a})=0 and g''({a})=0. Which conclusion is justified about x={a}, and why is the second derivative test alone insufficient?"
    if kind=="minimum":reason="the even power and positive coefficient make g(x) greater than g(a) on both sides"
    elif kind=="maximum":reason="the even power and negative coefficient make g(x) less than g(a) on both sides"
    else:reason="the odd power makes g(x) pass through g(a) with opposite signs on the two sides"
    ch=[f"x={a} is {('a local '+kind) if kind!='neither' else 'neither a local maximum nor a local minimum'}; {reason}, while g''({a})=0 makes the second derivative test inconclusive.",f"x={a} must be a local minimum because g''({a})=0 and zero counts as nonnegative.",f"x={a} must be a local maximum because g'({a})=0 and g''({a})=0.","No conclusion about the actual function can be drawn by any method because the second derivative test is inconclusive."]
    check=f"At x={a}, the first two derivatives vanish. The sign of {k}(x−({a}))^{power} relative to g({a})=0 on either side shows {kind}; zero second derivative alone does not classify it."
    wrong=["The test requires a strictly positive second derivative for a minimum; zero is inconclusive.","Vanishing first and second derivatives do not establish a maximum; inspect the function or derivative sign.","An inconclusive test does not prohibit using the function's explicit power and sign to classify the point."]
    cases.append((stem,ch,check,wrong))
add("B","handle an inconclusive zero second derivative with independent evidence",cases)
cases=[]
for a,k in [(-2,1),(1,-1),(3,2),(-1,-2)]:
    kind="minimum" if k>0 else "maximum";opposite="maximum" if k>0 else "minimum"
    stem=f"A continuous function h is differentiable for every real x and has h'(x)={k}(x−({a}))/(1+x²). This is its only critical point. What can be concluded about x={a} using the second derivative test together with the one-critical-point result?"
    ch=[f"h has a local {kind} at x={a}, and it is also an absolute {kind} on the real line.",f"h has a local {opposite} at x={a}, and it is also an absolute {opposite} because the denominator is positive.",f"h has a local {kind} at x={a}, but it cannot be an absolute extremum because the real-line interval has no endpoints.",f"h has no extremum at x={a} because the first derivative vanishes there."]
    check=f"h''({a})={k}/(1+{a}²), with sign {'positive' if k>0 else 'negative'}. The denominator of h' is always positive, so h' changes {'negative to positive' if k>0 else 'positive to negative'} at its unique zero; the local {kind} is absolute."
    wrong=["The sign of h'' at the critical point is reversed here, so the local type is wrong.","A continuous function with only this critical point and a local extremum has the same absolute extremum on its real-line domain; endpoints are not required.","A zero first derivative is a critical point, and the nonzero second derivative classifies an extremum."]
    cases.append((stem,ch,check,wrong))
add("C","connect a conclusive second derivative test and a unique critical point to global behavior",cases)
src="\n\n".join(out)+"\n";(H/"source_draft.md").write_text(src)
B=H.parent/"apcalcbc-harder-seeds-u5-t5_7-2026-11-13";B.mkdir(exist_ok=True);(B/"source_draft.md").write_text(src)
for p in (H,B):
    json.dump({"N-5.7-A":{"skill":"classify two critical points with f''"},"N-5.7-B":{"skill":"resolve an inconclusive second derivative test"},"N-5.7-C":{"skill":"infer a global extremum from one critical point"}},open(p/"seed_map.json","w"),indent=2)
    json.dump({"retire":[]},open(p/"retire_keys.json","w"),indent=2)
print("wrote 12 shared second-derivative-test questions")
