# AP Calculus BC topics 4.1 to 4.7: new seed drafts

DRAFT for owner review. Author-in-session; not checked by a checker; not in the database. Every numeric claim recomputed in Python (exact fractions, finite differences, numerical integration and numerical limits).
Scope: the published BC pool has no practice MCQs for Unit 4, so this is new content (14 seeds, 56 items). No recall or one-step seeds. Mostly R3 (interpretation, misconception-driven reasoning); the rest strong R2.
Target level: derivative of a rate with units and sign, speeding up and slowing down, total distance versus displacement, marginal analysis and its trend, setup of related rates with a shape constraint, product rule with two changing variables, linearization with concavity (including solving for a time), and valid versus invalid uses of L'Hôpital's rule including 0·∞ and 1^∞ forms.

| Seed | Topic | Focus |
|---|---|---|
| N-4.1-A | 4.1 Interpreting the Meaning of the Derivative in Context | new: derivative of a rate function (R3) |
| N-4.1-B | 4.1 Interpreting the Meaning of the Derivative in Context | new: table estimate and interpretation (R2) |
| N-4.2-A | 4.2 Straight-Line Motion: Connecting Position, Velocity, and Acceleration | new: speeding up and slowing down (R3) |
| N-4.2-B | 4.2 Straight-Line Motion: Connecting Position, Velocity, and Acceleration | new: total distance vs displacement (R2) |
| N-4.3-A | 4.3 Rates of Change in Applied Contexts Other Than Motion | new: marginal profit and its trend (R3) |
| N-4.3-B | 4.3 Rates of Change in Applied Contexts Other Than Motion | new: instantaneous versus average rate (R2) |
| N-4.4-A | 4.4 Introduction to Related Rates | new: Pythagorean related rates (R2) |
| N-4.4-B | 4.4 Introduction to Related Rates | new: volume with a shape constraint (R3) |
| N-4.5-A | 4.5 Solving Related Rates Problems | new: angle and similar-triangle related rates (R2) |
| N-4.5-B | 4.5 Solving Related Rates Problems | new: product rule with two changing dimensions (R3) |
| N-4.6-A | 4.6 Approximating Values of a Function Using Local Linearity and Linearization | new: tangent-line estimate and concavity (R3) |
| N-4.6-B | 4.6 Approximating Values of a Function Using Local Linearity and Linearization | new: inverse use of linearization and concavity (R3) |
| N-4.7-A | 4.7 Using L'Hospital's Rule for Determining Limits of Indeterminate Forms | new: valid and invalid uses of L'Hôpital's rule (R3) |
| N-4.7-B | 4.7 Using L'Hospital's Rule for Determining Limits of Indeterminate Forms | new: 0·∞ and 1^∞ forms (R3) |

---

## Seed N-4.1-A (new) — Topic 4.1 Interpreting the Meaning of the Derivative in Context
**Skill:** interpret the derivative of a rate function in context, with units and sign, without confusing the rate with its own rate of change.

Water flows into a reservoir at a rate of F(t) thousand liters per hour, where t is the number of hours after midnight. At t = 6, F(6) = 4.2 and F′(6) = −0.5. Which statement is correct at t = 6?

- A. The volume of water is decreasing at 0.5 thousand liters per hour.
- B. The volume of water is decreasing, because F′(6) is negative.
- **C. The volume of water is increasing at 4.2 thousand liters per hour, and that rate of increase is decreasing at 0.5 thousand liters per hour per hour.**
- D. The inflow rate will be exactly 3.7 thousand liters per hour at t = 7.

Check: The volume V satisfies V′(t) = F(t), so V′(6) = 4.2 > 0 and the volume is increasing. Also V″(6) = F′(6) = −0.5, so the rate of increase is falling by 0.5 thousand liters per hour each hour.
Rationales: A: this treats F′(6) as the rate of change of the volume, but F itself is the volume's rate of change, so F′ is the rate at which the inflow rate is changing. B: the sign of F′ shows whether the inflow rate is rising or falling, not whether the volume is rising; the volume rises because F(6) = 4.2 is positive. D: F′(6) is an instantaneous rate at t = 6, so multiplying it by one hour only approximates the change in F and does not give an exact value.

**N-4.1-A-v1.** Water leaves a lake through a dam at a rate of D(t) million gallons per day, where t is measured in days. At t = 10, D(10) = 3.0 and D′(10) = 0.4. Which statement is correct at t = 10?

- A. The volume of the lake is increasing at 0.4 million gallons per day.
- B. The volume of the lake is increasing at 3.0 million gallons per day, because D′(10) is positive.
- C. The outflow rate will be exactly 3.4 million gallons per day at t = 11.
- **D. The volume of the lake is decreasing at 3.0 million gallons per day, and the outflow rate is increasing at 0.4 million gallons per day per day.**

Check: Volume V satisfies V′(t) = −D(t), so V′(10) = −3.0 and the volume is decreasing at 3.0 million gallons per day. D′(10) = 0.4 > 0 means the outflow rate is rising by 0.4 million gallons per day each day.
Rationales: A: this reads D′(10) as the rate of change of the volume; the volume's rate of change is −D(10), while D′ describes how the outflow rate itself is changing. B: a positive D′ means the outflow rate is rising, not that the lake is filling; water is leaving, so the volume decreases whenever D(10) is positive. C: D′(10) = 0.4 is an instantaneous rate at t = 10; adding it to D(10) for one full day is only an approximation, not an exact value.

**N-4.1-A-v2.** The rate at which customers enter a store is c(t) customers per minute, where t is the number of minutes after the store opens. At t = 20, c(20) = 6 and c′(20) = 0.3. Which statement is correct at t = 20?

- **A. The number of customers who have entered is increasing at 6 customers per minute, and that rate is increasing at 0.3 customers per minute per minute.**
- B. The number of customers who have entered is increasing at 0.3 customers per minute.
- C. Customers are entering at 0.3 customers per minute at t = 20.
- D. The entry rate will be exactly 6.3 customers per minute at t = 21.

Check: The count N of customers who have entered satisfies N′(t) = c(t), so N′(20) = 6 customers per minute. c′(20) = 0.3 > 0, so the entry rate itself is rising at 0.3 customers per minute each minute.
Rationales: B: 0.3 is the value of c′(20), the rate at which the entry rate is changing; the number of customers who have entered changes at the entry rate c(20) = 6. C: the entry rate at t = 20 is c(20) = 6 customers per minute; c′(20) = 0.3 has units of customers per minute per minute and measures how that rate is changing. D: the derivative is an instantaneous rate at t = 20, so using it over a full minute only approximates the new entry rate; it does not give an exact value.

**N-4.1-A-v3.** Oil is pumped out of a storage tank at a rate of p(t) hundred barrels per hour, where t is measured in hours. At t = 3, p(3) = 5.5 and p′(3) = −0.8. Which statement is correct at t = 3?

- A. The volume of oil is increasing at 0.8 hundred barrels per hour, because the pumping rate is falling.
- B. The volume of oil is decreasing at 5.5 hundred barrels per hour, and it is decreasing faster as time passes.
- C. The pumping rate will be exactly 4.7 hundred barrels per hour at t = 4.
- **D. The volume of oil is decreasing at 5.5 hundred barrels per hour, and it is decreasing more slowly as time passes.**

Check: The volume V satisfies V′(t) = −p(t), so V′(3) = −5.5 (decreasing at 5.5). V″(3) = −p′(3) = 0.8 > 0, so V′ is rising toward zero and the decrease is slowing.
Rationales: A: a falling pumping rate means oil still leaves the tank, only more slowly; the volume keeps decreasing as long as p(3) is positive. B: p′(3) is negative, so the pumping rate is shrinking; the volume's rate of change −p(t) rises toward zero, which is a slowing decrease and not a faster one. C: p′(3) = −0.8 is an instantaneous rate at t = 3, so applying it over one full hour gives only an approximation of p(4), not an exact value.

---

## Seed N-4.1-B (new) — Topic 4.1 Interpreting the Meaning of the Derivative in Context
**Skill:** estimate a derivative from a table with a symmetric difference quotient and interpret it as a rate with units, not as an average per-unit value.

The total cost, in dollars, of producing q units of a product is C(q). Selected values are given.

q | C(q)
400 | 1520
500 | 1800
600 | 2120

Using the table values at q = 400 and q = 600 to estimate the rate at which cost is changing at q = 500, which statement is correct?

- A. The cost is changing at about $3.60 per unit, so each additional unit beyond 500 adds about $3.60 to the total cost.
- **B. The cost is changing at about $3.00 per unit, so each additional unit beyond 500 adds about $3.00 to the total cost.**
- C. The cost is changing at about $600 per unit, so each additional unit beyond 500 adds about $600 to the total cost.
- D. The cost is changing at about $1.50 per unit, so each additional unit beyond 500 adds about $1.50 to the total cost.

