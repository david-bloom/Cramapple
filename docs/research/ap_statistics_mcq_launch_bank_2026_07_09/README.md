# AP Statistics MCQ Launch Bank - 2026-07-09

**Purpose:** 100-item AP Statistics MCQ bank for launch-bar calibration.
**Schema:** Matches `supabase/functions/_shared/grading-router.ts`'s `mcq` / `rule_based_mcq` path: `content_key`, `subject`, `item_type`, `modules`, `subtopics`, `intended_difficulty`, `stimulus`, `stem`, and `choices[]` with exactly one `is_correct: true`.

## Composition

- Existing live items reused as-is: 18
- Net-new authored items: 82
- Total items: 100

## Module distribution

| Module | Count |
| --- | ---: |
| 1 | 11 |
| 2 | 11 |
| 3 | 11 |
| 4 | 11 |
| 5 | 11 |
| 6 | 11 |
| 7 | 11 |
| 8 | 11 |
| 9 | 12 |

## Difficulty distribution

| Difficulty | Count |
| --- | ---: |
| Medium | 43 |
| Hard | 42 |
| Easy | 12 |
| Very Hard | 3 |

## Validation

- 100/100 items have exactly 4 choices.
- 100/100 items have exactly 1 correct answer key.
- Existing 18 items were reused unchanged from the published 2026-07-01 smoke batch.
- The 82 new items were authored to stay balanced across modules 1-9 and to exercise common AP Statistics misconceptions without using hand-drawn or image stems.

## Notes

This bank is development/calibration content, not the human-authored launch pilot batch. It is meant to exercise the deterministic MCQ grading path and the surrounding content workflow.
