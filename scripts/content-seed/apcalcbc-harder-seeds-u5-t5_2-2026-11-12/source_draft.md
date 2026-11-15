# AP Calculus AB and BC Unit 5 topic 5.2 — Extreme Value Theorem and Critical Points

DRAFT. Author-in-session 2026-11-12. Same questions for separate AB/BC packs. CED FUN-1.C.1–3.

---

## Seed N-5.2-A (new) — Topic 5.2 Extreme Value Theorem and Critical Points

**Skill:** check the closed-interval continuity condition and distinguish a guarantee from an actual extreme value



On [-1,1], let f(x)=x² for x≠0 and f(0)=1. A student invokes the Extreme Value Theorem to claim both absolute extrema exist. Which assessment is correct?



- **A. The theorem does not apply because f is discontinuous at 0; f has absolute maximum 1 but no absolute minimum on [-1,1].**

- B. The theorem applies because f is defined at every x, and the absolute minimum is 0 at x=0.

- C. The theorem does not apply, so neither an absolute maximum nor an absolute minimum can exist.

- D. The theorem applies because differentiability is unnecessary, and both extrema occur at the endpoints.



Check: As x approaches 0, x² approaches 0 but f(0)=1, so continuity fails. Every value is positive and values approach 0 without reaching it; the maximum 1 is attained at 0 and both endpoints.

Rationales: B: Being defined everywhere is not the same as continuity, and f(0)=1 rather than 0. C: Failure of EVT removes a guarantee; a maximum can still exist, and here it equals 1. D: EVT requires continuity, which fails at 0; endpoints alone do not supply a minimum here.



**N-5.2-A-v1.** Let g(x)=1/x on the closed interval [1,4]. Which conclusion correctly uses the Extreme Value Theorem and the function's behavior?



- **A. g is continuous on [1,4], so EVT applies; its absolute maximum is 1 at x=1 and its absolute minimum is 1/4 at x=4.**

- B. EVT fails because g is undefined at x=0, even though 0 is outside [1,4].

- C. EVT guarantees extrema only when the derivative is zero at an interior point.

- D. Both extreme values occur at x=0 because the derivative is undefined there.



Check: The interval [1,4] excludes the discontinuity at 0; 1/x is continuous there and decreasing, so endpoint values 1 and 1/4 are the absolute extrema.

Rationales: B: A discontinuity outside the interval does not violate continuity on [1,4]. C: EVT needs closed-interval continuity, not an interior stationary point; extrema can be endpoints. D: x=0 is outside the domain interval and cannot supply an extremum on [1,4].



**N-5.2-A-v2.** A function h(x)=x is considered on [0,2), including 0 but excluding 2. Which statement about its greatest value and EVT is correct?



- **A. EVT does not apply because the interval is not closed; h has a minimum 0, but no maximum because values approach 2 without attaining it.**

- B. EVT applies because h is continuous, and the maximum is 2 at x=2.

- C. EVT does not apply, so h cannot have either a minimum or maximum.

- D. The maximum is 1 because 2 is not included in the interval.



Check: The endpoint 2 is absent, so [0,2) is not a closed interval. h(0)=0 is attained, while values can be arbitrarily close to 2 without equaling it.

Rationales: B: Continuity alone is insufficient for EVT on a nonclosed interval, and x=2 is excluded. C: No EVT guarantee does not rule out the actual minimum at the included endpoint 0. D: Values such as 1.5 exceed 1, and there is no greatest value below 2.



**N-5.2-A-v3.** For p(x)=x² on [-1,2], which explanation correctly separates the Extreme Value Theorem from locating the extrema?



- **A. Continuity on the closed interval guarantees both extrema; checking the graph or values shows absolute minimum 0 at x=0 and maximum 4 at x=2.**

- B. EVT guarantees that both extrema must be at endpoints, so the minimum is 1 at x=-1.

- C. EVT does not apply because p'(0)=0, creating a critical point.

- D. EVT states that the maximum and minimum values must be equal for a continuous function.



