# Approval Request — Stripe Payment Schema to Production (3 migrations)

**Status:** REQUESTED — **not approved. Nothing in this document has been run on Production.**
**Requested by:** Claude (Main Conductor). **Approver:** David Bloom (Product Owner).
**Proposed ID when approved:** `APPROVAL-0069` (`0068` is taken on `main`; confirm the next free ID at record time).
**Governing records:** `TASK-0041`, `DECISION-0094`, `docs/product/STRIPE_PRODUCTION_CUTOVER_CHECKLIST_2026_09_30.md` (Gate C, step D)
**Tier:** Hard-Gate (Production migration, payments)

## 1. What you are approving

Apply three **additive** migrations to Production (`pcntajvbdfqhbeewmdry`), in this order, each in its own transaction. All three
are already committed on `main` and have run on Dev.

| # | File | Result | SHA-256 |
|---|---|---|---|
| 1 | `20260928134000_task0041_payment_runtime_repair.sql` | creates `app.stripe_customers` (RLS on, service-role only). Re-states two tables and their policies that already exist (no-op) | `179f390a7d2ba36bd8cf0114fb3b1a15f013713daebf975823ff59720d27bdfc` |
| 2 | `20260928135500_task0041_parent_email_audit.sql` | creates `app.parent_payment_email_requests` (stores a hash of the parent email only; RLS on, service-role only) | `57e7baa53eb13f79ca9b1400de63143dbe420548a871c05d3d973ee4e3a158ee` |
| 3 | `20260928191213_task0041_webhook_replay.sql` | adds `status`, `attempt_count`, `last_attempt_at` to `app.stripe_webhook_events`; backfills the 5 existing rows; adds a status CHECK; creates `app.claim_stripe_webhook_event(text)` (service-role execute only) | `82f59796494214c7601e0719213adbfa201c42178076de0843766a649f9c1139` |

I will apply the **exact file bytes** and confirm the SHA-256 of each before applying.

**Why now, and why in this order:** the new `stripe-webhook` calls `claim_stripe_webhook_event` and writes `stripe_customers`
(`index.ts:282-303` throws on error). Deployed before these migrations it would fail every student checkout in Production and
grant no entitlement. The functions are **not** deployed by this approval.

## 2. Pre-flight evidence (read-only, 2026-10-02)

- Production already has `stripe_checkout_sessions`, `stripe_checkout_session_attempts`, `stripe_webhook_events` and `subject_entitlements`.
  The first three are **column-for-column identical to Dev** (verified 2026-09-30), so migration 1 does not alter them.
- Migration 1 does `drop policy if exists … / create policy …` on tables that already carry a policy of the **same name, same role
  (`service_role`), same command (`ALL`)**. It is replaced by an identical policy inside one transaction. Existing grants
  (`service_role`: INSERT/SELECT/UPDATE/DELETE) and RLS (enabled) already match.
- Production's extra indexes on `stripe_checkout_sessions` (`coupon_ids`, `promotion_code_ids`) are untouched.
- `stripe_webhook_events` has 5 rows, **all with `processed_at` set and no error**, so migration 3's backfill sets all 5 to `processed`.
- `claim_stripe_webhook_event`, `stripe_customers` and `parent_payment_email_requests` do not exist in Production today.
- Migration 3 takes a brief exclusive lock on a 5-row table (`alter column … set not null`). No traffic of consequence: card payment is
  switched off on the live site and the parent-pay function isn't deployed.
- **Not included:** `20260929034129_open_hand_entitlement_scoped_contract.sql` (TASK-0051 gate). No `db push`.

## 3. How I would run it

1. Re-read Production state (the queries in §2) and the three file hashes. **Stop if anything differs.**
2. Apply migration 1 → check → migration 2 → check → migration 3 → check, via the Supabase `apply_migration` tool. Stop at the first error.
3. Record each applied version from `supabase_migrations.schema_migrations` in the approval record. `apply_migration` stamps its own
   version, which won't match the filename (known drift, `TASK-0055`). I will **not** rename files or run `db push` without a separate instruction.

## 4. Post-apply checks (each must pass)

```sql
-- tables exist, RLS on
select relname, relrowsecurity from pg_class c join pg_namespace n on n.oid=c.relnamespace
where n.nspname='app' and relname in ('stripe_customers','parent_payment_email_requests','stripe_webhook_events');
-- only service_role has policies/grants on the two new tables (no anon/authenticated)
select tablename, policyname, roles from pg_policies where schemaname='app' and tablename in ('stripe_customers','parent_payment_email_requests');
select table_name, grantee, privilege_type from information_schema.role_table_grants
 where table_schema='app' and table_name in ('stripe_customers','parent_payment_email_requests') and grantee in ('anon','authenticated');  -- expect 0 rows
-- replay columns + backfill
select status, count(*), min(attempt_count) from app.stripe_webhook_events group by 1;   -- expect processed = 5
-- claim function exists and is not executable by anon/authenticated
select has_function_privilege('anon','app.claim_stripe_webhook_event(text)','execute') a,
       has_function_privilege('authenticated','app.claim_stripe_webhook_event(text)','execute') b,
       has_function_privilege('service_role','app.claim_stripe_webhook_event(text)','execute') c;  -- expect f, f, t
-- untouched
select count(*) from app.subject_entitlements;   -- expect 253 (unchanged unless real activity)
```

Also run Supabase's security advisor and confirm no **new** warning for these objects.

## 5. Risk and rollback

- **Risk is low.** Everything is additive; no existing column or row is dropped or rewritten except the 5-row status backfill, and the old
  Production webhook (v20) keeps working during the gap (new columns have defaults: `status` defaults to `received`, `attempt_count` to 0).
- **Rollback:** not needed for data. If a check fails, I stop and report; I do not drop tables that might hold rows. If an object must be
  removed, it is a separate, reviewed `DROP` (the new tables are empty at apply time).
- **Do not leave it half-done:** if migration 3 fails after 1 and 2 succeed, the old webhook is unaffected and Production stays functional.

## 6. This approval does NOT authorize

Deploying any function; setting or changing any secret; Stripe live-mode changes (account, prices, coupons, webhook endpoint); switching on
card payment in Lovable; the open-hand migration; any `db push`; any data change in `subject_entitlements`; or the go/no-go.

## 7. To approve

Reply in chat with an explicit yes (e.g., "Approved — apply the three Stripe migrations to Production"). I will then record `APPROVAL-0069`,
apply, verify, and report each check's result.
