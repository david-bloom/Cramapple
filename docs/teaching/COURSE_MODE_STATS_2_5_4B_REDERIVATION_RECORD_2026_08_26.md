# Course Mode AP Statistics 2.5 x 4.B Re-Derivation Record

Date: 2026-08-26  
Branch: `content/course-mode-stats-2.5-4b`  
Frame: `FB-U2-5-4B-MUTUALLY-EXCLUSIVE-01` / `slotframe_u2_5_mutually_exclusive`  
Cell: Unit 2 topic 2.5, skill 4.B  
Track: B conceptual MCQ

## Gate 1 Property Harness

Final `python3 scripts/course_mode_stats_generator/slot_frames.py` result for this frame:

- instances: 120
- checks: 1800
- failures: 0
- distinct prompts: 8
- correct answer positions: `[0, 1, 2, 3]`
- `correct_answer_position_varies`: true
- full Track B meta-tests: all green, including misconception catalog self-check, scenario catalog self-check, and expected-tag coverage

Required companion checks also passed:

- `python3 scripts/course_mode_stats_generator/generator.py`: PASS, 880 instances / 13040 checks / 0 rejects
- `python3 scripts/course_mode_stats_generator/scenarios.py`: ok true; `u2_5_mutually_exclusive` context bank has 8 contexts
- `python3 scripts/course_mode_stats_generator/misconceptions.py`: ok true; four `slotframe_u2_5_mutually_exclusive` tags present
- `python3 scripts/course_mode_stats_generator/build_load_sql.py --check`: validated 220 packages, 0 problems
- `python3 scripts/course_mode_stats_generator/build_load_sql.py`: regenerated DRAFT SQL only

The 20 emitted review packages cover both relationships (`mutually_exclusive` and `overlap`), all four Unit 2.5 misconception tags, and all four correct-answer positions.

## Gate 2 Independent Re-Derivation

Definition used: Two events are mutually exclusive if no single outcome in the one trial can satisfy both event definitions. If at least one outcome can satisfy both, the events overlap and are not mutually exclusive.

### Emitted Instance `slotframe-u2_5-4b-022500`

Prompt summary: One card is selected from a standard deck. Event A: the card is a face card. Event B: the card is a heart.

Independent key derivation: A heart can also be a face card. For example, the jack of hearts, queen of hearts, and king of hearts each satisfy both A and B on the same selected card. Therefore the events are not mutually exclusive. This matches the emitted key.

Distractor checks:

- `u2_5__different_labels_mean_disjoint`: says the events are mutually exclusive because the descriptions use different labels. This is the documented wrong rule: label difference is substituted for checking shared outcomes. It is wrong here because face-card hearts exist.
- `u2_5__overlap_wording_ignored`: says the events are mutually exclusive because the event names are stated separately. This ignores the explicit shared outcomes. It is wrong here because jack/queen/king of hearts satisfy both events.
- `u2_5__same_trial_condition_missed`: says not mutually exclusive because the events can occur on different repetitions. The conclusion happens to match this overlap instance, but the justification is invalid for 4.B because mutual exclusivity is judged within one selected card, not across repeated selections.

### Emitted Instance `slotframe-u2_5-4b-022501`

Prompt summary: One fair six-sided die is rolled. Event A: the result is even. Event B: the result is odd.

Independent key derivation: The sample space is {1, 2, 3, 4, 5, 6}. Event A = {2, 4, 6}; Event B = {1, 3, 5}. The intersection is empty, so one die result cannot be both even and odd. Therefore the events are mutually exclusive. This matches the emitted key.

Distractor checks:

- `u2_5__same_trial_condition_missed`: says the events are not mutually exclusive because one could occur on one repetition and the other on another repetition. This uses repeated trials instead of the one-roll trial, so it is the named same-trial misconception.
- `u2_5__different_labels_mean_disjoint`: says the events are mutually exclusive because the descriptions use different labels. The conclusion matches here, but the justification is not sufficient: the valid reason is the empty intersection, not different wording.
- `u2_5__uses_independent_for_disjoint`: calls the events independent because Event A occurring prevents Event B. This confuses disjointness with independence; for nonempty events, prevention is mutual exclusivity, not independence.

## Gate 3 CED Conformance and Rights

The cell is valid in `cells.py`: topic `2.5` has skill `4.B`. The item demands a justification from event relationships, matching Practice 4.B and Unit 2.5 mutually exclusive events. All scenarios are original synthetic contexts. No College Board item wording, keys, or scoring language was used.

## Gate 4 Distractor Realism

Each distractor represents a plausible student error for the specific event pair: confusing mutually exclusive with independent, deciding from labels instead of shared outcomes, ignoring explicit overlap, or reasoning across repeated trials instead of the single trial. Every distractor tag is cell-namespaced and cited in `misconceptions.py`.

## Release Boundary

No loader application, database write, release RPC, serving switch, frontend/router/engine change, Edge deploy, Dev mutation, or Prod mutation was performed. The generated SQL remains DRAFT only.
