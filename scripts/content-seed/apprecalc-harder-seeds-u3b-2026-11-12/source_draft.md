# AP Precalculus topics 3.4 to 3.9: replacement seed drafts

DRAFT for owner review. Author-in-session; not checked by a checker; not in the database. All numeric values, orderings, asymptote sets and function matches were recomputed in Python (math module), including that exactly one choice is correct in every item.
Scope: the published practice MCQs for these topics that were one-step recall (graph description and domain/range, amplitude/midline reading, function evaluation, one-step asymptotes, exact inverse values) are replaced. Families judged R2 or better stay: 3.5 np2-006 (frequency to b), 3.6 043 (equation from features), 3.8 069 (end behavior from sine over cosine). Teaching items stay.

| Seed | Topic | Replaces |
|---|---|---|
| N-3.4-A | 3.4 Sine and Cosine Function Graphs | 067 and 068 families: combine increasing/decreasing with concavity on a quarter-period of a sine or cosine graph, including a reflected curve. |
| N-3.4-B | 3.4 Sine and Cosine Function Graphs | new: order values of sine or cosine at inputs spread over more than one period segment, using rise and fall of the graph rather than input order. |
| N-3.5-A | 3.5 Sinusoidal Functions | 016 family: build the equation of a sinusoid from a maximum point and the adjacent minimum point (amplitude, midline, half period to b, phase). |
| N-3.5-B | 3.5 Sinusoidal Functions | 016 family: use periodicity and midline symmetry of a sinusoid to decide which function value statement must hold at inputs far from the given points. |
| N-3.6-A | 3.6 Sinusoidal Function Transformations | new: translate a verbal list of transformations of y = sin x into an equation, handling the order of horizontal dilation and horizontal shift. |
| N-3.6-B | 3.6 Sinusoidal Function Transformations | new: locate the first maximum of a reflected or phase-shifted cosine transformation with horizontal compression, handling the sign of the leading coefficient and the scaling of the phase term. |
| N-3.7-A | 3.7 Sinusoidal Function Context and Data Modeling | 045 family: choose the cosine model that fits a described context (starting position or time of an extreme, range, period), with sign, b and shift each a common error. |
| N-3.7-B | 3.7 Sinusoidal Function Context and Data Modeling | 045 family: find and interpret the average rate of change between a maximum and the next minimum of a sinusoidal model (half a period), and avoid the full-period zero. |
| N-3.8-A | 3.8 The Tangent Function | 070 family: find every vertical asymptote of a tangent with horizontal dilation and phase shift, including the spacing between asymptotes. |
| N-3.8-B | 3.8 The Tangent Function | 070 family: determine whether a transformed tangent goes to +∞ or −∞ approaching an asymptote from a given side, using the signs of the stretch factor and of b. |
| N-3.9-A | 3.9 Inverse Trigonometric Functions | 018 family: evaluate arcsin, arccos or arctan of the matching trigonometric function at an angle outside the principal range, instead of cancelling naively. |
| N-3.9-B | 3.9 Inverse Trigonometric Functions | 018 family: evaluate a trigonometric function of an inverse trigonometric value, using the principal range to fix the sign. |

---

## Seed N-3.4-A (067 and 068 families) — Topic 3.4 Sine and Cosine Function Graphs
**Skill:** combine increasing/decreasing with concavity on a quarter-period of a sine or cosine graph, including a reflected curve.

On the interval 0 < x < 2π, which open interval of the graph of y = sin x is both increasing and concave down?

- **A. (0, π/2)**
- B. (π/2, π)
- C. (π, 3π/2)
- D. (3π/2, 2π)

Check: For y = sin x the slope sign and second-derivative sign by quadrant give increasing and concave down only on (0, π/2).
Rationales: B: On (π/2, π) the graph is concave down there but it is decreasing, so only one of the two conditions holds. C: On (π, 3π/2) the graph is decreasing and concave up there, which meets neither condition. D: On (3π/2, 2π) the graph is increasing there but it is concave up, so only one of the two conditions holds.

**N-3.4-A-v1.** On the interval 0 < x < 2π, which open interval of the graph of y = cos x is both decreasing and concave up?

- A. (0, π/2)
- **B. (π/2, π)**
- C. (π, 3π/2)
- D. (3π/2, 2π)

Check: For y = cos x the slope sign and second-derivative sign by quadrant give decreasing and concave up only on (π/2, π).
Rationales: A: On (0, π/2) the graph is decreasing there but it is concave down, so only one of the two conditions holds. C: On (π, 3π/2) the graph is concave up there but it is increasing, so only one of the two conditions holds. D: On (3π/2, 2π) the graph is increasing and concave down there, which meets neither condition.

**N-3.4-A-v2.** On the interval 0 < x < 2π, which open interval of the graph of y = sin x is both decreasing and concave up?

- A. (0, π/2)
- B. (π/2, π)
- **C. (π, 3π/2)**
- D. (3π/2, 2π)

Check: For y = sin x the slope sign and second-derivative sign by quadrant give decreasing and concave up only on (π, 3π/2).
Rationales: A: On (0, π/2) the graph is increasing and concave down there, which meets neither condition. B: On (π/2, π) the graph is decreasing there but it is concave down, so only one of the two conditions holds. D: On (3π/2, 2π) the graph is concave up there but it is increasing, so only one of the two conditions holds.

**N-3.4-A-v3.** On the interval 0 < x < 2π, which open interval of the graph of y = cos x is both increasing and concave down?

- A. (0, π/2)
- B. (π/2, π)
- C. (π, 3π/2)
- **D. (3π/2, 2π)**

