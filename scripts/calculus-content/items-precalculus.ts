import type { Difficulty, FrqCriterionSpec, FrqPartSpec, FrqSpec, McqSpec, SubjectSpec } from "./types.ts";

const d=(description:string,evidence:string[],numeric?:FrqCriterionSpec["numeric"]):FrqCriterionSpec=>({description,evidence,...(numeric?{numeric}:{})});
const p=(prompt:string,...criteria:FrqCriterionSpec[]):FrqPartSpec=>({prompt,criteria});
const f=(unit:number,practice:number,difficulty:Difficulty,archetype:string,calculator:boolean,scenario:string,parts:FrqPartSpec[],boundaryCases?:string[]):FrqSpec=>({unit,practice,difficulty,archetype,calculator,scenario,parts,...(boundaryCases?{boundaryCases}:{})});
const m=(unit:number,practice:number,difficulty:Difficulty,stem:string,choices:McqSpec["choices"],key:McqSpec["key"],reasoning:string,wrong:[string,string,string,string]):McqSpec=>({unit,practice,difficulty,stem,choices,key,reasoning,distractors:wrong});

const mcq: McqSpec[] = [
  m(1,1,"Easy","For f(x)=x²−3x, the average rate of change from x=1 to x=4 is",["0","2","3","5"],"B","[f(4)−f(1)]/(4−1)=(4−(−2))/3=2.",["This confuses equal-looking terms with zero change.","Correct.","This uses only the input change.","This subtracts values but does not divide correctly."]),
  m(1,2,"Medium","Which end behavior matches P(x)=−2x⁵+7x²−1?",["P→∞ at both ends","P→−∞ at both ends","P→∞ as x→−∞ and P→−∞ as x→∞","P→−∞ as x→−∞ and P→∞ as x→∞"],"C","The odd degree and negative leading coefficient determine opposite ends: left up and right down.",["This is even-degree positive behavior.","This is even-degree negative behavior.","Correct.","This reverses the sign set by the negative leading coefficient."]),
  m(1,1,"Medium","The graph of R(x)=(x²−5x+6)/(x−2) has",["a vertical asymptote at x=2","a hole at (2,−1)","a hole at (2,1)","no discontinuity"],"B","Factoring and canceling x−2 gives x−3 for x≠2, so the missing point is (2,−1).",["The common factor cancels, so the discontinuity is removable.","Correct.","The simplified value at 2 is −1, not 1.","The original domain still excludes x=2."]),
  m(1,2,"Hard","A polynomial has zeros −1 of multiplicity 2 and 3 of multiplicity 1. Which behavior is required?",["It crosses at both zeros","It touches at −1 and crosses at 3","It crosses at −1 and touches at 3","It touches at both zeros"],"B","Even multiplicity produces a touch and turn; odd multiplicity produces a crossing.",["The even-multiplicity zero does not require crossing.","Correct.","The behaviors are reversed.","The odd-multiplicity zero crosses."]),
  m(1,3,"Medium","A cubic model fits sales data for 0≤t≤12 months. Which use requires the greatest caution?",["Interpolating at t=6","Computing the model at t=0","Predicting at t=60","Comparing t=4 and t=5"],"C","A prediction far outside the observed domain is extrapolation and may not preserve the modeled pattern.",["This is inside the data domain.","This is at a modeled endpoint.","Correct.","Both inputs are inside the data domain."]),
  m(1,1,"Hard","If f(x)=2x−1 and g(x)=x²+3, then (g∘f)(x)=",["2x²+2","(2x−1)²+3","2x²+5","x²+5"],"B","Substituting f(x) into g gives (2x−1)²+3.",["This squares only x and distributes incorrectly.","Correct.","This does not substitute the complete inner expression.","This adds the formulas rather than composing them."]),
  m(1,2,"Very Hard","For Q(x)=(x−1)²(x+2)/(x²+1), the right-end behavior is closest to",["Q(x)→0","Q(x)→1","Q(x) behaves like x","Q(x) behaves like x²"],"C","The numerator has degree 3 with leading coefficient 1 and the denominator degree 2, so polynomial division gives slant behavior like x.",["The numerator degree is larger, so the ratio does not tend to zero.","Equal-degree behavior would give a horizontal limit.","Correct.","The degree difference is one, not two."]),
  m(2,1,"Easy","A quantity starts at 80 and grows by 6% each period. A suitable model is",["80+0.06t","80(0.06)^t","80(1.06)^t","1.06(80)^t"],"C","Repeated 6% growth multiplies the current amount by 1.06 each period.",["This adds 0.06 units rather than 6 percent.","This shrinks sharply because the base is below 1.","Correct.","The initial value and growth factor are reversed."]),
  m(2,1,"Medium","Solve log₂(x−1)=3.",["x=4","x=7","x=8","x=9"],"D","The equation is x−1=2³=8, so x=9.",["This uses 2·3.","This subtracts rather than adds 1.","This gives x−1 rather than x.","Correct."]),
  m(2,2,"Medium","The inverse of f(x)=3e^(2x) is",["(1/2)ln(x/3)","2ln(3x)","ln(x−3)/2","3ln(x/2)"],"A","From y=3e^(2x), divide by 3, take ln, and divide by 2.",["Correct.","The constants are not isolated correctly.","The model requires division by 3, not subtraction.","This does not undo the multiplication and exponent coefficient."]),
  m(2,1,"Hard","If 5^(2x−1)=17, then x equals",["(1+log₅17)/2","(log₅17−1)/2","1+2log₅17","log₅(17/2)"],"A","Taking log base 5 gives 2x−1=log₅17, hence x=(1+log₅17)/2.",["Correct.","The sign of the constant is reversed.","This does not solve the linear equation in x.","The exponent coefficient is not handled by dividing the argument."]),
  m(2,3,"Hard","A residual plot for an exponential regression shows a clear U-shaped pattern. This most strongly indicates",["the data are exactly exponential","the model systematically misses curvature","all residuals are zero","the response variable is categorical"],"B","A structured residual pattern shows that the model has not captured part of the relationship.",["A good fit would show unstructured residual scatter.","Correct.","A U-shape contains nonzero residuals.","Residual plots can be used for quantitative responses."]),
  m(2,1,"Easy","A medicine has half-life 5 hours. The fraction remaining after 15 hours is",["1/2","1/4","1/8","1/16"],"C","Fifteen hours is three half-lives, so the fraction is (1/2)³=1/8.",["This is one half-life.","This is two half-lives.","Correct.","This is four half-lives."]),
  m(2,2,"Very Hard","For h(x)=ln(x²−4), the domain is",["x>2","x<−2","−2<x<2","x<−2 or x>2"],"D","The logarithm requires x²−4>0, which holds outside [−2,2].",["This omits the negative branch.","This omits the positive branch.","The logarithm's argument is negative there.","Correct."]),
  m(3,1,"Easy","Convert 150° to radians.",["5π/12","5π/6","3π/5","6π/5"],"B","Multiplying by π/180 gives 150π/180=5π/6.",["This corresponds to 75°.","Correct.","This reverses part of the conversion.","This corresponds to 216°."]),
  m(3,2,"Medium","A sinusoid has maximum 14, minimum 6, and period 8. Its amplitude and midline are",["4 and y=10","8 and y=10","4 and y=8","10 and y=4"],"A","Amplitude is half the range, 4, and the midline is the average, 10.",["Correct.","This uses the full range as amplitude.","The midline is not half the maximum.","The two quantities are interchanged."]),
  m(3,1,"Hard","On 0≤x<2π, the solutions to 2sin x=√3 are",["π/3 only","2π/3 only","π/3 and 2π/3","4π/3 and 5π/3"],"C","sin x=√3/2 is positive in Quadrants I and II.",["The second-quadrant solution is omitted.","The first-quadrant solution is omitted.","Correct.","Sine is negative at those angles."]),
  m(3,1,"Medium","If θ=arccos(−1/2), using the principal range of arccos, then θ=",["π/3","2π/3","4π/3","5π/3"],"B","The principal arccos range is [0,π], and cosine is −1/2 at 2π/3 there.",["Cosine is positive at π/3.","Correct.","This angle lies outside the principal range.","This angle also lies outside the principal range."]),
  m(3,2,"Hard","The polar point (r,θ)=(−3,π/6) has Cartesian coordinates",["(3√3/2,3/2)","(−3√3/2,−3/2)","(−3√3/2,3/2)","(3/2,−3√3/2)"],"B","x=r cosθ=−3√3/2 and y=r sinθ=−3/2.",["This ignores the negative radius.","Correct.","Only one coordinate uses the negative radius.","The sine and cosine components are interchanged."]),
  m(3,3,"Medium","For the polar curve r=4sin θ, which description is correct?",["A circle of radius 2 centered at (0,2)","A circle of radius 4 centered at the origin","A circle of radius 2 centered at (2,0)","A line y=4"],"A","Multiplying by r gives x²+y²=4y, or x²+(y−2)²=4.",["Correct.","The polar equation is not r=4.","That center corresponds to a cosine form.","Completing the square produces a circle, not a line."]),
];

