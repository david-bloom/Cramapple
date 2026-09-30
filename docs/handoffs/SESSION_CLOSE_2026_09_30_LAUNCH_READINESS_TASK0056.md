# Session Close — 2026-09-30 (launch readiness: TASK-0056 to Production)

**Session:** Claude Code, cloud. Branch `claude/cramapple-launch-readiness-1q9dcq`.
**Next owner:** David Bloom (with Orly for the practice session).
**Single best next action:** deploy #284's two checkout functions to Dev, then complete a $0 checkout
in Stripe test mode with a 100%-off code. That path is now the only way into the Oct 2 launch.

## 1. Tasks in scope

- **TASK-0056** (answer keys directly readable; launch-gating per DECISION-0089): steps 2–5, Dev and Production.
- **TASK-0051** QA finding F2 (`evaluate-attempt` exclusion lookup).
- **Launch shape:** Oct 2 access runs through coupon checkout (DECISION-0091).

## 2. What changed

| Change | Where | Record |
|---|---|---|
| DECISION-0091: Oct 2 stays free, via `/checkout` with a 100%-off coupon. Runbook §1/§2 and the payment stop condition amended | `DECISIONS_LOG.md`, `LAUNCH_RUNBOOK_2026_10_02.md` | DECISION-0091 |
| Reviewer function `public.get_review_item_version` | migration `20260930120000`; Dev + Prod | APPROVAL-0063/0064 |
| Answer-key revoke: rebuilt `public.content_item_versions` / `public.frq_criteria` without answer and rubric columns | migration `20260930120100`; Dev + Prod | APPROVAL-0063/0064 |
| Table-level SELECT replaced by a safe-column grant (the column revokes alone were no-ops) | migration `20260930120200`; Dev + Prod | APPROVAL-0063/0064 |
| Dev parity: replayed committed `public.mcq_choices` fix as ledger version `20260827010001` (byte-identical to Prod) | Dev only | APPROVAL-0063 |
| Guard query + daily `answer-key-exposure-guard` CI job | `scripts/qa/answer_key_exposure_guard.sql`, `servable-items-check.yml` | TASK-0056 step 4 |
| Reviewer portal: `getReviewTask` no longer selects the unused `explanation` | Lovable app `56cae479` commit `783f6e04`, **published by David** | APPROVAL-0063 |
| F2: `.maybeSingle()` → `.limit(1)` + two-row test | `evaluate-attempt`; **Prod v70, deployed by David** | APPROVAL-0064 |
| Merged | PRs #285, #286, #284, #277 (#278 closed by #285) | — |

Every migration is recorded in each environment's ledger under **its file's version**, with a statement
body MD5-identical to the committed file. No renames are needed (runbook Trap 1).

## 3. Verified

- **Guard returns no rows on Dev and Production.** Before the change it listed every known leak, so the
  check has been seen to work in both directions.
- Production student matrix (rolled-back SQL as a real student): every protected base column is refused
  (42501); the view columns are gone (42703). Safe reads work: 1,335 versions, 2,885 criteria, 3,132 MCQ
  choices. `select_practice_frqs` returns 20 Biology items. The reviewer function returns 0 rows to a
  student and 1 to an admin.
- Dev: the reviewer function gives 1 row to an assigned reviewer (with explanation), 0 to an unassigned
  user, 1 to an admin; `anon` is refused (42501).
- Production `evaluate-attempt` v70: all 24 files byte-identical to `main`, and the `.limit(1)` fix is present.
- `evaluate-attempt/index_test.ts`: 14/14 pass. Both Open Hand tests fail against the old code.
- CI green on #285 and #286.

## 4. Open

- **The coupon checkout path is unproven.** #284 is merged but not deployed. No $0 Checkout Session has
  ever been completed; its author flags that Elements must be checked to confirm a $0 order with no payment method.
- **Live click-through of TASK-0056** (David + Orly practice session): an MCQ, an FRQ, a graded submit,
  and a reviewer opening a submitted assignment. Then watch logs for 24 hours for 42501 / 42703 from app traffic.
- **Fresh independent QA of TASK-0051 + TASK-0056.** TASK-0051 stays **Blocked** until it passes. F3
  (Dev still runs `open-hand-item` v9) is open.
