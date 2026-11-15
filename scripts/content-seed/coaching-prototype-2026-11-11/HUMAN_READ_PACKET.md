# Human read packet: coaching texts (blind)

Order is shuffled. No judge verdicts are shown in the body; they are in the key at the end (open it only after you have marked each one).

For each: **OK / WRONG / MISLEADING / TOO LONG / TONE**, plus a note. Ask yourself: if a student read this right after missing, would it teach them something false, or send them off the point?

---

## 1. FRQ

**Student response (synthetic):**

> (a) We are 95% confident that the interval from 0.046 to 0.174 captures the difference between the proportion of all Riverton adults who used a library in the past month and the proportion of all Lakeside adults, Riverton minus Lakeside.
> 
> (b) If we took many pairs of random samples of 500 Riverton adults and 400 Lakeside adults and built a 95% interval from each pair, about 95% of those intervals would contain the true difference in the proportions.
> 
> (c) The first claim is supported because 0 is not in the interval, so there is convincing evidence the proportions differ. The second claim is also roughly consistent with the interval since 0.20 is close to the upper limit of 0.174, so the difference could be about 20 percentage points.
> 
> (d) The interval came from random samples, so it may or may not contain the true difference. The 95% confidence only means that about 5% of intervals built this way would miss, so the resident is wrong to say the true difference must be between 0.046 and 0.174.

**Criteria the student missed:** part-c-criterion-02

- part-c-criterion-02 (1 pt): States that the interval does not support the second claim because every plausible value of p₁ − p₂ is less than 0.20 (0.20 is above the upper limit 0.174).

**Coaching text:**

> You earned parts (a), (b), and (d). For part (c), the second claim costs you a point. You wrote the difference "could be about 20 percentage points," but the interval's upper limit is 0.174—every plausible value is below 0.20. The trap is treating "close to" as support. Convert the claim to a difference (0.20) and check whether it falls inside the interval; since it doesn't, the interval does not support the claim. Next time, state that explicitly.

**Your mark:** 

**Note:** 

---

## 2. MCQ

**Question:** A researcher wants to know whether more than half of the voters in a large state support a ballot measure. In a random sample of 100 voters, 62 support it. For a one-sample z-test of H0: p = 0.50 versus Ha: p > 0.50, which value is the test statistic?

- A. z = 0.24
- B. z = 2.40  **(correct)**
- C. z = 2.47
- D. z = 24

**Student picked:** D

**Authored rationale for that choice:** Divided sqrt[p0(1 - p0)] by n instead of taking the square root of p0(1 - p0)/n.

**Coaching text:**

> You put \(n\) outside the square root, making the standard error too small and \(z\) too large. The test-statistic point requires \(p_0\) in the standard error, with \(n\) inside the radical: \(\sqrt{p_0(1-p_0)/n}\). Write that structure before substituting; here, the statistic is \(z=2.40\).

**Your mark:** 

**Note:** 

---

## 3. MCQ

**Question:** A school fair sells 500 tickets at $4 each. There is one prize of $600 and two prizes of $100. What is the expected net gain for a person who buys one ticket?

- A. $1.60
- B. −$2.40  **(correct)**
- C. −$2.80
- D. −$4.00

**Student picked:** C

**Authored rationale for that choice:** This counts only the $600 prize (expected $1.20) and leaves out the two $100 prizes.

**Coaching text:**

> Your −$2.80 counts only the $600 prize: 600/500 = 1.20, then 1.20 − 4. The two $100 prizes are outcomes too, each with probability 2/500, and they were left out. Include every outcome, each multiplied by its probability: (600 + 2·100)/500 = 1.60, then subtract the $4 cost to get −$2.40. Next time, list every prize value beside its probability, sum the products, then subtract the ticket price.

**Your mark:** 

**Note:** 

---

## 4. MCQ

**Question:** The annual salaries, in thousands of dollars, of the 38 employees of a small firm form a distribution with these features: most salaries are between 42 and 78, with a single peak, a median of 57, Q1 = 50 and Q3 = 64; two employees earn about 140 and 155, far above everyone else; the mean is about 63 and the standard deviation about 22. Which is the best description of the distribution of salaries?

- A. The salaries are roughly symmetric and centered near $63 thousand, and they typically vary from the center by about $22 thousand.
- B. The distribution is skewed right, with a median of 57 and an interquartile range of 14.
- C. The salaries are skewed to the right by two high outliers (about $140 thousand and $155 thousand); the typical salary is about $57 thousand, and the middle 50% span about $14 thousand.  **(correct)**
- D. The salaries are bimodal, with one peak near $57 thousand and a second peak near $150 thousand.

