# Codex QA Prompt — TASK-0016 Phase C: Publish-Staging Packet Pre-Approval Review

Use per `docs/team_charter/AGENT_OPERATING_MODEL.md`'s QA Agent role: an
independent, skeptical review, not a relabeled continuation of the implementer.
Treat yourself as having no prior context on this work; verify claims from
source, not from the PR description, the packet's own README, or this
prompt's summary of it. If a claim in this prompt turns out to be wrong when
you check it against source, say so — do not defer to it.

**Revision note:** this is v2 of this prompt, rewritten after a pre-QA
clarification round with the reviewing model. Answers to the process
questions raised are folded in below (report location, sampling method,
Production-access boundary) — no need to re-ask them.

## Task

Review PR #36 ("TASK-0016 Phase C AP Statistics approval packet") — a clean
branch from `main` containing five files:

- `docs/research/ap_statistics_phase_c_publish_staging_2026_07_11/README.md`
- `docs/research/ap_statistics_phase_c_publish_staging_2026_07_11/
  bulk_import_payload.json`
- `docs/research/ap_statistics_phase_c_publish_staging_2026_07_11/
  verification_log.md`
- `docs/research/ap_statistics_phase_c_publish_staging_2026_07_11/
  approval_packet.md`
- `scripts/build_task0016_phase_c_publish_packet.mjs`

This packet stages 200 AP Statistics items (100 MCQ + 100 FRQ) as `draft`
content via the real `admin-content` edge function's `operation: "bulk_import"`
path.

**Approval status:** David (Product Owner) has given **provisional owner
approval, contingent on this independent QA pass** — not final approval. The
actual staging action (calling `bulk_import`) has not been executed and will
not be, pending this review. Treat missed defects here as landing in
Production, not as caught later — this is the last independent check before
that happens.

## Process boundaries (answers to your pre-QA questions)

- **Report location:** commit
  `docs/research/ap_statistics_phase_c_publish_staging_2026_07_11/
  qa_review.md` as a repo artifact, matching the existing packet files.
  Additionally leave a **non-approving summary comment** on PR #36 linking to
  it. **Do not submit an "Approve" GitHub review on PR #36** — comment only.
  Your authority is to propose a verdict, not to approve, merge, or execute
  anything (see Authority Boundaries below).
- **Sampling method:** deterministic, not hash/seed-based — see §3 below for
  the exact method and the exclusion list.
- **Production access:** repository-only by default. You do not have live
  Supabase access in this review; do not attempt to fabricate or guess
  Production state. If a claim genuinely requires live-DB confirmation and
  can't be resolved from the repo, name the specific claim and mark it "not
  independently verified in this pass — requires live DB access" rather than
  skipping it silently or trusting the packet's stated number.

## Background

- Full context: `docs/tasks/TASK-0016-GRADING-ENGINE-ROLLOUT.md`,
  `prompts/CODEX_TASK0016_PHASE_C_CONTENT_PUBLISH_AND_APPROVAL_PACKET_2026_07_11.md`
  (the prompt that produced this packet).
- There is an earlier, superseded stacked PR (#35, base
  `codex/task0016-phase-c-calibration-dryrun`) — do not review that one; #36
  is the one being staged, specifically because it claims to be clean off
  `main`.
- Governance note: this corpus's approval path is Product Owner direct review
  (David), replacing the two-Grading-Validator blind-scoring process for this
  calibration corpus only — an explicit, one-time owner decision, not a
  standing policy change. Do not flag "no dual-blind-scoring" as a defect.

## Verdict threshold

- **Fail** — any of: a malformed `compatibility` projection (missing/
  mistyped required field for any of the 200 items), an incorrect canonical
  answer discovered in your fresh sample, an item whose numeric "canonical"
  value rests on a missing/fabricated dataset without being flagged as such
  (the MOD8 corpus-defect pattern), an executable/reachable `publish`
  operation path anywhere in the payload or build script, or any evidence
  that `draft`-status content is exposed to grading or students.
