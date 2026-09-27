# Claude QA Remediation: AP Precalculus Tier 3 (2026-09-26)

Follow-up to Codex's independent cross-QA of PR #198 (`claude/apprecalc-tier3-labels-difficulty-2026-09-25`),
which found the Precalculus difficulty classifier undocumented/uncommitted and flagged a likely scoring
defect (multiple FRQs recorded Hard on every criterion from a single hard cue). This document records the
root cause, the fix, the corrected difficulty distribution, and the 13 serving-label hold resolutions
applied in the same session. Nothing here touches AP Calculus AB, starts Pair 3, or promotes anything to
`validated`.

## 1. Branch reconciliation

`claude/apprecalc-tier3-labels-difficulty-2026-09-25` was 31 commits behind `main` (diverged, non-mergeable
per Codex). Merged `origin/main` into the branch with a plain merge commit (no rebase, no force-push
needed). `docs/product/TIER3_PAIR2_STATUS_2026_09_25.md` changed on both sides -- main added the AP
Calculus AB "DONE, cross-QA'd, follow-up fixes applied" section; this branch had the original (pre-QA)
AP Precalculus section. Git's three-way merge resolved this cleanly (the two sections are non-overlapping),
and the Precalculus section is updated by this same commit to reflect the corrected, final state (see the
bottom of this document and the status doc's own diff).

## 2. The classifier bug

**Root cause, confirmed by reading Production content directly.** No AP Precalculus difficulty classifier
was ever committed to the repository -- `docs/research/apbio_difficulty_calibration_2026_09_22/` had a CSV
(`APPRECALC_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv`) but no `assign_difficulty_apprecalc.py`, unlike every
other subject in that directory. The 117 difficulty assignments loaded to Production on 2026-09-25 were
therefore not reproducible from repository state, exactly as Codex reported.

Reading the actual flagged items' stems and rubric criteria showed why the (missing) classifier's output
looked wrong: several multi-part FRQs were recorded **Hard on every criterion in every part**, even though
only one part of the item contained a hard-tier cue verb ("justify", "explain ... limitation"). For example:

- `apprecalc-frq-013`: "Part A: Factor P completely and state its zeros. **Part B: Solve P(x)>=0 and justify
  the solution with a sign chart.** Part C: State the y-intercept and end behavior." -- only Part B says
  "justify"; Parts A and C are mechanical (factor/state).
- `apprecalc-frq-017`: only part (c) says "justify."
- `apprecalc-frq-005`: "justify" in Part A, "explain one limitation" in Part C, but Part B ("Find and
  interpret the maximum profit") has neither.
- `apprecalc-frq-015`: only part (c) says "Verify" -- checked its `frq_criteria` rows directly and found
  **6 distinct criteria, no duplication** (`part-a-criterion-1/2`, `part-b-criterion-1/2`,
  `part-c-criterion-1/2`); the "3 duplicate rows per criterion_key" concern raised in the task brief does
  not reproduce against current Production data -- it does not exist in the live schema.

This is the signature of a classifier that concatenated an entire item's stem + all criteria into one blob
and ran a hard-cue regex once per item (any hard cue anywhere -> whole item Hard), instead of the documented
Method A (`docs/research/apbio_difficulty_calibration_2026_09_22/README.md` Sec 3): classify **each rubric
criterion's own text**, then take the **modal tier across that item's criteria**, ties broken upward. Since
the original script was never committed, this is inferred from its output rather than read directly from
its source -- but it is the only mechanism consistent with every one of the four named examples.

**A second, real wrinkle found while building the replacement:** this corpus's `frq_criteria.learner_facing_text`
rows are almost always *answer-content* statements ("The zeros are -1,1,4."), not task-verb sentences -- the
verb that actually determines difficulty lives in the stem's per-part instruction ("Part A: Factor P
completely...", "(c) ... and justify from the zeros and a sign analysis"). A literal criterion-only
classifier (matching cues against `learner_facing_text` alone) would starve on verb-free answer-content
sentences and default most FRQs to `calibrated_judgement`. The corrected classifier
(`docs/research/apbio_difficulty_calibration_2026_09_22/assign_difficulty_apprecalc.py`) instead:

1. Splits each FRQ's stem into per-part instruction text (`Part A:` / `(a)` markers).
2. Maps each `frq_criteria` row to its owning part via `criterion_key` (`part-a-criterion-1` -> part `a`).
3. Classifies **that part's own instruction text** (never the whole item) against Easy/Medium/Hard cues.
4. Takes the **modal tier across the item's criteria**, ties broken upward -- still a genuinely per-criterion
   computation, just sourcing each criterion's cue from the part instruction it was written to grade.
5. Falls back to the criterion's own `learner_facing_text` only for the `apprecalc-frq-u12-*` items, whose
   stems are a generic template with no per-part breakdown (those criteria do carry verb-like phrasing:
   "Correctly applies...", "Correctly rejects... as extraneous").

MCQ is classified from the stem's own cue (single judgement, no per-criterion aggregation needed).

Cue lists extend the generic Method A verb tiers (README Sec 3) with Precalculus-specific phrasing this
corpus actually uses ("find", "solve", "give ... key points", "average rate of change",
"construct/write a model", "factor"), per-part/per-criterion only, never blob-wide. One regex bug was caught
and fixed during testing: `\bstate\w*` also matched "state**ment**" ("which statement is true"), spuriously
classifying `apprecalc-mcq-032` Easy; narrowed to `\bstate[sd]?\b`.

### Before/after on the four named examples

| Item | Before (uncommitted classifier) | After (corrected) | Why |
|---|---|---|---|
| `apprecalc-frq-013` | Hard | **Hard** (unchanged) | Genuinely mixed now: Part A Medium (factor), Part B Hard (justify), Part C Easy (state) -> tied 2/2/2 across criteria, upward tie-break still lands Hard. The *label* didn't change, but it is now honestly computed instead of a blob-bug artifact. |
| `apprecalc-frq-015` | Hard | **Medium** | Part A Medium (factor), Part B Easy (list), Part C Medium (verify) -> modal Medium (4 of 6 criteria). |
| `apprecalc-frq-017` | Hard | **Medium** | Parts (a)/(b) Medium (average rate of change / approximate), part (c) Hard (justify) -> modal Medium (4 of 6). |
| `apprecalc-frq-005` | Hard | **Hard** (unchanged) | Genuinely Hard now: Part A Hard (justify) x2, Part C Hard (extrapolation limitation) x2, Part B Medium x2 -> modal Hard (4 of 6), a real majority, not a false unanimous one. |

Ten more items share the same multi-part-with-one-hard-cue shape and also dropped Hard -> Medium:
`apprecalc-frq-007`, `-014`, `-020`, `-022`, `-023`, `-024`, `-025`, `-026`, `-np2-002`, `-np2-008`.

## 3. Corrected difficulty distribution

Re-derived the servable set independently from Production (item **and** latest content_item_version both
`published`, joined through `exam_pack_versions`/`exam_packs.exam_code = 'ap_precalculus'` with
`retired_at is null`): **117 items**, matching the number already loaded (64 FRQ + 53 MCQ). Ran the
corrected classifier against all 117 and overwrote
`docs/research/apbio_difficulty_calibration_2026_09_22/APPRECALC_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv`.

**Before (loaded 2026-09-25):** Easy 1, Medium 96, Hard 20.
**After (corrected):** Easy 1, Medium 109, Hard 7.

**Judgement-basis count:** was 45 (`calibrated_judgement`), now **33** -- it shrank, as anticipated, because
the per-part/per-criterion cues catch verbs the blob-level version's item-wide hard-cue scan incidentally
missed on non-Hard items.

**30 of 117 rows changed** (difficulty and/or basis); **16 changed `difficulty`**:

| content_key | before -> after |
|---|---|
| apprecalc-frq-007 | Hard -> Medium |
| apprecalc-frq-014 | Hard -> Medium |
| apprecalc-frq-015 | Hard -> Medium |
| apprecalc-frq-017 | Hard -> Medium |
| apprecalc-frq-020 | Hard -> Medium |
| apprecalc-frq-022 | Hard -> Medium |
| apprecalc-frq-023 | Hard -> Medium |
| apprecalc-frq-024 | Hard -> Medium |
| apprecalc-frq-025 | Hard -> Medium |
| apprecalc-frq-026 | Hard -> Medium |
| apprecalc-frq-np2-002 | Hard -> Medium |
| apprecalc-frq-np2-008 | Hard -> Medium |
| apprecalc-frq-u12-004 | Medium -> Easy |
| apprecalc-frq-u12-016 | Hard -> Medium |
| apprecalc-mcq-032 | Medium -> Easy (then reverted -- see regex-bug note; final state Medium via judgement) |
| apprecalc-mcq-np2-009 | Easy -> Medium |

(`apprecalc-mcq-032`'s Easy reclassification was the `\bstate\w*`/"statement" regex bug caught during testing
and fixed before the CSV/migration were finalized -- its final corrected value is Medium, unchanged from
before. Listed here for transparency since it appeared mid-process.)

An additional 14 rows kept the same `difficulty` but changed `basis` (mostly `calibrated_judgement` ->
`calibrated_task_verb` for the `apprecalc-frq-u12-*` items, whose criteria do carry usable verb cues once
matched individually rather than not at all).

Applied via `supabase/migrations/20260926140000_apprecalc_difficulty_correction_batch_01.sql` (30 rows,
single batch since the guideline's 20-30 range comfortably covers the full changeset). Verified: 30 rows
carry the new `proposal_run = 'apprecalc_tier3_2026_09_25_qa_correction_2026_09_26'`; all 30 join through
`exam_pack_versions`/`exam_packs.exam_code = 'ap_precalculus'` (zero contamination); post-migration
Production distribution (Easy 1 / Medium 109 / Hard 7 across all 117 live items) matches the corrected CSV
exactly.

## 4. Serving-label hold resolutions (13 of 13 `model_unit_disagreement` holds)

Independently queried all currently-`held` AP Precalculus rows with `source_payload->>'reason' =
'model_unit_disagreement'` (not just Codex's sampled six) and found exactly 13, matching the counts given in
the task brief. Resolved all 13; zero `model_unit_disagreement` holds remain for AP Precalculus afterward
(confirmed by re-querying).

**11 items -- "resolve broader" rule** (both models agree on `primary_unit`; the only disagreement is
whether Unit 1 belongs as a secondary `required_unit` for routine polynomial/rational algebra used as a
mechanical step toward the item's real content in a higher unit). Spot-checked 4 of the 11 against actual
stem/criteria text before applying (not just pattern-matched):

- `apprecalc-frq-014`: Gemini's Unit-1 tag is for recognizing the log-transformed equation is *linear in x*
  before applying "nonzero coefficient implies one solution" -- genuine mechanical Unit-1 step. Confirmed.
- `apprecalc-frq-020`: part (b) requires solving a 2x2 linear system for constants a, b -- routine Unit-1
  algebra. Confirmed.
- `apprecalc-frq-u12-002`: its own `frq_criteria` (part-c-criterion-01) literally says "forms the equation
  x(x-4) = 21, solving to get x = 7 or x = -3" -- a quadratic solve, Unit-1 mechanics, inside an otherwise
  Unit-2 (log) item. Confirmed.
- `apprecalc-frq-u12-016`: its own `frq_criteria` (part-a-criterion-02) says "Correctly concludes a linear
  model is NOT appropriate because the first differences are not constant" -- checking/ruling-out a linear
  (Unit-1) model as a mechanical step before the Unit-2 exponential-model conclusion. Confirmed.

| content_key | GPT-5.5 | Gemini | Resolved to |
|---|---|---|---|
| apprecalc-frq-014 | [2] | [1,2] | [1,2], primary 2 |
| apprecalc-frq-020 | [2] | [1,2] | [1,2], primary 2 |
| apprecalc-frq-np2-007 | [2,3] | [1,2,3] | [1,2,3], primary 2 |
| apprecalc-frq-u12-002 | [2] | [1,2] | [1,2], primary 2 |
| apprecalc-frq-u12-007 | [2] | [1,2] | [1,2], primary 2 |
| apprecalc-frq-u12-009 | [2] | [1,2] | [1,2], primary 2 |
| apprecalc-frq-u12-014 | [2] | [1,2] | [1,2], primary 2 |
| apprecalc-frq-u12-016 | [2] | [1,2] | [1,2], primary 2 |
| apprecalc-frq-u12-017 | [2] | [1,2] | [1,2], primary 2 |
| apprecalc-mcq-014 | [2] | [1,2] | [1,2], primary 2 |
| apprecalc-frq-np2-003 | [3] | [1,3] | [1,3], primary 3 |

**1 item -- same pattern, reversed direction** (`apprecalc-frq-030`): GPT-5.5 [1,3] / Gemini [3], both
primary 3. Spot-checked the item's stem (part c: "state whether d is increasing or decreasing and whether
its rate of change is increasing or decreasing") -- the same kind of general rate-of-change/graph-behavior
reasoning Gemini itself tagged Unit 1 in the other 10 items. Resolved broader, to **[1,3]**, for consistency.

**1 item -- individual resolution, not "resolve broader"** (`apprecalc-mcq-027`): GPT-5.5 `required_units=
[1,2,3]`/`primary_unit=1`; Gemini `required_units=[1]`/`primary_unit=1`. Read the actual stem: "A table has
constant second differences and nonconstant first differences for equally spaced inputs. Which model type
is most appropriate?" (options Linear/Exponential/Quadratic/Sinusoidal) -- pure Unit 1 finite-differences
recognition; it does not touch exponential (Unit 2) or trig (Unit 3) content at all. GPT-5.5's broader answer
is a genuine model error here, not a defensible secondary-unit read. Resolved individually to **Gemini's
narrower, correct answer: [1], primary 1**.

**Left untouched:** `apprecalc-frq-np2-008` (reason `rubric_preflight_failure`) -- Codex confirmed this is a
real, correctly-held rubric defect, not something to fix in this pass. Also untouched: `apprecalc-frq-006`,
`-024`, `-027`, `-029`, `-031`, `-np2-001`, `-u12-004` -- pre-existing holds with reasons `other`,
`empty_required_units`, and `rubric_preflight_failure`, none of them `model_unit_disagreement` and none in
scope for this remediation.

Applied via `supabase/migrations/20260926140100_apprecalc_unit_disagreement_hold_resolutions.sql`: one
`begin`/`commit` transaction, 13 individual insert-new-current-row-and-supersede-the-old-held-row operations
(the same pattern as `20260926130000_apcalcab_frq005_hold_resolution.sql` /
`20260926130100_apcalcab_mcq030_hold_resolution.sql`), `label_status = 'provisional_model'`,
`source = 'claude_cross_qa_hold_resolution_2026_09_26'`. Verified after applying: all 13 new current rows
belong to live AP Precalculus items (zero contamination, confirmed via the same
`exam_pack_versions`/`exam_packs.exam_code` join), zero `model_unit_disagreement` holds remain, and no row
was set to `validated`.

## 4b. Follow-up: metadata reconciliation (Codex's second cross-QA pass)

Codex ran a second independent cross-QA pass against the pushed remediation (head `6fa0c896`) and confirmed
all of the above -- reconciled branch, mergeable, corrected classifier committed and reproducible, correct
1/109/7 difficulty distribution, 84/33 basis split, 13 holds resolved, 0 contamination, 0 `validated` writes.
It found one residual issue: the 2026-09-26 difficulty correction migration
(`20260926140000_apprecalc_difficulty_correction_batch_01.sql`) only updated the 30 rows whose difficulty
**band** actually changed. The other 87 rows kept the correct band but still carried stale `rationale`/
`basis`/`proposal_run` metadata computed by the pre-fix, item-level-blob classifier -- for example
`apprecalc-frq-005` and `apprecalc-frq-013` still showed rationale text like `modal of 6 criteria:
{'Hard': 6}` even though their band was already correct by coincidence. Since `rationale` and `proposal_run`
are durable audit/provenance fields, not just display text, this needed a fix before the difficulty pass
could be called fully closed.

Applied `supabase/migrations/20260926150000_apprecalc_difficulty_metadata_reconcile.sql`: an idempotent,
band-preserving update (its `where` clause only touches rows whose current band already equals the corrected
CSV's band for that content_key, as a guard against this migration accidentally becoming a second band-change
path) that rewrites `basis`/`confidence`/`rationale` to the corrected classifier's actual output and retags
`proposal_run` to `apprecalc_tier3_2026_09_25_metadata_reconcile_2026_09_26`. Verified post-apply: all 87
previously-stale rows now carry the corrected metadata (0 rows remain on the original `proposal_run`), and
the two named examples now read exactly as the corrected CSV specifies (`apprecalc-frq-005`: Hard, "Easy=0,
Medium=2, Hard=4"; `apprecalc-frq-013`: Hard, "Easy=2, Medium=2, Hard=2" -- an upward-tie-break Hard, not the
old bug's false unanimous Hard).

## 5. What was NOT touched

- AP Calculus AB (Pair 2's other half) -- untouched.
- Pair 3 (AP Physics 1/2, AP Physics C) -- not started.
- `apprecalc-frq-np2-008`'s rubric defect -- left as a correctly-held, real content issue.
- No `content_taxonomy_labels` or `content_item_difficulty` row was set to `label_status = 'validated'`.

## 6. Branch state

Merged `origin/main` into `claude/apprecalc-tier3-labels-difficulty-2026-09-25` via a plain merge commit
(no force-push). This document, the corrected CSV, the new classifier script, the two new migrations, and
the updated `docs/product/TIER3_PAIR2_STATUS_2026_09_25.md` are committed on top of that merge and pushed to
the same PR #198 branch. The PR itself was not merged and no content was promoted to `validated`.
