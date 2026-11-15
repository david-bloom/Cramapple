# AP Calculus AB topics 2.1 to 2.10: harder second seeds (Unit 2)

DRAFT for owner review. Author-in-session; not checked by a checker; not in the database. Every key recomputed in Python (derivatives, limits, tangent conditions). Calculator-free; no images; no chain rule (Unit 3).
Target level: R3 interpretation, multi-step reasoning and error analysis. Seed A and seed B in each topic test different skills; variants keep the skill with new functions, contexts and wrong-answer structures.

| Seed | Topic | Replaces |
|---|---|---|
| N-2.1-A | 2.1 Defining Average and Instantaneous Rates | new |
| N-2.1-B | 2.1 Defining Average and Instantaneous Rates | new |
| N-2.2-A | 2.2 Defining the Derivative of a Function an | new |
| N-2.2-B | 2.2 Defining the Derivative of a Function an | new |
| N-2.3-A | 2.3 Estimating Derivatives of a Function at  | new |
| N-2.3-B | 2.3 Estimating Derivatives of a Function at  | new |
| N-2.4-A | 2.4 Connecting Differentiability and Continu | new |
| N-2.4-B | 2.4 Connecting Differentiability and Continu | new |
| N-2.5-A | 2.5 Applying the Power Rule | new |
| N-2.5-B | 2.5 Applying the Power Rule | new |
| N-2.6-A | 2.6 Derivative Rules: Constant, Sum, Differe | new |
| N-2.6-B | 2.6 Derivative Rules: Constant, Sum, Differe | new |
| N-2.7-A | 2.7 Derivatives of cos x, sin x, e^x, and ln | new |
| N-2.7-B | 2.7 Derivatives of cos x, sin x, e^x, and ln | new |
| N-2.8-A | 2.8 The Product Rule | new |
| N-2.8-B | 2.8 The Product Rule | new |
| N-2.9-A | 2.9 The Quotient Rule | new |
| N-2.9-B | 2.9 The Quotient Rule | new |
| N-2.10-A | 2.10 Derivatives of tan x, cot x, sec x, and  | new |
| N-2.10-B | 2.10 Derivatives of tan x, cot x, sec x, and  | new |

---

## Seed N-2.1-A (new) — Topic 2.1 Defining Average and Instantaneous Rates of Change at a Point
**Skill:** relate the average rate of change over an interval to the instantaneous rate for a quadratic position function, solving for the time.

A particle moves along a line so that its position is s(t) = t² − 5t + 3 meters at time t seconds. At what time t, with 1 < t < 7, is the instantaneous velocity equal to the average velocity over the interval [1, 7]?

- **A. t = 4 seconds**
- B. t = 3 seconds
- C. t = 5/2 seconds
- D. t = 23/2 seconds
Check: The average velocity is (s(7) − s(1))/6 = (17 − (−1))/6 = 3. Setting s′(t) = 2t − 5 = 3 gives t = 4, which lies in (1, 7).
Rationales: B: The number 3 is the value of the average velocity in meters per second, not a time. The time comes from solving s′(t) = 3. C: Solving s′(t) = 2t − 5 = 0 finds when the particle is momentarily at rest, which is a different question from matching the average velocity. D: This solves 2t − 5 = 18, using the total change s(7) − s(1) = 18 without dividing by the interval length 6. The result also lies outside the interval (1, 7).

**N-2.1-A-v1.** A cyclist's position along a straight road is s(t) = t² − 6t + 1 meters at time t seconds. At what time t, with 2 < t < 8, is the instantaneous velocity equal to the average velocity over the interval [2, 8]?

- **A. t = 5 seconds**
- B. t = 4 seconds
- C. t = 3 seconds
- D. t = 15 seconds
Check: The average velocity is (s(8) − s(2))/6 = (17 − (−7))/6 = 4. Setting s′(t) = 2t − 6 = 4 gives t = 5.
Rationales: B: The value 4 is the average velocity in meters per second, not a time. The time comes from solving s′(t) = 4. C: Solving 2t − 6 = 0 gives the instant the cyclist is momentarily at rest, not the instant that matches the average velocity. D: This solves 2t − 6 = 24, using the total change s(8) − s(2) = 24 without dividing by the length 6 of the interval. The answer is also outside (2, 8).

**N-2.1-A-v2.** A ball is thrown upward from the ground so that its height is h(t) = −5t² + 30t meters after t seconds. At what time t, with 0 < t < 4, is the instantaneous velocity equal to the average velocity over the interval [0, 4]?

- **A. t = 2 seconds**
- B. t = 10 seconds
- C. t = 3 seconds
- D. t = 4 seconds
Check: The average velocity is (h(4) − h(0))/4 = 40/4 = 10. Setting h′(t) = −10t + 30 = 10 gives t = 2, which lies in (0, 4).
Rationales: B: The number 10 is the average velocity in meters per second, not a time. The time comes from solving h′(t) = 10. C: Solving −10t + 30 = 0 gives t = 3, the time of the ball's highest point, where the velocity is zero. That is not the instant matching the average velocity. D: The endpoint t = 4 is where the interval ends. The average over [0, 4] says nothing about the endpoint velocity, which is h′(4) = −10, not the average 10.

**N-2.1-A-v3.** The volume of liquid in a vat is V(t) = 3t² − 12t liters after t minutes. At what time t, with 0 < t < 5, is the instantaneous rate of change of volume equal to the average rate of change over [0, 5]?

- **A. t = 5/2 minutes**
- B. t = 3 minutes
- C. t = 2 minutes
- D. t = 9/2 minutes
Check: The average rate is (V(5) − V(0))/5 = 15/5 = 3. Setting V′(t) = 6t − 12 = 3 gives t = 5/2.
Rationales: B: The value 3 is the average rate in liters per minute, not a time. The time comes from solving V′(t) = 3. C: Solving 6t − 12 = 0 gives the minimum volume at t = 2, where the rate is zero. That is a different condition from matching the average rate. D: This solves 6t − 12 = 15, using V(5) − V(0) = 15 without dividing by the interval length 5 to form the average rate.

---

## Seed N-2.1-B (new) — Topic 2.1 Defining Average and Instantaneous Rates of Change at a Point
**Skill:** decide what a net change over an interval does and does not tell you: average rate, not instantaneous rate or constant rate.

The amount of water in a tank is W(t) gallons, where t is measured in hours. It is known that W(2) = 90 and W(8) = 60. Which statement must be true?

- A. W′(5) = −5 gallons per hour.
- **B. The net change in the water from t = 2 to t = 8 is −30 gallons, so the average rate of change over that interval is −5 gallons per hour.**
- C. The tank lost exactly 5 gallons during every hour from t = 2 to t = 8.
- D. The average rate of change of the water from t = 2 to t = 8 is −30 gallons per hour.
Check: The net change is W(8) − W(2) = −30 gallons over 6 hours, so the average rate is −30/6 = −5 gallons per hour. Only this average is guaranteed by two data points.
Rationales: A: The average rate over [2, 8] need not equal the instantaneous rate at the midpoint. W′(5) could be any value, since only the two endpoint values are known. C: An average of −5 gallons per hour is compatible with a leak that speeds up and slows down. The data do not show a constant rate in each hour. D: The net change −30 is the change in gallons, not a rate. It must be divided by the interval length 6 hours to get the average rate in gallons per hour.

**N-2.1-B-v1.** The temperature of an oven is T(t) degrees Celsius after t minutes. It is known that T(10) = 180 and T(25) = 255. Which statement must be true?

- A. T′(17.5) = 5 degrees Celsius per minute.
- **B. The temperature rose by a net 75 degrees Celsius from t = 10 to t = 25, an average of 5 degrees Celsius per minute.**
- C. The oven was heating at 5 degrees Celsius per minute at the moment t = 25.
- D. The average rate of change of temperature on [10, 25] is 75 degrees Celsius per minute.
Check: The net change is T(25) − T(10) = 75 degrees over 15 minutes, so the average rate of change is 75/15 = 5 degrees Celsius per minute.
Rationales: A: The midpoint of [10, 25] is 17.5, but an average rate over an interval does not force the instantaneous rate at the midpoint to equal it. C: The average over [10, 25] says nothing specific about the rate at the endpoint t = 25, where the oven could be heating faster or slower. D: The change of 75 degrees must be divided by the 15-minute length of the interval. As a rate, 75 degrees per minute is far too large.

**N-2.1-B-v2.** The number of subscribers to a service is N(m) thousand, where m is the number of months since launch. It is known that N(4) = 120 and N(10) = 84. Which statement must be true?

- A. The number of subscribers grew by an average of 6 thousand per month from m = 4 to m = 10.
- **B. The number of subscribers fell by a net 36 thousand from m = 4 to m = 10, an average of 6 thousand per month.**
- C. N′(7) = −6 thousand subscribers per month.
- D. N(7) = 102 thousand subscribers.
Check: N(10) − N(4) = −36 thousand over 6 months, so the average rate is −6 thousand per month. Neither the midpoint value nor the midpoint rate is determined.
Rationales: A: The values show a decrease: N(10) − N(4) = −36. Reporting the average as positive is a sign error from subtracting in the wrong order. C: The average rate over [4, 10] does not determine the instantaneous rate at the midpoint m = 7, which can differ from the average. D: N(7) = 102 assumes the number changed linearly between the two data points. With only two values, N(7) could be anything.

**N-2.1-B-v3.** The depth of a river is D(x) meters at a point x meters from the bank. It is known that D(2) = 3.5 and D(10) = 1.5. Which statement must be true?

