# AP Statistics Taxonomy Serving Label Run - 2026-08-05

Run ID: `math-serving-units-2026-08-04-20260805004703`

Production project: `pcntajvbdfqhbeewmdry`

Scope: AP Statistics published latest items only. This run wrote serving labels
only (`required_units`, `primary_unit`, derived `max_required_unit`). Topic
coverage (`assessed_topics`) was deferred and remains empty for this run.

Fact pack: `docs/product/AP_STATISTICS_2027_CED_FACT_PACK.md`. The local file
was verified byte-for-byte against GitHub commit
`e902db0e4607a0f91ddcca53b3b9593bc461de50`; SHA-256
`198c67f199f871e24c03a8b83a5268ff9c5f2690454636ca652fb6c16a899703`.

Models: `openai/gpt-5.5` and `google/gemini-2.5-flash` through Vercel AI
Gateway.

Validation rule: no `validated` labels were written. Two-model agreement writes
`provisional_model`; model disagreement, empty unit output, rubric preflight
failure, or model/schema irregularity writes `held`.

Stats-specific lane: confirm-or-correct against the active legacy serving label
when a usable legacy unit set exists. The legacy label is treated as a candidate,
not ground truth; corrections are made against the 2026-27 five-unit AP
Statistics fact pack. Items with no usable legacy unit set are cold-labeled from
the same fact pack.

## Summary

| Subject | Target items | Provisional model | Held |
| --- | ---: | ---: | ---: |
| AP Statistics | 70 | 60 | 10 |

Live Production census after write:

| Label census | Count |
| --- | ---: |
| Active serving labels on published Stats targets | 70 |
| Two-model agreed unit labels | 60 |
| Topic labels written | 0 |
| Validated labels written | 0 |

## Outcome Reasons

- two_model_unit_agreement_no_usable_legacy: 29
- two_model_corrected_legacy_unit: 25
- model_unit_disagreement: 9
- two_model_confirmed_legacy_unit: 6
- other: 1

## Item Outcomes

