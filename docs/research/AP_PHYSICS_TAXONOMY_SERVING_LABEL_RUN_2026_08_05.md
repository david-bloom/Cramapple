# AP Physics Taxonomy Serving Label Run - 2026-08-05

Production project: `pcntajvbdfqhbeewmdry`

Scope: published latest items for all four AP Physics subjects. This run wrote
serving labels only (`required_units`, `primary_unit`, derived
`max_required_unit`). Topic coverage (`assessed_topics`) was deferred and
remains empty for this run.

Fact packs used:

- `docs/product/AP_PHYSICS_1_CED_FACT_PACK.md`
- `docs/product/AP_PHYSICS_2_CED_FACT_PACK.md`
- `docs/product/AP_PHYSICS_C_MECHANICS_CED_FACT_PACK.md`
- `docs/product/AP_PHYSICS_C_EM_CED_FACT_PACK.md`

All four fact packs are marked primary-source verified and mirrored into this
repo on 2026-08-03. They supersede older Physics unit maps. Key boundaries:
Physics 1 has Units 1-8 and includes Fluids as Unit 8; Physics 2 has Units
9-15 and excludes Fluids; Physics C: Mechanics has Units 1-7 with
gravitation/orbital content in Unit 6; Physics C: E&M has Units 8-13.

Models: `openai/gpt-5.5` and `google/gemini-2.5-flash` through Vercel AI
Gateway.

Validation rule: no `validated` labels were written. Two-model agreement writes
`provisional_model`; model disagreement, empty unit output, rubric preflight
failure, or model/schema irregularity writes `held`.

Physics-specific lane: confirm-or-correct against active legacy serving labels
when a usable legacy unit set exists. In this target set, no published item had
a usable legacy unit set, so the run behaved as cold serving-unit labeling from
the verified Physics fact packs.

## Summary

| Subject | Target items | Provisional model | Held |
| --- | ---: | ---: | ---: |
| AP Physics 1 | 19 | 17 | 2 |
| AP Physics 2 | 16 | 15 | 1 |
| AP Physics C: Mechanics | 10 | 9 | 1 |
| AP Physics C: E&M | 8 | 8 | 0 |
| Total | 53 | 49 | 4 |

Live Production census after write:

| Label census | Count |
| --- | ---: |
| Active serving labels on published Physics targets | 53 |
| Two-model agreed unit labels | 49 |
| Held labels | 4 |
| Topic labels written | 0 |
| Validated labels written | 0 |
| Usable legacy unit sets before run | 0 |

## Outcome Reasons

- two_model_unit_agreement_no_usable_legacy: 49
- model_unit_disagreement: 4

## Item Outcomes