- A. The depth decreases by exactly 0.25 meter for each meter moved from x = 2 to x = 10.
- **B. The depth decreases by a net 2 meters from x = 2 to x = 10, an average of 0.25 meter of depth per meter of distance.**
- C. The average rate of change of depth on [2, 10] is −2 meters per meter.
- D. D(6) = 2.5 meters.
Check: The net change is D(10) − D(2) = −2 meters over 8 meters of distance, an average rate of −2/8 = −0.25 meter per meter (a decrease of 0.25).
Rationales: A: The average rate −0.25 does not mean the depth falls at that rate over every single meter. The riverbed may be steep in places and flat in others. C: The net change −2 meters must be divided by the 8-meter length of the interval. Its average rate is −2/8 = −0.25 meter per meter. D: D(6) = 2.5 assumes the depth changes linearly between the two readings. Two values do not determine the depth at x = 6.

---

## Seed N-2.2-A (new) — Topic 2.2 Defining the Derivative of a Function and Using Derivative Notation
**Skill:** identify the function and point behind a difference-quotient limit and evaluate it as a derivative.

The limit lim(x→3) (x⁴ − 81)/(x − 3) equals f′(a) for some function f and number a. What is the value of the limit?

- A. 81
- B. 324
- **C. 108**
- D. 12
Check: With f(x) = x⁴ and a = 3, the limit is f′(3) = 4 · 3³ = 108.
Rationales: A: The number 81 is f(3) for f(x) = x⁴, not the derivative. The limit is the slope f′(3), not the function value. B: This differentiates x⁴ as 4x⁴, keeping the exponent 4 instead of lowering it to 3. The correct power rule gives 4x³. D: This computes 4 · 3 instead of 4 · 3³. It lowers the exponent in the original function but then forgets to apply it to the evaluated point.

**N-2.2-A-v1.** The limit lim(x→2) (x⁵ − 32)/(x − 2) equals f′(a) for some function f and number a. What is the value of the limit?

- A. 32
- B. 160
- **C. 80**
- D. 10
Check: With f(x) = x⁵ and a = 2, the limit is f′(2) = 5 · 2⁴ = 80.
Rationales: A: The number 32 is f(2) for f(x) = x⁵, not f′(2). The limit is a slope, not a function value. B: This computes 5 · 2⁵, keeping the exponent at 5 instead of lowering it to 4. The correct power rule gives 5x⁴. D: This computes 5 · 2, lowering the exponent but not applying it to the evaluated point. The correct value is 5 · 2⁴.

**N-2.2-A-v2.** The limit lim(h→0) [(1 + h)⁻² − 1]/h equals f′(a) for some function f and number a. What is the value of the limit?

- A. 2
- B. 0
- **C. −2**
- D. 1
Check: With f(x) = x⁻² and a = 1, the limit is f′(1) = −2 · 1⁻³ = −2.
Rationales: A: This drops the negative sign. Differentiating x⁻² gives −2x⁻³, which is negative at x = 1. B: Substituting h = 0 gives the form 0/0. It does not mean the limit equals zero; the limit is the derivative of x⁻² at 1. D: The number 1 is f(1) = 1⁻², the function value rather than the derivative at x = 1.

**N-2.2-A-v3.** The limit lim(x→−2) (x³ + 8)/(x + 2) equals f′(a) for some function f and number a. What is the value of the limit?

- A. −8
- B. −6
- **C. 12**
- D. 0
Check: With f(x) = x³ and a = −2, the limit is f′(−2) = 3(−2)² = 12.
Rationales: A: The number −8 is f(−2) = (−2)³, not the derivative. The limit is the slope of f at −2. B: This uses 3x instead of 3x², so it does not square −2. The power rule gives f′(x) = 3x², which is positive. D: The numerator and denominator both approach 0, but that does not make the limit 0. It is f′(−2) for f(x) = x³.

---

## Seed N-2.2-B (new) — Topic 2.2 Defining the Derivative of a Function and Using Derivative Notation
**Skill:** find the error in a limit-definition derivation where f(x + h) is expanded incorrectly, and state the correct derivative.

A student uses the definition to find f′(x) for f(x) = x². The student writes f(x + h) = x² + h², so [f(x + h) − f(x)]/h = h²/h = h, and concludes f′(x) = lim(h→0) h = 0. Which statement identifies the error and gives the correct derivative?

- A. (x + h)² = x² + 2xh + h², so the correct derivative is 2x + h.
- B. There is no error. The terms in h vanish as h → 0, so the derivative of x² is 0 for every x.
- C. (x + h)² = x² + 2xh + h², so the correct derivative is 2.
- **D. (x + h)² = x² + 2xh + h², not x² + h², so the correct derivative is f′(x) = 2x.**
Check: The correct expansion gives [x² + 2xh + h² − x²]/h = 2x + h, whose limit as h → 0 is 2x.
Rationales: A: This finds the right expansion but stops before taking the limit. The difference quotient is 2x + h, and the derivative is its limit as h → 0, which is 2x. B: The squared binomial has a middle term 2xh that the student dropped. A derivative of 0 would make x² constant, which it is not. C: This divides 2xh by xh instead of by h, losing a factor of x. The difference quotient is 2x + h, which tends to 2x.

**N-2.2-B-v1.** A student uses the definition to find f′(x) for f(x) = x³. The student writes f(x + h) = x³ + h³, so [f(x + h) − f(x)]/h = h³/h = h², and concludes f′(x) = lim(h→0) h² = 0. Which statement identifies the error and gives the correct derivative?

- A. (x + h)³ = x³ + 3x²h + 3xh² + h³, so the correct derivative is 3x² + 3xh + h².
- B. There is no error. Both h² and h vanish as h → 0, so the derivative of x³ is 0.
- C. (x + h)³ = x³ + 3x²h + 3xh² + h³, so the correct derivative is 3x.
- **D. (x + h)³ = x³ + 3x²h + 3xh² + h³, not x³ + h³, so the correct derivative is f′(x) = 3x².**
Check: The correct expansion gives [3x²h + 3xh² + h³]/h = 3x² + 3xh + h², whose limit as h → 0 is 3x².
Rationales: A: This stops before taking the limit. The difference quotient is 3x² + 3xh + h², and the derivative is its limit as h → 0, which is 3x². B: The cube expansion has two cross terms the student dropped. A derivative of 0 would make x³ constant, which it is not. C: This lowers the exponent but loses a factor of x. The terms 3x²h and 3xh² give a difference quotient that tends to 3x², not 3x.

**N-2.2-B-v2.** A student uses the definition to find f′(x) for f(x) = 1/x. The student writes 1/(x + h) = 1/x + 1/h, so the numerator is 1/h and the quotient is 1/h², and concludes the derivative does not exist. Which statement identifies the error and gives the correct derivative?

- A. 1/(x + h) is not 1/x + 1/h; using a common denominator gives f′(x) = 1/x².
- B. There is no error. The quotient 1/h² is unbounded as h → 0, so 1/x has no derivative.
- C. 1/(x + h) is not 1/x + 1/h; using a common denominator gives f′(x) = −1/x.
- **D. 1/(x + h) is not 1/x + 1/h; using a common denominator gives f′(x) = −1/x².**
Check: [1/(x + h) − 1/x]/h = [x − (x + h)]/[x(x + h)h] = −1/[x(x + h)], whose limit as h → 0 is −1/x².
Rationales: A: This finds the right fix but loses the sign. The numerator x − (x + h) equals −h, so the limit is negative. B: A reciprocal of a sum is not the sum of reciprocals. The function 1/x is differentiable for x ≠ 0, so the conclusion is wrong. C: This keeps the sign but misses the factor 1/x² in the common denominator. The limit of −1/(x(x + h)) is −1/x², not −1/x.

**N-2.2-B-v3.** A student uses the definition to find f′(x) for f(x) = √x with x > 0. The student writes √(x + h) = √x + √h, so the quotient is √h/h = 1/√h, and concludes the derivative does not exist. Which statement identifies the error and gives the correct derivative?

- A. √(x + h) is not √x + √h; multiplying by the conjugate gives f′(x) = 1/√x.
- B. There is no error. The quotient 1/√h is unbounded as h → 0, so √x has no derivative for x > 0.
- C. √(x + h) is not √x + √h; multiplying by the conjugate gives f′(x) = 1/(2x).
- **D. √(x + h) is not √x + √h; multiplying by the conjugate gives f′(x) = 1/(2√x).**
Check: [√(x + h) − √x]/h = 1/[√(x + h) + √x], whose limit as h → 0 is 1/(2√x).
Rationales: A: This multiplies by the conjugate correctly but drops the 2. The denominator √(x + h) + √x tends to 2√x, not √x. B: A square root of a sum is not the sum of square roots. The function √x is differentiable for every x > 0. C: This keeps the factor 2 but replaces √x with x in the denominator. The conjugate denominator tends to 2√x.

---

## Seed N-2.3-A (new) — Topic 2.3 Estimating Derivatives of a Function at a Point
**Skill:** estimate acceleration from a table of velocity values with uneven spacing, then use the signs of velocity and acceleration to decide whether the object is speeding up.

The velocity v(t), in meters per second, of a car moving along a straight road is given in the table for selected times t in seconds.
t (seconds):   0   3   7   12
v(t) (m/s):   −4   −10   −16   −22
Using the table values closest to t = 5, which statement is best at t = 5?

