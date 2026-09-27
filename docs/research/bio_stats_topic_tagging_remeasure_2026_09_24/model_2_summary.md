# Model 2 Topic-Label Remeasurement

Date: 2026-09-24  
Mode: proposal/measurement only. No Production labels, assessed topics, or label statuses were changed.

## Scope and read-only verification

Latest published versions were selected with `status='published'`, `subject_key IN ('biology','ap-statistics')`, and `item_type IN ('mcq','frq')`, one row per `content_item_id` (highest published `version_num`). The live set is **118 Biology items (43 MCQ / 75 FRQ)** and **384 Statistics items (304 MCQ / 80 FRQ)**, **502 total**.

The subject-key bug was verified before classification. A direct lookup using content keys `biology` and `ap-statistics` returned 0 explainer rows. Normalizing with “strip leading `ap-`, replace `-` with `_`, prepend `ap_`” maps Biology to `ap_biology` and Statistics to `ap_statistics`; the normalized lookup returned **60 Biology** and **55 Statistics** explainer rows. The taxonomy closed lists contain the same **60 / 55** topic counts, and all 502 selected primary topics have an available normalized explainer.

The requested `apphy2-frq-006-style` scope check found no currently published `content_key LIKE 'apphy2-frq-006%'` rows in this database snapshot, so there was no other prior labeling run to remeasure in this packet.

## Model 2 method

This independent pass scores each item’s stem, stimulus, prompt JSON, choices, criteria, and explanation against the closed-list topic title plus normalized explainer fields (`core_idea`, `what_students_need_to_understand`, `how_this_becomes_points`, mini example, point-attaining answer, and common point loss). Author `subtopics` prose is scored separately for the agreement signal. Generator-family cues were used only for the already documented Statistics diagnostic families (compare-distributions, sampling-method, and LSRL); no label is written back to Production. Low-confidence, signal-conflict, and boilerplate graph items are routed to `needs_human=true`.

## Model 2 counts

| Subject | Items | High | Medium | Low | Needs human | Author yes/no/na | Explainer yes/no/na |
|---|---:|---:|---:|---:|---:|---|---|
| Biology | 118 | 97 | 12 | 9 | 34 | 33/30/55 | 118/0/0 |
| AP Statistics | 384 | 300 | 24 | 60 | 108 | 58/77/249 | 369/15/0 |

This file is model 2 only; two-model agreement is intentionally left to the final aggregation step.

## Statistics systematic-class check

The prior QA file records four Statistics classes: 20 `uninformative_stem`, 20 `topic_off_by_one`, 11 `sampling_method_vs_distribution`, and 5 `wrong_unit`.

| Prior class | Remeasurement diagnostic | Interpretation |
|---|---|---|
| `uninformative_stem` (20) | 20 HDG graph items; 20 routed to human | Persists as a data-quality/grounding limitation; explainer text cannot recover missing stimulus. |
| `topic_off_by_one` (20) | 20 prior `compare_stats` items and 20 `4b-compare` items; 40/40 labeled 1.9 | The prior 1.7-vs-1.9 error is not reproduced in model 2 for these families. |
| `sampling_method_vs_distribution` (11) | 20 `sampling-101` items; 20/20 labeled 1.11/1.12 | The method-vs-distribution confusion is resolved for the identified family, subject to human review. |
| `wrong_unit` (5) | 5 prior wrong-unit keys; 5/5 labeled in Unit 5 | The Unit-5 regression signal is recovered for the prior key set. |

No final promotion or aggregation is implied by this model-2 packet.
