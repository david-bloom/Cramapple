# AP Stats HDR Criterion Audit

Date: 2026-07-07

Scope:
- 12 AP Stats hand-drawn HDR items
- Arms reviewed: `VISION_FAST`, `VISION_ACCURACY`, `VISION_FAST_ESC`
- Gold contract: `REPRESENTATION`, `LABELING`, `GEOMETRY`, `COMPLETENESS`

## Executive Summary

The first benchmark round splits into two clear classes:

1. **Image-analysis misses**
   - The model misidentified the graph family or failed to detect the intended structure.
   - These are concentrated on items `004`, `005`, `006`, `008`, `009`, `011`, and parts of `012`.
   - In these cases, the rubric is probably not the main problem.

2. **Rubric-ambiguity / threshold misses**
   - The model and gold disagree on whether the drawing is "good enough" even when the intended graph family is visible.
   - These are concentrated on `GEOMETRY`, plus a smaller set of `LABELING` and `COMPLETENESS` decisions.
   - The main ambiguity is how much hand-drawn imprecision is still acceptable.

The biggest contract risk is not the graph family itself. It is the boundary between:
- acceptable approximation vs. geometry failure
- legible handwritten labels vs. insufficient labeling
- structural completeness vs. missing explanatory detail

## Criterion-Level Readout

### 1) Representation

Observed pattern:
- `VISION_FAST` got `5/12` exact.
- The misses were all on items where the model appears to have read the wrong graph type entirely.

Likely classification:
- Mostly **image-analysis miss**.
- The model is failing to recognize the intended display, not applying a fuzzy rubric boundary.

Items to treat as image-analysis misses:
- `APSTATS-HDG-2026-HDR-004`
- `APSTATS-HDG-2026-HDR-005`
- `APSTATS-HDG-2026-HDR-006`
- `APSTATS-HDG-2026-HDR-008`
- `APSTATS-HDG-2026-HDR-009`
- `APSTATS-HDG-2026-HDR-011`
- `APSTATS-HDG-2026-HDR-012`

### 2) Labeling

Observed pattern:
- `VISION_FAST` got `5/12` exact.
- `VISION_FAST_ESC` disagreed with `VISION_FAST` on `HDR-007` and `HDR-012`.
- The disagreement clusters around handwritten boxplot labels.

Likely classification:
- Mostly **image-analysis miss** on the gross failures.
- **Possible rubric ambiguity** on handwritten label sufficiency for the boxplot items.

Likely rubric-boundary items:
- `APSTATS-HDG-2026-HDR-007`
- `APSTATS-HDG-2026-HDR-012`

### 3) Geometry

Observed pattern:
- This is the noisiest criterion.
- Gold already marks geometry as `unable_to_determine` on most segmented-bar and boxplot items.
- The two stable arms also split on `HDR-010`.

Likely classification:
- **Rubric ambiguity** is the dominant issue.

Ambiguous geometry items:
- `APSTATS-HDG-2026-HDR-004`
- `APSTATS-HDG-2026-HDR-005`
- `APSTATS-HDG-2026-HDR-006`
- `APSTATS-HDG-2026-HDR-007`
- `APSTATS-HDG-2026-HDR-010`
- `APSTATS-HDG-2026-HDR-012`

What is ambiguous:
- How straight the partition lines must be in segmented bars
- How exact the quartiles and whiskers must be in boxplots
- When a slightly imperfect hand-drawn structure should still count as "earned"

### 4) Completeness

Observed pattern:
- The model is inconsistent on whether "completeness" means structural coverage or fully polished explanation.
- `VISION_FAST_ESC` disagreed with `VISION_FAST` on `HDR-003`.
- Both arms tended to reject items where the graph family was wrong, which suggests the criterion is being overloaded.

Likely classification:
- Mix of **rubric ambiguity** and **image-analysis miss**.
- The rubric needs to say that completeness is structural, not rhetorical.

Likely rubric-boundary items:
- `APSTATS-HDG-2026-HDR-003`
- `APSTATS-HDG-2026-HDR-007`
- `APSTATS-HDG-2026-HDR-010`

## Item-Level Notes

### Cleanly readable items

- `HDR-001`
- `HDR-002`
- `HDR-003`

These are good exemplars. They should stay in the benchmark as anchor items.

### Clear image-analysis misses

- `HDR-004`
- `HDR-005`
- `HDR-006`
- `HDR-008`
- `HDR-009`
- `HDR-011`
- `HDR-012`

The model mostly read the wrong graph family here, so rubric tightening alone will not fix these.

### Borderline rubric cases

- `HDR-003` completeness
- `HDR-007` labeling and completeness
- `HDR-010` geometry and completeness
- `HDR-012` labeling

These are the best candidates for contract clarification before the next round.

## Recommended Contract Tightening

1. **Make geometry rules explicit by archetype**
   - For segmented bars, require the full set of partitions and a consistent axis, but allow hand-drawn wobble.
   - For boxplots, require the five-number structure to be recognizable, not perfectly scaled.
   - For curve annotations, require the curve shape plus the marked point when the prompt asks for it.

2. **Separate labeling from legibility**
   - Count handwritten axis titles and category labels as sufficient if the intended text is recoverable.
   - Do not require perfect typography or every tick label unless the prompt explicitly asks for them.

3. **Define completeness as structural coverage**
   - Completeness should mean all requested components are present.
   - It should not require prose explanation, numeric perfection, or polished presentation.

4. **Reserve `unable_to_determine` for real visual uncertainty**
   - Use it only when the key structure cannot be recovered from the image.
   - Do not use it for ordinary hand-drawn wobble or small handwriting imperfections.

## Bottom Line

The next benchmark round should not start with broader model changes.
It should start with a tighter rubric, especially for:
- `GEOMETRY`
- `COMPLETENESS`
- handwritten `LABELING` on boxplot-style items

That will make the next results much easier to interpret.
