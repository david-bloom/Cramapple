# Codex — Five-Subject Content Authoring (180 items)

**Prepared:** 2026-07-15
**Related:** `TASK-0014` (Chemistry), `TASK-0015` (Physics), `DECISION-0031`/`0033` (no CB material), `DECISION-0036` (AI-led authoring)

## Goal

Author original practice content for five AP subjects — **20 MCQ + 16 FRQ per subject = 180 items total** — to seed tutor review batches. Each item must conform to the `item-package.schema.json` (v1.0.0) and be grounded in the corresponding CED fact pack.

## Input documents (read all before authoring)

For each subject, read:
1. The CED fact pack in `docs/product/` (unit/topic map, exam structure, science practices, FRQ archetypes, grading characteristics)
2. `schemas/subject-onboarding/item-package.schema.json` (the output schema)
3. `docs/architecture/CONTENT_GOVERNANCE_AND_VALIDATION.md` (governance rules)

| Subject | Fact pack | Content key prefix |
|---|---|---|
| AP Chemistry | `AP_CHEMISTRY_CED_FACT_PACK.md` | `APCHEM-MCQ-*`, `APCHEM-FRQ-*` |
| AP Physics 1 | `AP_PHYSICS_1_CED_FACT_PACK.md` | `APPHY1-MCQ-*`, `APPHY1-FRQ-*` |
| AP Physics 2 | `AP_PHYSICS_2_CED_FACT_PACK.md` | `APPHY2-MCQ-*`, `APPHY2-FRQ-*` |
| AP Physics C: Mechanics | `AP_PHYSICS_C_MECHANICS_CED_FACT_PACK.md` | `APPHYCM-MCQ-*`, `APPHYCM-FRQ-*` |
| AP Physics C: E&M | `AP_PHYSICS_C_EM_CED_FACT_PACK.md` | `APPHYCEM-MCQ-*`, `APPHYCEM-FRQ-*` |

## Output structure

Write each item as a JSON file under `content/item-packages/{subject_key}/`:

```
content/item-packages/ap-chemistry/apchem-mcq-001.json
content/item-packages/ap-chemistry/apchem-frq-001.json
...
content/item-packages/ap-physics-1/apphy1-mcq-001.json
...
```

Each file must validate against `schemas/subject-onboarding/item-package.schema.json`.

## Per-subject authoring spec

### MCQ (20 per subject)

Each MCQ item package:
- `item_type`: `"mcq"`
- `parts`: exactly 1 part with `response_modalities: ["choice"]`
- `criteria`: exactly 1 criterion with `check_type: "choice-key"` and the correct answer as the `parameters.correct_key` (e.g. `"C"`)
- `parts[0].prompt`: the question stem including 4 answer choices labeled A–D
- Distribute across units proportional to exam weight (heavier-weighted units get more items)
- Spread difficulty: ~5 Easy, ~8 Medium, ~5 Hard, ~2 Very Hard
- Each MCQ must have an unambiguous single correct answer

### FRQ (16 per subject)

