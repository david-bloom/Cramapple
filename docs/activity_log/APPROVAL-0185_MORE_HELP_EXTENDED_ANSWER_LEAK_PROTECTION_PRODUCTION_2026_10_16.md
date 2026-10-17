# APPROVAL-0185 — Deploy extended answer-leak protection to Production (2026-10-16)

**Approver:** David Bloom (chat, 2026-10-16: "Push to production, i don't need to read"; also "leave those prompt-only" for explain/justify asks).
**Numbering note:** 0181–0183 live on other branches; 0184 on PR #477; this is 0185. Renumber on merge if needed.

## What changed
Production `more-help` v2 → **v3** (project `pcntajvbdfqhbeewmdry`, deployed 2026-10-16 20:17 UTC from PR #477 branch). Source diff vs v2 (commit `c58ff339`) is exactly three files: `contract.ts`, `contract_test.ts`, `diagnostics.ts`. Adds `statedConclusionKinds`: FRQ subparts asking to state a direction/sign, named law/principle/theorem, a read-off value (midline, period, amplitude, domain, range, asymptote, end behavior) or a verdict get a pre-submit coaching boundary; direction/value/law also get deterministic checks (`direction_subpart`, `value_subpart`, `law_subpart`); verdict, and "explain/justify/what does this show" asks, stay prompt-only (owner ruling). No database or app change. No subject newly enabled.

## Evidence
36 backend tests pass. Development v19 live check: 8 of 9 FRQs delivered on a second synthetic identity, 0 refusals by the new rule, 1 unrelated `invalid_model_sources`; one earlier law false positive found and fixed. Owner chose not to read outputs. See the gap catalog §7.
Post-deploy: Production lists `more-help` v3 ACTIVE; unauthenticated POST is rejected (JWT enforced).

## Known effect
Applies to live subjects too (Calculus AB/BC, Statistics, Chemistry): about 11–13 FRQs each in units 1–3 receive the new boundary. A reply caught by a deterministic check shows the student "couldn't connect". Not live-smoked in Production.

## Rollback
Redeploy the prior source: `git checkout c58ff339 -- supabase/functions/more-help` then `supabase functions deploy more-help --project-ref pcntajvbdfqhbeewmdry --workdir <repo> --use-api` (explicit ref; the home-directory CLI default is Production).
