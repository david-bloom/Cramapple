# Math Taxonomy Serving Label Run — 2026-08-04

Run ID: `serving-units-mcp-2026-09-25-20260925163249`

Scope: serving labels only (`required_units`, `primary_unit`, derived `max_required_unit`). Topic coverage (`assessed_topics`) was deferred.

Models: `openai/gpt-5.5`, `google/gemini-2.5-flash` through Vercel AI Gateway.

Validation rule: no `validated` labels were written. Two-model agreement writes `provisional_model`; rubric, scope, model failure, or disagreement writes `held`.

## Summary

| Subject | Target items | Provisional model | Held |
| --- | ---: | ---: | ---: |
| AP Biology | 0 | 0 | 0 |
| AP Chemistry | 0 | 0 | 0 |
| AP Physics 1 | 0 | 0 | 0 |
| AP Physics 2 | 0 | 0 | 0 |
| AP Physics C: Mechanics | 0 | 0 | 0 |
| AP Physics C: E&M | 0 | 0 | 0 |
| AP Statistics | 126 | 107 | 19 |
| AP Calculus AB | 0 | 0 | 0 |
| AP Calculus BC | 0 | 0 | 0 |
| AP Precalculus | 0 | 0 | 0 |

## Held / Remainder Reasons

### AP Biology

### AP Chemistry

### AP Physics 1

### AP Physics 2

### AP Physics C: Mechanics

### AP Physics C: E&M

### AP Statistics
- two_model_corrected_legacy_unit: 65
- two_model_unit_agreement_no_usable_legacy: 37
- model_unit_disagreement: 11
- other: 7
- two_model_confirmed_legacy_unit: 5
- rubric_preflight_failure: 1

### AP Calculus AB

### AP Calculus BC

### AP Precalculus

## Item Outcomes

