# Math Taxonomy Serving Label Run — 2026-09-26

Run ID: `serving-units-mcp-2026-09-25-20260926232425`

Scope: serving labels only (`required_units`, `primary_unit`, derived `max_required_unit`). Topic coverage (`assessed_topics`) was deferred.

Models: `openai/gpt-5.5`, `google/gemini-2.5-flash` through Vercel AI Gateway.

Validation rule: no `validated` labels were written. Two-model agreement writes `provisional_model`; rubric, scope, model failure, or disagreement writes `held`.

## Summary

| Subject | Target items | Provisional model | Held |
| --- | ---: | ---: | ---: |
| AP Biology | 0 | 0 | 0 |
| AP Chemistry | 0 | 0 | 0 |
| AP Physics 1 | 0 | 0 | 0 |
| AP Physics 2 | 66 | 51 | 15 |
| AP Physics C: Mechanics | 0 | 0 | 0 |
| AP Physics C: E&M | 0 | 0 | 0 |
| AP Statistics | 0 | 0 | 0 |
| AP Calculus AB | 0 | 0 | 0 |
| AP Calculus BC | 0 | 0 | 0 |
| AP Precalculus | 0 | 0 | 0 |

## Held / Remainder Reasons

### AP Biology

### AP Chemistry

### AP Physics 1

### AP Physics 2
- two_model_unit_agreement_no_usable_legacy: 48
- model_unit_disagreement: 5
- other: 4
- two_model_confirmed_legacy_unit: 3
- rubric_preflight_failure: 3
- empty_required_units: 2
- model_call_failure: 1

### AP Physics C: Mechanics

### AP Physics C: E&M

### AP Statistics

### AP Calculus AB

### AP Calculus BC

### AP Precalculus

## Item Outcomes