Check: For y = cos x the slope sign and second-derivative sign by quadrant give increasing and concave down only on (3π/2, 2π).
Rationales: A: On (0, π/2) the graph is concave down there but it is decreasing, so only one of the two conditions holds. B: On (π/2, π) the graph is decreasing and concave up there, which meets neither condition. C: On (π, 3π/2) the graph is increasing there but it is concave up, so only one of the two conditions holds.

---

## Seed N-3.4-B (new) — Topic 3.4 Sine and Cosine Function Graphs
**Skill:** order values of sine or cosine at inputs spread over more than one period segment, using rise and fall of the graph rather than input order.

Which list orders the values cos(1), cos(2.5), cos(4), cos(5.5) from least to greatest? (Inputs are in radians.)

- A. cos(1) < cos(2.5) < cos(4) < cos(5.5)
- B. cos(5.5) < cos(4) < cos(2.5) < cos(1)
- **C. cos(2.5) < cos(4) < cos(1) < cos(5.5)**
- D. cos(1) < cos(4) < cos(5.5) < cos(2.5)

Check: Values: cos(1) ≈ 0.540, cos(2.5) ≈ −0.801, cos(4) ≈ −0.654, cos(5.5) ≈ 0.709; ascending order is cos(2.5) < cos(4) < cos(1) < cos(5.5).
Rationales: A: This lists the values in the order of the inputs, which assumes cos keeps increasing as its input increases; the graph rises and falls over these inputs. B: This reverses the input order, which assumes cos keeps decreasing as the input increases; the graph rises and falls over these inputs. D: This orders by distance from zero, ignoring that negative values are less than positive values.

**N-3.4-B-v1.** Which list orders the values sin(0.5), sin(2), sin(4), sin(5.5) from least to greatest? (Inputs are in radians.)

- A. sin(0.5) < sin(2) < sin(4) < sin(5.5)
- B. sin(5.5) < sin(4) < sin(2) < sin(0.5)
- C. sin(0.5) < sin(5.5) < sin(4) < sin(2)
- **D. sin(4) < sin(5.5) < sin(0.5) < sin(2)**

Check: Values: sin(0.5) ≈ 0.479, sin(2) ≈ 0.909, sin(4) ≈ −0.757, sin(5.5) ≈ −0.706; ascending order is sin(4) < sin(5.5) < sin(0.5) < sin(2).
Rationales: A: This lists the values in the order of the inputs, which assumes sin keeps increasing as its input increases; the graph rises and falls over these inputs. B: This reverses the input order, which assumes sin keeps decreasing as the input increases; the graph rises and falls over these inputs. C: This orders by distance from zero, ignoring that negative values are less than positive values.

**N-3.4-B-v2.** Which list orders the values cos(2), cos(3.5), cos(5), cos(6.5) from least to greatest? (Inputs are in radians.)

- **A. cos(3.5) < cos(2) < cos(5) < cos(6.5)**
- B. cos(2) < cos(3.5) < cos(5) < cos(6.5)
- C. cos(6.5) < cos(5) < cos(3.5) < cos(2)
- D. cos(5) < cos(2) < cos(3.5) < cos(6.5)

Check: Values: cos(2) ≈ −0.416, cos(3.5) ≈ −0.936, cos(5) ≈ 0.284, cos(6.5) ≈ 0.977; ascending order is cos(3.5) < cos(2) < cos(5) < cos(6.5).
Rationales: B: This lists the values in the order of the inputs, which assumes cos keeps increasing as its input increases; the graph rises and falls over these inputs. C: This reverses the input order, which assumes cos keeps decreasing as the input increases; the graph rises and falls over these inputs. D: This orders by distance from zero, ignoring that negative values are less than positive values.

**N-3.4-B-v3.** Which list orders the values sin(1), sin(3), sin(4.5), sin(6) from least to greatest? (Inputs are in radians.)

- A. sin(1) < sin(3) < sin(4.5) < sin(6)
- **B. sin(4.5) < sin(6) < sin(3) < sin(1)**
- C. sin(6) < sin(4.5) < sin(3) < sin(1)
- D. sin(3) < sin(6) < sin(1) < sin(4.5)

Check: Values: sin(1) ≈ 0.841, sin(3) ≈ 0.141, sin(4.5) ≈ −0.978, sin(6) ≈ −0.279; ascending order is sin(4.5) < sin(6) < sin(3) < sin(1).
Rationales: A: This lists the values in the order of the inputs, which assumes sin keeps increasing as its input increases; the graph rises and falls over these inputs. C: This reverses the input order, which assumes sin keeps decreasing as the input increases; the graph rises and falls over these inputs. D: This orders by distance from zero, ignoring that negative values are less than positive values.

---

## Seed N-3.5-A (016 family) — Topic 3.5 Sinusoidal Functions
**Skill:** build the equation of a sinusoid from a maximum point and the adjacent minimum point (amplitude, midline, half period to b, phase).

A sinusoidal function f has a maximum point at (2, 11) and its next minimum point at (8, 3). Which equation defines f?

- A. y = 4cos(π(x − 2)/3) + 7
- **B. y = 4cos(π(x − 2)/6) + 7**
- C. y = 8cos(π(x − 2)/6) + 7
- D. y = 4sin(π(x − 2)/6) + 7

Check: Amplitude = (11 − 3)/2 = 4; midline y = 7; half period 6 so period 12 and b = π/6; a maximum at x = 2 gives cosine shifted 2.
Rationales: A: This uses the distance between the two points as the full period, but it is only half a period, so the argument should be π(x − h)/6 and the graph repeats too quickly. C: This takes the whole distance between the maximum and minimum values as the amplitude, but the amplitude is half of that distance, so the graph overshoots the given points. D: This uses sine with the shift of the maximum, but sin(0) = 0 puts the midline value at x = 2 instead of the maximum.

**N-3.5-A-v1.** A sinusoidal function f has a minimum point at (3, 2) and its next maximum point at (10, 12). Which equation defines f?

