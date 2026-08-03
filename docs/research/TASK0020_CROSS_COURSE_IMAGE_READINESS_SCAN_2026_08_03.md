# TASK-0020 Cross-Course Image Readiness Scan

**Status:** Draft
**Date:** 2026-08-03
**Evidence Class:** Live verified for aggregate Production metadata; candidate classifications remain mechanical and unreviewed
**Production Project:** `pcntajvbdfqhbeewmdry`

## Purpose

Complete V5 Step 1's cheap cross-course scan before selecting the deep launch-critical slice. This scan identifies exposure; it does not decide which candidates truly require a displayed visual or drawn response.

## Method

- Read-only SQL against current Production metadata.
- One latest compatibility version per `content_item_id`, selected by descending `version_num` and `created_at`.
- Published counts require both `content_items.status = 'published'` and latest `content_item_versions.status = 'published'`.
- Candidate flags use image paths, structured prompt keys, visual-language terms, explicit hand-drawn/capture keys, content-key patterns, and graph-construction language.
- Storage checks compare latest `stimulus_image_path` references with private `content-assets` object metadata. No object content or signed URLs were read.
- Reproducible queries: `scripts/image_readiness/cross_course_scan.sql`.

## Aggregate result

| Metric | Count |
| --- | ---: |
| Latest compatibility items | 1,412 |
| Published item + latest-version pairs | 288 |
| Published prompt-visual candidates | 111 |
| Published drawn-response candidates | 38 |
| Published candidates flagged in both groups | 38 |
| Published possible missing-visual or missing-context candidates | 36 |
| Latest items with `stimulus_image_path`, any status | 10 |
| Published latest items with `stimulus_image_path` | 1 |

All 38 drawn-response candidates also carry a prompt-visual candidate signal because the explicit hand-drawn packages contain structured graph specifications. This is an overlap in program exposure, not proof that all 38 require a separate question image.

## Course-level result

| Course | Latest items | Published latest | Published image paths | Structured visual markers | Visual-language candidates | Drawn-response candidates | Possible missing visual/context |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| AP Biology | 254 | 97 | 1 | 5 | 31 | 5 | 25 |
| AP Calculus AB | 106 | 4 | 0 | 4 | 0 | 0 | 0 |
| AP Calculus BC | 106 | 2 | 0 | 2 | 0 | 0 | 0 |
| AP Chemistry | 136 | 31 | 0 | 0 | 2 | 0 | 2 |
| AP Physics 1 | 108 | 19 | 0 | 0 | 2 | 0 | 2 |
| AP Physics 2 | 100 | 16 | 0 | 0 | 2 | 0 | 2 |
| AP Physics C: E&M | 100 | 8 | 0 | 0 | 1 | 0 | 1 |
| AP Physics C: Mechanics | 100 | 10 | 0 | 0 | 2 | 1 | 2 |
| AP Precalculus | 106 | 31 | 0 | 31 | 4 | 0 | 0 |
| AP Statistics | 296 | 70 | 0 | 32 | 34 | 32 | 2 |

The columns are independent flags and must not be summed.

## Serving-format signal

- AP Statistics has 48 published targeted-drill FRQs; 32 carry explicit `hand_drawn`, `capture_instruction`, and `expected_graph_spec` markers.
- AP Biology has 41 published FRQs, including 31 prompt-visual candidates and five explicit drawn-response packages, but all 41 have `practice_format IS NULL`; the known strict FRQ selector therefore does not currently select them as targeted drills or full-exam FRQs.
- Published targeted-drill FRQ prompt-visual candidates also appear in Physics 1 (1), Physics 2 (2), Physics C: E&M (1), and Physics C: Mechanics (2).
- The AP Physics C: Mechanics text heuristic added one drawn candidate without explicit capture metadata; it requires manual classification and may be a false positive.

## Storage metadata signal

- `content-assets` is private and contains 11 objects.
- All 10 distinct latest-version image-path references were found in `content-assets`.
- Only one of those references belongs to a currently published item/latest-version pair.
- `learner-uploads` is private and contains zero objects.

Object existence does not establish student delivery, accessibility, rights, approval, or rendering readiness.

## Immediate interpretation

1. The problem is systemic enough to justify the cross-course scan: every major science course has at least one published possible missing-visual/context candidate, and AP Biology has 25.
2. Drawn-response launch exposure is concentrated in AP Statistics: 32 explicitly marked, published targeted-drill items.
3. Prompt-visual exposure is largest in AP Biology: 31 published FRQ candidates, including the only published latest-version image path and 25 possible missing/context candidates.
4. Structured markers dominate Calculus, Precalculus, and the drawn-response packages. A stored-raster count would materially understate the visual surface.
5. The zero-object `learner-uploads` bucket and text/parts-only response schema remain consistent with “capture not operationally demonstrated,” but this scan alone is not an end-to-end capability verdict.

## Recommended deep launch slice

To satisfy the Product Owner's requirement that both prompt-image issues and hand-drawn response issues reach execution, use a bounded dual slice:

- all 48 published AP Statistics targeted-drill FRQs; and
- all 41 published AP Biology FRQs.

This 89-item slice contains the 32 operationally concentrated drawn-response items and the 31 largest prompt-visual candidates without requiring immediate semantic classification of all 1,412 items.

## Decisions required before Step 2

1. **Launch slice:** approve, revise, or reject the recommended 89-item AP Statistics + AP Biology dual slice.
2. **Minimum viable content volume:** lock the minimum surviving item/archetype counts for each course before delivery findings are reviewed.
3. **Essential-visual failure behavior:** recommended baseline is fail closed—skip and replace only with an already approved item or construct-equivalent alternate.
4. **Grading/repair launch path:** recommended baseline is manual review; automation remains shadow-only until its evidence bars pass.
5. **Supported-device materiality rule:** define whether every officially supported answering-device class must have a viable paper-photo path, or set another measurable threshold before Step 3.

## Product Owner disposition

`APPROVAL-0042` approved the recommended 89-item dual slice and locked the following baselines:

- no scope narrowing to manufacture readiness;
- fail-closed essential visuals with replacement only by an already approved construct-equivalent item or representation;
- manual review as the launch baseline, with automation shadow-only until independently qualified; and
- a viable paper-photo capture route for every officially supported answering-device class.

Learning Quality validation remains required for construct-sensitive classification and equivalence judgments.

## Limitations

- Mechanical flags intentionally overcapture and undercapture; manual classification has not begun.
- `stimuli` and `expected_graph_spec` keys do not prove a displayed question visual.
- Visual-language matches can refer to a learner-created answer, a text-described relationship, or missing prior context.
- Published status does not by itself prove end-to-end servability.
- No student UI, browser, signed URL, capture, grading, or later-review flow was exercised in this scan.