Check: C′(500) ≈ (C(600) − C(400))/(600 − 400) = (2120 − 1520)/200 = 3.00 dollars per unit.
Rationales: A: 1800/500 = 3.60 is the average cost per unit of the first 500 units, which is not the rate at which total cost is changing at q = 500. C: 600 is the change in cost over the whole interval from 400 to 600; it must be divided by the 200 units in that interval to give a rate per unit. D: dividing the 600 change in cost by 400 uses the lower input value rather than the width of the interval, which is 600 − 400 = 200.

**N-4.1-B-v1.** A cup of coffee cools after it is poured. Its temperature, in degrees Fahrenheit, t minutes after pouring is T(t). Selected values are given.

t | T(t)
2 | 150
4 | 126
6 | 108

Using the table values at t = 2 and t = 6 to estimate the rate at which the temperature is changing at t = 4, which statement is correct?

- A. The temperature is rising at about 10.5 degrees Fahrenheit per minute at t = 4.
- B. The temperature is falling at about 42 degrees Fahrenheit per minute at t = 4.
- **C. The temperature is falling at about 10.5 degrees Fahrenheit per minute at t = 4.**
- D. The temperature is falling at about 31.5 degrees Fahrenheit per minute at t = 4.

Check: T′(4) ≈ (T(6) − T(2))/(6 − 2) = (108 − 150)/4 = −10.5 degrees Fahrenheit per minute.
Rationales: A: the temperature drops from 150 to 108, so the difference quotient (108 − 150)/4 is negative; a positive rate would mean the coffee is warming up. B: 42 is the total drop in temperature over the four-minute interval from t = 2 to t = 6; it must be divided by 4 to give a rate per minute. D: 126/4 = 31.5 divides the temperature by the time, which is a ratio of values and not the rate at which the temperature is changing.

**N-4.1-B-v2.** A lake's fish population, in thousands, is P(t), where t is the number of years since 2010. Selected values are given.

t | P(t)
0 | 84
5 | 90
10 | 98

Using the table values at t = 0 and t = 10 to estimate the rate at which the population is changing at t = 5, which statement is correct?

- A. The population is growing at about 18 thousand fish per year in 2015.
- **B. The population is growing at about 1.4 thousand fish per year in 2015.**
- C. The population is growing at about 14 thousand fish per year in 2015.
- D. The population is growing at about 2.8 thousand fish per year in 2015.

Check: P′(5) ≈ (P(10) − P(0))/(10 − 0) = (98 − 84)/10 = 1.4 thousand fish per year.
Rationales: A: 90/5 = 18 divides the population by the elapsed years, which is a ratio of values and not the rate at which the population is changing. C: 14 is the total change in population over the ten years from t = 0 to t = 10; it must be divided by 10 to give a rate per year. D: dividing the 14 thousand change by 5 uses the distance from the middle point to one endpoint, but the two points used are 10 years apart.

**N-4.1-B-v3.** The fuel in a vehicle's tank, in gallons, t hours into a trip is G(t). Selected values are given.

t | G(t)
1 | 40
3 | 34
5 | 31

Using the table values at t = 1 and t = 5 to estimate the rate at which the fuel is changing at t = 3, which statement is correct?

- A. The fuel is increasing at about 2.25 gallons per hour at t = 3.
- B. The fuel is decreasing at about 11.3 gallons per hour at t = 3.
- C. The fuel is decreasing at about 9 gallons per hour at t = 3.
- **D. The fuel is decreasing at about 2.25 gallons per hour at t = 3.**

Check: G′(3) ≈ (G(5) − G(1))/(5 − 1) = (31 − 40)/4 = −2.25 gallons per hour.
Rationales: A: the tank level falls from 40 to 31 gallons, so the difference quotient (31 − 40)/4 is negative; a positive rate would mean the tank is being filled. B: 34/3 is about 11.3 and divides the fuel level by the time elapsed, which is a ratio of values and not the rate at which the level is changing. C: 9 is the total drop in fuel over the four-hour interval from t = 1 to t = 5; it must be divided by 4 to give a rate per hour.

---

## Seed N-4.2-A (new) — Topic 4.2 Straight-Line Motion: Connecting Position, Velocity, and Acceleration
**Skill:** decide when a particle is speeding up by comparing the signs of velocity and acceleration, not either sign alone.

A particle moves along the x-axis with velocity v(t) = t² − 5t + 4 for 0 ≤ t ≤ 6. On which time intervals is the particle speeding up?

- **A. 1 < t < 2.5 and 4 < t < 6**
- B. 0 < t < 1 and 4 < t < 6
- C. 2.5 < t < 6
- D. 1 < t < 4

Check: v = (t − 1)(t − 4) and a = 2t − 5. v and a are both negative on 1 < t < 2.5 and both positive on 4 < t < 6, so the particle speeds up exactly there.
Rationales: B: these are the intervals where v is positive; speeding up needs v and a to share a sign, and on 0 < t < 1 the velocity is positive while a = 2t − 5 is negative, so the particle slows down. C: this is where a is positive, but on 2.5 < t < 4 the velocity is negative while a is positive, so the particle is slowing down on that stretch. D: this is where v is negative, meaning the particle moves left, but moving left is not the same as speeding up; on 2.5 < t < 4 the acceleration is positive, so it slows.

**N-4.2-A-v1.** A particle moves along the x-axis with velocity v(t) = t² − 6t + 8 for 0 ≤ t ≤ 6. On which time intervals is the particle speeding up?

- A. 0 < t < 2 and 4 < t < 6
- **B. 2 < t < 3 and 4 < t < 6**
- C. 3 < t < 6
- D. 2 < t < 4

Check: v = (t − 2)(t − 4) and a = 2t − 6. Both are negative on 2 < t < 3 and both are positive on 4 < t < 6, so the particle speeds up exactly there.
Rationales: A: these are the intervals where v is positive; on 0 < t < 2 the acceleration a = 2t − 6 is negative while v is positive, so the particle is slowing down there. C: this is where a is positive, but on 3 < t < 4 the velocity is negative while the acceleration is positive, so the particle is slowing down on that stretch. D: this is where v is negative, so the particle moves left, but moving left does not mean speeding up; on 3 < t < 4 the acceleration is positive and the speed falls.

**N-4.2-A-v2.** A particle moves along the x-axis with velocity v(t) = 2cos t for 0 ≤ t ≤ 2π. On which time intervals is the particle speeding up?

- **A. π/2 < t < π and 3π/2 < t < 2π**
- B. 0 < t < π/2 and 3π/2 < t < 2π
- C. π < t < 2π
- D. π/2 < t < 3π/2

Check: a = −2sin t. v and a are both negative on π/2 < t < π (cos t < 0, sin t > 0) and both positive on 3π/2 < t < 2π (cos t > 0, sin t < 0).
Rationales: B: these are the intervals where v is positive; on 0 < t < π/2 the acceleration a = −2sin t is negative while v is positive, so the particle is slowing down there. C: this is where a is positive, but on π < t < 3π/2 the velocity is negative while the acceleration is positive, so the particle is slowing down on that stretch. D: this is where v is negative, but moving left is not the same as speeding up; on π < t < 3π/2 the acceleration is positive, so the speed is falling.

**N-4.2-A-v3.** A particle moves along the x-axis with velocity v(t) = −t² + 6t − 5 for 0 ≤ t ≤ 7. On which time intervals is the particle speeding up?

- A. 1 < t < 5
- B. 0 < t < 3
- **C. 1 < t < 3 and 5 < t < 7**
- D. 0 < t < 1 and 5 < t < 7

Check: v = −(t − 1)(t − 5) and a = −2t + 6. Both are positive on 1 < t < 3 and both are negative on 5 < t < 7, so the particle speeds up exactly there.
Rationales: A: this is where v is positive, so the particle moves right, but moving right is not the same as speeding up; on 3 < t < 5 the acceleration a = −2t + 6 is negative and the speed falls. B: this is where a is positive, but on 0 < t < 1 the velocity is negative while the acceleration is positive, so the particle is slowing down there. D: these are the intervals where v is negative, so the particle moves left; on 0 < t < 1 the acceleration is positive, so the speed is falling and not rising.

---

## Seed N-4.2-B (new) — Topic 4.2 Straight-Line Motion: Connecting Position, Velocity, and Acceleration
**Skill:** distinguish total distance traveled from displacement and final position when velocity changes sign.

A particle moves along a horizontal line with velocity v(t) = 3t² − 12t + 9 for 0 ≤ t ≤ 4. Its position at t = 0 is x(0) = 2. What is the total distance traveled by the particle from t = 0 to t = 4?

