# AP Calculus AB topics 4.1 to 4.7: replacement seed drafts

DRAFT for owner review. Author-in-session; not checked by a checker; not in the database. Every numeric claim recomputed in Python (scratchpad).
Scope: Unit 4 has 11 published practice items and none in 4.1, 4.3 and 4.4. Nine of the 11 are one-step procedures (the 031 velocity-evaluation family, the three circle-area and sphere-volume related-rates items, one square-root linearization, one 0/0 limit) or R1 duplicates; they are retired. One concavity item (apcalcab-mcq-010) is kept. Two new seeds per topic bring each topic to at least 8 practice items.
Target level: interpretation of derivatives in context with units, speeding up and slowing down from signs, total distance, marginal versus average cost, related-rates setup and evaluation with signs, tangent-line estimates with concavity read from a table, and L'Hospital's Rule cases that need repeated use or are inconclusive.

| Seed | Topic | Replaces |
|---|---|---|
| N-4.1-A | 4.1 Interpreting the Meaning of the Derivati | new |
| N-4.1-B | 4.1 Interpreting the Meaning of the Derivati | new |
| N-4.2-A | 4.2 Straight-Line Motion: Connecting Positio | apcalcab-mcq-031 |
| N-4.2-B | 4.2 Straight-Line Motion: Connecting Positio | apcalcab-mcq-031 |
| N-4.3-A | 4.3 Rates of Change in Applied Contexts Othe | new |
| N-4.3-B | 4.3 Rates of Change in Applied Contexts Othe | new |
| N-4.4-A | 4.4 Introduction to Related Rates | new |
| N-4.4-B | 4.4 Introduction to Related Rates | new |
| N-4.5-A | 4.5 Solving Related Rates Problems | apcalcab-mcq-009, apcalcab-mcq-032, apcalcab-mcq-np2-001 |
| N-4.5-B | 4.5 Solving Related Rates Problems | apcalcab-mcq-009, apcalcab-mcq-032, apcalcab-mcq-np2-001 |
| N-4.6-A | 4.6 Approximating Values of a Function Using | apcalcab-mcq-033, apcalcab-mcq-np2-010 (apcalcab-mcq-010 kept) |
| N-4.6-B | 4.6 Approximating Values of a Function Using | apcalcab-mcq-033, apcalcab-mcq-np2-010 (apcalcab-mcq-010 kept) |
| N-4.7-A | 4.7 Using L'Hospital's Rule for Determining  | apcalcab-mcq-034, apcalcab-mcq-np2-002 |
| N-4.7-B | 4.7 Using L'Hospital's Rule for Determining  | apcalcab-mcq-034, apcalcab-mcq-np2-002 |

---

## Seed N-4.1-A (replaces new) — Topic 4.1 Interpreting the Meaning of the Derivative in Context
**Skill:** interpret a derivative value with units, separating marginal rate, average rate and percent change.

A bakery's total cost of producing n loaves of bread in one day is C(n) dollars. It is known that C(150) = 420 and C′(150) = 1.80. Which statement is the best interpretation of C′(150) = 1.80?

- **A. Producing the 151st loaf adds about 1.80 dollars to the total cost.**
- B. The average cost of each of the first 150 loaves is about 1.80 dollars.
- C. Each of the first 150 loaves costs 1.80 dollars, so the total cost is 270 dollars.
- D. The total cost is increasing by 1.80 percent for each additional loaf.

Check: C′(150) is the instantaneous rate of change of total cost, in dollars per loaf, so the next loaf costs about 1.80 dollars more. The average cost is 420/150 = 2.80 dollars per loaf and the relative rate is 1.80/420 ≈ 0.43%.
Rationales: B: The average cost per loaf is C(150)/150 = 420/150 = 2.80 dollars, which is a different quantity from the derivative C′(150). C: This treats the rate at n = 150 as a constant price for every loaf, and the resulting total of 270 contradicts the given value C(150) = 420. D: C′ has units of dollars per loaf, not percent. The relative rate would be 1.80/420, about 0.43 percent per loaf.

**N-4.1-A-v1.** The number of bacteria in a culture is B(t) thousand, where t is measured in hours. It is known that B(5) = 60 and B′(5) = −2.4. Which statement is the best interpretation of B′(5) = −2.4?

- A. At t = 5 hours the culture contains 2.4 thousand bacteria.
- **B. At t = 5 hours the population is decreasing at about 2.4 thousand bacteria per hour.**
- C. At t = 5 hours the population is decreasing by 2.4 percent per hour.
- D. The population was exactly 62.4 thousand at t = 4 hours.

Check: B′(5) = −2.4 thousand bacteria per hour is the instantaneous rate of change at t = 5. It is negative, so the population is falling; it equals 4% of B(5) = 60 only as a relative rate.
Rationales: A: The number of bacteria at t = 5 is B(5) = 60 thousand. The value B′(5) is a rate of change, not a population count. C: B′ has units of thousands of bacteria per hour. As a percent of the current population the rate is 2.4/60 = 4 percent per hour, not 2.4 percent. D: B′(5) is an instantaneous rate and only approximates the change over the next or previous hour, so it does not give the exact value of B(4).

**N-4.1-A-v2.** A city's total daily water use is W(h) gallons when the day's high temperature is h degrees Fahrenheit. It is known that W(90) = 5000 and W′(90) = 120. Which statement is the best interpretation of W′(90) = 120?

- A. The city uses 120 gallons of water for each degree of temperature from 0°F to 90°F, a total of 10,800 gallons.
- B. A change of 1 gallon in water use corresponds to a change of about 120 degrees in temperature.
- **C. When the high temperature is 90°F, each additional degree increases daily water use by about 120 gallons.**
- D. The city uses 120 gallons of water when the high temperature is 90°F.

Check: W′(90) = 120 gallons per degree is the instantaneous rate of change of water use with temperature at h = 90, so one more degree adds about 120 gallons. W(90) = 5000 is the amount itself.
Rationales: A: This treats the rate at h = 90 as a constant rate over all temperatures, and the total of 10,800 gallons contradicts W(90) = 5000. B: The units are reversed. W′ is in gallons per degree, so it describes gallons of change in W per degree of change in h. D: The water use at 90°F is the function value W(90) = 5000 gallons. The derivative W′(90) is a rate, not an amount.

**N-4.1-A-v3.** The charge of a phone battery is B(t) percent after t hours of use. It is known that B(3) = 55 and B′(3) = −12. Which statement is the best interpretation of B′(3) = −12?

- A. At t = 3 hours the battery charge is 12 percent.
- B. At t = 3 hours the battery loses 12 percent of its remaining charge each hour.
- C. The battery has lost exactly 12 percentage points every hour since t = 0.
- **D. At t = 3 hours the battery charge is falling at a rate of about 12 percentage points per hour.**

Check: B′(3) = −12 percentage points per hour is the instantaneous rate at t = 3, negative because the charge is falling. It is not the charge (55), a percent of the charge, or a constant rate.
Rationales: A: The charge at t = 3 is B(3) = 55 percent. The derivative B′(3) is a rate of change in percentage points per hour. B: B′ is in percentage points per hour. Twelve percent of the remaining 55 percent would be only 6.6 points, so this misreads the units. C: B′(3) is the rate at one instant. It does not show that the rate was constant on [0, 3], so the earlier rates may have been different.

---

## Seed N-4.1-B (replaces new) — Topic 4.1 Interpreting the Meaning of the Derivative in Context
**Skill:** estimate a derivative from a table with uneven spacing and state its units when the function is itself a rate.

Water leaks from a tank at a rate of L(t) liters per hour, where t is measured in hours. Selected values of L are given in the table.
t (hours):   0   2   5   9
L(t) (liters per hour):   40   34   22   14
Using the data in the table, which is the best estimate of L′(4), with units?

- A. −2 liters per hour per hour
- B. −12 liters per hour per hour
- **C. −4 liters per hour per hour**
- D. −4 liters per hour

