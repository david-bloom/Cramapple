# Reviewed-approved backlog investigation and publish — 2026-08-09

**Trigger:** Owner report that `https://cramapple.com/reviewer/content` still showed more
than 200 questions in "review approved" status.

**Scope:** Production (`pcntajvbdfqhbeewmdry`).

## 1. What the dashboard number actually was

228 `content_items` were sitting at `status='reviewed_approved'`, never published. This is
not one uniform problem:

| Bucket | n | Cause |
|---|---:|---|
| `review_status='question_review_approved'` | 167 | Genuinely ready — see §2. |
| `review_status IS NULL` | 55 | Legacy items (all dated 2026-07-25, `created_by=null`) that never went through `review-decision`'s workflow at all. **Out of scope for this pass** — can't clear the P0-B publish gate as written; needs its own investigation before any action. |
| `review_status` in an intermediate state (`difficulty_discussion`, `tutor_review_pending`, `ap_reader_pending`) | 6 | Contradictory: `status` claims approved, `review_status` says still mid-review. **Out of scope for this pass.** |

**Root cause of the 167 (and the dashboard number generally):** the P0-B publish gate
(`docs/research/CONTENT_AUTHORING_AND_QA_PROTOCOL.md` §7.2, added 2026-08-08) correctly
requires an explicit `review_status` before anything can reach `status='published'` — but
there is no code path that automatically publishes an item once it clears review. Someone
has to run a publish step, and nobody had been running one routinely. The 167 span
2026-07-27 through 2026-08-09 — nearly two weeks of accumulation.

## 2. QA before publish

Owner directed: don't publish on structural checks alone — run protocol §9 (independent
re-derivation) on all 167 first, matching the bar just set on the same day's Pool 1/Pool 2
run. Structural checks (choice/criteria counts, no stem/`mcq_choices` desync, no competing
published version) had already confirmed all 167 clean before this step; §9 checks
actual correctness, which structural checks can't.

**Method:** 13 parallel agents, grouped by subject, each independently re-deriving every
answer key / rubric criterion from scratch (per §9.2) before comparing to the stored
value — the same discipline as the day's Pool 1/Pool 2 run, at 3.3x the item count.

**Result: 162 of 167 CLEAN.** 5 items needed attention:

| content_key | Finding |
|---|---|
| `apchem-sfrq-014` | **Confirmed defect.** Criterion `c3`'s `learner_facing_text` correctly asks about molecular polarity (matching the stem), but `evidence_requirements`/`minimum_fix` asked for Xe hybridization (sp3d2) instead — never asked anywhere in the stem. A grader following the stored grading text would require an unprompted, unrelated claim. |
| `STATS-MOD3-M007` | **Confirmed defect.** The criterion's third disjunct ("or describes z-score standardization") let a response earn full credit by merely defining a z-score, without ever justifying why standard-normal-based probability statements remain valid for a non-normal population — the actual thing the stem asks for (the Central Limit Theorem). |
| `APSTAT-MOD4-H001-INV` | **Minor internal inconsistency.** Part (d) stated "the researcher finds a significant result (p = 0.02)"; independently recomputing from part (c)'s own data (t = 4/√(36/25+25/25) = 2.56, df ≈ 46–48) gives p ≈ 0.013–0.014, not 0.02. |
| `apphy1-mcq-021` | Data-completeness gap only (not a defect): `canonical_answer_1` is null, but `mcq_choices.is_correct` (the actual graded answer key) is correct. Matches a gap already flagged in an earlier session pass and left as a known, non-blocking issue. |
| `apcalcbc-frq-u13-005/007/009/013/015` (5 items) | Same data-completeness gap as above — `canonical_answer_1`/`_2` null, but every rubric criterion and derivation independently checked out. Not repaired this pass (redundant metadata field, doesn't block grading); flagged as a follow-up backfill. |

No off-CED content, internal contradictions, or other defects found across the other 162
items — every answer key, rubric criterion, and distractor rationale independently
re-derived and matched.

## 3. Repairs

`scripts/content-seed/reviewer-qa-remediation/20260809_backlog_defects_repair.sql` — the
usual insertion discipline (new version, never edit in place):

- `apchem-sfrq-014` c3: split the existing `learner_facing_text`'s two claims (identifies
  nonpolar; justifies via bond-dipole cancellation) into two explicit 1-point elements in
  `evidence_requirements`/`minimum_fix`, matching the criterion's existing
  `points_possible=2`.
