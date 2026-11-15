# Pass 3: rewritten prompts, 3 MCQs + 3 FRQs (old text from pass 2 shown for comparison)

## FRQ APBIO-FRQ-S-095 (pick/missed: b1), claude-haiku-5.5

**OLD:**
> You earned a1, a2, and b2. Your regulatory-region explanation is clear. The missed point is b1, because your response only traces the regulatory case and never considers a transposon inserting into the toxin gene's coding sequence. Add a sentence for that case: insertion into the coding region can disrupt the gene sequence by shifting the reading frame or changing codons, which can alter amino acids and make the toxin nonfunctional. Follow the chain from DNA insertion to codon change, amino acid change, and protein function. Then state each insertion site (coding and regulatory) separately so the rubric sees both.

**NEW (150 words):**
> Part (a) asks you to explain what a transposon does and why that matters for variation. Part (b) asks for two effects of insertion: one in a coding region and one in a regulatory region. You earned a1 (the transposon relocates to a new genome position), a2 (relocation adds genetic variation), and b2 (insertion near a promoter alters transcription).
> 
> You missed b1 (1 pt). Your response covers only the regulatory-region effect. It never states that insertion into a gene's coding sequence disrupts that gene's sequence. Part (b) requires both effects, so the coding-region effect must be stated as its own claim.
> 
> Next time, add a sentence such as: "If the transposon lands within the toxin gene's coding sequence, it can disrupt the gene's sequence, so the toxin may be altered or not produced." Keep your regulatory sentence and add this one. This is answering differently; no new concept is needed.

Judges: factual true/true, no-unsupported-claim true/true, defect+fix 5/5, kind-stated true/true, jargon-free true/true, links-to-requirement 5/5, why-required 5/5

## FRQ APBIO-FRQ-S-095 (pick/missed: b1), gpt-6-luna

**OLD:**
> You earn the movement, variation, and regulatory-region points. Your example focuses on a promoter, so you explain altered transcription but not the b1 point: insertion into a coding sequence can disrupt the gene. Add that consequence alongside your regulatory example to cover both ways insertion can affect a gene.

**NEW (116 words):**
> Part (a) asks you to state that a transposon can relocate and explain how that creates genetic variation. You earned both points (a1 and a2). Part (b) asks how insertion can affect genes: you earned the point for explaining that insertion near a regulatory sequence can change gene expression (b2), but missed the point for coding-sequence disruption (b1).
> 
> **What was missing:** You describe insertion near a promoter and its effect on transcription, but not insertion into a gene’s coding sequence. The rubric requires this because insertion into a coding region can disrupt the gene sequence.
> 
> **Fix — answer it differently:** Add that if a transposon inserts into a gene’s coding region, it can disrupt that sequence.

Judges: factual true/true, no-unsupported-claim true/true, defect+fix 5/5, kind-stated true/true, jargon-free true/true, links-to-requirement 5/5, why-required 4/5

## MCQ APBIO-MCQ-SV-135-v2 (pick/missed: A), claude-haiku-5.5

**OLD:**
> You treated the wall as something that adds flexibility, so you predicted more ruptures. A cell wall mechanically opposes expansion when water enters, so strengthening it reduces rupture even though the plasma membrane is unchanged (B). Next time, before predicting, name the structure that limits expansion and state how the treatment changes it. Base the prediction on that structural role, not on what would help the cell.

**NEW (97 words):**
> The question asks which structure limits expansion as water enters, and how that changes rupture risk when only the wall is strengthened.
> 
> Choice A says stronger walls will cause more ruptures because they block the expansion that protects cells. That reverses the mechanics. The wall opposes expansion, so it lowers rupture risk. A plasma membrane cannot stretch indefinitely, so unrestricted expansion is not protective.
> 
> Next time, answer it differently: name the structure that resists expansion, then predict how strengthening it changes rupture. Choice B is correct because a stronger wall resists swelling, so fewer treated cells rupture.

Judges: factual true/true, no-unsupported-claim true/true, defect+fix 4/5, kind-stated true/true, jargon-free true/true, links-to-requirement 4/4, why-required 4/4

