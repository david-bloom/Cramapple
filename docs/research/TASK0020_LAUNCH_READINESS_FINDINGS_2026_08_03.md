# TASK-0020 Launch-Readiness Findings

Date: 2026-08-03  
Assessment status: findings complete; fresh independent QA pending  
Launch decision: not granted by this assessment  
Production changes: none

## Executive verdict

The locked 89-item AP Biology/AP Statistics slice is **not launch ready** for prompt visuals or hand-drawn responses.

| Program | Verdict | Named scope |
|---|---|---|
| A — Question visual delivery | **Launch blocked by named remediations**; **Hard gate unresolved: accessibility and Learning Quality** | 1 stored-image item and 62 structured/text visual-data items |
| B — Student response-image capture, preservation, and review | **Launch blocked by named remediations**; **Hard gate unresolved: privacy, security, retention, accessibility, and operations** | All 37 construction items |
| C — Image grading and repair | **Automated grading and repair blocked; capture, preservation, and review still required**; **Manual-review launch path required but not operational** | All 37 construction items and every grading criterion |

There is no safe narrowing inside the approved slice that preserves the Product Owner's locked requirement: `APPROVAL-0042` explicitly disallows narrowing to manufacture readiness. The 26 items with no prompt-visual candidate are not promoted by this assessment because the deployed session uses placeholder content rather than the locked published items.

## Headline inventory

The launch slice has:

1. **63 questions with required prompt visual/data presentation**: one stored raster image plus 62 text- or JSON-encoded data/visual structures.
2. **63 required prompt presentations that remain delivery-unverified or blocked end to end**. The sole raster image cannot be retrieved through the student content-asset authorization path; the deployed session does not render the locked items' stimulus, image path, or structured prompt data.
3. **37 questions requiring a learner-drawn response**: 32 AP Statistics and 5 AP Biology.

Manual review of the locked slice found no truly absent prior figure/table/context. Several Biology stimuli serialize intended figures into words or values; seven construct-sensitive alternates still require Learning Quality equivalence review.

Detailed classification: `docs/research/TASK0020_LAUNCH_SLICE_CLASSIFICATION_2026_08_03.md`.

## Evidence discipline

| Evidence | Label | What it establishes |
|---|---|---|
| Production SELECT-only content/storage/schema queries | **Live verified** | Item counts, exact image binding, private buckets/policies, canonical response/grading shape, absence of captures and drawn-item attempts |
| Production Edge Function source retrieved read only | **Live verified** | Current authorization and text-only response/grading contracts |
| `https://cramapple.vercel.app` route checks and public bundle inspection | **Deployed verified** | Public capture UI exists, but the session is placeholder-backed and does not render canonical visual content or attach an image to a canonical response |
| Committed validators, logical contracts, static prototypes, and tests | **Prototype/research only** or **Repository only** | Useful controls and UX work exist, but they are not Production capability |
| DR-1, DR-2, corpus and architecture documents | **Proposed** | Quality bars and evaluation method exist; qualifying runs have not occurred |
| Authenticated end-to-end student capture with a consented image | **Not verified** | Not executed because the assessment forbids learner uploads/mutations and no approved test account/artifact path was supplied |

## Program A — question visual delivery

### Findings

1. **The sole stored question image is not student-deliverable through the current canonical path.** `APBIO-FRQ-S-009` is bound to `Biology/FRQ/APBIO-FRQ-S-009.png`, and the object exists in the private `content-assets` bucket. The live `storage-sign-url` permits authoring and reviewer roles to download that bucket but does not permit students. `select_practice_frqs` returns only the private object path, not a signed student URL. **Live verified.**
2. **The deployed student session does not render canonical stimulus content.** The deployed `/session` bundle constructs placeholder Biology questions locally. Its question section renders `currentQuestion.stem`; it has no canonical `stimulus`, `stimulus_image_path`, `stimulus_table`, or `expected_graph_spec` render path. **Deployed verified.**
3. **All 62 structured/text visual-data prompts therefore lack deployed render evidence.** The issue is broader than raster delivery: many Biology tables are stored as pipe-delimited prose and all 37 construction items carry required data in stimulus/JSON. Neither representation was exercised in the deployed learner session. **Live + deployed verified.**
4. **The published image is not approved for release.** The recovered exact-version manifest records the current image's visual-layout gate as rejected and scientific, grading, accessibility, rights, construct-equivalence, and answer-leakage gates as pending. The v3 replacement is deterministic and technically reviewed locally, but remains `release_eligible=false` with all human and Production delivery gates pending. **Repository/prototype only.**
5. **Production carries no learner-facing alt or long-description metadata for S009.** Its `prompt_json` contains only `modules`; Storage metadata contains media facts, not accessible representation. **Live verified.**
6. **Failure behavior is not established in the deployed student product.** The approved rule is fail closed—do not serve, or replace with an independently approved construct-equivalent item. That behavior exists only in local review prototypes. **Not verified / prototype only.**
7. **AP Biology reachability is separately blocked.** All 41 published Biology FRQs have `practice_format IS NULL`, while the strict selector requires an exact non-null format. This is not an image-specific defect, but it prevents calling the Biology half of the locked slice student-servable. **Live verified.**

