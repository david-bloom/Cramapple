# AP Precalculus Unit 1, topics 1.1 to 1.7: harder new seed drafts

DRAFT for owner review. Author-in-session; not checked by a checker; not in the database. Every key and distractor value was recomputed in Python (exact fractions) while writing.
Scope: topics 1.1 to 1.7 only (1.8 to 1.14 are covered by another author). Two new seeds per topic, each with three variants, written at R3 level (multi-step reasoning, interpretation, error analysis). Seed A and Seed B of a topic test different skills; none reuses the stems or skills of the existing published items.

| Seed | Topic | Replaces |
|---|---|---|
| N-1.1-A | 1.1 Change in Tandem | new: decide how subtracting a function from a constant changes both its direction and its concavity, using successive changes in a table rather than the direction alone |
| N-1.1-B | 1.1 Change in Tandem | new: combine the direction and concavity of two functions to decide which features of their sum are forced and which are not |
| N-1.2-A | 1.2 Rates of Change | new: combine the average rates over two adjacent unequal intervals into the average rate over the union, weighting by interval length |
| N-1.2-B | 1.2 Rates of Change | new: work backward from a given average rate of change of a quadratic to a missing coefficient, tracking the cancellation of the constant and the division by interval width |
| N-1.3-A | 1.3 Rates of Change and Behavior of Graphs | new: infer concavity from average rates over intervals of unequal width, not from raw changes in output |
| N-1.3-B | 1.3 Rates of Change and Behavior of Graphs | new: locate local extrema from the sign changes in a list of average rates over consecutive unit intervals, without over-claiming an exact location |
| N-1.4-A | 1.4 Polynomial Functions and Rates of Change | new: extend a table of a cubic by propagating the constant third difference back through second and first differences, rejecting lower-degree extrapolations |
| N-1.4-B | 1.4 Polynomial Functions and Rates of Change | new: combine the turning-point bound (degree at least turning points plus one) with the parity forced by end behavior to find the least possible degree |
| N-1.5-A | 1.5 Polynomial Functions and Complex Zeros | new: count real zeros of a real-coefficient polynomial by adding the conjugate of every nonreal zero with its multiplicity before subtracting from the degree |
| N-1.5-B | 1.5 Polynomial Functions and Complex Zeros | new: use the factor theorem to find an unknown coefficient, then use the sum of the zeros of a monic cubic to get the sum of the remaining two without finding them |
| N-1.6-A | 1.6 Polynomial Functions and End Behavior | new: find the end behavior of a product with a reflected factor by tracking both the degree parity and the sign contributed by the reflection |
| N-1.6-B | 1.6 Polynomial Functions and End Behavior | new: build a sign chart from end behavior and zero multiplicities, changing sign only at odd-multiplicity zeros |
| N-1.7-A | 1.7 Rational Functions and End Behavior | new: find the horizontal asymptote of an unexpanded rational function with equal degrees by multiplying the leading coefficients of every factor, including the square |
| N-1.7-B | 1.7 Rational Functions and End Behavior | new: describe the side of the horizontal asymptote y = 0 that a rational function approaches at each end by tracking the sign of the ratio of leading terms through the parity of the degree gap |

---

## Seed N-1.1-A (new) — Topic 1.1 Change in Tandem
**Skill:** decide how subtracting a function from a constant changes both its direction and its concavity, using successive changes in a table rather than the direction alone.

A store records f(t), its cumulative sales in thousands of dollars, at the end of weeks t = 0, 1, 2, 3, 4 of a promotion: 4, 9, 13, 16, 18. Let g(t) = 30 − f(t) be the sales still needed to reach a 30-thousand-dollar goal. Assume f changes smoothly between the table entries. Which statement describes g on 0 ≤ t ≤ 4?

- A. g is increasing and concave up
- **B. g is decreasing and concave up**
- C. g is increasing and concave down
- D. g is decreasing and concave down

Check: The changes in f are 5, 4, 3, 2, so f is increasing and concave down. For g = 30 − f the values are 26, 21, 17, 14, 12, with changes −5, −4, −3, −2, so g is decreasing and concave up.
Rationales: A: This has the concavity of g but the direction of f. Since g(t) = 30 − f(t), the outputs of g fall as f rises, so g is decreasing, not increasing. C: This is the behavior of f itself, not of g. Subtracting f from a constant negates every change, so the changes in g (−5, −4, −3, −2) reverse both the direction and the concavity of f. D: This reverses the direction as it should but carries over the concavity of f. The successive changes in g are −5, −4, −3, −2, which are the negatives of the changes in f, so g is concave up, not concave down.

**N-1.1-A-v1.** A cup of liquid cools, and f(t) is its temperature in °C at minutes t = 0, 1, 2, 3, 4: 40, 28, 20, 15, 12. Let g(t) = 60 − f(t) be the number of degrees by which f lies below a 60 °C reference line. Assume f changes smoothly between readings. Which statement describes g on 0 ≤ t ≤ 4?

- A. g is increasing and concave up
- B. g is decreasing and concave up
- C. g is decreasing and concave down
- **D. g is increasing and concave down**

Check: The changes in f are −12, −8, −5, −3, so f is decreasing and concave up. For g = 60 − f the values are 20, 32, 40, 45, 48, with changes 12, 8, 5, 3, so g is increasing and concave down.
Rationales: A: This reverses the direction as it should but carries over the concavity of f. The successive changes in g are 12, 8, 5, 3, which are the negatives of the changes in f, so g is concave down, not concave up. B: This is the behavior of f itself, not of g. Subtracting f from a constant negates every change, so the changes in g (12, 8, 5, 3) reverse both the direction and the concavity of f. C: This has the concavity of g but the direction of f. Since g(t) = 60 − f(t), the outputs of g rise as f falls, so g is increasing, not decreasing.

**N-1.1-A-v2.** The table gives f(t), the number of followers of a new account, in hundreds, at weeks t = 0, 1, 2, 3, 4: 2, 3, 5, 9, 17. A forecasting sheet tracks g(t) = 25 − f(t), the gap to a 25-hundred target. Assume f changes smoothly between table entries. Which statement describes g on 0 ≤ t ≤ 4?

- **A. g is decreasing and concave down**
- B. g is increasing and concave up
- C. g is increasing and concave down
- D. g is decreasing and concave up

Check: The changes in f are 1, 2, 4, 8, so f is increasing and concave up. For g = 25 − f the values are 23, 22, 20, 16, 8, with changes −1, −2, −4, −8, so g is decreasing and concave down.
Rationales: B: This is the behavior of f itself, not of g. Subtracting f from a constant negates every change, so the changes in g (−1, −2, −4, −8) reverse both the direction and the concavity of f. C: This has the concavity of g but the direction of f. Since g(t) = 25 − f(t), the outputs of g fall as f rises, so g is decreasing, not increasing. D: This reverses the direction as it should but carries over the concavity of f. The successive changes in g are −1, −2, −4, −8, which are the negatives of the changes in f, so g is concave down, not concave up.

**N-1.1-A-v3.** A diver's depth f(t), in feet below the surface, is recorded at seconds t = 0, 1, 2, 3, 4: 50, 46, 40, 32, 22. Let g(t) = 80 − f(t) be the diver's height above a marker 80 feet below the surface. Assume f changes smoothly between recorded times. Which statement describes g on 0 ≤ t ≤ 4?

- A. g is increasing and concave down
- B. g is decreasing and concave up
- **C. g is increasing and concave up**
- D. g is decreasing and concave down

Check: The changes in f are −4, −6, −8, −10, so f is decreasing and concave down. For g = 80 − f the values are 30, 34, 40, 48, 58, with changes 4, 6, 8, 10, so g is increasing and concave up.
Rationales: A: This reverses the direction as it should but carries over the concavity of f. The successive changes in g are 4, 6, 8, 10, which are the negatives of the changes in f, so g is concave up, not concave down. B: This has the concavity of g but the direction of f. Since g(t) = 80 − f(t), the outputs of g rise as f falls, so g is increasing, not decreasing. D: This is the behavior of f itself, not of g. Subtracting f from a constant negates every change, so the changes in g (4, 6, 8, 10) reverse both the direction and the concavity of f.


---

