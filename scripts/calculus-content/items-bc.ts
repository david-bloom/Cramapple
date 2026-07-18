import type { Difficulty, FrqCriterionSpec, FrqPartSpec, FrqSpec, McqSpec, SubjectSpec } from "./types.ts";

const d=(description:string,evidence:string[],numeric?:FrqCriterionSpec["numeric"]):FrqCriterionSpec=>({description,evidence,...(numeric?{numeric}:{})});
const p=(prompt:string,...criteria:FrqCriterionSpec[]):FrqPartSpec=>({prompt,criteria});
const f=(unit:number,practice:number,difficulty:Difficulty,archetype:string,calculator:boolean,scenario:string,parts:FrqPartSpec[],boundaryCases?:string[]):FrqSpec=>({unit,practice,difficulty,archetype,calculator,scenario,parts,...(boundaryCases?{boundaryCases}:{})});
const m=(unit:number,practice:number,difficulty:Difficulty,stem:string,choices:McqSpec["choices"],key:McqSpec["key"],reasoning:string,wrong:[string,string,string,string]):McqSpec=>({unit,practice,difficulty,stem,choices,key,reasoning,distractors:wrong});

const mcq: McqSpec[] = [
  m(1,1,"Easy","Evaluate lim(x→0) (e^(2x)−1)/x.",["0","1","2","The limit diverges"],"C","The expression has derivative ratio 2e^(2x)/1 at 0, or follows the standard exponential limit, giving 2.",["The numerator and denominator both approach zero, but their ratio need not.","This omits the inner factor 2.","Correct.","The removable 0/0 form has a finite limit."]),
  m(2,1,"Medium","For x>0, d/dx(x^x) equals",["x·x^(x−1)","x^x ln x","x^x(ln x+1)","x^(x−1)(x+1)"],"C","Logarithmic differentiation of y=x^x gives y′/y=ln x+1.",["This treats the exponent as constant.","This treats the base as constant.","Correct.","This does not follow from logarithmic differentiation."]),
  m(3,1,"Medium","Find d/dx arctan(3x).",["1/(1+9x²)","3/(1+9x²)","3/(1+3x²)","1/(1+3x)"],"B","The inverse-tangent derivative and chain rule give 3/(1+(3x)²).",["This omits the inner derivative 3.","Correct.","The squared inner function is incorrect.","The inverse-tangent denominator requires a square."]),
  m(4,2,"Hard","A particle has velocity v(t)=te^(−t), t≥0. At what time is its speed greatest?",["t=0","t=1","t=2","There is no maximum"],"B","Velocity is nonnegative and v′(t)=e^(−t)(1−t), which changes from positive to negative at t=1.",["The speed is zero initially.","Correct.","The velocity is already decreasing at t=2.","The speed tends to zero and has an interior maximum."]),
  m(5,2,"Medium","If f′(x)=x²(x−3), which statement is true?",["f has a local maximum at x=0","f has a local minimum at x=0","f has a local minimum at x=3","f has no local extrema"],"C","The derivative does not change sign at the double zero 0, but changes from negative to positive at 3.",["The even-multiplicity zero has no sign change.","The even-multiplicity zero has no sign change.","Correct.","There is a sign change at x=3."]),
  m(5,3,"Hard","For f(x)=x⁴−4x³, the graph is concave up on",["(−∞,0) only","(0,2) only","(−∞,0)∪(2,∞)","(0,∞)"],"C","f″(x)=12x(x−2), which is positive outside the roots 0 and 2.",["Concavity is also up for x>2.","The second derivative is negative there.","Correct.","The interval (0,2) is concave down."]),
  m(5,1,"Very Hard","One Newton iteration for solving x³−2=0, starting at x₀=1, gives x₁=",["1","4/3","3/2","2"],"B","Newton's formula gives 1−(1−2)/3=4/3.",["This performs no update.","Correct.","This uses an incorrect derivative or arithmetic.","This jumps to the radicand rather than applying Newton's method."]),
  m(6,1,"Medium","Evaluate ∫x e^x dx.",["e^x(x−1)+C","e^x(x+1)+C","x²e^x/2+C","e^x+C"],"A","Integration by parts with u=x gives xe^x−e^x+C.",["Correct.","Differentiation produces e^x(x+2).","This is not the integration-by-parts result.","This omits the factor x contribution."]),
  m(6,1,"Hard","An antiderivative of 1/(x²−1) is",["ln|x²−1|+C","(1/2)ln|(x−1)/(x+1)|+C","ln|(x−1)/(x+1)|+C","arctan x+C"],"B","Partial fractions give (1/2)/(x−1)−(1/2)/(x+1).",["Differentiating gives 2x/(x²−1).","Correct.","This is twice the needed antiderivative.","Arctangent applies to 1/(1+x²), not this difference of squares."]),
  m(6,3,"Medium","The improper integral ∫[1 to ∞] x^(−p)dx converges exactly when",["p<0","p<1","p=1","p>1"],"D","The p-integral has a finite tail precisely for p>1.",["Negative p makes the integrand grow.","For p≤1 the tail does not have a finite limit.","p=1 is the divergent logarithmic case.","Correct."]),
  m(6,1,"Easy","Evaluate ∫[0 to 1] 1/(1+x²) dx.",["ln 2","π/6","π/4","1"],"C","The antiderivative is arctan x, giving π/4−0.",["This is not a logarithmic antiderivative.","This corresponds to arctan(1/√3).","Correct.","The integrand is not constant 1."]),
  m(7,2,"Hard","For dP/dt=0.4P(10−P), the solution curve has greatest upward slope when P=",["0","2.5","5","10"],"C","As a function of P, 0.4P(10−P) is a downward-opening quadratic with vertex at P=5.",["This is an equilibrium with zero growth.","This is below the vertex.","Correct.","This is an equilibrium with zero growth."]),
  m(8,1,"Medium","The length of y=x^(3/2) from x=0 to x=1 is represented by",["∫[0 to 1]√(1+(9/4)x)dx","∫[0 to 1](1+(3/2)√x)dx","∫[0 to 1]√(1+(3/2)x)dx","∫[0 to 1]√(1+x³)dx"],"A","Arc length is ∫√(1+(y′)²)dx and y′=(3/2)√x.",["Correct.","The derivative must be squared inside a square root.","The square of the derivative is (9/4)x.","This squares the original function rather than its derivative."]),
  m(9,1,"Medium","A curve is x=t²+1, y=t³−t. At t=1, dy/dx equals",["0","1","2","3"],"B","dy/dx=(3t²−1)/(2t), which equals 1 at t=1.",["The numerator is not zero at 1.","Correct.","This uses only dx/dt.","This uses only part of dy/dt."]),
  m(9,1,"Hard","The area inside r=2cos θ for −π/2≤θ≤π/2 is",["π/2","π","2π","4π"],"B","Polar area is (1/2)∫4cos²θ dθ=π over the stated interval.",["This misses a factor from integrating over the full traced circle.","Correct.","This doubles the polar-area result.","This is the square's scale without angular averaging."]),
  m(9,2,"Medium","A planar position is r(t)=⟨t²,2t³⟩. Its speed at t=1 is",["√8","2√5","8","10"],"B","Velocity is ⟨2t,6t²⟩, whose magnitude at 1 is √40=2√10.",["This uses incomplete velocity components.","The displayed choice is 2√5, not √40; it is not correct.","This adds components without taking a magnitude.","This is neither the magnitude nor its square."].map((x,i)=>i===1?"Correct key correction is handled below.":x) as any),
  m(10,1,"Easy","The geometric series Σ[n=0 to ∞] 3(1/4)^n has sum",["3","4","12","It diverges"],"B","The sum is 3/(1−1/4)=4.",["This is only the first term.","Correct.","This divides by the ratio rather than 1−ratio.","The absolute ratio is less than 1."]),
  m(10,3,"Hard","For Σ[n=1 to ∞] n!/3^n, the ratio test shows the series",["converges absolutely","converges conditionally","diverges because the ratio limit is infinite","has ratio limit 1/3 and diverges"],"C","|a_(n+1)/a_n|=(n+1)/3→∞, so the terms eventually grow and the series diverges.",["The ratio limit is not below 1.","All terms are positive, so conditional convergence is inapplicable.","Correct.","The factorial contributes n+1 to the ratio."]),
  m(10,1,"Very Hard","The coefficient of x⁶ in the Maclaurin series for cos(x²) is",["−1/6","0","1/24","−1/720"],"B","cos(x²)=1−x⁴/2!+x⁸/4!−…, so no x⁶ term occurs.",["This resembles a sine-series coefficient.","Correct.","The next nonconstant powers are 4 and 8, not 6.","This uses a sixth-derivative pattern without composition."]),
  m(10,3,"Hard","Using the alternating series Σ[n=1 to ∞](−1)^(n+1)/n³, the error after 4 terms is at most",["1/64","1/125","1/216","1/625"],"B","The alternating-series remainder is bounded by the magnitude of the next term, 1/5³=1/125.",["This is the fourth term, not the next omitted term.","Correct.","This uses n=6.","This squares the correct denominator again."]),
];

