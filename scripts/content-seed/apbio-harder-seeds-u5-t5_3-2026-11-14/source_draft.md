# AP Biology Unit 5 topic 5.3 — Mendelian Genetics

DRAFT. Author-in-session 2026-11-14. CED 5.3.A.1–2.

---

## Seed N-5.3-A (new) — Topic 5.3 Mendelian Genetics

**Skill:** condition genotype probability on a dominant phenotype at two unlinked loci



Two genes A/a and B/b are on different chromosomes. In an AaBb × AaBb cross, an offspring has both dominant phenotypes (A_B_). What is the probability that this offspring is AaBb?



- **A. 4/9; among the 9/16 offspring with both dominant phenotypes, 4/16 are AaBb.**

- B. 1/4; the unconditional probability of AaBb is 1/4.

- C. 9/16; this is the probability of the observed phenotype, not the conditional genotype.

- D. 1/9; each dominant phenotype forces a homozygous dominant genotype.



Check: Independent segregation gives P(AaBb)=1/2×1/2=1/4=4/16 and P(A_B_)=3/4×3/4=9/16. Conditioning yields (4/16)/(9/16)=4/9.

Rationales: B: This ignores the information that the offspring is already known to have both dominant phenotypes. C: This is the frequency of the conditioning phenotype rather than the requested genotype given that phenotype. D: Dominant phenotypes include both homozygotes and heterozygotes; they do not force homozygosity.



**N-5.3-A-v1.** Genes A/a and B/b segregate independently. In an AaBb × Aabb cross, a randomly selected offspring has phenotype A_bb. What is the probability that the offspring genotype is Aabb?



- **A. 2/3; among A_ offspring, two thirds are Aa, and bb is already specified.**

- B. 1/2; half of all offspring are Aa before conditioning on the A_ phenotype.

- C. 1/4; this treats the A and B genotypes as two independent heterozygote probabilities after conditioning.

- D. 1/3; this counts the AA share among A_ offspring instead of the Aa share.



Check: At A, Aa×Aa gives AA:Aa:aa=1:2:1, so P(Aa|A_)=2/3. At B, Bb×bb can yield bb, and the observed bb phenotype fixes that genotype. Thus P(Aabb|A_bb)=2/3.

Rationales: B: The unconditional Aa frequency must be divided by the 3/4 chance of A_. C: The given recessive b phenotype fixes bb, so another factor of 1/2 should not be applied. D: Only one of the three dominant-A genotype parts is AA; two are Aa.



**N-5.3-A-v2.** Two independently assorting genes are crossed as AaBb × aaBb. An offspring has phenotype A_B_. What is the conditional probability that it is AaBb?



- **A. 2/3; A_ forces Aa in this cross, while two of the three B_ genotype parts are Bb.**

- B. 1/2; this uses the unconditional probability of Bb.

- C. 1/3; this selects BB rather than Bb among B_ offspring.

- D. 1/4; this multiplies two unconditional heterozygote probabilities.



Check: At A, the aa parent contributes a, so an A_ offspring must be Aa. At B, Bb×Bb gives BB:Bb:bb=1:2:1, and P(Bb|B_)=2/3. Therefore P(AaBb|A_B_)=2/3.

Rationales: B: B_ is known, so its Bb probability is 2/3 rather than the unconditional 1/2. C: One third of B_ offspring are BB; the requested genotype has Bb. D: Conditioning makes A_ deterministically Aa here, so an extra 1/2 factor is wrong.



**N-5.3-A-v3.** Two genes assort independently in an AaBb × AaBb cross. Among offspring that show both dominant phenotypes (A_B_), what fraction has genotype AABb?



- **A. 2/9; P(AABb)=1/4×1/2=2/16 and P(A_B_)=9/16.**

- B. 1/8; this is the unconditional chance of AABb.

- C. 4/9; this is the conditional chance of AaBb, a different genotype.

- D. 1/9; this assumes that both dominant phenotypes force AA and BB.



Check: P(AABb)=P(AA)P(Bb)=1/4×1/2=1/8=2/16. The observed A_B_ phenotype occurs 9/16 of the time, so P(AABb|A_B_)=2/9.

Rationales: B: The phenotype has been observed, so divide the unconditional genotype chance by 9/16. C: AaBb has twice as many heterozygote possibilities as the requested AABb genotype. D: A dominant phenotype does not uniquely identify a homozygous dominant genotype.

---