Check: t = 4 lies in [2, 5], so L′(4) ≈ (L(5) − L(2))/(5 − 2) = (22 − 34)/3 = −4. L is a rate in liters per hour, so L′ has units liters per hour per hour: the leak rate is dropping by about 4 liters per hour each hour.
Rationales: A: This uses the interval from t = 5 to t = 9, (14 − 22)/4 = −2, which does not contain t = 4. The estimate needs the interval that straddles 4. B: The change in L over [2, 5] is −12, but it must be divided by the interval length 3 to get a rate of change. D: The number is right but the units are not. L is already in liters per hour, so its derivative is in liters per hour per hour.

**N-4.1-B-v1.** The rate at which cars pass a toll booth is R(t) cars per minute, where t is the number of minutes after 7:00 am. Selected values of R are given in the table.
t (minutes):   0   10   25   30
R(t) (cars per minute):   18   24   39   33
Using the data in the table, which is the best estimate of R′(20), with units?

- A. −1.2 cars per minute per minute
- B. 15 cars per minute per minute
- C. 1 car per minute
- **D. 1 car per minute per minute**

Check: t = 20 lies in [10, 25], so R′(20) ≈ (R(25) − R(10))/(25 − 10) = (39 − 24)/15 = 1. R is a rate in cars per minute, so R′ is in cars per minute per minute.
Rationales: A: This uses the interval from t = 25 to t = 30, (33 − 39)/5 = −1.2, which does not contain t = 20. B: The change in R over [10, 25] is 15, but it must be divided by the interval length 15 to get a rate of change. C: The number is right but the units are not. R is already in cars per minute, so its derivative is in cars per minute per minute.

**N-4.1-B-v2.** The amount of medicine in a patient's bloodstream is M(t) milligrams, where t is the number of hours after an injection. Selected values of M are given in the table.
t (hours):   0   1   3   7
M(t) (milligrams):   0   50   38   22
Using the data in the table, which is the best estimate of M′(2), with units?

- **A. −6 milligrams per hour**
- B. −12 milligrams per hour
- C. −4 milligrams per hour
- D. about 3.1 milligrams per hour

Check: t = 2 lies in [1, 3], so M′(2) ≈ (M(3) − M(1))/(3 − 1) = (38 − 50)/2 = −6 milligrams per hour, so the amount of medicine is falling.
Rationales: B: The change in M over [1, 3] is −12, but it must be divided by the interval length 2 to get a rate of change. C: This uses the interval from t = 3 to t = 7, (22 − 38)/4 = −4, which does not contain t = 2. D: This is the average rate over the whole table, (22 − 0)/7. It is a positive average over [0, 7] and ignores that M is falling near t = 2.

**N-4.1-B-v3.** The height of a sunflower is H(d) centimeters, where d is the number of days after planting. Selected values of H are given in the table.
d (days):   0   4   10   14
H(d) (centimeters):   2   8   17   19
Using the data in the table, which is the best estimate of H′(7), with units?

- A. 0.5 centimeters per day
- **B. 1.5 centimeters per day**
- C. about 1.2 centimeters per day
- D. 9 centimeters per day

Check: d = 7 lies in [4, 10], so H′(7) ≈ (H(10) − H(4))/(10 − 4) = (17 − 8)/6 = 1.5 centimeters per day.
Rationales: A: This uses the interval from d = 10 to d = 14, (19 − 17)/4 = 0.5, which does not contain d = 7. C: This is the average rate over the whole table, (19 − 2)/14. It does not use the interval that straddles d = 7. D: The change in H over [4, 10] is 9, but it must be divided by the interval length 6 to get a rate of change.

---

## Seed N-4.2-A (replaces apcalcab-mcq-031) — Topic 4.2 Straight-Line Motion: Connecting Position, Velocity, and Acceleration
**Skill:** decide direction and speeding up or slowing down from the signs of v and a.

A particle moves along the x-axis with velocity v(t) = t² − 5t + 4 for t ≥ 0. Which statement describes the particle's motion at t = 3?

- **A. The particle is moving left and slowing down.**
- B. The particle is moving right and speeding up.
- C. The particle is moving left and speeding up.
- D. The particle is moving right and slowing down.

Check: v(3) = 9 − 15 + 4 = −2 (moving left). a(t) = 2t − 5, so a(3) = 1. Velocity and acceleration have opposite signs, so the speed |v| is decreasing: slowing down.
Rationales: B: v(3) = −2 is negative, so the particle moves left. This answer reads the positive acceleration a(3) = 1 as the direction of motion. C: Speeding up needs v and a to have the same sign. Here v(3) = −2 and a(3) = 1 have opposite signs, so the particle is slowing down. D: This takes the direction from the sign of the acceleration. The direction comes from v(3) = −2, which is negative, so the motion is leftward.

**N-4.2-A-v1.** A cart moves along a track with velocity v(t) = 2t² − 9t + 7 for t ≥ 0. Which statement describes the cart's motion at t = 2?

- A. The cart is moving left and slowing down.
- **B. The cart is moving left and speeding up.**
- C. The cart is moving right and speeding up.
- D. The cart is moving right and slowing down.

Check: v(2) = 8 − 18 + 7 = −3 (left). a(t) = 4t − 9, so a(2) = −1. Same signs mean the speed increases: moving left and speeding up.
Rationales: A: At t = 2 the velocity is −3 and the acceleration a(2) = 4(2) − 9 = −1. Both are negative, so the speed is increasing, not decreasing. C: The sign of v(2) = −3 shows the cart is moving left, not right. Speeding up describes the change in speed, not the direction of motion. D: The cart moves left because v(2) = −3, and with a(2) = −1 also negative the speed is increasing, so both parts of this statement are wrong.

**N-4.2-A-v2.** A bead slides along a wire with velocity v(t) = −t² + 6t − 5 for t ≥ 0. Which statement describes the bead's motion at t = 4?

- A. The bead is moving right and speeding up.
- B. The bead is moving left and slowing down.
- **C. The bead is moving right and slowing down.**
- D. The bead is moving left and speeding up.

Check: v(4) = −16 + 24 − 5 = 3 (right). a(t) = −2t + 6, so a(4) = −2. Opposite signs mean the speed decreases: moving right and slowing down.
Rationales: A: v(4) = 3 is positive, but a(4) = −2(4) + 6 = −2 is negative. The signs differ, so the bead is slowing down. B: The direction comes from v(4) = 3, which is positive, so the bead moves right. The negative acceleration is the reason it slows, not a sign of leftward motion. D: The negative acceleration a(4) = −2 does not mean leftward motion or a rising speed. The velocity v(4) = 3 is positive and opposite in sign to a(4).

**N-4.2-A-v3.** A particle moves along a line with position s(t) = t³ − 6t² + 9t for t ≥ 0. Which statement describes the particle's motion at t = 5?

- A. The particle is moving right and slowing down.
- B. The particle is moving left and speeding up.
- C. The particle is moving left and slowing down.
- **D. The particle is moving right and speeding up.**

Check: v(t) = s′(t) = 3t² − 12t + 9, v(5) = 24 > 0 (right). a(t) = s″(t) = 6t − 12, a(5) = 18 > 0. Same signs: speeding up.
Rationales: A: At t = 5 the velocity is positive and the acceleration is positive as well, s″(5) = 6(5) − 12 = 18, so the speed is increasing. B: v(5) = 3(25) − 60 + 9 = 24 is positive, so the particle moves right. Position is positive, but only the sign of the velocity gives direction. C: Both signs are positive at t = 5: v(5) = 24 and a(5) = 18. The particle moves right and speeds up, so neither part of this statement holds.

---

## Seed N-4.2-B (replaces apcalcab-mcq-031) — Topic 4.2 Straight-Line Motion: Connecting Position, Velocity, and Acceleration
**Skill:** find total distance traveled from a position function by locating the times the particle reverses direction.

A particle moves along a line with position s(t) = t³ − 9t² + 24t meters for 0 ≤ t ≤ 5 seconds. What is the total distance traveled by the particle on this interval?

- A. 20 meters
- B. 24 meters
- **C. 28 meters**
- D. 36 meters

