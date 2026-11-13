# AP Calculus AB topics 1.1 to 1.8: harder seeds (Unit 1, first half)

DRAFT for owner review. Author-in-session; not checked by a checker; not in the database. Every key recomputed in Python (limits, tables, parameter solves). Calculator-free; no images; graphs and tables described in words.
Target level: R3 interpretation, multi-step reasoning and error analysis. Seed A and seed B in each topic test different skills; variants keep the skill with new functions, contexts and wrong-answer structures.

| Seed | Topic | Replaces |
|---|---|---|
| N-1.1-A | 1.1 Introducing Calculus: Can Change Occur a | new |
| N-1.1-B | 1.1 Introducing Calculus: Can Change Occur a | new |
| N-1.2-A | 1.2 Defining Limits and Using Limit Notation | new |
| N-1.2-B | 1.2 Defining Limits and Using Limit Notation | new |
| N-1.3-A | 1.3 Estimating Limit Values from Graphs | new |
| N-1.3-B | 1.3 Estimating Limit Values from Graphs | new |
| N-1.4-A | 1.4 Estimating Limit Values from Tables | new |
| N-1.4-B | 1.4 Estimating Limit Values from Tables | new |
| N-1.5-A | 1.5 Determining Limits Using Algebraic Prope | new |
| N-1.5-B | 1.5 Determining Limits Using Algebraic Prope | new |
| N-1.6-A | 1.6 Determining Limits Using Algebraic Manip | new |
| N-1.6-B | 1.6 Determining Limits Using Algebraic Manip | new |
| N-1.7-A | 1.7 Selecting Procedures for Determining Lim | new |
| N-1.7-B | 1.7 Selecting Procedures for Determining Lim | new |
| N-1.8-A | 1.8 Determining Limits Using the Squeeze The | new |
| N-1.8-B | 1.8 Determining Limits Using the Squeeze The | new |

---

## Seed N-1.1-A (new) — Topic 1.1 Introducing Calculus: Can Change Occur at an Instant?
**Skill:** use average rates over shrinking intervals computed from position values to estimate an instantaneous rate and separate it from averages and amounts.

A cart's position along a track is s(t) = 2t² + t meters at time t seconds. Its positions are s(3) = 21, s(3.1) = 22.32, s(3.01) = 21.1302, and s(3.001) = 21.013002. Using the average velocities over [3, 3 + h] for h = 0.1, 0.01, and 0.001, which value do these averages suggest for the instantaneous velocity at t = 3?

- A. 13.2 meters per second
- B. 13.002 meters per second
- C. 7 meters per second
- **D. 13 meters per second**
Check: The average velocities over [3, 3 + h] are 1.32/0.1 = 13.2, 0.1302/0.01 = 13.02, and 0.013002/0.001 = 13.002. They approach 13 as h shrinks, so the instantaneous velocity at t = 3 is 13.
Rationales: A: The value 13.2 is only the average velocity over the longest interval, [3, 3.1]. Averages over shorter intervals are closer to the instantaneous velocity and keep moving toward 13. B: The value 13.002 is the average velocity over [3, 3.001], not an instantaneous velocity. The pattern of averages (13.2, 13.02, 13.002) shows they settle toward 13, which is the instantaneous velocity. C: The ratio s(3)/3 = 7 is the average velocity from t = 0 to t = 3, a long interval that says little about the velocity at the single instant t = 3.

**N-1.1-A-v1.** The population of a bacteria culture is P(t) = 3t² − t hundred bacteria at time t hours. The values are P(1) = 2, P(1.1) = 2.53, P(1.01) = 2.0503, and P(1.001) = 2.005003. Using the average rates of change over [1, 1 + h] for h = 0.1, 0.01, and 0.001, which value do they suggest for the instantaneous rate of change of the population at t = 1?

- **A. 5 hundred bacteria per hour**
- B. 5.3 hundred bacteria per hour
- C. 5.003 hundred bacteria per hour
- D. 2 hundred bacteria per hour
Check: The average rates are 0.53/0.1 = 5.3, 0.0503/0.01 = 5.03, and 0.005003/0.001 = 5.003. They approach 5 as the interval shrinks, so the instantaneous rate at t = 1 is 5.
Rationales: B: The value 5.3 is the average rate over the longest interval, [1, 1.1]. It is only the first, roughest approximation; shorter intervals give values closer to 5. C: The value 5.003 is the average rate over [1, 1.001], not the instantaneous rate. The sequence of averages 5.3, 5.03, 5.003 approaches 5, which is the instantaneous rate. D: The number 2 is P(1), the population itself in hundreds of bacteria. It is an amount, not a rate, and cannot be the rate of change per hour.

**N-1.1-A-v2.** The volume of fuel in a tank is V(t) = t² + 4t liters at time t minutes. The values are V(2.9) = 20.01, V(2.99) = 20.9001, V(2.999) = 20.990001, and V(3) = 21. Using the average rates of change over [2.9, 3], [2.99, 3], and [2.999, 3], which value do they suggest for the instantaneous rate of change of volume at t = 3?

- A. 9.9 liters per minute
- B. 9.999 liters per minute
- **C. 10 liters per minute**
- D. 21 liters per minute
Check: The average rates are 0.99/0.1 = 9.9, 0.0999/0.01 = 9.99, and 0.009999/0.001 = 9.999. They approach 10 from below, so the instantaneous rate at t = 3 is 10.
Rationales: A: The value 9.9 is the average rate over the longest interval, [2.9, 3]. The averages over shorter intervals keep climbing toward 10. B: The value 9.999 is an average rate over a tiny interval, not the instantaneous rate. The averages 9.9, 9.99, 9.999 approach 10, the instantaneous rate. D: The number 21 is V(3), an amount of fuel in liters. It is not a rate, so it cannot answer a question about liters per minute.

**N-1.1-A-v3.** A drone's height is h(t) = −4t² + 20t meters at time t seconds. The values are h(1) = 16, h(1.1) = 17.16, h(1.01) = 16.1196, and h(1.001) = 16.011996. Using the average velocities over [1, 1 + k] for k = 0.1, 0.01, and 0.001, which value do they suggest for the drone's instantaneous velocity at t = 1?

- A. 11.6 meters per second
- **B. 12 meters per second**
- C. 11.996 meters per second
- D. 16 meters per second
Check: The average velocities are 1.16/0.1 = 11.6, 0.1196/0.01 = 11.96, and 0.011996/0.001 = 11.996. They approach 12 from below, so the instantaneous velocity at t = 1 is 12.
Rationales: A: The value 11.6 is the average velocity over the longest interval, [1, 1.1]. Shorter intervals give averages closer to 12. C: The value 11.996 is the average velocity over [1, 1.001], not the instantaneous velocity. The averages 11.6, 11.96, 11.996 approach 12, the instantaneous velocity. D: The number 16 is h(1), the drone's height in meters. A height is a position, not a velocity in meters per second.

---

## Seed N-1.1-B (new) — Topic 1.1 Introducing Calculus: Can Change Occur at an Instant?
**Skill:** reason about how a strictly monotone instantaneous rate relates to the average rate over an interval and to midpoint values.

A car's velocity v(t), in meters per second, is continuous and strictly increasing for 0 ≤ t ≤ 10, where t is in seconds. The car's position s satisfies s(0) = 0 and s(10) = 120 meters. Which statement must be true?

- A. v(5) = 12
- **B. v(0) < 12 < v(10)**
- C. v(0) > 12 > v(10)
- D. v(t) = 12 for every t in [0, 10]
Check: The average velocity over [0, 10] is (120 − 0)/10 = 12 m/s. Because v is strictly increasing, every instantaneous velocity lies between v(0) and v(10), so the average lies strictly between them.
Rationales: A: The velocity at the midpoint equals the average only when the velocity is linear in time. A strictly increasing velocity need not be linear, so nothing forces v(5) to equal 12. C: This reverses the order. When velocity strictly increases, the earliest velocity is the smallest and the latest is the largest, so the average sits between them in the order v(0) < 12 < v(10). D: A constant velocity of 12 would have an average of 12, but the velocity is strictly increasing, so it cannot be constant. Only the average, not every instantaneous value, equals 12.

