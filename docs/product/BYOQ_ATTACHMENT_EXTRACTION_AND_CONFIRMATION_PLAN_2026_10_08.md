# BYOQ Attachment Extraction and Student Confirmation Plan

**Status:** Proposed — review required before implementation  
**Date:** 2026-10-08  
**Product Owner:** David Bloom  
**Prepared by:** Codex  
**Related task:** `TASK-0039` follow-on; implementation should receive its own Hard-Gate task ID  
**Related records:** `DECISION-0057`, `DECISION-0068`, `DECISION-0077`, `DECISION-0084`; `APPROVAL-0058`  
**Related designs:** `STUDENT_PROVIDED_QUESTION_INTAKE_DESIGN.md`; `BYOQ_WORKSHEET_PARSING_DESIGN.md`  
**Tier:** Hard-Gate  

> **Review boundary.** This document is a plan, not authorization to implement. It authorizes no
> model/vendor commitment, schema or migration change, deployment, secret/configuration change,
> Production write, privacy-policy change, or launch. David's 2026-10-08 direction establishes the
> intended experience: Cramapple should extract the question's structure and classification from an
> uploaded photo or worksheet, then ask the student to confirm or correct it instead of making the
> student enter every field manually. The plan and its remaining choices must be reviewed before work
> begins.

## 1. Decision to encode

When a student photographs a question or attaches a worksheet, Cramapple should attempt to propose:

- subject;
- AP unit;
- AP topic;
- question type (`mcq` or `frq`);
- question text;
- MCQ answer choices, when present;
- shared stimulus, passage, table, graph, diagram, or prior subpart needed to understand the question;
- question boundaries when an attachment contains more than one question; and
- a confidence value and warnings for every proposed field.

The student reviews the proposal beside the original attachment, corrects anything that is wrong,
and explicitly confirms it. Manual entry remains available when extraction fails or a student prefers
it, but it is not the default path after a photo or document upload.

In this plan, **"MCQ answers" means the visible answer-choice text**. It does not mean a correct-answer
key. BYOQ still stores no canonical answer, rubric, `is_correct`, rationale, or other grading truth.
A marked correct answer, answer key, worked solution, or teacher annotation is suspected answer
material and follows the quarantine/masking gate in §6.

## 2. Why this is new scope

The existing designs contain much of the right confirmation UX:

- `STUDENT_PROVIDED_QUESTION_INTAKE_DESIGN.md` already defines Original Submission versus Cramapple
  Captured, editable extraction, proposed subject/unit/topic, confidence-aware confirmation, and an
  explicit extraction-failure state.
- `BYOQ_WORKSHEET_PARSING_DESIGN.md` already defines server-side splitting, staging candidates,
  per-candidate confirmation, answer-key masking, and no bulk confirm.

But `TASK-0039` Phase 2 deliberately shipped with the opposite implementation default: no automatic
OCR; the student takes a photo and then types or pastes the transcription. This plan supersedes that
default for the follow-on work. It also expands worksheet parser output from boundaries + item type +
stem/choices to include subject, unit and topic inference.

This should be a new implementation slice rather than silently reopening the already-shipped
`APPROVAL-0058` scope. It affects model/vendor processing, student uploads, privacy, cost controls,
schema, background work, and Production behavior, so it remains Hard-Gate.

## 3. Product goals

1. **Make upload the input.** A usable photo or document should prefill the review screen without a
   second transcription task.
2. **Ask for verification, not data entry.** Students correct proposed values; they are not asked to
   repeat information Cramapple can see.
3. **Do not trade convenience for fabrication.** Low-confidence fields remain visibly unresolved;
   the system never invents missing choices, diagrams, passages, units, or topics.
4. **Preserve the BYOQ boundary.** Extraction must never turn a student's upload into a graded item,
   an Open Hand item, canonical content, or an answer-bearing record.
5. **Work anonymously and signed in.** The same extraction and confirmation behavior must work for an
   anonymous owner key and a recognized signed-in student. Sign-in changes persistence, not capability.
6. **Handle one or many questions.** A single photo normally yields one candidate; a worksheet may
   yield several, each independently confirmed.
7. **Degrade cleanly.** If parsing is uncertain or fails, retain the original, explain what could not
   be read, and offer correction, crop/retake, another upload, or manual entry.

## 4. Non-goals

