# Security Review — Pre-Launch (2026-10-15)

STATUS: CURRENT
SCOPE: this repository (Supabase schema, 26 edge functions, Stripe flow, CI). Production DB inspected **read-only**. The Lovable-hosted student frontend lives in a separate repo and was **not** reviewed.
CONTEXT: launching this week; users are minors; payments via Stripe.

## Verdict

No launch-blocking vulnerability found in the reviewed scope. The data layer and payment flow are materially better than typical AI-built apps. Open items are hardening and process, listed below in priority order.

## What was checked and held up

| Area | Result |
| --- | --- |
| Row-level security | Every `app.*` table has RLS on (one view-helper, `content_item_topic_resolution`, has no grants to client roles). 33 tables have RLS and no policy — deny-by-default, intentional. |
| Cross-student reads | `public.*` tables have own-row policies (`auth.uid() = student_id`); `public.*` views are `security_invoker=true`, so they respect the caller's RLS. |
| `SECURITY DEFINER` functions callable by signed-in users (19) | All 19 reviewed. Student-facing ones gate on `auth.uid()`; admin ones (`gold_set_admin_overview`, `content_review_invariant_report`) check `role = 'admin'`; reviewer ones check assignment or admin. All pin `search_path`. |
| Storage | `learner-uploads` is owner-scoped by path prefix; other buckets are service_role only. No public buckets. |
| Stripe | Webhook verifies signature (`constructEventAsync`) and is the sole entitlement authority; prices come from a server-side catalog, never the client; idempotent event ledger. |
| Secrets | None found in tracked files (Stripe, Supabase, Anthropic, Resend, Google key patterns). Git history was spot-checked for Stripe live/webhook keys only; a full-history scan (e.g. gitleaks) is still worth running. Edge functions read secrets from env. |
| Edge-function auth | Money/session/storage functions call `requireProfile`; email hook verifies a Standard Webhooks signature; transactional-email delivery requires a bearer secret; CORS has no wildcard fallback. |
| AI cost abuse | `evaluate-attempt` and `more-help` have quota/budget controls (`app.daily_budgets`, `model_usage_ledger`). |

## Fixed in this PR (no user-visible change)

1. Revoked `EXECUTE` on `app.cm_d19_release_template` / `app.cm_d19_revoke_template_release` from `anon`/`authenticated`/`PUBLIC`. Operator-only; never called by the app.
2. Added `.github/dependabot.yml` (GitHub Actions + `web/` npm).

**Not applied to Production.** The migration is a file in this PR; apply via the normal approval lane after merge.

## Recommended, needs your decision (changes behaviour or needs a dashboard)

| # | Item | Why it matters | Cost |
| --- | --- | --- | --- |
| 1 | **Rate-limit anonymous endpoints**: `create-parent-payment-link`, `resolve-parent-link`, `get-checkout-status`. | They are unauthenticated and unthrottled. Abuse = unlimited Stripe Checkout Sessions, promo-code guessing, short-code probing. Real money-adjacent exposure. | Small code change; needs a per-IP limit that does not block a parent on a shared school network. |
| 2 | **Enable leaked-password protection** (Supabase Auth). | Blocks known-breached passwords. Advisor WARN. | Dashboard toggle (Pro plan). Rejects some passwords at signup. |
| 3 | **MFA on owner accounts**: Supabase, Vercel, GitHub, Stripe, Lovable, Resend, Loops. | One phished account bypasses every control above. | None to students. |
| 4 | **Minors / COPPA & FERPA review by counsel.** Terms say "under 13: do not use without parental consent" but there is no age gate or consent capture. Refund draft already flags under-18 contracting as a counsel question. | Under-13 data collected without verifiable consent is a regulatory exposure, independent of code quality. | Counsel + possibly an age gate. |
| 5 | **Review the Lovable frontend repo** (security headers, any `VITE_*` env exposure, dependency audit). | Not in this repo; the part users actually touch. | Separate pass. |
| 6 | **Production alerting**: Stripe webhook failures, auth error spikes, function 5xx. | Detection gap, not a vulnerability. | Small. |
| 7 | **Revoke unneeded `anon` table grants** on `public.*`. | Defence in depth; RLS already returns nothing to anon. | Must first confirm no pre-login screen reads them (e.g. feature flags). |
| 8 | **Move `pg_trgm` / `pg_net` out of `public`.** | Advisor WARN. | Can break functions that reference them; test on Development first. |

## Advisor items judged acceptable
- `rls_enabled_no_policy` ×33 (INFO): intentional deny-all, service_role access only.
- `authenticated_security_definer_function_executable` ×19 (WARN): intentional RPC surface, each gated in-body (see above).
- `web/` npm audit: 2 moderate (`react-router`). `web/` is the prototype; confirm it is not what ships.

## Method limits
Static review of code and Production schema/grants/policies plus Supabase advisors. No active attack testing, no Production writes, no Stripe dashboard review, Supabase Auth settings not readable from here.

## Status update (end of 2026-10-15)

Superseded where this conflicts with the sections above. Full record: `docs/handoffs/SESSION_CLOSE_2026_10_15_SECURITY_REVIEW_AND_RATE_LIMITS.md`.

- **Fixed in this report's PR (#465) and now applied to Production:** the operator-function lockdown (`20261015200000`). Dependabot is enabled.
- **Recommended item 1 (rate-limit anonymous endpoints): done and live in Production** (PRs #471, #472; migration `20261015210000`; limits 30 / 120 / 240 per IP per hour and 600 / 3000 / 6000 global). Per-IP cap not proven end to end on a deployed function; see the handoff.
- **Recommended item 2 (leaked-password protection): on in Production and Development**, minimum password length 8 (reported by owner).
- **Recommended item 3 (MFA on owner accounts):** owner states all tools use 2FA or keychain; not independently verified.
- **Recommended item 5 (Lovable frontend):** dependency scan remediated and published; one `dangerouslySetInnerHTML` removed, two kept with reasons. Security headers and CSP still not reviewed.
- **Still open:** item 4 (COPPA / FERPA counsel), item 6 (alerting), item 7 (anon table grants), item 8 (extensions in `public`), plus the items in section 7 of the handoff.
