# Drawn-Response Architecture Review

**Status:** Research review; not implementation approval
**Related Tasks:** `TASK-0010`, `TASK-0011`, `TASK-0006`
**Product Owner:** David Bloom
**Reviewed:** 2026-06-13
**Input Reviewed:** Claude's `drawn-response-architecture.md`

## 1. Executive Verdict

Claude's proposal is a useful technology survey and correctly identifies the
main user-experience opportunity: let a learner draw on paper, use a phone to
capture the work, and return feedback to the primary learning device.

The proposal is not yet executable under Cramapple's approved architecture and
quality rules. It makes a vendor recommendation before a benchmark, treats a
single multimodal-model pass as an acceptable first grader, understates upload
security and minor-data requirements, conflicts with Cramapple's content-rights
policy, and replaces the approved learning-state model with a simple mastery
counter.

The recommended direction is:

1. Narrow the first capability to AP Biology quantitative graph construction.
2. Prototype paper-first QR capture and direct upload without learner-facing
   automated grades.
3. Build an adjudicated graph-image gold set under `TASK-0010`.
4. Compare deterministic geometry/OCR, multimodal-model, and hybrid extraction
   on the same locked holdout.
5. Separate visual observation from rubric judgment.
6. Calibrate abstention from observed errors rather than model confidence.
7. Enter shadow operation before any learner-facing score.

## 2. Why AP Biology Comes First

The 2026 AP Biology exam is hybrid digital: students view free-response
questions in Bluebook and handwrite answers in paper booklets. The free-response
section tests graphing and data analysis, and the second long question includes
experimental-results interpretation with graphing.

The initial Cramapple capability should therefore reproduce the actual AP
Biology operation:

- construct a quantitative graph from supplied data;
- label the graph correctly;
- plot values and uncertainty accurately where required; and
- answer associated written analysis separately.

Claude's AP Microeconomics labor-market example is a useful future stress test,
but it involves a different visual grammar: multiple conceptual curves,
equilibria, shifts, and policy markers. It should not define AP Biology V1.

Drawn response should remain a capability family rather than one universal
grader:

| Capability | Initial disposition |
| --- | --- |
| AP Biology quantitative graph construction | First research and validation target |
| Graph plus handwritten written explanation | Capture together; grade as separate linked modalities |
| Biological labeled diagram or model | Separate later research track |
| Economics multi-curve graph | Future exam-pack-specific track |
| Physics free-body diagram or circuit | Future exam-pack-specific track |
| Handwritten equations and derivations | Separate handwriting/math assessment track |

## 3. What To Retain From Claude's Proposal

### 3.1 Paper-First Capture

Paper-first work is exam-authentic and avoids prematurely building a general
drawing canvas. QR handoff plus direct file upload are reasonable prototype
flows.

### 3.2 Layered System Decomposition

Capture, pairing, quality checks, storage, inference, orchestration, and
feedback rendering should remain separately replaceable. The final architecture
should be vendor-neutral at the logical-contract level.

### 3.3 Raw And Derived Image Preservation

Keep the original upload immutable. Crops, rotations, contrast changes, and
other normalized images are derived artifacts with their own methods and
checksums. A derived image never replaces the original evidence.

### 3.4 Structured Criterion Output

Every grading result should be criterion-level and schema-validated. Structured
output improves system reliability, but schema validity must not be confused
with scoring accuracy.

### 3.5 Dispute And Review Workflow

Learners need recheck and dispute paths. Human corrections, adjudication, and
regrading must be versioned and connected to the exact image, rubric, prompt,
model, and preprocessing pipeline.

## 4. Blocking Corrections

### 4.1 Do Not Lift Official Questions Or Scoring Guides

Claude proposes using released College Board questions verbatim and modeling
rubrics directly on official scoring guides. This conflicts with Cramapple's
approved rights policy.

Cramapple must use independently authored or fully licensed questions and
scoring packages. Authorized human experts may extract abstract exam-alignment
requirements where counsel permits. Official question text, distinctive
scenarios, scoring language, images, and response samples must not become model
inputs, prompts, exemplars, evaluation cases, or production content.

### 4.2 Do Not Select A Model Before A Held-Out Bake-Off

No provider should be the architecture. Model names, pricing, image handling,
latency, and data terms change. More importantly, general vision capability
does not establish reliable grading of noisy student graphs.

Recent research benchmarks report substantial gaps between humans and
multimodal models on hand-drawn diagram grading. A 2025 handwritten-graph study
also found that specialized models could outperform vision-language models on
some classification tasks.

The first decision is the experiment, not "use Claude Sonnet."

### 4.3 Separate Perception From Judgment

A single model response currently mixes:

- image-quality assessment;
- handwriting and label recognition;
- geometry extraction;
- semantic graph interpretation;
- rubric judgment;
- confidence;
- annotation coordinates; and
- teaching feedback.

That output is difficult to audit and impossible to calibrate cleanly.

Use separate records:

