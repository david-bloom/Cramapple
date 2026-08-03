# TASK-0018 — Production staff QA script

**Purpose:** Hard Gate item 6 — authenticated Production staff QA across first-run,
skip, switch, resume/end, degraded and mobile states.
**Precondition:** the migration batch is applied to Production, the manifest row is
enabled, and the tester holds a `home-v2` flag assignment.
**Environment:** Production (`pcntajvbdfqhbeewmdry`), real authenticated session.

Home V2 is dark unless **both** gates pass, so nothing here is visible to students
during testing:

1. `HOME_V2_GLOBAL_ENABLED=true` in the Vercel server environment, and
2. a row in `app.feature_flag_assignments` for `feature_key='home-v2'` naming the
   tester's `user_id`, `enabled=true`, `expires_at` null or in the future.

Every failure path returns `enabled:false` — env unset gives `global_off`, a query
error gives `error`, a missing row gives `unassigned`. It fails closed.

---

## Setup

### S1. Enable the manifest row (once)

```sql
insert into app.home_release_manifest (
  exam_pack_version_id, quick_start_enabled, minimum_published_items,
  allowed_unit_numbers, criterion_starter_enabled, updated_by
) values (
  '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7',  -- AP Biology, 2026, published, 56 serveable MCQs
  true, 10, '{}'::integer[], false,
  (select user_id from app.profiles where role='admin' limit 1)
)
on conflict (exam_pack_version_id) do update
  set quick_start_enabled = excluded.quick_start_enabled,
      minimum_published_items = excluded.minimum_published_items,
      updated_by = excluded.updated_by,
      updated_at = now();
```

Confirm eligibility resolves true before testing anything else:

```sql
select subject_key, compatible_published_items, minimum_published_items, eligible
from public.home_quick_start_subjects
where exam_pack_version_id = '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7';
-- expect: biology | 56 | 10 | t
```

`allowed_unit_numbers = '{}'` is deliberate — Biology has **zero unit-labelled
published items**, so unit scoping must stay off. `criterion_starter_enabled=false`
for the same reason: no criterion-level promise until the evidence exists.

### S2. Assign the flag to each tester

```sql
insert into app.feature_flag_assignments (feature_key, user_id, enabled, expires_at, assigned_by)
values ('home-v2', '<TESTER_USER_ID>', true, now() + interval '7 days',
        (select user_id from app.profiles where role='admin' limit 1))
on conflict (feature_key, user_id) do update
  set enabled = true, expires_at = excluded.expires_at, updated_at = now();
```

Use a 7-day expiry so a forgotten assignment self-revokes.

### S3. Reset a tester to first-run (repeatable)

```sql
-- capture current values first if the account is in use
update app.profiles
set active_exam_pack_version_id = null,
    onboarding_completed_at = null,
    first_run_dismissed_at = null
where user_id = '<TESTER_USER_ID>';
```

Do **not** delete accounts to reset them. `app.profiles` has 70 inbound foreign
keys; 11 cascade and ~59 are `NO ACTION`, so deletion either fails or silently
destroys review history.

### Available reset accounts

Already at first-run state as of 2026-07-31: **Orly Bloom**, **Micah Bloom**,
**ibtisam mohammed** (all `role='student'`, no attempts, no sessions).

---

## Scenarios

Record for each: pass/fail, what was observed, and a screenshot for anything visual.

### 1. First-run, no subject

**Setup:** S3 on the tester. **Go to** `/home`.

- [ ] Page renders authenticated; no redirect to `/setup/subject`
- [ ] Greeting uses the profile's real name, **never** an email fragment
- [ ] Subject picker offered inline; setup is skippable, not a gate
- [ ] No progress figures, no zeroes, no empty bars, no percentages
- [ ] No trend or mastery language anywhere

### 2. Skip setup

**From scenario 1**, dismiss the first-run surface without choosing a subject.

- [ ] Home still renders, still usable
- [ ] `first_run_dismissed_at` is set (verify in DB)
- [ ] Reload does not re-show the first-run surface
- [ ] A practice CTA is still reachable, or its absence is explained honestly

### 3. Subject selection and quick start

Select AP Biology, then start practice.