## Seed N-1.1-B (new) — Topic 1.1 Change in Tandem
**Skill:** combine the direction and concavity of two functions to decide which features of their sum are forced and which are not.

On the interval 0 ≤ x ≤ 10, f(x) models the yearly revenue of one product and g(x) the yearly revenue of a second product, and s(x) = f(x) + g(x) is the combined revenue. On this interval f is increasing and concave down and g is increasing and concave up. Which statement about s must be true?

- A. s is increasing and concave up.
- B. s is increasing and concave down.
- **C. s is increasing, but its concavity cannot be determined from the information given.**
- D. Neither the direction nor the concavity of s can be determined.

Check: When two functions are both increasing on an interval, every average rate of change of s = f + g is the sum of two rates of the same sign, so s is increasing. Because f is concave down and g is concave up, the change in the rates of s is a sum of a positive and a negative amount, so concavity is undetermined.
Rationales: A: This is not forced. One summand is concave down and the other is concave up, so how s bends depends on which one curves more sharply; concave up is possible but so is concave down. B: This is not forced. One summand is concave down and the other is concave up, so how s bends depends on which one curves more sharply; concave down is possible but so is concave up. D: The direction is determined. When two functions are both increasing on an interval, every average rate of change of s = f + g is the sum of two rates of the same sign, so s is increasing. Only the concavity is left open.

**N-1.1-B-v1.** Two pipes drain a reservoir. Over 0 ≤ t ≤ 8, the volume f(t) from the first pipe's tank is decreasing and concave up, and the volume g(t) in the second pipe's tank is decreasing and concave down. Let s(t) = f(t) + g(t) be the total volume remaining. Which statement about s must be true?

- **A. s is decreasing, but its concavity cannot be determined from the information given.**
- B. s is decreasing and concave up.
- C. s is decreasing and concave down.
- D. Neither the direction nor the concavity of s can be determined.

Check: When two functions are both decreasing on an interval, every average rate of change of s = f + g is the sum of two rates of the same sign, so s is decreasing. Because f is concave up and g is concave down, the change in the rates of s is a sum of a positive and a negative amount, so concavity is undetermined.
Rationales: B: This is not forced. One summand is concave up and the other is concave down, so how s bends depends on which one curves more sharply; concave up is possible but so is concave down. C: This is not forced. One summand is concave up and the other is concave down, so how s bends depends on which one curves more sharply; concave down is possible but so is concave up. D: The direction is determined. When two functions are both decreasing on an interval, every average rate of change of s = f + g is the sum of two rates of the same sign, so s is decreasing. Only the concavity is left open.

**N-1.1-B-v2.** A runner's distance f(t) and a cyclist's distance g(t) from a starting line are modeled for 0 ≤ t ≤ 5, with f increasing and concave up and g decreasing and concave up. Let s(t) = f(t) + g(t) be the sum of their distances. Which statement about s must be true?

- A. s is increasing and concave up.
- B. s is decreasing and concave up.
- C. Neither the direction nor the concavity of s can be determined.
- **D. s is concave up, but whether it is increasing or decreasing cannot be determined from the information given.**

Check: Both functions are concave up, so the rates of change of f and of g are each increasing and the rates of s = f + g, which are their sums, are increasing too. Because f is increasing and g is decreasing, the sign of f's rate plus g's rate depends on which is larger, so the direction is undetermined.
Rationales: A: This is not forced. One summand is increasing and the other is decreasing, so the sum of their rates of change can be positive on one part of the interval and negative on another; increasing is possible but so is decreasing. B: This is not forced. One summand is increasing and the other is decreasing, so the sum of their rates of change can be positive on one part of the interval and negative on another; decreasing is possible but so is increasing. C: The concavity is determined. Both functions are concave up, so the rates of change of f and of g are each increasing and the rates of s = f + g, which are their sums, are increasing too. Only the direction is left open.

**N-1.1-B-v3.** Over 1 ≤ x ≤ 9, the function f represents the depth of a lake basin at a point and g the depth at another point, with f decreasing and concave down and g increasing and concave down. Let s(x) = f(x) + g(x). Which statement about s must be true?

- A. s is increasing and concave down.
- **B. s is concave down, but whether it is increasing or decreasing cannot be determined from the information given.**
- C. s is decreasing and concave down.
- D. Neither the direction nor the concavity of s can be determined.

Check: Both functions are concave down, so the rates of change of f and of g are each decreasing and the rates of s = f + g, which are their sums, are decreasing too. Because f is decreasing and g is increasing, the sign of f's rate plus g's rate depends on which is larger, so the direction is undetermined.
Rationales: A: This is not forced. One summand is decreasing and the other is increasing, so the sum of their rates of change can be positive on one part of the interval and negative on another; increasing is possible but so is decreasing. C: This is not forced. One summand is decreasing and the other is increasing, so the sum of their rates of change can be positive on one part of the interval and negative on another; decreasing is possible but so is increasing. D: The concavity is determined. Both functions are concave down, so the rates of change of f and of g are each decreasing and the rates of s = f + g, which are their sums, are decreasing too. Only the direction is left open.


---

## Seed N-1.2-A (new) — Topic 1.2 Rates of Change
**Skill:** combine the average rates over two adjacent unequal intervals into the average rate over the union, weighting by interval length.

A drone's altitude h(t), in meters, has average rate of change 6 meters per second over 1 ≤ t ≤ 4 and −2 meters per second over 4 ≤ t ≤ 6. What is the average rate of change of h over 1 ≤ t ≤ 6, in meters per second?

- A. 2
- B. 4
- C. 14
- **D. 2.8**

Check: Change over [1,4] is 6·3 = 18; change over [4,6] is −2·2 = −4. Total change 14 over length 5 gives 2.8.
Rationales: A: This averages the two rates, 6 and −2, as if the two subintervals had equal length. The subintervals have lengths 3 and 2, so each rate must be weighted by its length. B: This adds the two average rates. Rates cannot be added across consecutive intervals; the combined rate is the total change divided by the total length 5. C: This is the total change, 6·3 + −2·2 = 14, but it was never divided by the length 5 of the whole interval, so it is a change and not a rate.

**N-1.2-A-v1.** The water level L(d) of a reservoir, in centimeters, has average rate of change −4 cm per day over 0 ≤ d ≤ 2 and 3 cm per day over 2 ≤ d ≤ 7. What is the average rate of change of L over 0 ≤ d ≤ 7, in cm per day?

- A. −0.5
- **B. 1**
- C. −1
- D. 7

Check: Change over [0,2] is −4·2 = −8; change over [2,7] is 3·5 = 15. Total change 7 over length 7 gives 1.
Rationales: A: This averages the two rates, −4 and 3, as if the two subintervals had equal length. The subintervals have lengths 2 and 5, so each rate must be weighted by its length. C: This adds the two average rates. Rates cannot be added across consecutive intervals; the combined rate is the total change divided by the total length 7. D: This is the total change, −4·2 + 3·5 = 7, but it was never divided by the length 7 of the whole interval, so it is a change and not a rate.

**N-1.2-A-v2.** A company's profit P(q), in thousands of dollars, has average rate of change −6 thousand dollars per unit over 3 ≤ q ≤ 5 and 5 thousand dollars per unit over 5 ≤ q ≤ 8. What is the average rate of change of P over 3 ≤ q ≤ 8, in thousand dollars per unit?

- A. −0.5
- B. −1
- **C. 0.6**
- D. 3

Check: Change over [3,5] is −6·2 = −12; change over [5,8] is 5·3 = 15. Total change 3 over length 5 gives 0.6.
Rationales: A: This averages the two rates, −6 and 5, as if the two subintervals had equal length. The subintervals have lengths 2 and 3, so each rate must be weighted by its length. B: This adds the two average rates. Rates cannot be added across consecutive intervals; the combined rate is the total change divided by the total length 5. D: This is the total change, −6·2 + 5·3 = 3, but it was never divided by the length 5 of the whole interval, so it is a change and not a rate.

**N-1.2-A-v3.** A tree's height H(y), in centimeters, has average rate of change 7 cm per year over 0 ≤ y ≤ 4 and −2 cm per year over 4 ≤ y ≤ 10. What is the average rate of change of H over 0 ≤ y ≤ 10, in cm per year?

