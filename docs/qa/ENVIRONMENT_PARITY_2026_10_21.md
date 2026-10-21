# Environment parity: Development vs Production (assessment 6)

**Status:** read-only inventory · **Date:** 2026-10-21 · **Read against:** `main` `73206cde` · **Branch:** `claude/assessments-5-6-2026-10-21` · **Companion:** `TEST_GATE_INVENTORY_2026_10_21.md` · **Projects:** Production `pcntajvbdfqhbeewmdry`, Development `wmgjsdkphcyhngaffbqf` · **Changes:** none.

## Summary

**Verified.** Development and Production differ in ways that can make a rehearsal mislead. The three most likely to mislead, in order: (1) **`GRADING_ENTITLEMENTS_ENABLED` is `true` on Production and absent on Development**, and the code treats absence as `false`, so Development runs the submit-time entitlement gate off; (2) **`FRQ_PHOTO_SUBJECTS` is absent on Production and set on Development**, so photo answers are dark on Production but live on Development; (3) **`SERVICE_ROLE_KEY` is set on Production and absent on Development**, and two code paths fall back to an empty string when it is missing, so a Development rehearsal of those paths runs with no service key (*the runtime effect is not verified*). Beyond the three: Development lacks `start-trial` (deployed to Production only), nine deployed functions have different bundle hashes on the two projects, and the migration ledgers share only 84 versions (274 are only on Production, 108 only on Development).

Two findings contradict the prompt or the references it cites:

- **Security review item 6 is not what the prompt says.** In `docs/security/SECURITY_REVIEW_2026_10_15.md`, item 6 is *Production alerting*. The anon-executable `SECURITY DEFINER` check the prompt describes is closest to item 7 (*revoke unneeded `anon` table grants*). I ran the prompt's queries as written; they are a check of anon function execute, **not** a verification of item 6. Item 7 (anon table grants on `public.*`) was not run.
- **The advisor and the database disagree on Production's anon-executable functions.** The query finds 11 `app` functions on Production that `anon` can execute as `SECURITY DEFINER`; the Production security advisor reports no `anon_security_definer_function_executable` lint. The advisor may scope to exposed schemas; **not verified**.

## 1. Secrets (names and digests only)

Values are never read. `true` and `false` mean the digest equals `sha256("true")` or `sha256("false")`; `set` means a value exists whose digest is neither. `absent` means the name is not in `supabase secrets list`. Counts: Production 71 names, Development 74, 67 shared, 4 Production-only, 7 Development-only.

**Flag-shaped names (`*_ENABLED`, `*_SUBJECTS`, `*_RETIRED`, `*_MODE`):**

| Name | Production | Development | Code default when absent | Effect on a Development rehearsal |
|---|---|---|---|---|
| `GRADING_ENTITLEMENTS_ENABLED` | **true** | **absent** | `"false"` (`attempt-response/index.ts:122`, `evaluate-attempt/index.ts:122`) | Submit-time entitlement gate is **off** on Development |
| `FRQ_PHOTO_RESPONSES_ENABLED` | true | true | `"false"` (`attempt-response/index.ts:70`) | Same on both |
| `FRQ_PHOTO_SUBJECTS` | **absent** | **set** (not a boolean) | `null` (`student-session-items/index.ts:101`, `attempt-response/index.ts:86`) | Photo subject list is **empty** on Production, **set** on Development |
| `TRIAL_ADMISSION_ENABLED` | true | true | `=== "true"` | Same on both |
| `TRIAL_CHARGES_ENABLED` | true | true | `=== "true"` (`charge-due-trials/index.ts:30`) | **Charges are enabled on Development too.** Whether Development's `STRIPE_SECRET_KEY` is a test key cannot be read from digests; **not verified** |
| `TRIAL_NOTICES_ENABLED` | true | true | `=== "true"` (`deliver-transactional-email/index.ts:29`) | Same on both |
| `LOOPS_PAYER_EMAILS_ENABLED` | false | false | `=== "true"` (`_shared/payer-email.ts:37`) | Same on both |
| `LOOPS_PAYMENT_EMAILS_ENABLED` | false | false | `=== "true"` (`_shared/payment-email.ts:53`) | Same on both |
| `PARENT_EMAIL_LIFECYCLE_ENABLED` | false | false | `!== "true"` disables (`_shared/parent-email-lifecycle.ts:340`) | Same on both |
| `PARENT_EMAIL_USE_SHORT_LINKS` | false | false | short links used unless `"false"` (`send-parent-payment-email/index.ts:94`) | Same on both; links are long-form |
| `CARDLESS_TRIAL_RETIRED` | absent | absent | not retired (`start-trial/index.ts:129`) | Same on both |

