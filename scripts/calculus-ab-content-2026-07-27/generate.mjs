import { createHash } from "node:crypto";
import { mkdir, writeFile } from "node:fs/promises";

const ROOT = new URL("../../", import.meta.url).pathname;
const OUT = `${ROOT}content/item-packages/ap-calculus-ab`;
const PACKET = `${ROOT}docs/teaching/AP_CALCULUS_AB_PRACTICE_PACKET_2026_07_27.md`;
const GENERATED_AT = "2026-07-27T00:00:00Z";
const SOURCE_REF = "ap-calculus-ab-bc-ced-effective-fall-2020-2026-release";
const ORIGINALITY = "Independently authored Cramapple practice item from a blank scope brief; no released, secure, or third-party question or scoring language was used.";
const sha = value => createHash("sha256").update(value).digest("hex");

const mcq = [
  {topic:"1.6",unit:1,practice:1,difficulty:"Easy",mode:"no-calculator",stem:"What is lim(x→2) (x²−4)/(x−2)?",choices:["4","2","0","The limit does not exist"],key:"A",proof:"For x≠2, (x²−4)/(x−2)=x+2, so the limit is 4.",r:["Correctly factors, cancels, and evaluates the resulting expression.","Substitutes 2 into only one surviving term.","Treats the zero numerator as determining the limit.","Confuses an undefined function value with a nonexistent limit."]},
  {topic:"1.11",unit:1,practice:1,difficulty:"Medium",mode:"no-calculator",stem:"Let f(x)=kx+1 for x<2 and f(x)=x²−1 for x≥2. For what value of k is f continuous at x=2?",choices:["0","1","3/2","2"],key:"B",proof:"Continuity requires 2k+1=2²−1=3, so k=1.",r:["Sets the left-hand expression equal to 1 instead of the function value at 2.","Correctly equates the one-sided limit and function value.","Divides the right-side value by 2 without subtracting 1.","Uses the input value as the parameter."]},
  {topic:"1.16",unit:1,practice:2,difficulty:"Medium",mode:"no-calculator",stem:"A function f is continuous on [1,4], with f(1)=−2 and f(4)=5. Which conclusion is guaranteed?",choices:["f has an absolute minimum at x=1.","There is a c in (1,4) with f′(c)=7/3.","There is a c in (1,4) with f(c)=0.","f is increasing on [1,4]."],key:"C",proof:"Because 0 lies between −2 and 5, the Intermediate Value Theorem guarantees f(c)=0 for some c in (1,4).",r:["Continuity guarantees extrema but not that the left endpoint is the minimum.","The Mean Value Theorem also requires differentiability, which is not given.","Correctly applies the Intermediate Value Theorem.","Endpoint values alone do not establish monotonicity."]},
  {topic:"1.15",unit:1,practice:1,difficulty:"Easy",mode:"no-calculator",stem:"What is lim(x→∞) (5x²−x+4)/(2x²+3)?",choices:["0.0","0.4","2.0","2.5"],key:"D",proof:"The numerator and denominator have equal degree, so the limit is the ratio 5/2=2.5 of leading coefficients.",r:["Incorrectly applies the rule for a lower-degree numerator.","Reverses the ratio of the leading coefficients.","Uses the denominator's degree as the limit.","Correctly compares the leading terms."]},
  {topic:"2.2",unit:2,practice:1,difficulty:"Medium",mode:"no-calculator",stem:"Which expression equals f′(3)?",choices:["lim(h→0) [f(3+h)−f(3)]/h","lim(h→0) [f(3+h)−f(h)]/3","lim(x→3) [f(x)−f(3)]/3","lim(x→0) [f(3+x)−f(3)]/3"],key:"A",proof:"The derivative at a is lim(h→0)[f(a+h)−f(a)]/h; set a=3.",r:["Correctly instantiates the derivative definition at x=3.","Uses inconsistent base inputs and divides by the fixed point.","Divides by the point rather than the input change.","Keeps a fixed denominator instead of the increment."]},
  {topic:"2.8",unit:2,practice:1,difficulty:"Easy",mode:"no-calculator",stem:"If f(x)=x²e^x, what is f′(1)?",choices:["e","3e","e²","2+e"],key:"B",proof:"f′(x)=2xe^x+x²e^x, so f′(1)=3e.",r:["Differentiates only the polynomial factor.","Correctly applies the product rule and evaluates.","Confuses evaluation at 1 with squaring e.","Adds derivatives without preserving the product factors."]},
  {topic:"2.10",unit:2,practice:1,difficulty:"Hard",mode:"no-calculator",stem:"What is d/dx[sec x tan x]?",choices:["sec x(sec²x+tan x)","sec x(tan²x−sec²x)","sec x(tan²x+sec²x)","tan x(sec²x+tan²x)"],key:"C",proof:"The product rule gives (sec x tan x)tan x+sec x(sec²x)=sec x(tan²x+sec²x).",r:["Combines derivative pieces but omits one tangent factor.","Subtracts the product-rule terms instead of adding.","Correctly applies the product rule to both trigonometric factors.","Uses tangent rather than secant as the common factor."]},
  {topic:"2.4",unit:2,practice:2,difficulty:"Medium",mode:"no-calculator",stem:"Which statement is always true?",choices:["Every continuous function is differentiable.","A function with a derivative of 0 at x=a has a local extremum there.","A function can be differentiable where it is discontinuous.","If a function is differentiable at x=a, then it is continuous there."],key:"D",proof:"Differentiability at a point implies continuity at that point.",r:["A corner can be continuous but not differentiable.","A horizontal tangent need not be an extremum.","Differentiability cannot occur at a discontinuity.","Correctly states the differentiability-continuity implication."]},
  {topic:"3.1",unit:3,practice:1,difficulty:"Easy",mode:"no-calculator",stem:"If f(x)=sin(x²), what is f′(x)?",choices:["2x cos(x²)","cos(2x)","2x sin(x²)","cos(x²)"],key:"A",proof:"The chain rule gives cos(x²)·2x.",r:["Correctly applies the chain rule.","Moves the inner derivative inside the cosine.","Uses the original outer function instead of its derivative.","Omits the inner derivative."]},
  {topic:"3.2",unit:3,practice:1,difficulty:"Medium",mode:"no-calculator",stem:"For the curve x²+y²=25, what is dy/dx at (3,4)?",choices:["−4/3","−3/4","3/4","4/3"],key:"B",proof:"Implicit differentiation gives 2x+2yy′=0, so y′=−x/y=−3/4.",r:["Uses the negative reciprocal of the correct slope.","Correctly differentiates implicitly and substitutes.","Drops the negative sign.","Interchanges x and y and drops the sign."]},
  {topic:"4.2",unit:4,practice:1,difficulty:"Hard",mode:"calculator",stem:"A particle has position s(t)=t³−4.7t²+2.1t+6 meters. What is its velocity at t=2.35 seconds, to the nearest hundredth?",choices:["−5.34 m/s","−3.81 m/s","−3.42 m/s","2.35 m/s"],key:"C",proof:"v(t)=3t²−9.4t+2.1, and v(2.35)=−3.4225≈−3.42 meters per second.",r:["Evaluates the derivative with an incorrect linear coefficient.","Evaluates the position rather than the velocity.","Correctly differentiates and evaluates with units.","Reports the time as though it were a velocity."]},
  {topic:"4.5",unit:4,practice:1,difficulty:"Medium",mode:"calculator",stem:"The radius of a circular stain is increasing at 0.37 centimeter per minute. When the radius is 5.2 centimeters, how fast is its area increasing, to the nearest tenth?",choices:["1.9 cm²/min","3.8 cm²/min","10.1 cm²/min","12.1 cm²/min"],key:"D",proof:"dA/dt=2πr·dr/dt=2π(5.2)(0.37)≈12.1 square centimeters per minute.",r:["Multiplies the two rates but omits the circumference factor.","Uses πr(dr/dt) and misses a factor of 2.","Uses πr²(dr/dt), which differentiates incorrectly.","Correctly differentiates A=πr² and evaluates."]},
  {topic:"4.6",unit:4,practice:2,difficulty:"Medium",mode:"no-calculator",stem:"Using the linearization of f(x)=√x at x=4, which approximation is obtained for √4.1?",choices:["2.025","2.050","2.100","2.200"],key:"A",proof:"L(x)=2+(1/4)(x−4), so L(4.1)=2.025.",r:["Correctly uses f′(4)=1/4 in the tangent-line approximation.","Uses a slope of 1/2 instead of 1/4.","Adds the entire input change to the output.","Uses an unrelated slope of 2."]},
  {topic:"4.7",unit:4,practice:1,difficulty:"Easy",mode:"no-calculator",stem:"What is lim(x→0) (e^(2x)−1)/x?",choices:["0","2","e²","The limit does not exist"],key:"B",proof:"L'Hospital's Rule gives lim(x→0)2e^(2x)=2.",r:["Substitutes before resolving the indeterminate form.","Correctly differentiates numerator and denominator.","Confuses the exponent coefficient with exponentiation.","Treats the removable 0/0 form as nonexistence."]},
  {topic:"5.2",unit:5,practice:1,difficulty:"Easy",mode:"no-calculator",stem:"What are the critical numbers of f(x)=x³−3x?",choices:["0 only","3 only","−1 and 1","−3 and 3"],key:"C",proof:"f′(x)=3x²−3=3(x−1)(x+1), so the critical numbers are −1 and 1.",r:["Uses the midpoint of the two derivative zeros.","Uses a coefficient from the original function.","Correctly solves f′(x)=0.","Solves x²=9 instead of x²=1."]},
  {topic:"5.1",unit:5,practice:1,difficulty:"Medium",mode:"no-calculator",stem:"For f(x)=x² on [1,3], the Mean Value Theorem guarantees a c in (1,3) with f′(c) equal to the average rate of change. What is c?",choices:["1","3/2","3","2"],key:"D",proof:"The average rate is (9−1)/(3−1)=4. Since f′(x)=2x, c=2.",r:["Uses the left endpoint instead of an interior MVT value.","Uses the midpoint of the output values incorrectly.","Uses the right endpoint instead of an interior MVT value.","Correctly equates the derivative to the secant slope."]},
  {topic:"5.4",unit:5,practice:2,difficulty:"Hard",mode:"calculator",stem:"A differentiable function has f′(x)=x³−3.2x²−1.1x+2.4 on −2≤x≤4. At which x-value does f have a local maximum, to the nearest thousandth?",choices:["−0.910","0.796","1.000","3.313"],key:"A",proof:"The derivative zeros are approximately −0.910, 0.796, and 3.313; f′ changes from positive to negative at x≈−0.910.",r:["Correctly identifies the positive-to-negative derivative sign change.","Selects a negative-to-positive sign change, which gives a local minimum.","Uses a convenient input that is not a derivative zero.","Selects another negative-to-positive sign change."]},
  {topic:"5.6",unit:5,practice:1,difficulty:"Easy",mode:"no-calculator",stem:"If f″(x)=6x−12, on which interval is f concave up?",choices:["x<0","x>2","x<2","0<x<2"],key:"B",proof:"Concavity is upward where f″(x)>0, so 6x−12>0 and x>2.",r:["Uses the sign of x rather than the second derivative.","Correctly solves the second-derivative inequality.","Reverses the inequality.","Restricts the solution without justification."]},
  {topic:"5.11",unit:5,practice:1,difficulty:"Medium",mode:"no-calculator",stem:"A rectangle has perimeter 20. What is its greatest possible area?",choices:["20","24","25","40"],key:"C",proof:"If the sides are x and 10−x, area x(10−x) is maximized at x=5, giving 25.",r:["Uses the perimeter as the area.","Uses unequal side lengths without maximizing.","Correctly identifies the square as optimal.","Multiplies the full perimeter by a side."]},
  {topic:"6.2",unit:6,practice:2,difficulty:"Medium",mode:"calculator",stem:"Values of f are shown: x=0, 0.7, 1.9, 3.0 and f(x)=2.1, 2.8, 1.6, 3.4. What is the right Riemann-sum approximation for ∫₀³ f(x)dx?",choices:["6.20","7.56","8.04","7.62"],key:"D",proof:"The right sum is 0.7(2.8)+1.2(1.6)+1.1(3.4)=7.62.",r:["Uses incorrect interval widths.","Treats the table as equally spaced.","Uses left rather than right endpoint values.","Correctly uses each nonuniform width and right endpoint."]},
  {topic:"6.4",unit:6,practice:1,difficulty:"Medium",mode:"no-calculator",stem:"If F(x)=∫₁^(x²) √(1+t³) dt, what is F′(x)?",choices:["2x√(1+x⁶)","√(1+x⁶)","2x√(1+x³)","x²√(1+x⁶)"],key:"A",proof:"The Fundamental Theorem and chain rule give F′(x)=√(1+(x²)³)·2x.",r:["Correctly combines the Fundamental Theorem with the chain rule.","Omits the derivative of the upper limit.","Uses x rather than x² inside the integrand substitution.","Uses the upper limit itself instead of its derivative."]},
  {topic:"6.6",unit:6,practice:3,difficulty:"Easy",mode:"no-calculator",stem:"If f is odd and integrable on [−3,3], what is ∫₋₃³ f(x)dx?",choices:["−6","0","3","6"],key:"B",proof:"The signed areas of an odd function over a symmetric interval cancel.",r:["Uses the interval length with a negative sign.","Correctly applies odd-function symmetry.","Uses one endpoint as the integral.","Uses the full interval length as the integral."]},
  {topic:"6.9",unit:6,practice:1,difficulty:"Easy",mode:"no-calculator",stem:"Which is an antiderivative of 2x cos(x²)?",choices:["2sin(x²)","x²sin(x²)","sin(x²)","cos(x²)"],key:"C",proof:"With u=x² and du=2x dx, the integral is sin(x²)+C.",r:["Introduces an extra factor of 2.","Multiplies by the inner function instead of substituting.","Correctly recognizes the chain-rule reversal.","Differentiating this choice gives −2x sin(x²)."]},
  {topic:"6.5",unit:6,practice:3,difficulty:"Hard",mode:"calculator",stem:"Let f(x)=e^(−x²). What is the average value of f on [0,1.6], to the nearest thousandth?",choices:["0.338","0.866","0.676","0.541"],key:"D",proof:"The average value is (1/1.6)∫₀^1.6 e^(−x²)dx≈0.541.",r:["Divides an endpoint-scale estimate by the interval incorrectly.","Uses the left endpoint as though the function were constant.","Uses an inaccurate midpoint-style estimate.","Correctly divides the numerical integral by the interval length."]},
  {topic:"7.5",unit:7,practice:2,difficulty:"Medium",mode:"no-calculator",stem:"Use Euler's method with step size 0.5 to estimate y(1) for y′=x+y and y(0)=1.",choices:["2.5","2.0","1.75","1.5"],key:"A",proof:"y(0.5)=1+0.5(1)=1.5 and y(1)=1.5+0.5(0.5+1.5)=2.5.",r:["Correctly performs both Euler steps.","Uses only one full-size slope update.","Uses the initial slope for both steps.","Stops after the first half-step."]},
  {topic:"7.9",unit:7,practice:3,difficulty:"Medium",mode:"calculator",stem:"A population follows dP/dt=0.18P(1−P/900). At what population is the instantaneous growth rate greatest?",choices:["225","450","720","900"],key:"B",proof:"The logistic growth rate as a function of P is a downward-opening quadratic with maximum at half the carrying capacity, P=450.",r:["Uses one quarter of the carrying capacity.","Correctly identifies half the carrying capacity.","Uses four fifths of carrying capacity.","Uses the carrying capacity, where growth is zero."]},
  {topic:"8.4",unit:8,practice:1,difficulty:"Easy",mode:"no-calculator",stem:"What is the area between y=x and y=x² on 0≤x≤1?",choices:["1/3","1/4","1/6","1/2"],key:"C",proof:"The area is ∫₀¹(x−x²)dx=1/2−1/3=1/6.",r:["Integrates only the quadratic term.","Subtracts endpoint values rather than integrating.","Correctly integrates top minus bottom.","Adds the two elementary areas."]},
  {topic:"8.9",unit:8,practice:3,difficulty:"calculator",mode:"calculator",stem:"The region bounded by y=e^(−x²), the x-axis, x=0, and x=1.3 is revolved about the x-axis. What is its volume, to the nearest thousandth?",choices:["1.114","1.548","2.073","1.951"],key:"D",proof:"The disk-method volume is π∫₀^1.3 e^(−2x²)dx≈1.951.",r:["Omits the factor of π or squares incorrectly.","Integrates the unsquared radius.","Uses a rectangular approximation.","Correctly squares the radius and evaluates the numerical integral."]},
  {topic:"8.3",unit:8,practice:2,difficulty:"Medium",mode:"calculator",stem:"A particle's velocity is v(t)=sin(t²)+0.5 meters per second. What is its displacement from t=0 to t=2.2, to the nearest thousandth?",choices:["1.719 m","0.619 m","2.819 m","3.008 m"],key:"A",proof:"Displacement is ∫₀^2.2[sin(t²)+0.5]dt≈1.719 meters.",r:["Correctly evaluates the signed velocity integral.","Omits the constant contribution.","Adds the constant contribution twice.","Uses speed or endpoint velocity instead of displacement."]},
  {topic:"8.13",unit:8,practice:3,difficulty:"Hard",mode:"calculator",stem:"What is the length of y=x² from x=0 to x=1.4, to the nearest thousandth?",choices:["2.800","2.520","1.960","1.400"],key:"B",proof:"Arc length is ∫₀^1.4√(1+4x²)dx≈2.520.",r:["Uses an overlarge linear estimate.","Correctly evaluates the arc-length integral.","Uses the vertical change as the length.","Uses only the horizontal interval length."]}
];