**N-1.1-B-v1.** The number of bacteria in a culture is P(t) thousand at time t hours. The rate of change P′(t) is continuous and strictly decreasing for 0 ≤ t ≤ 6. Also P(0) = 500 and P(6) = 1100. Which statement must be true?

- **A. P′(0) > 100 > P′(6)**
- B. P′(3) = 100
- C. P′(0) < 100 < P′(6)
- D. P(3) = 800
Check: The average rate over [0, 6] is (1100 − 500)/6 = 100 thousand per hour. Because P′ is strictly decreasing, it starts above its average and ends below it.
Rationales: B: The rate at the midpoint equals the average only for a constant or linear-in-time rate. A strictly decreasing P′ gives no reason for the midpoint value to equal 100. C: This order fits a rate that is increasing. Here P′ is strictly decreasing, so the earliest rate is the largest and the latest is the smallest. D: The value 800 is the midpoint of 500 and 1100, which would hold only if the culture grew at a constant rate. With a decreasing rate the culture grows faster early on, so P(3) is larger than 800.

**N-1.1-B-v2.** Water drains from a tank, and the volume is V(t) liters at time t minutes. The rate of change V′(t) is continuous and strictly increasing for 0 ≤ t ≤ 8, with V(0) = 200 and V(8) = 80. Which statement must be true?

- A. V′(4) = −15
- B. V′(0) > −15 > V′(8)
- **C. V′(0) < −15 < V′(8)**
- D. V(4) = 140
Check: The average rate over [0, 8] is (80 − 200)/8 = −15 liters per minute. Because V′ is strictly increasing, it starts below −15 and ends above −15.
Rationales: A: The rate at the midpoint equals the average only for a linear-in-time rate. A strictly increasing V′ gives no such guarantee. B: This order fits a rate that is decreasing. Here V′ is strictly increasing, so the earliest rate is the smallest (most negative) and the latest is the largest. D: The value 140 is the midpoint of 200 and 80, which holds only if the tank drains at a constant rate. The draining slows over time, so more water is lost early and V(4) is less than 140.

**N-1.1-B-v3.** A drone descends so that its altitude is A(t) meters at time t minutes. The rate of change A′(t) is continuous and strictly decreasing for 0 ≤ t ≤ 5, with A(0) = 400 and A(5) = 100. Which statement must be true?

- A. A′(0) < −60 < A′(5)
- B. A′(2.5) = −60
- C. A(2.5) = 250
- **D. A′(0) > −60 > A′(5)**
Check: The average rate over [0, 5] is (100 − 400)/5 = −60 meters per minute. Because A′ is strictly decreasing, it starts above −60 and ends below −60.
Rationales: A: This order fits a rate that is increasing. Here A′ is strictly decreasing, so the earliest rate is the largest (least negative) and the latest is the smallest. B: The rate at the midpoint equals the average only when the rate is linear in time. A strictly decreasing A′ gives no such guarantee. C: The value 250 is the midpoint of 400 and 100, true only for a constant descent rate. The descent speeds up over time, so the drone loses height more slowly early and A(2.5) is greater than 250.

---

## Seed N-1.2-A (new) — Topic 1.2 Defining Limits and Using Limit Notation
**Skill:** evaluate a limit of f(g(x)) by determining from which side the inner expression approaches the point, using one-sided limit notation.

A function f satisfies lim(x→1⁻) f(x) = 3, lim(x→1⁺) f(x) = −1, and f(1) = 7. What is lim(x→0) f(1 − x²)?

- A. −1
- B. 7
- **C. 3**
- D. The limit does not exist
Check: For x ≠ 0 near 0, 1 − x² is slightly less than 1, so the input to f approaches 1 from the left only. The limit is therefore the left-hand limit of f at 1, which is 3.
Rationales: A: The value −1 is the limit of f as its input approaches 1 from the right. Since 1 − x² is always less than 1, the input approaches 1 from the left, not the right. B: The value 7 is f(1), but the input 1 − x² never equals 1 when x ≠ 0. A limit depends on the nearby values of f, not on the value at the point. D: The limit would fail to exist if the input approached 1 from both sides, but 1 − x² approaches 1 only from below. Only the left-hand limit of f matters, and it is 3.

**N-1.2-A-v1.** A function f satisfies lim(x→1⁻) f(x) = 2, lim(x→1⁺) f(x) = 6, and f(1) = −4. What is lim(x→0) f(1 + x²)?

- A. 2
- **B. 6**
- C. −4
- D. The limit does not exist
Check: For x ≠ 0 near 0, 1 + x² is slightly greater than 1, so the input to f approaches 1 from the right only. The limit is the right-hand limit of f at 1, which is 6.
Rationales: A: The value 2 is the limit of f as its input approaches 1 from the left. Since 1 + x² is always greater than 1, the input approaches 1 from the right. C: The value −4 is f(1), but 1 + x² never equals 1 when x ≠ 0. A limit uses nearby values of f and ignores the value at the point. D: The one-sided limits of f differ, but the input 1 + x² approaches 1 from one side only. Only the right-hand limit of f is involved, so the limit exists and equals 6.

**N-1.2-A-v2.** A function f satisfies lim(x→3⁻) f(x) = −5, lim(x→3⁺) f(x) = 4, and f(3) = 0. What is lim(x→1) f(3 − |x − 1|)?

- A. 4
- B. 0
- C. The limit does not exist
- **D. −5**
Check: For x ≠ 1 near 1, 3 − |x − 1| is slightly less than 3, so the input to f approaches 3 from the left only. The limit is the left-hand limit of f at 3, which is −5.
Rationales: A: The value 4 is the limit of f as its input approaches 3 from the right. Because |x − 1| is positive, 3 − |x − 1| lies below 3, so the input approaches 3 from the left. B: The value 0 is f(3), reached only if the input equals 3 exactly. The limit looks at inputs near 3 but not equal to it when x ≠ 1. C: The two one-sided limits of f at 3 disagree, but the input approaches 3 from one side only. The relevant one-sided limit is −5, so the limit exists.

**N-1.2-A-v3.** A function f satisfies lim(x→−2⁻) f(x) = 1, lim(x→−2⁺) f(x) = −3, and f(−2) = 2. What is lim(x→2) f(−2 + (x − 2)²)?

- **A. −3**
- B. 1
- C. 2
- D. The limit does not exist
Check: For x ≠ 2 near 2, −2 + (x − 2)² is slightly greater than −2, so the input to f approaches −2 from the right only. The limit is the right-hand limit of f at −2, which is −3.
Rationales: B: The value 1 is the limit of f as its input approaches −2 from the left. Since (x − 2)² is positive, the input −2 + (x − 2)² lies above −2 and approaches from the right. C: The value 2 is f(−2). The inner expression equals −2 only at x = 2, and a limit ignores the value at the point and uses nearby inputs. D: The one-sided limits of f at −2 differ, but the input approaches −2 from one side only. The limit exists and equals the right-hand value.

---

## Seed N-1.2-B (new) — Topic 1.2 Defining Limits and Using Limit Notation
**Skill:** set one-sided limits equal to find a parameter for which a two-sided limit exists, ignoring the function value at the point.

Let f be defined by f(x) = kx + 1 for x < 2, f(2) = 10, and f(x) = x² − k for x > 2, where k is a constant. For which value of k does lim(x→2) f(x) exist?

- A. k = 9/2
- B. k = 3
- C. k = 4/3
- **D. k = 1**
Check: The left-hand limit is 2k + 1 and the right-hand limit is 4 − k. Setting 2k + 1 = 4 − k gives 3k = 3, so k = 1, and both one-sided limits equal 3.
Rationales: A: This sets 2k + 1 = f(2) = 10. The value of f at 2 does not affect whether the limit exists; the two one-sided limits must be equal to each other. B: This sets 2k + 1 = 4 + k, replacing the right-hand limit 4 − k with 4 + k. The right piece is x² − k, which tends to 4 − k. C: This sets 2k = 4 − k and drops the constant term 1 from the left piece. The left-hand limit is 2k + 1, so 2k + 1 = 4 − k is the correct equation.

