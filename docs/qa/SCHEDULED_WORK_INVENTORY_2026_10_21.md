# Scheduled-work inventory (Assessment 4)

**Verdict: six `pg_cron` jobs run on Production and all six are succeeding, but two jobs the data model needs have no invoker at all: `app.sweep_learning_sessions` (4 Production sessions have been `active` for more than 24 hours, the oldest since 2026-09-23) and the 24-month photo redaction (DECISION-0111), which is admin-triggered only.** The August statement "pg_cron is not installed" is stale: `pg_cron` is installed on both projects. The runbook's "4 cron jobs, 4 Vault entries" on 2026-10-20 is also consistent with what I see once the two TASK-0077 jobs and four trial/email Vault names written on 2026-10-21 are added (section 3). "Succeeded" in `cron.job_run_details` only means the SQL statement ran; for the three jobs that call an Edge Function through `pg_net`, success is proven separately by 276 HTTP 200 responses in `net._http_response` since 2026-10-21 11:28 UTC.

**Status:** read-only assessment, proposals only. **Date:** 2026-10-21 (queries ran about 17:20-17:30 UTC). **Author:** Claude (Sonnet 5.5).
**Reviewed against:** Cramapple `main` at `df39cd09`; Production `pcntajvbdfqhbeewmdry`; Development `wmgjsdkphcyhngaffbqf`.
**Evidence convention:** **Verified** = read in source at the recorded commit, or returned by a read-only query quoted in the appendix. **Inferred** = a conclusion from verified facts. **Not verified** = not demonstrated. Vault: names only; no secret value was read. `cron.job.command` text was passed through a redaction regex before display, which also masked two function names (jobs 3 and 6 on Production, 2 and 5 on Development); their targets are inferred from the job names and the function list.

## 1. Live state (Verified)

| | Production | Development |
| --- | --- | --- |
| Extensions | http, pg_cron, pg_net, pg_stat_statements, pg_trgm, pgcrypto, plpgsql, supabase_vault, uuid-ossp | pg_cron, pg_net, pg_stat_statements, pgcrypto, plpgsql, supabase_vault, uuid-ossp |
| `cron.job` rows | 6, all active | 5, all active |
| Vault names | byoq_function_url, byoq_purge_token, email_worker_function_url, email_worker_secret, qa_grader_anon_jwt_v1, qa_grader_rpc_secret_v1, trial_charge_function_url, trial_charge_worker_secret | byoq_function_url, byoq_purge_token, email_worker_function_url, email_worker_secret, trial_charge_function_url, trial_charge_worker_secret |

## 2. Inventory