Check: v(t) = 3t² − 18t + 24 = 3(t − 2)(t − 4), so the particle reverses at t = 2 and t = 4. s(0) = 0, s(2) = 20, s(4) = 16, s(5) = 20. Distance = 20 + |16 − 20| + |20 − 16| = 20 + 4 + 4 = 28.
Rationales: A: This is the displacement s(5) − s(0) = 20. The particle reverses direction at t = 2 and t = 4, so the distance traveled is larger than the displacement. B: This leaves out the middle leg from t = 2 to t = 4, where the particle moves 4 meters in the negative direction, and counts only 20 + 4. D: This adds the positions s(2) = 20 and s(4) = 16 instead of adding the sizes of the changes in position on each leg.

**N-4.2-B-v1.** A particle moves along a line with position s(t) = 2t³ − 15t² + 24t meters for 0 ≤ t ≤ 6 seconds. What is the total distance traveled by the particle on this interval?

- A. 36 meters
- B. 38 meters
- C. 63 meters
- **D. 90 meters**

Check: v(t) = 6t² − 30t + 24 = 6(t − 1)(t − 4). s(0) = 0, s(1) = 11, s(4) = −16, s(6) = 36. Distance = 11 + |−16 − 11| + |36 − (−16)| = 11 + 27 + 52 = 90.
Rationales: A: This is the displacement s(6) − s(0) = 36. The particle reverses direction at t = 1 and t = 4, so the total distance is larger. B: This stops at t = 4 and counts only the first two legs, 11 + 27, leaving out the final leg from t = 4 to t = 6. C: This adds the sizes of the positions at the turning points and the end, 11 + 16 + 36, instead of the changes in position on each leg.

**N-4.2-B-v2.** A particle moves along a line with position s(t) = t³ − 12t² + 36t centimeters for 0 ≤ t ≤ 7 seconds. What is the total distance traveled by the particle on this interval?

- **A. 71 centimeters**
- B. 7 centimeters
- C. 64 centimeters
- D. 57 centimeters

Check: v(t) = 3t² − 24t + 36 = 3(t − 2)(t − 6). s(0) = 0, s(2) = 32, s(6) = 0, s(7) = 7. Distance = 32 + 32 + 7 = 71.
Rationales: B: This is the displacement s(7) − s(0) = 7. The particle reverses direction at t = 2 and t = 6, so the distance traveled is larger. C: This leaves out the final leg from t = 6 to t = 7, where the particle moves 7 centimeters, and counts only 32 + 32. D: This subtracts the final 7 centimeters, 64 − 7, instead of adding it, as if the last leg took the particle back over earlier distance.

**N-4.2-B-v3.** A particle moves along a line with position s(t) = t³ − 6t² + 9t feet for 0 ≤ t ≤ 5 seconds. What is the total distance traveled by the particle on this interval?

- A. 20 feet
- **B. 28 feet**
- C. 8 feet
- D. 24 feet

Check: v(t) = 3t² − 12t + 9 = 3(t − 1)(t − 3). s(0) = 0, s(1) = 4, s(3) = 0, s(5) = 20. Distance = 4 + 4 + 20 = 28.
Rationales: A: This is the displacement s(5) − s(0) = 20. The particle reverses direction at t = 1 and t = 3, so the total distance is larger. C: This stops at t = 3 and counts only the first two legs, 4 + 4, leaving out the final leg from t = 3 to t = 5. D: This counts the first leg and the last leg, 4 + 20, and leaves out the middle leg from t = 1 to t = 3.

---

## Seed N-4.3-A (replaces new) — Topic 4.3 Rates of Change in Applied Contexts Other Than Motion
**Skill:** read increasing or decreasing and concavity from a table of a rate of change, and describe it as speeding up or slowing down.

A cup of tea cools after it is poured. Its temperature is T(t) degrees Celsius at time t minutes, and selected values of T′(t) are given in the table. Assume T′ keeps the trend shown for 0 < t < 15.
t (minutes):   0   5   10   15
T′(t) (degrees per minute):   −8.0   −5.2   −3.4   −2.2
Which statement is true for 0 < t < 15?

- **A. T is decreasing and its rate of decrease is shrinking, so the graph of T is concave up.**
- B. T is decreasing, and T″ < 0 because T′ < 0.
- C. T is increasing, because the values of T′ are increasing.
- D. T is decreasing and its rate of decrease is growing, so the graph of T is concave down.

Check: T′ < 0 in the table, so T is decreasing. T′ increases from −8.0 to −2.2, so T″ > 0 and the graph is concave up; the cooling slows down because |T′| shrinks.
Rationales: B: The sign of T′ tells whether T is increasing or decreasing. The sign of T″ comes from whether T′ is increasing or decreasing, and the table shows T′ increasing from −8.0 toward −2.2. C: T′ is negative throughout the table, so T is decreasing. The fact that T′ is increasing says only that the graph of T is concave up. D: The size of the rate of decrease is shrinking from 8.0 to 2.2 degrees per minute, so the tea is cooling more slowly, not faster.

**N-4.3-A-v1.** A social media account has N(t) thousand followers at time t weeks, and selected values of N′(t) are given in the table. Assume N′ keeps the trend shown for 0 < t < 12.
t (weeks):   0   4   8   12
N′(t) (thousands per week):   6.0   4.1   2.3   0.8
Which statement is true for 0 < t < 12?

- A. N is decreasing, because the values of N′ are decreasing.
- **B. N is increasing and growth is slowing, so the graph of N is concave down.**
- C. N is increasing and concave up, because N′ is positive.
- D. N is increasing at a constant rate, because N′ never changes sign.

Check: N′ > 0 so N is increasing. N′ decreases from 6.0 to 0.8, so N″ < 0 and the graph is concave down: followers are still rising, but more slowly each week.
Rationales: A: N′ is positive throughout the table, so N is increasing. The values of N′ decreasing says only that the graph of N is concave down. C: A positive N′ shows N is increasing, but concavity depends on whether N′ is rising or falling. N′ falls from 6.0 to 0.8, so N is concave down. D: N′ is not constant. It drops from 6.0 to 0.8 thousand followers per week, so the growth rate is changing even though its sign is not.

**N-4.3-A-v2.** The water level in a reservoir is W(t) centimeters at time t days, and selected values of W′(t) are given in the table. Assume W′ keeps the trend shown for 0 < t < 9.
t (days):   0   3   6   9
W′(t) (centimeters per day):   −1.2   −2.0   −3.1   −4.5
Which statement is true for 0 < t < 9?

- A. W is decreasing and the decline is slowing, so the graph of W is concave up.
- B. W is increasing, because the values of W′ are getting larger in size.
- **C. W is decreasing and the decline is speeding up, so the graph of W is concave down.**
- D. W is decreasing, and W″ > 0 because W′ < 0.

Check: W′ < 0, so W is decreasing. W′ decreases from −1.2 to −4.5, so W″ < 0 and the graph is concave down; the level falls faster each day.
Rationales: A: The size of W′ grows from 1.2 to 4.5 centimeters per day, so the level is falling faster each day. W′ is falling, which makes W concave down. B: W′ is negative throughout, so W is decreasing. A growing magnitude of a negative rate means the decline is speeding up, not that W increases. D: The sign of W′ tells whether W is increasing or decreasing, not the sign of W″. W′ is decreasing from −1.2 to −4.5, so W″ < 0.

**N-4.3-A-v3.** The amount of product formed in a chemical reaction is P(t) grams at time t minutes, and selected values of P′(t) are given in the table. Assume P′ keeps the trend shown for 0 < t < 6.
t (minutes):   0   2   4   6
P′(t) (grams per minute):   0.5   1.1   1.9   3.0
Which statement is true for 0 < t < 6?

- A. P is increasing, but the growth is slowing, so the graph of P is concave down.
- B. P is decreasing, because the values of P′ are increasing.
- C. P is increasing at a constant rate.
- **D. P is increasing and growth is speeding up, so the graph of P is concave up.**

Check: P′ > 0, so P is increasing. P′ increases from 0.5 to 3.0, so P″ > 0 and the graph is concave up: the product forms faster as time passes.
Rationales: A: P′ is rising from 0.5 to 3.0, which means the rate of growth is increasing. A rising P′ gives a concave up graph, not a concave down one. B: P′ is positive throughout, so P is increasing. A rising P′ describes how the growth is changing, not the direction of P. C: P′ is not constant. It rises from 0.5 to 3.0 grams per minute, so the rate of formation changes over the interval.

---

