# TASK-0078 A5 — Required write failures

Status: Ready for Review; implementation author verification only
Date: 2026-10-21
Branch: `codex/task-0078-required-write-errors`
PR: [#536](https://github.com/david-bloom/Cramapple/pull/536)
Tier: Standard; deployment remains separately gated

David explicitly requested action 5: replace the empty advanceWorkflow catch with logged, surfaced failures; apply the same treatment to admin-content's ten audited groups and capture-pairing cancellation. Governing evidence: `SWALLOWED_ERROR_AUDIT_2026_10_21.md` and the canonical TASK-0078 A5 checklist. The owner ruling freezes review endpoint deployments; this source-only fix does not redesign review or lift that freeze.

Required database operations now inspect resolved errors as well as thrown transport failures. Logs identify the request/assignment, safe operation step and error code; raw database details are not returned.

- Review: eight required status transitions and both group reads propagate failures. Status updates require a returned row. The handler returns HTTP 500 `workflow_advance_failed`, `decision_recorded:true`, `reconciliation_required:true` and the assignment ID when advancement fails after the immutable decision committed. Optional secondary tutor QA remains best-effort and now logs its read/upsert failures.
- Admin: all ten audited groups are checked: compatibility item/choices/criteria/labels, artifact labels, legacy item/version state, the audit anchor, label reads and legacy projection reads. The prior-state RPC also fails instead of fabricating a draft state on database error. A checked failure returns HTTP 500 `admin_content_failed` with a safe failed_step and reconciliation_required. Earlier independent writes can remain committed; this is not rollback or automatic idempotency recovery.
- Capture: cancel write errors return HTTP 500 `pairing_cancel_failed`. A zero-row compare-and-set for a previously active token returns HTTP 409 `pairing_cancel_conflict`, with no false cancellation acknowledgement or provenance event. Successful cancellation and already-terminal behavior are retained.

Admin/review handlers are exported with dependency injection and import.meta.main entry guards, following the existing attempt/evaluate pattern. Capture's entry point also becomes import-safe. Default deployed authentication and caller policy remain unchanged.

Verification: exact Minimal CI command **322 passed**. The **67** targeted tests cover every audited admin group (including each deciding-read failure), all review status branches/group reads, an immutable-decision partial failure, successful review/admin operations and capture cancel error/conflict/success. Transport/error-detail isolation is covered by helper tests. All three handlers type-check; the new helper/tests lint clean. CI includes the four suites, with fixture environment names and no runtime network permission.

Limits: not a transactional redesign, not a repair of historical stuck decisions or partial admin operations, and not a permission to blindly retry partially committed requests. Human-review staffing, reviewer qualifications and the deployment freeze are unchanged. Independent source QA, operator recovery assessment and approved Development/Production releases remain pending. No deployment, migration, flag change or main merge was performed.

Next owner: independent reviewer/conductor. Review error propagation, partial-commit responses and auth preservation; keep review endpoint deployment frozen until the owner re-plans it. This PR is independent of #535 and the earlier refactor stack.
