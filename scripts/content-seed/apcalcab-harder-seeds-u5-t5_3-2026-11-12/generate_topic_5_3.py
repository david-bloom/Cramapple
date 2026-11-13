"""Author-in-session shared AB/BC topic 5.3 derivative-sign questions."""
from pathlib import Path
H=Path(__file__).resolve().parent
out=["# AP Calculus AB and BC Unit 5 topic 5.3 — Increasing and Decreasing Intervals",
     "DRAFT. Author-in-session 2026-11-12. Identical new content for separate AB and BC packs. CED FUN-4.A.1."]
def add(fam,skill,cases):
    assert len(cases)==4
    for i,(stem,ch,check,wrong) in enumerate(cases):
        assert len(ch)==4 and len(wrong)==3
        ident=f"N-5.3-{fam}"
        if i==0: out.extend(["---",f"## Seed {ident} (new) — Topic 5.3 Determining Intervals of Increase and Decrease",f"**Skill:** {skill}","",stem,""])
        else: out.extend(["",f"**{ident}-v{i}.** {stem}",""])
        out.extend([f"- **A. {ch[0]}**",*[f"- {z}. {v}" for z,v in zip("BCD",ch[1:])],"",f"Check: {check}","Rationales: "+" ".join(f"{z}: {v}" for z,v in zip("BCD",wrong))])

add("A","derive increasing and decreasing intervals from a factored derivative",[
 ("A differentiable function f has f'(x)=(x+2)(x-1) on (-4,4). On which intervals is f increasing, and why?",
  ["f increases on (-4,-2) and (1,4), where both derivative factors have the same sign.","f increases only on (-2,1), where the two factors have opposite signs.","f increases on all of (-4,4) because f' has two zeros.","f increases only at x=-2 and x=1 because f'=0 there."],
  "The product is positive for x<-2 and x>1, negative between the roots, and zero only at the roots. f increases where f'>0.",
  ["Opposite factor signs make f' negative between the roots, so f decreases there.","Zeros split the domain into sign intervals; they do not make f positive everywhere.","At the two isolated zeros the instantaneous slope is zero; intervals of increase come from positive derivative signs."]),
 ("Suppose g'(x)=-(x+3)(x-2) for every x in (-5,4). Which description of g is supported?",
  ["g increases on (-3,2) and decreases on (-5,-3) and (2,4).","g decreases on (-3,2) because the two factors have opposite signs there.","g increases on both outer intervals because a quadratic derivative is positive for large |x|.","g is constant on (-3,2) because g' vanishes at the interval's ends."],
  "Inside (-3,2) the product (x+3)(x-2) is negative, so its negative is positive. On either outer interval the product is positive and g' negative.",
  ["The leading minus sign reverses the sign of the negative product between roots.","The leading minus sign makes the derivative negative outside the roots in this case.","The derivative vanishes only at two points, not throughout the open interval between them."]),
 ("A differentiable h has h'(x)=x(x-2)(x+1) on (-3,3). Which intervals of increase follow from a sign analysis?",
  ["h increases on (-1,0) and (2,3), where the three-factor product is positive.","h increases on (-3,-1) and (0,2), where the product is negative.","h increases on all intervals because h' has three real zeros.","h increases only at x=-1, 0, and 2."],
  "Across roots -1,0,2, the cubic derivative signs are negative, positive, negative, positive. Positive signs give (-1,0) and (2,3).",
  ["A negative derivative means h decreases on those two intervals, not increases.","Roots identify sign boundaries; the derivative is negative on two of the four intervals.","A derivative equal to zero at isolated points does not define an increasing interval."]),
 ("A differentiable p satisfies p'(x)=(x-1)²(x+2) on (-4,4). Where does p decrease?",
  ["p decreases on (-4,-2); the squared factor does not reverse the derivative's sign at x=1.","p decreases on (-4,-2) and (1,4), since every derivative zero flips its sign.","p decreases on (-2,1), because x+2 is positive there.","p never decreases, because a squared factor makes p' nonnegative everywhere."],
  "(x-1)² is nonnegative and positive away from 1, so the sign comes from x+2. It is negative only for x<-2; the zero at 1 does not change sign.",
  ["An even-multiplicity zero at 1 does not switch derivative sign.","Both x+2 and the squared factor are positive on (-2,1), so p increases there.","The other factor x+2 is negative to the left of -2, making p' negative there."])
])

