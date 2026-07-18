import type { Difficulty, FrqCriterionSpec, FrqPartSpec, FrqSpec, McqSpec, SubjectSpec } from "./types.ts";

const d = (description: string, evidence: string[], numeric?: FrqCriterionSpec["numeric"]): FrqCriterionSpec => ({ description, evidence, ...(numeric ? { numeric } : {}) });
const p = (prompt: string, ...criteria: FrqCriterionSpec[]): FrqPartSpec => ({ prompt, criteria });
const f = (unit: number, practice: number, difficulty: Difficulty, archetype: string, calculator: boolean, scenario: string, parts: FrqPartSpec[], boundaryCases?: string[]): FrqSpec => ({ unit, practice, difficulty, archetype, calculator, scenario, parts, ...(boundaryCases ? { boundaryCases } : {}) });
const m = (unit: number, practice: number, difficulty: Difficulty, stem: string, choices: McqSpec["choices"], key: McqSpec["key"], reasoning: string, wrong: [string, string, string, string]): McqSpec => ({ unit, practice, difficulty, stem, choices, key, reasoning, distractors: wrong });

const mcq: McqSpec[] = [
  m(1,1,"Easy","Evaluate lim(x→3) (x²−9)/(x−3).",["0","3","6","The limit does not exist"],"C","Factoring gives x+3 for x≠3, whose limit is 6.",["Substitution into the uncanceled numerator alone does not evaluate the quotient.","This uses only the approach value, not the simplified function.","Correct.","The removable hole does not prevent the two-sided limit from existing."]),
  m(1,3,"Medium","For x≠2 let f(x)=(x²−a)/(x−2), and define f(2)=4. For which value of a is f continuous at x=2?",["0","2","4","8"],"C","Continuity requires x²−a to vanish at x=2; a=4 then yields lim f(x)=lim(x+2)=4.",["The quotient would have a vertical asymptote.","The numerator would not vanish at x=2.","Correct.","The numerator would not vanish at x=2."]),
  m(1,3,"Easy","A function g is continuous on [1,4], with g(1)=−2 and g(4)=5. Which conclusion is guaranteed?",["g has exactly one zero in (1,4)","g has at least one zero in (1,4)","g is increasing on [1,4]","g′ exists everywhere on (1,4)"],"B","The Intermediate Value Theorem guarantees at least one zero because 0 lies between the endpoint values.",["Continuity does not guarantee uniqueness.","Correct.","Continuity and endpoint values do not guarantee monotonicity.","A continuous function need not be differentiable."]),
  m(2,1,"Easy","If f(x)=x²+1, which value equals f′(3)?",["3","5","6","10"],"C","The difference quotient simplifies to 6+h, so its limit is 6.",["This confuses the input with the slope.","This subtracts 1 rather than differentiating.","Correct.","This evaluates f(3), not f′(3)."]),
  m(2,1,"Medium","Find d/dx [e^(2x) sin x].",["2e^(2x) cos x","e^(2x)(2 sin x+cos x)","e^(2x)(sin x+2 cos x)","2e^x sin x"],"B","The product rule and chain rule give 2e^(2x)sin x+e^(2x)cos x.",["This omits both product-rule terms.","Correct.","The factors of 2 are attached to the wrong term.","This differentiates e^(2x) incorrectly and omits a product-rule term."]),
  m(2,2,"Medium","The tangent line to y=ln x at x=e is",["y=1+(x−e)/e","y=e+(x−1)/e","y=1+e(x−e)","y=(x−e)/e"],"A","The point is (e,1) and the slope is 1/e.",["Correct.","This uses an incorrect point.","This uses slope e instead of 1/e.","This omits the y-coordinate 1 of the tangency point."]),
  m(3,1,"Medium","Find d/dx √(1+x³).",["3x²/(2√(1+x³))","3x²√(1+x³)","1/(2√(1+x³))","3x/(2√(1+x³))"],"A","Applying the chain rule to (1+x³)^(1/2) gives 3x²/(2√(1+x³)).",["Correct.","The derivative of the outer square root is inverted.","This omits the inner derivative 3x².","The derivative of x³ is not 3x."]),
  m(3,1,"Hard","On x²+xy+y²=7, what is dy/dx at (1,2)?",["−5/4","−4/5","4/5","5/4"],"B","Implicit differentiation gives 2x+y+(x+2y)y′=0, so y′=−4/5 at (1,2).",["This takes the negative reciprocal of the correct slope.","Correct.","The sign from moving 2x+y is missing.","Both sign and reciprocal are incorrect."]),
  m(4,1,"Medium","A circular stain has radius increasing at 0.30 cm/min. When r=5 cm, its area is increasing at",["0.30π cm²/min","1.5π cm²/min","3π cm²/min","25π cm²/min"],"C","Differentiating A=πr² gives dA/dt=2πr·dr/dt=3π.",["This fails to differentiate r².","This omits the factor 2.","Correct.","This reports area rather than its rate."]),
  m(4,3,"Hard","Let h(x)=√x. The tangent-line estimate at x=9 is used for √10. The estimate is",["an underestimate because h is concave up","an overestimate because h is concave down","exact because h is linear near 9","an underestimate because h′(9)>0"],"B","Since h″(x)<0, the tangent line lies above the graph, so the linearization overestimates √10.",["The square-root function is not concave up.","Correct.","Local linearity is an approximation, not exact equality.","The sign of the first derivative does not determine over- versus underestimation."]),
  m(5,2,"Medium","A particle has position s(t)=t³−6t²+9t for t≥0. At which time does s have a local maximum?",["t=0","t=1","t=2","t=3"],"B","v(t)=3(t−1)(t−3) changes from positive to negative at t=1.",["The endpoint is not the requested interior sign change.","Correct.","The velocity is not zero at t=2.","At t=3 velocity changes from negative to positive, giving a local minimum."]),
  m(5,3,"Hard","For f(x)=x² on [1,4], the Mean Value Theorem value c satisfies",["c=3/2","c=2","c=5/2","c=3"],"C","The secant slope is (16−1)/3=5 and f′(c)=2c, so c=5/2.",["This uses the midpoint of the left half.","This uses the interval midpoint without matching slopes.","Correct.","This confuses the secant slope with c."]),
  m(5,2,"Very Hard","Suppose f′(x)=x(x−2) and f(0)=1. Which statement is true?",["f has a local minimum at x=0","f has a local maximum at x=0 and a local minimum at x=2","f is increasing only on (0,2)","f is concave down for all x"],"B","The sign of f′ is positive, then negative, then positive across 0 and 2.",["The sign changes positive to negative at 0, so it is a maximum.","Correct.","f′ is negative on (0,2).","Since f″=2x−2, concavity changes at x=1."]),
  m(6,1,"Medium","If F(x)=∫[1 to x²] cos(t³)dt, then F′(x)=",["cos(x⁶)","2x cos(x⁶)","2x cos(x³)","x² cos(x⁶)"],"B","The Fundamental Theorem and chain rule give cos((x²)³)·2x.",["This omits the derivative of the upper limit.","Correct.","The integrand must be evaluated at t=x², producing x⁶.","The derivative of x² is 2x, not x²."]),
  m(6,1,"Easy","Evaluate ∫ 2x/(x²+5) dx.",["2 ln(x²+5)+C","ln(x²+5)+C","1/(x²+5)+C","x² ln(x²+5)+C"],"B","With u=x²+5 and du=2x dx, the integral is ln(x²+5)+C.",["The factor 2 has already been absorbed into du.","Correct.","Differentiating this expression does not recover the integrand.","This incorrectly applies integration by parts."]),
  m(6,2,"Easy","The average value of f(x)=x² on [0,3] is",["3","6","9","27"],"A","(1/3)∫[0 to 3]x²dx=(1/3)(9)=3.",["Correct.","This is twice the average value.","This is f(3), not the average.","This is the endpoint cube before dividing by the needed factors."]),
  m(6,2,"Hard","A(t)=10+∫[0 to t](u²−4u+3)du. On which interval is A decreasing?",["(−∞,1)","(1,3)","(3,∞)","A never decreases"],"B","A′(t)=(t−1)(t−3), which is negative between its zeros.",["The derivative is positive there.","Correct.","The derivative is positive there.","The integrand, and hence A′, is negative on (1,3)."]),
  m(7,1,"Hard","The solution of dy/dx=2x/y with y(0)=3 satisfies y(2)=",["√13","4","√17","5"],"C","Separating gives y dy=2x dx, so y²=2x²+9 and the positive branch gives √17.",["This omits one x² contribution.","Squaring 4 does not satisfy the initial-value relation.","Correct.","This results from adding rather than integrating consistently."]),
  m(8,1,"Easy","The area enclosed by y=x and y=x² on 0≤x≤1 is",["1/6","1/3","1/2","2/3"],"A","On [0,1], x is above x² and ∫(x−x²)dx=1/6.",["Correct.","This omits the integral of one boundary.","This is the area under y=x only.","This reverses or miscombines the antiderivative terms."]),
  m(8,1,"Very Hard","The region under y=√x from x=0 to x=4 is revolved about the x-axis. Its volume is",["4π","8π","16π","32π/3"],"B","Using disks, V=π∫[0 to 4](√x)²dx=π∫[0 to 4]x dx=8π.",["This halves the correct integral.","Correct.","This doubles the disk integral.","This integrates √x rather than the squared radius."]),
];