- **The TASK-0051 Production gate** (`get_open_hand_item` is not in Production), after QA.
- Carried over, not touched: `get_graded_choice_feedback` / `get_chosen_distractor_rationale` do not exist,
  so the app's post-grade MCQ reveal silently never shows (Lovable side); TASK-0055 ledger drift; the
  Production smoke test before test students.
- The remaining runbook sections (§1 live page, §2 new-student access, §3/§4 Bio/Stats flat-path, §5 BYOQ,
  §6 QA and go/no-go) are all still unchecked.

## 5. Risks

- **Oct 2 now depends on Stripe:** coupon checkout, the webhook grant, and live-mode configuration.
  None of these is proven end to end.
- Production has a `content_reviewer` role with table-level SELECT on both tables. It isn't a PostgREST
  login role, so it was out of scope and left unchanged.
- The guard's daily job uses the `SERVABLE_ITEMS_CHECK_DB_URL` secret. Whichever environment that points
  at, it now passes. If the secret is ever repointed, check the guard on the new target.
- A column added later to `app.content_item_versions` or `app.frq_criteria` is **not** readable by
  students until it is granted on purpose (`20260930120200`). This is deliberate, but a new student-facing
  column will fail with 42501 until the grant is added.

## 6. Files changed

`supabase/migrations/20260930120000_task0056_get_review_item_version.sql`,
`…120100_task0056_revoke_answer_key_reads.sql`, `…120200_task0056_column_grants_not_table_grant.sql`,
`scripts/qa/answer_key_exposure_guard.sql`, `.github/workflows/servable-items-check.yml`,
`supabase/functions/evaluate-attempt/index.ts`, `index_test.ts`,
`docs/tasks/TASK-0056-ANSWER-KEY-DIRECT-READ-EXPOSURE.md`, `docs/tasks/TASK-0051-*.md`,
`docs/activity_log/{DECISIONS_LOG,APPROVALS_LOG,ACTIVITY_LOG}.md`, `docs/product/LAUNCH_RUNBOOK_2026_10_02.md`, this file.

## 7. Commands and results

- Guard on Dev/Prod before: 15 / 16 violation rows. After: 0 / 0.
- `deno test supabase/functions/evaluate-attempt/index_test.ts`: 14 passed. The cloud session maps
  `esm.sh` imports to `npm:` through a scratch import map, because esm.sh is blocked here.
- Production `evaluate-attempt` fetched after David's deploy: v70, 0 of 24 files differ from `main`.
- **Environment limits** in this cloud container: no route to `api.supabase.com` (no CLI deploys), and
  `esm.sh` / `deno.land` are blocked. Edge-function deploys go through David's Mac.

## 8. Approval state

- APPROVAL-0063 (Dev + Lovable edit): used, complete.
- APPROVAL-0064 (Prod migrations + `evaluate-attempt` deploy): used, complete.
- **Still needed:** a Production deploy of #284's functions; creating the live coupon and deciding how
  students get it; Stripe live mode; the TASK-0051 Production gate; the final go/no-go (David).

## 9. Next session: exact next step

1. David deploys `stripe-webhook` and `get-checkout-status` to Dev (command in the #284 description).
2. Complete a $0 checkout in Stripe test mode with a 100%-off promo code. Confirm the entitlement is
   granted and `get-checkout-status` reports `paid`, not `processing`.
3. David + Orly practice session on Production (§4 above). Report any 42501/42703.
4. Commission a fresh independent QA of TASK-0051 + TASK-0056 (new context, not this session).
5. Then walk the remaining runbook sections, ending with Production checkout enablement under its own approvals.

## 10. Do not touch

- Do not re-grant table-level SELECT on `app.content_item_versions` / `app.frq_criteria` to
  `authenticated`. Add new student-facing columns to the column grant instead.
- Do not apply `20260929034129` (`get_open_hand_item`) to Production before the fresh QA passes.
- Do not run `supabase db push` (TASK-0055).
- Do not enable Stripe live mode or create the live coupon without David's explicit approval.
- Do not run the smoke test against Production except at David's direction.