const frq = [
  {unit:4,topic:"4.3",practice:2,difficulty:"Hard",mode:"calculator",archetype:"contextual-rate-accumulation",stimulus:"A tank initially contains 80 liters of water. For 0≤t≤6 minutes, water enters at I(t)=12+3sin(t²/8) liters per minute and leaves at O(t)=4+0.5t² liters per minute.",parts:[
    ["(a)","Find the net rate of change of the amount of water at t=2. Interpret the value with units.",["I(2)−O(2)≈7.438 liters per minute.","The amount of water is increasing at that instant.","The response distinguishes amount from its rate of change."]],
    ["(b)","Find the net change in the amount of water during the six minutes.",["Uses ∫₀⁶[I(t)−O(t)]dt.","The net change is approximately 17.918 liters."]],
    ["(c)","At what time is the amount of water greatest? Justify using candidate times and the sign of the net rate.",["Solves I(t)=O(t) to obtain t≈4.443.","The net rate changes from positive to negative there.","Compares the interior candidate with t=0 and t=6.","Concludes the maximum amount is approximately 107.953 liters at t≈4.443."]]
  ]},
  {unit:4,topic:"4.2",practice:1,difficulty:"Hard",mode:"calculator",archetype:"particle-motion",stimulus:"A particle moves on a horizontal line with velocity v(t)=t³−5t²+4t+1 for 0≤t≤5, where position is measured in meters and time in seconds.",parts:[
    ["(a)","Find all times in the interval when the particle changes direction.",["Solves v(t)=0 and obtains t≈1.286 and t≈3.912.","Verifies a sign change at each reported zero."]],
    ["(b)","Find the displacement of the particle from t=0 to t=5.",["Uses the signed integral ∫₀⁵v(t)dt.","The displacement is 35/12≈2.917 meters."]],
    ["(c)","Find the total distance traveled from t=0 to t=5.",["Splits the interval at both velocity zeros.","Integrates |v(t)| or sums absolute signed displacements.","Obtains approximately 19.802 meters."]],
    ["(d)","Find the time when the velocity has its absolute minimum, and justify.",["Uses a(t)=v′(t)=3t²−10t+4.","Identifies t≈2.869 as the minimum-velocity candidate and compares endpoints/other candidate."]]
  ]},
  {unit:5,topic:"5.4",practice:3,difficulty:"Hard",mode:"calculator",archetype:"derivative-defined-function",stimulus:"A differentiable function f satisfies f(0)=2 and f′(x)=e^(−x/2)(x²−5x+3) on 0≤x≤6.",parts:[
    ["(a)","Find the intervals on which f is increasing.",["Finds critical numbers x≈0.697 and x≈4.303.","Concludes f increases on (0,0.697) and (4.303,6)."]],
    ["(b)","Find the absolute maximum and absolute minimum values of f on the interval.",["Evaluates f at both endpoints and both critical numbers using f(x)=2+∫₀ˣf′(t)dt.","Finds the absolute maximum f(0.697)≈2.887.","Finds the absolute minimum f(4.303)≈0.461."]],
    ["(c)","Find the x-coordinate of the inflection point of f and justify the change in concavity.",["Computes or analyzes f″(x)=e^(−x/2)(−0.5x²+4.5x−6.5).","Obtains x≈1.807.","Shows f″ changes sign at the reported value." ]],
    ["(d)","Write the equation of the tangent line to f at x=0.",["Uses f(0)=2 and f′(0)=3 to obtain y=2+3x."]]
  ]},
  {unit:6,topic:"6.4",practice:1,difficulty:"Hard",mode:"calculator",archetype:"accumulation-function",stimulus:"For 0≤x≤2, define g(x)=∫₀ˣ√(1+t⁴)dt.",parts:[
    ["(a)","Find g(2) to three decimal places.",["Uses numerical integration on the stated integral.","Obtains g(2)≈3.653."]],
    ["(b)","Write the equation of the tangent line to g at x=1.",["Finds g(1)≈1.089.","Uses g′(1)=√2.","Writes y−1.089=√2(x−1) or an equivalent line."]],
    ["(c)","Determine the concavity of g on (0,2) and justify.",["Finds g″(x)=2x³/√(1+x⁴).","Concludes g is concave up because g″(x)>0 on (0,2)."]],
    ["(d)","Solve g(x)=3 to three decimal places.",["Uses a numerical zero or intersection method.","Obtains x≈1.828."]]
  ]},
  {unit:7,topic:"7.9",practice:2,difficulty:"Hard",mode:"calculator",archetype:"logistic-model",stimulus:"A fish population P(t) follows dP/dt=0.3P(1−P/500), with P(0)=80, where t is measured in years.",parts:[
    ["(a)","Find dP/dt at t=0 and interpret it.",["Computes P′(0)=20.16 fish per year.","States that the population is initially increasing at about 20.16 fish per year."]],
    ["(b)","Find the particular solution P(t).",["Uses the logistic form P=500/(1+Ae^(−0.3t)).","Uses P(0)=80 to obtain A=5.25.","States P(t)=500/(1+5.25e^(−0.3t))."]],
    ["(c)","Find P(10) and P′(10), each to three decimal places.",["Obtains P(10)≈396.391 fish.","Obtains P′(10)≈24.642 fish per year."]],
    ["(d)","When is the population growing most rapidly? Justify.",["Uses the logistic inflection condition P=250.","Solves to obtain t=ln(5.25)/0.3≈5.527 years."]]
  ]},
  {unit:8,topic:"8.4",practice:1,difficulty:"Hard",mode:"calculator",archetype:"area-volume",stimulus:"Let R be the region in the first quadrant bounded by y=√x and y=x²/4.",parts:[
    ["(a)","Find the nonzero x-coordinate where the curves intersect.",["Solves √x=x²/4 for x>0.","Obtains x=4^(2/3)≈2.520."]],
    ["(b)","Find the area of R.",["Uses ∫₀^(4^(2/3))(√x−x²/4)dx.","Obtains area 4/3 square units."]],
    ["(c)","Find the volume when R is revolved about the x-axis.",["Uses π∫₀^(4^(2/3))(x−x⁴/16)dx.","Obtains approximately 5.984 cubic units."]],
    ["(d)","Find the volume of a solid whose base is R and whose cross sections perpendicular to the x-axis are squares.",["Uses √x−x²/4 as the square side length.","Uses ∫₀^(4^(2/3))(√x−x²/4)²dx.","Obtains approximately 0.816 cubic units."]]
  ]},
  {unit:2,topic:"2.8",practice:1,difficulty:"Hard",mode:"calculator",archetype:"transcendental-function-analysis",stimulus:"For 0≤x≤5, let f(x)=xe^(−x²/4).",parts:[
    ["(a)","Find the absolute maximum value of f and where it occurs.",["Solves f′(x)=e^(−x²/4)(1−x²/2)=0.","Obtains x=√2≈1.414 and f(√2)≈0.858.","Compares the critical value with both endpoints."]],
    ["(b)","Solve f(x)=0.5 on the interval.",["Uses a numerical solver or graph.","Obtains x≈0.537 and x≈2.554."]],
    ["(c)","Find the average value of f on [0,5].",["Uses (1/5)∫₀⁵xe^(−x²/4)dx.","Obtains approximately 0.399."]],
    ["(d)","Find the x-coordinate of the inflection point in (0,5) and justify.",["Finds f″(x)=xe^(−x²/4)(x²−6)/4.","Obtains x=√6≈2.449 and verifies a concavity change."]]
  ]},
  {unit:1,topic:"1.11",practice:3,difficulty:"Medium",mode:"no-calculator",archetype:"continuity-differentiability",stimulus:"Define f(x)=(x²−1)/(x−1) for x≠1 and f(1)=k.",parts:[
    ["(a)","Find lim(x→1)f(x) and the value of k that makes f continuous.",["Simplifies f(x)=x+1 for x≠1.","Finds the limit is 2.","Sets k=2 for continuity."]],
    ["(b)","For the continuous choice of k, determine whether f is differentiable at x=1.",["Uses the difference quotient or the simplified linear function.","Finds f′(1)=1.","Concludes f is differentiable at x=1."]],
    ["(c)","Explain why f(x)=5/2 has a solution in (1,2), and find that solution.",["Cites continuity on [1,2].","Uses f(1)=2 and f(2)=3 to apply the Intermediate Value Theorem.","Solves x+1=5/2 to obtain x=3/2."]]
  ]},
  {unit:1,topic:"1.8",practice:3,difficulty:"Medium",mode:"no-calculator",archetype:"limits-theorems",stimulus:"Answer each limit or theorem question and show supporting work.",parts:[
    ["(a)","Evaluate lim(x→0) sin(5x)/x.",["Rewrites the expression as 5·sin(5x)/(5x).","Obtains the limit 5."]],
    ["(b)","Evaluate lim(x→∞) (3x²−x)/√(9x⁴+1).",["Divides numerator and denominator by x².","Uses x²>0 as x→∞ and obtains 1."]],
    ["(c)","Use the Squeeze Theorem to evaluate lim(x→0)x²cos(1/x).",["States −x²≤x²cos(1/x)≤x².","Notes both bounds approach 0 and concludes the limit is 0."]],
    ["(d)","Show that p(x)=x³+x−1 has a zero in (0,1).",["States p is continuous on [0,1].","Computes p(0)=−1 and p(1)=1.","Applies the Intermediate Value Theorem to conclude a zero exists in (0,1)."]]
  ]},
  {unit:2,topic:"2.8",practice:1,difficulty:"Hard",mode:"no-calculator",archetype:"derivatives-from-table",stimulus:"Differentiable functions f and g satisfy f(2)=3, f′(2)=−1, g(2)=4, and g′(2)=2. Also, f is one-to-one near x=2.",parts:[
    ["(a)","Find d/dx[f(x)g(x)] at x=2.",["Uses the product rule.","Obtains (−1)(4)+(3)(2)=2."]],
    ["(b)","Find (f⁻¹)′(3).",["Uses (f⁻¹)′(3)=1/f′(2).","Obtains −1."]],
    ["(c)","Find d/dx[f(g(x))] at x=2 if f′(4)=5.",["Uses the chain rule f′(g(2))g′(2).","Obtains 5·2=10."]],
    ["(d)","Write the tangent line to h(x)=f(x)/g(x) at x=2.",["Finds h(2)=3/4.","Uses the quotient rule to find h′(2)=−5/8.","Writes y−3/4=−5/8(x−2)."]]
  ]},
  {unit:2,topic:"2.9",practice:1,difficulty:"Medium",mode:"no-calculator",archetype:"analytic-derivatives",stimulus:"Let h(x)=x²ln x for x>0.",parts:[
    ["(a)","Find h′(x) and h″(x).",["Finds h′(x)=2xln x+x.","Finds h″(x)=2ln x+3.","Uses the product rule correctly."]],
    ["(b)","Write the tangent line to h at x=1.",["Finds h(1)=0.","Finds h′(1)=1.","Writes y=x−1."]],
    ["(c)","Find the x-coordinate of the inflection point and justify.",["Solves 2ln x+3=0 to get x=e^(−3/2).","Shows h″ changes from negative to positive there.","Concludes the point is an inflection point."]]
  ]},
  {unit:3,topic:"3.2",practice:1,difficulty:"Hard",mode:"no-calculator",archetype:"implicit-inverse",stimulus:"The curve x²+xy+y²=7 contains the point (1,2).",parts:[
    ["(a)","Find dy/dx at (1,2).",["Differentiates to obtain 2x+y+(x+2y)y′=0.","Obtains y′=−4/5."]],
    ["(b)","Find d²y/dx² at (1,2).",["Differentiates the first-derivative relation again.","Uses 2+2y′+2(y′)²+(x+2y)y″=0.","Obtains y″=−42/125."]],
    ["(c)","Find dx/dy at (1,2) and explain why it exists locally.",["Uses the reciprocal derivative to obtain dx/dy=−5/4.","Notes dy/dx is nonzero at the point."]],
    ["(d)","Write the normal line to the curve at (1,2).",["Uses normal slope 5/4.","Writes y−2=(5/4)(x−1)."]]
  ]},
  {unit:4,topic:"4.5",practice:4,difficulty:"Medium",mode:"no-calculator",archetype:"related-rates-linearization",stimulus:"Water fills an inverted conical tank whose height is always three times the radius of its water surface. The water volume increases at 6π cubic feet per minute.",parts:[
    ["(a)","When the water radius is 2 feet, find dr/dt.",["Uses V=(1/3)πr²h=πr³.","Differentiates to obtain dV/dt=3πr²dr/dt.","Obtains dr/dt=1/2 foot per minute."]],
    ["(b)","At the same instant, find dh/dt and state units.",["Uses h=3r and dh/dt=3dr/dt.","Obtains dh/dt=3/2 feet per minute.","Includes correct rate units."]],
    ["(c)","Use the linearization of ln x at x=1 to approximate ln(1.04), and state whether the approximation is an overestimate or underestimate.",["Uses L(x)=x−1 to obtain 0.04.","Notes (ln x)″<0 for x>0.","Concludes the tangent-line approximation is an overestimate."]]
  ]},
  {unit:5,topic:"5.4",practice:2,difficulty:"Medium",mode:"no-calculator",archetype:"sign-chart-analysis",stimulus:"A continuous function f is differentiable except possibly at x=−2,1,4. The sign of f′ is positive on (−3,−2), negative on (−2,1), positive on (1,4), and negative on (4,5). Values are f(−3)=1, f(−2)=5, f(1)=−2, f(4)=4, and f(5)=3.",parts:[
    ["(a)","State the intervals on which f is increasing.",["Identifies (−3,−2) and (1,4).","Connects increasing behavior to f′>0."]],
    ["(b)","Classify the local extrema.",["Identifies local maxima at x=−2 and x=4.","Identifies a local minimum at x=1.","Uses derivative sign changes to justify the classifications."]],
    ["(c)","Find the absolute maximum and minimum values on [−3,5].",["Compares all listed endpoint and critical values.","Finds absolute maximum 5 and absolute minimum −2."]],
    ["(d)","Could f″ be positive throughout (1,4)? Explain.",["Answers yes.","Explains that f′ may remain positive while increasing on (1,4), which is consistent with f″>0."]]
  ]},
  {unit:5,topic:"5.6",practice:3,difficulty:"Hard",mode:"no-calculator",archetype:"derivative-polynomial-analysis",stimulus:"A function f satisfies f(0)=0 and f′(x)=(x−1)²(x+2) on −3≤x≤3.",parts:[
    ["(a)","Find the intervals on which f is increasing and decreasing.",["Finds f decreases on (−3,−2).","Finds f increases on (−2,1) and (1,3), or equivalently on (−2,3)."]],
    ["(b)","Classify each critical number.",["Identifies a local minimum at x=−2.","States x=1 is not a local extremum because f′ does not change sign."]],
    ["(c)","Find intervals of concavity and all inflection x-coordinates.",["Finds f″(x)=3x²−3.","Finds concave up on (−3,−1) and (1,3), concave down on (−1,1).","Identifies inflections at x=−1 and x=1."]],
    ["(d)","Explain why the point at x=1 can be an inflection point even though f′(1)=0.",["States that inflection depends on a change in concavity.","Uses the sign change of f″ at x=1."]]
  ]},
  {unit:5,topic:"5.11",practice:1,difficulty:"Hard",mode:"no-calculator",archetype:"optimization",stimulus:"Squares of side length x are cut from each corner of a 20-inch by 14-inch rectangle. The sides are folded to form an open-top box.",parts:[
    ["(a)","Write the volume function and its physical domain.",["Writes V(x)=x(20−2x)(14−2x).","States 0<x<7."]],
    ["(b)","Find the critical value in the physical domain.",["Finds V′(x)=12x²−136x+280.","Solves V′(x)=0.","Obtains x=(17−√79)/3≈2.704."]],
    ["(c)","Justify that this critical value gives the absolute maximum volume.",["Uses a derivative sign change or endpoint comparison.","Notes volume approaches 0 at both ends of the physical domain."]],
    ["(d)","Give the resulting box dimensions and maximum volume.",["Gives dimensions approximately 14.592 by 8.592 by 2.704 inches.","Gives maximum volume approximately 339.013 cubic inches."]]
  ]},
  {unit:5,topic:"5.1",practice:3,difficulty:"Hard",mode:"no-calculator",archetype:"mean-value-theorem",stimulus:"A function f is continuous on [0,4], differentiable on (0,4), f(0)=1, and f(4)=9.",parts:[
    ["(a)","State the Mean Value Theorem conclusion for f on this interval.",["Computes the secant slope (9−1)/4=2.","States there is at least one c in (0,4) with f′(c)=2.","Cites the given continuity and differentiability conditions."]],
    ["(b)","Explain why it is impossible for f′(x)≤1 for every x in (0,4).",["Uses the Mean Value Theorem conclusion f′(c)=2.","Identifies the contradiction with the proposed bound.","Concludes the bound cannot hold throughout the interval."]],
    ["(c)","If f″(x)>0 throughout (0,4), show that exactly one c satisfies f′(c)=2.",["Uses f″>0 to conclude f′ is strictly increasing.","States a strictly increasing function takes the value 2 at most once.","Combines uniqueness with MVT existence to conclude exactly one."]]
  ]},
  {unit:6,topic:"6.4",practice:1,difficulty:"Medium",mode:"no-calculator",archetype:"fundamental-theorem",stimulus:"Define F(x)=∫₁^(x²)(t³+1)dt.",parts:[
    ["(a)","Find F′(x).",["Uses the Fundamental Theorem of Calculus.","Applies the chain rule to obtain F′(x)=2x(x⁶+1)."]],
    ["(b)","Find F(1) and write the tangent line at x=1.",["Finds F(1)=0 and F′(1)=4.","Writes y=4(x−1)."]],
    ["(c)","Evaluate ∫₀¹F′(x)dx.",["Uses ∫₀¹F′=F(1)−F(0).","Finds F(0)=−5/4 and obtains 5/4."]],
    ["(d)","Find an explicit polynomial expression for F(x).",["Antidifferentiates t³+1.","Obtains F(x)=x⁸/4+x²−5/4.","Includes the correct constant from the lower limit."]]
  ]},
  {unit:7,topic:"7.6",practice:1,difficulty:"Hard",mode:"no-calculator",archetype:"separable-differential-equation",stimulus:"A function y satisfies dy/dx=2x/(1+y) and y(0)=1.",parts:[
    ["(a)","Write the equation of the tangent line to the solution curve at x=0.",["Finds the initial slope is 0 at the point (0,1).","Writes y=1."]],
    ["(b)","Use Euler's method with step size 0.5 to estimate y(1).",["Finds y(0.5)=1 and then uses slope 0.5 at (0.5,1).","Obtains y(1)≈1.25."]],
    ["(c)","Solve the differential equation for the particular solution.",["Separates variables as (1+y)dy=2x dx.","Integrates and applies y(0)=1.","Obtains y=−1+√(2x²+4)."]],
    ["(d)","Find y(1) exactly and compare it with the Euler estimate.",["Finds y(1)=√6−1.","Notes √6−1≈1.449 exceeds 1.25."]]
  ]},
  {unit:8,topic:"8.4",practice:1,difficulty:"Medium",mode:"no-calculator",archetype:"multiple-volumes",stimulus:"Let R be the region bounded by y=2x and y=x² for 0≤x≤2.",parts:[
    ["(a)","Find the area of R.",["Uses ∫₀²(2x−x²)dx.","Obtains 4/3 square units."]],
    ["(b)","Find the volume when R is revolved about the x-axis.",["Uses π∫₀²[(2x)²−(x²)²]dx.","Obtains 64π/15 cubic units."]],
    ["(c)","Find the volume when R is revolved about the y-axis.",["Uses cylindrical shells 2π∫₀²x(2x−x²)dx.","Obtains 8π/3 cubic units."]],
    ["(d)","Find the volume of the solid with base R and square cross sections perpendicular to the x-axis.",["Uses side length 2x−x².","Integrates ∫₀²(2x−x²)²dx.","Obtains 16/15 cubic units."]]
  ]}
];

