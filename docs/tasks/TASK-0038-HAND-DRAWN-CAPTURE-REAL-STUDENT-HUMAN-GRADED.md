# TASK-0038 — Hand-Drawn Capture: Real Students, Human-Graded

**Task ID:** TASK-0038
**Title:** Open the existing hand-drawn capture pipeline to real (non-admin)
students, graded by a real human queue, since automated grading remains
DR-1-disqualified
**Owner:** Claude (implementation), Technical Owner (review)
**Product Owner:** David Bloom
**Tier:** Hard-Gate
**Status:** Opened — Phase 1 Done, Phase 2 Done, Phase 3 Done (Still
Admin-Gated), Phase 4 Done (Infrastructure + Operational Commitment
Approved — `DECISION-0059`/`APPROVAL-0049`). Next: Stage 1's real
end-to-end run.
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

**Done (2026-09-23), still admin-gated.** Found that `CaptureItem` +
`prepareCaptureSlot`/`submitCapturedResponse` were already wired into the
*real* `SessionFrame`/`use-session.ts` (built for TASK-0016 Phase D2's QR
capture) — `/hand-drawn-pilot` is a separate, older, bespoke standalone page
(`SameDeviceCapture`, its own hand-rolled state machine) that never touches
this real machinery. The actual gap was narrower than first scoped: real
`/session` had no way to *reach* a hand-drawn item, not a missing UI.

Backend (`supabase/functions/`):
- New migration `20260923170000_select_hand_drawn_pilot_items.sql`: a
  dedicated selector RPC, deliberately separate from
  `select_practice_frqs`/`select_unit_gated_practice_items` (which, per
  Phase 1, now actively exclude hand-drawn items) — returns only items with
  `hand_drawn=true AND label_status='human_graded_pilot_approved'`
  (belt-and-suspenders double filter). Applied to Development then
  Production; live-verified against Production returning exactly
  `APBIO-HDG-2026-GRAPH-002` and nothing else.
- `_shared/student-item-delivery.ts`: `SelectedRow` gained `hand_drawn?:
  boolean` (computed by the caller, never read from a raw prompt_json
  column downstream) and `RenderItem` gained `response_mode: "typed" |
  "hand_drawn"`. New unit test; fixed a pre-existing stale key-allowlist
  test (missing `choices`/`item_type`, unrelated to this change — the test
  had drifted from the real `RenderItem` shape before this session).
- `student-session-items/index.ts`: new `mode: "hand_drawn_pilot"` branch
  calling the new selector (no `practice_format` requirement — the promoted
  item carries `practice_format=null`); new `withHandDrawnFlag` helper
  derives the safe boolean from `prompt_json` once, at the single place that
  column is read, so the rest of the pipeline never has to carry or filter
  the rest of `prompt_json` (which holds answer-bearing fields like
  `expected_graph_spec`).
- Deployed to Development then Production (byte-identical content hash
  confirmed via file-content diff, not just a matching hash). Smoke-tested
  clean on Development (401 unauthenticated, no crash); Production deploy
  relies on the identical-content confirmation rather than a direct HTTP
  call (consistent with this session's established practice of not forcing
  live Prod HTTP checks).
- Pre-existing, unrelated finding: `supabase/functions/student-session-items/index_test.ts`
  is currently broken on `main` (confirmed via `git stash`, not caused by
  this session) — its fixtures use non-UUID session ids, so every test
  fails a strict UUID check and returns the wrong status code. Flagged as a
  separate follow-up task (`task_dff018c9`), not fixed here.

Frontend (`exam-buddy-wireframe`):
- `use-session.ts`: `servedItemToQuestion` now derives `kind: "hand_drawn"`
  from `item.response_mode`; new `ServedItem.response_mode` field; new
  `UseSessionOptions.handDrawnPilot` flag that, when true, skips the
  ordinary/pilot-MCQ serving paths and requests `mode: "hand_drawn_pilot"`.