### Safe interim behavior

- Do not serve `APBIO-FRQ-S-009` until its asset, accessible representation, student delivery, and fail-closed behavior pass review.
- Do not silently replace any of the seven construct-sensitive textual representations with prose and count it as equivalent.
- Do not present the 37 construction items until their required stimulus data and response-image path are both available.

### Program A remediation handoff — next approval only

**Tier:** Critical launch blocker; implementation remains separately approved.  
**Owners:** Technical Owner; Content/Learning Quality Owner; Accessibility reviewer; Product Owner for failure behavior.

Approve a bounded student visual-delivery task that:

- makes exact-version prompt visuals available through a student-authorized server boundary without exposing private bucket access;
- renders the one image and the existing text/JSON data representations—no universal artifact model;
- carries approved accessible metadata with the rendered representation;
- removes or replaces an item before answer entry when essential delivery fails; and
- keeps the S009 replacement workflow's current review and rollback gates.

Acceptance evidence needed:

- S009 renders from an authenticated student route on supported desktop/mobile sizes and at required zoom/reflow, with approved alt/long description and no private-path exposure;
- a representative item from every structured/text representation and every construction archetype renders legibly and semantically;
- forced missing/expired delivery prevents an unanswerable item from accepting a response and follows the approved skip/replacement policy;
- exact content-version binding, rights, scientific/grading, accessibility, answer-leakage, and independent-QA gates are closed;
- the Biology serving-format blocker is resolved under its own content-serving approval.

Preliminary human review load for approval: at least seven construct-equivalence reviews plus S009 scientific, grading, accessibility, visual-layout, and rights reviews. At 15–30 minutes per review cell, reserve roughly **4–7 specialist-hours**, excluding engineering and independent device QA. This is a planning range, not measured throughput.

## Program B — capture, preservation, and authorized review

### Findings

1. **A deployed QR/photo interface exists.** The session can generate a QR/link, the phone route uses `accept="image/*"` and `capture="environment"`, and the UI exposes framing guidance, preview, retake, quality states, explicit submission, expiry, and error copy. Capture acceptance is described separately from answer correctness. **Deployed verified.**
2. **That interface is attached to placeholder items, not canonical responses.** `/session` generates `placeholder-handdrawn-*`; its canonical-looking item reference is `session-item:<placeholder id>`. After capture, it appends a string like `[hand-drawn capture submitted — capture:<id>]` to the text/raw answer. **Deployed verified.**
3. **The canonical Production response contract cannot attach an image.** `app.response_versions` stores only `response_text` and `response_parts`; `attempt-response` accepts only those fields. No attachment, capture-session, image-lineage, or response-image table/column exists in `app`. **Live verified.**
4. **No durable learner-image evidence exists in the canonical store.** `learner-uploads` is empty; the 37 drawn versions have zero canonical attempts, response versions, and grading results. **Live verified aggregate.**
5. **The bucket primitive is incomplete as a launch upload boundary.** `learner-uploads` is private and owner-prefixed, and students may request signed upload/download URLs. The bucket and signer set no MIME allowlist, file-size limit, decode/dimension rule, metadata handling, malware rule, attempt/response binding, or retention/deletion lifecycle. **Live verified.**
6. **Current-device upload is missing from the answering session.** The primary session always opens the QR/link component. The file input is on the paired phone route. There is no deployed baseline control to photograph or choose a file directly on the answering device. **Deployed verified.**
7. **The QR materiality decision is not falsifiable.** No supported-device inventory, numerator, denominator, percentage, uncertainty, or threshold was available. Because the approved requirement is a viable paper-photo path for every supported device class, QR must remain in the candidate path, but it cannot be the only proven route. **Not verified.**
8. **Later student and reviewer retrieval are not established.** The deployed UI can request a temporary preview during its placeholder capture flow, but no canonical response attachment exists for future student review, grading dispute, reviewer access, or regrade lineage. **Live + deployed verified.**
9. **The executable offline capture-session contract is sound research input, not implementation.** It correctly requires immutable binding, single-use hashed handles, separate quality and grading states, explicit learner review, retake lineage, and terminal behavior. Its own status states that Production implementation and participant testing remain unapproved. **Repository/prototype only.**