## Seed N-4.3-B (replaces new) — Topic 4.3 Rates of Change in Applied Contexts Other Than Motion
**Skill:** compare marginal cost with average cost to decide whether average cost is rising or falling.

A manufacturer's total cost of producing q units is C(q) = 0.02q² + 5q + 400 dollars, and the average cost per unit is A(q) = C(q)/q. At a production level of q = 50 units, which statement is correct?

- A. The average cost per unit is increasing, because the total cost C is increasing.
- B. The average cost per unit is increasing, because the marginal cost is increasing (C″(q) = 0.04 > 0).
- **C. The average cost per unit is decreasing, because the marginal cost C′(50) = 7 dollars per unit is less than the average cost A(50) = 14 dollars per unit.**
- D. The average cost per unit is 7 dollars at q = 50, because C′(50) = 7 gives the cost per unit.

Check: C′(q) = 0.04q + 5, so C′(50) = 7. C(50) = 50 + 250 + 400 = 700, A(50) = 14. A′(q) = (qC′(q) − C(q))/q², so A′(50) = (350 − 700)/2500 = −0.14 < 0.
Rationales: A: Total cost increasing does not decide the behavior of the average. The average cost falls whenever the extra unit costs less than the current average. B: A rising marginal cost does not alone make the average rise. At q = 50 the marginal cost 7 is still below the average 14, which pulls the average down. D: C′(50) is the marginal cost of the next unit. The average cost per unit is C(50)/50 = 700/50 = 14 dollars.

**N-4.3-B-v1.** A print shop's total cost of making q posters is C(q) = 0.05q² + 3q + 500 dollars, and the average cost per poster is A(q) = C(q)/q. At a production level of q = 60 posters, which statement is correct?

- A. The average cost per poster is increasing, because the total cost C is increasing.
- B. The average cost per poster is increasing, because the marginal cost is increasing (C″(q) = 0.1 > 0).
- C. The average cost per poster is 9 dollars at q = 60, because C′(60) = 9 gives the cost per poster.
- **D. The average cost per poster is decreasing, because the marginal cost C′(60) = 9 dollars per poster is less than the average cost A(60) ≈ 14.33 dollars per poster.**

Check: C′(q) = 0.1q + 3, so C′(60) = 9. C(60) = 180 + 180 + 500 = 860, A(60) ≈ 14.33. A′(60) = (60·9 − 860)/3600 ≈ −0.089 < 0, so the average cost is decreasing.
Rationales: A: Total cost increasing does not decide whether the average rises. The average falls whenever the cost of one more poster is below the current average. B: A rising marginal cost does not alone make the average rise. At q = 60 the marginal cost 9 is below the average 14.33, which pulls the average down. C: C′(60) is the marginal cost of the next poster. The average cost per poster is C(60)/60 = 860/60, about 14.33 dollars.

**N-4.3-B-v2.** A bike shop's total cost of assembling q bikes in a month is C(q) = 0.5q² + 4q + 50 dollars, and the average cost per bike is A(q) = C(q)/q. At a production level of q = 20 bikes, which statement is correct?

- **A. The average cost per bike is increasing, because the marginal cost C′(20) = 24 dollars per bike is greater than the average cost A(20) = 16.50 dollars per bike.**
- B. The average cost per bike is decreasing, because the total cost C is increasing at a slowing pace.
- C. The average cost per bike is decreasing, because 400 dollars of fixed cost is spread over more bikes.
- D. The average cost per bike is 24 dollars at q = 20, because C′(20) = 24 gives the cost per bike.

Check: C′(q) = q + 4, so C′(20) = 24. C(20) = 200 + 80 + 50 = 330, A(20) = 16.5. A′(20) = (20·24 − 330)/400 = 0.375 > 0, so the average cost is increasing.
Rationales: B: The total cost's growth is speeding up, since C″(q) = 1 > 0, and the extra bike costs more than the average, so the average is rising. C: The fixed cost is only 50 dollars here, and the marginal cost of 24 dollars is well above the average of 16.50, so the average is rising. D: C′(20) is the marginal cost of the next bike. The average cost per bike is C(20)/20 = 330/20 = 16.50 dollars.

**N-4.3-B-v3.** A bottling plant's total cost of filling q hundred bottles is C(q) = 0.01q² + 2q + 300 dollars, where q is measured in hundreds of bottles, and the average cost per hundred bottles is A(q) = C(q)/q. At a production level of q = 200 hundred bottles, which statement is correct?

- A. The average cost per hundred bottles is decreasing, because the average is only 5.50 dollars and the marginal cost is 6 dollars.
- **B. The average cost per hundred bottles is increasing, because the marginal cost C′(200) = 6 dollars is greater than the average cost A(200) = 5.50 dollars.**
- C. The average cost per hundred bottles is decreasing, because the total cost C is increasing at a slowing pace.
- D. The average cost per hundred bottles is 6 dollars at q = 200, because C′(200) = 6 gives the average cost.

Check: C′(q) = 0.02q + 2, so C′(200) = 6. C(200) = 400 + 400 + 300 = 1100, A(200) = 5.5. A′(200) = (200·6 − 1100)/40000 = 0.0025 > 0, so the average cost is increasing.
Rationales: A: The comparison is reversed. When the marginal cost 6 is above the average 5.50, the next hundred bottles raise the average. C: C″(q) = 0.02 > 0, so the total cost grows faster, not slower, and the marginal cost is above the average, so the average is rising. D: C′(200) is the marginal cost. The average cost is C(200)/200 = 1100/200 = 5.50 dollars.

---

## Seed N-4.4-A (replaces new) — Topic 4.4 Introduction to Related Rates
**Skill:** build a relationship from similar triangles and differentiate it with respect to time.

A 6-foot-tall person walks away from a streetlight that is 15 feet tall. Let x be the person's distance from the base of the light and s the length of the person's shadow, both in feet. Which equation correctly relates ds/dt and dx/dt?

- **A. ds/dt = (2/3)·dx/dt**
- B. ds/dt = (2/5)·dx/dt
- C. ds/dt = dx/dt
- D. ds/dt = (5/3)·dx/dt

Check: Similar triangles: 15/(x + s) = 6/s, so 15s = 6x + 6s, 9s = 6x, s = (2/3)x. Differentiating with respect to t gives ds/dt = (2/3)·dx/dt.
Rationales: B: This uses the ratio of heights 6/15 directly. The similar triangles give 15/(x + s) = 6/s, which leads to s = (2/3)x, not s = (2/5)x. C: This assumes the shadow grows at the same rate as the person walks. The shadow length s is only a fraction of x, so it grows more slowly. D: This is the rate at which the tip of the shadow moves, d(x + s)/dt, not the rate at which the shadow's length s changes.

**N-4.4-A-v1.** A 5-foot-tall person walks away from a lamp that is 20 feet tall. Let x be the person's distance from the base of the lamp and s the length of the person's shadow, both in feet. Which equation correctly relates ds/dt and dx/dt?

- A. ds/dt = (1/4)·dx/dt
- **B. ds/dt = (1/3)·dx/dt**
- C. ds/dt = dx/dt
- D. ds/dt = (4/3)·dx/dt

Check: Similar triangles: 20/(x + s) = 5/s, so 20s = 5x + 5s, 15s = 5x, s = x/3. Differentiating with respect to t gives ds/dt = (1/3)·dx/dt.
Rationales: A: This uses the ratio of heights 5/20 directly. The similar triangles give 20/(x + s) = 5/s, which leads to s = x/3, not s = x/4. C: This assumes the shadow grows at the same rate as the person walks. The shadow length s is only a fraction of x, so it grows more slowly. D: This is the rate at which the tip of the shadow moves, d(x + s)/dt, not the rate at which the shadow's length s changes.

**N-4.4-A-v2.** A person 1.8 meters tall walks away from a lamppost that is 6 meters tall. Let x be the person's distance from the base of the post and s the length of the person's shadow, both in meters. Which equation correctly relates ds/dt and dx/dt?

- A. ds/dt = (3/10)·dx/dt
- B. ds/dt = dx/dt
- **C. ds/dt = (3/7)·dx/dt**
- D. ds/dt = (10/7)·dx/dt