- **Pass-with-conditions** — documentation/metadata discrepancies (e.g. stale
  counts in a summary table, the known typed-routing-column backfill gap)
  that do not affect correctness or safety of the staged draft content itself.
- **Pass** — no findings in either category above.

Classify every finding as exactly one of:
- **staging blocker** — must be fixed before the `bulk_import` call runs.
- **publish blocker** — fine to stage as `draft`, but must be resolved before
  any later `publish` operation (e.g., the known `rubric_type`/
  `evaluator_strategy` backfill gap belongs here, not as a staging blocker).
- **follow-up** — worth tracking, blocks neither staging nor publish.

## What has already been independently verified (do not re-litigate; spend
your effort elsewhere)

A prior independent pass (not the packet's author) already confirmed, against
live source, all of the following:

- **Live collision check**: ran the packet's own read-only SQL against
  Production (`pcntajvbdfqhbeewmdry`) — zero rows returned; all 200 staged
  `content_key`s (including the 18 renamed `-CAL` items) are clear.
- **`rights_record` omission**: read `admin-content/index.ts`'s
  `createArtifactDraft` — `rights_records` insert only runs
  `if (rightsRecord)` is present in the request body; omitting it causes no
  error. Confirmed non-blocking for draft staging (publish blocker, not a
  staging blocker).
- **Routing-metadata gap**: grepped `admin-content/index.ts` for
  `rubric_type`/`evaluator_strategy` — zero matches; the bulk-import path
  does not write those typed columns (only `prompt_json`). Confirmed the
  legacy `item_type` fallback in `grading-router.ts` still routes `mcq`/`frq`
  correctly with those columns NULL. Classified: **publish blocker**
  (planned backfill `UPDATE` after staging, before publish), not a staging
  blocker.
- **Structural/schema pass on the full 200-item payload** (not a sample):
  zero duplicate `content_key`s, every MCQ has 4-5 choices with exactly one
  `is_correct: true`, every FRQ has non-empty `frq_criteria` with positive
  total `points_possible`, no item missing `exam_pack_version_id` /
  `content_key` / `item_type` / `title` / `stem`, single consistent
  `exam_pack_version_id` (`548f06be-ccf4-426d-b82b-b424137a4438`, confirmed
  live via SQL to be the real published AP Statistics exam pack version).
- **Independent arithmetic re-derivation of the packet's 10 flagged
  "deterministic vs provisional" disagreements** (in `approval_packet.md`
  §1), against the actual rubric/response text in
  `docs/research/ap_statistics_gold_set_candidate_2026_07_09/
  provisional_labels.json`. 9 of 10 confirmed as stated (6 look like the
  provisional label under-credited correct work; 4 are already correctly
  labeled `not_earned` and are useful regression-test material, not real
  disagreements). 1 of 10 (`APSTAT-MOD4-H001-INV` r1,
  `hypothesis_test_execution`) was judged **more genuinely borderline** than
  the packet's framing suggested — recorded numbers: response states
  "t ≈ -2.5", canonical is 2.56074, relative error ≈ 2.35% — near the 2%
  `DEFAULT_REL_TOL` used elsewhere in `statistics-verifier.ts`. Recommend
  leaving it in the adjudication queue as already scoped, not treating it as
  a settled false-positive.

**Content_keys already touched by some verification pass — exclude these
from your fresh sample (§3):**

From `verification_log.md`'s named 18-item label/rubric spot-check:
`STATS-MOD1-E002`, `APSTAT-MOD5-M004`, `APSTAT-MOD7-H010`, `STATS-MOD1-M001`,
`STATS-MOD3-H009`, `APSTAT-MOD6-M005`, `STATS-MOD4-E005`, `STATS-MOD9-H019`,
`APSTAT-MOD8-M001`, `APSTAT-MOD8-M005`, `APSTAT-MOD4-M004`, `STATS-MOD9-H016`,
`APSTAT-MOD6-M004`, `STATS-MOD4-M009`, `STATS-MOD3-H007`, `APSTAT-MOD8-M003`,
`STATS-MOD4-H014`, `APSTAT-MOD6-H006`.

From the 30-row adjudication queue in `approval_packet.md` (10 unique
content_keys, 3 responses each): `APSTAT-MOD3-H001-INV`,
`APSTAT-MOD4-H001-INV`, `APSTAT-MOD5-H001-INV`, `APSTAT-MOD6-M001`,
`APSTAT-MOD6-H001`, `APSTAT-MOD6-H002-INV`, `APSTAT-MOD7-H001`,
`APSTAT-MOD7-H002-INV`, `APSTAT-MOD8-H001`, `APSTAT-MOD8-VH001`.

From the independent 10-disagreement re-derivation, the additional keys not
already in the two lists above: `APSTAT-MOD7-M005`, `APSTAT-MOD8-M002`,
`APSTAT-MOD8-M004`, `STATS-MOD1-E004`.

That's 32 unique FRQ content_keys already touched, out of 100 total. **For
MCQ**, only "6 of 82 new items hand-spot-checked" is recorded in the prior
remediation PR, but the specific 6 are not named in any available material —
full non-overlap with those 6 can't be guaranteed. Exclude the 18 reused-as-
is `-CAL` items from your MCQ sample (they were verified pre-publish in the
original 2026-07-01 batch, not new content); sample only from the 82
newly-authored MCQ items, and if you discover post-selection that one of your
15 happens to be among the unnamed 6, note it rather than treating it as a
process violation.

## 3. Deterministic sample selection (do this first, before judging any
answer)