- **A. The acceleration is about −1.5 m/s² and the car is speeding up.**
- B. The acceleration is about −1.5 m/s² and the car is slowing down.
- C. The acceleration is about −6 m/s² and the car is speeding up.
- D. The acceleration is about 1.5 m/s² and the car is slowing down.
Check: a(5) ≈ (v(7) − v(3))/(7 − 3) = (−16 − (−10))/4 = −1.5 m/s². Since v < 0 and a < 0, the speed is increasing.
Rationales: B: Velocity and acceleration have the same sign (both negative), so the speed is increasing. A negative acceleration slows an object down only when the velocity is positive. C: The change in velocity over [3, 7] is −6, but it must be divided by the interval length 4 to estimate acceleration. D: This subtracts the values in the wrong order, giving +1.5 instead of −1.5. The velocity is becoming more negative, so the acceleration estimate is negative.

**N-2.3-A-v1.** The velocity v(t), in meters per second, of a cart on a track is given in the table for selected times t in seconds.
t (seconds):   0   2   6   10
v(t) (m/s):   12   9   3   1
Using the table values closest to t = 4, which statement is best at t = 4?

- **A. The acceleration is about −1.5 m/s² and the cart is slowing down.**
- B. The acceleration is about −1.5 m/s² and the cart is speeding up.
- C. The acceleration is about −6 m/s² and the cart is slowing down.
- D. The acceleration is about −0.5 m/s² and the cart is slowing down.
Check: a(4) ≈ (v(6) − v(2))/(6 − 2) = (3 − 9)/4 = −1.5 m/s². Since v > 0 and a < 0, the speed is decreasing.
Rationales: B: Here the velocity is positive and the acceleration negative, so the speed decreases. Treating a negative acceleration as always meaning speeding up reverses the conclusion. C: The change in velocity over [2, 6] is −6, but it must be divided by the interval length 4 to get the acceleration. D: This uses the interval [6, 10], which does not contain t = 4. The estimate needs the interval that straddles t = 4, namely [2, 6].

**N-2.3-A-v2.** The velocity v(t), in feet per second, of a boat on a river is given in the table for selected times t in seconds.
t (seconds):   0   4   10   16
v(t) (ft/s):   −20   −14   −5   −2
Using the table values closest to t = 7, which statement is best at t = 7?

- **A. The acceleration is about 1.5 ft/s² and the boat is slowing down.**
- B. The acceleration is about 1.5 ft/s² and the boat is speeding up.
- C. The acceleration is about 9 ft/s² and the boat is slowing down.
- D. The acceleration is about 0.5 ft/s² and the boat is slowing down.
Check: a(7) ≈ (v(10) − v(4))/(10 − 4) = (−5 − (−14))/6 = 1.5 ft/s². Since v < 0 and a > 0, the speed is decreasing.
Rationales: B: The velocity is negative and the acceleration positive, so the velocity is moving toward zero and the speed is decreasing. A positive acceleration does not always mean speeding up. C: The change in velocity over [4, 10] is 9, but it must be divided by the interval length 6 to estimate acceleration. D: This uses the interval [10, 16], which does not contain t = 7. The estimate needs the interval [4, 10].

**N-2.3-A-v3.** The velocity v(t), in centimeters per second, of a robot arm is given in the table for selected times t in seconds.
t (seconds):   0   5   8   14
v(t) (cm/s):   3   8   20   26
Using the table values closest to t = 6, which statement is best at t = 6?

- **A. The acceleration is about 4 cm/s² and the arm is speeding up.**
- B. The acceleration is about 4 cm/s² and the arm is slowing down.
- C. The acceleration is about 12 cm/s² and the arm is speeding up.
- D. The acceleration is about 1 cm/s² and the arm is speeding up.
Check: a(6) ≈ (v(8) − v(5))/(8 − 5) = (20 − 8)/3 = 4 cm/s². Since v > 0 and a > 0, the speed is increasing.
Rationales: B: Velocity and acceleration are both positive, so the speed is increasing. Calling it slowing down confuses a positive acceleration with a deceleration. C: The change in velocity over [5, 8] is 12, but it must be divided by the interval length 3 to estimate acceleration. D: This uses the interval [8, 14], which does not contain t = 6. The estimate needs the interval [5, 8].

---

## Seed N-2.3-B (new) — Topic 2.3 Estimating Derivatives of a Function at a Point
**Skill:** use the monotonic behaviour of f′ to bracket f′(a) between the slopes of secant lines on either side of a.

The table gives selected values of a differentiable function f. It is also known that f′ is increasing on the interval [2, 10].
x:   2   5   10
f(x):   7   13   31
Which statement about f′(5) must be true?

- A. f′(5) = 2.8
- **B. 2 < f′(5) < 3.6**
- C. f′(5) > 3.6
- D. f′(5) < 2
Check: The secant slope on [2, 5] is (13 − 7)/3 = 2 and on [5, 10] is (31 − 13)/5 = 3.6. With f′ increasing, f′(5) lies strictly between them.
Rationales: A: The average of the two secant slopes is 2.8, but with only three data points nothing forces f′(5) to equal it. C: The slope of the secant over [5, 10] is 3.6. Since f′ is increasing, f′(5) is below the average of f′ on [5, 10], so f′(5) < 3.6. D: The slope of the secant over [2, 5] is 2. Since f′ is increasing, f′(5) is above the average of f′ on [2, 5], so f′(5) > 2.

**N-2.3-B-v1.** The table gives selected values of a differentiable function f. It is also known that f′ is decreasing on the interval [1, 9].
x:   1   4   9
f(x):   10   25   40
Which statement about f′(4) must be true?

- A. f′(4) = 4
- **B. 3 < f′(4) < 5**
- C. f′(4) > 5
- D. f′(4) < 3
Check: The secant slopes are (25 − 10)/3 = 5 on [1, 4] and (40 − 25)/5 = 3 on [4, 9]. With f′ decreasing, f′(4) lies between 3 and 5.
Rationales: A: The average of the two secant slopes is 4, but nothing in the data forces f′(4) to equal it. C: The slope of the secant over [1, 4] is 5. Since f′ is decreasing, f′(4) is below the average of f′ on [1, 4], so f′(4) < 5. D: The slope of the secant over [4, 9] is 3. Since f′ is decreasing, f′(4) is above the average of f′ on [4, 9], so f′(4) > 3.

**N-2.3-B-v2.** The table gives selected values of a differentiable function g. It is also known that g′ is increasing on the interval [0, 4].
x:   0   3   4
g(x):   2   8   12
Which statement about g′(3) must be true?

- A. g′(3) = 2.5
- **B. 2 < g′(3) < 4**
- C. g′(3) > 4
- D. g′(3) < 2
Check: The secant slopes are (8 − 2)/3 = 2 on [0, 3] and (12 − 8)/1 = 4 on [3, 4]. With g′ increasing, g′(3) lies between 2 and 4.
Rationales: A: The slope of the secant over [0, 4] is 2.5, but the endpoint-to-endpoint slope is not guaranteed to equal g′(3) at an interior point. C: The slope of the secant over [3, 4] is 4. Since g′ is increasing, g′(3) is below the average of g′ on [3, 4], so g′(3) < 4. D: The slope of the secant over [0, 3] is 2. Since g′ is increasing, g′(3) is above the average of g′ on [0, 3], so g′(3) > 2.

**N-2.3-B-v3.** The table gives the population P(t), in thousands, of a town at selected times t in years. It is also known that P′ is decreasing on the interval [2, 8].
t:   2   6   8
P(t):   50   90   100
Which statement about P′(6) must be true?

- A. P′(6) = 7.5
- **B. 5 < P′(6) < 10**
- C. P′(6) > 10
- D. P′(6) < 5
Check: The secant slopes are (90 − 50)/4 = 10 on [2, 6] and (100 − 90)/2 = 5 on [6, 8]. With P′ decreasing, P′(6) lies between 5 and 10.
Rationales: A: The average of the two secant slopes is 7.5, but the data do not force P′(6) to equal it. C: The slope of the secant over [2, 6] is 10 thousand per year. Since P′ is decreasing, P′(6) is below the average of P′ on [2, 6], so P′(6) < 10. D: The slope of the secant over [6, 8] is 5 thousand per year. Since P′ is decreasing, P′(6) is above the average of P′ on [6, 8], so P′(6) > 5.

---

## Seed N-2.4-A (new) — Topic 2.4 Connecting Differentiability and Continuity
**Skill:** choose constants that make a piecewise function both continuous and differentiable at the join, using the slopes and values of both pieces.

The function f is defined by f(x) = x³ for x ≤ 1 and f(x) = ax + b for x > 1. For which values of a and b is f differentiable at x = 1?

- A. a = 3 and b = 1
- B. a = 1 and b = 0
- **C. a = 3 and b = −2**
- D. a = 3 and b = 2
Check: Continuity needs a(1) + b = 1³ = 1. Equal slopes need a = 3x² at x = 1, so a = 3, and then b = 1 − 3 = −2.
Rationales: A: Matching the slope gives a = 3, but b = 1 leaves the pieces disconnected: 3 + 1 = 4 does not equal f(1) = 1, so f is not even continuous. B: Continuity alone holds with a + b = 1, but the slopes are 3 and 1, so the graph has a corner at x = 1 and f is not differentiable there. D: This sets a = 3 correctly but solves a − b = 1 instead of a + b = 1. At x = 1 the right piece is 3 + 2 = 5, not 1.

**N-2.4-A-v1.** The function f is defined by f(x) = ax² + b for x ≤ 2 and f(x) = x³ − 2x for x > 2. For which values of a and b is f differentiable at x = 2?

