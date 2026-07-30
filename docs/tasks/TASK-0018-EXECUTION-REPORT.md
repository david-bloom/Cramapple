# TASK-0018 — Recognized Student Home Release 1: Execution Report

**Execution date:** 2026-07-30

**Environment changed:** Development (`wmgjsdkphcyhngaffbqf`) only

**Production changed:** No

**Overall task status:** In Progress — Development implementation and contract
QA complete; Production staff-validation and activation gates remain open.

## Delivered

- Optional first-run Home journey with `Start a quick session`,
  `Adjust session`, and a separately persisted `Skip for now`.
- Subject resolution for trusted active subject, sole eligible subject,
  multiple eligible subjects, and no eligible subject.
- Server-owned, fail-closed rollout requiring both the private global
  `HOME_V2_GLOBAL_ENABLED` setting and an unexpired per-user assignment.
- Profile-name greeting without email inference; deterministic profile,
  browser, then UTC timezone resolution without implicit persistence.
- Honest Release 1 activity acknowledgement and active-session recovery; no
  unsupported mastery, readiness, progress, or performance claims.
- Adjustable duration, optional/unknown course position, subject switching,
  and navigation-only unit detail.
- Authenticated `/home`, safe login return paths, admin-only `/proto/*`, and
  optional setup after account creation.
- Active learning-session subject-switch blocking with explicit recovery/end
  actions.

## Database contract

The following forward-only migrations were applied to Development:

1. `20260730181732_recognized_student_home_release_1.sql`
2. `20260730183313_recognized_home_subject_key_compatibility.sql`
3. `20260730183354_fix_home_course_position_conflict_target.sql`
4. `20260730183551_harden_home_rpcs_and_indexes.sql`
5. `20260730184213_fix_home_quick_start_distinct_items.sql`

The contract adds the Home release manifest, own-row rollout assignments,
own-row course positions, narrow own-user RPCs, active-session switching
protection, and the Data API views required by the frontend. User-facing
mutations are `SECURITY INVOKER`; RLS and explicit grants remain authoritative.

Quick-start eligibility counts distinct published MCQ content items, not item
versions. The Home broad-start route uses MCQ content, so other item types do
not inflate the threshold.

## Development evidence

- Rollback-only SQL integration test passed, including own-row isolation,
  unknown course position, manifest unit validation, first-run dismissal,
  active-session switch blocking, explicit session completion, and restricted
  rollout-assignment writes.
- Supabase schema lint completed. Its only warning is the pre-existing,
  unrelated `app.content_publication_gate_status` `text`/`text[]` warning.
- Security advisor: no TASK-0018 notices.
- Performance advisor: three new FK-supporting indexes are reported as unused
  at INFO level, expected before rollout traffic exists.
- Development inventory after migration:
  - `ap-statistics`: 1 compatible published MCQ; not eligible.
  - `biology`: 0 compatible published MCQs; not eligible.
  - Both manifest rows have `quick_start_enabled = false`.
  - Zero `home-v2` user assignments.

## Frontend evidence

- Production build passed.
- TypeScript `--noEmit` passed.
- Targeted ESLint passed.
- Full Vitest suite passed: 15 files, 156 tests.
- Public build scan found no service-role key marker.
- Browser QA verified:
  - unauthenticated `/home?home=v2` redirects to
    `/login?returnTo=%2Fhome%3Fhome%3Dv2`;
  - unauthenticated `/proto/home` redirects to
    `/login?returnTo=%2Fproto%2Fhome`;
  - the prototype guard was checked at desktop and mobile viewport sizes.

`npm ci` could not be used because `package.json` and the committed lockfile
already disagree. Verification used the existing dependency installation and
did not rewrite the lockfile. The build also reports pre-existing deprecated
`inputValidator()` calls outside TASK-0018 and a route-discovery warning for a
test file stored below `src/routes`.

## Remaining hard gates

TASK-0018 must not be marked Done or enabled for students until all of these
are satisfied:

1. Publish at least 10 distinct compatible MCQs for a candidate subject and
   prove the live default quick-session serving path can assemble a session.
2. Explicitly enable that exam-pack version in the Home release manifest.
3. Approve and apply the migrations to Production.
4. Configure the private Production global flag and assign only named staff
   users.
5. Run authenticated staff QA against real Production records, including
   first-run start, dismissal, return, active-session recovery, subject
   switching, empty/degraded states, and mobile layout.
6. Record product-owner approval. A separate student-launch hard gate is still
   required before Home V2 becomes the default student experience.
