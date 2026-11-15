# AP Statistics Unit 2: replacement seed drafts, topics 2.4 / 2.5 / 2.6

DRAFT for owner review. Not checked by any checker. Not in the database. Author-in-session drafts; arithmetic checked by hand once.
Replaces these R1 seeds (each with its three variants): 050 (2.4), 051 (2.5), 046 and 048 (2.6). Correct-answer position is varied on purpose.
Target level: two linked steps or an interpretation, distractors that are real student errors, no impossible values.

---

## Seed N-2.4-A (replaces 050 family) — Topic 2.4 Introduction to Probability
**Skill:** interpret a probability as a long-run relative frequency; distinguish it from a guaranteed count.

A phone manufacturer's records over many thousands of phones show that 3% have a defective screen. A store receives a random shipment of 200 phones. The store manager says, "Since 3% are defective, exactly 6 phones in this shipment will have a defective screen." Which statement best evaluates the manager's claim?

- A. The claim is correct, because 3% of 200 is 6.
- B. The claim is incorrect, because the manager should have used 97%, since most phones in the shipment are not defective.
- **C. The claim is incorrect, because a probability describes the long-run proportion, so the number of defective phones in this particular shipment will vary around 6 and need not equal 6.**
- D. The claim is incorrect, because a 3% rate applies only to shipments of 1,000 or more phones.

Rationales: A: confuses an expected count with a guaranteed one. B: confuses the event with its complement. D: invents a minimum sample size; probability applies to each phone.

## Seed N-2.4-B (second 2.4 seed) — Topic 2.4
**Skill:** complement rule used to avoid listing a large event; sample space of two dice.

Two fair six-sided dice are rolled. What is the probability that the sum of the two dice is at least 4?

- A. 1/12
- B. 5/6
- **C. 11/12**
- D. 1/2

Check: sums below 4 are (1,1), (1,2), (2,1): 3 of 36, so P = 1 − 3/36 = 33/36 = 11/12.
Rationales: A: gave the complement (sum less than 4) and stopped. B: counted sums of 4 or less as excluded (6 outcomes), i.e. computed P(sum > 4) = 30/36. D: treated sums above and below as equally likely.

---

## Seed N-2.5-A (replaces 051 family) — Topic 2.5 Mutually Exclusive Events
**Skill:** separate "mutually exclusive" from "independent" using numbers, not wording.

For two events A and B, P(A) = 0.50, P(B) = 0.30, and P(A or B) = 0.65. Which statement is correct?

- A. A and B are mutually exclusive, because P(A or B) = 0.65 is less than 1.
- B. A and B are both mutually exclusive and independent, because P(A and B) equals P(A)P(B).
- C. A and B are neither mutually exclusive nor independent, because P(A or B) ≠ P(A) + P(B).
- **D. A and B are not mutually exclusive, because P(A and B) = 0.15 > 0, but they are independent, because 0.15 = (0.50)(0.30).**

Check: P(A and B) = 0.50 + 0.30 − 0.65 = 0.15. 0.50 × 0.30 = 0.15.
Rationales: A: a union below 1 says nothing about overlap. B: mutually exclusive events with positive probabilities can never be independent. C: unequal sum shows overlap, not dependence.

## Seed N-2.5-B (second 2.5 seed) — Topic 2.5
**Skill:** general addition rule with overlap, then the complement.

At a school, 55% of students take Spanish, 30% take French, and 10% take both. What is the probability that a randomly selected student takes neither language?

- A. 0.15
- **B. 0.25**
- C. 0.05
- D. 0.45

Check: P(Spanish or French) = 0.55 + 0.30 − 0.10 = 0.75; 1 − 0.75 = 0.25.
Rationales: A: ignored the overlap (1 − 0.85). C: added the overlap instead of subtracting (1 − 0.95). D: only removed Spanish students (1 − 0.55).

---

## Seed N-2.6-A (replaces 046 family) — Topic 2.6 Conditional Probability
**Skill:** test independence from a two-way table; conditional proportions, not counts; the asymmetry of P(A | B) and P(B | A).

Two hundred students were classified by whether they play a school sport and whether they are on the honor roll.

| | On honor roll | Not on honor roll | Total |
|---|---|---|---|
| Athlete | 24 | 56 | 80 |
| Not an athlete | 36 | 84 | 120 |
| Total | 60 | 140 | 200 |

Which statement is correct?

- A. Being an athlete and being on the honor roll are not independent, because more non-athletes (36) than athletes (24) are on the honor roll.
- B. Being an athlete and being on the honor roll are not independent, because P(athlete | honor roll) = 0.40 is not equal to P(honor roll | athlete) = 0.30.
- **C. Being an athlete and being on the honor roll are independent, because P(honor roll | athlete) = 24/80 = 0.30 equals P(honor roll) = 60/200 = 0.30.**
- D. Being an athlete and being on the honor roll are independent, because P(athlete and honor roll) = 0.12 is smaller than both P(athlete) and P(honor roll).

Check: P(athlete) = 0.40, P(honor) = 0.30, P(both) = 24/200 = 0.12 = 0.40 × 0.30.
Rationales: A: compares counts of unequal groups. B: P(A | B) and P(B | A) are different quantities; they need not be equal. D: a joint probability is always smaller than each marginal; it does not show independence.

## Seed N-2.6-B (replaces 048 family) — Topic 2.6
**Skill:** multiplication rule with a changing sample space (without replacement), combining two disjoint outcomes.

A bag contains 5 red marbles and 3 blue marbles. Two marbles are drawn at random, one after the other, without replacement. What is the probability that both marbles are the same color?

- A. 17/32
- B. 5/14
- **C. 13/28**
- D. 15/56

Check: P(RR) = (5/8)(4/7) = 20/56; P(BB) = (3/8)(2/7) = 6/56; total 26/56 = 13/28.
Rationales: A: used replacement, (5/8)² + (3/8)² = 34/64. B: counted only red-red, 20/56. D: P(red then blue) = (5/8)(3/7), a different-colors outcome.

---

## Open before any of this can ship
1. Two different-family checkers on every seed, a verified union of flags, then the patch loop (protocol `research/SEEDED_ITEM_GENERATION_PROTOCOL_2026_09_30.md`, not yet read in full by this session).
2. Topic and skill labels voted per seed (both checkers agree, or drop).
3. Independent re-derivation of every key (hard publish precondition).
4. Three variants per approved seed, after the seed passes.
5. Publication and retirement of the old families only with owner approval and a logged APPROVAL id; old items superseded, not deleted.

---
---

# VARIANTS (three per seed), drafted the same way as the seeds

Same skill and same level as the parent seed; new context, new numbers, and, where useful, a different shape of the same trap (so students cannot pattern-match). Correct key position varied. All arithmetic checked with exact fractions in Python. No checker pass, by owner decision: the old protocol is not trusted, the seeds were judged better by the owner directly.

## N-2.4-A variants (long-run interpretation)

**N-2.4-A-v1.** A hospital's records over many years show that 12% of scheduled patients miss their appointment. Tomorrow 300 patients are scheduled. The scheduler says, "Exactly 36 patients will miss their appointment." Which statement best evaluates this claim?
- A. The claim is correct, because 12% of 300 is 36.
- B. The claim is incorrect, because the scheduler should have used 88%, since most patients attend.
- C. The claim is incorrect, because a 12% rate applies only to clinics with at least 1,000 appointments in a day.
- **D. The claim is incorrect, because 12% is a long-run proportion, so the number who miss tomorrow will vary around 36 and need not equal 36.**

**N-2.4-A-v2.** A seed company reports that, over many tests, 90% of its tomato seeds germinate. A gardener plants 20 seeds. Which statement is the most reasonable?
- A. Exactly 18 seeds will germinate, because 90% of 20 is 18.
- **B. About 18 seeds are likely to germinate, but the actual number will vary from garden to garden.**
- C. At least 18 seeds will germinate, because 90% is the minimum germination rate.
- D. Nothing can be said about how many will germinate, because only 20 seeds are planted.

