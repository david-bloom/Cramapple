# TASK-0012 — Production Plumbing and Cutover Readiness

**Task ID:** TASK-0012
**Title:** Production Plumbing and Beta-to-Prod Cutover Readiness
**Owner:** Main Conductor
**Product Owner:** David Bloom
**Status:** In Progress
**Priority:** High
**Created Date:** 2026-06-20
**Approved Date:** Pending

## Product Goal

Define and prepare the production plumbing needed to move Cramapple from beta
validation into a governed production launch once UX001 and UX006 are stable.
The goal is to make the deployment, authentication, secrets, observability,
and environment boundaries explicit before any cutover.

## Technical Scope

- Define the production and beta environment split.
- Define which services own identity, durable data, orchestration, and delivery.
- Inventory required production accounts, keys, certificates, and service roles.
- Define the environment-variable matrix for local, beta, preview, and production.
- Define the backend boundary between Lovable, Vercel, Supabase, and any other
  approved infrastructure.
- Define deployment, rollback, logging, and monitoring expectations.
- Define cutover readiness checks for account flow, assessment flow, and content
  publishing flow.
- Define the release sequence for any future production migration or secret
  rotation.

## Working Plan

This task is being executed as a documentation-first production boundary plan.
The concrete operating draft now lives in:

- `docs/architecture/PRODUCTION_PLUMBING_AND_CUTOVER_PLAN.md`
- `docs/architecture/PRODUCTION_PLUMBING_EXECUTION_CHECKLIST.md`

Known Vercel projects:

- `cramapple-dev` (`prj_Vgjlo4aQKKtDnjw4iMzsT1znT7SQ`) for non-production work.
- `cramapple` (`prj_o6OPEaC541tFdI3VDjfhnLG9TlGG`) for production.

Known Supabase projects:

- `Cramapple-Development` (`https://wmgjsdkphcyhngaffbqf.supabase.co`) for
  non-production work.
- `Cramapple-Production` (`https://pcntajvbdfqhbeewmdry.supabase.co`) for
  production.

That plan is the source of truth for:

- environment split and ownership;
- required production accounts and keys;
- environment-variable matrix;
- trust boundaries for auth, content, assessment, and storage;
- logging, rollback, and cutover sequence;
- secret rotation and escalation rules.

## Known Cutover Blockers

The following issues are known or strongly suspected from current review and
must be closed or explicitly accepted before production cutover:

- confirm and document the current Lovable Cloud runtime boundary for the beta
  front-end, then move all authoritative backend behavior off Lovable Cloud
  before any production cutover;
- confirm the non-production Supabase project is `Cramapple-Development`
  (`https://wmgjsdkphcyhngaffbqf.supabase.co`) and the production project is
  `Cramapple-Production` (`https://pcntajvbdfqhbeewmdry.supabase.co`);
- confirm whether any live beta grading or session mutation logic still runs
  inside Lovable-hosted `_serverFn` infrastructure instead of the intended
  server boundary, and migrate it if so;
- confirm whether beta and production share the same Supabase project or other
  provider resources, and if so document a formal isolation or migration plan;
- fix and verify the content-publishing defects in `admin-content` and the
  governance migration path before claiming content-publishing readiness (see
  the itemized list in
  `docs/architecture/PRODUCTION_PLUMBING_EXECUTION_CHECKLIST.md` §1.3a);
- ensure startup fails fast on missing required secrets rather than silently
  defaulting to empty values.

### 2026-07-09 migration-file reconciliation and new findings

Local `supabase/migrations/` had drifted from both live projects — 15 applied
migrations existed on one or both projects with no corresponding local file.
This session pulled the exact applied SQL for all 15 directly from
`supabase_migrations.schema_migrations` on both projects and verified every
file byte-for-byte via `md5(array_to_string(statements, E'\n'))` before
committing. Local files now match both live projects exactly as of this
commit. Two things surfaced in the process that are new blockers, not closed
items:

- **Undocumented production decision reference.** Migration
  `202607090002_curated_public_interface_revoke_anon.sql`, applied to
  *production* on 2026-07-09, cites `DECISION-0035` in its lead comment.
  `docs/activity_log/DECISIONS_LOG.md` tops out at `DECISION-0032` — 0033,
  0034, and 0035 do not exist anywhere in the log. A production schema change
  citing an approval record that was never recorded is a Source-of-Truth Rule
  violation (`docs/team_charter/AI_COLLABORATION_RULES.md`) on top of being a
  database migration, which is independently a Hard Gate
  (`STANDING_APPROVAL_LANES.md`). **Someone applied production schema changes
  outside this repo's tracked/approved migration flow.** David: please confirm
  who ran this and whether DECISION-0033/0034/0035 exist in some other record
  that needs to be backfilled here, or whether this needs to be treated as an
  unauthorized change.