add("B","interpret a derivative sign representation without confusing it with function values",[
 ("A graph of f' lies above the x-axis on (-3,-1), below it on (-1,2), and above it on (2,4), crossing at -1 and 2. A student says f is negative on (-1,2). What is the justified conclusion?",
  ["f decreases on (-1,2); the sign of f' gives direction, but it does not determine whether f itself is positive or negative there.","f is negative on (-1,2) because its derivative graph is below the axis.","f increases on (-1,2) because the graph of f' may be rising there.","f is constant on (-1,2) because f' equals zero at both ends."],
  "f'<0 throughout (-1,2), so f decreases. Derivative sign alone cannot determine the vertical position or sign of f.",
  ["A negative derivative means negative slope, not necessarily negative function values.","Whether f' itself rises does not change its negative sign on the stated interval.","Zero derivative at isolated boundaries does not make f constant across the interval."]),
 ("The derivative of a differentiable g is negative on (0,2) and positive on (2,5), with g(2)=7. Which comparison is certain?",
  ["g(1)>7 and g(4)>7; g decreases toward x=2 then increases away from it, but g(1) versus g(4) is undetermined.","g(1)<7 and g(4)<7 because g' changes sign at 2.","g(1)>g(4) because the negative derivative on (0,2) controls the whole interval.","g(1)=g(4) because the intervals lie on opposite sides of x=2."],
  "As x increases from 1 to 2, g falls to 7, so g(1)>7. As x increases from 2 to 4, g rises from 7, so g(4)>7. Their relative heights need rate magnitudes.",
  ["Both side values exceed the local minimum g(2)=7, not fall below it.","Derivative signs establish each comparison to g(2), but not between g(1) and g(4).","Opposite sides of a minimum need not have equal function values without symmetry or rate information."]),
 ("A differentiable function h has h'(x)>0 on (-4,0) and h'(x)<0 on (0,3). Which statement about h(-2), h(0), and h(2) must hold?",
  ["h(-2)<h(0) and h(2)<h(0); the chart does not order h(-2) against h(2).","h(-2)<h(2)<h(0) must hold because -2<2.","h(-2)>h(0)>h(2) because a positive derivative makes earlier values larger.","h(-2)=h(2) because the derivative signs switch at 0."],
  "A positive derivative up to 0 raises h from -2 to 0, and a negative derivative afterward lowers it from 0 to 2. The two side values can differ either way.",
  ["x-order alone cannot compare values across two intervals with opposite derivative signs.","A positive derivative makes later values greater on (-4,0), not earlier ones.","A sign change at 0 establishes a peak, not symmetry of the two side values."]),
 ("A graph shows q' positive for 1<x<3, zero at x=3, and negative for 3<x<6. A student concludes q is increasing on (1,6) because q'(3)=0. What correction is valid?",
  ["q increases on (1,3) and decreases on (3,6); one zero does not override the derivative signs on either side.","q increases on all of (1,6) because a derivative can be zero at one point.","q decreases on (1,3) because q' is above the axis there.","Nothing can be inferred about monotonicity unless q values are also given."],
  "The sign of q' is positive before 3 and negative afterward. Those signs determine the two monotonic intervals independently of the isolated zero.",
  ["A zero derivative at one point does not erase a negative derivative on the entire right interval.","A derivative graph above zero means q has positive slope and increases to the left of 3.","Derivative signs are sufficient to establish monotonic intervals when differentiability is given."])
])

