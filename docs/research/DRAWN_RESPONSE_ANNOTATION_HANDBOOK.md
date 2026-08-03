# Drawn-Response Annotation Handbook

**Status:** Internal specification work, not a participant-labeling
authorization
**Version:** `v0.1`
**Related Tasks:** `TASK-0010`, `TASK-0011`
**Source Specification:** `docs/research/TASK-0011_PHASE_1_EXECUTION_SPEC.md`
(sections 4-7)
**Owner:** Learning Quality Owner / Grading Lead
**Last Updated:** 2026-06-18

## 0. What This Document Is

This handbook operationalizes the labeling rules already approved as research
specification in `TASK-0011_PHASE_1_EXECUTION_SPEC.md`. It does not add new
labeling policy. Where this handbook gives an example or a decision aid, the
example is illustrative and archetype-generic — it is not drawn from any of
the six authored `DRG-P1` items and must not be treated as a scoring
precedent for them.

This handbook does not authorize labeling production or learner data. Human
labeling of real responses still requires the approvals in the phase-1 spec's
section 10 (Product Owner bounded-pilot scope, Learning Quality criteria
approval, rights/counsel review, accessibility review).

Record formats referenced throughout this handbook are defined in:

- `scripts/drawn_response/schemas/observation_record.schema.json`
- `scripts/drawn_response/schemas/criterion_decision_record.schema.json`
- `scripts/drawn_response/schemas/capture_quality_record.schema.json`
- `scripts/drawn_response/schemas/partition_manifest.schema.json`

Validate any labeled JSONL file before submitting it with:

```text
python3 scripts/drawn_response/validate_records.py <schema-name> <file.jsonl>
```

## 1. Roles (spec section 6.1)

| Role | Responsibility | Cannot also be |
| --- | --- | --- |
| Corpus Coordinator | Assigns IDs, controls partitions, keeps model/algorithm output hidden from labelers | A Validator on a pair they coordinate |
| Grading Validator A | Independently labels every eligible response | Grading Validator B on the same response |
| Grading Validator B | Independently labels every eligible response | Grading Validator A on the same response |
| Lead Grading Validator | Adjudicates every disagreement between A and B | Validator A or B on a response they adjudicate |
| Capture Reviewer | Labels image quality only, without seeing criterion outcomes | A criterion-decision labeler on the same response before capture labeling is locked |
| Learning Quality Owner | Owns rubric defects and tolerance approval | — |

