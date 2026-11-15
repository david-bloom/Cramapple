"""Author-in-session AP Calculus AB/BC Unit 5 topic 5.1 drafts.

The identical source draft is packaged separately for the AB and BC served packs.
"""
from pathlib import Path

HERE=Path(__file__).resolve().parent
blocks=["# AP Calculus AB and BC Unit 5 topic 5.1 — Using the Mean Value Theorem",
        "DRAFT. Author-in-session 2026-11-12. Shared question text for separately packaged AB and BC items. CED: AP Calculus AB and BC Unit 5 topic 5.1, FUN-1.B.1."]

def add(fam,skill,cases):
    assert len(cases)==4
    for i,(stem,choices,check,reasons) in enumerate(cases):
        assert len(choices)==4 and len(reasons)==3
        ident=f"N-5.1-{fam}"
        if i==0:
            blocks.extend(["---",f"## Seed {ident} (new) — Topic 5.1 Using the Mean Value Theorem",f"**Skill:** {skill}","",stem,""])
        else:
            blocks.extend(["",f"**{ident}-v{i}.** {stem}",""])
        blocks.extend([f"- **A. {choices[0]}**",*[f"- {letter}. {choice}" for letter,choice in zip("BCD",choices[1:])],"",f"Check: {check}","Rationales: "+" ".join(f"{letter}: {reason}" for letter,reason in zip("BCD",reasons))])

add("A","apply MVT to a function and derive every interior point with secant-matching derivative",[
    ("Let f(x)=x^3-3x on [-2,2]. Which set contains every c in (-2,2) guaranteed by the Mean Value Theorem to satisfy f'(c)=[f(2)-f(-2)]/4?",
     ["c=-2/sqrt(3) and c=2/sqrt(3)","c=0 only","c=-2 and c=2","No c exists because f' changes sign on the interval."],
     "The polynomial meets both hypotheses. f(2)=2 and f(-2)=-2, so the secant slope is 1. Solve 3c²-3=1 to get c²=4/3, hence both interior solutions ±2/sqrt(3).",
     ["At c=0 the derivative is -3, not the secant slope 1; the equation has two solutions.","The theorem specifies c strictly inside the interval, and the endpoint derivatives do not equal 1.","A derivative may change sign while a polynomial remains continuous and differentiable; that does not invalidate MVT."]),
    ("Let g(x)=x^3+2x on [-3,3]. What are all interior c values whose instantaneous slope equals the secant slope over the interval, as MVT guarantees?",
     ["c=-sqrt(3) and c=sqrt(3)","c=0 only","c=-3 and c=3","There is no such c because g is increasing throughout the interval."],
     "The secant slope is (g(3)-g(-3))/6=11. Since g'(x)=3x²+2, solving 3c²+2=11 gives c=±sqrt(3), both interior.",
     ["g'(0)=2, which differs from the secant slope 11; two interior points work.","Endpoints are excluded by the theorem, and their slopes are 29 rather than 11.","Increasing functions can still have an instantaneous slope equal to their average slope."]),
    ("A polynomial h(x)=x^3-6x is examined on [-1,3]. Which interior c values make h'(c) equal to its average rate of change on that interval?",
     ["c=sqrt(7/3) only","c=-1 and c=3","c=1 only","No interior point is required because h has a local maximum."],
     "h(-1)=5 and h(3)=9, so the secant slope is 1. h'(c)=3c²-6=1 gives c=±sqrt(7/3), but only the positive root lies in (-1,3).",
     ["The endpoints are excluded and do not solve the derivative equation.","h'(1)=-3, so the midpoint is not the matching point.","A polynomial satisfies MVT even when it has extrema within the interval."]),
    ("For p(x)=x^3 on [0,3], which interior value c has p'(c) equal to the average rate of change from 0 to 3?",
     ["c=sqrt(3)","c=3","c=1","No c exists because p'(0)=0 differs from the average rate."],
     "The secant slope is (27-0)/3=9. Solving 3c²=9 gives c=±sqrt(3), but only +sqrt(3) lies in (0,3).",
     ["c=3 is an endpoint, excluded by MVT, and p'(3)=27 rather than 9.","p'(1)=3, which is below the average rate 9.","Endpoint derivatives need not equal the secant slope; MVT guarantees an interior equality for this polynomial."])
])