- A. 4
- B. 6
- C. 8
- **D. 12**

Check: v = 3(t − 1)(t − 3), and an antiderivative is t³ − 6t² + 9t, which equals 0 at t = 0, 4 at t = 1, 0 at t = 3 and 4 at t = 4. Distance = |4 − 0| + |0 − 4| + |4 − 0| = 12.
Rationales: A: this is the displacement x(4) − x(0); it lets the leftward motion on 1 < t < 3 cancel part of the rightward motion instead of adding to the distance. B: this is the final position x(4) = 2 + 4, which includes the starting position and is not a distance traveled. C: this counts only 0 ≤ t ≤ 3 and leaves out the final stretch 3 ≤ t ≤ 4, where the particle moves right again by 4 units.

**N-4.2-B-v1.** A particle moves along a horizontal line with velocity v(t) = 6t² − 30t + 24 for 0 ≤ t ≤ 5. Its position at t = 0 is x(0) = 3. What is the total distance traveled by the particle from t = 0 to t = 5?

- **A. 49**
- B. 5
- C. 22
- D. 38

Check: v = 6(t − 1)(t − 4), and an antiderivative is 2t³ − 15t² + 24t, which equals 0 at t = 0, 11 at t = 1, −16 at t = 4 and −5 at t = 5. Distance = 11 + 27 + 11 = 49.
Rationales: B: this is the size of the displacement x(5) − x(0) = −5; the rightward and leftward motion partly cancel in displacement but both count toward distance. C: this adds only the two stretches where v is positive, 11 each, and omits the 27 units traveled while the particle moves left. D: this adds the first two stretches, 11 and 27, but leaves out the final stretch 4 ≤ t ≤ 5, where the particle moves right by another 11 units.

**N-4.2-B-v2.** A particle moves along a horizontal line with velocity v(t) = cos t for 0 ≤ t ≤ 3π/2. Its position at t = 0 is x(0) = 5. What is the total distance traveled by the particle from t = 0 to t = 3π/2?

- A. 1
- **B. 3**
- C. 2
- D. 4

Check: The integral of |cos t| splits at t = π/2: ∫ from 0 to π/2 of cos t dt = 1 and ∫ from π/2 to 3π/2 of |cos t| dt = 2. Total distance = 1 + 2 = 3.
Rationales: A: this is the size of the displacement, sin(3π/2) − sin 0 = −1, in which the leftward and rightward motion cancel; distance adds them instead. C: this counts only the leftward motion on π/2 < t < 3π/2 and leaves out the 1 unit traveled right on 0 < t < π/2. D: this is the final position x(3π/2) = 5 − 1, which includes the starting position and is not a distance traveled.

**N-4.2-B-v3.** A particle moves along a horizontal line with velocity v(t) = 4 − t² for 0 ≤ t ≤ 4. Its position at t = 0 is x(0) = 1. What is the total distance traveled by the particle from t = 0 to t = 4?

- A. 16/3
- B. 32/3
- C. 13/3
- **D. 16**

Check: An antiderivative is 4t − t³/3, which equals 0 at t = 0, 16/3 at t = 2 and −16/3 at t = 4. Distance = 16/3 + |−16/3 − 16/3| = 16/3 + 32/3 = 16.
Rationales: A: this is the size of the net change in position, −16/3, in which the rightward and leftward motion partly cancel; distance counts both stretches in full. B: this counts only the leftward motion on 2 < t < 4 and leaves out the 16/3 units traveled right on 0 < t < 2. C: this is the size of the final position x(4) = 1 − 16/3 = −13/3, which includes the starting position and is not a distance traveled.

---

## Seed N-4.3-A (new) — Topic 4.3 Rates of Change in Applied Contexts Other Than Motion
**Skill:** combine marginal revenue and marginal cost into a marginal profit and read the sign of the second derivative as the trend of that rate.

A company's revenue from selling x hundred units is R(x) = 50x − 0.5x² thousand dollars and its cost is C(x) = 20 + 12x + 0.1x² thousand dollars. Which statement is correct at x = 20?

- **A. Profit is increasing at 14 thousand dollars per hundred units, and that rate of increase is itself decreasing.**
- B. Profit is increasing at 30 thousand dollars per hundred units, and that rate of increase is itself decreasing.
- C. Profit is increasing at 14 thousand dollars per hundred units, and that rate of increase is itself increasing.
- D. Profit is increasing at 46 thousand dollars per hundred units, and that rate of increase is itself decreasing.

Check: P(x) = R(x) − C(x), so P′(x) = (50 − x) − (12 + 0.2x) = 38 − 1.2x and P′(20) = 14 > 0. P″(x) = −1.2 < 0, so the rate of profit increase is itself decreasing.
Rationales: B: R′(20) = 30 is only the marginal revenue; the marginal profit also subtracts the marginal cost C′(20) = 16. C: P″ = R″ − C″ = −1 − 0.2 = −1.2 is negative, so the marginal profit is falling; claiming that the rate of increase is itself increasing gets the sign of P″ wrong. D: 46 = 30 + 16 adds marginal revenue and marginal cost; profit is revenue minus cost, so the marginal cost must be subtracted.

**N-4.3-A-v1.** A bakery's revenue from selling x cakes in a day is R(x) = 9x − 0.04x² dollars and its cost is C(x) = 30 + 2x + 0.03x² dollars. Which statement is correct at x = 90?

- A. Profit is decreasing at $7.40 per cake, and it is decreasing faster as x increases.
- **B. Profit is decreasing at $5.60 per cake, and it is decreasing faster as x increases.**
- C. Profit is decreasing at $5.60 per cake, but it is decreasing more slowly as x increases.
- D. Profit is increasing at $9.20 per cake, and it is decreasing faster as x increases.

Check: P′(x) = (9 − 0.08x) − (2 + 0.06x) = 7 − 0.14x, so P′(90) = −5.6. P″(x) = −0.14 < 0, so the rate of profit change keeps falling and profit declines faster.
Rationales: A: 7.40 is the marginal cost C′(90) alone; the marginal profit also includes the marginal revenue R′(90) = 1.80. C: P″ = R″ − C″ = −0.08 − 0.06 = −0.14 is negative, so the profit rate keeps falling; a negative P′ with a negative P″ means the decline is speeding up. D: 9.20 = 1.80 + 7.40 adds marginal revenue and marginal cost; profit is revenue minus cost, so marginal cost is subtracted, giving a negative rate.

**N-4.3-A-v2.** A shop sells x units of an item at a constant price of $14 each, so its revenue is R(x) = 14x dollars. Its cost is C(x) = 100 + 6x + 40√x dollars. Which statement is correct at x = 25?

- A. Profit is increasing at $14.00 per unit, and the rate of increase is itself increasing.
- B. Profit is increasing at $4.00 per unit, and the rate of increase is decreasing.
- C. Profit is decreasing at $10.00 per unit, and the rate of decrease is itself decreasing.
- **D. Profit is increasing at $4.00 per unit, and the rate of increase is itself increasing.**

Check: P′(x) = 14 − (6 + 20/√x), so P′(25) = 14 − 10 = 4 > 0. C″(x) = −10x^(−3/2) < 0, so P″(x) = −C″(x) > 0 and the rate of profit increase is itself increasing.
Rationales: A: 14 is the marginal revenue alone; the marginal profit also subtracts the marginal cost C′(25) = 6 + 20/5 = 10. B: C″(x) = −10x^(−3/2) is negative, so C′ is falling; profit's rate 14 − C′(x) therefore rises, and P″ = −C″ is positive, not negative. C: 10 is the marginal cost alone; the marginal revenue of 14 per unit must also be included, which makes the profit rate positive.

**N-4.3-A-v3.** A shop sells x units of an item at a constant price of $4 each, so its revenue is R(x) = 4x dollars. Its cost is C(x) = 10 + 60√x dollars. Which statement is correct at x = 25?

- A. Profit is decreasing at $6.00 per unit, and it is decreasing more slowly as x increases.
- B. Profit is decreasing at $2.00 per unit, and it is decreasing faster as x increases.
- C. Profit is increasing at $2.00 per unit, and it is increasing faster as x increases.
- **D. Profit is decreasing at $2.00 per unit, and it is decreasing more slowly as x increases.**

Check: P′(x) = 4 − 30/√x, so P′(25) = 4 − 6 = −2. C″(x) = −15x^(−3/2), so P″(25) = 15/125 = 0.12 > 0 and the profit rate rises toward zero, meaning profit declines more slowly.
Rationales: A: 6 is the marginal cost C′(25) = 30/5 alone; the marginal profit also includes the marginal revenue of 4 per unit. B: C″(x) = −15x^(−3/2) is negative, so C′ is falling and P″ = −C″ is positive; the profit rate rises toward zero, so the decrease slows down. C: this finds C′ − R′ instead of R′ − C′; marginal cost 6 exceeds marginal revenue 4, so the profit rate is negative and profit is falling.