### Safe interim behavior

- Do not serve the 37 construction items as answerable practice.
- Do not count an uploaded object or capture-reference string as a preserved response.
- Do not tell learners a capture is stored for review or future access until canonical binding and retrieval are demonstrated.

### Program B remediation handoff — next approval only

**Tier:** Critical launch blocker with privacy/security hard gates.  
**Owners:** Technical Owner; Security/Privacy approvers; Product Owner; Accessibility reviewer; Operations owner.

Approve a bounded attachment-and-capture task using the simplest two routes:

1. current-device camera/gallery input; and
2. QR/fallback phone handoff when the primary device cannot reliably capture paper.

The minimum requirements-level attachment must bind one immutable original and any traceable derivatives to the exact learner, attempt, submitted response version, and content-item version; record capture, grading-eligibility, and review states separately; allow authorized later student/reviewer access; and reference approved retention/deletion rules. Reuse private storage and short-lived access primitives where they satisfy the requirement; do not create a universal artifact model.

Acceptance evidence needed:

- an approved supported-device matrix with the actual QR materiality numerator, denominator, percentage, uncertainty, and threshold;
- consented synthetic/adult test artifacts complete both routes on every supported device class;
- single-use/expiry/replay/recovery, file signature/decode/size/dimension/metadata, idempotency, and authorization tests pass;
- the exact response attachment survives submit, later student review, authorized manual review, dispute, and regrade without rewriting the original;
- capture `accepted`, `retake_required`, and `indeterminate` remain independent from automated eligibility and review status;
- privacy, retention/deletion, accessibility, and independent security QA approve the path.

## Program C — grading and repair

### Findings

1. **The canonical grader is text-only.** `evaluate-attempt` loads `response_text` and `response_parts`, constructs a text grading prompt, and has no attachment/image/perception input. The presence of `capture_error` and `transcription_error` vocabulary in repair research does not create an image grader. **Live/repository verified.**
2. **No launch-slice image grade exists.** All 37 drawn items have zero canonical attempts, responses, or grading results. **Live verified aggregate.**
3. **DR-1 has not qualified any automated method.** The protocol says all four candidate methods are unimplemented and the locked-holdout run has not occurred. The 300-response target is a proposed design, not evidence. **Proposed.**
4. **The available real-photo corpus is not governable yet.** A read-only audit found 372 local images but only 294 unique byte sequences, 78 excess duplicates, ancillary metadata in 271 files, and zero file-level consent/provenance declarations. It cannot be ingested, uploaded, or sent to a provider. **Repository-only aggregate audit.**
5. **Synthetic/reference images do not fill the gap.** The repository contains a large deterministic graph/question corpus and synthetic full/partial examples, but these do not establish performance on student handwriting, phone conditions, or authentic mistakes. **Research only.**
6. **Repair parity is untested.** DR-2 defines grounded, minimum-fix, comprehension, and independent-transfer requirements, but no qualifying run exists. **Proposed.**
7. **No operational learner-response manual-review path exists.** Existing review assignments and reviewer queue serve content artifacts, not response images. No response-image queue, reviewer retrieval contract, SLA, dispute/regrade path, qualification roster, or capacity commitment was found. **Live verified / not found.**

### Safe interim behavior

