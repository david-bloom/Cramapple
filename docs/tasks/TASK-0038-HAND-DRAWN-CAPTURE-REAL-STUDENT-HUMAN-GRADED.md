# TASK-0038 — Hand-Drawn Capture: Real Students, Human-Graded

**Task ID:** TASK-0038
**Title:** Open the existing hand-drawn capture pipeline to real (non-admin)
students, graded by a real human queue, since automated grading remains
DR-1-disqualified
**Owner:** Claude (implementation), Technical Owner (review)
**Product Owner:** David Bloom
**Tier:** Hard-Gate
**Status:** Opened — Phase 1 Done, Phase 2 Done, Phase 3 Next
**Priority:** High
**Created Date:** 2026-09-23
**Approved Date:** Pending (Product Owner directed "get image capture into
production, human-graded" in-session 2026-09-23; formal phase-by-phase
go-aheads recorded below as they happen)

## Why this task exists

An end-to-end audit this session (2026-09-23) found that TASK-0016 Phase D2
and TASK-0025 shipped real, deployed infrastructure — `app.response_attachments`
binding, retake lineage, the entitlement gate, `record_manual_grade` — but
**zero real usage has ever occurred** (`response_attachments` = 0 rows,
`grading_results` with `model_id='manual-review'` = 0 rows, checked live
against Production). The pipeline is admin-pilot-only by *intent*, but not
admin-pilot-only by *enforcement* — see Finding 1 below, which this task
closes as its first phase.

Automated hand-drawn grading (`evaluate-attempt`'s spatial engine) is not an
option yet: DR-1 accuracy gates remain failed as of 2026-08-20 (best
confirmed automated slice, confidence-gated ~40% coverage: FAR 10.9% vs a
≤2% target; see `docs/research/grading_phase_d_spatial_2026_07_27/`). Closing
that gap is blocked on human reader-certification time and real-photo corpus
volume, not engineering, and is explicitly out of this task's scope (see
"Out of Scope"). This task instead makes the **human-graded** path — already
built and deployed as an admin tool via `record_manual_grade` — into a real,
if narrow, student-facing capability.

## Finding 1 — accidental serving-gate leak (audit, 2026-09-23)

`label_status` (the field that marks a content item `ai_provisional_unapproved`
vs. reader-approved) is **never referenced anywhere in the edge functions
codebase** — it is a label, not a serving gate. The real content selector
`/session` calls (`select_practice_frqs`, via `student-session-items`) filters
only on `status='published'` and `practice_format`. Checked live against
Production:

- 48 published hand-drawn-capture (`*-HDG-*`) content items exist (12
  `APBIO-HDG-*`, 36 `APSTATS-HDG-*`), all still `ai_provisional_unapproved`.
- **36 of the 36 `APSTATS-HDG-*` items have `practice_format='targeted_drill'`**,
  which is in `select_practice_frqs`'s allowed set — structurally eligible to
  be served to a real student today.
- Zero attempts have ever been created against any HDG item in Production —
  this has not happened yet, but only incidentally (queue ordering/volume
  among the larger FRQ pool), not by any designed protection.
- If one *were* served: the frontend's real `/session` question-kind
  derivation (`servedItemToQuestion` in `use-session.ts`) can only ever
  produce `kind: "mcq" | "short_frq" | "long_frq"` — there is no path to
  `"hand_drawn"` outside the separate, unlinked `/hand-drawn-pilot` route. A
  served HDG item would render as a plain text box for a prompt instructing
  the student to draw a graph, with no way to submit the intended response.

This is the first thing this task fixes — independent of everything else
below, it is a live correctness/safety gap that should not wait on the rest
of the phased rollout.

## Phased scope

### Phase 1 — Close the serving-gate leak (do first, independently shippable)
- Exclude any content item whose `prompt_json` marks it hand-drawn/spatial
  response mode from `select_practice_frqs` (or add an explicit
  `response_mode`/servable-format filter at the RPC or delivery-layer level,
  whichever matches this codebase's existing pattern for `content_asset_metadata`
  visual-requirement gating in `partitionDeliverable`).
- Add a regression test asserting no hand-drawn item is ever returned by the
  real-content selector students hit.
- Verify against Production data (rolled-back SQL, matching this repo's
  established verification pattern) that the 36 previously-eligible
  `APSTATS-HDG-*` items are now excluded.

