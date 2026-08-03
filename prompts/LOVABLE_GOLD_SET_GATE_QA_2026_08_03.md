# Lovable QA Prompt — gold-set gate and verification screen

**Target:** Lovable workspace for `exam-buddy-wireframe`.
**Date:** 2026-08-03
**Build prompt this QA's:** `LOVABLE_GOLD_SET_VERIFICATION_SCREEN_2026_08_03.md`
**Server-side coverage (already automated, do NOT re-test here):**
`supabase/tests/gold_set_verification.integration.sql` — T0–T8, passing.

---

> ## DO NOT PASTE THIS FILE INTO LOVABLE
>
> Despite the filename, nothing here is a build instruction. This is a **human**
> checklist, run in a browser after the screen exists. Lovable has no database
> access and will correctly report that it cannot execute the SQL below — that is
> not a blocker, it is the wrong tool.
>
> - **Lovable gets** `LOVABLE_GOLD_SET_VERIFICATION_SCREEN_2026_08_03.md` (the build).
> - **An admin runs** the Setup/Teardown SQL below, in the Supabase SQL editor.
> - **A human tester runs** the scenarios, signed in as the QA reviewer.
>
> **Setup was applied to Production on 2026-08-03** — QA reviewer
> `aaaaaaaa-0002-0000-0000-000000000002` (Tutor Beta), flag granted, 8 fixtures
> seeded. `<QA_USER_ID>` below is already resolved; the SQL is kept for the record
> and for re-runs. Do not run Setup again without running Teardown first.
>
> **Fixtures are visible to their owner and invisible in aggregate.** The QA
> reviewer sees their own queue and progress (0 of 8) so those screens can be
> tested; `gold_set_admin_overview()` and admin all-scope progress exclude
> anything with `is_fixture = true`. That exclusion is why the Setup insert below
> must set the column — a fixture without it silently inflates the counts an
> admin reads as the real state of the certification.

## Read this before running any of it

**You cannot QA this with real gold-set data.** Element marks are write-once and an
assignment closes permanently on submit. Any answer a tester marks is **burned** — it can
never again be verified cold by Jill or Saood, so it is lost from the certification
sample. Testing "just by clicking through Jill's queue" silently destroys the thing the
queue exists to measure.

Therefore: **QA runs against a disposable reviewer and disposable answers**, torn down
afterwards (setup and teardown SQL below). Never QA with Jill's or Saood's account, and
never against real seeded answers.

**What is already proven, and is not this QA's job.** The permission gate and the data
contract are enforced in the database and covered by the integration test: an unflagged
tutor is denied `not_authorized`; expired flags do not admit; admins are admitted by
role; readers cannot reach each other's assignments; the reader payload contains exactly
seven fields and none of them is the script, the verifiers' marks, the grader's output,
the writer family, the route, or the canonical answer.

**So the client gate is cosmetic, and should be treated that way.** If the UI gating
breaks, a reviewer sees a menu item they cannot use — the data stays sealed. Do not let
anyone "fix" a client gating bug by having the server return more, or by relaxing a
guard so a tester can see more.

---

## Setup (run as service_role before testing)

```sql
-- A disposable reviewer. Replace <QA_USER_ID> with a real staff auth user that is
-- NOT Jill, NOT Saood, and not an admin (admins pass by role and cannot test denial).
insert into app.feature_flag_assignments (feature_key, user_id, enabled, expires_at)
values ('gold-set-review', '<QA_USER_ID>', true, null)
on conflict (feature_key, user_id) do update set enabled = true, expires_at = null;

-- Disposable answers on 4 real Statistics items, tagged so teardown is exact.
do $$
declare v_v uuid; v_ids uuid[] := '{}'; v_id uuid;
begin
  for v_v in
    select civ.id from app.content_items ci
    join app.content_item_versions civ on civ.content_item_id=ci.id and civ.status='published'
    where ci.content_key in ('APSTATS-SFRQ-001','APSTATS-SFRQ-004',
                             'APSTATS-SFRQ-006','APSTATS-SFRQ-008')
  loop
    perform app.seed_gold_set_elements_single_point(v_v);
    for i in 1..2 loop
      -- is_fixture is what keeps these out of the admin aggregate views. Set it.
      -- Without it the fixtures inflate the certification counts an admin reads
      -- as the real state of the gold set.
      insert into app.gold_set_answers (set_key, content_item_version_id, answer_type,
        answer_text, writer_family, script, script_hash, route, item_content_hash,
        is_fixture)
      values ('B', v_v, 'A'||i::text,
              'QA FIXTURE — not a real answer. Sample text for '||i::text,
              'anthropic', '{"qa":true}'::jsonb, 'QAFIXTURE', 'provisional_accept', 'QAFIXTURE',
              true)
      returning gold_set_answer_id into v_id;
      v_ids := v_ids || v_id;
    end loop;
  end loop;
  perform app.seed_gold_set_verification_assignments('<QA_USER_ID>'::uuid, v_ids, 3);
end $$;
```

## Teardown (run immediately after QA — do not leave fixtures in place)

Keyed on `is_fixture`, not on the `'QAFIXTURE'` string — the boolean is what the
admin views filter on, so tearing down by the same predicate cannot leave a row
that is invisible to the check below. Run as one block; assignments must go before
the answers they reference.

