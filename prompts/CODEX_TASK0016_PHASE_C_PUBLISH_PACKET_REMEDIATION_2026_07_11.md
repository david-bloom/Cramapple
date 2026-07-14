# Codex Remediation — TASK-0016 Phase C Publish-Staging Packet (post-QA, 2026-07-11)

Independent QA (fresh-context, Codex Sol, repository-only verification —
`docs/research/ap_statistics_phase_c_publish_staging_2026_07_11/qa_review.md`
on PR #36) returned **Fail**. Do not run the staged `bulk_import` call. This
prompt covers the three staging blockers that QA found and confirms one item
(the SD error) via independent re-derivation done separately from the QA
pass itself — this is not a single source's claim, it's been checked twice
by two different reviewers who don't share context.

MCQ content is verified clean (15/15 fresh-sampled items matched independent
derivation) — do not touch the MCQ payload. The known publish-blockers
(typed `rubric_type`/`evaluator_strategy` columns, rights/source gate) are
unchanged and remain publish-blockers, not staging blockers — do not treat
them as in scope for this remediation.

## Read first

1. `docs/research/ap_statistics_phase_c_publish_staging_2026_07_11/
   qa_review.md` — the full QA report this remediation responds to. Read it
   in full before touching anything; it has exact file:line references and
   the exact commands used to find each defect.
2. `scripts/build_task0016_phase_c_publish_packet.mjs` — specifically lines
   15-23, which enumerate the nine source artifacts the generator reads.
3. `docs/research/ap_statistics_phase_c_publish_staging_2026_07_11/
   bulk_import_payload.json` — the currently-staged (blocked) payload.

## R1 (blocking) — PR #36 is not reproducible from `main`

QA ran `git worktree add --detach ... HEAD` from a fresh checkout of PR #36
and executed `node scripts/build_task0016_phase_c_publish_packet.mjs`. It
exited `1` with `ENOENT` on
`docs/research/ap_statistics_gold_set_candidate_2026_07_09/
provisional_labels.json` — the first of nine source inputs the generator
depends on, none of which are present in the PR #36 branch. QA also could not
run `docs/research/statistics_phase_b_2026_07_08/validate_keys.py` (absent,
exit `2`), meaning **the claimed 44/44 + 7/7 deterministic-key validation
result was never actually re-verified** in this QA pass — it's an open
question, not a confirmed pass, until this is fixed.

This traces back to the same root cause flagged earlier in this project:
`main` doesn't currently contain the TASK-0016 Phase A/C prerequisite files
(the router, verifiers, and supporting research artifacts) that PR #36
implicitly depends on. PR #36 was built as "clean from main" specifically to
satisfy the original prompt's "PR against main" requirement, but that
requirement is in tension with the generator's actual dependencies — a
branch can't simultaneously be minimal-diff-from-main and self-contained if
main is missing what it needs.

**Do:**
1. Identify the exact nine source artifacts (`build_task0016_phase_c_publish_
   packet.mjs:15-23`) and, for each one, either (a) commit it into this PR's
   branch (the `docs/research/...` artifacts and `validate_keys.py` are
   research/tooling files, not production code — committing them here is
   reasonable and doesn't reintroduce the unmerged Phase A production-code
   diff), or (b) confirm it's already reachable from `main` under a path the
   generator isn't correctly pointed at, if that's actually the case. State
   which of the two applies for each of the nine files — don't silently pick
   one approach without saying why.
2. After the fix, demonstrate the exact reproducibility test QA used: a
   detached worktree from the PR branch, run the generator into a **separate
   temporary directory** (do not overwrite the committed payload), and show
   semantic equality (same 200 items, same field values) between the
   regenerated and committed `bulk_import_payload.json`. Paste the actual
   command and exit code in your evidence, not just a claim it passed.
3. Re-run `python3 docs/research/statistics_phase_b_2026_07_08/
   validate_keys.py` yourself, from this now-self-contained branch, and
   report the actual pass count — this has never been independently
   confirmed for this packet and must be before staging proceeds.
4. Note for awareness, not action in this prompt: this same root cause
   (main missing TASK-0016 prerequisite files) will keep surfacing on future
   PRs until it's addressed directly. That's a separate, larger
   consolidation effort — flag it in your PR description if you want it
   tracked, but do not attempt to merge Phase A production code into main as
   part of this remediation. Scope here is: make this specific packet
   self-contained and reproducible, nothing broader.

## R2 (blocking) — `APSTAT-MOD5-M001` stages the wrong standard deviation

Data: 10, 15, 20, 25, 30. The question asks to calculate the mean and
standard deviation of **"this sample."** Mean = 20 is correct. The staged
canonical answer and rubric text say SD ≈ 7.07
(`bulk_import_payload.json:14800`), which is the **population** standard
deviation (√(250/5)). Because the question explicitly frames this as sample
data, AP Statistics convention requires the **sample** standard deviation
(Bessel's correction, n−1 denominator): √(250/4) = **7.905694…**, i.e.
"approximately 7.91," not 7.07. Relative error of the staged value against
the correct one is 10.57% — independently confirmed by two separate
reviewers (QA and a second pass done after QA), not a single source's
arithmetic.

**Do:**
1. Correct the rubric `learner_facing_text` and any keyed canonical value for
   `APSTAT-MOD5-M001`'s `descriptive_statistics` criterion to state
   approximately 7.91 (sample SD), not 7.07.
2. Check the item's `fully_correct` synthetic response text in the source
   corpus (`docs/research/ap_statistics_gold_set_candidate_2026_07_09/
   provisional_labels.json`) — it currently states "SD = √50 ≈ 7.07," which
   is the same defect one level up the pipeline. Fix it there too, not just
   in the staged payload, so the defect doesn't reappear on the next
   regeneration.
3. Scan the rest of the corpus for the same failure shape: any item that
   frames data as "this sample" / "a sample of..." but keys or states the
   population-SD formula instead of sample-SD. This is exactly the kind of
   single-item-caught, corpus-wide-not-yet-checked defect the MOD6-H007
   confidence-level error turned out to be in an earlier remediation round —
   treat this as a signal to re-scan, not a one-off fix.
4. Report every item you correct as part of this pass, with the wrong value,
   the corrected value, and your independent recomputation — same evidence
   standard as this remediation prompt itself uses.

## R3 (blocking) — eight FRQ items are unanswerable as staged

Each of the following has `stimulus: ""` while its stem and/or rubric
requires a visual or dataset that was never supplied:

| content_key | what's missing | payload line (pre-fix) |
| --- | --- | --- |
| `APSTAT-MOD4-M004` | scatterplot (direction/strength/outliers) | 14378 |
| `APSTAT-MOD5-M003` | histogram (shape/center/spread) | 15036 |
| `APSTAT-MOD6-M004` | sampling-distribution graph | 15821 |
| `APSTAT-MOD6-H004` | residual pattern | 16445 |
| `APSTAT-MOD6-H002-INV` | raw data, regression, and residual plot | 17457 |
| `APSTAT-MOD8-M003` | regression line and new x-value | 19873 |
| `STATS-MOD3-H009` | histogram (shape/center/spread) | 22708 |
| `STATS-MOD4-H014` | diagram (factors and levels) | 23630 |

Line numbers are from the pre-remediation payload and will shift once R1/R2
land — re-locate each item by `content_key`, not by line number, when you do
this pass.

**Do, per item, your choice which:**
- **Option A** — author the actual missing visual/data content (an
  actual scatterplot description precise enough to grade against, an actual
  data table for the histogram, an actual regression equation/dataset) and
  populate `stimulus` for real.
- **Option B** — rewrite the stem and rubric so the item is fully answerable
  from text alone, without inventing a visual that was never designed (e.g.,
  a scatterplot item could become "describe what a scatterplot showing X
  would look like" only if the rubric doesn't then require judging specific
  numeric values that only exist in an actual plot — be careful not to
  create a new version of the same defect).
- Do not delete these 8 items without a replacement — that would drop the
  packet below 100 FRQ items, which is out of scope for this remediation
  (corpus sizing was already settled). If you determine an item truly can't
  be fixed either way, flag it explicitly as a finding for Product Owner
  decision rather than silently removing or leaving it broken.

State which option you chose per item and why.

## Explicitly out of scope for this remediation

- The two publish-blockers (typed routing metadata columns, rights/source
  gate) — already correctly scoped as blocking `publish`, not `bulk_import`
  staging. Do not fix them here; they're tracked separately.
- The MCQ payload — verified clean by QA (15/15), do not touch.
- Merging TASK-0016 Phase A production code into `main` (see R1.4).
- Re-opening the resolved boundary-contract decisions (z*/t*, sign
  convention, MOD8-pattern method-only scoping) — apply them if R2's corpus
  scan surfaces a new case that invokes one, don't re-litigate them.

## Required Evidence on Completion

- The reproducibility demonstration from R1 (exact commands, exit codes,
  confirmation of semantic equality between regenerated and committed
  payload).
- `validate_keys.py`'s actual, independently-run pass count.
- `APSTAT-MOD5-M001`'s correction, in both the payload and the upstream
  corpus source, plus the results of the corpus-wide sample-SD-vs-
  population-SD scan (R2.3) — even if it finds nothing else, say so
  explicitly with what you checked.
- Per-item resolution (Option A or B, and why) for all 8 items in R3.
- Regenerate `bulk_import_payload.json` from the now-fixed sources and
  re-run the full 200-item compatibility/schema checker (the fail-closed one
  QA used) and confirm 200/200 still valid after your changes.

## Next Expected Output

A commit (or PR update to #36) that closes R1-R3, ready for another
independent fresh-context QA pass — not self-certified — before this comes
back to David for a staging decision. Do not claim this is ready to stage in
your own PR description; that determination is QA's and the Product Owner's,
not yours to assert.