**N-2.4-A-v3.** A streaming service finds that, over millions of plays, 2% of videos stall at least once. An engineer tests 500 plays and says, "Since 2% stall, exactly 10 of these 500 plays will stall." Which statement best evaluates the engineer's claim?
- A. The claim is incorrect, because 2% is too small a probability to apply to 500 plays.
- **B. The claim is incorrect, because a probability is a long-run proportion, so the number of stalls in these 500 plays will vary around 10 and need not equal 10.**
- C. The claim is correct, because 2% of 500 is 10.
- D. The claim is incorrect, because the engineer should have used 98%, the probability that a play does not stall.

## N-2.4-B variants (complement rule, dice and coins)

**N-2.4-B-v1.** Two fair six-sided dice are rolled. What is the probability that the sum is at least 5?
- **A. 5/6**
- B. 1/6
- C. 13/18
- D. 1/2

Check: sums below 5 are (1,1), (1,2), (2,1), (1,3), (3,1), (2,2): 6 of 36, so 1 − 6/36 = 5/6. B = the complement. C = counted sums of 5 as excluded (10 outcomes): 26/36.

**N-2.4-B-v2.** Two fair six-sided dice are rolled. What is the probability that at least one die shows a number greater than 1?
- A. 1/36
- B. 25/36
- C. 5/6
- **D. 35/36**

Check: the only outcome with no die above 1 is (1,1), so 1 − 1/36 = 35/36. A = the complement. B = both dice above 1, (5/6)². C = only one die considered.

**N-2.4-B-v3.** A fair coin is flipped 4 times. What is the probability of getting at least one tail?
- A. 1/16
- B. 7/8
- **C. 15/16**
- D. 3/4

Check: only HHHH has no tail, so 1 − 1/16 = 15/16. A = the complement. B = used 3 flips. D = treated the 4 flips as 4 separate quarters (1 − 1/4).

## N-2.5-A variants (mutually exclusive vs independent)

**N-2.5-A-v1.** At a high school, let C be the event that a randomly chosen student is in a club and J the event that the student has a job. P(C) = 0.40, P(J) = 0.25, and P(C or J) = 0.55. Which statement is correct?
- A. C and J are mutually exclusive, because P(C or J) = 0.55 is less than 1.
- B. C and J are mutually exclusive and independent, because P(C and J) equals P(C)P(J).
- **C. C and J are not mutually exclusive, because P(C and J) = 0.10 > 0, but they are independent, because 0.10 = (0.40)(0.25).**
- D. C and J are neither mutually exclusive nor independent, because P(C or J) ≠ P(C) + P(J).

Check: P(C and J) = 0.40 + 0.25 − 0.55 = 0.10 = 0.40 × 0.25.

**N-2.5-A-v2.** For events A and B, P(A) = 0.35, P(B) = 0.40, and P(A or B) = 0.75. Which statement is correct?
- A. A and B are not mutually exclusive, because P(A) + P(B) = 0.75 is less than 1.
- **B. A and B are mutually exclusive, because P(A and B) = 0, but they are not independent, because P(A)P(B) = 0.14 ≠ 0.**
- C. A and B are mutually exclusive and independent, because P(A and B) = 0 means one event does not affect the other.
- D. A and B are independent, because P(A or B) = P(A) + P(B).

Check: 0.35 + 0.40 − 0.75 = 0, so the events are mutually exclusive; 0.35 × 0.40 = 0.14 ≠ 0. A = wrong inference from a sum under 1. C = the common "they cannot affect each other" confusion. D = P(A or B) = P(A) + P(B) is the exclusivity condition, not independence.

**N-2.5-A-v3.** For two events A and B, P(A) = 0.60, P(B) = 0.50, and P(A or B) = 0.85. Which statement is correct?
- A. A and B are mutually exclusive, because P(A or B) < P(A) + P(B).
- B. A and B are independent, because P(A or B) = 0.85 is greater than both P(A) and P(B).
- **C. A and B are not mutually exclusive, because P(A and B) = 0.25 > 0, and they are not independent, because P(A)P(B) = 0.30 ≠ 0.25.**
- D. A and B are not mutually exclusive, but they are independent, because P(A and B) = 0.25 is positive.

Check: 0.60 + 0.50 − 0.85 = 0.25; 0.60 × 0.50 = 0.30.

## N-2.5-B variants (general addition rule, then complement)

**N-2.5-B-v1.** A survey of commuters finds that 45% bike to work, 25% take the bus, and 10% do both on different days. What is the probability that a randomly selected commuter does neither?
- A. 0.30
- B. 0.55
- **C. 0.40**
- D. 0.20

Check: union 0.45 + 0.25 − 0.10 = 0.60; 1 − 0.60 = 0.40. A = ignored the overlap (1 − 0.70). B = only removed bikers (1 − 0.45). D = added the overlap (1 − 0.80).

**N-2.5-B-v2.** Among adults in a town, 38% read news online, 27% read a print paper, and 9% do both. What is the probability that a randomly selected adult reads neither?
- A. 0.35
- B. 0.26
- C. 0.62
- **D. 0.44**

Check: union 0.38 + 0.27 − 0.09 = 0.56; 1 − 0.56 = 0.44. A = ignored the overlap (1 − 0.65). B = added the overlap (1 − 0.74). C = only removed online readers.

**N-2.5-B-v3.** Of 200 students, 90 play soccer, 70 play basketball, and 30 play both. What is the probability that a randomly selected student plays neither sport?
- A. 0.20
- **B. 0.35**
- C. 0.05
- D. 0.55

Check: students in at least one sport = 90 + 70 − 30 = 130; 70/200 play neither, so 0.35. A = ignored the overlap (1 − 160/200). C = added the overlap (1 − 190/200). D = 110/200, the students who do not play soccer.

## N-2.6-A variants (independence from a two-way table)

**N-2.6-A-v1.** A company classified 250 workers by work location and whether they completed an optional training.

| | Completed | Did not complete | Total |
|---|---|---|---|
| Remote | 45 | 55 | 100 |
| On-site | 30 | 120 | 150 |
| Total | 75 | 175 | 250 |

Which statement is correct?
- A. Work location and completing the training are independent, because both groups have more workers who did not complete than who did.
- **B. Work location and completing the training are not independent, because P(completed | remote) = 45/100 = 0.45 is not equal to P(completed) = 75/250 = 0.30.**
- C. Work location and completing the training are independent, because P(remote and completed) = 0.18 is smaller than both P(remote) and P(completed).
- D. Work location and completing the training are not independent, because P(remote | completed) = 0.60 is not equal to P(completed | remote) = 0.45.

Check: 0.45 vs 0.30; P(remote and completed) = 45/250 = 0.18; P(remote | completed) = 45/75 = 0.60. D reaches the right verdict for the wrong reason: those two conditional probabilities are always allowed to differ.

**N-2.6-A-v2.** Three hundred students were classified by grade and by whether they take an AP class.

| | Take AP | No AP | Total |
|---|---|---|---|
| Senior | 48 | 72 | 120 |
| Junior | 72 | 108 | 180 |
| Total | 120 | 180 | 300 |

Which statement is correct?
- A. Grade and taking an AP class are not independent, because more juniors (72) than seniors (48) take an AP class.
- B. Grade and taking an AP class are not independent, because P(junior | AP) = 0.60 is not equal to P(senior | AP) = 0.40.
- C. Grade and taking an AP class are independent, because P(senior and AP) = 0.16 is smaller than both P(senior) and P(AP).
- **D. Grade and taking an AP class are independent, because P(AP | senior) = 48/120 = 0.40 equals P(AP) = 120/300 = 0.40.**

Check: 0.40 = 0.40. P(senior and AP) = 48/300 = 0.16. B compares two conditional probabilities that describe different groups and are expected to differ.

**N-2.6-A-v3.** A store classified 400 customers by whether they have a loyalty membership and whether they bought an item on sale.

| | Bought on sale | Did not | Total |
|---|---|---|---|
| Member | 72 | 88 | 160 |
| Non-member | 48 | 192 | 240 |
| Total | 120 | 280 | 400 |

