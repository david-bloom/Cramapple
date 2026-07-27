# MCQ answer-length parity QA

**Date:** 2026-07-21
**Trigger:** AP Statistics tutor Jill's feedback that correct MCQ answers are
systematically longer and more detailed than distractors.
**Scope:** AP Statistics, AP Biology, AP Chemistry, AP Physics 1, AP Physics 2,
AP Physics C: Mechanics, AP Physics C: Electricity and Magnetism, AP Calculus
AB, AP Calculus BC, and AP Precalculus (Production, `pcntajvbdfqhbeewmdry`,
latest version of every published MCQ). Follow-up audits are described in
§7–§9.

## 1. Verdict

Confirmed in AP Statistics and AP Biology. Both published Chemistry items also
have longer correct choices, but Chemistry's current population ratio and both
item-level ratios remain below the 1.4x warning threshold:

| Subject | Published MCQs | Correct-longer | Avg correct len | Avg distractor len | Ratio |
|---|---|---|---|---|---|
| AP Statistics | 118 | 88 (75%) | 78.5 | 49.0 | 1.60x |
| AP Biology | 54 | 47 (87%) | 217.1 | 125.6 | 1.73x |
| AP Chemistry | 2 | 2 (100%) | 21.0 | 15.8 | 1.33x |
| AP Physics 1 | 1 | 0 (0%) | 6.0 | 6.3 | 0.95x |
| AP Physics 2 | 1 | 0 (0%) | 6.0 | 7.7 | 0.78x |
| AP Physics C: Mechanics | 1 | 1 (100%) | 7.0 | 6.3 | 1.11x |
| AP Physics C: E&M | 1 | 0 (0%) | 13.0 | 13.7 | 0.95x |
| AP Calculus AB | 2 | 0 (0%) | 1.0 | 4.8 | 0.21x |
| AP Calculus BC | 1 | 0 (0%) | 1.0 | 6.7 | 0.15x |
| AP Precalculus | 1 | 0 (0%) | 1.0 | 1.0 | 1.00x |

## 2. Mechanical check added

`supabase/functions/_shared/mcq-quality.ts` (this branch) —
`checkAnswerLengthParity()`, wired into `admin-content/index.ts`'s MCQ
ingestion path as a non-blocking `quality_warnings` entry
(`MCQ_CORRECT_ANSWER_LENGTH_OUTLIER`, ratio >= 1.4). Unit tests in
`mcq-quality_test.ts`. This only catches newly-authored/edited content going
forward — it does not retroactively touch anything published. The list below
is the retroactive scan run directly against Production with the same 1.4x
threshold.

Chemistry uses the same check/threshold, added to
`supabase/functions/_shared/content-preflight.ts` on
`codex/five-subject-harness-and-content` instead (that branch's actual
preflight infrastructure) — see the handoff prompt for why.

## 3. Definitive impacted-item list (ratio >= 1.4x)

**AP Statistics — 9 of 118:**

| content_key | correct len | distractor avg len | ratio |
|---|---|---|---|
| APSTATS-MCQ-005 | 186 | 82.0 | 2.27 |
| APSTATS-MCQ-017 | 179 | 87.0 | 2.06 |
| APSTATS-MCQ-018 | 262 | 127.7 | 2.05 |
| APSTATS-MCQ-003 | 106 | 54.3 | 1.95 |
| APSTATS-MCQ-015 | 154 | 79.0 | 1.95 |
| APSTATS-MCQ-010 | 169 | 89.7 | 1.88 |
| APSTATS-MCQ-011 | 182 | 97.3 | 1.87 |
| APSTATS-MCQ-013 | 184 | 112.0 | 1.64 |
| APSTATS-MCQ-006 | 132 | 91.0 | 1.45 |

**AP Biology — 41 of 54:**

