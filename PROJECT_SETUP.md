# Cramapple Project Setup

## Purpose

This file identifies the installed Cramapple configuration of the AI Project Operating Kit. The
upstream kit is a reusable template; the approved files in this repository govern Cramapple.

## Session entry point

Every substantive Cramapple session, including Claude and Codex sessions, starts with:

- `docs/team_charter/CRAMAPPLE_SESSION_START.md`

Agent-specific convenience prompts point to the same bootstrap:

- `prompts/CLAUDE_NEW_SESSION_PROMPT.md`
- `prompts/CODEX_NEW_SESSION_PROMPT.md`

## Installed operating documents

- `docs/team_charter/AI_COLLABORATION_RULES.md` — authority, source of truth, roles, and branch rules.
- `docs/team_charter/TASK_WORKFLOW.md` — task metadata, tiers, and statuses.
- `docs/team_charter/AGENT_OPERATING_MODEL.md` — conductor, implementation, live-state, and independent-QA roles.
- `docs/team_charter/STANDING_APPROVAL_LANES.md` — standing, batch, and hard-gate authority.
- `docs/team_charter/HANDOFF_PACKET_TEMPLATE.md` — required packet for Standard and Hard-Gate execution or QA.
- `docs/team_charter/DEFINITION_OF_DONE.md` — completion and QA requirements.
- `docs/team_charter/TOOL_AND_INTEGRATION_GUIDE.md` — project-specific service boundaries.
- `docs/team_charter/CHANGELOG.md` — approved operating-policy changes.

## Cramapple configuration

- Canonical repository: `david-bloom/Cramapple`.
- Product Owner and final launch approver: David Bloom.
- Learning domain approver: Orly Bloom, within the approved delegated lane.
- Marketing/GTM domain approver: Micah Bloom, within the approved delegated lane.
- Durable source of truth: current GitHub records, not chat history or local-only files.
- Branch pattern: one reviewable slice per `<agent>/<task-or-work-id>-<slug>` branch; promotion to
  `main` is by pull request.
- Standard and Hard-Gate work receives fresh-context independent QA before the Main Conductor can
  mark it Done.
- Production launch, deployments, migrations, secrets, payments, privacy/legal decisions, and
  material operating-policy changes remain Hard Gates.

## Current launch entry point

For the October 2, 2026 free launch, begin with:

- `docs/product/LAUNCH_RUNBOOK_2026_10_02.md`
- `docs/product/APP_LAUNCH_READINESS_INDEX_2026_09_26.md`

The runbook is the short execution surface. The readiness index and five component plans retain the
full reasoning, corrections, commercial-launch follow-ups, and historical context.