## Seed N-5.3-B (new) — Topic 5.3 Mendelian Genetics

**Skill:** calculate chi-square and interpret a Mendelian testcross



A dihybrid testcross for two genes on different chromosomes predicts four equally frequent phenotypes. Observed counts are 30, 20, 27, 23 (total 100). At α=0.05, the chi-square critical value with 3 degrees of freedom is 7.815. Which calculation and conclusion are justified?



- **A. χ²=2.32, below 7.815; fail to reject the 1:1:1:1 null model.**

- B. χ²=7.815 by definition; the data prove that the genes assort independently.

- C. χ²=2.32, below 7.815; reject the 1:1:1:1 null model.

- D. The four observed counts must be exactly equal or Mendel’s segregation law is disproved.



Check: Expected count per class is 100/4=25. Sum (observed−25)²/25 over the four classes to get χ²=2.32. This is below the given 3-df critical value 7.815, so fail to reject the equal-classes null model; this test does not prove a particular biological cause.

Rationales: B: The critical value is a threshold, not a statistic computed from these observations; failure to reject cannot prove a model. C: The numerical statistic is correct, but the decision direction is reversed relative to the critical value. D: Sampling variation can create unequal observed counts even when the 1:1:1:1 model is true.



**N-5.3-B-v1.** A dihybrid testcross for two genes on different chromosomes predicts four equally frequent phenotypes. Observed counts are 40, 10, 30, 20 (total 100). At α=0.05, the chi-square critical value with 3 degrees of freedom is 7.815. Which calculation and conclusion are justified?



- **A. χ²=20.0, above 7.815; reject the 1:1:1:1 null model.**

- B. χ²=7.815 by definition; the data prove that the genes assort independently.

- C. χ²=20.0, above 7.815; fail to reject the 1:1:1:1 null model.

- D. The four observed counts must be exactly equal or Mendel’s segregation law is disproved.



Check: Expected count per class is 100/4=25. Sum (observed−25)²/25 over the four classes to get χ²=20.0. This is above the given 3-df critical value 7.815, so reject the equal-classes null model; this test does not prove a particular biological cause.

Rationales: B: The critical value is a threshold, not a statistic computed from these observations; failure to reject cannot prove a model. C: The numerical statistic is correct, but the decision direction is reversed relative to the critical value. D: Sampling variation can create unequal observed counts even when the 1:1:1:1 model is true.



**N-5.3-B-v2.** A dihybrid testcross for two genes on different chromosomes predicts four equally frequent phenotypes. Observed counts are 24, 16, 22, 18 (total 80). At α=0.05, the chi-square critical value with 3 degrees of freedom is 7.815. Which calculation and conclusion are justified?



- **A. χ²=2.00, below 7.815; fail to reject the 1:1:1:1 null model.**

- B. χ²=7.815 by definition; the data prove that the genes assort independently.

- C. χ²=2.00, below 7.815; reject the 1:1:1:1 null model.

- D. The four observed counts must be exactly equal or Mendel’s segregation law is disproved.



Check: Expected count per class is 80/4=20. Sum (observed−20)²/20 over the four classes to get χ²=2.00. This is below the given 3-df critical value 7.815, so fail to reject the equal-classes null model; this test does not prove a particular biological cause.

Rationales: B: The critical value is a threshold, not a statistic computed from these observations; failure to reject cannot prove a model. C: The numerical statistic is correct, but the decision direction is reversed relative to the critical value. D: Sampling variation can create unequal observed counts even when the 1:1:1:1 model is true.



**N-5.3-B-v3.** A dihybrid testcross for two genes on different chromosomes predicts four equally frequent phenotypes. Observed counts are 36, 4, 30, 10 (total 80). At α=0.05, the chi-square critical value with 3 degrees of freedom is 7.815. Which calculation and conclusion are justified?



- **A. χ²=35.6, above 7.815; reject the 1:1:1:1 null model.**

- B. χ²=7.815 by definition; the data prove that the genes assort independently.

- C. χ²=35.6, above 7.815; fail to reject the 1:1:1:1 null model.

- D. The four observed counts must be exactly equal or Mendel’s segregation law is disproved.



Check: Expected count per class is 80/4=20. Sum (observed−20)²/20 over the four classes to get χ²=35.6. This is above the given 3-df critical value 7.815, so reject the equal-classes null model; this test does not prove a particular biological cause.

