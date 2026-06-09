# Cramapple Skills Guide

**Status:** Approved
**Owner / Product Owner:** David Bloom

## Purpose

Define project-specific skill equivalents that agents should follow even when local skills are unavailable.

## Skill Equivalent: Source of Truth

Use for:

- Docs.
- Task state.
- Issues.
- Activity logs.
- Approval records.
- Handoff packets.

Rules:

- Source-of-truth docs override chat memory.
- Read relevant task/docs before executing.
- Preserve approval boundaries.

## Skill Equivalent: Implementation / Live State

Use for:

- Source code.
- Schema/data.
- Services.
- Logs.
- Live QA.

Rules:

- Read source-of-truth docs first.
- Live state is authority for deployed/runtime behavior.
- Do not change live state without approval.

## Skill Equivalent: Payments / Integrations

Use for:

Stripe when introduced; model providers; email or SMS providers; and other approved external services.

Rules:

- Secrets stay backend-only.
- Client redirects or UI state do not prove trusted outcomes.
- Webhooks/events should be idempotent where relevant.

## Skill Equivalent: Deployment / Serverless Routes

Use for:

Lovable, Supabase, Vercel, and any approved model or serverless provider.

Examples:

- Vercel routes.
- Serverless functions.
- Provider signing routes.
- Environment variables.
- Deployment logs.
- Preview vs production behavior.

Rules:

- Secrets stay server-side.
- Frontend clients must not receive private keys, service-role keys, certificates, or provider signing material.
- Production deployments and env var changes should be hard gates unless explicitly moved to a standing approval lane.
- Live provider state should be persisted in the system of record before downstream status treats it as durable.
- Preview and production behavior must be distinguished.

## Skill Equivalent: Frontend / UX

Use for:

- Frontend prompts.
- Route instructions.
- User-facing copy.
- Client/backend wiring.

Rules:

- Frontend does not own trust decisions.
- Backend/status APIs own gates.
- UI hiding is not security.

## Skill Equivalent: QA

Use for:

- Ready-for-QA tasks.
- Re-QA.
- Evidence review.

Rules:

- QA proposes findings.
- Main conductor owns the integrated QA verdict; David retains any required Product Owner acceptance, risk, Done, or launch decision.
- QA pass does not approve launch.

## Skill Equivalent: Strategy

Use for:

- Vision, positioning, pricing, economics, operating model, and go-to-market planning.
- Decision memos and alternatives.
- Market and competitive research.

Rules:

- Distinguish decisions, hypotheses, recommendations, and open questions.
- State assumptions and evidence quality.
- Challenge the founding team's premise when the evidence warrants it.
- Record durable recommendations and approved decisions in GitHub.
- Strategy advice does not replace Product Owner approval.
