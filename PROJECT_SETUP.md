# Cramapple Project Setup

**Operating Kit:** `david-bloom/ai-project-operating-kit`
**Primary Repository:** `david-bloom/Cramapple`
**Product Owner:** David Bloom
**Status:** Installed; initial governance configured June 9, 2026

## Source of Truth

Durable project state lives in:

- GitHub product and architecture documents.
- Task files and issues.
- Pull requests.
- Activity, approval, and decision logs.
- QA notes and handoff packets.

If a decision exists only in chat, it is not authoritative for operating purposes.

## Current Product and Stack

**Product:** AP score optimization, launching with AP Biology.
**Architecture direction:** Low-code implementation using tools such as Lovable, Supabase, Vercel, and model APIs. Final architecture remains subject to approved technical design.

## Roles

- **Product Owner:** David Bloom.
- **Functional co-founder, Learning:** Orly Bloom.
- **Functional co-founder, Marketing and Go-to-Market:** Micah Bloom.
- **Advisor:** Naama Bloom.
- **Strategy Advisor:** Advises David and the co-founders on plans and business decisions; does not independently approve scope or execution.
- **Main Conductor:** Coordinates source of truth, approvals, agents, QA integration, and publishing.
- **Implementation Agent:** Executes approved work.
- **QA Agent:** Produces independent proposed findings and evidence.
- **UX / Prompt Agent:** Handles user-facing behavior and prompt work when assigned.

## Standing Approvals

Low-risk read-only research, draft documentation, planning, handoff preparation, and QA planning are pre-approved as described in `docs/team_charter/STANDING_APPROVAL_LANES.md`.

## Hard Gates

David's explicit approval is required for:

- Product scope, priority, and material positioning changes.
- Architecture choices that create material cost, security, privacy, or vendor lock-in.
- Implementation outside an approved task.
- Database migrations or destructive data actions.
- Deployments, production configuration, secrets, and environment changes.
- Payment live-mode actions.
- Contracts, material spending, or paid commitments.
- Use of copyrighted or licensed content in the product.
- Privacy policy, parental access, student data, and legal-risk decisions.
- Public performance claims, launch, risk acceptance, Done decisions, and task closure.

## Tools and Skills

Use project-relevant GitHub, document, browser, Lovable, Supabase, Vercel, model-provider, and QA workflows. Tool access never overrides an approval boundary.