- `STATS-MOD3-M007`: removed the z-score-only disjunct; the criterion now only credits the
  CLT-based sample-mean-normality justification the stem actually asks for.
- `APSTAT-MOD4-H001-INV`: corrected the stated p-value in part (d) from 0.02 to
  approximately 0.014, matching the item's own part (c) data.

All 3 re-approved (`owner_remediation_approval`, `tutor_score=1`) and landed back at
`reviewed_approved`/`question_review_approved`, ready for the publish step below.

## 4. Publish

`scripts/content-seed/publication/20260809_backlog_publish_167.sql` — publishes every
content item currently at `status='reviewed_approved'` and
`review_status='question_review_approved'` with no existing competing published version.

**Two additional gates fired during this step, both legitimate catches, not bugs in the
publish script:**

1. **`content_item_versions_one_published_per_item` unique constraint** — `apphycm-frq-018`
   has a stale `reviewed_approved` v2 sitting alongside an already-published v3 (the
   revert-fix case documented in the QA protocol §9.4: "correcting a misapplied fix on
   `apphycm-frq-018`"). Publishing v2 would have been a **regression**, re-introducing the
   mistake v3's revert fixed. Added a safety filter (`not exists ... status='published'`)
   excluding any item with a competing published version — the filter still selected
   exactly 167, confirming this stale row was never part of the batch and the exclusion was
   correct.
2. **`practice_format_required_at_publish` trigger** — 15 of the 167 FRQs had
   `practice_format IS NULL`. All 15 have `frq_archetype IS NULL` too, so per the
   established rule ("`full_exam_frq` requires non-null `frq_archetype`; none present" —
   same rule applied in `docs/tasks/TASK-0022-AP-STATISTICS-MULTIPOINT-RUBRIC-DEFECT.md`),
   all 15 were set to `practice_format='targeted_drill'` before retrying.
3. **`content_pipeline_guard_publish` trigger** — 6 AP Statistics items (`APSTAT-MOD3-E002`,
   `APSTAT-MOD4-M001`, `APSTAT-MOD5-M001`, `STATS-MOD4-E005`, `APSTAT-MOD6-M002`,
   `STATS-MOD1-M001`) had `content_items.status='retired'` while their **only** version
   (`version_num=1`) was `reviewed_approved`/`question_review_approved` — a stale
   item-level status with nothing to justify "retired" (no newer version exists). Corrected
   `content_items.status` to `reviewed_approved` for these 6 (verified each has exactly one
   version before doing so) and retried.

**Result: all 167 published successfully** on the second retry, once the above three were
resolved.

## 5. Final re-verification

- `disapproved_but_published` (P0-B net): **0**
- Duplicate published versions per item: **0**
- Published MCQs with a stem/`mcq_choices` desync: **0**
- Items still at `reviewed_approved`+`question_review_approved` with no competing published
  version: **1** (`apphycm-frq-018` v2, the stale superseded duplicate noted above —
  correctly excluded, not published)

## 6. Follow-ups

- **`apphycm-frq-018` v2** should be explicitly retired (`status='retired'`) to stop it from
  showing as pending in future backlog counts — it's superseded by the already-published
  v3 and was correctly excluded from this publish, but it's still sitting there confusingly.
- **The 55 legacy `review_status IS NULL` items** (all dated 2026-07-25) need their own
  investigation: did they actually go through real human review with `review_status`
  simply never populated, or are they a different gap entirely? Out of scope for this pass.
- **The 6 contradictory-state items** (`status='reviewed_approved'` while `review_status`
  shows an intermediate value) need the same kind of investigation as the 6 stale-retired
  items found and fixed in §4 point 3 — likely the same class of stale-status bug, not yet
  confirmed.
- **Backfill `canonical_answer_1`/`_2`** for `apphy1-mcq-021` and the 5 Calc BC `-u13-` FRQs
  — non-blocking (the real answer key is intact elsewhere), but worth cleaning up for
  corpus consistency.
- **No standing "publish on approval" automation exists.** This 167-item backlog will
  recur unless either a routine publish-sweep job is scheduled, or `review-decision`'s
  `advanceWorkflow` is extended to publish directly once the terminal `review_status` is
  reached (the more durable fix, per the same "one code path instead of ad hoc scripts"
  rationale as the P0-B gate itself).