- A. a = 1 and b = 0
- B. a = 5/2 and b = 4
- **C. a = 5/2 and b = −6**
- D. a = 5/2 and b = −14
Check: Continuity needs 4a + b = 2³ − 2(2) = 4. Equal slopes need 2a(2) = 3(2²) − 2 = 10, so a = 5/2, and then b = 4 − 10 = −6.
Rationales: A: Continuity needs 4a + b = 4, which a = 1, b = 0 satisfies, but the slopes are 4 and 10, so f has a corner at x = 2. B: This matches the slopes with a = 5/2 but sets b equal to the right-hand value 4, forgetting that b = 4 − 4a. Then 4a + b = 14, so f jumps. D: This matches the slopes but solves 4a + b = −4 instead of 4. The pieces then disagree at x = 2, so f is not continuous.

**N-2.4-A-v2.** The function f is defined by f(x) = ax + b for x ≤ 2 and f(x) = 1/x for x > 2. For which values of a and b is f differentiable at x = 2?

- A. a = −1/4 and b = 1/2
- B. a = 1/4 and b = 0
- **C. a = −1/4 and b = 1**
- D. a = −1/4 and b = 0
Check: Continuity needs 2a + b = 1/2. Equal slopes need a = −1/x² at x = 2, so a = −1/4, and then b = 1/2 + 1/2 = 1.
Rationales: A: The slope matches with a = −1/4, but b = 1/2 is the value of 1/x at 2 and ignores that the left piece must equal 1/2 at x = 2, which requires 2a + b = 1/2. B: This uses the slope of 1/x with the wrong sign. The derivative of 1/x is −1/x², which is −1/4 at x = 2. D: With a = −1/4 and b = 0 the left piece equals −1/2 at x = 2, not 1/2, so f is not continuous.

**N-2.4-A-v3.** The function f is defined by f(x) = ax² + bx for x ≤ 1 and f(x) = 2 ln x + 3 for x > 1. For which values of a and b is f differentiable at x = 1?

- A. a = 1 and b = 2
- B. a = 1 and b = 0
- **C. a = −1 and b = 4**
- D. a = 2 and b = −2
Check: Continuity needs a + b = 2 ln 1 + 3 = 3. Equal slopes need 2a + b = 2/x = 2 at x = 1. Subtracting gives a = −1, so b = 4.
Rationales: A: This satisfies continuity (1 + 2 = 3), but the left slope is 2a + b = 4 while the right slope is 2, so the graph has a corner at x = 1. B: The slope condition 2a + b = 2 holds, but a + b = 1 while the right piece equals 3 at x = 1, so f has a jump at x = 1. D: This ignores the +3 in the right piece, matching a + b to 2 ln 1 = 0. The right piece actually equals 3 at x = 1, so f has a jump there.

---

## Seed N-2.4-B (new) — Topic 2.4 Connecting Differentiability and Continuity
**Skill:** count the points where the absolute value of a polynomial fails to be differentiable by telling simple roots from repeated roots.

Let f(x) = |(x − 2)²(x + 1)|. At how many values of x is f not differentiable?

- A. 0
- B. 2
- C. 3
- **D. 1**
Check: Near x = 2, (x − 2)²(x + 1) is positive, so f equals the smooth polynomial there. Only the sign change at x = −1 produces a corner, so there is 1 point.
Rationales: A: The absolute value of a polynomial can have corners where the polynomial crosses zero. At x = −1 the factor x + 1 changes sign, so there is a corner there. B: Counting both zeros forgets that (x − 2)² does not change sign at x = 2. Near 2, f(x) = (x − 2)²(x + 1), which is smooth. C: Counting the roots with multiplicity (2 at x = 2 and 1 at x = −1) does not reflect where the graph has corners. Only a sign change creates one.

**N-2.4-B-v1.** Let f(x) = |x(x − 3)²(x + 2)|. At how many values of x is f not differentiable?

- A. 3
- B. 1
- C. 0
- **D. 2**
Check: The factors x and x + 2 each change sign once, giving corners at x = 0 and x = −2. The squared factor leaves f smooth at x = 3, so there are 2 points.
Rationales: A: Counting all three zeros ignores that (x − 3)² does not change sign at x = 3, so f is smooth there. B: Counting only one zero misses that both x and x + 2 change sign. Each simple root gives a corner in the absolute value. C: The absolute value is not automatically differentiable where the inside is. At a simple root such as x = 0 the one-sided slopes are opposite.

**N-2.4-B-v2.** Let f(x) = |(x − 1)³(x + 2)²|. At how many values of x is f not differentiable?

- A. 1
- B. 2
- C. 5
- **D. 0**
Check: At x = 1, f(x) = |x − 1|³(x + 2)², whose derivative from both sides is 0. At x = −2 the squared factor does not change sign. So f is differentiable everywhere.
Rationales: A: The triple root is a trap: (x − 1)³ changes sign, but |(x − 1)³| = |x − 1|³ has one-sided slopes that both equal 0 at x = 1, so there is no corner. B: Counting both distinct zeros assumes every zero produces a corner. A zero of order 2 or higher, with a vanishing derivative, does not. C: Adding the multiplicities (3 + 2) counts something unrelated to corners of the graph.

**N-2.4-B-v3.** Let f(x) = |x³ − 9x|. At how many values of x is f not differentiable?

- A. 1
- B. 2
- C. 0
- **D. 3**
Check: x³ − 9x = x(x − 3)(x + 3) has three simple roots at 0, 3 and −3. Each is a sign change with nonzero slope, so the absolute value has three corners.
Rationales: A: The zeros are x = 0, 3 and −3. Counting only x = 0 ignores that the polynomial also crosses zero at x = 3 and x = −3. B: Counting only the two nonzero roots forgets that the polynomial also changes sign at x = 0, where the factor x is simple. C: The absolute value is not smooth where a simple root makes the inside change sign. Each of the three crossings is a corner.

---

## Seed N-2.5-A (new) — Topic 2.5 Applying the Power Rule
**Skill:** find the points of tangency of lines drawn from an external point to a power-function curve.

Two lines pass through the point (1, −3) and are tangent to the graph of y = x². What are the x-coordinates of the points of tangency?

- **A. x = −1 and x = 3**
- B. x = 1
- C. x = 3
- D. x = −3 and x = 1
Check: The tangent at x = a is y = a² + 2a(x − a). It passes through (1, −3) when −3 = a² + 2a(1 − a), so a² − 2a − 3 = 0 and a = 3 or a = −1.
Rationales: B: The point (1, −3) is not on the parabola, since 1² = 1. It is the external point the lines pass through, not a point of tangency. C: This keeps only the positive solution. The equation a² − 2a − 3 = 0 has two roots, and the second line is tangent where x = −1. D: This factors a² − 2a − 3 as (a + 3)(a − 1), which expands to a² + 2a − 3. The correct factors are (a − 3)(a + 1).

**N-2.5-A-v1.** A line through the point (−2, 0) is tangent to the graph of y = √x. What is the x-coordinate of the point of tangency?

- **A. x = 2**
- B. x = −2
- C. x = 1
- D. x = 4
Check: The tangent at x = a is y = √a + (x − a)/(2√a). It passes through (−2, 0) when 0 = √a + (−2 − a)/(2√a), so 2a = 2 + a and a = 2.
Rationales: B: The point (−2, 0) is the external point the line passes through; it is not on the graph of √x, which is defined only for x ≥ 0. C: The point (1, 1) is on the curve, but the tangent there is y = 1 + (x − 1)/2, which crosses the x-axis at x = −1, not at −2. D: At x = 4 the tangent is y = 2 + (x − 4)/4, which crosses the x-axis at x = −4, not at −2.

**N-2.5-A-v2.** Two lines pass through the point (2, −5) and are tangent to the graph of y = x². What are the x-coordinates of the points of tangency?

- **A. x = −1 and x = 5**
- B. x = 5
- C. x = 2
- D. x = 1 and x = −5
Check: The tangent at x = a is y = a² + 2a(x − a). It passes through (2, −5) when −5 = a² + 2a(2 − a), so a² − 4a − 5 = 0 and a = 5 or a = −1.
Rationales: B: This keeps only the positive root of a² − 4a − 5 = 0. The second solution a = −1 gives a second tangent line. C: The x-coordinate of the given point is 2, but the point (2, −5) is not on the parabola (where y would be 4). It is the external point. D: This factors a² − 4a − 5 as (a − 1)(a + 5), which expands to a² + 4a − 5. The correct factors are (a − 5)(a + 1).

**N-2.5-A-v3.** A line through the point (3, 0) is tangent to the graph of y = 1/x for x > 0. What is the x-coordinate of the point of tangency?

- **A. x = 3/2**
- B. x = 3
- C. x = 2/3
- D. x = 1/3
Check: The tangent at x = a is y = 2/a − x/a². It passes through (3, 0) when 2/a = 3/a², so a = 3/2.
Rationales: B: The x-coordinate of the given point is 3, but that is where the line crosses the x-axis. The point of tangency is on the curve, so its y-coordinate is not 0. C: This inverts the answer. At x = 2/3 the tangent line is y = 3 − (9/4)x, which crosses the x-axis at x = 4/3, not at 3. D: At x = 1/3 the tangent has slope −9 and meets the x-axis at x = 2/3, not 3.

---

## Seed N-2.5-B (new) — Topic 2.5 Applying the Power Rule
**Skill:** use the power rule to find where a rate of change numerically equals the quantity itself in a geometric context.

The volume of a cube with side length s centimeters is V(s) = s³ cubic centimeters. For what positive side length is the rate of change of V with respect to s, in cubic centimeters per centimeter, numerically equal to V?