**N-1.2-B-v1.** Let f be defined by f(x) = kx − 1 for x < 2, f(2) = 0, and f(x) = x² + k for x > 2, where k is a constant. For which value of k does lim(x→2) f(x) exist?

- A. k = 1/2
- **B. k = 5**
- C. k = 5/3
- D. k = 4
Check: The left-hand limit is 2k − 1 and the right-hand limit is 4 + k. Setting 2k − 1 = 4 + k gives k = 5, and both one-sided limits equal 9.
Rationales: A: This sets 2k − 1 = f(2) = 0. The limit's existence depends on the two one-sided limits agreeing, not on the value of f at 2. C: This sets 2k − 1 = 4 − k, using −k for the right piece. The right piece is x² + k, so its limit is 4 + k. D: This sets 2k = 4 + k and drops the constant −1 from the left piece. The left-hand limit is 2k − 1, so the equation 2k − 1 = 4 + k is needed.

**N-1.2-B-v2.** Let f be defined by f(x) = kx + 2 for x < 3, f(3) = 7, and f(x) = 14 − kx for x > 3, where k is a constant. For which value of k does lim(x→3) f(x) exist?

- **A. k = 2**
- B. k = 5/3
- C. k = 7/3
- D. k = 3
Check: The left-hand limit is 3k + 2 and the right-hand limit is 14 − 3k. Setting 3k + 2 = 14 − 3k gives 6k = 12, so k = 2, and both one-sided limits equal 8.
Rationales: B: This sets 3k + 2 = f(3) = 7. The value f(3) plays no role in whether the limit exists; the one-sided limits must match each other. C: This sets 3k = 14 − 3k and drops the constant 2 from the left piece. The left-hand limit is 3k + 2, so both pieces' constants must be kept. D: This sets 3k + 2 = 14 − k, forgetting to multiply k by 3 in the right piece. The right-hand limit is 14 − 3k.

**N-1.2-B-v3.** Let f be defined by f(x) = kx² + 1 for x < 1, f(1) = 0, and f(x) = 9 − kx for x > 1, where k is a constant. For which value of k does lim(x→1) f(x) exist?

- A. k = −1
- B. k = 9/2
- **C. k = 4**
- D. k = 5
Check: The left-hand limit is k + 1 and the right-hand limit is 9 − k. Setting k + 1 = 9 − k gives k = 4, and both one-sided limits equal 5.
Rationales: A: This sets k + 1 = f(1) = 0. The value of f at 1 does not decide whether the limit exists; the one-sided limits must equal each other. B: This sets k = 9 − k and drops the constant 1 from the left piece. The left-hand limit is k + 1, not k. D: This sets k − 1 = 9 − k, a sign slip that turns the +1 in kx² + 1 into −1. The left-hand limit is k + 1.

---

## Seed N-1.3-A (new) — Topic 1.3 Estimating Limit Values from Graphs
**Skill:** read a verbally described graph at several points and distinguish where a finite limit exists from where the function value, one-sided behavior or unbounded growth interferes.

The graph of f on [0, 8] has these features. At x = 1 the curve jumps: it approaches height 2 from the left and height 5 from the right, and the filled point is (1, 2). At x = 3 the curve on both sides approaches height 4, there is an open circle at (3, 4), and the only filled point on the line x = 3 is (3, 1). At x = 5 the curve rises without bound on both sides of a vertical asymptote. At x = 7 the curve is smooth and passes through the filled point (7, 3). At how many of the values x = 1, 3, 5, 7 does lim(x→a) f(x) exist as a finite number?

- A. 1
- B. 3
- **C. 2**
- D. 4
Check: The limit exists at x = 3 (both sides approach 4) and at x = 7 (smooth curve through (7, 3)). It fails at x = 1 (one-sided limits 2 and 5 differ) and at x = 5 (the curve is unbounded). That is 2 values.
Rationales: A: Only x = 7 has a point on the curve at the limit value, which gives 1. But x = 3 also has a limit of 4, even though the filled point (3, 1) is elsewhere; the value of f(3) does not matter. B: Counting x = 1 because the filled point (1, 2) matches the left-hand limit, or counting x = 5 for its infinite behavior, gives 3. At x = 1 the one-sided limits differ, and at x = 5 the curve increases without bound, which is not a finite limit. D: A limit exists at every listed value only if the curve approaches a single finite height from both sides. The jump at x = 1 and the vertical asymptote at x = 5 prevent that.

**N-1.3-A-v1.** The graph of f has these features. At x = −3 the curve rises to +∞ on the left side of a vertical asymptote and falls to −∞ on the right side. At x = −1 the curve approaches height 0 from both sides, but the only filled point on the line x = −1 is (−1, 3). At x = 1 there is an open circle at (1, 2) with the curve approaching 2 from both sides and no filled point on that line. At x = 3 the graph has a sharp corner at the filled point (3, 1), with the curve approaching 1 from both sides. At x = 5 the curve approaches height 1 from the left and height −1 from the right, and the filled point is (5, −1). At how many of the values x = −3, −1, 1, 3, 5 does lim(x→a) f(x) exist as a finite number?

- A. 1
- B. 4
- C. 5
- **D. 3**
Check: The limit exists at x = −1 (both sides approach 0), at x = 1 (both sides approach 2), and at x = 3 (both sides approach 1). It fails at x = −3 (unbounded) and at x = 5 (one-sided limits 1 and −1 differ). That is 3 values.
Rationales: A: Counting only x = 3, where the filled point lies on the curve, gives 1. The limit also exists at x = −1 and x = 1, even though f(−1) is displaced and f(1) is undefined. B: Counting x = 5 because the filled point (5, −1) matches the right-hand limit gives 4. A two-sided limit needs both one-sided limits to agree, and 1 and −1 do not. C: Every listed x has some visible feature, but a limit exists only where both sides approach the same finite height. The vertical asymptote at x = −3 and the jump at x = 5 break this.

**N-1.3-A-v2.** The graph of f has these features. At x = 0 the curve jumps: it approaches height 3 from the left and height 1 from the right. At x = 2 the curve rises to +∞ on both sides of a vertical asymptote. At x = 4 there is an open circle at (4, 1), the curve on both sides approaches 1, and the only filled point on the line x = 4 is (4, 6). At x = 6 the curve passes smoothly through the filled point (6, 3). At how many of the values x = 0, 2, 4, 6 does lim(x→a) f(x) fail to exist as a finite number?

- **A. 2**
- B. 1
- C. 3
- D. 4
Check: The limit fails to exist as a finite number at x = 0 (one-sided limits 3 and 1 differ) and at x = 2 (the curve is unbounded). It exists at x = 4 (both sides approach 1) and x = 6. That is 2 values.
Rationales: B: Counting only the jump at x = 0 gives 1. The vertical asymptote at x = 2 also has no finite limit, because the outputs grow without bound. C: Counting x = 4 because the filled point (4, 6) differs from the nearby curve gives 3. The limit at x = 4 is 1 from both sides, regardless of the value f(4). D: This counts every listed value as a failure. The limits at x = 4 and x = 6 both exist, since the curve approaches a single finite height from both sides.

**N-1.3-A-v3.** The graph of f has these features. At x = −2 the curve approaches height 4 from both sides, and the only filled point on the line x = −2 is (−2, 1). At x = 0 the curve is smooth and passes through the filled point (0, 2). At x = 2 the curve jumps: it approaches height 5 from the left and height 3 from the right, and the filled point is (2, 5). At x = 4 the graph has a sharp corner at the filled point (4, 0), with the curve approaching 0 from both sides. For how many of the values x = −2, 0, 2, 4 does lim(x→a) f(x) exist and equal f(a)?

- A. 1
- **B. 2**
- C. 3
- D. 4
Check: The limit equals f(a) at x = 0 (limit 2, f(0) = 2) and at x = 4 (limit 0, f(4) = 0). At x = −2 the limit is 4 but f(−2) = 1, and at x = 2 the limit does not exist. That is 2 values.
Rationales: A: Counting only x = 0 misses the corner at x = 4. A sharp corner does not break the equality of the limit 0 and the value f(4) = 0. C: Counting x = −2 because its limit exists gives 3. There the limit is 4 but f(−2) = 1, so the limit does not equal the function value. D: Counting x = 2 because f(2) = 5 matches the left-hand limit gives 4. A two-sided limit needs both sides to agree, and 5 and 3 differ.

