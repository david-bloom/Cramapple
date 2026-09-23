# AP Statistics and AP Chemistry — Framework Validation and Provisional Assignments

Status: **Proposal — Chemistry framework validated, item assignments PROVISIONAL and not ready to ratify**
Date: 2026-09-22 | Companion to `README.md` (AP Biology method)

David supplied a subject-specific difficulty framework for AP Statistics (topic-based) and AP
Chemistry (task-verb plus mechanics). Both were tested against the only ground truth that exists —
published Chief Reader Report attainment — and then applied to the published corpora.

**Headline: the Chemistry framework validates very well (9/10). The Statistics framework validates
only partially (n=6). Neither subject's item-level assignments are ready to ratify, for a
structural reason given in §4.**

---

## 1. AP Chemistry — framework VALIDATED, 9/10

The 2025 AP Chemistry Chief Reader Report publishes per-point means. Question 1 has ten parts
mapping one-to-one onto ten scored points, so it hand-maps exactly. Scored against AP Chemistry's
own tertiles from the 316-point calibration (Hard ≤ 0.35, Medium 0.35–0.52, Easy ≥ 0.52):

| Part | Task | Ratio | Actual | Framework predicts | Match |
|---|---|---:|---|---|---|
| A(i) | annotate mass spectrum | 0.72 | Easy | Easy | YES |
| A(ii) | identify atomic-structure difference | 0.55 | Easy | Easy | YES |
| B(i) | explain via Coulomb — charge | 0.65 | Easy | Medium–Hard | no |
| B(ii) | explain via Coulomb — ionic radii | 0.11 | Hard | Medium–Hard | YES |
| C | calculate pH of strong base | 0.66 | Easy | Easy–Medium | YES |
| D | calculate diluted concentration | 0.46 | Medium | Easy–Medium | YES |
| E(i) | write Ksp expression | 0.59 | Easy | Easy–Medium | YES |
| E(ii) | calculate reaction quotient Q | 0.42 | Medium | Easy–Medium | YES |
| E(iii) | determine if precipitate forms | 0.45 | Medium | Medium | YES |
| F | **predict + justify** effect of strong acid | **0.17** | **Hard** | **Hard** | YES |

**9 of 10.** The verb ordering is monotonic and matches the framework exactly:

    identify/annotate 0.635  >  calculate 0.513  >  explain 0.380  >  predict+justify 0.170

The framework's distinctive claim — *"Predict and Justify = determining a directional change plus a
multi-step chemical argument = Hard"* — is confirmed precisely. Part F asks whether the solubility
of Mg(OH)₂ changes on adding strong acid and requires the Q-versus-Ksp equilibrium argument. It
scored 0.17, the second-lowest point on the question.

The single miss is instructive: **`explain` splits hard within one part.** B(i) (charge) scored
0.65 while B(ii) (ionic radii, a longer causal chain) scored 0.11 — the same verb, the same
question, a 6× difference. This is the same finding as AP Biology's SP1-versus-SP6 `explain` split
(see `README.md` §4): *explain* is not one difficulty, it is a range set by the length of the
reasoning chain.

## 2. AP Statistics — framework PARTIALLY validated, n=6

AP Statistics publishes **question-level means only** — no per-point data. So the evidence is six
observations, not sixteen, and one level coarser.

| | Task | Ratio | Rank | Framework predicts |
|---|---|---:|---:|---|
| Q2 | Sampling | 0.525 | 1 | Medium |
| Q6 | Investigative Task | 0.445 | 2 | **Hard** |
| Q1 | Exploring Data | 0.438 | 3 | Easy |
| Q4 | Inference | 0.412 | 4 | Medium |
| Q3 | Probability | 0.388 | 5 | **Hard** |
| Q5 | Multifocus | 0.357 | 6 | **Hard** |

Mean by predicted tier: Easy 0.438, Medium 0.469, **Hard 0.397**.

- **HOLDS** — the Hard tier has the lowest mean, and two of the three lowest-scoring questions are
  predicted Hard. The claim that probability is among the lowest-scoring topics is supported
  (Q3 ranks 5th of 6), and multi-unit synthesis (Q5 Multifocus) is in fact the lowest.
- **FAILS** — Easy (0.438) scores *below* Medium (0.469). The Easy/Medium distinction does not
  separate in this data.