- A. s = √3
- **B. s = 3**
- C. s = 6
- D. s = 1/3
Check: V′(s) = 3s². Setting 3s² = s³ gives s²(3 − s) = 0, so s = 3 for s > 0.
Rationales: A: This uses V′(s) = 3s instead of 3s². Setting 3s = s³ gives s = √3, which is not a solution of 3s² = s³. C: The value 6 comes from setting the surface area 6s² equal to the volume. The question is about the rate of change of the volume. D: This inverts the result of solving 3s² = s³, which gives s = 3.

**N-2.5-B-v1.** The area of a circle with radius r centimeters is A(r) = πr² square centimeters. For what positive radius is the rate of change of A with respect to r, in square centimeters per centimeter, numerically equal to A?

- A. r = 1
- **B. r = 2**
- C. r = √2
- D. r = 1/2
Check: A′(r) = 2πr. Setting 2πr = πr² gives r(r − 2) = 0, so r = 2 for r > 0.
Rationales: A: This uses A′(r) = πr instead of 2πr. Setting πr = πr² gives r = 1, which does not satisfy 2πr = πr². C: This treats r as constant when differentiating, getting A′ = 2π and then 2π = πr², so r = √2. D: This inverts the result of solving 2πr = πr², which gives r = 2.

**N-2.5-B-v2.** The amount of a drug in the bloodstream is P(x) = x^(3/2) milligrams, x hours after infusion begins. For what positive x is the rate of change of P, in milligrams per hour, numerically equal to P(x)?

- A. x = 9/4
- **B. x = 3/2**
- C. x = 2/3
- D. x = 3
Check: P′(x) = (3/2)x^(1/2). Setting (3/2)x^(1/2) = x^(3/2) and dividing by x^(1/2) gives x = 3/2.
Rationales: A: This squares the correct value. Setting (3/2)x^(1/2) = x^(3/2) and dividing by x^(1/2) gives x = 3/2 directly, with no further squaring. C: This inverts the result. The equation (3/2)x^(1/2) = x^(3/2) gives x = 3/2. D: This uses P′(x) = 3x^(1/2) by doubling the exponent instead of multiplying by 3/2. The correct coefficient is 3/2.

**N-2.5-B-v3.** The number of bacteria in a culture is N(t) = t⁵ thousand, t hours after the start. For what positive time t is the rate of growth, in thousands per hour, numerically equal to N(t)?

- A. t = 1/5
- **B. t = 5**
- C. t = 4
- D. t = 25
Check: N′(t) = 5t⁴. Setting 5t⁴ = t⁵ gives t⁴(5 − t) = 0, so t = 5 for t > 0.
Rationales: A: This inverts the answer. The equation 5t⁴ = t⁵ gives t = 5. C: This uses the lowered exponent as the answer. The equation is 5t⁴ = t⁵, whose positive solution is the coefficient 5, not the exponent 4. D: This squares the correct value. Dividing 5t⁴ = t⁵ by t⁴ gives t = 5 directly.

---

## Seed N-2.6-A (new) — Topic 2.6 Derivative Rules: Constant, Sum, Difference, and Constant Multiple
**Skill:** use the fact that a constant term disappears under differentiation to choose the constant that makes a horizontal line tangent.

Let f(x) = x³ − 3x² + k, where k is a constant. For which values of k is the horizontal line y = 5 tangent to the graph of f?

- A. k = 5 only
- B. k = 9 only
- **C. k = 5 or k = 9**
- D. k = 1 or k = 5
Check: f′(x) = 3x² − 6x is zero at x = 0 and x = 2. Tangency to y = 5 needs f(0) = k = 5 or f(2) = k − 4 = 5, so k = 5 or k = 9.
Rationales: A: Here f′(x) = 3x² − 6x = 0 at x = 0 and x = 2. Using only x = 0 gives f(0) = k = 5 but misses that the graph is also horizontal at x = 2. B: Using only x = 2 gives f(2) = k − 4 = 5, so k = 9, but it misses that f is also horizontal at x = 0, where f(0) = k = 5. D: This has a sign error at x = 2: f(2) = 8 − 12 + k = k − 4, so f(2) = 5 gives k = 9, not k = 1.

**N-2.6-A-v1.** Let f(x) = x³ − 12x + k, where k is a constant. For which values of k is the x-axis tangent to the graph of f?

- A. k = 16 only
- B. k = 0
- **C. k = 16 or k = −16**
- D. k = 2 or k = −2
Check: f′(x) = 3x² − 12 is zero at x = ±2. Tangency to y = 0 needs f(2) = k − 16 = 0 or f(−2) = k + 16 = 0, so k = 16 or k = −16.
Rationales: A: Here f′(x) = 3x² − 12 is zero at x = 2 and x = −2. The value k = 16 comes from x = 2, but x = −2 gives f(−2) = 16 + k = 0, so k = −16 also works. B: The constant k does not disappear from f; it only disappears from f′. The horizontal tangent at x = ±2 needs f(±2) = 0, which fixes k. D: The values ±2 are the x-coordinates where f′ = 0, not the values of k. Tangency to the x-axis needs f(±2) = 0.

**N-2.6-A-v2.** Let f(x) = 2x³ − 9x² + k, where k is a constant. For which values of k is the horizontal line y = −4 tangent to the graph of f?

- A. k = −4 only
- B. k = 23 only
- **C. k = −4 or k = 23**
- D. k = 4 or k = −23
Check: f′(x) = 6x² − 18x is zero at x = 0 and x = 3. Tangency to y = −4 needs f(0) = k = −4 or f(3) = k − 27 = −4, so k = −4 or k = 23.
Rationales: A: Here f′(x) = 6x² − 18x is zero at x = 0 and x = 3. Using only x = 0 gives f(0) = k = −4 but misses the second point of tangency at x = 3. B: Using only x = 3 gives f(3) = k − 27 = −4, so k = 23, but it misses the horizontal tangent at x = 0, where f(0) = k = −4. D: This reverses the sign of both values. The conditions f(0) = k = −4 and f(3) = k − 27 = −4 give k = −4 and k = 23, not 4 and −23.

**N-2.6-A-v3.** Let f(x) = x⁴ − 8x² + k, where k is a constant. For which values of k is the horizontal line y = 3 tangent to the graph of f?

- A. k = 3 only
- B. k = 19 only
- **C. k = 3 or k = 19**
- D. k = −13 or k = 3
Check: f′(x) = 4x³ − 16x is zero at x = 0 and x = ±2. Tangency to y = 3 needs f(0) = k = 3 or f(±2) = k − 16 = 3, so k = 3 or k = 19.
Rationales: A: Here f′(x) = 4x³ − 16x is zero at x = 0 and x = ±2. Using only x = 0 gives f(0) = k = 3 but misses the horizontal tangents at x = ±2. B: Using only x = ±2 gives f(±2) = k − 16 = 3, so k = 19, but it misses the horizontal tangent at x = 0, where f(0) = k = 3. D: This has a sign error at x = ±2: f(±2) = 16 − 32 + k = k − 16, so f(±2) = 3 gives k = 19, not k = −13.

---

## Seed N-2.6-B (new) — Topic 2.6 Derivative Rules: Constant, Sum, Difference, and Constant Multiple
**Skill:** work backward from a given derivative of a combination to the derivative of a component function, using the sum and constant multiple rules.

Let f be a differentiable function, and let g(x) = 4f(x) − x². The tangent line to the graph of g at x = 2 has slope 6. What is f′(2)?

- A. 3/2
- B. 2
- C. 1/2
- **D. 5/2**
Check: g′(x) = 4f′(x) − 2x, so g′(2) = 4f′(2) − 4 = 6, which gives 4f′(2) = 10 and f′(2) = 5/2.
Rationales: A: This ignores the −x² term. From 4f′(2) = 6 it gives 3/2, but g′(x) = 4f′(x) − 2x, so at x = 2 the term −4 must be included. B: This solves 4f′(2) − 4 = 6 incorrectly by subtracting 4 from 6 and not dividing by 4. The correct step is 4f′(2) = 10. C: This has a sign error on the x² term: it solves 4f′(2) + 4 = 6, but the derivative of −x² is −2x, which is −4 at x = 2.

**N-2.6-B-v1.** Let f be a differentiable function, and let g(x) = 3f(x) + x³. The tangent line to the graph of g at x = 1 has slope 12. What is f′(1)?

- A. 4
- B. 9
- C. 5
- **D. 3**
Check: g′(x) = 3f′(x) + 3x², so g′(1) = 3f′(1) + 3 = 12, which gives 3f′(1) = 9 and f′(1) = 3.
Rationales: A: This ignores the x³ term and divides 12 by 3 to get 4, but g′(x) = 3f′(x) + 3x² includes 3x² = 3 at x = 1. B: This subtracts 3 from 12 but forgets to divide by the constant multiple 3. The step 3f′(1) = 9 gives f′(1) = 3. C: This has a sign error on the x³ term: it solves 3f′(1) − 3 = 12, but the derivative of +x³ is +3x².

**N-2.6-B-v2.** Let f be a differentiable function, and let h(x) = 5x − 2f(x). The graph of h has a horizontal tangent line at x = −1. What is f′(−1)?

- A. 5
- B. −5/2
- C. 2/5
- **D. 5/2**
Check: h′(x) = 5 − 2f′(x). A horizontal tangent needs h′(−1) = 5 − 2f′(−1) = 0, so f′(−1) = 5/2.
Rationales: A: This forgets the constant multiple 2: from 5 − 2f′(−1) = 0, f′(−1) = 5/2, not 5. B: This has a sign error: it solves 5 + 2f′(−1) = 0, but the derivative of −2f(x) is −2f′(x). C: This inverts the result. Solving 5 − 2f′(−1) = 0 gives f′(−1) = 5/2.