---

## Seed N-4.3-B (new) — Topic 4.3 Rates of Change in Applied Contexts Other Than Motion
**Skill:** differentiate a rational or exponential model, with units, and compare the instantaneous rate to an average rate over an interval.

The concentration of a drug in the blood, in mg/L, is C(t) = 8t/(t + 3), where t is the number of hours after the dose. Which statement is correct?

- A. At t = 3 the concentration is rising at 4 mg/L per hour, which is faster than its average rate of 8/9 mg/L per hour over [0, 6].
- **B. At t = 3 the concentration is rising at 2/3 mg/L per hour, which is slower than its average rate of 8/9 mg/L per hour over [0, 6].**
- C. At t = 3 the concentration is rising at 4/3 mg/L per hour, which is faster than its average rate of 8/9 mg/L per hour over [0, 6].
- D. At t = 3 the concentration is falling at 2/3 mg/L per hour, while its average rate over [0, 6] is 8/9 mg/L per hour.

Check: C′(t) = [8(t + 3) − 8t]/(t + 3)² = 24/(t + 3)², so C′(3) = 24/36 = 2/3. The average rate is (C(6) − C(0))/6 = (16/3)/6 = 8/9, and 2/3 < 8/9.
Rationales: A: the quotient rule gives C′(t) = 24/(t + 3)²; 24/(t + 3) = 4 leaves out squaring the denominator. C: 8/(t + 3) = 4/3 differentiates only the numerator and divides by the denominator; the quotient rule also needs the term from differentiating the denominator. D: the quotient rule numerator is 8(t + 3) − 8t = 24, which is positive, so C′(3) is positive and the concentration is rising, not falling.

**N-4.3-B-v1.** The number of bacteria, in thousands, in a culture is P(t) = 60t/(t + 4), where t is the number of hours after the culture is started. Which statement is correct?

- A. At t = 1 the population is growing at 48 thousand per hour, which is faster than its average rate of 5 thousand per hour over [0, 8].
- B. At t = 1 the population is growing at 12 thousand per hour, which is faster than its average rate of 5 thousand per hour over [0, 8].
- **C. At t = 1 the population is growing at 9.6 thousand per hour, which is faster than its average rate of 5 thousand per hour over [0, 8].**
- D. At t = 1 the population is shrinking at 9.6 thousand per hour, while its average rate over [0, 8] is 5 thousand per hour.

Check: P′(t) = [60(t + 4) − 60t]/(t + 4)² = 240/(t + 4)², so P′(1) = 240/25 = 9.6. The average rate is (P(8) − P(0))/8 = 40/8 = 5, and 9.6 > 5.
Rationales: A: the quotient rule gives P′(t) = 240/(t + 4)²; 240/(t + 4) = 48 leaves out squaring the denominator. B: 60/(t + 4) = 12 differentiates only the numerator and divides by the denominator; the quotient rule also needs the term from differentiating the denominator. D: the quotient rule numerator is 60(t + 4) − 60t = 240, which is positive, so P′(1) is positive and the population is growing, not shrinking.

**N-4.3-B-v2.** The amount of salt dissolved from a crystal after t minutes is Q(t) = 5(1 − e^(−0.4t)) grams. Which statement is correct?

- A. At t = 3 the salt is dissolving at about 1.51 grams per minute, which is faster than its average rate of about 0.86 grams per minute over [0, 5].
- B. At t = 3 the salt is dissolving at about −0.60 grams per minute, which is slower than its average rate of about 0.86 grams per minute over [0, 5].
- **C. At t = 3 the salt is dissolving at about 0.60 grams per minute, which is slower than its average rate of about 0.86 grams per minute over [0, 5].**
- D. At t = 3 the salt is dissolving at about 0.12 grams per minute, which is slower than its average rate of about 0.86 grams per minute over [0, 5].

Check: Q′(t) = 5(0.4)e^(−0.4t) = 2e^(−0.4t), so Q′(3) = 2e^(−1.2) ≈ 0.602. The average rate is (Q(5) − Q(0))/5 = 5(1 − e^(−2))/5 ≈ 0.865, and 0.602 < 0.865.
Rationales: A: this omits the chain-rule factor 0.4 from differentiating the exponent: Q′(t) = 5·0.4e^(−0.4t) = 2e^(−0.4t), not 5e^(−0.4t). B: the derivative of −e^(−0.4t) is +0.4e^(−0.4t); keeping the minus sign makes the rate negative, but the amount dissolved is increasing. D: this drops the constant 5 and gets 0.4e^(−1.2); the factor 5 multiplies the whole derivative, giving 5·0.4e^(−1.2) = 2e^(−1.2).

**N-4.3-B-v3.** The height of a plant, in centimeters, is H(t) = 12 ln(t + 1), where t is the number of days after planting. Which statement is correct?

- **A. At t = 5 the plant is growing at 2 cm per day, which is slower than its average rate of about 3.30 cm per day over [0, 8].**
- B. At t = 5 the plant is growing at about 4.30 cm per day, which is faster than its average rate of about 3.30 cm per day over [0, 8].
- C. At t = 5 the plant is growing at 2.4 cm per day, which is slower than its average rate of about 3.30 cm per day over [0, 8].
- D. At t = 5 the plant is growing at about 0.33 cm per day, which is slower than its average rate of about 3.30 cm per day over [0, 8].

Check: H′(t) = 12/(t + 1), so H′(5) = 2. The average rate is (H(8) − H(0))/8 = 12 ln 9/8 ≈ 3.296, and 2 < 3.296.
Rationales: B: 12 ln 6/5 ≈ 4.30 is the average rate over [0, 5], not the instantaneous rate; the derivative H′(t) = 12/(t + 1) must be evaluated at t = 5. C: 12/t = 2.4 differentiates ln(t + 1) as 1/t, forgetting the +1 inside the log; the derivative of ln(t + 1) is 1/(t + 1). D: 12/(t + 1)² = 1/3 uses a squared denominator, which belongs to the quotient rule; the derivative of ln(t + 1) is simply 1/(t + 1).

---

## Seed N-4.4-A (new) — Topic 4.4 Introduction to Related Rates
**Skill:** relate a changing hypotenuse to a changing leg by differentiating the Pythagorean relationship before substituting values.

A drone flies horizontally at a constant altitude of 60 m. An observer stands on the ground, and the drone moves away at 10 m/s. At the instant when its horizontal distance from the observer is 80 m, how fast is the straight-line distance from the observer to the drone increasing?

- A. 10 m/s
- B. 12.5 m/s
- C. 6 m/s
- **D. 8 m/s**

Check: D² = x² + 60², so 2D·D′ = 2x·x′ and D′ = (x/D)x′. At x = 80, D = 100, so D′ = (80/100)(10) = 8 m/s.
Rationales: A: this treats the straight-line distance as changing at the same rate as the horizontal distance, but D′ = (x/D)x′ is smaller because the hypotenuse D = 100 is longer than x = 80. B: this inverts the ratio: D′ = (x/D)(x′) uses x/D = 0.8, not D/x = 1.25, and the hypotenuse cannot grow faster than the leg that drives it here. C: this multiplies by the altitude ratio 60/100 instead of the horizontal ratio 80/100; the altitude is constant and its rate is zero, so x is the factor that appears.

**N-4.4-A-v1.** A boat is pulled toward a dock by a rope attached to its bow and passing through a ring on the dock that is 6 ft above the bow. The rope is pulled in at 2 ft/s. When 10 ft of rope is out, how fast is the boat approaching the dock?

- **A. 2.5 ft/s**
- B. 2 ft/s
- C. 1.6 ft/s
- D. 1.2 ft/s

Check: x² + 6² = L², so 2x·x′ = 2L·L′ and x′ = (L/x)L′. At L = 10, x = 8, so x′ = (10/8)(−2) = −2.5; the boat approaches at 2.5 ft/s.
Rationales: B: this assumes the boat moves at the same rate as the rope, but the rope is the hypotenuse and the boat's horizontal distance changes at (L/x)(L′), which is faster. C: this inverts the ratio: x′ = (L/x)L′ uses L/x = 10/8, and the factor 8/10 puts the larger length in the wrong place, giving a slower rate. D: this multiplies by the ring height ratio 6/10 instead of L/x; the height is constant, so only the horizontal distance x enters the relationship.

**N-4.4-A-v2.** At a certain moment car P is 3 miles east of an intersection and moving toward it at 30 mph, while car Q is 4 miles north of the intersection and moving away from it at 40 mph. At that moment, how fast is the distance between the cars changing?