// Correct the vector-speed item without obscuring the intended single key.
mcq[15].choices = ["√8","2√10","8","10"];
mcq[15].distractors = ["This uses incomplete velocity components.","Correct.","This adds components without taking a magnitude.","This is neither the magnitude nor its square."];

const frq: FrqSpec[] = [
  f(1,3,"Easy","justification",false,"Let F(x)=(sin 3x)/x for x≠0.",[
    p("Find lim(x→0)F(x).",d("The limit is 3 by rewriting as 3·sin(3x)/(3x).",["3","sin(3x)/(3x)"])),
    p("Define F(0) so F is continuous at 0.",d("Set F(0)=3, equal to the limit.",["F(0)=3","limit"])),
    p("Determine whether this extension is differentiable at 0 and find F′(0).",d("Yes; the difference quotient tends to 0, so F′(0)=0.",["difference quotient","0","differentiable"])),
  ]),
  f(2,1,"Medium","procedural",false,"For x>0 define y=x^x.",[
    p("Use logarithmic differentiation to find y′.",d("y′=x^x(ln x+1).",["ln y=x ln x","x^x","ln x+1"])),
    p("Find the critical point of y and classify it.",d("The critical point is x=e^(−1), and it is a minimum.",["x=e^(−1)","minimum"])),
    p("Find the minimum value.",d("The minimum value is e^(−1/e).",["e^(−1/e)"])),
  ]),
  f(3,1,"Hard","procedural",false,"A curve is defined implicitly by e^(xy)+x²−y=1 near (0,0).",[
    p("Find dy/dx in terms of x and y.",d("y′=−(y e^(xy)+2x)/(x e^(xy)−1).",["y e^(xy)+2x","x e^(xy)−1","negative"])),
    p("Find the slope at (0,0).",d("The slope is 0.",["0"],{expected:0,tolerance:0})),
    p("Find d²y/dx² at (0,0).",d("Differentiating again or using a local expansion gives y″(0)=2.",["second derivative","2"],{expected:2,tolerance:0})),
  ]),
  f(4,3,"Medium","modeling",true,"A drone's horizontal velocity is v(t)=6te^(−t/2) meters per second for t≥0.",[
    p("Find the time when the velocity is greatest.",d("v′(t)=6e^(−t/2)(1−t/2), so the maximum occurs at t=2 seconds.",["v′","1−t/2","t=2"])),
    p("Find the distance traveled from t=0 to t=4.",d("The distance is ∫[0 to 4]6te^(−t/2)dt=24−72e^(−2) meters.",["integral","24−72e^(−2)"])),
    p("Explain why displacement and distance are equal on this interval.",d("v(t)≥0 on [0,4], so the drone never reverses horizontal direction.",["v≥0","never reverses"])),
  ]),
  f(5,2,"Medium","representation",false,"A function f has f′(x)=x(x−2)³.",[
    p("Find and classify all critical numbers.",d("x=0 is a local maximum and x=2 is a local minimum.",["x=0 maximum","x=2 minimum"])),
    p("Find the intervals where f is increasing.",d("f is increasing on (−∞,0) and (2,∞).",["(−∞,0)","(2,∞)"])),
    p("Determine the concavity of f at x=1.",d("f″(1)=2>0, so f is concave up at x=1.",["f″(1)=2","concave up"])),
  ]),
  f(5,3,"Hard","justification",false,"The equation cos x=x has one solution in (0,1). Use Newton's method with x₀=0.75.",[
    p("Write the Newton iteration function.",d("N(x)=x−(cos x−x)/(−sin x−1).",["cos x−x","−sin x−1"])),
    p("Compute x₁ to four decimals.",d("x₁≈0.7391.",["0.7391"],{expected:0.7391,tolerance:0.0001})),
    p("Explain why the solution in (0,1) is unique.",d("For h(x)=cos x−x, h′(x)=−sin x−1<0, so h is strictly decreasing and can cross zero at most once.",["h′<0","strictly decreasing","unique"])),
  ]),
  f(6,1,"Medium","procedural",false,"Evaluate three integrals and show the method selected.",[
    p("Evaluate ∫x²e^x dx.",d("The antiderivative is e^x(x²−2x+2)+C by repeated integration by parts.",["integration by parts","e^x(x²−2x+2)"])),
    p("Evaluate ∫1/(x²−4) dx.",d("The antiderivative is (1/4)ln|(x−2)/(x+2)|+C.",["partial fractions","1/4","ln|(x−2)/(x+2)|"])),
    p("Evaluate ∫[0 to 1]x/√(1−x²) dx.",d("The improper endpoint integral equals 1 using u=1−x².",["u=1−x²","1"])),
  ]),
  f(6,3,"Hard","justification",false,"For p>0 consider I(p)=∫[2 to ∞]1/[x(ln x)^p] dx.",[
    p("Use a substitution to rewrite I(p).",d("With u=ln x, I(p)=∫[ln 2 to ∞]u^(−p)du.",["u=ln x","u^(−p)","ln 2"])),
    p("Determine all p for which I(p) converges.",d("The integral converges exactly for p>1.",["p>1"])),
    p("Evaluate I(2).",d("I(2)=1/ln 2.",["1/ln 2"])),
  ]),
  f(6,1,"Very Hard","procedural",false,"Let J=∫[0 to π/2]sin³x cos²x dx.",[
    p("Rewrite the integral using u=cos x and evaluate it.",d("J=∫[0 to 1](u²−u⁴)du=2/15.",["u=cos x","u²−u⁴","2/15"])),
    p("Express J as a beta-function value.",d("J=(1/2)B(2,3/2).",["1/2","B(2,3/2)"])),
    p("Verify the beta-function expression using gamma values.",d("(1/2)Γ(2)Γ(3/2)/Γ(7/2)=2/15.",["Gamma","Γ(7/2)","2/15"])),
  ]),
  f(7,2,"Hard","modeling",false,"A normalized concentration C satisfies dC/dt=0.6C(1−C), C(0)=0.2.",[
    p("Solve the initial-value problem.",d("C(t)=1/(1+4e^(−0.6t)).",["separation","1+4e^(−0.6t)"])),
    p("Find the time when C=0.5.",d("t=(ln 4)/0.6≈2.310.",["ln 4/0.6","2.310"])),
    p("Determine the limiting concentration and explain it from the differential equation.",d("C approaches 1, the stable positive equilibrium.",["approaches 1","stable equilibrium"])),
  ]),
  f(8,1,"Medium","modeling",false,"The curve y=(1/3)(x²+2)^(3/2) is considered for 0≤x≤1.",[
    p("Find dy/dx.",d("dy/dx=x√(x²+2).",["x√(x²+2)"])),
    p("Write and simplify the arc-length integral.",d("L=∫[0 to 1]√(1+x²(x²+2))dx=∫[0 to 1](x²+1)dx.",["arc length","(x²+1)²","x²+1"])),
    p("Evaluate the length.",d("The length is 4/3.",["4/3"])),
  ]),
  f(9,1,"Medium","representation",false,"A parametric curve is x=t²−2t and y=t³−3t for −1≤t≤3.",[
    p("Find dy/dx where dx/dt≠0.",d("dy/dx=(3t²−3)/(2t−2)=3(t+1)/2 for t≠1.",["(3t²−3)/(2t−2)","3(t+1)/2"])),
    p("Identify the parameter value for a vertical tangent and give the point.",d("At t=1, dx/dt=0 and dy/dt=0 as well; after cancellation the slope limit is 3, so there is no vertical tangent there.",["t=1","both derivatives zero","no vertical tangent"])),
    p("Find the tangent line at t=0.",d("The point is (0,0), the slope is 3/2, and the line is y=(3/2)x.",["(0,0)","3/2","y=(3/2)x"])),
  ],["At t=1 the original parameterization is singular; do not award a vertical tangent solely from dx/dt=0."]),
  f(9,2,"Very Hard","modeling",true,"A polar curve is r=1+cos θ for 0≤θ≤2π.",[
    p("Find the area enclosed by the curve.",d("A=(1/2)∫[0 to 2π](1+cos θ)²dθ=3π/2.",["polar area","(1+cos θ)²","3π/2"])),
    p("Find the slope dy/dx at θ=π/2.",d("Using polar derivatives, dy/dx=1 at θ=π/2.",["polar derivative","1"])),
    p("Write an integral for the curve length without evaluating it.",d("L=∫[0 to 2π]√((1+cos θ)²+sin²θ)dθ.",["arc length","(1+cos θ)²","sin²θ"])),
  ]),
  f(10,1,"Easy","procedural",false,"Consider the power series Σ[n=1 to ∞] n(x−2)^n/4^n.",[
    p("Find its radius and interval of convergence.",d("The radius is 4 and the interval is (−2,6); both endpoints diverge.",["radius 4","(−2,6)","endpoints diverge"])),
    p("Find the sum function inside the interval.",d("With z=(x−2)/4, the sum is z/(1−z)²=4(x−2)/(6−x)².",["z/(1−z)²","4(x−2)/(6−x)²"])),
    p("Find the value of the series at x=4.",d("At x=4, z=1/2 and the sum is 2.",["z=1/2","2"])),
  ]),
  f(10,3,"Hard","justification",false,"Use the alternating series S=Σ[n=1 to ∞](−1)^(n+1)/n⁴.",[
    p("Explain why the series converges.",d("The terms 1/n⁴ decrease to zero, so the alternating-series test applies; it also converges absolutely as a p-series.",["decrease","approach zero","absolutely","p-series"])),
    p("Find the least N that guarantees the N-term error is below 0.0001 using the alternating bound.",d("Require 1/(N+1)^4<0.0001, so the least N is 10.",["1/(N+1)^4","N=10"])),
    p("State the sign of S−S₁₀.",d("The next term is positive, so S−S₁₀>0.",["next term positive","S−S10>0"])),
  ]),
  f(10,1,"Very Hard","representation",false,"Let f(x)=ln(1+x) for −1<x≤1.",[
    p("Write the first four nonzero Maclaurin terms.",d("f(x)=x−x²/2+x³/3−x⁴/4+…",["x","−x²/2","x³/3","−x⁴/4"])),
    p("Use these terms to approximate ln(1.2).",d("At x=0.2 the approximation is 0.1822667.",["x=0.2","0.1822667"],{expected:0.1822667,tolerance:0.000001})),
    p("Give a valid error bound for this approximation.",d("The alternating bound is at most 0.2⁵/5=0.000064.",["0.2^5/5","0.000064"])),
  ]),
];

