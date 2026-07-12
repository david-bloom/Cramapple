# TASK-0016 Phase C Publish Packet Remediation Log

Date: 2026-07-11  
Scope: R1-R3 response to `qa_review.md`; no staging or publish action executed

This log records implementation evidence only. It does not certify the packet
as stage-ready; that determination remains with independent QA and the Product
Owner.

## R1: Self-Contained Inputs

All nine generator inputs were absent from `main`; none existed there under an
alternate path. Each is now committed to PR #36 at the exact path consumed by
the generator.

| generator input | resolution and provenance |
| --- | --- |
| `ap_statistics_gold_set_candidate_2026_07_09/provisional_labels.json` | Committed from the tracked Phase C source branch, then corrected at source for R2/R3. |
| `ap_statistics_gold_set_candidate_2026_07_09/manifest.json` | Committed unchanged from the tracked Phase C source branch. |
| `ap_statistics_mcq_launch_bank_2026_07_09/ap_statistics_mcq_launch_bank_2026_07_09.json` | Committed byte-for-byte from the local research artifact used to build the original packet. |
| `ap_statistics_phase4_mcq_smoke_batch_2026_07_01/ap_statistics_mcq_smoke_batch.json` | Committed unchanged from the tracked Phase C source branch. |
| `ap_statistics_phase4_mcq_smoke_batch_2026_07_01/ap_statistics_frq_batch_2026_07_01.json` | Committed unchanged from the tracked Phase C source branch. |
| `statistics_phase_b_2026_07_08/statistics_item_keys.json` | Committed from the local research artifact and corrected for R2's sample-SD key. |
| `AP_STATISTICS_VERIFICATION_PROFILE.json` | Committed byte-for-byte from the newer local profile used by the original packet; the older tracked profile was rejected because it regenerated stale `unkeyed` dispositions. |
| `ap_statistics_phase_c_calibration_dryrun_2026_07_11/summary.json` | Committed unchanged from the tracked Phase C source branch. |
| `ap_statistics_gold_set_candidate_2026_07_09/adjudication_queue.csv` | Committed unchanged from the tracked Phase C source branch. |

The required validator is also committed. Its actual local dependencies,
`math_formula_grading_experiment_2026_07_08/ecf_engine.py` and
`formula_checker.py`, are included so the command is runnable rather than
merely present.

Detached reproducibility command:

```text
git worktree add --detach /private/tmp/task0016-remediation-repro HEAD
node scripts/build_task0016_phase_c_publish_packet.mjs
node -e '<semantic deep-equality comparison of both bulk_import_payload.json files>'
```

Result: generator exit `0`; semantic comparison exit `0`; regenerated payload
contains the same 200 items and field values as the committed payload. The
detached worktree is the separate temporary output directory, so the committed
packet was not overwritten by this test.

## R2: Sample Standard Deviation

`APSTAT-MOD5-M001` is corrected throughout the source pipeline:

- Mean: `20`.
- Squared-deviation sum: `250`.
- Wrong population calculation: `sqrt(250/5) = sqrt(50) = 7.071068`.
- Correct sample calculation: `sqrt(250/(5-1)) = sqrt(62.5) = 7.905694`,
  reported as approximately `7.91`.

The upstream rubric, fully-correct synthetic response, deterministic target
note, deterministic formula, part id, and canonical value now agree. The
regenerated payload carries `7.91`; no payload-only patch was used.

Corpus scan covered every FRQ whose question text says `sample` and whose item
contains `standard deviation`/`SD`, plus the MCQ bank for population-versus-
sample denominator language. No additional defect required correction.
`STATS-MOD1-M002` already correctly uses `40/(5-1)` and `sqrt(10) = 3.16`.
Other matches use a supplied sample SD to calculate a standard error or
confidence interval and do not compute SD with an n-versus-n-1 denominator.

Validator command and result:

```text
python3 docs/research/statistics_phase_b_2026_07_08/validate_keys.py
```

Exit `0`: `44/44` keys internally consistent; `7/7` ECF templates behave
correctly; `ALL CHECKS PASS`.

## R3: Eight Answerability Fixes

