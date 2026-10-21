# TASK-0078 A4 — Grade persistence failures

Status: Ready for Review; implementation author verification only
Date: 2026-10-21
Branch: `codex/task-0078-grade-write-failures`
PR: [#535](https://github.com/david-bloom/Cramapple/pull/535)
Tier: Standard; deployment remains separately gated

David explicitly requested action 4: read the errors on both final grade writes and fail the request when persistence fails. Governing finding: `SWALLOWED_ERROR_AUDIT_2026_10_21.md`, two evaluate-attempt must-fail rows; canonical checklist: TASK-0078 A4. Current main includes the owner rulings at `dea6717d`; those rulings do not supersede this fix.

Both final grading_results updates now read the error and select the acknowledged request row. A database error or zero updated rows returns HTTP 500 `{error:"grade_store_failed"}` before any computed score, downstream attempt truth, memory, mastery or final telemetry is returned/written. The log includes request ID, route and database code; the response contains no raw database detail. MCQ, LLM and shadow grading policy and successful response statuses remain unchanged.

Verification: exact Minimal CI command **278 passed**; evaluate-attempt suite **23 passed**, including nine added request cases for database errors, zero rows and success across MCQ, LLM and shadow paths. LLM tests fake the provider response in-process and restore fetch in finally; no runtime network permission, live credentials, model calls or spend. Handler type-check and diff whitespace check pass. The workflow explicitly includes the handler suite and fixture environment-name allowlist.

Limits: this does not make grading and every downstream write one transaction. An unsuccessful final store can leave the existing processing record unresolved, and an ambiguous transport outcome may already have committed. No automatic retry, paid regrading, hash change, processing-row reclaim or new recovery policy is introduced. The separately audited attempts truth/analytics/memory failures are outside this action. Independent source QA and Development verification are pending; no deployment, migration or main merge occurred.

Next owner: independent reviewer/conductor. Review both store checks and failure tests; approve an exact Development release before any Production proposal. Do not redeploy the earlier helper/replay stack implicitly with this independent main-based PR.
