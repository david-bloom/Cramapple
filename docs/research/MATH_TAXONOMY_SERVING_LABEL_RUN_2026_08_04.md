# Math Taxonomy Serving Label Run - 2026-08-04

Production project: `pcntajvbdfqhbeewmdry`

Scope: serving labels only. This run wrote `required_units`, `primary_unit`, and
derived `max_required_unit` for model-agreed items. It did not write
`assessed_topics`, and it did not write any `validated` labels.

Models: `openai/gpt-5.5` and `google/gemini-2.5-flash` through Vercel AI
Gateway.

Run IDs:

- `math-serving-units-2026-08-04-20260804211015` - Calc AB/BC full pass and
  initial Precalculus pass.
- `math-serving-units-2026-08-04-20260804211958` - corrected Precalculus rerun;
  superseded the earlier Precalculus model-call-failure holds.

## Registry

`extend_math_taxonomy_registries` applied as Production migration
`20260804205322`. It corrected the topic-code regex and seeded verified CED
topic registries:

| Subject | Topics | Unit range | Confidence |
| --- | ---: | --- | --- |
| AP Calculus AB | 85 | 1-8 | verified |
| AP Calculus BC | 111 | 1-10 | verified |
| AP Precalculus | 44 | 1-3 | verified |

AB uses the shared AB/BC CED source but excludes Units 9-10 and BC-only Topics
6.12 and 6.13. Precalculus Unit 4 remains course content only and is not seeded
as an assessed topic registry row.

## Active Serving Labels

Target set: latest `published` or `reviewed_approved` items in AP Calculus AB,
AP Calculus BC, and AP Precalculus.

| Subject | Target items | Provisional model | Held |
| --- | ---: | ---: | ---: |
| AP Calculus AB | 44 | 28 | 16 |
| AP Calculus BC | 36 | 21 | 15 |
| AP Precalculus | 78 | 68 | 10 |
| Total | 158 | 117 | 41 |

No active target item has `label_status='validated'`. All target items now have
an active serving label that is either `provisional_model` or `held`.

## Provisional Distribution

| Subject | Max required unit | Count |
| --- | ---: | ---: |
| AP Calculus AB | 1 | 11 |
| AP Calculus AB | 2 | 5 |
| AP Calculus AB | 3 | 3 |
| AP Calculus AB | 5 | 4 |
| AP Calculus AB | 6 | 1 |
| AP Calculus AB | 8 | 4 |
| AP Calculus BC | 1 | 4 |
| AP Calculus BC | 2 | 2 |
| AP Calculus BC | 3 | 4 |
| AP Calculus BC | 5 | 2 |
| AP Calculus BC | 6 | 3 |
| AP Calculus BC | 8 | 2 |
| AP Calculus BC | 10 | 4 |
| AP Precalculus | 1 | 23 |
| AP Precalculus | 2 | 24 |
| AP Precalculus | 3 | 21 |

## Held Reasons

| Subject | Reason | Count |
| --- | --- | ---: |
| AP Calculus AB | `model_unit_disagreement` | 14 |
| AP Calculus AB | `empty_required_units` | 1 |
| AP Calculus AB | `rubric_preflight_failure` | 1 |
| AP Calculus BC | `model_unit_disagreement` | 8 |
| AP Calculus BC | `empty_required_units` | 5 |
| AP Calculus BC | `other` | 1 |
| AP Calculus BC | `rubric_preflight_failure` | 1 |
| AP Precalculus | `model_unit_disagreement` | 5 |
| AP Precalculus | `rubric_preflight_failure` | 3 |
| AP Precalculus | `empty_required_units` | 1 |
| AP Precalculus | `other` | 1 |

## Held Items

