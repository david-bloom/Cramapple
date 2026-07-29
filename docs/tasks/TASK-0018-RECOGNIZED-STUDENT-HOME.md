# TASK-0018 — Recognized Student Home (`/home` V2)

**Task ID:** TASK-0018
**Title:** Recognized Student Home — productionalize `/home` from the `/proto/home` prototype
**Owner:** Codex (frontend repo `exam-buddy-wireframe`)
**Product Owner:** David Bloom
**Tier:** Standard
**Status:** Not Started
**Priority:** High
**Created Date:** 2026-07-28
**Approved Date:** Pending

---

## Product Goal

An authenticated student who opens Cramapple lands on one page that knows who they
are, which subject they are studying, how long until their exam, and what to do
next — with **no invented progress**. Every statement on the page traces to a
production record or is not shown at all.

Release 1 is a **staff-only internal milestone**: it proves the data contract
against real Production records behind a server-side flag, before any student
sees it. Personalized performance claims and sharing are explicitly deferred
(see Out of Scope and §Release 2).

---

## Evidence base (verified 2026-07-28 against Production `pcntajvbdfqhbeewmdry`)

This task exists because the current `HomeV2` implementation on
`exam-buddy-wireframe@origin/main` cannot return data from Production. Verified
findings:

### The snapshot server function is broken in four places

| `src/lib/home.functions.ts` queries | Production reality |
| --- | --- |
| `profiles` filtered on `.eq("id", userId)` | `app.profiles` PK is **`user_id`**; there is no `id` column. PostgREST returns 400 → `no_subject` for **every** user. |
| `.from("sessions")` with `user_id`, `goal` | `public.sessions` is legacy (`student_id`, `mode`, `selected_unit`, `questions_served`). The live table is **`learning_sessions`** (`user_id`, `status`, `session_mode`, `practice_format`, `started_at`, `ended_at`). |
| `attempts` selecting `session_id`, `mcq_item_id`, `frq_package_id` | Real columns: **`learning_session_id`**, **`content_item_version_id`**, `assistance_state`, `attempt_mode`, `score_points`, `score_possible`, `graded_at`, `result_state`, `confidence_level`. |
| `student_course_position` | **Not deployed.** Exists only as `supabase/pending/20260727120000_home_course_position_and_targets.sql`. |

Net effect today: `/home?home=v2` renders "Choose your subject" for all users, in
all environments.

### Errors are swallowed, and the failure mode invents a state

All four queries destructure `{ data }` and ignore `error`. A schema drift
therefore renders a **returning student as brand new**, with `experienceStage:
"new"` and zero evidence. This is the "never invent progress" principle running
in reverse and is the highest-severity defect in the current implementation.

### No attempt in Production has ever been scored

| Metric | Value |
| --- | --- |
| `app.attempts` rows | 42 |
| rows with `score_points` not null | **0** |
| rows with `graded_at` not null | **0** |
| `app.attempt_criterion_results` rows | **0** |
| `app.learning_sessions` rows | 23 |
| `app.progress_snapshots` rows | 0 (table exists) |
| `app.profiles` with `active_exam_pack_version_id` | 5 of 21 |

Breakdown: 30 `draft`/`frq`, 7 `submitted`/`mcq`, 5 `submitted`/`frq`, all
`assistance_state = 'independent'`, all `result_state` null. The most recent
submitted MCQ is 2026-07-29 02:01 UTC — the practice path is being exercised,
but **grading does not write back to `app.attempts`**, and MCQ scoring (which is
deterministic, `mcq_choices` exists) is not happening either.

### Unit taxonomy does not exist as a joinable structure

There is no units/topics table. Unit membership lives in
`app.content_labels` (`label_type='unit'`, 30 labels across 4 exam packs) linked
by `app.content_item_labels`. Coverage of **published** items:

| Subject | Published items | With a unit label |
| --- | --- | --- |
| AP Biology | 94 | **0** |
| AP Statistics | 96 | 23 |
| AP Physics 2 | 16 | 0 |
| AP Precalculus | 11 | 11 |
| AP Physics 1 | 11 | 0 |
| AP Physics C (EM) | 10 | 0 |
| AP Physics C (Mech) | 10 | 0 |
| AP Chemistry | 8 | 0 |
| AP Calculus AB | 4 | 4 |
| AP Calculus BC | 2 | 2 |

Label keys are also inconsistent: AP Statistics uses `unit_1`…`unit_9`; Calculus
and Precalculus use `unit-1-limits-and-continuity`-style slugs. The unit list the
UI renders comes from a hardcoded client file, `src/data/taxonomy.ts`, with no
server-side mapping from label to unit number.

### Other verified facts

- `public.*` are `security_invoker` views over `app.*` (correct), but **stale**:
  `public.learning_sessions` is missing `practice_format`;
  `public.content_item_versions` is missing `rubric_type` and
  `evaluator_strategy`. The Data API only sees the views.