const frq: FrqSpec[] = [
  f(1,3,"Easy","representation",false,"Define g(x)=(x²−4)/(x−2) for x≠2 and g(2)=k.",[
    p("Find lim(x→2)g(x) and show the algebra used.",d("The limit is 4 after factoring x²−4=(x−2)(x+2).",["factor","x+2","4"],{expected:4,tolerance:0})),
    p("Choose k so that g is continuous at x=2 and justify the choice.",d("k=4 because continuity requires the function value to equal the limit.",["k=4","function value","limit"])),
    p("State whether g is differentiable at x=2 for this k and give g′(2).",d("Yes; the filled function equals x+2, so g′(2)=1.",["differentiable","x+2","1"],{expected:1,tolerance:0})),
  ]),
  f(1,3,"Medium","justification",false,"A continuous function q satisfies q(0)=3, q(2)=−1, and q(5)=4.",[
    p("Explain what the Intermediate Value Theorem guarantees about zeros on (0,2) and (2,5).",d("There is at least one zero in each interval because the endpoint values change sign.",["at least one","(0,2)","(2,5)","sign"])),
    p("Can the given information establish exactly two zeros on [0,5]? Explain.",d("No; continuity guarantees existence but not uniqueness, so additional crossings are possible.",["no","not uniqueness","additional"])),
    p("Give one additional condition that would make exactly one zero in each interval follow.",d("Strict monotonicity on each interval, with the stated sign changes, would give uniqueness.",["strictly monotonic","each interval","uniqueness"])),
  ]),
  f(2,1,"Easy","procedural",false,"A particle moves on a line with position x(t)=t³−3t²+2 for 0≤t≤4, measured in meters.",[
    p("Find the velocity and acceleration functions.",d("v(t)=3t²−6t and a(t)=6t−6.",["3t²−6t","6t−6"])),
    p("Find all times when the particle is at rest.",d("The particle is at rest at t=0 and t=2.",["v=0","t=0","t=2"])),
    p("Determine whether the particle speeds up or slows down immediately after t=2.",d("Immediately after 2, v>0 and a>0, so the particle speeds up.",["v>0","a>0","speeds up"])),
  ]),
  f(2,2,"Medium","representation",false,"Let r(x)=ln x. Use information at x=e to approximate nearby values.",[
    p("Write the tangent line L(x) at x=e.",d("L(x)=1+(x−e)/e.",["1","1/e","x−e"])),
    p("Use L to approximate ln(e+0.2).",d("The approximation is 1+0.2/e, about 1.0736.",["1+0.2/e","1.0736"],{expected:1.0736,tolerance:0.0002})),
    p("State whether the estimate is high or low and justify using concavity.",d("It is high because r″(x)=−1/x²<0 and tangent lines lie above a concave-down graph.",["high","−1/x²","concave down","above"])),
  ]),
  f(3,1,"Medium","procedural",false,"Points (x,y) lie on x²+xy+2y²=14 near the point (2,2).",[
    p("Find dy/dx in terms of x and y.",d("dy/dx=−(2x+y)/(x+4y).",["−(2x+y)","x+4y"])),
    p("Find the slope at (2,2).",d("The slope is −3/5.",["−3/5"],{expected:-0.6,tolerance:0})),
    p("Write the normal line at (2,2).",d("A normal line is y−2=(5/3)(x−2).",["y−2","5/3","x−2"])),
  ]),
  f(3,3,"Hard","justification",false,"A differentiable one-to-one function h has h(1)=4, h′(1)=−3, h(4)=7, and h′(4)=2.",[
    p("Evaluate (h⁻¹)′(4).",d("(h⁻¹)′(4)=1/h′(1)=−1/3.",["1/h′(1)","−1/3"])),
    p("Let P(x)=h⁻¹(x²). Find P′(2).",d("P′(2)=2·2/h′(1)=−4/3.",["2x","h′(1)","−4/3"])),
    p("Explain why h′(4) is not used in either calculation.",d("The inverse derivative at input 4 uses the original input h⁻¹(4)=1, not the point where h has input 4.",["h⁻¹(4)=1","original input","not h′(4)"])),
  ]),
  f(4,1,"Medium","modeling",false,"A spherical balloon has radius increasing at 0.4 cm/s. Consider the instant when the radius is 6 cm.",[
    p("Find the instantaneous rate of change of volume V=(4/3)πr³.",d("dV/dt=4πr² dr/dt=57.6π cm³/s.",["4πr²","0.4","57.6π"],{expected:180.9557,tolerance:0.01,unit:"cm^3/s"})),
    p("Find the instantaneous rate of change of surface area S=4πr².",d("dS/dt=8πr dr/dt=19.2π cm²/s.",["8πr","0.4","19.2π"])),
    p("Explain why dV/dt is not constant even though dr/dt is constant.",d("The volume rate contains the changing factor r², so equal radial increases add larger shells as the balloon grows.",["r²","changing radius","larger"])),
  ]),
  f(4,3,"Hard","modeling",true,"Water enters a tank at R(t)=12+3sin(t/2) liters per minute and leaves at 10 liters per minute, where 0≤t≤6.",[
    p("Write an expression for the net change in water volume from t=0 to t=6.",d("The net change is ∫[0 to 6](2+3sin(t/2))dt.",["integral 0 to 6","2+3sin(t/2)"])),
    p("Evaluate the net change.",d("The net change is 12+6(1−cos 3) liters, approximately 23.94 liters.",["12+6(1−cos 3)","23.94"],{expected:23.93995,tolerance:0.01,unit:"liters"})),
    p("At what times is the water volume increasing?",d("It is increasing throughout 0≤t≤6 because 2+3sin(t/2)>0 on this interval.",["2+3sin(t/2)>0","0≤t≤6","throughout"])),
  ]),
  f(5,2,"Medium","representation",false,"A differentiable function has derivative f′(x)=(x+1)(x−2)²(x−4).",[
    p("Identify all critical numbers of f.",d("The critical numbers are x=−1, 2, and 4.",["−1","2","4"])),
    p("Classify each critical number using a sign analysis of f′.",d("f has local maxima at −1, no extremum at 2, and a local minimum at 4.",["maximum at −1","no extremum at 2","minimum at 4"])),
    p("Explain the significance of the squared factor at x=2.",d("The even multiplicity means f′ touches zero without changing sign, so monotonicity does not switch there.",["even multiplicity","no sign change","monotonicity"])),
  ]),
  f(5,3,"Hard","justification",false,"Let f(x)=x+9/x on the closed interval [1,6].",[
    p("Find all critical numbers in the interval.",d("f′(x)=1−9/x², so the only interior critical number is x=3.",["1−9/x²","x=3"])),
    p("Determine the absolute minimum and maximum values and their locations.",d("The absolute minimum is 6 at x=3; the absolute maximum is 10 at x=1.",["minimum 6 at x=3","maximum 10 at x=1"])),
    p("Explain why checking only the critical number would be insufficient.",d("The closed-interval method also requires endpoint values, one of which supplies the absolute maximum.",["endpoints","closed interval","maximum"])),
  ]),
  f(6,1,"Easy","procedural",false,"Define F(x)=∫[0 to x](3t²−4t+1)dt.",[
    p("Find F′(x) and F″(x).",d("F′(x)=3x²−4x+1 and F″(x)=6x−4.",["3x²−4x+1","6x−4"])),
    p("Find the intervals on which F is increasing.",d("F is increasing for x<1/3 and x>1.",["x<1/3","x>1","F′>0"])),
    p("Find the x-coordinate where F changes concavity.",d("F changes concavity at x=2/3.",["F″=0","x=2/3"])),
  ]),
  f(6,1,"Medium","procedural",false,"Evaluate integrals using justified substitutions.",[
    p("Evaluate ∫[0 to 1] x e^(x²) dx.",d("The value is (e−1)/2 using u=x².",["u=x²","(e−1)/2"])),
    p("Evaluate ∫[0 to π/4] sec²x/(1+tan x) dx.",d("The value is ln 2 using u=1+tan x.",["u=1+tan x","ln 2"])),
    p("Explain why no absolute-value issue remains in the second definite integral.",d("On [0,π/4], 1+tan x is positive.",["positive","[0,π/4]","1+tan x"])),
  ]),
  f(7,1,"Hard","modeling",false,"A population P, in hundreds, satisfies dP/dt=0.2P(5−P) with P(0)=1.",[
    p("State the equilibrium solutions and identify which is stable for positive populations.",d("The equilibria are P=0 and P=5; P=5 is stable for positive initial values.",["P=0","P=5","stable"])),
    p("Find d²P/dt² when P=2 and determine the concavity then.",d("P′=1.2 and P″=0.2P′(5−2P)=0.24, so the solution is concave up.",["P′=1.2","P″=0.24","concave up"])),
    p("At what population is the growth rate greatest? Justify.",d("Growth is greatest at P=2.5 hundreds, the vertex of 0.2P(5−P).",["P=2.5","vertex","greatest growth"])),
  ]),
  f(7,2,"Very Hard","representation",false,"The differential equation is dy/dx=x−y with y(0)=1.",[
    p("Use Euler's method with step size 0.5 to approximate y(1).",d("The Euler approximation is y(1)=0.5: y(0.5)=0.5 and the next Euler slope is 0.",["step 0.5","y(0.5)=0.5","next slope 0","y(1)=0.5"],{expected:0.5,tolerance:0})),
    p("Solve the differential equation exactly.",d("Using an integrating factor gives y=x−1+2e^(−x).",["integrating factor","x−1+2e^(−x)"])),
    p("Compare the Euler value with the exact y(1) and state the error direction.",d("The exact value is 2/e≈0.7358, so 0.5 is an underestimate.",["2/e","0.7358","underestimate"])),
  ]),
  f(8,1,"Hard","modeling",false,"The region R is bounded by y=2x and y=x² for 0≤x≤2.",[
    p("Find the area of R.",d("The area is ∫[0 to 2](2x−x²)dx=4/3.",["2x−x²","4/3"])),
    p("Find the volume when R is revolved about the x-axis.",d("Using washers, V=π∫[0 to 2](4x²−x⁴)dx=64π/15.",["washers","4x²−x⁴","64π/15"])),
    p("Write, but do not evaluate, an integral for the volume when R is revolved about y=5.",d("A correct washer integral is π∫[0 to 2][(5−x²)²−(5−2x)²]dx.",["π integral 0 to 2","(5−x²)²","(5−2x)²"])),
  ]),
  f(8,3,"Very Hard","modeling",true,"A reservoir's depth is modeled by h(t)=2+0.4t−0.05t² meters for 0≤t≤6. Its horizontal cross-sectional area at depth h is A(h)=30+5h square meters.",[
    p("Find the instantaneous rate of change of water volume at t=4.",d("dV/dt=A(h(t))h′(t); h(4)=2.8 and h′(4)=0, so dV/dt=0.",["A(h)h′","h(4)=2.8","h′(4)=0","dV/dt=0"])),
    p("Find the total change in volume from t=0 to t=6.",d("The change is ∫[2 to 2.6](30+5h)dh=24.9 m³.",["integral 2 to 2.6","30+5h","24.9"],{expected:24.9,tolerance:0.01,unit:"m^3"})),
    p("Explain why total distance traveled by the water surface is not h(6)−h(0).",d("The surface rises until t=4 and then falls, so total distance must add the absolute changes on both intervals.",["rises until t=4","falls","absolute changes"])),
  ]),
];