---

## Seed N-1.3-B (new) — Topic 1.3 Estimating Limit Values from Graphs
**Skill:** combine one-sided limits read from two graphs to evaluate a sum, difference or product whose two-sided limit exists even though the factors' limits do not.

Graph of f: as x approaches 2 from the left, f(x) approaches 3; as x approaches 2 from the right, f(x) approaches 1; and f(2) = 2. Graph of g: as x approaches 2 from the left, g(x) approaches 0; from the right, g(x) approaches 2; and g(2) = 5. What is lim(x→2) [f(x) + g(x)]?

- A. The limit does not exist
- B. 7
- **C. 3**
- D. 5
Check: From the left, f + g approaches 3 + 0 = 3. From the right it approaches 1 + 2 = 3. The one-sided limits of the sum agree, so the limit is 3 even though neither lim f nor lim g exists.
Rationales: A: Neither f nor g has a two-sided limit at 2, but the limit of the sum can still exist. The sum approaches 3 from both sides. B: The value 7 is f(2) + g(2) = 2 + 5. Limits depend on the nearby behavior of the functions, not on their values at 2. D: This adds the left-hand limit of f (3) to the right-hand limit of g (2), mixing sides. Both functions must be combined on the same side.

**N-1.3-B-v1.** Graph of f: as x approaches 1 from the left, f(x) approaches 4; from the right, f(x) approaches −2; and f(1) = 0. Graph of g: as x approaches 1 from the left, g(x) approaches −3; from the right, g(x) approaches 3; and g(1) = 6. What is lim(x→1) [f(x) + g(x)]?

- **A. 1**
- B. The limit does not exist
- C. 6
- D. 7
Check: From the left, f + g approaches 4 + (−3) = 1. From the right it approaches −2 + 3 = 1. The one-sided limits of the sum agree, so the limit is 1.
Rationales: B: Neither f nor g has a two-sided limit at 1, but their sum does. The left-hand and right-hand limits of f + g are both 1. C: The value 6 is f(1) + g(1) = 0 + 6. A limit is determined by the behavior near 1, not by the values at 1. D: This adds the left-hand limit of f (4) to the right-hand limit of g (3), mixing sides. Both functions must be evaluated on the same side.

**N-1.3-B-v2.** Graph of f: as x approaches −1 from the left, f(x) approaches 2; from the right, f(x) approaches 5; and f(−1) = 4. Graph of g: as x approaches −1 from the left, g(x) approaches −1; from the right, g(x) approaches 2; and g(−1) = −3. What is lim(x→−1) [f(x) − g(x)]?

- A. The limit does not exist
- **B. 3**
- C. 7
- D. 6
Check: From the left, f − g approaches 2 − (−1) = 3. From the right it approaches 5 − 2 = 3. The one-sided limits of the difference agree, so the limit is 3.
Rationales: A: Neither f nor g has a two-sided limit at −1, but the difference does. Both one-sided limits of f − g equal 3. C: The value 7 is f(−1) − g(−1) = 4 − (−3). The limit depends on nearby values, not on the values at −1. D: This subtracts the left-hand limit of g (−1) from the right-hand limit of f (5), mixing sides. Both must be taken from the same side.

**N-1.3-B-v3.** Graph of f: as x approaches 4 from the left, f(x) approaches 2; from the right, f(x) approaches −1; and f(4) = 1. Graph of g: as x approaches 4 from the left, g(x) approaches 3; from the right, g(x) approaches −6; and g(4) = 4. What is lim(x→4) [f(x) · g(x)]?

- A. The limit does not exist
- B. 4
- C. −12
- **D. 6**
Check: From the left, f · g approaches 2 · 3 = 6. From the right it approaches (−1)(−6) = 6. The one-sided limits of the product agree, so the limit is 6.
Rationales: A: Neither f nor g has a two-sided limit at 4, but their product does. Both one-sided limits of f · g are 6. B: The value 4 is f(4) · g(4) = 1 · 4. A limit is not the product of the function values at the point. C: This multiplies the left-hand limit of f (2) by the right-hand limit of g (−6), mixing sides. Each side's limits must be multiplied together.

---

## Seed N-1.4-A (new) — Topic 1.4 Estimating Limit Values from Tables
**Skill:** estimate two limits from tables of values near a point where both functions are undefined, then combine them.

Two functions f and g are both undefined at x = 2. Their values at inputs near 2 are given for x = 1.99, 1.999, 2.001, 2.01: f(x) = 11.9401, 11.994, 12.006, 12.0601; g(x) = 3.99, 3.999, 4.001, 4.01. Based on the table, what is lim(x→2) f(x)/g(x)?

- A. The limit does not exist
- **B. 3**
- C. 48
- D. 8
Check: The values of f approach 12 and the values of g approach 4 from both sides. The limit of the quotient is 12/4 = 3, even though neither function is defined at 2.
Rationales: A: Neither function is defined at x = 2, but a limit depends only on values near 2. Both f and g approach finite values and g does not approach 0, so the quotient has a limit. C: The value 48 is 12 · 4, the product of the two limits. The question asks about the quotient. D: The value 8 is 12 − 4, the difference of the two limits. The question asks about the quotient.

**N-1.4-A-v1.** Two functions f and g are both undefined at x = 1. Their values near 1 are given for x = 0.99, 0.999, 1.001, 1.01: f(x) = 2.9701, 2.997, 3.003, 3.0301; g(x) = 1.99, 1.999, 2.001, 2.01. Based on the table, what is lim(x→1) [f(x) − (g(x))²]?

- A. 1
- B. 7
- C. The limit does not exist
- **D. −1**
Check: The values of f approach 3 and the values of g approach 2. The limit of f(x) − (g(x))² is 3 − 2² = 3 − 4 = −1.
Rationales: A: The value 1 is 3 − 2, which forgets to square g. The expression subtracts (g(x))², whose limit is 4. B: The value 7 is 3 + 4, a sign error that adds (g(x))² instead of subtracting it. C: Neither function is defined at x = 1, but the table shows each approaching a finite value from both sides, so the combined expression has a limit.

**N-1.4-A-v2.** Two functions f and g are both undefined at x = −2. Their values near −2 are given for x = -2.01, -2.001, -1.999, -1.99: f(x) = 12.0601, 12.006, 11.994, 11.9401; g(x) = -4.01, -4.001, -3.999, -3.99. Based on the table, what is lim(x→−2) f(x)/g(x)?

- **A. −3**
- B. The limit does not exist
- C. −48
- D. 16
Check: The values of f approach 12 and the values of g approach −4 from both sides. The limit of the quotient is 12/(−4) = −3.
Rationales: B: Neither function is defined at x = −2, but a limit uses only nearby values. Both functions approach finite values and the limit of g is not 0. C: The value −48 is 12 · (−4), the product of the limits. The question asks about the quotient. D: The value 16 is 12 − (−4), the difference of the limits. The question asks about the quotient.

**N-1.4-A-v3.** Two functions f and g are both undefined at x = 3. Their values near 3 are given for x = 2.99, 2.999, 3.001, 3.01: f(x) = 5.99, 5.999, 6.001, 6.01; g(x) = 26.9101, 26.991, 27.009, 27.0901. Based on the table, what is lim(x→3) g(x)/f(x)?

- A. 2/9
- B. 162
- **C. 9/2**
- D. 21
Check: The values of f approach 6 and the values of g approach 27. The limit of g(x)/f(x) is 27/6 = 9/2.
Rationales: A: The value 2/9 is 6/27, which inverts the quotient. The question asks for g divided by f. B: The value 162 is 27 · 6, the product of the limits. The question asks about the quotient. D: The value 21 is 27 − 6, the difference of the limits. The question asks about the quotient.

---

