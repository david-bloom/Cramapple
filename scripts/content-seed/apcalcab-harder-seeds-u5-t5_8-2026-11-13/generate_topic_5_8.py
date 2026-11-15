"""Compact author-in-session graph-feature questions for both Calculus packs."""
from pathlib import Path
import json
H=Path(__file__).resolve().parent
out=["# AP Calculus AB and BC Unit 5 topic 5.8 — Sketching f from derivatives", "DRAFT. Author-in-session 2026-11-13. Identical content for separate AB and BC packs. CED FUN-4.A.9–10."]
def add(fam,skill,cases):
    assert len(cases)==4
    for i,(stem,ch,check,wrong) in enumerate(cases):
        assert len(ch)==4 and len(wrong)==3
        ident=f"N-5.8-{fam}"
        if i==0:out.extend(["---",f"## Seed {ident} (new) — Topic 5.8 Sketching Graphs of Functions and Their Derivatives",f"**Skill:** {skill}","",stem,""])
        else:out.extend(["",f"**{ident}-v{i}.** {stem}",""])
        out.extend([f"- **A. {ch[0]}**",*[f"- {z}. {v}" for z,v in zip("BCD",ch[1:])],"",f"Check: {check}","Rationales: "+" ".join(f"{z}: {v}" for z,v in zip("BCD",wrong))])
cases=[]
for a,b,k in [(-3,1,1),(-2,4,-1),(0,6,2),(-4,2,-2)]:
    m=(a+b)//2;first="maximum" if k>0 else "minimum";second="minimum" if k>0 else "maximum";slope="decreasing" if k>0 else "increasing"
    stem=f"A function f has f'(x)={k}(x−({a}))(x−({b})) for all real x, with {a}<{b}. Which set of features belongs in an accurate sketch of f?"
    ch=[f"A local {first} at x={a}, a local {second} at x={b}, and an inflection at x={m} where f is {slope}.",f"A local {second} at x={a}, a local {first} at x={b}, and an inflection at x={m}.",f"Inflection points at both x={a} and x={b} because f' is zero there, with no local extrema.","No inflection point, because the given first derivative is a quadratic polynomial."]
    check=f"f' has signs {'positive, negative, positive' if k>0 else 'negative, positive, negative'} across {a},{b}. Also f''={k}(2x−({a})−({b})) changes sign at {m}; f'({m}) has sign {'negative' if k>0 else 'positive'}."
    wrong=["The first derivative sign changes at both zeros are reversed.","Zeros of f' classify extrema of f; f'' changes sign at the midpoint, not at both derivative zeros.","The derivative of the quadratic f' is linear and changes sign at its zero, producing an inflection of f."]
    cases.append((stem,ch,check,wrong))
