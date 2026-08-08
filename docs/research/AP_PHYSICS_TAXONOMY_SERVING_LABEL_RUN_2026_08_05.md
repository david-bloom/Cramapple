# Math Taxonomy Serving Label Run — 2026-08-04

Run ID: `math-serving-units-2026-08-04-20260808183559`

Scope: serving labels only (`required_units`, `primary_unit`, derived `max_required_unit`). Topic coverage (`assessed_topics`) was deferred.

Models: `openai/gpt-5.5`, `google/gemini-2.5-flash` through Vercel AI Gateway.

Validation rule: no `validated` labels were written. Two-model agreement writes `provisional_model`; rubric, scope, model failure, or disagreement writes `held`.

## Summary

| Subject | Target items | Provisional model | Held |
| --- | ---: | ---: | ---: |
| AP Biology | 0 | 0 | 0 |
| AP Chemistry | 0 | 0 | 0 |
| AP Physics 1 | 17 | 9 | 8 |
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

### AP Physics 1
- two_model_unit_agreement_no_usable_legacy: 9
- model_call_failure: 4
- model_unit_disagreement: 4

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
| ap_physics_1 | apphy1-frq-002 | held | model_call_failure | - |
| ap_physics_1 | apphy1-frq-003 | provisional_model | two_model_unit_agreement_no_usable_legacy | 3 |
| ap_physics_1 | apphy1-frq-004 | provisional_model | two_model_unit_agreement_no_usable_legacy | 3, 4 |
| ap_physics_1 | apphy1-frq-009 | held | model_unit_disagreement | - |
| ap_physics_1 | apphy1-frq-013 | held | model_call_failure | - |
| ap_physics_1 | apphy1-frq-025 | provisional_model | two_model_unit_agreement_no_usable_legacy | 3 |
| ap_physics_1 | apphy1-frq-028 | held | model_unit_disagreement | - |
| ap_physics_1 | apphy1-frq-034 | held | model_unit_disagreement | - |
| ap_physics_1 | apphy1-mcq-003 | provisional_model | two_model_unit_agreement_no_usable_legacy | 2 |
| ap_physics_1 | apphy1-mcq-004 | provisional_model | two_model_unit_agreement_no_usable_legacy | 2 |
| ap_physics_1 | apphy1-mcq-006 | provisional_model | two_model_unit_agreement_no_usable_legacy | 3 |
| ap_physics_1 | apphy1-mcq-007 | provisional_model | two_model_unit_agreement_no_usable_legacy | 3 |
| ap_physics_1 | apphy1-mcq-008 | provisional_model | two_model_unit_agreement_no_usable_legacy | 3 |
| ap_physics_1 | apphy1-mcq-010 | held | model_call_failure | - |
| ap_physics_1 | apphy1-mcq-011 | provisional_model | two_model_unit_agreement_no_usable_legacy | 5 |
| ap_physics_1 | apphy1-mcq-015 | held | model_call_failure | - |
| ap_physics_1 | apphy1-mcq-016 | held | model_unit_disagreement | - |

Raw model outputs and SQL write file are stored under `/private/tmp/cramapple-math-taxonomy-serving/`.