Each FRQ item package:
- `item_type`: `"frq"`
- `parts`: 2–6 parts depending on item length
- For **Chemistry**: author 6 long FRQ (matching the 3-long exam pattern, ~4 parts each) + 10 short FRQ (~2 parts each)
- For **Physics 1/2**: author 4 items per FRQ type (Mathematical Routines, Translation Between Representations, Experimental Design, Qualitative/Quantitative Translation)
- For **Physics C: Mechanics**: same 4 FRQ types but with calculus-level math (integrals, derivatives, differential equations)
- For **Physics C: E&M**: same 4 FRQ types with E&M-specific calculus (Gauss's law, Biot-Savart, RC/LR/LC circuits)
- Each part must have at least 1 criterion with `description` and `required_evidence`
- Include `deterministic_checks` where applicable:
  - `numeric-tolerance` for calculation answers (with `expected_value`, `tolerance`, `unit`)
  - `expression-equivalence` for symbolic/algebraic answers
  - `keyword-evidence` for explanation parts (key terms that must appear)
  - `choice-key` for any embedded multiple-choice sub-parts

### Canonical answers

Every item must have clear canonical answers embedded in the criteria:
- MCQ: correct choice key in `deterministic_checks.parameters.correct_key`
- FRQ calculation parts: expected numeric value in `deterministic_checks.parameters.expected_value`
- FRQ symbolic parts: expected expression in `deterministic_checks.parameters.expected_expression`
- FRQ explanation parts: required evidence keywords in `criterion.required_evidence`

## Quality rules

1. **Original content only.** Do not copy or paraphrase College Board questions, scoring guidelines, or released exam content. Every stem, scenario, and answer key must be independently constructed.
2. **Scientifically/physically correct.** Every answer key must be unambiguously correct. Every distractor must be clearly wrong.
3. **Self-contained.** Each item must include all information needed to solve it — no external references, no "as discussed in class."
4. **Unit coverage.** Distribute items across all units, weighted by exam weighting. No unit should have zero items.
5. **Skill coverage.** Include items targeting each science practice (calculation, representation, argumentation, experimental design).
6. **Difficulty spread.** Mix Easy/Medium/Hard/Very Hard within each subject.
7. **Boundary cases.** Include at least 2 items per subject that test grading edge cases: partial credit boundaries, common misconceptions, notation sensitivity, unit/sig-fig issues.
8. **Physics C must be calculus-level.** Physics C: Mechanics items must not be solvable with algebra alone — they must genuinely require derivatives, integrals, or differential equations. Physics C: E&M items must require vector calculus or transient circuit analysis.
9. **Physics 2 must not duplicate Physics 1.** Where topics overlap conceptually (circuits, forces), Physics 2 items must be at the Physics 2 level and scope.

## Item package field reference

```json
{
  "schema_version": "1.0.0",
  "package_id": "apchem-mcq-001",
  "content_key": "apchem-mcq-001",
  "content_version": 1,
  "exam_pack_ref": {
    "exam_code": "ap_chemistry",
    "school_year": "2025-26",
    "exam_pack_version": "1.0.0"
  },
  "item_type": "mcq",
  "archetype_ref": {
    "archetype_key": "ap-chemistry-mcq",
    "version": "1.0.0"
  },
  "taxonomy_refs": [
    {
      "scheme_key": "ap-chemistry-2025-26",
      "scheme_version": "1.0.0",
      "node_key": "topic-1-1-moles-and-molar-mass"
    }
  ],
  "stimuli": [],
  "parts": [
    {
      "part_key": "q1",
      "ordinal": 1,
      "prompt": "A sample of pure iron (Fe, molar mass 55.85 g/mol) has a mass of 27.93 g. How many moles of iron are in the sample?\n\nA. 0.250 mol\nB. 0.500 mol\nC. 1.00 mol\nD. 2.00 mol",
      "response_modalities": ["choice"],
      "points": 1,
      "criteria": [
        {
          "criterion_key": "correct-answer",
          "points": 1,
          "description": "Select the correct number of moles",
          "required_evidence": ["0.500"],
          "deterministic_checks": [
            {
              "check_type": "choice-key",
              "parameters": {"correct_key": "B"}
            }
          ]
        }
      ]
    }
  ],
  "accessibility": {
    "language": "en",
    "screen_reader_review_required": false,
    "accommodation_notes": ""
  },
  "provenance": {
    "source_refs": ["cramapple-original"],
    "fact_pack_version": "2026-07-15",
    "authoring_prompt_version": "CODEX_FIVE_SUBJECT_CONTENT_AUTHORING_2026_07_15",
    "generated_by": "codex",
    "generated_at": "2026-07-15T00:00:00Z",
    "content_sha256": "TO_BE_COMPUTED"
  }
}
```

## Taxonomy node_key conventions

Derive `node_key` slugs from the topic number and a short name:
- Chemistry: `topic-1-1-moles-and-molar-mass`, `topic-3-4-ideal-gas-law`, `unit-8-acids-and-bases`
- Physics 1: `topic-1-1-scalars-and-vectors`, `topic-2-5-newtons-second-law`, `unit-8-fluids`
- Physics 2: `topic-9-1-kinetic-theory`, `topic-11-8-rc-circuits`, `unit-15-modern-physics`
- Physics C: Mech: `topic-1-1-scalars-and-vectors`, `topic-7-5-physical-pendulums`
- Physics C: E&M: `topic-8-6-gausss-law`, `topic-13-5-lr-circuits`

The subject package (authored separately) will define the exact node keys. Use these conventions so they match.

## Archetype keys

| Subject | MCQ archetype | FRQ archetype(s) |
|---|---|---|
| AP Chemistry | `ap-chemistry-mcq` | `ap-chemistry-frq-long`, `ap-chemistry-frq-short` |
| AP Physics 1 | `ap-physics-1-mcq` | `ap-physics-1-frq-math`, `ap-physics-1-frq-representation`, `ap-physics-1-frq-experimental`, `ap-physics-1-frq-translation` |
| AP Physics 2 | `ap-physics-2-mcq` | `ap-physics-2-frq-math`, `ap-physics-2-frq-representation`, `ap-physics-2-frq-experimental`, `ap-physics-2-frq-translation` |
| AP Physics C: Mech | `ap-physics-c-mechanics-mcq` | `ap-physics-c-mechanics-frq-math`, `ap-physics-c-mechanics-frq-representation`, `ap-physics-c-mechanics-frq-experimental`, `ap-physics-c-mechanics-frq-translation` |
| AP Physics C: E&M | `ap-physics-c-em-mcq` | `ap-physics-c-em-frq-math`, `ap-physics-c-em-frq-representation`, `ap-physics-c-em-frq-experimental`, `ap-physics-c-em-frq-translation` |

## Commit and branch

Write all item packages to `content/item-packages/` on the same branch as the harness work (`codex/five-subject-harness-and-content`). Commit per subject (5 commits). Reference TASK-0014 / TASK-0015.

## Validation

After authoring each subject's items:
1. Validate every JSON file against `item-package.schema.json`.
2. Confirm content_key uniqueness across all items.
3. Confirm unit coverage: every unit in the fact pack has at least 1 item.
4. Confirm difficulty spread: no more than 40% of items at any single difficulty level.
5. Report any items where the canonical answer is ambiguous or the deterministic check is not feasible.