add("A","combine f' zeros and f'' sign for a whole-function sketch",cases)
cases=[]
for case_index,(x,y) in enumerate([(-3,1),(-1,3),(-3,-1),(1,3)]):
    d=lambda t:t*t-4;dd=lambda t:2*t
    slope=lambda t:"rising" if d(t)>0 else "falling"
    bend=lambda t:"up" if dd(t)>0 else "down"
    if case_index in (1,2,3):
        place=lambda t:"above" if dd(t)<0 else "below"
        reverse=lambda t:"below" if dd(t)<0 else "above"
        stem=f"A twice-differentiable function has f'({x})={d(x)}, f''({x})={dd(x)}, f'({y})={d(y)}, and f''({y})={dd(y)}. For a sufficiently small neighborhood of each point, compare the graph with its tangent line there. Which pair of sketch notes is justified?"
        ch=[f"At x={x}, the tangent slopes {'up' if d(x)>0 else 'down'} and lies locally {place(x)} the graph; at x={y}, it slopes {'up' if d(y)>0 else 'down'} and lies locally {place(y)} the graph.",f"The tangent slopes have the same signs as stated, but lie {reverse(x)} the graph near x={x} and {reverse(y)} the graph near x={y}.",f"The tangent lies on the stated side of the graph at each point, but its slope signs are the reverse of the listed f' values.","The tangent must cross the graph at both points because both second derivatives are nonzero."]
        check=f"f' gives tangent slopes {d(x)},{d(y)}. Negative f'' puts a graph below its tangent locally; positive f'' puts a graph above it. The tangent sides are {place(x)},{place(y)}."
        wrong=["This reverses the local tangent-versus-graph relation implied by each nonzero second derivative.","The sign of f' directly gives each tangent slope; these slope directions are reversed.","Nonzero second derivative makes the tangent stay on one local side of the graph rather than cross it immediately."]
    else:
        stem=f"A table from a twice-differentiable function records f'({x})={d(x)}, f''({x})={dd(x)}, f'({y})={d(y)}, and f''({y})={dd(y)}. A student is drawing local pieces of the graph near x={x} and x={y}. Which annotations match the table?"
        ch=[f"Near x={x}, f is {slope(x)} and concave {bend(x)}; near x={y}, f is {slope(y)} and concave {bend(y)}.","f is rising at both points because f'' is nonzero at both.",f"Near x={x}, f is {'falling' if d(x)>0 else 'rising'}, and near x={y}, f is {'falling' if d(y)>0 else 'rising'}; the f' values give the opposite slope signs.","Both sampled points must be local extrema of f because f'' is nonzero at each."]
        check=f"f' signs at {x},{y} are {d(x)},{d(y)}, setting rise/fall; f'' signs are {dd(x)},{dd(y)}, setting concavity. Neither f' value is zero."
        wrong=["A nonzero second derivative controls concavity, not whether f is rising; one listed f' is negative.","This reverses the sign interpretation of f' at both sampled points.","A nonzero f' rules out a differentiable local extremum at these sampled points."]
    cases.append((stem,ch,check,wrong))
add("B","translate sampled slope and concavity data into local sketch features",cases)
cases=[]
for a,b,k in [(-2,4,1),(-4,2,-1),(0,6,2),(-1,5,-2)]:
    c=(2*b+a)//3;kind="minimum" if k>0 else "maximum"
    stem=f"A differentiable function g has g'(x)={k}(x−({a}))²(x−({b})) for all real x. A proposed sketch marks x={a} as a horizontal tangent and x={b} as another horizontal tangent. Which additional classification is correct?"
    ch=[f"x={a} is a stationary inflection, x={c} is another inflection, and x={b} is a local {kind}.",f"x={a} and x={b} are both local {kind} points because g' vanishes at both.",f"x={a} is a stationary inflection, but x={b} is also an inflection because g' vanishes there.",f"x={c} is a local {kind} of g because it is a zero of g''."]
    check=f"The squared factor makes g' keep its sign at {a}; the simple factor changes sign at {b}, giving a local {kind}. Differentiation gives g''={k}(x−({a}))(3x−({2*b+a})), whose signs change at {a} and {c}."
    wrong=["A repeated derivative zero does not change g' sign, while the simple zero does.","The simple zero of g' is an extremum of g, not an inflection; g'' does not vanish there.","A zero of g'' can signal an inflection of g, not a local extremum unless g' also changes sign."]
    cases.append((stem,ch,check,wrong))
add("C","distinguish stationary inflections from extrema in a derivative-based sketch",cases)
src="\n\n".join(out)+"\n";(H/"source_draft.md").write_text(src)
B=H.parent/"apcalcbc-harder-seeds-u5-t5_8-2026-11-13";B.mkdir(exist_ok=True);(B/"source_draft.md").write_text(src)
for p in (H,B):
    json.dump({"N-5.8-A":{"skill":"combine f' and f'' for graph features"},"N-5.8-B":{"skill":"translate derivative table into local sketch"},"N-5.8-C":{"skill":"classify stationary inflection and local extremum"}},open(p/"seed_map.json","w"),indent=2)
    json.dump({"retire":[]},open(p/"retire_keys.json","w"),indent=2)
print("wrote 12 shared graph-feature questions")
