# Approvals Log

This log records approvals, rejections, Done decisions, and risk acceptances.

## Index

Most recent entries (full chronological list follows below):

- APPROVAL-0050 — BYOQ Data-Model Architecture (Option A) and TASK-0039 Phase 1 Scope
- APPROVAL-0049 — Pilot-Scale Operational Commitment for Hand-Drawn Manual Grading (TASK-0038 Phase 4)
- APPROVAL-0048 — Promote `APBIO-HDG-2026-GRAPH-002` to Human-Graded-Pilot-Approved (TASK-0038 Phase 2)
- APPROVAL-0047 — Device-Neutral Cramapple Bootstrap and Shared ChatGPT Project Contract
- APPROVAL-0046 — Confirm QR Handoff as Engine 4's Sole Capture Path; Approve Capture-Failure Handling Split
- APPROVAL-0045 — Retire Engine 4's Dual-Human-Adjudicated Gold Requirement; Adopt the DECISION-0045 Gold Model
- APPROVAL-0044 — Replace Free Score Check with 7-Day Trial; Enable GRADING_ENTITLEMENTS_ENABLED (TASK-0026)
- APPROVAL-0043 — Retire the ≤1000ms p50 Grading Latency Gate; Approve Engine 1/3 Go-Live Ahead of Full Gold-Set Certification
- APPROVAL-0042 — Lock TASK-0020 Launch Slice and Assessment Baselines
- APPROVAL-0041 — Execute Image and Drawn-Response Launch-Gating Assessment (TASK-0020)
- Older entries: [`APPROVALS_LOG-0001_to_0040.md`](archive/APPROVALS_LOG-0001_to_0040.md)

**Rotation rule:** once this log exceeds ~400 lines, archive the older entries to `docs/activity_log/archive/APPROVALS_LOG-<range>.md` and update this index to point at the archive. Keep the index itself to the last ~10 entries.

## APPROVAL-0050 — BYOQ Data-Model Architecture (Option A) and TASK-0039 Phase 1 Scope

**Date:** 2026-09-26
**Approved By:** David Bloom
**Related Task:** `TASK-0039-BYOQ-PRODUCTION-OPERATIONAL.md`, Phase 1
**Decision:** Approved

### Summary

Approves `DECISION-0068`: BYOQ (bring-your-own-question) gets its own parallel data model
(`app.byoq_items`/`app.byoq_responses`, and later `app.byoq_capture_pairing_tokens`/
`app.byoq_attachments`) rather than generalizing the live `app.attempts`/`app.response_versions`/
`app.response_attachments`/`app.capture_pairing_tokens` tables, after an adversarial review found the
generalize-in-place option would leave a real path for a BYOQ item to reach the human-grading queue.
Authorizes starting `TASK-0039` Phase 1: the `byoq_items`/`byoq_responses` schema, a separate BYOQ
Practice screen sharing components with (never branching inside) the live graded Practice screens,
and the Home entry point.

### Notes

- Does **not** authorize Phase 2 (QR photo capture) or Phase 3 (worksheet parsing) — both remain
  gated on their own open items (`TASK-0039`'s Pre-flight verification step for Phase 2; the Open
  Decisions in `docs/product/BYOQ_WORKSHEET_PARSING_DESIGN.md` for Phase 3).
- Does **not** resolve `TASK-0039`'s "New gaps" list (entitlement/trial gating, rate limits/quotas,
  retention/deletion, consent copy, the private-until-promoted boundary, subject/taxonomy scoping,
  stuck-BYOQ routing, the hints/deep-dive floor) — these still need an explicit Product Owner call
  before Phase 1 ships to real students, separate from this schema/scope approval.

## APPROVAL-0049 — Pilot-Scale Operational Commitment for Hand-Drawn Manual Grading (TASK-0038 Phase 4)

**Date:** 2026-09-23
**Approved By:** David Bloom
**Related Task:** `TASK-0038-HAND-DRAWN-CAPTURE-REAL-STUDENT-HUMAN-GRADED.md`, Phase 4
**Decision:** Approved

### Summary

Approves `DECISION-0059`: a pilot-scale operational commitment for manual
hand-drawn grading, scoped to one item (`APBIO-HDG-2026-GRAPH-002`) and one
grader (David Bloom). Sets a 24-hour grading SLA with at least daily queue
checks; adopts a manual, logged-correction interim stance for disputes
(no regrade tooling exists yet); accepts that manually-graded students
receive a score but no repair prompt (`highestValueGap` stays null); and
adopts a two-stage rollout -- Stage 1 (admin-gated, one real end-to-end run
by David) before Stage 2 (a small named group, never the general Biology
population), with no further widening without revisiting this decision.

### Notes

- Does **not** close TASK-0020 Program C's Hard Gate -- that still needs the
  full multi-owner design (Learning Quality, Operations, Privacy/Security)
  for any broader launch. This approval covers only the one-item, one-grader
  pilot scope named in `DECISION-0059`.
- Does not authorize lifting `/session-hand-drawn-pilot`'s admin gate by
  itself -- Stage 1's real end-to-end run must happen and be reported first.