| content key | option | resolution |
| --- | --- | --- |
| `APSTAT-MOD4-M004` | B | Rewrote the stem to state the upward, roughly linear, moderate-to-strong pattern and absence of outliers; rubric and fully-correct response use only those supplied facts. |
| `APSTAT-MOD5-M003` | A | Added five histogram-bin counts and keyed an approximately symmetric, unimodal distribution centered in the 70s. |
| `APSTAT-MOD6-M004` | B | Replaced the graph reference with a text-only CLT problem specifying a right-skewed population and `n = 50`; rubric now requires shape, center, and `sigma/sqrt(50)`. |
| `APSTAT-MOD6-H004` | A | Added a precise residual-plot description: random around zero, constant spread, no curve or isolated outlier. |
| `APSTAT-MOD6-H002-INV` | B | Replaced the missing raw data/plots with supplied summaries, regression equation, R-squared, observed range, and residual description; asks for interpretation and model assessment rather than impossible reconstruction. |
| `APSTAT-MOD8-M003` | A | Added `y-hat = 10 + 2.5x`, observed range `0-20`, and new `x = 12`; keyed prediction is `40` with an interpolation/uncertainty limitation. |
| `STATS-MOD3-H009` | A | Added six test-score histogram-bin counts and keyed the resulting left-skewed, high-score-concentrated interpretation. |
| `STATS-MOD4-H014` | A | Added all four cells of a 2 x 2 tutoring-frequency by practice-type factorial design; rubric requires factors, levels, main effects, interaction, and random assignment. |

No item was deleted, so the payload remains 100 MCQ + 100 FRQ. MCQ payload
content was unchanged: its pre/post-regeneration semantic SHA-256 remained
`800a3c3edd0727090a4a97f4b048c9af0a1d3a5eb1f1e3f3e8c6ccf8163e9901`.

## Post-Remediation Checks

`node scripts/build_task0016_phase_c_publish_packet.mjs` exited `0`: 200 items,
100 MCQ, 100 FRQ, 18 known collisions renamed, zero duplicate staged keys,
and zero unresolved known collisions.

The same fail-closed checker used by QA was rerun:

```text
node /private/tmp/task0016_qa_checks.mjs \
  docs/research/ap_statistics_phase_c_publish_staging_2026_07_11/bulk_import_payload.json \
  docs/research/statistics_phase_b_2026_07_08/statistics_item_keys.json
```

Exit `0`: 200/200 compatibility projections valid; 100 MCQ; 100 FRQ; module,
difficulty, and form counts unchanged; deterministic dispositions remain 28
keyed, 68 conceptual-only, and 4 excluded/method-only.

The known typed-routing-column and rights/source conditions remain untouched
publish blockers. The MCQ source and payload were not edited. No Supabase or
Production write was attempted.

---

## R4: Independent Re-QA Findings (2026-07-12) — New Answerability Blockers and Difficulty Bug

