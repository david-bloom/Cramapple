# Subject access before study entry

**Status:** In Progress  
**Tier:** Standard implementation; Production release remains Hard-Gate  
**Owner:** Codex conductor; Product Owner David Bloom  
**Created / approved:** 2026-10-31  
**Branch:** `codex/work-subject-access` in Cramapple and ap-prep-blueprint  
**PR:** pending

## Approval and goal

David instructed: “I think just kill it. Students should not have access to subjects for which they aren't entitled”. This authorizes implementation of early subject-access enforcement and removal of the “Your answer was checked, but your progress was not saved. Try saving again” presentation. It does not grant account access or authorize Production migrations/publication.

Related investigation: `docs/qa/MCQ_ENTITLEMENT_BLOCK_2026_10_27.md`. That report's access-specific retry UI proposal is superseded by this instruction: prevent entry first; handle access lost mid-session without retrying a forbidden submission.

## Scope and acceptance

- Student subject options and active-subject resolution use current account entitlement, including status/start/end validity, and fail closed on lookup failure.
- The server enforces access before subject selection, question delivery/current-answer preload and existing-session readback. Direct URLs cannot bypass the gate.
- Authenticated Cheat Sheet access checks the requested subject; sibling reference inheritance checks entitlement to the requesting subject.
- An answer is presented as scored only after authoritative grading succeeds. Remove the separate optimistic-result save banner; retain the selected response and resumable grading chain for transient failures.
- Access denied during a session removes the study content and offers an accessible Account/Home exit.
- Do not change entitlements, payments, roles, anonymous BYOQ, staff review workflows, or unrelated content.

## QA plan

Regression tests cover authorized/denied accounts, expired/future/revoked grants, account switching and cache isolation, direct links, revocation after page load, genuine missing worked examples, and transient submit retry without duplicate attempts. Backend handler tests prove denial before answer/media delivery. Database checks run in a rollback-only fixture. App tests/typecheck/build and backend tests must pass before release consideration.

## Implementation / evidence

Pending. Live baseline inspected 2026-10-31; production subject switch and question readback did not check subject entitlement, while submit did. No account identifiers or raw student data are stored in this public record.

**QA result:** pending. **Done decision:** not requested. **Next owner/action:** Codex implements and verifies; David approves the exact Production release when ready.
