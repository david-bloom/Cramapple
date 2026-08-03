# TASK-0020 Image Readiness Assessment Handoff

Task:
- TASK-0020 — Image and Drawn-Response Launch Readiness

Prompts Included:
- [x] Implementation Agent (read-only assessment)
- [ ] QA Agent
- [ ] UX / Prompt Agent

Current Source:
- Task doc: `docs/tasks/TASK-0020-IMAGE-AND-DRAWN-RESPONSE-LAUNCH-READINESS.md`
- Governing plan: `docs/research/IMAGE_AND_DRAWN_RESPONSE_LAUNCH_GATING_ASSESSMENT_PLAN_V5_2026_08_03.md`
- Prior findings: `docs/research/IMAGE_QUESTION_AND_DRAWN_RESPONSE_SECOND_OPINION_PACKET_2026_08_03.md`
- Related tasks: `TASK-0006`, `TASK-0011`, `UX-003`, `UX-008`, `TASK-0016`
- Relevant approval: `APPROVAL-0041`
- Branch / PR: `codex/image-workflows-readiness` / pending
- Uncommitted / unpushed state: clean at assessment start

Approval State:
- Approved: read-only inventory, source/live-state audit, non-mutating QA, verdicts, and proportional next-approval handoffs.
- Not approved: implementation, migration, deployment, Production writes, learner-image access, new vendor/model selection, operational manual-review setup, automated learner-facing grading, or launch.
- Required before deep Step 2: Product Owner launch-slice decision and Product Owner/Learning Quality minimum viable content volume.

Live / Tool State:
- Environments checked: repository and task governance; Production read-only checks pending.
- Services checked: Supabase source inspected previously; current read-only live scan pending.
- Not checked / unavailable: current student UI behavior, storage object completeness, device/browser capture paths, and live learner-image workflow.

Files / Systems Affected:
- Docs: task, evidence register, inventory report, launch verdicts, remediation handoffs.
- Code: read-only inspection only.
- Data/schema: read-only queries only.
- Integrations: read-only Supabase/deployment evidence only.
- Frontend/routes: non-mutating inspection and browser QA only where authorized.

Open Risks / Blockers:
- P1: launch slice and minimum viable content volume are not yet locked.
- P1: final QA must be performed by a fresh independent context.
- P2: reviewer capacity may constrain manual-review and validation paths.
- Pending owner decisions: exact launch slice, minimum viable volume, essential-image failure behavior, and launch grading/repair mode.

Do Not Touch:
- Quarantined branch `codex/image-workflows-design-sketch` at `a34a078`.
- Production data, schema, functions, storage objects, configuration, or secrets.
- Real learner/minor images.
- Unapproved renderer, QR, model, retention, or universal-artifact decisions.

Next Expected Output:
- Cheap cross-course candidate scan and evidence register.
- Required files to update: TASK-0020, assessment evidence report, activity log.
- Required evidence: reproducible queries/scripts, count reconciliation, evidence-class labels, and uncertainty.

Recommended Prompt for Implementation Agent:
"""
Execute TASK-0020 as a read-only launch-readiness assessment. Begin with the cheap cross-course mechanical scan. Preserve intersections between prompt visuals and learner-drawn responses. Do not implement, mutate Production, retrieve learner images, or adopt quarantined code. Stop before deep Step 2 if the launch slice and minimum viable content volume remain unlocked. Record reproducible evidence and prepare proportional next-approval handoffs for Programs A, B, and C.
"""