| Job | What breaks if it never runs | Invoker | Schedule | Last-run evidence | Env | Status |
| --- | --- | --- | --- | --- | --- | --- |
| `app.sweep_session_targets` (cron 1 `task0019-sweep-session-targets`) | Stale or ineligible Home session targets are never expired, so `issue_session_target` / consumption see old rows | pg_cron | `17 3 * * *` | Prod: 79 runs, last 2026-10-21 03:17 UTC, last 5 succeeded. Dev: 83 runs, last 03:17 UTC | both | running |
| `app.check_content_review_invariants` (Prod cron 2 `content-review-invariants`) | Content-review invariant violations are not reported | pg_cron | `5 6 * * *` | Prod: 79 runs, last 2026-10-21 06:05 UTC, last 5 succeeded | Prod only | running (Prod only; the function body differs between projects, see the drift register) |
| `app.expire_byoq_capture_pairing_tokens` (cron 3 / Dev cron 2 `task0039-expire-byoq-pairings`; function name inferred) | BYOQ pairing tokens never expire | pg_cron | `*/15 * * * *` | Prod 2210 runs, last 17:15 UTC; Dev 2216 runs, last 17:15 UTC | both | running |
| `app.byoq_invoke_purge` (`task0039-byoq-purge`) | BYOQ photo purge stops (privacy retention) | pg_cron → `pg_net` → `byoq` function, token from Vault | `7,22,37,52 * * * *` | Prod 2210 runs, last 17:22 UTC; Dev 2214 runs | both | running (HTTP outcome not separated per job) |
| `app.invoke_charge_due_trials` (`task0077-charge-due-trials`) | Trials are never converted to paid | pg_cron → `pg_net` → `charge-due-trials` | `*/5 * * * *` | Prod 193 runs, last 17:20 UTC; Dev 782 runs, last 17:20 UTC | both | running |
| `app.invoke_deliver_transactional_email` (`task0077-deliver-transactional-email`; function name inferred) | Payment, trial-notice and parent-lifecycle emails sit in the outbox | pg_cron → `pg_net` → `deliver-transactional-email` | `*/2 * * * *` | Prod 483 runs, last 17:22 UTC; Dev 1955 runs, last 17:24 UTC | both | running |
| `app.sweep_learning_sessions(integer)` | Sessions whose time budget has elapsed stay `active` and can block subject switching (TASK-0063) | **none**. The only references are the definition and `comment on` in migration `20260821050000`, which states "Requires an external scheduler; pg_cron is not installed". Source grep finds no caller in `supabase/functions` or any other migration | n/a | Prod `learning_sessions`: active 4 (all older than 24 h, oldest `started_at` 2026-09-23 17:18 UTC), archived 187 (latest 2026-10-20 00:33 UTC), completed 63. Who archived the 187 is **Not verified** (a one-off batch is Inferred from the identical 00:33:38 timestamps) | Prod | no invoker |
| 24-month photo redaction, DECISION-0111 (`app.response_attachments_due_for_redaction(interval)` + `app.redact_response_attachment` + admin op `redact_attachment` in `attempt-response`) | Photo bytes older than 24 months are never removed | Admin operation only (`attempt-response/index.ts` `redact_attachment`); nothing calls `response_attachments_due_for_redaction` on a schedule (grep over `supabase/` and `docs/tasks`) | n/a | Prod: 0 attachments exist (0 redacted of 0); 0 due at a 24-month threshold. The first possible due date is after the first attachment is 24 months old, so nothing is overdue | Prod | not built (no scheduler; no exposure yet) |
| `app.public_endpoint_hits` clean-up | Table grows without bound | Opportunistic: `delete … where created_at < now() - interval '1 day'` inside the rate-limit function (`20261015210000_public_endpoint_rate_limit.sql:83`) | on use | Prod: 34 rows, oldest 2026-10-20 22:44 UTC, newest 2026-10-21 12:34 UTC (older than one day is gone only if the function ran after the first hour; consistent with it running) | Prod | running on use (Inferred) |
| Trial notice worker inside `deliver-transactional-email` | Day-before-charge notices are never sent | Same job as the email worker above (`claim_trial_notice_jobs` is claimed by that function) | `*/2` | as the email worker | both | running |
| `trial-recovery` function | Failed-charge recovery attempts are not made | No cron job, no Vault name, and no `invoke_*` function for it. Who calls it is **Not verified** (Stripe webhook or `charge-due-trials` may call it directly) | n/a | not measured | both | scheduled but unproven (invoker not found) |
| `growth_event_outbox` flush | PostHog events stay undelivered | Delivery appears to be inline from `_shared/growth-events.ts`; no scheduled flush found | n/a | Prod: 206 rows, 2 with `delivered_at` null, newest 2026-10-21 12:45 UTC. Whether the 2 are in flight or stuck is **Not verified** | Prod | scheduled but unproven |
| `transactional_email_outbox` flush | Emails stay queued | The `*/2` email job | `*/2` | Prod: 0 rows ever (the table is empty, so no delivery has been exercised there). 276 HTTP 200s from `pg_net` since 11:28 UTC show the worker answers | Prod | scheduled but unproven (no row has ever passed through) |
| Model-usage ledger housekeeping (`app.reserve_model_usage`, `complete_model_usage`) | Reservations left open consume budget | No cleanup job found in source or cron | n/a | not measured | Prod | **Not verified** (nothing found; not queried further) |
| QA grader secrets (`qa_grader_*` Vault names, Prod only) | n/a | Read by `verify_qa_grader_token` on use | on use | names present on Prod, absent from Dev | Prod | n/a |

## 3. Reconciling the two statements the task flagged

- **"Production had 4 cron jobs and 4 Vault entries on 2026-10-20" (TASK-0077 runbook).** The TASK-0077 task file's survey (line 254) says Production then had "No cron jobs and no trial or email Vault entries", and the 2026-10-21 session close records "Vault (4 entries, written by David)" and cron jobs 5 and 6 added for the trial. Today Production has 6 jobs: jobs 1-4 (session-target sweep, content-review invariants, BYOQ expiry, BYOQ purge) existed before TASK-0077 and jobs 5-6 were added on 2026-10-21. The Vault holds 8 names: 4 pre-existing (the two BYOQ names and the two `qa_grader_*` names) plus 4 trial/email names. So "4 and 4" describes the state before the trial launch; it does not contradict today's 6 and 8. **Inferred**: the 10-20 survey dates are from different surveys written on different days; I did not see the 10-20 state itself.
- **"pg_cron was not installed" (migration `20260821050000`, 2026-08-21).** Not true today on either project. Production's `task0019-sweep-session-targets` has 79 daily runs, so it was scheduled roughly 79 days ago (about early August; **Inferred** from the run count, not from a creation timestamp). The comment on `sweep_learning_sessions` is therefore stale as to the platform, but the function still has no job.

