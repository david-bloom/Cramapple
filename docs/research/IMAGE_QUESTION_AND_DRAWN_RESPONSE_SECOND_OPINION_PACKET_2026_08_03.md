# Image Questions and Drawn Responses — Second-Opinion Packet

**Status:** Draft
**Date:** 2026-08-03
**Prepared for:** Independent Codex review
**Product Owner:** David Bloom
**Purpose:** Assessment and challenge; not implementation approval

## 1. Review request

Cramapple needs an independent assessment of three consequential capabilities:

1. How many current questions require an image as part of the question itself?
2. Is there a reliable process to create, QA, approve, deliver, and monitor those images?
3. Is the paper-first hand-drawn response capability actually ready across QR handoff, phone capture, upload, grading, repair feedback, storage, and later student review?

Please review the evidence and proposed assessment plan below skeptically. Do not treat the preparer's preliminary implementation ideas, local prototypes, or pushed branch commits as approved architecture. Identify unsupported conclusions, missing evidence, governance errors, alternative approaches, and risks that could materially change the plan.

## 2. Governing state and approval boundary

The project charter was re-read on 2026-08-03. It establishes that read-only assessment, drafting, and non-destructive QA are standing-approved, while unapproved implementation, production changes, database work, learner-data handling, privacy decisions, automated learner-facing grading, and launch are hard-gated.

The relevant canonical task records do not authorize production implementation:

- `TASK-0006` (visual stimulus and rendering) is `Ready for Owner Review`, with its architecture and five owner decisions still pending. Its 964-item representation audit is incomplete.
- `TASK-0011` (handwritten graph capture) is a research placeholder with approval pending. It explicitly requires a separate production hard gate.
- `UX-008` authorizes design documentation and a Lovable brief only. It explicitly excludes a working camera, QR, upload, storage, extraction, or grading prototype.
- `UX-003` authorizes frontend-only authoring prototype work, not production uploads, APIs, storage, or release.
- `DECISION-0022` approves research into paper-first QR capture; it explicitly does not approve implementation.
- `APPROVAL-0016` approves camera capture research, not production.

This packet therefore proposes an assessment sequence only. Any eventual implementation needs a properly scoped task, tier, approval state, handoff, independent QA, and the applicable privacy/security/learning-quality gates.

## 3. Evidence standard

The assessment should distinguish five evidence classes:

1. **Verified live state:** read-only evidence from the current Production system.
2. **Repository implementation:** committed code, which may or may not be deployed.
3. **Deployed behavior:** exercised endpoint or UI behavior in the relevant environment.
4. **Prototype or research evidence:** useful for learning but not proof of production capability.
5. **Proposed design:** unapproved architecture, protocol, or local draft.

No conclusion should silently cross from one class to another. In particular, a rendered prototype is not evidence that QR pairing, camera access, upload binding, grading, retention, or future review works.

## 4. Preliminary findings

### 4.1 The requested question-image count is not yet known

No defensible current count has been produced. The proposed visual architecture itself says the planned 964-item inventory must be classified by visual kind and purpose before estimating coverage. That historical planned count must not be substituted for the current Production inventory.

Known evidence is incomplete and demonstrates why a semantic inventory is needed:

- A 2026-08-01 AP Statistics remediation record reports 276 AP Statistics items, including 158 FRQs and 40 hand-drawn graph drills. Those 40 require an image as the **student answer**, not necessarily an image in the question, so they must not be counted in question-image demand.
- The same record identifies at least three questions referencing a missing tree diagram or residual plot while both `stimulus` and `stimulus_image_path` are empty. These are examples of image-required question defects, not a complete cross-exam count.
- Database fields and text references alone cannot reliably distinguish an essential visual, incidental art, a semantic table, a learner-created response, an intentionally accessible alternate, or a stale/missing asset.

**Preliminary conclusion:** the answer requires both a mechanical inventory and semantic classification. A count of non-null image paths would be materially misleading.

### 4.2 The proposed image-governance model is substantially stronger than the observed compatibility implementation

The proposed `VISUAL_STIMULUS_AND_RENDERING_SYSTEM.md` defines a four-lane model, immutable visual artifacts, visual purpose, provenance, rights, renderer identity, checksums, accessible representations, construct-equivalence and answer-leakage review, independent human review, deterministic failure, and change-triggered revalidation.

The compatibility data path inspected so far is much thinner:

- `content_item_versions` has a `stimulus_image_path` and general `prompt_json`, but no observed enforced physical contract equivalent to the proposed governed artifact model.
- The practice-selection function returns a bare private-storage path.
- The reviewer queue signs private `content-assets` images for authorized reviewers.
- The general storage-signing endpoint does not allow students to sign `content-assets` question images.
- The attempt-creation API binds the exact content version but does not return a hydrated, learner-safe question payload with a signed image.
- The compatibility authoring projection inspected so far does not persist `stimulus_image_path`.
- The reviewer queue contains heuristic missing-image detection, but no complete release proof was identified for scientific fidelity, grading impact, accessibility, construct equivalence, rights, answer leakage, and viewport rendering.

These observations are repository/code findings, not yet a complete deployed-state audit.

**Preliminary conclusion:** there is a serious apparent gap between the proposed governance model and the compatibility delivery path. The proper resolution may be different from the preparer's preliminary code design and must follow the unresolved `TASK-0006` owner decisions.

### 4.3 Student delivery of private question images is not demonstrated end to end

The present code trace did not identify a student endpoint that takes the exact attempted content version and safely returns its private stimulus as a short-lived signed URL. Returning a private object path is not equivalent to rendering the image.

This creates several unverified questions:

- Does the current student frontend use another service or route not yet inspected?
- Are current image-bearing questions actually exercised in Production?
- Does image failure fail closed for questions whose construct depends on the visual?
- Are alt text, long description, semantic tables, zoom, reflow, and responsive behavior delivered and tested?
- Can any learner-facing payload expose answers, rubrics, rationales, or reviewer-only metadata?

**Preliminary conclusion:** image delivery readiness is unproven, not definitively absent. Repository, deployment, and browser evidence must be reconciled before a final verdict.

### 4.4 The hand-drawn capture experience is designed, but a production QR workflow is not established

The approved research direction is paper-first work with a short-lived, single-use, purpose-bound QR or fallback handoff. The design records are unusually thoughtful about capture permission, framing, retake, crop/rotation, quality states, accessibility alternatives, immutable originals, and the distinction between “capture accepted” and “answer correct.”

However:

- `UX-008` explicitly says no working camera, QR, upload, storage, extraction, or grading prototype is authorized by that task.
- The current response API inspected so far accepts response text and structured parts; no binding from a learner-uploaded image to an immutable response version was found.
- The existing `learner-uploads` signing capability supports learner-owned paths, but that alone does not prove secure cross-device pairing, single-use submission, attempt/response binding, phone-to-primary-device synchronization, immutable original/derivative lineage, or later retrieval.
- No verified browser/device matrix or end-to-end deployed test was found showing QR scan through stored response and later review.

**Preliminary conclusion:** the UX specification is relatively mature; operational capability is unproven.

### 4.5 Drawn-response grading quality is not decision-grade

Existing records explicitly warn against claiming otherwise:

- The capture/manual-grading dry run used three distinct human drawings and manual photo sharing through AirDrop, not the QR product flow.
- Initial image-quality defects caused abstention; clearer recaptures improved the manual read. This supports the importance of capture QA but does not validate automated grading.
- The dry run says it was not a DR-1 bake-off and used no automated method, locked gold set, dual-validator process, or full annotation protocol.
- DR-1 is proposed, not approved for execution, and reports no completed decision-grade run in its canonical record. It requires a locked 300-response corpus and strict per-criterion, severe-error, abstention, and scoring thresholds before production-candidate conclusions.
- Other project records report useful synthetic hand-drawn experiments and a larger local collection of real photographs, but those artifacts must be reconciled with DR-1's governance, partitioning, labeling, and held-out requirements before being cited as grading validation.

**Preliminary conclusion:** Cramapple has meaningful research assets and early pipeline lessons, but no verified basis yet to say images are graded well enough for authoritative learner-facing scoring.

### 4.6 Repair-feedback parity with written answers is not demonstrated

DR-2 correctly separates rubric-match accuracy from feedback usefulness. It defines grounded, minimum-fix, non-leaking feedback and requires independent-transfer evidence. Its canonical status says:

- Tier 1 depends on DR-1 gold criterion decisions.
- Tier 2 requires Product Owner approval for a bounded adult/tutor participant test.
- Tier 3 real-student shadow measurement is a hard gate and is not authorized.

No completed DR-2 result was identified. Image overlays are intentionally deferred because inaccurate localization can teach the wrong correction.

**Preliminary conclusion:** parity with written-answer repair has not been established. A correct-looking criterion card or prototype repair state is not transfer evidence.

### 4.7 Storage for future student review is not demonstrated

The research architecture calls for immutable raw images, versioned derivatives, exact links to prompt/rubric/model/preprocessing versions, disputes, adjudication, and regrading. The inspected response path does not currently bind an image to a response version, so later student review cannot yet be inferred from the existence of the `learner-uploads` bucket.

