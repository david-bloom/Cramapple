# Lovable Build Brief - UX-006 Student Practice and Grading (Real Integration)

**Supersedes the frontend-only version of this brief.** That version (frontend-
only, simulated state, no backend) shipped the UX design and interaction
patterns; this version wires the same experience to the real backend so
tutors and, later, students hit real grading. Approved per David Bloom,
2026-07-12, alongside `TASK-0010` approval — see
`docs/activity_log/ACTIVITY_LOG.md` and `APPROVALS_LOG.md` /
`DECISIONS_LOG.md` entries dated 2026-07-12 for the decision record.

Build a polished, responsive Cramapple student-practice and grading
experience, connected to the real Production Supabase backend, covering MCQ
and FRQ response, criterion feedback, and the grading states the backend
actually produces today. **Do not build dispute or regrade against a real
backend — no such backend exists yet (see Explicitly Deferred below); keep
those two flows simulated exactly as the prior brief specified.**

## Before Writing Any Code: Verify These Live

The backend has drifted from git before (see `ACTIVITY_LOG.md`, 2026-07-12
entries — a full grading engine was found deployed to Production with no
corresponding commit anywhere, and it was live-broken for hours with zero
invocations). Do not trust this document's specifics as gospel. Before
wiring anything, confirm against the live Production project
(`pcntajvbdfqhbeewmdry`) via Supabase MCP or dashboard:

1. **Is there real published content to practice on?** A prior finding
   (`DECISION-0033`, referenced in `ACTIVITY_LOG.md`) flagged that all AP
   Biology `content_items` were stuck in `draft` status — i.e., nothing
   published to practice against. Query
   `select status, count(*) from app.content_items group by 1;` (or the
   `public.content_items` view) before building. If nothing is published,
   this brief cannot be exercised end-to-end yet — stop and report that
   back rather than building against fixtures that only look real.
2. **What is the actual response-submission entrypoint?** Git has a
   `submit-response` edge function and an `app.submit_response(uuid, uuid,
   uuid, text, text, text)` RPC (see
   `supabase/migrations/202606210007_submit_response_rpc.sql` for the exact
   signature and error contract). But Production's live edge-function list
   (checked 2026-07-12) shows a function called **`attempt-response`**, not
   `submit-response` — likely another piece of the same out-of-band
   deployment that shipped the grading engine. Pull `attempt-response`'s
   actual source via `mcp__supabase__get_edge_function` before assuming
   which one to call from the client.
3. **Confirm `evaluate-attempt`'s current deployed contract still matches
   this brief's §Grading Call below** — it was rewritten and fixed live on
   2026-07-12; re-pull it if this brief is used more than a few days after
   that date.

## Product Boundary

- UX-001 supplies the overall student portal and learning-loop frame.
- UX-006 supplies detailed practice and grading interactions.
- Scores are Cramapple practice results, not official College Board scores.
- A low-confidence result must not look like an authoritative grade.
- This build is scoped for **tutor visibility and iteration**, per David's
  2026-07-12 direction — not a general student-facing launch. `TASK-0010`'s
  acceptance criteria (adjudicated gold sets, shadow cohort, calibrated
  confidence/abstention, limited-release sampling) remain open even though
  the task itself is now approved to proceed; do not present this build as
  having cleared those gates.

## Backend Connection

- **Project:** Supabase Production, `pcntajvbdfqhbeewmdry`
  (`https://pcntajvbdfqhbeewmdry.supabase.co`). Not Lovable Cloud, not the
  `Cramapple-Development` project (`wmgjsdkphcyhngaffbqf`).
- **Auth:** Real Supabase Auth, sign-in required. No anonymous practice —
  per `DECISION-0035`, curated views grant `authenticated` only, no `anon`.
  Use native Supabase Google OAuth (or email/password if that's what's
  already configured on this project) — do not reintroduce Lovable Cloud
  auth.
- **Data access:** Read and write **only through the curated `public`
  schema** — `public.content_items`, `public.content_item_versions`,
  `public.mcq_choices`, `public.frq_criteria`, `public.attempts`,
  `public.response_versions`, `public.grading_results`,
  `public.attempt_criterion_results`, `public.learning_sessions`,
  `public.progress_snapshots`. Full column-level contract:
  `docs/architecture/PHASE1_CURATED_INTERFACE_NOTES.md`. **Never query
  `app.*` tables directly from the client** — that schema is intentionally
  not exposed to `authenticated`; only service-role edge functions touch it.
- **Writes:** response submission and grading go through RPC/edge-function
  calls (see §Grading Call and the live-verification step above for the
  submission entrypoint), not direct table writes — `public` is read-only
  views by design (`PHASE1_CURATED_INTERFACE_NOTES.md` §Write paths).

## Grading Call

Once a response is submitted (entrypoint TBD per live verification above),
request a grade by calling the `evaluate-attempt` edge function directly:

```
POST https://pcntajvbdfqhbeewmdry.supabase.co/functions/v1/evaluate-attempt
Authorization: Bearer <the signed-in user's access token>
Content-Type: application/json

{
  "operation": "grade_initial_attempt",
  "idempotency_key": "<client-generated UUID, one per grading request>",
  "attempt_id": "<uuid>",
  "response_version_id": "<uuid>",
  "content_item_version_id": "<uuid>",
  "rubric_version_id": "<uuid>",
  "assistance_condition": "independent" | "coached" | "exam_practice"
}
```