- **Dev/prod schema divergence.** Development (`wmgjsdkphcyhngaffbqf`) has 7
  migrations production does not: HDR response assets, calibration sets,
  bootstrap FRQ schema, grading experiments, AP Chemistry/Physics 1 subject
  instantiation, student memory runtime context, and FRQ synthetic responses
  (all dated 2026-07-07, presumably TASK-0013/TASK-0010-adjacent research
  work). Notably, the chemistry/physics migration marks those two subjects
  `status = 'active'` in dev even though `EXPAND-001` (second exam pack) is
  `Deferred` in `docs/MASTER_TODO.md`. This is dev-only and the exam packs
  themselves stay `draft`, but it's schema-level evidence that subject
  expansion work has already started ahead of the backlog's own deferral —
  worth a policy check, not just a technical one.

A QA review prompt covering this reconciliation plus a fresh code-review pass
on `admin-content`'s publish-gate trust model is drafted at
`prompts/CODEX_TASK0012_BACKEND_MIGRATION_QA_REVIEW.md`.

## Out of Scope

- Building the production frontend.
- Shipping UX001 or UX006 features themselves.
- Changing live secrets, migrations, or deployment settings without approval.
- Final legal, privacy, or procurement decisions.
- Final content-authoring or grading-policy decisions.

## Routes / Components / Systems Affected

- Student application deployment.
- Authentication and session services.
- Backend-for-frontend and API gateway.
- Production Supabase project and Edge Functions.
- Production Vercel deployment and runtime environment.
- Observability, logging, and alerting systems.
- Content publishing and release workflows.

## Data / Security / Integration Impact

This task introduces production-sensitive boundaries for secrets, provider
credentials, environment variables, routing, and observability. It must keep
service credentials server-side, separate beta from production state, and avoid
placing authoritative logic in the client. It also must make rollback and
incident review possible without exposing protected learner data to unrelated
systems.

## Acceptance Criteria

- [ ] Beta and production environment responsibilities are explicitly mapped.
- [ ] Required production services and credentials are inventoried.
- [ ] Environment variables are categorized by environment and owner.
- [ ] Server-side trust boundaries are defined for auth, content, and grading.
- [ ] Logging, metrics, error reporting, and alerting requirements are defined.
- [ ] Deployment and rollback flow is documented.
- [ ] Cutover criteria for UX001 and UX006 are documented.
- [ ] Secret storage, access limits, and rotation expectations are documented.
- [ ] Approval boundaries for any future production change are explicit.

## QA Plan

- Manual QA: Review the boundary definitions against the architecture docs and
  the beta product flows.
- Automated tests: Markdown link and formatting checks when available.
- Regression areas: Client-side authority, secret leakage, beta/prod confusion,
  missing rollback path, and undefined monitoring.
- Failure cases: Environment mismatch, unsafe credential sharing, skipped
  observability, or a cutover plan that depends on unreviewed beta state.
- Security/data/integration checks: Confirm no live systems, secrets, or
  deployments are changed by this document alone.

## Approval State

**Approval Required:** Yes
**Approval Type:** Hard Gate
**Decision:** Pending

## Implementation Notes

This task follows the architecture direction in:

- `docs/architecture/HIGH_LEVEL_SYSTEM_ARCHITECTURE.md`
- `docs/architecture/SYSTEM_CONTEXT_AND_LOGICAL_COMPONENT_ARCHITECTURE.md`
- `docs/architecture/CONTENT_GOVERNANCE_AND_VALIDATION.md`
- `docs/architecture/SUPABASE_EDGE_FUNCTIONS_DRAFT.md`
- `docs/architecture/PRODUCTION_PLUMBING_AND_CUTOVER_PLAN.md`

It is intended to bridge the beta surfaces from UX001 and UX006 into a
governed production launch without mixing product validation work with release
plumbing.

The following checks must be complete before this task can be marked ready:

- runtime-boundary confirmation that Lovable is front-end only in the target
  state, plus a documented migration plan for any backend logic still running
  there today;
- runtime-boundary confirmation for any Lovable-hosted backend logic, with
  migration to Vercel/Supabase where needed;
- beta/production resource separation or a documented exception with a
  migration plan;
- fresh-database smoke test for auth, assessment, content publish, and storage
  paths;
- explicit verification that publish authorization and service-role writes are
  functioning as intended.

## QA Review

Pending. Fire `prompts/CODEX_TASK0012_BACKEND_MIGRATION_QA_REVIEW.md` in a
fresh, independent context to verify the 2026-07-09 migration reconciliation
and the `admin-content` gate-trust findings above.

## Done Decision

**Decision:** Pending
**Date:** Pending