| Subject | Content key | Status | Reason | Required units |
| --- | --- | --- | --- | --- |
| ap_statistics | APSTAT-MOD3-E002 | provisional_model | two_model_unit_agreement_no_usable_legacy | 1 |
| ap_statistics | APSTAT-MOD3-H001-INV | provisional_model | two_model_unit_agreement_no_usable_legacy | 1, 4 |
| ap_statistics | APSTAT-MOD4-H001-INV | held | rubric_preflight_failure | - |
| ap_statistics | APSTAT-MOD4-M001 | provisional_model | two_model_unit_agreement_no_usable_legacy | 1 |
| ap_statistics | APSTAT-MOD5-H001-INV | provisional_model | two_model_unit_agreement_no_usable_legacy | 1, 4 |
| ap_statistics | APSTAT-MOD5-M001 | provisional_model | two_model_unit_agreement_no_usable_legacy | 1 |
| ap_statistics | APSTAT-MOD6-H001 | provisional_model | two_model_unit_agreement_no_usable_legacy | 4 |
| ap_statistics | APSTAT-MOD6-H002-INV | provisional_model | two_model_unit_agreement_no_usable_legacy | 5 |
| ap_statistics | APSTAT-MOD6-M002 | provisional_model | two_model_unit_agreement_no_usable_legacy | 4 |
| ap_statistics | APSTAT-MOD7-H002-INV | provisional_model | two_model_unit_agreement_no_usable_legacy | 1, 2, 3 |
| ap_statistics | apstats-frq-u12-001 | provisional_model | two_model_unit_agreement_no_usable_legacy | 1 |
| ap_statistics | apstats-frq-u12-002 | provisional_model | two_model_unit_agreement_no_usable_legacy | 2 |
| ap_statistics | apstats-frq-u12-003 | provisional_model | two_model_unit_agreement_no_usable_legacy | 1 |
| ap_statistics | apstats-frq-u12-004 | provisional_model | two_model_unit_agreement_no_usable_legacy | 1 |
| ap_statistics | apstats-frq-u12-005 | provisional_model | two_model_unit_agreement_no_usable_legacy | 1 |
| ap_statistics | apstats-frq-u12-006 | provisional_model | two_model_unit_agreement_no_usable_legacy | 2 |
| ap_statistics | apstats-frq-u12-007 | provisional_model | two_model_unit_agreement_no_usable_legacy | 2 |
| ap_statistics | apstats-frq-u12-008 | provisional_model | two_model_unit_agreement_no_usable_legacy | 2 |
| ap_statistics | apstats-frq-u12-009 | provisional_model | two_model_unit_agreement_no_usable_legacy | 2 |
| ap_statistics | apstats-frq-u12-010 | provisional_model | two_model_unit_agreement_no_usable_legacy | 1 |
| ap_statistics | apstats-frq-u12-011 | provisional_model | two_model_unit_agreement_no_usable_legacy | 2 |
| ap_statistics | apstats-frq-u12-012 | provisional_model | two_model_unit_agreement_no_usable_legacy | 1 |
| ap_statistics | apstats-frq-u12-013 | provisional_model | two_model_unit_agreement_no_usable_legacy | 1 |
| ap_statistics | apstats-frq-u12-014 | provisional_model | two_model_unit_agreement_no_usable_legacy | 2 |
| ap_statistics | apstats-frq-u12-015 | provisional_model | two_model_unit_agreement_no_usable_legacy | 2 |
| ap_statistics | apstats-frq-u12-016 | provisional_model | two_model_unit_agreement_no_usable_legacy | 2 |
| ap_statistics | apstats-frq-u12-017 | provisional_model | two_model_unit_agreement_no_usable_legacy | 1, 2 |
| ap_statistics | apstats-frq-u12-018 | provisional_model | two_model_unit_agreement_no_usable_legacy | 2 |
| ap_statistics | apstats-frq-u12-019 | provisional_model | two_model_unit_agreement_no_usable_legacy | 2 |
| ap_statistics | apstats-frq-u12-020 | provisional_model | two_model_unit_agreement_no_usable_legacy | 1 |
| ap_statistics | APSTATS-HDG-2026-GRAPH-005 | provisional_model | two_model_unit_agreement_no_usable_legacy | 5 |
| ap_statistics | APSTATS-HDG-2026-GRAPH-019 | held | model_unit_disagreement | - |
| ap_statistics | APSTATS-HDG-2026-GRAPH-033 | provisional_model | two_model_unit_agreement_no_usable_legacy | 5 |
| ap_statistics | APSTATS-MCQ-002 | held | model_unit_disagreement | - |
| ap_statistics | APSTATS-MCQ-004 | provisional_model | two_model_corrected_legacy_unit | 5 |
| ap_statistics | APSTATS-MCQ-004-CAL | provisional_model | two_model_corrected_legacy_unit | 5 |
| ap_statistics | APSTATS-MCQ-005-CAL | provisional_model | two_model_corrected_legacy_unit | 1 |
| ap_statistics | APSTATS-MCQ-008-CAL | provisional_model | two_model_corrected_legacy_unit | 2 |
| ap_statistics | APSTATS-MCQ-009 | held | model_unit_disagreement | - |
| ap_statistics | APSTATS-MCQ-010-CAL | provisional_model | two_model_corrected_legacy_unit | 3 |
| ap_statistics | APSTATS-MCQ-011-CAL | provisional_model | two_model_corrected_legacy_unit | 3 |
| ap_statistics | APSTATS-MCQ-013-CAL | held | model_unit_disagreement | - |
| ap_statistics | APSTATS-MCQ-014-CAL | provisional_model | two_model_corrected_legacy_unit | 4 |
| ap_statistics | APSTATS-MCQ-016-CAL | held | other | - |
| ap_statistics | APSTATS-MCQ-018-CAL | held | other | - |
| ap_statistics | APSTATS-MCQ-020 | held | model_unit_disagreement | - |
| ap_statistics | APSTATS-MCQ-021 | provisional_model | two_model_confirmed_legacy_unit | 1 |
| ap_statistics | APSTATS-MCQ-023 | provisional_model | two_model_confirmed_legacy_unit | 1 |
| ap_statistics | APSTATS-MCQ-024 | provisional_model | two_model_confirmed_legacy_unit | 1 |
| ap_statistics | APSTATS-MCQ-025 | provisional_model | two_model_confirmed_legacy_unit | 1 |
| ap_statistics | APSTATS-MCQ-027 | provisional_model | two_model_confirmed_legacy_unit | 1 |
| ap_statistics | APSTATS-MCQ-028 | provisional_model | two_model_corrected_legacy_unit | 5 |
| ap_statistics | APSTATS-MCQ-029 | provisional_model | two_model_corrected_legacy_unit | 5 |
| ap_statistics | APSTATS-MCQ-030 | provisional_model | two_model_corrected_legacy_unit | 5 |
| ap_statistics | APSTATS-MCQ-031 | provisional_model | two_model_corrected_legacy_unit | 5 |
| ap_statistics | APSTATS-MCQ-033 | provisional_model | two_model_corrected_legacy_unit | 5 |
| ap_statistics | APSTATS-MCQ-034 | provisional_model | two_model_corrected_legacy_unit | 5 |
| ap_statistics | APSTATS-MCQ-035 | provisional_model | two_model_corrected_legacy_unit | 5 |
| ap_statistics | APSTATS-MCQ-037 | provisional_model | two_model_corrected_legacy_unit | 1 |
| ap_statistics | APSTATS-MCQ-038 | provisional_model | two_model_corrected_legacy_unit | 1 |
| ap_statistics | APSTATS-MCQ-039 | provisional_model | two_model_corrected_legacy_unit | 1 |
| ap_statistics | APSTATS-MCQ-040 | provisional_model | two_model_corrected_legacy_unit | 1 |
| ap_statistics | APSTATS-MCQ-041 | provisional_model | two_model_corrected_legacy_unit | 1 |
| ap_statistics | APSTATS-MCQ-042 | provisional_model | two_model_corrected_legacy_unit | 1 |
| ap_statistics | APSTATS-MCQ-043 | provisional_model | two_model_corrected_legacy_unit | 1 |
| ap_statistics | APSTATS-MCQ-044 | provisional_model | two_model_corrected_legacy_unit | 1 |
| ap_statistics | APSTATS-MCQ-045 | provisional_model | two_model_corrected_legacy_unit | 1 |
| ap_statistics | APSTATS-MCQ-046 | provisional_model | two_model_corrected_legacy_unit | 2 |
| ap_statistics | APSTATS-MCQ-047 | provisional_model | two_model_corrected_legacy_unit | 2 |
| ap_statistics | APSTATS-MCQ-048 | provisional_model | two_model_corrected_legacy_unit | 2 |
| ap_statistics | APSTATS-MCQ-049 | provisional_model | two_model_corrected_legacy_unit | 2 |
| ap_statistics | APSTATS-MCQ-050 | provisional_model | two_model_corrected_legacy_unit | 2 |
| ap_statistics | APSTATS-MCQ-051 | provisional_model | two_model_corrected_legacy_unit | 2 |
| ap_statistics | APSTATS-MCQ-052 | provisional_model | two_model_corrected_legacy_unit | 2 |
| ap_statistics | APSTATS-MCQ-053 | provisional_model | two_model_corrected_legacy_unit | 2 |
| ap_statistics | APSTATS-MCQ-054 | provisional_model | two_model_corrected_legacy_unit | 2 |
| ap_statistics | APSTATS-MCQ-055 | held | model_unit_disagreement | - |
| ap_statistics | APSTATS-MCQ-056 | provisional_model | two_model_corrected_legacy_unit | 4 |
| ap_statistics | APSTATS-MCQ-057 | provisional_model | two_model_corrected_legacy_unit | 2 |
| ap_statistics | APSTATS-MCQ-058 | provisional_model | two_model_corrected_legacy_unit | 3 |
| ap_statistics | APSTATS-MCQ-059 | provisional_model | two_model_corrected_legacy_unit | 2 |
| ap_statistics | APSTATS-MCQ-060 | provisional_model | two_model_corrected_legacy_unit | 3 |
| ap_statistics | APSTATS-MCQ-061 | provisional_model | two_model_corrected_legacy_unit | 3 |
| ap_statistics | APSTATS-MCQ-062 | provisional_model | two_model_corrected_legacy_unit | 4 |
| ap_statistics | APSTATS-MCQ-063 | provisional_model | two_model_corrected_legacy_unit | 3 |
| ap_statistics | APSTATS-MCQ-064 | provisional_model | two_model_corrected_legacy_unit | 4 |
| ap_statistics | APSTATS-MCQ-065 | provisional_model | two_model_corrected_legacy_unit | 4 |
| ap_statistics | APSTATS-MCQ-066 | provisional_model | two_model_corrected_legacy_unit | 3 |
| ap_statistics | APSTATS-MCQ-067 | provisional_model | two_model_corrected_legacy_unit | 3 |
| ap_statistics | APSTATS-MCQ-068 | provisional_model | two_model_corrected_legacy_unit | 4 |
| ap_statistics | APSTATS-MCQ-069 | held | model_unit_disagreement | - |
| ap_statistics | APSTATS-MCQ-070 | provisional_model | two_model_corrected_legacy_unit | 4 |
| ap_statistics | APSTATS-MCQ-071 | provisional_model | two_model_corrected_legacy_unit | 3 |
| ap_statistics | APSTATS-MCQ-072 | provisional_model | two_model_corrected_legacy_unit | 4 |
| ap_statistics | APSTATS-MCQ-073 | provisional_model | two_model_corrected_legacy_unit | 2 |
| ap_statistics | APSTATS-MCQ-074 | provisional_model | two_model_corrected_legacy_unit | 2 |
| ap_statistics | APSTATS-MCQ-075 | held | other | - |
| ap_statistics | APSTATS-MCQ-076 | provisional_model | two_model_corrected_legacy_unit | 3 |
| ap_statistics | APSTATS-MCQ-078 | provisional_model | two_model_corrected_legacy_unit | 2 |
| ap_statistics | APSTATS-MCQ-079 | held | model_unit_disagreement | - |
| ap_statistics | APSTATS-MCQ-080 | provisional_model | two_model_corrected_legacy_unit | 3 |
| ap_statistics | APSTATS-MCQ-081 | provisional_model | two_model_corrected_legacy_unit | 2 |
| ap_statistics | APSTATS-MCQ-082 | provisional_model | two_model_corrected_legacy_unit | 5 |
| ap_statistics | APSTATS-MCQ-083 | provisional_model | two_model_corrected_legacy_unit | 5 |
| ap_statistics | APSTATS-MCQ-084 | provisional_model | two_model_corrected_legacy_unit | 5 |
| ap_statistics | APSTATS-MCQ-085 | provisional_model | two_model_corrected_legacy_unit | 5 |
| ap_statistics | APSTATS-MCQ-087 | provisional_model | two_model_corrected_legacy_unit | 5 |
| ap_statistics | APSTATS-MCQ-088 | held | other | - |
| ap_statistics | APSTATS-MCQ-090 | provisional_model | two_model_corrected_legacy_unit | 5 |
| ap_statistics | APSTATS-MCQ-091 | provisional_model | two_model_corrected_legacy_unit | 3, 4 |
| ap_statistics | APSTATS-MCQ-092 | provisional_model | two_model_corrected_legacy_unit | 3 |
| ap_statistics | APSTATS-MCQ-093 | provisional_model | two_model_corrected_legacy_unit | 4 |
| ap_statistics | APSTATS-MCQ-094 | held | other | - |
| ap_statistics | APSTATS-MCQ-095 | provisional_model | two_model_corrected_legacy_unit | 3 |
| ap_statistics | APSTATS-MCQ-096 | held | model_unit_disagreement | - |
| ap_statistics | APSTATS-MCQ-097 | held | model_unit_disagreement | - |
| ap_statistics | APSTATS-MCQ-098 | held | other | - |
| ap_statistics | APSTATS-MCQ-099 | provisional_model | two_model_corrected_legacy_unit | 3, 4 |
| ap_statistics | APSTATS-MCQ-100 | held | other | - |
| ap_statistics | APSTATS-SFRQ-003 | provisional_model | two_model_unit_agreement_no_usable_legacy | 5 |
| ap_statistics | APSTATS-SFRQ-010 | held | model_unit_disagreement | - |
| ap_statistics | STATS-MOD1-E002 | provisional_model | two_model_unit_agreement_no_usable_legacy | 1 |
| ap_statistics | STATS-MOD1-E003 | provisional_model | two_model_unit_agreement_no_usable_legacy | 1 |
| ap_statistics | STATS-MOD1-M001 | provisional_model | two_model_unit_agreement_no_usable_legacy | 1 |
| ap_statistics | STATS-MOD3-M007 | provisional_model | two_model_unit_agreement_no_usable_legacy | 2 |
| ap_statistics | STATS-MOD4-E005 | provisional_model | two_model_unit_agreement_no_usable_legacy | 1 |

Raw model outputs and SQL write file are stored under `/private/tmp/cramapple-math-taxonomy-serving/`.