| Subject | Content key | Reason |
| --- | --- | --- |
| AP Calculus AB | `apcalcab-frq-002` | `model_unit_disagreement` |
| AP Calculus AB | `apcalcab-frq-006` | `rubric_preflight_failure` |
| AP Calculus AB | `apcalcab-frq-027` | `model_unit_disagreement` |
| AP Calculus AB | `apcalcab-frq-u13-003` | `model_unit_disagreement` |
| AP Calculus AB | `apcalcab-frq-u13-007` | `model_unit_disagreement` |
| AP Calculus AB | `apcalcab-frq-u13-009` | `model_unit_disagreement` |
| AP Calculus AB | `apcalcab-frq-u13-013` | `model_unit_disagreement` |
| AP Calculus AB | `apcalcab-frq-u13-014` | `model_unit_disagreement` |
| AP Calculus AB | `apcalcab-frq-u13-016` | `model_unit_disagreement` |
| AP Calculus AB | `apcalcab-mcq-003` | `model_unit_disagreement` |
| AP Calculus AB | `apcalcab-mcq-009` | `model_unit_disagreement` |
| AP Calculus AB | `apcalcab-mcq-010` | `model_unit_disagreement` |
| AP Calculus AB | `apcalcab-mcq-013` | `model_unit_disagreement` |
| AP Calculus AB | `apcalcab-mcq-014` | `model_unit_disagreement` |
| AP Calculus AB | `apcalcab-mcq-015` | `empty_required_units` |
| AP Calculus AB | `apcalcab-mcq-018` | `model_unit_disagreement` |
| AP Calculus BC | `apcalcbc-frq-001` | `model_unit_disagreement` |
| AP Calculus BC | `apcalcbc-frq-018` | `model_unit_disagreement` |
| AP Calculus BC | `apcalcbc-frq-020` | `model_unit_disagreement` |
| AP Calculus BC | `apcalcbc-frq-027` | `other` |
| AP Calculus BC | `apcalcbc-frq-029` | `model_unit_disagreement` |
| AP Calculus BC | `apcalcbc-frq-033` | `rubric_preflight_failure` |
| AP Calculus BC | `apcalcbc-frq-034` | `model_unit_disagreement` |
| AP Calculus BC | `apcalcbc-frq-u13-004` | `empty_required_units` |
| AP Calculus BC | `apcalcbc-frq-u13-007` | `empty_required_units` |
| AP Calculus BC | `apcalcbc-frq-u13-014` | `empty_required_units` |
| AP Calculus BC | `apcalcbc-frq-u13-016` | `empty_required_units` |
| AP Calculus BC | `apcalcbc-mcq-001` | `model_unit_disagreement` |
| AP Calculus BC | `apcalcbc-mcq-003` | `empty_required_units` |
| AP Calculus BC | `apcalcbc-mcq-022` | `model_unit_disagreement` |
| AP Calculus BC | `apcalcbc-mcq-025` | `model_unit_disagreement` |
| AP Precalculus | `apprecalc-frq-006` | `other` |
| AP Precalculus | `apprecalc-frq-014` | `model_unit_disagreement` |
| AP Precalculus | `apprecalc-frq-020` | `model_unit_disagreement` |
| AP Precalculus | `apprecalc-frq-024` | `empty_required_units` |
| AP Precalculus | `apprecalc-frq-027` | `rubric_preflight_failure` |
| AP Precalculus | `apprecalc-frq-029` | `rubric_preflight_failure` |
| AP Precalculus | `apprecalc-frq-030` | `model_unit_disagreement` |
| AP Precalculus | `apprecalc-frq-031` | `rubric_preflight_failure` |
| AP Precalculus | `apprecalc-mcq-014` | `model_unit_disagreement` |
| AP Precalculus | `apprecalc-mcq-027` | `model_unit_disagreement` |

## Remainder

Legacy unvalidated serving labels remain active only outside the target set:
47 AP Calculus AB items, 39 AP Calculus BC items, and 28 AP Precalculus items.
They were not included because their latest content item/version status was not
`published` or `reviewed_approved`.

All model outputs and SQL write files are in
`/private/tmp/cramapple-math-taxonomy-serving/` for this local run.
