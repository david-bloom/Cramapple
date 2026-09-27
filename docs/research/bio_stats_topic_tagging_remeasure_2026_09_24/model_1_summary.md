# Model 1 Topic Labels — Corrected Explainer Lookup

## Scope and retrieval verification

This is a model-1 remeasurement artifact only; it makes no Production changes. The live scope is the latest published version per `content_item_id`, filtered to `status = 'published'`, `subject_key IN ('biology','ap-statistics')`, and `item_type IN ('mcq','frq')`: 502 rows.

| Subject | MCQ | FRQ |
|---|---:|---:|
| biology | 43 | 75 |
| ap-statistics | 304 | 80 |

The corrected key normalization (remove a leading `ap-`, replace hyphens with underscores, then prepend `ap_` when absent) retrieved 60/60 Biology explainers from `ap_biology` and 55/55 Statistics explainers from `ap_statistics`. Every emitted non-null topic therefore has an available explainer.

## Counts

| Subject | Rows | High | Medium | Low | Needs human | Explainer available |
|---|---:|---:|---:|---:|---:|---:|
| biology | 118 | 0 | 51 | 67 | 68 | 118 |
| ap-statistics | 384 | 0 | 128 | 256 | 269 | 384 |

The closed lists used were Biology taxonomy source `c676d1fc-3b58-4896-89e3-852d9bd1f81b` (60 topics) and Statistics taxonomy source `dae3c72e-82ca-4960-9552-1b034bd347e5` (55 topics). `agreement_with_explainer_retrieval` records whether the grounded explainer resolves the item-level pick; it is not a two-model agreement measurement.

## Statistics systematic-pattern check

Relative to the prior QA classes, this model corrects 5 regression wrong-unit cases to 5.3, 20 two-group quantitative-comparison cases to 1.9, and 11 sampling-method cases to 1.11. The 20 boilerplate graph-submission items remain low-confidence and `needs_human=true` because explainers cannot reconstruct missing item evidence. Thus the lookup repair grounds retrieval for all Statistics topics, but it does not by itself resolve the uninformative-stem template class.

For Biology, 2 osmosis/water-potential cases were corrected to 2.7; Biology graph-submission rows likewise remain human-routed where the stem is boilerplate.