**Names on one project only:**

| Production only | Development only |
|---|---|
| `ANTHROPIC_API_KEY`, `GRADING_ENTITLEMENTS_ENABLED`, `POSTHOG_PROJECT_API_KEY`, `SERVICE_ROLE_KEY` | `AUTH_EMAIL_WELCOME_URL`, `DEV_DB_URL`, `FRQ_PHOTO_SUBJECTS`, `LOOPS_INVITE_TRANSACTIONAL_ID`, `LOOPS_MAGICLINK_TRANSACTIONAL_ID`, `LOOPS_SIGNUP_TRANSACTIONAL_ID`, `SEND_EMAIL_HOOK_SECRET` |

Also set on **both** projects and read by no code: `POSTHOG_PROJOECT_API_KEY` (typo; the reader uses `POSTHOG_PROJECT_API_KEY`). `SERVICE_ROLE_KEY` is Production-only, while most code reads `SUPABASE_SERVICE_ROLE_KEY` (set on both); two readers use the shorter name (section 2).

## 2. Readers: names the code reads that a project does not set

Read by code (`grep -rn 'Deno.env.get("…")' supabase/functions`, excluding `_test.ts`), with the default when unset. "Neither" means neither project has the name.

| Name | Read by | Set on | Default when unset | Note |
|---|---|---|---|---|
| `SERVICE_ROLE_KEY` | `byoq/index.ts:290`, `_shared/public-rate-limit.ts:133` | Production only | `""` | **Development: both paths get an empty key.** Runtime effect **not verified** |
| `BYOQ_IP_HMAC_KEY` | `byoq/index.ts:291`, `_shared/public-rate-limit.ts:131` | Neither | falls back to `serviceRoleKey` (empty on Development) | |
| `PUBLIC_RATE_LIMIT_HMAC_KEY` | `_shared/public-rate-limit.ts:130` | Neither | falls back to `BYOQ_IP_HMAC_KEY`, then further (not read in full) | |
| `POSTHOG_PROJECT_API_KEY` | `_shared/growth-events.ts:120` | Production only | falls back to `POSTHOG_PROJECT_TOKEN`, then `POSTHOG_API_KEY` | **Development: growth events have no key and are off** (not verified at runtime) |
| `POSTHOG_PROJECT_TOKEN`, `POSTHOG_API_KEY`, `POSTHOG_HOST` | `_shared/growth-events.ts:121–123` | Neither | host defaults to `https://us.i.posthog.com` | |
| `GRADING_ARM` | `evaluate-attempt/index.ts:138` | Neither | `"b"` | |
| `CAPTURE_QUALITY_MODEL`, `CAPTURE_QUALITY_TIMEOUT_MS`, `CAPTURE_QUALITY_RESERVED_COST_USD` | `capture-pairing/index.ts` | Neither | model `gpt-4o-mini`; others not checked | defaults for the two not checked |
| `FRQ_TRANSCRIPT_TIMEOUT_MS`, `FRQ_TRANSCRIPT_RESERVED_COST_USD`, `FRQ_TRANSCRIPT_DAILY_RUNS`, `FRQ_PHOTO_DAILY_CAP_USD` | `attempt-response/index.ts` | Neither | not checked | |
| `OPENAI_REQUEST_TIMEOUT_MS` | `evaluate-attempt/index.ts:167` | Neither | `90_000` | |
| `PARENT_REMINDER_LEAD_SECONDS` | `_shared/parent-email-lifecycle.ts:98` | Neither | `null` | Both projects lack it; reminder lead time is then unset |
| `LOOPS_QUESTION_REPORT_TRANSACTIONAL_ID`, `QUESTION_REPORT_EMAIL` | `report-question/index.ts:8–11` | Neither | a hard-coded template id and a hard-coded personal address | Question reports go to that address on both projects |
| `MARKETING_BASE_URL` | `deliver-transactional-email/index.ts:46` | Neither | `https://cramapple.com` | |
| `CARDLESS_TRIAL_RETIRED` | `start-trial/index.ts:129` | Neither | not retired | |
| `DENO_DEPLOYMENT_ID`, `SB_EXECUTION_ID` | several | Neither | — | Probably platform runtime variables, not secrets (**not verified**) |