add("B","test continuity and differentiability hypotheses before claiming an MVT point",[
    ("A student applies MVT to f(x)=|x| on [-1,1] and says there must be an interior c with f'(c)=0 because the endpoint values agree. Which response is correct?",
     ["The conclusion is not guaranteed: f is not differentiable at 0, and its derivative is -1 or +1 wherever defined inside.","MVT applies because f is continuous, and c=0 has derivative 0.","MVT applies because f is differentiable at both endpoints.","Every interior point works because the secant slope is 0."],
     "The closed-interval continuity condition holds, but the open-interval differentiability condition fails at the cusp x=0. At other interior points f' is ±1, never 0.",
     ["A cusp has no derivative at 0; continuity alone is insufficient for MVT.","Endpoint differentiability is not the theorem's requirement and does not repair the interior cusp.","A zero secant slope does not force each derivative to be zero, and here none is."]),
    ("For q(x)=sqrt(x) on [0,4], a student rejects MVT because q'(0) is undefined. Which conclusion is justified?",
     ["MVT applies: differentiability is required on (0,4), not at 0; the secant slope is 1/2 and q'(1)=1/2.","MVT fails because the derivative must exist at both endpoints of a closed interval.","MVT applies, but the matching derivative occurs only at x=0.","MVT fails because the graph is not a straight line."],
     "sqrt(x) is continuous on [0,4] and differentiable on (0,4). Its secant slope is (2-0)/4=1/2, and 1/(2sqrt(c))=1/2 gives c=1.",
     ["The theorem asks for continuity at endpoints and differentiability only in the open interval.","x=0 is excluded from the sought interior point and has no finite derivative.","MVT applies to nonlinear differentiable curves; the graph need not itself be a straight line."]),
    ("A student uses MVT on r(x)=1/x over [-1,1], claiming that some interior tangent has slope [r(1)-r(-1)]/2=1. Which objection is decisive?",
     ["r is undefined at 0, so it is not continuous on [-1,1]; in fact r'(x)=-1/x² never equals +1 where defined.","MVT applies because the endpoint values are finite, so a tangent of slope +1 is guaranteed.","MVT fails only because r' is undefined at x=-1 and x=1.","MVT applies with c=0 because the two branches are symmetric."],
     "The domain gap at 0 breaks closed-interval continuity and open-interval differentiability. Every defined derivative is negative, while the endpoint secant slope is positive.",
     ["Finite endpoint values do not imply continuity through the interval's interior.","Endpoint derivative values are not required by MVT; the interior discontinuity is decisive.","The function and derivative are undefined at c=0, so symmetry supplies no MVT point."]),
    ("A student applies MVT to s(x)=x^(2/3) on [-1,1], where both endpoint values equal 1, and concludes s'(c)=0 for some interior c. Which analysis is correct?",
     ["The cusp at 0 makes s nondifferentiable there; at every other interior x the derivative is nonzero, so MVT does not apply and no such c exists.","The equal endpoints force c=0 with derivative 0.","MVT applies because s is continuous, regardless of interior differentiability.","The theorem guarantees c=-1 or c=1 because both are endpoint extrema."],
     "s is continuous, but s'(x)=(2/3)x^(-1/3) is undefined at 0 and nonzero elsewhere in (-1,1). The differentiability hypothesis fails.",
     ["A cusp derivative does not become zero merely because endpoint values match.","MVT requires differentiability throughout the open interval as well as closed-interval continuity.","The theorem seeks an interior point, not either endpoint."])
])