- A. y = −5cos(π(x − 3)/3.5) + 7
- B. y = −10cos(π(x − 3)/7) + 7
- **C. y = −5cos(π(x − 3)/7) + 7**
- D. y = 5cos(π(x − 3)/7) + 7

Check: Amplitude = (12 − 2)/2 = 5; midline y = 7; half period 7 so period 14 and b = π/7; a minimum at x = 3 gives a negative cosine shifted 3.
Rationales: A: This uses the distance between the two points as the full period, but it is only half a period, so the argument should be π(x − h)/7 and the graph repeats too quickly. B: This takes the whole distance between the maximum and minimum values as the amplitude, but the amplitude is half of that distance, so the graph overshoots the given points. D: This uses the cosine curve with a positive sign, so it has a maximum, not a minimum, at x = 3.

**N-3.5-A-v2.** A sinusoidal function f has a maximum point at (5, 8) and its next minimum point at (9, −4). Which equation defines f?

- A. y = 6cos(π(x − 5)/2) + 2
- B. y = 12cos(π(x − 5)/4) + 2
- C. y = 6sin(π(x − 5)/4) + 2
- **D. y = 6cos(π(x − 5)/4) + 2**

Check: Amplitude = (8 − −4)/2 = 6; midline y = 2; half period 4 so period 8 and b = π/4; a maximum at x = 5 gives cosine shifted 5.
Rationales: A: This uses the distance between the two points as the full period, but it is only half a period, so the argument should be π(x − h)/4 and the graph repeats too quickly. B: This takes the whole distance between the maximum and minimum values as the amplitude, but the amplitude is half of that distance, so the graph overshoots the given points. C: This uses sine with the shift of the maximum, but sin(0) = 0 puts the midline value at x = 5 instead of the maximum.

**N-3.5-A-v3.** A sinusoidal function f has a minimum point at (4, 1) and its next maximum point at (6, 9). Which equation defines f?

- **A. y = −4cos(π(x − 4)/2) + 5**
- B. y = −4cos(π(x − 4)/1) + 5
- C. y = −8cos(π(x − 4)/2) + 5
- D. y = 4cos(π(x − 4)/2) + 5

Check: Amplitude = (9 − 1)/2 = 4; midline y = 5; half period 2 so period 4 and b = π/2; a minimum at x = 4 gives a negative cosine shifted 4.
Rationales: B: This uses the distance between the two points as the full period, but it is only half a period, so the argument should be π(x − h)/2 and the graph repeats too quickly. C: This takes the whole distance between the maximum and minimum values as the amplitude, but the amplitude is half of that distance, so the graph overshoots the given points. D: This uses the cosine curve with a positive sign, so it has a maximum, not a minimum, at x = 4.

---

## Seed N-3.5-B (016 family) — Topic 3.5 Sinusoidal Functions
**Skill:** use periodicity and midline symmetry of a sinusoid to decide which function value statement must hold at inputs far from the given points.

A sinusoidal function g has a minimum value of 3 at x = 1, and its next maximum value of 11 occurs at x = 5. Which statement must be true?

- **A. g(3) = 7**
- B. g(9) = 11
- C. g(7) = 3
- D. g(13) = 3

Check: Period = 8, midline 7. x = 3 is a quarter or three quarters of a period from an extreme point, which is where the graph crosses its midline, so the value there is 7.
Rationales: B: Not guaranteed: x = 9 is a whole number of periods from the minimum at x = 1, so the value there is the minimum, 3, not 11. C: Not guaranteed: x = 7 is a quarter or three quarters of a period from an extreme point, which is where the graph crosses its midline, so the value there is 7, not 3. D: Not guaranteed: x = 13 is an odd number of half periods from the minimum at x = 1, so the value there is the maximum, 11, not 3.

**N-3.5-B-v1.** A sinusoidal function g has a minimum value of −2 at x = 2, and its next maximum value of 10 occurs at x = 8. Which statement must be true?

- A. g(14) = 10
- **B. g(20) = 10**
- C. g(11) = −2
- D. g(5) = 10

Check: Period = 12, midline 4. x = 20 is an odd number of half periods from the minimum at x = 2, so the value there is the maximum, 10.
Rationales: A: Not guaranteed: x = 14 is a whole number of periods from the minimum at x = 2, so the value there is the minimum, −2, not 10. C: Not guaranteed: x = 11 is a quarter or three quarters of a period from an extreme point, which is where the graph crosses its midline, so the value there is 4, not −2. D: Not guaranteed: x = 5 is a quarter or three quarters of a period from an extreme point, which is where the graph crosses its midline, so the value there is 4, not 10.

**N-3.5-B-v2.** A sinusoidal function g has a maximum value of 13 at x = 3, and its next minimum value of 5 occurs at x = 7. Which statement must be true?

- A. g(9) = 13
- B. g(11) = 5
- **C. g(5) = 9**
- D. g(15) = 9

Check: Period = 8, midline 9. x = 5 is a quarter or three quarters of a period from an extreme point, which is where the graph crosses its midline, so the value there is 9.
Rationales: A: Not guaranteed: x = 9 is a quarter or three quarters of a period from an extreme point, which is where the graph crosses its midline, so the value there is 9, not 13. B: Not guaranteed: x = 11 is a whole number of periods from the maximum at x = 3, so the value there is the maximum, 13, not 5. D: Not guaranteed: x = 15 is an odd number of half periods from the maximum at x = 3, so the value there is the minimum, 5, not 9.

**N-3.5-B-v3.** A sinusoidal function g has a minimum value of 0 at x = 2, and its next maximum value of 8 occurs at x = 11. Which statement must be true?

- A. g(20) = 8
- B. g(15.5) = 0
- C. g(29) = 0
- **D. g(6.5) = 4**