- A. Increasing at 10 mph
- B. Increasing at 70 mph
- **C. Increasing at 14 mph**
- D. Not changing, at 0 mph

Check: D² = x² + y², so D′ = (x·x′ + y·y′)/D. With x = 3, x′ = −30, y = 4, y′ = 40 and D = 5, D′ = (−90 + 160)/5 = 14 mph.
Rationales: A: this adds the signed speeds, −30 + 40, as if the distance between the cars were a straight line along one road, ignoring that the distance is a hypotenuse. B: this computes x·x′ + y·y′ = 70 but forgets to divide by the distance D = 5; the relationship is D′ = (x·x′ + y·y′)/D. D: this pairs each speed with the other car's distance, 4(−30) + 3(40) = 0; x′ must be multiplied by x and y′ by y.

**N-4.4-A-v3.** The legs of a right triangular metal plate are x cm and y cm. As the plate is heated, x increases at 3 cm/min and y decreases at 2 cm/min. When x = 6 and y = 8, how fast is the hypotenuse changing?

- **A. Increasing at 0.2 cm/min**
- B. Increasing at 1 cm/min
- C. Increasing at 2 cm/min
- D. Increasing at 3.4 cm/min

Check: z² = x² + y², so z′ = (x·x′ + y·y′)/z. With x = 6, y = 8, z = 10, z′ = (6·3 + 8·(−2))/10 = 2/10 = 0.2 cm/min.
Rationales: B: this adds the leg rates, 3 − 2 = 1, as if the hypotenuse were the sum of the legs; the hypotenuse satisfies z² = x² + y² and does not add linearly. C: this computes x·x′ + y·y′ = 18 − 16 = 2 but does not divide by the hypotenuse z = 10; the rate is (x·x′ + y·y′)/z. D: this treats the decreasing leg as increasing, using 18 + 16 = 34 divided by 10; the rate of y is −2, so its term is 8(−2) = −16.

---

## Seed N-4.4-B (new) — Topic 4.4 Introduction to Related Rates
**Skill:** set up the volume relationship for a cone or trough using the stated shape constraint, so that only one variable changes before differentiating.

Sand falls from a conveyor at 10 ft³/min and forms a conical pile whose height always equals its base diameter. How fast is the height of the pile increasing when the height is 4 ft?

- **A. 5/(2π) ft/min**
- B. 15/(2π) ft/min
- C. 5/(8π) ft/min
- D. 5/(32π) ft/min

Check: With r = h/2, V = (1/3)π(h/2)²h = πh³/12, so dV/dt = (π/4)h²·dh/dt. At h = 4, 10 = 4π·dh/dt, so dh/dt = 5/(2π) ft/min.
Rationales: B: this treats the radius as a constant 2 ft when differentiating V = (1/3)πr²h, so only the height changes; the radius r = h/2 grows with the height and must be replaced first. C: this uses r = h, taking the height to equal the radius, but the height equals the base diameter, so r = h/2 and V = πh³/12. D: this inverts the relationship and uses r = 2h; the height equals the diameter 2r, so the radius is half the height, r = h/2.

**N-4.4-B-v1.** Gravel falls from a hopper at 6 ft³/min and forms a conical pile whose height is always 3 times its base radius. How fast is the height of the pile increasing when the height is 3 ft?

- A. 18/π ft/min
- **B. 6/π ft/min**
- C. 2/(3π) ft/min
- D. 2/(27π) ft/min

Check: With r = h/3, V = (1/3)π(h/3)²h = πh³/27, so dV/dt = (π/9)h²·dh/dt. At h = 3, 6 = π·dh/dt, so dh/dt = 6/π ft/min.
Rationales: A: this treats the radius as a constant 1 ft when differentiating V = (1/3)πr²h; the radius r = h/3 grows with the height and must be replaced before differentiating. C: this uses r = h, taking the radius to equal the height, but the height is 3 times the radius, so r = h/3 and V = πh³/27. D: this inverts the relationship and uses r = 3h; the height is three times the radius, so r = h/3 and not 3h.

**N-4.4-B-v2.** A horizontal trough is 10 ft long and its ends are triangles. The width of the water surface is always 1.5 times the depth h of the water. Water is poured in at 6 ft³/min. How fast is the depth increasing when the depth is 2 ft?

- A. 0.1 ft/min
- **B. 0.2 ft/min**
- C. 0.4 ft/min
- D. 0.45 ft/min

Check: The end area is (1/2)(1.5h)(h) = 0.75h², so V = 7.5h² and dV/dt = 15h·dh/dt. At h = 2, 6 = 30·dh/dt, so dh/dt = 0.2 ft/min.
Rationales: A: this leaves out the factor 1/2 in the triangle's area, using V = 10(1.5h)(h) = 15h² instead of V = 10·(1/2)(1.5h)(h) = 7.5h². C: this treats the surface width as a constant 3 ft when differentiating; the width 1.5h grows with the depth and must be replaced by 1.5h before differentiating. D: this inverts the ratio and uses width = h/1.5; the width is 1.5 times the depth, so the cross-sectional area is (1/2)(1.5h)(h) = 0.75h².

**N-4.4-B-v3.** Salt falls onto a table at 24 cm³/min and forms a conical pile whose base radius is always twice its height. How fast is the height of the pile increasing when the height is 3 cm?

- A. 2/π cm/min
- B. 8/(3π) cm/min
- **C. 2/(3π) cm/min**
- D. 32/(3π) cm/min

Check: With r = 2h, V = (1/3)π(2h)²h = 4πh³/3, so dV/dt = 4πh²·dh/dt. At h = 3, 24 = 36π·dh/dt, so dh/dt = 2/(3π) cm/min.
Rationales: A: this treats the radius as a constant 6 cm when differentiating V = (1/3)πr²h; the radius r = 2h grows with the height and must be replaced before differentiating. B: this uses r = h, taking the radius to equal the height, but the radius is twice the height, so V = (1/3)π(2h)²h = 4πh³/3. D: this inverts the relationship and uses r = h/2; the radius is twice the height, so r = 2h and not h/2.

---

## Seed N-4.5-A (new) — Topic 4.5 Solving Related Rates Problems
**Skill:** solve a related-rates problem involving an angle or similar triangles by differentiating the trigonometric or proportional relationship.

A camera on the ground is 90 m horizontally from the point where a drone lifts straight up at 15 m/s. When the drone is 120 m above the ground, how fast is the camera's angle of elevation to the drone changing?

- A. 1/6 radian per second
- B. 25/54 radian per second
- **C. 0.06 radian per second**
- D. 3/32 radian per second

Check: tan θ = h/90, so sec²θ·θ′ = h′/90. At h = 120 the hypotenuse is 150, cos θ = 3/5 and sec²θ = 25/9, so θ′ = (15/90)(9/25) = 0.06 radian per second.
Rationales: A: this differentiates tan θ = h/90 but treats dθ/dt as h′/90, dropping the factor sec²θ that comes from the chain rule on tan θ. B: this multiplies (1/6) by sec²θ = 25/9, but the equation sec²θ·θ′ = h′/90 requires dividing by sec²θ, which is the same as multiplying by cos²θ. D: this takes cos²θ as (90/120)², mixing up the hypotenuse with the height; at h = 120 the hypotenuse is 150 and cos θ = 90/150.

**N-4.5-A-v1.** A person 1.8 m tall walks directly away from a lamp post 6 m tall at 1.2 m/s. How fast is the tip of the person's shadow moving along the ground?

- A. 1.2 m/s
- **B. 12/7 m/s**
- C. 18/35 m/s
- D. 4 m/s

Check: Let x be the person's distance from the lamp and T the tip's distance. Similar triangles give T/6 = (T − x)/1.8, so T = (10/7)x and T′ = (10/7)(1.2) = 12/7 m/s.
Rationales: A: this assumes the tip of the shadow moves at the same speed as the person, but similar triangles show the tip must move faster to stay ahead of the person. C: this is the rate at which the shadow's length is growing, not the speed of its tip; the tip also moves with the person, so its speed is the sum. D: this uses the ratio 6/1.8 from the heights directly; the similar triangles give 6/(6 − 1.8) = 10/7, not 6/1.8, as the factor multiplying the walking speed.

**N-4.5-A-v2.** A lighthouse is 3 km from a straight shore. Its beam rotates at 0.2 radian per minute and sweeps a spot along the shore. When the spot is 4 km from the point on shore nearest the lighthouse, how fast is the spot moving along the shore?

- A. 0.6 km/min
- B. 16/15 km/min
- **C. 5/3 km/min**
- D. 0.216 km/min