| Subject | Content key | Status | Reason | Required units |
| --- | --- | --- | --- | --- |
| ap_statistics | APSTAT-MOD6-M001 | provisional_model | two_model_unit_agreement_no_usable_legacy | 1, 3 |
| ap_statistics | APSTATS-HDG-2026-GRAPH-001 | provisional_model | two_model_unit_agreement_no_usable_legacy | 1 |
| ap_statistics | APSTATS-HDG-2026-GRAPH-002 | provisional_model | two_model_unit_agreement_no_usable_legacy | 2 |
| ap_statistics | APSTATS-HDG-2026-GRAPH-003 | held | model_unit_disagreement | - |
| ap_statistics | APSTATS-HDG-2026-GRAPH-004 | provisional_model | two_model_unit_agreement_no_usable_legacy | 1 |
| ap_statistics | APSTATS-HDG-2026-GRAPH-007 | provisional_model | two_model_unit_agreement_no_usable_legacy | 1 |
| ap_statistics | APSTATS-HDG-2026-GRAPH-008 | provisional_model | two_model_unit_agreement_no_usable_legacy | 2 |
| ap_statistics | APSTATS-HDG-2026-GRAPH-010 | provisional_model | two_model_unit_agreement_no_usable_legacy | 1 |
| ap_statistics | APSTATS-HDG-2026-GRAPH-011 | provisional_model | two_model_unit_agreement_no_usable_legacy | 5 |
| ap_statistics | APSTATS-HDG-2026-GRAPH-013 | provisional_model | two_model_unit_agreement_no_usable_legacy | 1 |
| ap_statistics | APSTATS-HDG-2026-GRAPH-014 | provisional_model | two_model_unit_agreement_no_usable_legacy | 1 |
| ap_statistics | APSTATS-HDG-2026-GRAPH-015 | provisional_model | two_model_unit_agreement_no_usable_legacy | 1 |
| ap_statistics | APSTATS-HDG-2026-GRAPH-016 | provisional_model | two_model_unit_agreement_no_usable_legacy | 1 |
| ap_statistics | APSTATS-HDG-2026-GRAPH-017 | provisional_model | two_model_unit_agreement_no_usable_legacy | 1 |
| ap_statistics | APSTATS-HDG-2026-GRAPH-018 | provisional_model | two_model_unit_agreement_no_usable_legacy | 2 |
| ap_statistics | APSTATS-HDG-2026-GRAPH-019 | provisional_model | two_model_unit_agreement_no_usable_legacy | 2 |
| ap_statistics | APSTATS-HDG-2026-GRAPH-020 | held | model_unit_disagreement | - |
| ap_statistics | APSTATS-HDG-2026-GRAPH-021 | provisional_model | two_model_unit_agreement_no_usable_legacy | 2 |
| ap_statistics | APSTATS-HDG-2026-GRAPH-022 | held | model_unit_disagreement | - |
| ap_statistics | APSTATS-HDG-2026-GRAPH-023 | provisional_model | two_model_unit_agreement_no_usable_legacy | 2 |
| ap_statistics | APSTATS-HDG-2026-GRAPH-024 | provisional_model | two_model_unit_agreement_no_usable_legacy | 2 |
| ap_statistics | APSTATS-HDG-2026-GRAPH-025 | held | model_unit_disagreement | - |
| ap_statistics | APSTATS-HDG-2026-GRAPH-026 | provisional_model | two_model_unit_agreement_no_usable_legacy | 2 |
| ap_statistics | APSTATS-HDG-2026-GRAPH-027 | provisional_model | two_model_unit_agreement_no_usable_legacy | 2 |
| ap_statistics | APSTATS-HDG-2026-GRAPH-028 | provisional_model | two_model_unit_agreement_no_usable_legacy | 1 |
| ap_statistics | APSTATS-HDG-2026-GRAPH-029 | provisional_model | two_model_unit_agreement_no_usable_legacy | 1 |
| ap_statistics | APSTATS-HDG-2026-GRAPH-030 | provisional_model | two_model_unit_agreement_no_usable_legacy | 1 |
| ap_statistics | APSTATS-HDG-2026-GRAPH-031 | provisional_model | two_model_unit_agreement_no_usable_legacy | 1 |
| ap_statistics | APSTATS-HDG-2026-GRAPH-032 | provisional_model | two_model_unit_agreement_no_usable_legacy | 5 |
| ap_statistics | APSTATS-HDG-2026-GRAPH-033 | provisional_model | two_model_unit_agreement_no_usable_legacy | 5 |
| ap_statistics | APSTATS-HDG-2026-GRAPH-034 | provisional_model | two_model_unit_agreement_no_usable_legacy | 5 |
| ap_statistics | APSTATS-HDG-2026-GRAPH-035 | provisional_model | two_model_unit_agreement_no_usable_legacy | 5 |
| ap_statistics | APSTATS-HDG-2026-GRAPH-036 | provisional_model | two_model_unit_agreement_no_usable_legacy | 5 |
| ap_statistics | APSTATS-MCQ-001 | provisional_model | two_model_confirmed_legacy_unit | 1 |
| ap_statistics | APSTATS-MCQ-002 | provisional_model | two_model_confirmed_legacy_unit | 1 |
| ap_statistics | APSTATS-MCQ-002-CAL | held | model_unit_disagreement | - |
| ap_statistics | APSTATS-MCQ-003 | provisional_model | two_model_corrected_legacy_unit | 5 |
| ap_statistics | APSTATS-MCQ-005 | provisional_model | two_model_corrected_legacy_unit | 1 |
| ap_statistics | APSTATS-MCQ-006 | provisional_model | two_model_corrected_legacy_unit | 1 |
| ap_statistics | APSTATS-MCQ-006-CAL | provisional_model | two_model_corrected_legacy_unit | 1 |
| ap_statistics | APSTATS-MCQ-007 | provisional_model | two_model_corrected_legacy_unit | 2 |
| ap_statistics | APSTATS-MCQ-007-CAL | provisional_model | two_model_corrected_legacy_unit | 2 |
| ap_statistics | APSTATS-MCQ-008 | provisional_model | two_model_corrected_legacy_unit | 2 |
| ap_statistics | APSTATS-MCQ-009-CAL | held | model_unit_disagreement | - |
| ap_statistics | APSTATS-MCQ-010 | provisional_model | two_model_corrected_legacy_unit | 3 |
| ap_statistics | APSTATS-MCQ-011 | provisional_model | two_model_corrected_legacy_unit | 3 |
| ap_statistics | APSTATS-MCQ-012 | provisional_model | two_model_corrected_legacy_unit | 1, 3 |
| ap_statistics | APSTATS-MCQ-012-CAL | provisional_model | two_model_corrected_legacy_unit | 1, 3 |
| ap_statistics | APSTATS-MCQ-013 | held | model_unit_disagreement | - |
| ap_statistics | APSTATS-MCQ-014 | held | model_unit_disagreement | - |
| ap_statistics | APSTATS-MCQ-017 | held | other | - |
| ap_statistics | APSTATS-MCQ-019 | provisional_model | two_model_confirmed_legacy_unit | 1 |
| ap_statistics | APSTATS-MCQ-022 | provisional_model | two_model_confirmed_legacy_unit | 1 |
| ap_statistics | APSTATS-MCQ-026 | provisional_model | two_model_confirmed_legacy_unit | 1 |
| ap_statistics | APSTATS-MCQ-032 | provisional_model | two_model_corrected_legacy_unit | 5 |
| ap_statistics | APSTATS-SFRQ-001 | provisional_model | two_model_confirmed_legacy_unit | 1 |
| ap_statistics | APSTATS-SFRQ-002 | held | model_unit_disagreement | - |
| ap_statistics | APSTATS-SFRQ-003 | provisional_model | two_model_corrected_legacy_unit | 5 |
| ap_statistics | APSTATS-SFRQ-004 | provisional_model | two_model_corrected_legacy_unit | 5 |
| ap_statistics | APSTATS-SFRQ-005 | provisional_model | two_model_corrected_legacy_unit | 1 |
| ap_statistics | APSTATS-SFRQ-006 | provisional_model | two_model_corrected_legacy_unit | 1 |
| ap_statistics | APSTATS-SFRQ-007 | provisional_model | two_model_corrected_legacy_unit | 2 |
| ap_statistics | APSTATS-SFRQ-008 | provisional_model | two_model_corrected_legacy_unit | 2 |
| ap_statistics | APSTATS-SFRQ-009 | provisional_model | two_model_corrected_legacy_unit | 3 |
| ap_statistics | APSTATS-SFRQ-010 | provisional_model | two_model_corrected_legacy_unit | 4 |
| ap_statistics | APSTATS-SFRQ-011 | provisional_model | two_model_corrected_legacy_unit | 3 |
| ap_statistics | APSTATS-SFRQ-012 | provisional_model | two_model_corrected_legacy_unit | 3 |
| ap_statistics | APSTATS-SFRQ-013 | provisional_model | two_model_corrected_legacy_unit | 4 |
| ap_statistics | APSTATS-SFRQ-014 | provisional_model | two_model_corrected_legacy_unit | 4 |
| ap_statistics | APSTATS-SFRQ-016 | provisional_model | two_model_corrected_legacy_unit | 3 |

Raw model outputs and SQL write file are stored under `/private/tmp/cramapple-math-taxonomy-serving/`.
