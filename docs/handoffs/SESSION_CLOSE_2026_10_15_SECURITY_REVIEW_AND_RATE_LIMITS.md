# Pre-Launch Security Review, Payment-Endpoint Rate Limits and Hardening: Session Close (2026-10-15)

Status: session close. Launch week; users are minors; payments through Stripe.
Findings report: `docs/security/SECURITY_REVIEW_2026_10_15.md` (has a status update appended). This document is the record of what was done, what was verified, what was not, and what is still open.

## 1. Outcome

No launch-blocking vulnerability was found in the reviewed scope (Supabase schema, 26 edge functions, Stripe flow, CI). Two real gaps were closed and are live in Production:

1. The three unauthenticated payment endpoints (`create-parent-payment-link`, `resolve-parent-link`, `get-checkout-status`) now have per-IP and global hourly rate limits.
2. Two operator-only functions (`app.cm_d19_release_template`, `app.cm_d19_revoke_template_release`) are no longer executable by `anon` or `authenticated`.

Also done: leaked-password protection turned on in Supabase Auth (Production and Development), Dependabot added, and the Lovable frontend's dependency findings remediated and published.

## 2. What shipped

| Item | Where | Reference | State |
| --- | --- | --- | --- |
| Review report, operator-function lockdown migration `20261015200000`, `.github/dependabot.yml` | repo | PR #465 | merged; migration applied to Development and Production |
| Rate-limit table + function, migration `20261015210000`; `_shared/public-rate-limit.ts`; wiring in the three functions; unit tests added to Minimal CI | repo | PR #471 | merged; applied and deployed to Development and Production |
| Limiter made self-contained (no longer imports the 22 KB `_shared/byoq.ts`); behaviour unchanged | repo | PR #472 | merged; deployed code is identical to it |
| `react-dom` 18 -> 19.3.0 in `web/` (Dependabot), conflict with main resolved | repo | PR #470 | merged (conflict: main already had `react` 19 and `react-router-dom` 7 with `react-dom` 18) |
| Leaked-password protection on; minimum password length 8 | Supabase Auth, both projects | owner action | Production and Development advisors no longer list the warning. The length of 8 was reported by David and cannot be read from the advisor |
| Frontend dependency fixes: `react-router-dom` and `@tailwindcss/vite` removed, `katex` ^0.16.22, `source-map-js` override; one `dangerouslySetInnerHTML` removed (`src/routes/_authenticated/reviewer.tsx`) | Lovable project "New Cramapple App" | Lovable reports 121 files / 1190 tests pass, type check clean | published by David on 2026-10-15. Post-publish behaviour not checked by this session |

## 3. Limits (decision)

| Endpoint | Per IP per hour | Global per hour |
| --- | --- | --- |
| create-parent-payment-link | 30 | 600 |
| resolve-parent-link | 120 | 3000 |
| get-checkout-status | 240 | 6000 |

Reasoning: a school or family shares one IP, so per-IP numbers must tolerate a classroom. They exist to stop scripts, not people. Raise them in `public-rate-limit.ts` if real families hit them.

Design properties:
- **Fails open.** If the limiter errors, the request proceeds and the error is logged. A parent who is trying to pay is never blocked by the throttle breaking.
- **Only allowed requests are recorded.** A flood of denied requests cannot inflate the global counter and lock real parents out.
- **No raw IPs stored.** Only an HMAC (64 hex characters). Key: `PUBLIC_RATE_LIMIT_HMAC_KEY`, else `BYOQ_IP_HMAC_KEY`, else the service-role key. The first is not set today. Rotating the service-role key would change the hashes, which only resets the counters.
- Blocked callers get `429 {"error":"rate_limited","retry_after_seconds":N}` with a `Retry-After` header.
- The table `app.public_endpoint_hits` and function `app.record_public_endpoint_hit` are `service_role` only. Old rows are cleaned up opportunistically (2% of calls delete rows older than a day).

## 4. Current deployed state