export const calculusAb: SubjectSpec = {
  key: "ap-calculus-ab", name: "AP Calculus AB", examCode: "ap_calculus_ab", examDate: "2026-05-11", prefix: "apcalcab",
  factPackPath: "docs/product/AP_CALCULUS_AB_FACT_PACK.md", factPackSourceKey: "ap-calculus-ab-public-fact-pack",
  units: [[1,"Limits and Continuity",.10,.15],[2,"Differentiation Definition and Fundamental Properties",.10,.15],[3,"Differentiation Composite Implicit and Inverse Functions",.05,.10],[4,"Contextual Applications of Differentiation",.10,.15],[5,"Analytical Applications of Differentiation",.15,.20],[6,"Integration and Accumulation of Change",.15,.20],[7,"Differential Equations",.05,.10],[8,"Applications of Integration",.10,.15]],
  practices: ["Mathematical Procedures","Connecting Representations","Justification and Reasoning","Notation and Communication"],
  archetypes: [{key:"procedural",label:"Procedural and Symbolic",examTarget:2},{key:"representation",label:"Connecting Representations",examTarget:2},{key:"modeling",label:"Contextual Modeling",examTarget:1},{key:"justification",label:"Justification",examTarget:1}],
  mcq, frq, mcqMinutes:100, frqMinutes:90, frqExamCount:6,
};