**Student picked:** B

**Authored rationale for that choice:** This gives shape, center and spread but with no units or context and no mention of the two unusually high salaries, so it is not a complete description in context.

**Coaching text:**

> You identify the right skew, median, and IQR, but stop at the statistics: B omits the salary context and the two unusually high values, costing you the complete-description-in-context point. Next time, include shape, center, spread, and unusual values with units: right-skewed by two high outliers, typical salary about $57,000, and the middle 50% spanning $14,000.

**Your mark:** 

**Note:** 

---

## 5. MCQ

**Question:** A laboratory develops a treatment that strengthens bacterial cell walls without changing the plasma membranes. Treated and untreated bacteria are exposed to conditions that drive water into the cells, causing some untreated bacteria to rupture. Which prediction about the treated bacteria is best supported?

- A. More treated bacteria will rupture because stronger walls prevent the unrestricted membrane expansion needed for protection.
- B. Fewer treated bacteria will rupture because stronger walls provide greater resistance to expansion as water enters.  **(correct)**
- C. Treated bacteria will gain different plasma-membrane selectivity because the strengthened walls determine which molecules cross the membrane.
- D. Treated bacteria will have the same rupture risk because their plasma membranes already provide structural support equivalent to the walls.

**Student picked:** A

**Authored rationale for that choice:** The flexibility-as-protection error treats unrestricted expansion as protective. A plasma membrane cannot stretch indefinitely; resistance from the wall helps prevent rupture rather than causing it. Fix: Identify which structure limits expansion before predicting the risk of rupture.

**Coaching text:**

> You picked A because you treated the plasma membrane's flexibility as the protection. But a membrane cannot stretch indefinitely; rupture happens when expansion exceeds what the wall can resist. The strengthened wall adds mechanical support, so fewer treated bacteria rupture. Next time, first identify which structure limits expansion, then predict the rupture risk. That matches the exam's move of explaining outcomes from structure, not from assumptions about flexibility.

**Your mark:** 

**Note:** 

---

## 6. FRQ

**Student response (synthetic):**

> (a) This is a chi-square test for homogeneity because separate random samples were taken from three cities, and we are comparing the distribution of main news source across those populations.
> 
> (b) H₀: The distribution of main news source (television, online, other) is the same for adults in all three cities. Hₐ: The distribution of main news source is not the same for adults in all three cities.
> 
> (c) Each city has more than 500,000 adults, so 10% of each city is more than 50,000. Each sample of 150 is far less than that, so the 10% condition is met.
> 
> (d) The chi-square statistic adds up (observed − expected)²/expected over all cells. Each term measures how far an observed count is from its expected count, relative to the expected count. A large value means the observed counts are far from what we would expect if the distributions were the same, which is evidence against H₀.

**Criteria the student missed:** part-c-criterion-02+part-d-criterion-01

- part-c-criterion-02 (1 pt): States that all expected counts are greater than 5 (the smallest is 19.3).
- part-d-criterion-01 (1 pt): States that the chi-square distribution with 4 degrees of freedom is skewed right, and that the distribution with 10 degrees of freedom is less skewed (its skew is less pronounced).

**Coaching text:**

> Your 10% check is correct, but it does not verify the expected-count condition, which costs that condition point. Add that every expected count exceeds 5; the smallest is 19.3. In part (d), you explain what a large statistic means, but leave out the distribution-shape comparison, costing that point. State that the 4-df distribution is skewed right and the 10-df distribution is less skewed.

**Your mark:** 

**Note:** 

---

## 7. MCQ

**Question:** A researcher wants to know whether more than half of the voters in a large state support a ballot measure. In a random sample of 100 voters, 62 support it. For a one-sample z-test of H0: p = 0.50 versus Ha: p > 0.50, which value is the test statistic?

- A. z = 0.24
- B. z = 2.40  **(correct)**
- C. z = 2.47
- D. z = 24

**Student picked:** C

**Authored rationale for that choice:** Used p-hat in the standard error; in a test the standard error uses the hypothesized p0.

**Coaching text:**

> You chose C by putting p-hat under the radical. That costs the point for computing the test statistic: in a one-proportion z-test, the standard error must use the null p0, not p-hat, because you're measuring distance from the claim. Next, before calculating, write z = (0.62 - 0.50) / sqrt(0.50(0.50)/100) and check that p0 satisfies the large-counts condition.

**Your mark:** 