const unitNames = {
  1:"limits-and-continuity",
  2:"differentiation-fundamental-properties",
  3:"differentiation-composite-implicit-inverse",
  4:"contextual-applications-of-differentiation",
  5:"analytical-applications-of-differentiation",
  6:"integration-and-accumulation",
  7:"differential-equations",
  8:"applications-of-integration"
};

function common(item, id, type) {
  return {
    schema_version:"1.0.0",
    package_id:id,
    content_key:id,
    content_version:1,
    difficulty:item.difficulty,
    exam_pack_ref:{exam_code:"ap_calculus_ab",school_year:"2026-27",exam_pack_version:"1.0.0"},
    item_type:type,
    archetype_ref:{archetype_key:type==="mcq"?"ap-calculus-ab-mcq":`ap-calculus-ab-frq-${item.archetype}`,version:"1.0.0"},
    taxonomy_refs:[
      {scheme_key:"ap-calculus-ab-2026-27",scheme_version:"1.0.0",node_key:`unit-${item.unit}-${unitNames[item.unit]}`},
      {scheme_key:"ap-calculus-ab-2026-27",scheme_version:"1.0.0",node_key:`topic-${item.topic}`},
      {scheme_key:"ap-calculus-ab-mathematical-practices",scheme_version:"1.0.0",node_key:`practice-${item.practice}`}
    ],
    accessibility:{language:"en",screen_reader_review_required:false,accommodation_notes:"All assessed mathematical information is available in text; notation requires normal math-reading support."}
  };
}