```text
capture_quality_result
visual_observation_result
criterion_decision_result
confidence_and_abstention_result
feedback_result
```

The observation layer should describe evidence without awarding points. The
criterion layer should cite observation IDs and source-image regions. Feedback
should use only locked criterion decisions.

### 4.4 Do Not Trust Self-Reported Confidence

Confidence must be calibrated against adjudicated outcomes. It may depend on:

- image-quality measurements;
- extraction completeness;
- criterion-specific historical error;
- disagreement across independent methods;
- out-of-distribution signals; and
- known unsupported visual patterns.

A model saying it is confident is not evidence that it is correct.

### 4.5 Do Not Ship Single-Pass Automated Scoring As V1

`TASK-0010` requires dual-human gold labels, a locked holdout, calibrated
abstention, 100% human review in shadow operation, and a limited-release gate.
The proposal's "single-pass v1" conflicts with those controls.

The first working product may return:

- capture accepted;
- capture needs a retake; or
- feedback is pending expert review.

It must not present an unvalidated automated score as authoritative.

### 4.6 Treat Image Annotation As Optional And High Risk

Provider documentation acknowledges that vision models can struggle with graph
styles and precise spatial localization. A hard-coded acceptance of 5-10%
coordinate error is not suitable for criterion feedback.

Start with criterion cards that cite observable evidence. Add image overlays
only after a localization benchmark passes. A misleading circle or arrow can
teach the wrong correction even when the textual score is right.

### 4.7 Preserve The Approved Learning Model

Do not update "mastery" through a decaying counter or generic SM-2 schedule.
Drawn-response evidence must use Cramapple's approved model:

- assessable target and facet;
- representation actually delivered;
- support and assistance level;
- immediate transfer;
- independent retry;
- delayed confirmation;
- learner Move On and Park choices; and
- evidence-weighted recommendations.

One corrected graph is not mastery.

### 4.8 Strengthen Capture And Upload Security

The HTML `capture` attribute is not uniformly supported and should be treated
as a progressive enhancement. QR pairing requires more than an opaque channel
name.

The design must include:

- short-lived, single-use, purpose-bound pairing capability;
- authenticated or narrowly scoped upload authorization;
- private realtime channels and access policies;
- file signature and decode validation;
- size, dimension, and page-count limits;
- metadata stripping before downstream use;
- malware and malformed-image handling;
- storage outside public paths;
- signed, short-lived retrieval;
- replay prevention and audit;
- rate limits and abuse controls; and
- explicit deletion and retention behavior.

### 4.9 Do Not Assume Preprocessing Helps

Cropping and deskewing may improve readability, but thresholding or contrast
enhancement can erase pencil marks, thin error bars, dashed lines, or labels.

Benchmark:

- original image;
- lossless orientation/crop only;
- document-normalized image; and
- task-specific enhanced variants.

Retain all variants and select preprocessing by measured criterion accuracy,
not visual neatness.

### 4.10 Replace Production Estimates With Measured Results

The proposed per-image costs, five-second response, one-day integrations,
two-day storage migration, and two-to-four-week build estimates are not
decision-grade. The executable plan needs measured:

- end-to-end latency distributions;
- retries and timeout rates;
- cost per accepted grade and per reviewed grade;
- human-review minutes;
- capture failure and retake rates;
- provider retention and regional-processing terms; and
- engineering effort after the prototype exposes actual failure modes.

### 4.11 Fix The Quality-Sampling Plan

Score outliers are not a reliable error detector. An unusual score can be
correct, and a common model mistake can look statistically normal.

Use the review sequence already defined in Cramapple governance:

- 100% human review in shadow operation;
- every escalation and dispute reviewed;
- at least 20% of apparently high-confidence cases during limited release;
- hidden sentinel cases after every relevant change; and
- production sampling and suspension triggers after general release.

## 5. Recommended Logical Architecture

```text
Learner paper response
  -> QR capture or direct upload
  -> security and decode validation
  -> immutable raw image
  -> capture-quality assessment
  -> retake or accepted capture
  -> versioned normalization variants
  -> visual observation candidates
       A. deterministic geometry and pixel analysis
       B. OCR or handwriting recognition
       C. multimodal model observation
  -> observation reconciliation and uncertainty
  -> criterion-level grader
  -> empirically calibrated confidence and abstention
  -> human review when required
  -> criterion feedback and optional validated localization
  -> independent retry and learning-evidence update
```

The pipeline should support multiple observation strategies behind one
contract. The benchmark should determine which strategy is used by graph
archetype and criterion.

## 6. Most Promising Technical Work

### Priority 1 - AP Biology Graph Grammar

Define the smallest supported grammar for original Cramapple questions:

- graph type;
- axes and variable assignment;
- labels and units;
- scale and tick behavior;
- plotted observations;
- uncertainty or error bars;
- legend or category mapping; and
- required relationship between graph and supplied dataset.

This bounded grammar creates opportunities for deterministic checks and makes
gold labeling repeatable.

### Priority 2 - Capture Quality Before Grading