`operation` must be one of `grade_initial_attempt`, `select_repair`,
`grade_revision`, `grade_transfer_attempt` — anything else is rejected.
Re-sending the same `idempotency_key` returns the cached result instead of
re-grading (safe to retry on a dropped connection).

**Read the result** from `public.grading_results` (poll or re-fetch by
`request_id` after the call returns, or use the response body directly —
confirm which with a live test) — as of 2026-07-12 the view includes:
`status`, `points_earned`, `points_available`, `criterion_results`,
`highest_value_gap`, `confidence`, `uncertainty_reason`,
`feedback_preview`, `action_hint`, `repair_hint`,
`deterministic_verifier_version`, `boundary_contract_version`. Use
`feedback_preview`/`action_hint`/`repair_hint` for the criterion-card and
repair-prompt copy specified below instead of inventing that language
client-side — it now comes from the grader.

**What actually grades deterministically vs. via LLM today:** only a small,
explicitly seeded set of AP Statistics long-FRQ `content_key`s route to the
deterministic symbolic/ECF verifier (see `STATISTICS_ITEM_KEYS` in
`supabase/functions/_shared/math-verifier.ts`); everything else, including
every currently published AP Biology item, goes through the single-call LLM
grader. Don't build UI that implies a uniform grading mechanism — it's fine
for the UI to be silent about which one graded a given response, but don't
claim "deterministic" or "verified" language for items that didn't route
there. `deterministic_verifier_version` being non-null on a result is the
signal, if you want to expose it.

## Grading States You Will Actually See

Unlike the frontend-only version, you cannot script every state via
fixtures — build the UI to handle whatever the real grader returns, and use
these real triggers to test each state:

- **High-confidence result** — `status: "graded"`, `confidence: "high"`.
- **Qualified / low-confidence result** — `status: "uncertain"`,
  `confidence: "low"` or `"medium"`. Do not show a precise total; show
  `uncertainty_reason` and whatever criteria did resolve.
- **Technical failure** — the grading call times out, errors, or returns
  `status: "failed"`. The attempt and response are already saved
  server-side before grading starts; retrying with the same
  `idempotency_key` is safe and will not create a duplicate.
- **MCQ** — always deterministic, `model_id: "rule-based-mcq"`, always
  `confidence: "high"`.

There is **no live "content uncertain," "human review pending," "regrade
pending," or "corrected regrade" state available from the backend today** —
those states exist in the design doc
(`docs/product/STUDENT_PRACTICE_AND_GRADING_DESIGN.md`) but nothing
currently produces them. Build the UI states so they're ready (per the
original visual/copy spec below) but they cannot be exercised against real
data yet — say so in your handoff notes rather than silently faking them
with fixtures mixed into an otherwise-real flow.

## Explicitly Deferred (Keep Simulated, Do Not Wire)

- **Dispute (`Request a recheck`)** — no backend table, RPC, or edge
  function for student-initiated disputes exists anywhere in this
  codebase, git or Production. Keep this flow exactly as simulated in the
  original brief, clearly labeled as a preview of a future capability.
- **Regrade comparison** — same: no backend support exists. Keep simulated.
- **Human review** — `review-queue`/`review-decision`/`assign-for-review`
  edge functions exist but are for tutor/content-reviewer workflows
  (grading *content*, not adjudicating a *student's* disputed result). Do
  not wire student-facing "human review pending" to those.

## Visual Direction

(Unchanged from the original brief.)

- Calm, focused study workspace.
- Warm neutral canvas, deep green navigation, white question and feedback cards.
- Feedback should feel precise and humane, not celebratory or punitive.
- Use restrained status colors with text and icons.
- No confetti, streaks, ranking, countdown pressure, or fake mastery meters.

## Routes

```text
/practice/mcq/:attemptId
/practice/frq/:attemptId
/attempts/:attemptId/result
```

Drop the `/prototype/` prefix from the original brief — this is a real
route tree against real data, not a fixture sandbox. Keep
`/attempts/:attemptId/dispute` and `/attempts/:attemptId/regrade` under a
`/prototype/` prefix or equivalent visual "preview" treatment, since those
stay simulated (see Explicitly Deferred).

## Stable Frame, MCQ Scenario, FRQ Composer, Criterion Feedback, Quantitative Scenario, Repair and Retry, Accessibility

Unchanged from the original brief (`git log` this file for the prior
version) **except**: replace every scripted/fixture data source with the
real backend calls above, and drive criterion-card copy from
`criterion_results`/`feedback_preview`/`action_hint`/`repair_hint` instead
of authored fixture text.

## Required Scenarios (Real Data)

- MCQ correct and incorrect, against real published MCQ content (once
  confirmed available per the pre-build check).
- FRQ criterion feedback against a real published FRQ, both a
  high-confidence and a low-confidence real result if you can find or
  produce cases of each.
- One real technical-failure/retry cycle (e.g. by temporarily using a bad
  `content_item_version_id` or another way to force a failure) to confirm
  idempotent retry actually works end-to-end.
- Simulated dispute and regrade flows, clearly marked as preview-only.

## Security

- Real learner auth, real session tokens — do not hardcode a service key
  or bypass auth in the client.
- No `app.*` schema access from the client under any circumstance.
- This is now real production data flowing through a real grader — treat
  any test submissions as real usage, not throwaway fixtures. Coordinate
  with David before submitting AP Biology test content broadly, since
  usage here writes real rows to `app.grading_results` and
  `app.model_usage_ledger` (which enforces `OPENAI_DAILY_CAP_USD`).