**Note:** 

---

## 8. MCQ

**Question:** A manufacturer reports that 45% of its tablets pass inspection on the first try. A random sample of 100 tablets gives a sample proportion of 0.50. Which statement is correct?

- A. The sample proportion is about 10 standard deviations above 0.45, since the standard deviation of the sampling distribution is 0.005.
- B. The sample proportion is about 1 standard deviation above 0.45, so a result this large would not be unusual if the true proportion were 0.45.  **(correct)**
- C. The sample proportion is 0.05 above 0.45, which is too large a gap to be ordinary sampling variability.
- D. The sample proportion is about 20 standard deviations above 0.45, since the standard deviation of the sampling distribution is 0.0025.

**Student picked:** A

**Authored rationale for that choice:** Divided sqrt[p(1 - p)] by n instead of taking the square root of p(1 - p)/n, which makes the standard deviation far too small.

**Coaching text:**

> You use \(p(1-p)/n\) as the standard deviation; it is the variance, so you miss the square root. Here, \(\sigma_{\hat p}=\sqrt{0.45(0.55)/100}\approx0.05\), making 0.50 about 1 standard deviation above 0.45—not unusual (B). To earn the setup point, name the mean and SD of \(\hat p\), check the sampling conditions, then interpret the result in context.

**Your mark:** 

**Note:** 

---

## 9. MCQ

**Question:** When oxygen is removed from isolated mitochondria that are supplied with NADH, ATP production by ATP synthase quickly falls. Which statement best explains this result?

- A. Oxygen binds directly to ADP and phosphate to form ATP.
- B. Oxygen is required to split glucose during glycolysis in the mitochondria in order to feed the later steps.
- C. Oxygen supplies the protons that are pumped across the inner mitochondrial membrane.
- D. Oxygen is the final electron acceptor, so without it electron flow stops and the proton gradient used by ATP synthase is no longer maintained.  **(correct)**

**Student picked:** A

**Authored rationale for that choice:** Tempting because oxygen is linked with energy release. But oxygen does not make ATP directly; ATP synthase does. Fix: trace oxygen to the end of the electron transport chain, where it accepts electrons, not to ATP synthase.

**Coaching text:**

> You picked oxygen as a direct reactant in ATP formation, but that conflates oxygen’s role with ATP synthase’s job. The point cost: connecting oxygen to chemiosmosis. Instead, trace electrons from NADH through the chain to oxygen, then note how the proton gradient runs ATP synthase.

**Your mark:** 

**Note:** 

---

## 10. MCQ

**Question:** A laboratory develops a treatment that strengthens bacterial cell walls without changing the plasma membranes. Treated and untreated bacteria are exposed to conditions that drive water into the cells, causing some untreated bacteria to rupture. Which prediction about the treated bacteria is best supported?

- A. More treated bacteria will rupture because stronger walls prevent the unrestricted membrane expansion needed for protection.
- B. Fewer treated bacteria will rupture because stronger walls provide greater resistance to expansion as water enters.  **(correct)**
- C. Treated bacteria will gain different plasma-membrane selectivity because the strengthened walls determine which molecules cross the membrane.
- D. Treated bacteria will have the same rupture risk because their plasma membranes already provide structural support equivalent to the walls.

**Student picked:** A

**Authored rationale for that choice:** The flexibility-as-protection error treats unrestricted expansion as protective. A plasma membrane cannot stretch indefinitely; resistance from the wall helps prevent rupture rather than causing it. Fix: Identify which structure limits expansion before predicting the risk of rupture.

**Coaching text:**

> You treated the wall as something that adds flexibility, so you predicted more ruptures. A cell wall mechanically opposes expansion when water enters, so strengthening it reduces rupture even though the plasma membrane is unchanged (B). Next time, before predicting, name the structure that limits expansion and state how the treatment changes it. Base the prediction on that structural role, not on what would help the cell.

**Your mark:** 

**Note:** 

---

## 11. MCQ

**Question:** A zoo veterinarian weighs all 15 giraffes at the zoo to describe the herd. What is this called?

- A. A random sample of giraffes
- B. A census of the herd  **(correct)**
- C. An experiment
- D. A convenience sample

**Student picked:** A

**Authored rationale for that choice:** A random sample uses chance to pick only some members of the population; here all 15 were measured.

**Coaching text:**

> You picked A, but the veterinarian measured every giraffe in the herd, so no sample was drawn. Ask first: did the researcher select some members, or include all of them? Here it was all 15, which makes this a census of the population of interest (B). Next time, before naming a sampling method, check whether any units were left out. If none were, the study is a census, not a sample, and that distinction is where this point is earned.