## MCQ APBIO-MCQ-SV-135-v2 (pick/missed: A), gpt-6-luna

**OLD:**
> You treat membrane flexibility as protection, but the wall resists the expansion caused by water entering. B is supported: stronger walls mean fewer ruptures. For the membrane-permeability point, check which structure changes before predicting an effect; use molecule properties and membrane composition to explain passage, and the wall’s role to explain mechanical support.

**NEW (69 words):**
> The question asks you to predict how stronger cell walls affect rupture when water enters. Choice A says they cause more rupture by preventing membrane expansion. The defect is treating unrestricted expansion as protection; the wall’s resistance helps prevent rupture. The point is lost because the prediction reverses the wall’s mechanical effect. Next time, **answer it differently**: identify which structure resists expansion and predict fewer treated bacteria will rupture.

Judges: factual true/true, no-unsupported-claim true/true, defect+fix 1/5, kind-stated true/true, jargon-free true/true, links-to-requirement 1/5, why-required 1/5

Contradiction noted: None. The coaching text accurately restates choice A's error (treating unrestricted membrane expansion as protective) and correctly states that the wall's resistance to expansion prevents rupture, matching the authored rationale for A. The corrective advice — identify which structure resists expansion and predict fewer ruptures — is consistent with the correct rationale for B. No arithmetic is involved, and no rubric/background material is misused.

## FRQ apstats-frq-u13g-3-14 (pick/missed: part-c-criterion-02+part-d-criterion-01), claude-haiku-5.5

**OLD:**
> You lost two points in parts (c) and (d).
> 
> In (c), you checked the 10% condition but never addressed expected counts. Find the smallest expected count in the table (19.3) and write that every expected count is greater than 5. Check the expected counts, not the observed ones.
> 
> In (d), you explained what the statistic measures but did not describe the distribution's shape. Chi-square distributions are skewed right. The df = 4 distribution is more strongly skewed than the df = 10 distribution, which is less skewed. Write one sentence comparing the two shapes.

**NEW (160 words):**
> Part (a) earned 1 point, part (b) 1 point, part (c) 1 of 2 points, and part (d) 1 of 2 points. Score: 4 of 6.
> 
> Part (c) asks you to verify two conditions: the 10% condition and the expected counts condition. You checked only the 10% condition. Next time, add a sentence that names the smallest expected count and states that all expected counts are greater than 5. The smallest is 19.3, so every expected count passes. Check the expected counts, not the observed counts.
> 
> Part (d) asks you to describe the shape of the 4-df distribution and compare it with the 10-df distribution. You explained the statistic and what a large value means, but you did not describe any shape. Learn this first: chi-square distributions are skewed right, and the skew decreases as degrees of freedom increase. So the 4-df distribution is more strongly skewed right than the 10-df distribution. Write that comparison before explaining the large value.

Judges: factual true/true, no-unsupported-claim true/true, defect+fix 5/5, kind-stated true/true, jargon-free true/true, links-to-requirement 5/5, why-required 5/4

Contradiction noted: None. The labels (missed part-c-criterion-02 and part-d-criterion-01) match the student response. Recomputing: (a) correctly identifies homogeneity with the separate-samples justification (1 pt); (b) states both hypotheses in context about distributions across the three cities (1 pt); (c) verifies only the 10% condition (150 < 50,000) and never addresses expected counts, so part-c-criterion-02 is missed (1 of 2); (d) gives the formula, explains relative distance between observed and expected counts, and interprets a large value, earning part-d-criterion-02, but says nothing about shape, missing part-d-criterion-01 (1 of 2). Total 4 of 6, exactly as the coaching text states. The coaching content is also accurate: the smallest expected count is 19.3 (all expected counts exceed 5), and chi-square distributions are skewed right with skew decreasing as df increases, so 4 df is more skewed than 10 df.

## FRQ apstats-frq-u13g-3-14 (pick/missed: part-c-criterion-02+part-d-criterion-01), gpt-6-luna

**OLD:**
> Your 10% check is correct, but it does not verify the expected-count condition, which costs that condition point. Add that every expected count exceeds 5; the smallest is 19.3. In part (d), you explain what a large statistic means, but leave out the distribution-shape comparison, costing that point. State that the 4-df distribution is skewed right and the 10-df distribution is less skewed.