Which statement is correct?
- **A. Membership and buying on sale are not independent, because P(bought on sale | member) = 72/160 = 0.45 is not equal to P(bought on sale) = 120/400 = 0.30.**
- B. Membership and buying on sale are independent, because the store has more non-members (240) than members (160).
- C. Membership and buying on sale are independent, because P(member and bought on sale) = 0.18 is smaller than both P(member) and P(bought on sale).
- D. Membership and buying on sale are not independent, because P(member | bought on sale) = 0.60 is not equal to P(bought on sale | member) = 0.45.

Check: 0.45 vs 0.30; 72/400 = 0.18; 72/120 = 0.60.

## N-2.6-B variants (without replacement)

**N-2.6-B-v1.** A bag contains 6 green marbles and 4 yellow marbles. Two marbles are drawn at random, one after the other, without replacement. What is the probability that both marbles are the same color?
- A. 13/25
- **B. 7/15**
- C. 1/3
- D. 4/15

Check: (6/10)(5/9) + (4/10)(3/9) = 30/90 + 12/90 = 42/90 = 7/15. A = with replacement. C = green-green only. D = P(green then yellow) = (6/10)(4/9).

**N-2.6-B-v2.** A box contains 5 black pens and 4 white pens. Two pens are drawn at random, one after the other, without replacement. What is the probability that the two pens are different colors?
- A. 40/81
- B. 5/18
- C. 4/9
- **D. 5/9**

Check: 2 × (5/9)(4/8) = 40/72 = 5/9. A = with replacement. B = only black then white. C = P(same color) = 32/72, the complement.

**N-2.6-B-v3.** A bag contains 3 red, 3 blue, and 2 green marbles. Two marbles are drawn at random, one after the other, without replacement. What is the probability that both marbles are the same color?
- A. 11/32
- B. 3/28
- **C. 1/4**
- D. 1/3

Check: (3/8)(2/7) + (3/8)(2/7) + (2/8)(1/7) = 6/56 + 6/56 + 2/56 = 14/56 = 1/4. A = with replacement, (9 + 9 + 4)/64. B = red-red only. D = treated the three colors as equally likely.

---
Count: 6 seeds + 18 variants = 24 items. Keys are spread across A, B, C and D.
Not done: topic and skill labels, per-choice rationales in database form, publication, and retirement of the old 050/051/046/048 families. Each needs your approval and a logged APPROVAL id.

---
---

# PART 2: topics 2.7, 2.9, 2.10 (seeds and variants)

Replaces the R1 seeds 054 (2.7), 049 and 081 (2.9), and 052 (2.10), with their variants. Same method as part 1: harder seed, then three variants each with a new context, new numbers and, where useful, a different shape of the same trap. Every number was verified in Python (exact fractions or binomial formulas). No checker pass. Not in the database.
Left alone on purpose: 047 (independence test, R2), 078 (single binomial term, R2) and the standalone MCQ-053 (combination recall, R1), which has no variants and could be replaced if you want.

---

## Seed N-2.7-A (replaces 054 family) — Topic 2.7 Independent Events and Unions of Events
**Skill:** use independence to get P(A and B), then the general addition rule.

Events A and B are independent, with P(A) = 0.40 and P(B) = 0.30. What is P(A or B)?
- A. 0.70
- B. 0.12
- **C. 0.58**
- D. 0.42

Check: P(A and B) = 0.40 × 0.30 = 0.12; P(A or B) = 0.40 + 0.30 − 0.12 = 0.58.
Rationales: A: added without subtracting the overlap. B: stopped at P(A and B). D: 1 − 0.58, the complement.

**N-2.7-A-v1.** At a school, whether a student rides the bus (event R, P = 0.50) and whether a student has a part-time job (event J, P = 0.20) are independent. What is the probability that a randomly selected student rides the bus or has a job (or both)?
- A. 0.70
- B. 0.10
- C. 0.40
- **D. 0.60**
Check: 0.50 + 0.20 − (0.50)(0.20) = 0.60. A: no overlap subtracted. B: product only. C: 1 − 0.60.

**N-2.7-A-v2.** In a town, the event that a household owns a dog (P = 0.35) and the event that it owns a bicycle (P = 0.40) are independent. What is the probability that a randomly selected household owns a dog or a bicycle?
- A. 0.14
- **B. 0.61**
- C. 0.75
- D. 0.39
Check: 0.35 + 0.40 − 0.14 = 0.61. A: product only. C: no overlap subtracted. D: 1 − 0.61.

**N-2.7-A-v3.** Events A and B are independent, with P(A) = 0.50 and P(A or B) = 0.65. What is P(B)?
- A. 0.15
- B. 0.35
- **C. 0.30**
- D. 0.50
Check: 0.50 + P(B) − 0.50·P(B) = 0.65, so 0.50·P(B) = 0.15 and P(B) = 0.30. A: P(A or B) − P(A) ignores the overlap. B: 1 − 0.65. D: assumed P(B) = P(A).

---

## Seed N-2.7-B (second 2.7 seed) — Topic 2.7
**Skill:** "at least one" of independent events, via the complement; separating "at least one" from "exactly one" and "both".

A building has two independent alarms. During a break-in, alarm 1 sounds with probability 0.90 and alarm 2 sounds with probability 0.80. What is the probability that at least one alarm sounds?
- A. 0.72
- B. 0.26
- C. 0.90
- **D. 0.98**
Check: 1 − (0.10)(0.20) = 0.98. A: both alarms, (0.90)(0.80). B: exactly one, (0.90)(0.20) + (0.10)(0.80). C: only the better alarm.

**N-2.7-B-v1.** A website has two independent servers. Server 1 responds to a request with probability 0.95 and server 2 with probability 0.90. What is the probability that at least one server responds?
- **A. 0.995**
- B. 0.855
- C. 0.14
- D. 0.95
Check: 1 − (0.05)(0.10) = 0.995. B: both, 0.855. C: exactly one, 0.095 + 0.045 = 0.14. D: only server 1.

**N-2.7-B-v2.** A security system uses three independent sensors. Each sensor detects an intruder with probability 0.70. What is the probability that at least one sensor detects the intruder?
- A. 0.343
- B. 0.189
- C. 0.700
- **D. 0.973**
Check: 1 − (0.30)³ = 0.973. A: all three, 0.7³ = 0.343. B: exactly one, 3(0.7)(0.3)² = 0.189. C: one sensor.

**N-2.7-B-v3.** Ana makes a free throw with probability 0.60 and Ben with probability 0.50. Each takes one shot, independently. What is the probability that at least one of them makes the shot?
- A. 0.30
- B. 0.55
- C. 0.50
- **D. 0.80**
Check: 1 − (0.40)(0.50) = 0.80. A: both, 0.30. B: the average of the two. C: exactly one, 0.30 + 0.20 = 0.50.

---

## Seed N-2.9-A (replaces 081 family) — Topic 2.9 Parameters of Random Variables
**Skill:** how a linear change Y = aX + b moves the mean and the standard deviation (the shift affects only the mean).

A random variable X has mean 4 and standard deviation 1.5. Let Y = 3X − 2. What are the mean and standard deviation of Y?
- A. Mean 10, standard deviation 2.5
- **B. Mean 10, standard deviation 4.5**
- C. Mean 12, standard deviation 4.5
- D. Mean 10, standard deviation 13.5
Check: mean 3(4) − 2 = 10; SD 3(1.5) = 4.5.
Rationales: A: subtracted 2 from the SD. C: forgot the −2 for the mean. D: multiplied the SD by 9 (squared the multiplier).

**N-2.9-A-v1.** A random variable X has mean 20 and standard deviation 4. Let Y = 0.5X + 10. What are the mean and standard deviation of Y?
- A. Mean 20, standard deviation 12
- B. Mean 20, standard deviation 4
- **C. Mean 20, standard deviation 2**
- D. Mean 30, standard deviation 2
Check: mean 0.5(20) + 10 = 20; SD 0.5(4) = 2. A: added 10 to the SD (2 + 10). B: left the SD unscaled. D: added 10 to the unscaled mean.