1. From `bulk_import_payload.json`, take all FRQ `content_key`s **not** in
   the 32-key exclusion list above. Sort lexicographically ascending. Select
   the first 15.
2. From `bulk_import_payload.json`, take all MCQ `content_key`s **not**
   ending in `-CAL` (i.e. the 82 newly-authored items). Sort lexicographically
   ascending. Select the first 15.
3. **Record both selected lists in `qa_review.md` before inspecting any
   answer content.** This guards against unconsciously gravitating toward
   easier items once you've seen them.
4. For each selected item, independently re-derive the correct answer/rubric
   from the stem/stimulus alone — not from the provided rationale or
   `explanation` field — the same way the original `APSTAT-MOD6-H007` defect
   was caught (compute it yourself first, then compare to what's staged).
5. While sampling, specifically scan for the three known failure shapes from
   `docs/research/AP_STATISTICS_MOD3_MOD6_BOUNDARY_CONTRACTS_2026_07_09.md`:
   an unflagged z*-vs-t* critical-value choice, a sign-conventional numeric
   answer presented as canonical without the resolved non-directional
   exception, and any item whose numeric "canonical" value rests on a
   missing/fabricated dataset without being flagged as a corpus defect.

## Numeric-judgment methodology (removes subjectivity on borderline cases)

For any numeric criterion you evaluate as correct/incorrect/borderline,
report the actual relative error you computed
(`|response_value - canonical_value| / |canonical_value|`), not a qualitative
label. Use the same 2% relative-tolerance convention already established as
`DEFAULT_REL_TOL` in `supabase/functions/_shared/statistics-verifier.ts` as
your reference band: at or under ≈2%, treat as arithmetically acceptable;
meaningfully over, treat as a genuine miss. State the number either way —
"acceptable, 0.4% relative error" or "miss, 8.2% relative error" — not "close
enough" or "too strict."

## What to verify, not assume

1. **PR #36 is actually clean, and the build is reproducible.** Confirm the
   diff against `main` contains exactly the five stated files and nothing
   else. Then: checkout PR #36 from a fresh `main`, run
   `scripts/build_task0016_phase_c_publish_packet.mjs` into a **temporary
   directory** (do not overwrite the committed files), and structurally
   compare (not necessarily byte-identical, but semantically identical —
   same items, same field values) the regenerated `bulk_import_payload.json`
   against the committed one. If the script depends on any file/state that
   only exists on another branch and isn't in `main`, that's a **staging
   blocker**.

2. **`bulk_import_payload.json`'s `compatibility` shape, for every one of the
   200 items, not a sample.** Cross-check against `ensureLegacyProjection` in
   `supabase/functions/admin-content/index.ts` (around line 206): confirm
   every item's `compatibility` object has the exact field names/types that
   function reads (`exam_pack_version_id`, `content_key`, `item_type`,
   `frq_form`, `title`, `stem`, `stimulus`, `prompt_json`, `explanation`,
   `help_text`, `content_labels`, `mcq_choices[]`/`frq_criteria[]` with their
   own required sub-fields). Do this with a script over the full file, not
   manual spot-checking — **the checker must fail closed**: nonzero exit on
   any schema/type/count mismatch. Retain the exact script/command you ran
   in the evidence section.

3. **Content correctness on the fresh 30-item sample** — per §3 above.

4. **Draft status is genuinely inert.** Confirm — from the actual grading
   path, not assumption — that `status: 'draft'` content_items/
   content_item_versions cannot be graded or served to a student. Search
   `supabase/functions/evaluate-attempt/index.ts` for the status check that
   should reject/404 anything where `contentItem.status !== 'published'`.
   Confirm `admin-content`'s bulk_import path really does create items at
   `draft` (re-derive from `createArtifactDraft`'s status parameter), not
   `published`.

5. **No accidental publish path.** Confirm neither
   `scripts/build_task0016_phase_c_publish_packet.mjs` nor
   `bulk_import_payload.json` contains or triggers an `operation: "publish"`
   call anywhere, and that the script has no live-write capability beyond
   generating the staged JSON file (it should not call Supabase itself).

6. **`verification_log.md` and `approval_packet.md` internal consistency.**
   Recompute the item counts, module/difficulty distributions, and
   deterministic-coverage numbers stated in `approval_packet.md` yourself.
   **Authoritative source per field, in case of conflict:**
   `bulk_import_payload.json`'s `compatibility.prompt_json` is authoritative
   for what's actually being staged (module/difficulty/`rubric_type`/
   `evaluator_strategy` tags — these are the literal values that will land in
   `content_item_versions.prompt_json`). `statistics_item_keys.json` is
   authoritative for deterministic-key coverage counts (which items have a
   checkable key) — that's a separate verification-layer artifact, not the
   staged content. If the two sources disagree on anything that should be
   the same fact, that disagreement is itself a finding — report it, don't
   silently pick one.

7. **Validation.** Re-run
   `python3 docs/research/statistics_phase_b_2026_07_08/validate_keys.py`
   yourself and confirm the 44/44 + 7/7 pass count independently, from your
   own execution, not the packet's stated number. Record the exact command
   and its output in your evidence.

## Authority boundaries

You may propose a verdict and findings. You may not approve, merge, execute
the staged `bulk_import` call, alter live Production/Development state, or
submit an "Approve" GitHub review on PR #36 (comment only). David is the
final approver, and the actual staging action happens as a separate, explicit
step after this review.

## Required Output

Committed to
`docs/research/ap_statistics_phase_c_publish_staging_2026_07_11/qa_review.md`:

1. The two selected sample lists (§3), recorded before any correctness
   judgment, per the anti-cherry-picking requirement.
2. Proposed verdict: Pass / Fail / Pass-with-conditions, per the threshold
   definitions above.
3. Findings, each tagged **staging blocker** / **publish blocker** /
   **follow-up**, with file:line or content_key-level references.
4. For every numeric judgment: the actual computed relative error, not a
   qualitative label.
5. Evidence actually checked: files read, exact commands run (including the
   reproducibility rebuild and the schema-conformance script), sample items
   independently re-derived.
6. Any claim you could not verify from the repo alone, explicitly marked as
   requiring live DB access.
7. Required remediation, if any, before staging proceeds.

Plus a short, non-approving summary comment on PR #36 linking to the
committed report.

Keep the report concise and source-backed. Do not restate what the "already
verified" section above already covered as if it were your own finding.