- Determining or revealing the correct answer to the student's question.
- Grading the student's answer or work.
- Generating a worked solution specific to the uploaded question.
- Publishing uploaded material or promoting it into Cramapple's canonical item bank.
- Building a full document editor, arbitrary merge/split canvas, or OCR-vendor abstraction for every
  future file type in the first release.
- Changing the shipped 30-day anonymous-owner retention policy without a separate decision.
- Treating parser confidence as proof that a taxonomy classification is correct.

## 5. Intended student flow

### 5.1 Single photo or screenshot

```text
1. Choose Take a photo / Upload an image
2. Preview, crop/rotate if needed, and submit
3. Safety normalization and extraction run
4. Review Cramapple's proposal beside the original
5. Correct highlighted fields or supply only missing context
6. Confirm the question
7. Enter the existing BYOQ guidance experience
```

The review card contains:

- subject, unit and topic;
- MCQ or FRQ;
- extracted question text;
- extracted MCQ choices, preserving labels and order;
- detected supporting material and any missing-context warning;
- confidence per field, not one misleading whole-question score; and
- `Confirm question` only after blocking warnings are resolved.

### 5.2 Worksheet or multi-page document

```text
1. Upload document/pages
2. Safety normalization and page processing
3. Split into ordered candidate questions
4. Show candidate-review list
5. Review and confirm each wanted candidate
6. Show confirmed / discarded / unresolved batch summary
```

The parser may propose shared subject/unit/topic defaults for the batch, but every candidate remains
editable and receives its own explicit confirmation. There is no `Confirm all` action.

If a worksheet spans more than one unit or subject, classification is per candidate. A batch default
is only a convenience, never a constraint.

### 5.3 Confidence behavior

| Field state | Student experience |
| --- | --- |
| High confidence | Prefilled, clearly reviewable, editable; still requires final confirmation. |
| Moderate confidence | Highlight the proposal and show likely alternatives where available. |
| Low confidence | Leave unresolved or show the best proposal as uncertain; ask only for this field. |
| Failed / missing | Name what could not be read and offer crop, retake, replace, or manual entry. |
| Conflicting evidence | Show the conflict; do not silently choose one interpretation. |

Confidence controls the review burden, not whether confirmation happens.

## 6. Answer-choice and answer-key boundary

### 6.1 Allowed extraction

For an MCQ, extract the visible options as ordered pairs such as:

```json
[
  {"choice_key": "A", "choice_text": "..."},
  {"choice_key": "B", "choice_text": "..."}
]
```

The confirmed payload remains constrained to the shipped exact-key allowlist. No parser/model output
may add `is_correct`, `correct`, `answer`, `rationale`, `explanation`, or an equivalent field.

### 6.2 Suspected answer material

The pipeline must separately detect and flag:

- answer keys;
- a circled, checked, highlighted, bolded, or otherwise marked option;
- phrases such as "correct answer," "answer:" or "solution";
- teacher annotations indicating correctness;
- worked calculations that appear to solve the photographed problem; and
- an answer section elsewhere in the same worksheet.

Suspected answer spans are masked before the first student-facing rendering of parser output. They
are not written into a confirmed `byoq_items` row. The student may remove a flagged span or assert
that it is not answer material and edit the remaining question, but confirmation stays blocked while
the server-side gate still detects an answer-bearing span.

The original private attachment remains viewable to its owner under the approved retention rules.
Masking parser output is not represented as erasing the source image.

### 6.3 Question attachment versus student response

The parser applies to `capture_role = question`. A later image of the student's own work remains
`capture_role = response`; it must not be folded into the question stem or choices. Mixing these roles
would create both answer leakage and a false question extraction.

## 7. Proposed extraction contract

Parser output is untrusted staging data. A proposed candidate should include:

```text
candidate_id
source_page / source_region
source_digest
item_type + confidence
stem + confidence
choices[] + per-choice confidence
stimulus_text / visual_presence / missing_context warnings
subject_candidates[] + confidence
unit_candidates[] + confidence
topic_candidates[] + confidence
answer_material_flags[]
personal_information_flags[]
parse_warnings[]
parser/model version
created_at / expires_at
```

Rules:

- Taxonomy values must resolve to the live Cramapple taxonomy; free-form model labels never become
  stored subject/unit/topic identifiers.
- Store ranked candidates when useful so the review UI can offer corrections without another model
  call.
- Preserve question numbering, choice labels, mathematical notation and meaningful layout order.
- Preserve a reference to the source region for review, but never trust a client-supplied crop or
  coordinate as an authorization boundary.