**N-2.9-A-v2.** The number of items X in an online order has mean 3.2 and standard deviation 1.1. A shipping charge is C = 4 + 2.5X dollars. What are the mean and standard deviation of C?
- A. Mean $8, standard deviation $2.75
- B. Mean $12, standard deviation $6.75
- C. Mean $12, standard deviation $1.10
- **D. Mean $12, standard deviation $2.75**
Check: mean 4 + 2.5(3.2) = 12; SD 2.5(1.1) = 2.75. A: forgot the $4 base fee. B: added $4 to the SD (2.75 + 4). C: left the SD unscaled.

**N-2.9-A-v3.** A random variable X has mean 15 and standard deviation 3. Let Y = 50 − 2X. What are the mean and standard deviation of Y?
- A. Mean 20, standard deviation −6
- B. Mean 80, standard deviation 6
- **C. Mean 20, standard deviation 6**
- D. Mean 20, standard deviation 3
Check: mean 50 − 2(15) = 20; SD |−2|(3) = 6. A: kept the negative sign on the SD. B: added 2(15) to 50. D: left the SD unscaled.

---

## Seed N-2.9-B (replaces 049 family) — Topic 2.9
**Skill:** expected net gain with a cost, from a multi-prize distribution.

A charity sells 400 raffle tickets at $10 each. There is one grand prize of $1,000 and three prizes of $200. What is the expected net gain for a person who buys one ticket?
- A. $4.00
- B. −$7.50
- **C. −$6.00**
- D. −$10.00
Check: expected prize = (1,000 + 3 × 200)/400 = 4.00; net = 4.00 − 10 = −6.00.
Rationales: A: left out the ticket price. B: used only the grand prize, 2.50 − 10. D: assumed the ticket price is simply lost.

**N-2.9-B-v1.** A school fair sells 500 tickets at $4 each. There is one prize of $600 and two prizes of $100. What is the expected net gain for a person who buys one ticket?
- A. $1.60
- B. −$2.80
- **C. −$2.40**
- D. −$4.00
Check: expected prize (600 + 200)/500 = 1.60; net 1.60 − 4 = −2.40. A: ignored the ticket price. B: only the $600 prize, 1.20 − 4.

**N-2.9-B-v2.** A carnival game costs $5 to play. A fair six-sided die is rolled: a 6 pays $12, a 5 pays $6, and any other roll pays $0. What is the expected net gain per play?
- A. $3.00
- B. −$3.00
- **C. −$2.00**
- D. −$5.00
Check: expected payout 12(1/6) + 6(1/6) = 3.00; net 3.00 − 5 = −2.00. A: ignored the $5 cost. B: only the $12 prize, 2 − 5.

