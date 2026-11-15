"""Compact author-in-session AB/BC topic 5.4 first-derivative-test families."""
from pathlib import Path
H=Path(__file__).resolve().parent
out=["# AP Calculus AB and BC Unit 5 topic 5.4 — First Derivative Test",
     "DRAFT. Author-in-session 2026-11-13. Identical content for separate AB and BC packs. CED FUN-4.A.2."]
def add(fam,skill,cases):
    assert len(cases)==4
    for i,(stem,ch,check,wrong) in enumerate(cases):
        assert len(ch)==4 and len(wrong)==3
        ident=f"N-5.4-{fam}"
        if i==0:out.extend(["---",f"## Seed {ident} (new) — Topic 5.4 Using the First Derivative Test",f"**Skill:** {skill}","",stem,""])
        else:out.extend(["",f"**{ident}-v{i}.** {stem}",""])
        out.extend([f"- **A. {ch[0]}**",*[f"- {z}. {v}" for z,v in zip("BCD",ch[1:])],"",f"Check: {check}","Rationales: "+" ".join(f"{z}: {v}" for z,v in zip("BCD",wrong))])

cases=[]
for a,b,k in [(-2,1,1),(-3,2,-1),(0,4,2),(-1,3,-2)]:
    high,low=(a,b) if k>0 else (b,a)
    stem=f"A differentiable function f has f'(x)={k}(x-({a}))(x-({b})) for all real x, with {a}<{b}. Which classification of its local extrema follows from the first derivative test?"
    ch=[f"f has a local maximum at x={high} and a local minimum at x={low}.",f"f has a local minimum at x={high} and a local maximum at x={low}.",f"Both x={a} and x={b} are local maxima because f' is zero at both.","Neither zero of f' can be a local extremum because f is differentiable there."]
    check=f"For x<{a}, between {a} and {b}, and x>{b}, the derivative signs are {'positive, negative, positive' if k>0 else 'negative, positive, negative'}. Thus x={high} is a positive-to-negative switch and x={low} a negative-to-positive switch."
    wrong=["This reverses the derivative sign changes: positive-to-negative makes a maximum and negative-to-positive a minimum.","Zeros are candidates; the sign changes around each root determine opposite extremum types.","Differentiability does not prevent local extrema; these derivative sign reversals establish them."]
    cases.append((stem,ch,check,wrong))
add("A","classify two stationary points from a factored derivative",cases)

cases=[]
for c1,c2,c3,signs,max_at,min_at,neutral in [
    (-2,0,3,"+,-,-,+",-2,3,0),
    (-3,1,4,"-,+,+,-",4,-3,1),
    (-1,2,5,"+,+,-,+",2,5,-1),
    (-4,-1,2,"-,-,+,-",2,-1,-4),
]:
    stem=f"A graph of a continuous derivative f' crosses or touches the x-axis only at x={c1}, {c2}, and {c3}. On the four successive intervals its signs are {signs}. Which conclusion about f follows?"
    ch=[f"f has a local maximum at x={max_at}, a local minimum at x={min_at}, and neither type of extremum at x={neutral}.",f"f has a local minimum at x={max_at}, a local maximum at x={min_at}, and neither at x={neutral}.",f"All three zeros are local extrema because f' is zero at each.",f"No local extrema can be inferred because the numerical values of f at the zeros are unknown."]
    check=f"Read derivative signs in x order: {signs}. A + to - switch marks a maximum, - to + marks a minimum, and no sign switch at x={neutral} marks neither."
    wrong=["The sign-switch directions are reversed: positive-to-negative is a local maximum, not a minimum.","A derivative zero without a sign reversal need not be a local extremum; inspect all adjacent intervals.","The first derivative test uses signs of f', so explicit function values are unnecessary to classify local extrema."]
    cases.append((stem,ch,check,wrong))
add("B","interpret a derivative sign representation with a stationary non-extremum",cases)

cases=[]
for a,b,k in [(1,-2,1),(-1,3,-1),(4,0,2),(-3,2,-2)]:
    kind="minimum" if k>0 else "maximum"
    other="maximum" if k>0 else "minimum"
    stem=f"A differentiable function g satisfies g'(x)={k}(x-({a}))²(x-({b})) for all real x. Which statement about the stationary points x={a} and x={b} is correct?"
    ch=[f"x={b} is a local {kind}; x={a} is stationary but not a local extremum because g' keeps its sign there.",f"x={a} is a local {kind}; x={b} is not an extremum because the factor at {b} has odd multiplicity.",f"x={b} is a local {other}, and x={a} is also a local extremum because both factors vanish.","Neither point can be a local extremum because the derivative is a polynomial and therefore continuous."]
    check=f"The squared factor at x={a} does not flip sign. Away from that point the sign of g' is the sign of {k}(x-({b})), which changes {'negative to positive' if k>0 else 'positive to negative'} at x={b}."
    wrong=["The squared factor gives no derivative sign reversal at its root, while the simple factor does reverse sign at the other root.","The simple factor changes sign, but its extremum type is reversed here; the repeated root stays stationary without an extremum.","A continuous polynomial derivative can change sign at a simple root and create a local extremum."]
    cases.append((stem,ch,check,wrong))
add("C","distinguish even- and odd-multiplicity derivative zeros",cases)

src="\n\n".join(out)+"\n";(H/"source_draft.md").write_text(src)
B=H.parent/"apcalcbc-harder-seeds-u5-t5_4-2026-11-13";B.mkdir(exist_ok=True);(B/"source_draft.md").write_text(src)
print("wrote 12 shared first-derivative-test questions")
