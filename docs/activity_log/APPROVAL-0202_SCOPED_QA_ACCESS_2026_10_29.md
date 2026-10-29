# APPROVAL-0202 — Scoped QA access for the MCQ investigation

**Date:** 2026-10-29
**Approved By:** David Bloom, Product Owner
**Decision:** Approved
**Tier:** Hard-Gate (one scoped Production data correction)
**Related work:** `docs/qa/MCQ_ENTITLEMENT_BLOCK_2026_10_27.md`
**Status:** Executed; independent database read-back verified. Browser resubmission remains an owner check.
**Branch:** `codex/qa-chemistry-access`

## Owner instruction

In the active QA conversation, the owner confirmed that the previously identified test account
should have QA access. This record contains no account identifiers, personal details, payment
history, or raw service results because the repository is public.

## Executable scope

- Enable AP Chemistry for that single, already identified test account through the existing
  `app.subject_entitlements` model, using `access_tier = beta`, `status = active`, and a separate
  manual QA source `owner_qa_20261029` linked to this approval.
- Chemistry is the subject of the reported failure. The implementation takes the narrow subject
  scope and uses access active until revoked (`ends_at = null`), rather than inventing a QA expiry.
- Preserve the student role. Do not reactivate old entitlement rows or change payment records.
- Guard the write with the previously identified attempt's ownership and Chemistry subject,
  verify no duplicate active grant is created, and read back the resulting access predicate.
- Verify `app.authorize_grading_access` accepts that account and the incident attempt without
  submitting or grading another student answer.

No broader subject grant, schema change, deployment, publication, role change or payment action
is approved by this record. The frontend defects remain a separate implementation slice.

## Verification and reversal

If reversal is needed,
revoke only the grant with this manual QA source for the privately identified account and subject.
Do not remove historical records or change unrelated access.

## Execution result (2026-10-29)

The guarded correction created one active Chemistry-only QA grant, active until revoked. A separate
post-write query confirmed exactly one matching active grant and that the profile remains a student.
The authoritative grading authorization RPC accepted the incident attempt. A read-only check in the
test identity's auth context returned an available topic 2.1 teaching item, resolving both access
denials identified in the investigation. No new answer was submitted or graded during verification.

The error-presentation and recovery defects in the question page remain open. This correction
removes the access blocker for the scoped QA flow; it is not an app release or a QA pass.