add("C","interpret the MVT guarantee and detect incompatible rate claims",[
    ("A differentiable distance function records 0 miles at noon and 150 miles at 3 p.m. It is continuous throughout the trip. A driver claims the instantaneous rate was always below 45 miles per hour. Which statement follows?",
     ["The endpoint data imply an average rate of 50 miles per hour, so MVT guarantees a time strictly between noon and 3 p.m. with instantaneous rate 50; the claim is incompatible.","The average rate is 45 miles per hour, so the claim could be correct.","MVT guarantees the rate is 50 miles per hour at every moment of the trip.","MVT cannot apply because the distance at intermediate times is not listed."],
     "The average rate is (150-0)/3=50. The stated continuity and differentiability imply at least one interior instantaneous rate of 50, contradicting an always-below-45 bound.",
     ["150 miles divided by three hours is 50 miles per hour, not 45.","MVT guarantees at least one interior time, not a constant rate at every time.","An explicit formula or intermediate observations are unnecessary when the hypotheses and endpoints are known."]),
    ("A tank's water volume rises from 20 to 68 liters over four minutes. Volume is continuous over the closed interval and differentiable inside. An observer says inflow was always under 10 liters per minute. What does MVT imply?",
     ["An interior instant has volume-change rate 12 liters per minute, contradicting the claimed upper bound.","An interior instant has rate 10 liters per minute, confirming the claim.","The volume must rise at 12 liters per minute during every minute.","Only endpoint rates can be inferred, so the claim cannot be evaluated."],
     "The average change is (68-20)/4=12 liters per minute; MVT guarantees an interior derivative of 12, which exceeds the claimed upper bound 10.",
     ["The 48-liter increase over four minutes yields 12, not 10.","MVT supplies at least one instant, not a constant rate over the full interval.","The theorem yields an interior rate from endpoints and regularity, not an endpoint derivative."]),
    ("A continuously differentiable cooling object's temperature falls from 80 to 56 degrees over six minutes. A sensor report claims its temperature-change rate was always greater than -3 degrees per minute. Which conclusion is justified?",
     ["MVT guarantees an interior temperature-change rate of -4 degrees per minute, so the report is inconsistent.","MVT gives +4 degrees per minute because temperature is positive.","The report is consistent because -4 is greater than -3.","The rate must have been exactly -4 throughout the six minutes."],
     "The average change is (56-80)/6=-4 degrees per minute. At some interior time the instantaneous derivative equals -4, which is not greater than -3.",
     ["The signed rate is negative because temperature decreased, despite positive temperature values.","On the number line -4 is less than -3, contradicting an always-greater-than--3 report.","MVT guarantees one matching instant, not a constant rate."]),
    ("A plant's measured height increases from 8 to 23 centimeters in five days. Assume height is continuous and differentiable on the required intervals. Which claim is guaranteed by MVT, and which is not?",
     ["At least one interior instant has growth rate 3 centimeters per day; the theorem does not say when or that the rate stays 3.","The growth rate equals 3 centimeters per day on every day.","The growth rate equals 15 centimeters per day at the fifth-day endpoint.","No instantaneous rate can be inferred without knowing the formula for height."],
     "The secant slope is (23-8)/5=3 centimeters per day. MVT guarantees at least one interior derivative equal to that average, without fixing its time or constancy.",
     ["An average rate does not imply the same instantaneous rate throughout the interval.","The total increase is 15 centimeters, not a per-day rate, and an endpoint derivative is not guaranteed.","MVT needs endpoints and its regularity hypotheses, not an explicit height formula."])
])

src="\n\n".join(blocks)+"\n"
(HERE/"source_draft.md").write_text(src)
BC=HERE.parent/"apcalcbc-harder-seeds-u5-t5_1-2026-11-12"
BC.mkdir(exist_ok=True)
(BC/"source_draft.md").write_text(src)
print("wrote shared 5.1 draft to AB and BC")
