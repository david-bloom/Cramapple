# Spike Input Packet -- Hardy-Weinberg Allele Frequencies After a Non-Random Mating Shift

**Subject:** AP Biology
**Answer type:** Text FRQ
**Unit:** Unit 7 - Natural Selection (Population Genetics)
**Difficulty:** Medium
**Content type:** concept-heavy
**Version:** `v1.0-ai-provisional-2026-07-06`
**Label status:** `ai_provisional_unapproved`

## Prompt

In a population of 500 beetles, 320 are homozygous dominant (`GG`, green), 160 are heterozygous (`Gg`, green), and 20 are homozygous recessive (`gg`, brown) for a single-locus coat color gene.

**A.** Calculate the allele frequencies of `G` and `g` in this population, showing your work.

**B.** The population is later found to be mating non-randomly: green beetles strongly prefer to mate with other green beetles. Explain whether this population is in Hardy-Weinberg equilibrium, and predict how the genotype frequencies (not allele frequencies) will change over subsequent generations as a result.

## Draft Rubric Criteria

| Criterion ID | Criterion | Notes for reviewer |
| --- | --- | --- |
| `C1` | Correctly calculates allele frequencies: p(G) = (2*320 + 160) / 1000 = 0.8, q(g) = (2*20 + 160) / 1000 = 0.2, showing the work (counting alleles, not individuals). | Accept equivalent correct arithmetic paths (e.g., computing genotype frequencies first then p = freq(GG) + 1/2 freq(Gg)). |
| `C2` | States that the population is not in Hardy-Weinberg equilibrium because non-random mating (assortative mating) violates one of the required Hardy-Weinberg assumptions. | Must name non-random/assortative mating specifically as the violated assumption, not just 'conditions aren't met.' |
| `C3` | Predicts that homozygote genotype frequencies (GG and gg) will increase over subsequent generations while heterozygote (Gg) frequency will decrease. | Must specify the direction for both homozygotes and heterozygotes. |
| `C4` | Explains that assortative mating increases the frequency of matings between similar genotypes, which increases homozygosity in offspring, while allele frequencies themselves (p and q) remain unchanged because no alleles are being gained, lost, or selected against -- only genotypes are being redistributed. | Must explicitly note that allele frequencies stay the same even though genotype frequencies shift -- this is the key boundary-sensitive point. |

## Response Set

| Response ID | Points (Claude-provisional) |
| --- | ---: |
| `R1` | 4 |
| `R2` | 0 |
| `R3` | 3 |
| `R4` | 4 |
| `R5` | 2 |

#### R1

```text
(A) Total alleles = 1000. Count of G alleles = (320 x 2) + (160 x 1) = 640 + 160 = 800, so p(G) = 800/1000 = 0.8. Count of g alleles = (20 x 2) + (160 x 1) = 40 + 160 = 200, so q(g) = 200/1000 = 0.2.

(B) This population is not in Hardy-Weinberg equilibrium because assortative (non-random) mating violates the random-mating assumption. Over subsequent generations, the frequency of homozygotes (both GG and gg) will increase and the frequency of heterozygotes (Gg) will decrease, because green beetles preferentially producing offspring with other green beetles increases the chance of pairing similar alleles together. However, the allele frequencies themselves (p = 0.8, q = 0.2) will not change, because no alleles are being added, removed, or selected against -- assortative mating only redistributes which genotypes those alleles end up in, not how many of each allele exist.
```

#### R2

```text
(A) p = 320/500 = 0.64, q = 20/500 = 0.04.

(B) The population is in Hardy-Weinberg equilibrium because the total number of beetles isn't changing. Genotype frequencies will stay the same.
```

#### R3

```text
(A) p(G) = 0.8, q(g) = 0.2 (counting alleles: 800 G alleles and 200 g alleles out of 1000 total).

(B) This is not Hardy-Weinberg equilibrium because mating isn't random. Homozygotes will become more common and heterozygotes less common over time.
```

#### R4

```text
(A) p(G) = 0.8 and q(g) = 0.2, calculated by counting alleles across all 500 individuals (1000 total alleles).

(B) Since green beetles prefer green mates, this violates the random mating assumption of Hardy-Weinberg, so the population is not in equilibrium. Homozygote frequencies will rise and heterozygote frequency will fall over generations as similar genotypes increasingly pair up, but the allele frequencies p and q will stay at 0.8 and 0.2 respectively since assortative mating only changes which genotype combinations occur, not the total number of each allele in the gene pool.
```

#### R5

```text
(A) p(G) = 0.8, q(g) = 0.2.

(B) Not in equilibrium, since mating is non-random. Over time, allele frequencies will shift so that G becomes even more common, since green beetles are mating together and passing on more G alleles, eventually approaching fixation.
```

## Draft Label Matrix

**Label status:** Claude-authored draft, `ai_provisional_unapproved`. NOT confirmed by Learning Quality. Contrast with the Bio reference packet, where an equivalent matrix was confirmed by Orly / Learning Quality before use.

| Response ID | `C1` | `C2` | `C3` | `C4` | Reviewer notes |
| --- | --- | --- | --- | --- | --- |
| `R1` | earned | earned | earned | earned | Full-credit response with correct arithmetic shown, correctly named violated assumption, correct genotype-frequency direction, and the key boundary point that allele frequencies stay constant under assortative mating. |
| `R2` | not_earned | not_earned | not_earned | not_earned | Calculates allele frequency using individual counts divided by total individuals rather than counting alleles (a common error -- should count each homozygote as 2 alleles and heterozygote as 1 of each), producing incorrect values that don't even sum to 1. Part B incorrectly claims equilibrium holds and that genotype frequencies won't shift, missing the assortative-mating violation entirely. Flags: arithmetic method error, missed assumption violation. |
| `R3` | earned | earned | earned | not_earned | Correct calculation, correct equilibrium violation, and correct genotype-frequency direction, but never addresses whether allele frequencies themselves change -- the key boundary distinction the question is testing (genotype frequencies shift, allele frequencies don't). Flags: over-credit risk if graders assume C3 implies C4; this is exactly the kind of response the boundary tag exists to catch. |
| `R4` | earned | earned | earned | earned | Second full-credit response with the allele-vs-genotype distinction stated explicitly and tied back to the numeric p/q values from (A). |
| `R5` | earned | earned | not_earned | not_earned | Correct calculation and correctly identifies the violated assumption, but invents an allele-frequency-shift outcome that assortative mating does not cause on its own (that would require selection, drift, or differential reproduction, not just non-random pairing) -- also never addresses genotype frequencies as asked. Flags: invented biology, conflates assortative mating with selection. |

## Boundary Tags Index

- `R1`: (none)
- `R2`: `arithmetic_method_error`, `invented_biology`
- `R3`: `over_credit_risk`, `rubric_boundary_allele_vs_genotype_frequency`
- `R4`: (none)
- `R5`: `invented_biology`, `conflates_assortative_mating_with_selection`