- **CONTRADICTED** — the Investigative Task (FRQ #6) is predicted Hard but ranks **second highest**
  at 0.445. On the one year of evidence available, it is not among the hard questions.

This mirrors AP Biology: the extremes carry signal, the middle does not.

## 3. Provisional assignments

| Subject | Items | Easy | Medium | Hard | No cue matched |
|---|---:|---:|---:|---:|---:|
| **AP Statistics** | 384 | 142 (37.0%) | 173 (45.1%) | 69 (18.0%) | **104 (27%)** |
| — FRQ | 80 | 24 (30.0%) | 34 (42.5%) | 22 (27.5%) | |
| — MCQ | 304 | 118 (38.8%) | 139 (45.7%) | 47 (15.5%) | |
| **AP Chemistry** | 119 | 23 (19.3%) | 88 (73.9%) | 8 (6.7%) | **59 (50%)** |
| — FRQ | 51 | 17 (33.3%) | 26 (51.0%) | 8 (15.7%) | |
| — MCQ | 68 | 6 (8.8%) | 62 (91.2%) | **0 (0.0%)** | |

Files: `apstats_difficulty_assignments.csv` (superseded by §4b), `apchem_difficulty_assignments.csv`.

Agreement with the existing authored 4-level labels (collapsed to 3): Statistics **44.0%, kappa
0.084**; Chemistry **47.1%, kappa −0.084**. Both at or below chance. That is not by itself
damning — the authored labels were independently measured as unreliable (README §1) — but it means
the two sources corroborate nothing.

## 4. Why these are NOT ready to ratify — and it is structural, not a tuning problem

**The task-verb method requires a task verb. Chemistry and Statistics MCQ stems do not have one.**

Representative Chemistry MCQ stems that matched no cue:

- "A 9.00 g sample of water (18.0 g mol⁻¹) contains how many moles?"
- "Which species has a trigonal planar molecular geometry?"
- "Why does solid NaCl not conduct while molten NaCl does?"
- "At the same temperature, which gas sample has the greatest average particle speed?"

A human classifies each of these in seconds. A verb-based classifier cannot reach them at all —
**58 of 68 Chemistry MCQ** and **104 of 384 Statistics items** fall through to a Medium default,
which is why Chemistry MCQ came out 91.2% Medium with **zero** Hard.

AP Biology did not have this problem because its MCQ stems are argumentation-phrased ("Which best
explains…", "…best supported by all three results"), which carries the verb implicitly.

So the correct reading is:

- **The Chemistry framework is sound** — 9/10 against real attainment — and is the right rule for
  **FRQ rubric criteria**, where task verbs are present.
- **The Statistics framework is half-sound** — its Hard tier is supported, its Easy/Medium split is
  not, and its Investigative-Task claim is contradicted.
- **MCQ cannot be labelled by the *verb* method** — but see §4a. The *characteristics* half of the
  Chemistry framework does reach them, and it was this document's error to conflate the two.

## 4a. CORRECTION — the characteristics DO work on MCQ, implemented structurally

An earlier version of this document concluded that neither subject's MCQ could be labelled. That
was wrong, and the error was in the implementation rather than the framework.

The Chemistry framework has two halves: a **task-verb table** and a set of **characteristics**
(single-step algorithmic / connects two Science Practices / conceptual synthesis). The first pass
encoded the characteristics as *keyword* markers — `particulate`, `equilibrium shift`, `deviation
from ideal` — which is vocabulary Chemistry MCQ simply do not use. Measured contribution:

| Cue type | Chemistry MCQ (68) | Chemistry FRQ (51) |
|---|---:|---:|
| Characteristic cue fired | **0** | 4 |
| Verb cue fired | 10 | 46 |
| Defaulted to Medium | 58 | 1 |

Re-implemented as **structural** detectors — quantities-with-units plus numeric answer choices for
"single-step algorithmic"; property/trend recall phrasing for "direct recall"; relational and
multi-step markers for "connects two ideas"; deviation and anomaly phrasing ("even though",
"does not change … because", "and why") for synthesis — coverage transforms:

| Method on Chemistry MCQ | Classified | Distribution |
|---|---:|---|
| Task verb | 10 / 68 = 14.7% | 91.2% Medium, **0 Hard** |
| Characteristics, structural | **58 / 68 = 85.3%** | Easy 51.7%, Medium 37.9%, Hard 10.3% |

Spot checks against the authored labels are encouraging, and notably correct labels that are
plainly wrong:

| Item | Authored | Characteristics | Comment |
|---|---|---|---|
| "Adding an inert gas … does not change an ideal-gas equilibrium because" | Hard | **Hard** | agree |
| "first ionization energy of magnesium … greater than aluminum, even though" | — | **Hard** | deviation from a periodic trend, correctly caught |
| "a process is thermodynamically favorable when …" | **Very Hard** | **Easy** | pure definition recall; the authored label is wrong |
| "The pH of 1.0×10⁻³ M HCl is approximately" | **Hard** | unclassified | one-step log calculation; authored label is wrong |

**The two halves are complementary, not competing:** verbs reach FRQ rubric criteria (46/51 = 90%),
characteristics reach MCQ (58/68 = 85%). Use the verb table for FRQ and the characteristics for
MCQ, rather than choosing between them.

**Caveat — coverage is not accuracy.** The Chief Reader Reports score FRQ only, so no ground truth
exists for any MCQ in any subject. The 85.3% is a measure of how many items the method can *reach*,
not how often it is right. The spot checks above are plausibility evidence, not validation.

File: `apchem_mcq_characteristics.csv` (regenerate with `assign_chem_mcq_characteristics.py`).

## 4b. Statistics, re-done structurally

The same structural treatment was applied to AP Statistics. Coverage, counting only items that
matched a real cue (v1 forced its misses to Medium, which inflated that tier):

| Method | Genuinely classified | Distribution |
|---|---:|---|
| Keyword v1 | 280 / 384 = 72.9% | Easy 37.0%, Medium 45.1%, Hard 18.0% (104 forced to Medium) |
| Structural v2 | 304 / 384 = 79.2% | Easy 46.1%, Medium 29.6%, Hard 24.3% |
| **Structural v3 (landed)** | **349 / 384 = 90.9%** | **Easy 51.0%, Medium 27.8%, Hard 21.2%** |

FRQ reach 80/80 = 100%; MCQ 269/304 = 88.5%.

Two structural signals did the work that keywords could not:

1. **`subtopics` carries `"Unit N: descriptor"` strings** on 135 items (35.2%) — e.g.
   `Unit 4: independence`, `Unit 4: combinations`, `Unit 9: paired vs independent`. The keyword
   pass missed these because it searched for phrases like *independent events* rather than parsing
   the unit. Unit 4 maps straight onto the framework's Hard tier (probability and random
   variables).
2. **Short stems carry their content in `stimulus`, not `stem`.** Items like "What type of study is
   this?" and "Are A and B independent?" are uninterpretable from the stem alone; the scenario
   lives in the stimulus.

**Judgement call, stated because it is load-bearing.** 33 items are one repeated template —
"Sampling plan: … Which choice best describes the sampling method?" and a variable-classification
variant. These were classified **Easy**: read a described plan, recognise and name the method, one
step, no computation — the same shape as the framework's own Easy example ("identifying the
explanatory vs. response variable in a scatterplot"). The authored labels call them Medium.
Sensitivity: if they are Medium instead, the distribution moves from Easy 51.0% / Medium 27.8% to
**Easy 41.5% / Medium 37.2%**; Hard is unaffected at 21.2%. Worth settling before ratification.

**Caveat unchanged.** Chief Reader Reports score FRQ only, and AP Statistics does not even publish
per-point FRQ data — its validation remains the six question-level observations in §2. Coverage of
90.9% is reach, not accuracy.

## 5. Recommendation

1. **Ratify AP Biology only** (`README.md`). It has 0 unclassified items, 75% validation and 100%
   accuracy at both extremes.
2. **Adopt the Chemistry framework in both halves** — verb table for FRQ criteria (best-validated
   of the three, 9/10), characteristics for MCQ (85.3% reach, plausible distribution). The earlier
   "do not ship Chemistry MCQ labels" recommendation applied to the verb-only attempt and is
   superseded by §4a.
3. **Statistics is now labelled to 90.9% reach** (§4b) but its framework validation is still the
   weakest of the three (n=6, question-level). Settle the 33-item sampling-method template first,
   re-test the Investigative-Task claim against a second year, and treat the Easy/Medium boundary
   as unmeasured.
4. **For MCQ generally, stop trying to infer the verb — classify by structure instead** (§4a).
   Capturing an explicit task-verb or Science-Practice field at authoring time remains the durable
   fix, and is cheap for new content.

Point 4 is the durable fix. Every difficulty method tested here depends on knowing what cognitive
task the item demands; three of the ten subjects record it implicitly in prose and the rest do not
record it at all.

## 6. Limitations

- Chemistry validation is **10 points from one question, one year**, hand-mapped. It is the
  cleanest mapping available (ten parts, ten points, in order) but it is not a sample.
- Statistics validation is **6 question-level observations, one year**. No per-point data exists.
- Neither subject's item assignments were validated against anything; they are the output of a
  keyword classifier whose no-cue rate is 27% and 50% respectively.
- The 2025 reports are the only year extracted. AP Physics 1's report is 2024.
