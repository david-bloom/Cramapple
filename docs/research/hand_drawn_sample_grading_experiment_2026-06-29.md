# Hand-Drawn Sample Grading Experiment - 2026-06-29

**Status:** Preliminary local evaluation; not production-validation evidence  
**Corpus:** `Hand Drawn Samples`  
**Evaluator:** Codex local visual pass in this workspace  
**External model API arm:** Not run. Uploading the private image corpus to an external API was blocked pending explicit approval for that data transfer.

## Purpose

Run a quick production-readiness experiment on the newly added hand-drawn graph
sample corpus, using the visible page labels as provisional gold labels.

This pass measures coarse classification only:

- `full`
- `partial`
- `ungradeable`

It does not measure exact numeric plotting tolerance because the folder does
not include a machine-readable item manifest, source data tables, expected
graph coordinates, or adjudicated criterion labels.

## Corpus Preparation

- Converted 22 HEIC files and 1 JPG to JPEG derivatives under `/private/tmp/cramapple-drawn-samples/images`.
- Created cropped grading derivatives under `/private/tmp/cramapple-drawn-samples/cropped_for_grading`.
- Created contact sheets:
  - `/private/tmp/cramapple-drawn-samples/contact_sheet.jpg`
  - `/private/tmp/cramapple-drawn-samples/cropped_contact_sheet.jpg`
  - `/private/tmp/cramapple-drawn-samples/header_sheet.jpg`

`IMG_6915` is not a graph response. It appears to be an accidental capture of a device label and was treated as an `ungradeable` control.

## Aggregate Result

| Metric | Result |
| --- | ---: |
| Total files | 23 |
| Graph response files | 22 |
| Unrelated/ungradeable controls | 1 |
| Agreement including all files | 20 / 23 = 87.0% |
| Agreement on graph files only | 19 / 22 = 86.4% |
| Agreement excluding two likely corpus/capture anomalies | 20 / 21 = 95.2% |

## Per-File Results

| File | Provisional gold | Local prediction | Result | Note |
| --- | --- | --- | --- | --- |
| `IMG_6912` | full | full | pass | Clear categorical graph with labels, scale, points, and error bars. |
| `IMG_6913` | partial | partial | pass | Categorical axes present; graph evidence incomplete. |
| `IMG_6914` | full | full | pass | Categorical response appears complete. |
| `IMG_6915` | ungradeable | ungradeable | pass | Accidental non-response image. |
| `IMG_6916` | full | partial | miss | Visible image shows axes but essentially no plotted data; likely label/capture mismatch. |
| `IMG_6917` | partial | partial | pass | Relationship graph present but incomplete. |
| `IMG_6918` | partial | partial | pass | Relationship graph lacks enough estimate/annotation evidence. |
| `IMG_6919` | full | full | pass | Clear zero-intercept estimate and trend. |
| `IMG_6920` | partial | full | miss | Looks superficially complete; likely hidden rubric issue not recoverable without item manifest. |
| `IMG_6921` | full | full | pass | Continuous graph appears complete. |
| `IMG_6922` | partial | partial | pass | Continuous graph appears incomplete relative to expected criteria. |
| `IMG_6923` | full | full | pass | Continuous graph appears complete. |
| `IMG_6924` | partial | partial | pass | Nonmonotonic graph present but incomplete. |
| `IMG_6925` | full | partial | miss | Cropped/blurred capture loses key axis evidence; likely capture artifact or label mismatch. |
| `IMG_6926` | partial | partial | pass | Nonmonotonic graph incomplete. |
| `IMG_6927` | full | full | pass | Nonmonotonic graph appears complete. |
| `IMG_6928` | partial | partial | pass | Categorical graph missing important uncertainty/label evidence. |
| `IMG_6929` | full | full | pass | Categorical graph appears complete. |
| `IMG_6930` | partial | partial | pass | Categorical graph incomplete. |
| `IMG_6931` | full | full | pass | Categorical graph appears complete. |
| `IMG_6932` | partial | partial | pass | Categorical graph incomplete. |
| `IMG_6933` | partial | partial | pass | Categorical graph incomplete. |
| `IMG_6934` | full | full | pass | Categorical graph appears complete. |

## Findings

1. Coarse full/partial recognition is promising on clean categorical and obvious missing-feature cases.
2. Continuous graph items are the production risk. A graph can look complete while still failing an item-specific criterion that is invisible without the expected data table and accepted variants.
3. The current folder is useful for smoke testing, but it is not yet an evaluation harness. It needs a manifest with item IDs, gold criterion labels, expected graph specs, and source data.
4. Capture quality and grading quality are currently entangled. `IMG_6916` and `IMG_6925` should be reviewed before they are used as gold cases.
5. External multimodal model grading should not be run on this corpus until the Product Owner explicitly approves provider submission, retention/training boundaries, and deletion expectations.

## Production-Readiness Implication

This corpus supports continued research, but it does not yet justify learner-facing automated grading of hand-drawn graphs.

Minimum next step before another model bake-off:

1. Add a `manifest.json` or CSV for every image.
2. Store the item prompt, source table, expected graph spec, and criterion-level gold labels separately from the images.
3. Mark capture-quality labels before grading labels.
4. Remove or quarantine `IMG_6916`, `IMG_6915`, and possibly `IMG_6925` from scoring metrics until reviewed.
5. Run at least two arms once external provider use is approved: direct multimodal grading, and observation-first followed by criterion grading.