- **A. 1.6**
- B. 2.5
- C. 5
- D. 16

Check: Change over [0,4] is 7·4 = 28; change over [4,10] is −2·6 = −12. Total change 16 over length 10 gives 1.6.
Rationales: B: This averages the two rates, 7 and −2, as if the two subintervals had equal length. The subintervals have lengths 4 and 6, so each rate must be weighted by its length. C: This adds the two average rates. Rates cannot be added across consecutive intervals; the combined rate is the total change divided by the total length 10. D: This is the total change, 7·4 + −2·6 = 16, but it was never divided by the length 10 of the whole interval, so it is a change and not a rate.


---

## Seed N-1.2-B (new) — Topic 1.2 Rates of Change
**Skill:** work backward from a given average rate of change of a quadratic to a missing coefficient, tracking the cancellation of the constant and the division by interval width.

The cost function C(x) = x² + kx + 40 models the cost, in dollars, of producing x items, where k is a constant. The average rate of change of C over 1 ≤ x ≤ 5 is 4 dollars per item. What is the value of k?

- **A. −2**
- B. 10
- C. −5
- D. 0

Check: The constant 40 cancels. The average rate is ((5² + 5k) − (1² + 1k))/4 = 6 + k. Setting 6 + k = 4 gives k = −2.
Rationales: B: This has a sign error. The average rate of change of x² + kx + 40 over [1,5] equals 1 + 5 + k, so k = 4 − 6, not 4 + 6. C: This sets the total change f(5) − f(1) equal to 4 without dividing by the interval length 4. The condition is on the average rate, which is that change divided by 4. D: This simplifies (f(5) − f(1))/4 incorrectly, using the width 4 where the sum of the endpoints 6 belongs, because the x² terms give (5² − 1²)/4 = 6.

**N-1.2-B-v1.** The height of a ball is modeled by h(t) = t² + kt + 9, in feet, for t in seconds, where k is a constant. The average rate of change of h over 2 ≤ t ≤ 5 is 6 feet per second. What is the value of k?

- A. 13
- B. −5
- **C. −1**
- D. 3

Check: The constant 9 cancels. The average rate is ((5² + 5k) − (2² + 2k))/3 = 7 + k. Setting 7 + k = 6 gives k = −1.
Rationales: A: This has a sign error. The average rate of change of x² + kx + 9 over [2,5] equals 2 + 5 + k, so k = 6 − 7, not 6 + 7. B: This sets the total change f(5) − f(2) equal to 6 without dividing by the interval length 3. The condition is on the average rate, which is that change divided by 3. D: This simplifies (f(5) − f(2))/3 incorrectly, using the width 3 where the sum of the endpoints 7 belongs, because the x² terms give (5² − 2²)/3 = 7.

**N-1.2-B-v2.** A sensor reading is modeled by r(x) = x² + kx + 15, where k is a constant. The average rate of change of r over 1 ≤ x ≤ 7 is 9. What is the value of k?

- A. 17
- **B. 1**
- C. −6.5
- D. 3

Check: The constant 15 cancels. The average rate is ((7² + 7k) − (1² + 1k))/6 = 8 + k. Setting 8 + k = 9 gives k = 1.
Rationales: A: This has a sign error. The average rate of change of x² + kx + 15 over [1,7] equals 1 + 7 + k, so k = 9 − 8, not 9 + 8. C: This sets the total change f(7) − f(1) equal to 9 without dividing by the interval length 6. The condition is on the average rate, which is that change divided by 6. D: This simplifies (f(7) − f(1))/6 incorrectly, using the width 6 where the sum of the endpoints 8 belongs, because the x² terms give (7² − 1²)/6 = 8.

**N-1.2-B-v3.** The profit P(n) = n² + kn − 20, in dollars, is earned when n bags are sold, where k is a constant. The average rate of change of P over 3 ≤ n ≤ 5 is 2 dollars per bag. What is the value of k?

- A. 10
- B. −7
- C. 0
- **D. −6**

Check: The constant -20 cancels. The average rate is ((5² + 5k) − (3² + 3k))/2 = 8 + k. Setting 8 + k = 2 gives k = −6.
Rationales: A: This has a sign error. The average rate of change of x² + kx + -20 over [3,5] equals 3 + 5 + k, so k = 2 − 8, not 2 + 8. B: This sets the total change f(5) − f(3) equal to 2 without dividing by the interval length 2. The condition is on the average rate, which is that change divided by 2. C: This simplifies (f(5) − f(3))/2 incorrectly, using the width 2 where the sum of the endpoints 8 belongs, because the x² terms give (5² − 3²)/2 = 8.


---

## Seed N-1.3-A (new) — Topic 1.3 Rates of Change and Behavior of Graphs
**Skill:** infer concavity from average rates over intervals of unequal width, not from raw changes in output.

A sensor reading f is recorded at the times x = 0, 1, 3, 7, with corresponding readings 0, 2, 5, 8. Assume the graph of f is continuous and has the same concavity throughout this interval. Which description of f is supported by the average rates of change?

- A. f is increasing and concave up
- B. f is decreasing and concave up
- **C. f is increasing and concave down**
- D. f is decreasing and concave down

Check: The average rates on the three intervals are 2, 1.5, 0.75. They are positive and decreasing, so f is increasing and concave down.
Rationales: A: This compares the changes in output (2, 3, 3) instead of the average rates. The input intervals have different widths, so the changes mislead; the rates are 2, 1.5, 0.75, which are decreasing, so f is concave down. B: This gets the direction wrong and takes concavity from the raw output changes (2, 3, 3) rather than from the rates (2, 1.5, 0.75). The rates show f is increasing and concave down. D: This has the right concavity but the wrong direction. Every average rate (2, 1.5, 0.75) is positive, so f is increasing.

**N-1.3-A-v1.** A tank's water level f is measured at the times x = 0, 4, 6, 7, with corresponding levels 10, 6, 2, −1. Assume the graph of f is continuous and has the same concavity throughout this interval. Which description of f is supported by the average rates of change?

- **A. f is decreasing and concave down**
- B. f is increasing and concave up
- C. f is increasing and concave down
- D. f is decreasing and concave up

Check: The average rates on the three intervals are −1, −2, −3. They are negative and decreasing, so f is decreasing and concave down.
Rationales: B: This gets the direction wrong and takes concavity from the raw output changes (−4, −4, −3) rather than from the rates (−1, −2, −3). The rates show f is decreasing and concave down. C: This has the right concavity but the wrong direction. Every average rate (−1, −2, −3) is negative, so f is decreasing. D: This compares the changes in output (−4, −4, −3) instead of the average rates. The input intervals have different widths, so the changes mislead; the rates are −1, −2, −3, which are decreasing, so f is concave down.

**N-1.3-A-v2.** A company's cumulative output f is logged at the days x = 2, 6, 8, 9, with corresponding totals 3, 7, 10, 12. Assume the graph of f is continuous and has the same concavity throughout this interval. Which description of f is supported by the average rates of change?

- A. f is increasing and concave down
- **B. f is increasing and concave up**
- C. f is decreasing and concave up
- D. f is decreasing and concave down

Check: The average rates on the three intervals are 1, 1.5, 2. They are positive and increasing, so f is increasing and concave up.
Rationales: A: This compares the changes in output (4, 3, 2) instead of the average rates. The input intervals have different widths, so the changes mislead; the rates are 1, 1.5, 2, which are increasing, so f is concave up. C: This has the right concavity but the wrong direction. Every average rate (1, 1.5, 2) is positive, so f is increasing. D: This gets the direction wrong and takes concavity from the raw output changes (4, 3, 2) rather than from the rates (1, 1.5, 2). The rates show f is increasing and concave up.

**N-1.3-A-v3.** A balloon's height f is logged at the seconds x = 0, 1, 3, 7, with corresponding heights 20, 17, 12, 4. Assume the graph of f is continuous and has the same concavity throughout this interval. Which description of f is supported by the average rates of change?

- A. f is increasing and concave up
- B. f is increasing and concave down
- C. f is decreasing and concave down
- **D. f is decreasing and concave up**

