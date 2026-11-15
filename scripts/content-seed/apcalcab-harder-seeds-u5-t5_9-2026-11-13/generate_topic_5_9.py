"""Compact author-in-session f, f', f'' correspondence questions for AB and BC."""
from pathlib import Path
import json
H=Path(__file__).resolve().parent
out=["# AP Calculus AB and BC Unit 5 topic 5.9 — Connecting f, f', and f''", "DRAFT. Author-in-session 2026-11-13. Identical content for separate AB and BC packs. CED FUN-4.A.11."]
def add(fam,skill,cases):
    assert len(cases)==4
    for i,(stem,ch,check,wrong) in enumerate(cases):
        assert len(ch)==4 and len(wrong)==3
        ident=f"N-5.9-{fam}"
        if i==0:out.extend(["---",f"## Seed {ident} (new) — Topic 5.9 Connecting a Function, Its First Derivative, and Its Second Derivative",f"**Skill:** {skill}","",stem,""])
        else:out.extend(["",f"**{ident}-v{i}.** {stem}",""])
        out.extend([f"- **A. {ch[0]}**",*[f"- {z}. {v}" for z,v in zip("BCD",ch[1:])],"",f"Check: {check}","Rationales: "+" ".join(f"{z}: {v}" for z,v in zip("BCD",wrong))])
cases=[]
for a,k,m in [(-2,1,0),(1,-1,0),(0,2,1),(3,-2,-1)]:
    extremum="minimum" if k>0 else "maximum";stationary="stationary" if m==0 else "nonstationary"
    stem=f"Let f(x)={k}(x−({a}))³+({m})(x−({a})) for all real x. Which description correctly links the graphs of f, f', and f'' at x={a}?"
    ch=[f"f has a {stationary} inflection there; f' has a local {extremum} there, and f'' changes sign through zero.",f"f has a local {extremum} there because f' has a local {extremum} there.","f' has an inflection there because f'' is zero there, while f has no concavity change.","f'' has a local extremum there because its value is zero, so f cannot have an inflection."]
    check=f"f'=3({k})(x−({a}))²+({m}), f''=6({k})(x−({a})). The linear f'' changes sign at {a}; f' is quadratic with local {extremum} there; f'({a})={m}, so f is {stationary}."
    wrong=["An extremum of f' concerns the slope of f; f has an inflection here, and may have a nonzero slope.","A zero of f'' with sign change makes an inflection of f, while f' has a local extremum, not an inflection, here.","The linear f'' crosses zero rather than turning around; that crossing marks f's concavity change."]
    cases.append((stem,ch,check,wrong))
add("A","connect a local extremum of f' to an inflection of f, including stationary status",cases)
cases=[]
for a,b,k,p in [(-1,2,2,5),(-3,0,-2,-4),(0,3,2,4),(-2,1,-2,-5)]:
    diff=-k*(b-a)**3//6;atb=p+diff
    trend="decreases" if k>0 else "increases";first="maximum" if k>0 else "minimum";second="minimum" if k>0 else "maximum";inside="maximum" if k>0 else "minimum"
    stem=f"A twice-differentiable function f has f''(x)={k}(x−({a}))(x−({b})) for all real x, where {a}<{b}. Also f'({a})={p} and f'({b})={atb}. Which relationship among the three graphs is forced on ({a},{b}) and at its boundary points?"
    ch=[f"f' {trend} from {p} to {atb} and has exactly one zero inside ({a},{b}), giving f a local {inside} there; f has inflections at x={a} and x={b}.",f"f has local extrema at both x={a} and x={b} because f'' is zero at those points.",f"f' cannot cross zero between {a} and {b} because f'' has no zero strictly between them.","The interior zero of f' is an inflection of f, while x=a and x=b cannot be inflections because f'' vanishes there."]
    check=f"Between {a} and {b}, f'' has sign {'negative' if k>0 else 'positive'}, so f' is strictly monotone. Its endpoint values {p},{atb} straddle zero, forcing exactly one zero, where f has a local {inside}. f'' changes sign at each boundary root."
    wrong=["f''=0 can make an inflection of f, but the given f' values at those points are nonzero, so neither is a local extremum of f.","A monotone continuous f' with endpoint values on opposite sides of zero must cross zero exactly once.","At the interior zero, f'' is nonzero, giving an extremum of f; f'' changes sign at the two boundary roots, giving inflections there."]
    cases.append((stem,ch,check,wrong))
add("B","use f'' signs and f' endpoint values to locate an extremum and inflections",cases)
cases=[]
for shift,k in [("0",1),("π/2",-1),("π",1),("−π/2",-1)]:
    maxat=f"{shift}+π/2" if k>0 else f"{shift}+3π/2";minat=f"{shift}+3π/2" if k>0 else f"{shift}+π/2";mid=f"{shift}+π"
    stem=f"On the interval from x={shift} to x={shift}+2π, let g(x)={k}sin(x−({shift})). Which interior features of the graphs of g, g', and g'' correspond?"
    ch=[f"g has a local maximum at x={maxat} and a local minimum at x={minat}; g has an inflection at x={mid}, where g' has a local extremum.",f"g has inflections at x={maxat} and x={minat}, because g' is zero there; g has an extremum at x={mid}.",f"g has local extrema at all three listed interior points because either g' or g'' vanishes at each.","g cannot have an inflection at the middle point because g'' is zero there."]
    check=f"g'={k}cos(x−({shift})), g''=−{k}sin(x−({shift})). The cosine zeros make g's two extrema; g'' changes sign at the middle point, where the cosine graph has an extremum."
    wrong=["Zeros of g' locate extrema of g, whereas a sign change of g'' locates an inflection of g.","At the middle point g' is nonzero, so g has no extremum there; g''=0 alone does not mark an extremum of g.","g'' changes sign at the middle point, which is the defining concavity change for an inflection."]
    cases.append((stem,ch,check,wrong))
add("C","match trig graph landmarks across f, f', and f''",cases)
src="\n\n".join(out)+"\n";(H/"source_draft.md").write_text(src)
B=H.parent/"apcalcbc-harder-seeds-u5-t5_9-2026-11-13";B.mkdir(exist_ok=True);(B/"source_draft.md").write_text(src)
for p in (H,B):
    json.dump({"N-5.9-A":{"skill":"connect f' extrema and f inflections"},"N-5.9-B":{"skill":"locate f extrema using f'' and f'"},"N-5.9-C":{"skill":"match trig graph landmarks"}},open(p/"seed_map.json","w"),indent=2)
    json.dump({"retire":[]},open(p/"retire_keys.json","w"),indent=2)
print("wrote 12 shared graph-correspondence questions")