- `app.attempts` has **no** `repair_of_attempt_id` / `attempt_sequence`, so
  "initial, non-repair attempt" is not expressible from the schema — it can only
  be inferred from `min(started_at)` per `(user_id, content_item_version_id)`.
- `/home` is **not authenticated** today. `src/routes/_ux.tsx` sets
  `noindex, nofollow` and mounts `SubjectSwitcher`, but has no auth guard.
  `_authenticated/` is a separate layout that `_ux` does not use.
- The `home-v2` flag (`src/lib/feature-flags.ts`) is **localStorage +
  `VITE_HOME_V2` only**. There is no per-user server flag, so "enable for staff
  accounts" and "enable for a student cohort" are not currently executable.
- `CRITERION_STARTER_SUBJECTS` is hardcoded to `["ap_biology","ap_statistics"]`
  rather than derived from published content.
- `firstNameFrom()` reads Supabase Auth `user_metadata` and falls back to the
  email local part — a student can be greeted "Hi, dbloom01."
- `resolveExamState()` computes the countdown in UTC; `app.profiles.timezone`
  exists and is unused, so the day count is off by one for some students.
- `/proto/*` is publicly reachable and unauthenticated.
- **Live prototype defect:** on `/proto/home` at mobile width the recognition
  line ("Last session you worked on osmosis and earned the water-movement
  prediction criterion") renders near-black on the dark hero card and is
  effectively invisible. The floating "Prototype menu" pill also overlaps the
  "Open Unit 2" CTA. That sentence is the feature; it must be legible.

---

## Technical Scope — Release 1 (staff-only)

### 1. Route and access

- Add an auth guard so `/home` requires an authenticated Supabase session.
- Preserve recovery priority: incomplete setup → interrupted session →
  personalized Home.
- Keep `noindex, nofollow`.
- Gate `/proto/*` behind staff auth **now** (not at cutover). It is currently
  public.
- Keep `/proto/home` reachable by staff for comparison; redirect to `/home` only
  after Release 2 parity.

### 2. Server-side feature flag

- Add per-user flag resolution (a `profiles` column or a flags table) so the
  `home-v2` flag can be enabled per account server-side.
- Retain the existing `?home=v2` / localStorage override for local development.
- Without this, the rollout steps below cannot be executed.

### 3. Fix and harden the snapshot contract

`StudentHomeSnapshot` in `src/lib/home-snapshot.ts` is a sound contract and does
not need redesigning. Fix the server function:

- `profiles` → filter on `user_id`.
- `sessions` → `learning_sessions`, using `status` / `started_at` / `ended_at`
  and `practice_format` (adding `practice_format` to `public.learning_sessions`
  first — see §6).
- `attempts` → select `learning_session_id`, `content_item_version_id`,
  `assistance_state`, `attempt_mode`, `score_points`, `score_possible`,
  `graded_at`, `result_state`, `exam_pack_version_id`.
- Stop hardcoding `attemptCondition: "independent"`, `isRetry: false`,
  `pointsEarned: null` — read real values.
- Scope every query to the active `exam_pack_version_id`.
- **Check `error` on every query.** Add a distinct
  `status: "degraded"` (or an `evidenceUnavailable` flag on the snapshot) so a
  query failure renders an explicit "we can't show your progress right now"
  state and **never** `experienceStage: "new"`.
- Identity: prefer `app.profiles.full_name`; fall back to a nameless greeting.
  Never render an email local part.
- Exam countdown: compute against `app.profiles.timezone`.
- Derive `capability.criterionStarter` from published content counts for the
  active exam pack, not a hardcoded subject list.

### 4. Migration

- Move `supabase/pending/20260727120000_home_course_position_and_targets.sql`
  into the authoritative migration history.
- RLS/security review before application. `session_targets` correctly revokes
  all grants from `anon`/`authenticated` and relies on service-role access —
  preserve that.
- Apply to **Development** first (`wmgjsdkphcyhngaffbqf`), then Production by
  explicit approval. Note the Dev migration-history reconciliation of
  2026-07-15 — do not `db push`.
- Add `repair_of_attempt_id` (or `attempt_sequence`) to `app.attempts` so
  initial-vs-repair is recorded rather than inferred.

### 5. Recognition (evidence-backed, deterministic templates)

Release 1 covers the `new` and `building_signal` structures only, which require
no grading data:

- No evidence: "Let's get your first useful signal."
- One or two graded answers: "You've got one graded answer in. One more short
  session will help us identify a specific gap."
- Interrupted session: "Pick up where you left off." (resume URL derived from
  the live session's actual `practice_format` — never assumed `/session/mcq`)

No generated motivational copy. No mastery, readiness, or AP-score implication
from any number of answers.

### 6. Units and subject switching — navigation only

Per the 2026-07-28 decision, Release 1 ships the unit strip as **navigation**:

- The strip changes the selected unit and opens that unit's detail.
- **No per-unit point capture, no per-unit fractions, no completion
  percentages.** `computeUnitPointCapture` is not wired in Release 1.
- The practice CTA is scoped to **subject**, not unit, and its copy must not
  imply unit-specific targeting.
- Unit names derive from `src/data/taxonomy.ts` for now; a server-side
  label→unit mapping is Release 2 work and depends on unit labeling.
- Show `SubjectSwitcher` only when two or more published subjects are available.
- Persist course position per `(user, exam_pack_version)` via
  `setCoursePosition`; `unitId: null` records an honest "Not sure" and never
  silently selects Unit 1.
- On subject switch: clear the previous subject's cached content, session state,
  and prototype storage; confirm before abandoning an active session.
- Refresh the stale `public.*` views (`learning_sessions.practice_format`, and
  any other column the snapshot needs) as part of this task.

### 7. Prototype defect fixes

- Fix the invisible recognition line on the dark hero card at mobile width.
- Fix the floating prototype-menu pill overlapping the secondary CTA.

---

## Out of Scope

- **All sharing (Layer A and Layer B).** Cut from this release by decision
  2026-07-28. Home links to "View all progress" only. Native share, PNG/MP4
  artifact generation, Instagram/TikTok connection, provider token storage, and
  the youth/privacy/legal review move to a separate program with its own plan
  and approval. The recommended delivery order when that program starts is Web
  Share → TikTok draft upload → audited TikTok Direct Post → Instagram
  professional-account publishing.
- **Factual recent-performance panel** (questions attempted, earned/available
  points, criteria earned, next repair target, trend claims) — Release 2,
  blocked on the grading dependency below.
- **Per-unit evidence and unit-level point capture** — Release 2, blocked on
  unit labeling.
- **Student-facing rollout.** Release 1 ends at staff accounts.
- Scheduled `progress_snapshot` materialization. The table already exists; the
  first implementation must remain reproducible from source records.

---

## Blocking dependencies

### D1 — Grading must write back to `app.attempts` (blocks Release 2)

Zero of 42 Production attempts carry `score_points`, `graded_at`, or a
`result_state`, and `attempt_criterion_results` is empty. Until that write path
is verified in Production, **no factual performance statement and no
criterion-level recognition can be built**. This is owned by the grading
workstream (`docs/GRADING_ENGINES_TO_PRODUCTION_HANDOFF.md`), not by Home.
Deterministic MCQ scoring is the cheapest first win and should be treated as
separable from FRQ engine work.

### D2 — AP Biology unit labeling (blocks Release 2 unit evidence)

0 of 94 published Biology items carry a unit label. Owner: curriculum (Orly).
Also requires normalizing label-key formats across subjects (`unit_1` vs
`unit-1-…-slug`) and a server-side label→unit-number mapping. Note the AP
Statistics 2027 format change reduces Stats from 9 units to 5 — the existing
`unit_1`…`unit_9` labels will need remapping.

### D3 — Observability target

Step "monitor snapshot failures" needs a destination. The cutover plan still
lists the observability provider as undecided.

---

## Routes / Components / Systems Affected

- `src/routes/_ux.tsx` (auth guard), `src/routes/_ux.home.tsx`
- `src/components/home/HomeV2.tsx`
- `src/lib/home.functions.ts`, `src/lib/home-snapshot.ts`
- `src/lib/feature-flags.ts` (server-side flag)
- `src/lib/subject-key.ts`, `src/data/taxonomy.ts`
- `src/components/ux/SubjectSwitcher.tsx`, `set_active_exam_pack_version` RPC
- `src/routes/proto.*` (staff gating)
- `supabase/pending/20260727120000_home_course_position_and_targets.sql`
- `public.learning_sessions` and other stale `public.*` views

---

## Data / Security / Integration Impact

- New tables `student_course_position` (RLS, own-row only) and `session_targets`
  (server-only, no `authenticated` grants, service-role access via server
  functions). Both require RLS review before Production application.
- New `app.attempts` column for repair lineage.
- `public.*` view recreation — must preserve `security_invoker=true`.
- Supabase is moving toward requiring tables to opt into the Data API; grants
  must be explicit.
- No service-role key or provider secret may reach the browser.
- `session_targets.resolved_items` is server-only; the client holds only
  `target_id`.

---

## Acceptance Criteria

- [ ] `/home` requires an authenticated session and is `noindex, nofollow`.
- [ ] `/proto/*` requires staff auth.
- [ ] `home-v2` can be enabled per user account server-side.
- [ ] `loadStudentHome` returns `status: "ready"` for a real Production staff
      account with an `active_exam_pack_version_id` (this currently fails for
      every user).
- [ ] Every Supabase query in the snapshot path checks `error`; a failure yields
      an explicit degraded state and **never** `experienceStage: "new"`.
- [ ] The greeting uses `profiles.full_name` or no name — never an email
      fragment.
- [ ] The exam countdown matches the student's `profiles.timezone` local date.
- [ ] `capability.criterionStarter` is derived from published content, not a
      hardcoded subject list.
- [ ] A student with zero graded attempts sees the `new` structure with no
      percentages, no zeroes, no fake bars, and no trend language.
- [ ] No percentage or trend is displayed anywhere in Release 1.
- [ ] The unit strip changes the selected unit and opens unit detail, and
      displays **no** per-unit progress values.
- [ ] "Not sure" persists as an honest unknown course position and never
      resolves to Unit 1.
- [ ] The primary CTA starts exactly the content the recommendation names, via an
      opaque server-issued `target_id`.
- [ ] Switching Biology → Statistics never flashes Biology units,
      recommendations, or cached attempt data under Statistics.
- [ ] Session resume uses the live session's real `practice_format`.
- [ ] The recognition line is legible at mobile width in both hero treatments,
      and no floating element overlaps a CTA.
- [ ] The migration is in authoritative history, applied to Development, RLS
      reviewed, and Production application is a separate approved step.
- [ ] The old Home remains a one-click rollback for the duration of the release.

---

## QA Plan

- **Manual QA:** staff account on Production behind the flag; mobile (375px),
  keyboard-only, screen reader, slow-network / offline-recovery.
- **Automated tests — contract tests** for: `new`, sparse evidence,
  personalized (fixture-only until D1 lands), missing subject, unsupported
  subject, subject switch, interrupted session, and **degraded / query-failure**.
  The degraded case is new and is the most important one.
- **Seeding:** contract tests need a seeder that writes graded attempts,
  criterion results, and multi-session histories, because Production has none.
  Build it against Development; treat it as a deliverable of this task.
- **Regression areas:** `SubjectSwitcher` + `set_active_exam_pack_version`,
  session setup/resume, `/setup` recovery, existing `/home` v1.
- **Failure cases:** snapshot query error, missing `active_exam_pack_version_id`,
  retired exam pack, elapsed exam date (off-season), zero published content for
  the active subject, subject switch mid-session.
- **Security/data checks:** RLS on `student_course_position` (cross-user read
  denied), `session_targets` unreachable with an `authenticated` JWT, no
  service-role key in the client bundle, `security_invoker` preserved on
  recreated views, no prototype fixtures in the production bundle.

---

## Release 2 (defined, not scheduled)

Unblocked by D1 and D2:

1. Factual performance panel: most recent completed session, questions
   attempted, earned/available points, criteria earned and next repair target,
   current unit, plain-language sample size.
2. Evidence rules: count only graded, independent, initial attempts; keep
   coached work and repairs visible as activity but separate from cold
   performance; exclude uncertain / failed / review-pending grades from
   achievement claims; no percentage or trend below the configured minimum
   sample (`RECOMMEND_MIN_ATTEMPTS = 3` / `RECOMMEND_MIN_ITEMS = 2`;
   `TREND_MIN_ATTEMPTS = 5` / `TREND_MIN_SESSIONS = 2`).
3. Personalized recognition and targeted next-point recommendations.
4. Per-unit evidence via a server-side label→unit mapping.
5. Student cohort rollout → default → redirect `/proto/home` → remove prototype
   fixtures from production bundles.

---

## Approval State

**Approval Required:** Yes
**Approval Type:** Hard Gate (Production migration application; student-facing
route becoming the authenticated landing page)
**Decision:** Pending

---

## Implementation Notes

Product decisions recorded 2026-07-28 (David Bloom):

1. Release 1 is a **staff-only internal milestone**, not the Aug 2026 Bio beta
   gate.
2. Unit strip ships **navigation-only**, no unit evidence, rather than blocking
   on Biology labeling.
3. **Sharing is cut entirely** from this release and becomes a separate program.

The prototype at `/proto/home` remains the design reference for layout, voice,
and information order. Productionalizing means finishing the data, not
redesigning the component: `StudentHomeSnapshot` and `HomeV2` are structurally
correct, and the separation of the recommendation threshold from the trend
threshold, the opaque server-issued target, and the honest "Not sure" state
should all be preserved as-is.

Alignment: `docs/product/STUDENT_PORTAL_INTERACTION_DESIGN.md` §4.2 (Returning
Session) and `docs/architecture/PRODUCTION_PLUMBING_AND_CUTOVER_PLAN.md` §3
(environment and ownership split).

## QA Review

**QA Verdict:** Pending

## Done Decision

**Decision:** Pending
**Date:** YYYY-MM-DD