| | Development `wmgjsdkphcyhngaffbqf` | Production `pcntajvbdfqhbeewmdry` |
| --- | --- | --- |
| Migrations | `20261015200000`, `20261015210000` | `20261015200000`, `20261015210000` |
| `resolve-parent-link` | v14 | v5 |
| `get-checkout-status` | v33 | v9 |
| `create-parent-payment-link` | v31 | v7 |
| `verify_jwt` | false (unchanged) | false (unchanged) |

Bundle fingerprints (`ezbr_sha256`) are identical across the two projects, so Production runs byte-for-byte the code that was tested on Development:
- resolve-parent-link `7c7ad0bf7028b9ce08b61869ad98c212fd04042a5871e779612198dd2d8e1bf4`
- get-checkout-status `028cef3920c0e781e407d6376ef82c0f63c8409695152e66b3b57339714e48f9`
- create-parent-payment-link `a70b56da7431b6c5d12dde37ae97bc8612b68ad824cc0d73b67ecf2f246373f3`

Before overwriting Production, its three functions were confirmed to be `main` as it was before the change (two had identical fingerprints to Development's previous copy; `create-parent-payment-link` was compared file by file).

## 5. Verification, and its limits

Verified:
- Database objects on both projects: operator functions and the new function have `anon` and `authenticated` execute = false and `service_role` = true; the new table has RLS on and no client grants.
- SQL logic (Development, rolled back, then applied): hits 1-3 allowed, 4th blocked with `retry_after_seconds` 3600, a second caller unaffected, global cap trips independently.
- Deployed function on Development: boots, answers normally (404 / 400 / 400 on deliberately invalid input, nothing created in Stripe), records each call as a 64-character hash. The block path was proven end to end by seeding the global counter past its cap (rows timestamped 58 minutes old so the artificial block expired by itself): the function returned `429` with `Retry-After: 60`, then recovered to normal about 2 minutes later.
- Production live check: David ran the three invalid-input calls from his own terminal; `app.public_endpoint_hits` showed exactly one hit per endpoint (23:08 UTC), each a 64-character hash. The Production security advisor was unchanged by this work.

Not verified:
- **The per-IP cap through a deployed function.** The test sandbox's outbound traffic came from a pool of at least 17 IPs, so 121 requests could not be sent from one address. The per-IP logic is covered by the SQL test and the unit tests only.
- The block-and-recover test was deliberately not run on Production (it would have briefly blocked real parents and written thousands of rows).
- Post-publish behaviour of the Lovable app, including that styling is intact after `@tailwindcss/vite` was removed (Lovable says the shared build config supplies the plugin).
- David's statements that all tool accounts use 2FA or keychain, and that the minimum password length is 8.
- Frontend security headers and CSP.

## 6. Reviewed and judged acceptable (do not redo)

- Row-level security on every `app.*` table; own-row policies on `public.*`; `public.*` views are `security_invoker`.
- All 19 `SECURITY DEFINER` functions callable by signed-in users: student ones gate on `auth.uid()`, admin ones check `role = 'admin'`, reviewer ones check assignment or admin; all pin `search_path`.
- Storage: `learner-uploads` owner-scoped by path; other buckets `service_role` only; no public buckets.
- Stripe: webhook verifies the signature and is the sole entitlement authority; prices come from a server-side catalog; idempotent event ledger.
- Edge-function auth, CORS (no wildcard), AI-cost controls (`app.daily_budgets`, `model_usage_ledger`).
- No secrets found in tracked files. Git history was spot-checked for Stripe live and webhook keys only.
- Lovable repo: `.env` is committed but holds only the Supabase URL and publishable key. The two remaining `dangerouslySetInnerHTML` uses (`Formula.tsx` KaTeX with `trust` off; `Figure.tsx` SVG built from admin-authored `app.figures` rows) were kept. The escaping code in `src/lib/figures/render.ts` was not read by this session.

## 7. Open items

| # | Item | Owner | Notes |
| --- | --- | --- | --- |
| 1 | **COPPA / FERPA review by counsel** | David | The largest remaining risk. Terms say under-13s should not use the service without parental consent, but nothing checks age or captures consent. Ask: parental consent and an age gate; FERPA obligations when selling to schools; whether the Terms need changing for under-18 contracting (the refund draft already flags it) |
| 2 | First-week monitoring of the limiter | David / next session | `select endpoint, count(*), count(distinct key_hmac) from app.public_endpoint_hits group by 1;` daily. If real users reach a 429, raise that endpoint's numbers |
| 3 | Prove the per-IP cap on a deployed function | next session | Needs a single-IP client, e.g. David's own terminal with 121 requests to Development |
| 4 | Lovable repo follow-ups | David / Lovable | Check security headers and CSP; confirm only one lockfile (it has both `bun.lock` and `package-lock.json`); delete the unused static mocks `public/progress-mock-v2.html` and `public/course-mode/*.html` (publicly reachable); look at `render.ts` escaping |
| 5 | `web/` prototype cannot install or build | David | `@vitejs/plugin-react` 6 needs `vite` 8 but the project is on `vite` 5, so `npm ci` fails with ERESOLVE and `vite build` fails on `main` too. Tests pass because they never touch React. Options: align `vite` / plugin-react, or retire `web/` and its Dependabot entry. Dependabot will keep opening major bumps for it |
| 6 | Development differs from Production | next session | Development only: `public.scc_rehearsal_chunks_20261006` has no RLS (advisor ERROR); 12 `SECURITY DEFINER` functions (10 in `app`, 2 in `public`) are executable by `anon`. Production does not show these. Decide whether Development should mirror Production |
| 7 | Advisor leftovers on Production | next session | `cm_d19_*` search path still mutable (execute was revoked instead); `pg_trgm` and `pg_net` in `public` (moving them may break functions, test on Development first) |
| 8 | Not done | next session | Revoke unneeded `anon` table grants on `public.*` (first confirm no pre-login screen reads them, e.g. feature flags); full-history secret scan (e.g. gitleaks); alerting on Stripe webhook failures, auth error spikes and function 5xx |

## 8. Rollback

- Rate limits: redeploy the three functions from commit `3b72e134` (the last commit before this work). The new table and function are inert without the callers.
- Operator-function lockdown: `grant execute on function app.cm_d19_release_template(text, uuid, jsonb, uuid, text), app.cm_d19_revoke_template_release(text, uuid, uuid) to authenticated;` (not recommended).

## 9. Approvals (David's instructions in the session, 2026-10-15)

No `APPROVAL-NNNN` records were created by this session; David should add them to `docs/activity_log/APPROVALS_LOG.md` if the log is to carry these. The instructions were:
- "Fix anything which has no impact on user experience or functionality" (scope of the first fixes).
- "Build rate limits for the payment endpoints" (PR #471).
- "Yes, apply the migrations to Development" and "Yes, deploy the functions to Development".
- "do all three steps the same way I did them on Development" (apply migrations, deploy the three functions, test; carried out on Production, with the live test run by David because the session's network policy blocked the Production host).
- "clean up the Development test rows" (3,152 rows deleted from `app.public_endpoint_hits`; the table is empty on Development).
- "check PR 470 for conflict, resolve and merge it" (PR #470).

## 10. Operating notes for the next session

- This cloud session's network policy allows the Development Supabase host but not Production's. To call Production endpoints from a session, add `pcntajvbdfqhbeewmdry.supabase.co` under the environment's Allowed domains.
- Sandbox egress rotates across many IPs, so any per-IP test from it is unreliable.
- `execute_sql` through the Supabase tool timed out on `DELETE` statements twice and worked later; treat as a flaky tool, check state with a read before retrying.
- The Supabase tool's `query_logs` needs the right log table names; the ones tried (`function_logs`, `function_edge_logs`) did not exist.