Check: x² is continuous on [-1,2], so existence follows from EVT. The interior value p(0)=0 is below endpoint values 1 and 4; p(2)=4 is greatest.

Rationales: B: EVT guarantees existence, not that extrema are restricted to endpoints; x=0 is smaller. C: A zero derivative is allowed under EVT, which requires continuity only. D: EVT makes no claim that the extreme values coincide; here they are 0 and 4.

---

## Seed N-5.2-B (new) — Topic 5.2 Extreme Value Theorem and Critical Points

**Skill:** distinguish critical points from local extrema, including zero and undefined derivatives



For f(x)=x³ on (-2,2), a student says x=0 is a local extremum because f'(0)=0. Which response is correct?



- **A. x=0 is a critical point but not a local extremum: f is increasing through 0, so the derivative's zero does not force a turn.**

- B. Every point with derivative 0 is both a local maximum and a local minimum.

- C. x=0 is not a critical point because f is differentiable there.

- D. x=0 is an absolute maximum because f(0)=0.



Check: f'(x)=3x², so f'(0)=0 makes 0 critical. But f values change from negative to positive through 0, so 0 is neither a local high nor low.

Rationales: B: The definition of critical point does not guarantee a local extremum; f continues increasing. C: A critical point can have derivative zero at a differentiable point. D: Nearby positive x-values have f(x)>0, so f(0) is not a maximum.



**N-5.2-B-v1.** For g(x)=|x-1| on (0,2), which classification of x=1 is justified?



- **A. x=1 is a critical point and local minimum even though g'(1) does not exist; the graph decreases before 1 and increases after.**

- B. x=1 cannot be critical because the derivative is undefined rather than zero.

- C. x=1 is a local maximum because the left and right slopes have opposite signs.

- D. The function has no extrema because it is not differentiable at x=1.



Check: The cusp at 1 lies in the domain and has no derivative, satisfying the critical-point definition. |x-1| is 0 there and positive at nearby points, so it is a local minimum.

Rationales: B: A critical point includes an interior domain point where the derivative is zero or undefined. C: The function falls toward 1 and rises afterward, making a minimum rather than a maximum. D: Differentiability is not required for a local extremum; the cusp is the lowest nearby point.



**N-5.2-B-v2.** Let h(x)=x^(1/3) on (-1,1), using the real cube root. At x=0 the derivative is undefined. What follows?



- **A. x=0 is critical but not a local extremum because h increases through 0 despite its vertical tangent.**

- B. x=0 is not critical because h is continuous there.

- C. x=0 is a local maximum because the derivative is undefined.

- D. x=0 is a local minimum because h(0)=0.



Check: The function is defined at 0, and h'(0) is undefined, so 0 is critical. Real cube root increases on both sides of 0; nearby negative and positive values bracket h(0), ruling out an extremum.

Rationales: B: Continuity does not prevent a point with undefined derivative from being critical. C: An undefined derivative alone cannot establish a local maximum when nearby values exceed h(0). D: Nearby negative values are below h(0), so it is not a local minimum either.



**N-5.2-B-v3.** For q(x)=x⁴-2x² on (-2,2), a student finds critical points at -1, 0, and 1 and claims all are local minima. Which correction is valid?



- **A. -1 and 1 are local minima, but 0 is a local maximum; all three are critical because q'(x)=4x(x²-1).**

- B. Only 0 is critical because the derivative is zero there.

- C. All three are local maxima because the derivative vanishes at all three.

- D. None is a local extremum because polynomial derivatives exist everywhere.



Check: q'(x)=4x(x²-1), so the critical points are -1,0,1. q(±1)=-1 and q(0)=0; in nearby regions the graph rises from -1 to 0 then falls to 1, so 0 is locally high and ±1 locally low.

Rationales: B: The derivative equation has all three listed roots, not just 0. C: A zero derivative identifies candidates; q values and neighboring behavior show different extremum types. D: Differentiable polynomials can have local extrema where their derivative equals zero.

---