const frq: FrqSpec[] = [
  f(1,2,"Easy","function-concepts",true,"A polynomial f has values f(0)=4, f(1)=1, f(2)=0, and f(3)=1. A quadratic model is proposed.",[
    p("Find the average rate of change from x=0 to x=2.",d("The average rate is −2.",["(0−4)/(2−0)"],{expected:-2,tolerance:0}),d("The negative rate means f falls by 2 output units per input unit on average.",["falls","2","per input"])),
    p("Find a quadratic matching all four values.",d("The model is f(x)=(x−2)².",["(x−2)²"]),d("Substitution gives outputs 4,1,0,1 at x=0,1,2,3.",["f(0)=4","f(1)=1","f(2)=0","f(3)=1"])),
    p("Describe the vertex and symmetry in context of the table.",d("The vertex is (2,0), the minimum of the model.",["(2,0)","minimum"]),d("The axis x=2 explains equal values at inputs equally spaced from 2.",["axis x=2","equally spaced"])),
  ]),
  f(2,2,"Easy","function-concepts",true,"A function is modeled by E(t)=12(1.18)^t for t≥0.",[
    p("Identify the initial value and percent change per unit time.",d("The initial value is 12.",["E(0)=12"]),d("The quantity increases 18% per unit time.",["1.18","18% increase"])),
    p("Solve E(t)=30 and give a decimal approximation.",d("t=ln(30/12)/ln(1.18).",["ln(30/12)","ln(1.18)"]),d("The time is approximately 5.54 units.",["5.54"],{expected:5.536,tolerance:0.01})),
    p("Describe the inverse function and its domain.",d("E⁻¹(x)=ln(x/12)/ln(1.18).",["ln(x/12)","ln(1.18)"]),d("For the modeled range, the inverse domain is x≥12.",["x≥12","range of E"])),
  ]),
  f(3,2,"Medium","function-concepts",false,"Let T(θ)=3−2cos θ for 0≤θ≤2π.",[
    p("State the range and where each extreme occurs.",d("The range is [1,5].",["[1,5]"]),d("The minimum 1 occurs at θ=0,2π and maximum 5 at θ=π.",["minimum","0 or 2π","maximum","π"])),
    p("Solve T(θ)=4 on the stated interval.",d("The equation becomes cos θ=−1/2.",["cos θ=−1/2"]),d("The solutions are θ=2π/3 and 4π/3.",["2π/3","4π/3"])),
    p("Explain the transformation from y=cos θ.",d("Multiplying by −2 reflects across the horizontal axis and gives amplitude 2.",["reflection","amplitude 2"]),d("Adding 3 shifts the midline to y=3.",["shift up 3","midline y=3"])),
  ]),
  f(1,1,"Medium","function-concepts",false,"Define f(x)=3x−5 and g(x)=(x+5)/3.",[
    p("Verify algebraically that f and g are inverses.",d("f(g(x))=x.",["3((x+5)/3)−5=x"]),d("g(f(x))=x.",["(3x−5+5)/3=x"])),
    p("Find f(g(8)) and interpret the result.",d("f(g(8))=8.",["8"],{expected:8,tolerance:0}),d("An inverse composition returns the original input.",["original input","inverse"])),
    p("Compare the graphs of f and g.",d("Their graphs are reflections across y=x.",["reflection","y=x"]),d("The point (a,b) on f corresponds to (b,a) on g.",["coordinates reversed","(b,a)"])),
  ]),
  f(1,3,"Medium","nonperiodic-modeling",true,"A workshop's daily profit, in hundreds of dollars, is modeled by P(x)=−0.5x²+8x−18 for 2≤x≤14, where x is the number of batches produced.",[
    p("Find the production level that maximizes modeled profit.",d("The vertex occurs at x=8 batches.",["−b/(2a)","x=8"]),d("The negative leading coefficient confirms the vertex is a maximum.",["negative leading coefficient","maximum"])),
    p("Find and interpret the maximum profit.",d("P(8)=14 hundred dollars.",["P(8)=14"],{expected:14,tolerance:0}),d("The modeled maximum daily profit is $1,400.",["$1,400","daily profit"])),
    p("State one limitation of using the model at x=30.",d("x=30 lies outside the stated domain.",["outside","2≤x≤14"]),d("The quadratic's extrapolated decline is not supported by the observed production range.",["extrapolation","not supported"])),
  ]),
  f(1,2,"Hard","nonperiodic-modeling",true,"The concentration after mixing is modeled by C(t)=(18+2t)/(3+t), in milligrams per liter, for t≥0 minutes.",[
    p("Find C(0) and the horizontal limiting value.",d("C(0)=6 mg/L.",["6"],{expected:6,tolerance:0,unit:"mg/L"}),d("As t grows, C(t) approaches 2 mg/L from the ratio of leading coefficients.",["2","horizontal limit"])),
    p("Determine whether C is increasing or decreasing.",d("C′(t)=−12/(t+3)²<0.",["−12/(t+3)²","<0"]),d("Therefore concentration decreases for all t≥0.",["decreases","t≥0"])),
    p("Solve C(t)=3 and interpret.",d("The solution is t=9 minutes.",["18+2t=9+3t","t=9"],{expected:9,tolerance:0,unit:"minutes"}),d("At 9 minutes the modeled concentration reaches 3 mg/L.",["9 minutes","3 mg/L"])),
  ]),
  f(2,3,"Hard","nonperiodic-modeling",true,"A sensor's excess temperature above room level is D(t)=48(0.82)^t degrees Celsius after t minutes.",[
    p("Find D(5) and interpret it.",d("D(5)≈17.80°C.",["48(0.82)^5","17.80"],{expected:17.795,tolerance:0.02,unit:"degrees C"}),d("After 5 minutes the sensor is about 17.8°C above room temperature.",["above room","5 minutes"])),
    p("Find the time when the excess first falls below 10°C.",d("The boundary time solves t=ln(10/48)/ln(0.82)≈7.91.",["ln(10/48)","ln(0.82)","7.91"]),d("The model is below 10°C for t>7.91 minutes.",["t>7.91","below 10"])),
    p("Explain why a linear decrease of 18% of the original 48 each minute would be a different model.",d("Exponential decay removes 18% of the current amount each minute.",["current amount","18%"]),d("A linear model would subtract the same absolute temperature difference each minute.",["same absolute amount","linear"])),
  ]),
  f(2,2,"Very Hard","nonperiodic-modeling",true,"A model for signal strength is S(d)=72−18log₂(d+1) for distance d≥0 meters.",[
    p("Find S(3).",d("S(3)=36.",["log2(4)=2","36"],{expected:36,tolerance:0}),d("The modeled signal at 3 meters is 36 units.",["3 meters","36 units"])),
    p("Solve S(d)=18.",d("log₂(d+1)=3, so d=7.",["log2(d+1)=3","d=7"],{expected:7,tolerance:0,unit:"meters"}),d("The model reaches 18 units at 7 meters.",["18 units","7 meters"])),
    p("Determine the largest distance for which the model remains nonnegative.",d("S(d)≥0 implies log₂(d+1)≤4.",["log2(d+1)≤4"]),d("Thus 0≤d≤15 meters.",["d≤15","domain"])),
  ]),
  f(3,2,"Medium","periodic-modeling",true,"A greenhouse temperature has maximum 30°C at 3 p.m. and minimum 18°C at 3 a.m., repeating every 24 hours. Let t be hours after midnight.",[
    p("Find the amplitude and midline.",d("The amplitude is 6°C.",["(30−18)/2","6"]),d("The midline is 24°C.",["(30+18)/2","24"])),
    p("Write a cosine model with its maximum at t=15.",d("One model is T(t)=24+6cos((π/12)(t−15)).",["24+6cos","π/12","t−15"]),d("The coefficient π/12 gives period 24.",["2π/(π/12)=24"])),
    p("Find T(9) and interpret.",d("T(9)=24°C.",["cos(−π/2)=0","24"],{expected:24,tolerance:0,unit:"degrees C"}),d("At 9 a.m. the model is crossing its midline while warming.",["9 a.m.","midline","warming"])),
  ]),
  f(3,2,"Medium","periodic-modeling",true,"A wheel has radius 8 meters, center height 10 meters, and completes one revolution every 40 seconds. A rider starts at the lowest point at t=0.",[
    p("Write a height model.",d("A model is h(t)=10−8cos(πt/20).",["10−8cos","π/20"]),d("It starts at 2 meters and has period 40 seconds.",["h(0)=2","period 40"])),
    p("Find the first time the rider reaches height 14 meters.",d("cos(πt/20)=−1/2.",["cos","−1/2"]),d("The first time is t=40/3 seconds.",["40/3"],{expected:13.3333,tolerance:0.01,unit:"seconds"})),
    p("State the rider's maximum and minimum heights.",d("The minimum is 2 meters.",["2 meters"]),d("The maximum is 18 meters.",["18 meters"])),
  ]),
  f(3,3,"Hard","periodic-modeling",false,"A tidal depth is modeled by H(t)=5+1.8sin((π/6)t), where t is hours after noon and 0≤t≤12.",[
    p("State the period and range.",d("The period is 12 hours.",["2π/(π/6)","12"]),d("The range is [3.2,6.8] meters.",["5−1.8","5+1.8"])),
    p("Find all times when H(t)=5.9.",d("The equation is sin((π/6)t)=1/2.",["sin","1/2"]),d("The times are t=1 and t=5 hours.",["t=1","t=5"])),
    p("Determine whether the depth is rising or falling at t=5 without calculus.",d("The angle is 5π/6, on the descending side after the sine maximum at π/2.",["5π/6","after maximum"]),d("Therefore the depth is falling at t=5.",["falling"])),
  ]),
  f(3,2,"Very Hard","periodic-modeling",false,"A rotating scanner records radial distance r=3+2cos(2θ) for 0≤θ≤2π.",[
    p("State the period in θ and the range of r.",d("The period is π.",["2π/2","π"]),d("The radius ranges from 1 to 5.",["1","5"])),
    p("Find all θ where r=4.",d("cos(2θ)=1/2.",["cos(2θ)=1/2"]),d("θ=π/6,5π/6,7π/6,11π/6.",["π/6","5π/6","7π/6","11π/6"])),
    p("Compare the points at θ and θ+π.",d("The radii are equal because cos(2(θ+π))=cos(2θ).",["equal radii","period π"]),d("The angles differ by π, so the corresponding Cartesian points are opposites across the origin.",["opposite","origin"])),
  ]),
  f(1,1,"Easy","symbolic-manipulation",false,"Work with P(x)=x³−4x²−x+4.",[
    p("Factor P completely.",d("Grouping gives P(x)=(x−4)(x−1)(x+1).",["grouping","(x−4)(x−1)(x+1)"]),d("The zeros are −1,1,4.",["−1","1","4"])),
    p("Solve P(x)≥0.",d("A sign chart changes sign at each simple zero.",["sign chart","simple zeros"]),d("The solution is [−1,1]∪[4,∞).",["[−1,1]","[4,∞)"])),
    p("State the y-intercept and end behavior.",d("The y-intercept is (0,4).",["(0,4)"]),d("The positive odd leading term gives left down and right up.",["left down","right up"])),
  ]),
  f(2,1,"Hard","symbolic-manipulation",false,"Solve and analyze 3^(x+1)=7^(2x−1).",[
    p("Solve exactly for x.",d("Taking logarithms gives (x+1)ln3=(2x−1)ln7.",["(x+1)ln3","(2x−1)ln7"]),d("x=−(ln3+ln7)/(ln3−2ln7).",["−(ln3+ln7)/(ln3−2ln7)"])),
    p("Give a decimal approximation.",d("x≈1.090.",["1.090"],{expected:1.09,tolerance:0.002}),d("Substitution makes the two positive exponential expressions approximately equal.",["substitution","equal"])),
    p("Explain why there is at most one solution.",d("The logarithmic equation is linear in x.",["linear in x"]),d("Its coefficient ln3−2ln7 is nonzero, so it has one solution.",["nonzero coefficient","one solution"])),
  ]),
  f(3,1,"Hard","symbolic-manipulation",false,"Solve 2cos²x−3cos x+1=0 for 0≤x<2π.",[
    p("Factor the equation in cos x.",d("(2cos x−1)(cos x−1)=0.",["(2cos x−1)","(cos x−1)"]),d("Thus cos x=1/2 or cos x=1.",["cos x=1/2","cos x=1"])),
    p("List all solutions in the interval.",d("cos x=1 gives x=0.",["x=0"]),d("cos x=1/2 gives x=π/3 and 5π/3.",["π/3","5π/3"])),
    p("Verify the solutions without introducing extras.",d("Substitution makes the original expression zero for all three values.",["substitution","zero"]),d("No squaring or inverse operation introduced extraneous solutions.",["no extraneous","factoring"])),
  ]),
  f(3,2,"Medium","symbolic-manipulation",false,"A polar curve is r=6cos θ.",[
    p("Convert the equation to Cartesian form.",d("Multiplying by r gives r²=6r cos θ.",["r²=6r cos θ"]),d("Thus x²+y²=6x.",["x²+y²=6x"])),
    p("Write the Cartesian equation in center-radius form.",d("Completing the square gives (x−3)²+y²=9.",["(x−3)²+y²=9"]),d("The graph is a circle centered at (3,0) with radius 3.",["center (3,0)","radius 3"])),
    p("Explain why negative r values are not needed to trace this circle once.",d("For cos θ<0 the formula produces negative r, which maps to the opposite direction.",["negative r","opposite direction"]),d("Restricting to −π/2≤θ≤π/2 traces the circle with r≥0.",["−π/2≤θ≤π/2","r≥0"])),
  ]),
];

export const precalculus: SubjectSpec = {
  key:"ap-precalculus",name:"AP Precalculus",examCode:"ap_precalculus",examDate:"2026-05-12",prefix:"apprecalc",
  factPackPath:"docs/product/AP_PRECALCULUS_FACT_PACK.md",factPackSourceKey:"ap-precalculus-public-fact-pack",
  units:[[1,"Polynomial and Rational Functions",.30,.40],[2,"Exponential and Logarithmic Functions",.25,.40],[3,"Trigonometric and Polar Functions",.30,.35]],
  practices:["Algebraic Manipulation","Connecting Representations","Communication and Rationale"],
  archetypes:[{key:"function-concepts",label:"Function Concepts",examTarget:1},{key:"nonperiodic-modeling",label:"Modeling a Nonperiodic Context",examTarget:1},{key:"periodic-modeling",label:"Modeling a Periodic Context",examTarget:1},{key:"symbolic-manipulation",label:"Symbolic Manipulation",examTarget:1}],
  mcq,frq,mcqMinutes:105,frqMinutes:70,frqExamCount:4,
};