Check: x = 3 tan θ, so x′ = 3 sec²θ·θ′. At x = 4 the beam length is 5, so sec θ = 5/3 and x′ = 3(25/9)(0.2) = 5/3 km/min.
Rationales: A: this uses x′ = 3θ′ and leaves out the factor sec²θ that comes from differentiating x = 3 tan θ. B: this takes sec²θ as (4/3)², mixing the shore distance 4 with the secant; at x = 4 the beam length is 5, so sec θ = 5/3 and sec²θ = 25/9. D: this multiplies by cos²θ = 9/25 instead of sec²θ = 25/9; differentiating x = 3 tan θ gives x′ = 3 sec²θ·θ′.

**N-4.5-A-v3.** Two sides of a triangular sail are 8 m and 10 m long, and the angle θ between them increases at 0.1 radian per second. How fast is the area of the sail changing when θ = π/6?

- **A. 2√3 m²/s**
- B. 2 m²/s
- C. 4 m²/s
- D. 4√3 m²/s

Check: A = (1/2)(8)(10) sin θ = 40 sin θ, so A′ = 40 cos θ·θ′. At θ = π/6, A′ = 40(√3/2)(0.1) = 2√3 m²/s.
Rationales: B: this uses sin(π/6) = 1/2 where the derivative of the area A = 40 sin θ, namely 40 cos θ·θ′, needs cos(π/6) = √3/2. C: this multiplies 40 by θ′ and drops the trigonometric factor entirely; the derivative of sin θ is cos θ, which must be evaluated at π/6. D: this uses A = 80 sin θ and omits the factor 1/2 in the triangle area formula A = (1/2)(8)(10) sin θ = 40 sin θ.

---

## Seed N-4.5-B (new) — Topic 4.5 Solving Related Rates Problems
**Skill:** apply the product rule to a quantity that depends on two changing variables, keeping the sign of each rate.

The radius of a cylindrical can increases at 0.2 cm/s while its height decreases at 0.5 cm/s. At the instant when r = 4 cm and h = 10 cm, which statement about the volume V = πr²h is correct?

- **A. The volume is increasing at 8π cm³/s.**
- B. The volume is increasing at 16π cm³/s.
- C. The volume is increasing at 24π cm³/s.
- D. The volume is decreasing at 0.8π cm³/s.

Check: V′ = π(2rh·r′ + r²·h′) = π(2·4·10·0.2 + 16·(−0.5)) = π(16 − 8) = 8π cm³/s, so the volume is increasing.
Rationales: B: this accounts for the growing radius, 2πrh·r′ = 16π, but leaves out the term πr²·h′ from the shrinking height. C: this treats the height's rate as +0.5 when computing πr²h′, adding 8π instead of subtracting it; the height is decreasing, so h′ = −0.5. D: this multiplies the derivatives of the factors, π(2rr′)(h′), instead of using the product rule, which gives 2πrh·r′ + πr²·h′.

**N-4.5-B-v1.** The length of a rectangular plate increases at 0.3 cm/s while its width decreases at 0.4 cm/s. At the instant when the length is 12 cm and the width is 8 cm, which statement about the area is correct?

- A. The area is increasing at 7.2 cm²/s.
- B. The area is decreasing at 0.12 cm²/s.
- C. The area is increasing at 0.4 cm²/s.
- **D. The area is decreasing at 2.4 cm²/s.**

Check: A = ℓw, so A′ = ℓ′w + ℓw′ = (0.3)(8) + (12)(−0.4) = 2.4 − 4.8 = −2.4 cm²/s, so the area is decreasing.
Rationales: A: this treats the width's rate as +0.4, adding 12(0.4) = 4.8 to 0.3(8) = 2.4; the width is decreasing, so w′ = −0.4 and that term is −4.8. B: this multiplies the two rates, ℓ′·w′ = (0.3)(−0.4), instead of using the product rule A′ = ℓ′w + ℓw′. C: this computes ℓ·ℓ′ + w·w′ = 3.6 − 3.2, pairing each rate with its own dimension; the product rule pairs ℓ′ with w and w′ with ℓ.

**N-4.5-B-v2.** A sealed syringe holds a gas whose pressure P and volume V satisfy PV = k at constant temperature. At the instant when P = 200 kPa and V = 1.5 L, the pressure is increasing at 10 kPa/min. Which statement is correct?

- A. The volume is increasing at 0.075 L/min.
- B. The volume is decreasing at 0.05 L/min.
- C. The volume is decreasing at about 1333 L/min.
- **D. The volume is decreasing at 0.075 L/min.**

Check: PV = k gives P′V + PV′ = 0, so V′ = −V·P′/P = −(1.5)(10)/200 = −0.075 L/min.
Rationales: A: differentiating PV = k gives P′V + PV′ = 0, so V′ = −VP′/P is negative; rising pressure at constant temperature means shrinking volume. B: this uses V′ = −P′/P and drops the factor V = 1.5; solving P′V + PV′ = 0 gives V′ = −VP′/P = −1.5(10)/200. C: this inverts the ratio, V′ = −(P/V)P′, but solving P′V + PV′ = 0 for V′ gives −(V/P)P′, with V on top.

**N-4.5-B-v3.** The radius of a cone increases at 0.5 cm/s while its height decreases at 1 cm/s. At the instant when r = 6 cm and h = 9 cm, which statement about the volume V = (1/3)πr²h is correct?

- A. The volume is increasing at 18π cm³/s.
- **B. The volume is increasing at 6π cm³/s.**
- C. The volume is increasing at 30π cm³/s.
- D. The volume is decreasing at 2π cm³/s.

Check: V′ = (π/3)(2rh·r′ + r²·h′) = (π/3)(2·6·9·0.5 + 36·(−1)) = (π/3)(54 − 36) = 6π cm³/s, so the volume is increasing.
Rationales: A: this applies the product rule correctly but leaves out the factor 1/3 from V = (1/3)πr²h, tripling the result. C: this treats the height's rate as +1 and adds r² to 2rh·r′ inside the parentheses; the height is decreasing, so h′ = −1. D: this multiplies the derivatives of the factors, (π/3)(2rr′)(h′), instead of using the product rule, which gives (π/3)(2rh·r′ + r²·h′).

---

## Seed N-4.6-A (new) — Topic 4.6 Approximating Values of a Function Using Local Linearity and Linearization
**Skill:** use a tangent-line approximation at the correct point and decide whether it overestimates or underestimates from the concavity of the function.

A differentiable function f has f(3) = 4, and f′ is decreasing on the interval [2, 4]. Selected values of f′ are given.

x | f′(x)
2.5 | 1.5
3 | 1.1
3.5 | 0.6
4 | 0.2

The tangent line at x = 3 is used to approximate f(3.4). Which statement is correct?

- A. The approximation is 4.44, and it is an underestimate of f(3.4).
- B. The approximation is 4.24, and it is an overestimate of f(3.4).
- C. The approximation is 3.56, and it is an underestimate of f(3.4).
- **D. The approximation is 4.44, and it is an overestimate of f(3.4).**

Check: L(x) = f(3) + f′(3)(x − 3) = 4 + 1.1(0.4) = 4.44. Since f′ is decreasing, f″ < 0, the graph is concave down and lies below its tangent line, so 4.44 overestimates f(3.4).
Rationales: A: f′ is decreasing, so f″ < 0 and f is concave down; a tangent line to a concave-down graph lies above the graph, so it overestimates. B: this uses the slope f′(3.5) = 0.6, the table value nearest 3.4, but the tangent line at x = 3 must use the slope at the point of tangency, f′(3) = 1.1. C: this subtracts f′(3)(0.4) even though 3.4 is to the right of 3; the tangent line gives f(3) + f′(3)(3.4 − 3) = 4 + 0.44.

**N-4.6-A-v1.** Let h(x) = e^(x/2). The tangent line at x = 0 is used to approximate h(0.6). Which statement is correct?

- A. The approximation is 1.3, and it is an overestimate of h(0.6).
- **B. The approximation is 1.3, and it is an underestimate of h(0.6).**
- C. The approximation is 1.6, and it is an overestimate of h(0.6).
- D. The approximation is 0.7, and it is an underestimate of h(0.6).

Check: h′(0) = 1/2, so L(x) = 1 + x/2 and L(0.6) = 1.3. Since h″(x) = (1/4)e^(x/2) > 0, the graph is concave up and lies above its tangent line, so 1.3 underestimates h(0.6).
Rationales: A: h″(x) = (1/4)e^(x/2) > 0, so the graph is concave up and lies above its tangent line; the tangent line therefore underestimates. C: this uses h′(0) = 1 by omitting the chain-rule factor 1/2; the correct derivative is h′(x) = (1/2)e^(x/2), so h′(0) = 1/2. D: this subtracts h′(0)(0.6) = 0.3 from h(0) = 1 even though 0.6 is to the right of 0; the tangent line gives 1 + (1/2)(0.6).