export const calculusBc: SubjectSpec = {
  key:"ap-calculus-bc",name:"AP Calculus BC",examCode:"ap_calculus_bc",examDate:"2026-05-11",prefix:"apcalcbc",
  factPackPath:"docs/product/AP_CALCULUS_BC_FACT_PACK.md",factPackSourceKey:"ap-calculus-bc-public-fact-pack",
  units:[[1,"Limits and Continuity",.05,.10],[2,"Differentiation Definition and Fundamental Properties",.05,.10],[3,"Differentiation Composite Implicit and Inverse Functions",.05,.10],[4,"Contextual Applications of Differentiation",.05,.10],[5,"Analytical Applications of Differentiation",.10,.15],[6,"Integration and Accumulation of Change",.15,.20],[7,"Differential Equations",.05,.10],[8,"Applications of Integration",.05,.10],[9,"Parametric Polar and Vector Valued Functions",.10,.15],[10,"Infinite Sequences and Series",.15,.20]],
  practices:["Mathematical Procedures","Connecting Representations","Justification and Reasoning","Notation and Communication"],
  archetypes:[{key:"procedural",label:"Procedural and Symbolic",examTarget:2},{key:"representation",label:"Connecting Representations",examTarget:2},{key:"modeling",label:"Contextual Modeling",examTarget:1},{key:"justification",label:"Justification",examTarget:1}],
  mcq,frq,mcqMinutes:100,frqMinutes:90,frqExamCount:6,
};