Date: 2026-07-12
Scope: response to an independent, isolated-worktree re-QA of this packet
(see `docs/activity_log/ACTIVITY_LOG.md`, "Phase C Publish Packet
Independent Re-QA" entry). That re-QA confirmed R1-R3 above genuinely hold,
but found the same answerability defect class in 3 more FRQ items the
original 15-item-sample QA never sampled, plus a corpus-wide Module 8
difficulty-label bug. This section documents the fix for both, plus a
committed replacement for the fail-closed checker script, which — as the
re-QA discovered — was never actually committed to this repository despite
both `qa_review.md` and R1-R3 above citing its output.

### R4a: Three More Unanswerable FRQ Items

Same defect as the original 8 (R3): the item's deterministic answer key or
rubric requires numeric data that was never shown to the student.

| content key | issue | resolution |
| --- | --- | --- |
| `APSTAT-MOD7-M001` | Answer key requires `prefer=80, total=200` for a marginal-probability calculation; stimulus was empty. | Added stimulus: "Of 200 people surveyed, 80 indicated they prefer the new product." |
| `APSTAT-MOD7-M004` | Answer key requires `p1=0.3, p2=0.7` for a tree-diagram path probability; stimulus was empty. | Added stimulus stating both stage probabilities directly. |
| `APSTAT-MOD7-H002-INV` | Part (a) asks the student to construct a full contingency table, but only the low- and high-anxiety group rates were given — no group sizes, and no medium-anxiety rate at all. Also had an unrelated bug: `module` field said 6, content_key says MOD7. | Added stimulus with all three group sizes (200/200/100 of 500) and all three rates (80%/60%/40%); rewrote all 4 response texts (`fully_correct` through `subtly_wrong`) to use a self-consistent table (independently computed: χ² ≈ 48.61, df=2, p<0.0001); fixed `module` to 7. |

Independently recomputed the chi-square statistic for the new
`APSTAT-MOD7-H002-INV` table by hand before writing it into the
`fully_correct` response text — not just asserted.

### R4b: Module 8 Difficulty-Label Bug

All 10 Module 8 FRQ items were tagged `difficulty: "very_hard"` regardless
of their key-suffix letter, which encodes difficulty everywhere else in the
100-item corpus (confirmed corpus-wide: E→easy 15/15 consistent, VH→very_hard
6/6 consistent; only Module 8's M-suffix and H-suffix items deviated).
Fixed 9 items: `APSTAT-MOD8-M001` through `-M005` → `medium`;
`APSTAT-MOD8-H001` through `-H004` → `hard`. `APSTAT-MOD8-VH001` was already
correct and untouched.

### R4c: Committed the Fail-Closed Checker

`task0016_qa_checks.mjs`, cited by both `qa_review.md` and R1-R3 above as
returning a clean pass, was never committed anywhere in this repository — it
only ever existed at a `/private/tmp/...` path on the original QA author's
and remediator's own machines, confirmed by the independent re-QA (grepped
the full repo and all `codex/task0016-phase-c-*` branches; no match).
Nobody without that specific machine could actually re-run the tool both
documents cite.

Committed a fresh replacement at `scripts/task0016_phase_c_qa_checks.mjs`.
It is not a recovery of the original — it's a new implementation covering
the same structural ground (item/MCQ/FRQ counts, duplicate keys, ECF-keyed
disposition count) plus two checks neither the original checker nor the
15-item-sample QA methodology covered: a full-corpus (not sampled) scan for
FRQ items whose deterministic answer key references data never shown to the
student, and a full-corpus difficulty-label consistency check against the
corpus's own key-suffix convention. The first pass of this new checker
produced false positives of its own (flagged standard AP Statistics
constants like the z=1.96 95%-CI critical value, and missed percentage-form
givens like "35%" vs. decimal `0.35`) — both fixed in the committed version;
see the script's own comments for the specific corpus evidence that
motivated each fix. The visual/tabular-keyword scan (Heuristic A) is
deliberately a WARNING, not a fail: verified by hand that it produces real
false positives on this corpus (self-contained or purely conceptual items
that happen to mention "table"/"plot"/"graph"), so it surfaces human-read
candidates rather than asserting a verdict a regex can't actually make.

**Post-fix checker run** (`node scripts/task0016_phase_c_qa_checks.mjs
docs/research/ap_statistics_phase_c_publish_staging_2026_07_11/bulk_import_payload.json
docs/research/statistics_phase_b_2026_07_08/statistics_item_keys.json`):
exit `0`, `PASS`, 200 items / 100 MCQ / 100 FRQ / 0 duplicate keys / 28
deterministically-keyed FRQs (matches R1-R3's figure), 7 human-read
candidates.

**The 7 human-read candidates, resolved by hand:**

| content key | disposition |
| --- | --- |
| `APSTAT-MOD3-E002` | False positive. Purely conceptual ("what shape WOULD you expect..."), no missing data. |
| `APSTAT-MOD4-M004` | False positive. Already self-contained from the original R3 fix — direction/form/strength are all stated directly in the stem text. |
| `APSTAT-MOD5-M002` | False positive. Five-number summary is given directly in the stem; fully answerable. |
| `APSTAT-MOD8-H002` | False positive. Purely conceptual (curved residual pattern is the given fact; no extra data needed). |
| `APSTAT-MOD8-H003` | False positive. Purely conceptual (outliers stated as given; no extra data needed). |
| `STATS-MOD1-M004` | False positive. Raw data list is given directly in the stem. |
| `APSTAT-MOD8-M001` | **Real, known, unresolved.** Same defect class, previously flagged as the "softer" issue in the original re-QA. Direction is answerable ("appears linear" → positive), but the rubric also requires assessing "strength," which the stem's "appears linear" alone cannot support — no scatter-tightness description given. Left unfixed: out of the specific 3-item scope of this remediation round; tracked here so it isn't lost. |

### Post-R4 Checks

Ran `python3 docs/research/statistics_phase_b_2026_07_08/validate_keys.py`
after all edits: exit `0`, `44/44 keys internally consistent`,
`7/7 ECF templates behave correctly`, `ALL CHECKS PASS` — confirms the R4a
content edits (stem/stimulus text only) did not disturb the deterministic
ECF answer keys underneath them.

Regenerated the packet with `node
scripts/build_task0016_phase_c_publish_packet.mjs`: exit `0`, same 200/100/
100/18/0/0 structural counts as before R4.

### Still Open

- `APSTAT-MOD8-M001`'s strength-assessment gap (see table above).
- No independent re-QA of R4 itself has run yet — this remediation, like
  R1-R3 before it, is self-reported until someone else verifies it.
- Rights/source and typed-routing-column conditions remain untouched
  publish blockers, as in R1-R3.
- No Supabase or Production write was attempted.