- A candidate is not a `byoq_items` row and is not practice-ready.
- Only the student's confirmed, server-revalidated payload becomes a `byoq_items` row.

## 8. Proposed technical shape

### 8.1 Processing stages

1. **Upload validation:** existing server-side byte/type/size/dimension checks; digest from actual
   bytes; metadata stripping that fails closed.
2. **Document normalization:** render supported pages/images into a bounded internal format; preserve
   page order; reject encrypted, malformed or over-limit files.
3. **Candidate detection:** identify one or more question regions and shared stimulus relationships.
4. **Structured extraction:** produce question type, stem, choices, supporting material and warnings.
5. **Taxonomy inference:** rank subject/unit/topic candidates against the live taxonomy.
6. **Safety gates:** answer-material detection, personal-information warnings, completeness checks and
   schema validation.
7. **Staging write:** persist only owner-scoped candidates and processing metadata.
8. **Student confirmation:** edit and confirm a candidate.
9. **Server revalidation:** re-run answer-material and shape checks against the edited payload.
10. **Promotion:** create the private BYOQ item through the existing BYOQ creation path.

### 8.2 Data model direction

Extend the staging model already proposed in `BYOQ_WORKSHEET_PARSING_DESIGN.md` rather than putting
unconfirmed parser output into `app.byoq_items`:

- `app.byoq_intake_batches` — owner, source attachment(s), digest, processing state, parser version,
  aggregate status and expiry.
- `app.byoq_intake_candidates` — batch, source region, proposed structured fields, ranked taxonomy
  matches, field confidences, warnings, student edits, review status, and eventual `byoq_item_id`.

The final migration design must decide whether anonymous ownership continues through the existing
hashed BYOQ owner key or uses a derived batch capability. It must not expose either table directly to
`anon`; anonymous operations continue through the authenticated BYOQ service boundary.

### 8.3 Execution and retry behavior

- Parsing should be asynchronous once it cannot reliably finish within the existing request budget.
- Every job is idempotent on owner + source digest + parser version.
- Retries must not duplicate batches, candidates, model charges or final BYOQ items.
- A parser/model timeout produces a resumable failed state, not an empty successful batch.
- The client may poll or subscribe to bounded status updates; it never receives service credentials.
- Parser/model version and prompt/config version are recorded for QA and rollback.

### 8.4 Vendor/model boundary

No vendor is selected by this plan. The implementation should expose a narrow internal contract so a
bake-off can compare candidates without coupling the schema or UI to one provider. Before any real
student upload is sent to an external processor, the Product Owner must approve:

- provider and model;
- data-retention and model-training terms;
- region/subprocessor posture;
- expected latency and per-page/per-question cost;
- volume caps and circuit breaker;
- failure and deletion behavior; and
- secrets/configuration and observability plan.

## 9. Evaluation before implementation commitment

Run a read-only/offline bake-off on a rights-controlled, purpose-collected evaluation set. Do not use
Production student uploads for vendor selection.

### 9.1 Evaluation matrix

Include all ten supported AP subjects and deliberately cover:

- clean printed single-question photos;
- phone photos with rotation, perspective, glare, shadow and mild blur;
- printed MCQs with two through six choices;
- FRQs, multi-part questions and shared stimuli;
- graphs, tables, diagrams, equations and scientific notation;
- one-page and multi-page worksheets;
- mixed-unit and mixed-subject documents;
- instructions, headers, page numbers and non-question material;
- answer keys, circled choices, worked solutions and teacher markings;
- personal information fixtures;
- unsupported, unreadable and adversarial files; and
- handwritten question text as a separately reported cohort, not silently averaged into print.

Do not use official or third-party questions outside an approved rights path. Synthetic and
Cramapple-authored fixtures are preferred for the benchmark.

### 9.2 Proposed measurements

- question-boundary precision and recall;
- question-count accuracy;
- stem completeness and material hallucination rate;
- MCQ choice count/order/text completeness;
- subject top-1 accuracy;
- unit/topic top-1 and top-3 accuracy;
- correct abstention rate when the source is unreadable or unsupported;
- answer-material flag recall and false-positive rate;
- personal-information flag behavior;
- student correction rate per field in usability testing;
- time from upload to review-ready;
- confirmation time for a single question and per worksheet candidate;
- cost per image, page and confirmed question; and
- duplicate/retry behavior.

### 9.3 Proposed quality gates for review

These are proposed starting thresholds, not approved requirements:

| Measure | Proposed gate |
| --- | --- |
| Clean printed single-question detection | ≥ 98% yields exactly one correct candidate |
| Worksheet boundary precision / recall | ≥ 95% / ≥ 95% on clean typeset cohort; report harder cohorts separately |
| MCQ choice completeness | ≥ 98% on clean typeset cohort; no invented choices |
| Subject top-1 | ≥ 98% across supported-subject fixtures |
| Unit/topic | ≥ 90% top-1 and ≥ 97% top-3 on in-scope, readable fixtures |
| Material hallucination | 0 accepted hallucinated stems/choices; uncertain output must abstain or be flagged |
| Answer-bearing structured fields | 0; schema rejects every planted field |
| Planted answer-key exposure in candidate text | 0 unmasked confirmed rows across the security test corpus |
| Anonymous versus signed-in behavior | Functional parity; only ownership/persistence differs |
| Idempotency | 0 duplicate candidates, items or billable retries in the retry suite |

Any threshold changed during review should be changed here before implementation so QA does not have
to invent a release bar after the build exists.

## 10. Delivery slices

### Slice 0 — approve the plan and choose the experiment

- Resolve §14 decisions.
- Create a new Hard-Gate implementation task with branch, owner, acceptance criteria and QA plan.
- Build the rights-controlled benchmark and human ground truth.
- Approve the vendor bake-off budget and data-use boundary.

**Exit:** approved plan plus an approved evaluation packet. No app/schema change.

### Slice 1 — offline parser bake-off

- Run candidate models/providers against the fixed benchmark.
- Compare quality, latency, cost and privacy/retention terms.
- Include planted answer-key, PII and malformed-file controls.
- Select a provider/approach or stop if none meets the bar.

**Exit:** Product Owner vendor/approach decision. No Production student data.

### Slice 2 — single-photo extraction in Development

- Add staging data model and owner/security policies.
- Parse one question from one photo.
- Infer subject/unit/topic and extract MCQ choices.
- Build Original versus Cramapple Captured confirmation UI.
- Keep manual entry as fallback.
- Verify anonymous and signed-in ownership paths.

**Exit:** Development-only, independent QA passed; no worksheet splitting and no Production deploy.

### Slice 3 — worksheet and multi-page extraction in Development

- Add bounded batch processing and candidate review.
- Add shared-stimulus links and per-candidate taxonomy confirmation.
- Add resume, discard and batch summary.
- Exercise cost caps, retries, duplicate uploads and partial failures.

**Exit:** Development-only, independent QA passed against the approved benchmark.

### Slice 4 — controlled Production pilot

- Separate explicit Production approval.
- Named testers only at first; no general rollout.
- Real-phone and representative worksheet tests.
- Monitor latency, failures, cost, correction rate, answer/PII flags and deletion behavior.
- Roll back by disabling new parsing while preserving typed/photo-only BYOQ.

**Exit:** pilot evidence and an explicit Product Owner expand/hold/rollback decision.

## 11. QA plan

Independent QA is required for every implementation slice and must use a context separate from the
implementer.

Minimum QA:

1. **Unit/contract:** schema allowlists, confidence rules, taxonomy resolution, warning propagation,
   answer/PII fixtures, parser-output rejection, idempotency and expiry.
2. **Integration:** upload → normalize → parse → stage → edit → revalidate → confirm; anonymous and
   signed-in; retries and resumptions; delete/expiry behavior.
3. **RLS/security:** no cross-owner reads; no direct `anon` grants; capability replay/expiry; source
   and derived-object authorization; service-role-only provider calls.
4. **Adversarial extraction:** answer keys, marked choices, prompt-like source text, hidden text,
   malformed PDFs/images, mixed questions and misleading headers.
5. **Regression:** existing typed intake, photo storage, delete, 30-day anonymous retention, no-answer
   checks, BYOQ topic hints and graded-practice separation.
6. **UX/accessibility:** keyboard and screen-reader confirmation, masked-span announcement, mobile
   photo flow, progress, failure recovery and no forced re-entry of high-confidence fields.
7. **Live pilot:** real phone, anonymous then signed-in claim/persistence, single photo, multi-page
   worksheet, cancellation, deletion and observability.

QA proposes Pass/Fail. It does not authorize Production or mark the task Done.

## 12. Privacy, rights and security requirements

