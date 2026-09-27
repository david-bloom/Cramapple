# Biology and Statistics Topic Tagging + FRQ Canonical Review

Date: 2026-09-22
Mode: proposal only. No Production content, labels, answers, or serving contracts were modified.

## Scope and filters

Published set re-run against Production project `pcntajvbdfqhbeewmdry` using latest published version per `content_item_id`: `public.content_item_versions.status = 'published'`, `subject_key IN ('biology','ap-statistics')`, and `item_type IN ('mcq','frq')`. Counts: AP Biology 43 MCQ / 75 FRQ (118 total); AP Statistics 304 MCQ / 80 FRQ (384 total). The live counts match the work order.

Closed list verified from `app.taxonomy_topics`: Biology 60 topics across units 1-8, source `c676d1fc-3b58-4896-89e3-852d9bd1f81b`; AP Statistics 55 topics across units 1-5, source `dae3c72e-82ca-4960-9552-1b034bd347e5`.

## Task 0 inventory

| Subject | Type | Items | Topic labels | Canonical answer 1 | Prior model run | Author prose | Criteria |
|---|---:|---:|---:|---:|---:|---:|---:|
| ap-statistics | frq | 80 | 0 | 34 | 54 | 34 | 362 |
| ap-statistics | mcq | 304 | 0 | na | 101 | 101 | na |
| biology | frq | 75 | 0 | 68 | 32 | 20 | 278 |
| biology | mcq | 43 | 0 | na | 43 | 43 | na |

Inventory notes: topic-label counts use `app.content_taxonomy_labels.label_scope='coverage'` with a non-empty `assessed_topics`; prior-run counts use any label row with non-null `source_payload`; canonical counts use non-blank `canonical_answer_1`; author prose uses non-blank `prompt_json->>'subtopics'`; criteria counts count `public/app.frq_criteria` rows attached to the latest published version. Historical label rows were deduplicated by content item for the inventory.

## Task A topic proposal

All 502 in-scope items are included because the inventory found no existing coverage label. Topic codes were selected only from the verified closed lists. Confidence: high 0, medium 144, low 358. Rows routed to `needs_human=true`: 372. Author-prose agreement: 113 yes among items with prose; explainer agreement: 0 yes where explainer data was available.

This pass is conservative in the sense that low-confidence and signal-conflict rows are explicitly routed to humans. Because the model-side explainer table returned 0 rows for the queried subject keys, explainer agreement is recorded as `na` where unavailable and should be re-run against the authoritative explainer source during QA.

## Task B FRQ canonical review

| Subject | FRQ | Existing canonical answer 1 | Missing/draft proposals | Existing-answer rubric mismatches flagged |
|---|---:|---:|---:|---:|
| biology | 75 | 68 | 7 | 4 |
| ap-statistics | 80 | 34 | 46 | 0 |

Existing canonical answers were never redrafted. Missing answers are labeled as draft proposals for human approval. Structured parts are reported from `prompt_json->'parts'`; prose-only multi-part items are noted in the flags column.

## Disagreements and governance

The live published counts match the order. The live prior-model-run rows are historical and exceed the order's expected 155 Statistics / 75 Biology when counted across all item types; this summary uses distinct in-scope items with non-null `source_payload`, not raw label-row counts. Nothing in these files is validated. Human review and the required double-approve governance step remain outstanding.

