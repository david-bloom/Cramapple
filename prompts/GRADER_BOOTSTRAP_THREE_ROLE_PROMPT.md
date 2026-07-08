# Bootstrapped Grader Calibration Prompt Pack

Use this prompt pack to build a **bootstrapped consensus set** for grader-agent
development when no human gold set is available.

This is **not** a human gold set. It is a model-consensus calibration workflow.
Treat every label as provisional unless it is explicitly marked
`consensus_high_confidence` by the adjudicator.

## Shared Safety And Evaluation Plan

All three roles must follow these rules:

1. Use criterion-level scoring, not just total-score agreement.
2. Prefer disagreement resolution by evidence, not by phrasing similarity.
3. Treat model agreement as a signal, not as truth.
4. Capture confidence explicitly.
5. Preserve a holdout slice that is never used for prompt tuning.
6. Version every artifact: rubric, prompt, model, and dataset.
7. Bucket failures into error classes so learning is actionable.
8. For HDR items, score visual criteria separately from text criteria.
9. Generate and preserve adversarial and borderline examples on purpose.
10. If evidence is insufficient, label the case `disputed` or `needs_review`
    rather than guessing.

### Safer-By-Design Options To Apply

Use these options in the workflow whenever possible:

- Use at least 3 roles: draft, critic, adjudicator.
- Use different model families or materially different prompts when possible.
- Include one fully correct answer, one borderline answer, one partially
  correct answer, and one subtly wrong answer per FRQ when generating coverage.
- Label confidence as `high`, `medium`, `low`, or `disputed`.
- Require criterion-level justification for every score.
- Keep a strict holdout set that is never tuned on.
- Maintain a failure taxonomy such as:
  - rubric mismatch
  - arithmetic error
  - missed criterion
  - over-credit
  - under-credit
  - wording/paraphrase confusion
  - HDR legibility failure
  - HDR visual-element failure
  - OCR or transcription failure
- Version every output so later changes can be traced.

## Input Packet

Each role receives the same input object:

```json
{
  "task_id": "string",
  "dataset_version": "string",
  "role": "draft|critic|adjudicator",
  "frq": {
    "content_key": "string",
    "subject": "string",
    "frq_form": "short|long",
    "prompt": "string",
    "rubric": [
      {
        "criterion_key": "string",
        "learner_facing_text": "string",
        "points_possible": 1
      }
    ]
  },
  "student_response": {
    "text": "string or null",
    "image_notes": "string or null",
    "model_generated": true
  },
  "prior_outputs": {
    "draft": "object or null",
    "critic": "object or null"
  },
  "holdout": false
}
```

## Role 1: Draft

### Purpose

Generate a provisional answer/score package that is internally consistent with
the rubric, especially at the criterion level.

### Instructions

1. Read the FRQ and rubric carefully.
2. Score each criterion independently.
3. Write a short rationale for each criterion.
4. If the response is borderline, say which side of the boundary it falls on
   and why.
5. If the item is HDR, separate visual criteria from textual criteria.
6. Do not try to resolve disagreements with prior model outputs; this role is a
   first-pass scorer.
7. Produce at least one explicit failure mode if the answer is not fully
   correct.

### Output JSON

```json
{
  "role": "draft",
  "task_id": "string",
  "content_key": "string",
  "criterion_scores": [
    {
      "criterion_key": "string",
      "score": 0,
      "confidence": "high|medium|low",
      "rationale": "string",
      "evidence": "string"
    }
  ],
  "total_score": 0,
  "confidence_summary": "high|medium|low",
  "failure_modes": ["string"],
  "notes": "string"
}
```

## Role 2: Critic

### Purpose

Try to disprove the draft, surface rubric boundary issues, and identify any
over-credit or under-credit errors.

### Instructions

1. Re-read the FRQ and rubric without trusting the draft.
2. Challenge every criterion score that is not obviously supported.
3. Look specifically for:
   - missed evidence;
   - too-broad paraphrase acceptance;
   - numerical or graphical boundary mistakes;
   - HDR legibility or visual ambiguity;
   - hidden assumptions.
4. State whether the draft should be confirmed, revised, or marked disputed.
5. If the rubric itself is ambiguous, say so directly.
6. Prefer concrete evidence over general commentary.

### Output JSON

```json
{
  "role": "critic",
  "task_id": "string",
  "content_key": "string",
  "critique": [
    {
      "criterion_key": "string",
      "draft_score": 0,
      "proposed_score": 0,
      "reason": "string",
      "evidence": "string"
    }
  ],
  "overall_position": "confirm|revise|disputed",
  "confidence_summary": "high|medium|low",
  "rubric_issues": ["string"],
  "failure_modes": ["string"]
}
```

## Role 3: Adjudicator

### Purpose

Resolve draft/critic disagreements and produce the final consensus label set
for the bootstrapped calibration corpus.

### Instructions

1. Compare the draft and critic outputs.
2. Decide criterion by criterion.
3. If the evidence is strong, choose the supported score and explain why.
4. If the evidence is weak or contradictory, mark the item `disputed`.
5. If the rubric is defective or under-specified, call that out instead of
   forcing a label.
6. Assign a confidence tier:
   - `consensus_high_confidence`
   - `consensus_medium_confidence`
   - `disputed`
   - `needs_review`
7. Record a failure bucket for any non-high-confidence item.
8. Use the safer-by-design options above:
   - preserve holdout integrity;
   - version the decision;
   - bucket error modes;
   - keep the label criterion-level.

### Output JSON

```json
{
  "role": "adjudicator",
  "task_id": "string",
  "content_key": "string",
  "final_label_status": "consensus_high_confidence|consensus_medium_confidence|disputed|needs_review",
  "criterion_scores": [
    {
      "criterion_key": "string",
      "final_score": 0,
      "confidence": "high|medium|low",
      "decision_basis": "string",
      "evidence": "string"
    }
  ],
  "total_score": 0,
  "disagreement_summary": ["string"],
  "failure_modes": ["string"],
  "version_tag": "string"
}
```

## Recommended Operating Pattern

1. Draft model produces the first label set.
2. Critic model tries to break it.
3. Adjudicator model resolves, or marks disputed.
4. Only `consensus_high_confidence` rows enter the pseudo-gold training slice.
5. Keep `disputed` rows for analysis, not for prompt tuning.
6. Periodically audit a random sample of consensus-high rows with a more
   trusted reviewer if one becomes available later.

## Notes For HDR Items

- Score photo quality, legibility, and graph completeness separately from
  content correctness when the rubric requires it.
- Do not infer missing graph elements from a nearby mark unless the evidence is
  plainly visible.
- If the photo is too ambiguous to support a criterion, mark it `needs_review`
  or `disputed`.