Check: Period = 18, midline 4. x = 6.5 is a quarter or three quarters of a period from an extreme point, which is where the graph crosses its midline, so the value there is 4.
Rationales: A: Not guaranteed: x = 20 is a whole number of periods from the minimum at x = 2, so the value there is the minimum, 0, not 8. B: Not guaranteed: x = 15.5 is a quarter or three quarters of a period from an extreme point, which is where the graph crosses its midline, so the value there is 4, not 0. C: Not guaranteed: x = 29 is an odd number of half periods from the minimum at x = 2, so the value there is the maximum, 8, not 0.

---

## Seed N-3.6-A (new) — Topic 3.6 Sinusoidal Function Transformations
**Skill:** translate a verbal list of transformations of y = sin x into an equation, handling the order of horizontal dilation and horizontal shift.

The graph of y = sin x is stretched vertically by a factor of 3, compressed horizontally so that its period is π, and then translated right π/4 and up 2. Which equation describes the new graph?

- A. y = 3 sin(2x − π/4) + 2
- B. y = 3 sin(2(x + π/4)) + 2
- C. y = 3 sin((x − π/4)/2) + 2
- **D. y = 3 sin(2(x − π/4)) + 2**

Check: Amplitude 3, b = 2π/π = 2, right shift π/4 gives sin(2(x − π/4)), up 2.
Rationales: A: This subtracts π/4 after multiplying by 2, which shifts the graph right only π/8, not π/4. B: This has a plus sign inside the parentheses, which shifts the graph left π/4 instead of right. C: This divides x by 2, which stretches the period to 4π, but a period of π needs b = 2π/π = 2.

**N-3.6-A-v1.** The graph of y = sin x is reflected across the x-axis, stretched vertically by a factor of 5, stretched horizontally so that its period is 4π, and then translated left π and down 1. Which equation describes the new graph?

- **A. y = −5 sin((x + π)/2) − 1**
- B. y = −5 sin(x/2 + π) − 1
- C. y = −5 sin((x − π)/2) − 1
- D. y = −5 sin(2(x + π)) − 1

Check: Reflection gives −5, b = 2π/4π = 1/2, left shift π gives (x + π)/2, down 1.
Rationales: B: This adds π after dividing by 2, which shifts the graph left 2π, not π. C: This has a minus sign inside the parentheses, which shifts the graph right π instead of left. D: This uses b = 2, which gives a period of π, but a period of 4π needs b = 2π/4π = 1/2.

**N-3.6-A-v2.** The graph of y = sin x is stretched vertically by a factor of 4, compressed horizontally so that its period is 2π/3, and then translated right π/6 and down 3. Which equation describes the new graph?

- A. y = 4 sin(3x − π/6) − 3
- **B. y = 4 sin(3(x − π/6)) − 3**
- C. y = 4 sin(3(x + π/6)) − 3
- D. y = 4 sin((x − π/6)/3) − 3

Check: Amplitude 4, b = 2π/(2π/3) = 3, right shift π/6 gives sin(3(x − π/6)), down 3.
Rationales: A: This subtracts π/6 after multiplying by 3, which shifts the graph right only π/18, not π/6. C: This has a plus sign inside the parentheses, which shifts the graph left π/6 instead of right. D: This divides x by 3, which stretches the period to 6π, but a period of 2π/3 needs b = 3.

**N-3.6-A-v3.** The graph of y = sin x is stretched vertically by a factor of 2, stretched horizontally so that its period is 8, and then translated left 2 units and up 1. Which equation describes the new graph?

- A. y = 2 sin(πx/4 + 2) + 1
- B. y = 2 sin(π(x − 2)/4) + 1
- **C. y = 2 sin(π(x + 2)/4) + 1**
- D. y = 2 sin(8(x + 2)) + 1

Check: b = 2π/8 = π/4; left 2 gives (x + 2); amplitude 2; up 1.
Rationales: A: This adds 2 after multiplying by π/4, which shifts the graph left 8/π units, not 2 units. B: This has a minus sign inside the parentheses, which shifts the graph right 2 instead of left. D: This uses the period 8 as the value of b, but b = 2π/8 = π/4.

---

## Seed N-3.6-B (new) — Topic 3.6 Sinusoidal Function Transformations
**Skill:** locate the first maximum of a reflected or phase-shifted cosine transformation with horizontal compression, handling the sign of the leading coefficient and the scaling of the phase term.

The function f is defined by f(x) = −3cos(2x + π/3) + 1. What is the least positive value of x at which f attains its maximum value?

- A. 5π/6
- B. π/6
- **C. π/3**
- D. π/12

Check: Maximum (4) needs cos(2x + π/3) = −1, so 2x + π/3 = π + 2πk, giving x = π/3 for the least positive value (f there = 4).
Rationales: A: This solves the argument equal to 0 mod 2π, which is where the unreflected cosine peaks; the negative sign makes f maximum where the cosine equals −1. B: This divides only the π by b and subtracts c unscaled, but the shift c must also be divided by b. D: This adds a quarter period to the phase shift, which locates a midline crossing of a sine curve, not the maximum of this cosine curve.

**N-3.6-B-v1.** The function f is defined by f(x) = 5cos(3x − π/3) − 2. What is the least positive value of x at which f attains its maximum value?

- A. 4π/9
- B. π/3
- C. 5π/18
- **D. π/9**

Check: Maximum (3) needs cos(3x − π/3) = 1, so 3x − π/3 = 0 + 2πk, giving x = π/9 for the least positive value (f there = 3).
Rationales: A: This uses the argument equal to π, which is where cosine is −1; with a positive coefficient the maximum is where the cosine equals 1. B: This divides only the 0 by b and subtracts c unscaled, but the shift c must also be divided by b. C: This adds a quarter period to the phase shift, which locates a midline crossing of a sine curve, not the maximum of this cosine curve.

