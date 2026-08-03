import { createHash } from "node:crypto";
import { mkdir, writeFile } from "node:fs/promises";

const ROOT = new URL("../../", import.meta.url).pathname;
const OUT = `${ROOT}content/item-packages/ap-calculus-bc`;
const PACKET = `${ROOT}docs/teaching/AP_CALCULUS_BC_PRACTICE_PACKET_2026_07_28.md`;
const GENERATED_AT = "2026-07-28T00:00:00Z";
const SOURCE_REF = "ap-calculus-ab-bc-ced-effective-fall-2020-2026-release";
const ORIGINALITY = "Independently authored Cramapple practice item from a blank scope brief; no released, secure, or third-party question or scoring language was used.";
const sha = value => createHash("sha256").update(value).digest("hex");

const mcq = [
  {topic:"1.7",unit:1,practice:1,difficulty:"Easy",mode:"no-calculator",stem:"What is lim(x→0) (e^(3x)−1)/x?",choices:["0","1","3","e³"],key:"C",proof:"L'Hospital's Rule or the standard exponential limit gives lim(x→0)3e^(3x)=3.",r:["Substitutes before resolving the indeterminate form.","Uses the derivative of x but omits the exponent coefficient.","Correctly resolves the 0/0 form and evaluates the derivative.","Confuses the coefficient in the exponent with a function value."]},
  {topic:"1.9",unit:1,practice:2,difficulty:"Medium",mode:"no-calculator",stem:"What is lim(x→0) ln(1+2x)/sin(3x)?",choices:["3/2","2/3","1/6","The limit does not exist"],key:"B",proof:"Using standard limits, ln(1+2x) is asymptotic to 2x and sin(3x) to 3x, so the limit is 2/3.",r:["Reverses the numerator and denominator scale factors.","Correctly compares the two first-order behaviors.","Multiplies rather than divides the scale factors.","Treats a removable 0/0 form as nonexistence."]},
  {topic:"2.8",unit:2,practice:1,difficulty:"Easy",mode:"no-calculator",stem:"If f(x)=x²ln x for x>0, what is f′(1)?",choices:["0","2","1","e"],key:"C",proof:"The product rule gives f′(x)=2xln x+x, so f′(1)=1.",r:["Differentiates only the logarithmic value at 1.","Keeps the polynomial derivative but omits the logarithm's contribution.","Correctly applies the product rule and evaluates.","Confuses evaluation at x=1 with evaluation at x=e."]},
  {topic:"2.2",unit:2,practice:2,difficulty:"Medium",mode:"no-calculator",stem:"Which limit equals f″(2), provided the second derivative exists?",choices:["lim(h→0)[f(2+h)−f(2)]/h","lim(h→0)[f′(2+h)−f′(h)]/2","lim(x→2)[f′(x)−f′(2)]/2","lim(h→0)[f′(2+h)−f′(2)]/h"],key:"D",proof:"The derivative definition applied to f′ at x=2 is lim(h→0)[f′(2+h)−f′(2)]/h.",r:["This is the definition of the first derivative at 2.","Uses inconsistent base inputs and a fixed denominator.","Divides by the point rather than the change in input.","Correctly applies the derivative definition to f′."]},
  {topic:"3.4",unit:3,practice:1,difficulty:"Medium",mode:"no-calculator",stem:"What is d/dx[arctan(x²)]?",choices:["2x/(1+x⁴)","2x/(1+x²)","1/(1+x⁴)","2/(1+x⁴)"],key:"A",proof:"The chain rule gives [1/(1+(x²)²)]·2x=2x/(1+x⁴).",r:["Correctly combines the inverse-tangent derivative with the chain rule.","Fails to square the inner expression in the denominator.","Omits the derivative of the inner function.","Differentiates x² as though its derivative were 2."]},
  {topic:"3.3",unit:3,practice:1,difficulty:"Hard",mode:"no-calculator",stem:"Let g=f⁻¹. If f(2)=5 and f′(2)=−3, what is g′(5)?",choices:["−3","1/3","3","−1/3"],key:"D",proof:"For an inverse function, g′(5)=1/f′(g(5))=1/f′(2)=−1/3.",r:["Uses the original derivative without taking its reciprocal.","Drops the negative sign from the reciprocal.","Uses the reciprocal relationship in the wrong direction.","Correctly applies the inverse-function derivative rule."]},
  {topic:"4.5",unit:4,practice:1,difficulty:"Easy",mode:"no-calculator",stem:"The radius of a sphere is increasing at 0.2 centimeter per second. How fast is its volume increasing when the radius is 3 centimeters?",choices:["1.8π cm³/s","3.6π cm³/s","10.8π cm³/s","7.2π cm³/s"],key:"D",proof:"From V=(4/3)πr³, dV/dt=4πr²dr/dt=4π(9)(0.2)=7.2π cubic centimeters per second.",r:["Uses half of the required surface-area factor.","Omits a factor of 2 from differentiating the cubic.","Uses the original volume coefficient as the rate factor.","Correctly differentiates with respect to time and substitutes."]},
  {topic:"4.2",unit:4,practice:1,difficulty:"Hard",mode:"calculator",stem:"A particle has velocity v(t)=t sin(t²)−0.4. What is its acceleration at t=1.3, to the nearest thousandth?",choices:["−0.744","−0.131","0.591","0.862"],key:"C",proof:"a(t)=sin(t²)+2t²cos(t²), so a(1.3)≈0.591.",r:["Differentiates only the trigonometric factor and changes the sign.","Uses an incomplete chain-rule contribution.","Correctly applies the product and chain rules, then evaluates.","Uses the velocity value rather than its derivative."]},
  {topic:"5.3",unit:5,practice:2,difficulty:"Easy",mode:"no-calculator",stem:"If f′(x)=(x−1)(x+2), on which intervals is f increasing?",choices:["(−∞,−2) and (1,∞)","(−2,1) only","(−∞,1) only","(−2,∞) only"],key:"A",proof:"The derivative is positive outside its zeros −2 and 1, so f increases on (−∞,−2) and (1,∞).",r:["Correctly uses the positive intervals of the derivative.","Selects the interval where both factors have opposite signs.","Ignores the sign change at the left derivative zero.","Combines an increasing and a decreasing interval."]},
  {topic:"5.1",unit:5,practice:1,difficulty:"Medium",mode:"no-calculator",stem:"For f(x)=e^x on [0,1], which value of c is guaranteed by the Mean Value Theorem?",choices:["1/2","e−1","ln(e−1)","ln 2"],key:"C",proof:"The secant slope is e−1. Since f′(c)=e^c, the required value is c=ln(e−1), which lies in (0,1).",r:["Uses the interval midpoint without solving the derivative equation.","Reports the required derivative value instead of its input.","Correctly equates the derivative to the average rate of change.","Uses a convenient logarithm unrelated to the secant slope."]},
  {topic:"5.4",unit:5,practice:2,difficulty:"Hard",mode:"calculator",stem:"A differentiable function has f′(x)=x⁴−4x²+0.5 on −2≤x≤2. At which x-values does f have local maxima, to the nearest thousandth?",choices:["−1.967 and 0.359","−0.359 and 1.967","−1.967 and 1.967","−0.359 and 0.359"],key:"A",proof:"The derivative zeros are approximately ±0.359 and ±1.967; positive-to-negative sign changes occur at x≈−1.967 and x≈0.359.",r:["Correctly identifies both positive-to-negative sign changes.","Selects the two negative-to-positive sign changes.","Chooses the outer roots without checking derivative signs.","Chooses the inner roots without checking derivative signs."]},
  {topic:"5.9",unit:5,practice:3,difficulty:"Very Hard",mode:"no-calculator",stem:"If f′(x)=x²(x−1)³(x+2)², which statement is true?",choices:["f has local maxima at x=−2 and x=0, but no extremum at x=1.","f has a local maximum at x=1 and no extrema at x=−2 or x=0.","f has local minima at x=−2 and x=0, but no extremum at x=1.","f has a local minimum at x=1 and no extrema at x=−2 or x=0."],key:"D",proof:"The even-multiplicity factors do not change sign at −2 or 0; the odd factor changes f′ from negative to positive at 1, producing only a local minimum.",r:["Even-multiplicity derivative zeros do not create those sign changes.","The sign change at 1 is negative to positive, not positive to negative.","Derivative zeros alone do not guarantee extrema.","Correctly distinguishes stationary points from the sole extremum."]},
  {topic:"6.13",unit:6,practice:1,difficulty:"Easy",mode:"no-calculator",stem:"What is the value of the improper integral ∫₁^∞ 1/x² dx?",choices:["0","2","The integral diverges","1"],key:"D",proof:"lim(b→∞)∫₁ᵇx⁻²dx=lim(b→∞)(1−1/b)=1.",r:["Uses only the antiderivative limit at infinity.","Uses the p-value as the integral's value.","Incorrectly treats a convergent p-integral as divergent.","Correctly evaluates the defining limit."]},
  {topic:"6.11",unit:6,practice:1,difficulty:"Medium",mode:"no-calculator",stem:"Which is an antiderivative of xe^x?",choices:["xe^x−e^x","xe^x+e^x","x²e^x/2","e^x/x"],key:"A",proof:"Integration by parts gives ∫xe^x dx=xe^x−e^x+C.",r:["Correctly applies integration by parts.","Differentiating produces xe^x+2e^x, not xe^x.","This treats e^x as a constant factor.","This quotient does not differentiate to the integrand."]},
  {topic:"6.12",unit:6,practice:1,difficulty:"Hard",mode:"no-calculator",stem:"What is ∫1/(x²−1) dx on an interval not containing ±1?",choices:["ln|x²−1|+C","ln|(x−1)/(x+1)|+C","(1/2)ln|x²−1|+C","(1/2)ln|(x−1)/(x+1)|+C"],key:"D",proof:"Since 1/(x²−1)=1/[2(x−1)]−1/[2(x+1)], the integral is (1/2)ln|(x−1)/(x+1)|+C.",r:["Differentiating introduces an unwanted factor of 2x.","Omits the one-half coefficients in the decomposition.","Combines logarithms with the wrong signs.","Correctly decomposes into linear partial fractions and integrates."]},
  {topic:"6.4",unit:6,practice:1,difficulty:"Hard",mode:"calculator",stem:"Let G(x)=∫₀^(x²) cos(t³)dt. What is G′(1.2), to the nearest thousandth?",choices:["−2.371","−0.988","0.988","2.371"],key:"A",proof:"G′(x)=2x cos(x⁶), so G′(1.2)=2.4cos(1.2⁶)≈−2.371.",r:["Correctly combines the Fundamental Theorem and the chain rule.","Omits or misuses the derivative of the upper limit.","Drops the negative sign from the cosine value and omits a factor.","Uses the correct magnitude but loses the negative sign."]},
  {topic:"6.13",unit:6,practice:1,difficulty:"Very Hard",mode:"no-calculator",stem:"What is ∫₁^∞ (ln x)/x² dx?",choices:["1/2","1","2","The integral diverges"],key:"B",proof:"Integration by parts gives [−(ln x)/x]₁^∞+∫₁^∞1/x²dx=0+1=1.",r:["Uses an incorrect boundary contribution.","Correctly combines integration by parts with the improper limit.","Doubles the convergent p-integral contribution.","Mistakes slow logarithmic growth for divergence."]},
  {topic:"7.5",unit:7,practice:2,difficulty:"Medium",mode:"calculator",stem:"Use Euler's method with step size 0.25 to estimate y(0.5) for y′=x²−y and y(0)=1.",choices:["0.500","0.688","0.750","0.578"],key:"D",proof:"The steps give y(0.25)=0.75 and y(0.5)=0.75+0.25(0.25²−0.75)=0.578125≈0.578.",r:["Uses the initial slope for both steps.","Uses the second slope before updating the first point.","Stops after the first Euler step.","Correctly updates the point and slope at each step."]},
  {topic:"7.9",unit:7,practice:1,difficulty:"Hard",mode:"calculator",stem:"A population satisfies dP/dt=0.4P(1−P/1200) and P(0)=300. When does P reach 600, to the nearest thousandth?",choices:["1.733","3.466","2.747","4.394"],key:"C",proof:"The solution is P=1200/(1+3e^(−0.4t)); setting P=600 gives t=ln(3)/0.4≈2.747.",r:["Uses ln(2) instead of the initial-condition factor.","Divides ln(4) by the growth constant.","Correctly solves the logistic model for half the capacity.","Uses the carrying-capacity ratio without the exponential model."]},
  {topic:"8.4",unit:8,practice:1,difficulty:"Easy",mode:"no-calculator",stem:"What is the area between y=√x and y=x on 0≤x≤1?",choices:["1/3","1/4","1/6","1/2"],key:"C",proof:"The area is ∫₀¹(√x−x)dx=2/3−1/2=1/6.",r:["Integrates only one boundary correctly.","Subtracts endpoint values rather than areas.","Correctly integrates top minus bottom.","Adds rather than subtracts the two component integrals."]},
  {topic:"8.8",unit:8,practice:2,difficulty:"Very Hard",mode:"calculator",stem:"The base of a solid is 0≤x≤1.5 and 0≤y≤e^(−x²). Cross sections perpendicular to the x-axis are semicircles whose diameters lie in the base. What is the volume, to the nearest thousandth?",choices:["0.245","0.491","0.982","1.963"],key:"A",proof:"A semicircle with diameter e^(−x²) has area (π/8)e^(−2x²), so V=(π/8)∫₀^1.5e^(−2x²)dx≈0.245.",r:["Correctly converts the diameter to a semicircle area and integrates.","Uses π/4 rather than π/8 as the cross-sectional factor.","Uses the full-circle area with the given diameter.","Treats the diameter as the radius and uses a full circle."]},
  {topic:"9.1",unit:9,practice:1,difficulty:"Medium",mode:"no-calculator",stem:"A curve is given by x=t²+1 and y=t³−3t. What is dy/dx at t=1?",choices:["−1","0","1","2"],key:"B",proof:"dy/dx=(3t²−3)/(2t), which equals 0 at t=1.",r:["Subtracts the parameter derivatives rather than dividing.","Correctly divides dy/dt by dx/dt.","Uses the ratio before evaluating both derivatives.","Uses dx/dt alone as the slope."]},
  {topic:"9.6",unit:9,practice:2,difficulty:"Hard",mode:"calculator",stem:"A particle has position r(t)=⟨t²−2t,e^(−t)⟩. What is its speed at t=1.4, to the nearest thousandth?",choices:["0.554","0.837","0.800","1.047"],key:"B",proof:"The velocity is ⟨2t−2,−e^(−t)⟩, so the speed at 1.4 is √(0.8²+e^(−2.8))≈0.837.",r:["Uses only the vertical velocity magnitude.","Correctly takes the magnitude of the velocity vector.","Uses only the horizontal velocity magnitude.","Adds component magnitudes rather than using the Euclidean norm."]},
  {topic:"9.8",unit:9,practice:1,difficulty:"Hard",mode:"no-calculator",stem:"What is the area of one petal of the polar curve r=2sin(3θ)?",choices:["π/6","π/3","2π/3","π"],key:"B",proof:"One petal is traced for 0≤θ≤π/3, so its area is (1/2)∫₀^(π/3)4sin²(3θ)dθ=π/3.",r:["Uses half of the correct angular contribution.","Correctly applies the polar-area formula over one petal.","Doubles the one-petal result.","Uses an entire-circle scale unrelated to one petal."]},
  {topic:"9.2",unit:9,practice:3,difficulty:"Very Hard",mode:"calculator",stem:"A curve is given by x=t+sin t and y=1−cos t. What is d²y/dx² at t=1, to the nearest thousandth?",choices:["0.421","0.354","0.500","0.771"],key:"A",proof:"dy/dx=sin t/(1+cos t). Differentiating with respect to t and dividing by dx/dt gives d²y/dx²≈0.421 at t=1.",r:["Correctly differentiates the parametric slope and divides by dx/dt.","Differentiates the slope but does not complete the parameter conversion.","Uses the derivative of tan(t/2) without dividing by dx/dt.","Evaluates the first derivative rather than the second derivative."]},
  {topic:"10.2",unit:10,practice:1,difficulty:"Medium",mode:"no-calculator",stem:"What is the sum of Σ[n=1 to ∞] 5(−1/3)^(n−1)?",choices:["5/4","15/4","5","15/2"],key:"B",proof:"The geometric series has first term 5 and ratio −1/3, so its sum is 5/[1−(−1/3)]=15/4.",r:["Uses 1−1/3 instead of accounting for the negative ratio.","Correctly applies the infinite geometric-series formula.","Reports only the first term.","Uses the magnitude of the ratio in the wrong denominator."]},
  {topic:"10.9",unit:10,practice:3,difficulty:"Medium",mode:"no-calculator",stem:"Which statement describes Σ[n=1 to ∞](−1)^(n+1)/√n?",choices:["It diverges by the nth-term test.","It converges conditionally.","It converges absolutely.","It is geometric and converges."],key:"B",proof:"The alternating-series conditions hold, but Σ1/√n is a divergent p-series, so convergence is conditional.",r:["The terms do approach zero, so this test does not prove divergence.","Correctly distinguishes alternating from absolute convergence.","The corresponding positive p-series diverges.","The ratio between successive terms is not constant."]},
  {topic:"10.13",unit:10,practice:3,difficulty:"Hard",mode:"no-calculator",stem:"What is the interval of convergence of Σ[n=1 to ∞](x−2)^n/(n3^n)?",choices:["(−1,5)","[−1,5]","[−1,5)","(−1,5]"],key:"C",proof:"The radius is 3. At x=5 the harmonic series diverges; at x=−1 the alternating harmonic series converges, giving [−1,5).",r:["Omits the convergent left endpoint.","Incorrectly includes the divergent harmonic endpoint.","Correctly tests both endpoints after finding the radius.","Reverses the endpoint conclusions."]},
  {topic:"10.12",unit:10,practice:3,difficulty:"Very Hard",mode:"calculator",stem:"The degree-5 Maclaurin polynomial for sin x is used at x=0.7. Which is a valid Lagrange error bound?",choices:["0.7⁵/5!","0.7⁶/6!","0.7⁷/7!","sin(0.7)/6!"],key:"B",proof:"The next derivative has magnitude at most 1, so |R₅(0.7)|≤0.7⁶/6!≈0.000163.",r:["Uses the degree of the polynomial instead of the next power.","Correctly applies the Lagrange remainder with n+1=6.","Skips an additional power and factorial without justification.","Uses a function value rather than a derivative bound."]},
  {topic:"10.15",unit:10,practice:1,difficulty:"Very Hard",mode:"no-calculator",stem:"What is the coefficient of x⁷ in the Maclaurin series for x²e^(−x)?",choices:["−1/120","1/120","−1/5040","1/5040"],key:"A",proof:"Since e^(−x)=Σ(−1)^n x^n/n!, the x⁷ term after multiplying by x² comes from n=5 and has coefficient −1/5!=−1/120.",r:["Correctly shifts the power by two and uses the n=5 coefficient.","Drops the alternating sign.","Uses the factorial associated with the final power rather than the original series index.","Uses both the wrong index and the wrong sign."]}
];