Check: Similar triangles: 6/(x + s) = 1.8/s, so 6s = 1.8x + 1.8s, 4.2s = 1.8x, s = (3/7)x. Differentiating with respect to t gives ds/dt = (3/7)·dx/dt.
Rationales: A: This uses the ratio of heights 1.8/6 directly. The similar triangles give 6/(x + s) = 1.8/s, which leads to s = (3/7)x, not s = (3/10)x. B: This assumes the shadow grows at the same rate as the person walks. The shadow length s is only a fraction of x, so it grows more slowly. D: This is the rate at which the tip of the shadow moves, d(x + s)/dt, not the rate at which the shadow's length s changes.

**N-4.4-A-v3.** A 4-foot-tall child walks toward a lantern that is 12 feet tall. Let x be the child's distance from the base of the lantern and s the length of the child's shadow, both in feet. Which equation correctly relates ds/dt and dx/dt?

- A. ds/dt = (1/3)·dx/dt
- B. ds/dt = dx/dt
- C. ds/dt = (3/2)·dx/dt
- **D. ds/dt = (1/2)·dx/dt**

Check: Similar triangles: 12/(x + s) = 4/s, so 12s = 4x + 4s, 8s = 4x, s = x/2. Differentiating with respect to t gives ds/dt = (1/2)·dx/dt; dx/dt is negative here, so the shadow shortens.
Rationales: A: This uses the ratio of heights 4/12 directly. The similar triangles give 12/(x + s) = 4/s, which leads to s = x/2, not s = x/3. B: This assumes the shadow's length changes at the same rate as the child's distance. The shadow length s is only a fraction of x, so it changes more slowly. C: This is the rate at which the tip of the shadow moves, d(x + s)/dt, not the rate at which the shadow's length s changes.

---

## Seed N-4.4-B (replaces new) — Topic 4.4 Introduction to Related Rates
**Skill:** reduce a two-variable volume formula to one variable using a stated constraint, then differentiate with respect to time.

Water is draining from a conical tank with its vertex pointing down. At every moment the radius r and depth h of the water satisfy r = h/2, and the volume of water is V = (1/3)πr²h. Which expression gives dV/dt in terms of h and dh/dt?

- A. dV/dt = (π/12)h²·dh/dt
- B. dV/dt = (π/12)h³
- **C. dV/dt = (π/4)h²·dh/dt**
- D. dV/dt = (π/4)h³·dh/dt

Check: Substitute r = h/2: V = (1/3)π(h/2)²h = (π/12)h³. Then dV/dt = (π/12)(3h²)·dh/dt = (π/4)h²·dh/dt.
Rationales: A: This differentiates (1/3)πr²h as if r were constant and then replaces r by h/2. Since r changes with h, the constraint must be used before differentiating. B: This is the volume V itself after substituting r = h/2. It has not been differentiated and has no factor dh/dt. D: The factor 3 is brought down but the exponent is not reduced. The derivative of h³ is 3h², not 3h³.

**N-4.4-B-v1.** A conical funnel with its vertex pointing down is being filled with oil. At every moment the radius r and depth h of the oil satisfy r = h/3, and the volume of oil is V = (1/3)πr²h. Which expression gives dV/dt in terms of h and dh/dt?

- A. dV/dt = (π/27)h²·dh/dt
- B. dV/dt = (π/27)h³
- C. dV/dt = (π/9)h³·dh/dt
- **D. dV/dt = (π/9)h²·dh/dt**

Check: Substitute r = h/3: V = (1/3)π(h/3)²h = (π/27)h³. Then dV/dt = (π/27)(3h²)·dh/dt = (π/9)h²·dh/dt.
Rationales: A: This differentiates (1/3)πr²h as if r were constant and then replaces r by h/3. Since r changes with h, the constraint must be used before differentiating. B: This is the volume V itself after substituting r = h/3. It has not been differentiated and has no factor dh/dt. C: The factor 3 is brought down but the exponent is not reduced. The derivative of h³ is 3h², not 3h³.

**N-4.4-B-v2.** Grain is poured into an inverted conical bin with its vertex pointing down. At every moment the radius r and depth h of the grain satisfy r = 2h, and the volume of grain is V = (1/3)πr²h. Which expression gives dV/dt in terms of h and dh/dt?

- **A. dV/dt = 4πh²·dh/dt**
- B. dV/dt = (4π/3)h²·dh/dt
- C. dV/dt = (4π/3)h³
- D. dV/dt = 4πh³·dh/dt

Check: Substitute r = 2h: V = (1/3)π(2h)²h = (4π/3)h³. Then dV/dt = (4π/3)(3h²)·dh/dt = 4πh²·dh/dt.
Rationales: B: This differentiates (1/3)πr²h as if r were constant and then replaces r by 2h. Since r changes with h, the constraint must be used before differentiating. C: This is the volume V itself after substituting r = 2h. It has not been differentiated and has no factor dh/dt. D: The factor 3 is brought down but the exponent is not reduced. The derivative of h³ is 3h², not 3h³.

**N-4.4-B-v3.** A trough 5 meters long has triangular ends, and water is flowing into it. At every moment the width w of the water surface and the depth h of the water satisfy w = h, and the volume of water is V = (5/2)wh. Which expression gives dV/dt in terms of h and dh/dt?

- A. dV/dt = (5/2)h·dh/dt
- **B. dV/dt = 5h·dh/dt**
- C. dV/dt = (5/2)h²
- D. dV/dt = 5h²·dh/dt

Check: Substitute w = h: V = (5/2)h². Then dV/dt = (5/2)(2h)·dh/dt = 5h·dh/dt.
Rationales: A: This differentiates (5/2)wh as if w were constant and then replaces w by h. Since w changes with h, the constraint must be used before differentiating. C: This is the volume V itself after substituting w = h. It has not been differentiated and has no factor dh/dt. D: The factor 2 is brought down but the exponent is not reduced. The derivative of h² is 2h, not 2h².

---

## Seed N-4.5-A (replaces apcalcab-mcq-009, apcalcab-mcq-032, apcalcab-mcq-np2-001) — Topic 4.5 Solving Related Rates Problems
**Skill:** use a constraint to write V in one variable, differentiate, and evaluate at an instant without substituting the value early.

Sand is poured onto a flat surface at a rate of 5 cubic meters per minute and forms a conical pile whose height always equals its base radius. How fast is the height of the pile increasing at the instant when the height is 4 meters?

- **A. 5/(16π) meters per minute**
- B. 15/(16π) meters per minute
- C. 5/(48π) meters per minute
- D. 0 meters per minute

Check: Since r = h, V = (1/3)πh³ and dV/dt = πh²·dh/dt. At h = 4: 5 = π(16)·dh/dt, so dh/dt = 5/(16π) ≈ 0.10 meters per minute.
Rationales: B: This differentiates V = (1/3)πr²h with r held at its current value of 4, so the dependence of r on h is lost. The result is three times too large. C: This uses V = πh³ and omits the factor 1/3 from the volume of a cone, so the result is one third of the correct rate. D: This substitutes h = 4 into the volume formula before differentiating, which turns V into a constant whose derivative is 0.

**N-4.5-A-v1.** Salt falls from a conveyor at a rate of 3 cubic meters per minute and forms a conical pile whose base radius is always half its height. How fast is the height of the pile increasing at the instant when the height is 6 meters?

- A. 1/π meters per minute
- **B. 1/(3π) meters per minute**
- C. 1/(9π) meters per minute
- D. 0 meters per minute

Check: Since r = h/2, V = (1/3)π(h²/4)h = (π/12)h³ and dV/dt = (π/4)h²·dh/dt. At h = 6: 3 = 9π·dh/dt, so dh/dt = 1/(3π) meters per minute.
Rationales: A: This differentiates V = (1/3)πr²h with r held at its current value of 3, so the dependence of r on h is lost. The result is three times too large. C: This uses V = πr²h and omits the factor 1/3 from the volume of a cone, so the result is one third of the correct rate. D: This substitutes h = 6 into the volume formula before differentiating, which turns V into a constant whose derivative is 0.

**N-4.5-A-v2.** Grain pours from a chute at 8 cubic feet per minute and forms a conical pile whose base radius is always twice its height. How fast is the height of the pile increasing at the instant when the height is 1.5 feet?