**N-3.6-B-v2.** The function f is defined by f(x) = −2cos(4x + π/4) + 3. What is the least positive value of x at which f attains its maximum value?

- **A. 3π/16**
- B. 7π/16
- C. π/2
- D. π/16

Check: Maximum (5) needs cos(4x + π/4) = −1, so 4x + π/4 = π + 2πk, giving x = 3π/16 for the least positive value (f there = 5).
Rationales: B: This solves the argument equal to 0 mod 2π, which is where the unreflected cosine peaks; the negative sign makes f maximum where the cosine equals −1. C: This divides only the π by b and subtracts c unscaled, but the shift c must also be divided by b. D: This adds a quarter period to the phase shift, which locates a midline crossing of a sine curve, not the maximum of this cosine curve.

**N-3.6-B-v3.** The function f is defined by f(x) = 4cos(2x − π/6). What is the least positive value of x at which f attains its maximum value?

- A. 7π/12
- **B. π/12**
- C. π/6
- D. π/3

Check: Maximum (4) needs cos(2x − π/6) = 1, so 2x − π/6 = 0 + 2πk, giving x = π/12 for the least positive value (f there = 4).
Rationales: A: This uses the argument equal to π, which is where cosine is −1; with a positive coefficient the maximum is where the cosine equals 1. C: This divides only the 0 by b and subtracts c unscaled, but the shift c must also be divided by b. D: This adds a quarter period to the phase shift, which locates a midline crossing of a sine curve, not the maximum of this cosine curve.

---

## Seed N-3.7-A (045 family) — Topic 3.7 Sinusoidal Function Context and Data Modeling
**Skill:** choose the cosine model that fits a described context (starting position or time of an extreme, range, period), with sign, b and shift each a common error.

A Ferris wheel has diameter 40 meters and its center is 22 meters above the ground. It makes one full rotation every 30 seconds. A rider boards at the lowest point of the wheel at time t = 0 seconds. Which function gives the rider's height h(t), in meters above the ground, at time t seconds?

- A. h(t) = 20 cos(πt/15) + 22
- **B. h(t) = −20 cos(πt/15) + 22**
- C. h(t) = −20 cos(πt/30) + 22
- D. h(t) = 20 sin(πt/15) + 22

Check: Amplitude 20, midline 22, b = 2π/30 = π/15; starting at the minimum requires −cos: h(0) = −20 + 22 = 2.
Rationales: A: This has the correct amplitude, midline and period, but with a positive cosine the rider starts at the top, 42 meters, instead of at the lowest point. C: This uses b = π/30, which has period 60 seconds, as if the 30 seconds were half a rotation; b should be 2π/30 = π/15. D: This has the right amplitude, midline and period, but sine starts at the midline, 22 meters, not the lowest point 2 meters.

**N-3.7-A-v1.** At a harbor, the water height is at its highest, 7.4 meters, at time t = 0 hours, and at its lowest, 1.2 meters, 6.2 hours later. The pattern repeats every 12.4 hours. Which function gives the water height H(t), in meters, at time t hours?

- A. H(t) = −3.1 cos(πt/6.2) + 4.3
- B. H(t) = 3.1 cos(πt/12.4) + 4.3
- **C. H(t) = 3.1 cos(πt/6.2) + 4.3**
- D. H(t) = 3.1 sin(πt/6.2) + 4.3

Check: Amplitude (7.4 − 1.2)/2 = 3.1; midline 4.3; b = 2π/12.4 = π/6.2; maximum at t = 0 requires +cos.
Rationales: A: This has the correct amplitude, midline and period, but with a negative cosine the water starts at its lowest height, not its highest. B: This uses b = π/12.4, which has period 24.8 hours, twice the stated 12.4 hours; b should be 2π/12.4 = π/6.2. D: This has the right amplitude, midline and period, but sine starts at the midline, 4.3, not at the highest height 7.4.

**N-3.7-A-v2.** In a greenhouse, the temperature is lowest, 14 degrees Celsius, at 4 a.m. and highest, 30 degrees Celsius, 12 hours later. The pattern repeats every 24 hours. Which function gives the temperature C(t), where t is hours after midnight?

- A. C(t) = 8 cos(π(t − 4)/12) + 22
- B. C(t) = −8 cos(π(t − 4)/24) + 22
- C. C(t) = −8 cos(πt/12) + 22
- **D. C(t) = −8 cos(π(t − 4)/12) + 22**

Check: Amplitude 8, midline 22, b = π/12; the minimum is at t = 4, so −cos with argument π(t − 4)/12.
Rationales: A: This has the right shift, amplitude, midline and period, but a positive cosine puts the maximum, not the minimum, at t = 4. B: This uses b = π/24, which has period 48 hours; for a 24 hour period b should be 2π/24 = π/12. C: This leaves out the horizontal shift, so the minimum occurs at t = 0 (midnight), not at 4 a.m.

**N-3.7-A-v3.** In a northern city, the length of the day is longest, 15 hours, in mid-June, at t = 5.5 months after January 1, and shortest, 9 hours, six months later. The pattern repeats every 12 months. Which function gives the day length D(t), in hours, at time t months after January 1?

- **A. D(t) = 3 cos(π(t − 5.5)/6) + 12**
- B. D(t) = −3 cos(π(t − 5.5)/6) + 12
- C. D(t) = 3 cos(π(t − 5.5)/12) + 12
- D. D(t) = 3 cos(πt/6) + 12

Check: Amplitude 3, midline 12, b = π/6; the maximum at t = 5.5 means +cos with argument π(t − 5.5)/6.
Rationales: B: This has the right shift, amplitude, midline and period, but a negative cosine makes t = 5.5 the shortest day, not the longest. C: This uses b = π/12, which has period 24 months; for a 12 month period b should be 2π/12 = π/6. D: This leaves out the horizontal shift, so the longest day occurs at t = 0 (January 1), not in mid-June.