const frq = [
  {unit:1,topic:"1.13",practice:3,difficulty:"Easy",mode:"no-calculator",archetype:"removable-discontinuity",stimulus:"Let f(x)=(x²−9)/(x−3) for x≠3, and let f(3)=k.",parts:[
    ["(a)","Evaluate lim(x→3)f(x).",["Factors and simplifies f(x) to x+3 for x≠3.","Concludes the limit is 6."]],
    ["(b)","Find k so that f is continuous at x=3.",["States that continuity requires f(3) to equal the limit.","Concludes k=6."]],
    ["(c)","For this value of k, use the derivative definition to find f′(3).",["Writes lim(h→0)[f(3+h)−f(3)]/h.","Simplifies the quotient to 1.","Concludes f′(3)=1."]],
    ["(d)","Find the value c in (3,5) for which f(c)=7, and name the theorem that guarantees such a value.",["Finds c=4.","Cites continuity and the Intermediate Value Theorem."]]
  ]},
  {unit:1,topic:"1.16",practice:3,difficulty:"Medium",mode:"calculator",archetype:"transcendental-limit",stimulus:"Let c be the solution in (0,1) of e^(−x)=x, and define g(x)=(e^(−x)−x)/(x−c) for x≠c.",parts:[
    ["(a)","Explain why at least one such value c exists.",["Defines h(x)=e^(−x)−x or an equivalent continuous function.","Notes h(0)>0 and h(1)<0.","Applies the Intermediate Value Theorem."]],
    ["(b)","Find c to three decimal places.",["Obtains c≈0.567 using a numerical zero method."]],
    ["(c)","Evaluate lim(x→c)g(x).",["Recognizes the limit as the derivative of h at c.","Uses h′(c)=−e^(−c)−1 and e^(−c)=c to obtain −c−1.","Reports approximately −1.567."]],
    ["(d)","Define g(c) so that g is continuous at c, and explain why the definition works.",["Sets g(c)=−c−1 or the corresponding numerical value.","States that the assigned value equals lim(x→c)g(x)."]]
  ]},
  {unit:2,topic:"2.8",practice:1,difficulty:"Easy",mode:"no-calculator",archetype:"derivative-procedures",stimulus:"Let f(x)=x²e^x.",parts:[
    ["(a)","Find f′(x).",["Uses the product rule.","Obtains f′(x)=e^x(x²+2x)."]],
    ["(b)","Write the equation of the tangent line to f at x=0.",["Finds f(0)=0 and f′(0)=0.","Writes y=0."]],
    ["(c)","Find f″(x).",["Differentiates f′ using the product rule.","Obtains f″(x)=e^x(x²+4x+2)."]],
    ["(d)","Determine the concavity of f at x=0 and justify.",["Finds f″(0)=2.","Concludes f is concave up at x=0 because f″(0)>0.","Connects the positive second derivative to local concavity."]]
  ]},
  {unit:3,topic:"3.2",practice:1,difficulty:"Medium",mode:"no-calculator",archetype:"implicit-derivatives",stimulus:"The curve x²+xy+y²=7 passes through the point (1,2).",parts:[
    ["(a)","Find dy/dx in terms of x and y, and then find the slope at (1,2).",["Differentiates to obtain 2x+y+xy′+2yy′=0.","Solves y′=−(2x+y)/(x+2y).","Finds the slope −4/5."]],
    ["(b)","Write the tangent-line equation at (1,2).",["Uses the point (1,2) and slope −4/5.","Writes y−2=−(4/5)(x−1)."]],
    ["(c)","Find d²y/dx² at (1,2).",["Differentiates again to obtain 2+2y′+2(y′)²+(x+2y)y″=0.","Substitutes x=1, y=2, and y′=−4/5.","Obtains y″=−42/125."]],
    ["(d)","State the local concavity of the curve at the point.",["Concludes the curve is concave down because y″<0."]]
  ]},
  {unit:4,topic:"4.3",practice:2,difficulty:"Hard",mode:"calculator",archetype:"contextual-rate-accumulation",stimulus:"A tank initially contains 40 liters. For 0≤t≤6 minutes, liquid enters at I(t)=7+sin t liters per minute and leaves at L(t)=2+0.8t liters per minute.",parts:[
    ["(a)","Find the net rate of change of liquid at t=2 and interpret the result with units.",["Uses I(2)−L(2).","Obtains approximately 4.309 liters per minute.","States that the amount of liquid is increasing at that instant."]],
    ["(b)","Find the net change in the amount of liquid from t=0 to t=6.",["Uses ∫₀⁶[I(t)−L(t)]dt.","Obtains approximately 15.640 liters."]],
    ["(c)","Find the time at which the amount of liquid is greatest.",["Solves I(t)=L(t) to obtain t≈5.086.","Uses the sign change of I−L from positive to negative."]],
    ["(d)","Find the greatest amount of liquid in the tank and justify that it is an absolute maximum.",["Evaluates 40+∫₀^t[I(s)−L(s)]ds at the critical time.","Obtains approximately 55.718 liters and confirms it exceeds both endpoint amounts."]]
  ]},
  {unit:5,topic:"5.9",practice:3,difficulty:"Medium",mode:"no-calculator",archetype:"derivative-sign-analysis",stimulus:"A differentiable function f satisfies f(0)=4 and f′(x)=(x+1)(x−2)² on −3≤x≤3.",parts:[
    ["(a)","Find all critical numbers of f.",["Identifies x=−1.","Identifies x=2."]],
    ["(b)","Determine the intervals on which f is increasing and decreasing, and classify the critical numbers.",["Finds f decreases on (−3,−1).","Finds f increases on (−1,2) and (2,3).","Classifies x=−1 as a local minimum and x=2 as neither a maximum nor a minimum."]],
    ["(c)","Determine the intervals of concavity.",["Finds f″(x)=3x(x−2).","Concludes concave up on (−3,0) and (2,3), and concave down on (0,2)."]],
    ["(d)","Find the absolute maximum and absolute minimum values of f on [−3,3].",["Compares f at endpoints and critical numbers to obtain an absolute maximum f(−3)=157/4 and an absolute minimum f(−1)=5/4.","States the corresponding input values x=−3 and x=−1."]]
  ]},
  {unit:5,topic:"5.4",practice:3,difficulty:"Hard",mode:"calculator",archetype:"derivative-defined-function",stimulus:"A differentiable function f satisfies f(0)=2 and f′(x)=e^(−x/3)(x²−4x+1) on 0≤x≤6.",parts:[
    ["(a)","Find the intervals on which f is increasing.",["Finds the critical numbers x=2−√3 and x=2+√3.","Concludes f increases on (0,2−√3) and (2+√3,6)."]],
    ["(b)","Find the absolute maximum and absolute minimum values of f on [0,6].",["Evaluates f at the endpoints and both critical numbers using f(x)=2+∫₀ˣf′(t)dt.","Finds the absolute maximum f(2−√3)≈2.127.","Finds the absolute minimum f(2+√3)≈−1.550."]],
    ["(c)","Find the x-coordinate of the inflection point in (0,6) and justify.",["Finds f″(x)=(e^(−x/3)/3)(−x²+10x−13).","Obtains x=5−2√3≈1.536 and verifies a concavity change."]],
    ["(d)","Write the tangent-line equation at x=0.",["Uses f(0)=2 and f′(0)=1.","Writes y=2+x."]]
  ]},
  {unit:6,topic:"6.4",practice:1,difficulty:"Easy",mode:"no-calculator",archetype:"fundamental-theorem",stimulus:"Define F(x)=∫₁^(x²)(1+t³)dt.",parts:[
    ["(a)","Find F′(x) and F(1).",["Applies the Fundamental Theorem of Calculus.","Uses the chain rule for the upper limit.","Obtains F′(x)=2x(1+x⁶).","Obtains F(1)=0."]],
    ["(b)","Find F″(x).",["Differentiates 2x+2x⁷.","Obtains F″(x)=2+14x⁶."]],
    ["(c)","Evaluate ∫₀¹F′(x)dx.",["Uses F(1)−F(0) to obtain 5/4."]],
    ["(d)","Find the absolute minimum of F on [−1,1].",["Uses the sign of F′ to identify x=0.","Finds the minimum value F(0)=−5/4."]]
  ]},
  {unit:6,topic:"6.14",practice:1,difficulty:"Hard",mode:"no-calculator",archetype:"integration-techniques",stimulus:"Show the setup and result for each integral.",parts:[
    ["(a)","Evaluate ∫xe^(2x)dx.",["Uses integration by parts.","Obtains e^(2x)(2x−1)/4+C."]],
    ["(b)","Evaluate ∫1/(x²−1)dx.",["Decomposes 1/(x²−1)=1/[2(x−1)]−1/[2(x+1)].","Integrates the two logarithmic terms.","Obtains (1/2)ln|(x−1)/(x+1)|+C."]],
    ["(c)","Evaluate ∫₁^∞1/[x(x+1)]dx.",["Uses 1/[x(x+1)]=1/x−1/(x+1).","Evaluates the improper limit.","Obtains ln 2."]],
    ["(d)","Evaluate ∫x³/(x²+1)dx.",["Obtains x²/2−(1/2)ln(x²+1)+C by division or substitution."]]
  ]},
  {unit:6,topic:"6.5",practice:3,difficulty:"Very Hard",mode:"calculator",archetype:"oscillatory-accumulation",stimulus:"For 0≤x≤2, define G(x)=∫₀ˣe^(−t²)cos(t³)dt.",parts:[
    ["(a)","Find G(2) to three decimal places.",["Uses numerical integration on the defining integral.","Obtains G(2)≈0.695."]],
    ["(b)","Find all critical numbers of G in (0,2) and determine where G is increasing.",["Uses G′(x)=e^(−x²)cos(x³).","Finds critical numbers approximately 1.162, 1.677, and 1.988.","Finds G increasing on (0,1.162) and (1.677,1.988)."]],
    ["(c)","Find the absolute maximum and minimum values of G on [0,2].",["Evaluates G at endpoints and all critical numbers.","Finds the absolute maximum G(1.162)≈0.730 and absolute minimum G(0)=0."]],
    ["(d)","Determine the concavity of G at x=1.",["Finds G″(x)=e^(−x²)[−2xcos(x³)−3x²sin(x³)].","Concludes G is concave down at x=1 because G″(1)<0."]]
  ]},
  {unit:7,topic:"7.6",practice:2,difficulty:"Medium",mode:"no-calculator",archetype:"differential-equation",stimulus:"A function y satisfies dy/dx=x−y and y(0)=2.",parts:[
    ["(a)","Write the tangent-line equation to the solution at x=0.",["Finds the initial slope −2.","Writes y=2−2x."]],
    ["(b)","Use Euler's method with two steps of size 0.5 to approximate y(1).",["Finds the first Euler value y(0.5)=1.","Obtains y(1)=0.75."]],
    ["(c)","Solve the differential equation for the particular solution.",["Rewrites the equation as y′+y=x.","Uses an integrating factor or verifies the general form.","Obtains y=x−1+3e^(−x)."]],
    ["(d)","Find y(1) exactly and compare it with the Euler estimate.",["Finds y(1)=3/e.","States that 3/e≈1.104 is greater than the Euler estimate 0.75."]]
  ]},
  {unit:8,topic:"8.7",practice:2,difficulty:"Hard",mode:"calculator",archetype:"cross-sections-and-revolution",stimulus:"Let R be the region 0≤x≤1.5 and 0≤y≤e^(−x²).",parts:[
    ["(a)","Find the area of R.",["Uses ∫₀^1.5e^(−x²)dx.","Obtains approximately 0.856 square units."]],
    ["(b)","Find the volume of the solid with base R and square cross sections perpendicular to the x-axis.",["Uses ∫₀^1.5e^(−2x²)dx.","Obtains approximately 0.625 cubic units."]],
    ["(c)","Find the volume when the cross sections are semicircles whose diameters lie in R.",["Uses (π/8)∫₀^1.5e^(−2x²)dx.","Obtains approximately 0.245 cubic units."]],
    ["(d)","Find the volume when R is revolved about the line y=2.",["Uses washers π∫₀^1.5[4−(2−e^(−x²))²]dx.","Obtains approximately 8.796 cubic units.","Correctly identifies the outer and inner radii relative to y=2."]]
  ]},
  {unit:9,topic:"9.2",practice:1,difficulty:"Easy",mode:"no-calculator",archetype:"parametric-derivatives",stimulus:"A curve is given by x=t²+1 and y=t³−3t.",parts:[
    ["(a)","Find the point, dx/dt, and dy/dt at t=1.",["Obtains the point (2,−2).","Finds dx/dt=2.","Finds dy/dt=0."]],
    ["(b)","Find the tangent-line equation at t=1.",["Finds dy/dx=0.","Writes y=−2."]],
    ["(c)","Find d²y/dx² at t=1.",["Differentiates dy/dx with respect to t.","Divides by dx/dt and obtains 3/2."]],
    ["(d)","Find the speed and acceleration vector at t=1.",["Finds speed 2.","Finds acceleration ⟨2,6⟩."]]
  ]},
  {unit:9,topic:"9.6",practice:2,difficulty:"Medium",mode:"no-calculator",archetype:"vector-motion",stimulus:"A particle has position r(t)=⟨2cos t,2sin t⟩ for 0≤t≤π/2.",parts:[
    ["(a)","Find the velocity and speed at t=π/4.",["Finds v(t)=⟨−2sin t,2cos t⟩.","Obtains speed 2."]],
    ["(b)","Find the acceleration and its magnitude at t=π/4.",["Finds a(t)=⟨−2cos t,−2sin t⟩.","Obtains acceleration magnitude 2."]],
    ["(c)","Find the displacement vector and its magnitude from t=0 to t=π/2.",["Finds displacement ⟨−2,2⟩.","Obtains magnitude 2√2."]],
    ["(d)","Find the total distance traveled from t=0 to t=π/2.",["Uses ∫₀^(π/2)|v(t)|dt.","Uses the constant speed 2.","Obtains total distance π."]]
  ]},
  {unit:9,topic:"9.8",practice:2,difficulty:"Hard",mode:"calculator",archetype:"polar-numerical-analysis",stimulus:"A polar curve is given by r=2+sin(θ²) for 0≤θ≤π/2.",parts:[
    ["(a)","Find the Cartesian coordinates at θ=π/4.",["Evaluates r=2+sin(π²/16).","Obtains approximately (1.823,1.823)."]],
    ["(b)","Find dy/dx at θ=π/4.",["Finds dr/dθ=2θcos(θ²).","Uses dy/dx=[(dr/dθ)sinθ+r cosθ]/[(dr/dθ)cosθ−r sinθ].","Obtains the slope approximately −2.976."]],
    ["(c)","Find the area swept out by the radius from θ=0 to θ=π/2.",["Uses (1/2)∫₀^(π/2)[2+sin(θ²)]²dθ.","Obtains approximately 5.118 square units."]],
    ["(d)","Find dA/dθ at θ=π/4 and interpret the value.",["Uses dA/dθ=(1/2)r².","Obtains approximately 3.324 square units per radian."]]
  ]},
  {unit:10,topic:"10.15",practice:1,difficulty:"Very Hard",mode:"no-calculator",archetype:"derived-power-series",stimulus:"For |x|<1, define S(x)=Σ[n=1 to ∞]n x^n.",parts:[
    ["(a)","Derive a closed form for S(x) from the geometric series.",["Starts with Σ[n=0 to ∞]x^n=1/(1−x).","Differentiates term by term.","Multiplies by x to obtain S(x)=x/(1−x)²."]],
    ["(b)","Evaluate Σ[n=1 to ∞]n/3^n.",["Uses x=1/3 to obtain 3/4."]],
    ["(c)","Find a closed form for Σ[n=1 to ∞]n²x^(n−1).",["Differentiates S(x).","Simplifies the derivative.","Obtains (1+x)/(1−x)³."]],
    ["(d)","Find the interval of convergence of S(x) and justify the endpoints.",["Finds radius 1.","Rejects both endpoints because the terms do not approach zero."]]
  ]},
  {unit:10,topic:"10.9",practice:3,difficulty:"Medium",mode:"no-calculator",archetype:"convergence-tests",stimulus:"For each series, state whether it converges or diverges and justify with a named test.",parts:[
    ["(a)","Σ[n=1 to ∞]1/(n²+1)",["Compares with 1/n².","Concludes the series converges."]],
    ["(b)","Σ[n=1 to ∞](−1)^n n/(n+1)",["Notes that the terms do not approach zero.","Concludes divergence by the nth-term test."]],
    ["(c)","Σ[n=1 to ∞](−1)^(n+1)/n",["Uses the Alternating Series Test to establish convergence.","Notes that Σ1/n diverges.","Classifies the convergence as conditional."]],
    ["(d)","Σ[n=1 to ∞]3^n/n!",["Uses the Ratio Test.","Obtains ratio limit 0 and concludes absolute convergence."]]
  ]},
  {unit:10,topic:"10.14",practice:1,difficulty:"Hard",mode:"no-calculator",archetype:"maclaurin-series",stimulus:"Let f(x)=1/(1+x²).",parts:[
    ["(a)","Write the Maclaurin series for f and its interval of convergence.",["Uses the geometric-series form with ratio −x².","Obtains Σ[n=0 to ∞](−1)^n x^(2n) for |x|<1."]],
    ["(b)","Write the degree-6 Maclaurin polynomial.",["Obtains 1−x²+x⁴−x⁶.","Includes all nonzero terms through degree 6."]],
    ["(c)","Find f^(8)(0).",["Identifies the coefficient of x⁸ as 1.","Uses f^(8)(0)=8! to obtain 40320."]],
    ["(d)","Use the series to obtain a power series for ∫₀ˣf(t)dt and state its interval of convergence.",["Integrates term by term.","Obtains Σ[n=0 to ∞](−1)^n x^(2n+1)/(2n+1).","States the interval [−1,1]."]]
  ]},
  {unit:10,topic:"10.12",practice:3,difficulty:"Very Hard",mode:"calculator",archetype:"taylor-error",stimulus:"Use the Maclaurin series for e^x to approximate e^0.6.",parts:[
    ["(a)","Write the degree-4 Maclaurin polynomial P₄(x).",["Writes 1+x+x²/2!+x³/3!+x⁴/4!.","Identifies it as the degree-4 polynomial for e^x."]],
    ["(b)","Find P₄(0.6).",["Obtains P₄(0.6)=1.8214."]],
    ["(c)","Use the Lagrange error bound to bound |e^0.6−P₄(0.6)|.",["Uses a fifth-derivative bound M=e^0.6 on [0,0.6].","Writes |R₄(0.6)|≤e^0.6(0.6)^5/5!.","Obtains a bound of approximately 0.001181."]],
    ["(d)","Find the smallest degree n for which the Lagrange bound guarantees error below 10^(−5), and explain what the bound establishes.",["Tests the successive remainder bounds.","Concludes n=7.","States that the actual absolute error cannot exceed the calculated bound."]]
  ]},
  {unit:10,topic:"10.15",practice:1,difficulty:"Very Hard",mode:"no-calculator",archetype:"power-series-differential-equation",stimulus:"Find a power-series solution centered at x=0 for y′=xy with y(0)=1.",parts:[
    ["(a)","Let y=Σ[n=0 to ∞]a_nx^n. Derive a recurrence for the coefficients.",["Writes y′=Σ[n=0 to ∞](n+1)a_(n+1)x^n.","Matches coefficients with xy.","Obtains a_(n+1)=a_(n−1)/(n+1) for n≥1, with a₁=0."]],
    ["(b)","Write the first four nonzero terms and identify the elementary function represented.",["Uses a₀=1 and the recurrence.","Obtains 1+x²/2+x⁴/8+x⁶/48.","Recognizes y=e^(x²/2)."]],
    ["(c)","State and justify the radius of convergence.",["Uses the exponential-series representation or a ratio argument.","Concludes the radius is infinite."]],
    ["(d)","Find the coefficient of x^10.",["Obtains 1/(2⁵5!)=1/3840."]]
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
  8:"applications-of-integration",
  9:"parametric-polar-vector-valued-functions",
  10:"infinite-sequences-and-series"
};

function common(item,id,type) {
  return {
    schema_version:"1.0.0", package_id:id, content_key:id, content_version:1,
    difficulty:item.difficulty,
    exam_pack_ref:{exam_code:"ap_calculus_bc",school_year:"2026-27",exam_pack_version:"1.0.0"},
    item_type:type,
    archetype_ref:{archetype_key:type==="mcq"?"ap-calculus-bc-mcq":`ap-calculus-bc-frq-${item.archetype}`,version:"1.0.0"},
    taxonomy_refs:[
      {scheme_key:"ap-calculus-bc-2026-27",scheme_version:"1.0.0",node_key:`unit-${item.unit}-${unitNames[item.unit]}`},
      {scheme_key:"ap-calculus-bc-2026-27",scheme_version:"1.0.0",node_key:`topic-${item.topic}`},
      {scheme_key:"ap-calculus-bc-mathematical-practices",scheme_version:"1.0.0",node_key:`practice-${item.practice}`}
    ],
    accessibility:{language:"en",screen_reader_review_required:false,accommodation_notes:"All assessed mathematical information is available in text; notation requires normal math-reading support."}
  };
}

function packageMcq(item,index) {
  const id=`apcalcbc-mcq-${String(index+21).padStart(3,"0")}`;
  const choices=item.choices.map((choice,i)=>({choice_key:"ABCD"[i],choice_text:choice,is_correct:"ABCD"[i]===item.key,rationale:item.r[i]}));
  const pkg={
    ...common(item,id,"mcq"),
    stimuli:[{stimulus_key:"directions",ordinal:1,kind:"text",payload:{text:item.mode==="calculator"?"A graphing calculator is required.":"No calculator is permitted.",calculator_mode:item.mode},source_refs:[SOURCE_REF]}],
    mcq_choices:choices, canonical_answers:[item.key],
    parts:[{part_key:"question",ordinal:1,prompt:`${item.stem}\n\n${choices.map(c=>`${c.choice_key}. ${c.choice_text}`).join("\n")}`,stimulus_refs:["directions"],response_modalities:["choice"],points:1,criteria:[{criterion_key:"correct-answer",points:1,description:"Select the unique correct response.",required_evidence:[item.key,item.proof],accepted_variants:["Only a displayed choice that is mathematically identical to the keyed response may be treated as equivalent."],insufficient_responses:["An unkeyed choice without a valid ambiguity finding."],contradictions:["A choice or rationale that conflicts with the governing domain, units, or theorem conditions."],minimum_fix:"Select the keyed response after correcting the first invalid mathematical step.",deterministic_checks:[{check_type:"choice-key",parameters:{correct_key:item.key}}]}]}],
    review_notes:{expected_reasoning:item.proof,teaching_explanation:item.proof,minimum_fix:"Correct the first invalid mathematical step, then recompute without changing the problem conditions.",transfer_candidate:`Create a new item assessing Topic ${item.topic} with different values and a different representation.`,delayed_retrieval_candidate:`Reassess Topic ${item.topic} after a delay without reusing this stem or choices.`,known_boundary_cases:["Reject if more than one displayed choice becomes correct under a reasonable interpretation.","Check that the keyed choice is not identifiable by length, grammar, or precision alone."],originality_statement:ORIGINALITY},
    provenance:{source_refs:[SOURCE_REF],fact_pack_version:"2026-07-28",authoring_prompt_version:"CALCULUS_BC_CONTENT_BATCH_2026_07_28",generated_by:"codex",generated_at:GENERATED_AT}
  };
  pkg.provenance.content_sha256=sha(JSON.stringify(pkg));
  return pkg;
}

function packageFrq(item,index) {
  const id=`apcalcbc-frq-${String(index+17).padStart(3,"0")}`;
  const parts=item.parts.map(([label,prompt,criteria],partIndex)=>({
    part_key:`part-${"abcde"[partIndex]}`,ordinal:partIndex+1,label,prompt,stimulus_refs:["scenario"],response_modalities:["typed-text","typed-math"],points:criteria.length,
    criteria:criteria.map((description,criterionIndex)=>({
      criterion_key:`part-${"abcde"[partIndex]}-criterion-${criterionIndex+1}`,points:1,description,required_evidence:[description],
      accepted_variants:["Any mathematically equivalent expression, valid reasoning path, or appropriately rounded value supported by the student's setup."],
      insufficient_responses:["A correct number without required setup, justification, interpretation, or units when that evidence is named in the criterion."],
      contradictions:["Do not award the criterion when the response directly contradicts the required mathematical relationship or contextual meaning."],
      minimum_fix:`Add or correct the evidence needed to establish: ${description}`,
      deterministic_checks:[{check_type:"criterion-points",parameters:{expected_points:1}}]
    }))
  }));
  const pkg={
    ...common(item,id,"frq"), frq_form:"long",
    canonical_answers:[parts.flatMap(p=>p.criteria.map(c=>c.description)).join(" | ")],
    stimuli:[{stimulus_key:"scenario",ordinal:1,kind:"text",payload:{text:item.stimulus,calculator_mode:item.mode},source_refs:[SOURCE_REF]}],
    parts,
    scoring_contract:{total_points:9,part_count:parts.length,calculator_mode:item.mode,carry_forward_rule:"A later criterion may earn when the student's earlier arithmetic error is carried forward consistently and the later reasoning remains valid.",rounding_rule:"Accept exact values or values correctly rounded to the precision requested.",units_rule:"Units are required only when a criterion or prompt explicitly requests contextual units.",ambiguity_rule:"Escalate responses that use a valid but unlisted interpretation rather than forcing a score."},
    development_cases:{full_credit:"Provides all required setup, values, justifications, interpretations, and units.",partial_credit:"Shows a valid method for multiple criteria but omits or misstates at least one independently required piece of evidence.",no_credit:"Provides no relevant calculus relationship or only unsupported answers.",equivalent:"Uses algebraically equivalent forms or a different valid theorem-based argument.",contradictory:"States a correct value but also asserts an incompatible sign, interval, unit, or conclusion.",ambiguous:"Contains notation whose intended mathematical meaning cannot be determined reliably."},
    review_notes:{expected_reasoning:parts.flatMap(p=>p.criteria.map(c=>c.description)).join(" | "),teaching_explanation:"Connect each awarded point to the stated calculus relationship and the evidence shown in the response.",minimum_fix:"Repair the earliest missing setup or justification needed for the next unearned criterion.",transfer_candidate:`Create a new ${item.archetype} task with a different context, representation, and numerical structure.`,delayed_retrieval_candidate:`Reassess Topic ${item.topic} later with a different function family and no shared wording.`,known_boundary_cases:["Award criteria independently when the exam task permits.","Do not award interpretation or justification points for a bare numerical answer.","Use carry-forward only when later reasoning remains mathematically valid."],originality_statement:ORIGINALITY},
    provenance:{source_refs:[SOURCE_REF],fact_pack_version:"2026-07-28",authoring_prompt_version:"CALCULUS_BC_CONTENT_BATCH_2026_07_28",generated_by:"codex",generated_at:GENERATED_AT}
  };
  pkg.provenance.content_sha256=sha(JSON.stringify(pkg));
  return pkg;
}

await mkdir(OUT,{recursive:true});
const mcqPackages=mcq.map(packageMcq);
const frqPackages=frq.map(packageFrq);
for (const pkg of [...mcqPackages,...frqPackages]) await writeFile(`${OUT}/${pkg.package_id}.json`,`${JSON.stringify(pkg,null,2)}\n`);

let md="# AP Calculus BC Practice Packet — 30 MCQs and 20 FRQs\n\n";
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