- A. 8/(3π) feet per minute
- B. 8/(27π) feet per minute
- **C. 8/(9π) feet per minute**
- D. 0 feet per minute

Check: Since r = 2h, V = (1/3)π(4h²)h = (4π/3)h³ and dV/dt = 4πh²·dh/dt. At h = 1.5: 8 = 9π·dh/dt, so dh/dt = 8/(9π) feet per minute.
Rationales: A: This differentiates V = (1/3)πr²h with r held at its current value of 3, so the dependence of r on h is lost. The result is three times too large. B: This uses V = πr²h and omits the factor 1/3 from the volume of a cone, so the result is one third of the correct rate. D: This substitutes h = 1.5 into the volume formula before differentiating, which turns V into a constant whose derivative is 0.

**N-4.5-A-v3.** Water drains from a conical tank, vertex down, at 12 cubic feet per minute. The water's radius is always three-fourths of its depth. How fast is the water level changing at the instant when the depth is 4 feet?

- A. It is falling at 4/π feet per minute.
- B. It is falling at 4/(9π) feet per minute.
- C. It is rising at 4/(3π) feet per minute.
- **D. It is falling at 4/(3π) feet per minute.**

Check: Since r = (3/4)h, V = (1/3)π(9h²/16)h = (3π/16)h³ and dV/dt = (9π/16)h²·dh/dt. At h = 4: −12 = 9π·dh/dt, so dh/dt = −4/(3π) feet per minute.
Rationales: A: This differentiates V = (1/3)πr²h with r held at its current value of 3, so the dependence of r on h is lost. The result is three times too large. B: This uses V = πr²h and omits the factor 1/3 from the volume of a cone, so the result is one third of the correct rate. C: The magnitude is right, but the tank is draining, so dV/dt = −12 and the depth must be decreasing. This answer ignores the negative sign.

---

## Seed N-4.5-B (replaces apcalcab-mcq-009, apcalcab-mcq-032, apcalcab-mcq-np2-001) — Topic 4.5 Solving Related Rates Problems
**Skill:** relate the distance between two moving objects to their rates, using signs for approaching and receding motion.

Car P is 6 miles west of an intersection and is driving east toward it at 30 miles per hour. Car Q is 8 miles north of the same intersection and is driving north, away from it, at 40 miles per hour. At this instant, the distance D between the cars is changing at what rate?

- A. Increasing at 50 miles per hour
- B. Increasing at 70 miles per hour
- **C. Increasing at 14 miles per hour**
- D. Increasing at 140 miles per hour

Check: Let x = distance of P from the intersection and y = distance of Q. D² = x² + y², so D·dD/dt = x·dx/dt + y·dy/dt. Here x = 6, dx/dt = −30, y = 8, dy/dt = 40, D = 10, so dD/dt = (−180 + 320)/10 = 14.
Rationales: A: This treats the rate for the approaching car as +30 instead of −30, giving (6·30 + 8·40)/10 and ignoring that car P is getting closer to the intersection. B: This adds the two speeds, 30 + 40. The rate of change of the distance between the cars is not the sum of their speeds, because they move along perpendicular lines. D: This computes x·dx/dt + y·dy/dt = 140 but forgets to divide by D = 10, which comes from differentiating D² = x² + y².

**N-4.5-B-v1.** Boat A is 5 kilometers west of a dock and is moving east toward it at 12 kilometers per hour. Boat B is 12 kilometers north of the dock and is moving north, away from it, at 6 kilometers per hour. At this instant, the distance D between the boats is changing at what rate?

- A. Increasing at 132/13 kilometers per hour
- B. Increasing at 18 kilometers per hour
- C. Increasing at 12 kilometers per hour
- **D. Increasing at 12/13 kilometers per hour**

Check: D² = x² + y², so D·dD/dt = x·dx/dt + y·dy/dt. With x = 5, dx/dt = −12, y = 12, dy/dt = 6, D = 13: dD/dt = (−60 + 72)/13 = 12/13.
Rationales: A: This treats the rate for the approaching boat as +12 instead of −12, giving (5·12 + 12·6)/13 and ignoring that boat A is getting closer to the dock. B: This adds the two speeds, 12 + 6. The rate of change of the distance between the boats is not the sum of their speeds, because they move along perpendicular lines. C: This computes x·dx/dt + y·dy/dt = 12 but forgets to divide by D = 13, which comes from differentiating D² = x² + y².

**N-4.5-B-v2.** Car M is 12 miles east of an intersection and is driving east, away from it, at 5 miles per hour. Car N is 5 miles north of the same intersection and is driving south toward it at 10 miles per hour. At this instant, the distance D between the cars is changing at what rate?

- **A. Increasing at 10/13 miles per hour**
- B. Increasing at 110/13 miles per hour
- C. Increasing at 15 miles per hour
- D. Increasing at 10 miles per hour

Check: D² = x² + y², so D·dD/dt = x·dx/dt + y·dy/dt. With x = 12, dx/dt = 5, y = 5, dy/dt = −10, D = 13: dD/dt = (60 − 50)/13 = 10/13.
Rationales: B: This treats the rate for the approaching car as +10 instead of −10, giving (12·5 + 5·10)/13 and ignoring that car N is getting closer to the intersection. C: This adds the two speeds, 5 + 10. The rate of change of the distance between the cars is not the sum of their speeds, because they move along perpendicular lines. D: This computes x·dx/dt + y·dy/dt = 10 but forgets to divide by D = 13, which comes from differentiating D² = x² + y².

**N-4.5-B-v3.** Robot R is 8 meters east of a pillar and is moving west toward it at 3 meters per second. Robot S is 6 meters north of the pillar and is moving south toward it at 4 meters per second. At this instant, the distance D between the robots is changing at what rate?

- A. Increasing at 4.8 meters per second
- **B. Decreasing at 4.8 meters per second**
- C. Decreasing at 48 meters per second
- D. Decreasing at 7 meters per second

Check: D² = x² + y², so D·dD/dt = x·dx/dt + y·dy/dt. With x = 8, dx/dt = −3, y = 6, dy/dt = −4, D = 10: dD/dt = (−24 − 24)/10 = −4.8, so D is decreasing.
Rationales: A: The magnitude is right, but both robots move toward the pillar, so x·dx/dt + y·dy/dt is negative and the distance is shrinking. This answer has the wrong sign. C: This computes x·dx/dt + y·dy/dt = −48 but forgets to divide by D = 10, which comes from differentiating D² = x² + y². D: This adds the two speeds, 3 + 4. The rate of change of the distance between the robots is not the sum of their speeds, because they move along perpendicular lines.

---

## Seed N-4.6-A (replaces apcalcab-mcq-033, apcalcab-mcq-np2-010 (apcalcab-mcq-010 kept)) — Topic 4.6 Approximating Values of a Function Using Local Linearity and Linearization
**Skill:** form a tangent-line estimate and decide over or under from the trend of f′ in a table.

A differentiable function f has f(4) = 7, and selected values of f′ are given in the table.
x:   4.0   4.1   4.2   4.3
f′(x):   −2.0   −1.8   −1.5   −1.1
The tangent line to the graph of f at x = 4 is used to approximate f(4.3). Which statement is correct?

- **A. The approximation is 6.4, and it is an underestimate of f(4.3).**
- B. The approximation is 6.4, and it is an overestimate of f(4.3).
- C. The approximation is 7.6, and it is an overestimate of f(4.3).
- D. The approximation is 6.67, and it is an underestimate of f(4.3).

Check: L(4.3) = f(4) + f′(4)(4.3 − 4) = 7 + (−2.0)(0.3) = 6.4. The values of f′ are increasing, so f″ > 0, the graph is concave up, and the tangent line lies below it: 6.4 underestimates f(4.3).
Rationales: B: The values of f′ increase from −2.0 to −1.1, so f is concave up on this interval and the tangent line lies below the graph, giving an underestimate. C: This adds 0.6 instead of subtracting it, ignoring that f′(4) = −2.0 is negative. The tangent line value is 7 + (−2.0)(0.3) = 6.4. D: This uses the slope f′(4.3) = −1.1 at the far end. The tangent line at x = 4 must use the slope f′(4) = −2.0, which gives 6.4.