---

## Seed N-3.7-B (045 family) — Topic 3.7 Sinusoidal Function Context and Data Modeling
**Skill:** find and interpret the average rate of change between a maximum and the next minimum of a sinusoidal model (half a period), and avoid the full-period zero.

The temperature, in degrees Fahrenheit, in a warehouse is modeled by T(t) = 60 + 15 cos(π(t − 14)/12), where t is hours after midnight. What is the average rate of change of T from the time of the day's highest temperature to the time of the next lowest temperature?

- **A. −2.5 degrees per hour**
- B. −1.25 degrees per hour
- C. 2.5 degrees per hour
- D. 0 degrees per hour

Check: Maximum 75 at t = 14, next minimum 45 at t = 26: (45 − 75)/12 = −2.5 degrees per hour.
Rationales: B: This divides the total drop of 2R by the full period instead of by the half period that actually elapses from the maximum to the next minimum. C: This has the correct size but the wrong sign; the value falls from its maximum to its minimum, so the average rate is negative. D: This treats the interval as a full period, where the average rate of change is 0; but a maximum to the next minimum is only half a period and the value falls.

**N-3.7-B-v1.** The depth, in feet, of water in a reservoir is modeled by H(t) = 20 + 6 sin(π(t − 1)/4), where t is in days. What is the average rate of change of H from the time of its maximum depth to the time of its next minimum depth?

- A. −1.5 feet per day
- **B. −3 feet per day**
- C. 3 feet per day
- D. 0 feet per day

Check: Maximum 26 at t = 3, next minimum 14 at t = 7: (14 − 26)/4 = −3 feet per day.
Rationales: A: This divides the total drop of 2R by the full period instead of by the half period that actually elapses from the maximum to the next minimum. C: This has the correct size but the wrong sign; the value falls from its maximum to its minimum, so the average rate is negative. D: This treats the interval as a full period, where the average rate of change is 0; but a maximum to the next minimum is only half a period and the value falls.

**N-3.7-B-v2.** A deer population, in hundreds, is modeled by N(t) = 40 − 12 cos(πt/3), where t is in years. What is the average rate of change of N from the time of its maximum to the time of its next minimum, in hundreds of deer per year?

- A. −4 hundred deer per year
- B. 8 hundred deer per year
- **C. −8 hundred deer per year**
- D. 0 hundred deer per year

Check: Maximum 52 at t = 3, next minimum 28 at t = 6: (28 − 52)/3 = −8 hundred deer per year.
Rationales: A: This divides the total drop of 2R by the full period instead of by the half period that actually elapses from the maximum to the next minimum. B: This has the correct size but the wrong sign; the value falls from its maximum to its minimum, so the average rate is negative. D: This treats the interval as a full period, where the average rate of change is 0; but a maximum to the next minimum is only half a period and the value falls.

**N-3.7-B-v3.** The depth, in meters, of the water at a pier is modeled by D(t) = 7 + 3 cos(π(t − 2)/6), where t is in hours. What is the average rate of change of D from the time of high tide to the time of the next low tide?

- A. −0.5 meters per hour
- B. 1 meters per hour
- C. 0 meters per hour
- **D. −1 meters per hour**

Check: Maximum 10 at t = 2, next minimum 4 at t = 8: (4 − 10)/6 = −1 meters per hour.
Rationales: A: This divides the total drop of 2R by the full period instead of by the half period that actually elapses from the maximum to the next minimum. B: This has the correct size but the wrong sign; the value falls from its maximum to its minimum, so the average rate is negative. C: This treats the interval as a full period, where the average rate of change is 0; but a maximum to the next minimum is only half a period and the value falls.

---

## Seed N-3.8-A (070 family) — Topic 3.8 The Tangent Function
**Skill:** find every vertical asymptote of a tangent with horizontal dilation and phase shift, including the spacing between asymptotes.

What is the complete set of vertical asymptotes of the graph of y = 2tan(2x + π/3) − 1, where k is any integer?

- A. x = π/4 + kπ/2
- B. x = 5π/12 + kπ/2
- C. x = π/12 + kπ
- **D. x = π/12 + kπ/2**

Check: Asymptotes where 2x + π/3 = π/2 + kπ, so x = (π/2 − (π/3) + kπ)/b; first asymptote π/12, spacing π/2: x = π/12 + kπ/2.
Rationales: A: This sets the inside expression equal to π/2 + kπ but forgets the phase term, so the asymptotes are not shifted. B: This divides only the π/2 by b and subtracts the phase term unscaled; the whole of π/2 − c must be divided by b. C: This finds one asymptote correctly but spaces them by π; spacing is the period π/b, so most asymptotes are missed.

**N-3.8-A-v1.** What is the complete set of vertical asymptotes of the graph of y = 3tan(3x + π/4) + 1, where k is any integer?

- **A. x = π/12 + kπ/3**
- B. x = π/6 + kπ/3
- C. x = π/4 + kπ/3
- D. x = π/12 + kπ

Check: Asymptotes where 3x + π/4 = π/2 + kπ, so x = (π/2 − (π/4) + kπ)/b; first asymptote π/12, spacing π/3: x = π/12 + kπ/3.
Rationales: B: This sets the inside expression equal to π/2 + kπ but forgets the phase term, so the asymptotes are not shifted. C: This divides only the π/2 by b and subtracts the phase term unscaled; the whole of π/2 − c must be divided by b. D: This finds one asymptote correctly but spaces them by π; spacing is the period π/b, so most asymptotes are missed.

**N-3.8-A-v2.** What is the complete set of vertical asymptotes of the graph of y = −tan(x/2 − π/4), where k is any integer?