## Seed N-5.2-C (new) — Topic 5.2 Extreme Value Theorem and Critical Points

**Skill:** classify interior local versus absolute extrema from consistent interval behavior



A continuous function on [-2,2] is strictly decreasing, increasing, decreasing, then increasing on successive intervals cut by x=-1,0,1. Its values at x=-2,-1,0,1,2 are 4,0,3,1,5. Which statement is correct?



- **A. x=-1 is an interior local and absolute minimum; x=2 is the absolute maximum, even though it is an endpoint.**

- B. x=1 is the absolute minimum because it is an interior local minimum.

- C. x=0 is the absolute maximum because it is the only interior local maximum.

- D. The absolute maximum must occur at a critical point inside the interval.



Check: The monotonicity on each segment leaves the smallest listed/possible value 0 at -1 and largest 5 at endpoint 2. x=1 is only a higher local minimum and x=0 a lower local maximum.

Rationales: B: f(1)=1 exceeds f(-1)=0, so the local minimum at 1 is not absolute. C: The interior local peak f(0)=3 is below the endpoint value f(2)=5, so it is not the absolute maximum. D: An absolute extremum can occur at a closed interval endpoint; interior critical points are not the only candidates.



**N-5.2-C-v1.** A continuous function on [-2,2] alternately increases, decreases, increases, and decreases across x=-1,0,1. Values at -2,-1,0,1,2 are 2,5,1,4,0. Which classification is supported?



- **A. x=-1 is an interior local and absolute maximum, while x=2 is an absolute minimum at an endpoint.**

- B. x=1 is the absolute maximum because it is the last interior local maximum.

- C. x=0 is the absolute minimum because it is an interior local minimum.

- D. No endpoint can be an absolute minimum when the function has interior local extrema.



Check: The monotonicity confirms local maxima at -1 and 1, and a local minimum at 0. Listed values show the largest is 5 at -1 and smallest is 0 at endpoint 2.

Rationales: B: f(1)=4 is below f(-1)=5, despite being locally high. C: The local minimum f(0)=1 is above the endpoint value f(2)=0, so it is not absolute. D: Interior local extrema do not prevent an endpoint from being globally smallest.



**N-5.2-C-v2.** A continuous function on [-2,2] alternately increases, decreases, increases, and decreases across x=-1,0,1. Values at -2,-1,0,1,2 are 0,3,1,4,2. What is true?



- **A. x=-2 is the absolute minimum, and x=1 is an interior local and absolute maximum.**

- B. x=0 is the absolute minimum because it is an interior local minimum.

- C. x=-1 is the absolute maximum because it is the first interior peak.

- D. Absolute extrema cannot occur at endpoints if a function changes direction inside.



Check: The smallest value is f(-2)=0 and the greatest is f(1)=4. The stated monotonicity prevents any intermediate values outside the neighboring endpoint values.

Rationales: B: The interior local minimum f(0)=1 exceeds the endpoint value f(-2)=0. C: The first local peak f(-1)=3 is below the later local peak f(1)=4. D: An endpoint may be an absolute extremum even when interior local extrema exist.



**N-5.2-C-v3.** A continuous function on [-2,2] decreases, increases, decreases, and increases across x=-1,0,1. Values at -2,-1,0,1,2 are 5,1,4,0,3. Which comparison is correct?



- **A. x=-2 is the absolute maximum, while x=1 is an interior local and absolute minimum.**

- B. x=0 is the absolute maximum because it is an interior local peak.

- C. x=-1 is the absolute minimum because it is the first interior valley.

- D. The function cannot have absolute extrema because its direction changes three times.



Check: The listed monotonic intervals confine values to the endpoint values of each segment. f(-2)=5 is greatest, f(1)=0 is least; 0 is a smaller local peak and -1 a higher local valley.

Rationales: B: The interior local peak f(0)=4 is below the endpoint value f(-2)=5. C: The first local valley f(-1)=1 is above the later valley f(1)=0. D: Direction changes do not prevent a continuous function on a closed interval from attaining absolute extrema.
