# TASK-0020 Image Readiness Assessment Handoff

Task:
- TASK-0020 — Image and Drawn-Response Launch Readiness

Prompts Included:
- [x] Implementation Agent (read-only assessment)
- [x] QA Agent handoff and fresh-context execution completed; reconciliation recorded
- [ ] UX / Prompt Agent

Current Source:
- Task doc: `docs/tasks/TASK-0020-IMAGE-AND-DRAWN-RESPONSE-LAUNCH-READINESS.md`
- Governing plan: `docs/research/IMAGE_AND_DRAWN_RESPONSE_LAUNCH_GATING_ASSESSMENT_PLAN_V5_2026_08_03.md`
- Primary findings: `docs/research/TASK0020_LAUNCH_READINESS_FINDINGS_2026_08_03.md`
- Launch-slice classification: `docs/research/TASK0020_LAUNCH_SLICE_CLASSIFICATION_2026_08_03.md`
- Cross-course scan: `docs/research/TASK0020_CROSS_COURSE_IMAGE_READINESS_SCAN_2026_08_03.md`
- Independent QA reconciliation: `docs/research/TASK0020_INDEPENDENT_QA_RECONCILIATION_2026_08_03.md`
- Prior findings: `docs/research/IMAGE_QUESTION_AND_DRAWN_RESPONSE_SECOND_OPINION_PACKET_2026_08_03.md`
- Related tasks: `TASK-0006`, `TASK-0011`, `UX-003`, `UX-008`, `TASK-0016`
- Relevant approvals: `APPROVAL-0041`, `APPROVAL-0042`
- Branch / PR: `codex/image-workflows-readiness` / pending
- Uncommitted / unpushed state: clean at assessment start

Approval State:
- Approved: read-only inventory, source/live-state audit, non-mutating QA, verdicts, and proportional next-approval handoffs.
- Not approved: implementation, migration, deployment, Production writes, learner-image access, new vendor/model selection, operational manual-review setup, automated learner-facing grading, or launch.
- Locked scope: all 48 published AP Statistics targeted-drill FRQs plus all 41 published AP Biology FRQs; no narrowing to manufacture readiness.

Live / Tool State:
- Environments checked: repository, Production metadata/schema/storage/function source, and deployed public/student-route bundles.
- Services checked: Supabase content/response/grading/storage contracts and deployed Cramapple routes.
- Not checked / unavailable: authenticated end-to-end image submission with a consented artifact, representative device matrix, independent assistive-technology QA, and operational manual reviewer throughput.

Files / Systems Affected:
- Docs: task, evidence register, inventory report, launch verdicts, remediation handoffs.
- Code: read-only inspection only.
- Data/schema: read-only queries only.
- Integrations: read-only Supabase/deployment evidence only.
- Frontend/routes: non-mutating inspection and browser QA only where authorized.

Open Risks / Blockers:
- P1: fresh independent QA confirmed the verdicts, but a second reviewer must still independently re-derive the Biology construct-equivalence-risk list from all 41 candidates.
- P1: Programs A, B, and C are independently launch-blocked by the named findings.
- P1: privacy, security, retention, accessibility, Learning Quality, and manual-review operational gates remain unresolved.
- P2: reviewer capacity is unmeasured; the findings use a clearly labeled planning range only.

Do Not Touch:
- Quarantined branch `codex/image-workflows-design-sketch` at `a34a078`.
- Production data, schema, functions, storage objects, configuration, or secrets.
- Real learner/minor images.
- Unapproved renderer, QR, model, retention, or universal-artifact decisions.

Next Expected Output:
- Independent all-41 Biology construct-risk re-derivation, reconciliation against the current seven-item list, then Learning Quality review of the reconciled list.
- No implementation approval or launch decision until that remaining check is recorded and reconciled.

Completed Prompt for Fresh-Context QA Agent:
"""
Independently QA TASK-0020 from a fresh context. Start with `docs/research/TASK0020_LAUNCH_READINESS_FINDINGS_2026_08_03.md`, then reconcile its counts to the classification and cross-course query artifacts. Challenge live/deployed/repository/prototype evidence labels; the one-image versus 62 structured/text distinction; the seven construct-sensitive alternates; the placeholder-session and capture-reference findings; canonical response/grading limitations; device/QR assumptions; privacy, retention, accessibility and reviewer-capacity gaps; all three verdicts; and whether each remediation handoff is the smallest approval-sized next step. Do not implement, mutate Production, retrieve learner images, use signed URLs, merge quarantine code, approve launch, or let one program's readiness promote another. Record issues by severity and state whether the packet is Ready for Approval, Changes Required, or Blocked.
"""