## APPROVAL-0048 — Promote `APBIO-HDG-2026-GRAPH-002` to Human-Graded-Pilot-Approved (TASK-0038 Phase 2)

**Date:** 2026-09-23
**Approved By:** David Bloom
**Related Task:** `TASK-0038-HAND-DRAWN-CAPTURE-REAL-STUDENT-HUMAN-GRADED.md`, Phase 2
**Decision:** Approved

### Summary

Approves `DECISION-0058`'s operational definition of "approved" for hand-drawn
`label_status` (human-graded-pilot-ready; explicitly not AI-grading-ready, not
rights-cleared) and names `APBIO-HDG-2026-GRAPH-002` (`content_item_version_id
1c29347d-0f41-4f09-96a7-6f863be82eaf`) as the item promoted under it, after
reviewing its real `content_review_decisions` trail (one flagged concern, fixed and
re-approved 2026-08-08) rather than the `review_status` label alone. Authorizes
updating `prompt_json.label_status` on this item from `ai_provisional_unapproved` to
`human_graded_pilot_approved` in Production.

### Notes

- This approval covers this one item only; it does not blanket-approve the other 23
  reviewed-but-`ai_provisional_unapproved` hand-drawn items, and does not authorize
  Phase 3 (real `/session` frontend wiring) or Phase 4 (a real human-grading queue)
  — each remains its own go-ahead per TASK-0038's Hard-Gate tier.
- Does not certify automated grading readiness (DR-1 remains failed, unchanged) or
  content rights/authorship (`rights_status` remains
  `independently_authored_synthetic_research_seed_unverified`).

## APPROVAL-0047 — Device-Neutral Cramapple Bootstrap and Shared ChatGPT Project Contract

**Date:** 2026-09-22
**Approved By:** David Bloom
**Related Task:** Cramapple mobile/desktop context parity
**Decision:** Approved

### Summary

Approves DECISION-0054 and the narrowly scoped governance changes that make the existing
Cramapple ChatGPT Project use one current GitHub bootstrap across desktop, iPhone, ChatGPT Work,
Codex, and Claude. Approval covers the new session-start and Project-instructions documents,
their startup-prompt/README links, and the associated governance records.

### Notes

- Keep the existing Cramapple Project on Default memory while ChatGPT Work is part of the workflow.
- Do not create a separate mobile Cramapple Project.
- GitHub remains authoritative; Project memory and prior chats provide continuity but do not replace current repository or live-service verification.
- This approval does not authorize a Production deployment, migration, secret change, payment action, or other live-system mutation.

## APPROVAL-0046 — Confirm QR Handoff as Engine 4's Sole Capture Path; Approve Capture-Failure Handling Split

**Date:** 2026-08-19
**Approved By:** David Bloom
**Related Task:** TASK-0016 Phase D, TASK-0025
**Decision:** Approved

### Summary

Approves `DECISION-0051`: reaffirms QR handoff (System A) as Engine 4's sole capture path with no
direct-upload fallback, resolving the System A/System B ambiguity in favor of TASK-0016's original
decision #10. System B's `SameDeviceCapture` frontend stays superseded/pilot-only; its
`attach_capture`/`app.response_attachments` backend is approved for reuse as System A's storage
layer. Also approves the capture-failure handling split: generic retake guidance on image-quality
failures, bug-logged on technical failures.

### Notes

- Does not itself authorize any Production deployment or migration — Stage D2 implementation
  still follows this program's normal deploy discipline (diff-before-deploy, Dev-before-Prod).
- Does not resolve the pre-existing `capture_quality_state`/`capture_retake_reason` frontend/
  backend contract mismatch — separate follow-up.

## APPROVAL-0045 — Retire Engine 4's Dual-Human-Adjudicated Gold Requirement; Adopt the DECISION-0045 Gold Model

**Date:** 2026-08-19
**Approved By:** David Bloom
**Related Task:** TASK-0016 Phase D, TASK-0011
**Decision:** Approved

### Summary

Approves `DECISION-0050`: retires the ≥300-response, ≥40-per-archetype dual-human-adjudicated
gold-set requirement as a hard gate specifically for Engine 4 (spatial/hand-drawn grading), and
un-defers `DECISION-0045`'s Set C — Engine 4 gold-set construction now follows the same
AI-generation + two-independent-non-OpenAI-model-verification + reader-certification protocol
already governing every other engine, with the same independence constraints.

### Notes

- Does not waive corpus-readiness requirements (consent/provenance manifest, deduplication,
  metadata stripping) the existing photo corpus still needs per its own 2026-08-03 readiness
  audit.
- Does not retroactively certify the existing 200-photo real-Biology corpus's single-pass-AI gold
  as meeting the new standard — a `DECISION-0045`-protocol pass still needs to actually run
  against it before it's launch-qualifying evidence.
- Surfaced and requested during Stage D0 execution of TASK-0016 Phase D
  (`docs/research/grading_phase_d_spatial_2026_07_27/`), which had identified the old requirement
  as Engine 4's largest concrete blocker.

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