- A. x = π + 2kπ
- **B. x = 3π/2 + 2kπ**
- C. x = 5π/4 + 2kπ
- D. x = π/2 + kπ

Check: Asymptotes where x/2 − π/4 = π/2 + kπ, so x = (π/2 − (−π/4) + kπ)/b; first asymptote 3π/2, spacing 2π: x = 3π/2 + 2kπ.
Rationales: A: This sets the inside expression equal to π/2 + kπ but forgets the phase term, so the asymptotes are not shifted. C: This divides only the π/2 by b and subtracts the phase term unscaled; the whole of π/2 − c must be divided by b. D: This finds one asymptote correctly but spaces them by π; spacing is the period π/b, so most asymptotes are missed.

**N-3.8-A-v3.** What is the complete set of vertical asymptotes of the graph of y = 4tan(2x − π/3) + 2, where k is any integer?

- A. x = π/4 + kπ/2
- B. x = π/12 + kπ/2
- **C. x = 5π/12 + kπ/2**
- D. x = 5π/12 + kπ

Check: Asymptotes where 2x − π/3 = π/2 + kπ, so x = (π/2 − (−π/3) + kπ)/b; first asymptote 5π/12, spacing π/2: x = 5π/12 + kπ/2.
Rationales: A: This sets the inside expression equal to π/2 + kπ but forgets the phase term, so the asymptotes are not shifted. B: This divides only the π/2 by b and subtracts the phase term unscaled; the whole of π/2 − c must be divided by b. D: This finds one asymptote correctly but spaces them by π; spacing is the period π/b, so most asymptotes are missed.

---

## Seed N-3.8-B (070 family) — Topic 3.8 The Tangent Function
**Skill:** determine whether a transformed tangent goes to +∞ or −∞ approaching an asymptote from a given side, using the signs of the stretch factor and of b.

The function g is defined by g(x) = −3tan(x − π/4) + 1. The graph of g has a vertical asymptote at x = 3π/4. What happens to g(x) as x approaches 3π/4 from the left?

- A. g(x) increases without bound.
- B. g(x) approaches 1, the vertical shift.
- **C. g(x) decreases without bound.**
- D. g(x) approaches 0.

Check: Approaching from the left, the inside expression approaches an odd multiple of π/2 from below, so the tangent part goes to +∞; multiplying by −3 gives −∞. Numerical check: g at 1e−7 left of the asymptote is about −3e+07.
Rationales: A: This has the direction reversed: near this asymptote the tangent part goes to +∞, and the factor −3 flips that direction, so g goes to −∞. B: This treats the vertical shift as a horizontal asymptote, but a tangent graph has no horizontal asymptote; its values are unbounded near a vertical asymptote. D: This assumes the outputs settle at 0 near the asymptote, but the tangent function is undefined there and its values grow without bound in size.

**N-3.8-B-v1.** The function g is defined by g(x) = 2tan(2x) − 1. The graph of g has a vertical asymptote at x = π/4. What happens to g(x) as x approaches π/4 from the right?

- A. g(x) increases without bound.
- B. g(x) approaches −1, the vertical shift.
- C. g(x) approaches 0.
- **D. g(x) decreases without bound.**

Check: Approaching from the right, the inside expression approaches an odd multiple of π/2 from above, so the tangent part goes to −∞; multiplying by 2 gives −∞. Numerical check: g at 1e−7 right of the asymptote is about −1e+07.
Rationales: A: This has the direction reversed: near this asymptote the tangent part goes to −∞, and the factor 2 keeps that direction, so g goes to −∞. B: This treats the vertical shift as a horizontal asymptote, but a tangent graph has no horizontal asymptote; its values are unbounded near a vertical asymptote. C: This assumes the outputs settle at 0 near the asymptote, but the tangent function is undefined there and its values grow without bound in size.

**N-3.8-B-v2.** The function g is defined by g(x) = 4tan(x/2 + π/6) − 2. The graph of g has a vertical asymptote at x = 2π/3. What happens to g(x) as x approaches 2π/3 from the left?

- **A. g(x) increases without bound.**
- B. g(x) decreases without bound.
- C. g(x) approaches −2, the vertical shift.
- D. g(x) approaches 0.

Check: Approaching from the left, the inside expression approaches an odd multiple of π/2 from below, so the tangent part goes to +∞; multiplying by 4 gives +∞. Numerical check: g at 1e−7 left of the asymptote is about 8e+07.
Rationales: B: This has the direction reversed: near this asymptote the tangent part goes to +∞, and the factor 4 keeps that direction, so g goes to +∞. C: This treats the vertical shift as a horizontal asymptote, but a tangent graph has no horizontal asymptote; its values are unbounded near a vertical asymptote. D: This assumes the outputs settle at 0 near the asymptote, but the tangent function is undefined there and its values grow without bound in size.

**N-3.8-B-v3.** The function g is defined by g(x) = 3tan(−2x + π/6) + 2. The graph of g has a vertical asymptote at x = π/3. What happens to g(x) as x approaches π/3 from the right?

- A. g(x) decreases without bound.
- **B. g(x) increases without bound.**
- C. g(x) approaches 2, the vertical shift.
- D. g(x) approaches 0.

Check: Approaching from the right, the inside expression approaches an odd multiple of π/2 from below, so the tangent part goes to +∞; multiplying by 3 gives +∞. Numerical check: g at 1e−7 right of the asymptote is about 1.5e+07.
Rationales: A: This has the direction reversed: near this asymptote the tangent part goes to +∞, and the factor 3 keeps that direction, so g goes to +∞. C: This treats the vertical shift as a horizontal asymptote, but a tangent graph has no horizontal asymptote; its values are unbounded near a vertical asymptote. D: This assumes the outputs settle at 0 near the asymptote, but the tangent function is undefined there and its values grow without bound in size.

