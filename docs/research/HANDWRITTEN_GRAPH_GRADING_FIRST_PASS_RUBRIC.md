# Handwritten Graph Grading First-Pass Rubric

**Status:** Research rubric draft
**Purpose:** Define a first-pass evaluation standard for hand-drawn graph images
so we can measure capture quality, feature visibility, completeness, and
grading confidence before any higher-stakes automation.
**Scope:** Research only. This rubric does not authorize production upload,
storage, learner-facing scores, or human scoring.
**Anchor set:** `IMG_6914.heic`, `IMG_6913.heic`, `IMG_6912.heic`

## 1. What This Rubric Is For

This rubric is meant to answer four questions for each image:

1. Is the image readable enough to evaluate?
2. What kind of graph is it?
3. Which required graph features are visibly present or missing?
4. Can we make a bounded judgment, or should we abstain?

The rubric is intentionally stricter than a normal “best effort” review. If the
image does not support a reliable decision, the correct output is abstention,
not guessing.

## 2. What This Rubric Is Not For

This rubric is not for:

- human scoring;
- learner-facing feedback;
- accepting a blurry or partial graph by inference;
- correcting the student’s work in the absence of visible evidence;
- deciding whether a response deserves credit when key marks are missing;
- converting image quality problems into graph correctness judgments.

Capture quality and graph correctness are separate decisions.

## 3. Evaluation Order

Evaluate every image in this order:

1. Capture quality.
2. Graph family / format.
3. Completeness.
4. Visible feature extraction.
5. Correctness against the known rubric or prompt.
6. Confidence and abstention.

Do not skip straight to correctness if the image is too partial or too noisy to
support feature reading.

## 4. Capture-Quality Labels

Use one of these labels:

- `clear`
- `usable_with_caution`
- `too_partial`
- `unreadable`

### 4.1 `clear`

Use when:

- the page or graph region is fully readable;
- axis labels and plotted marks are legible enough to inspect;
- there is no severe blur, glare, or cutoff that blocks evaluation.

### 4.2 `usable_with_caution`

Use when:

- the image is readable but slightly noisy, skewed, or dim;
- a small amount of uncertainty remains, but the core graph is still visible.

### 4.3 `too_partial`

Use when:

- the image shows some graph structure, but not enough of the response to
  evaluate all required features;
- a major section is cut off, blank, or missing;
- the page appears to be an incomplete draft rather than a finished response.

### 4.4 `unreadable`

Use when:

- the image is too blurry, dark, or obstructed to inspect the graph reliably;
- the graph is not recoverable from the visible evidence.

## 5. Graph-Family Labels

Classify the response as one of:

- `categorical_comparison`
- `continuous_series`
- `relationship_estimate`
- `unsupported_or_unknown`

Use `unsupported_or_unknown` when the image does not clearly fit the supported
graph families or does not expose enough evidence to classify it.

## 6. Completeness Labels

Use one of these labels:

- `complete`
- `mostly_complete`
- `partial`
- `insufficient`

### 6.1 `complete`

Use when all major required elements are visible and legible.

### 6.2 `mostly_complete`

Use when the graph is present and readable, but one minor element is weak,
slightly clipped, or ambiguous without changing the overall evaluability.

### 6.3 `partial`

Use when one or more major required elements are missing or cut off, but the
response still provides some usable evidence.

### 6.4 `insufficient`

Use when the image does not provide enough visible evidence to make a reliable
judgment.

## 7. Visible Feature Checklist

Mark each feature as one of:

- `present`
- `absent`
- `ambiguous`
- `not_applicable`
- `not_visible`

Recommended features:

- title
- x-axis
- y-axis
- axis labels
- units
- tick marks
- category labels or numeric scale
- plotted points or bars
- error bars / uncertainty marks
- line or curve where required
- legend where required
- estimate annotation where required
- correction marks or overwritten data

## 8. Correctness Labels

Once the image is readable enough, use one of these overall judgments:

- `correct`
- `partially_correct`
- `incorrect`
- `cannot_determine`

### 8.1 `correct`

Use only when the visible graph matches the required structure and the required
elements are present.

### 8.2 `partially_correct`

Use when some required features are present and correct, but others are missing,
misplaced, or ambiguous.

### 8.3 `incorrect`

Use when the visible graph clearly conflicts with the expected structure or
required features.

### 8.4 `cannot_determine`

Use when the image quality or completeness prevents a reliable correctness
judgment.

## 9. Abstention Rules

Abstain when any of the following is true:

- the response is too partial to support feature-level evaluation;
- the graph family is unsupported or unknown;
- the image quality prevents reliable reading of the key marks;
- the rubric depends on content that is not visible;
- the evaluator would have to guess missing data.

When abstaining, return a reason code such as:

- `image_too_partial`
- `unsupported_graph_family`
- `key_features_not_visible`
- `missing_required_context`
- `ambiguous_structure`

## 10. Output Schema For Each Image

Every evaluation record should include:

```text
image_id
capture_quality
graph_family
completeness
visible_features
missing_features
correctness
confidence
abstain
abstain_reason
notes
```

## 11. First-Pass Anchor Interpretations

These anchors are not final gold labels. They are working references for the
next evaluation pass.

### 11.1 `IMG_6914.heic`

Recommended first-pass labels:

- `capture_quality`: `clear`
- `graph_family`: `categorical_comparison`
- `completeness`: `complete`
- `correctness`: `partially_correct` or `correct`, depending on the target
  prompt package
- `confidence`: high

Observed strengths:

- full page is visible;
- graph axes and labels are legible;
- plotted values and uncertainty marks are visible;
- the response is strong enough to serve as a positive anchor.

### 11.2 `IMG_6913.heic`

Recommended first-pass labels:

- `capture_quality`: `clear`
- `graph_family`: `categorical_comparison`
- `completeness`: `partial`
- `correctness`: `cannot_determine`
- `confidence`: low to medium
- `abstain`: yes, if the missing response area is required for scoring

Observed strengths:

- graph frame, axes, and labels are visible;
- the page is readable enough to identify the intended graph structure.

Observed limitation:

- the plotted response appears incomplete enough that correctness should not be
  inferred.

### 11.3 `IMG_6912.heic`

Recommended first-pass labels:

- `capture_quality`: `clear`
- `graph_family`: `categorical_comparison`
- `completeness`: `complete`
- `correctness`: `partially_correct` or `correct`, depending on the target
  prompt package
- `confidence`: high

Observed strengths:

- graph family is obvious;
- axes, labels, and plotted values are visible;
- uncertainty bars are visible;
- the response is strong enough to serve as a second positive anchor.

## 12. Measurement Targets For The Next Batch

For the next generated images, track:

- capture-quality classification accuracy;
- graph-family classification accuracy;
- completeness classification accuracy;
- visible-feature extraction accuracy;
- abstention precision;
- abstention recall;
- false positive rate on `correct`;
- false negative rate on `cannot_determine`.

## 13. Minimum Decision Rules For Improvement

Use this rubric to improve the system if all of the following become true:

- capture-quality labels are stable across images of similar difficulty;
- partial images are not being over-scored;
- unsupported or unknown graphs are being abstained on;
- completeness and correctness stay separate in the output;
- the system stops guessing missing axes, labels, or plotted marks.

If any of those fail, tighten the rubric before expanding the dataset.

