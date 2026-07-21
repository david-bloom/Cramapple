# MCQ answer-length parity QA

**Date:** 2026-07-21
**Trigger:** AP Statistics tutor Jill's feedback that correct MCQ answers are
systematically longer and more detailed than distractors.
**Scope so far:** AP Statistics, AP Biology (Production, `pcntajvbdfqhbeewmdry`,
latest version of every published MCQ). Chemistry handed off separately
(see `prompts/CODEX_CHEMISTRY_MCQ_LENGTH_PARITY_QA.md`).

## 1. Verdict

Confirmed, in both subjects, and worse in Biology than in Stats:

| Subject | Published MCQs | Correct-longer | Avg correct len | Avg distractor len | Ratio |
|---|---|---|---|---|---|
| AP Statistics | 118 | 88 (75%) | 78.5 | 49.0 | 1.60x |
| AP Biology | 54 | 47 (87%) | 217.1 | 125.6 | 1.73x |

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

## 6. Remaining work

- 5 more Stats items and 37 more Biology items in the table above still need
  drafts (only the top few per subject were drafted here as a template).
- Chemistry: handed to Codex, see `prompts/CODEX_CHEMISTRY_MCQ_LENGTH_PARITY_QA.md`.
- Not yet checked: AP Calculus AB/BC, AP Physics 1/2/C-EM/C-Mech, AP
  Precalculus. The check function is subject-agnostic — running it on the
  remaining subjects is a cheap follow-up once someone wants that visibility.
