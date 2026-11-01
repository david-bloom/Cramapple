# Subject access before study entry

**Status:** Ready for Review
**Tier:** Standard implementation; Production release remains Hard-Gate
**Owner:** Codex conductor; Product Owner David Bloom
**Created / approved:** 2026-10-31
**Branch:** `codex/work-subject-access` in Cramapple and ap-prep-blueprint
**PR:** [Backend #584](https://github.com/david-bloom/Cramapple/pull/584) · [App #42](https://github.com/david-bloom/ap-prep-blueprint/pull/42)

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

Implemented 2026-11-01 in paired backend/app branches. Live baseline inspected 2026-10-31; production subject switch and question readback did not check subject entitlement, while submit did. No account identifiers or raw student data are stored in this public record.

- Backend: current-user subject/pack access RPCs, selection/onboarding checks, learning-session insert/reactivation trigger, get_question_experience gate, gated study guides, and early Edge Function start/resume/serve checks. Unknown access returns 503; missing access returns 403. Existing staff QA roles remain exempt for study entry; grading rules are unchanged.
- App: per-account catalog/full-pack/Home/guide caches; available-subject filtering; Home and direct study links gated; denied teaching requests cannot fall through into practice; denied scoring/serving removes the question. Practice no longer preloads its key or shows an optimistic result. Transient grading retries retain the selected response and existing resumable chain.
- BYOQ retains its existing reference endpoint; authenticated subject study uses the new gated endpoint with no fallback. This preserves the explicitly excluded identity-agnostic BYOQ behavior. Shared BC reference content checks BC access, not access to the source subject.
- The 2026-10-31 paywall proposal is still DRAFT/unapproved and is not implemented here.

Validation: app TypeScript check, 130 test files / 1,266 tests, and production build passed. Backend handler suites: 55 tests passed. Isolated PostgreSQL migration/fixtures passed: missing/active/expired/future/revoked grants, account isolation, selection, onboarding, session insert/reactivation, legacy session readback denial, requested-subject guides and function privileges. Added a dedicated SQL CI workflow. These are implementation checks, not an independent QA verdict.

Local app dependencies were installed with npm without rewriting the stale npm lockfile; repository CI uses the committed Bun lockfile on Node 22 and is the release gate. Production browser verification and independent QA remain pending.

**QA result:** implementation checks passed; independent QA pending. **Done decision:** not requested.

**Release sequence, after review and explicit Production approval:** apply `20261031143302_subject_access_before_study.sql`, deploy `session-event` and `student-session-items` with `_shared/subject-access.ts`, then publish the paired app commit. Recheck the live definitions before migration. Exercise denied/allowed accounts and revocation end-to-end in the published app. No grants, payments, or account identities change.

**Rollback:** retain the server access checks while investigating frontend regressions; revert app publication if needed. Any rollback that removes access enforcement needs explicit approval. The migration creates no entitlement data and deletes no records.

**Next owner/action:** independent reviewer checks the paired PRs and CI; David approves the exact Production release once review is complete. No Production changes were made in this session.