| Subject | Content key | Status | Reason | Required units |
| --- | --- | --- | --- | --- |
| ap_physics_1 | apphy1-frq-001 | provisional_model | two_model_unit_agreement_no_usable_legacy | 1 |
| ap_physics_1 | apphy1-frq-002 | provisional_model | two_model_unit_agreement_no_usable_legacy | 2 |
| ap_physics_1 | apphy1-frq-003 | provisional_model | two_model_unit_agreement_no_usable_legacy | 3 |
| ap_physics_1 | apphy1-frq-004 | provisional_model | two_model_unit_agreement_no_usable_legacy | 3, 4 |
| ap_physics_1 | apphy1-frq-009 | held | model_unit_disagreement | - |
| ap_physics_1 | apphy1-frq-013 | provisional_model | two_model_unit_agreement_no_usable_legacy | 5 |
| ap_physics_1 | apphy1-frq-025 | provisional_model | two_model_unit_agreement_no_usable_legacy | 3 |
| ap_physics_1 | apphy1-frq-028 | held | model_unit_disagreement | - |
| ap_physics_1 | apphy1-frq-034 | provisional_model | two_model_unit_agreement_no_usable_legacy | 7 |
| ap_physics_1 | apphy1-mcq-001 | provisional_model | two_model_unit_agreement_no_usable_legacy | 1 |
| ap_physics_1 | apphy1-mcq-003 | provisional_model | two_model_unit_agreement_no_usable_legacy | 2 |
| ap_physics_1 | apphy1-mcq-004 | provisional_model | two_model_unit_agreement_no_usable_legacy | 2 |
| ap_physics_1 | apphy1-mcq-006 | provisional_model | two_model_unit_agreement_no_usable_legacy | 3 |
| ap_physics_1 | apphy1-mcq-007 | provisional_model | two_model_unit_agreement_no_usable_legacy | 3 |
| ap_physics_1 | apphy1-mcq-008 | provisional_model | two_model_unit_agreement_no_usable_legacy | 3 |
| ap_physics_1 | apphy1-mcq-010 | provisional_model | two_model_unit_agreement_no_usable_legacy | 4 |
| ap_physics_1 | apphy1-mcq-011 | provisional_model | two_model_unit_agreement_no_usable_legacy | 5 |
| ap_physics_1 | apphy1-mcq-015 | provisional_model | two_model_unit_agreement_no_usable_legacy | 7 |
| ap_physics_1 | apphy1-mcq-016 | provisional_model | two_model_unit_agreement_no_usable_legacy | 7 |
| ap_physics_2 | apphy2-frq-001 | provisional_model | two_model_unit_agreement_no_usable_legacy | 9 |
| ap_physics_2 | apphy2-frq-006 | provisional_model | two_model_unit_agreement_no_usable_legacy | 14 |
| ap_physics_2 | apphy2-frq-009 | provisional_model | two_model_unit_agreement_no_usable_legacy | 10 |
| ap_physics_2 | apphy2-frq-016 | provisional_model | two_model_unit_agreement_no_usable_legacy | 10 |
| ap_physics_2 | apphy2-frq-017 | provisional_model | two_model_unit_agreement_no_usable_legacy | 9 |
| ap_physics_2 | apphy2-frq-018 | provisional_model | two_model_unit_agreement_no_usable_legacy | 9 |
| ap_physics_2 | apphy2-frq-024 | provisional_model | two_model_unit_agreement_no_usable_legacy | 11 |
| ap_physics_2 | apphy2-frq-026 | provisional_model | two_model_unit_agreement_no_usable_legacy | 12 |
| ap_physics_2 | apphy2-frq-027 | provisional_model | two_model_unit_agreement_no_usable_legacy | 12 |
| ap_physics_2 | apphy2-frq-030 | provisional_model | two_model_unit_agreement_no_usable_legacy | 14 |
| ap_physics_2 | apphy2-frq-033 | provisional_model | two_model_unit_agreement_no_usable_legacy | 15 |
| ap_physics_2 | apphy2-mcq-001 | provisional_model | two_model_unit_agreement_no_usable_legacy | 9 |
| ap_physics_2 | apphy2-mcq-006 | provisional_model | two_model_unit_agreement_no_usable_legacy | 10 |
| ap_physics_2 | apphy2-mcq-009 | held | model_unit_disagreement | - |
| ap_physics_2 | apphy2-mcq-011 | provisional_model | two_model_unit_agreement_no_usable_legacy | 12 |
| ap_physics_2 | apphy2-mcq-018 | provisional_model | two_model_unit_agreement_no_usable_legacy | 14 |
| ap_physics_c_mechanics | apphycm-frq-001 | provisional_model | two_model_unit_agreement_no_usable_legacy | 1 |
| ap_physics_c_mechanics | apphycm-frq-002 | held | model_unit_disagreement | - |
| ap_physics_c_mechanics | apphycm-frq-006 | provisional_model | two_model_unit_agreement_no_usable_legacy | 5 |
| ap_physics_c_mechanics | apphycm-frq-014 | provisional_model | two_model_unit_agreement_no_usable_legacy | 5, 7 |
| ap_physics_c_mechanics | apphycm-frq-019 | provisional_model | two_model_unit_agreement_no_usable_legacy | 2 |
| ap_physics_c_mechanics | apphycm-frq-021 | provisional_model | two_model_unit_agreement_no_usable_legacy | 2 |
| ap_physics_c_mechanics | apphycm-frq-023 | provisional_model | two_model_unit_agreement_no_usable_legacy | 1, 2, 3 |
| ap_physics_c_mechanics | apphycm-frq-028 | provisional_model | two_model_unit_agreement_no_usable_legacy | 2, 5 |
| ap_physics_c_mechanics | apphycm-mcq-001 | provisional_model | two_model_unit_agreement_no_usable_legacy | 1 |
| ap_physics_c_mechanics | apphycm-mcq-004 | provisional_model | two_model_unit_agreement_no_usable_legacy | 2 |
| ap_physics_c_em | apphycem-frq-001 | provisional_model | two_model_unit_agreement_no_usable_legacy | 8 |
| ap_physics_c_em | apphycem-frq-002 | provisional_model | two_model_unit_agreement_no_usable_legacy | 9 |
| ap_physics_c_em | apphycem-frq-003 | provisional_model | two_model_unit_agreement_no_usable_legacy | 10 |
| ap_physics_c_em | apphycem-frq-007 | provisional_model | two_model_unit_agreement_no_usable_legacy | 8 |
| ap_physics_c_em | apphycem-frq-019 | provisional_model | two_model_unit_agreement_no_usable_legacy | 8 |
| ap_physics_c_em | apphycem-frq-024 | provisional_model | two_model_unit_agreement_no_usable_legacy | 8, 9, 10 |
| ap_physics_c_em | apphycem-frq-030 | provisional_model | two_model_unit_agreement_no_usable_legacy | 8, 12 |
| ap_physics_c_em | apphycem-mcq-001 | provisional_model | two_model_unit_agreement_no_usable_legacy | 8 |

Raw local run outputs are preserved at:

- `/private/tmp/cramapple-math-taxonomy-serving/model_results_ap_physics_1.json`
- `/private/tmp/cramapple-math-taxonomy-serving/model_results_ap_physics_2.json`
- `/private/tmp/cramapple-math-taxonomy-serving/model_results_ap_physics_c_mechanics.json`
- `/private/tmp/cramapple-math-taxonomy-serving/model_results_ap_physics_c_em.json`
