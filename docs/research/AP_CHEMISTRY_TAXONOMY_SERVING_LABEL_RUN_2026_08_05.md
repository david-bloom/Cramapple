# Math Taxonomy Serving Label Run — 2026-08-04

Run ID: `math-serving-units-2026-08-04-20260808185254`

Scope: serving labels only (`required_units`, `primary_unit`, derived `max_required_unit`). Topic coverage (`assessed_topics`) was deferred.

Models: `openai/gpt-5.5`, `google/gemini-2.5-flash` through Vercel AI Gateway.

Validation rule: no `validated` labels were written. Two-model agreement writes `provisional_model`; rubric, scope, model failure, or disagreement writes `held`.

## Summary

| Subject | Target items | Provisional model | Held |
| --- | ---: | ---: | ---: |
| AP Biology | 0 | 0 | 0 |
| AP Chemistry | 110 | 78 | 32 |
| AP Physics 1 | 0 | 0 | 0 |
| AP Physics 2 | 0 | 0 | 0 |
| AP Physics C: Mechanics | 0 | 0 | 0 |
| AP Physics C: E&M | 0 | 0 | 0 |
| AP Statistics | 0 | 0 | 0 |
| AP Calculus AB | 0 | 0 | 0 |
| AP Calculus BC | 0 | 0 | 0 |
| AP Precalculus | 0 | 0 | 0 |

## Held / Remainder Reasons

### AP Biology

### AP Chemistry
- two_model_unit_agreement_no_usable_legacy: 78
- model_unit_disagreement: 16
- rubric_preflight_failure: 7
- other: 4
- model_call_failure: 3
- empty_required_units: 2

### AP Physics 1

### AP Physics 2

### AP Physics C: Mechanics

### AP Physics C: E&M

### AP Statistics

### AP Calculus AB

### AP Calculus BC

### AP Precalculus

## Item Outcomes

