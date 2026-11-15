# APPROVAL-0206 — Paywall change plan approved for Development-only design and build (granted 2026-11-08; nothing released)

- **Date:** 2026-11-08
- **Decision:** Approved, **limited to Development/draft work**. No Production change, publish, send or deploy is authorized by this entry.
- **Granted by:** David Bloom (Product Owner), in chat on 2026-11-08, approving the plan in `docs/product/PAYWALL_CHANGE_PLAN_2026_10_31.md` as revised 2026-11-08 (merged in PR #580 and PR #589). The exact words are in the chat transcript, not reproduced here; this entry records that approval was given in chat and what it covers.
- **Tier:** Hard-Gate (access control, payments adjacency, public pages, minors' data).
- **Numbering check:** on 2026-11-08 `main` ended at APPROVAL-0205 and DECISION-0132; no open pull request and no remote branch claimed APPROVAL-0206. No new `DECISION-xxxx` is created: the plan's local D1–D5 and D8–D10 remain plan-local identifiers.

## What is approved

1. Phase 0 read-only verification and the per-unit sample audit (`docs/product/PAYWALL_PHASE0_AND_UNIT_AUDIT_2026_11_08.md`).
2. Development-only backend design and build, owned by the `paywall-backend` session (branch `paywall-backend-sample-access`).
3. App and marketing UI built in the local app clone behind a **disabled** flag, analytics contract and email copy as **drafts**, in draft pull requests that are not merged.
4. An independent Codex QA pass before any release request.

## What this does not approve

- Any Production migration, edge-function deploy, Lovable publish, email or Loops send, PostHog schema change, or flag enablement. Each needs its own approval entry (plan §9, Phase 3).
- The open rules in plan §8 and the experiment in §6: anonymous repeat/switching allowance; attempt-start/consumption/retry rules; out-of-unit uploads; identity and eligibility uniqueness; trial-transition precedence; rollback behavior; **D6** experiment design; **D7** nurture emails (whether, when, content, classification, preferences). Implementation that depends on one of these is built behind a marked placeholder and flagged, not decided.
- Any change to the seven-day card trial (`DECISION-0126`) or to the identity-agnostic BYOQ policy.

## Evidence at approval time

- Phase 0 found live checkout showing "Total due today $39.99" while the live landing page says "pay nothing today", and `/try` returns 404 (audit doc §1). Sample-ready units exist for Units 1–3 per subject; later units commonly fail the 8-MCQ test (audit doc §2).
- Existing `get_graded_mcq_feedback` requires an authenticated owner; the anonymous first-MCQ path needs a new reviewed contract.

## Rollback

Documentation only. Revert the pull request carrying this entry; work done under it is in draft branches that are not merged.
