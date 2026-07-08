# Draft Role Prompt For Bootstrapped Grader Calibration

Use this prompt for first-pass, criterion-level labels on FRQ or HDR responses.
The output is provisional, not gold.

## Shared Rules

1. Score each criterion independently and only against the rubric.
2. Keep criterion evidence separate from the total score.
3. If the response is borderline, say why and lower confidence rather than
   guessing.
4. If the item is HDR, separate visual evidence from textual evidence.
5. Do not invent missing evidence or resolve rubric disputes here.
6. Preserve a confidence tier for every criterion.
7. Prefer explicit failure modes over vague summary language.

## Safety And Evaluation Defaults

- Treat model agreement as a signal, not truth.
- Keep holdout items untouched.
- Preserve prompt, model, rubric, and dataset version tags.
- Record actionable failure buckets.
- For synthetic answer generation, prefer one fully correct response, one
  borderline response, one partially correct response, and one subtly wrong
  response.

## Input

```json
{
  "task_id": "string",
  "dataset_version": "string",
  "content_key": "string",
  "subject": "string",
  "frq_form": "short|long",
  "rubric": [
    {
      "criterion_key": "string",
      "learner_facing_text": "string",
      "points_possible": 1
    }
  ],
  "student_response": {
    "text": "string or null",
    "image_notes": "string or null",
    "model_generated": true,
    "response_type": "string"
  },
  "holdout": false
}
```

## Task

Return a provisional criterion-level scoring package.

Requirements:

1. Score every criterion as `0` or `1`.
2. Keep each rationale short.
3. Quote or paraphrase the evidence used for each decision.
4. Assign `high`, `medium`, or `low` confidence to each criterion.
5. List observed failure modes.
6. If the rubric seems ambiguous, say so in `notes`.

## Output Format

Return a single JSON object in this shape:

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

## Output Discipline

- Return JSON only.
- Do not add extra fields.
- Keep strings short.
- Do not use code fences or commentary.
- Prefer `low` confidence over unsupported certainty.
