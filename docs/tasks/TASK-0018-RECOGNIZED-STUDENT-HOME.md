# TASK-0018 — Recognized Student Home, Release 1 (`/home` V2)

**Task ID:** TASK-0018
**Title:** Recognized Student Home — Production staff validation of `/home` V2
**Owner:** Codex (cross-repo: backend/migrations in `Cramapple`; frontend in
`exam-buddy-wireframe`)
**Product Owner:** David Bloom
**Tier:** Hard-Gate
**Status:** Not Started
**Priority:** High
**Created Date:** 2026-07-28
**Approved Date:** Pending

---

## North-star Product Goal

An authenticated student who opens Cramapple lands on one page that knows who they
are, which subject they are studying, how long until their exam, and what to do
next — with **no invented progress**. Every learner-specific factual statement
on the page traces to a production record or is not shown at all. Generic
instructional and encouraging copy may be deterministic product copy.

Release 1 is a **staff-only internal milestone**: it builds and validates the
recognized-Home data contract, optional first-run surface, guarded rollout, and
broad subject-scoped session entry against real Production records behind a
server-side flag, before any student sees it. Personalized performance claims,
persisted exact-target infrastructure, and sharing are explicitly deferred (see
Out of Scope and §Release 2).

This task is complete only through staff validation; it does **not** by itself
make Home V2 the default student landing page. A later student-launch Hard Gate
must be approved and tracked before the north-star goal is considered shipped.

---

## Evidence base (verified 2026-07-28 and re-verified 2026-07-30 against
Production `pcntajvbdfqhbeewmdry`)

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

Net effect in Production today: `/home?home=v2` renders "Choose your subject"
for every user. Any environment that still has the same frontend code and lacks
the pending course-position table has the same or additional failures; do not
generalize the Production finding to an environment without checking it.

### Errors are swallowed, and some failure modes invent a state

All four queries destructure `{ data }` and ignore `error`, but the visible
failure depends on which query failed:

- the broken profile query produces `status: "no_subject"`;
- a course-position failure silently becomes `source: "unknown"`;
- attempt and session failures silently become zero evidence and can render a
  **returning student as brand new**, with `experienceStage: "new"`.

The last case is the "never invent progress" principle running in reverse and is
the highest-severity defect in the current implementation. The task must
distinguish legitimate absence from failed retrieval at every step.

### No attempt in Production has ever been scored

| Metric | Value |
| --- | --- |
| `app.attempts` rows | 42 |
| rows with `score_points` not null | **0** |
| rows with `graded_at` not null | **0** |
| `app.attempt_criterion_results` rows | **0** |
| `app.learning_sessions` rows | 23 |
| `app.progress_snapshots` rows | 0 (table exists) |
| `app.profiles` with `active_exam_pack_version_id` | 5 of 25 |

Breakdown: 30 `draft`/`frq`, 7 `submitted`/`mcq`, 5 `submitted`/`frq`, all
`assistance_state = 'independent'`, all `result_state` null. The most recent
submitted MCQ is 2026-07-29 02:01 UTC — the practice path is being exercised,
but **grading does not write back to `app.attempts`**, and MCQ scoring (which is
deterministic, `mcq_choices` exists) is not happening either.

### Unit taxonomy label layer now exists; legacy labels remain unvalidated

Historical note: at TASK-0018 launch, there was no units/topics table. Unit
membership lived in
`app.content_labels` (`label_type='unit'`, 30 labels across 4 exam packs) linked
by `app.content_item_labels`. Coverage of **published** items:

| Subject | Published items | With a unit label |
| --- | --- | --- |
| AP Biology | 95 | **0** |
| AP Statistics | 91 | 23 |
| AP Physics 1 | 19 | 0 |
| AP Physics 2 | 14 | 0 |
| AP Precalculus | 13 | 13 |
| AP Physics C (Mech) | 9 | 0 |
| AP Physics C (EM) | 8 | 0 |
| AP Chemistry | 8 | 0 |
| AP Calculus AB | 4 | 4 |
| AP Calculus BC | 2 | 2 |

Label keys are also inconsistent: AP Statistics uses `unit_1`…`unit_9`; Calculus
and Precalculus use `unit-1-limits-and-continuity`-style slugs. The unit list the
UI renders comes from a hardcoded client file, `src/data/taxonomy.ts`, with no
server-side mapping from label to unit number. These are point-in-time inventory
counts; re-query them immediately before implementation or approval rather than
treating the table as a durable launch metric.

