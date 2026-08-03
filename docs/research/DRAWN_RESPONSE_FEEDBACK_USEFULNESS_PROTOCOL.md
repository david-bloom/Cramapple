# Drawn-Response Feedback Usefulness Protocol (DR-2)

**Status:** Proposed; Tier 1 may begin once DR-1 produces gold criterion
decisions to generate feedback from. Tier 2 requires Product Owner approval
of bounded participant scope. Tier 3 requires Hard Gate approval and is
described, not authorized, by this document.
**Owner:** Product Owner with Learning Quality Owner
**Last Updated:** 2026-06-18
**Related Tasks:** `TASK-0011`
**Related Specs:** `docs/teaching/LEARNING_SYSTEM.md` (sections 1, 3.6, 3.7,
4.1-4.4, 5.3, 10), `docs/architecture/CONTENT_GOVERNANCE_AND_VALIDATION.md`
(section 12.3), `docs/research/DRAWN_RESPONSE_ARCHITECTURE_REVIEW.md`
(sections 4.6, 6 Priority 5), `docs/product/HANDWRITTEN_GRAPH_CAPTURE
_EXPERIENCE_DESIGN.md`, `docs/team_charter/STANDING_APPROVAL_LANES.md`
(Lane 3), `docs/research/DRAWN_RESPONSE_RUBRIC_MATCH_PROTOCOL.md` (DR-1)
**Template:** Structured after `docs/research/GRADER_SPEED_SUBTASK_PROTOCOL.md`

## 1. Purpose

DR-1 tests whether grading decisions match the rubric. This protocol tests
the other half of the same sentence in the request that produced both
documents: whether the resulting feedback is actually useful to the
student. An accurate criterion decision wrapped in unhelpful feedback still
fails Cramapple's stated teaching premise — `LEARNING_SYSTEM.md` section 1:
"teach the student what that point is testing, have them attempt it, score
the attempt against the actual rubric criteria, and repair the specific gap
that lost the point." Accuracy is necessary; this protocol tests
sufficiency.