**N-2.6-B-v3.** Let f be a differentiable function, and let p(x) = (1/2)f(x) + 6x². The tangent line to the graph of p at x = 1 has slope −5. What is f′(1)?

- A. −17
- B. −22
- C. 14
- **D. −34**
Check: p′(x) = (1/2)f′(x) + 12x, so p′(1) = (1/2)f′(1) + 12 = −5, which gives (1/2)f′(1) = −17 and f′(1) = −34.
Rationales: A: This forgets to multiply by 2 to undo the constant multiple 1/2. From (1/2)f′(1) = −17, f′(1) = −34. B: This differentiates 6x² as 6x instead of 12x, getting (1/2)f′(1) + 6 = −5, so f′(1) = −22. C: This has a sign error: it solves (1/2)f′(1) − 12 = −5, but the derivative of +6x² is +12x, which is +12 at x = 1.

---

## Seed N-2.7-A (new) — Topic 2.7 Derivatives of cos x, sin x, e^x, and ln x
**Skill:** find where a tangent line to e^x or ln x passes through a given external point.

The tangent line to the graph of y = eˣ at x = a passes through the origin. What is the value of a?

- **A. a = 1**
- B. a = 0
- C. a = e
- D. a = −1
Check: The tangent at x = a is y = eᵃ + eᵃ(x − a). At x = 0, y = eᵃ(1 − a), which is 0 only when a = 1.
Rationales: B: At x = 0 the tangent line is y = 1 + x, which passes through (0, 1), not the origin. The origin's x-coordinate is not the point of tangency. C: The number e is the value of eˣ at x = 1. It is the y-coordinate of the point of tangency, not the x-coordinate. D: This has a sign error: the tangent y = eᵃ + eᵃ(x − a) passes through (0, 0) when 1 − a = 0, not 1 + a = 0.

**N-2.7-A-v1.** The tangent line to the graph of y = ln x at x = a passes through the origin. What is the value of a?

- **A. a = e**
- B. a = 1
- C. a = 1/e
- D. a = e²
Check: The tangent at x = a is y = ln a + (x − a)/a. At x = 0 it gives y = ln a − 1, which is 0 when ln a = 1, so a = e.
Rationales: B: At x = 1 the tangent is y = x − 1, which crosses the x-axis at x = 1 but passes through (0, −1), not the origin. C: This has a sign error. The tangent y = ln a + (x − a)/a passes through (0, 0) when ln a − 1 = 0, so ln a = 1, not −1. D: This gives ln a = 2 instead of ln a = 1, which comes from doubling the 1 contributed by the (x − a)/a term.

**N-2.7-A-v2.** The tangent line to the graph of y = eˣ at x = a passes through the point (2, 0). What is the value of a?

- **A. a = 3**
- B. a = 2
- C. a = 1
- D. a = e³
Check: The tangent at x = a is y = eᵃ + eᵃ(x − a). At the point (2, 0), 0 = eᵃ(1 + 2 − a), so a = 3.
Rationales: B: The number 2 is the x-coordinate of the given point, not the point of tangency. At x = 2 the tangent is y = e²(x − 1), which does not pass through (2, 0). C: This has a sign error in the constant: the tangent y = eᵃ(x − a + 1) passes through (2, 0) when 2 − a + 1 = 0. Using 2 − a − 1 = 0 gives a = 1. D: The number e³ is the y-coordinate of the point of tangency when a = 3, not the x-coordinate a.

**N-2.7-A-v3.** The tangent line to the graph of y = ln x at x = a passes through the point (0, −2). What is the value of a?

- **A. a = 1/e**
- B. a = e
- C. a = e⁻²
- D. a = e⁻³
Check: At x = 0 the tangent gives y = ln a − 1. Setting ln a − 1 = −2 gives ln a = −1, so a = 1/e.
Rationales: B: This has a sign error: the tangent y = ln a + (x − a)/a passes through (0, −2) when ln a − 1 = −2, so ln a = −1, not 1. C: This sets ln a = −2 directly, forgetting the −1 contributed by the (x − a)/a term at x = 0. D: This solves ln a + 1 = −2, adding 1 instead of subtracting it. At x = 0 the tangent gives ln a − 1.

---

## Seed N-2.7-B (new) — Topic 2.7 Derivatives of cos x, sin x, e^x, and ln x
**Skill:** differentiate a sum that contains constant-valued exponential, logarithmic and trigonometric terms without treating the constants as variables.

Let f(x) = eˣ + e²x + ln 3. What is f′(2)?

- A. 2e² + 1/3
- **B. 2e²**
- C. e² + 4e
- D. 3e²
Check: f′(x) = eˣ + e² + 0, so f′(2) = e² + e² = 2e².
Rationales: A: This differentiates the constant ln 3 as 1/(3). The derivative of any constant, including ln 3, is 0. C: This differentiates e²x as 2e · x by treating e² as a variable power. Since e² is a constant, the derivative of e²x is e². D: This differentiates e²x as e²x, as if it were eˣ. The derivative of a constant times x is just the constant e².

**N-2.7-B-v1.** Let g(x) = ln x + x ln 3 for x > 0. What is g′(3)?

- A. 4/3
- **B. 1/3 + ln 3**
- C. 2/3
- D. 1/3
Check: g′(x) = 1/x + ln 3, so g′(3) = 1/3 + ln 3.
Rationales: A: This differentiates x ln 3 as x · (1/3), treating ln 3 as a variable. The derivative is the constant ln 3, which is not 1/3. C: This differentiates x ln 3 as 1/3, applying the logarithm rule to a constant instead of using the constant multiple rule. D: This treats x ln 3 as a constant, dropping it entirely. The derivative of x ln 3 is ln 3.

**N-2.7-B-v2.** Let h(x) = cos x + x sin(π/6) + cos(π/3). What is h′(π/2)?

- A. −1/2 − √3/2
- **B. −1/2**
- C. 3/2
- D. −1 + π√3/4
Check: h′(x) = −sin x + sin(π/6) + 0 = −sin x + 1/2, so h′(π/2) = −1 + 1/2 = −1/2.
Rationales: A: This differentiates cos(π/3), a constant, as −sin(π/3) = −√3/2. The derivative of a constant is 0. C: This has a sign error on cos x, which has derivative −sin x. Using +sin x gives 1 + 1/2 = 3/2. D: This differentiates x sin(π/6) as x cos(π/6), applying the sine rule to a constant. The derivative is the constant sin(π/6) = 1/2.

**N-2.7-B-v3.** Let p(x) = πx + ln x + e^π for x > 0. What is p′(2)?

- A. π + 1/2 + e^π
- **B. π + 1/2**
- C. 1/2
- D. 2π + 1/2
Check: p′(x) = π + 1/x + 0, so p′(2) = π + 1/2.
Rationales: A: This differentiates the constant e^π as e^π, as if it were eˣ. The derivative of a constant is 0. C: This treats πx as a constant and drops it. The derivative of πx is π. D: This differentiates πx as πx, leaving the factor of x. The derivative of πx is the constant π.

---

## Seed N-2.8-A (new) — Topic 2.8 The Product Rule
**Skill:** use the product rule backward: a horizontal tangent to a product determines the derivative of one factor.

Let f be a differentiable function with f(3) = 2, and let h(x) = x²f(x). The graph of h has a horizontal tangent line at x = 3. What is f′(3)?

- A. 0
- B. −3
- **C. −4/3**
- D. 4/3
Check: h′(x) = 2x f(x) + x² f′(x), so h′(3) = 6(2) + 9f′(3) = 12 + 9f′(3). Setting this to 0 gives f′(3) = −12/9 = −4/3.
Rationales: A: This differentiates the product as 2x · f′(x), the product of the derivatives of the factors with f dropped. That would give f′(3) = 0, but h′ = 2xf + x²f′. B: This swaps the roles in the product rule, writing h′ = x²f + 2xf′. Setting 9(2) + 6f′(3) = 0 gives −3, which is not the correct equation. D: This has a sign error: 12 + 9f′(3) = 0 gives f′(3) = −12/9, so the result is negative, not positive.

**N-2.8-A-v1.** Let f be a differentiable function with f(4) = 6, and let h(x) = √x · f(x). The graph of h has a horizontal tangent line at x = 4. What is f′(4)?

- A. 0
- B. −3/2
- **C. −3/4**
- D. 3/4
Check: h′(x) = f(x)/(2√x) + √x f′(x), so h′(4) = 6/4 + 2f′(4) = 0, which gives f′(4) = −3/4.
Rationales: A: This differentiates the product as the product of the derivatives, (1/(2√x))f′(x), which is zero only if f′(4) = 0. The product rule has two terms. B: This writes the derivative of √x as 1/√x instead of 1/(2√x), so the first term becomes 6/2 = 3 instead of 6/4. D: This has a sign error: 6/4 + 2f′(4) = 0 gives a negative f′(4), not a positive one.

**N-2.8-A-v2.** Let f be a differentiable function with f(0) = 7, and let h(x) = eˣ f(x). The graph of h has a horizontal tangent line at x = 0. What is f′(0)?

- A. 0
- B. 7
- **C. −7**
- D. −1/7
Check: h′(x) = eˣ f(x) + eˣ f′(x), so h′(0) = 7 + f′(0) = 0, which gives f′(0) = −7.
Rationales: A: This differentiates the product as eˣ · f′(x), the product of the derivatives with f dropped. The product rule also contributes eˣ f(x). B: This has a sign error: e⁰(7 + f′(0)) = 0 gives f′(0) = −7, not 7. D: This divides the wrong way, using 1/f(0) instead of f(0). Setting h′(0) = f(0) + f′(0) = 0 gives f′(0) = −f(0).