Check: The average rates on the three intervals are −3, −2.5, −2. They are negative and increasing, so f is decreasing and concave up.
Rationales: A: This has the right concavity but the wrong direction. Every average rate (−3, −2.5, −2) is negative, so f is decreasing. B: This gets the direction wrong and takes concavity from the raw output changes (−3, −5, −8) rather than from the rates (−3, −2.5, −2). The rates show f is decreasing and concave up. C: This compares the changes in output (−3, −5, −8) instead of the average rates. The input intervals have different widths, so the changes mislead; the rates are −3, −2.5, −2, which are increasing, so f is concave up.


---

## Seed N-1.3-B (new) — Topic 1.3 Rates of Change and Behavior of Graphs
**Skill:** locate local extrema from the sign changes in a list of average rates over consecutive unit intervals, without over-claiming an exact location.

A continuous function f has average rates of change over the successive unit intervals [0,1], [1,2], [2,3], and so on, of 8, 5, 1, −2, −3, −1, 3. Which statement must be true?

- A. f has a local minimum for some x between 2 and 4 and a local maximum for some x between 5 and 7.
- B. f has a local maximum at x = 3 and a local minimum at x = 6.
- C. f has a local maximum for some x between 3 and 4 and a local minimum for some x between 6 and 7.
- **D. f has a local maximum for some x between 2 and 4 and a local minimum for some x between 5 and 7.**

Check: A positive average rate on one unit interval followed by a negative one means f rose and then fell across those two intervals, so by continuity a local maximum lies within them; the reverse change gives a local minimum. The sign changes are at 2–4 and 5–7.
Rationales: A: This reverses the roles. A change in the sign of the average rate from positive to negative means the function rose and then fell, which is a local maximum; from negative to positive it is a local minimum. B: This places each extremum at the midpoint of the pair of intervals where the sign of the rate changes. The averages only show that the extremum lies somewhere within that stretch, not that it sits at one particular input. C: This narrows the location to the single interval where the rate first has the new sign. The function could turn around in the earlier interval, so the sign change only places the turn somewhere in the two intervals together.

**N-1.3-B-v1.** The altitude f(t) of a glider, with t in minutes, is continuous. Its average rates of change over the successive unit intervals [0,1], [1,2], [2,3], and so on, are −5, −2, 1, 4, 3, −1, −4, −2. Which statement must be true?

- A. f has a local maximum for some x between 1 and 3 and a local minimum for some x between 4 and 6.
- **B. f has a local minimum for some x between 1 and 3 and a local maximum for some x between 4 and 6.**
- C. f has a local minimum at x = 2 and a local maximum at x = 5.
- D. f has a local minimum for some x between 2 and 3 and a local maximum for some x between 5 and 6.

Check: A positive average rate on one unit interval followed by a negative one means f rose and then fell across those two intervals, so by continuity a local maximum lies within them; the reverse change gives a local minimum. The sign changes are at 1–3 and 4–6.
Rationales: A: This reverses the roles. A change in the sign of the average rate from positive to negative means the function rose and then fell, which is a local maximum; from negative to positive it is a local minimum. C: This places each extremum at the midpoint of the pair of intervals where the sign of the rate changes. The averages only show that the extremum lies somewhere within that stretch, not that it sits at one particular input. D: This narrows the location to the single interval where the rate first has the new sign. The function could turn around in the earlier interval, so the sign change only places the turn somewhere in the two intervals together.

**N-1.3-B-v2.** A stock index f(d) is a continuous function of the day d. Its average rates of change over the successive one-day intervals [0,1], [1,2], [2,3], and so on, are 4, 1, −2, −3, −1, 2, 3. Which statement must be true?

- **A. f has a local maximum for some x between 1 and 3 and a local minimum for some x between 4 and 6.**
- B. f has a local minimum for some x between 1 and 3 and a local maximum for some x between 4 and 6.
- C. f has a local maximum at x = 2 and a local minimum at x = 5.
- D. f has a local maximum for some x between 2 and 3 and a local minimum for some x between 5 and 6.

Check: A positive average rate on one unit interval followed by a negative one means f rose and then fell across those two intervals, so by continuity a local maximum lies within them; the reverse change gives a local minimum. The sign changes are at 1–3 and 4–6.
Rationales: B: This reverses the roles. A change in the sign of the average rate from positive to negative means the function rose and then fell, which is a local maximum; from negative to positive it is a local minimum. C: This places each extremum at the midpoint of the pair of intervals where the sign of the rate changes. The averages only show that the extremum lies somewhere within that stretch, not that it sits at one particular input. D: This narrows the location to the single interval where the rate first has the new sign. The function could turn around in the earlier interval, so the sign change only places the turn somewhere in the two intervals together.

**N-1.3-B-v3.** The temperature f(h) of a room is a continuous function of the hour h. Its average rates of change over the successive one-hour intervals [0,1], [1,2], [2,3], and so on, are −2, 3, 5, 2, −1, −4, −3, 1. Which statement must be true?

- A. f has a local maximum for some x between 0 and 2, a local minimum for some x between 3 and 5, and a local maximum for some x between 6 and 8.
- B. f has a local minimum at x = 1, a local maximum at x = 4, and a local minimum at x = 7.
- **C. f has a local minimum for some x between 0 and 2, a local maximum for some x between 3 and 5, and a local minimum for some x between 6 and 8.**
- D. f has a local minimum for some x between 1 and 2, a local maximum for some x between 4 and 5, and a local minimum for some x between 7 and 8.

Check: A positive average rate on one unit interval followed by a negative one means f rose and then fell across those two intervals, so by continuity a local maximum lies within them; the reverse change gives a local minimum. The sign changes are at 0–2, 3–5, and 6–8.
Rationales: A: This reverses the roles. A change in the sign of the average rate from positive to negative means the function rose and then fell, which is a local maximum; from negative to positive it is a local minimum. B: This places each extremum at the midpoint of the pair of intervals where the sign of the rate changes. The averages only show that the extremum lies somewhere within that stretch, not that it sits at one particular input. D: This narrows the location to the single interval where the rate first has the new sign. The function could turn around in the earlier interval, so the sign change only places the turn somewhere in the two intervals together.


---

## Seed N-1.4-A (new) — Topic 1.4 Polynomial Functions and Rates of Change
**Skill:** extend a table of a cubic by propagating the constant third difference back through second and first differences, rejecting lower-degree extrapolations.

A cubic polynomial model f has the following values at equally spaced inputs x = 0, 1, 2, 3, 4: 2, 2, 4, 14, 38. What is the value of f(5) predicted by the model?

- **A. 82**
- B. 76
- C. 62
- D. 68

Check: First differences 0, 2, 10, 24; second differences 2, 8, 14; third differences constant at 6. The next second difference is 20, the next first difference is 44, so the next value is 82.
Rationales: B: This assumes the second differences stay constant at 14, which would make the model quadratic. The second differences here are 2, 8, 14, not constant; the third differences are constant. C: This assumes the first differences stay constant at 24, which would make the model linear. The first differences are 0, 2, 10, 24, so they keep changing. D: This adds the constant third difference 6 directly to the last first difference. It must first be added to the last second difference (14) to get the next second difference, and that is then added to the last first difference.

**N-1.4-A-v1.** A designer fits a cubic polynomial g to measurements taken at x = 0, 2, 4, 6, 8, getting g = 7, 9, 15, 19, 15. According to the cubic model, what is g(10)?

- A. 3
- B. 11
- **C. −3**
- D. 5

Check: First differences 2, 6, 4, −4; second differences 4, −2, −8; third differences constant at −6. The next second difference is −14, the next first difference is −18, so the next value is −3.
Rationales: A: This assumes the second differences stay constant at −8, which would make the model quadratic. The second differences here are 4, −2, −8, not constant; the third differences are constant. B: This assumes the first differences stay constant at −4, which would make the model linear. The first differences are 2, 6, 4, −4, so they keep changing. D: This adds the constant third difference −6 directly to the last first difference. It must first be added to the last second difference (−8) to get the next second difference, and that is then added to the last first difference.

**N-1.4-A-v2.** A cubic polynomial p models the depth of a channel at positions x = 1, 2, 3, 4, 5 meters, with depths 5, 4, 9, 32, 85 centimeters. What depth does the model give at x = 6?