**Your mark:** 

**Note:** 

---

## 12. FRQ

**Student response (synthetic):**

> (a) This is a chi-square test for homogeneity because separate random samples were taken from three cities, and we are comparing the distribution of main news source across those populations.
> 
> (b) H₀: The distribution of main news source (television, online, other) is the same for adults in all three cities. Hₐ: The distribution of main news source is not the same for adults in all three cities.
> 
> (c) Each city has more than 500,000 adults, so 10% of each city is more than 50,000. Each sample of 150 is far less than that, so the 10% condition is met.
> 
> (d) The chi-square statistic adds up (observed − expected)²/expected over all cells. Each term measures how far an observed count is from its expected count, relative to the expected count. A large value means the observed counts are far from what we would expect if the distributions were the same, which is evidence against H₀.

**Criteria the student missed:** part-c-criterion-02+part-d-criterion-01

- part-c-criterion-02 (1 pt): States that all expected counts are greater than 5 (the smallest is 19.3).
- part-d-criterion-01 (1 pt): States that the chi-square distribution with 4 degrees of freedom is skewed right, and that the distribution with 10 degrees of freedom is less skewed (its skew is less pronounced).

**Coaching text:**

> You lost two points in parts (c) and (d).
> 
> In (c), you checked the 10% condition but never addressed expected counts. Find the smallest expected count in the table (19.3) and write that every expected count is greater than 5. Check the expected counts, not the observed ones.
> 
> In (d), you explained what the statistic measures but did not describe the distribution's shape. Chi-square distributions are skewed right. The df = 4 distribution is more strongly skewed than the df = 10 distribution, which is less skewed. Write one sentence comparing the two shapes.

**Your mark:** 

**Note:** 

---

## 13. MCQ

**Question:** A researcher wants to know whether more than half of the voters in a large state support a ballot measure. In a random sample of 100 voters, 62 support it. For a one-sample z-test of H0: p = 0.50 versus Ha: p > 0.50, which value is the test statistic?

- A. z = 0.24
- B. z = 2.40  **(correct)**
- C. z = 2.47
- D. z = 24

**Student picked:** A

**Authored rationale for that choice:** Left n out of the standard error, dividing by sqrt[p0(1 - p0)] only.

**Coaching text:**

> You left n out of the standard error, dividing by sqrt[p0(1-p0)] only. That drops the sample size from the denominator, inflating z. Write the full formula first—sqrt(p0(1-p0)/n)—then plug in 0.50 and 100 before doing arithmetic. Showing that setup is the rubric habit that earns the point.

**Your mark:** 

**Note:** 

---

## 14. MCQ

**Question:** A researcher wants to know whether more than half of the voters in a large state support a ballot measure. In a random sample of 100 voters, 62 support it. For a one-sample z-test of H0: p = 0.50 versus Ha: p > 0.50, which value is the test statistic?

- A. z = 0.24
- B. z = 2.40  **(correct)**
- C. z = 2.47
- D. z = 24

**Student picked:** A

**Authored rationale for that choice:** Left n out of the standard error, dividing by sqrt[p0(1 - p0)] only.

**Coaching text:**

> Your 0.24 came from dividing 0.12 by sqrt(0.50 × 0.50) = 0.50, which drops the n = 100 from the standard error. The test uses sqrt(p0(1 − p0)/n), so the denominator is 0.05. Points for this step require p0 in the standard error with n included. Before plugging in numbers, write the full radical with n inside, then compute. The correct answer is z = 2.40, from 0.12 / 0.05.

**Your mark:** 

**Note:** 

---

## 15. MCQ

**Question:** A bag contains 6 green marbles and 4 yellow marbles. Two marbles are drawn at random, one after the other, without replacement. What is the probability that both marbles are the same color?

- A. 13/25
- B. 1/3
- C. 7/15  **(correct)**
- D. 4/15

**Student picked:** A

**Authored rationale for that choice:** This treats the draws as if each item were replaced, but the draws are made without replacement, so the second draw has a different composition.

**Coaching text:**

> You treated the second draw as if the first marble were replaced, keeping the denominator at 10. That is the independence trap: without replacement, the second branch's probabilities must shrink to 5/9 and 3/9. The point brief's answer move is to build the tree before computing. Next time, sketch both same-color branches and update the counts after the first draw; that earns the multiplication-rule point.

**Your mark:** 

**Note:** 

---

## 16. MCQ