**NEW (110 words):**
> Part (a) earned 1/1, (b) 1/1, and (c) 1/2. In part (c), you verified the 10% condition, but your response did not check expected counts. The part requires both conditions for the test. **Answer it differently:** state that every expected count exceeds 5; the smallest is 19.3.
> 
> Part (d) earned 1/2. You explained that a large statistic means observed counts are far from expected counts, earning that point. But you described the statistic, not the distributions’ shapes and comparison. **Learn this first:** a chi-square distribution with 4 degrees of freedom is skewed right; with 10 degrees of freedom, it is less skewed. Include both facts to earn the remaining point.

Judges: factual true/true, no-unsupported-claim true/true, defect+fix 5/5, kind-stated true/true, jargon-free true/true, links-to-requirement 5/5, why-required 5/4

## FRQ apstats-frq-u4z-4-6-1 (pick/missed: part-a-criterion-01), claude-haiku-5.5

**OLD:**
> **Part (a) cost you the point.** The mean of a difference of sample means is the difference of the population means, μ₁ − μ₂, taken in the same order. You added 502 + 500, which gives the mean of a sum, not a difference. The correct center is 502 − 500 = 2 g.
> 
> The addition rule you used in (b) and (d) applies to variances, not to means. Keep the two rules separate: subtract the means, then add the variances before taking the square root.
> 
> Your work in (b), (c), and (d) earned full credit.

**NEW (147 words):**
> Part (a) asks for the mean of x̄1 − x̄2, so the center is the difference of the population means, not their sum. You earned 0 of 1 point here.
> 
> Your response wrote "502 + 500 = 1002 g" and added the means. Adding them gives the mean of a sum, which the question does not ask for. Next time, subtract in the same order as the expression: μ1 − μ2 = 502 − 500 = 2 g.
> 
> This is an answer-it-differently fix. The rule to know is that the mean of x̄1 − x̄2 equals μ1 − μ2.
> 
> You earned the points for part (b) (1.354 g), both criteria in part (c) (approximately normal, justified because n1 = 36 and n2 = 30 are both at least 30), and both criteria in part (d) (1.190 g, smaller than 1.354 g). Your score is 5 of 6.

Judges: factual true/true, no-unsupported-claim true/true, defect+fix 1/5, kind-stated true/true, jargon-free true/true, links-to-requirement 1/5, why-required 1/5

## FRQ apstats-frq-u4z-4-6-1 (pick/missed: part-a-criterion-01), gpt-6-luna

**OLD:**
> You lose the part (a) point because you add the machine means, treating the center of a difference as a sum. Match the order in \( \bar{x}_1-\bar{x}_2 \): calculate \( \mu_1-\mu_2=502-500=2\) g.

**NEW (84 words):**
> Part (a) asks for the mean of the sampling distribution: you earned 0/1 point. You added the machine means, writing “502 + 500 = 1002,” instead of finding the difference in the order \( \mu_1-\mu_2 \). The part asks for the center of \( \bar{x}_1-\bar{x}_2 \), so the means must be subtracted in that same order. **Fix: answer it differently** by writing \(502-500=2\) g.
> 
> You earned 1/1 point in part (b), both points in part (c) (2/2), and both points in part (d) (2/2).

Judges: factual true/true, no-unsupported-claim true/true, defect+fix 5/5, kind-stated true/true, jargon-free true/true, links-to-requirement 5/5, why-required 5/5

## MCQ APSTATS-MCQ-SV-H-2.9-B-v1 (pick/missed: C), claude-haiku-5.5

**OLD:**
> Your −$2.80 counts only the $600 prize: 600/500 = 1.20, then 1.20 − 4. The two $100 prizes are outcomes too, each with probability 2/500, and they were left out. Include every outcome, each multiplied by its probability: (600 + 2·100)/500 = 1.60, then subtract the $4 cost to get −$2.40. Next time, list every prize value beside its probability, sum the products, then subtract the ticket price.