Execution update 2026-08-04: `taxonomy_label_layer` created
`app.taxonomy_source_versions`, `app.taxonomy_topics`, and
`app.content_taxonomy_labels` in Production. The initial registry contains the
verified AP Biology 2026-2027 CED taxonomy, and legacy
`prompt_json.modules`/`subtopics` were backfilled as `legacy_unvalidated`
serving/coverage labels. These rows are not servable for unit-gated practice;
they are containment/audit records until validated labels supersede them.

Unit-serving update 2026-08-04: `unit_serving_registry` created
`app.taxonomy_units` and seeded human-verified unit maps for AP Biology,
Statistics, Calculus AB, Calculus BC, Chemistry, Physics 1, Physics 2, Physics C
Mechanics, Physics C E&M, and Precalculus. AP Statistics Home allowed units were
corrected to `[1,2,3,4,5]`; AP Precalculus Unit 4 is recorded as not
exam-assessed. `unit_gated_serving_selector` added
`public.select_unit_gated_practice_items`, which reads only validated
serving-scope labels, requires a matching taxonomy relevance hash, and ignores
topic/coverage labels. Biology and Statistics currently return 0 eligible items
at their final units because no serving labels have been validated yet; this is
the intended fail-closed state.

Serving rule locked 2026-08-04: multi-unit items are eligible only after the
student has reached the latest required unit. The canonical content record must
track all required units for an item; `primary_unit`, when present, is a label
or coverage convenience only. Student serving, reviewer packets that are scoped
by course position, and Home course-position eligibility derive
`max_required_unit = max(required_units)` and fail closed when the complete unit
set is unavailable. For MCQs, the required-unit set includes knowledge needed to
justify the keyed answer and reject each distractor.

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
  exists and is unused. It is null for **25 of 25** current profiles, so the
  fallback path—not the profile-timezone path—is the Release 1 norm and must be
  tested directly.
- `app.profiles.role` currently contains only `admin`, `reader`, `student`, and
  `tutor`, so an admin-only prototype guard is expressible. The existing
  authenticated/student guards do not perform that role authorization.
- `app.learning_sessions.status` currently contains `active` and `completed`;
  subject-switch blocking can use `status = 'active'` without inference.
- `src/hooks/use-student-guard.ts` already lets authenticated `/home` render
  without a subject, but its `requireSubject` mode redirects `/session/*` to
  `/setup/subject`. `src/routes/account-created.tsx` also routes new accounts to
  `/setup/subject`; both conflict with optional setup.
- `/proto/*` is publicly reachable and unauthenticated. The existing
  `src/routes/_authenticated/route.tsx` guard checks **authentication only**
  (no role) and redirects to `/tutor-login` — it cannot be reused as-is for
  admin gating.
- `app.profiles.role` values in Production are `admin`, `reader`, `student`,
  `tutor`. Admin gating is therefore implementable from the curated profile
  view without inventing a role.
- `app.profiles.timezone` is set for **0 of 25** profiles. Combined with the
  rule that a detected or fallback timezone must not be written without student
  action, the **fallback governs 100% of Release 1 traffic** — it is the path
  that must be tested, not the exception.
- `app.learning_sessions.status` values in Production are `active` and
  `completed`. "Has an active session" is expressible as
  `status = 'active'`; no new column is needed to block a subject switch.
- **10 exam-pack versions are published.** A first-run subject chooser keyed
  only on "published" would offer AP Calculus BC (2 published items) and AP
  Chemistry (8). Eligibility needs a content threshold — see §1.
- **`complete_onboarding` writes two things in one transaction.**
  `src/lib/active-subject.ts` documents an RPC that sets
  `active_exam_pack_version_id` **and** `onboarding_completed_at` together, and
  `onboarding_completed_at` has at least four consumers
  (`src/hooks/use-student-guard.ts`, `src/lib/active-subject.ts`,
  `src/routes/_ux.setup.index.tsx`, `src/routes/onboard.tsx`). Independent
  persistence of first-run answers cannot go through that RPC, and the column's
  meaning cannot be changed cheaply.
- **`useStudentGuard`'s `requireSubject` mode redirects `/session/*` to
  `/setup/subject`** when subject state is `none` or `invalid` — the exact
  prerequisite §2 forbids. Its *default* mode already renders `/home`
  regardless of subject state, so part of the §2 goal is already satisfied.
- **`src/integrations/supabase/auth-middleware.ts` is auto-generated**
  ("This file is automatically generated. Do not edit it directly.") and builds
  its client from `SUPABASE_PUBLISHABLE_KEY` plus the caller's JWT. A
  service-role client exists separately at
  `src/integrations/supabase/client.server.ts`, but
  `src/lib/dashboard.functions.ts` records that `SUPABASE_SERVICE_ROLE_KEY` may
  not be provisioned. Anything reading `app.session_targets` needs that
  provisioning and cannot live inside the generated middleware.
