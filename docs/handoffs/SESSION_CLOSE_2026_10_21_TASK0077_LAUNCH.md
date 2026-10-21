# Session Close — TASK-0077 Production Launch (2026-10-20 to 2026-10-21)

**Task:** `TASK-0077` seven-day card trial. **Tier:** Hard-Gate. **Product Owner:** David Bloom. **Closed at David's request.**
**Read with:** `docs/tasks/TASK-0077-PRODUCTION-RUNBOOK.md` (per-step results, Production migration versions) and
`docs/tasks/TASK-0077-SEVEN-DAY-CARD-TRIAL.md`. Previous handoff: `SESSION_CLOSE_2026_10_21_TASK0077_PRODUCTION_READINESS.md`.

## 1. Where things stand

**The card trial is LIVE in Production.** `TRIAL_ADMISSION_ENABLED=true` since ~12:25 UTC 2026-10-21: every checkout on
cramapple.com (student-direct and parent-pay, promo codes included) offers $0 today and one charge of the locked price at the
end of day 7. David's $1 live run passed the whole loop (start → day-7 charge → `converted` → refund → `refunded`, access
revoked, four emails, every webhook `processed`). Records merged in PR #509 (`2375e6d3`).

## 2. What changed this session

- **Pre-flight re-run:** matched the record except secret names (29, not 31; David accepted 29 as the baseline).
- **Decisions (David):** D1 launch with the trial (admission for everyone; coupons of varying amounts will be distributed);
  D2 Loops payment/lifecycle flags `false`; D3 `TRIAL_TERMS_VERSION=terms-2026-10-18`; D4 apply product feedback; D5 parent
  request via Loops. Preconditions: 0.4 Stripe Radar + Terms/Privacy saved; 0.5 covered by the live run; 0.6 **launch
  without lawyer review**; 0.7 confirmed by Claude (Production and Development share the same `LOOPS_SECRET_KEY` digest).
- **Step 2 (email foundation):** 3 migrations, 17 secrets, `deliver-transactional-email` + `send-parent-payment-email`.
- **Step 3 (trial backend):** 6 migrations (each stored statement md5-identical to its repo file; schema matches
  Development), 24 secrets, Vault (4 entries, written by David), 10 functions (each identical to `3616edff`), workers
  invoked and scheduled (cron jobs 5 `*/5` charge, 6 `*/2` email), smoke tests.
- **Step 4:** David added the five live Stripe events to the existing "Cramapple Checkout" destination.
- **Step 5:** both Lovable projects published. The marketing build lacked `VITE_TRIAL_CHECKOUT_ENABLED`; Claude added it via
  a one-line Lovable prompt (`779c7320`), David republished.
- **Step 6:** admission on; David's $1 live trial (order `9569c2d2-76a1-4953-8ad8-12e8e6924732`), day-7 shift (David OK),
  charge 12:45, refund 12:51 — all verified in the database and on the Account page ("Refunded · AP Biology").
- **UX follow-ups from David's run, shipped the same day:** Google sign-in nonce fix (marketing `a4bb0577`, live; error was
  "Passed nonce and nonce in id_token should either both exist or not"); Home banner inline "Cancel trial" with confirmation
  (app `4f71acbd`, live; Account page and nav link kept because the mandate says "Cancel any time in Account"). David chose
  code sign-in with **no email pre-fill** (no address in URLs).

## 3. Verified

Production function downloads equal `3616edff` file for file; migration statements equal repo files by md5; trial schema
equals Development (functions identical except two whose Development copies lack comments); worker HTTP 200 via Vault;
cron runs all succeeded; quote `pay_now`/`admission_off` before launch and `trial` after; live bundles carry the trial flag,
the nonce code and the inline cancel; the $1 order's every state transition, entitlement change, email hand-off and webhook.

## 4. Open

- **Step 7 watch:** first real trials — `app.stripe_webhook_events` failures, `app.trial_worker_heartbeat`,
  `app.trial_notice_jobs` errors/`needs_review`, orders in `reconciling`.
- **`CARDLESS_TRIAL_RETIRED=true`** (start-trial → 410) — David's call after a quiet period.
- **Test session expiry:** `cs_live_b18T1A9a1jJnfUy1EeSlbnmaaIyW35fB8gnZHbmBu1AypEoWqrWw5u0od1` (created in step 3.6) should
  show `checkout.session.expired` `processed` after ~2026-10-22 01:15 UTC. Low risk: two live expiries processed on 10-21.
- Trial emails land in **Gmail Promotions** (Loops sender setup).
- Checkout page's `rest/v1/subjects` request returns **401** (the list renders; same endpoint answers with the publishable key).
- Wallets did not render in incognito Chrome (expected); re-check Apple Pay in Safari and Google Pay/Link in a normal profile.
- David to confirm "Continue with Google" works on cramapple.com/login in a real browser.
- Known limits carried in (runbook): no account-deletion path while a learner has a trial order; recovery-form retry past
  the cap; generic error on restart over a completed setup; Development return URL drops `backend=dev`.

## 5. Risks

Lawyer review was waived for launch. Production has a default ACL granting `content_reviewer` SELECT on every new `app`
table (trial tables included); forced RLS with a service-role-only policy means it reads nothing.

## 6. Session mechanics worth knowing

- The session's permission classifier blocks Claude from writing Vault/secret-store entries and `.claude/settings*`; David
  ran the Vault write himself and added allow rules for `supabase secrets set`, `supabase functions deploy` (Production ref)
  and `curl` to Production functions in `.claude/settings.local.json`.
- `supabase db query --linked` against Production needs `--workdir ~` (that link holds the IPv4 pooler URL).
- Generated worker secrets lived only in session scratch files, deleted at close; the values exist only in Production
  secrets and Vault.

## 7. Approval state

`APPROVAL-0197` covers steps 2–4; steps 5–6 ran on David's explicit chat approvals recorded in the runbook. Rollback switch:
`TRIAL_ADMISSION_ENABLED=false`. Nothing awaits approval.

## 8. Do not touch

Do not change Production trial secrets, cron jobs 5/6, the Stripe webhook destination's events or the Vault entries without
David's approval. Do not reword mandate/Terms text without bumping `MANDATE_TEXT_VERSION`.

## Prompt for the next session

```text
Start a Cramapple session on TASK-0077 post-launch. The seven-day card trial has been LIVE in Production since
2026-10-21 ~12:25 UTC.

Read first: docs/team_charter/CRAMAPPLE_SESSION_START.md, then
docs/handoffs/SESSION_CLOSE_2026_10_21_TASK0077_LAUNCH.md, then docs/tasks/TASK-0077-PRODUCTION-RUNBOOK.md (step 7).

Then, read-only on Production (pcntajvbdfqhbeewmdry): report trial orders by status, any failed/processing webhook events,
worker heartbeat and cron failures, notice jobs with errors or needs_review, and confirm the step-3.6 test session's
checkout.session.expired was processed. Change nothing without my approval. Then propose the next item from section 4.
```
