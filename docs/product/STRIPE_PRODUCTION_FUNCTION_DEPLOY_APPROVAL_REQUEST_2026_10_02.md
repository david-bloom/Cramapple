# Approval Request — Deploy the Six Stripe Functions to Production (two tranches)

**Status:** **Tranche 1 APPROVED 2026-10-02 (`APPROVAL-0070`); tranche 2 NOT approved.** Outcome: `docs/activity_log/APPROVALS_LOG.md`.
**Requested by:** Claude (Main Conductor). **Approver:** David Bloom (Product Owner).
**Approval ID:** `APPROVAL-0070` (tranche 1).
**Governing records:** `TASK-0041`, `DECISION-0094`, `APPROVAL-0069` (schema, already applied), `docs/product/STRIPE_PRODUCTION_CUTOVER_CHECKLIST_2026_09_30.md` (Gate C, step E)
**Tier:** Hard-Gate (Production deploy, payments)
**Deploy source:** `main` at or after `0bfe8511`. `supabase/functions/**` is byte-unchanged since the Dev deploy (`644a052c`); re-checked 2026-10-02.

## 1. Read this first: deploying the parent-pay function turns on real payments

Card payment on the live site is **switched off** (no Stripe publishable key in Lovable). But the live `/checkout` page already shows
"Ask a parent to pay", and it fails today only because `create-parent-payment-link` is not deployed. **The moment that function is deployed,
the button works** and will create real Stripe Checkout sessions using whatever `STRIPE_SECRET_KEY` and `STRIPE_PRICE_CATALOG_JSON` Production
holds. If the webhook signing secret doesn't match the live Stripe endpoint, a parent could be **charged and the student granted nothing**.

So the request is split into two tranches, and **tranche 2 must not start until the checks in §4 pass.**

## 2. What you are approving

Deploy from `main` to Production (`pcntajvbdfqhbeewmdry`), each with `--no-verify-jwt --use-api`, from your Mac (cloud sessions cannot reach the Supabase API).

| Tranche | Function | Today in Production | Creates money/charges? |
|---|---|---|---|
| **1** | `stripe-webhook` | v20 (August) → replaced | no (receives Stripe events) |
| **1** | `get-checkout-status` | **not deployed** → new | no (read-only status) |
| **1** | `send-parent-payment-email` | **not deployed** → new | no (emails a link for an *existing* session; rate-limited 5/hour/session) |
| **2** | `create-checkout-session` | v21 (August) → replaced | **yes** (once Elements is on) |
| **2** | `create-parent-payment-link` | **not deployed** → new | **yes — enables "Ask a parent to pay"** |
| **2** | `create-post-purchase-addon` | **not deployed** → new | **yes — $30 off-session charge** |

Each function reads these Production secrets (**names verified present 2026-10-02; values and live/test mode are NOT verifiable by me**):
`STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET`, `STRIPE_PRICE_CATALOG_JSON`, `APP_BASE_URL`, `ALLOWED_ORIGINS`, `LOOPS_SECRET_KEY`, plus the standard Supabase keys.

## 3. Rollback preparation (done, read-only)

The pre-cutover sources of the only two functions being **replaced** are saved in the repo with SHA-256s:
`scripts/stripe-cutover/prod-rollback-2026-10-02/` (`stripe-webhook`, `create-checkout-session`, shared files). The four new functions have nothing to roll back to;
rolling those back means deleting them or leaving them unreachable (the page would again fail "Ask a parent").
No secrets are in those files (scanned).

## 4. Prerequisites for tranche 2 (David to confirm; Claude cannot see Stripe)

- [ ] **Which Stripe mode do Production's secrets hold?** (`STRIPE_SECRET_KEY` live or test; the August purchase used live.) Say which.
- [ ] **A live-mode webhook endpoint** exists at `https://pcntajvbdfqhbeewmdry.supabase.co/functions/v1/stripe-webhook`, subscribed to
      `checkout.session.completed`, `checkout.session.async_payment_succeeded`, `checkout.session.async_payment_failed`,
      `checkout.session.expired`, `charge.refunded`, and **only one endpoint** per mode.
- [ ] **`STRIPE_WEBHOOK_SECRET` in Production is that live endpoint's signing secret** (the usual Dev failure was a stale or mismatched secret).
- [ ] **`STRIPE_PRICE_CATALOG_JSON` holds live price IDs** for the Day-1 subjects at $39.99 (and bundles if sold).
- [ ] **A refund / terms position exists** — strangers will be able to pay full price as soon as tranche 2 is live (`DECISION-0094`).
- [ ] The homepage copy no longer promises "free until November" (you said you're fixing it).
- [ ] Optional safety: until you are ready for parents to pay, **skip `create-parent-payment-link`** and the page keeps failing safely.

## 5. How I would run it

**Tranche 1** — you run, I verify:

```bash
cd /Users/davidbloom/Documents/Cramapple.nosync && git switch main && git pull --ff-only
for f in stripe-webhook get-checkout-status send-parent-payment-email; do
  supabase functions deploy $f --project-ref pcntajvbdfqhbeewmdry --no-verify-jwt --use-api --workdir "$PWD"
done
```

**Verify (Claude, read-only):** versions advanced; `verify_jwt = false` on all three; deployed source re-downloaded and `diff -r` against `main` shows no difference;
Production `stripe_webhook_events` still `processed` for the 5 old rows and no `failed` rows; probes with **invalid** bodies only (no Stripe call, no charge):
`stripe-webhook` POST without a signature → 400 `invalid_signature`, `get-checkout-status` with a bad session id → 400.

**Tranche 2** — only after §4 is confirmed and tranche 1 verified:

```bash
for f in create-checkout-session create-post-purchase-addon create-parent-payment-link; do
  supabase functions deploy $f --project-ref pcntajvbdfqhbeewmdry --no-verify-jwt --use-api --workdir "$PWD"
done
```

(`create-parent-payment-link` last.) Same verification, plus an invalid-body probe of each (expect 400, not 401/500). I will **not** create a Stripe session during verification.

## 6. Risk and rollback

- **Money risk:** tranche 2 as above. Mitigated by the §4 checks and by deploying the parent-link function last.
- **Entitlement risk:** a wrong `STRIPE_WEBHOOK_SECRET` means payments without access. Caught by §4 and by the Gate D smoke test (your own $1 purchase) **before Orly sends the code**.
- **Schema:** already applied (`APPROVAL-0069`); the webhook needs it, so tranche 1 is safe now.
- **Rollback:** redeploy the two August sources from `scripts/stripe-cutover/prod-rollback-2026-10-02/`; for the new functions, delete them (or don't deploy parent-link) to restore today's behavior.
- **No data rollback needed:** none of these functions run migrations.

## 7. This approval does NOT authorize

Setting or changing any secret; any Stripe dashboard action (account, prices, coupon, webhook endpoint); the Lovable publishable key or publish (which is what turns **card** payment on);
the open-hand migration; the `student-session-items` function; any `db push`; the Orly email; or the go/no-go.

## 8. To approve

Reply with an explicit yes. You can approve **tranche 1 now** and **tranche 2 later** (recommended): e.g., "Approved — deploy tranche 1."
I will then record `APPROVAL-0070`, hand you the commands, verify, and report each check.