**N-2.9-B-v3.** An insurance company charges a $120 premium. With probability 0.10 it pays a $500 claim, with probability 0.02 it pays a $2,000 claim, and otherwise it pays nothing. What is the company's expected profit per policy?
- A. $90
- B. −$30
- C. $70
- **D. $30**
Check: expected payout 0.10(500) + 0.02(2,000) = 90; profit 120 − 90 = 30. A: reported expected payout, not profit. B: sign reversed (customer's view). C: counted only the $500 claims.

---

## Seed N-2.10-A (replaces 052 family) — Topic 2.10 The Binomial Distribution
**Skill:** judge whether sampling without replacement still gives an (approximately) binomial count; the 10% condition.

In a large school of 1,800 students, 10% are left-handed. A teacher randomly selects 25 students, and X is the number who are left-handed. Which statement is correct?
- A. X is not binomial, because the students are selected without replacement.
- B. X is not binomial, because the probability of being left-handed, 0.10, is too small.
- **C. X is approximately binomial, because the sample is a small fraction of the school, so the trials are nearly independent with nearly constant P(left-handed).**
- D. X is exactly binomial, because the number of trials is fixed at 25.
Rationales: A: ignores that a small sample from a large population is nearly independent. B: there is no minimum for p. D: a fixed n alone does not guarantee independence and constant p.

**N-2.10-A-v1.** A city has 5,000 registered voters, and 52% favor a ballot measure. A pollster randomly selects 50 voters, and X is the number who favor the measure. Which statement is correct?
- A. X is binomial only if the pollster samples with replacement.
- **B. X is approximately binomial, because 50 is a small fraction of 5,000, so the trials are nearly independent with P(favor) nearly constant at 0.52.**
- C. X is not binomial, because 0.52 is not equal to 0.50.
- D. X is exactly binomial, because there are only two possible responses.

**N-2.10-A-v2.** A class of 30 students includes 12 who are left-handed. A teacher randomly selects 10 students from the class without replacement, and X is the number who are left-handed. Which statement is correct?
- A. X is binomial, because there are exactly 10 trials with two outcomes each.
- B. X is binomial, because the probability of selecting a left-handed student on the first pick is 12/30 = 0.40.
- **C. X is not approximately binomial, because the sample is one-third of the class, so each pick changes the probability for the next.**
- D. X is not binomial, because the students can be left-handed or right-handed but not both.
Check: 10/30 is well above the usual 10% guideline.

**N-2.10-A-v3.** A town has 12,000 residents, and 20% own an electric vehicle. A researcher randomly selects 30 residents, and X is the number who own an electric vehicle. Which statement is correct?
- A. X is not binomial, because sampling without replacement always makes trials dependent.
- B. X is exactly binomial, because the number of residents sampled is fixed.
- C. X is binomial only if 30 is at least half the town.
- **D. X is approximately binomial, because 30 is a small fraction of 12,000, so P(owns an electric vehicle) stays nearly 0.20 on every pick.**

---

## Seed N-2.10-B (second 2.10 seed) — Topic 2.10
**Skill:** a cumulative binomial probability ("at least k") by complement, with the boundary read correctly.

Each of 6 independent customers buys an upgrade with probability 0.25. Let X be the number who buy the upgrade. What is P(X ≥ 2)?
- A. 0.2966
- B. 0.8220
- **C. 0.4661**
- D. 0.5339
Check: P(0) = 0.75⁶ = 0.1780; P(1) = 6(0.25)(0.75)⁵ = 0.3560; 1 − 0.1780 − 0.3560 = 0.4661.
Rationales: A: P(X = 2) only. B: P(X ≥ 1), 1 − P(0). D: P(X ≤ 1), the complement.

**N-2.10-B-v1.** Each of 8 independent seeds sprouts with probability 0.30. Let X be the number that sprout. What is P(X ≥ 2)?
- A. 0.2965
- B. 0.9424
- **C. 0.7447**
- D. 0.2553
Check: 1 − 0.7⁸ − 8(0.3)(0.7)⁷ = 0.7447. A: P(X = 2). B: P(X ≥ 1). D: P(X ≤ 1).

**N-2.10-B-v2.** Each of 10 independent calls is answered with probability 0.20. Let X be the number answered. What is P(X ≥ 3)?
- A. 0.2013
- B. 0.8791
- C. 0.1209
- **D. 0.3222**
Check: 1 − P(0) − P(1) − P(2) = 0.3222. A: P(X = 3). B: P(X ≤ 3). C: P(X ≥ 4), one boundary too high.

**N-2.10-B-v3.** Each of 5 independent free throws is made with probability 0.40. Let X be the number made. What is P(X ≥ 4)?
- A. 0.0768
- B. 0.3174
- **C. 0.0870**
- D. 0.9898
Check: P(4) + P(5) = 0.0768 + 0.0102 = 0.0870. A: P(X = 4) only. B: P(X ≥ 3). D: P(X ≤ 4).

---
Part 2 count: 6 seeds + 18 variants = 24 items (two seeds each for 2.7, 2.9 and 2.10, three variants per seed). Total across parts 1 and 2: 12 seeds + 36 variants = 48 items.
Not done: the same list as part 1 (labels, database-format rationales, publication, retirement of old families 054, 049, 081, 052 with their 16 items, owner approval and an APPROVAL id).

---
---

# PART 3: topics 2.1, 2.2, 2.3, 2.8 (new seeds and variants)

These four topics have no variant families today (only single items: OHT-2.1, MCQ-073, OHT-2.2, OHT-2.3, OHT-2.8). Two new seeds per topic, three variants each. Seeds 2.2-A and 2.2-B replace the R1 item MCQ-073 and strengthen the R2 OHT-2.2. The R3 singles OHT-2.1, OHT-2.3 and OHT-2.8 are kept. No checker pass; every number verified in Python. Not in the database.

---

## TOPIC 2.1 — Tabular and Graphical Representations for Two Categorical Variables

### Seed N-2.1-A — Counts versus within-group percentages
**Skill:** compare groups of different sizes using conditional percentages, not raw counts.

A school surveyed 200 students about whether they prefer online meetings.

| | Prefer online | Prefer in person | Total |
|---|---|---|---|
| Freshman | 45 | 15 | 60 |
| Senior | 56 | 84 | 140 |
| Total | 101 | 99 | 200 |

A student says, "More seniors (56) than freshmen (45) prefer online, so seniors are more likely to prefer online." Which is the best evaluation?
- A. The claim is correct, because 56 is greater than 45.
- B. The claim is correct, because 56/200 = 28% of all students are seniors who prefer online, compared with 45/200 = 22.5% for freshmen.
- C. The claim is incorrect, because 101 of the 200 students prefer online, which is more than half.
- **D. The claim is incorrect, because the groups differ in size: 45/60 = 75% of freshmen prefer online, compared with 56/140 = 40% of seniors.**

**N-2.1-A-v1.** A club coordinator recorded whether 250 members attended weekend events.

| | Attended | Did not attend | Total |
|---|---|---|---|
| Art Club | 60 | 20 | 80 |
| Chess Club | 85 | 85 | 170 |
| Total | 145 | 105 | 250 |

A member says, "More Chess Club members (85) than Art Club members (60) attended, so Chess Club members are more likely to attend." Which is the best evaluation?
- **A. The claim is incorrect, because the clubs differ in size: 60/80 = 75% of Art Club members attended, compared with 85/170 = 50% of Chess Club members.**
- B. The claim is correct, because 85 is greater than 60.
- C. The claim is incorrect, because 145 of the 250 members attended, which is more than half.
- D. The claim is correct, because 85/250 = 34% of all members are Chess Club attendees, compared with 60/250 = 24% for Art Club.

**N-2.1-A-v2.** A survey of 300 commuters recorded where they live and whether they use transit weekly.

| | Use transit | Do not | Total |
|---|---|---|---|
| Urban | 130 | 70 | 200 |
| Rural | 20 | 80 | 100 |
| Total | 150 | 150 | 300 |

A reporter says, "Urban residents are more likely to use transit, because 130 urban residents do, compared with only 20 rural residents." Which is the best evaluation?
- A. The claim is wrong, because the group counts cannot be compared at all, so no conclusion is possible.
- B. The claim is correct, because 130 is greater than 20, which shows urban residents are more likely.
- **C. The conclusion is correct, but the reasoning should compare percentages within each group: 130/200 = 65% of urban residents versus 20/100 = 20% of rural residents.**
- D. The claim is incorrect, because 150 of the 300 commuters use transit, which is exactly half.

**N-2.1-A-v3.** A gym has 300 members: 200 are over 40 and 100 are 40 or under. Members were asked whether they use the gym's app.

| | Use app | Do not | Total |
|---|---|---|---|
| Over 40 | 65 | 135 | 200 |
| 40 or under | 55 | 45 | 100 |
| Total | 120 | 180 | 300 |

A manager says, "About 54% of app users are over 40, so members over 40 are more likely to use the app." Which is the best evaluation?
- A. The claim is correct, because 54% is greater than 50%.
- B. The claim is correct, because 65 over-40 members use the app, compared with 55 members who are 40 or under.
- **C. The claim is incorrect: over-40 members are 200/300 ≈ 67% of all members, so 54% of app users is below their share; within groups, 65/200 = 32.5% of over-40 members use the app versus 55/100 = 55% of the others.**
- D. The claim is incorrect, because only 120 of the 300 members, or 40%, use the app.

### Seed N-2.1-B — Choosing a display
**Skill:** pick a display that supports a fair comparison of a categorical response across groups of different sizes.

A researcher surveys 1,000 commuters in four cities with very different populations (the smallest sample is 50 people and the largest is 600). Each person reports whether they usually commute by car, transit, or bike. The researcher wants to compare commuting patterns across the four cities. Which display is most appropriate?
- A. A single pie chart of all 1,000 responses.
- B. A bar chart of the number of people surveyed in each city.
- **C. A segmented bar graph showing, for each city, the percent of that city's respondents using each commuting mode.**
- D. A side-by-side bar graph showing the number of people using each mode in each city.

**N-2.1-B-v1.** A coach records the position (guard, forward, center) played by students on three school teams of very different sizes and wants to compare position patterns across the teams. Which display is most appropriate?
- A. A bar chart of the number of students on each team.
- B. A pie chart of all students' positions combined.
- C. A side-by-side bar graph of the number of students at each position on each team.
- **D. A segmented bar graph of the percent of each team's students at each position.**

**N-2.1-B-v2.** An inspector samples items from three factories that produce very different volumes and records whether each item is acceptable, minor defect, or major defect. The inspector wants to see whether the defect pattern differs by factory. Which display is most appropriate?
- A. A pie chart of the defect types for all sampled items combined.
- **B. A segmented bar graph of the percent of each factory's sampled items in each defect category.**
- C. A bar chart of the number of items sampled from each factory.
- D. A side-by-side bar graph of the number of items in each defect category for each factory.

**N-2.1-B-v3.** A segmented bar graph shows, for each of four age groups, the percent who prefer each of three streaming services. If the two variables (age group and service preference) are not associated, what would the graph show?
- A. Four bars of equal height, each split into three equal segments.
- B. The segments in each bar would be the same size as the group's sample size.
- **C. The segments would be split in nearly the same proportions in every bar.**
- D. One service would take up the largest segment in exactly one of the bars.

---

## TOPIC 2.2 — Summary Statistics for Two Categorical Variables

### Seed N-2.2-A (replaces MCQ-073) — Marginal, joint and conditional
**Skill:** decide on association from conditional proportions; not from equal joint counts or marginals.

In a clinical study of 500 patients, 200 received Treatment A and 300 received Treatment B.

| | Recovered | Did not recover | Total |
|---|---|---|---|
| Treatment A | 120 | 80 | 200 |
| Treatment B | 120 | 180 | 300 |
| Total | 240 | 260 | 500 |

Which statement is correct?
- A. There is no association, because the same number of patients (120) recovered under each treatment.
- B. Treatment B has the higher recovery rate, because more patients received B (300) than A (200).
- C. The recovery rate is 48% for both treatments, because 240/500 = 0.48.
- **D. There is an association: 120/200 = 60% of patients on A recovered, compared with 120/300 = 40% on B.**

**N-2.2-A-v1.** A school tracked 400 students: 150 used tutoring and 250 did not.

| | Passed | Did not pass | Total |
|---|---|---|---|
| Tutoring | 105 | 45 | 150 |
| No tutoring | 125 | 125 | 250 |
| Total | 230 | 170 | 400 |

Which statement is correct?
- A. Tutoring does not help, because more students passed without tutoring (125) than with it (105).
- B. The pass rate is 57.5% for both groups, because 230/400 = 0.575.
- **C. There is an association: 105/150 = 70% of tutored students passed, compared with 125/250 = 50% of the others.**
- D. There is no association, because 105 and 125 are close.

**N-2.2-A-v2.** A delivery company recorded 500 deliveries by area and whether the delivery was late.

| | Late | On time | Total |
|---|---|---|---|
| City | 90 | 210 | 300 |
| Suburb | 60 | 140 | 200 |
| Total | 150 | 350 | 500 |

Which statement is correct?
- A. There is an association, because more city deliveries (90) than suburb deliveries (60) were late.
- B. The suburb has the lower late rate, because it has fewer deliveries.
- **C. There is no association in these data: 90/300 = 30% of city deliveries and 60/200 = 30% of suburb deliveries were late.**
- D. Lateness is related to area, because 150 of the 500 deliveries were late.

**N-2.2-A-v3.** A health app study followed 300 adults: 180 used a sleep app and 120 did not.

| | Improved sleep | Did not improve | Total |
|---|---|---|---|
| Used app | 72 | 108 | 180 |
| Did not use app | 66 | 54 | 120 |
| Total | 138 | 162 | 300 |

Which statement is correct?
- A. App users did better, because more app users improved (72) than non-users (66).
- **B. There is an association, and non-users did better: 66/120 = 55% of non-users improved, compared with 72/180 = 40% of app users.**
- C. There is no association, because 138/300 = 46% improved overall.
- D. The app has no effect, because 72 and 66 are nearly equal.

### Seed N-2.2-B — Conditional from a joint table (direction matters)
**Skill:** compute P(A | B) from joint relative frequencies and avoid reading P(B | A) or the joint value instead.

A survey classified adults by age group and phone type. The table shows the proportion of all adults in each category.

| | iOS | Android |
|---|---|---|
| Under 30 | 0.30 | 0.20 |
| 30 or older | 0.15 | 0.35 |

Among adults who use iOS, what proportion are under 30?
- A. 0.30
- B. 0.45
- **C. 0.67**
- D. 0.60

Check: P(iOS) = 0.45; 0.30/0.45 ≈ 0.667. A: joint. B: P(iOS). D: P(iOS | under 30) = 0.30/0.50 = 0.60.

**N-2.2-B-v1.** A study classified adults by exercise habit and sleep.

| | Sleeps 8+ hours | Sleeps less |
|---|---|---|
| Exercises regularly | 0.24 | 0.16 |
| Does not exercise regularly | 0.21 | 0.39 |

Among adults who sleep 8 or more hours, what proportion exercise regularly?
- A. 0.24
- B. 0.60
- C. 0.40
- **D. 0.53**
Check: P(sleeps 8+) = 0.45; 0.24/0.45 ≈ 0.533. A: joint. B: P(sleeps 8+ | exercises) = 0.24/0.40. C: P(exercises).

**N-2.2-B-v2.** Using the table in N-2.2-B-v1, among adults who do not exercise regularly, what proportion sleep 8 or more hours?
- **A. 0.35**
- B. 0.21
- C. 0.47
- D. 0.45
Check: P(not exercise) = 0.60; 0.21/0.60 = 0.35. B: joint. C: 0.21/0.45 = P(not exercise | sleeps 8+) ≈ 0.467. D: P(sleeps 8+).

**N-2.2-B-v3.** A library asked members whether they use e-books (A) and whether they attend events (B). Proportions of all members: A and B 0.18; A only 0.12; B only 0.32; neither 0.38. Among members who attend events, what proportion use e-books?
- A. 0.18
- B. 0.30
- C. 0.60
- **D. 0.36**
Check: P(B) = 0.50; 0.18/0.50 = 0.36. A: joint. B: P(A). C: P(B | A) = 0.18/0.30.

---

## TOPIC 2.3 — Estimating Probabilities Using Simulation

### Seed N-2.3-A — Design: waiting for the first success
**Skill:** build a valid simulation for a "number of trials until the first success" event.

A cereal company puts a prize in 25% of its boxes, randomly and independently. A student plans to use a table of random digits to estimate the probability that it takes at least 4 boxes to get the first prize. Which simulation design is valid?
- A. Let digits 0, 1 and 2 represent a prize. Read single digits until a prize appears, record the number of digits read, and repeat many times.
- B. Let two-digit numbers 01 to 25 represent a prize. One trial is a single two-digit number. Do the trial 4 times and record the proportion of prizes.
- C. Let two-digit numbers 01 to 25 represent a prize. One trial is four two-digit numbers; record whether none of them is a prize; repeat many times.
- **D. Let two-digit numbers 01 to 25 represent a prize. One trial is reading two-digit numbers until a prize appears, recording the number of boxes; repeat many times and find the proportion of trials needing at least 4 boxes.**
Rationales: A: 3 of 10 digits is 30%, not 25%. B: estimates the prize rate, not the waiting event. C: "none in four" estimates "at least 5 boxes".

**N-2.3-A-v1.** A scratch-off game wins on 20% of tickets, randomly and independently. A student wants to estimate the probability that it takes at least 3 tickets to get the first winner, using random digits. Which design is valid?
- A. Let digits 0, 1 and 2 represent a winner. Read digits until a winner appears, record the count, repeat many times.
- B. Let digits 0 and 1 represent a winner. One trial is three digits; record whether none is a winner; repeat many times.
- **C. Let digits 0 and 1 represent a winner. One trial is reading digits until a winner appears, recording the count; repeat many times and find the proportion of trials needing at least 3 tickets.**
- D. Let digits 0 and 1 represent a winner. One trial is a single digit; repeat 3 times and record the proportion of winners.
Rationales: A: 30%. B: "none in three" estimates "at least 4 tickets". D: estimates the winning rate.

**N-2.3-A-v2.** A basketball player makes 40% of her shots, independently. A student wants to estimate the probability that she makes exactly 2 of her next 5 shots, using random digits. Which design is valid?
- A. Let digits 0 to 4 represent a made shot. One trial is five digits; record whether exactly 2 are made; repeat many times.
- B. Let digits 0 to 3 represent a made shot. One trial is two digits; record whether both are made; repeat many times.
- **C. Let digits 0 to 3 represent a made shot. One trial is five digits; record whether exactly 2 are made; repeat many times.**
- D. Let digits 0 to 3 represent a made shot. One trial is five digits; record whether at least 2 are made; repeat many times.
Rationales: A: 50%. B: wrong number of shots and event. D: wrong event ("at least").

**N-2.3-A-v3.** The chance of rain on any day in a region is 35%, independently from day to day. A student wants to estimate the probability that it rains on exactly 2 of the next 3 days, using random digits. Which design is valid?
- A. Let digits 0 to 3 represent rain. One trial is three digits; record whether exactly 2 are rain; repeat many times.
- B. Let two-digit numbers 00 to 34 represent rain. One trial is two numbers; record whether both are rain; repeat many times.
- **C. Let two-digit numbers 00 to 34 represent rain. One trial is three numbers; record whether exactly 2 are rain; repeat many times.**
- D. Let two-digit numbers 00 to 34 represent rain. One trial is three numbers; record whether at least 2 are rain; repeat many times.
Rationales: A: 40%. B: wrong number of days. D: wrong event.

### Seed N-2.3-B — Reading and interpreting simulation results
**Skill:** read an estimate from simulation counts and interpret its reliability.

A student simulates flipping a fair coin 5 times and records the number of heads, repeating this for 100 trials.

| Heads | 0 | 1 | 2 | 3 | 4 | 5 |
|---|---|---|---|---|---|---|
| Trials | 3 | 15 | 32 | 30 | 16 | 4 |

Based on this simulation, what is the estimated probability of at least 4 heads, and which statement about it is best?
- A. 0.20; it is the exact probability, because 100 trials were used.
- **B. 0.20; it is an estimate that would change in a new simulation, and more trials would make it more reliable.**
- C. 0.16; it is an estimate that would change in a new simulation, and more trials would make it more reliable.
- D. 0.20; it is an estimate, and fewer trials would make it more reliable.
Check: (16 + 4)/100 = 0.20. C: exactly 4 heads.

**N-2.3-B-v1.** A student simulates a basketball player who makes 70% of her shots, taking 4 shots per trial, for 200 trials.

| Shots made | 0 | 1 | 2 | 3 | 4 |
|---|---|---|---|---|---|
| Trials | 2 | 18 | 50 | 80 | 50 |

What is the estimated probability that she makes at least 3 of 4 shots, and which statement is best?
- A. 0.40; it is an estimate that would change in a new simulation, and more trials would make it more reliable.
- B. 0.65; it is the exact probability, because the player's 70% rate is known.
- **C. 0.65; it is an estimate that would change in a new simulation, and more trials would make it more reliable.**
- D. 0.65; it is an estimate, and fewer trials would make it more reliable.
Check: (80 + 50)/200 = 0.65. A: exactly 3 made = 0.40.

**N-2.3-B-v2.** A student simulates choosing 3 bulbs at random from a large shipment and records how many are defective, for 50 trials.

| Defective bulbs | 0 | 1 | 2 | 3 |
|---|---|---|---|---|
| Trials | 30 | 15 | 4 | 1 |

What is the estimated probability that at least one chosen bulb is defective, and which statement is best?
- A. 0.30; it is an estimate that would change in a new simulation, and more trials would make it more reliable.
- B. 0.40; it is the exact probability, because all 50 trials are counted.
- **C. 0.40; it is an estimate that would change in a new simulation, and more trials would make it more reliable.**
- D. 0.40; it is an estimate, and fewer trials would make it more reliable.
Check: (15 + 4 + 1)/50 = 0.40. A: exactly one defective = 0.30.

**N-2.3-B-v3.** A student simulates families with 4 children, recording the number of boys, for 250 trials.

| Boys | 0 | 1 | 2 | 3 | 4 |
|---|---|---|---|---|---|
| Trials | 14 | 63 | 92 | 61 | 20 |

What is the estimated probability of at least 3 boys, and which statement is best?
- A. 0.368; it is an estimate that would change in a new simulation, and more trials would make it more reliable.
- B. 0.324; it is the exact probability, because 250 trials is a large number.
- C. 0.324; it is an estimate, and fewer trials would make it more reliable.
- **D. 0.324; it is an estimate that would change in a new simulation, and more trials would make it more reliable.**
Check: (61 + 20)/250 = 0.324. A: exactly 2 boys = 0.368.

---

## TOPIC 2.8 — Introduction to Random Variables and Probability Distributions

### Seed N-2.8-A — Find the constant, then an event probability
**Skill:** use "probabilities sum to 1" to find an unknown constant, then compute a probability for an event.

A random variable X takes the values 1, 2, 3 and 4 with P(X = x) = kx. What is P(X ≥ 3)?
- A. 0.3
- B. 0.4
- C. 0.5
- **D. 0.7**
Check: k + 2k + 3k + 4k = 10k = 1, so k = 0.1; P(X ≥ 3) = 0.3 + 0.4 = 0.7. A: P(X ≤ 2). B: P(X = 4). C: treated the four values as equally likely.

**N-2.8-A-v1.** A random variable X takes the values 0, 1, 2 and 3 with P(X = x) = k(x + 1). What is P(X < 2)?
- A. 0.7
- **B. 0.3**
- C. 0.2
- D. 0.1
Check: k + 2k + 3k + 4k = 10k = 1, so k = 0.1; P(X < 2) = 0.1 + 0.2 = 0.3. A: P(X ≥ 2) = 0.7, the complement. C: P(X = 1). D: P(X = 0).

**N-2.8-A-v2.** A random variable X has P(X = 1) = 0.25, P(X = 2) = k, P(X = 3) = 2k, and P(X = 4) = 0.15. What is P(X ≥ 3)?
- A. 0.35
- B. 0.45
- C. 0.40
- **D. 0.55**
Check: 0.25 + 3k + 0.15 = 1, so k = 0.20; P(X ≥ 3) = 0.40 + 0.15 = 0.55. A: forgot the 2k (0.20 + 0.15). B: P(X ≤ 2) = 0.25 + 0.20. C: P(X = 3).

**N-2.8-A-v3.** A random variable X takes the values 2, 4, 6 and 8 with probabilities k, 2k, 3k and 4k. What is the mean of X?
- A. 5
- **B. 6**
- C. 20
- D. 0.25
Check: k = 0.1; mean = 2(0.1) + 4(0.2) + 6(0.3) + 8(0.4) = 6.0. A: simple average of the values. C: sum of the values. D: average of the probabilities.

### Seed N-2.8-B — Recognising a valid distribution
**Skill:** test a table against both conditions (each probability between 0 and 1; probabilities sum to 1).

Which table shows a valid probability distribution for a random variable X?
- A. x = 0, 1, 2 with P(X = x) = 0.30, 0.50, 0.30
- B. x = 0, 1, 2 with P(X = x) = 0.50, 0.60, −0.10
- **C. x = 0, 1, 2 with P(X = x) = 0.20, 0.50, 0.30**
- D. x = 0, 1, 2 with P(X = x) = 0.20, 0.40, 0.30
Check: A sums to 1.10. B sums to 1.00 but has a negative value. C sums to 1.00 and every value is in [0, 1]. D sums to 0.90.

**N-2.8-B-v1.** Which table shows a valid probability distribution for a random variable Y?
- **A. y = 1, 2, 3, 4 with P(Y = y) = 0.10, 0.25, 0.35, 0.30**
- B. y = 1, 2, 3, 4 with P(Y = y) = 0.10, 0.25, 0.35, 0.35
- C. y = 1, 2, 3, 4 with P(Y = y) = 0.15, 0.25, 0.35, 0.20
- D. y = 1, 2, 3, 4 with P(Y = y) = 1.20, 0.30, −0.30, 0.80
Check: A sums to 1.00. B sums to 1.05. C sums to 0.95. D sums to 2.00 and has an out-of-range value.

**N-2.8-B-v2.** A table gives P(X = x) for x = 1, 2, 3, 4 as 0.40, 0.30, 0.20, 0.20. Which statement is correct?
- A. It is valid, because every probability is between 0 and 1.
- B. It is valid, because the values of x are whole numbers.
- **C. It is not valid, because the probabilities sum to 1.10, not 1.**
- D. It is not valid, because the first probability is greater than the others.
Check: 0.40 + 0.30 + 0.20 + 0.20 = 1.10.

**N-2.8-B-v3.** A table lists P(X = x) for x = 0, 1, 2, 3 as 0.15, 0.35, 0.30, 0.20. Which statement is correct?
- A. It is not valid, because the probabilities are not all equal.
- B. It is not valid, because the probabilities do not decrease as x increases.
- C. It is not valid, because the mean of the probabilities is not 1.
- **D. It is valid, because every probability is between 0 and 1 and the probabilities sum to 1.**
Check: 0.15 + 0.35 + 0.30 + 0.20 = 1.00.

---
Part 3 count: 8 seeds + 24 variants = 32 items.
Total across parts 1, 2 and 3: 20 seeds + 60 variants = 80 items.
Not done: same as parts 1 and 2 (labels, database-format rationales, publication, retirement of superseded items — here MCQ-073 and optionally OHT-2.2, with owner approval and an APPROVAL id).

---
---

# PART 4: topics 2.11 and 2.12 (new seeds and variants)

Each topic has one item today (OHT-2.11, R2, an empirical-rule lookup; OHT-2.12-r2, R3, the dotplot and CLT item). Both are kept. Two new seeds per topic, three variants each: 16 items. Normal values use z from the inverse normal (e.g. z = 1.2816 for the 90th percentile) and are rounded to the stated precision. Every number verified in Python. No checker pass. Not in the database.

---

## TOPIC 2.11 — The Normal Distribution

### Seed N-2.11-A — Percentile cutoff (inverse normal)
**Skill:** turn a percentile into a z-score, then back into a data value in context.

Heights of adult women in a region are approximately normal with mean 64 inches and standard deviation 3 inches. A clothing company wants to design a size that is at least as long as 90% of women are tall. About how tall is a woman at the 90th percentile?
- A. 60.2 inches
- B. 66.7 inches
- **C. 67.8 inches**
- D. 68.9 inches
Check: z = 1.2816; 64 + 1.2816(3) ≈ 67.84. A: the 10th percentile (z = −1.28). B: used 0.90 as the z-score, 64 + 0.9(3). D: used z = 1.645, the 95th percentile.

**N-2.11-A-v1.** Scores on a placement exam are approximately normal with mean 500 and standard deviation 100. A scholarship goes to students at or above the 75th percentile. About what score is needed?
- A. 432.6
- B. 575.0
- C. 664.5
- **D. 567.4**
Check: z = 0.6745; 500 + 67.45 ≈ 567.4. A: the 25th percentile. B: 500 + 0.75(100). C: z = 1.645.

**N-2.11-A-v2.** Birth weights of a species of puppy are approximately normal with mean 120 ounces and standard deviation 15 ounces. A vet flags the lightest 5% for extra monitoring. About what weight is the cutoff?
- **A. 95.3 ounces**
- B. 144.7 ounces
- C. 105.0 ounces
- D. 100.8 ounces
Check: z = −1.645; 120 − 1.645(15) ≈ 95.3. B: the 95th percentile. C: z = −1. D: z = −1.28, the 10th percentile.

**N-2.11-A-v3.** Reaction times in a game are approximately normal with mean 0.25 seconds and standard deviation 0.04 seconds. A trainer wants the cutoff for the slowest 10% of times. About what time is the cutoff?
- A. 0.199 seconds
- B. 0.254 seconds
- **C. 0.301 seconds**
- D. 0.316 seconds
Check: z = 1.2816; 0.25 + 1.2816(0.04) ≈ 0.301. A: the fastest 10%. B: 0.25 + 0.1(0.04). D: z = 1.645.

### Seed N-2.11-B — Find the mean from a percentile
**Skill:** solve for an unknown parameter using z = (x − μ)/σ when a proportion is given.

A machine fills bags with a weight that is approximately normal with a standard deviation of 10 grams. The weight is below 40 grams in 20% of bags. What is the mean weight?
- A. 31.6 grams
- B. 42.0 grams
- **C. 48.4 grams**
- D. 52.8 grams
Check: z for the 20th percentile = −0.8416; 40 = μ − 0.8416(10), so μ ≈ 48.4. A: wrong sign, 40 − 8.4. B: 40 + 0.2(10). D: used the 80th/90th-percentile z (1.28) instead.

**N-2.11-B-v1.** Test scores are approximately normal with a standard deviation of 8. Exactly 25% of scores are below 60. What is the mean?
- A. 54.6
- **B. 65.4**
- C. 62.0
- D. 70.3
Check: z = −0.6745; μ = 60 + 0.6745(8) ≈ 65.4. A: wrong sign. C: 60 + 0.25(8). D: used z = 1.28.

**N-2.11-B-v2.** The lengths of a part are approximately normal with a standard deviation of 4 mm. Exactly 10% of parts are longer than 50 mm. What is the mean length?
- A. 55.1 mm
- B. 49.6 mm
- C. 43.4 mm
- **D. 44.9 mm**
Check: z = +1.2816 above the mean; 50 = μ + 1.2816(4), so μ ≈ 44.9. A: wrong sign. B: 50 − 0.1(4). C: used z = 1.645.

**N-2.11-B-v3.** Commute times are approximately normal with a standard deviation of 15 minutes. About 30% of commutes are shorter than 100 minutes. What is the mean commute time?
- A. 92.1 minutes
- B. 104.5 minutes
- **C. 107.9 minutes**
- D. 112.6 minutes
Check: z = −0.5244; μ = 100 + 0.5244(15) ≈ 107.9. A: wrong sign. B: 100 + 0.3(15). D: used z = 0.84.

---

## TOPIC 2.12 — Sampling Distributions and the Central Limit Theorem

### Seed N-2.12-A — A probability about a sample mean
**Skill:** use the standard deviation of the sampling distribution, σ/√n, not σ, for a probability about x̄.

A population has mean 50 and standard deviation 12. A random sample of n = 36 is taken, and x̄ is the sample mean. Assuming the conditions for the Central Limit Theorem are met, what is P(x̄ > 53)?
- A. 0.4013
- B. 0.9332
- C. 0.1336
- **D. 0.0668**
Check: SD of x̄ = 12/√36 = 2; z = (53 − 50)/2 = 1.5; P(Z > 1.5) = 0.0668. A: used σ = 12, z = 0.25, a probability about one individual. B: P(Z < 1.5), the wrong tail. C: doubled to a two-sided area.

**N-2.12-A-v1.** A population has mean 100 and standard deviation 15. A random sample of n = 25 is taken. Assuming the conditions are met, what is P(x̄ < 94)?
- A. 0.3446
- B. 0.9772
- **C. 0.0228**
- D. 0.0455
Check: SD of x̄ = 15/5 = 3; z = −2; P = 0.0228. A: used σ, z = −0.4. B: wrong tail. D: doubled.

**N-2.12-A-v2.** A population has mean 8.5 and standard deviation 2.4. A random sample of n = 64 is taken. Assuming the conditions are met, what is P(7.9 < x̄ < 9.1)?
- A. 0.9772
- B. 0.1974
- C. 0.0455
- **D. 0.9545**
Check: SD of x̄ = 2.4/8 = 0.3; z = ±2; area between = 0.9545. A: P(Z < 2), one tail only. B: used σ, z = ±0.25. C: the area outside, 1 − 0.9545.

**N-2.12-A-v3.** A population has mean 30 and standard deviation 10. A random sample of n = 100 is taken. Assuming the conditions are met, what is P(x̄ > 31.2)?
- **A. 0.1151**
- B. 0.4522
- C. 0.8849
- D. 0.2301
Check: SD of x̄ = 10/10 = 1; z = 1.2; P(Z > 1.2) = 0.1151. B: used σ, z = 0.12. C: wrong tail. D: doubled.

### Seed N-2.12-B — How sample size changes the spread of x̄
**Skill:** the standard deviation of x̄ shrinks by 1/√n, independent of the population's shape.

A population of delivery times has standard deviation 20 minutes. A researcher takes random samples and computes the sample mean. When the sample size is 25, the standard deviation of the sampling distribution of x̄ is 4 minutes. If the sample size is increased to 100, which statement is correct?
- A. The standard deviation of x̄ decreases from 4 to 1, because four times as many observations make it one-fourth as large.
- **B. The standard deviation of x̄ decreases from 4 to 2, because it is proportional to 1/√n.**
- C. The standard deviation of x̄ stays at 4, because the population standard deviation is still 20.
- D. The standard deviation of x̄ increases, because a larger sample has more observations that can vary.
Check: 20/√25 = 4; 20/√100 = 2.

**N-2.12-B-v1.** A population has standard deviation 18. The standard deviation of x̄ for samples of size 9 is 6. If the sample size is increased to 36, what is the standard deviation of x̄?
- A. 1.5
- **B. 3**
- C. 6
- D. 9
Check: 18/√36 = 3. A: quartered (÷4). C: unchanged. D: increased.

**N-2.12-B-v2.** A population has standard deviation 30. With samples of size 16, the standard deviation of x̄ is 7.5. If the sample size is increased to 64, what happens to the standard deviation of x̄?
- A. It increases to 15.
- B. It decreases to about 1.9.
- C. It stays 7.5.
- **D. It decreases to 3.75.**
Check: 30/√64 = 3.75. B: divided by 4 again (÷4). A: increased.

**N-2.12-B-v3.** A researcher wants to reduce the standard deviation of x̄ to one-third of its current value. By what factor must the sample size be multiplied?
- A. 3
- B. 6
- **C. 9**
- D. 27
Check: SD ∝ 1/√n; 1/3 requires √n × 3, so n × 9. A: forgot the square root. D: cubed.

---
Part 4 count: 4 seeds + 12 variants = 16 items.
Total across parts 1 to 4: 24 seeds + 72 variants = 96 items. This covers every Unit 2 topic: 2.1 to 2.12.
Not done: topic and skill labels, database-format rationales, publication, retirement of superseded items, and final shuffling of key positions. Each needs your approval and a logged APPROVAL id.