Rationales: B: The critical value is a threshold, not a statistic computed from these observations; failure to reject cannot prove a model. C: The numerical statistic is correct, but the decision direction is reversed relative to the critical value. D: Sampling variation can create unequal observed counts even when the 1:1:1:1 model is true.

---

## Seed N-5.3-C (new) — Topic 5.3 Mendelian Genetics

**Skill:** infer carrier parents and calculate a two-child pedigree probability



For a fully penetrant autosomal trait, two unaffected parents have an affected child. Assume no new mutation and independent outcomes for later births. What is the probability that, among their next two children, exactly one affected? Explain the parents’ inferred genotypes.



- **A. 3/8; both parents must be heterozygous carriers (Aa × Aa), so each birth has a 1/4 affected chance.**

- B. 1/4; only one birth needs to be considered despite the question asking about two.

- C. 1/2; the affected child shows that one parent must be homozygous recessive.

- D. 0; two unaffected parents cannot have a child with a recessive trait.



Check: Unaffected parents of an affected aa child must both carry a: Aa×Aa. Each later child independently has P(affected)=1/4 and P(unaffected)=3/4. For exactly one affected among two children, the binomial/complement calculation gives 3/8.

Rationales: B: This uses a one-child probability or drops one of the possible two-child orders. C: The parents are unaffected, so neither can be aa under complete penetrance; both are Aa. D: Recessive inheritance allows unaffected carriers to have affected offspring.



**N-5.3-C-v1.** For a fully penetrant autosomal trait, two unaffected parents have an affected child. Assume no new mutation and independent outcomes for later births. What is the probability that, among their next two children, both affected? Explain the parents’ inferred genotypes.



- **A. 1/16; both parents must be heterozygous carriers (Aa × Aa), so each birth has a 1/4 affected chance.**

- B. 1/4; only one birth needs to be considered despite the question asking about two.

- C. 1/8; the affected child shows that one parent must be homozygous recessive.

- D. 0; two unaffected parents cannot have a child with a recessive trait.



Check: Unaffected parents of an affected aa child must both carry a: Aa×Aa. Each later child independently has P(affected)=1/4 and P(unaffected)=3/4. For both affected among two children, the binomial/complement calculation gives 1/16.

Rationales: B: This uses a one-child probability or drops one of the possible two-child orders. C: The parents are unaffected, so neither can be aa under complete penetrance; both are Aa. D: Recessive inheritance allows unaffected carriers to have affected offspring.



**N-5.3-C-v2.** For a fully penetrant autosomal trait, two unaffected parents have an affected child. Assume no new mutation and independent outcomes for later births. What is the probability that, among their next two children, neither affected? Explain the parents’ inferred genotypes.



- **A. 9/16; both parents must be heterozygous carriers (Aa × Aa), so each birth has a 1/4 affected chance.**

- B. 3/4; only one birth needs to be considered despite the question asking about two.

- C. 1/2; the affected child shows that one parent must be homozygous recessive.

- D. 0; two unaffected parents cannot have a child with a recessive trait.



Check: Unaffected parents of an affected aa child must both carry a: Aa×Aa. Each later child independently has P(affected)=1/4 and P(unaffected)=3/4. For neither affected among two children, the binomial/complement calculation gives 9/16.

Rationales: B: This uses a one-child probability or drops one of the possible two-child orders. C: The parents are unaffected, so neither can be aa under complete penetrance; both are Aa. D: Recessive inheritance allows unaffected carriers to have affected offspring.



**N-5.3-C-v3.** For a fully penetrant autosomal trait, two unaffected parents have an affected child. Assume no new mutation and independent outcomes for later births. What is the probability that, among their next two children, at least one affected? Explain the parents’ inferred genotypes.



- **A. 7/16; both parents must be heterozygous carriers (Aa × Aa), so each birth has a 1/4 affected chance.**

- B. 1/4; only one birth needs to be considered despite the question asking about two.

- C. 3/8; the affected child shows that one parent must be homozygous recessive.

- D. 0; two unaffected parents cannot have a child with a recessive trait.



Check: Unaffected parents of an affected aa child must both carry a: Aa×Aa. Each later child independently has P(affected)=1/4 and P(unaffected)=3/4. For at least one affected among two children, the binomial/complement calculation gives 7/16.

Rationales: B: This uses a one-child probability or drops one of the possible two-child orders. C: The parents are unaffected, so neither can be aa under complete penetrance; both are Aa. D: Recessive inheritance allows unaffected carriers to have affected offspring.