add("C","make a derivative sign chart around zeros and points outside the domain",[
 ("A function f is differentiable wherever x≠2 and satisfies f'(x)=(x+1)/(x-2). Its domain includes both sides of x=2 but excludes x=2. Which monotonic intervals follow?",
  ["f increases on (-infinity,-1) and (2,infinity), and decreases on (-1,2); the domain gap separates the last two intervals.","f increases on (-1,2) because the numerator is positive there.","f increases on (-infinity,-1) and (-1,infinity) because only the zero at -1 matters.","f decreases on both sides of x=2 because the denominator is zero there."],
  "The ratio signs across -1 and 2 are positive, negative, positive. x=2 is outside the domain, so monotonic intervals cannot be joined through it.",
  ["The denominator is negative on (-1,2), making the positive numerator produce a negative derivative.","The denominator changes sign at the excluded point 2, so the sign chart must split there.","A derivative undefined at one point does not force the same sign on both neighboring intervals."]),
 ("A differentiable g has g'(x)=(x-3)/(x+1) wherever x≠-1; g is undefined at -1. On which intervals is g decreasing?",
  ["g decreases on (-1,3) only, where the numerator and denominator have opposite signs.","g decreases on (-infinity,-1) and (3,infinity), because both factors share a sign there.","g decreases on (-infinity,3) as a single interval, crossing the excluded x=-1.","g never decreases because the derivative is a quotient rather than a product."],
  "For x<-1 the ratio is positive, for -1<x<3 it is negative, and for x>3 it is positive. The domain gap at -1 prevents merging across it.",
  ["Equal signs make a quotient positive, so g increases on the two outer intervals.","A monotonic interval cannot contain the point -1 where g is not defined.","A quotient can be negative; its sign is determined by numerator and denominator signs."]),
 ("A function h has h'(x)=(x+2)/(x-1) wherever x≠1, and h is undefined at 1. Which statement is warranted by the derivative?",
  ["h decreases on (-2,1) and increases on (-infinity,-2) and (1,infinity); x=1 is a domain break, not a critical point of h.","h decreases on both intervals to the left of 1 because the denominator is negative there.","x=1 is a critical point because h' does not exist there, even though h itself is undefined.","h increases throughout (-infinity,infinity) because h' is positive for large x."],
  "Across -2 and 1, ratio signs are positive, negative, positive. A critical point must be in the function's domain; x=1 is excluded.",
  ["For x<-2 both numerator and denominator are negative, making h' positive.","An excluded input is not a point of h, so it cannot be a critical point on its graph.","Positive derivative for some large x-values does not establish increase on intervals where h'<0."]),
 ("A differentiable p has p'(x)=(x-2)/(x+4) except at x=-4, where p is also undefined. A student says p increases on (-infinity,2) because the numerator is negative there. Which correction is correct?",
  ["p increases on (-infinity,-4) and (2,infinity), but decreases on (-4,2); the quotient changes sign at the excluded x=-4.","p increases on (-4,2) because a negative numerator always makes a quotient positive.","p increases on all x<2 as one interval because x=-4 is just an isolated point.","p decreases on both outer intervals because the numerator has a zero at x=2."],
  "The ratio is positive for x<-4, negative for -4<x<2, and positive for x>2. The excluded point splits the domain and the derivative sign.",
  ["On (-4,2), the denominator is positive while the numerator is negative, so p'<0.","No monotonic interval can cross an input at which the function is undefined.","A derivative zero at x=2 does not make the derivative negative on either outer interval."])
])

src="\n\n".join(out)+"\n"
(H/"source_draft.md").write_text(src)
B=H.parent/"apcalcbc-harder-seeds-u5-t5_3-2026-11-12";B.mkdir(exist_ok=True);(B/"source_draft.md").write_text(src)
print("wrote AB and BC topic 5.3 drafts")