| Subject | Content key | Status | Reason | Required units |
| --- | --- | --- | --- | --- |
| ap_chemistry | apchem-frq-l-001 | held | model_unit_disagreement | - |
| ap_chemistry | apchem-frq-l-003 | held | rubric_preflight_failure | - |
| ap_chemistry | apchem-frq-l-004 | provisional_model | two_model_unit_agreement_no_usable_legacy | 1, 3, 4 |
| ap_chemistry | apchem-frq-l-005 | held | rubric_preflight_failure | - |
| ap_chemistry | apchem-frq-l-010 | provisional_model | two_model_unit_agreement_no_usable_legacy | 2, 3 |
| ap_chemistry | apchem-frq-l-011 | provisional_model | two_model_unit_agreement_no_usable_legacy | 1, 3 |
| ap_chemistry | apchem-frq-l-016 | provisional_model | two_model_unit_agreement_no_usable_legacy | 1, 3, 4 |
| ap_chemistry | apchem-frq-l-017 | held | model_unit_disagreement | - |
| ap_chemistry | apchem-frq-l-021 | held | other | - |
| ap_chemistry | apchem-frq-l-022 | held | model_unit_disagreement | - |
| ap_chemistry | apchem-frq-l-023 | held | rubric_preflight_failure | - |
| ap_chemistry | apchem-frq-l-024 | provisional_model | two_model_unit_agreement_no_usable_legacy | 7, 8 |
| ap_chemistry | apchem-frq-l-025 | held | model_unit_disagreement | - |
| ap_chemistry | apchem-frq-l-026 | held | rubric_preflight_failure | - |
| ap_chemistry | apchem-frq-l-027 | provisional_model | two_model_unit_agreement_no_usable_legacy | 9 |
| ap_chemistry | apchem-frq-l-028 | held | model_unit_disagreement | - |
| ap_chemistry | apchem-mcq-002 | provisional_model | two_model_unit_agreement_no_usable_legacy | 1 |
| ap_chemistry | apchem-mcq-003 | provisional_model | two_model_unit_agreement_no_usable_legacy | 2 |
| ap_chemistry | apchem-mcq-004 | held | model_unit_disagreement | - |
| ap_chemistry | apchem-mcq-005 | provisional_model | two_model_unit_agreement_no_usable_legacy | 3 |
| ap_chemistry | apchem-mcq-006 | held | model_call_failure | - |
| ap_chemistry | apchem-mcq-007 | held | model_unit_disagreement | - |
| ap_chemistry | apchem-mcq-008 | provisional_model | two_model_unit_agreement_no_usable_legacy | 3 |
| ap_chemistry | apchem-mcq-009 | provisional_model | two_model_unit_agreement_no_usable_legacy | 4 |
| ap_chemistry | apchem-mcq-010 | provisional_model | two_model_unit_agreement_no_usable_legacy | 4 |
| ap_chemistry | apchem-mcq-011 | provisional_model | two_model_unit_agreement_no_usable_legacy | 5 |
| ap_chemistry | apchem-mcq-012 | provisional_model | two_model_unit_agreement_no_usable_legacy | 5, 7, 9 |
| ap_chemistry | apchem-mcq-013 | provisional_model | two_model_unit_agreement_no_usable_legacy | 6 |
| ap_chemistry | apchem-mcq-014 | held | model_unit_disagreement | - |
| ap_chemistry | apchem-mcq-015 | provisional_model | two_model_unit_agreement_no_usable_legacy | 7 |
| ap_chemistry | apchem-mcq-016 | provisional_model | two_model_unit_agreement_no_usable_legacy | 3, 7 |
| ap_chemistry | apchem-mcq-017 | provisional_model | two_model_unit_agreement_no_usable_legacy | 8 |
| ap_chemistry | apchem-mcq-018 | provisional_model | two_model_unit_agreement_no_usable_legacy | 8 |
| ap_chemistry | apchem-mcq-019 | provisional_model | two_model_unit_agreement_no_usable_legacy | 9 |
| ap_chemistry | apchem-mcq-020 | provisional_model | two_model_unit_agreement_no_usable_legacy | 9 |
| ap_chemistry | apchem-mcq-021 | provisional_model | two_model_unit_agreement_no_usable_legacy | 1 |
| ap_chemistry | apchem-mcq-022 | provisional_model | two_model_unit_agreement_no_usable_legacy | 1 |
| ap_chemistry | apchem-mcq-023 | held | empty_required_units | - |
| ap_chemistry | apchem-mcq-024 | provisional_model | two_model_unit_agreement_no_usable_legacy | 1 |
| ap_chemistry | apchem-mcq-025 | provisional_model | two_model_unit_agreement_no_usable_legacy | 2 |
| ap_chemistry | apchem-mcq-026 | provisional_model | two_model_unit_agreement_no_usable_legacy | 2 |
| ap_chemistry | apchem-mcq-027 | provisional_model | two_model_unit_agreement_no_usable_legacy | 2 |
| ap_chemistry | apchem-mcq-028 | held | model_unit_disagreement | - |
| ap_chemistry | apchem-mcq-029 | provisional_model | two_model_unit_agreement_no_usable_legacy | 3 |
| ap_chemistry | apchem-mcq-030 | provisional_model | two_model_unit_agreement_no_usable_legacy | 3 |
| ap_chemistry | apchem-mcq-031 | provisional_model | two_model_unit_agreement_no_usable_legacy | 3 |
| ap_chemistry | apchem-mcq-032 | provisional_model | two_model_unit_agreement_no_usable_legacy | 3 |
| ap_chemistry | apchem-mcq-033 | provisional_model | two_model_unit_agreement_no_usable_legacy | 3 |
| ap_chemistry | apchem-mcq-034 | provisional_model | two_model_unit_agreement_no_usable_legacy | 3 |
| ap_chemistry | apchem-mcq-035 | held | model_unit_disagreement | - |
| ap_chemistry | apchem-mcq-036 | provisional_model | two_model_unit_agreement_no_usable_legacy | 3 |
| ap_chemistry | apchem-mcq-037 | held | model_call_failure | - |
| ap_chemistry | apchem-mcq-038 | provisional_model | two_model_unit_agreement_no_usable_legacy | 3 |
| ap_chemistry | apchem-mcq-039 | provisional_model | two_model_unit_agreement_no_usable_legacy | 3 |
| ap_chemistry | apchem-mcq-040 | provisional_model | two_model_unit_agreement_no_usable_legacy | 1, 4 |
| ap_chemistry | apchem-mcq-041 | held | model_unit_disagreement | - |
| ap_chemistry | apchem-mcq-042 | held | other | - |
| ap_chemistry | apchem-mcq-043 | provisional_model | two_model_unit_agreement_no_usable_legacy | 4 |
| ap_chemistry | apchem-mcq-044 | provisional_model | two_model_unit_agreement_no_usable_legacy | 3, 4 |
| ap_chemistry | apchem-mcq-045 | provisional_model | two_model_unit_agreement_no_usable_legacy | 5 |
| ap_chemistry | apchem-mcq-046 | provisional_model | two_model_unit_agreement_no_usable_legacy | 5 |
| ap_chemistry | apchem-mcq-047 | provisional_model | two_model_unit_agreement_no_usable_legacy | 5, 6 |
| ap_chemistry | apchem-mcq-048 | provisional_model | two_model_unit_agreement_no_usable_legacy | 5, 6, 7 |
| ap_chemistry | apchem-mcq-049 | provisional_model | two_model_unit_agreement_no_usable_legacy | 6 |
| ap_chemistry | apchem-mcq-050 | provisional_model | two_model_unit_agreement_no_usable_legacy | 6 |
| ap_chemistry | apchem-mcq-051 | provisional_model | two_model_unit_agreement_no_usable_legacy | 6 |
| ap_chemistry | apchem-mcq-052 | provisional_model | two_model_unit_agreement_no_usable_legacy | 6 |
| ap_chemistry | apchem-mcq-053 | provisional_model | two_model_unit_agreement_no_usable_legacy | 6 |
| ap_chemistry | apchem-mcq-054 | provisional_model | two_model_unit_agreement_no_usable_legacy | 7 |
| ap_chemistry | apchem-mcq-055 | provisional_model | two_model_unit_agreement_no_usable_legacy | 7 |
| ap_chemistry | apchem-mcq-056 | provisional_model | two_model_unit_agreement_no_usable_legacy | 7 |
| ap_chemistry | apchem-mcq-057 | provisional_model | two_model_unit_agreement_no_usable_legacy | 7 |
| ap_chemistry | apchem-mcq-058 | provisional_model | two_model_unit_agreement_no_usable_legacy | 4 |
| ap_chemistry | apchem-mcq-059 | held | model_call_failure | - |
| ap_chemistry | apchem-mcq-060 | provisional_model | two_model_unit_agreement_no_usable_legacy | 8 |
| ap_chemistry | apchem-mcq-061 | held | model_unit_disagreement | - |
| ap_chemistry | apchem-mcq-062 | provisional_model | two_model_unit_agreement_no_usable_legacy | 8 |
| ap_chemistry | apchem-mcq-063 | provisional_model | two_model_unit_agreement_no_usable_legacy | 8 |
| ap_chemistry | apchem-mcq-064 | provisional_model | two_model_unit_agreement_no_usable_legacy | 8 |
| ap_chemistry | apchem-mcq-065 | provisional_model | two_model_unit_agreement_no_usable_legacy | 8 |
| ap_chemistry | apchem-mcq-066 | provisional_model | two_model_unit_agreement_no_usable_legacy | 9 |
| ap_chemistry | apchem-mcq-067 | provisional_model | two_model_unit_agreement_no_usable_legacy | 9 |
| ap_chemistry | apchem-mcq-068 | provisional_model | two_model_unit_agreement_no_usable_legacy | 9 |
| ap_chemistry | apchem-mcq-069 | provisional_model | two_model_unit_agreement_no_usable_legacy | 9 |
| ap_chemistry | apchem-sfrq-001 | provisional_model | two_model_unit_agreement_no_usable_legacy | 7, 9 |
| ap_chemistry | apchem-sfrq-002 | provisional_model | two_model_unit_agreement_no_usable_legacy | 8 |
| ap_chemistry | apchem-sfrq-004 | held | rubric_preflight_failure | - |
| ap_chemistry | apchem-sfrq-005 | held | rubric_preflight_failure | - |
| ap_chemistry | apchem-sfrq-007 | held | rubric_preflight_failure | - |
| ap_chemistry | apchem-sfrq-008 | provisional_model | two_model_unit_agreement_no_usable_legacy | 7 |
| ap_chemistry | apchem-sfrq-009 | provisional_model | two_model_unit_agreement_no_usable_legacy | 8 |
| ap_chemistry | apchem-sfrq-015 | provisional_model | two_model_unit_agreement_no_usable_legacy | 3 |
| ap_chemistry | apchem-sfrq-016 | provisional_model | two_model_unit_agreement_no_usable_legacy | 3 |
| ap_chemistry | apchem-sfrq-018 | held | empty_required_units | - |
| ap_chemistry | apchem-sfrq-019 | provisional_model | two_model_unit_agreement_no_usable_legacy | 1, 3 |
| ap_chemistry | apchem-sfrq-021 | provisional_model | two_model_unit_agreement_no_usable_legacy | 4 |
| ap_chemistry | apchem-sfrq-022 | provisional_model | two_model_unit_agreement_no_usable_legacy | 1, 3, 4 |
| ap_chemistry | apchem-sfrq-023 | held | other | - |
| ap_chemistry | apchem-sfrq-026 | provisional_model | two_model_unit_agreement_no_usable_legacy | 6, 9 |
| ap_chemistry | apchem-sfrq-027 | provisional_model | two_model_unit_agreement_no_usable_legacy | 1, 6, 9 |
| ap_chemistry | apchem-sfrq-028 | provisional_model | two_model_unit_agreement_no_usable_legacy | 6 |
| ap_chemistry | apchem-sfrq-029 | provisional_model | two_model_unit_agreement_no_usable_legacy | 7, 8 |
| ap_chemistry | apchem-sfrq-030 | held | model_unit_disagreement | - |
| ap_chemistry | apchem-sfrq-031 | held | model_unit_disagreement | - |
| ap_chemistry | apchem-sfrq-032 | held | model_unit_disagreement | - |
| ap_chemistry | apchem-sfrq-033 | provisional_model | two_model_unit_agreement_no_usable_legacy | 4, 8 |
| ap_chemistry | apchem-sfrq-034 | provisional_model | two_model_unit_agreement_no_usable_legacy | 8 |
| ap_chemistry | apchem-sfrq-035 | held | other | - |
| ap_chemistry | apchem-sfrq-037 | provisional_model | two_model_unit_agreement_no_usable_legacy | 9 |
| ap_chemistry | apchem-sfrq-038 | held | model_unit_disagreement | - |

Raw model outputs and SQL write file are stored under `/private/tmp/cramapple-math-taxonomy-serving/`.