**N-4.6-A-v1.** A differentiable function f has f(1) = 12, and selected values of f′ are given in the table.
x:   1.0   1.2   1.4   1.5
f′(x):   5.0   4.2   3.1   2.4
The tangent line to the graph of f at x = 1 is used to approximate f(1.5). Which statement is correct?

- A. The approximation is 14.5, and it is an underestimate of f(1.5).
- **B. The approximation is 14.5, and it is an overestimate of f(1.5).**
- C. The approximation is 13.2, and it is an underestimate of f(1.5).
- D. The approximation is 19.5, and it is an overestimate of f(1.5).

Check: L(1.5) = f(1) + f′(1)(1.5 − 1) = 12 + 5.0(0.5) = 14.5. The values of f′ are decreasing, so f″ < 0, the graph is concave down, and the tangent line lies above it: 14.5 overestimates f(1.5).
Rationales: A: The values of f′ decrease from 5.0 to 2.4, so f is concave down on this interval and the tangent line lies above the graph, giving an overestimate. C: This uses the slope f′(1.5) = 2.4 at the far end. The tangent line at x = 1 must use the slope f′(1) = 5.0, which gives 14.5. D: This multiplies the slope by 1.5, the new x-value, instead of by the change in x, which is 0.5.

**N-4.6-A-v2.** A differentiable function f has f(6) = −2, and selected values of f′ are given in the table.
x:   5.6   5.8   6.0
f′(x):   2.0   2.5   3.0
The tangent line to the graph of f at x = 6 is used to approximate f(5.8). Which statement is correct?

- A. The approximation is −2.6, and it is an overestimate of f(5.8).
- B. The approximation is −1.4, and it is an overestimate of f(5.8).
- **C. The approximation is −2.6, and it is an underestimate of f(5.8).**
- D. The approximation is −2.5, and it is an underestimate of f(5.8).

Check: L(5.8) = f(6) + f′(6)(5.8 − 6) = −2 + 3(−0.2) = −2.6. The values of f′ are increasing, so f″ > 0 and the graph is concave up; the tangent line lies below it on both sides, so −2.6 underestimates f(5.8).
Rationales: A: The values of f′ increase from 2.0 to 3.0, so f is concave up, and a tangent line to a concave up graph lies below it on both sides of the point, giving an underestimate. B: This uses x − 6 = +0.2 instead of −0.2. Moving left from x = 6 lowers the tangent line value, so L(5.8) = −2 + 3(−0.2) = −2.6. D: This uses the slope f′(5.8) = 2.5 at the point being estimated. The tangent line at x = 6 must use the slope f′(6) = 3.0.

**N-4.6-A-v3.** A differentiable function f has f(3) = 5, and selected values of f′ are given in the table.
x:   3.0   3.2   3.4
f′(x):   −1.0   −1.4   −2.0
The tangent line to the graph of f at x = 3 is used to approximate f(3.4). Which statement is correct?

- A. The approximation is 4.6, and it is an underestimate of f(3.4).
- B. The approximation is 4.2, and it is an underestimate of f(3.4).
- C. The approximation is 5.4, and it is an overestimate of f(3.4).
- **D. The approximation is 4.6, and it is an overestimate of f(3.4).**

Check: L(3.4) = f(3) + f′(3)(3.4 − 3) = 5 + (−1.0)(0.4) = 4.6. The values of f′ are decreasing, so f″ < 0, the graph is concave down, and the tangent line lies above it: 4.6 overestimates f(3.4).
Rationales: A: The values of f′ decrease from −1.0 to −2.0, so f is concave down and the tangent line lies above the graph, giving an overestimate. Decreasing f does not mean an underestimate. B: This uses the slope f′(3.4) = −2.0 at the far end. The tangent line at x = 3 must use the slope f′(3) = −1.0, which gives 4.6. C: This adds 0.4 instead of subtracting it, ignoring that f′(3) = −1.0 is negative. The tangent line value is 5 + (−1.0)(0.4) = 4.6.

---

## Seed N-4.6-B (replaces apcalcab-mcq-033, apcalcab-mcq-np2-010 (apcalcab-mcq-010 kept)) — Topic 4.6 Approximating Values of a Function Using Local Linearity and Linearization
**Skill:** use a linear approximation to turn a percent error in a measurement into a percent error in a derived quantity.

The radius of a spherical balloon is measured with a possible error of 2 percent. Using a linear approximation, what is the approximate percent error in the volume V = (4/3)πr³ calculated from this radius?

- A. 2 percent
- B. 4 percent
- **C. 6 percent**
- D. 8 percent

Check: dV = 4πr²·dr, so dV/V = 4πr²·dr/((4/3)πr³) = 3·dr/r = 3(2%) = 6%.
Rationales: A: This assumes the relative error in V equals the relative error in r. Since V depends on r³, the relative error is multiplied by 3. B: This uses the exponent 2, as if the formula were an area such as πr². The volume formula has r³, so the factor is 3. D: This cubes the percent, 2³, instead of multiplying by the exponent. The linear approximation gives dV/V = 3·dr/r.

**N-4.6-B-v1.** The edge of a cube is measured with a possible error of 1.5 percent. Using a linear approximation, what is the approximate percent error in the volume V = s³ calculated from this edge length?

- A. 1.5 percent
- B. 3 percent
- C. 3.375 percent
- **D. 4.5 percent**

Check: dV = 3s²·ds, so dV/V = 3s²·ds/s³ = 3·ds/s = 3(1.5%) = 4.5%.
Rationales: A: This assumes the relative error in V equals the relative error in s. Since V depends on s³, the relative error is multiplied by 3. B: This uses the exponent 2, as if the formula were an area such as s². The volume formula has s³, so the factor is 3. C: This cubes the percent, 1.5³, instead of multiplying by the exponent. The linear approximation gives dV/V = 3·ds/s.

**N-4.6-B-v2.** The diameter of a circular plate is measured with a possible error of 3 percent. Using a linear approximation, what is the approximate percent error in the area A = π(d/2)² calculated from this diameter?

- **A. 6 percent**
- B. 3 percent
- C. 9 percent
- D. 1.5 percent

Check: A = (π/4)d², so dA = (π/2)d·dd and dA/A = ((π/2)d·dd)/((π/4)d²) = 2·dd/d = 2(3%) = 6%.
Rationales: B: This assumes the relative error in A equals the relative error in d. Since A depends on d², the relative error is multiplied by 2. C: This squares the percent, 3², or uses the exponent 3, instead of multiplying by the exponent 2. The linear approximation gives dA/A = 2·dd/d. D: This halves the error because the radius is half the diameter. The percent error of d/2 equals that of d, and the exponent 2 then doubles it.

**N-4.6-B-v3.** The length of a pendulum is measured with a possible error of 4 percent. Using a linear approximation, what is the approximate percent error in the period T = 2π√(L/g) calculated from this length, where g is a constant?

- A. 4 percent
- **B. 2 percent**
- C. 8 percent
- D. 16 percent

Check: T = (2π/√g)·L^(1/2), so dT = (π/√g)L^(−1/2)·dL and dT/T = (1/2)·dL/L = (1/2)(4%) = 2%.
Rationales: A: This assumes the relative error in T equals the relative error in L. Since T depends on the square root of L, the relative error is multiplied by 1/2. C: This doubles the error instead of halving it. The exponent of L in T is 1/2, so the linear approximation gives dT/T = (1/2)·dL/L. D: This squares the percent, 4², instead of multiplying by the exponent 1/2. The linear approximation gives dT/T = (1/2)·dL/L.

---

## Seed N-4.7-A (replaces apcalcab-mcq-034, apcalcab-mcq-np2-002) — Topic 4.7 Using L'Hospital's Rule for Determining Limits of Indeterminate Forms
**Skill:** recognize that L'Hospital's Rule must be applied more than once, rechecking the form after each step.

What is lim(x→0) (x − sin x)/x³?

- **A. 1/6**
- B. 0
- C. 1/3
- D. 1/2