## 3. Functions (`list_edge_functions` on both projects)

`updated_at` is UTC. "Same bundle hash" compares `ezbr_sha256`. `Dev` has no hash for `session-event` (a legacy build, as the refactor review notes). Nine functions are deployed with different bundles on each project. Three deployed functions have **no source directory** in this repository (`grade-frq`, `seed-stimulus-images-2026-07-19`, `open-hand-item`). Two repo directories are deployed to neither project (`content-intake`, `submit-response`).

Counts: Production 29 functions, Development 29, union 31. Only Production: `start-trial`, `seed-stimulus-images-2026-07-19`. Only Development: `open-hand-item`, `send-auth-email`. All listed functions are `ACTIVE`.

| Slug | Prod version (updated, UTC) | Prod verify_jwt | Dev version (updated, UTC) | Dev verify_jwt | Same bundle hash | Source dir in repo |
|---|---|---|---|---|---|---|
| admin-content | v43 (2026-07-11) | true | v41 (2026-06-22) | true | no | yes |
| assign-for-review | v39 (2026-07-12) | true | v37 (2026-07-14) | true | no | yes |
| attempt-response | v42 (2026-10-10) | false | v46 (2026-10-10) | false | yes | yes |
| byoq | v19 (2026-10-17) | false | v37 (2026-10-10) | false | no | yes |
| cancel-trial | v2 (2026-10-21) | false | v12 (2026-10-20) | false | yes | yes |
| capture-pairing | v17 (2026-10-10) | false | v34 (2026-10-09) | false | yes | yes |
| charge-due-trials | v2 (2026-10-21) | false | v12 (2026-10-20) | false | yes | yes |
| create-checkout-session | v33 (2026-10-21) | false | v47 (2026-10-20) | false | yes | yes |
| create-parent-payment-link | v11 (2026-10-21) | false | v44 (2026-10-20) | false | yes | yes |
| create-post-purchase-addon | v8 (2026-10-02) | false | v36 (2026-10-21) | false | no | yes |
| deliver-transactional-email | v3 (2026-10-21) | false | v30 (2026-10-20) | false | yes | yes |
| evaluate-attempt | v81 (2026-10-10) | false | v59 (2026-10-10) | false | yes | yes |
| get-checkout-status | v13 (2026-10-21) | false | v42 (2026-10-20) | false | yes | yes |
| get-trial-status | v2 (2026-10-21) | true | v10 (2026-10-20) | true | yes | yes |
| grade-frq | v38 (2026-07-10) | true | v38 (2026-06-25) | true | no | **no** |
| more-help | v8 (2026-10-17) | true | v29 (2026-10-17) | true | yes | yes |
| open-hand-item | — | — | v30 (2026-09-27) | true | — | **no** |
| report-question | v5 (2026-10-13) | true | v10 (2026-10-13) | true | no | yes |
| resolve-parent-link | v9 (2026-10-21) | false | v22 (2026-10-18) | false | yes | yes |
| review-decision | v49 (2026-08-13) | true | v38 (2026-07-21) | true | no | yes |
| review-queue | v56 (2026-08-02) | true | v37 (2026-07-14) | true | no | yes |
| reviewer-invite | v36 (2026-07-12) | true | v37 (2026-07-14) | true | no | yes |
| seed-stimulus-images-2026-07-19 | v31 (2026-07-19) | true | — | — | — | **no** |
| send-auth-email | — | — | v22 (2026-10-07) | false | — | yes |
| send-parent-payment-email | v13 (2026-10-21) | false | v36 (2026-10-19) | false | yes | yes |
| session-event | v51 (2026-08-03) | true | v40 (2026-06-22) | true | n/a (Dev has no hash) | yes |
| start-trial | v21 (2026-10-21) | false | — | — | — | yes |
| storage-sign-url | v46 (2026-09-23) | true | v43 (2026-09-23) | true | yes | yes |
| stripe-webhook | v33 (2026-10-21) | false | v55 (2026-10-20) | false | yes | yes |
| student-session-items | v44 (2026-10-16) | true | v45 (2026-10-16) | true | yes | yes |
| trial-recovery | v2 (2026-10-21) | false | v10 (2026-10-20) | false | yes | yes |


