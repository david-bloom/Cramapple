# APPROVAL-0208 — Free trial without a card: plan approved for Development-only design and build (granted 2026-11-09; nothing released)

- **Date:** 2026-11-09
- **Decision:** Approved, **limited to Development and draft work**. No Production change, publish, send, deploy, switch change or flag enablement is authorized by this entry.
- **Granted by:** David Bloom (Product Owner), in chat on 2026-11-09: "Approve recommendations", in answer to "Answer D1-D8, or approve the plan's recommendations?" about `docs/product/FREE_TRIAL_NO_CARD_CHANGE_PLAN_2026_11_09.md`. The decisions are recorded in `DECISION-0135`. This entry reads that answer as approving the plan for Development and draft work; if a narrower reading was meant, say so.
- **Tier:** Hard-Gate (entitlements, access control, payments adjacency, public pages, minors' data).
- **Numbering check:** on 2026-11-09 `main` ended at APPROVAL-0207 and DECISION-0134; no open pull request claimed APPROVAL-0208 or DECISION-0135.

## What is approved
1. A backend design spec (backend session), then Development backend build for a single-subject cardless 7-day trial.
2. App changes (start step, `/home` subject prompt, days remaining, pay prompt) behind a disabled flag, in draft pull requests that are not merged without the owner.
3. Lovable prompts for marketing and checkout changes as **drafts only**; none is sent to Lovable without the owner's explicit go-ahead.
4. Independent Codex QA before any release request.

## What this does not approve
- Any Production migration, edge-function deploy, secret, switch or flag change, Lovable publish, email or Loops send, PostHog schema change.
- Switching the **card trial** off in Production (the last step of the rollout; needs its own approval).
- Retiring the live 72-hour sample's switches.
- Any price, bundle or Reddit-conversion definition change.

## Rollback
Documentation only. Work done under this entry is in draft branches that are not merged without the owner.