This protocol assumes DR-1's gold criterion decisions as a fixed input
(Tier 1 and Tier 2 below use gold labels, not a candidate method's output)
so that grading-accuracy questions and feedback-quality questions do not
confound each other. A wrong criterion decision wrapped in excellent
feedback is still a DR-1 failure, not a DR-2 success.

## 2. Priority Order (Binding)

1. **Safety and honesty** — feedback must never imply graph correctness
   from capture acceptance alone, and must never present unvalidated
   visual interpretation as fact (UX-008 design principles 8 and 10;
   Architecture Review section 4.4: "A model saying it is confident is not
   evidence that it is correct").
2. **Grounded** — feedback must cite something observable on the
   learner's own response, not generic rubric language (the literature's
   dominant AI-feedback failure mode, `LEARNING_SYSTEM.md` section 5.3).
3. **Effective** — feedback should produce independent transfer
   (`LEARNING_SYSTEM.md` section 3.6), not just look correct to an expert.
4. **Efficient** — feedback length and turnaround. Tertiary; never traded
   against the three above.

## 3. Operational Definition of "Useful Feedback"

Spec gap this protocol closes: `TASK-0011_PHASE_1_EXECUTION_SPEC.md`
section 8.4 lists rubric-match metrics only. It does not carry forward the
two feedback-quality release metrics that
`CONTENT_GOVERNANCE_AND_VALIDATION.md` section 12.3 already requires for
general FRQ grading:

| Metric | General-FRQ threshold (section 12.3) |
| --- | --- |
| Feedback evidence grounding | At least 98% references actual response evidence and the applicable criterion |
| Generic or rubric-recycled feedback defect | At most 2% |

This protocol proposes both apply to drawn-response feedback unchanged,
plus a graph-specific tightening: "actual response evidence" for a graph
means a specific, locatable mark or region on the learner's own image
(citable as an `observation_id` per
`scripts/drawn_response/schemas/observation_record.schema.json`), not a
restatement of the criterion in prose. Flag to Learning Quality that
`TASK-0011_PHASE_1_EXECUTION_SPEC.md` section 8.4 should likely be amended
to include these two metrics so a future locked-holdout run isn't treated
as a complete release gate without them.

Beyond grounding, "useful" decomposes into three independently measurable
properties, each tested at its own tier below:

- **Grounded** — cites a specific, locatable piece of evidence from the
  learner's own response.
- **Actionable (minimum-fix)** — identifies the smallest correction likely
  to earn the next point (`LEARNING_SYSTEM.md` sections 1 and 4.1) without
  leaking other hidden criteria (`CONTENT_GOVERNANCE_AND_VALIDATION.md`
  section 12.4: "Rubric criteria do not leak into cold orientation";
  UX-008 section 5: "Do not reveal hidden scoring criteria beyond what the
  student prompt already requires").
- **Effective** — a learner who receives the feedback and nothing else can
  independently complete a fresh, structurally equivalent graph criterion
  correctly. This is `LEARNING_SYSTEM.md` section 3.6's "immediate
  independent transfer," operationalized for one drawn-response criterion.

## 4. Non-Goals

- Do not test capture-quality UX comprehension generally — UX-008 already
  owns those research questions (its section 18).
- Do not test rubric-match accuracy — DR-1's job. This protocol holds
  grading accuracy fixed (uses gold labels) at Tiers 1-2.
- Do not run with real enrolled students, minors, or any non-deidentified
  production data without explicit Product Owner Hard Gate approval
  (`STANDING_APPROVAL_LANES.md` Lane 3: "Student-data, parent-access,
  privacy-policy, age-gating, or legal-risk decisions"). Tiers 1 and 2 are
  scoped specifically to avoid needing that gate; Tier 3 requires it and is
  described, not requested, here.
- Do not build or approve learner-facing image-overlay annotation
  (Architecture Review section 4.6 — out of scope until a separate
  localization benchmark is approved).
- Do not let this protocol's existence imply the existing, separately
  blocked Orly capture pilot (`docs/research/DRAWN_RESPONSE_PILOT_V0
  _REVIEW.md`) is superseded. See Open Question 4.

## 5. Pre-Registered Hypotheses

1. **H1 (estimate-linking criteria are hardest to ground):** Feedback for
   `ZERO_INTERCEPT_ANNOTATION` and `PLATEAU_ANNOTATION` decisions will show
   a lower Tier-1 grounding rate than feedback for presence/absence
   criteria like `CATEGORY_IDENTITY` or `UNCERTAINTY_MARKS`, because
   describing how an annotation should visibly link two pieces of evidence
   in evidence-grounded language is harder than pointing at one missing
   mark.
2. **H2 (Tighten vs. Show split holds, untested for graphs):**
   `LEARNING_SYSTEM.md` section 4.4 already defaults "insufficient
   specificity" gaps to Tighten and "missing knowledge" gaps to Show for
   text FRQs, but this mapping has never been validated for graph
   criteria. Prediction: Tighten-style minimum-fix feedback will produce a
   higher Tier-2 independent-transfer rate for specificity gaps (e.g., an
   unlabeled axis on an otherwise-correct graph), while Show-style faded
   worked examples will outperform Tighten for knowledge gaps (e.g., a
   learner who has never drawn a symmetric SEM bar before).
3. **H3 (capture-accepted is misread as graph-correct):** The
   comprehension check (section 7, Tier 2) will fail — the learner
   incorrectly answers that their graph is fully correct — at a materially
   higher rate when feedback follows a capture `ACCEPT` disposition than
   when it follows a `HUMAN_REVIEW` disposition, testing whether UX-008's
   "capture accepted is distinguished from graph correct" design principle
   actually survives contact with real feedback copy rather than just
   living correctly in the spec.

## 6. Tiered Design

### Tier 1 — Expert Grounding and Actionability Review

**Gate to start:** DR-1 has produced at least one corpus snapshot of gold
criterion decisions (any read tier — Tier 1 here uses gold decisions as
feedback-generation input, not as a rubric-match measurement, so DR-1's
own read-tier restrictions on quality claims don't apply to this use).
**Participants:** None. No governance gate.

For each `(criterion_label, decision, reason_code)` combination present in
the available gold data, draft the corresponding learner-facing feedback
text using a drawn-response adaptation of `LEARNING_SYSTEM.md` section
4.4's Repair-mode mapping (this draft mapping is itself a Tier-1
deliverable, not assumed in advance — see section 6's table below).

A blind panel of two expert reviewers (the Learning Quality Owner plus one
qualified tutor, neither the authoring item's author) independently rates
every feedback message:

- **Grounded** (Y/N, plus which `observation_id` it cites)
- **Generic or rubric-recycled** (Y/N)
- **Minimum-fix-correct** (Y/N — is the identified fix actually sufficient
  to earn the point, per `CONTENT_GOVERNANCE_AND_VALIDATION.md` section
  12.4's "the minimum fix is actually sufficient for the next point")
- **Leaks other hidden criteria** (Y/N)

Same dual-rate-plus-lead-adjudication discipline as the annotation
handbook (`docs/research/DRAWN_RESPONSE_ANNOTATION_HANDBOOK.md` section
2): neither reviewer sees the other's ratings until both are locked; a
third reviewer adjudicates disagreements.

**Metrics and pass thresholds:**

| Metric | Threshold |
| --- | --- |
| Grounded rate | At least 98% (matches section 12.3) |
| Generic-feedback rate | At most 2% (matches section 12.3) |
| Minimum-fix-correct rate | At least 95% (proposed; no general-FRQ precedent cites this exact number, treat as a working threshold pending Learning Quality confirmation) |
| Leaks-other-criteria rate | 0% (any leak is a standalone blocker, not an averaged rate) |

**Gate to Tier 2:** all four thresholds pass on the available snapshot.
Failing this tier means revising feedback templates and re-running Tier 1
— do not proceed to a participant test of feedback that experts have
already flagged as ungrounded or leaking.

### Tier 2 — Bounded Participant Transfer Test

**Gate to start:** Tier 1 passes. Product Owner approves bounded
participant scope — the same approval class already used for the Orly
capture-pilot precedent (`docs/research/ORLY_DRAWN_RESPONSE_PILOT
_PROTOCOL.md`), **not** the Hard Gate. This distinction matters: Tier 2
participants are compensated adults or qualified tutors, not enrolled
students or minors, so `STANDING_APPROVAL_LANES.md` Lane 3 does not apply
here. State this explicitly in any approval request so it is not conflated
with Tier 3's Hard Gate.

**Participants:** target 8-12 compensated adult participants or qualified
tutors. This is explicitly Smoke/Directional tier by sample size
(`bio_reference_layer_reporting_standard.md` section 3) — see Open
Question 2 on whether this is enough.

**Procedure per participant, per criterion under test:**

1. Participant attempts one `DRG-P1-*` item cold (no help).
2. Score the attempt using DR-1's gold-labeling protocol.
3. For each criterion the participant missed, show **only** the Tier-1-
   approved feedback for that criterion — no other intervention, no
   tutor commentary.
4. Immediately after reading the feedback, ask the single comprehension
   check: *"Does this feedback mean your graph is now fully correct?"*
   (Yes/No/Unsure). This tests H3 and the UX-008 capture-accepted-vs-
   graph-correct distinction.
5. Participant attempts a second, structurally equivalent item on the
   same criterion with a changed dataset (same archetype, different
   numbers/treatment labels), cold, with the feedback no longer visible.
6. Score the second attempt against the same criterion using DR-1's gold-
   labeling protocol. This produces a real `LEARNING_SYSTEM.md` section
   3.6 "immediate independent transfer: yes/no" observation.

**Metrics:**

| Metric | Treatment |
| --- | --- |
| Independent-transfer rate, per `criterion_label` | Report only at this n. Do not gate a production decision on a Tier-2 number. |
| Comprehension-check pass rate | Report only; flag any rate below 90% as a feedback-copy defect requiring revision before Tier 3 is even considered |
| Tighten-vs-Show effectiveness, per archetype | Qualitative + transfer-rate comparison; informs whether `LEARNING_SYSTEM.md` section 4.4's mapping should be amended for graph criteria |

**Gate to Tier 3:** Tier 2 does not have a numeric promotion gate by
design (the n is too small to set one credibly) — see section 8. Its
output is a go/revise/stop recommendation to the Product Owner, not an
automatic gate.

### Tier 3 — Real-Student Shadow Measurement (Hard Gate; not authorized here)

**Gate to start, all required:**

- DR-1 reaches Locked-Holdout tier and passes (`DRAWN_RESPONSE_RUBRIC
  _MATCH_PROTOCOL.md` section 12).
- Tier 1 and Tier 2 above pass and produce a Product-Owner-reviewed
  go recommendation.
- Product Owner Hard Gate approval (`STANDING_APPROVAL_LANES.md` Lane 3).
- The production provider review flagged in
  `docs/governance/provider_settings_review.md` section 5.
- Counsel review of consent and minor-data handling
  (`LEARNING_SYSTEM.md` section 13.4).

**Method (design only):** measure independent-transfer rate and
delayed-confirmation rate (`LEARNING_SYSTEM.md` section 3.7's Lock) on
real enrolled students during a 100%-human-reviewed shadow cohort
(`CONTENT_GOVERNANCE_AND_VALIDATION.md` section 12.5 step 6) — automated
output remains non-learner-facing or human-reviewed throughout.

This protocol specifies Tier 3's design now so it is ready the moment the
five gate conditions are met. It does not request, assume, or schedule
those approvals.

## 7. Feedback Mode Mapping Under Test (Tier 1 deliverable)

`LEARNING_SYSTEM.md` section 4.4 maps text-FRQ error diagnoses to Tighten
or Show. No equivalent mapping exists for drawn-response criteria. Tier 1
must draft one before generating feedback text to rate. Working starting
hypothesis, to be revised by Tier 1 findings:

| Criterion gap | Proposed mode | Rationale |
| --- | --- | --- |
| Missing or mislabeled axis/unit (`X_UNIT`, `Y_UNIT`, `X_VARIABLE`, `Y_VARIABLE`) | Tighten | Specificity gap — the learner likely knows what's needed, just omitted it |
| Missing uncertainty marks (`UNCERTAINTY_MARKS`) on a first-time item | Show | Likely a knowledge gap — learner may never have drawn a symmetric SEM bar |
| Missing or wrong point connection (`POINT_CONNECTION`) | Tighten | Usually a specificity/instruction-following gap |
| Missing best-fit relationship or estimate annotation (`BEST_FIT_RELATIONSHIP`, `ZERO_INTERCEPT_ANNOTATION`, `PLATEAU_ANNOTATION`) | Show | Likely unfamiliar procedure (fit-then-annotate) — needs a worked example, not a nudge |
| Plotted values present but inaccurate (`PLOT_VALUES`) | Tighten | Usually a precision/reading-the-table gap, not a knowledge gap |

## 8. Decision Gates

- **Tier 1 → Tier 2:** all four Tier 1 thresholds (section 6) pass.
- **Tier 2 → Tier 3 request:** Tier 2 produces a Product-Owner-reviewed
  recommendation, not an automatic numeric gate. A reasonable
  recommend-go bar: comprehension-check pass rate ≥ 90%, no
  criterion_label showing 0% independent transfer across all its Tier-2
  attempts (a hard floor — zero transfer on any tested criterion is a
  feedback-design failure regardless of overall average), and the
  Tighten-vs-Show qualitative findings folded into a revised section 7
  mapping.
- **Tier 3 promotion to general release:** governed entirely by the
  existing `CONTENT_GOVERNANCE_AND_VALIDATION.md` section 12.5
  Confidence-Building Release Sequence and `LEARNING_SYSTEM.md` section
  3.7's Lock mechanics — this protocol does not invent new release rules
  at Tier 3, it only specifies how to measure feedback effectiveness
  within that existing sequence.
- **Stop or revise:** if Tier 1 fails twice on the same feedback template
  after revision, or Tier 2's comprehension-check pass rate is below 75%,
  treat this as a feedback-design defect requiring a redesign of the
  feedback-generation approach itself, not just copy edits.

## 9. Out of Scope

- Rubric-match accuracy (DR-1).
- Capture-quality UX comprehension beyond the single H3 check (UX-008
  owns this generally).
- Image-overlay or coordinate-localization feedback (Architecture Review
  section 4.6).
- Any Tier 3 execution — design only.
- Production mastery-model updates from Tier 1/2 evidence — these are
  development-pilot observations, not learner-model-affecting evidence
  per `LEARNING_SYSTEM.md` section 13.3's anonymization/consent
  boundaries.

## 10. Open Questions for Reviewers

1. Is 8-12 Tier-2 participants enough given six items × up to nine
   criteria each? A per-criterion transfer-rate read at this n will mostly
   be single-digit counts per criterion — likely only enough for a
   directional flag on the worst-performing criteria, not a ranked
   comparison. Should Tier 2 instead concentrate all participants on the
   2-3 criteria H1 predicts will be hardest to ground, rather than
   spreading thin across all criteria?
2. Should Tier 2 participants be compensated general adults, or
   specifically AP Biology teachers/tutors who can better simulate a
   motivated-but-imperfect AP student's response patterns? Teachers may
   be too skilled to produce realistic gaps; general adults may produce
   gaps that don't resemble real AP Biology student errors at all.
3. Who owns drafting and iterating the Tier-1 feedback templates (section
   7) — is this Learning Quality, a hired content author, or something
   this protocol's Tier 1 reviewers do themselves as part of the rating
   pass?
4. How does this protocol relate to the existing, separately blocked
   Orly capture pilot? That pilot tests capture-flow usability with three
   prompts and is currently QA-blocked pending a v0.2 remediation
   (`docs/research/DRAWN_RESPONSE_PILOT_V0_REVIEW.md`). It is not a
   feedback-usefulness test and this protocol does not assume it is
   resolved first, but the same three pilot items could plausibly serve
   as Tier 2's item pool once both are ready — worth deciding explicitly
   rather than running two separate small participant studies.
5. Should the Tier 1 minimum-fix-correct threshold (proposed 95% in
   section 6) be confirmed by Learning Quality before Tier 1 runs, given
   it has no existing general-FRQ precedent to anchor it?
