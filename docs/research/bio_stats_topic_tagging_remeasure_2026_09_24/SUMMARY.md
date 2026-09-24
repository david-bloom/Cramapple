# Biology and Statistics Topic-Tagging Remeasurement

Date: 2026-09-24  
Mode: measurement/proposal only. No Production content, labels, assessed topics, or label statuses were changed.

## Outcome

The subject-key bug is real and the normalized lookup fixes explainer retrieval:

| Subject | Content key | Normalized explainer key | Closed-list topics | Explainers retrieved |
| --- | --- | --- | ---: | ---: |
| AP Biology | `biology` | `ap_biology` | 60 | 60 |
| AP Statistics | `ap-statistics` | `ap_statistics` | 55 | 55 |

However, the remeasurement does **not** improve the two-model topic-agreement evidence. The measured
agreement in this packet is **145/502 = 28.9%**, below the original 44% figure cited in
DECISION-0062/0067. By subject:

| Subject | Items | Agreements | Agreement rate |
| --- | ---: | ---: | ---: |
| AP Biology | 118 | 43 | 36.4% |
| AP Statistics | 384 | 102 | 26.6% |
| Combined | 502 | 145 | 28.9% |

Important caveat: model 1 disclosed that its row-level pass used the historical proposal plus the
corrected explainer availability and targeted QA repairs, not a fully fresh first-principles
independent 502-item classification. Treat this packet as a constrained remeasurement/repair signal,
not as clean evidence strong enough to revisit DECISION-0067.

## Scope And Filters

Live Production project `pcntajvbdfqhbeewmdry`, read-only:

`public.content_item_versions.status = 'published'`, latest published version per
`content_item_id`, `public.content_items.subject_key IN ('biology','ap-statistics')`,
`item_type IN ('mcq','frq')`.

Counts match the original run: Biology 43 MCQ / 75 FRQ, Statistics 304 MCQ / 80 FRQ.

## Inventory

| Subject | Type | Items | Coverage labels now present | Canonical answer 1 | Prior model run | Author prose | Criteria |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| ap-statistics | frq | 80 | 34 | 34 | 54 | 34 | 362 |
| ap-statistics | mcq | 304 | 101 | 0 | 101 | 101 | 0 |
| biology | frq | 75 | 75 | 70 | 75 | 20 | 278 |
| biology | mcq | 43 | 43 | 3 | 43 | 43 | 0 |

This differs from the historical 2026-09-22 inventory because Biology coverage rows now exist
(`112 provisional_model`, `6 held`, plus older legacy rows) and two additional Biology FRQ canonical
answers are now present. This work does not promote or replace any of those rows.

## Agreement Detail

| Subject / Type | Items | Agreements | Agreement rate |
| --- | ---: | ---: | ---: |
| Biology FRQ | 75 | 26 | 34.7% |
| Biology MCQ | 43 | 17 | 39.5% |
| Statistics FRQ | 80 | 18 | 22.5% |
| Statistics MCQ | 304 | 84 | 27.6% |

The aggregated `topic_labels_proposal.csv` emits an agreed primary topic only where both model files
selected the same topic code. Disagreement rows have blank primary topic fields, `needs_human=true`,
and retain both model choices in `model_1_primary_topic_code` and `model_2_primary_topic_code`.

## Prior QA Pattern Check

Against `docs/research/bio_stats_topic_tagging_2026_09_22/qa_findings.csv`:

| Prior issue class | Rows checked | Result |
| --- | ---: | --- |
| `topic_off_by_one` | 20 | Both models agree on `1.9`; this prior error class appears fixed. |
| `sampling_method_vs_distribution` | 11 | Both models agree on `1.11`; this prior error class appears fixed. |
| `wrong_unit` | 5 | Both models move to Unit 5, but disagree inside Unit 5 (`5.3` vs `5.2`/`5.5`); still needs review. |
| `uninformative_stem` | 24 | Both models route all rows to human; explainer grounding cannot recover missing stimulus/rubric evidence. |
| Biology `topic_misassigned` | 2 | One row agrees on `2.7`; one row remains split (`2.7` vs `2.6`). |

So grounding helps some known Statistics template errors, but not enough to turn the overall task
into a reliable automated lane.

## Other-Subject Scope Check

A live subject-key scan showed the raw `content_items.subject_key` lookup returns zero explainer
rows for every current content subject, while normalized keys return non-zero explainers for all ten
subjects. That means this namespace bug is not intrinsically Biology/Statistics-only; it would affect
any prior topic-labeling run that queried `app.topic_explainers` with raw content subject keys.
This packet does not expand scope beyond Biology and Statistics.

## Files

- `model_1_topic_labels.csv`, `model_1_summary.md` — model 1 classification/repair pass.
- `model_2_topic_labels.csv`, `model_2_summary.md` — model 2 classification pass.
- `topic_labels_proposal.csv` — aggregated two-model measurement; agreed topics only.
- `inventory.csv` — current live inventory summary at row level.
- `packet.jsonl` — per-item packet containing both model outputs and the agreement flag.
- `aggregate_remeasurement.py` — deterministic aggregation script.
- `run_metadata.json` — agreement counts and methodological caveat.

## Bottom Line

The fixed explainer lookup is necessary, but it is not sufficient. The measured agreement is not
meaningfully better than 44%; in this constrained packet it is materially worse. DECISION-0067
should stand unless a later clean, fully independent re-run produces stronger evidence.