**N-2.8-A-v3.** Let f be a differentiable function with f(e) = 3, and let h(x) = f(x) ln x. The graph of h has a horizontal tangent line at x = e. What is f′(e)?

- A. 0
- B. −3
- **C. −3/e**
- D. 3/e
Check: h′(x) = f′(x) ln x + f(x)/x, so h′(e) = f′(e) + 3/e = 0, which gives f′(e) = −3/e.
Rationales: A: This differentiates the product as f′(x) · (1/x), the product of the derivatives. The product rule has a second term f(x)/x. B: This writes the derivative of ln x as 1 instead of 1/x, so the first term becomes f(e) = 3 instead of 3/e. D: This has a sign error: 3/e + f′(e) = 0 gives f′(e) = −3/e, not +3/e.

---

## Seed N-2.8-B (new) — Topic 2.8 The Product Rule
**Skill:** apply the product rule to a rate in context, such as revenue as price times quantity, and interpret the result with units.

A company sells q units at a price of p(q) dollars per unit, so its revenue is R(q) = q · p(q) dollars. When q = 100, the price is p(100) = 12 dollars and p′(100) = −0.05 dollar per unit. Which statement is the best interpretation of R′(100)?

- A. Selling one more unit beyond 100 changes revenue by about +12 dollars.
- B. Selling one more unit beyond 100 changes revenue by about −0.6 dollar.
- C. Selling one more unit beyond 100 changes revenue by about +11.95 dollars.
- **D. Selling one more unit beyond 100 changes revenue by about +7 dollars.**
Check: R′(q) = p(q) + q p′(q), so R′(100) = 12 + 100(−0.05) = 7 dollars per unit.
Rationales: A: This takes R′ to be the price p(100). It forgets that a higher quantity also lowers the price on all the units already sold, a term q p′(q). B: This multiplies the price by its rate of change, 12 · (−0.05) = −0.6. The product rule gives p(q) + q p′(q), not p(q) p′(q). C: This adds p and p′ without the factor q, giving 12 − 0.05. The second product-rule term is q p′(q) = 100(−0.05) = −5.

**N-2.8-B-v1.** A rectangle has length ℓ(t) meters and width w(t) meters at time t minutes, so its area is A(t) = ℓ(t)w(t). At t = 5, ℓ = 20, ℓ′ = 1.5, w = 8 and w′ = −0.5. What is the rate of change of the area at t = 5?

- A. −0.75 square meters per minute
- B. 26 square meters per minute
- C. 1 square meter per minute
- **D. 2 square meters per minute**
Check: A′ = ℓ′w + ℓw′ = (1.5)(8) + (20)(−0.5) = 12 − 10 = 2 square meters per minute.
Rationales: A: This multiplies the rates, 1.5 · (−0.5). The product rule gives ℓ′w + ℓw′, not ℓ′w′. B: This pairs each derivative with its own function, ℓ′ℓ + w′w = 30 − 4, instead of cross-multiplying as ℓ′w + ℓw′. C: This adds the rates, 1.5 + (−0.5), ignoring the current length and width. Area rates depend on both dimensions.

**N-2.8-B-v2.** A fundraiser has n(t) donors and an average gift of a(t) dollars at day t, so total pledges are T(t) = n(t)a(t) dollars. At t = 10, n = 200, n′ = 15 donors per day, a = 40 and a′ = −1.5 dollars per day. What is the best estimate of T′(10)?

- A. 600 dollars per day
- B. −22.5 dollars per day
- C. 8000 dollars per day
- **D. 300 dollars per day**
Check: T′ = n′a + na′ = (15)(40) + (200)(−1.5) = 600 − 300 = 300 dollars per day.
Rationales: A: This keeps only the new-donor term n′a = 600 and omits n a′ = −300, the loss from falling average gifts. B: This multiplies the two rates, 15 · (−1.5). The product rule gives n′a + na′, not n′a′. C: This is the current total pledged, T(10) = 200 · 40, a quantity in dollars rather than a rate in dollars per day.

**N-2.8-B-v3.** A town has n(t) thousand households and s(t) people per household at year t, so its population in thousands is P(t) = n(t)s(t). At t = 2, n = 50, n′ = 3 thousand households per year, s = 2.5 and s′ = −0.1 people per household per year. What is P′(2)?

- A. 7.5 thousand people per year
- B. −5 thousand people per year
- C. −0.3 thousand people per year
- **D. 2.5 thousand people per year**
Check: P′ = n′s + ns′ = (3)(2.5) + (50)(−0.1) = 7.5 − 5 = 2.5 thousand people per year.
Rationales: A: This keeps only the household-growth term n′s = 7.5 and omits ns′ = −5, the loss from shrinking household size. B: This keeps only the term ns′ = −5 and omits n′s = 7.5, the gain from new households. C: This multiplies the rates, 3 · (−0.1). The product rule gives n′s + ns′, not n′s′.

---

## Seed N-2.9-A (new) — Topic 2.9 The Quotient Rule
**Skill:** use the quotient rule backward: a horizontal tangent to a quotient determines a derivative of the numerator.

Let f and g be differentiable functions with f(2) = 8, g(2) = 4 and g′(2) = 3, and let h(x) = f(x)/g(x). The graph of h has a horizontal tangent line at x = 2. What is f′(2)?

- **A. 6**
- B. −6
- C. 0
- D. 32/3
Check: h′ = (f′g − fg′)/g². Setting h′(2) = 0 gives 4f′(2) − 8(3) = 0, so f′(2) = 6.
Rationales: B: This uses the product rule signs, f′g + fg′ = 0, instead of the quotient rule numerator f′g − fg′. C: This sets only f′(2) = 0, as if h′ were f′/g′. The quotient rule has a second term −f g′. D: This solves f′ = f g/g′ by inverting the relation. The condition f′g − fg′ = 0 gives f′ = f g′/g.

**N-2.9-A-v1.** Let f and g be differentiable functions with f(1) = −3, g(1) = 2 and g′(1) = −5, and let h(x) = f(x)/g(x). The graph of h has a horizontal tangent line at x = 1. What is f′(1)?

- **A. 15/2**
- B. −15/2
- C. 0
- D. 6/5
Check: h′ = (f′g − fg′)/g². Setting h′(1) = 0 gives 2f′(1) − (−3)(−5) = 0, so f′(1) = 15/2.
Rationales: B: This uses the product rule signs, f′g + fg′ = 0, which gives the opposite sign. C: This sets only f′(1) = 0, as if h′ were f′/g′. The quotient rule has a second term −f g′. D: This solves f′ = f g/g′ by inverting the relation. The condition f′g − fg′ = 0 gives f′ = f g′/g.

**N-2.9-A-v2.** Let f be a differentiable function with f(2) = 10, and let h(x) = f(x)/x². The graph of h has a horizontal tangent line at x = 2. What is f′(2)?

- **A. 10**
- B. 20
- C. 5
- D. 0
Check: h′ = (x²f′ − 2xf)/x⁴. Setting h′(2) = 0 gives 4f′(2) − 4(10) = 0, so f′(2) = 10.
Rationales: B: This forgets to divide by x: the condition x² f′ − 2x f = 0 gives f′ = 2f/x = 10, not 2f = 20. C: This uses f′ = f/x with the 2 lost from the derivative of x². The derivative of x² is 2x. D: This sets only f′(2) = 0. The quotient rule has a second term −2x f(x) that is not zero.

**N-2.9-A-v3.** Let f be a differentiable function with f(0) = −4, and let h(x) = f(x)/eˣ. The graph of h has a horizontal tangent line at x = 0. What is f′(0)?

- **A. −4**
- B. 4
- C. 0
- D. −16
Check: h′ = (eˣ f′ − f eˣ)/e²ˣ = (f′ − f)/eˣ. Setting h′(0) = 0 gives f′(0) = f(0) = −4.
Rationales: B: This has a sign error from the numerator f′ − f: setting it to 0 gives f′(0) = f(0) = −4, not +4. C: This sets only f′(0) = 0, dropping the term −f eˣ from the quotient rule. D: This squares f(0), producing f² = 16, which has no role in the condition f′(0) = f(0).

---

## Seed N-2.9-B (new) — Topic 2.9 The Quotient Rule
**Skill:** use the quotient rule on an average-cost function to find where average cost stops falling.

The total cost of producing q units is C(q) = q² + 10q + 400 dollars, so the average cost per unit is A(q) = C(q)/q. At what production level q > 0 does A′(q) = 0?

- A. q = 400
- **B. q = 20**
- C. q = 10
- D. q = 200
Check: A′(q) = [qC′(q) − C(q)]/q² = [q(2q + 10) − (q² + 10q + 400)]/q² = (q² − 400)/q². This is zero at q = 20.
Rationales: A: This solves 1 − 400/q² = 0 as q² = 400 and then stops without taking the square root. C: This reads the coefficient of the linear term of C off as the answer. It has no connection to where A′ = 0. D: This sets C′(q) = 2q equal to the constant 400, which is not the condition A′(q) = 0.

**N-2.9-B-v1.** The total cost of producing q units is C(q) = q² + 4q + 225 dollars, so the average cost per unit is A(q) = C(q)/q. At what production level q > 0 does A′(q) = 0?

- A. q = 225
- **B. q = 15**
- C. q = 4
- D. q = 112.5
Check: A′(q) = [q(2q + 4) − (q² + 4q + 225)]/q² = (q² − 225)/q². This is zero at q = 15.
Rationales: A: This solves q² = 225 and stops without taking the square root. C: This reads the coefficient of the linear term of C off as the answer. It has no connection to where A′ = 0. D: This sets C′(q) = 2q equal to the constant 225, which is not the condition A′(q) = 0.