Retention, deletion, consent, EXIF handling, provider use, signed retrieval, parent/student access, and minor-data policy remain hard-gated decisions.

**Preliminary conclusion:** desired provenance is well described; durable response-level storage and student-history retrieval remain unverified.

## 5. Process failure and dirty-state disclosure

Before the charter and task approvals were re-read, the preparer incorrectly interpreted a broad session topic as permission to execute. This is relevant evidence for the reviewer because it may bias the preliminary technical framing.

Three commits were pushed to `codex/image-workflows-readiness`:

- `dd9feb2` — capture-session validation work;
- `b6c7045` — deterministic image release-candidate workflow;
- `6f4aba8` — image-authoring and synthetic drawn-capture prototypes.

The branch also contains uncommitted, unverified local changes:

- modified `supabase/functions/admin-content/index.ts`;
- new `supabase/functions/_shared/question-image.ts` and test;
- new `supabase/functions/attempt-content/` handler, adapter, and tests.

The last validation command was interrupted. None of these changes were deployed or merged. The uncommitted design should be treated as one hypothesis, not the baseline architecture. A separate governance decision is needed on whether to preserve, revise, split, or discard the unauthorized implementation work.

## 6. Proposed assessment plan

### Phase 0 — Governance reset and evidence map

1. Identify or create the canonical assessment task with tier, owner, branch, scope, exclusions, approval state, and QA plan.
2. Reconcile `TASK-0006`, `TASK-0011`, UX-003, UX-008, the August AP Statistics remediation, activity/decision/approval logs, and any later GitHub records.
3. Record the unauthorized branch work as a dirty-state handoff; do not merge or build on it.
4. Define the environments to inspect and the meaning of “current”: Production data, Production deployment, repository `main`, and feature/prototype branches.

**Output:** evidence register and explicit assessment boundaries.

### Phase 1 — Count questions that require an image

1. Export a read-only inventory of every current question version, status, exam pack, item type, stem, stimulus, structured prompt flags, image path, and relevant labels.
2. Separately verify whether referenced storage objects exist; do not expose signed URLs or learner data in the report.
3. Mechanically identify candidate image dependence from paths, visual language in stems/stimuli, missing-display flags, visual-purpose fields, structured specifications, and known content families.
4. Human-classify candidates into:
   - image essential to answering;
   - image helpful but incidental;
   - semantic table/structured visual rather than raster image;
   - learner creates the image as the answer;
   - accessible alternate item or representation;
   - false positive or ambiguous.
5. For essential-question images, classify lifecycle state: present, missing, stale/unverified, inaccessible, or display-unverified.
6. Report counts by exam, item type, status, and delivery eligibility with uncertainty and reconciliation totals.
7. Have a second reviewer independently classify all ambiguous cases and a sample of clear cases.

**Output:** reproducible inventory, exception list, and a defensible answer to question A.

### Phase 2 — Audit image creation, QA, review, and display

For every essential-question image or a stratified sample if volume requires it, trace:

1. authoring lane and source asset;
2. source/rights/originality record;
3. immutable version and checksum;
4. dataset/specification/renderer lineage where structured;
5. scientific and statistical review;
6. grading and answer-leakage review;
7. accessibility representation and construct-equivalence review;
8. viewport, zoom, reflow, contrast, screen-reader, and failure-state QA;
9. reviewer delivery;
10. student delivery on the exact question version;
11. monitoring, change classification, revalidation, rollback, and missing-asset response.

Compare observed evidence with the proposed four-lane architecture without assuming that architecture is approved. Surface the five unresolved `TASK-0006` owner decisions before recommending physical schema or API changes.

**Output:** lifecycle control matrix, defect register, process-owner gaps, and options for Product Owner/Learning Quality review.

### Phase 3 — Audit the hand-drawn capture capability end to end

Build a capability matrix for:

- primary-device question and paper instructions;
- QR generation and fallback link;
- short-lived, single-use, purpose-bound token;
- cross-device authentication and attempt/response binding;
- camera permission, gallery upload, and accessible alternative;
- framing, crop, rotation, retake, and explicit submission;
- blur/glare/cutoff/perspective/resolution checks;
- upload signature/decode/size/dimension/malware/metadata controls;
- immutable original plus versioned derivatives;
- phone/desktop synchronization, expiry, retry, and idempotency;
- storage linkage to the exact response version;
- signed retrieval, retention/deletion, dispute, regrade, and later student review.

For each capability, label: designed only, repository implementation, deployed, exercised, independently QA'd, or not found. Use consented test artifacts only; real learner or minor data requires a separate hard gate.

**Output:** truthful readiness matrix and a bounded prototype-test recommendation, not an implementation.