---

## Seed N-3.9-A (018 family) — Topic 3.9 Inverse Trigonometric Functions
**Skill:** evaluate arcsin, arccos or arctan of the matching trigonometric function at an angle outside the principal range, instead of cancelling naively.

What is the exact value of arcsin(sin(7π/6))?

- A. 7π/6
- **B. −π/6**
- C. π/6
- D. 5π/6

Check: sin(7π/6) = −1/2 and the angle in [−π/2, π/2] whose sine is −1/2 is −π/6.
Rationales: A: This cancels arcsin and sin directly, but arcsin only returns angles in [−π/2, π/2], and 7π/6 is outside that interval. C: This uses the reference angle with a positive sign; sin(7π/6) = −1/2, so the output must have a negative sine. D: This is an angle with sin(5π/6) = +1/2; the sine of 7π/6 is −1/2, and 5π/6 is also outside the range [−π/2, π/2].

**N-3.9-A-v1.** What is the exact value of arccos(cos(−2π/3))?

- A. −2π/3
- B. π/3
- **C. 2π/3**
- D. 4π/3

Check: cos(−2π/3) = −1/2 and the angle in [0, π] whose cosine is −1/2 is 2π/3.
Rationales: A: This cancels arccos and cos directly, but arccos only returns angles in [0, π], and −2π/3 is outside that interval. B: This uses the reference angle, but cos(π/3) = 1/2 while cos(−2π/3) = −1/2. D: This is an angle with the same cosine as −2π/3, but it is outside the range [0, π] of arccos.

**N-3.9-A-v2.** What is the exact value of arctan(tan(5π/6))?

- A. 5π/6
- B. π/6
- C. −5π/6
- **D. −π/6**

Check: tan(5π/6) = −√3/3 and the angle in (−π/2, π/2) with that tangent is −π/6.
Rationales: A: This cancels arctan and tan directly, but arctan only returns angles in (−π/2, π/2), and 5π/6 is outside that interval. B: This uses the reference angle with a positive sign; tan(5π/6) = −√3/3, so the output must be negative. C: This is outside (−π/2, π/2), and tan(−5π/6) = +√3/3, which has the wrong sign.

**N-3.9-A-v3.** What is the exact value of arccos(cos(7π/4))?

- **A. π/4**
- B. 7π/4
- C. −π/4
- D. 3π/4

Check: cos(7π/4) = √2/2 and the angle in [0, π] whose cosine is √2/2 is π/4.
Rationales: B: This cancels arccos and cos directly, but arccos only returns angles in [0, π], and 7π/4 is outside that interval. C: This is the angle in the fourth quadrant with the same cosine, but arccos never returns negative angles; its range is [0, π]. D: This is in [0, π], but cos(3π/4) = −√2/2, while cos(7π/4) = +√2/2.

---

## Seed N-3.9-B (018 family) — Topic 3.9 Inverse Trigonometric Functions
**Skill:** evaluate a trigonometric function of an inverse trigonometric value, using the principal range to fix the sign.

What is the exact value of sin(arccos(−3/5))?

- **A. 4/5**
- B. −4/5
- C. 3/5
- D. 4/3

Check: Let θ = arccos(−3/5), in [0, π]; cos θ = −3/5, so sin θ = √(1 − 9/25) = 4/5, positive in the second quadrant.
Rationales: B: This gives sine a negative sign because the cosine is negative, but arccos returns an angle in [0, π], where sine is never negative. C: This takes the magnitude of the given ratio, but the value asked for is the sine; the cosine is −3/5 and the sine is found from sin² = 1 − cos². D: This divides the sine 4/5 by the cosine magnitude 3/5, which gives a tangent-like ratio, not the sine.

**N-3.9-B-v1.** What is the exact value of cos(arcsin(−5/13))?

- A. −12/13
- **B. 12/13**
- C. 5/13
- D. 13/12

Check: Let θ = arcsin(−5/13), in [−π/2, π/2]; sin θ = −5/13, so cos θ = √(1 − 25/169) = 12/13, positive in the fourth quadrant.
Rationales: A: This gives cosine a negative sign because the sine is negative, but arcsin returns an angle in [−π/2, π/2], where cosine is never negative. C: This takes the magnitude of the given ratio, but the cosine is found from cos² = 1 − sin², giving 12/13. D: This is the reciprocal of the correct value 12/13, which would be the secant, not the cosine.

**N-3.9-B-v2.** What is the exact value of tan(arccos(−4/5))?

- A. 3/4
- B. −4/3
- **C. −3/4**
- D. 3/5

Check: Let θ = arccos(−4/5), in [0, π]; cos θ = −4/5, sin θ = 3/5 (positive), so tan θ = (3/5)/(−4/5) = −3/4.
Rationales: A: This drops the negative sign; the angle is in the second quadrant, where sine is positive and cosine is negative, so tangent is negative. B: This inverts the ratio, using adjacent over opposite; tangent is sine divided by cosine, which is (3/5)/(−4/5). D: This is the sine of the angle, not the tangent; the tangent is the sine divided by the cosine.

**N-3.9-B-v3.** What is the exact value of sin(arctan(−3/4))?

- A. 3/5
- B. −3/4
- C. −4/5
- **D. −3/5**

Check: Let θ = arctan(−3/4), in (−π/2, π/2); the legs are −3 and 4 with hypotenuse 5, so sin θ = −3/5.
Rationales: A: This drops the negative sign; arctan(−3/4) is in the fourth quadrant, where sine is negative. B: This is the tangent of the angle itself; the sine is the opposite side over the hypotenuse 5, which is −3/5. C: This is the cosine's magnitude with a negative sign; the sine is the opposite side −3 over the hypotenuse 5.

---