- Automated image grading and learner-facing image repair remain blocked for every archetype and criterion.
- Captures may not launch without an approved manual-review path; “human review pending” cannot be a dead-end label.
- Any future automation begins in hidden shadow mode with 100% human review after the manual path is operational.

### Program C remediation handoff — manual path

**Tier:** Critical launch blocker; operational design approval, not queue implementation.  
**Owners:** Learning Quality Owner; Operations owner; Privacy/Security approvers; Product Owner.

Approve a manual-review-path design that names supported archetypes, reviewer qualifications, secure image/prompt/rubric presentation, criterion-level decision and evidence capture, repair authoring, learner turnaround/SLA, escalation, dispute, regrade, audit, and later learner access. It must use the exact attachment from Program B and must not rely on automated perception.

Reviewer capacity is currently unproven because expected launch submissions and timed review minutes are both missing. For approval planning only, a **5–10 minute review plus 20% QA** implies roughly **10–20 qualified reviewer-hours per 100 submissions**. Before commitment, time a consented 20-response sample across the five Statistics archetypes and Biology construction cases, then combine the measured distribution with a declared launch-volume forecast and SLA.

### Program C remediation handoff — automation research

Keep this separate from the manual launch path. First make the 372-photo corpus governable or assemble a new consented corpus, remove duplicate leakage, and stratify by archetype, criterion, item, handwriting, score state, ambiguity, severe errors, and phone/photo conditions. Keep all photos of one underlying response in one partition. Implement at least two approved bake-off methods, run DR-1 on a locked holdout, require zero severe errors and every per-criterion gate, then run DR-2 grounding/repair/transfer evaluation. Automation remains shadow-only until those gates and 100% human review pass.

## Minimum-content-volume check

The approved minimum is the full named 89-item slice, not a post-defect survivor count. Removing all blocked visual/data and construction items would leave 26 nonvisual candidates, but that is not an approved launch slice and the deployed session does not serve those canonical items. Any future narrowing requires a separate Product Owner and Learning Quality decision; this assessment does not recommend one as a substitute for remediation.

## Revalidation triggers

Re-run the affected program's checks after any:

- content republication, changed image or structured stimulus, content-version or practice-format change;
- selector, content API, renderer, signed-delivery, storage-policy, bucket, or authorization change;
- capture route, token lifecycle, attachment contract, file-processing, retention/deletion, or supported-device change;
- rubric, grader, model, prompt, preprocessing, abstention, feedback, reviewer qualification, SLA, or dispute/regrade change;
- accessibility-equivalence or rights decision affecting an item.

Any new archetype, criterion, device class, or materially different photo condition is unsupported until its evidence is added; aggregate performance from existing cells does not carry over automatically.

## Verification performed

- SELECT-only Production metadata/schema/storage queries; no object contents, signed URLs, learner images, or personal data retrieved.
- Read-only retrieval of deployed Edge Function source for `attempt-response`, `storage-sign-url`, and `review-queue`.
- Deployed route inspection for `/`, `/hand-drawn-responses`, `/free-score-check`, `/session`, `/login`, and `/capture-phone` with no submission or account mutation.
- Public deployed bundle inspection. Recorded bundle SHA-256 values:
  - main: `7f79521b309d3d20f51b600744d627d87e233c646d2f1631edaafbc21c15a953`
  - session: `7795d3c22214dcfd708a4a36aacc76b12fcdcbba0b11a28dbad20f51a355bc5e`
  - capture functions: `53a36c7217f66018e6b99550ea4eed51c8b96fc0d021623d51c5793e5ffb55a6`
  - capture phone: `4e8adf7b5cd907282c956702371007da18993c9116aa4a867f222b2544431410`
- `python3 scripts/test_image_workflow_prototypes.py`: 10 tests passed.
- `python3 -m unittest test_image_release_candidate.py` from `scripts/`: 9 tests passed.
- `scripts/validate_image_package.py` accepted the recovered manifest structurally; its release gates remain open by design.

## Independent QA boundary

This report is **Ready for Review**, not independently approved. A fresh AI context or separately assigned reviewer must challenge the inventory, evidence labels, verdicts, remediation sizing, device assumptions, construct-equivalence list, and manual-review estimate before any implementation task is approved.