```sql
delete from app.gold_set_verification_assignments a
using app.gold_set_answers ans
where ans.gold_set_answer_id = a.gold_set_answer_id
  and ans.is_fixture;

delete from app.gold_set_answers where is_fixture;

delete from app.feature_flag_assignments
where feature_key = 'gold-set-review' and user_id = '<QA_USER_ID>';

-- fixtures_left must be 0. real_answers and grants are the live corpus and must
-- be UNCHANGED by teardown — if either moved, something deleted real data.
select (select count(*) from app.gold_set_answers where is_fixture)     as fixtures_left,
       (select count(*) from app.gold_set_answers where not is_fixture) as real_answers,
       (select count(*) from app.feature_flag_assignments
          where feature_key = 'gold-set-review')                        as grants;
```

As of 2026-08-03 the live corpus is **40 real answers** and **2 grants** (Jill and
Saood). Record the numbers before you start and compare after — a teardown that
changes them has deleted something it should not have.

Marks cannot be deleted by anything but service_role, and the assignment cascade removes
them — that is intentional and is why teardown works.

---

## Scenarios

Non-waivable: **G1, G2, V4, V6, X1.** A failure in any of those blocks the pilot.

### Gate

| # | Steps | Expect |
|---|---|---|
| **G1** | Sign in as a reviewer with **no** gold-set permission (e.g. Shazia, Gulgeldi, Abdul Hanan). Look at the reviewer portal navigation. | **No gold-set entry of any kind.** Not greyed out, not "request access", no tooltip, nothing. They must not learn the feature exists. |
| **G2** | Same account, navigate directly to `/reviewer/gold-set` and `/reviewer/gold-set/verify` by typing the URL. | Redirected to reviewer home. No error page, no flash of the screen before redirect, no console leak of payload data. |
| G3 | Sign in as the QA reviewer (has the flag). | Gold-set entry visible; both routes load. |
| G4 | Sign in as an **admin**. | Gold-set entry visible with no flag row — admins pass by role. |
| G5 | While the QA reviewer is signed in, revoke the flag in SQL, then reload. | Entry disappears on reload. It need not vanish mid-session; it must not survive a reload. |
| G6 | With the flag revoked, attempt a submit from a stale open tab. | Server rejects. UI surfaces a clear failure and does not silently discard the reader's marks. |

### Verification screen

| # | Steps | Expect |
|---|---|---|
| V1 | Open the verify screen. | Question (stem, stimulus, image if present) and the answer, clearly separated. Answer is visually the focus. |
| V2 | Inspect the page, the network tab, and the React props/state. | The payload contains **exactly** `assignment_id, seq, stem, stimulus, stimulus_image_path, answer_text, elements`. If you can find the script, the writer model, the route, another verifier's marks, or the item's canonical answer anywhere in the client, **stop and report — this is the one failure that invalidates the pilot.** |
| V3 | Read the element list. | No point values anywhere. No running total, subtotal, percentage, or present/absent count. |
| V4 | Try to submit with one element unmarked; then with a Present element and an empty quote. | Submit stays disabled in both cases. The reader should never be able to reach a server-side rejection through normal use. |
| V5 | Mark all elements, submit, confirm the dialog. | Advances to the next answer. The submitted marks are **not** shown back. |
| V6 | After submitting, use browser Back, and reload `/reviewer/gold-set/verify`. | The submitted answer is never served again. No route exists that can display it. |
| V7 | Mark two elements, reload mid-answer without submitting. | Marks restored (localStorage autosave). |
| V8 | Submit, then immediately submit again (double-click, or replay the request). | Treated as success and advances — not an error toast. |
| V9 | Work to the end of the queue. | Completion state, no crash, no infinite spinner. |
| V10 | Click "I've seen something I shouldn't have", confirm. | Advances. Copy carries no friction or judgement. |
| V11 | Resize to mobile; check dark mode if the portal supports it. | Question collapses, answer and elements usable, nothing clipped. |
| V12 | Keyboard only: focus an element, press `p` / `a`, Tab through. | Marks set without the mouse. One reader has 224 marks to make. |

### Cross-checks

| # | Steps | Expect |
|---|---|---|
| **X1** | Sign in as the QA reviewer. In another session note a **different** reviewer's assignment id, and replay the submit request against it. | Rejected `not_authorized`. Already covered by integration T8 — re-confirm the client cannot be coaxed into sending it. |
| X2 | Confirm the existing review queue still works for a reviewer with no gold-set permission. | Unchanged. This feature must not touch the normal review flow. |
| X3 | Check `app.gold_set_element_marks` after QA. | One row per element per submitted assignment; `present=false` rows carry a null quote; `present=true` rows carry text. |

---

## Reporting

Report per scenario id with pass/fail and a screenshot for any failure. Two rules:

- **Any V2 failure is a stop-the-line event.** It does not get triaged with the rest — the
  server contract and the build prompt both have to be re-examined before anyone
  verifies another answer.
- Run teardown even if QA fails partway. Leftover fixtures would be seeded alongside real
  answers later and are indistinguishable to a reader once the `QAFIXTURE` hash is out of
  view.