- New route `/session-hand-drawn-pilot`: mounts the real `SessionFrame` +
  `useSession(..., { handDrawnPilot: true })` against the real selector.
  Admin-gated and unlinked from any nav, same posture as `/hand-drawn-pilot`
  — Phase 4 (a real, operational human-grading queue) doesn't exist yet, so
  a real student submitting today would land in `human_review_pending` with
  nothing currently committed to resolve it. Opening this route to real
  students is Phase 4's go-ahead, not this one's.
- Verified: `tsc --noEmit` clean; `vite build` succeeds and the new route
  registers in the generated route tree; full Vitest suite 401/402 (the
  same one pre-existing, unrelated failure this repo has had all session —
  a stale string-match assertion in `session-setup.test.ts`).
- Committed and pushed to `main` (backend `864c22aa`, frontend `e16c72d`,
  merged clean with unrelated upstream Lovable work). **Lovable publish not
  triggered** — a push to `main` does not deploy; publishing is its own
  explicit step, left for David.

### Phase 4 — Real human-grading queue

**Infrastructure done (2026-09-23); the operational commitment (named
grader, SLA) is still open — see "Left for David" below.**

**New finding that shaped this phase:** `app.attempts`,
`app.response_attachments`, and `app.grading_results` RLS is owner-only
(`auth.uid() = user_id`) with **no admin bypass policy**. The original
single-attempt admin page (`admin.grade-response.$attemptId.tsx`) read these
tables directly via the authenticated client — that only ever worked
because every attempt graded through this pilot to date has been an admin's
own test submission (matches the audit finding that `response_attachments`
= 0 rows, ever). A real admin grading a real student's attempt would have
hit RLS and failed silently on the read side. Separately, the photo itself
was unreachable too: `storage-sign-url`'s `ownsLearnerPath` check had no
admin exception at all for `sign_download`, so `canAccessBucket`'s existing
admin clearance for `learner-uploads` was dead code for a real cross-user
read.

Backend (`supabase/functions/`):
- New admin-only, service-role `attempt-response` operations:
  `list_manual_grading_queue` (submitted attempts that have a current
  `original` `response_attachments` row — the signal that scopes the queue
  to hand-drawn capture rather than every stuck `submitted` attempt) and
  `get_manual_grading_context` (attempt status, response_version_id,
  storage bucket/path, criteria — everything the grading page needs for one
  attempt, replacing the RLS-blocked direct reads).
- `storage-sign-url/index.ts`: `ownsLearnerPath` now has a narrow admin
  exception, scoped to `mode: "sign_download"` only — upload/delete stay
  strictly owner/admin-delete as before. **Caught and fixed a real
  transcription bug during this deploy**: an intermediate manual retype of
  `storage-access.ts` swapped `validator` for `content_author` on the
  `validation-artifacts` bucket rule; caught by comparing the deployed
  content against local disk before promoting to Production, fixed, and
  redeployed with the correct rule before Production ever saw the bad
  version (confirmed via Dev/Prod content-hash match, not just a status
  code).
- Both deployed to Development then Production; `attempt-response`'s new
  operations verified byte-for-byte against local source (comment-only
  diff, no logic drift) before the Production push. 2 new unit tests (both
  new operations refuse a non-admin caller before ever touching the
  service client — the actual security property this phase depends on).
- Pre-existing gap flagged, not fixed: `student-session-items/index_test.ts`
  (see Phase 3) remains broken; no new test coverage was added for the
  admin-success path of the two new operations (would need a much larger
  fake `.from()` query-builder than this codebase's existing test harness
  supports) — relied on live rolled-back SQL verification of the underlying
  join instead, plus the deploy-time content diff.

Frontend (`exam-buddy-wireframe`):
- New route `/admin/grade-response` (index): lists pending attempts via
  `list_manual_grading_queue`, links to the existing per-attempt page.
- `admin.grade-response.$attemptId.tsx` rewritten to call
  `get_manual_grading_context` instead of direct `db.from(...)` reads (the
  actual RLS fix on the frontend side) and to sign the photo via the
  context's bucket/path.