### Phase 4 — Audit grading and repair quality

1. Reconcile all hand-drawn corpora and experiments with the canonical DR-1 eligibility requirements.
2. Verify human-label provenance, item rights, participant consent, response-level partitioning, photo-variant leakage prevention, dual-blind labeling, adjudication, and locked holdout status.
3. Separate capture-quality performance, visual observation accuracy, criterion judgment, abstention calibration, scoring, and feedback.
4. Do not make an automated-grading claim below the DR-1 locked-holdout tier.
5. Apply DR-2 independently to feedback grounding, minimum-fix correctness, answer leakage, comprehension, and fresh-item transfer.
6. Compare drawn-response repair against the same evidence standard used for written answers; do not compare UI polish or anecdotal examples.
7. Preserve human review and abstention as first-class outcomes.

**Output:** evidence-grade grading verdict, feedback-parity verdict, and explicit stop/narrow/proceed conditions.

### Phase 5 — Independent QA and decision packet

Use a genuinely fresh QA context to challenge:

- inventory completeness and classification bias;
- live/repository/prototype conflation;
- accessibility and construct preservation;
- security, privacy, minor-data, and retention assumptions;
- grading sample leakage and insufficient power;
- false confidence from synthetic images or expert drawings;
- repair-feedback claims without independent transfer;
- operational burden, human review load, and stop conditions.

The final packet should present options rather than a preselected architecture:

- proceed with a bounded research prototype;
- narrow to capture and manual review only;
- narrow supported graph archetypes;
- defer automated scoring while retaining paper capture;
- revise the displayed-image governance model;
- or stop if usability, accessibility, safety, accuracy, or economics fail.

## 7. Questions for the independent reviewer

1. Is the proposed inventory taxonomy sufficient to answer “requires an image,” or does it hide important classes?
2. What evidence would make the count reproducible and resistant to subjective overcounting?
3. Which findings above are overstated, understated, or unsupported?
4. What alternative visual-asset architecture should be considered before physical implementation?
5. Should displayed-question images and learner-uploaded responses remain separate programs, share only infrastructure, or share a broader artifact model?
6. Is QR handoff the right default to test, or should direct primary-device capture/upload be the baseline comparator?
7. Are DR-1's sample sizes, metrics, thresholds, archetypes, and stop conditions adequate?
8. How should repair quality be compared fairly with written answers?
9. What privacy, retention, consent, accessibility, abuse, and operational risks are missing?
10. What should happen to the pushed and uncommitted work created before approval was confirmed?
11. What is the smallest next step that creates decision-quality evidence without prematurely committing to an architecture?

## 8. Source records reviewed

- `docs/team_charter/` (complete approved charter set and changelog)
- `docs/tasks/TASK-0006-VISUAL-STIMULUS-AND-RENDERING-SYSTEM.md`
- `docs/architecture/VISUAL_STIMULUS_AND_RENDERING_SYSTEM.md`
- `docs/tasks/TASK-0011-HANDWRITTEN-GRAPH-CAPTURE.md`
- `docs/tasks/UX-008-HANDWRITTEN-GRAPH-CAPTURE.md`
- `docs/tasks/UX-003-CONTENT-AUTHORING-REVISION-WORKBENCH.md`
- `docs/research/DRAWN_RESPONSE_ARCHITECTURE_REVIEW.md`
- `docs/research/DRAWN_RESPONSE_CAPTURE_PIPELINE_DRY_RUN_LOG.md`
- `docs/research/DRAWN_RESPONSE_RUBRIC_MATCH_PROTOCOL.md`
- `docs/research/DRAWN_RESPONSE_FEEDBACK_USEFULNESS_PROTOCOL.md`
- `docs/research/DRAWN_RESPONSE_PILOT_V0_REVIEW.md`
- `docs/research/AP_STATISTICS_FRQ_REMEDIATION_PLAN_2026_08_01.md`
- relevant entries in `docs/activity_log/ACTIVITY_LOG.md`, `APPROVALS_LOG.md`, and `DECISIONS_LOG.md`
- current repository implementations for content authoring, attempt/response handling, review queue image signing, storage signing, schema baseline, and prototypes on `codex/image-workflows-readiness`

## 9. Limitations of this packet

- No complete live cross-exam inventory has been run.
- No current Production UI or endpoint has been exercised end to end for image-bearing questions or QR capture.
- No live storage-object completeness audit has been run.
- No real-student or minor data was inspected.
- The preparer authored preliminary implementation work before re-reading the approval boundary, creating anchoring risk.
- Findings remain preliminary until an independent reviewer challenges them and the read-only assessment is completed.