- A. 168
- B. 138
- C. 150
- **D. 180**

Check: First differences −1, 5, 23, 53; second differences 6, 18, 30; third differences constant at 12. The next second difference is 42, the next first difference is 95, so the next value is 180.
Rationales: A: This assumes the second differences stay constant at 30, which would make the model quadratic. The second differences here are 6, 18, 30, not constant; the third differences are constant. B: This assumes the first differences stay constant at 53, which would make the model linear. The first differences are −1, 5, 23, 53, so they keep changing. C: This adds the constant third difference 12 directly to the last first difference. It must first be added to the last second difference (30) to get the next second difference, and that is then added to the last first difference.

**N-1.4-A-v3.** A polynomial of degree 3 describes the cost c at production levels x = 0, 5, 10, 15, 20, with costs 10, 7, 10, 25, 58. What cost does the model give at x = 25?

- A. 109
- **B. 115**
- C. 91
- D. 97

Check: First differences −3, 3, 15, 33; second differences 6, 12, 18; third differences constant at 6. The next second difference is 24, the next first difference is 57, so the next value is 115.
Rationales: A: This assumes the second differences stay constant at 18, which would make the model quadratic. The second differences here are 6, 12, 18, not constant; the third differences are constant. C: This assumes the first differences stay constant at 33, which would make the model linear. The first differences are −3, 3, 15, 33, so they keep changing. D: This adds the constant third difference 6 directly to the last first difference. It must first be added to the last second difference (18) to get the next second difference, and that is then added to the last first difference.


---

## Seed N-1.4-B (new) — Topic 1.4 Polynomial Functions and Rates of Change
**Skill:** combine the turning-point bound (degree at least turning points plus one) with the parity forced by end behavior to find the least possible degree.

A polynomial function p has exactly 5 local extrema, and the graph of p rises without bound at both ends of the graph. What is the least possible degree of p?

- A. 5
- B. 7
- C. 4
- **D. 6**

Check: A polynomial of degree n has at most n − 1 turning points, so n ≥ 6. Both ends rising means even degree, which also forces an odd number of turning points (5 is odd), so the least possible degree is 6.
Rationales: A: A polynomial of degree 5 has at most 4 turning points, but this function has 5. The degree must be at least 6. B: A polynomial of degree 7 could have 5 turning points, but a degree-7 polynomial is odd, so its ends would point in opposite directions. The stated end behavior requires an even degree. C: A polynomial of degree 4 has at most 3 turning points, but this function has 5. The degree must be at least 6.

**N-1.4-B-v1.** A polynomial function q has exactly 3 turning points, and its graph rises without bound at both ends of the graph. What is the least possible degree of q?

- A. 3
- B. 5
- C. 2
- **D. 4**

Check: A polynomial of degree n has at most n − 1 turning points, so n ≥ 4. The end behavior makes n even, so the least possible degree is 4.
Rationales: A: A polynomial of degree 3 has at most 2 turning points, but this function has 3. The degree must be at least 4. B: A polynomial of degree 5 could have 3 turning points, but a degree-5 polynomial is odd, so its ends would point in opposite directions. The stated end behavior requires an even degree. C: A polynomial of degree 2 has at most 1 turning points, but this function has 3. The degree must be at least 4.

**N-1.4-B-v2.** The graph of a polynomial function r has exactly 4 local extrema and falls without bound to the left and rises without bound to the right. What is the least possible degree of r?

- A. 4
- B. 6
- **C. 5**
- D. 3

Check: A polynomial of degree n has at most n − 1 turning points, so n ≥ 5. The end behavior makes n odd, so the least possible degree is 5.
Rationales: A: A polynomial of degree 4 has at most 3 turning points, but this function has 4. The degree must be at least 5. B: A polynomial of degree 6 could have 4 turning points, but a degree-6 polynomial is even, so its ends would point the same way. The stated end behavior requires an odd degree. D: A polynomial of degree 3 has at most 2 turning points, but this function has 4. The degree must be at least 5.

**N-1.4-B-v3.** A polynomial function s has exactly 2 turning points, and the graph of s falls without bound to the left and rises without bound to the right. What is the least possible degree of s?

- A. 2
- **B. 3**
- C. 4
- D. 1

Check: A polynomial of degree n has at most n − 1 turning points, so n ≥ 3. The ends pointing opposite ways means odd degree, which also forces an even number of turning points (2 is even), so the least possible degree is 3.
Rationales: A: A polynomial of degree 2 has at most 1 turning point, but this function has 2. The degree must be at least 3. C: A polynomial of degree 4 could have 2 turning points, but a degree-4 polynomial is even, so its ends would point the same way. The stated end behavior requires an odd degree. D: A polynomial of degree 1 has at most 0 turning points, but this function has 2. The degree must be at least 3.


---

## Seed N-1.5-A (new) — Topic 1.5 Polynomial Functions and Complex Zeros
**Skill:** count real zeros of a real-coefficient polynomial by adding the conjugate of every nonreal zero with its multiplicity before subtracting from the degree.

A polynomial P has real coefficients and degree 9. Every nonreal zero of P is either one of the following numbers or the complex conjugate of one of them: 3 + 2i with multiplicity 2 and −4i with multiplicity 1. Counting multiplicity, how many real zeros does P have?

- A. 6
- B. 5
- C. 7
- **D. 3**

Check: Nonreal zeros come in conjugate pairs with equal multiplicity, so they total 2·(2+1) = 6. The remaining 9 − 6 = 3 zeros are real.
Rationales: A: This counts each listed nonreal zero but not its conjugate. Because P has real coefficients, each nonreal zero comes with its conjugate with the same multiplicity, so there are 2·3 = 6 nonreal zeros, not 3. B: This includes the conjugates but counts each listed zero only once. Multiplicity matters when counting zeros, so the nonreal zeros number 2·3 = 6, not 2·2 = 4. C: This subtracts only the 2 distinct listed zeros. It ignores both the conjugate of each and the multiplicities, so it removes far fewer than the 6 nonreal zeros there are.

**N-1.5-A-v1.** A polynomial Q has real coefficients and degree 10. Every nonreal zero of Q is either one of the following numbers or the complex conjugate of one of them: 2 − 3i with multiplicity 2 and i with multiplicity 1. Counting multiplicity, how many real zeros does Q have?

- A. 7
- **B. 4**
- C. 6
- D. 8

Check: Nonreal zeros come in conjugate pairs with equal multiplicity, so they total 2·(2+1) = 6. The remaining 10 − 6 = 4 zeros are real.
Rationales: A: This counts each listed nonreal zero but not its conjugate. Because P has real coefficients, each nonreal zero comes with its conjugate with the same multiplicity, so there are 2·3 = 6 nonreal zeros, not 3. C: This includes the conjugates but counts each listed zero only once. Multiplicity matters when counting zeros, so the nonreal zeros number 2·3 = 6, not 2·2 = 4. D: This subtracts only the 2 distinct listed zeros. It ignores both the conjugate of each and the multiplicities, so it removes far fewer than the 6 nonreal zeros there are.

**N-1.5-A-v2.** A polynomial R has real coefficients and degree 11. Every nonreal zero of R is either one of the following numbers or the complex conjugate of one of them: −1 + 4i with multiplicity 1, 3i with multiplicity 2 and 2 + i with multiplicity 1. Counting multiplicity, how many real zeros does R have?

- A. 7
- B. 5
- **C. 3**
- D. 8

Check: Nonreal zeros come in conjugate pairs with equal multiplicity, so they total 2·(1+2+1) = 8. The remaining 11 − 8 = 3 zeros are real.
Rationales: A: This counts each listed nonreal zero but not its conjugate. Because P has real coefficients, each nonreal zero comes with its conjugate with the same multiplicity, so there are 2·4 = 8 nonreal zeros, not 4. B: This includes the conjugates but counts each listed zero only once. Multiplicity matters when counting zeros, so the nonreal zeros number 2·4 = 8, not 2·3 = 6. D: This subtracts only the 3 distinct listed zeros. It ignores both the conjugate of each and the multiplicities, so it removes far fewer than the 8 nonreal zeros there are.

