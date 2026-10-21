# TASK-0077 — Production Rollout Runbook (Seven-Day Card Trial)

**Status:** Ready to execute once its preconditions are met. Nothing in it has been run on Production.
**Written:** 2026-10-20 by Claude, from read-only checks of Production that day. **Tier:** Hard-Gate.
**Every step marked ⛔ needs David's explicit approval at the time it is run.** Approval for one step does not carry to the next.
**Governing records:** `DECISION-0126`, `docs/tasks/TASK-0077-SEVEN-DAY-CARD-TRIAL.md` (release checklist, QA rounds 1–5),
`docs/product/SEVEN_DAY_CARD_TRIAL_PLAN_2026_10_18.md` §8, `docs/product/LOOPS_TRANSACTIONAL_EMAIL_MIGRATION_2026_10_06.md`.
**Pick-up prompt and open items:** `docs/handoffs/SESSION_CLOSE_2026_10_21_TASK0077_PRODUCTION_READINESS.md`.

Production project `pcntajvbdfqhbeewmdry`; Development `wmgjsdkphcyhngaffbqf`. Stripe live account `acct_1TddjmLwoRHzBJ1O`.
Every CLI call names `--project-ref` and `--workdir <repo root>` (the CLI's home-directory link points at Production).

## What Production looks like today (read-only, 2026-10-20)

- **Last migration** `20261016000100`. No trial tables, no `app.transactional_email_outbox`, no parent-email lifecycle tables,
  no `app.product_feedback`. 20 legacy cardless `trial_v1` entitlements (the trial migration backfills them as used emails).
  `growth_event_outbox_event_name_check` holds exactly the 17 names the trial migration replaces.
- **Functions** (each matched to a git commit, so there is no code on Production outside git): `stripe-webhook` = `95392f15`,
  `create-checkout-session` = `09b31244`, `create-parent-payment-link` / `get-checkout-status` / `resolve-parent-link` =
  `6c92db42`, `send-parent-payment-email` = `10abfd88`. `start-trial` is a mixed August build (`start-trial/index.ts` =
  `f7aa0093`; `_shared/cors.ts` and `_shared/supabase.ts` differ from git only in comments; `_shared/growth-events.ts` is older,
  without the `environment` tag). Not on Production: `deliver-transactional-email`, `charge-due-trials`, `cancel-trial`,
  `trial-recovery`, `get-trial-status`.
- **Secrets:** 31 set. Missing, and read by the release code: `LOOPS_PAYER_EMAILS_ENABLED`, `LOOPS_PAYMENT_EMAILS_ENABLED`,
  `PARENT_EMAIL_LIFECYCLE_ENABLED`, `PARENT_EMAIL_USE_SHORT_LINKS`, `STUDENT_APP_URL`, `TRANSACTIONAL_EMAIL_WORKER_SECRET`,
  `TRANSACTIONAL_MAILING_ADDRESS`, `TRANSACTIONAL_STUDY_URL`, `TRIAL_ADMISSION_ENABLED`, `TRIAL_CHARGES_ENABLED`,
  `TRIAL_CHARGE_WORKER_SECRET`, `TRIAL_NOTICES_ENABLED`, `TRIAL_TERMS_VERSION`, and the Loops template ids (below).
  `MARKETING_BASE_URL` and `PUBLIC_RATE_LIMIT_HMAC_KEY` are unset in both environments and have defaults.
- **Vault:** 4 entries, none for the trial or email workers. **Cron:** 4 jobs, none for the trial or email workers.
- **Auth email:** Send Email hook **off**; SMTP via Resend; "Confirm sign up", Magic Link and Invite carry `{{ .Token }}`.
  Trial sign-in does not depend on Loops. **Leave the Send Email hook off** in this rollout.
- **Stripe live:** one webhook endpoint ("Cramapple Checkout" → Production `stripe-webhook`, 6 events). Production's current
  webhook (and `main`'s before #507) **throws on unknown event types**, so the five new events go on only after step 4.
  Terms/Privacy URLs typed into the public-details form but **not saved**; Radar for saved payment methods **off**;
  `cramapple.com` and `checkout.cramapple.com` registered as payment-method domains.

## 0. Preconditions (David)

| # | Precondition | State 2026-10-20 |
| --- | --- | --- |
| 0.1 | Cramapple PR #507 merged (backend + these records) | open when written |
| 0.2 | ap-prep-blueprint PRs #38 (spelling) and #39 (recovery card-only) merged | open when written; checked to merge cleanly together |
| 0.3 | Codex sign-off on the trial code | **done** (`43440c98`, no findings; code and local tests only) |
| 0.4 | Stripe live: click **Save** on Public details (Terms `https://cramapple.com/terms`, Privacy `https://cramapple.com/privacy`); turn on **Radar → "Use Radar on payment methods saved for future use"** | **confirmed 2026-10-20** by David: Radar active; Terms and Privacy URLs saved on the public profile |
| 0.5 | Production first sign-in: a brand-new account requests a code on Production, the email carries a 6-digit code and no one-browser link, and the code signs in (checklist item 9) | not done |
| 0.6 | Lawyer review of the trial Terms section, both mandate texts (`trial-mandate-v4`) and the notice emails, or David's decision to launch without it (`DECISION-0126` item 27) | open |
| 0.7 | Loops: the 20 trial templates (19 notices + the parent trial request) and the other parent/payment templates are published in the **same Loops workspace as Production's `LOOPS_SECRET_KEY`** (ids in `docs/email/transactional/manifest.json`) | **confirmed 2026-10-20**: same `LOOPS_SECRET_KEY` digest as Development |
| 0.8 | Decisions D1–D5 below answered | **answered 2026-10-20** (below) |

## Decisions needed before running

- **D1 — How the $1 live trial is admitted.** There is no per-person allowlist: `TRIAL_ADMISSION_ENABLED` is all or nothing.
  (a) Run the $1 trial with admission on for everyone, as launch, at a quiet hour, ready to switch it off (recommended: it is one
  switch and rollback stops new trials at once). (b) Add an admission allowlist first (small code change + Codex review).
- **D2 — Loops payment emails on Production.** `deliver-transactional-email` also delivers the non-trial payment and
  parent-lifecycle emails. Recommended: deploy with `LOOPS_PAYMENT_EMAILS_ENABLED=false`, `LOOPS_PAYER_EMAILS_ENABLED=false`,
  `PARENT_EMAIL_LIFECYCLE_ENABLED=false` (those queues stay empty; Stripe's own receipts continue) and turn them on separately.
- **D3 — `TRIAL_TERMS_VERSION`.** Development uses `terms-2026-10-18`. It should be the published Terms' "last updated" date
  after any edit (the 2026-10-20 spelling pass may count).
- **D4 — `20261003000100_create_product_feedback_phase_b.sql`** is on `main` but not Production. The trial does not need it.
  Apply it here, or leave it to its own task.
- **D5 — The parent-request email.** `main`'s `send-parent-payment-email` sends through Loops transactional templates
  (`LOOPS_PARENT_REQUEST_TRANSACTIONAL_ID`, `LOOPS_PARENT_TRIAL_REQUEST_TRANSACTIONAL_ID`), replacing Production's August
  workflow. Confirm before step 2.3, because parent emails change the moment it deploys.

**David's answers (2026-10-20, rollout session):**
- **D1 — (a).** "We are launching with the 7-day free trial." Admission goes on for everyone; the $1 trial is the launch. David
  will also distribute coupons for varying amounts. As built (plan §6.9): the discount is locked at signup and the day-7 charge is
  the discounted price; a 100%-off code skips the trial (`pay_now_zero`, immediate access); a code leaving 1–49¢ is rejected;
  codes must be USD coupon promotions in live mode whose product restriction, if any, includes the trial Price's product.
- **D2 — agreed:** all three flags `false`.
- **D3 — `TRIAL_TERMS_VERSION=terms-2026-10-18`** (2026-10-18 is the Terms date).
- **D4 — apply** `20261003000100_create_product_feedback_phase_b.sql` in step 2.1.
- **D5 — confirmed:** `send-parent-payment-email` moves to the Loops templates in step 2.3.
- Pre-flight step 4: David accepted **29** secret names as the baseline.

## 1. Pre-flight (Claude, read-only, same day as the rollout)

1. `git fetch`; release commit = `main` after #507. Record its SHA here.
2. Re-run the Production function before-diff (download each function above, match to a commit). Stop if any no longer
   matches what is listed above.
3. `select max(version) from supabase_migrations.schema_migrations` is still `20261016000100`; no trial or email tables exist.
4. Secret names unchanged from the list above (`supabase secrets list`, names only).
5. Production's `stripe_webhook_events` has nothing stuck in `processing`/`failed` from the last day.

### Pre-flight results (2026-10-20/21)

- Step 1 (release SHA): **`3616edff`** (#507 merged 2026-10-21 00:16 UTC; app #38 `39fd4ff0`, #39 `c0c0f2d7` merged the same
  minute, app `main` = `c0c0f2d`). Its `supabase/functions` tree is identical to `43440c98` (Codex's sign-off, and what
  Development runs); its migrations differ only by the round-5 rename (same content) and the #508 stranded migration.
- Step 2: all six matched functions unchanged (`stripe-webhook` 9 files, `create-checkout-session` 8,
  `create-parent-payment-link` 9, `get-checkout-status` 8, `resolve-parent-link` 7, `send-parent-payment-email` 6; 0 differ
  each); `start-trial/index.ts` still `f7aa0093`; none of the new functions, and not `send-auth-email`, exist.
- Step 3: last migration `20261016000100`, none newer; no trial, outbox, lifecycle or `product_feedback` tables; 20 legacy
  `trial_v1` rows; the outbox check still holds the 17 names; Vault and cron unchanged (4 entries, 4 jobs, none for these
  workers).
- Step 4: 31 secret names, identical to the list above.
- Step 5: no webhook events in the last day. **Two older live events are `failed`:** `evt_1UNhfiLwoRHzBJ1Oq8uxoixk` and
  `evt_1UNhjzLwoRHzBJ1OKmwEezcj`, both `checkout.session.expired` for unpaid `student_direct` pay-now sessions on 2026-10-06,
  7 attempts each, last 2026-10-09 (`stripe_webhook_processing_failed`). An expired session grants nothing, so no customer was
  affected; logs from that date are gone, so the cause is not known. Not a blocker; step 3.6 now checks the new webhook
  processes an expiry.

### Pre-flight re-run (2026-10-20, rollout session)

- Step 1: `main` is still **`3616edff`**.
- Step 2: the six functions match their commits file for file (same file counts as above, 0 differ); `start-trial` still
  differs only in `_shared/growth-events.ts`, `_shared/cors.ts`, `_shared/supabase.ts`. None updated since 2026-10-16.
- Step 3: unchanged (last migration `20261016000100`, none newer; no new tables; 20 `trial_v1` rows; 17 outbox names;
  Vault 4, cron 4, none for these workers).
- Step 4: **differs from the record: 29 secret names, not 31.** `-o json` and the table output both give 29. Which two names
  were in the earlier 31 was not recorded, so it cannot be shown whether two secrets were removed or the earlier count included
  the table's header lines. Every name the release reads and Production lacks is one listed above (plus names read only by
  non-trial code or with defaults); `STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET`, `STRIPE_PRICE_CATALOG_JSON`,
  `LOOPS_SECRET_KEY`, `APP_BASE_URL`, `ALLOWED_ORIGINS` are present. **Stopped here for David** per the pre-flight rule.
- Step 5: one new event, `evt_1USLEjLwoRHzBJ1O8SKvlPTT` (`checkout.session.expired`, 2026-10-19 18:24 UTC), `processed` on the
  first attempt, so Production's current webhook can process an expiry; the two 2026-10-06 events are still `failed`. Nothing in
  `processing`.

## 2. ⛔ Email foundation (TASK-0060's tables and worker), dormant

1. `apply_migration` on Production, in order: `20261006084914_loops_transactional_email_outbox.sql`,
   `20261006143000_parent_email_lifecycle.sql` (and `20261003000100` only if D4 says so). Production records its own versions:
   note each in the task record (the repo filenames follow Development). Read back the tables, RLS forced, functions
   service-role only.
2. Secrets: `TRANSACTIONAL_MAILING_ADDRESS` (the real footer address), `TRANSACTIONAL_STUDY_URL=https://app.cramapple.com/home`,
   `STUDENT_APP_URL=https://app.cramapple.com`, a new random `TRANSACTIONAL_EMAIL_WORKER_SECRET`, the D2 flags (all `false`),
   `PARENT_EMAIL_USE_SHORT_LINKS` as on Development, and the non-trial Loops ids Development has
   (`LOOPS_PARENT_REQUEST_…`, `LOOPS_PARENT_TRIAL_REQUEST_…`, `LOOPS_PARENT_PAID_…`, `LOOPS_PARENT_REMINDER_…`,
   `LOOPS_PARENT_EXPIRED_…`, `LOOPS_PAYMENT_EXPIRED_…`, `LOOPS_PURCHASE_…`, `LOOPS_RECEIPT_…`, `LOOPS_REFUND_…`), all from the
   manifest. Never print values; set from a file or stdin.
3. Deploy `deliver-transactional-email` (`--no-verify-jwt`; its bearer secret is the boundary) and, per D5,
   `send-parent-payment-email`. Do **not** deploy or enable `send-auth-email`.
4. Check: `deliver-transactional-email` without its secret → 401; with it → 200 and an empty summary.
- *Rollback:* redeploy `send-parent-payment-email` from `10abfd88`; the new tables are additive and unused while the flags are off.

**Run 2026-10-20 (`APPROVAL-0197`):** 2.1 done — Production versions `20261021003534` (product feedback), `20261021003602`
(outbox), `20261021003627` (lifecycle); read-back passed (details in the approval record). 2.2 secrets file built (17 names);
setting it was first blocked by the session's permission rules; David added an allow rule and 2.2–2.4 then ran:
- 2.2: 17 secrets set (46 names now); each verified against its intended value by digest. `TRANSACTIONAL_MAILING_ADDRESS`
  = David's business address (2026-10-20). Development's value differs (its footer is not this address).
- 2.3: `deliver-transactional-email` (new, `verify_jwt` false) and `send-parent-payment-email` (`verify_jwt` false, as before)
  deployed from the worktree at `3616edff`'s functions tree; downloaded back, 11 and 9 files, 0 differ from `3616edff`.
- 2.4: no secret → 401; with secret → 200 `{"payment":{"claimed":0,"sent":0},"lifecycle":{"disabled":true,...},"trial":null}`.

## 3. ⛔ Trial backend, dormant

1. `apply_migration` on Production, in order: `20261018191924_task0077_card_trial_orders.sql`,
   `20261018191935_task0077_trial_worker_invokers.sql`, `20261019142835_task0077_trial_qa_fixes.sql`,
   `20261020224101_task0077_trial_qa_round3.sql`, `20261020233210_task0077_trial_qa_round4.sql`,
   `20261020235937_task0077_trial_qa_round5.sql`. Record each Production version. Read back: trial tables with RLS forced,
   no client role can read them or call the functions, `app.trial_sweep()` runs, 20 legacy emails backfilled into
   `app.trial_consumed_emails`, the outbox check lists the 22 names.
2. Secrets: `TRIAL_ADMISSION_ENABLED=false`, `TRIAL_CHARGES_ENABLED=true`, `TRIAL_NOTICES_ENABLED=true`,
   `TRIAL_TERMS_VERSION` (D3), a new random `TRIAL_CHARGE_WORKER_SECRET`, and the 19 `LOOPS_TRIAL_<KIND>_<ROLE>_TRANSACTIONAL_ID`
   values from the manifest: kinds `TRIAL_STARTED`, `REMINDER`, `PAYMENT_FAILED`, `REQUIRES_ACTION`, `GRACE_ENDED`,
   `DELAYED_CHARGE`, `CANCELED`, `CONVERTED`, `REFUNDED`, each `PAYER` and `STUDENT`, plus `TRIAL_STARTED_LEARNER` (the 20th
   trial template is the parent trial request, set in step 2.2).
   Leave `CARDLESS_TRIAL_RETIRED` unset.
3. Vault (values not printed): `trial_charge_function_url` = `https://pcntajvbdfqhbeewmdry.supabase.co/functions/v1/charge-due-trials`,
   `trial_charge_worker_secret` = the step-2 secret, `email_worker_function_url` =
   `https://pcntajvbdfqhbeewmdry.supabase.co/functions/v1/deliver-transactional-email`, `email_worker_secret` = the
   `TRANSACTIONAL_EMAIL_WORKER_SECRET` from step 2.2.
4. Deploy from the release commit, **`stripe-webhook` first**, then `create-checkout-session`, `create-parent-payment-link`,
   `get-checkout-status`, `resolve-parent-link`, `start-trial`, `charge-due-trials`, `cancel-trial`, `trial-recovery`
   (all `--no-verify-jwt`) and `get-trial-status` (JWT verified; `config.toml`). After: download each and confirm it matches the
   release commit file for file.
5. Invoke both workers once through the Vault path (`select app.invoke_charge_due_trials()`,
   `select app.invoke_deliver_transactional_email()`); expect HTTP 200 and a heartbeat with `charges_enabled: true`. Then run
   `scripts/task0077/schedule_workers.sql` (charge `*/5`, email `*/2`) and confirm the two `task0077-%` cron jobs.
6. Smoke tests (no money moves): worker without its secret → 401; cancel and recovery with an unknown token → 404; trial status
   without a login → 401; webhook with a bad signature → 400; `trial_quote` → `billing_mode: pay_now`, `pay_now_reason: admission_off`, with
   the live price; a legacy pay-now `create-checkout-session` still returns a client secret (an unpaid live session; let it expire).
   **24 hours later:** that session's `checkout.session.expired` event must be `processed` in `app.stripe_webhook_events`.
   (Production's current webhook failed both live expiry events it received on 2026-10-06, 7 attempts each; see "Pre-flight
   results".)
**Run 2026-10-20 (`APPROVAL-0197`):**
- 3.1 done. Production versions: `20261021010317` card_trial_orders, `20261021010400` worker_invokers, `20261021010442` qa_fixes,
  `20261021010520` round3, `20261021010541` round4, `20261021010547` round5. Each stored statement is md5-identical to its repo
  file. Against Development: columns, constraints, indexes and policies identical; all 20 functions identical except
  `invoke_trial_worker` and `trial_record_attempt`, whose Development copies lack the comments (same code). Read-back: RLS
  enabled + forced on all six trial tables, no anon/authenticated access, `app.trial_sweep()` returns zeros, outbox check 22
  names. **Correction:** the backfill is **2 emails**, not 20 — the 20 legacy `trial_v1` rows belong to 2 accounts (10 subjects
  each). Production-only: a pre-existing default ACL grants `content_reviewer` (no login, no RLS bypass, members: `postgres`)
  SELECT on every new `app` table, the trial tables included; forced RLS with a service-role-only policy means it reads 0 rows.
- 3.2 done: 24 secrets (admission `false`, charges/notices `true`, `TRIAL_TERMS_VERSION=terms-2026-10-18`, new worker secret, 19
  trial Loops ids), digest-verified; 70 names now. `CARDLESS_TRIAL_RETIRED` unset.
- 3.3 done 2026-10-21 01:16 UTC by David (the session's permission rules block Claude's secret-store writes): four entries
  created with `supabase db query --linked --workdir ~` from a file built out of the step-2/3 secrets, values never printed;
  read back by name, both URLs correct. (A first attempt from a fresh link folder failed on IPv6 before writing anything.)
- 3.4 done: all ten functions deployed (`stripe-webhook` first; `get-trial-status` JWT-verified, the rest `--no-verify-jwt`;
  `start-trial` changes from gateway-JWT to its own `requireProfile` 401 check, as the runbook specifies); each downloaded back,
  0 files differ from `3616edff`.
- 3.5 done: `app.invoke_charge_due_trials()` → HTTP 200 (`charges_enabled: true`, sweep zeros, heartbeat 01:17:30 UTC);
  `app.invoke_deliver_transactional_email()` → HTTP 200 (trial `claimed 0`). Scheduled: cron job 5
  `task0077-charge-due-trials` `*/5`, job 6 `task0077-deliver-transactional-email` `*/2`, both active.
- 3.6 done except the 24-hour check: charge worker no secret 401; cancel and recovery unknown token 404; trial status no login
  401; webhook bad signature 400; `trial_quote` → `pay_now` / `admission_off`, $39.99, `terms-2026-10-18`, `trial-mandate-v4`;
  legacy pay-now checkout returned `cs_live_b18T1A9a1jJnfUy1EeSlbnmaaIyW35fB8gnZHbmBu1AypEoWqrWw5u0od1` with a client secret.
  **Due ~2026-10-22 01:15 UTC:** that session's `checkout.session.expired` must be `processed` in `app.stripe_webhook_events`.

- *Rollback:* redeploy the step-1 commits listed under "What Production looks like today"; unschedule the two jobs
  (`cron.unschedule('task0077-…')`). Tables stay (additive). With admission off no trial can start, so nothing needs undoing.

## 4. ⛔ Stripe live webhook events (David, in the dashboard)

Only after step 3.4. Add to "Cramapple Checkout": `payment_intent.succeeded`, `payment_intent.payment_failed`,
`payment_intent.processing`, `payment_intent.canceled`, `charge.dispute.created`. Check the endpoint's next deliveries return 200
and Production's `stripe_webhook_events` records them as `processed`. (Every PaymentIntent on the account now reaches the
webhook; the handler acts only on `metadata.kind = trial_conversion` and returns 200 for the rest.)
- *Rollback:* remove the five events.

**Run 2026-10-21 (`APPROVAL-0197`):** David added the five events to the existing "Cramapple Checkout" destination (a
new-destination form came up first and was abandoned: a second destination would have its own signing secret). The endpoint
also lists `payment_intent.created`; the new webhook routes every `payment_intent.*` to the trial handler, so it is safe, though
Production had never recorded one. No deliveries yet at 12:15 UTC; **the first PaymentIntent event must show `processed`**
(check at the next live purchase or in step 6). Workers healthy: 132 charge and 329 email runs, all succeeded, heartbeat
`charges_enabled: true`. A `resource_missing` GET for a `cs_test_` session seen in the live dashboard is the known
Development return-page issue (it asks Production about a test session), not this rollout.

## 5. ⛔ Frontend publish, still dormant (David, in Lovable)

1. Marketing `61dd6602`: set `VITE_TRIAL_CHECKOUT_ENABLED=true` and publish. Includes the trial checkout, the parent drawer,
   `/trial` redirects and the 2026-10-20 fixes (`f9a5e637`). Optional first: a "finishing your trial" message for
   `409 trial_setup_completing` (today: generic error).
2. App `56cae479`: publish (`main` with #37, #38, #39: Account trial card, cancel and recovery links, Home banner).
3. Check on cramapple.com with admission still off: checkout quotes `pay_now` and looks like today; `/trial` redirects to checkout;
   the app's Account page loads.
- *Rollback:* republish the previous Lovable versions.

## 6. ⛔ David's $1 live trial (plan §8 slice 8; admission per D1)

1. Admission on: `TRIAL_ADMISSION_ENABLED=true` (D1 (a)) or allowlisted (D1 (b)).
2. David checks out on cramapple.com with the $1 pilot code and his own card (direct, or parent link to a second inbox). Expect:
   card saved, "Your free trial has started", trial-started email(s), Account shows the trial, Stripe shows one unconfirmed $1
   PaymentIntent.
3. ⛔ Per-order exception (Production SQL, this order only) to bring day 7 forward:
   `update app.trial_orders set trial_started_at = trial_started_at - interval '7 days', trial_ends_at = trial_ends_at - interval '7 days' where id = '<order>' and status = 'trialing';`
   and the same shift on its `app.subject_entitlements` rows (`source = 'stripe_trial_v1'`, `external_reference = '<order>'`).
4. Within 5 minutes the worker charges $1 off-session; expect `converted`, paid access, the converted email, a Stripe receipt.
5. Refund the $1 in the Stripe dashboard; expect `refunded`, access revoked, the refunded email.
6. Either keep admission on (launch, step 7) or set `TRIAL_ADMISSION_ENABLED=false` until ready.

## 7. ⛔ Launch and retire the cardless trial

1. `TRIAL_ADMISSION_ENABLED=true` (if not already). Watch for the first day: `stripe_webhook_events` failures,
   `app.trial_worker_heartbeat`, `trial_notice_jobs` with `needs_review` or errors, orders in `reconciling`.
2. After a quiet period David chooses: `CARDLESS_TRIAL_RETIRED=true` (`start-trial` answers 410).

## Rollback at any point

| Problem | Action | Effect |
| --- | --- | --- |
| Stop new trials | `TRIAL_ADMISSION_ENABLED=false` | Checkout returns to pay-now at once; existing trials keep cancel, status and recovery |
| Stop charging | `TRIAL_CHARGES_ENABLED=false` | No charges; after 2 h overdue orders get a 48-hour notice and access continues |
| Stop trial emails | `TRIAL_NOTICES_ENABLED=false` | Jobs queue and send when switched back on (the parent's cancel link is in these emails, so do not leave it off with trials live) |
| Webhook errors | Remove the five events, redeploy the previous `stripe-webhook` | Trial conversions then wait for event retries |

## Known limits carried into launch

- No account-deletion path (deletion is blocked while a learner has any trial order).
- A payer who keeps the recovery form open can retry within it past the 5-attempt cap, up to Stripe's own limit.
- The return page after a restart over a completed setup shows a generic error (step 5.1 option).