**N-4.6-A-v2.** A twice-differentiable function f has f(10) = 20 and f′(10) = −1.5, and f′ is increasing on [10, 11]. The tangent line at x = 10 is used to approximate f(10.4). Which statement is correct?

- **A. The approximation is 19.4, and it is an underestimate of f(10.4).**
- B. The approximation is 19.4, and it is an overestimate of f(10.4).
- C. The approximation is 20.6, and it is an overestimate of f(10.4).
- D. The approximation is 18.5, and it is an underestimate of f(10.4).

Check: L(10.4) = 20 + (−1.5)(0.4) = 19.4. Since f′ is increasing, f″ > 0, the graph is concave up and lies above its tangent line, so 19.4 underestimates f(10.4).
Rationales: B: f′ is increasing, so f″ > 0 and f is concave up; the tangent line lies below the graph, so it underestimates even though the slope is negative. C: this adds 1.5(0.4) to f(10); the slope is −1.5, so the tangent line moves down as x increases, giving 20 − 1.5(0.4). D: this uses a step of 1 unit instead of 0.4; the tangent line changes by f′(10)(10.4 − 10) = −1.5(0.4) = −0.6.

**N-4.6-A-v3.** Let g(x) = x^(1/3). The tangent line at x = 27 is used to approximate the cube root of 25, which is g(25). Which statement is correct?

- A. The approximation is about 2.926, and it is an underestimate of g(25).
- **B. The approximation is about 2.926, and it is an overestimate of g(25).**
- C. The approximation is about 2.778, and it is an underestimate of g(25).
- D. The approximation is about 3.074, and it is an overestimate of g(25).

Check: g′(x) = (1/3)x^(−2/3), so g′(27) = 1/27 and L(25) = 3 + (1/27)(−2) ≈ 2.926. Since g″(x) < 0 the graph is concave down and lies below its tangent line, so L(25) overestimates g(25) ≈ 2.924.
Rationales: A: g″(x) = −(2/9)x^(−5/3) < 0, so the graph is concave down and lies below its tangent line; the tangent line therefore overestimates. C: this uses g′(27) = 1/9 by writing (1/3)x^(−1/3) instead of (1/3)x^(−2/3); the correct slope is 1/27. D: this adds 2/27 to g(27) = 3; since 25 is to the left of 27 the change is g′(27)(25 − 27) = −2/27 and the approximation is below 3.

---

## Seed N-4.6-B (new) — Topic 4.6 Approximating Values of a Function Using Local Linearity and Linearization
**Skill:** use a tangent-line model in reverse to estimate when a target value is reached, and use concavity to decide whether the true time is earlier or later.

A pie is removed from an oven at t = 10 minutes. Its temperature T(t), in degrees Fahrenheit, satisfies T(10) = 250 and T′(10) = −4, and T is concave up for t ≥ 10. The tangent line at t = 10 is used to estimate when the pie reaches 200 degrees Fahrenheit. Which statement is correct?

- A. The tangent line gives t = 22.5 minutes, and the pie actually reaches 200 degrees earlier than that.
- B. The tangent line gives t = 12.5 minutes, and the pie actually reaches 200 degrees later than that.
- C. The tangent line gives t = 62.5 minutes, and the pie actually reaches 200 degrees earlier than that.
- **D. The tangent line gives t = 22.5 minutes, and the pie actually reaches 200 degrees later than that.**

Check: L(t) = 250 − 4(t − 10) = 200 gives t = 22.5. Because T is concave up, T(t) ≥ L(t), so T(22.5) > 200 and the pie has not yet reached 200 at t = 22.5; the true time is later.
Rationales: A: T is concave up, so the graph lies above its tangent line; at t = 22.5 the true temperature is still above 200, so the pie reaches 200 later. B: solving 250 − 4(t − 10) = 200 gives t − 10 = 12.5; 12.5 is the elapsed time since t = 10, so 10 must be added to get t = 22.5. C: 250/4 = 62.5 divides the temperature by the rate instead of dividing the 50-degree drop by the rate; the equation is 250 − 4(t − 10) = 200.

**N-4.6-B-v1.** A tank is draining. At t = 5 minutes the volume is V(5) = 900 liters, and V′(5) = −30 liters per minute. V is concave up for t ≥ 5. The tangent line at t = 5 is used to estimate when the volume reaches 600 liters. Which statement is correct?

- A. The tangent line gives t = 15 minutes, and the volume actually reaches 600 liters earlier than that.
- B. The tangent line gives t = 10 minutes, and the volume actually reaches 600 liters later than that.
- **C. The tangent line gives t = 15 minutes, and the volume actually reaches 600 liters later than that.**
- D. The tangent line gives t = 30 minutes, and the volume actually reaches 600 liters earlier than that.

Check: L(t) = 900 − 30(t − 5) = 600 gives t = 15. Because V is concave up, V(t) ≥ L(t), so V(15) > 600 and the tank has not yet reached 600 at t = 15; the true time is later.
Rationales: A: V is concave up, so the graph lies above its tangent line; at t = 15 the true volume is still above 600, so the tank reaches 600 liters later. B: solving 900 − 30(t − 5) = 600 gives t − 5 = 10; 10 is the elapsed time since t = 5, so 5 must be added to get t = 15. D: 900/30 = 30 divides the starting volume by the rate instead of dividing the 300-liter drop by the rate; the equation is 900 − 30(t − 5) = 600.

**N-4.6-B-v2.** A town's population is P(t) thousand people, t years after 2000. P(2) = 40 and P′(2) = 6, and P is concave down for t ≥ 2. The tangent line at t = 2 is used to estimate when the population reaches 70 thousand. Which statement is correct?

- A. The tangent line gives t = 7, and the population actually reaches 70 thousand earlier than that.
- B. The tangent line gives t = 5, and the population actually reaches 70 thousand later than that.
- **C. The tangent line gives t = 7, and the population actually reaches 70 thousand later than that.**
- D. The tangent line gives t = 11.7, and the population actually reaches 70 thousand earlier than that.

Check: L(t) = 40 + 6(t − 2) = 70 gives t = 7. Because P is concave down, P(t) ≤ L(t), so P(7) < 70 and the population has not yet reached 70 at t = 7; the true time is later.
Rationales: A: P is concave down, so the graph lies below its tangent line; at t = 7 the true population is still below 70, so it reaches 70 later. B: solving 40 + 6(t − 2) = 70 gives t − 2 = 5; 5 is the elapsed time since t = 2, so 2 must be added to get t = 7. D: 70/6 ≈ 11.7 divides the target value by the rate instead of dividing the 30-thousand increase by the rate; the equation is 40 + 6(t − 2) = 70.

**N-4.6-B-v3.** A company's yearly revenue is R(t) million dollars, t years after launch. R(4) = 30 and R′(4) = 5, and R is concave up for t ≥ 4. The tangent line at t = 4 is used to estimate when revenue reaches 50 million dollars. Which statement is correct?

- A. The tangent line gives t = 8, and revenue actually reaches 50 million dollars later than that.
- **B. The tangent line gives t = 8, and revenue actually reaches 50 million dollars earlier than that.**
- C. The tangent line gives t = 4, and revenue actually reaches 50 million dollars earlier than that.
- D. The tangent line gives t = 10, and revenue actually reaches 50 million dollars later than that.

Check: L(t) = 30 + 5(t − 4) = 50 gives t = 8. Because R is concave up, R(t) ≥ L(t), so R(8) > 50 and revenue passed 50 million before t = 8; the true time is earlier.
Rationales: A: R is concave up, so the graph lies above its tangent line; at t = 8 the true revenue is already above 50, so it reached 50 earlier. C: solving 30 + 5(t − 4) = 50 gives t − 4 = 4; 4 is the elapsed time since t = 4, so 4 must be added to get t = 8. D: 50/5 = 10 divides the target value by the rate instead of dividing the 20-million increase by the rate; the equation is 30 + 5(t − 4) = 50.

---

## Seed N-4.7-A (new) — Topic 4.7 Using L'Hospital's Rule for Determining Limits of Indeterminate Forms
**Skill:** decide whether L'Hôpital's rule applies, then apply it correctly, including repeated applications and chain-rule factors.

Which of the following evaluations of a limit is completely correct?

- A. lim (x→0) cos x/(x + 1): by L′Hôpital's rule this equals lim (−sin x)/1 = 0.
- B. lim (x→∞) (x + sin x)/x: the quotient of derivatives, 1 + cos x, has no limit, so the original limit does not exist.
- C. lim (x→0) (e^(2x) − 1)/sin 3x: by L′Hôpital's rule this equals lim e^(2x)/cos 3x = 1.
- **D. lim (x→0) (1 − cos 2x)/x²: by L′Hôpital's rule twice, this equals lim 2sin 2x/(2x) = lim 4cos 2x/2 = 2.**