## Seed N-1.4-B (new) — Topic 1.4 Estimating Limit Values from Tables
**Skill:** judge what a table of sampled values can and cannot establish about a limit.

For a function g, the table shows g(x) = 0 at each of the inputs x = −0.1, −0.01, −0.001, 0.001, 0.01, and 0.1. The function is undefined at x = 0. Which statement about lim(x→0) g(x) is best supported by the table alone?

- A. The limit is 0, because g(x) = 0 on both sides of x = 0 and the values never change.
- B. The limit does not exist, because g is undefined at x = 0.
- **C. The table is consistent with a limit of 0, but it lists only a few inputs, so it cannot establish the limit.**
- D. The limit is 0.001, because that is the input closest to 0.
Check: A table samples finitely many inputs, so values that agree at those inputs do not rule out different behavior between them. The table suggests 0 but does not prove it.
Rationales: A: The tabulated values are 0, but a table gives only sampled inputs. A function can equal 0 at the sampled inputs and still take other values between them, so the table alone does not prove the limit. B: Whether g is defined at 0 has no effect on the limit. A limit can exist at a point where the function is undefined. D: The limit is a value the outputs approach, not the closest input listed. The listed outputs are all 0, so 0.001 does not come from the table.

**N-1.4-B-v1.** A sensor's reading is R(t) = cos(π/t) volts at time t seconds. The table shows R(t) = 1 at each of the inputs t = 0.5, 0.25, 0.125, and 0.1 (since 2π, 4π, 8π, and 10π are multiples of 2π). Which statement about lim(t→0⁺) R(t) is best supported by the table alone?

- A. The limit is 1, because the readings equal 1 at every input in the table.
- B. The limit is 0, because the inputs in the table approach 0.
- C. The limit cannot be discussed, because R(0) is undefined.
- **D. The table is consistent with a limit of 1, but it lists only a few inputs, so it cannot establish the limit.**
Check: The tabulated values are all 1, but the table samples only specific inputs. Other inputs close to 0 could give different readings, so the table suggests 1 without proving it.
Rationales: A: Equal readings at sampled inputs do not guarantee the outputs stay near 1 at the inputs not listed. The table alone cannot prove the limit. B: The limit describes the outputs, not the inputs. The outputs in the table are all 1, so nothing in the table points to 0. C: A limit does not need the function to be defined at the point. The table can still suggest a value for the limit, even though it cannot prove it.

**N-1.4-B-v2.** For a function p, the table shows p(x) = 0 at each of the inputs x = −0.5, −0.25, −0.1, −0.05, 0.05, 0.1, 0.25, and 0.5. The function is undefined at x = 0. Which statement about lim(x→0) p(x) is best supported by the table alone?

- A. The limit is 0, because p(x) = 0 at inputs on both sides of 0.
- **B. The table is consistent with a limit of 0, but it lists only a few inputs, so it cannot establish the limit.**
- C. The limit does not exist, because p(0) is undefined and the table has no value there.
- D. The limit is 0.05, because that is the smallest input in absolute value.
Check: Only eight sampled inputs are listed. Different behavior at the unlisted inputs near 0 would be invisible in the table, so the table suggests 0 but cannot prove it.
Rationales: A: Having values on both sides is necessary for a limit estimate but not sufficient. Unlisted inputs might give other values, so the table does not prove the limit. C: A limit does not depend on the value, or lack of one, at the point itself. Only the behavior of p near 0 matters. D: The limit is about outputs, not inputs. The outputs in the table are all 0, so 0.05 has no support from the data.

**N-1.4-B-v3.** A signal is w(x) = 5 + 3 sin(π/x). The table shows w(x) = 5 at each of the inputs x = 0.5, 0.2, 0.1, and 0.05 (since π/x equals 2π, 5π, 10π, and 20π, and sin of each is 0). Which statement about lim(x→0⁺) w(x) is best supported by the table alone?

- **A. The table is consistent with a limit of 5, but it lists only a few inputs, so it cannot establish the limit.**
- B. The limit is 5, because every tabulated output equals 5.
- C. The limit is 0, because the inputs approach 0.
- D. The limit is 8, because w can be as large as 5 + 3.
Check: All four tabulated outputs equal 5, but the table samples only a few inputs. Other inputs near 0 could give different outputs, so the table suggests 5 without proving it.
Rationales: B: Identical outputs at four sampled inputs do not show the outputs stay near 5 at the unlisted inputs. The table is evidence, not proof. C: The limit is the value the outputs approach. The tabulated outputs are 5, not 0, so nothing supports 0. D: The maximum possible output is not the limit. The table shows only outputs equal to 5, and the table does not support any other limit.

---

## Seed N-1.5-A (new) — Topic 1.5 Determining Limits Using Algebraic Properties of Limits
**Skill:** recover individual limits from limits of linear combinations using limit properties, then evaluate a new expression.

Suppose lim(x→3) [2f(x) − g(x)] = 7 and lim(x→3) [f(x) + g(x)] = 2. What is lim(x→3) f(x)·g(x)?

- A. 14
- B. −15
- C. 6
- **D. −3**
Check: Adding the two limits gives lim 3f(x) = 9, so lim f(x) = 3, and then lim g(x) = 2 − 3 = −1. The limit of the product is 3 · (−1) = −3.
Rationales: A: The value 14 multiplies the two given limits, 7 · 2. The product of the limits of the combinations is not the limit of f(x)g(x). B: This comes from reading the first limit as the limit of 2f(x) + g(x), which would give f = 5 and g = −3. The first combination subtracts g(x). C: The value 6 is 3 · 2, the limit of f(x) times the limit of the second combination. The product must use lim f and lim g.

**N-1.5-A-v1.** Suppose lim(x→−1) [f(x) + g(x)] = 5 and lim(x→−1) [f(x) − g(x)] = 1. What is lim(x→−1) [(f(x))² − g(x)]?

- A. 5
- **B. 7**
- C. 11
- D. 9
Check: Adding the limits gives lim 2f(x) = 6, so lim f(x) = 3, and then lim g(x) = 5 − 3 = 2. The limit of (f(x))² − g(x) is 3² − 2 = 7.
Rationales: A: The value 5 multiplies the two given limits, 5 · 1, which is the limit of (f(x))² − (g(x))², not the requested expression. C: The value 11 is 3² + 2, a sign error that adds g(x) instead of subtracting it. D: The value 9 is 3², the limit of (f(x))² alone. The limit of g(x), which is 2, still has to be subtracted.

**N-1.5-A-v2.** Suppose lim(x→5) [2f(x) + 3g(x)] = 1 and lim(x→5) [f(x) − g(x)] = 3. What is lim(x→5) f(x)/g(x)?

- A. 1/3
- B. 2
- **C. −2**
- D. −1/2
Check: Writing f = g + 3 in the limits gives 2(L + 3) + 3L = 1, so L = −1, where L = lim g(x), and lim f(x) = 2. The limit of the quotient is 2/(−1) = −2.
Rationales: A: The value 1/3 divides the first given limit by the second. The question asks about the quotient f(x)/g(x), which needs lim f and lim g. B: The value 2 is lim f(x), or the quotient with the wrong sign for lim g(x). The limit of g(x) is −1, so the quotient is negative. D: The value −1/2 inverts the quotient, giving lim g divided by lim f. The question asks for f(x) divided by g(x).

**N-1.5-A-v3.** Suppose lim(x→0) [f(x) + g(x)] = −2 and lim(x→0) [2f(x) − g(x)] = 11. What is lim(x→0) [(g(x))² − f(x)]?

- **A. 22**
- B. 28
- C. −22
- D. 64
Check: Adding the limits gives lim 3f(x) = 9, so lim f(x) = 3, and then lim g(x) = −2 − 3 = −5. The limit of (g(x))² − f(x) is 25 − 3 = 22.
Rationales: B: The value 28 is 25 + 3, a sign error that adds f(x) instead of subtracting it. C: The value −22 is 3 − 25, the limit of f(x) − (g(x))² with the order reversed. The question subtracts f(x) from (g(x))². D: The value 64 is (−5 − 3)², the square of g − f. The expression squares only g(x) and then subtracts f(x).