**N-1.5-A-v3.** A polynomial S has real coefficients and degree 13. Every nonreal zero of S is either one of the following numbers or the complex conjugate of one of them: 3 + i with multiplicity 1, −5i with multiplicity 2 and 1 − 2i with multiplicity 2. Counting multiplicity, how many real zeros does S have?

- **A. 3**
- B. 8
- C. 7
- D. 10

Check: Nonreal zeros come in conjugate pairs with equal multiplicity, so they total 2·(1+2+2) = 10. The remaining 13 − 10 = 3 zeros are real.
Rationales: B: This counts each listed nonreal zero but not its conjugate. Because P has real coefficients, each nonreal zero comes with its conjugate with the same multiplicity, so there are 2·5 = 10 nonreal zeros, not 5. C: This includes the conjugates but counts each listed zero only once. Multiplicity matters when counting zeros, so the nonreal zeros number 2·5 = 10, not 2·3 = 6. D: This subtracts only the 3 distinct listed zeros. It ignores both the conjugate of each and the multiplicities, so it removes far fewer than the 10 nonreal zeros there are.


---

## Seed N-1.5-B (new) — Topic 1.5 Polynomial Functions and Complex Zeros
**Skill:** use the factor theorem to find an unknown coefficient, then use the sum of the zeros of a monic cubic to get the sum of the remaining two without finding them.

The polynomial p(x) = x³ + ax² − 4x + 3 has x − 3 as a factor, where a is a constant. What is the sum of the other two zeros of p?

- **A. −1**
- B. 2
- C. 5
- D. −5

Check: Since x − 3 is a factor, p(3) = 0, which gives a = −2. The zeros of this monic cubic sum to −a = 2, so the other two sum to 2 minus the known zero 3, which is −1.
Rationales: B: This is the sum of all three zeros, 2, found from the x² coefficient. The question asks for the other two zeros, so the known zero 3 must be subtracted from that sum. C: This adds the known zero 3 to the sum of all three zeros instead of subtracting it. Removing a zero from the total means subtracting it. D: This uses a = −2 for the sum of the zeros instead of −a. For a monic cubic the three zeros add to the opposite of the x² coefficient.

**N-1.5-B-v1.** The polynomial f(x) = x³ + ax² − x − 6 has x + 2 as a factor, where a is a constant. What is the sum of the two zeros of f other than the zero from that factor?

- A. −3
- B. −5
- **C. −1**
- D. 5

Check: Since x + 2 is a factor, p(-2) = 0, which gives a = 3. The zeros of this monic cubic sum to −a = −3, so the other two sum to −3 minus the known zero −2, which is −1.
Rationales: A: This is the sum of all three zeros, −3, found from the x² coefficient. The question asks for the other two zeros, so the known zero −2 must be subtracted from that sum. B: This adds the known zero −2 to the sum of all three zeros instead of subtracting it. Removing a zero from the total means subtracting it. D: This uses a = 3 for the sum of the zeros instead of −a. For a monic cubic the three zeros add to the opposite of the x² coefficient.

**N-1.5-B-v2.** For a constant a, the cubic g(x) = x³ + ax² + 2x + 8 is divisible by x − 4. What is the sum of the remaining two zeros of g?

- A. 5
- **B. 1**
- C. 9
- D. −9

Check: Since x − 4 is a factor, p(4) = 0, which gives a = −5. The zeros of this monic cubic sum to −a = 5, so the other two sum to 5 minus the known zero 4, which is 1.
Rationales: A: This is the sum of all three zeros, 5, found from the x² coefficient. The question asks for the other two zeros, so the known zero 4 must be subtracted from that sum. C: This adds the known zero 4 to the sum of all three zeros instead of subtracting it. Removing a zero from the total means subtracting it. D: This uses a = −5 for the sum of the zeros instead of −a. For a monic cubic the three zeros add to the opposite of the x² coefficient.

**N-1.5-B-v3.** A cubic function h is given by h(x) = x³ + ax² − 3x − 6, where a is a constant, and x + 1 divides h(x) with no remainder. What is the sum of the other two zeros of h?

- A. −4
- B. −5
- C. 5
- **D. −3**

Check: Since x + 1 is a factor, p(-1) = 0, which gives a = 4. The zeros of this monic cubic sum to −a = −4, so the other two sum to −4 minus the known zero −1, which is −3.
Rationales: A: This is the sum of all three zeros, −4, found from the x² coefficient. The question asks for the other two zeros, so the known zero −1 must be subtracted from that sum. B: This adds the known zero −1 to the sum of all three zeros instead of subtracting it. Removing a zero from the total means subtracting it. C: This uses a = 4 for the sum of the zeros instead of −a. For a monic cubic the three zeros add to the opposite of the x² coefficient.


---

## Seed N-1.6-A (new) — Topic 1.6 Polynomial Functions and End Behavior
**Skill:** find the end behavior of a product with a reflected factor by tracking both the degree parity and the sign contributed by the reflection.

f is a polynomial of degree 5 with a negative leading coefficient, and g is a polynomial of degree 3 with a positive leading coefficient. Let h(x) = f(x)·g(−x). Which statement describes the end behavior of h?

- A. h(x) → −∞ as x → ∞ and h(x) → −∞ as x → −∞
- **B. h(x) → ∞ as x → ∞ and h(x) → ∞ as x → −∞**
- C. h(x) → ∞ as x → ∞ and h(x) → −∞ as x → −∞
- D. h(x) → −∞ as x → ∞ and h(x) → ∞ as x → −∞

Check: The leading term of h has degree 5+3 = 8, which is even, and its coefficient is positive because replacing x with −x in g multiplies its leading term by (−1)^3, which is negative. So as x → ∞, h → ∞, and as x → −∞, h → ∞.
Rationales: A: This has the right shape, since the degree 5+3 = 8 is even, but the wrong sign for the leading coefficient. The leading coefficient is positive because replacing x with −x in g multiplies its leading term by (−1)^3, which is negative. C: This sends the left end to −∞ and the right end to ∞, so the ends point opposite ways. But the degree of h is 5 + 3 = 8, which is even, so its ends point the same way; here the left end should go to ∞, not −∞. D: This sends the left end to ∞ and the right end to −∞, so the ends point opposite ways. But the degree of h is 5 + 3 = 8, which is even, so its ends point the same way; the right end goes to ∞, not −∞.

**N-1.6-A-v1.** f is a polynomial of degree 4 with a positive leading coefficient, and g is a polynomial of degree 5 with a negative leading coefficient. Let h(x) = f(−x)·g(x). Which statement describes the end behavior of h?

- A. h(x) → ∞ as x → ∞ and h(x) → ∞ as x → −∞
- B. h(x) → −∞ as x → ∞ and h(x) → −∞ as x → −∞
- C. h(x) → ∞ as x → ∞ and h(x) → −∞ as x → −∞
- **D. h(x) → −∞ as x → ∞ and h(x) → ∞ as x → −∞**

Check: The leading term of h has degree 4+5 = 9, which is odd, and its coefficient is negative because replacing x with −x in f multiplies its leading term by (−1)^4, which is positive. So as x → ∞, h → −∞, and as x → −∞, h → ∞.
Rationales: A: This sends the left end to ∞ and the right end to ∞, so the ends point the same way. But the degree of h is 4 + 5 = 9, which is odd, so its ends point opposite ways; the right end goes to −∞, not ∞. B: This sends the left end to −∞ and the right end to −∞, so the ends point the same way. But the degree of h is 4 + 5 = 9, which is odd, so its ends point opposite ways; here the left end should go to ∞, not −∞. C: This has the right shape, since the degree 4+5 = 9 is odd, but the wrong sign for the leading coefficient. The leading coefficient is negative because replacing x with −x in f multiplies its leading term by (−1)^4, which is positive.

**N-1.6-A-v2.** f is a polynomial of degree 2 with a positive leading coefficient, and g is a polynomial of degree 4 with a positive leading coefficient. Let h(x) = −f(x)·g(x). Which statement describes the end behavior of h?

- **A. h(x) → −∞ as x → ∞ and h(x) → −∞ as x → −∞**
- B. h(x) → ∞ as x → ∞ and h(x) → ∞ as x → −∞
- C. h(x) → ∞ as x → ∞ and h(x) → −∞ as x → −∞
- D. h(x) → −∞ as x → ∞ and h(x) → ∞ as x → −∞