- Send only metadata-stripped, validated derivatives to the parser/model.
- Do not send account identifiers, owner keys, filenames or unrelated metadata to a provider.
- Preserve private owner-only access. Parsing does not create a publication path.
- The intake notice must explain automated extraction and any external processor before launch.
- Provider terms must prohibit training on uploads and define deletion/retention acceptable to the
  Product Owner; legal/privacy review remains a Hard Gate.
- Abandoned raw uploads keep the shipped short sweep behavior. Staged derived candidates need a
  separately approved retention period (§14); they must not outlive the source/owner they depend on.
- A worksheet may contain third-party copyrighted material. The feature is private study use only;
  no item may flow into Cramapple authoring, SEO/AEO or public content without a separate clean-room,
  rights and moderation process.
- Logs and analytics must not contain question text, answer choices, image contents, owner keys or
  provider request bodies.
- Rate limits and global spend/circuit breakers fail closed before model invocation.

## 13. Observability and rollback

Record privacy-safe operational measures:

- job counts by terminal state;
- latency bands by input type/page count;
- candidate counts and confidence bands;
- correction/confirmation/discard rates without content text;
- provider errors and retry counts;
- cost units;
- answer/PII flag counts; and
- deletion/expiry success.

Rollback must not require undoing the shipped BYOQ feature. A feature/config gate disables attachment
parsing and returns the product to the current photo-reference/manual-entry behavior. Staged jobs stop;
already-confirmed BYOQ items remain usable because their final schema is unchanged. Any migration must
be additive and have a documented cleanup path for unconfirmed staging data.

## 14. Decisions for Product Owner review

The plan recommends the bold option where one is shown.

1. **Confirm terminology:** "MCQ answers" means answer choices; marked correct answers/keys are
   quarantined and never stored as grading truth.
2. **First release inputs:** **phone photos/screenshots plus image-based and ordinary PDFs**; defer
   DOCX and arbitrary office formats.
3. **Handwriting:** support printed question text first; treat handwritten question text as a measured
   best-effort cohort until it independently meets the gate.
4. **Batch cap:** approve **20 proposed candidates per upload**, with pages/bytes separately bounded.
5. **Staging retention:** choose how long abandoned parser candidates persist. Recommendation:
   **24 hours anonymous, 7 days signed in**, never beyond the source owner's deletion/expiry.
6. **Taxonomy uncertainty:** when topic confidence is low, recommend **show top alternatives plus
   `I'm not sure`**, rather than forcing a topic before the student can preserve the extraction.
7. **Unsupported subject:** keep the extracted question privately editable but do not promise AP
   guidance; offer a supported-subject correction or a clear unsupported state.
8. **Academic-integrity context:** collect once per batch with a per-candidate override when the parser
   detects materially different sections.
9. **Merge/split UI:** defer bespoke region editing; allow direct text correction and re-upload/crop in
   v1, then use pilot evidence to decide whether merge/split controls are needed.
10. **Provider selection:** approve an offline bake-off before choosing or integrating a vendor.
11. **Production rollout:** named pilot first, with a separate expand decision.
12. **Privacy-policy work:** decide whether the existing public policy must be refreshed before the
    Development pilot or before the first Production pilot. Recommendation: before Production.

## 15. Approval gates

| Gate | Required evidence | Approver | What it authorizes |
| --- | --- | --- | --- |
| A — Plan | This document reviewed; §14 answered; implementation task created | David | Detailed design/evaluation work only |
| B — Vendor/evaluation | Fixed benchmark, bake-off results, cost and privacy terms | David; privacy/legal review as needed | Chosen processor in Development |
| C — Development build | Approved task, schema/security design, budgets and secrets plan | David | Development migration/function/frontend work |
| D — Production pilot | Independent QA Pass, real-device plan, rollback, policy/copy readiness | David | Named Production pilot only |
| E — Wider release | Pilot evidence, monitoring, deletion evidence and remaining-risk decision | David | General availability |
| F — Done | Final QA recommendation, durable records, handoff and PO sign-off | David + Main Conductor | Task closure |

No silence-is-consent mechanism applies because the work is Hard-Gate.

## 16. Definition of plan approval

This plan is ready for implementation planning only when:

- David has answered or accepted every §14 item;
- the selected quality gates are explicit;
- the implementation work has a new task ID and clean branch;
- the evaluation corpus and rights basis are named;
- the provider bake-off has an approved cost ceiling and data boundary;
- privacy-policy/copy timing is decided; and
- the decision and approval are recorded in the canonical logs.

Until then, the correct state is **Proposed — review required before implementation**.