**Question:** A laboratory develops a treatment that strengthens bacterial cell walls without changing the plasma membranes. Treated and untreated bacteria are exposed to conditions that drive water into the cells, causing some untreated bacteria to rupture. Which prediction about the treated bacteria is best supported?

- A. More treated bacteria will rupture because stronger walls prevent the unrestricted membrane expansion needed for protection.
- B. Fewer treated bacteria will rupture because stronger walls provide greater resistance to expansion as water enters.  **(correct)**
- C. Treated bacteria will gain different plasma-membrane selectivity because the strengthened walls determine which molecules cross the membrane.
- D. Treated bacteria will have the same rupture risk because their plasma membranes already provide structural support equivalent to the walls.

**Student picked:** A

**Authored rationale for that choice:** The flexibility-as-protection error treats unrestricted expansion as protective. A plasma membrane cannot stretch indefinitely; resistance from the wall helps prevent rupture rather than causing it. Fix: Identify which structure limits expansion before predicting the risk of rupture.

**Coaching text:**

> You treat membrane flexibility as protection, but the wall resists the expansion caused by water entering. B is supported: stronger walls mean fewer ruptures. For the membrane-permeability point, check which structure changes before predicting an effect; use molecule properties and membrane composition to explain passage, and the wall’s role to explain mechanical support.

**Your mark:** 

**Note:** 

---

## 17. MCQ

**Question:** A researcher wants to know whether more than half of the voters in a large state support a ballot measure. In a random sample of 100 voters, 62 support it. For a one-sample z-test of H0: p = 0.50 versus Ha: p > 0.50, which value is the test statistic?

- A. z = 0.24
- B. z = 2.40  **(correct)**
- C. z = 2.47
- D. z = 24

**Student picked:** D

**Authored rationale for that choice:** Divided sqrt[p0(1 - p0)] by n instead of taking the square root of p0(1 - p0)/n.

**Coaching text:**

> You divided by sqrt[p0(1-p0)] before dividing by n, which changes the standard error. The z-statistic uses sqrt[p0(1-p0)/n] as a single quantity, so the square root applies to the entire fraction. Next, write out the standard error in one step before computing z. This protects the point for computing the test statistic with p0.

**Your mark:** 

**Note:** 

---

## 18. MCQ

**Question:** A cereal company puts a prize in 25% of its boxes, randomly and independently. A student plans to use a table of random digits to estimate the probability that it takes at least 4 boxes to get the first prize. Which simulation design is valid?

- A. Let digits 0, 1 and 2 represent a prize. Read single digits until a prize appears, record the number of digits read, and repeat many times.
- B. Let two-digit numbers 01 to 25 represent a prize. One trial is reading two-digit numbers until a prize appears, recording the number of boxes; repeat many times and find the proportion of trials needing at least 4 boxes.  **(correct)**
- C. Let two-digit numbers 01 to 25 represent a prize. One trial is a single two-digit number. Do the trial 4 times and record the proportion of prizes.
- D. Let two-digit numbers 01 to 25 represent a prize. One trial is four two-digit numbers; record whether none of them is a prize; repeat many times.

**Student picked:** D

**Authored rationale for that choice:** Recording "no prize in four boxes" estimates the chance of needing at least 5 boxes, not at least 4.

**Coaching text:**

> D treats "at least 4 boxes" as "no prize in the first four," which actually estimates needing 5 or more. The trap is shifting the boundary by one. A valid simulation records the number of digits read until the first prize appears, then counts trials where that number is 4 or greater. Redo the design with that stopping rule and recorded quantity.

**Your mark:** 

**Note:** 

---

## 19. MCQ

**Question:** A plant tissue has a water potential of -4.0 bar. A researcher wants a sucrose solution in an open beaker at 20°C (293 K) that produces no net water movement. Use solute potential = -iCRT, with i = 1 for sucrose and R = 0.0831 liter bar per mole kelvin. Which concentration is needed?

- A. 2.4 M
- B. 0.16 M  **(correct)**
- C. 0.082 M
- D. 0.014 M

**Student picked:** D

**Authored rationale for that choice:** 0.014 M results from leaving out the gas constant R in the calculation.

**Coaching text:**

> You leave out \(R\), which makes your calculated concentration too high. In the open beaker, \(\Psi_p=0\), so use \(-4.0=-iCRT\); this gives \(0.16\text{ M}\) (B). For the exam point on comparing solute concentrations, include every term in the equation, then check that the solution matches the tissue’s water potential so there is no net water movement.

**Your mark:** 