| Subject | Content key | Status | Reason | Required units |
| --- | --- | --- | --- | --- |
| ap_physics_2 | apphy2-frq-001 | provisional_model | two_model_confirmed_legacy_unit | 9 |
| ap_physics_2 | apphy2-frq-002 | held | rubric_preflight_failure | - |
| ap_physics_2 | apphy2-frq-003 | held | other | - |
| ap_physics_2 | apphy2-frq-004 | provisional_model | two_model_unit_agreement_no_usable_legacy | 12 |
| ap_physics_2 | apphy2-frq-005 | provisional_model | two_model_unit_agreement_no_usable_legacy | 13 |
| ap_physics_2 | apphy2-frq-007 | held | model_unit_disagreement | - |
| ap_physics_2 | apphy2-frq-008 | held | other | - |
| ap_physics_2 | apphy2-frq-010 | provisional_model | two_model_unit_agreement_no_usable_legacy | 11 |
| ap_physics_2 | apphy2-frq-011 | held | rubric_preflight_failure | - |
| ap_physics_2 | apphy2-frq-012 | provisional_model | two_model_unit_agreement_no_usable_legacy | 13 |
| ap_physics_2 | apphy2-frq-013 | provisional_model | two_model_unit_agreement_no_usable_legacy | 14 |
| ap_physics_2 | apphy2-frq-014 | held | model_unit_disagreement | - |
| ap_physics_2 | apphy2-frq-015 | held | model_call_failure | - |
| ap_physics_2 | apphy2-frq-017 | provisional_model | two_model_confirmed_legacy_unit | 9 |
| ap_physics_2 | apphy2-frq-019 | held | empty_required_units | - |
| ap_physics_2 | apphy2-frq-020 | provisional_model | two_model_unit_agreement_no_usable_legacy | 10, 11 |
| ap_physics_2 | apphy2-frq-021 | provisional_model | two_model_unit_agreement_no_usable_legacy | 10 |
| ap_physics_2 | apphy2-frq-022 | held | model_unit_disagreement | - |
| ap_physics_2 | apphy2-frq-023 | provisional_model | two_model_unit_agreement_no_usable_legacy | 11 |
| ap_physics_2 | apphy2-frq-025 | provisional_model | two_model_unit_agreement_no_usable_legacy | 10, 11 |
| ap_physics_2 | apphy2-frq-028 | held | rubric_preflight_failure | - |
| ap_physics_2 | apphy2-frq-029 | provisional_model | two_model_unit_agreement_no_usable_legacy | 13 |
| ap_physics_2 | apphy2-frq-031 | held | other | - |
| ap_physics_2 | apphy2-frq-032 | held | empty_required_units | - |
| ap_physics_2 | apphy2-frq-034 | held | model_unit_disagreement | - |
| ap_physics_2 | apphy2-frq-035 | held | other | - |
| ap_physics_2 | apphy2-frq-036 | provisional_model | two_model_unit_agreement_no_usable_legacy | 9 |
| ap_physics_2 | apphy2-frq-037 | provisional_model | two_model_unit_agreement_no_usable_legacy | 13 |
| ap_physics_2 | apphy2-mcq-002 | provisional_model | two_model_unit_agreement_no_usable_legacy | 9 |
| ap_physics_2 | apphy2-mcq-003 | provisional_model | two_model_unit_agreement_no_usable_legacy | 9 |
| ap_physics_2 | apphy2-mcq-004 | provisional_model | two_model_unit_agreement_no_usable_legacy | 10 |
| ap_physics_2 | apphy2-mcq-005 | provisional_model | two_model_unit_agreement_no_usable_legacy | 10 |
| ap_physics_2 | apphy2-mcq-006 | provisional_model | two_model_confirmed_legacy_unit | 10 |
| ap_physics_2 | apphy2-mcq-007 | provisional_model | two_model_unit_agreement_no_usable_legacy | 11 |
| ap_physics_2 | apphy2-mcq-008 | provisional_model | two_model_unit_agreement_no_usable_legacy | 11 |
| ap_physics_2 | apphy2-mcq-010 | provisional_model | two_model_unit_agreement_no_usable_legacy | 12 |
| ap_physics_2 | apphy2-mcq-012 | provisional_model | two_model_unit_agreement_no_usable_legacy | 12 |
| ap_physics_2 | apphy2-mcq-013 | provisional_model | two_model_unit_agreement_no_usable_legacy | 14 |
| ap_physics_2 | apphy2-mcq-014 | provisional_model | two_model_unit_agreement_no_usable_legacy | 13 |
| ap_physics_2 | apphy2-mcq-015 | provisional_model | two_model_unit_agreement_no_usable_legacy | 13 |
| ap_physics_2 | apphy2-mcq-016 | provisional_model | two_model_unit_agreement_no_usable_legacy | 14 |
| ap_physics_2 | apphy2-mcq-017 | provisional_model | two_model_unit_agreement_no_usable_legacy | 14 |
| ap_physics_2 | apphy2-mcq-019 | held | model_unit_disagreement | - |
| ap_physics_2 | apphy2-mcq-020 | provisional_model | two_model_unit_agreement_no_usable_legacy | 15 |
| ap_physics_2 | apphy2-mcq-021 | provisional_model | two_model_unit_agreement_no_usable_legacy | 9 |
| ap_physics_2 | apphy2-mcq-022 | provisional_model | two_model_unit_agreement_no_usable_legacy | 9 |
| ap_physics_2 | apphy2-mcq-023 | provisional_model | two_model_unit_agreement_no_usable_legacy | 9 |
| ap_physics_2 | apphy2-mcq-024 | provisional_model | two_model_unit_agreement_no_usable_legacy | 10 |
| ap_physics_2 | apphy2-mcq-025 | provisional_model | two_model_unit_agreement_no_usable_legacy | 10 |
| ap_physics_2 | apphy2-mcq-026 | provisional_model | two_model_unit_agreement_no_usable_legacy | 10 |
| ap_physics_2 | apphy2-mcq-027 | provisional_model | two_model_unit_agreement_no_usable_legacy | 11 |
| ap_physics_2 | apphy2-mcq-028 | provisional_model | two_model_unit_agreement_no_usable_legacy | 11 |
| ap_physics_2 | apphy2-mcq-029 | provisional_model | two_model_unit_agreement_no_usable_legacy | 11 |
| ap_physics_2 | apphy2-mcq-030 | provisional_model | two_model_unit_agreement_no_usable_legacy | 11 |
| ap_physics_2 | apphy2-mcq-031 | provisional_model | two_model_unit_agreement_no_usable_legacy | 12 |
| ap_physics_2 | apphy2-mcq-032 | provisional_model | two_model_unit_agreement_no_usable_legacy | 12 |
| ap_physics_2 | apphy2-mcq-033 | provisional_model | two_model_unit_agreement_no_usable_legacy | 12 |
| ap_physics_2 | apphy2-mcq-034 | provisional_model | two_model_unit_agreement_no_usable_legacy | 13 |
| ap_physics_2 | apphy2-mcq-035 | provisional_model | two_model_unit_agreement_no_usable_legacy | 13 |
| ap_physics_2 | apphy2-mcq-036 | provisional_model | two_model_unit_agreement_no_usable_legacy | 13 |
| ap_physics_2 | apphy2-mcq-037 | provisional_model | two_model_unit_agreement_no_usable_legacy | 14 |
| ap_physics_2 | apphy2-mcq-038 | provisional_model | two_model_unit_agreement_no_usable_legacy | 14 |
| ap_physics_2 | apphy2-mcq-039 | provisional_model | two_model_unit_agreement_no_usable_legacy | 14 |
| ap_physics_2 | apphy2-mcq-040 | provisional_model | two_model_unit_agreement_no_usable_legacy | 15 |
| ap_physics_2 | apphy2-mcq-041 | provisional_model | two_model_unit_agreement_no_usable_legacy | 15 |
| ap_physics_2 | apphy2-mcq-042 | provisional_model | two_model_unit_agreement_no_usable_legacy | 15 |

Raw model outputs and SQL write file were generated under `/private/tmp/cramapple-content-pipeline-2026-09-26/ap_physics_2_ready/`.
