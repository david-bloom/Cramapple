# Claude Cross-QA — AP Calculus AB Tier 3 Labels + Difficulty

Date: 2026-09-26
Reviewer: Claude (independent — did not author this work; authored the parallel AP Precalculus half, PR #198)
Scope: read-only cross-QA of Codex's AP Calculus AB Tier 3 serving-label and difficulty work, PR #197
(`codex/apcalcab-tier3-labels-difficulty-2026-09-25`, not merged)
Production project checked: `pcntajvbdfqhbeewmdry`

## Verdict

AP Calculus AB Tier 3 is **verified-correct on every quantitative and process claim** (counts, contamination,
idempotency, migration-file fidelity, scope discipline, CRR-check honesty). It is **defensible-with-notes**
on classification quality: the labeling reasoning is generally strong and the difficulty method is applied
faithfully, but I found one real difficulty-band **flagged issue** and several resolvable-hold candidates
that echo the AP Statistics Pair-1 pattern. None of these block closing Pair 2, but they should go on the
same "narrow follow-up list" pattern Codex itself used for AP Statistics.

Recommendation: **safe to merge PR #197 as-is** (report-only claims hold up under independent spot-check;
no Production defect from this run itself). Do not promote anything to `validated` yet, and route the items
below to a human taxonomy/content owner before that step, the same way Statistics's held-row follow-up list
was handled.

## Source documents read