**Note:** 

---

## 20. MCQ

**Question:** A laboratory develops a treatment that strengthens bacterial cell walls without changing the plasma membranes. Treated and untreated bacteria are exposed to conditions that drive water into the cells, causing some untreated bacteria to rupture. Which prediction about the treated bacteria is best supported?

- A. More treated bacteria will rupture because stronger walls prevent the unrestricted membrane expansion needed for protection.
- B. Fewer treated bacteria will rupture because stronger walls provide greater resistance to expansion as water enters.  **(correct)**
- C. Treated bacteria will gain different plasma-membrane selectivity because the strengthened walls determine which molecules cross the membrane.
- D. Treated bacteria will have the same rupture risk because their plasma membranes already provide structural support equivalent to the walls.

**Student picked:** C

**Authored rationale for that choice:** The wall–membrane confusion assigns the plasma membrane’s selective function to the wall. Strengthening the wall does not change the unchanged membrane’s hydrophobic barrier or its molecular selectivity. Fix: Locate the selective barrier and check whether the treatment changes it.

**Coaching text:**

> You picked C, which assigns selectivity to the wall. The item says the treatment leaves the plasma membranes unchanged, so the hydrophobic bilayer still controls what crosses. The wall's job here is mechanical: it opposes expansion as water enters. For this kind of prediction, the points come from linking the structure to its role, so next time ask which structure resists the stress, then predict the outcome from that structure alone. Correct answer: B, because stronger walls resist expansion and reduce rupture.

**Your mark:** 

**Note:** 

---

## 21. MCQ

**Question:** Equal amounts of three lipids are added to separate tubes of water and shaken. Phospholipid: forms a cloudy mixture of tiny sacs, each enclosing a droplet of water. Triglyceride: forms oily droplets that merge into a layer on top and shows no ordered structure. Which statement best explains why the triglyceride does not assemble like the phospholipid?

- A. The triglyceride has a larger mass than the phospholipid, so it sinks.
- B. The triglyceride has fewer fatty acid tails than the phospholipid, so it cannot form droplets.
- C. The triglyceride is hydrophilic, so it dissolves completely in water.
- D. The triglyceride has no polar head group, so the whole molecule is nonpolar and is excluded from water, whereas the phospholipid has a polar phosphate-containing head and nonpolar tails.  **(correct)**

**Student picked:** A

**Authored rationale for that choice:** The triglyceride floats on top, which shows it is less dense than water, so mass is not the cause.

**Coaching text:**

> You picked density because the triglyceride floats, but that observes the symptom, not the cause. The exam point is distinguishing lipid classes by structure, not lumping them together. Your move: before comparing physical behavior, check polarity—does it have a polar head? The triglyceride is entirely nonpolar, whereas the phospholipid is amphipathic.

**Your mark:** 

**Note:** 

---

## 22. MCQ

**Question:** A cereal company puts a prize in 25% of its boxes, randomly and independently. A student plans to use a table of random digits to estimate the probability that it takes at least 4 boxes to get the first prize. Which simulation design is valid?

- A. Let digits 0, 1 and 2 represent a prize. Read single digits until a prize appears, record the number of digits read, and repeat many times.
- B. Let two-digit numbers 01 to 25 represent a prize. One trial is reading two-digit numbers until a prize appears, recording the number of boxes; repeat many times and find the proportion of trials needing at least 4 boxes.  **(correct)**
- C. Let two-digit numbers 01 to 25 represent a prize. One trial is a single two-digit number. Do the trial 4 times and record the proportion of prizes.
- D. Let two-digit numbers 01 to 25 represent a prize. One trial is four two-digit numbers; record whether none of them is a prize; repeat many times.

**Student picked:** A

**Authored rationale for that choice:** Three of the ten digits is 30%, not 25%, so the simulated prize rate is wrong.

**Coaching text:**

> A is invalid because 3 of 10 digits is 30%, not the given 25% prize rate. The rubric point for simulation design requires your digit mapping to match the real-world probability exactly. Next time, convert 25% into 25 of 100 two-digit numbers, 01–25, before defining trials. That fixes both the probability and the trial structure.

**Your mark:** 

**Note:** 

---

# Key (open after marking)