Build and test the capture flow independently. A useful quality gate should
detect cutoff content, blur, glare, rotation, severe perspective, insufficient
resolution, and likely missing labels. It should explain one corrective action
at a time.

The capture prototype can produce valuable usability and image-quality evidence
without storing production learner data or displaying automated grades.

### Priority 3 - Hybrid Observation Benchmark

Compare at least:

1. multimodal model directly to criteria;
2. multimodal observation followed by a separate criterion grader;
3. deterministic geometry/OCR followed by a criterion grader; and
4. hybrid reconciliation of deterministic and multimodal observations.

The likely winning design is criterion-specific. Geometry may be strongest for
plot placement, OCR for labels, and multimodal reasoning for ambiguous marks.

### Priority 4 - Abstention And Human Escalation

Optimize for useful coverage at controlled risk, not maximum automation.
Determine which criteria can be safely automated and which remain human-only.

### Priority 5 - Teaching And Retry

After a locked score:

- identify the smallest repair;
- let the learner inspect evidence;
- ask for a fresh independent graph;
- distinguish a capture failure from a representation failure; and
- schedule delayed confirmation under the approved learning model.

## 7. Research Program To Reach An Executable Plan

### Gate 0 - Rights, Scope, And Participants

Required before dataset creation:

- Product Owner confirms the bounded AP Biology research scope.
- Learning Quality Owner defines graph archetypes and criterion primitives.
- Counsel confirms question, source, learner-image, consent, retention, and
  provider boundaries.
- Participant recruitment and compensation are approved.

### Phase 1 - Specification Package

Produce:

- supported and excluded response taxonomy;
- three or fewer initial graph archetypes;
- versioned logical graph-rubric contract;
- capture and grading state machine;
- threat and privacy model;
- accessibility alternatives;
- evaluation protocol; and
- prototype acceptance criteria.

### Phase 2 - Capture Prototype

Prototype QR capture and direct upload using mock or consented test data.
Measure completion time, retake rate, device/browser compatibility, image
quality, learner comprehension, and accessible fallback use.

Do not connect production learner records or show automated grades.

### Phase 3 - Gold Set And Offline Bake-Off

Use the `TASK-0010` minimum held-out requirements:

- at least 300 independently authored, licensed, synthetic, or properly
  deidentified responses;
- at least 40 responses for every supported archetype;
- dual-blind qualified grading with lead adjudication;
- development, calibration, holdout, and challenge partitions split by
  underlying response, not by photo variant; and
- capture-condition variants retained for robustness analysis.

Evaluate the full governance metric suite, plus:

- capture-quality sensitivity and specificity;
- per-feature observation accuracy;
- response-level exact criterion-vector agreement;
- coverage-risk curve after abstention;
- robustness by camera, lighting, pencil/pen, crop, and handwriting;
- localization accuracy if overlays are proposed;
- latency and cost distributions; and
- human-review burden.

### Phase 4 - Shadow Prototype

Run the complete flow with 100% human review. Automated output remains hidden
or clearly non-authoritative until the gold and shadow gates pass.

### Phase 5 - Owner Decision Packet

The packet must identify:

- criteria approved for automation;
- criteria requiring human review;
- unsupported graph types;
- calibrated abstention policy;
- selected provider or provider-neutral routing rule;
- capture and accessibility findings;
- privacy and retention decision requirements;
- expected cost and reviewer load;
- implementation backlog and dependencies; and
- explicit proceed, revise, or stop recommendation.

## 8. Stop Conditions

Pause or narrow the capability if:

- capture failure or retake burden undermines the cram-window value;
- no method reaches the approved criterion thresholds on a locked holdout;
- safe coverage is too low after abstention;
- human-review burden removes the economic advantage;
- accessibility alternatives do not preserve the assessed construct;
- provider data terms are unacceptable for minors' work;
- rights-cleared training and evaluation evidence cannot be assembled; or
- graph feedback does not improve independent retry performance.

## 9. Sources

- [AP Biology Exam, 2026](https://apstudents.collegeboard.org/courses/ap-biology/assessment)
- [AP Biology Course and Exam Description, effective Fall 2025](https://apcentral.collegeboard.org/media/pdf/ap-biology-course-and-exam-description.pdf)
- [Hybrid Digital AP Exams](https://apcentral.collegeboard.org/exam-administration-ordering-scores/administering-exams/digital-ap-exams/hybrid-digital)
- [MDN: HTML `capture` attribute](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/capture)
- [Supabase Realtime authorization](https://supabase.com/docs/guides/realtime/authorization)
- [OWASP File Upload Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/File_Upload_Cheat_Sheet.html)
- [OpenAI image and vision limitations](https://developers.openai.com/api/docs/guides/images-vision)
- [SketchJudge benchmark](https://arxiv.org/abs/2601.06944)
- [Automated Grading of Students' Handwritten Graphs](https://arxiv.org/abs/2507.03056)
- [FERMAT handwritten-math benchmark](https://arxiv.org/abs/2501.07244)