---

## Seed N-1.5-B (new) — Topic 1.5 Determining Limits Using Algebraic Properties of Limits
**Skill:** decide what the limit laws force about one function when a combination and the other function have limits.

Suppose lim(x→a) [f(x) + g(x)] exists as a finite number. Which statement must be true?

- **A. If lim(x→a) f(x) exists, then lim(x→a) g(x) exists.**
- B. Both lim(x→a) f(x) and lim(x→a) g(x) exist.
- C. f(a) + g(a) equals the limit of the sum.
- D. lim(x→a) f(x) = lim(x→a) g(x).
Check: Since g(x) = [f(x) + g(x)] − f(x), the difference rule gives lim g(x) = lim[f + g] − lim f whenever lim f exists. So the existence of lim f forces the existence of lim g.
Rationales: B: The sum can have a limit even if its parts do not. For f(x) = 1/(x − a) and g(x) = −1/(x − a), the sum is 0 but neither part has a finite limit. C: This holds only when the sum is continuous at a. The limit of a sum can differ from the value at a, or the value might not exist. D: Nothing forces the two limits to be equal. For f(x) = 1 and g(x) = 2, the sum has a limit of 3 while the parts have limits 1 and 2.

**N-1.5-B-v1.** Suppose lim(x→2) [f(x)·g(x)] = 0 and lim(x→2) f(x) = 5. Which statement must be true?

- A. g(2) = 0
- B. lim(x→2) g(x) = 5
- **C. lim(x→2) g(x) = 0**
- D. g(x) = 0 for every x near 2
Check: Near 2, f is not zero, so g(x) = [f(x)g(x)]/f(x). Using the quotient rule, lim g(x) = 0/5 = 0.
Rationales: A: The limit of g is 0, but the value of g at 2 can be anything, or g may be undefined there. Limits do not control the value at the point. B: The value 5 is lim f(x). The product's limit is 0, which gives lim g = 0 rather than 5. D: The limit is 0 even if g(x) is never exactly 0 near 2. For example, g(x) = x − 2 has limit 0 and is nonzero for every x ≠ 2.

**N-1.5-B-v2.** Suppose lim(x→1) [f(x)/g(x)] = 3 and lim(x→1) g(x) = 0. Which statement must be true?

- A. lim(x→1) f(x) = 3
- B. lim(x→1) f(x) does not exist, because the denominator approaches 0.
- C. f(1) = 3·g(1)
- **D. lim(x→1) f(x) = 0**
Check: Near 1, f(x) = [f(x)/g(x)]·g(x), so by the product rule lim f(x) = 3 · 0 = 0.
Rationales: A: The value 3 is the limit of the quotient, not of f. The product of 3 and lim g = 0 shows lim f = 0. B: A quotient with a denominator approaching 0 can still have a finite limit when the numerator also approaches 0. Here the product rule forces lim f = 0. C: The relation holds for the limits as x approaches 1, not necessarily at x = 1, where f or g may not even be defined.

**N-1.5-B-v3.** Suppose lim(x→−4) [f(x)/g(x)] = 5 and lim(x→−4) g(x) = 2. Which statement must be true?

- A. lim(x→−4) f(x) = 5/2
- **B. lim(x→−4) f(x) = 10**
- C. lim(x→−4) f(x) = 7
- D. f(−4) = 10
Check: Near −4, f(x) = [f(x)/g(x)]·g(x), so by the product rule lim f(x) = 5 · 2 = 10.
Rationales: A: The value 5/2 divides the limit of the quotient by lim g. Since f = (f/g)·g, the limits are multiplied, not divided. C: The value 7 adds the two limits. The relationship between f, g and the quotient is multiplicative. D: The limits give lim f = 10 but say nothing about the function value f(−4), which may be anything or undefined.

---

## Seed N-1.6-A (new) — Topic 1.6 Determining Limits Using Algebraic Manipulation
**Skill:** choose the constant that makes a 0/0 form removable, factor, and evaluate the resulting limit.

Let a be the constant for which lim(x→2) (x² + ax + 2)/(x − 2) exists. What is the value of this limit?

- A. 0
- **B. 1**
- C. −3
- D. −1
Check: The denominator approaches 0, so the numerator must approach 0: 4 + 2a + 2 = 0 gives a = −3. Then x² − 3x + 2 = (x − 1)(x − 2), and the limit of (x − 1) as x→2 is 1.
Rationales: A: The numerator does approach 0, but so does the denominator. Canceling x − 2 leaves x − 1, whose limit is 1, not 0. C: The number −3 is the value of a that makes the limit exist, not the value of the limit. D: This comes from factoring the numerator as (x + 1)(x − 2), which expands to x² − x − 2, not x² − 3x + 2. The correct factor left over is x − 1.

**N-1.6-A-v1.** Let a be the constant for which lim(x→3) (x² + ax − 3)/(x − 3) exists. What is the value of this limit?

- A. 0
- B. −2
- C. 3
- **D. 4**
Check: The numerator must approach 0 as the denominator does: 9 + 3a − 3 = 0 gives a = −2. Then x² − 2x − 3 = (x − 3)(x + 1), and the limit of (x + 1) as x→3 is 4.
Rationales: A: Both numerator and denominator approach 0, so the limit is found after canceling x − 3. The remaining factor x + 1 approaches 4. B: The number −2 is the value of a that makes the limit exist, not the value of the limit. C: The number 3 is the value x approaches, not the value of the limit. The limit is the value of the simplified factor x + 1 at x = 3.

**N-1.6-A-v2.** Let a be the constant for which lim(x→−1) (x² + ax + 6)/(x + 1) exists. What is the value of this limit?

- **A. 5**
- B. 0
- C. 7
- D. −1
Check: The numerator must approach 0 as x→−1: 1 − a + 6 = 0 gives a = 7. Then x² + 7x + 6 = (x + 1)(x + 6), and the limit of (x + 6) as x→−1 is 5.
Rationales: B: Both numerator and denominator approach 0. After canceling x + 1, the remaining factor x + 6 approaches 5, not 0. C: The number 7 is the value of a that makes the limit exist, not the value of the limit. D: The number −1 is the value x approaches, not the limit. The limit is the value of the factor x + 6 at x = −1.

**N-1.6-A-v3.** Let a be the constant for which lim(x→4) (x² + ax − 8)/(x − 4) exists. What is the value of this limit?

- A. 0
- B. −2
- **C. 6**
- D. 4
Check: The numerator must approach 0 as the denominator does: 16 + 4a − 8 = 0 gives a = −2. Then x² − 2x − 8 = (x − 4)(x + 2), and the limit of (x + 2) as x→4 is 6.
Rationales: A: Both numerator and denominator approach 0, so the limit comes from the canceled form. The remaining factor x + 2 approaches 6. B: The number −2 is the value of a that makes the limit exist, not the value of the limit. D: The number 4 is the value x approaches. The limit is the value of the simplified factor x + 2 at x = 4.

---

## Seed N-1.6-B (new) — Topic 1.6 Determining Limits Using Algebraic Manipulation
**Skill:** evaluate a 0/0 limit by combining a complex fraction or rationalizing a radical.

What is lim(x→0) [1/(4 + x) − 1/4]/x?

- **A. −1/16**
- B. 0
- C. 1/16
- D. The limit does not exist
Check: Combining over a common denominator gives [4 − (4 + x)]/[4(4 + x)] = −x/[4(4 + x)]. Dividing by x gives −1/[4(4 + x)], whose limit as x→0 is −1/16.
Rationales: B: The numerator 1/(4 + x) − 1/4 does approach 0, but so does the denominator x. The limit is found after simplifying, not by treating the numerator alone. C: The limit has the right size but the wrong sign. Combining gives 4 − (4 + x) = −x in the numerator, so the result is negative. D: The form 0/0 does not mean the limit fails to exist; it signals that algebra is needed. After simplifying, the limit is −1/16.

**N-1.6-B-v1.** What is lim(x→0) [√(x + 16) − 4]/x?