1. apstats-frq-u13g-3-11 pick part-c-criterion-02 | deepseek-v4-flash | judges factually_correct: true/true
2. APSTATS-MCQ-SV-H-3.7-A-v3 pick D | gpt-6-luna | judges factually_correct: true/true
3. APSTATS-MCQ-SV-H-2.9-B-v1 pick C | claude-haiku-5.5 | judges factually_correct: false/false
   - glm-5.3-flash: The coaching text says the two $100 prizes are outcomes 'each with probability 2/500.' That is wrong: each individual $100 prize has probability 1/500; the combined probability of winning $100 (either prize) is 2/500. The final arithmetic happens to work out because the text then writes (600 + 2·100)/500, which implicitly uses 1/500 per prize, but the stated per-outcome probability is incorrect and would mislead a student who applies it to a single-outcome expected-value setup.
   - gemini-3.8-flash: The coaching text states that the two $100 prizes have a probability of '2/500 each'. Each individual $100 prize has a probability of 1/500 (or the probability of winning a $100 prize is 2/500 in total).
4. apstats-mcq-b7-h-1.6-a pick B | gpt-6-luna | judges factually_correct: true/false
   - glm-5.3-flash: The coaching text frames the student's pick as if it were a free-response description that 'cost you the complete-description-in-context point.' This was a multiple-choice question — the student selected B, and there is no partial credit or 'point' to lose. The text also never explains WHY C beats B: it omits the decisive authored reasoning that the 1.5×IQR fence (64 + 1.5(14) = 85) lies below 140 and 155, formally establishing the two salaries as outliers. Without that, the student cannot distinguish 'mention the outliers' as a stylistic nicety from the actual statistical justification that makes C the best answer.
5. APBIO-MCQ-SV-135-v2 pick A | deepseek-v4-flash | judges factually_correct: true/true
6. apstats-frq-u13g-3-14 pick part-c-criterion-02+part-d-criterion-01 | gpt-6-luna | judges factually_correct: true/true
7. APSTATS-MCQ-SV-H-3.7-A-v3 pick C | deepseek-v4-flash | judges factually_correct: true/true
8. APSTATS-MCQ-SV-H-3.2-A-v3 pick A | gpt-6-luna | judges factually_correct: true/false
   - gemini-3.8-flash: The coaching text claims the student used p(1-p)/n as the standard deviation (which yields 0.0025, Choice D), whereas the student picked Choice A (which gives 0.005 by dividing sqrt(p(1-p)) by n).
9. APBIO-OHT-3.5 pick A | deepseek-v4-flash | judges factually_correct: false/false
   - gemini-3.8-flash: The text states 'The point cost: connecting oxygen to chemiosmosis', which contradicts the point brief; connecting oxygen's role in the electron transport chain to the proton gradient driving ATP synthesis (chemiosmosis) earns points, rather than costing them.
   - glm-5.3-flash: The diagnosis and fix are sound, but the point-cost line misstates what the student loses points for. The point brief says the common point loss is 'saying oxygen makes ATP directly instead of explaining its role as final electron acceptor.' The coaching text instead claims the point cost is 'connecting oxygen to chemiosmosis' — but the student's error (choice A) was placing oxygen at the ATP synthesis step, not at the chemiosmosis/gradient step. The actual point loss is failing to identify oxygen as the final electron acceptor that keeps electron flow and proton pumping going.
10. APBIO-MCQ-SV-135-v2 pick A | claude-haiku-5.5 | judges factually_correct: false/true
   - gemini-3.8-flash: Choice A states that stronger walls prevent membrane expansion, not that the wall adds flexibility; the misconception in Choice A is viewing membrane expansion/flexibility as protective rather than viewing the wall as adding flexibility.
11. APSTATS-MCQ-SV-045-v3 pick A | claude-haiku-5.5 | judges factually_correct: true/false
   - glm-5.3-flash: The coaching text's explanation of the answer itself is accurate (all 15 measured → census, not a sample, matching the rationales for A and B), but its closing claim — 'that distinction is where this point is earned' — contradicts the point brief, which states points are earned by classifying a study as observational vs. experimental (and then prospective vs. retrospective), not by the census-vs-sample distinction. The text also skips the point brief's required answer move entirely: it never asks whether a treatment was imposed, so the student is never told this is an observational study (which the rationale for C confirms).
12. apstats-frq-u13g-3-14 pick part-c-criterion-02+part-d-criterion-01 | claude-haiku-5.5 | judges factually_correct: true/true
13. APSTATS-MCQ-SV-H-3.7-A-v3 pick A | deepseek-v4-flash | judges factually_correct: false/false
   - gemini-3.8-flash: Leaving n out of the denominator makes the standard error larger (0.50 instead of 0.05), which deflates z to 0.24 rather than inflating it.