Check: The leading term of h has degree 2+4 = 6, which is even, and its coefficient is negative because the leading coefficient of f·g is negated by the leading minus sign. So as x → ∞, h → −∞, and as x → −∞, h → −∞.
Rationales: B: This has the right shape, since the degree 2+4 = 6 is even, but the wrong sign for the leading coefficient. The leading coefficient is negative because the leading coefficient of f·g is negated by the leading minus sign. C: This sends the left end to −∞ and the right end to ∞, so the ends point opposite ways. But the degree of h is 2 + 4 = 6, which is even, so its ends point the same way; the right end goes to −∞, not ∞. D: This sends the left end to ∞ and the right end to −∞, so the ends point opposite ways. But the degree of h is 2 + 4 = 6, which is even, so its ends point the same way; here the left end should go to −∞, not ∞.

**N-1.6-A-v3.** f is a polynomial of degree 3 with a negative leading coefficient, and g is a polynomial of degree 2 with a negative leading coefficient. Let h(x) = f(x)·g(−x). Which statement describes the end behavior of h?

- A. h(x) → ∞ as x → ∞ and h(x) → ∞ as x → −∞
- B. h(x) → −∞ as x → ∞ and h(x) → −∞ as x → −∞
- **C. h(x) → ∞ as x → ∞ and h(x) → −∞ as x → −∞**
- D. h(x) → −∞ as x → ∞ and h(x) → ∞ as x → −∞

Check: The leading term of h has degree 3+2 = 5, which is odd, and its coefficient is positive because replacing x with −x in g multiplies its leading term by (−1)^2, which is positive. So as x → ∞, h → ∞, and as x → −∞, h → −∞.
Rationales: A: This sends the left end to ∞ and the right end to ∞, so the ends point the same way. But the degree of h is 3 + 2 = 5, which is odd, so its ends point opposite ways; here the left end should go to −∞, not ∞. B: This sends the left end to −∞ and the right end to −∞, so the ends point the same way. But the degree of h is 3 + 2 = 5, which is odd, so its ends point opposite ways; the right end goes to ∞, not −∞. D: This has the right shape, since the degree 3+2 = 5 is odd, but the wrong sign for the leading coefficient. The leading coefficient is positive because replacing x with −x in g multiplies its leading term by (−1)^2, which is positive.


---

## Seed N-1.6-B (new) — Topic 1.6 Polynomial Functions and End Behavior
**Skill:** build a sign chart from end behavior and zero multiplicities, changing sign only at odd-multiplicity zeros.

The polynomial p has the form p(x) = a(x + 3)(x − 1)²(x − 4)², where a is a nonzero constant. The zeros of p are −3 with multiplicity 1, 1 with multiplicity 2, and 4 with multiplicity 2, and p(x) → −∞ as x → ∞. For which values of x is p(x) > 0?

- A. (−3, 1) ∪ (1, 4) ∪ (4, ∞)
- B. (−∞, −3) ∪ (1, 4)
- **C. (−∞, −3)**
- D. (−3, 1) ∪ (4, ∞)

Check: Since a polynomial's ends follow the leading term, the sign on the far right is negative. Moving left, the sign changes only at zeros of odd multiplicity. This gives p(x) > 0 on (−∞, −3).
Rationales: A: This takes the sign to be negative on the far right, reversing the end behavior. Because p(x) → −∞ as x → ∞, a is negative, and the intervals found here are where p is negative. B: This changes sign at every zero. A zero of even multiplicity only touches the x-axis, so p does not change sign there; only the zeros of odd multiplicity are sign changes. D: This makes two errors. It reverses the sign on the far right and also changes sign at every zero, so it lists the intervals where p would be negative if every zero were a crossing.

**N-1.6-B-v1.** A polynomial q has the form q(x) = a(x + 2)²x(x − 5) for some nonzero constant a, with zeros −2 with multiplicity 2, 0 with multiplicity 1, and 5 with multiplicity 1. Also q(x) → ∞ as x → ∞. On which set of x-values is q(x) > 0?

- **A. (−∞, −2) ∪ (−2, 0) ∪ (5, ∞)**
- B. (0, 5)
- C. (−2, 0) ∪ (5, ∞)
- D. (−∞, −2) ∪ (0, 5)

Check: Since a polynomial's ends follow the leading term, the sign on the far right is positive. Moving left, the sign changes only at zeros of odd multiplicity. This gives p(x) > 0 on (−∞, −2) ∪ (−2, 0) ∪ (5, ∞).
Rationales: B: This takes the sign to be negative on the far right, reversing the end behavior. Because p(x) → ∞ as x → ∞, a is positive, and the intervals found here are where p is negative. C: This changes sign at every zero. A zero of even multiplicity only touches the x-axis, so p does not change sign there; only the zeros of odd multiplicity are sign changes. D: This makes two errors. It reverses the sign on the far right and also changes sign at every zero, so it lists the intervals where p would be negative if every zero were a crossing.

**N-1.6-B-v2.** A polynomial r has the form r(x) = a(x + 5)(x + 1)³(x − 2)² for some nonzero constant a, with zeros −5 with multiplicity 1, −1 with multiplicity 3, and 2 with multiplicity 2. It is known that r(x) → −∞ as x → ∞. On which set of x-values is r(x) > 0?

- A. (−∞, −5) ∪ (−1, 2) ∪ (2, ∞)
- B. (−∞, −5) ∪ (−1, 2)
- C. (−5, −1) ∪ (2, ∞)
- **D. (−5, −1)**

Check: Since a polynomial's ends follow the leading term, the sign on the far right is negative. Moving left, the sign changes only at zeros of odd multiplicity. This gives p(x) > 0 on (−5, −1).
Rationales: A: This takes the sign to be negative on the far right, reversing the end behavior. Because p(x) → −∞ as x → ∞, a is negative, and the intervals found here are where p is negative. B: This changes sign at every zero. A zero of even multiplicity only touches the x-axis, so p does not change sign there; only the zeros of odd multiplicity are sign changes. C: This makes two errors. It reverses the sign on the far right and also changes sign at every zero, so it lists the intervals where p would be negative if every zero were a crossing.

**N-1.6-B-v3.** A polynomial w has the form w(x) = a(x + 4)²(x − 1)(x − 3)²(x − 6) for some nonzero constant a, with zeros −4 with multiplicity 2, 1 with multiplicity 1, 3 with multiplicity 2, and 6 with multiplicity 1. It is known that w(x) → ∞ as x → ∞. On which set of x-values is w(x) > 0?

- A. (1, 3) ∪ (3, 6)
- **B. (−∞, −4) ∪ (−4, 1) ∪ (6, ∞)**
- C. (−∞, −4) ∪ (1, 3) ∪ (6, ∞)
- D. (−4, 1) ∪ (3, 6)

Check: Since a polynomial's ends follow the leading term, the sign on the far right is positive. Moving left, the sign changes only at zeros of odd multiplicity. This gives p(x) > 0 on (−∞, −4) ∪ (−4, 1) ∪ (6, ∞).
Rationales: A: This takes the sign to be negative on the far right, reversing the end behavior. Because p(x) → ∞ as x → ∞, a is positive, and the intervals found here are where p is negative. C: This changes sign at every zero. A zero of even multiplicity only touches the x-axis, so p does not change sign there; only the zeros of odd multiplicity are sign changes. D: This makes two errors. It reverses the sign on the far right and also changes sign at every zero, so it lists the intervals where p would be negative if every zero were a crossing.


---

## Seed N-1.7-A (new) — Topic 1.7 Rational Functions and End Behavior
**Skill:** find the horizontal asymptote of an unexpanded rational function with equal degrees by multiplying the leading coefficients of every factor, including the square.

The rational function R is given by R(x) = 3(2x − 1)²(x + 3) / ((x² + 5)(−4x + 1)). Which equation gives the horizontal asymptote of the graph of R?

- **A. y = −3**
- B. y = −1.5
- C. y = 3
- D. y = −1/3