Item authors may label development-partition cases but must never label or
access `locked_holdout` or `challenge` cases (enforced structurally by
`check_partition_manifest.py`'s access-lock invariant check).

## 2. Labeling Order (spec section 6.2)

Follow this order for every response. Do not skip ahead — later steps depend
on earlier ones being locked.

1. Confirm rights, provenance, consent, and response identity.
2. Label each raw capture independently for capture quality (section 3
   below). The Capture Reviewer must not see criterion outcomes yet.
3. Select the predeclared image variant for primary scoring (the rule is
   fixed per item before labeling starts, not chosen per response).
4. Record visual observations (section 4 below) without awarding credit.
5. Lock observations. Once locked, observations are immutable for that
   labeling pass.
6. Apply item-specific criteria (section 5 below) using only cited
   observation IDs from the locked set.
7. Record one criterion-level reason code (section 6 below) per decision.
8. Compare Validator A and Validator B only after both submissions are
   locked. Comparing earlier contaminates independence.
9. Send every disagreement to lead adjudication.
10. If adjudication reveals a rubric defect, invalidate the affected labels,
    issue a new `rubric_version`, and relabel every affected partition.

Model or algorithm output must stay hidden from human labelers until gold
labels are locked.

## 3. Capture-Quality Labeling (spec section 5)

Capture quality describes the **image**, not the student's graph quality. A
clear photo of a graph missing its axis labels is a capture `PASS` and a
later scoring observation — not a capture failure.

| Label | PASS means | FAIL means | UNCERTAIN means |
| --- | --- | --- | --- |
| `PAGE_COMPLETE` | The full response page is visible | Part of the page is missing from frame | Cannot tell if the page is complete |
| `GRAPH_REGION_COMPLETE` | The entire graph region is in frame | Graph is cut off | Cannot tell if anything is cut off |
| `FOCUS_LEGIBILITY` | Marks and text are sharp enough to read | Blur prevents reading required marks | Some marks readable, some not, and it's unclear which matter |
| `GLARE_OCCLUSION` | No glare or shadow obscures evidence | Glare/shadow covers point-bearing evidence | Glare is present but its effect on required evidence is unclear |
| `PERSPECTIVE_READABILITY` | Geometry is readable despite any skew | Perspective distortion makes axes/marks unreadable | Distortion present, severity unclear |
| `RESOLUTION_READABILITY` | Resolution is sufficient for required marks | Resolution is too low to read required marks | Resolution is borderline |
| `ORIENTATION_USABLE` | Image orientation can be corrected to readable | No correctable orientation makes it readable | Unclear without attempting correction |
| `INCIDENTAL_IDENTIFIER` | (uses `NONE`/`PRESENT`/`UNCERTAIN`, not PASS/FAIL) | — | — |

`INCIDENTAL_IDENTIFIER` values:

- `NONE`: no visible name, face, school marking, or unrelated surroundings.
- `PRESENT`: an incidental personal identifier is visible. Route per the
  approved privacy handling procedure before any further processing.
- `UNCERTAIN`: something might be an identifier (e.g. a partial name in the
  margin) but it isn't clearly readable either way.

`CAPTURE_DISPOSITION` decision rule:

- `ACCEPT`: every applicable label above is `PASS` (or `NONE` for the
  identifier field).
- `RETAKE`: at least one label is `FAIL`, **and** a new photograph could
  plausibly fix it (e.g. cutoff, blur, glare, bad angle). Name the specific
  fixable defect — do not issue a bare `RETAKE`.
- `HUMAN_REVIEW`: any label is `UNCERTAIN`, `INCIDENTAL_IDENTIFIER` is
  `PRESENT` or `UNCERTAIN`, or a `FAIL` exists that recapture cannot fix
  (e.g. the student's own marks are genuinely too faint on the original
  paper). `HUMAN_REVIEW` is also used per section 7.1 when the file fails
  technical validation, doesn't match the assigned response/item, or shows
  multiple competing final graphs with unclear intent.

## 4. Visual Observation Labeling (spec section 4.1)

Observations describe evidence. They never award credit. Each observation
needs a `feature_label` — an item-specific name for what you're observing
(e.g. `x_axis_unit_text`, `point_mark_t6h`). There is no fixed feature-label
vocabulary; it comes from each item's authoring package.

`state` values:

- `PRESENT`: the feature is visibly there as described.
- `ABSENT`: the feature is visibly missing — you can tell it's not there,
  not just that you can't see it.
- `AMBIGUOUS`: the feature might be there, but its identity or value can't
  be pinned down (e.g. two overlapping marks where it's unclear which is the
  intended data point).
- `NOT_VISIBLE`: the relevant region is not visible due to capture
  conditions (distinct from `ABSENT`, which is a positive observation that
  something was not drawn).
- `NOT_APPLICABLE`: the feature doesn't apply to this item or response
  variant at all (e.g. a legend feature on an item whose rubric never
  requires one).

`ABSENT` vs `NOT_VISIBLE` is the most common confusion point: if you can see
the space where a feature would be and it simply isn't drawn, that's
`ABSENT`. If you cannot see that space well enough to judge one way or the
other, that's `NOT_VISIBLE` — and any criterion relying on it must abstain
(section 7.2).

Fill `transcribed_text`, `numeric_value`, and `evidence_region` only when
they apply; otherwise leave them `null`. Leave `reviewer_note` for anything
a future adjudicator would need to understand your call.

## 5. Criterion Decision Labeling (spec sections 4.1-4.2)

Criterion decisions cite observation IDs — they do not re-examine the image.
If the evidence you need wasn't captured as an observation, go back to step
4, not forward to a decision.

`decision` values:

- `MET`: cited observations show the required evidence satisfies the
  criterion.
- `NOT_MET`: cited observations are sufficient to judge, and they show the
  criterion is not satisfied. A blank graph region is `NOT_MET`, not
  `ABSTAIN` — you have enough evidence (its absence) to decide.
- `ABSTAIN`: the evidence or the rubric itself is insufficient to decide
  safely. An unreadable crop is `ABSTAIN`, not `NOT_MET` — you don't know
  whether the requirement was met.
- `NOT_APPLICABLE`: this criterion does not apply to this item or accepted
  variant.

`criterion_label` is the shared taxonomy from spec section 4.2
(`REPRESENTATION_TYPE`, `X_VARIABLE`, `Y_VARIABLE`, `X_UNIT`, `Y_UNIT`,
`X_SCALE`, `Y_SCALE`, `CATEGORY_IDENTITY`, `PLOT_VALUES`,
`UNCERTAINTY_MARKS`, `POINT_CONNECTION`, `BEST_FIT_RELATIONSHIP`,
`ZERO_INTERCEPT_ANNOTATION`, `PLATEAU_ANNOTATION`, `ESTIMATE_VALUE`). It
lets the offline evaluation harness roll metrics up by criterion type across
all six items even though each item's `criterion_id` is its own instance
(e.g. `DRG-P1-01-UNCERTAINTY_MARKS` and `DRG-P1-03-UNCERTAINTY_MARKS` share
`criterion_label: UNCERTAINTY_MARKS` but are scored independently).

A response-level total is withheld whenever any point-bearing criterion
abstains (section 7.2) — do not backfill a guessed decision to avoid an
abstention.

## 6. Reason Codes (spec section 6.3)

Pick exactly one primary reason code per decision. When two codes seem to
fit, use the priority order below (top wins).

| Reason code | Use when | Illustrative example (generic, not a real item) |
| --- | --- | --- |
| `UNREADABLE_CAPTURE` | The image itself, not the rubric or the response, is the blocker | A real-but-blurred mark where you can tell something was drawn but not what |
| `CUTOFF_EVIDENCE` | The required region is outside the photographed frame | An axis label that runs off the edge of the captured image |
| `AMBIGUOUS_MARK` | A visual mark exists but its graphical meaning is genuinely unclear | Two overlapping points where it's unclear which is the intended value |
| `AMBIGUOUS_TEXT` | Handwritten text exists but cannot be read with confidence | A unit abbreviation that could be read two different ways |
| `UNSUPPORTED_REPRESENTATION` | The response uses a representation the phase-1 grammar doesn't cover | A response using a log axis when only linear axes are supported (spec section 2.2) |
| `RUBRIC_AMBIGUITY` | The rubric itself doesn't resolve what you're looking at, independent of image quality | An accepted-variant question the criterion definition doesn't address |
| `OUT_OF_DISTRIBUTION` | The response is readable and the rubric is clear, but the case falls outside what the rubric anticipated | A response style far outside the development-set range |
| `VISIBLE_CONTRADICTION` | Two pieces of visible evidence conflict with each other | A reported estimate that contradicts the plotted curve it cites |
| `VISIBLE_INCORRECT` | Evidence is fully visible and readable, and it's simply wrong | A clearly mislabeled axis unit |
| `VISIBLE_OMISSION` | Evidence is fully visible (i.e. you can confirm the region was captured), and the required element is absent | A clearly empty space where an uncertainty bar should be |
| `EVIDENCE_SATISFIES` | Cited observations affirmatively meet the criterion | Use for every `MET` decision |
| `NOT_REQUIRED` | The criterion does not apply to this item/variant | Use alongside `NOT_APPLICABLE` decisions |

Priority order when multiple codes could apply: capture-condition codes
(`UNREADABLE_CAPTURE`, `CUTOFF_EVIDENCE`) outrank content-ambiguity codes
(`AMBIGUOUS_MARK`, `AMBIGUOUS_TEXT`), which outrank rubric/grammar codes
(`UNSUPPORTED_REPRESENTATION`, `RUBRIC_AMBIGUITY`, `OUT_OF_DISTRIBUTION`),
which outrank content-judgment codes (`VISIBLE_CONTRADICTION`,
`VISIBLE_INCORRECT`, `VISIBLE_OMISSION`, `EVIDENCE_SATISFIES`,
`NOT_REQUIRED`). Rationale: if the image quality is the actual blocker, say
so first — it routes differently (possible retake) than a content judgment
does.

## 7. Abstention Quick Reference (spec sections 7.1-7.2)

**Capture-level** (produces `RETAKE` or `HUMAN_REVIEW`, not a criterion
decision at all): cutoff graph region; unreadable required marks/labels from
blur, glare, perspective, or resolution; failed file validation; incidental
identifier; mismatched response/item; multiple competing final graphs with
unclear intent; preprocessing that materially changed relevant evidence.

**Criterion-level** (produces `ABSTAIN` on that criterion only, other
criteria may still be decided): occluded/ambiguous/unrecoverable evidence
for that specific criterion; OCR/geometry disagreement beyond the
calibrated reconciliation rule; an unsupported-but-possibly-valid
representation; a rubric that doesn't resolve the observed variant; an
out-of-distribution response; confidence not yet mapped to an empirical
error band for that exact item-version/criterion/preprocessing/method
combination.

Never let one criterion's abstention bleed into another decidable
criterion's outcome — abstain narrowly.

## 8. Capture Variants (spec section 6.4)

A single underlying response may have multiple photographs and derived
images (at minimum: immutable original, lossless orientation/crop, and a
document-normalized derivative — section 6.4 and `TASK-0011_PHASE_1
_EXECUTION_SPEC.md` section 8.2). All variants stay in the same corpus
partition as their underlying response. The primary scoring image is the
one named by the item's predeclared selection rule — never the variant that
happens to produce the best result for a given method. Task-specific
enhancement variants are a separate experimental arm; check them for erased
pencil marks, thinned error bars, dashed marks, or lost labels before
treating them as equivalent to the original.

## 9. Version History

| Version | Date | Change |
| --- | --- | --- |
| `v0.1` | 2026-06-18 | Initial handbook, operationalizing spec sections 4-7. No labeling has occurred under this version. |

Any future version that changes a labeling rule (not just clarifies wording)
must trigger the relabel requirement in section 6.2 step 10 for any
partition already labeled under the prior version.