14. APSTATS-MCQ-SV-H-3.7-A-v3 pick A | claude-haiku-5.5 | judges factually_correct: true/true
15. APSTATS-MCQ-SV-H-2.6-B-v1 pick A | deepseek-v4-flash | judges factually_correct: false/false
   - glm-5.3-flash: The coaching text misattributes the point brief's answer move. The brief's actual answer move is about translating the conditioning phrase ('given that' / 'of the') into the denominator and noting that reversing conditioning changes the answer. Building a tree before computing is not the stated answer move; the tree diagram is only mentioned as one way to earn the conditional-probability point. The rest of the diagnosis is sound: A (13/25) does correspond to with-replacement arithmetic, (6/10)(6/10) + (4/10)(4/10) = 52/100, and the correct answer C = (6/10)(5/9) + (4/10)(3/9) = 42/90 = 7/15 does require the second-draw denominators to drop to 9. The claim that sketching the branches and updating counts earns the multiplication-rule point is consistent with the brief.
   - gemini-3.8-flash: The coaching text states that the point brief's answer move is to build the tree before computing, which directly contradicts the authored point brief's stated answer move.
16. APBIO-MCQ-SV-135-v2 pick A | gpt-6-luna | judges factually_correct: true/true
17. APSTATS-MCQ-SV-H-3.7-A-v3 pick D | deepseek-v4-flash | judges factually_correct: true/false
   - gemini-3.8-flash: The rationale states that the student 'Divided sqrt[p0(1 - p0)] by n' (giving 0.5/100 = 0.005, and 0.12/0.005 = 24). The coaching text states 'You divided by sqrt[p0(1-p0)] before dividing by n', which mathematically yields (0.12 / 0.5) / 100 = 0.0024 instead of 24.
18. APSTATS-MCQ-H-2.3-A pick D | deepseek-v4-flash | judges factually_correct: false/true
   - glm-5.3-flash: The coaching text says a valid simulation 'records the number of digits read until the first prize appears.' That is wrong terminology for this design. The correct design (choice B) uses two-digit numbers, not single digits: each two-digit number represents one box, and the trial records the number of two-digit numbers (boxes) read until the first prize appears. Saying 'digits' describes choice A's device, which the rationale itself rejects as an invalid 30% prize rate. The boundary-shift explanation (no prize in four boxes estimates needing 5 or more) and the '4 or greater' stopping condition are correct; only the word 'digits' is wrong.
19. apbio-mcq-b5-sv-h-2.7-a-v2 pick D | gpt-6-luna | judges factually_correct: false/false
   - glm-5.3-flash: The coaching text states that leaving out R makes the calculated concentration 'too high,' but the arithmetic shows the opposite. Omitting R gives C = 4.0 / (1 × 293) ≈ 0.014 M, which is far too LOW compared to the correct 0.164 M (since R = 0.0831 sits in the denominator, dropping it shrinks the denominator and shrinks the result). The student's wrong answer (D, 0.014 M) is an underestimate, not an overestimate.
   - gemini-3.8-flash: The coaching text states that leaving out R makes the calculated concentration too high, but leaving out R (0.0831) in the denominator divides by 293 instead of 24.35, resulting in 0.014 M, which is too low compared to the correct value of 0.16 M.
20. APBIO-MCQ-SV-135-v2 pick C | claude-haiku-5.5 | judges factually_correct: true/true
21. apbio-mcq-b6-h-1.5-a pick A | deepseek-v4-flash | judges factually_correct: true/false
   - gemini-3.8-flash: Choice A states that the triglyceride 'sinks', but the coaching text incorrectly states 'You picked density because the triglyceride floats'.
22. APSTATS-MCQ-H-2.3-A pick A | deepseek-v4-flash | judges factually_correct: true/false
   - glm-5.3-flash: The final sentence claims that converting 25% into the 01–25 digit mapping 'fixes both the probability and the trial structure.' That is wrong. The digit mapping only fixes the probability; it does nothing for trial structure. Choice C in this very question uses the correct 01–25 mapping but fails because its trial structure is wrong (one trial = a single two-digit number, estimating the 25% prize rate instead of the 'at least 4 boxes' probability). The point brief is explicit that a design is incomplete unless it defines where one trial ends and what is recorded — for this question, a trial must be reading two-digit numbers until the first prize appears, recording the count of boxes, and repeating to estimate the proportion needing at least 4. The coaching text never mentions the stopping rule or the recorded quantity, which is exactly the 'answer move' the point brief flags, and its closing claim would leave the student thinking a correct mapping alone earns the design point.