| content_key | correct len | distractor avg len | ratio |
|---|---|---|---|
| APBIO-MCQ-005 | 222 | 73.0 | 3.04 |
| APBIO-MCQ-011 | 298 | 99.0 | 3.01 |
| APBIO-MCQ-088 | 348 | 136.7 | 2.55 |
| APBIO-MCQ-027 | 323 | 133.3 | 2.42 |
| APBIO-MCQ-024 | 390 | 162.7 | 2.40 |
| APBIO-MCQ-056 | 311 | 130.7 | 2.38 |
| APBIO-MCQ-072 | 417 | 179.3 | 2.33 |
| APBIO-MCQ-007 | 266 | 117.0 | 2.27 |
| APBIO-MCQ-093 | 343 | 151.0 | 2.27 |
| APBIO-MCQ-084 | 389 | 186.0 | 2.09 |
| APBIO-MCQ-038 | 237 | 115.3 | 2.05 |
| APBIO-MCQ-006 | 199 | 97.3 | 2.04 |
| APBIO-MCQ-079 | 274 | 135.3 | 2.02 |
| APBIO-MCQ-086 | 346 | 175.3 | 1.97 |
| APBIO-MCQ-004 | 216 | 111.0 | 1.95 |
| APBIO-MCQ-045 | 313 | 164.0 | 1.91 |
| APBIO-MCQ-003 | 232 | 122.3 | 1.90 |
| APBIO-MCQ-043 | 236 | 128.0 | 1.84 |
| APBIO-MCQ-047 | 316 | 172.3 | 1.83 |
| APBIO-MCQ-063 | 257 | 142.0 | 1.81 |
| APBIO-MCQ-029 | 311 | 176.0 | 1.77 |
| APBIO-MCQ-054 | 227 | 130.3 | 1.74 |
| APBIO-MCQ-041 | 283 | 164.7 | 1.72 |
| APBIO-MCQ-065 | 234 | 138.3 | 1.69 |
| APBIO-MCQ-090 | 302 | 178.3 | 1.69 |
| APBIO-MCQ-032 | 208 | 128.7 | 1.62 |
| APBIO-MCQ-014 | 141 | 87.3 | 1.61 |
| APBIO-MCQ-016 | 165 | 102.3 | 1.61 |
| APBIO-MCQ-009 | 166 | 103.7 | 1.60 |
| APBIO-MCQ-067 | 250 | 156.7 | 1.60 |
| APBIO-MCQ-049 | 246 | 156.0 | 1.58 |
| APBIO-MCQ-017 | 220 | 139.7 | 1.58 |
| APBIO-MCQ-099 | 330 | 214.3 | 1.54 |
| APBIO-MCQ-008 | 196 | 129.3 | 1.52 |
| APBIO-MCQ-097 | 295 | 202.0 | 1.46 |
| APBIO-MCQ-010 | 192 | 132.0 | 1.45 |
| APBIO-MCQ-034 | 206 | 142.0 | 1.45 |
| APBIO-MCQ-012 | 163 | 112.7 | 1.45 |
| APBIO-MCQ-036 | 174 | 123.3 | 1.41 |

## 4. Draft distractor rewrites (illustrative, NOT final)

These are drafts for subject-matter review — flagged explicitly, not a
finished remediation. Approach: keep the correct answer as-authored (trimming
risks losing rubric-relevant content), expand distractors with a real,
specific-but-wrong mechanism at similar length/specificity, so length stops
being a usable tell.

### APSTATS-MCQ-005 (ratio 2.27)

Correct (unchanged): *"There is an association between meditation habits and
blood pressure in this sample, but causation cannot be concluded because
participants were not randomly assigned to meditate or not."*

