# AP Chemistry Taxonomy Serving Label Run - 2026-08-05

Run ID: `math-serving-units-2026-08-04-20260805122550`

Production project: `pcntajvbdfqhbeewmdry`

Scope: AP Chemistry published latest items only. This run wrote serving labels
only (`required_units`, `primary_unit`, derived `max_required_unit`). Topic
coverage (`assessed_topics`) was deferred and remains empty for this run.

Fact pack: `docs/product/AP_CHEMISTRY_CED_FACT_PACK.md`. Source document is AP
Chemistry Course and Exam Description, Effective Fall 2024, Course Framework
V.1. The fact pack records source SHA-256
`b5dfe8677ef3d88c613865d2e2a3e8d6125d652e2b24c71ef1e8ce4e011094f0` and
supersedes the Fall 2020 digest.

Models: `openai/gpt-5.5` and `google/gemini-2.5-flash` through Vercel AI
Gateway.

Validation rule: no `validated` labels were written. Two-model agreement writes
`provisional_model`; model disagreement, empty unit output, rubric preflight
failure, or model/schema irregularity writes `held`.

Chemistry-specific lane: confirm-or-correct against the active legacy serving
label when a usable legacy unit set exists. In this target set, no published
item had a usable legacy unit set, so the run behaved as cold serving-unit
labeling from the verified nine-unit AP Chemistry fact pack.

## Summary

| Subject | Target items | Provisional model | Held |
| --- | ---: | ---: | ---: |
| AP Chemistry | 31 | 26 | 5 |

Live Production census after write:

| Label census | Count |
| --- | ---: |
| Active serving labels on published Chemistry targets | 31 |
| Two-model agreed unit labels | 26 |
| Held labels | 5 |
| Topic labels written | 0 |
| Validated labels written | 0 |
| Usable legacy unit sets before run | 0 |

## Outcome Reasons

- two_model_unit_agreement_no_usable_legacy: 26
- model_unit_disagreement: 4
- rubric_preflight_failure: 1

## Item Outcomes

| Subject | Content key | Status | Reason | Required units |
| --- | --- | --- | --- | --- |
| ap_chemistry | apchem-frq-l-001 | provisional_model | two_model_unit_agreement_no_usable_legacy | 1, 4 |
| ap_chemistry | apchem-frq-l-022 | provisional_model | two_model_unit_agreement_no_usable_legacy | 7 |
| ap_chemistry | apchem-mcq-002 | provisional_model | two_model_unit_agreement_no_usable_legacy | 1 |
| ap_chemistry | apchem-mcq-004 | held | model_unit_disagreement | - |
| ap_chemistry | apchem-mcq-009 | provisional_model | two_model_unit_agreement_no_usable_legacy | 4 |
| ap_chemistry | apchem-mcq-010 | provisional_model | two_model_unit_agreement_no_usable_legacy | 4 |
| ap_chemistry | apchem-mcq-013 | provisional_model | two_model_unit_agreement_no_usable_legacy | 6 |
| ap_chemistry | apchem-mcq-015 | provisional_model | two_model_unit_agreement_no_usable_legacy | 7 |
| ap_chemistry | apchem-mcq-016 | provisional_model | two_model_unit_agreement_no_usable_legacy | 3, 7 |
| ap_chemistry | apchem-mcq-026 | provisional_model | two_model_unit_agreement_no_usable_legacy | 2 |
| ap_chemistry | apchem-mcq-029 | held | model_unit_disagreement | - |
| ap_chemistry | apchem-mcq-031 | held | model_unit_disagreement | - |
| ap_chemistry | apchem-mcq-032 | provisional_model | two_model_unit_agreement_no_usable_legacy | 3 |
| ap_chemistry | apchem-mcq-036 | provisional_model | two_model_unit_agreement_no_usable_legacy | 3 |
| ap_chemistry | apchem-mcq-040 | provisional_model | two_model_unit_agreement_no_usable_legacy | 1, 4 |
| ap_chemistry | apchem-mcq-041 | provisional_model | two_model_unit_agreement_no_usable_legacy | 4 |
| ap_chemistry | apchem-mcq-045 | provisional_model | two_model_unit_agreement_no_usable_legacy | 5 |
| ap_chemistry | apchem-mcq-047 | provisional_model | two_model_unit_agreement_no_usable_legacy | 5 |
| ap_chemistry | apchem-mcq-048 | held | model_unit_disagreement | - |
| ap_chemistry | apchem-mcq-050 | provisional_model | two_model_unit_agreement_no_usable_legacy | 6 |
| ap_chemistry | apchem-mcq-054 | provisional_model | two_model_unit_agreement_no_usable_legacy | 7 |
| ap_chemistry | apchem-mcq-058 | provisional_model | two_model_unit_agreement_no_usable_legacy | 8 |
| ap_chemistry | apchem-mcq-060 | provisional_model | two_model_unit_agreement_no_usable_legacy | 8 |
| ap_chemistry | apchem-mcq-064 | provisional_model | two_model_unit_agreement_no_usable_legacy | 8 |
| ap_chemistry | apchem-mcq-065 | provisional_model | two_model_unit_agreement_no_usable_legacy | 8 |
| ap_chemistry | apchem-sfrq-001 | provisional_model | two_model_unit_agreement_no_usable_legacy | 7, 9 |
| ap_chemistry | apchem-sfrq-005 | held | rubric_preflight_failure | - |
| ap_chemistry | apchem-sfrq-008 | provisional_model | two_model_unit_agreement_no_usable_legacy | 7 |
| ap_chemistry | apchem-sfrq-018 | provisional_model | two_model_unit_agreement_no_usable_legacy | 3 |
| ap_chemistry | apchem-sfrq-028 | provisional_model | two_model_unit_agreement_no_usable_legacy | 6 |
| ap_chemistry | apchem-sfrq-029 | provisional_model | two_model_unit_agreement_no_usable_legacy | 7, 8 |

Raw model outputs and SQL write file are stored under `/private/tmp/cramapple-math-taxonomy-serving/`.