**N-2.9-B-v2.** The total cost of producing q units is C(q) = 2q² + 7q + 98 dollars, so the average cost per unit is A(q) = C(q)/q. At what production level q > 0 does A′(q) = 0?

- A. q = 49
- **B. q = 7**
- C. q = 98
- D. q = 7/4
Check: A′(q) = [q(4q + 7) − (2q² + 7q + 98)]/q² = (2q² − 98)/q². This is zero at q = 7.
Rationales: A: This solves q² = 49 and stops without taking the square root. C: This gives the constant 98 as the answer, which has no connection to where A′ = 0. D: This sets the marginal cost C′(q) = 4q + 7 equal to 0 and drops the sign of q = −7/4. The condition needed is on A′, not on C′.

**N-2.9-B-v3.** The total cost of producing q units is C(q) = q³ + 16 dollars, so the average cost per unit is A(q) = C(q)/q. At what production level q > 0 does A′(q) = 0?

- A. q = 8
- **B. q = 2**
- C. q = 16
- D. q = 4
Check: A′(q) = [q(3q²) − (q³ + 16)]/q² = (2q³ − 16)/q². This is zero when q³ = 8, so q = 2.
Rationales: A: This solves q³ = 8 and stops without taking the cube root. C: This gives the constant 16 as the answer, which has no connection to where A′ = 0. D: This solves q² = 16, treating the equation as a quadratic rather than q³ = 8.

---

## Seed N-2.10-A (new) — Topic 2.10 Derivatives of tan x, cot x, sec x, and csc x
**Skill:** solve for the points where the tangent to tan x or cot x has a given slope, using sec²x and csc²x and keeping both solutions in the interval.

For −π/2 < x < π/2, at which values of x does the tangent line to the graph of y = tan x have slope 4?

- A. x = π/3 only
- B. x = π/6 and x = −π/6
- **C. x = π/3 and x = −π/3**
- D. x = arctan 4 and x = −arctan 4
Check: d/dx[tan x] = sec²x. Setting sec²x = 4 gives cos x = ±1/2, so x = ±π/3 in (−π/2, π/2).
Rationales: A: Since sec²x = 4 gives cos x = ±1/2, both x = π/3 and x = −π/3 lie in the interval. Keeping only the positive solution misses the symmetric one. B: The angle π/6 has cos x = √3/2, not 1/2. The condition sec²x = 4 needs cos²x = 1/4. D: This sets tan x = 4. The derivative of tan x is sec²x, so the condition is sec²x = 4, not tan x = 4.

**N-2.10-A-v1.** For −π/2 < x < π/2, at which values of x does the tangent line to the graph of y = tan x have slope 2?

- A. x = π/4 only
- B. x = π/3 and x = −π/3
- **C. x = π/4 and x = −π/4**
- D. x = arctan 2 and x = −arctan 2
Check: d/dx[tan x] = sec²x. Setting sec²x = 2 gives cos x = ±√2/2, so x = ±π/4 in (−π/2, π/2).
Rationales: A: Since sec²x = 2 gives cos x = ±√2/2, both x = π/4 and x = −π/4 lie in the interval. Keeping only the positive solution misses the symmetric one. B: The angle π/3 has sec²x = 4, giving slope 4. The condition sec²x = 2 needs cos²x = 1/2. D: This sets tan x = 2. The derivative of tan x is sec²x, so the condition is sec²x = 2, not tan x = 2.

**N-2.10-A-v2.** For 0 < x < π, at which values of x does the tangent line to the graph of y = cot x have slope −4?

- A. x = π/6 only
- B. x = π/3 and x = 2π/3
- **C. x = π/6 and x = 5π/6**
- D. x = π/6 and x = 7π/6
Check: d/dx[cot x] = −csc²x. Setting −csc²x = −4 gives sin x = 1/2, so x = π/6 or 5π/6 in (0, π).
Rationales: A: Since csc²x = 4 gives sin x = 1/2 (positive on (0, π)), both x = π/6 and x = 5π/6 are solutions. Keeping only π/6 misses the second. B: This solves cos x = ±1/2, which would correspond to sec²x = 4. The condition here is csc²x = 4, so sin x = 1/2. D: The value 7π/6 is outside the interval (0, π). The second solution of sin x = 1/2 in (0, π) is 5π/6.

**N-2.10-A-v3.** For 0 < x < π, at which values of x does the tangent line to the graph of y = cot x have slope −2?

- A. x = π/4 only
- B. x = π/6 and x = 5π/6
- **C. x = π/4 and x = 3π/4**
- D. x = π/3 and x = 2π/3
Check: d/dx[cot x] = −csc²x. Setting −csc²x = −2 gives sin x = √2/2, so x = π/4 or 3π/4 in (0, π).
Rationales: A: Since csc²x = 2 gives sin x = √2/2, both x = π/4 and x = 3π/4 are solutions. Keeping only π/4 misses the second. B: The angles π/6 and 5π/6 have sin x = 1/2, giving csc²x = 4 and slope −4, not −2. D: The angles π/3 and 2π/3 have sin x = √3/2, giving csc²x = 4/3 and slope −4/3, not −2.

---

## Seed N-2.10-B (new) — Topic 2.10 Derivatives of tan x, cot x, sec x, and csc x
**Skill:** combine derivative formulas and identities to determine the sign of a derivative and describe monotonic behaviour.

Let f(x) = tan x − x for −π/2 < x < π/2. Which statement about f is true?

- A. f has a local minimum at x = 0 because f′(0) = 0.
- B. f is decreasing for x < 0 and increasing for x > 0.
- C. f′(x) = sec²x + 1 > 0, so f is increasing and never has a horizontal tangent.
- **D. f′(x) = tan²x ≥ 0 with equality only at x = 0, so f is increasing and its graph has a horizontal tangent at x = 0 but no extremum there.**
Check: f′(x) = sec²x − 1 = tan²x, which is nonnegative and equals 0 only at x = 0. So f is increasing, with a horizontal tangent at 0 and no extremum.
Rationales: A: A zero of f′ gives a local extremum only if f′ changes sign. Here f′ = tan²x is nonnegative on both sides of 0, so there is no extremum. B: This assumes f′ changes sign at 0 like the derivative of x². But f′(x) = tan²x is positive on both sides of 0. C: This has a sign error: the derivative of −x is −1, so f′(x) = sec²x − 1 = tan²x, which is 0 at x = 0.

**N-2.10-B-v1.** Let g(x) = sec x − tan x for −π/2 < x < π/2. Which statement about g is true?

- A. g′(0) = 0, so the graph has a horizontal tangent line at x = 0.
- B. g′(x) = sec x tan x + sec²x > 0, so g is increasing.
- C. g is decreasing for x < 0 and increasing for x > 0.
- **D. g′(x) < 0 for every x in the interval, so g is decreasing and its graph has no horizontal tangent line.**
Check: g′(x) = sec x tan x − sec²x = sec x (tan x − sec x) = −(1 − sin x)/cos²x, which is negative on the interval since sin x < 1. So g is decreasing.
Rationales: A: Since g′(x) = sec x tan x − sec²x, g′(0) = 0 − 1 = −1, so the tangent at x = 0 has slope −1, not 0. B: This has a sign error: the derivative of −tan x is −sec²x, so g′(x) = sec x tan x − sec²x. C: This assumes g′ changes sign at 0, but g′(x) = −(1 − sin x)/cos²x is negative on the whole interval.

**N-2.10-B-v2.** Let h(x) = cot x + x for 0 < x < π. Which statement about h is true?

- A. h has a local maximum at x = π/2 because h′(π/2) = 0.
- B. h′(x) = csc²x + 1 > 0, so h is increasing.
- C. h′(x) = −csc²x − 1 < 0, so h is decreasing and never has a horizontal tangent.
- **D. h′(x) = −cot²x ≤ 0 with equality only at x = π/2, so h is decreasing and its graph has a horizontal tangent at x = π/2 but no extremum there.**
Check: h′(x) = −csc²x + 1 = −cot²x, which is nonpositive and equals 0 only at x = π/2. So h is decreasing, with a horizontal tangent at π/2 and no extremum.
Rationales: A: A zero of h′ gives a local extremum only if h′ changes sign. Here h′ = −cot²x is nonpositive on both sides of π/2, so there is no extremum. B: This has two sign errors: the derivative of cot x is −csc²x, and the derivative of x is +1. C: This has a sign error on the term x: its derivative is +1, so h′(x) = −csc²x + 1 = −cot²x, which is 0 at π/2.

**N-2.10-B-v3.** Let k(x) = csc x + cot x for 0 < x < π. Which statement about k is true?

- A. k′(π/2) = 0, so the graph has a horizontal tangent line at x = π/2.
- B. k′(x) = csc x cot x + csc²x > 0, so k is increasing.
- C. k is decreasing for x < π/2 and increasing for x > π/2.
- **D. k′(x) < 0 for every x in the interval, so k is decreasing and its graph has no horizontal tangent line.**
Check: k′(x) = −csc x cot x − csc²x = −csc x (cot x + csc x) = −(1 + cos x)/sin²x, which is negative on (0, π). So k is decreasing.
Rationales: A: Here k′(x) = −csc x cot x − csc²x, so k′(π/2) = 0 − 1 = −1. The tangent at π/2 has slope −1, not 0. B: This has sign errors: the derivatives of csc x and cot x are −csc x cot x and −csc²x. C: This assumes k′ changes sign at π/2, but k′(x) = −(1 + cos x)/sin²x is negative on the whole interval.

---