- A. 0
- **B. 1/8**
- C. 1/4
- D. The limit does not exist
Check: Multiply numerator and denominator by √(x + 16) + 4. The numerator becomes x, which cancels, leaving 1/[√(x + 16) + 4], whose limit as x→0 is 1/8.
Rationales: A: The numerator approaches 0, but so does the denominator. The limit comes from rationalizing, and the result is 1/8. C: This uses 4 in the denominator after rationalizing instead of √16 + 4 = 8. The conjugate sum is 8. D: The 0/0 form calls for more algebra rather than meaning the limit does not exist. Rationalizing gives 1/8.

**N-1.6-B-v2.** What is lim(x→2) [1/x − 1/2]/(x − 2)?

- A. 1/4
- B. 0
- **C. −1/4**
- D. The limit does not exist
Check: Combining the numerator gives (2 − x)/(2x) = −(x − 2)/(2x). Dividing by x − 2 leaves −1/(2x), whose limit as x→2 is −1/4.
Rationales: A: This has the right magnitude but the wrong sign. The numerator combines to 2 − x, which is the opposite of x − 2. B: The numerator approaches 0, but so does the denominator, so the limit is determined after simplification, which gives −1/4. D: A 0/0 form does not imply that the limit fails to exist. After canceling x − 2, the remaining expression −1/(2x) has a limit.

**N-1.6-B-v3.** What is lim(x→3) [√(x + 1) − 2]/(x − 3)?

- A. 0
- B. 1/2
- C. The limit does not exist
- **D. 1/4**
Check: Multiply by [√(x + 1) + 2]/[√(x + 1) + 2]. The numerator becomes (x + 1) − 4 = x − 3, which cancels, leaving 1/[√(x + 1) + 2], whose limit as x→3 is 1/4.
Rationales: A: The numerator approaches 0, but so does the denominator, so the limit is found after rationalizing and equals 1/4. B: This uses 2 in the denominator, as if the conjugate sum were √(x + 1) alone. The conjugate sum at x = 3 is 2 + 2 = 4. C: The form 0/0 is a signal to simplify, not evidence that the limit fails to exist. The result is 1/4.

---

## Seed N-1.7-A (new) — Topic 1.7 Selecting Procedures for Determining Limits
**Skill:** select the procedure of combining fractions over a common denominator for a difference of unbounded terms.

What is lim(x→0) [1/x − 1/(x² + x)]?

- A. 0
- B. The limit does not exist
- **C. 1**
- D. −1
Check: Writing the difference over a common denominator gives [(x + 1) − 1]/[x(x + 1)] = 1/(x + 1), whose limit as x→0 is 1.
Rationales: A: Each term grows without bound, but ∞ − ∞ is not automatically 0. Combining the fractions gives 1/(x + 1), with limit 1. B: Neither term has a finite limit, but the difference can still have one. Combining the terms removes the unbounded behavior. D: This subtracts the numerators in the wrong order, getting 1 − (x + 1) = −x. The first fraction has numerator x + 1 over the common denominator.

**N-1.7-A-v1.** What is lim(x→0) [1/x − 3/(x² + 3x)]?

- **A. 1/3**
- B. 0
- C. The limit does not exist
- D. −1/3
Check: Over the common denominator x(x + 3) the difference is [(x + 3) − 3]/[x(x + 3)] = 1/(x + 3), whose limit as x→0 is 1/3.
Rationales: B: Each term is unbounded, but ∞ − ∞ is not automatically 0. Combining gives 1/(x + 3), with limit 1/3. C: The individual terms have no finite limit, but their difference does. Combining over a common denominator removes the unbounded part. D: This reverses the order of subtraction in the numerator, giving 3 − (x + 3) = −x. The first fraction's numerator is x + 3.

**N-1.7-A-v2.** What is lim(x→2) [1/(x − 2) − 4/(x² − 4)]?

- A. 0
- B. The limit does not exist
- C. −1/4
- **D. 1/4**
Check: Over the common denominator (x − 2)(x + 2) the difference is [(x + 2) − 4]/[(x − 2)(x + 2)] = (x − 2)/[(x − 2)(x + 2)] = 1/(x + 2), whose limit as x→2 is 1/4.
Rationales: A: Each term is unbounded near 2, but ∞ − ∞ is not automatically 0. Combining gives 1/(x + 2), with limit 1/4. B: Neither term has a finite limit, but the difference can. Combining over a common denominator and canceling x − 2 gives a finite limit. C: This reverses the subtraction in the numerator, giving 4 − (x + 2) = 2 − x. The first fraction contributes x + 2.

**N-1.7-A-v3.** What is lim(x→3) [1/(x − 3) − 6/(x² − 9)]?

- A. 0
- **B. 1/6**
- C. The limit does not exist
- D. −1/6
Check: Over the common denominator (x − 3)(x + 3) the difference is [(x + 3) − 6]/[(x − 3)(x + 3)] = 1/(x + 3), whose limit as x→3 is 1/6.
Rationales: A: Each term is unbounded near 3, but ∞ − ∞ is not automatically 0. Combining gives 1/(x + 3), with limit 1/6. C: The terms have no finite limits individually, but the difference does. Combining and canceling x − 3 reveals the limit. D: This reverses the order of subtraction in the numerator, giving 6 − (x + 3) = 3 − x. The first fraction contributes x + 3.

---

## Seed N-1.7-B (new) — Topic 1.7 Selecting Procedures for Determining Limits
**Skill:** split a limit into a special trigonometric limit and a rational factor and combine the pieces.

What is lim(x→0) [sin(2x)·(x + 3)]/[x(x + 1)]?

- A. 3
- B. 2
- C. 0
- **D. 6**
Check: Rewrite as [sin(2x)/x]·[(x + 3)/(x + 1)]. The first factor approaches 2 and the second approaches 3, so the limit is 2 · 3 = 6.
Rationales: A: This treats sin(2x)/x as approaching 1, as if the argument were x. The special limit gives sin(2x)/x → 2. B: This finds the limit of sin(2x)/x but ignores the factor (x + 3)/(x + 1), which approaches 3. C: Substituting x = 0 makes the numerator 0, but the denominator is also 0. The limit must be found with the special trigonometric limit.

**N-1.7-B-v1.** What is lim(x→0) [sin(5x)·(x + 4)]/[x(x + 2)]?

- **A. 10**
- B. 2
- C. 5
- D. 0
Check: Rewrite as [sin(5x)/x]·[(x + 4)/(x + 2)]. The first factor approaches 5 and the second approaches 2, so the limit is 5 · 2 = 10.
Rationales: B: This treats sin(5x)/x as approaching 1. The special limit gives sin(5x)/x → 5. C: This finds the limit of sin(5x)/x but ignores the factor (x + 4)/(x + 2), which approaches 2. D: Substituting x = 0 makes the numerator 0, but the denominator is 0 too. The limit needs the special trigonometric limit.

**N-1.7-B-v2.** What is lim(x→0) [tan(3x)·(x + 5)]/[x(x + 1)]?

- A. 5
- B. 3
- **C. 15**
- D. 0
Check: Rewrite as [tan(3x)/x]·[(x + 5)/(x + 1)]. The first factor approaches 3 and the second approaches 5, so the limit is 3 · 5 = 15.
Rationales: A: This treats tan(3x)/x as approaching 1. The limit of tan(3x)/x is 3. B: This finds the limit of tan(3x)/x but ignores the factor (x + 5)/(x + 1), which approaches 5. D: Substituting x = 0 makes the numerator 0, but the denominator is 0 too. The limit must be found using the limit of tan(3x)/x.

**N-1.7-B-v3.** What is lim(x→0) [sin(6x)·(x + 4)]/[3x(x + 2)]?

- A. 2
- **B. 4**
- C. 12
- D. 0
Check: Rewrite as [sin(6x)/(3x)]·[(x + 4)/(x + 2)]. The first factor approaches 6/3 = 2 and the second approaches 2, so the limit is 2 · 2 = 4.
Rationales: A: This finds the limit of sin(6x)/(3x) but ignores the factor (x + 4)/(x + 2), which approaches 2. C: This takes sin(6x)/x → 6 and ignores the 3 in the denominator, then multiplies by 2. The factor 3x divides the limit 6 down to 2. D: Substituting x = 0 makes the numerator 0, but the denominator is 0 too. The limit must be found from the special limit sin(6x)/x → 6.