function packageMcq(item, index) {
  const id=`apcalcab-mcq-${String(index+21).padStart(3,"0")}`;
  const choices=item.choices.map((choice,i)=>({choice_key:"ABCD"[i],choice_text:choice,is_correct:"ABCD"[i]===item.key,rationale:item.r[i]}));
  const pkg={
    ...common(item,id,"mcq"),
    stimuli:[{stimulus_key:"directions",ordinal:1,kind:"text",payload:{text:item.mode==="calculator"?"A graphing calculator is required.":"No calculator is permitted.",calculator_mode:item.mode},source_refs:[SOURCE_REF]}],
    mcq_choices:choices,
    canonical_answers:[item.key],
    parts:[{part_key:"question",ordinal:1,prompt:`${item.stem}\n\n${choices.map(c=>`${c.choice_key}. ${c.choice_text}`).join("\n")}`,stimulus_refs:["directions"],response_modalities:["choice"],points:1,criteria:[{criterion_key:"correct-answer",points:1,description:"Select the unique correct response.",required_evidence:[item.key,item.proof],accepted_variants:["Only a displayed choice that is mathematically identical to the keyed response may be treated as equivalent."],insufficient_responses:["An unkeyed choice without a valid ambiguity finding."],contradictions:["A choice or rationale that conflicts with the governing domain, units, or theorem conditions."],deterministic_checks:[{check_type:"choice-key",parameters:{correct_key:item.key}}]}]}],
    review_notes:{expected_reasoning:item.proof,teaching_explanation:item.proof,minimum_fix:"Correct the first invalid mathematical step, then recompute without changing the problem conditions.",transfer_candidate:`Create a new item assessing Topic ${item.topic} with different values and a different representation.`,delayed_retrieval_candidate:`Reassess Topic ${item.topic} after a delay without reusing this stem or choices.`,known_boundary_cases:["Reject if more than one displayed choice becomes correct under a reasonable interpretation.","Check that the keyed choice is not identifiable by length, grammar, or precision alone."],originality_statement:ORIGINALITY},
    provenance:{source_refs:[SOURCE_REF],fact_pack_version:"2026-07-27",authoring_prompt_version:"CALCULUS_AB_CONTENT_BATCH_2026_07_27",generated_by:"codex",generated_at:GENERATED_AT}
  };
  pkg.provenance.content_sha256=sha(JSON.stringify(pkg));
  return pkg;
}

