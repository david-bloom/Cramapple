import json
# Verbatim from Production (published versions), 2026-09-30. Each: key, unit, stem, [(text, rationale, correct)...] in stored letter order.
I = [
("apcalcab-mcq-070",1,"The table shows values of f(x) for x near 2: f(1.9)=5.9, f(1.99)=5.99, f(1.999)=5.999, f(2.001)=6.001, f(2.01)=6.01, f(2.1)=6.1. Based on the table, what is lim(x->2) f(x)?",
 [("Does not exist, since the left- and right-side values are never exactly equal","Approaching, not equaling, is what matters for a limit.",0),("5.999","Reads a single table entry instead of the trend.",0),("6","Values approach 6 from both sides.",1),("Cannot be determined without knowing f(2)","A limit does not require the function value at the point.",0)]),
("apcalcab-mcq-024",1,"What is lim(x→∞) (5x²−x+4)/(2x²+3)?\nNo calculator is permitted.",
 [("0.0","Incorrectly applies the rule for a lower-degree numerator.",0),("0.4","Reverses the ratio of the leading coefficients.",0),("2.0","Uses the denominator's degree as the limit.",0),("2.5","Correctly compares the leading terms.",1)]),
("apcalcab-mcq-022",1,"Let f(x)=kx+1 for x<2 and f(x)=x²−1 for x≥2. For what value of k is f continuous at x=2?\nNo calculator is permitted.",
 [("0","Sets the left-hand expression equal to 1 instead of the function value at 2.",0),("1","Correctly equates the one-sided limit and function value.",1),("3/2","Divides the right-side value by 2 without subtracting 1.",0),("2","Uses the input value as the parameter.",0)]),
("apcalcab-mcq-080",1,"What is lim(x->-2) (x^2 + 5x + 6) / (x + 2)?",
 [("5","Arithmetic slip: evaluates x+3 at x=2 instead of x=-2.",0),("0","Plugs x=-2 into the numerator alone and stops before simplifying.",0),("1","Cancel the common factor, then evaluate x+3 at x=-2.",1),("Does not exist, because the denominator equals 0 at x = -2","Misses that it is a removable discontinuity, not a true division by zero.",0)]),
("apcalcab-mcq-006",2,"The tangent line to y=ln x at x=e is",
 [("y=1+(x−e)/e","The point is (e,1) and the slope is 1/e.",1),("y=e+(x−1)/e","This uses an incorrect point.",0),("y=1+e(x−e)","This uses slope e instead of 1/e.",0),("y=(x−e)/e","This omits the y-coordinate 1 of the tangency point.",0)]),
("apcalcab-mcq-027",2,"What is d/dx[sec x tan x]?\nNo calculator is permitted.",
 [("sec x(sec²x+tan x)","Combines derivative pieces but omits one tangent factor.",0),("sec x(tan²x−sec²x)","Subtracts the product-rule terms instead of adding.",0),("sec x(tan²x+sec²x)","Correctly applies the product rule to both trigonometric factors.",1),("tan x(sec²x+tan²x)","Uses tangent rather than secant as the common factor.",0)]),
("apcalcab-mcq-025",2,"Which expression equals f′(3)?\nNo calculator is permitted.",
 [("lim(h→0) [f(3+h)−f(3)]/h","Correctly instantiates the derivative definition at x=3.",1),("lim(h→0) [f(3+h)−f(h)]/3","Uses inconsistent base inputs and divides by the fixed point.",0),("lim(x→3) [f(x)−f(3)]/3","Divides by the point rather than the input change.",0),("lim(x→0) [f(3+x)−f(3)]/3","Keeps a fixed denominator instead of the increment.",0)]),
("apcalcab-mcq-028",2,"Which statement is always true?\nNo calculator is permitted.",
 [("Every continuous function is differentiable.","A corner can be continuous but not differentiable.",0),("A function with a derivative of 0 at x=a has a local extremum there.","A horizontal tangent need not be an extremum.",0),("A function can be differentiable where it is discontinuous.","Differentiability cannot occur at a discontinuity.",0),("If a function is differentiable at x=a, then it is continuous there.","Correctly states the differentiability-continuity implication.",1)]),
("apcalcab-mcq-005",3,"Find d/dx [e^(2x) sin x].",
 [("2e^(2x) cos x","This omits both product-rule terms.",0),("e^(2x)(2 sin x+cos x)","The product rule and chain rule give 2e^(2x)sin x+e^(2x)cos x.",1),("e^(2x)(sin x+2 cos x)","The factors of 2 are attached to the wrong term.",0),("2e^x sin x","This differentiates e^(2x) incorrectly and omits a product-rule term.",0)]),
("apcalcab-mcq-007",3,"Find d/dx √(1+x³).",
 [("3x²/(2√(1+x³))","Applying the chain rule to (1+x³)^(1/2) gives 3x²/(2√(1+x³)).",1),("3x²√(1+x³)","The derivative of the outer square root is inverted.",0),("1/(2√(1+x³))","This omits the inner derivative 3x².",0),("3x/(2√(1+x³))","The derivative of x³ is not 3x.",0)]),
("apcalcab-mcq-030",3,"For the curve x²+y²=25, what is dy/dx at (3,4)?\nNo calculator is permitted.",
 [("−4/3","Uses the negative reciprocal of the correct slope.",0),("−3/4","Correctly differentiates implicitly and substitutes.",1),("3/4","Drops the negative sign.",0),("4/3","Interchanges x and y and drops the sign.",0)]),
("apcalcab-mcq-008",3,"On x²+xy+y²=7, what is dy/dx at (1,2)?",
 [("−5/4","This takes the negative reciprocal of the correct slope.",0),("−4/5","Implicit differentiation gives 2x+y+(x+2y)y′=0, so y′=−4/5 at (1,2).",1),("4/5","The sign from moving 2x+y is missing.",0),("5/4","Both sign and reciprocal are incorrect.",0)]),
]
L="ABCD"; rows=[]
for k,u,stem,ch in I:
    assert sum(c[2] for c in ch)==1
    rows.append(dict(key=k,kind="mcq",unit=u,stem=stem,choices=[dict(label=L[i],text=c[0]) for i,c in enumerate(ch)],
        keyed_label=next(L[i] for i,c in enumerate(ch) if c[2]),rationales={L[i]:c[1] for i,c in enumerate(ch)}))
json.dump(rows,open("items.json","w"),indent=1); print(len(rows))