---

## Seed N-1.8-A (new) — Topic 1.8 Determining Limits Using the Squeeze Theorem
**Skill:** apply the Squeeze Theorem to a bounded oscillating factor inside a product and then add a constant.

What is lim(x→0) [5 + x²(3 + sin(1/x))]?

- **A. 5**
- B. The limit does not exist
- C. 8
- D. 0
Check: Since −1 ≤ sin(1/x) ≤ 1, we have 2x² ≤ x²(3 + sin(1/x)) ≤ 4x². Both bounds approach 0, so by the Squeeze Theorem the product approaches 0, and the limit of the whole expression is 5 + 0 = 5.
Rationales: B: The factor sin(1/x) oscillates, but it is bounded and multiplied by x², which approaches 0. The Squeeze Theorem shows the product has limit 0. C: The value 8 is 5 + 3, as if sin(1/x) were 0 and x² were 1. The factor x² approaches 0, so the product term approaches 0. D: The product x²(3 + sin(1/x)) approaches 0, but the constant 5 is added to it. The limit of the whole expression is 5.

**N-1.8-A-v1.** What is lim(x→0) [x⁴(5 + cos(1/x²)) − 2]?

- A. The limit does not exist
- **B. −2**
- C. 3
- D. 0
Check: Since −1 ≤ cos(1/x²) ≤ 1, we have 4x⁴ ≤ x⁴(5 + cos(1/x²)) ≤ 6x⁴. Both bounds approach 0, so the product approaches 0, and the limit of the whole expression is 0 − 2 = −2.
Rationales: A: The factor cos(1/x²) oscillates, but it is bounded and multiplied by x⁴, which approaches 0. The Squeeze Theorem gives a product limit of 0. C: The value 3 is 5 − 2, as if the cosine factor contributed 0 and x⁴ contributed 1. Since x⁴ approaches 0, the whole product term approaches 0. D: The product term approaches 0, but the constant −2 is still subtracted. The limit of the whole expression is −2.

**N-1.8-A-v2.** What is lim(x→2) [7 + (x − 2)²(4 + sin(1/(x − 2)))]?

- A. The limit does not exist
- B. 11
- C. 0
- **D. 7**
Check: Since −1 ≤ sin(1/(x − 2)) ≤ 1, we have 3(x − 2)² ≤ (x − 2)²(4 + sin(1/(x − 2))) ≤ 5(x − 2)². Both bounds approach 0, so the product approaches 0 and the limit is 7 + 0 = 7.
Rationales: A: The sine factor oscillates wildly near 2, but it is bounded and multiplied by (x − 2)², which approaches 0. The Squeeze Theorem gives a limit of 0 for the product. B: The value 11 is 7 + 4, as if the factor (x − 2)² were 1 and the sine were 0. That squared factor approaches 0. C: The product term approaches 0, but the constant 7 is added. The limit of the full expression is 7.

**N-1.8-A-v3.** What is lim(x→0) [1 + |x|(2 + cos(3/x))]?

- A. The limit does not exist
- B. 3
- **C. 1**
- D. 0
Check: Since −1 ≤ cos(3/x) ≤ 1, we have |x| ≤ |x|(2 + cos(3/x)) ≤ 3|x|. Both bounds approach 0, so the product approaches 0, and the limit of the whole expression is 1 + 0 = 1.
Rationales: A: The cosine factor oscillates, but it is bounded and multiplied by |x|, which approaches 0. The Squeeze Theorem gives a product limit of 0. B: The value 3 is 1 + 2, as if |x| were 1 and the cosine factor were 0. Because |x| approaches 0, the product term approaches 0. D: The product term approaches 0, but the constant 1 is added. The limit of the whole expression is 1.

---

## Seed N-1.8-B (new) — Topic 1.8 Determining Limits Using the Squeeze Theorem
**Skill:** identify where two quadratic bounds meet so the Squeeze Theorem applies, and recognize it applies nowhere else.

A function f satisfies 4x − x² ≤ f(x) ≤ x² + 2 for all x. For which values of a can the Squeeze Theorem be used to find lim(x→a) f(x) from these bounds, and what is the limit?

- A. For every a, because f lies between two continuous functions.
- B. Only for a = 0, where the bounds equal 0 and 2.
- C. For no value of a, because the two bounds are different functions.
- **D. Only for a = 1, where both bounds equal 3, so the limit is 3.**
Check: The bounds differ by (x² + 2) − (4x − x²) = 2(x − 1)², which is zero only at x = 1. There both bounds equal 3, so the limit is 3. At every other a the bounds have different limits and the theorem gives no value.
Rationales: A: Being squeezed between two continuous functions fixes the limit only where the two bounds approach the same value. Away from x = 1 the bounds have different limits, which leaves a range of possible values. B: The Squeeze Theorem needs the two bounds to have the same limit. At x = 0 the bounds are 0 and 2, which differ, so the theorem does not apply. C: Different bounds are fine; they only need to share a limit at the point of interest. They share the limit 3 at x = 1, so the theorem applies there.

**N-1.8-B-v1.** A function f satisfies 6x − 9 ≤ f(x) ≤ x² for all x. For which values of a can the Squeeze Theorem be used to find lim(x→a) f(x) from these bounds, and what is the limit?

- A. For every a, because f lies between two continuous functions.
- **B. Only for a = 3, where both bounds equal 9, so the limit is 9.**
- C. Only for a = 0, where the bounds equal −9 and 0.
- D. For no value of a, because the two bounds are different functions.
Check: The bounds differ by x² − (6x − 9) = (x − 3)², which is zero only at x = 3. There both bounds equal 9, so the limit is 9. At other values of a the bounds have different limits.
Rationales: A: The theorem determines a limit only when the two bounds approach the same value. Away from x = 3 the bounds differ, so f is not forced to one limit. C: The bounds must have equal limits for the Squeeze Theorem. At x = 0 they are −9 and 0, which differ. D: The bounds are allowed to be different functions as long as they approach the same value at the point. At x = 3 both approach 9.

**N-1.8-B-v2.** A function f satisfies 4x + 1 ≤ f(x) ≤ x² + 5 for all x. For which values of a can the Squeeze Theorem be used to find lim(x→a) f(x) from these bounds, and what is the limit?

- **A. Only for a = 2, where both bounds equal 9, so the limit is 9.**
- B. For every a, because f lies between two continuous functions.
- C. Only for a = 0, where the bounds equal 1 and 5.
- D. For no value of a, because the two bounds are different functions.
Check: The bounds differ by (x² + 5) − (4x + 1) = (x − 2)², which is zero only at x = 2. There both bounds equal 9, so the limit is 9. Elsewhere the bounds have different limits.
Rationales: B: The limit is forced only where both bounds approach the same value. Away from x = 2 the two bounds disagree. C: The bounds must have the same limit. At x = 0 they are 1 and 5, which differ, so no conclusion is possible. D: Bounds can be different functions. At x = 2 they approach the same value, 9, and the theorem applies.

**N-1.8-B-v3.** A function f satisfies x² − 6x ≤ f(x) ≤ 3x² − 2x + 2 for all x. For which values of a can the Squeeze Theorem be used to find lim(x→a) f(x) from these bounds, and what is the limit?

- A. For every a, because f lies between two continuous functions.
- B. Only for a = 0, where the bounds equal 0 and 2.
- **C. Only for a = −1, where both bounds equal 7, so the limit is 7.**
- D. For no value of a, because the two bounds are different functions.
Check: The bounds differ by (3x² − 2x + 2) − (x² − 6x) = 2(x + 1)², which is zero only at x = −1. There both bounds equal 7, so the limit is 7. At other values of a the bounds differ.
Rationales: A: A limit is forced only where both bounds approach the same value. Away from x = −1 the bounds disagree. B: The Squeeze Theorem needs equal limits for the two bounds. At x = 0 they are 0 and 2, which differ. D: Bounds may be different functions provided they approach the same value at the point. At x = −1 both approach 7.