function packageFrq(item,index) {
  const id=`apcalcab-frq-${String(index+17).padStart(3,"0")}`;
  const parts=item.parts.map(([label,prompt,criteria],partIndex)=>({
    part_key:`part-${"abcd"[partIndex]}`,ordinal:partIndex+1,label,prompt,stimulus_refs:["scenario"],response_modalities:["typed-text","typed-math"],points:criteria.length,
    criteria:criteria.map((description,criterionIndex)=>({
      criterion_key:`part-${"abcd"[partIndex]}-criterion-${criterionIndex+1}`,points:1,description,required_evidence:[description],
      accepted_variants:["Any mathematically equivalent expression, valid reasoning path, or appropriately rounded value supported by the student's setup."],
      insufficient_responses:["A correct number without required setup, justification, interpretation, or units when that evidence is named in the criterion."],
      contradictions:["Do not award the criterion when the response directly contradicts the required mathematical relationship or contextual meaning."],
      minimum_fix:`Add or correct the evidence needed to establish: ${description}`,
      deterministic_checks:[{check_type:"criterion-points",parameters:{expected_points:1}}]
    }))
  }));
  const pkg={
    ...common(item,id,"frq"),
    frq_form:"long",
    canonical_answers:[parts.flatMap(p=>p.criteria.map(c=>c.description)).join(" | ")],
    stimuli:[{stimulus_key:"scenario",ordinal:1,kind:"text",payload:{text:item.stimulus,calculator_mode:item.mode},source_refs:[SOURCE_REF]}],
    parts,
    scoring_contract:{total_points:9,part_count:parts.length,calculator_mode:item.mode,carry_forward_rule:"A later criterion may earn when the student's earlier arithmetic error is carried forward consistently and the later reasoning remains valid.",rounding_rule:"Accept exact values or values correctly rounded to the precision requested.",units_rule:"Units are required only when a criterion or prompt explicitly requests contextual units.",ambiguity_rule:"Escalate responses that use a valid but unlisted interpretation rather than forcing a score."},
    development_cases:{full_credit:"Provides all required setup, values, justifications, interpretations, and units.",partial_credit:"Shows a valid method for multiple criteria but omits or misstates at least one independently required piece of evidence.",no_credit:"Provides no relevant calculus relationship or only unsupported answers.",equivalent:"Uses algebraically equivalent forms or a different valid theorem-based argument.",contradictory:"States a correct value but also asserts an incompatible sign, interval, unit, or conclusion.",ambiguous:"Contains notation whose intended mathematical meaning cannot be determined reliably."},
    review_notes:{expected_reasoning:parts.flatMap(p=>p.criteria.map(c=>c.description)).join(" | "),teaching_explanation:"Connect each awarded point to the stated calculus relationship and the evidence shown in the response.",minimum_fix:"Repair the earliest missing setup or justification needed for the next unearned criterion.",transfer_candidate:`Create a new ${item.archetype} task with a different context, representation, and numerical structure.`,delayed_retrieval_candidate:`Reassess Topic ${item.topic} later with a different function family and no shared wording.`,known_boundary_cases:["Award criteria independently when the exam task permits.","Do not award interpretation or justification points for a bare numerical answer.","Use carry-forward only when later reasoning remains mathematically valid."],originality_statement:ORIGINALITY},
    provenance:{source_refs:[SOURCE_REF],fact_pack_version:"2026-07-27",authoring_prompt_version:"CALCULUS_AB_CONTENT_BATCH_2026_07_27",generated_by:"codex",generated_at:GENERATED_AT}
  };
  pkg.provenance.content_sha256=sha(JSON.stringify(pkg));
  return pkg;
}