Check: Both numerator and denominator have degree 3. The numerator's leading coefficient is 3·2²·1 = 12 and the denominator's is −4, so the horizontal asymptote is y = −3.
Rationales: B: This forgets to square the leading coefficient 2 of the squared factor. The leading coefficient of the numerator is 3·2²·1 = 12, not 6. C: This has the right size but the wrong sign. The leading coefficient of the numerator is 12 and of the denominator is −4, so their quotient is −3. D: This inverts the ratio, putting the denominator's leading coefficient over the numerator's. The horizontal asymptote is numerator over denominator, 12 / −4.

**N-1.7-A-v1.** The rational function S is given by S(x) = −2(3x + 1)²(x − 4) / ((x² + 2)(2x − 5)). Which equation gives the horizontal asymptote of the graph of S?

- A. y = −3
- B. y = 9
- **C. y = −9**
- D. y = −1/9

Check: Both numerator and denominator have degree 3. The numerator's leading coefficient is -2·3²·1 = −18 and the denominator's is 2, so the horizontal asymptote is y = −9.
Rationales: A: This forgets to square the leading coefficient 3 of the squared factor. The leading coefficient of the numerator is -2·3²·1 = -18, not -6. B: This has the right size but the wrong sign. The leading coefficient of the numerator is −18 and of the denominator is 2, so their quotient is −9. D: This inverts the ratio, putting the denominator's leading coefficient over the numerator's. The horizontal asymptote is numerator over denominator, −18 / 2.

**N-1.7-A-v2.** The rational function T is given by T(x) = 5(2x + 3)²(3x − 1) / ((x² + 1)(−3x + 2)). Which equation gives the horizontal asymptote of the graph of T?

- A. y = −10
- B. y = 20
- C. y = −0.05
- **D. y = −20**

Check: Both numerator and denominator have degree 3. The numerator's leading coefficient is 5·2²·3 = 60 and the denominator's is −3, so the horizontal asymptote is y = −20.
Rationales: A: This forgets to square the leading coefficient 2 of the squared factor. The leading coefficient of the numerator is 5·2²·3 = 60, not 30. B: This has the right size but the wrong sign. The leading coefficient of the numerator is 60 and of the denominator is −3, so their quotient is −20. C: This inverts the ratio, putting the denominator's leading coefficient over the numerator's. The horizontal asymptote is numerator over denominator, 60 / −3.

**N-1.7-A-v3.** The rational function U is given by U(x) = −3(−2x + 1)²(x + 5) / ((x² + 4)(6x − 1)). Which equation gives the horizontal asymptote of the graph of U?

- A. y = 1
- **B. y = −2**
- C. y = 2
- D. y = −0.5

Check: Both numerator and denominator have degree 3. The numerator's leading coefficient is -3·-2²·1 = −12 and the denominator's is 6, so the horizontal asymptote is y = −2.
Rationales: A: This forgets to square the leading coefficient -2 of the squared factor. The leading coefficient of the numerator is -3·-2²·1 = -12, not 6. C: This has the right size but the wrong sign. The leading coefficient of the numerator is −12 and of the denominator is 6, so their quotient is −2. D: This inverts the ratio, putting the denominator's leading coefficient over the numerator's. The horizontal asymptote is numerator over denominator, −12 / 6.


---

## Seed N-1.7-B (new) — Topic 1.7 Rational Functions and End Behavior
**Skill:** describe the side of the horizontal asymptote y = 0 that a rational function approaches at each end by tracking the sign of the ratio of leading terms through the parity of the degree gap.

Let R(x) = (5 − 2x²) / (x³ + 7x). Which statement describes the end behavior of R?

- A. R(x) approaches 0 from above as x → ∞ and from above as x → −∞
- **B. R(x) approaches 0 from below as x → ∞ and from above as x → −∞**
- C. R(x) approaches 0 from above as x → ∞ and from below as x → −∞
- D. R(x) approaches 0 from below as x → ∞ and from below as x → −∞

Check: The denominator has the greater degree, so R(x) → 0. The sign of R for large |x| is the sign of the ratio of leading terms, which gives about −0.002 at x = 1000 and 0.002 at x = −1000, so the graph lies below the x-axis on the right and above it on the left.
Rationales: A: This gets the right end wrong. For a large positive input such as x = 1000 the value of R is about −0.002, which is negative, so the graph is below the x-axis there. C: This reverses the side on both ends. At x = 1000 the value is about −0.002 and at x = −1000 it is about 0.002, which puts the graph below the axis on the right and above it on the left. D: This gets the left end wrong. For a large negative input such as x = −1000 the value of R is about 0.002, which is positive, so the graph is above the x-axis there.

**N-1.7-B-v1.** Let R(x) = (3x + 1) / (x³ − 4x). Which statement describes the end behavior of R?

- A. R(x) approaches 0 from above as x → ∞ and from below as x → −∞
- B. R(x) approaches 0 from below as x → ∞ and from above as x → −∞
- C. R(x) approaches 0 from below as x → ∞ and from below as x → −∞
- **D. R(x) approaches 0 from above as x → ∞ and from above as x → −∞**

Check: The denominator has the greater degree, so R(x) → 0. The sign of R for large |x| is the sign of the ratio of leading terms, which gives about 3.001e−06 at x = 1000 and 2.999e−06 at x = −1000, so the graph lies above the x-axis on the right and above it on the left.
Rationales: A: This gets the left end wrong. For a large negative input such as x = −1000 the value of R is about 2.999e−06, which is positive, so the graph is above the x-axis there. B: This gets the right end wrong. For a large positive input such as x = 1000 the value of R is about 3.001e−06, which is positive, so the graph is above the x-axis there. C: This reverses the side on both ends. At x = 1000 the value is about 3.001e−06 and at x = −1000 it is about 2.999e−06, which puts the graph above the axis on the right and above it on the left.

**N-1.7-B-v2.** Let R(x) = (2 − x)(x + 1) / (x⁴ + 3x² + 1). Which statement describes the end behavior of R?

- A. R(x) approaches 0 from above as x → ∞ and from above as x → −∞
- B. R(x) approaches 0 from above as x → ∞ and from below as x → −∞
- **C. R(x) approaches 0 from below as x → ∞ and from below as x → −∞**
- D. R(x) approaches 0 from below as x → ∞ and from above as x → −∞

Check: The denominator has the greater degree, so R(x) → 0. The sign of R for large |x| is the sign of the ratio of leading terms, which gives about −9.99e−07 at x = 1000 and −1.001e−06 at x = −1000, so the graph lies below the x-axis on the right and below it on the left.
Rationales: A: This reverses the side on both ends. At x = 1000 the value is about −9.99e−07 and at x = −1000 it is about −1.001e−06, which puts the graph below the axis on the right and below it on the left. B: This gets the right end wrong. For a large positive input such as x = 1000 the value of R is about −9.99e−07, which is negative, so the graph is below the x-axis there. D: This gets the left end wrong. For a large negative input such as x = −1000 the value of R is about −1.001e−06, which is negative, so the graph is below the x-axis there.

**N-1.7-B-v3.** Let R(x) = (x − 1)²(2x + 3) / ((x² + 1)(x² − 5)). Which statement describes the end behavior of R?

- **A. R(x) approaches 0 from above as x → ∞ and from below as x → −∞**
- B. R(x) approaches 0 from above as x → ∞ and from above as x → −∞
- C. R(x) approaches 0 from below as x → ∞ and from above as x → −∞
- D. R(x) approaches 0 from below as x → ∞ and from below as x → −∞

Check: The denominator has the greater degree, so R(x) → 0. The sign of R for large |x| is the sign of the ratio of leading terms, which gives about 0.001999 at x = 1000 and −0.002001 at x = −1000, so the graph lies above the x-axis on the right and below it on the left.
Rationales: B: This gets the left end wrong. For a large negative input such as x = −1000 the value of R is about −0.002001, which is negative, so the graph is below the x-axis there. C: This reverses the side on both ends. At x = 1000 the value is about 0.001999 and at x = −1000 it is about −0.002001, which puts the graph above the axis on the right and below it on the left. D: This gets the right end wrong. For a large positive input such as x = 1000 the value of R is about 0.001999, which is positive, so the graph is above the x-axis there.

