# Cramapple Tool and Integration Guide

**Status:** Approved
**Owner / Product Owner:** David Bloom

(Renamed from `SKILLS_GUIDE.md`. This guide covers project-specific tool and integration skills only. Role definitions, agent boundaries, source-of-truth rules, QA process, and approval lanes live in `AI_COLLABORATION_RULES.md`, `AGENT_OPERATING_MODEL.md`, and `STANDING_APPROVAL_LANES.md` — not here. The four sections that used to restate those rules here ("Source of Truth," "Implementation / Live State," "QA," "Strategy") were removed because a second copy of a role rule drifts from the first; if an agent reads only this file because the task looked technical, it would miss updates made to the canonical doc.)

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