await mkdir(OUT,{recursive:true});
const mcqPackages=mcq.map(packageMcq);
const frqPackages=frq.map(packageFrq);
for (const pkg of [...mcqPackages,...frqPackages]) await writeFile(`${OUT}/${pkg.package_id}.json`,`${JSON.stringify(pkg,null,2)}\n`);

let md="# AP Calculus AB Practice Packet — 30 MCQs and 20 FRQs\n\n";
md+="Status: Original draft practice content for independent human review. Not approved or published.\n\n";
md+="Source scope: `docs/product/AP_CALCULUS_AB_BC_CED_FACT_PACK.md` and the local College Board CED. Official question text and scoring language were not used as authoring inputs.\n\n";
md+="## Student directions\n\nFollow the calculator designation printed above each item. Each FRQ is worth 9 points, and calculator use is stated for every FRQ.\n\n";
md+="## Multiple-choice questions\n\n";
for (const [i,pkg] of mcqPackages.entries()) md+=`### ${i+1}. ${pkg.stimuli[0].payload.calculator_mode==="calculator"?"Calculator required":"No calculator"}\n\n${pkg.parts[0].prompt}\n\n`;
md+="## Free-response questions\n\n";
for (const [i,pkg] of frqPackages.entries()) {
  md+=`### FRQ ${i+1} — ${pkg.stimuli[0].payload.calculator_mode==="calculator"?"Calculator required":"No calculator"} — 9 points\n\n${pkg.stimuli[0].payload.text}\n\n`;
  for (const part of pkg.parts) md+=`${part.label} ${part.prompt}\n\n`;
}
md+="## Answer key and scoring guidance\n\n### MCQ key\n\n";
md+=mcqPackages.map((p,i)=>`${i+1}. ${p.canonical_answers[0]} — ${p.review_notes.expected_reasoning}`).join("\n\n");
md+="\n\n";
for (const [i,pkg] of frqPackages.entries()) {
  md+=`### FRQ ${i+1} — 9 points\n\n`;
  for (const part of pkg.parts) md+=`- ${part.label} ${part.points} points: ${part.criteria.map(c=>`1 pt — ${c.description}`).join(" | ")}\n`;
  md+="\n";
}
await writeFile(PACKET,md);
console.log(`Wrote ${mcqPackages.length} MCQs, ${frqPackages.length} FRQs, and ${PACKET}`);