## 4. Questions for David

1. Should `app.sweep_learning_sessions` be scheduled (for example hourly, grace window of your choice)? Four sessions have been `active` since September and can still trigger `active_session_blocks_subject_switch` for those users. A Hard-Gate migration would add the cron job; I did not propose a grace value.
2. Do you want a scheduled caller for `response_attachments_due_for_redaction` before the first photo can age 24 months (no attachment exists yet), or is the admin operation the intended permanent mechanism?
3. Who invokes `trial-recovery`? If nobody, is it meant to be on the `*/5` charge job or its own job?
4. The 2 undelivered `growth_event_outbox` rows: is there a retry path I did not find, or should delivery be scheduled?
5. Should the stale text in migration `20260821050000` ("pg_cron is not installed") be corrected in a comment-only migration or left as history?

## 5. Appendix: queries and commands

All database queries were `SELECT` only, through the Supabase MCP `execute_sql`, against the project named. `cron.job.command` was selected through `regexp_replace(command, '(eyJ[A-Za-z0-9_.-]{10,}|[A-Za-z0-9_-]{32,})', '<redacted>', 'g')`.

```sql
-- both projects
select (select string_agg(extname,',' order by extname) from pg_extension) ext,
       (select count(*) from cron.job) jobs,
       (select string_agg(name,',' order by name) from vault.secrets) vault_names;

-- both projects: job list, run counts, last five statuses
select j.jobid, j.jobname, j.schedule, j.active,
       left(regexp_replace(j.command, '(eyJ[A-Za-z0-9_.-]{10,}|[A-Za-z0-9_-]{32,})', '<redacted>', 'g'),260) cmd,
       (select count(*) from cron.job_run_details d where d.jobid=j.jobid) runs,
       (select max(start_time) from cron.job_run_details d where d.jobid=j.jobid) last_start,
       (select string_agg(status,',' order by start_time desc) from
          (select status,start_time from cron.job_run_details d where d.jobid=j.jobid order by start_time desc limit 5) x) last5
from cron.job j order by jobid;

-- Production only
select status_code, count(*), min(created), max(created) from net._http_response group by 1 order by 1;
-- result: 200, 276 rows, 2026-10-21 11:28:00 to 17:26:00 UTC
select 'sessions', status::text, count(*)::text, max(coalesce(ended_at,updated_at))::text from app.learning_sessions group by status
union all select 'stale_active_over_24h', count(*)::text, min(started_at)::text, null from app.learning_sessions where status='active' and started_at < now()-interval '24 hours'
union all select 'redaction_due_24mo', count(*)::text, null, null from app.response_attachments_due_for_redaction(interval '24 months')
union all select 'attachments', count(*) filter (where redacted_at is not null)::text, count(*)::text, min(created_at)::text from app.response_attachments
union all select 'endpoint_hits', count(*)::text, min(created_at)::text, max(created_at)::text from app.public_endpoint_hits
union all select 'growth_outbox', count(*) filter (where delivered_at is null)::text, count(*)::text, max(created_at)::text from app.growth_event_outbox
union all select 'email_outbox', count(*) filter (where delivered_at is null)::text, count(*)::text, max(created_at)::text from app.transactional_email_outbox;
```

Source searches (from the repository root at `df39cd09`): `grep -rln "sweep_learning_sessions" supabase docs`; `grep -rn "sweep_learning_sessions" supabase/functions supabase/migrations`; `grep -rln "redact_response_attachment\|response_attachments_due_for_redaction" supabase docs/tasks docs/product docs/decisions`; `grep -rn "public_endpoint_hits" supabase/migrations supabase/functions | grep -i delete`; `grep -rn "trial-recovery" supabase/migrations docs/runbooks`. `docs/tasks/TASK-0077-SEVEN-DAY-CARD-TRIAL.md:254` and `docs/handoffs/SESSION_CLOSE_2026_10_21_TASK0077_LAUNCH.md:23-24,38-39,77` were read for the reconciliation. The broad candidate grep in the task prompt (`cron|pg_cron|schedule|sweep|worker|retention|net.http_post` across migrations, functions, tasks, product docs) was **not run in full**; the targeted searches above replace it, so a scheduled job not named in the candidate list could be missing from the table.