**Phase 1 status: Done (2026-09-23), deployed to Development and Production.**
Live-verified against Production immediately before and after the fix:
`select_practice_frqs` was returning 19 hand-drawn rows out of 50 for the AP
Statistics `targeted_drill` pool (confirmed with the function's pre-fix
definition, read-only); after
`supabase/migrations/20260923150000_exclude_hand_drawn_from_text_serving.sql`
was applied to Production, the same call returns 0. Also fixed
`select_unit_gated_practice_items` (same gap; currently unreachable in
Production per TASK-0025's existing notes on that selector returning zero
rows until taxonomy labels are validated, but fixed for when that changes).
Regression coverage:
`supabase/tests/task0038_hand_drawn_serving_exclusion.integration.sql`
(read-only, rolled back, data-dependent rather than fixture-based --
publish-gate triggers on `content_items`/`content_item_versions` made a
synthetic "published" fixture not clearly representative of the real gates;
this instead asserts against whatever real published hand-drawn content the
target database has, and skips rather than fails when none exists). Ran
clean against Production (no exception raised, real leak data present) and
against Development (skip path, no hand-drawn content there yet).
Development was migrated first per this repo's standing practice, though it
carries no hand-drawn content to exercise the fix against -- Production is
where this gap was live and where the fix was actually verified against
real data.

### Phase 2 — Promote a narrow, real item set off `ai_provisional_unapproved`

**Done (2026-09-23).** `DECISION-0058`/`APPROVAL-0048`: defined "approved" for
this task's scope as human-graded-pilot-ready (a clean `tutor_question`-stage
review trail, checked against `app.content_review_decisions` directly rather
than trusting `review_status` at face value) — explicitly **not**
AI-grading-readiness and **not** rights clearance, both of which remain open
for the whole hand-drawn corpus. Reviewed the 24 published,
`tutor_question`-approved candidates (12 `APBIO-HDG-*`, cross-referenced
against known corpus defects in
`docs/research/HAND_DRAWN_REAL_PHOTO_GRADING_ACCURACY_2026_08_18.md` — none
of the axis-tick-corrupted `EST-*`-archetype items are in this set) and named
**`APBIO-HDG-2026-GRAPH-002`** (`content_item_version_id
1c29347d-0f41-4f09-96a7-6f863be82eaf`), the existing pilot item: reuses all
built plumbing, and its one flagged review concern (Accuracy/Ambiguity, plus
a curriculum-fit note) was fixed and cleanly re-approved 2026-08-08.
`prompt_json.label_status` updated on Production from
`ai_provisional_unapproved` to `human_graded_pilot_approved`, with a
`human_graded_pilot_approval` object recording the decision/approval IDs and
explicit scope. Verified live. This value is still descriptive only —
nothing server-side reads `label_status` yet; Phase 3 is what makes it
load-bearing.

### Phase 3 — Real `/session` frontend support for hand-drawn capture
- Extend `servedItemToQuestion` to detect a hand-drawn response mode from
  the served item and produce `kind: "hand_drawn"`.
- Reuse `CaptureItem`/`attach_capture` exactly as `/hand-drawn-pilot`
  already does — do not fork a second implementation.
- Remove/relax the pilot route's hard-coded admin-only client gate for the
  specific promoted item(s) once Phase 2 clears them.

### Phase 4 — Real human-grading queue
- TASK-0020 Program C already names "operationalizing manual grading
  (reviewer queue, qualifications, SLA, dispute/regrade path, capacity
  commitment)" as its own Hard Gate. `record_manual_grade` and
  `/admin/grade-response/$attemptId` are a single-attempt admin tool today,
  not a queue. This phase needs at minimum: a list view of submitted,
  ungraded hand-drawn attempts; a named grader (owner, to start); and a
  bounded SLA commitment before any real student is told to expect a graded
  result.

## Out of Scope (explicitly deferred, not silently dropped)

- Closing DR-1 for automated grading (D3 real-photo volume, reader
  certification, D4 locked holdout, D5 abstention packaging) — tracked in
  `docs/research/grading_phase_d_spatial_2026_07_27/D3_D4_D5_STATUS.md`,
  bottlenecked on non-engineering human time, not this task.
- Document/worksheet upload (Homework Mode's third intake mode) — no code
  exists yet for it anywhere; separate initiative, tracked under `TASK-0037`.
- Broader Program B/C completion beyond what Phases 1-4 above require.

## Acceptance Criteria

- [x] Phase 1: hand-drawn items provably excluded from
      `select_practice_frqs`/real `/session` delivery; regression test added;
      re-verified live against Production.
- [x] Phase 2: Product Owner has named the promoted item(s) and the
      operational meaning of "approved" for `label_status`.
- [ ] Phase 3: a real (non-admin) student can reach a hand-drawn item via
      `/session`, capture and submit a photo, and have it bound via the
      existing `attach_capture` pipeline — verified end-to-end with real
      credentials, not just type-checks.
- [ ] Phase 4: a real submitted attempt is graded by a named human within a
      committed SLA and the student sees a real result.

## Approval State

**Approval Required:** Yes — Hard Gate (opens a previously admin-only,
privacy/grading-relevant pipeline to real students; each phase needs its own
Product Owner go-ahead per this repo's standing practice for Hard-Gate work).
**Decision:** Pending (Phase 1 authorized to proceed as a safety fix;
Phases 2-4 pending explicit go-ahead at each checkpoint).