- B, current: *"Meditating for 20 minutes a day causes lower blood pressure."*
  **Draft rewrite:** *"Meditating for 20 minutes a day causes lower blood
  pressure, since the average drop observed among meditators in this sample is
  large enough that it is very unlikely to have occurred by chance alone."*
  (still wrong — conflates statistical significance with causal proof — but
  now matches the correct answer's clause structure and length.)
- D, current: *"No conclusion can be drawn because the study did not use a
  randomized experiment."*
  **Draft rewrite:** *"No conclusion can be drawn at all, because without
  random assignment to treatment groups, an observed association only
  reflects sampling variability and does not describe a real relationship
  even within this sample's own participants."*
  (still wrong — overstates what randomization does — matches length.)

### APSTATS-MCQ-017 (ratio 2.06)

Correct (unchanged): *"SE(b) = 0.6 measures how much the estimated slope, b,
would be expected to vary from sample to sample if many different random
samples of 45 adults were taken from the population."*

- A, current: *"On average, individual resting heart rates differ from the
  regression line's predictions by 0.6 beats per minute."*
  **Draft rewrite:** *"On average, individual resting heart rates differ from
  the regression line's predictions by 0.6 beats per minute — this confuses
  SE(b), the standard error of the slope estimate, with s, the standard
  deviation of the residuals around the regression line, which measures a
  different quantity entirely."*
  (keeps the same underlying wrong answer, adds the specific
  misconception it embodies, matching length/specificity.)

### APBIO-MCQ-011 (ratio 3.01)

Correct (unchanged): *"RNA likely preceded proteins as both the informational
and catalytic molecule, but RNA catalysis depended on metal-ion cofactors and
was far slower than modern protein enzymes — explaining why proteins
eventually took over most catalytic roles while RNA's catalytic role in
translation was retained."*

- A, current: *"RNA cannot have been the original catalyst because its kcat is
  too low to sustain any metabolism"*
  **Draft rewrite:** *"RNA cannot have been the original catalyst because its
  phosphodiester backbone lacks the diverse acidic, basic, and hydrophobic
  side chains that give protein active sites their catalytic power, so only
  amino-acid-based catalysts could plausibly have driven early metabolism."*
  (real biochemistry reasoning, still wrong per the RNA-world evidence —
  matches length/specificity of the correct answer.)
- C, current: *"Mg²⁺ ions were the original catalysts in pre-biotic chemistry;
  RNA evolved later to replace metal-ion catalysis"*
  **Draft rewrite:** *"Mg²⁺ and other metal ions were the original catalysts in
  pre-biotic chemistry, since they can drive phosphoryl-transfer reactions
  without any genetic template — RNA only arose afterward as a way to store
  and copy information, later co-opting catalysis from ions rather than the
  reverse."*

## 5. Publication note

None of these rewrites have been applied to any content row. `content_items`
and `content_item_versions` on this branch (once staging's
`content_pipeline_state_machine` migration lands) only allow publish from
`reviewed_approved` — any real fix has to go through a new version, review,
and re-approval, not a direct edit to a published row. Re-run
`checkAnswerLengthParity` against the new version before treating anything as
resolved.

## 6. Status — UPDATED 2026-07-21 (later same day)

**All 50 flagged items now have complete draft rewrite sets** (all 9 AP
Statistics + all 41 AP Biology, ratio >= 1.4x per §3's definitive list).
Drafts were produced conversationally, one or two items at a time, and
confirmed clear by David; they are not recorded item-by-item in this file —
the conversation transcript is the source of record for the exact wording
until they're carried into real content versions per §5. Each draft keeps
the correct answer unchanged and expands every distractor to a real,
specific-but-wrong misconception at the correct answer's length and
mechanistic specificity, per the pattern established in §4.

**Length-parity across all subjects, for visibility** (all published MCQs,
2026-07-21): Biology 39/54 flagged, AP Statistics 9/20 (note: AP Statistics'
`content_items.status` distribution changed mid-session — see the
2026-07-21 Production content-state finding, unrelated to this workstream),
Chemistry 0/2, all other subjects n<=2 with ratio < 1.4. The four Physics
subjects were independently re-verified in §8, and the three Calculus subjects
in §9; remaining subjects are unflagged at current sample sizes but were not
independently re-verified as complete for this workstream.

Still open:
- **Step 5 (§5, unchanged): none of these 50 drafts have been applied to any
  content row.** Routing them through a real new-version → review →
  re-approval cycle, and re-running the length-parity check against each
  resulting version, is the remaining work before any of this is "fixed"
  rather than "drafted."

## 7. AP Chemistry follow-up audit

**Completed:** 2026-07-21

**Production project:** `pcntajvbdfqhbeewmdry`

**Method:** Read-only SQL through an isolated Production-linked Supabase CLI
directory. The query joined `app.content_items` → latest
`app.content_item_versions` → `app.mcq_choices`, restricted to published MCQs
under the AP Chemistry subject. No Production row was inserted, updated, or
deleted.

### Production quantitative result

| Subject | Published MCQs | Correct-longer | Avg correct len | Avg distractor len | Ratio |
|---|---:|---:|---:|---:|---:|
| AP Chemistry | 2 | 2 (100%) | 21.0 | 15.8 | 1.33x |

The full affected `content_key` list at the `>= 1.4x` item threshold is:
**none**.

Per-item verification:

| content_key | Version | Version status | Correct len | Distractor avg len | Ratio | Flagged |
|---|---:|---|---:|---:|---:|---|
| `apchem-mcq-001` | 1 | published | 9 | 8.0 | 1.13x | no |
| `apchem-mcq-002` | 1 | published | 33 | 23.7 | 1.39x | no |

The second item is close to the threshold but remains below it using the same
unrounded calculation as the preflight check (`33 / 23.666... = 1.3944`).
Because no published Chemistry item is affected, there is no published-item
distractor rewrite to draft or redrafted Production version to recheck.

### Branch-package pre-publication result

The referenced `codex/five-subject-harness-and-content` worktree contains 20
Chemistry MCQ packages, of which only `apchem-mcq-001` and
`apchem-mcq-002` match the two published Production items. Running commit
`b1e803d`'s `content-preflight.ts` against all 20 packages produced two
non-blocking length-parity warnings:

| Scope | MCQs | Correct-longer | Avg correct len | Avg distractor len | Ratio | `>= 1.4x` |
|---|---:|---:|---:|---:|---:|---:|
| Branch Chemistry packages (not all published) | 20 | 9 (45%) | 15.4 | 14.8 | 1.04x | 2 |

Affected draft-package keys: `apchem-mcq-012`, `apchem-mcq-016`.

The following are **unreviewed draft candidates only**. They have not been
written into the package files or any database row and require AP Chemistry
subject-matter review.

- `apchem-mcq-012` (catalysis), choice B
  - Current: *"raises activation energy"*
  - **Unreviewed draft:** *"raises the reactants’ average kinetic energy"*
  - Misconception targeted: confusing a catalyst with a temperature increase.
    At fixed temperature, a catalyst does not raise average molecular kinetic
    energy; it provides an alternate reaction pathway with lower activation
    energy.
  - Same-check simulation: correct 31 characters; distractor average
    19.3 → 26.0; ratio 1.60x → **1.19x**; warning clears.

- `apchem-mcq-016` (inert gas at constant volume), choice A
  - Current: *"all partial pressures increase"*
  - **Unreviewed draft:** *"all reacting-gas partial pressures increase"*
  - Misconception targeted: applying the increase in total pressure to every
    reacting species. At fixed volume and temperature, adding inert gas raises
    total pressure but leaves each reacting gas's partial pressure unchanged.
  - Same-check simulation: correct 48 characters; distractor average
    33.7 → 38.0; ratio 1.43x → **1.26x**; warning clears.
  - Separate content defect found during qualitative review: the current stem
    says adding inert gas "changes equilibrium because," while the keyed answer
    correctly says the reacting-gas partial pressures do not change. A
    subject-matter reviewer should revise the stem to say **"does not change
    equilibrium because"** before this package is eligible for publication.

### Check and pipeline verification

- The referenced preflight implementation was inspected at commit `b1e803d`
  rather than reimplemented. Its full test file passes: 17 tests, 0 failures.
  It emits no length warning for the two real published Chemistry packages and
  emits the two warnings above across all 20 branch packages.
- Production currently has the expanded content status constraints and two
  `content_pipeline_guard_publish` triggers. Those guards require transition
  from `reviewed_approved` before an item/version can become `published`.
- This is not full database-level immutability for choice text:
  `service_role` still has `UPDATE` on `app.mcq_choices`, and the repository
  migrations do not define an unconditional trigger that rejects changes to
  choices belonging to an already-published version. Therefore the required
  operational path remains new version → qualified review → approval →
  publish, but a privileged raw update is not technically prevented by the
  current database boundary.
- Production's migration history records
  `20260721172940_enforce_content_review_qualification`, but did not return
  history entries for the repository filenames
  `20260720213000_content_pipeline_state_machine` or
  `20260721143031_lock_content_review_submission`, even though the publish
  constraints/triggers are present in the live catalog. This history/catalog
  drift was not changed as part of this read-only audit.

## 8. Four-subject AP Physics follow-up audit

**Completed:** 2026-07-21

**Production project:** `pcntajvbdfqhbeewmdry`

**Subjects:** AP Physics 1, AP Physics 2, AP Physics C: Mechanics, and AP
Physics C: Electricity and Magnetism.

**Method:** The same read-only latest-version query and unrounded `>= 1.4x`
item threshold used for Chemistry. Production was queried through the isolated
Production-linked Supabase CLI directory; no Production row was inserted,
updated, or deleted. The branch-package audit used commit `b1e803d`'s
`content-preflight.ts` against all 80 Physics MCQ packages.

### Production quantitative result

| Subject | Published MCQs | Correct-longer | Avg correct len | Avg distractor len | Ratio | `>= 1.4x` |
|---|---:|---:|---:|---:|---:|---:|
| AP Physics 1 | 1 | 0 (0%) | 6.0 | 6.3 | 0.95x | 0 |
| AP Physics 2 | 1 | 0 (0%) | 6.0 | 7.7 | 0.78x | 0 |
| AP Physics C: Mechanics | 1 | 1 (100%) | 7.0 | 6.3 | 1.11x | 0 |
| AP Physics C: Electricity and Magnetism | 1 | 0 (0%) | 13.0 | 13.7 | 0.95x | 0 |

Full affected Production `content_key` lists:

- AP Physics 1: **none** (`apphy1-mcq-001` = 0.95x).
- AP Physics 2: **none** (`apphy2-mcq-001` = 0.78x).
- AP Physics C: Mechanics: **none** (`apphycm-mcq-001` = 1.11x).
- AP Physics C: Electricity and Magnetism: **none**
  (`apphycem-mcq-001` = 0.95x).

Because no published Physics item is affected, no published-item rewrite or
new Production version was created.

### Branch-package pre-publication result

| Subject | MCQ packages | Correct-longer | Avg correct len | Avg distractor len | Ratio | `>= 1.4x` |
|---|---:|---:|---:|---:|---:|---:|
| AP Physics 1 | 20 | 11 (55%) | 17.0 | 13.4 | 1.26x | 6 |
| AP Physics 2 | 20 | 9 (45%) | 14.2 | 13.8 | 1.03x | 4 |
| AP Physics C: Mechanics | 20 | 14 (70%) | 8.1 | 6.9 | 1.17x | 8 |
| AP Physics C: Electricity and Magnetism | 20 | 10 (50%) | 10.0 | 9.3 | 1.07x | 6 |

Full affected draft-package lists:

- AP Physics 1: `apphy1-mcq-002`, `apphy1-mcq-004`, `apphy1-mcq-007`,
  `apphy1-mcq-010`, `apphy1-mcq-015`, `apphy1-mcq-019`.
- AP Physics 2: `apphy2-mcq-013`, `apphy2-mcq-015`, `apphy2-mcq-017`,
  `apphy2-mcq-020`.
- AP Physics C: Mechanics: `apphycm-mcq-002`, `apphycm-mcq-003`,
  `apphycm-mcq-004`, `apphycm-mcq-009`, `apphycm-mcq-010`,
  `apphycm-mcq-011`, `apphycm-mcq-012`, `apphycm-mcq-015`.
- AP Physics C: Electricity and Magnetism: `apphycem-mcq-002`,
  `apphycem-mcq-004`, `apphycem-mcq-014`, `apphycem-mcq-018`,
  `apphycem-mcq-019`, `apphycem-mcq-020`.

### Unreviewed balanced distractor drafts

These are **draft candidates for qualified Physics subject-matter review**,
not final content. They keep every correct answer unchanged and replace all
three distractors on each flagged item so the options have comparable length
and distinct error mechanisms. They were simulated in memory only; no package
file or database row was changed.

#### AP Physics 1

| content_key | Unreviewed draft distractors | Misconceptions targeted | Ratio before → after |
|---|---|---|---:|
| `apphy1-mcq-002` | A “velocity change”; C “force impulse”; D “energy transfer” | Confuses the area of a velocity-time graph with acceleration-time, force-time, or power-time area. | 1.64x → **0.84x** |
| `apphy1-mcq-004` | A “Earth's force on the book”; C “gravity's force on the table”; D “the book's resisting inertia” | Chooses a second force on the same object, the table's weight, or treats inertia as a force instead of identifying the book-on-table reaction. | 1.42x → **0.93x** |
| `apphy1-mcq-007` | A “one-half”; B “two times”; D “eight times” | Applies inverse, linear, or cubic scaling instead of the quadratic kinetic-energy relation. | 1.43x → **1.07x** |
| `apphy1-mcq-010` | A “equal-magnitude velocity changes”; B “equal masses during the collision”; D “equal changes in kinetic energy” | Treats equal impulse as implying equal velocity change, mass, or kinetic-energy change rather than equal-magnitude momentum change. | 1.88x → **1.00x** |
| `apphy1-mcq-015` | A “constant and directed toward equilibrium”; C “proportional to velocity and opposite the motion”; D “zero except at the turning points” | Confuses SHM with constant acceleration, resistive damping, or reverses where acceleration vanishes. | 2.69x → **1.09x** |
| `apphy1-mcq-019` | A “a new forward force acts on them”; C “the seat briefly reduces their mass”; D “gravity tilts toward the windshield” | Invokes a fictitious forward force, mass loss, or rotating gravity instead of inertia. | 1.45x → **0.94x** |

#### AP Physics 2

| content_key | Unreviewed draft distractors | Misconceptions targeted | Ratio before → after |
|---|---|---|---:|
| `apphy2-mcq-013` | A “increases with speed”; B “decreases with speed”; D “vanishes in glass” | Makes source frequency follow propagation speed or disappear at the boundary instead of holding frequency constant. | 1.40x → **0.74x** |
| `apphy2-mcq-015` | A “from lower to higher index above a critical angle”; C “at normal incidence when reflection is strongest”; D “from either medium whenever the incidence angle is large” | Reverses the index condition, substitutes normal incidence, or ignores the required high-to-low transition. | 2.01x → **1.00x** |
| `apphy2-mcq-017` | B “a half-integer multiple of wavelength”; C “zero regardless of the source phase”; D “greater than the wave amplitude” | Uses the destructive-interference condition, ignores source phase, or compares path difference with amplitude. | 1.41x → **0.96x** |
| `apphy2-mcq-020` | B “the electron rest mass”; C “each electron's charge”; D “the atom's proton count” | Changes intrinsic particle or nuclear properties instead of the emitted electron's maximum kinetic energy. | 1.57x → **0.99x** |

#### AP Physics C: Mechanics

| content_key | Unreviewed draft distractors | Misconceptions targeted | Ratio before → after |
|---|---|---|---:|
| `apphycm-mcq-002` | A `kT²/4`; B `kT²`; D `2kT²` | Applies an extra averaging factor, omits the integration factor, or doubles the endpoint rectangle. | 1.88x → **1.25x** |
| `apphycm-mcq-003` | A `aL²/4`; B `aL²`; D `2aL²` | Applies the wrong triangular-area factor or treats the endpoint force as constant over the interval. | 1.88x → **1.25x** |
| `apphycm-mcq-004` | A `v₀(1-bt/m)`; C `v₀e^{+bt/m}`; D `v₀/(1+bt/m)` | Uses a linearized form as exact, reverses the exponential sign, or substitutes the quadratic-drag solution form. | 1.83x → **1.03x** |
| `apphycm-mcq-009` | A `F(T)T/2`; C `T·dF/dt`; D `∫₀ᴸF(x)dx` | Assumes a triangular force-time graph, differentiates force, or computes work instead of impulse. | 1.69x → **1.17x** |
| `apphycm-mcq-010` | A “rocket alone as mass decreases”; C “exhaust alone after expulsion”; D “rocket and Earth, not exhaust” | Chooses open or irrelevant system boundaries instead of rocket plus expelled mass. | 1.44x → **0.85x** |
| `apphycm-mcq-011` | A `dθ/dt`; C `d(θ²)/dt²`; D `θ/t²` | Uses angular velocity, differentiates the squared coordinate, or substitutes a finite quotient for the second derivative. | 1.91x → **1.17x** |
| `apphycm-mcq-012` | A `+dU/dθ`; C `-U/θ`; D `-∫U dθ` | Drops the restoring sign, substitutes a finite ratio, or integrates instead of differentiating potential energy. | 1.50x → **1.13x** |
| `apphycm-mcq-015` | B `θ''-(g/L)θ=0`; C `θ'+(g/L)θ=0`; D `θ''+gθ=0` | Reverses the restoring sign, reduces the dynamics to first order, or omits the pendulum length. | 1.64x → **1.16x** |

#### AP Physics C: Electricity and Magnetism

| content_key | Unreviewed draft distractors | Misconceptions targeted | Ratio before → after |
|---|---|---|---:|
| `apphycem-mcq-002` | B `ρ(R)(4πR³/3)`; C `4π∫₀ᴿρ(r)dr`; D `4πR²ρ(R)` | Treats boundary density as uniform, omits the spherical `r²` volume factor, or uses a surface shell instead of enclosed volume. | 1.86x → **1.26x** |
| `apphycem-mcq-004` | A `+∫aᵇE·dl`; C `-∫aᵇ(∇×E)·dl`; D `-q∫aᵇE·dl` | Drops the sign, substitutes a curl integral, or gives potential-energy change rather than potential difference. | 1.85x → **0.83x** |
| `apphycem-mcq-014` | B “E constant/tangent on a loop”; C “enclosed current is uniform”; D “magnetic potential is discontinuous” | Applies the symmetry condition to the wrong field or substitutes current/potential conditions that do not make the Ampère integral directly solvable. | 1.56x → **0.93x** |
| `apphycem-mcq-018` | A `1/(2π√(LC))`; B `1/(LC)²`; D `√(LC)/2π` | Reports ordinary frequency instead of angular frequency, squares the inverse product, or uses a quantity with time rather than inverse-time dimensions. | 1.91x → **0.81x** |
| `apphycem-mcq-019` | A “at infinity where E=0”; C “on each Gaussian sphere”; D “along the radial axis” | Confuses zero field with a source singularity or spreads the point-source divergence over a surface or line. | 1.65x → **1.02x** |
| `apphycem-mcq-020` | A “conservative because circulation remains zero”; C “radial around the changing magnetic flux”; D “zero in vacuum because no charges are present” | Treats induced fields as electrostatic, imposes point-source geometry, or assumes charges are required for a changing flux to induce an electric field. | 1.76x → **0.92x** |

### Physics verification and correction status

- Preflight before redrafting: 80 items, 0 blocking findings, 24
  `MCQ_CORRECT_ANSWER_LENGTH_OUTLIER` warnings.
- In-memory balanced redraft: all 24 candidate sets found and applied; the
  exact preflight check reports **0 remaining length outliers**.
- The committed preflight tests remain 17/17 passing, and the current branch's
  standalone parity tests remain 4/4 passing.
- Qualitative review found no incorrect keyed Physics answer or internally
  contradictory stem among the 24 flagged items. These drafts still require
  qualified Physics subject-matter review before use.
- No package hashes, package JSON, published rows, versions, or review records
  were changed. Any accepted correction must be written as a new content
  version and pass the review/publish flow described in §7.

## 9. AP Calculus AB, AP Calculus BC, and AP Precalculus follow-up audit

**Completed:** 2026-07-21

**Production project:** `pcntajvbdfqhbeewmdry`

**Method:** The same read-only latest-version query and unrounded `>= 1.4x`
item threshold used in §7–§8. Production was queried through the isolated
Production-linked Supabase CLI directory. The package audit used commit
`b1e803d`'s `content-preflight.ts` against all 60 MCQ packages. No Production
or package row was modified.

### Production quantitative result

| Subject | Published MCQs | Correct-longer | Avg correct len | Avg distractor len | Ratio | `>= 1.4x` |
|---|---:|---:|---:|---:|---:|---:|
| AP Calculus AB | 2 | 0 (0%) | 1.0 | 4.8 | 0.21x | 0 |
| AP Calculus BC | 1 | 0 (0%) | 1.0 | 6.7 | 0.15x | 0 |
| AP Precalculus | 1 | 0 (0%) | 1.0 | 1.0 | 1.00x | 0 |

Full affected Production `content_key` lists:

- AP Calculus AB: **none** (`apcalcab-mcq-001` = 0.12x;
  `apcalcab-mcq-002` = 1.00x).
- AP Calculus BC: **none** (`apcalcbc-mcq-001` = 0.15x).
- AP Precalculus: **none** (`apprecalc-mcq-001` = 1.00x).

Because no published item is affected, no published-item rewrite or new
Production version was created.

### Branch-package pre-publication result

| Subject | MCQ packages | Correct-longer | Avg correct len | Avg distractor len | Ratio | `>= 1.4x` |
|---|---:|---:|---:|---:|---:|---:|
| AP Calculus AB | 20 | 10 (50%) | 11.7 | 10.0 | 1.17x | 3 |
| AP Calculus BC | 20 | 12 (60%) | 9.3 | 8.1 | 1.14x | 4 |
| AP Precalculus | 20 | 14 (70%) | 14.8 | 12.2 | 1.22x | 4 |

Full affected draft-package lists:

- AP Calculus AB: `apcalcab-mcq-005`, `apcalcab-mcq-013`,
  `apcalcab-mcq-018`.
- AP Calculus BC: `apcalcbc-mcq-007`, `apcalcbc-mcq-009`,
  `apcalcbc-mcq-016`, `apcalcbc-mcq-018`.
- AP Precalculus: `apprecalc-mcq-006`, `apprecalc-mcq-007`,
  `apprecalc-mcq-010`, `apprecalc-mcq-014`.

### Unreviewed balanced distractor drafts

These are **draft candidates for qualified Calculus/Precalculus subject-matter
review**, not final content. Correct answers remain unchanged. All three
distractors were reviewed together so each option expresses a distinct,
plausible mathematical error at a comparable level of detail. The drafts were
applied only in memory for verification.

#### AP Calculus AB

| content_key | Unreviewed draft distractors | Misconceptions targeted | Ratio before → after |
|---|---|---|---:|
| `apcalcab-mcq-005` | A `e^(2x)(2 cos x+sin x)`; C `e^(2x)(sin x+2 cos x)`; D `2e^(2x)(sin x+cos x)` | Attaches the chain-rule factor to the wrong product-rule term or multiplies both terms by it. | 1.43x → **1.02x** |
| `apcalcab-mcq-013` | A “f has local minima at x=0 and x=2 because f′ vanishes”; C “f increases on (0,2) and decreases outside that interval”; D “f is concave up for x<1 and concave down for x>1” | Treats critical points as automatic minima, reverses the `f′` sign chart, or reverses the `f″` concavity chart. | 1.96x → **1.05x** |
| `apcalcab-mcq-018` | A `√13`; B `±4`; D `±5` | Omits part of the integrated `x²` contribution, retains an inadmissible negative branch despite `y(0)=3`, or adds/integrates inconsistently. | 1.80x → **1.29x** |

#### AP Calculus BC

| content_key | Unreviewed draft distractors | Misconceptions targeted | Ratio before → after |
|---|---|---|---:|
| `apcalcbc-mcq-007` | A `2/3`; C `3/2`; D `5/3` | Reverses the Newton-update sign or makes derivative/arithmetic errors in `x₁=x₀−f(x₀)/f′(x₀)`. | 1.80x → **1.00x** |
| `apcalcbc-mcq-009` | A `(1/2)ln|x²−1|+C`; C `2ln|(x−1)/(x+1)|+C`; D `(1/2)arctan(x)+C` | Applies a chain-rule antiderivative without partial fractions, mis-scales the logarithmic result, or substitutes the `1/(1+x²)` template. | 1.78x → **1.35x** |
| `apcalcbc-mcq-016` | A `√(1+4)`; C `2+6`; D `√(2+6)` | Uses position components, adds velocity components, or forgets to square components before taking the speed magnitude. | 2.40x → **0.80x** |
| `apcalcbc-mcq-018` | A “converges absolutely because the ratio approaches 1/3”; B “converges conditionally because the terms alternate in sign”; D “diverges because the ratio limit approaches 1 from below” | Drops the factorial's `n+1` factor, invents alternation for positive terms, or misstates the limiting ratio. | 1.76x → **0.79x** |

#### AP Precalculus

| content_key | Unreviewed draft distractors | Misconceptions targeted | Ratio before → after |
|---|---|---|---:|
| `apprecalc-mcq-006` | A `(2x)²−1+3`; C `(2x−1)²`; D `(x²+3)(2x−1)` | Squares only part of the inner expression, omits the outer `+3`, or multiplies functions instead of composing them. | 1.93x → **0.96x** |
| `apprecalc-mcq-007` | A “Q(x) approaches zero”; B “Q(x) approaches one”; D “Q(x) behaves like x²” | Applies lower-degree, equal-degree, or degree-difference-two end behavior instead of the degree-difference-one slant behavior. | 1.78x → **0.97x** |
| `apprecalc-mcq-010` | B `(1/2)ln(3x)`; C `(1/2)ln(x−3)`; D `3ln(x)/2` | Fails to divide by the outer coefficient before taking logs, subtracts instead of divides, or fails to undo the exponential scaling. | 1.50x → **1.16x** |
| `apprecalc-mcq-014` | A `x>2 only`; B `x<−2 only`; C `−2<x<2 only` | Keeps only one solution branch or reverses the sign condition for the logarithm's argument. | 2.54x → **1.18x** |

### Calculus/Precalculus verification and correction status

- Preflight before redrafting: 60 items, 0 blocking findings, 11
  `MCQ_CORRECT_ANSWER_LENGTH_OUTLIER` warnings.
- In-memory balanced redraft: all 11 candidate sets found and applied; the
  exact preflight check reports **0 remaining length outliers**.
- The committed preflight tests remain 17/17 passing, and the current branch's
  standalone parity tests remain 4/4 passing.
- Qualitative review found no incorrect keyed answer or internally
  contradictory stem among the 11 flagged items. The drafts still require
  qualified subject-matter review before use, including corresponding
  rationale updates if accepted.
- No package hashes, package JSON, published rows, versions, or review records
  were changed. Accepted corrections must use a new content version and the
  review/publish flow described in §7.