- Verified: `tsc --noEmit` clean, `vite build` succeeds with both routes
  registered, full Vitest suite 401/402 (same one pre-existing unrelated
  failure).

**Operational commitment approved (2026-09-23) — `DECISION-0059`/
`APPROVAL-0049`.** Pilot-scale, not the full Program C launch design:

- **Scope:** `APBIO-HDG-2026-GRAPH-002` only.
- **Grader:** David Bloom (the only admin who has ever operated this
  pipeline; no qualified-reviewer roster exists yet).
- **SLA:** graded within 24 hours; queue checked at least once daily.
- **Dispute/regrade:** interim manual stance, not tooling — a direct,
  logged SQL correction (no regrade RPC exists yet).
- **Repair authoring:** accepted gap — `record_manual_grade` always passes
  `highestValueGap: null`, so a manually-graded student sees a score but no
  repair prompt. Left unbuilt for this pilot.
- **Staged rollout:** Stage 1 (now) — `/session-hand-drawn-pilot` stays
  admin-gated while David runs one real end-to-end loop under real
  (non-simulated) conditions, the one Phase 3 acceptance criterion never
  yet exercised. Stage 2 — only after Stage 1 proves clean, the gate lifts
  for a small named group, never the general Biology population. No
  further widening without revisiting `DECISION-0059`.

This does **not** close TASK-0020 Program C's Hard Gate — a broader launch
still needs the full multi-owner design (Learning Quality, Operations,
Privacy/Security). **Next action, still open:** Stage 1's real
end-to-end run.

### Addendum (2026-09-23) — reviewed against a separate Codex discussion draft

David asked for a review of
`docs/product/BYOQ_UPLOAD_POLICY_AND_DATA_LIFECYCLE_DISCUSSION_2026_09_23.md`
(a Codex-authored discussion draft, not yet approved, on BYOQ upload policy
generally) against this task. Two findings, both resolved same-session:

- The draft's first-upload disclosure requirement (§4) applies to hand-drawn
  capture too, not just BYOQ uploads — its own "Hand-drawn work" subsection
  names the hand-drawn scoring feature explicitly. **David's direction**:
  simple consent copy near the upload action, linking to Terms/Privacy, no
  separate recorded-acceptance event. Added to `CaptureItem.tsx` (the real
  `/session` capture component) — a visible "by submitting a photo, you
  agree to our Terms and Privacy Policy" notice with a PII reminder, shown
  before and during every capture. `exam-buddy-wireframe` commit `677728c`.
- The draft's student-initiated-deletion section (§8) directly conflicts
  with `response_attachments`' immutability trigger (`BEFORE DELETE OR
  UPDATE`, blocks all deletion including `service_role`, added on purpose
  by TASK-0025 for grading-dispute/audit integrity). **David's direction**:
  disregard — that section was discussion only, not a policy decision. No
  schema change made or needed.

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
- [x] Phase 3 (pipeline built and verified; still admin-gated, not yet
      opened to real students — that step belongs to Phase 4). A real
      (non-admin) student CAN technically reach a hand-drawn item via
      `/session` once the admin gate on `/session-hand-drawn-pilot` is
      lifted; not yet exercised end-to-end with real non-admin credentials
      (no such credentials were available this session).
- [x] Phase 4: infrastructure (real queue + per-attempt read/sign path,
      RLS/storage gaps that blocked cross-user admin grading found and
      fixed) and the operational commitment (named grader, SLA,
      dispute/regrade stance, staged rollout — `DECISION-0059`/
      `APPROVAL-0049`) are both done. **Still open:** a real submitted
      attempt actually being graded within the SLA and the student seeing
      a real result — that needs Stage 1's real end-to-end run, not yet
      performed.

## Approval State

**Approval Required:** Yes — Hard Gate (opens a previously admin-only,
privacy/grading-relevant pipeline to real students; each phase needs its own
Product Owner go-ahead per this repo's standing practice for Hard-Gate work).
**Decision:** Pending (Phase 1 authorized to proceed as a safety fix;
Phases 2-4 pending explicit go-ahead at each checkpoint).