- [ ] Selecting the subject persists `active_exam_pack_version_id`
- [ ] Navigation to the session route succeeds — **no bounce back to Home**
      *(this was P1-2: Home wrote the subject but the canonical active-subject
      cache still returned `none`, so the session route redirected back)*
- [ ] The session serves a real published MCQ, not an empty set
      *(P1-4: eligibility counted MCQs the runner could not serve)*
- [ ] Exactly **one** `app.learning_sessions` row is created — check before/after:
      `select count(*) from app.learning_sessions where user_id='<TESTER>';`
- [ ] Double-clicking Start does not create a second session
- [ ] Opening Start in two tabs does not create two active sessions

### 4. Resume an interrupted session

Answer one question, then navigate away without finishing. Return to `/home`.

- [ ] Home offers resume, not a fresh start
- [ ] Resume lands on the **format-correct** route — MCQ session to the MCQ runner,
      FRQ to the FRQ runner *(P1-5: `practice_format` was null or unroutable, so
      resume fell through to `/session` and bounced to setup)*
- [ ] The resumed session is the same `learning_session_id`, not a new row

### 5. End a session

Complete or end the session.

- [ ] The exact session that was started transitions to `completed` — confirm by id
- [ ] No `active` session is left behind:
      `select id,status from app.learning_sessions where user_id='<TESTER>' order by started_at desc limit 5;`
- [ ] Completion page says only what is supported — "Session complete."
- [ ] **No** claims of retry, retention, spaced review, mastery, or "that point held
      up" *(P1-6: the page fabricated all four after a single MCQ)*

### 6. Subject switch

With two or more published subjects available, switch Biology → Statistics.

- [ ] Switcher appears only when ≥2 published subjects exist
- [ ] After switching, **no** Biology units, recommendations or attempt data appear
      under Statistics
- [ ] Starting practice serves Statistics content, not Biology
- [ ] Switching with an active session prompts for confirmation first
- [ ] Switching back returns coherent Biology state

### 7. Cross-user cache isolation

The most important security check. In **one browser tab, without a full reload**:
sign out as tester A, sign in as tester B.

- [ ] Home shows B's name, B's subject, B's activity — **never** A's
- [ ] The rollout flag re-resolves for B; if B has no assignment, B sees Home V1
      *(P1-1: both queries used global keys, so B briefly saw A's snapshot and
      inherited A's Home V2 eligibility)*

### 8. Degraded state

Simulate a failed read — block the server function in devtools, or temporarily
revoke a grant on a Development copy. **Do not break Production to test this.**

- [ ] Home shows an explicit "can't load right now" state
- [ ] It does **not** render as a new student with zero evidence
      *(this was the highest-severity defect in the original implementation:
      swallowed errors turned a returning student into a brand-new one)*
- [ ] Retry works once the fault is removed
- [ ] No raw Postgres or PostgREST error text is visible in the UI

### 9. Mobile

Repeat scenarios 1, 3 and 5 at 375 px width.

- [ ] The recognition line is legible — sufficient contrast on the dark hero card
      *(the prototype rendered it near-black on dark, effectively invisible; that
      sentence is the entire feature)*
- [ ] No floating element overlaps a CTA
- [ ] Primary CTA reachable without horizontal scroll
- [ ] Page body never scrolls horizontally

### 10. Accessibility

- [ ] Full keyboard traversal: subject picker, unit strip, CTA, resume
- [ ] Visible focus indicators throughout
- [ ] Screen reader announces the greeting, recommendation and CTA sensibly
- [ ] Unit strip is operable without a pointer

---

## Teardown

```sql
-- revoke tester flags
delete from app.feature_flag_assignments
where feature_key='home-v2' and user_id in ('<TESTER_1>','<TESTER_2>');

-- and unset HOME_V2_GLOBAL_ENABLED in Vercel if the window is closing
```

Leave the manifest row in place — it gates content eligibility, not visibility, and
Home stays dark without the flag assignments.

---

## Exit criteria

QA passes only if **all of 1–9 pass**. Scenario 10 failures may be logged as
follow-ups at the Product Owner's discretion; **scenarios 3, 4, 5, 7 and 8 are not
waivable** — each maps to a P1 that failed QA on 2026-07-30.

A pass here authorises staff validation only. Making Home V2 the default student
landing page is a **separate Hard Gate** and is explicitly not granted by this run.