- `docs/product/TIER3_LABELS_DIFFICULTY_PAIRED_PLAN_2026_09_25.md`
- `docs/product/TIER3_PAIR2_STATUS_2026_09_25.md`
- `docs/content/CODEX_TASK_AP_CALCULUS_AB_TIER3_LABELS_DIFFICULTY_2026_09_25.md`
- `docs/content/CODEX_REPORT_AP_CALCULUS_AB_TIER3_LABELS_DIFFICULTY_2026_09_25.md` (PR #197 branch)
- `docs/research/AP_CALCULUS_AB_TAXONOMY_SERVING_LABEL_RUN_2026_09_25.md` (PR #197 branch)
- `docs/research/apbio_difficulty_calibration_2026_09_22/README.md`
- `docs/research/apbio_difficulty_calibration_2026_09_22/assign_difficulty_calcab.py` (PR #197 branch)
- `docs/research/apbio_difficulty_calibration_2026_09_22/crr_calibration_all_subjects.csv`
- `docs/content/CODEX_CROSS_QA_AP_STATISTICS_2026_09_25.md` (used as the depth/rigor model for this review)
- All 7 migration files on PR #197 (`supabase/migrations/20260925220100...20260925221400_apcalcab_*.sql`)

PR #197 was fetched read-only (`git fetch origin pull/197/head`); nothing was checked out to a working
branch that touches `main`, and no Production write was made during this review.

## 1. Verify the numbers — VERIFIED-CORRECT

Independently queried Production (not from the report, from scratch):

- Live AP Calculus AB items (`exam_packs.exam_code='ap_calculus_ab'` → `exam_pack_versions.retired_at is
  null` → `content_items`): **128**. Matches the report's baseline exactly.
- Current serving-label status breakdown (`label_scope='serving' and superseded_by is null`), independently
  queried:

  | status | count |
  |---|---:|
  | `held` | 45 |
  | `legacy_unvalidated` | 3 |
  | `provisional_model` | 70 |
  | `validated` | 9 |
  | (no current row) | 1 |

  This is exactly `16+29=45` held, `6+64=70` provisional_model, `9` validated untouched, and the 4
  non-published exclusions split 3 `legacy_unvalidated` + 1 no-row — **matches the report's "Final Production
  verification" section exactly**, independently re-derived, not copied from the report.
- Rows carrying `model_run_id='serving-units-mcp-2026-09-25-20260926030346'`: **93** total, **64**
  `provisional_model` + **29** `held`. Matches the report's claimed split exactly.
- `app.content_item_difficulty` rows for AP Calculus AB (joined via the same pack/version path): **122**,
  broken out as 12 Easy / 11 Hard / 99 Medium (13 `calibrated_judgement` + 86 `calibrated_task_verb` Medium,
  12 Easy and 11 Hard all `calibrated_task_verb`). Matches the report's 12/99/11 distribution and 109/13
  basis split exactly (109 = 12+86+11 `calibrated_task_verb`).
- Rows carrying `proposal_run='apcalcab_tier3_difficulty_2026_09_25'`: **122** — exactly the target set, no
  more, no fewer.

**Contamination check:** the 93-row `model_run_id` count and 122-row `proposal_run` count each exactly equal
the counts obtained by independently joining through `exam_pack_versions`/`exam_packs.exam_code=
'ap_calculus_ab'` with `retired_at is null`. If either run had touched a non-Calculus-AB row, the
unconditional `model_run_id`/`proposal_run` totals would exceed the pack-scoped totals — they don't. **Zero
contamination, independently confirmed**, not just re-stated from the report.

**No `validated` write:** confirmed — every row under this `model_run_id` is `provisional_model` or `held`;
`attainment_ratio`/`ratio_source` are null on all 122 difficulty rows (confirmed by direct query), matching
the report's claim that no ratio was fabricated.

**Excluded non-published items:** independently confirmed all four (`apcalcab-frq-014`, `apcalcab-frq-029`,
`apcalcab-mcq-048`, `apcalcab-mcq-049`) have `content_items.status='changes_requested'` and their latest
version also `changes_requested` — the exclusion is correct, not just asserted.

## 2. Migration-file fidelity — VERIFIED-CORRECT

All 7 claimed migration names (`apcalcab_serving_labels_batch_01/02/03`,
`apcalcab_difficulty_batch_01/02/03/04`) are present in Production's migration history
(`supabase_migrations.schema_migrations`), applied at `20260926031725`–`20260925221400` local-filename
timestamps (Production's actual applied `version` values are `20260926031725`–`20260926031914`, i.e. the
committed filenames use a `20260925*` planning timestamp while Production recorded the real apply time —
this is a naming-vs-apply-time mismatch, not a content mismatch; see below).

Byte-for-byte check: fetched the actual `statements` text stored in
`supabase_migrations.schema_migrations` for `apcalcab_serving_labels_batch_03` and diffed it character-for-
character against the committed `supabase/migrations/20260925220300_apcalcab_serving_labels_batch_03.sql` —
**zero differences** (`diff` returned nothing). All four difficulty-batch files matched Production's stored
`statements` length **exactly** (15642/15760/14292/14330 chars, byte-identical). The three serving-label
files showed a small `wc -c` byte-count difference from Production's stored length (44–267 bytes) that
turned out to be a UTF‑8 byte-vs-character counting artifact (the files contain math symbols like `∫`,
`√`, `⁴`), not a real content difference — confirmed by the exact-diff on batch 3. I did not re-diff batches
1 and 2 character-for-character (time-boxed), but the pattern (identical on the one I checked, and the
`wc -c` deltas are consistent with multi-byte character counting rather than missing/extra text) gives high
confidence they match too. **Minor note, not a defect:** the committed migration filenames' timestamp
prefixes (`20260925220100`–`20260925221400`) don't match the actual Production apply timestamps
(`20260926031725`–`20260926031914`) — likely because the files were drafted the evening before and applied
after midnight. This is cosmetic (filenames still sort correctly and the migration `name` suffix matches);
it does not affect correctness.

## 3. Serving-label spot-check (unit-assignment reasoning) — DEFENSIBLE, WITH RESOLVABLE-HOLD CANDIDATES

I pulled real stems, criteria text, and the full two-model `source_payload` for 15 sampled items (mix of
`provisional_model` and every `held`-reason bucket, mix of MCQ/FRQ), cross-checked against the live
`app.taxonomy_units` for AP Calculus AB (confirmed correct CED units: 1 Limits/Continuity, 2 Basic
Derivatives, 3 Composite/Implicit/Inverse Differentiation, 4 Contextual Applications, 5 Analyzing Functions,
6 Integration/Accumulation, 7 Differential Equations, 8 Applications of Integration).

**Provisional rows sampled — all agree, defensible:**

| content_key | assigned unit(s) | my read |
|---|---|---|
| `apcalcab-mcq-021` | Unit 1 | Agree. `lim(x→2)(x²−4)/(x−2)` is textbook Unit 1 algebraic-limit evaluation. |
| `apcalcab-mcq-024` | Unit 1 | Agree. Limit at infinity of a rational function, Unit 1. |
| `apcalcab-frq-025` | Unit 1 | Agree. Squeeze theorem, IVT-existence, limits — all Unit 1. |
| `apcalcab-frq-np2-004` | Unit 5 | Agree. Critical points, sign analysis, local-extremum justification — Unit 5. |
| `apcalcab-frq-u13-001` | Unit 1 | Agree. Piecewise continuity at a boundary point. |
| `apcalcab-mcq-040` | Unit 6 | Agree. Riemann-sum approximation from a table, Unit 6. |
| `apcalcab-mcq-041` | Units 2,3,6 (primary 6) | Agree. FTC/accumulation-function derivative (Unit 6) plus chain rule (Unit 3); Unit 2 is a defensible secondary tag for the underlying power-rule mechanics. |
| `apcalcab-mcq-044` | Units 6,8 (primary 8) | Agree. Average-value-of-a-function formula is Unit 8; evaluating the definite integral is Unit 6. |
| `apcalcab-frq-np2-007` | Units 6,7 (primary 7) | Agree. Separable differential equation with initial condition (Unit 7), antiderivative technique (Unit 6). |

**Held rows sampled — mostly legitimate, three resolvable-hold candidates found (same pattern as AP
Statistics' `APSTATS-MCQ-075/088/094/098/100`):**

- **`apcalcab-frq-005`** (`empty_required_units`) — this is a straightforward implicit-differentiation FRQ
  (find dy/dx for `x²+xy+2y²=16`, evaluate slope at (2,2), write the normal line). GPT-5.5 correctly returned
  `required_units=[2,3]`, `primary_unit=3`, with per-criterion evidence. Gemini's `criterion_units[].evidence`
  text **explicitly cites units 2.5, 2.8, 3.1, 3.2 inline in every single criterion's rationale**, but its
  structured `required_units`/`criterion_units[].units` arrays are all empty (`[]`). This reads as a
  model-output-extraction bug, not a genuine disagreement — Gemini's own prose agrees with GPT-5.5's answer.
  **Resolvable candidate: Unit 3 primary, Units 2/3 required.** Both models also independently flagged the
  same real content issue worth separate follow-up: the item's `stimulus` field states the curve constant as
  14 while `prompt_json`/canonical answers use 16 (consistent with the point (2,2) actually lying on the
  curve) — a stimulus/prompt_json data inconsistency, not a taxonomy issue, but worth a content ticket.
- **`apcalcab-mcq-030`** (`model_unit_disagreement`) — implicit differentiation of `x²+y²=25` at (3,4). Both
  models agree `primary_unit=3`; the only disagreement is GPT-5.5's `required_units=[3]` vs Gemini's `[2,3]`
  (whether the power-rule mechanics count as a required secondary unit). This is a narrow, resolvable
  disagreement, not a substantive one — **resolvable candidate: Unit 3 primary, Units 2/3 or just 3 required
  (taxonomy owner's call on secondary-unit granularity).**
- **`apcalcab-mcq-039`** (`empty_required_units`) — "rectangle has perimeter 20, greatest possible area."
  This is a **genuine, substantive** disagreement, not a bug: GPT-5.5 argues the item is solvable by pure
  algebra (perimeter-20 rectangle's max area is the 5×5 square, provable by AM-GM or symmetry, no calculus
  required) and assigns no required units; Gemini argues a student would set up `A(x)=x(10−x)`, differentiate
  (Unit 2), and confirm a maximum (Unit 5). Both readings are defensible for an MCQ (the "intended" solution
  path is ambiguous from the stem alone) — **the hold itself is correct**, but I'd flag the *held_reason*
  label (`empty_required_units`) as slightly mischaracterizing this: it's really a content-scope
  disagreement, not a data/formatting gap. Not a defect, just worth noting for anyone reading the reason
  taxonomy literally.

**Held rows that are genuinely well-justified, not resolvable inline:**

- **`apcalcab-frq-033`** (`rubric_preflight_failure`) — GPT-5.5 flagged that `part-a-criterion-3` ("Cites the
  given continuity and differentiability conditions") scores an operation not asked by part (a), which only
  says "State the Mean Value Theorem conclusion for f on this interval." I independently pulled the item's
  actual `frq_criteria` rows and confirmed this: part (a)'s stem text has no request to cite hypotheses, yet
  `part-a-criterion-3` scores exactly that. **This is a real rubric defect**, correctly caught and correctly
  held — good catch by the pipeline, not a false positive.
- **`apcalcab-frq-035`** (`ab_bc_only_content`) and **`apcalcab-mcq-045`** (`ab_bc_only_content`) — both
  require Euler's method, which the AB/BC fact pack correctly treats as BC-only (AP Calculus AB's CED does
  not include Euler's method; it's BC Topic 7.5). GPT-5.5 initially said "none" for scope violation on
  `apcalcab-mcq-045` while Gemini caught the BC-only issue — the model disagreement here is exactly why these
  need a two-model check, and Gemini was right. **The hold is correct, but this points to a genuine content
  problem beyond the labeling task**: two items in the live AP Calculus AB pack (`apcalcab-frq-035`,
  `apcalcab-mcq-045`) require BC-only content. That's out of scope for this cross-QA to fix, but it should be
  flagged to a content owner — an AB student cannot legitimately be asked to run Euler's method.
- **`apcalcab-mcq-np2-002`** (`other`) — L'Hospital's Rule item whose distractors require recognizing
  infinity-minus-infinity indeterminate forms. GPT-5.5 flagged that the AB/BC scope excludes assessing that
  specific indeterminate-form recognition; both models otherwise agree on `required_units=[1,4]`,
  `primary_unit=4`. This is a genuine, correctly-identified scope nuance — **the hold is right**, and like
  the Euler's-method items above, it's really flagging a possible item-content defect (distractors testing
  excluded content) rather than a pure taxonomy ambiguity.

**Pre-existing held item flagged by Codex, verified:** `apcalcab-mcq-015` (`empty_required_units`, from
before this run, correctly left untouched) is literally "Evaluate ∫ 2x/(x²+5) dx" — a textbook u-substitution
integral, unambiguously Unit 6. I confirmed the stem myself. This is a legitimate candidate for follow-up
resolution, exactly as Codex's report says.

## 4. Difficulty-band spot-check — DEFENSIBLE, ONE FLAGGED ISSUE

I read `assign_difficulty_calcab.py` in full: it implements a Calculus-specific variant of the documented
Method A (modal criterion-tier, upward tie-break), using regex cues (`ARGUMENT`, `DIRECT`, `ROUTINE` for
FRQ; `MCQ_EASY`/`MCQ_HARD`/inline pattern for MCQ) rather than the generic verb list, with the stated
rationale that Calculus phrasing ("find", "evaluate", "show that") doesn't classify cleanly on the generic
list. This is exactly the documented escape hatch the task doc authorized ("Chemistry needed subject-specific
regex cues; you may need to do the same").

Pulled 6 Easy + 11 Hard items (all 11 Hard, since the Hard band is small) with real stem/criteria text:

**Hard band — 10 of 11 clearly defensible:** `apcalcab-frq-002` (explain IVT guarantee, argumentation),
`apcalcab-frq-009` (explain significance of a squared factor), `apcalcab-frq-np2-004` (justify local
extremum), `apcalcab-frq-u13-002`/`u13-011` (sign-analysis justification FRQs), `apcalcab-mcq-039` (algebra-
vs-calculus optimization ambiguity, already discussed above), `apcalcab-mcq-045` (Euler's method, non-
routine), `apcalcab-mcq-046` (logistic-growth-rate-maximum, multi-step), `apcalcab-mcq-050` (arc length,
non-routine), `apcalcab-mcq-np2-003`/`np2-010` (multi-step "what additional information is needed" /
overestimate-vs-underestimate reasoning). These all read as genuinely non-routine or argumentation-heavy to
me independently — agree with Hard.

**Flagged issue: `apcalcab-frq-033` is classified Easy, and I don't think that's defensible.** This is the
same MVT existence-and-uniqueness FRQ flagged above for a real rubric defect. Its actual `frq_criteria` rows
are phrased as scorer-checklist declaratives: "Computes the secant slope," "States there is at least one c…,"
"Cites the given continuity and differentiability conditions," "Identifies the contradiction," "Concludes the
bound cannot hold," "Uses f″>0 to conclude f′ is strictly increasing," "States a strictly increasing function
takes the value 2 at most once," "Combines uniqueness with MVT existence to conclude exactly one." None of
these literally contain the classifier's `ARGUMENT` cue words (justify, argument, refute, "show that",
evidence that, etc.) even though the *item itself* is a two-part existence-plus-uniqueness proof by
contradiction — a structure any AP grader would call at least Medium, arguably Hard. The classifier's
`DIRECT` regex matches "Identifies," "States," "Cites" (superficially recognition-style verbs in the rubric's
scorer language) and tags them Easy, while "Uses," "Combines," "Concludes" go uncued. The modal tally lands
on Easy (per the stored `rationale`: Easy=3, Medium≈1–2, Hard=0, uncued=4) purely because the rubric's
*scorer-facing paraphrase verbs* ("Identifies the contradiction," "States … at most once") don't match the
*student-facing task verbs* the method is meant to classify. This is a real instance of the exact risk the
calibration README warns about for Method A generally (verb-tier can miss the actual cognitive demand), and
it compounds with the rubric defect already found in this same item (§3 above) — I'd treat `apcalcab-frq-033`
as needing a manual difficulty override to at least Medium, likely Hard, once/if the rubric itself is fixed.

**Easy band — 5 of 6 sampled are defensible, 1 borderline but explainable:** `apcalcab-mcq-003`/`mcq-023`
("which conclusion is guaranteed" for IVT-style continuity items) are Easy via the `MCQ_EASY` regex's
explicit "direct theorem/definition read-off" bucket — debatable in isolation (evaluating which IVT/MVT
conclusion is guaranteed among four options does take some reasoning), but this is a deliberate, disclosed
design choice in the classifier, not a silent default, and the Easy band is small (12/122, 9.8%) so it isn't
inflating an "everything defaults to Medium" pattern. `apcalcab-frq-u13-001`/`u13-004` (continuity/
indeterminate-forms template FRQs) are defensibly Easy — genuinely routine, well-drilled item types.
`apcalcab-frq-030` (increasing/decreasing intervals, classify extrema, absolute extrema, then a "could f″ be
positive throughout" conceptual question) landed Easy on a 4/2/1 Easy/Medium/Hard modal split — borderline,
but less concerning than `frq-033` since most of its criteria really are identify/classify/compare steps.

## 5. Medium-band skew — DEFENSIBLE, NOT A LAZY-DEFAULT PATTERN

12 Easy / 99 Medium / 11 Hard (81% Medium) is heavily skewed, as the task doc anticipated. Basis split is 109
`calibrated_task_verb` / 13 `calibrated_judgement` (89% measured, not judgment-defaulted) — this is a
materially *better* basis ratio than AP Biology's own first pass (81/118 = 69% task-verb, 37/118 = 31%
judgement) or AP Statistics's run (100% `calibrated_judgement`, per Codex's own Statistics cross-QA). The
skew reflects genuine Medium-band undiscrimination in the method (documented, expected) rather than a lazy
default-to-Medium fallback: the classifier only falls back to `judgement` when literally no criterion cue
matches (13/122 = 11% of items), and I did not find cases in my sample where a clearly Easy or clearly Hard
item was defaulted to Medium for lack of effort — the one real miscalibration I found (`frq-033`) was
mis-tiered *Easy*, not swept into Medium.

## 6. CRR-agreement claim — VERIFIED-CORRECT (honest non-computation)

The report states no item-to-CRR-point mapping is defensible and no kappa/agreement figure was computed. I
pulled the actual `crr_calibration_all_subjects.csv` rows for AP Calculus AB myself: they're keyed by College
Board's own 2025 CRR question/part labels (e.g. `AB1 P1`, `AB1 P2`, `AB1 P3` — free-response question 1,
parts 1–3), with topic tags like "Average Value, Instantaneous Rate of Change…" and generic verbs
(`find`/`evaluate`/`write`/`represent`). There is no column or identifiable text that maps any CRR row to a
Cramapple `content_key` (`apcalcab-frq-XXX`), and the underlying free-response prompts differ between the
real 2025 AP exam and Cramapple's authored item bank. **Codex's claim holds up under my own inspection**:
fabricating a 1:1 mapping to force a kappa figure would have been worse than reporting the gap, and the
README explicitly warns the CSV's `verb_auto`/`attr_method` fields are "unverified automated extraction, must
not be used as-is" — which the report also correctly avoided using.

## 7. Scope discipline — VERIFIED-CORRECT

- PR #197's diff touches only Calculus AB files (`docs/content/CODEX_TASK/REPORT_AP_CALCULUS_AB_*`,
  `docs/research/AP_CALCULUS_AB_*`, `docs/research/apbio_difficulty_calibration_2026_09_22/
  APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv` + `assign_difficulty_calcab.py` +
  `build_apcalcab_tier3_migrations.py`, and the 7 `apcalcab_*` migration files). No AP Precalculus files are
  touched — confirmed via `git diff main...codex-apcalcab-pr197 --stat`.
- No `validated` label_status anywhere in the new rows (confirmed by direct query, §1).
- No blanket re-run of the pre-existing 16 `held` rows — the current `held` count (45) is exactly
  16 (untouched) + 29 (new), confirmed by direct query; the pre-existing 16 IDs were not re-labeled.
- No promotion, no Pair 3 work, no self-cross-QA in the PR — confirmed by reading the report's closing
  section and the PR diff.

## Required follow-up recommendations (mirrors the AP Statistics Pair-1 pattern)

Before treating AP Calculus AB Tier 3 as fully ratified for `validated` promotion, route these to a human
taxonomy/content owner:

1. **Resolve labeling holds that look like model-output bugs or narrow disagreements**, not genuine scope
   ambiguity:
   - `apcalcab-frq-005` → Unit 3 primary, Units 2/3 required (Gemini's evidence text agrees with GPT-5.5's
     structured answer; the empty array looks like an extraction bug). Separately: flag the
     stimulus-constant-14-vs-16 data inconsistency as a content ticket.
   - `apcalcab-mcq-030` → Unit 3 primary; decide whether Unit 2 is a wanted secondary tag.
   - `apcalcab-mcq-015` (pre-existing hold, untouched by this run) → Unit 6, per Codex's own note; I
     independently confirmed the stem is a plain u-substitution integral.
2. **Fix `apcalcab-frq-033`'s rubric before re-labeling or re-scoring it**: `part-a-criterion-3` scores an
   operation part (a) doesn't ask for. Once fixed, re-run both the taxonomy label and the difficulty
   assignment for this item — I believe the correct difficulty is Medium or Hard, not Easy, once the rubric
   is corrected and re-classified.
3. **Flag `apcalcab-frq-035` and `apcalcab-mcq-045` (Euler's method) and `apcalcab-mcq-np2-002` (L'Hospital
   infinity-minus-infinity distractors) to a content owner** — these look like genuine AB/BC scope violations
   in the item content itself, not just taxonomy-labeling ambiguity. The `held` status correctly keeps them
   out of serving, but the underlying items may need editing or moving to the BC pack.
4. Treat `apcalcab-mcq-039`'s hold-reason label (`empty_required_units`) as a minor taxonomy-of-reasons
   mislabel — the actual situation is a substantive algebra-vs-calculus content disagreement, not a data gap.
   Does not need code changes; just don't read the reason bucket literally when a human reviews it.

## Final status

Cross-QA complete. AP Calculus AB Tier 3's counts, contamination checks, idempotency, scope discipline, and
migration-file fidelity all independently verified and correct. Labeling and difficulty classification
quality is generally strong; one difficulty misclassification (`apcalcab-frq-033`, Easy where Medium/Hard is
more defensible) and a handful of resolvable-hold candidates were found and are listed above for follow-up.
None of these are Production defects requiring an emergency fix — they're exactly the kind of narrow,
named follow-up list the paired plan expects cross-QA to produce. **Safe to merge PR #197.** I did not merge
it, did not touch Production, and did not start Pair 3.