**NEW (91 words):**
> The question asks for the expected net gain: the probability-weighted average of all prizes, minus the $4 price. Option C counts only the $600 prize, giving an expected prize of 600/500 = $1.20 and a net of −$2.80. It leaves out the two $100 prizes, each with probability 1/500, which add 200/500 = $0.40 to the expected prize.
> 
> Next time, list every outcome (the $600 prize, each $100 prize, and no prize), multiply each prize by its probability, sum to get $1.60, then subtract $4. The correct answer is B, −$2.40.

Judges: factual true/true, no-unsupported-claim true/true, defect+fix 5/5, kind-stated true/false, jargon-free true/true, links-to-requirement 5/5, why-required 5/4

## MCQ APSTATS-MCQ-SV-H-2.9-B-v1 (pick/missed: C), gpt-6-luna

**OLD:**
> You count only the $600 prize, dropping the two $100 outcomes. That costs you the expected-value point for weighting every outcome by its probability. Add each prize times its probability to get the expected prize, then subtract the $4 ticket price: the expected net gain is −$2.40.

**NEW (64 words):**
> The question asks for the expected net gain after accounting for all prizes and the $4 ticket cost. Choice C counts only the $600 prize, leaving out both $100 prizes. That omission makes the expected prize too low. **Defect:** one outcome is missing. **Fix—learn this first:** include every prize in the probability-weighted expected prize: \((600+100+100)/500=\$1.60\), then subtract $4. The expected net gain is **−$2.40**.

Judges: factual true/true, no-unsupported-claim true/true, defect+fix 5/1, kind-stated true/true, jargon-free true/true, links-to-requirement 5/1, why-required 4/1

## MCQ APSTATS-MCQ-SV-H-3.7-A-v3 (pick/missed: D), claude-haiku-5.5

**OLD:**
> You divided √[p0(1 − p0)] by n, which gives 0.5/100 = 0.005 and z = 24. The n belongs inside the radical: the standard error is √[p0(1 − p0)/n] = √(0.25/100) = 0.05. Next time, write this p0-based standard error with n under the radical before any arithmetic. Then divide 0.12 by 0.05 to get z = 2.40. The z-statistic point depends on this setup.

**NEW (131 words):**
> **What the question requires:** The z-statistic for H0: p = 0.50, using the sample result (62 of 100) and a standard error built from p0 = 0.50.
> 
> **What D says:** z = 24 means the standard error was computed as √(0.50 × 0.50) divided by 100. That order is wrong. n belongs inside the square root, so this value is off by a factor of ten.
> 
> **How the point is lost and how to earn it:** A wrong statistic cannot earn the calculation point, so this is a "learn this first" fix. The formula is z = (p̂ − p0) / √(p0(1 − p0)/n). Next time, put n inside the square root with p0(1 − p0). Here, z = 0.12 / √(0.25/100) = 0.12 / 0.05 = 2.40, which is B.

Judges: factual true/true, no-unsupported-claim true/true, defect+fix 5/5, kind-stated true/true, jargon-free true/true, links-to-requirement 5/5, why-required 4/5

## MCQ APSTATS-MCQ-SV-H-3.7-A-v3 (pick/missed: D), gpt-6-luna

**OLD:**
> You put \(n\) outside the square root, making the standard error too small and \(z\) too large. The test-statistic point requires \(p_0\) in the standard error, with \(n\) inside the radical: \(\sqrt{p_0(1-p_0)/n}\). Write that structure before substituting; here, the statistic is \(z=2.40\).

**NEW (44 words):**
> The question requires the one-sample z-test statistic. Choice D gives 24 because it divides \(\sqrt{p_0(1-p_0)}\) by \(n\), instead of taking the square root of \(p_0(1-p_0)/n\). That incorrect standard error loses the point. **Fix: learn this first**—use \(z=(\hat p-p_0)/\sqrt{p_0(1-p_0)/n}\). Here, \(z=(0.62-0.50)/\sqrt{0.50(0.50)/100}=2.40\), so B is correct.

Judges: factual true/true, no-unsupported-claim true/true, defect+fix 5/5, kind-stated true/true, jargon-free true/true, links-to-requirement 5/5, why-required 5/4