- **Live prototype defect:** on `/proto/home` at mobile width the recognition
  line ("Last session you worked on osmosis and earned the water-movement
  prediction criterion") renders near-black on the dark hero card and is
  effectively invisible. The floating "Prototype menu" pill also overlaps the
  "Open Unit 2" CTA. That sentence is the feature; it must be legible.

---

## Technical Scope — Release 1 (staff-only)

### 1. New-user journey — setup is optional

An authenticated first-time user lands on `/home`, not in a mandatory setup
funnel. Home must let the student start useful practice immediately while
making every setup choice adjustable inline or later from Account.

#### First-run states

1. **Trusted subject context exists.** If the account already has an active
   eligible exam-pack version from an invitation, an explicit signup choice, or
   prior saved state, greet the student in that subject and show `Start a quick
   session` immediately.
2. **Exactly one eligible subject exists.** Home may preselect it and clearly
   name it beside the CTA. The student can change it before starting.
3. **Multiple subjects exist and none is selected.** Home shows a compact,
   one-tap subject chooser above the CTA. Selecting a subject and starting may
   be one interaction. Do not guess from email, school, geography, or other
   indirect personal data.
4. **No eligible subject/content exists.** Show an honest unavailable state and
   a way back to subject selection; do not issue an empty or mislabeled target.

For Release 1, an **eligible subject** is an exam-pack version that:

- is published and not retired;
- is explicitly enabled in the server-owned Home quick-start release manifest;
- has at least the proposed launch threshold `QUICK_START_MIN_ITEMS = 10`
  distinct published items compatible with an enabled subject-scoped
  session-serving path; and
- passes a live resolver check that a default quick session can be assembled.

The inventory threshold is a launch buffer, not a learning-quality or mastery
claim; confirm the value at scope approval, re-query inventory at approval, and
fail the subject closed if the serving check errors. Eligibility is
intentionally separate from
`capability.criterionStarter`: a subject may support a broad starter while
criterion-level recognition remains disabled because grading is unverified.
This distinction keeps D1 from making every Release 1 subject ineligible.

Subject is the minimum practice-routing input, not a prerequisite onboarding
screen. If the server lacks trustworthy subject context, “Skip all” takes the
student to the first-run Home with the subject chooser; one subject tap is still
required before valid subject-specific content can start.

#### Optional setup, with safe defaults

- Every optional control is independently skippable; there is no all-or-nothing
  setup submission.
- Name is optional for this journey; use a nameless greeting when absent.
- Course position is optional. Default to and preserve `Not sure`; never infer
  or persist Unit 1.
- Available time is optional. Use a visible, adjustable **15-minute session
  default** for planning; record it only when the student starts or explicitly
  changes it.
- Registration status, immediate goal, diagnostic/calibration choice, and
  learner-entered exam date do not gate practice.
- The official exam date comes from the selected exam-pack specification.
- Timezone may use the documented safe fallback for countdown display, but a
  detected or fallback timezone must not overwrite the profile without the
  student's action.

Countdown timezone resolution is deterministic and testable:

1. use `app.profiles.timezone` when it is a valid IANA timezone;
2. otherwise use a validated browser-reported IANA timezone for that request;
3. if neither is available or valid, use `UTC`.

Browser detection and the UTC fallback are display inputs only and are never
persisted implicitly.

The first-run Home offers three nonblocking actions:

- `Start a quick session` — uses the selected/trusted subject, broad
  subject-scoped targeting, `Not sure` course position, and the visible default
  duration.
- `Adjust session` — inline subject, course-position, and duration controls.
- `Skip for now` — dismisses optional setup guidance and leaves the user on
  Home; it never sends them back into setup on the next route.

Persist each explicit answer independently. Missing optional values remain null
or unknown, not fabricated defaults. Preserve the existing
`onboarding_completed_at` meaning and `complete_onboarding` RPC contract; do not
repurpose either for the new journey. First-run subject selection uses the
existing `set_active_exam_pack_version` RPC. Persist `Skip for now` separately
as `app.profiles.first_run_dismissed_at` through a narrow own-user server/RPC
write so dismissal works across devices without overloading onboarding state.

#### First-session transition

`Home first run → subject resolved → target issued → session created → practice
→ session completed/interrupted → Home`

- Issue the target only after subject resolution.
- If target issuance or session creation fails, keep the student's explicit
  selections and show a retryable error; do not mark setup complete or create a
  phantom session.
- An interrupted first session takes recovery priority on return.
- Before D1 grading is available, session completion may be acknowledged as
  activity (“First session complete”) but must not be described as measured
  progress, improvement, mastery, or readiness.
- Optional setup stays reachable later from Home/Account without resetting
  attempts, targets, or course position.

### 2. Route and access

- Add an auth guard so `/home` requires an authenticated Supabase session.
- Redirect an unauthenticated request to `/login` with a validated, same-origin
  return path; do not render the student shell while auth is unresolved.
- Route every authenticated user to Home. Preserve recovery priority:
  interrupted session → Home first-run/subject resolution → returning Home.
  Incomplete optional setup never forces a `/setup` redirect.
- The default mode of `src/hooks/use-student-guard.ts` already admits `/home`
  regardless of subject state; preserve it. Change its `requireSubject` branch
  so direct `/session/*` entry with no valid subject returns to
  `/home?intent=start`, where the inline subject chooser can resolve the
  minimum input, rather than redirecting into mandatory `/setup/subject`.
- Change the post-account route in `src/routes/account-created.tsx` from
  `/setup/subject` to `/home`.
- Keep `/setup` as an optional, recoverable adjustment surface during
  transition; it may not be a prerequisite for `/home` or session start.
- Keep `noindex, nofollow`.
- Gate `/proto/*` behind authenticated **admin** authorization **now** (not at
  cutover). It is currently public. Resolve authorization from
  `app.profiles.role`/the curated profile view, never from user-editable Auth
  `user_metadata`. Tutors, readers, and ordinary students are denied by default.
  The existing `_authenticated`/default student guard proves authentication
  only; add a distinct role-aware guard for prototype routes.
- Keep `/proto/home` reachable by staff for comparison; redirect to `/home` only
  after Release 2 parity.

### 3. Server-side feature flag

- Add a private, per-user rollout assignment rather than adding a product flag
  column to `profiles`. Recommended shape:
  `app.feature_flag_assignments(feature_key, user_id, enabled, expires_at, ...)`
  with own-row read and service/admin-only writes, exposed only through a
  `security_invoker` curated view or an equivalent current-user resolver.
- Add a server-side global kill switch. The effective flag is on only when both
  the kill switch and the current user's assignment are on.
- Retain the existing `?home=v2` / localStorage override **only in local and
  preview development**. Ignore it in Production; otherwise any student can
  bypass the staff-only milestone.
- Flag-resolution failure fails closed to Home V1 and emits a structured server
  error. Without this, the rollout and rollback steps below cannot be executed
  safely.

### 4. Fix and harden the snapshot contract

`StudentHomeSnapshot` in `src/lib/home-snapshot.ts` is a useful starting
contract, not a frozen Production contract. Preserve the broad stage model, but
create an explicit Release 1 snapshot profile (for example,
`snapshotVersion: "home-v2"`) that excludes unsupported learner evidence and
replaces synthetic targets:

- `profiles` → filter on `user_id`.
- `sessions` → `learning_sessions`, using `status` / `started_at` / `ended_at`
  and `practice_format` (adding `practice_format` to `public.learning_sessions`
  first — see “Units and subject switching”).
- `attempts` → select `learning_session_id`, `content_item_version_id`,
  `assistance_state`, `attempt_mode`, `score_points`, `score_possible`,
  `graded_at`, `result_state`, `exam_pack_version_id`.
- Read real assistance and score fields wherever they exist.
- Do not hardcode `isRetry: false`. Until D1 defines and persists retry lineage,
  retry-sensitive evidence is ineligible for Production aggregation; the
  `building_signal` stage and personalized evidence remain fixture-only.
- Scope every subject-dependent session, attempt, content, course-position, and
  target query to the active `exam_pack_version_id`.
- **Check `error` on every query.** Add a distinct
  `status: "degraded"` so a query failure renders an explicit "we can't show
  your progress right now" state and **never** `experienceStage: "new"`.
  `no_subject` is reserved for a successful profile read whose active selection
  is genuinely null. In the UI, that is a valid first-run `needs_subject`
  experience rather than an error or a redirect to mandatory setup.
- Identity: prefer `app.profiles.full_name`; fall back to a nameless greeting.
  Never render an email local part.
- Exam countdown: compute the calendar-day difference between the date-only
  official exam date and “today” using the explicit resolution order:
  valid `app.profiles.timezone` → validated browser-reported IANA timezone →
  `UTC`. Contract-test all three branches, including invalid profile/browser
  values. Do not convert the exam date into a UTC instant and subtract elapsed
  milliseconds, and do not persist a detected/fallback timezone.
- Replace the hardcoded `CRITERION_STARTER_SUBJECTS` list with an authoritative
  capability gate for the active exam-pack version. Published content counts
  alone are insufficient: the gate also requires a compatible serving path,
  rubric/criteria availability, and verified grading. Default the capability to
  false when any requirement is unknown. Because D1 is unresolved,
  criterion-level starter promises remain off in Release 1 Production.
- Log structured failure stage/code and a request correlation ID without
  student names, email addresses, response text, or other unnecessary learner
  data.

### 5. Migration

- **Rewrite**, do not simply move,
  `supabase/pending/20260727120000_home_course_position_and_targets.sql`. The
  pending file creates new base tables in `public`, which conflicts with the
  approved architecture: authoritative application tables live in `app`; only
  a curated interface is exposed in `public`. Split out and defer the
  `session_targets` portion; TASK-0018 migrates course position only.
- Name the authoritative table **`app.student_course_positions`** (plural),
  scoped uniquely to `(user_id, exam_pack_version_id)`, with foreign keys to the
  authoritative profile/exam-pack tables. Change the frontend query from the
  pending/current singular `student_course_position` name. Expose only the
  columns needed by the student app through a `security_invoker` curated view
  (or a narrow validated write function), with explicit authenticated grants
  and own-row RLS.
- Add `app.profiles.first_run_dismissed_at` plus a narrow authenticated own-user
  setter if dismissal persistence remains part of the approved journey.
- Course-position writes must validate that the requested unit exists in the
  active subject's canonical taxonomy in `app.taxonomy_units`; ownership plus
  `unit_id > 0` or a client hardcoded unit list is not sufficient validation.
- Item eligibility against course position must use all required units. For a
  multi-unit item, serve only when `student_current_unit >= max_required_unit`;
  never use the first, lowest, or primary unit as the eligibility gate.
- Unit-gated practice must use validated serving-scope taxonomy labels with a
  current taxonomy relevance hash, via `public.select_unit_gated_practice_items`
  or an equivalent server-owned selector. Topic-level coverage labels are not a
  serving signal.
- Apply to **Development** first (`wmgjsdkphcyhngaffbqf`), then Production by
  explicit approval. Note the Dev migration-history reconciliation of
  2026-07-15 — do not `db push`.
- Generate the authoritative migration from the `Cramapple` repository, not the
  frontend repository's `supabase/pending` directory. Run database advisors and
  explicit authenticated/cross-user RLS tests before the Production gate.
- Do **not** add `repair_of_attempt_id` or `attempt_sequence` in Release 1.
  First decide in the grading workstream whether repair lineage belongs between
  attempts or between response versions. That schema decision is part of D1 /
  Release 2 and should not be guessed by Home.

### 6. Recognition (evidence-backed, deterministic templates)

Release 1 Production covers the `new` structure. The `building_signal`
structure still requires qualifying graded attempts, so it is contract-tested
with fixtures but is not claimed as Production-verified until D1 lands:

- No evidence: "Let's get your first useful signal."
- Fixture-only until D1: one or two graded answers → "You've got one graded
  answer in. One more short session will help us identify a specific gap."
- Interrupted session: "Pick up where you left off." (resume URL derived from
  the live session's actual `practice_format` — never assumed `/session/mcq`)

No generated motivational copy. No mastery, readiness, or AP-score implication
from any number of answers.

### 7. Units and subject switching — navigation only

Per the 2026-07-28 decision, Release 1 ships the unit strip as **navigation**:

- The strip changes the selected unit and opens that unit's detail.
- Release 1 unit detail is navigation-only. It may show vetted catalog identity
  (unit title and position), but must not imply progress, mastery, or
  educational guidance that is not backed by an approved source.
- **No per-unit point capture, no per-unit fractions, no completion
  percentages.** `computeUnitPointCapture` is not wired in Release 1.
- The practice CTA is scoped to **subject**, not unit, and its copy must not
  imply unit-specific targeting.
- Unit names derive from `src/data/taxonomy.ts` for now; a server-side
  label→unit mapping is Release 2 work and depends on unit labeling.
- Unit-scoped practice or reviewer packets must use the complete required-unit
  set. If an item draws on Units 1 and 3, it belongs behind the Unit 3 gate for
  serving, even if its primary label is Unit 1.
- Show `SubjectSwitcher` only when two or more published subjects are available.
- Persist course position per `(user, exam_pack_version)` via
  `setCoursePosition`; `unitId: null` records an honest "Not sure" and never
  silently selects Unit 1.
- On subject switch: clear the previous subject's cached content, session state,
  and prototype storage only after the server confirms the new selection.
- If the current subject has an active learning session, Release 1 blocks the
  switch and offers `Resume session` / `End session first`. It must not silently
  abandon or merely hide a server-side session. Use the authoritative predicate
  `app.learning_sessions.status = 'active'`. A later task may define a
  cross-subject resumable-session policy.
- Define a pre-migration Release 1 public-interface manifest, then refresh only
  the named stale view columns. `learning_sessions.practice_format` is the only
  presently identified addition; stale rubric/evaluator columns are not
  automatically in scope while the Production capability gate remains false.

### 8. Broad subject-scoped starter CTA

Persisted server-issued target lifecycle work is not required to validate
Release 1 recognition and is removed from this task's critical path. Release 1
reuses and hardens the existing subject-scoped session setup/start path:

- pass only the active eligible exam-pack version and visible quick-session
  defaults into setup/start;
- revalidate the user's active subject, quick-start eligibility, and published
  content availability at session creation;
- let the existing server-owned serving path select compatible published
  content; never accept arbitrary client-resolved content IDs;
- return a retryable error without a phantom session when compatible content
  cannot be assembled; and
- do not imply unit-, item-, criterion-, or personalized targeting.

The Home CTA may promise only what this path guarantees, for example, `Start a
quick AP Biology session`. It must not claim that Home has selected a specific
skill or exact content set.

### 9. Prototype defect fixes

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
- **Repair-lineage schema changes.** Release 2 / the grading workstream must
  decide whether repair is a new attempt or a new response version before a
  column is designed.
- **Persisted server-issued session targets.** Move `app.session_targets`,
  opaque target UUIDs, ownership/version/status/expiry validation, transactional
  single consumption, idempotent retry, and retired-content fallback into a
  separate follow-on task (proposed TASK-0019). That task must first verify
  `SUPABASE_SERVICE_ROLE_KEY` in the Vercel server environment and place any
  privileged adapter beside—not inside—the generated
  `src/integrations/supabase/auth-middleware.ts`. The current authenticated
  middleware uses the user's JWT and cannot access a table whose
  `authenticated` grants are revoked.
- **Student-facing rollout.** Release 1 ends at staff accounts.
- Scheduled `progress_snapshot` materialization. The table already exists; the
  first implementation must remain reproducible from source records.

---

## Blocking dependencies

### D1 — Grading must write back to student evidence records (blocks
`building_signal` Production verification and Release 2)

Zero of 42 Production attempts carry `score_points`, `graded_at`, or a
`result_state`, and `attempt_criterion_results` is empty. Until that write path
is verified in Production, **no factual performance statement and no
criterion-level recognition can be built**. This is owned by the grading
workstream (`docs/GRADING_ENGINES_TO_PRODUCTION_HANDOFF.md`), not by Home.
Deterministic MCQ scoring is the cheapest first win and should be treated as
separable from FRQ engine work. That workstream must also define durable repair
lineage; Home must not infer it from timestamps.

### D2 — validated serving labels (blocks Release 2 unit evidence)

Production now has a canonical unit registry and fail-closed unit-serving
selector, but no published Biology or Statistics item is eligible until
serving-scope labels are validated against current content hashes. Legacy
`prompt_json.modules`/`subtopics` and historical `content_labels` are
provenance only. The next blocker is automated unit-label validation that writes
`required_units`, `primary_unit`, and `max_required_unit` for serving scope; topic
coverage remains a separate, deferred workstream.

### Release 1 observability baseline (not a blocker)

The long-term observability provider remains undecided, but Release 1 does not
need to wait for that decision. Emit structured, PII-minimized events to the
existing Vercel server log destination with request correlation IDs and verify
they are searchable during staff QA. A dedicated provider remains follow-up
work. Any Management API log collector added later must use Supabase's current
`logs` endpoint rather than the retiring `logs.all` endpoint.

---

## Routes / Components / Systems Affected

- `src/routes/_ux.tsx` (auth guard), `src/routes/_ux.home.tsx`
- the existing `/setup` route and Account setup/preferences entry point
- `src/routes/account-created.tsx`, `src/hooks/use-student-guard.ts`, and a new
  role-aware prototype-route guard
- `src/components/home/HomeV2.tsx`
- `src/lib/home.functions.ts`, `src/lib/home-snapshot.ts`
- `src/lib/feature-flags.ts` (server-side flag)
- `src/lib/subject-key.ts`, `src/data/taxonomy.ts`
- `src/components/ux/SubjectSwitcher.tsx`, `set_active_exam_pack_version` RPC
- `src/routes/proto.*` (staff gating)
- `src/routes/session.setup.tsx` and the existing server-owned subject-scoped
  session-start path
- `supabase/pending/20260727120000_home_course_position_and_targets.sql`
- authoritative migrations in this `Cramapple` repository
- `app.student_course_positions`, `app.profiles.first_run_dismissed_at`,
  `app.feature_flag_assignments`
- curated `public` views/RPCs including `public.learning_sessions`

---

## Data / Security / Integration Impact

- New authoritative tables in `app`: `student_course_positions` (own-row RLS)
  and the private rollout-assignment table. Add the separately named first-run
  dismissal timestamp to `app.profiles`. Do not add these as `public` base
  tables.
- No `app.attempts` lineage change in Release 1.
- `public.*` view recreation — must preserve `security_invoker=true`.
- Supabase is moving toward requiring tables to opt into the Data API; grants
  must be explicit.
- No service-role key or provider secret may reach the browser.
- Existing optional profile values may remain null/unknown after first use.
  Neither `onboarding_completed_at`, `first_run_dismissed_at`, nor client
  defaults authorize the server to fabricate or persist name, timezone, course
  position, duration, or subject.

---

## Acceptance Criteria

- [ ] `/home` requires an authenticated session and is `noindex, nofollow`.
- [ ] A newly authenticated user reaches `/home` regardless of
      `onboarding_completed_at`; incomplete optional setup never forces a setup
      redirect.
- [ ] With a trusted or sole eligible subject, a first-time student can start a
      valid quick session directly from Home without completing setup.
- [ ] With multiple eligible subjects and no trusted selection, Home requires
      only a one-tap subject choice before start and does not infer a subject
      from indirect personal data.
- [ ] Quick-start eligibility requires a published/non-retired exam pack,
      explicit server release enablement, at least 10 compatible published
      items, and a successful serving-resolver check; it is tested separately
      from `capability.criterionStarter`.
- [ ] `Skip for now` dismisses optional setup guidance without creating a
      re-prompt loop; optional setup remains reachable from Home/Account.
- [ ] First-run subject choice uses `set_active_exam_pack_version`; the existing
      `complete_onboarding` transaction and `onboarding_completed_at` meaning
      remain unchanged. Dismissal, if selected, writes only the distinct
      `first_run_dismissed_at`.
- [ ] A student may save any subset of optional choices without being required
      to complete the rest, and later edits do not reset their learning state.
- [ ] Untouched course position remains `Not sure`, the visible default
      duration is not persisted before start, and detected/fallback timezone is
      not written to the profile without student action.
- [ ] `/proto/*` requires authenticated `admin` authorization; students,
      tutors, readers, and unauthenticated users are denied.
- [ ] Prototype authorization uses a new role-aware guard; the existing
      authentication-only guard is not treated as staff authorization.
- [ ] `home-v2` can be enabled per user account server-side, has a global kill
      switch, fails closed, and cannot be forced by query string/localStorage in
      Production.
- [ ] `loadStudentHome` returns `status: "ready"` for a real Production staff
      account with an `active_exam_pack_version_id` (this currently fails for
      every user).
- [ ] Every Supabase query in the snapshot path checks `error`; a failure yields
      an explicit degraded state and **never** `experienceStage: "new"`.
- [ ] The greeting uses `profiles.full_name` or no name — never an email
      fragment.
- [ ] The exam countdown uses valid `profiles.timezone` when set, otherwise a
      validated browser IANA timezone, otherwise `UTC`; all three branches plus
      invalid profile/browser values have contract tests.
- [ ] `capability.criterionStarter` is controlled by an authoritative,
      exam-pack-version capability gate; it is false when grading/serving
      verification is absent and is not inferred from subject name or raw
      content count alone.
- [ ] A student with zero graded attempts sees the `new` structure with no
      percentages, no zeroes, no fake bars, and no trend language.
- [ ] No percentage or trend is displayed anywhere in Release 1.
- [ ] The unit strip changes the selected unit and opens unit detail, and
      displays **no** per-unit progress values.
- [ ] "Not sure" persists as an honest unknown course position and never
      resolves to Unit 1.
- [ ] The primary CTA starts a broad session in the named active subject through
      the existing server-owned serving path, after server-side eligibility and
      published-content revalidation; it makes no more specific recommendation.
- [ ] If the subject-scoped server path cannot assemble compatible content, no
      learning session is created and the student receives a retryable error.
- [ ] Switching Biology → Statistics never flashes Biology units,
      recommendations, or cached attempt data under Statistics.
- [ ] A subject switch is blocked while the current subject has an active
      session and offers Resume / End session first; no active session is
      silently abandoned or hidden. “Active” is
      `app.learning_sessions.status = 'active'`.
- [ ] Session resume uses the live session's real `practice_format`.
- [ ] The recognition line is legible at mobile width in both hero treatments,
      and no floating element overlaps a CTA.
- [ ] The rewritten migration is in the authoritative `Cramapple` history,
      creates authoritative objects in `app` rather than `public`, is applied to
      Development, passes advisors/RLS tests, and leaves Production application
      as a separate approved step.
- [ ] The old Home remains a one-click rollback for the duration of the release.

---

## QA Plan

- **Manual QA:** Development first; then an admin account on Production behind
  the flag only after the Production-application gate. Cover mobile (375px),
  keyboard-only, screen reader, slow-network / offline-recovery.
- **Automated tests — contract tests** for: first login with trusted subject,
  first login with one eligible subject, first login with multiple subjects,
  skip-all optional setup, partial setup, `new`, sparse evidence, personalized
  (fixture-only until D1 lands), missing/unsupported subject, subject switch,
  interrupted first session, target-start failure with selection recovery, and
  **degraded / query-failure**. The degraded case remains the most important
  data-integrity case.
- **Fixtures:** use pure contract fixtures for `building_signal` and
  `personalized` until D1 defines the authoritative write path. Do not make this
  task invent a parallel graded-attempt seeder. An integration seed, if needed,
  must reuse the grading workstream's canonical development fixture path and
  never run against Production.
- **Regression areas:** signup/login return routing, `SubjectSwitcher` +
  `set_active_exam_pack_version`, session setup/resume, optional `/setup`
  recovery, Account edits, and existing `/home` v1.
- **Failure cases:** snapshot query error, missing `active_exam_pack_version_id`,
  retired exam pack, elapsed exam date (off-season), zero published content for
  the active subject, subject switch mid-session, and target creation failure
  after an explicit first-run choice.
- **Security/data checks:** cross-user read/write denied on
  `app.student_course_positions`; first-run dismissal can update only the
  authenticated user's profile; rollout assignments are not user-writable; no
  service-role key is present in the client bundle; `security_invoker` is
  preserved on recreated views; unit/course-position validation rejects a unit
  outside the active subject.

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
**Approval Type:** Hard Gate
**Decision:** Pending

Execution has separate gates:

1. **Scope approval:** authorizes implementation and Development-only testing.
2. **Production data/config approval:** authorizes the reviewed migrations,
   curated-view changes, server flag assignment, and Production deployment.
3. **Staff enablement approval:** authorizes enabling Home V2 for named admin
   accounts after Production verification.
4. **Student launch approval:** explicitly not part of Release 1; it requires a
   later Hard Gate after D1/D2, Release 2 QA, and risk review.

---

## Implementation Notes

Product decisions recorded 2026-07-28 (David Bloom):

1. Release 1 is a **staff-only internal milestone**, not the Aug 2026 Bio beta
   gate.
2. Unit strip ships **navigation-only**, no unit evidence, rather than blocking
   on Biology labeling.
3. **Sharing is cut entirely** from this release and becomes a separate program.

New-user decision recorded 2026-07-30 (David Bloom):

- Mandatory post-login setup is removed. The authenticated landing page is
  Home, optional setup is inline/deferrable, and the student may start with safe
  visible defaults.
- The prior proposed “one composed setup surface” becomes the expanded
  `Adjust session` experience, not a route gate. Its recoverability and
  accessibility requirements still apply.
- Subject is resolved just in time because valid content cannot be issued
  without it. Trusted/sole-subject context permits immediate start; otherwise
  the irreducible interaction is one explicit subject tap.

The prototype at `/proto/home` remains the design reference for layout, voice,
and information order. Productionalizing means finishing the data, not
redesigning the component. `StudentHomeSnapshot` and `HomeV2` are useful
starting points, but they are not preserved literally:

- Release 1 must suppress point-capture/personalized fields it cannot support;
- synthetic `starter:*` identifiers must not be treated as persisted contracts
  or used to make exact-target claims in Release 1; persisted targets are
  deferred to the proposed TASK-0019;
- `criterionStarter` must fail closed behind an authoritative capability gate;
- the honest "Not sure" state and the separation of recommendation and trend
  thresholds remain valid design decisions.

Alignment: `docs/product/STUDENT_PORTAL_INTERACTION_DESIGN.md` §4.1–4.2
(first/returning sessions) and
`docs/architecture/PRODUCTION_PLUMBING_AND_CUTOVER_PLAN.md` §3 (environment and
ownership split). TASK-0018's 2026-07-30 new-user decision supersedes any
mandatory-setup interpretation in the earlier UX proposal; reconcile those
source documents before implementation.

## QA Review

**QA Verdict:** Pending

## Done Decision

**Decision:** Pending
**Date:** YYYY-MM-DD
