# Session Close — 2026-09-30 (launch readiness: TASK-0056 to Production)

**Session:** Claude Code, cloud. Branch `claude/cramapple-launch-readiness-1q9dcq`.
**Next owner:** David Bloom (with Orly for the practice session).
**Single best next action:** deploy #284's two checkout functions to Dev, then complete a $0 checkout
in Stripe test mode with a 100%-off code. That path is now the only way into the Oct 2 launch.

## Update — 2026-09-30 midday (added from the activity log and `main` at `4451a69`)

Nothing below changes the original close; it records what landed on `main` after it, and what the log shows
is still open. The activity log has **no record** of #284's checkout functions being deployed or of any $0
checkout being run, so the "single best next action" above stands unchanged.

| Landed after close | Record |
|---|---|
| PR triage: TASK-0056 confirmed live in Production (ledger `20260930120000/100/200`, SQL re-check). #268 closed unmerged and replaced by **TASK-0057** (post-launch). Four stale branches retired. Remote is `main` + `claude/taxonomy-subject-id-link` only | Activity log, "PR Triage, TASK-0057 Opened" (#288, #290, #291) |
| **DECISION-0092:** AP Calculus AB opened to a named tester (Orly) in Production. `student-session-items` **v28** (v27 + Calc AB selector/parts patch only; deliberately excludes TASK-0051's `annotateOpenHandExclusions`); Lovable `56cae479` commit `be177e5` published. Calc AB is **not** an advertised Oct 2 subject | DECISIONS_LOG; PR #287 |
| **Calc AB Unit 1: 136 items published to Production** (hash-exact load, owner approval with human review waived by David, labels promoted, difficulty on 119). Calc AB census: 255 published, was 119. Log/decision/approval entries for this publish are **not written yet** (the publication record says so) | PR #292; `scripts/content-seed/calc-ab-unit1-original-2026-09-29/PUBLICATION_RECORD.md` |
| **TASK-0056 independent QA brief** written for a fresh-context session. It has not started | `docs/qa/TASK-0056_INDEPENDENT_QA_BRIEF.md` (#292) |
| Seeded item generation protocol added (content pipeline; not launch-gating) | PR #293 |

Still open from this addendum:

- **Calc AB grading is unproven in Production** (0 graded attempts before the tester night). Math renders as plain text.
- **Criteria-sourced `parts` on other subjects' long FRQs** show students answer text from
  `learner_facing_text`. **Measured and independently validated (2026-09-30):** **112 of the 141 servable
  Biology + Statistics FRQ items (79%) show answer content as the question** — Statistics 59 of 69,
  Biology 53 of 72. Proven end to end by running the live selectors and the shipped delivery code, not
  inferred. Two blind reviewers agreed 98.4%; an earlier keyword estimate of 50 items was a threefold
  undercount and wrongly treated Biology as the milder case. A serving fix (committed, untested in Prod)
  closes 46 — almost all Statistics. **66 remain, 52 of them Biology**, and need content work plus a
  Product Owner call. See `docs/qa/FRQ_CRITERIA_PARTS_ANSWER_EXPOSURE_2026_09_30.md`.
- ~~**`APBIO-MCQ-031` / `-035`** are suspected Unit 3/4 label mix-ups; Biology is a day-1 subject.~~
  **Withdrawn (2026-09-30).** Both items are `reviewed_disapproved` with zero published versions, so no
  selector can reach them, and none of the three Oct 2 flat-path selectors read taxonomy labels at all.
  Three genuine serving/coverage disagreements exist and are post-launch, with the unit-gated work. See
  `docs/qa/APBIO_MCQ_031_035_UNIT_LABEL_CHECK_2026_09_30.md`.
- **Production `student-session-items` is v28, not `main`.** The next deploy from `main` would pull in the still-gated
  TASK-0051 change. Do not deploy that function from `main` before the TASK-0051 gate.
- **Approval/decision records lag the Production writes** for the Calc AB publish.
- **Runbook §5 (BYOQ) checked 2026-09-30.** Answer exposure is structurally impossible (no answer column
  exists; the MCQ-choice CHECK is an exact two-key allowlist; `anon` holds no grants; RLS is owner-only).
  Marketing retention copy is accurate. Three open items — the privacy policy predates BYOQ and documents
  neither the 30-day purge nor EXIF stripping, it describes a publication path that does not exist, and the
  purge has never had anything older than 30 days to delete. Real-phone QR capture still needs a human. See
  `docs/qa/BYOQ_LAUNCH_SECTION5_EVIDENCE_2026_09_30.md`.
- **`get-checkout-status` is not deployed to Production at all** (confirmed against the live function list),
  which independently confirms the coupon-checkout path above is untested end to end.

## 1. Tasks in scope

- **TASK-0056** (answer keys directly readable; launch-gating per DECISION-0089): steps 2–5, Dev and Production.
- **TASK-0051** QA finding F2 (`evaluate-attempt` exclusion lookup).
- **Launch shape:** Oct 2 access runs through coupon checkout (DECISION-0091).
- **Added at update:** DECISION-0092 (Calc AB tester, `student-session-items` v28) and the Calc AB Unit 1 publish; see the update above.

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
- Do not deploy `student-session-items` from `main` (Production is v28 with the TASK-0051 change deliberately excluded).