## 4. Database

**Advisors (`get_advisors`, both projects, security):**

| Lint | Level | Production | Development |
|---|---|---|---|
| `rls_enabled_no_policy` | INFO | 35 | 31 |
| `function_search_path_mutable` | WARN | 2 (`app.cm_d19_*`) | 2 (same) |
| `extension_in_public` | WARN | 2 (`pg_trgm`, `pg_net`) | 1 (`pg_net`) |
| `authenticated_security_definer_function_executable` | WARN | 19 | 28 |
| `anon_security_definer_function_executable` | WARN | **not reported** (see summary) | 12 |
| `rls_disabled_in_public` | ERROR | none | **1: `public.scc_rehearsal_chunks_20261006`** |

**Advisors (performance):** Production: unindexed foreign keys 150, `auth_rls_initplan` 46, unused index 25, duplicate index 4, multiple permissive policies 4, no primary key 1, `auth_db_connections_absolute` 1. Development: unindexed foreign keys 142, `auth_rls_initplan` 47, unused index 38, duplicate index 3, multiple permissive policies 4, no primary key 1, `auth_db_connections_absolute` 1. (Which file is which project was checked by an object that exists only on Production.)

**Anon-executable `SECURITY DEFINER` functions (the prompt's query, `has_function_privilege('anon', …)`):**

- Production, 11 in `app`: `guard_memory_hook_publish`, `guard_reference_entry_unpublish`, `handle_new_user`, `refuse_attempt_on_teaching_item`, `response_versions_guard_submission`, `rollup_pre_submit_hint_count`, `servable_items_census`, `set_assistance_event_derived_fields`, `tg_content_pipeline_guard_publish`, `tg_content_pipeline_on_assignment`, `tg_require_practice_format_at_publish`. No `public` functions.
- Development, 12: in `app`: `check_content_review_invariants`, `content_item_is_published`, `guard_memory_hook_publish`, `guard_reference_entry_unpublish`, `handle_new_user`, `refuse_attempt_on_teaching_item`, `response_versions_guard_submission`, `rollup_pre_submit_hint_count`, `set_assistance_event_derived_fields`, `tg_require_practice_format_at_publish`; in `public`: `content_review_invariant_report`, `select_unit_gated_practice_items`.

**RLS disabled on tables in `app` or `public`:** Production none; Development `public.scc_rehearsal_chunks_20261006` (verified; the advisor also flags it as ERROR).

## 5. Migration ledger (`supabase_migrations.schema_migrations`)

| | Production | Development |
|---|---|---|
| Row count | **358** | **192** |
| Versions present on both | 84 | 84 |
| Versions on one project only | **274** | **108** |

Listed as the prompt asks, without interpretation (Assessment 2 interprets them). Each list is sorted; the Development-only list is first.

**Development only (108):**

```text
20260804170000 20260804183000 20260804190000 20260804203000 20260805100000 20260805110000 20260805120000
20260805130000 20260805140000 20260805150000 20260808200000 20260808201500 20260809130000 20260809150000
20260811160000 20260811160100 20260813113918 20260813120000 20260815120000 20260815130526 20260815140000
20260815175854 20260815181856 20260816120000 20260817000817 20260817015348 20260818011720 20260819120000
20260819120100 20260820154037 20260820154107 20260820221132 20260820222450 20260820223537 20260820223630
20260821002301 20260821004325 20260821004517 20260821010826 20260821011826 20260821022808 20260821153550
20260821153751 20260821161106 20260821161526 20260821163808 20260821164412 20260821170944 20260821173418
20260821174032 20260821174408 20260822170839 20260822172538 20260822172838 20260823115426 20260823121357
20260823121457 20260823165809 20260823175029 20260823180406 20260823213755 20260823223551 20260823224026
20260824014302 20260824020856 20260824120748 20260824155411 20260826120000 20260923172238 20260923173436
20260924123936 20260924152501 20260926155746 20260926184738 20260926211337 20260926213508 20260927004507
20260927004650 20260927005015 20260927151641 20260927162127 20260927211607 20260927211657 20260928023843
20260928132903 20260928133342 20260928133855 20260928151821 20260928155840 20260928191344 20261003202054
20261004230256 20261005021221 20261006084914 20261007004124 20261007180947 20261009112941 20261009115159
20261013015714 20261013020239 20261015175807 20261015232212 20261018191924 20261018191935 20261019142835
20261020224101 20261020233210 20261020235937
```

**Production only (274):**

```text
20260802021714 20260804193850 20260804201932 20260804202102 20260804205322 20260805130110 20260805130133
20260805185605 20260805203615 20260805204703 20260805233515 20260805234943 20260806013726 20260808192024
20260808195103 20260813123635 20260814190000 20260814200000 20260814210000 20260815141337 20260815181350
20260815181908 20260817000824 20260818014210 20260820154441 20260820154512 20260820221408 20260820222631
20260820223401 20260821002253 20260821011216 20260821011305 20260821011804 20260821021652 20260821022409
20260821022844 20260821023734 20260821154017 20260821161446 20260821163710 20260821163948 20260821164024
20260821164105 20260821164136 20260821173954 20260821174346 20260822170851 20260823122203 20260823224031
20260824020219 20260824020312 20260824020335 20260824020354 20260824020429 20260824020458 20260824020851
20260824121115 20260824122923 20260824130055 20260824161731 20260922004606 20260922005214 20260923172315
20260923172857 20260923173445 20260924130018 20260924130141 20260924131028 20260924133049 20260924135654
20260924140953 20260924141344 20260924142401 20260924143206 20260924143231 20260924154249 20260924231049
20260924235942 20260925000517 20260925001854 20260925002523 20260925010422 20260925012319 20260925012508
20260925012725 20260925012754 20260925012910 20260925013038 20260925013208 20260925013256 20260925020025
20260925020133 20260925020243 20260925020350 20260925020427 20260925020642 20260925020749 20260925020919
20260925021026 20260925021217 20260925021327 20260925021636 20260925021722 20260925021835 20260925021947
20260925022056 20260925022209 20260925022323 20260925022458 20260925022620 20260925022737 20260925100619
20260925100702 20260925100752 20260925100859 20260925101010 20260925101153 20260925101228 20260925101318
20260925101338 20260925101441 20260925101504 20260925101603 20260925101607 20260925101710 20260925101717
20260925101822 20260925102105 20260925102209 20260925102800 20260925112302 20260925112419 20260925112543
20260925112735 20260925112929 20260925113043 20260925113149 20260925113444 20260925113629 20260925121916
20260925124234 20260925132420 20260925132511 20260925132534 20260925164308 20260925164352 20260925164435
20260925164517 20260925164601 20260925164803 20260925165121 20260925165220 20260925165316 20260925165359
20260925165436 20260925165456 20260925165527 20260925165546 20260925165617 20260925165638 20260925165708
20260925165727 20260925165758 20260925165819 20260925165854 20260925165916 20260925165946 20260925170006
20260925170039 20260925170102 20260925204535 20260925204841 20260925205244 20260925205406 20260925205456
20260925205546 20260926031338 20260926031544 20260926031725 20260926031747 20260926031802 20260926031804
20260926031822 20260926031837 20260926031856 20260926031914 20260926032008 20260926032244 20260926032441
20260926032607 20260926032729 20260926032732 20260926032821 20260926032854 20260926032907 20260926032948
20260926032959 20260926113310 20260926113320 20260926113353 20260926121707 20260926122238 20260926140332
20260926164853 20260926195129 20260926211349 20260926213523 20260926233000 20260926233100 20260926233500
20260926234000 20260926234100 20260926234200 20260926234300 20260926234400 20260927004527 20260927004624
20260927004656 20260927005019 20260927010110 20260927014349 20260927112232 20260927112814 20260927113442
20260927113502 20260927113945 20260927114120 20260927114124 20260927114128 20260927151709 20260927162233
20260927181002 20260927184534 20260927211624 20260927211703 20260927215247 20260928122345 20260928122842
20260928165655 20260928165747 20260929071941 20260929102858 20260929102917 20260929103749 20260929110501
20261002001232 20261002001253 20261002001308 20261002164510 20261002170626 20261002184610 20261004120000
20261004130000 20261004140000 20261004223205 20261004231126 20261007181153 20261009113605 20261009115128
20261010210000 20261010210100 20261010210200 20261013131208 20261013131212 20261016000100 20261021003534
20261021003602 20261021003627 20261021010317 20261021010400 20261021010442 20261021010520 20261021010541
20261021010547
```

## Differences that change rehearsal results

1. **`GRADING_ENTITLEMENTS_ENABLED`** — on Production, absent on Development → submit gate off on Development. Verified (secrets and reader default).
2. **`FRQ_PHOTO_SUBJECTS`** — empty on Production, set on Development → photo path behaves differently. Verified (secrets and readers).
3. **`SERVICE_ROLE_KEY`** — set on Production, absent on Development; byoq and public rate-limit fall back to `""`. Verified by code and secret names; runtime effect not verified.
4. **Functions deployed to one project only** — `start-trial` (Production only) and `send-auth-email`, `open-hand-item` (Development only). Verified.
5. **Different function bundles** — nine functions (`admin-content`, `assign-for-review`, `byoq`, `create-post-purchase-addon`, `grade-frq`, `report-question`, `review-decision`, `review-queue`, `reviewer-invite`) have different `ezbr_sha256`. Verified. Whether the difference is code or only build metadata is not verified.
6. **Development charges are enabled** — `TRIAL_CHARGES_ENABLED` is true on Development; whether Development's Stripe key is a test key is not verified from the data here.
7. **Ledger** — the two projects share 84 of the versions (of 358 and 192). Do not use the ledger as proof of parity.
8. **Analytics** — the code finds no PostHog key on Development (see section 2). Verified by code and names; runtime effect not verified.

## Appendix: commands and queries (all read-only)

```bash
supabase secrets list --project-ref pcntajvbdfqhbeewmdry --workdir /Users/davidbloom/Documents/Cramapple.nosync
supabase secrets list --project-ref wmgjsdkphcyhngaffbqf --workdir /Users/davidbloom/Documents/Cramapple.nosync
grep -rhoE 'Deno\.env\.get\("[A-Z_0-9]+"\)' supabase/functions | sort -u   # reader names
```

Supabase MCP (read-only): `list_edge_functions` (both projects); `get_advisors` type `security` and `performance` (both projects); `execute_sql`:

```sql
select n.nspname, p.proname from pg_proc p join pg_namespace n on n.oid=p.pronamespace
  where p.prosecdef and has_function_privilege('anon', p.oid, 'execute') and n.nspname in ('app','public') order by 1,2;
select schemaname, tablename from pg_tables where schemaname in ('app','public') and not rowsecurity order by 1,2;
select count(*) as n, string_agg(version, ',' order by version) as versions from supabase_migrations.schema_migrations;
```

The Production performance advisor file was matched to Production by checking for `gold_set` objects, which exist only on Production per the security advisor.

Working files (secrets comparison, function table generator, ledger comparison) are in the session scratchpad, not in the repository.