Check: Direct substitution gives 0/0. L'Hospital: (1 − cos x)/(3x²), still 0/0. Again: sin x/(6x), still 0/0. Again: cos x/6 → 1/6.
Rationales: B: This applies L'Hospital's Rule once to get (1 − cos x)/(3x²), then evaluates only the numerator, 1 − cos 0 = 0, and ignores that the denominator is also 0, so the rule must be applied again. C: After the first application this treats (1 − cos x)/x² like the limit of sin x / x and replaces it with 1, leaving 1/3. The correct value of (1 − cos x)/x² is 1/2. D: This uses the known limit (1 − cos x)/x² = 1/2 but drops the factor 1/3 from the derivative of x³, which is 3x².

**N-4.7-A-v1.** What is lim(x→0) (eˣ − 1 − x)/x²?

- A. 0
- **B. 1/2**
- C. 1
- D. 2

Check: Direct substitution gives 0/0. L'Hospital: (eˣ − 1)/(2x), still 0/0. Again: eˣ/2 → 1/2.
Rationales: A: This applies L'Hospital's Rule once to get (eˣ − 1)/(2x), then evaluates only the numerator, e⁰ − 1 = 0, and ignores that the denominator is also 0, so the rule must be applied again. C: After the first application this treats (eˣ − 1)/(2x) as if the 2 were not there and uses the limit of (eˣ − 1)/x, which is 1. The factor 1/2 from 2x is lost. D: After the first application this moves the 2 from the denominator 2x into the numerator, writing 2(eˣ − 1)/x, so the limit becomes 2 instead of 1/2.

**N-4.7-A-v2.** What is lim(x→0) (1 − cos 2x)/x²?

- A. 0
- B. 1
- **C. 2**
- D. 4

Check: Direct substitution gives 0/0. L'Hospital: 2 sin 2x/(2x) = sin 2x/x, still 0/0. Again: 2 cos 2x/1 → 2.
Rationales: A: This applies L'Hospital's Rule once to get 2 sin 2x/(2x), then evaluates only the numerator, 2 sin 0 = 0, and ignores that the denominator is also 0, so the rule must be applied again. B: This differentiates 1 − cos 2x as sin 2x, forgetting the chain-rule factor 2, so the limit of sin 2x/(2x) is taken as 1 instead of 2. D: The second application gives 4 cos 2x over the derivative of 2x, which is 2. This answer leaves out the division by 2 and reports 4.

**N-4.7-A-v3.** What is lim(x→0) (eˣ − e⁻ˣ − 2x)/x³?

- A. 0
- B. 1/6
- C. does not exist
- **D. 1/3**

Check: Direct substitution gives 0/0. L'Hospital: (eˣ + e⁻ˣ − 2)/(3x²), 0/0. Again: (eˣ − e⁻ˣ)/(6x), 0/0. Again: (eˣ + e⁻ˣ)/6 → 2/6 = 1/3.
Rationales: A: This applies L'Hospital's Rule once to get (eˣ + e⁻ˣ − 2)/(3x²), then evaluates only the numerator, 1 + 1 − 2 = 0, and ignores that the denominator is also 0, so the rule must be applied again. B: After the final step the numerator is eˣ + e⁻ˣ, which equals 2 at x = 0. This answer takes it as 1, giving 1/6 instead of 2/6. C: This treats each 0/0 as meaning the limit does not exist. A 0/0 form is indeterminate, so the rule can be applied again, and here it leads to a finite value.

---

## Seed N-4.7-B (replaces apcalcab-mcq-034, apcalcab-mcq-np2-002) — Topic 4.7 Using L'Hospital's Rule for Determining Limits of Indeterminate Forms
**Skill:** recognize when L'Hospital's Rule is inconclusive because the limit of the derivative quotient does not exist.

Which statement about lim(x→∞) (x + sin x)/x is correct?

- A. The limit does not exist, because L'Hospital's Rule gives 1 + cos x, which oscillates.
- B. The limit is ∞, because the numerator is larger than the denominator.
- **C. The limit is 1, and L'Hospital's Rule gives no conclusion because the limit of 1 + cos x does not exist.**
- D. The limit is 0, because sin x is bounded and the denominator grows without bound.

Check: (x + sin x)/x = 1 + (sin x)/x. Since |sin x/x| ≤ 1/x → 0, the limit is 1. L'Hospital's Rule gives (1 + cos x)/1, which oscillates between 0 and 2, so the rule is inconclusive.
Rationales: A: L'Hospital's Rule only concludes something when the limit of the derivative quotient exists. If it does not, the original limit can still exist, and here (x + sin x)/x = 1 + (sin x)/x → 1. B: The numerator exceeds the denominator only by sin x, which stays between −1 and 1. The quotient equals 1 + (sin x)/x, which approaches 1. D: Only the term (sin x)/x approaches 0. The quotient is x/x + (sin x)/x = 1 + (sin x)/x, so the limit is 1, not 0.

**N-4.7-B-v1.** Which statement about lim(x→∞) (3x − cos x)/x is correct?

- A. The limit does not exist, because L'Hospital's Rule gives 3 + sin x, which oscillates.
- B. The limit is ∞, because the form is ∞/∞, which equals ∞.
- C. The limit is 0, because cos x is bounded and the denominator grows without bound.
- **D. The limit is 3, and L'Hospital's Rule gives no conclusion because the limit of 3 + sin x does not exist.**

Check: (3x − cos x)/x = 3 − (cos x)/x → 3. L'Hospital's Rule gives (3 + sin x)/1, which oscillates between 2 and 4, so the rule is inconclusive.
Rationales: A: L'Hospital's Rule only concludes something when the limit of the derivative quotient exists. If it does not, the original limit can still exist, and here (3x − cos x)/x = 3 − (cos x)/x → 3. B: The form ∞/∞ is indeterminate and can have any value. Here the quotient equals 3 − (cos x)/x, which approaches 3. C: Only the term (cos x)/x approaches 0. The quotient is 3x/x − (cos x)/x = 3 − (cos x)/x, so the limit is 3, not 0.

**N-4.7-B-v2.** Which statement about lim(x→∞) (x² + 2 sin x)/x² is correct?

- **A. The limit is 1, even though repeated use of L'Hospital's Rule ends in 1 − sin x, which has no limit.**
- B. The limit does not exist, because L'Hospital's Rule eventually gives 1 − sin x, which oscillates.
- C. The limit is 2, because the numerator contains the term 2 sin x.
- D. The limit is ∞, because the form ∞/∞ equals ∞.

Check: (x² + 2 sin x)/x² = 1 + 2 sin x/x² → 1. L'Hospital: (2x + 2 cos x)/(2x), again ∞/∞: (2 − 2 sin x)/2 = 1 − sin x, which oscillates, so the rule never concludes.
Rationales: B: L'Hospital's Rule only concludes something when the limit of the derivative quotient exists. Here (x² + 2 sin x)/x² = 1 + 2 sin x/x² → 1 by direct reasoning. C: The term 2 sin x is bounded and is divided by x², so it contributes 0 in the limit. The quotient equals 1 + 2 sin x/x², which approaches 1. D: The form ∞/∞ is indeterminate and can have any value. Here the quotient equals 1 + 2 sin x/x², which approaches 1.

**N-4.7-B-v3.** Which statement about lim(x→∞) (5x + 2 cos x)/(x + 1) is correct?

- A. The limit does not exist, because L'Hospital's Rule gives 5 − 2 sin x, which oscillates.
- **B. The limit is 5, and L'Hospital's Rule gives no conclusion because the limit of 5 − 2 sin x does not exist.**
- C. The limit is 3, because L'Hospital's Rule gives 5 − 2 sin x and sin x approaches 1.
- D. The limit is 0, because cos x is bounded and the denominator grows without bound.

Check: Divide top and bottom by x: (5 + 2 cos x/x)/(1 + 1/x) → 5. L'Hospital's Rule gives (5 − 2 sin x)/1, which oscillates between 3 and 7, so the rule is inconclusive.
Rationales: A: L'Hospital's Rule only concludes something when the limit of the derivative quotient exists. Dividing the top and bottom by x shows the limit is 5. C: Sin x does not approach any value as x grows; it keeps oscillating. The bounded term 2 cos x does not change the limit, which is 5 by dividing numerator and denominator by x. D: Only the term 2 cos x/(x + 1) approaches 0. The leading terms 5x and x give a ratio of 5, so the limit is 5, not 0.

---