Check: 1 − cos 2x and x² both tend to 0, so the form is 0/0. One application gives 2sin 2x/(2x), still 0/0; a second gives 4cos 2x/2, which tends to 2. The other three evaluations misuse the rule or drop chain-rule factors.
Rationales: A: the form at x = 0 is 1/1, which is not indeterminate, so L′Hôpital's rule does not apply; the limit is 1 by direct substitution. B: when the limit of the derivative quotient fails to exist, the rule gives no information; (x + sin x)/x = 1 + (sin x)/x, which tends to 1. C: this drops the chain-rule factors: the derivatives are 2e^(2x) and 3cos 3x, so the limit is 2/3.

**N-4.7-A-v1.** A student evaluates four limits using L′Hôpital's rule or a related argument. Which evaluation is completely correct?

- A. lim (x→2) (x² + 1)/(x − 1): by L′Hôpital's rule this equals lim 2x/1 = 4.
- B. lim (x→∞) (2x − cos x)/x: the quotient of derivatives, 2 + sin x, has no limit, so the original limit does not exist.
- **C. lim (x→0) (x − sin x)/x³: by L′Hôpital's rule repeatedly, this equals lim (1 − cos x)/(3x²) = lim sin x/(6x) = lim cos x/6 = 1/6.**
- D. lim (x→0) ln(1 + 4x)/x: by L′Hôpital's rule this equals lim [1/(1 + 4x)]/1 = 1.

Check: x − sin x and x³ both tend to 0. Applying the rule three times gives (1 − cos x)/(3x²), then sin x/(6x), then cos x/6, which tends to 1/6. The other three evaluations misuse the rule or drop a chain-rule factor.
Rationales: A: the form at x = 2 is 5/1, which is not indeterminate, so L′Hôpital's rule does not apply; the limit is 5 by direct substitution. B: when the limit of the derivative quotient fails to exist, the rule gives no information; (2x − cos x)/x = 2 − (cos x)/x, which tends to 2. D: this drops the chain-rule factor 4: the derivative of ln(1 + 4x) is 4/(1 + 4x), so the limit is 4.

**N-4.7-A-v2.** Four classmates each evaluate a limit and show their work. Which evaluation is completely correct?

- A. lim (x→0) (3 + 2x)/(1 + cos x): by L′Hôpital's rule this equals lim 2/(−sin x), which is unbounded, so the limit does not exist.
- B. lim (x→∞) (3x + sin 2x)/(x + 1): the quotient of derivatives, 3 + 2cos 2x, has no limit, so the original limit does not exist.
- **C. lim (x→0) (e^x − 1 − x)/x²: by L′Hôpital's rule twice, this equals lim (e^x − 1)/(2x) = lim e^x/2 = 1/2.**
- D. lim (x→0) sin 5x/(2x): by L′Hôpital's rule this equals lim cos 5x/2 = 1/2.

Check: e^x − 1 − x and x² both tend to 0, so the form is 0/0. One application gives (e^x − 1)/(2x), still 0/0; a second gives e^x/2, which tends to 1/2. The other three evaluations misuse the rule or drop a chain-rule factor.
Rationales: A: the form at x = 0 is 3/2, which is not indeterminate, so L′Hôpital's rule does not apply; the limit is 3/2 by direct substitution. B: when the limit of the derivative quotient fails to exist, the rule gives no information; dividing top and bottom by x shows the limit is 3. D: this drops the chain-rule factor 5: the derivative of sin 5x is 5cos 5x, so the limit is 5/2.

**N-4.7-A-v3.** Exactly one of the following limit evaluations is fully correct. Which one is it?

- **A. lim (x→∞) x²/e^(3x): by L′Hôpital's rule twice, this equals lim 2x/(3e^(3x)) = lim 2/(9e^(3x)) = 0.**
- B. lim (x→1) (x + 2)/(x² + 1): by L′Hôpital's rule this equals lim 1/(2x) = 1/2.
- C. lim (x→∞) (x − cos x)/(x + 3): the quotient of derivatives, 1 + sin x, has no limit, so the original limit does not exist.
- D. lim (x→0) (1 − cos 3x)/x²: by L′Hôpital's rule twice, this equals lim 3sin 3x/(2x) = lim 3cos 3x/2 = 3/2.

Check: x² and e^(3x) both tend to ∞, so the form is ∞/∞. One application gives 2x/(3e^(3x)), still ∞/∞; a second gives 2/(9e^(3x)), which tends to 0. The other three evaluations misuse the rule or drop a chain-rule factor.
Rationales: B: the form at x = 1 is 3/2, which is not indeterminate, so L′Hôpital's rule does not apply; the limit is 3/2 by direct substitution. C: when the limit of the derivative quotient fails to exist, the rule gives no information; dividing top and bottom by x shows the limit is 1. D: the second application drops a chain-rule factor: the derivative of 3sin 3x is 9cos 3x, so the limit is 9/2.

---

## Seed N-4.7-B (new) — Topic 4.7 Using L'Hospital's Rule for Determining Limits of Indeterminate Forms
**Skill:** rewrite a 0·∞ or 1^∞ form with a logarithm or a quotient so that L'Hôpital's rule can be used, then evaluate the limit.

What is lim (x→∞) (1 + 2/x)^(3x)?

- **A. e⁶**
- B. 1
- C. e²
- D. ∞

Check: Let y = (1 + 2/x)^(3x). Then ln y = 3·ln(1 + 2/x)/(1/x), a 0/0 form. L′Hôpital's rule gives 3·[(−2/x²)/(1 + 2/x)]/(−1/x²) = 6/(1 + 2/x), which tends to 6. So y → e⁶.
Rationales: B: this treats 1^∞ as 1, but the base approaches 1 while the exponent grows without bound, which is an indeterminate form that must be resolved with a logarithm. C: this finds lim x·ln(1 + 2/x) = 2 but forgets the factor 3 in the exponent; the log of the expression is 3x·ln(1 + 2/x), which tends to 6. D: this reasons that a base greater than 1 raised to an unbounded power must be unbounded, but the base 1 + 2/x approaches 1 so quickly that the product 3x·ln(1 + 2/x) stays finite.

**N-4.7-B-v1.** What is lim (x→∞) x(e^(1/x) − 1)?

- A. 0
- B. ∞
- **C. 1**
- D. −∞

Check: Rewrite as (e^(1/x) − 1)/(1/x), a 0/0 form. L′Hôpital's rule gives e^(1/x)(−1/x²)/(−1/x²) = e^(1/x), which tends to e⁰ = 1.
Rationales: A: this takes the second factor to 0 and concludes the product is 0, but the first factor grows without bound, so this is a 0·∞ form that must be rewritten. B: this takes the first factor to ∞ and concludes the product is unbounded, ignoring that the second factor tends to 0; the 0·∞ form must be rewritten as a quotient. D: this rewrites as (e^(1/x) − 1)/(1/x) and differentiates the numerator without the chain-rule factor −1/x², giving e^(1/x)/(−1/x²), which is unbounded negative.

**N-4.7-B-v2.** What is lim (x→π/2⁻) (π/2 − x)·tan x?

- A. 0
- B. ∞
- C. −1
- **D. 1**

Check: Rewrite as (π/2 − x)/cot x, a 0/0 form. L′Hôpital's rule gives (−1)/(−csc² x) = sin² x, which tends to 1 as x → π/2.
Rationales: A: this takes the first factor to 0 and concludes the product is 0, but tan x grows without bound as x approaches π/2, so this is a 0·∞ form. B: this takes tan x to ∞ and concludes the product is unbounded, ignoring that π/2 − x tends to 0; the 0·∞ form must be rewritten as a quotient. C: this rewrites as (π/2 − x)/cot x but takes the derivative of π/2 − x as +1 instead of −1, which flips the sign of the result.

**N-4.7-B-v3.** What is lim (x→1) x^(3/(x − 1))?

- A. 1
- **B. e³**
- C. e
- D. ∞

Check: Let y = x^(3/(x−1)). Then ln y = 3·ln x/(x − 1), a 0/0 form. L′Hôpital's rule gives 3·(1/x)/1, which tends to 3 as x → 1. So y → e³.
Rationales: A: this treats 1^∞ as 1, but the base approaches 1 while the exponent grows without bound, which is an indeterminate form that must be resolved with a logarithm. C: this finds lim ln x/(x − 1) = 1 but forgets the factor 3 in the exponent; the log of the expression is 3·ln x/(x − 1), which tends to 3. D: this reasons that a base near 1 raised to an unbounded power must be unbounded, but the product 3·ln x/(x − 1) stays finite, so the result is finite.

---
