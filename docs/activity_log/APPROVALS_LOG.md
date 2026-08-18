# Approvals Log

This log records approvals, rejections, Done decisions, and risk acceptances.

## Index

Most recent entries (full chronological list follows below):

- APPROVAL-0044 — Replace Free Score Check with 7-Day Trial; Enable GRADING_ENTITLEMENTS_ENABLED (TASK-0026)
- APPROVAL-0043 — Retire the ≤1000ms p50 Grading Latency Gate; Approve Engine 1/3 Go-Live Ahead of Full Gold-Set Certification
- APPROVAL-0042 — Lock TASK-0020 Launch Slice and Assessment Baselines
- APPROVAL-0041 — Execute Image and Drawn-Response Launch-Gating Assessment (TASK-0020)
- APPROVAL-0040 — Branch-Hygiene Adoption Steps 4–9 (PR #54 Rollout)
- APPROVAL-0027 — Branch Hygiene Rules (R1–R7) Adoption (Hard Gate)
- APPROVAL-0024 — AP Statistics Launch (TASK-0013, Phase 0 Decision Gate)
- APPROVAL-0023 — Agent Routing and Automatic QA (Codex Proposal)
- APPROVAL-0022 — Charter Simplification and Tiering Adoption
- APPROVAL-0021 — Start Content Authoring and Revision Workbench Design
- APPROVAL-0020 — Start Student-Provided Question Intake Design
- APPROVAL-0019 — Start Question and Answer Review Portal Design
- APPROVAL-0018 — Use Official Exam Dates and Confirm Registration

**Rotation rule:** once this log exceeds ~400 lines, archive the older entries to `docs/activity_log/archive/APPROVALS_LOG-<range>.md` and update this index to point at the archive. Keep the index itself to the last ~10 entries.

## APPROVAL-0044 — Replace Free Score Check with 7-Day Trial; Enable GRADING_ENTITLEMENTS_ENABLED (TASK-0026)

**Date:** 2026-08-15
**Approved By:** David Bloom
**Related Task:** TASK-0026
**Decision:** Approved

### Summary

Approves `DECISION-0047`: replaces the never-launched activation-limited
Free Score Check with a 7-day full-catalog trial, and authorizes enabling
`GRADING_ENTITLEMENTS_ENABLED=true` in Production as part of that change.

### Notes

- Resolves the gap `APPROVAL-0043`'s notes identified: that flag stayed
  `false` specifically because "no path for a new, unprovisioned student to
  get entitled" existed. `app.start_trial` is that path -- verified via
  direct RPC test against a real production attempt (both a pre-existing
  `beta` account, confirming no regression, and a freshly granted trial
  row, confirming the new path works) before flipping the flag.
- The flip was sequenced deliberately: migration + Edge Function deployed
  first, smoke-tested, then the flag set as a discrete, reversible secrets
  change -- not bundled with any other production change, given the
  documented history of an outage from flipping a related flag blind.
- FSC entitlement machinery (table, RPCs, Edge Function) was dropped from
  Production and Dev only after the trial path was verified working, so
  there was no window where neither model granted access.
- Does not itself approve the Loops lifecycle-email vendor choice or the
  day-2/day-7 PostHog scheduled-job gap -- those are tracked separately in
  TASK-0026, not launch-blocking.

## APPROVAL-0043 — Retire the ≤1000ms p50 Grading Latency Gate; Approve Engine 1/3 Go-Live Ahead of Full Gold-Set Certification

**Date:** 2026-08-14
**Approved By:** David Bloom
**Related Task:** TASK-0016
**Decision:** Approved

### Summary

Approves `DECISION-0046`: retires the ≤1000ms end-to-end p50 grading-latency
hard gate (originally set under `APPROVAL-0033`, 2026-07-08) in favor of a
two-SLA framing (time-to-acknowledgement / time-to-complete-feedback), and
authorizes Engine 1 (once its evidence-grounding P0 fix ships) and Engine 3
(shadow-only) to go live in Production ahead of the full 300+
dual-adjudicated gold-set certification originally required as a launch
gate. Full rationale and evidence in `DECISION-0046`.

### Notes

- Does not reopen the Quality > Speed > Cost priority order (2026-07-29
  owner decision) — the numeric latency target is what changed, not the
  ordering.
- The gold-set certification program continues in parallel as a dependency
  for later production-authority stages (per TASK-0016's 2026-08-13
  addendum, the five-stage model: offline → shadow → beta-audited →
  sampled-audit → broad), not waived outright.
- `GRADING_ENTITLEMENTS_ENABLED` (whether to gate grading behind
  entitlements at initial go-live) is explicitly **not** covered by this
  approval. **Resolved 2026-08-14, separately from this approval: stays
  `false`.** Investigation found `app.authorize_grading_access` requires an
  entitlement-granting path (`subject_entitlements` or `free_score_checks`).
  **Corrected 2026-08-14 (QA-caught, codex):** the original note here said
  this path "doesn't yet exist for any real student" — inaccurate;
  `subject_entitlements` has 71 active rows across 8 `student`-role
  accounts (all internal/family/test, none an unrelated real customer). The
  operative point stands — no path for a *new, unprovisioned* student to
  get entitled — but turning the flag on would not "block all grading,"
  it would leave the 8 already-provisioned accounts working. See TASK-0016
  addendum item 4 for the full correction.
- This approval covers the launch-bar scope change only. Each actual
  Production deploy/migration under this work still follows its own
  deploy discipline (diff-before-deploy, create→run→cleanup for any live
  test data) as already practiced in this program.

## APPROVAL-0042 — Lock TASK-0020 Launch Slice and Assessment Baselines

**Date:** 2026-08-03
**Approved By:** David Bloom
**Related Task:** TASK-0020
**Decision:** Approved with Notes

### Summary

Lock the deep assessment to all 48 published AP Statistics targeted-drill FRQs plus all 41 published AP Biology FRQs. Do not narrow the 89-item assessment scope to manufacture a readiness verdict.

### Notes

- Essential question visuals fail closed and may be replaced only with an already approved construct-equivalent item or representation.
- Manual review is the launch baseline for hand-drawn responses; automation remains shadow-only until its independent grading and repair evidence bars pass.
- Every officially supported answering-device class must have a viable paper-photo capture route; use QR/cross-device handoff where the answering device cannot satisfy that requirement.
- Any later item/archetype removal from launch scope requires a separate Product Owner and Learning Quality decision.
- Construct-sensitive classification and accessible-equivalence judgments still require Learning Quality validation before final launch verdicts.

## APPROVAL-0041 — Execute Image and Drawn-Response Launch-Gating Assessment

**Date:** 2026-08-03
**Approved By:** David Bloom
**Related Task:** TASK-0020
**Decision:** Approved with Notes

### Summary

Execute the read-only assessment in `IMAGE_AND_DRAWN_RESPONSE_LAUNCH_GATING_ASSESSMENT_PLAN_V5_2026_08_03.md`. Determine the launch blockers, safe named scope, and reliable implementation paths for required prompt visuals and hand-drawn response capture, preservation, review, grading, and repair.

### Notes

- Approval covers read-only repository, Production, deployment, storage-metadata, and browser/API assessment; reproducible inventory; launch verdicts; and proportional next-approval remediation handoffs.
- The cheap cross-course scan may begin immediately. Deep Step 2 requires the Product Owner-selected launch slice and the Product Owner/Learning Quality-approved minimum viable content volume.
- No schema, API, frontend, deployment, configuration, storage-object, learner-data, or Production mutation is approved.
- No real learner/minor image access, new vendor/model selection, operational manual-review setup, automated learner-facing grading, risk acceptance, or launch is approved.
- The quarantined branch `codex/image-workflows-design-sketch` at `a34a078` remains inert and must not be merged or used as baseline architecture.
- Final QA requires a genuinely fresh independent context before the task reaches an owner decision.

## APPROVAL-0040 — Branch-Hygiene Adoption Steps 4–9 (PR #54 Rollout)

**Date:** 2026-08-01
**Approved By:** David Bloom
**Related Task:** N/A (governance — follows PR #54, squash `e535f06`)
**Decision:** Approved
**Applies To:** All agents and human contributors working in the Cramapple repository
**Expires / Review Trigger:** No expiry. Review if trunk protection blocks legitimate emergency work, or if the CI check proves flaky.
**Status:** Active

### Summary

Approved execution of steps 4–9 of the recommended sequence in
`docs/proposals/BRANCH_HYGIENE_AND_ANTI_SPRAWL_2026_07_09.md`. Rules R1–R7 were
already approved on 2026-07-26 (PR #54) but were never operationalized, so branch
sprawl recurred: 15 local branches, `main` static since 2026-07-27, and one branch
93 commits ahead holding the AP Statistics CED fact pack that gates G0A.

Steps as approved:

4. Governance/docs-only adoption PR carrying `APPROVAL-0040` + `DECISION-0043`.
5. Enable PR-only `main`; block force-push and deletion; human-only admin bypass.
6. Land a minimal CI workflow and let it stabilize on `main`.
7. Make its checks required, and require review — **only after** step 6 is observed passing.
8. Enable remote head-branch auto-deletion and GitHub-native auto-merge.
9. Merge queue **only if** concurrent merges create a real stale-base problem.

### Notes

- **Verification against the live repository found steps 5–8 already in place.**
  Trunk protection (force-push and deletion blocked, conversation resolution
  required, `enforce_admins: false`), CI (`minimal-ci.yml`, job `test`, passing),
  that check already required with `strict: true`, and both
  `delete_branch_on_merge` and `allow_auto_merge` enabled. See `DECISION-0043` for
  the full audit table.
- **Step 4 was the only genuine gap**, and is what this approval lands: R1–R7
  encoded canonically in `AI_COLLABORATION_RULES.md`, the PR-policy contradiction
  removed, and this pair of log entries plus the charter changelog.
- No repository settings were changed. Nothing needed changing.
- Step 9 is conditional and not triggered; no merge queue configured.
- R5 unchanged: custom privileged merge automation remains **not adopted**.
- Consequence worth stating plainly: since no gate was broken, this approval does
  not mechanically unblock anything. It removes a charter contradiction that told
  agents they could skip PRs. The one-time cleanup of the existing 15 branches
  (proposal §4) is still outstanding and is the action that actually reduces the
  branch count.

## Approval Format

```markdown
## APPROVAL-0000 — Approval Title

**Date:** YYYY-MM-DD
**Approved By:** David Bloom / [Delegated Domain Approver name]
**Related Task:** TASK-0000 / N/A
**Decision:** Approved / Rejected / Approved with Notes / Done / Not Done / Do Not Do / Approved (Batch) / Approved (Domain)
**Decided By:** (required when Decision is Approved (Domain) — names the domain approver)
**Applies To:** (required when Decision is Approved (Batch) or Approved (Domain) — agents/roles/tasks the approval covers)
**Expires / Review Trigger:** (required when Decision is Approved (Batch) or Approved (Domain); end-of-day inclusive, America/New_York, or a named condition)
**Status:** Active / Expired / Superseded (required when Decision is Approved (Batch) or Approved (Domain))

### Summary

What was approved or rejected?

### Notes

-
```

**Conflict rule:** if `Expires` has passed but `Status` still reads `Active`, the approval is treated as expired regardless of the recorded status — the date wins. `Status: Superseded` overrides date-based validity even before expiration.

## APPROVAL-0001 — Adopt AI Project Operating Kit and GitHub Source of Truth

**Date:** 2026-06-09
**Approved By:** David Bloom
**Related Task:** TASK-0001
**Decision:** Approved

### Summary

Use `david-bloom/ai-project-operating-kit` for Cramapple and store the vision and other durable project documents in `david-bloom/Cramapple`.

### Notes

- David is the Product Owner.
- Add Strategy Advisor as an advisory role working with David and the co-founders.
- The role advises on plans and business decisions but has no independent approval authority.

## APPROVAL-0002 — Permit Estimated AP Score Guidance

**Date:** 2026-06-09
**Approved By:** David Bloom
**Related Task:** TASK-0002
**Decision:** Approved

### Summary

Revise the canonical vision to allow Cramapple to provide estimated AP score ranges and guidance on what a student should improve to move toward the next score range.

### Notes

- Estimates must be identified as Cramapple estimates, not official College Board scores or guarantees.
- Estimates should be based on sufficient evidence across relevant content, skills, and question formats.
- The product should disclose confidence, assumptions, and important evidence gaps.
- Estimated scoring must be calibrated and improved using expert-scored work and observed outcomes when available.
- This approval covers documentation and planning only, not implementation.

## APPROVAL-0003 — Create High-Level System Architecture

**Date:** 2026-06-09
**Approved By:** David Bloom
**Related Task:** TASK-0003
**Decision:** Approved

### Summary

Create and publish a detailed high-level Cramapple system architecture as a planning artifact.

### Notes

- Separate first-time sign up/start from resume learning.
- Include durable learner memory, account progress, and review recommendations.
- Account for accepting, teaching, and grading user-provided questions even if staged after MVP.
- Include efficient teaching and grading validation through entitlements, UI, workflow, and release gates.
- Include a future paid parent progress entitlement, explicitly outside MVP.
- Preserve separate follow-on designs for teaching and grading.
- This approval covers documentation and planning only.

## APPROVAL-0004 — Create Component Architecture and Teaching Design

**Date:** 2026-06-10
**Approved By:** David Bloom
**Related Task:** TASK-0004
**Decision:** Approved

### Summary

Create separate canonical documents for system context and logical component architecture, and for teaching and pedagogy.

### Notes

- The ten-day window should be treated as a specific exam-horizon learning constraint.
- Retrieval, spacing, interleaving, and metacognitive calibration should influence the design.
- College Board section and point distributions are critical recommendation inputs.
- Weakness and improvability must be treated as different estimates.
- The work remains planning and documentation only.

## APPROVAL-0005 — Adopt Unified Learning and Stuck-State Model

**Date:** 2026-06-10
**Approved By:** David Bloom
**Related Task:** TASK-0004
**Decision:** Approved

### Summary

Adopt one learning-state model for ordinary teaching and stuck escalation, with evidence-weighted entry, discriminating probes, independent confirmation, schedule-aware Park, and learner Move On.

### Notes

- Three misses are not treated as equivalent evidence or an automatic stuck trigger.
- Sideways, Apart, and Down should be selected from direct probes when feasible, while avoiding false precision.
- Immediate success must be confirmed through independent transfer and later review when the schedule permits.
- Intervention effectiveness is tracked by skill and task type, not as a general learning-style preference.
- Anonymous student responses may be used to improve Cramapple.
- Terms and Conditions govern residual personal-information submission risk; public candidates receive a signed-in-user proper-name sweep.

## APPROVAL-0006 — Resolve Learning-System Boundary Questions

**Date:** 2026-06-11
**Approved By:** David Bloom
**Related Task:** TASK-0004
**Decision:** Approved with Research Items

### Summary

Define the repeated-miss skill unit, use Frame for both diagnosis and teaching, make intervention selection learner-overridable, and assign public student-question publishing primarily to marketing while preserving educational quality gates.

### Notes

- Cramapple guides but does not dictate; the learner may resist a recommendation and choose another path.
- The evidence required for stronger independent-success or stable-improvement claims is a pedagogical research item.
- The amount of time spent on one skill remains TBD and should not be presented as a validated universal cap.
- Publishing question-and-teaching pages is primarily a marketing workflow, but the public artifact is educational and requires teaching and grading review.

## APPROVAL-0007 — TASK-0001 Done

**Date:** 2026-06-12
**Approved By:** David Bloom
**Related Task:** TASK-0001
**Decision:** Done

### Summary

Accept the project operating system and canonical vision task as complete.

### Notes

- `NOW-001` is Done.
- The operating kit, authority model, source-of-truth structure, and canonical
  vision are accepted.

## APPROVAL-0008 — TASK-0003 Done

**Date:** 2026-06-12
**Approved By:** David Bloom
**Related Task:** TASK-0003
**Decision:** Done

### Summary

Accept the high-level system architecture task as complete.

### Notes

- `NOW-002` is Done.
- Detailed follow-on designs remain separately scoped backlog work.

## APPROVAL-0009 — TASK-0004 Owner Review Complete

**Date:** 2026-06-12
**Approved By:** David Bloom
**Related Task:** TASK-0004
**Decision:** Approved with Notes

### Summary

Approve the current component architecture and teaching-design documentation.

### Notes

- `NOW-003` is Done.
- `TASK-0004` is not yet Done because AP Biology tutor review remains required
  under `NOW-004`.
- Tutor findings may require remediation before the task closes or the pedagogy
  is used for implementation or launch.

## APPROVAL-0010 — Paid Tutor Original-Question Model

**Date:** 2026-06-12
**Approved By:** David Bloom
**Related Task:** TASK-0005 / CONTENT-001
**Decision:** Approved

### Summary

Use paid qualified tutors and subject experts to create Cramapple's original
question packages instead of using historical College Board questions as seed
material.

### Notes

- Official questions and scoring materials are not generation inputs or
  adaptation targets.
- Authors cannot approve their own work.
- Base question packages are human-authored or purchased. Controlled
  generative-AI versioning received separate approval in `APPROVAL-0011`.
- Counsel review remains required for contracts, rights, and official-material
  guidance.

## APPROVAL-0011 — Proprietary Question Bank and AI Versioning Boundaries

**Date:** 2026-06-12
**Approved By:** David Bloom
**Related Task:** TASK-0005 / CONTENT-001
**Decision:** Approved with Notes

### Summary

Approve a proprietary MCQ and FRQ bank with at least ten approved questions per
subject-and-subtopic pair, built from Cramapple-authored and purchased packages,
with controlled AI creation of candidate variants.

### Notes

- Official question text is excluded from the workflow.
- AI may use only packages with explicit derivative and model-input rights.
- Every base question and AI variant requires a complete rubric and teaching
  package.
- AP Reader Validators must have served in at least one of 2024, 2025, or 2026
  and satisfy the applicable Cramapple validator qualification.
- Diagnostic questions may graduate to teaching use or retire.
- Student sample thresholds, AI holdout design, permitted source/asset policy,
  and final release language remain open gates.

### Supersession Note

The quantity language in this approval is superseded by `APPROVAL-0014`.

## APPROVAL-0012 — GitHub Document Synchronization Rule

**Date:** 2026-06-12
**Approved By:** David Bloom
**Related Task:** N/A
**Decision:** Approved

### Summary

Require every project document retained locally to be committed and pushed to
`david-bloom/Cramapple`.

### Notes

- Local-only documents are not durable project records.
- Synchronization requires remote verification.
- Temporary and machine-local files such as `.DS_Store` remain excluded.
- Secrets and protected data must use approved secure storage rather than
  GitHub.

## APPROVAL-0013 — Markdown-First Document Format Rule

**Date:** 2026-06-12
**Approved By:** David Bloom
**Related Task:** N/A
**Decision:** Approved

### Summary

Make Markdown in GitHub the default and canonical medium for project documents,
use Google Docs as the preferred collaboration or backup copy, and avoid Word
documents unless a specific external or layout requirement requires them.

### Notes

- Accepted Google Docs changes must be incorporated into canonical Markdown.
- Word documents must be derived from a canonical source and must not be
  maintained independently.
- Existing Word snapshots may remain but are not regenerated by default.
- Artifact-native formats remain permitted where Markdown is not suitable.

## APPROVAL-0014 — Corrected Content Coverage and Diagnostic Direction

**Date:** 2026-06-12
**Approved By:** David Bloom
**Related Task:** TASK-0005 / CONTENT-001A
**Decision:** Approved with Notes

### Summary

Approve all 60 official AP Biology topics as the coverage taxonomy, with
planning targets of ten MCQs and five short-FRQ prompts per topic and eight
long-FRQ prompts per unit. Approve expert-curated diagnostic use before
empirical confirmation, human review for statistical signals, and deferral of
physical Supabase design.

### Notes

- One MCQ or one independently delivered and answered FRQ prompt is one
  inventory item.
- The corrected full planning target is 964 inventory items.
- Cramapple will work to meet or exceed the target; a shortfall does not
  silently redefine the target.
- Learning Quality review remains required for feasibility and variety.
- Statistical signals cannot automatically change item state.
- Physical database design requires a later hard-gated task after logical
  governance and application architecture approval.

## APPROVAL-0015 — Reject Prohibited Derivative and Test Authoring Models

**Date:** 2026-06-13
**Approved By:** David Bloom
**Related Task:** TASK-0007
**Decision:** Approved with Notes

### Summary

Remove the proposed official-derived candidate, preserve consequential content
lessons only as abstract anti-example failure cards, and test alternative
AI-led authoring models without replacing the paid-tutor-first production
baseline.

### Notes

- The rejected item must not enter GitHub, prompts, exemplars, model inputs,
  evaluation sets, or production content.
- The stale ZIP patches are not applied.
- Experiment design and validation-only testing are approved in principle.
- Learning Quality, counsel, participant, blinding, data-capture, and budget
  gates remain before execution.
- Experimental items do not count toward production coverage.
- A separate Product Owner decision is required before any alternative
  authoring model becomes production policy.

## APPROVAL-0016 — Content and Assessment Follow-On Direction

**Date:** 2026-06-13
**Approved By:** David Bloom
**Related Tasks:** TASK-0008, TASK-0009, TASK-0010, TASK-0011
**Decision:** Approved with Notes

### Summary

Create a clean proprietary replacement exemplar, reconcile schemas with
governance before physical design, build confidence in FRQ grading through
human gold sets and phased validation, develop MCQ and FRQ authoring
simultaneously, and research paper-first QR-linked handwritten graph capture.

### Notes

- The replacement exemplar begins from a blank brief and cannot use the
  rejected candidate.
- Text-only visual storage is not a permanent solution; logical package
  contracts may precede physical DDL.
- Learner-facing automated FRQ scoring remains hard-gated.
- Existing FRQ candidates may be edited or dropped only through tutor and AP
  Reader review.
- Camera capture is approved for research, not production.

## APPROVAL-0017 - Start Initial Product UX Design

**Date:** 2026-06-13
**Approved By:** David Bloom
**Related Task:** UX-001
**Decision:** Approved with Notes

### Summary

Begin UX-001 design and prototype work for the student portal using the current
vision, architecture, learning-system, and backlog records.

### Notes

- Approval covers interaction specifications, copy variants, low-fidelity
  wireframes, clickable prototypes, research plans, and decision packets.
- Final student-facing UX decisions remain subject to Product Owner review.
- Learning, Marketing, and accessibility review remain required.
- This approval does not authorize production frontend implementation,
  deployment, physical database design, final grading behavior, or use of
  unapproved content.

## APPROVAL-0018 - Use Official Exam Dates and Confirm Registration

**Date:** 2026-06-13
**Approved By:** David Bloom
**Related Task:** UX-001
**Decision:** Approved with Notes

### Summary

Use the official AP exam date already defined by Cramapple's active versioned
exam specification. Do not ask students to provide that date. Ask students to
confirm whether they are registered for the selected exam.

### Notes

- Registration status supports `registered`, `not registered yet`, and
  `unsure`.
- Students who are not registered or are unsure may continue learning.
- Cramapple must explain that exam registration happens through the student's
  school or AP coordinator and must not imply that Cramapple registers them.
- If official date data is unavailable, show a system-data warning rather than
  inventing a date or asking the student to supply it.
- This approval covers UX-001 documentation and prototype work, not production
  implementation or deployment.

## APPROVAL-0019 - Start Question and Answer Review Portal Design

**Date:** 2026-06-13
**Approved By:** David Bloom
**Related Task:** UX-002
**Decision:** Approved with Notes

### Summary

Design a carousel-based review portal for logged-in tutors and AP Readers using
the Product Owner's question, answer, scoring, recycling, exclusion, and
difficulty-label workflow.

### Notes

- Approval covers design records, wireframes, clickable prototypes, and a
  Lovable render brief.
- Two tutor decisions remain independent until both are submitted.
- Candidate-stage approval does not authorize production publication.
- Existing source, rights, teaching, grading, accessibility, release, and
  exam-pack gates remain required.
- This approval does not authorize production authentication, database design,
  reviewer-data writes, deployment, or use of unapproved content.

## APPROVAL-0020 - Start Student-Provided Question Intake Design

**Date:** 2026-06-13
**Approved By:** David Bloom
**Related Task:** UX-004
**Decision:** Approved with Notes

### Summary

Design the student experience for typing, pasting, photographing, or uploading
an outside question and choosing teaching, hint, work-checking, or solution
help.

### Notes

- Approval covers interaction design, copy, clickable prototypes, and a
  Lovable render brief.
- Missing context must be requested rather than invented.
- Student confirmation may improve routing but does not make a question,
  source, or rubric authoritative.
- Private learning, anonymous improvement, canonical content, and public
  publication remain separate states.
- Final upload, privacy, rights, retention, consent, provider, and
  academic-integrity policy remains hard-gated.
- This approval does not authorize production file processing, storage,
  grading, publication, deployment, or use of protected content.

## APPROVAL-0021 - Start Content Authoring and Revision Workbench Design

**Date:** 2026-06-15
**Approved By:** David Bloom
**Related Task:** UX-003
**Decision:** Approved with Notes

### Summary

Design the author-facing workbench for creating complete question packages,
receiving recycled items from UX-002, responding to reviewer comments,
comparing immutable versions, recording provenance and rights, and resubmitting
new versions for independent reassessment.

### Notes

- The existing student-provided question intake is renumbered from UX-003 to
  UX-004 without changing its approved product direction.
- Approval covers interaction design, copy, clickable prototypes, and a
  Lovable render brief.
- UX-003 may link qualified users to the UX-002 review carousel but may not
  allow self-review or duplicate scoring inside the author editor.
- A recycled item creates a new immutable version; prior scores do not transfer
  as approval.
- Author attestation does not constitute rights clearance or production
  approval.
- This approval does not authorize production uploads, storage, database
  design, contracting, payment, review assignment, publication, or deployment.

## APPROVAL-0022 — Charter Simplification and Tiering Adoption

**Date:** 2026-06-23
**Approved By:** David Bloom
**Related Task:** N/A (governance/process, not a product task)
**Decision:** Approved

### Summary

Adopts, as a single bundle, into Cramapple's `docs/team_charter/` (pilot project; the public `ai-project-operating-kit` repo is untouched pending results):

- All eleven "What To Simplify" items plus the Rollout Sequencing, Success Metrics, and "Other Ways To Move Development Faster" sections of `docs/proposals/2026-06-23-kit-simplification-memo.md`.
- Proposals 1, 2 (recording structure and SLA substrate only — not its automation, per the proposal's own v2 resolution), 3, 4, 5 (reconciled — see Notes), 7, 8 (reconciled), and 9 of `docs/proposals/2026-06-14-team-charter-improvements.md`.
- Explicitly **not** adopted: Proposal 6 (Definition of Done test-evidence wording) and Proposal 10 (Cross-Agent Notes) — neither is depended on by the simplification memo; left for separate consideration.

### Notes

- **Status taxonomy conflict resolution:** the simplification memo's 6-state collapse was adopted over Proposals 5 and 8's status-preservation approach. Proposal 5's actual safety property (QA cannot unilaterally close a task) survives as a role rule in `AI_COLLABORATION_RULES.md` — only the Main Conductor sets `Done` — rather than as a dedicated `QA Passed` status word. Proposal 8's `Do Not Do` definition was kept; its `QA Blocked` distinction was folded into `Blocked`.
- **Log-count question resolution:** Proposal 2's purpose-built `APPROVALS_LOG.md` structure was kept as-is (not merged into `DECISIONS_LOG.md`) — it's the substrate the new Standing-tier SLA depends on.
- This approval does not authorize pushing any of this to the public `ai-project-operating-kit` repository. That remains a separate, later decision once the pilot is proven on new Cramapple tasks.
- `DECISIONS_LOG.md` is already roughly double its newly-adopted rotation threshold; the first archive pass is a follow-up, not done as part of this approval.

## APPROVAL-0023 — Agent Routing and Automatic QA (Codex Proposal)

**Date:** 2026-06-23
**Approved By:** David Bloom
**Related Task:** N/A (governance/process)
**Decision:** Approved with Notes

### Summary

Folds `docs/proposals/2026-06-23-agent-routing-and-qa-proposal-for-claude.md` into `AGENT_OPERATING_MODEL.md`: QA auto-triggers for `Standard`/`Hard-Gate` tier work instead of waiting for a request; the Main Conductor auto-applies the Model and Effort Policy without asking the Product Owner to choose a model per call; explicit good-use/bad-use guidance for spawning additional agents.

### Notes

- The proposal's guardrail "the orchestrator must record which model was used and why" was narrowed: recorded only on deviation from the default tier (i.e., escalation to the strongest tier), not on every routine call — recording every fast-tier call would reintroduce the ceremony this whole effort is removing.
- No conflicts found with the 06-14 proposal or the 06-23 simplification memo; this is additive to the Model and Effort Policy and Task Tiers sections adopted under APPROVAL-0022.
- Does not change any approval boundary: model selection and QA auto-triggering both still stop at the existing Hard-Gate list.

## APPROVAL-0024 — AP Statistics Launch (TASK-0013, Phase 0 Decision Gate)

**Date:** 2026-06-30
**Approved By:** David Bloom
**Related Task:** TASK-0013
**Decision:** Approved

### Summary

Approved TASK-0013's Phase 0 decision gate: AP Statistics is Subject 2;
content sourcing reuses the existing tutor-authored-base-package model under
Orly; pilot content batch follows the 9-unit MCQ/FRQ distribution recorded in
`DECISION-0031` (71 MCQs / 33 FRQs, investigative-task scope still TBD);
existing reviewers may be cross-credentialed across subjects without a new
tutor pool; rights/licensing posture is unchanged from AP Biology. Clears
Phase 1 (Codex: grading-prompt generalization) to execute.

### Notes

- This approval covers Phase 0 only. Phases 2–7 in
  `docs/tasks/TASK-0013-AP-STATISTICS-LAUNCH.md` still execute in sequence,
  each depending on the prior phase's output, and production
  deployment/launch remains a separate Hard Gate not granted here.
- The investigative-task item type (AP Statistics-specific archetype, not a
  long/short FRQ variant) is explicitly unscoped pending its own definition
  pass — does not block the MCQ/FRQ portion of the pilot batch.
- No target date set for the pilot batch; revisit once Orly confirms
  bandwidth.

## APPROVAL-0025 — TASK-0013 Phase 2 Migration Go-Ahead

**Date:** 2026-06-30
**Approved By:** David Bloom
**Related Task:** TASK-0013
**Decision:** Approved

### Summary

Authorizes the Phase 2 database migration (`app.subjects`, `app.exam_packs`/
`exam_pack_versions`, `app.content_labels` for AP Statistics) to execute.
Separate from `APPROVAL-0024`'s Phase 0 task-level approval, per the
Database Migrations Hard Gate in `STANDING_APPROVAL_LANES.md`. See
`DECISION-0032` for full scope and rationale.

### Notes

- Scope is exactly `prompts/CODEX_AP_STATISTICS_PHASE2_SCHEMA_INSTANTIATION.md`
  as drafted — no broader migration authority granted.
- Publishing the resulting exam pack/content is explicitly not covered.

## APPROVAL-0027 — Branch Hygiene Rules (R1–R7) Adoption (Hard Gate)

**Date:** 2026-07-26
**Approved By:** David Bloom
**Related Task:** N/A (charter / operating-model change)
**Decision:** Approved

### Summary

Approves adoption of branch-hygiene rules R1–R7 (anti branch-sprawl) as a charter /
operating-model change, encoded in `AI_COLLABORATION_RULES.md` (§In-Progress Drafts
and Branches) plus `TASK_WORKFLOW.md`, `HANDOFF_PACKET_TEMPLATE.md`, the Claude/Codex
new-session prompts, and `CLOSE_SESSION_PROMPT.md`. Durable owner approval was
recorded on PR #54 citing commit `85b1151` (source proposal
`docs/proposals/BRANCH_HYGIENE_AND_ANTI_SPRAWL_2026_07_09.md`, merged). See DECISION-0039.

### Notes

- Operational enforcement (main branch protection, required CI checks, native
  auto-merge, one-time branch/worktree cleanup) is separate from this charter
  adoption and sequenced in the proposal — not in this PR.
- R5 uses GitHub-native auto-merge/merge-queue with a human/conductor readiness
  step; a custom privileged merge agent is contingent, not adopted by default.
