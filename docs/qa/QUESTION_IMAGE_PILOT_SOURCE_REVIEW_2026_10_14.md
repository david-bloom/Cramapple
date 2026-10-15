# Question-image pilot — source review

**Status:** Preliminary source review complete; independent review and student-browser verification pending.
**Work:** `WORK-QUESTION-IMAGE-COMPLETENESS`, PR #455.
**Scope:** All 91 frozen Chemistry / Calculus AB candidates scoped to Units 1–4. The ten candidates with unresolved unit scope remain separate. Read-only Production inspection; no question classifications were written to the database.

## Result

Every candidate's stem, stimulus and choices was read, and the authored FRQ part prompts were checked where present. **86 have no missing prompt image identified, four need a visual-construct review, and one depends on a periodic-table reference whose delivery was not verified.** None was found to be missing question-specific numerical givens solely because an image was absent.

| Source classification | Calculus AB | Chemistry | Total |
| --- | ---: | ---: | ---: |
| Complete table or value list | 31 | 11 | 42 |
| Complete formula/relation | 37 | 1 | 38 |
| Complete verbal experiment/context | 0 | 1 | 1 |
| Requested/offered verbal Lewis-structure description | 0 | 3 | 3 |
| Select a description of the graph to produce | 0 | 2 | 2 |
| Visual task replaced by prose — review construct | 3 | 1 | 4 |
| Periodic-table reference delivery unverified | 0 | 1 | 1 |
| **Total** | **71** | **20** | **91** |

The two Chemistry graph-description MCQs supply all distance/energy data and ask students to choose a description of the resulting graph. A finished correct graph would disclose response content. These are not actual graph-drawing submission tasks; none of the 91 asks the student to submit a constructed graph. The Lewis-structure questions likewise ask for descriptions or electron counting, not an omitted input drawing.

`apchem-mcq-sv-035-v1` is a clear lexical false positive: the soda sits on a **table**, meaning furniture.

## Four representation concerns — proposed, not confirmed numerical defects

| Question | Source finding | Proposed prompt visual and limits |
| --- | --- | --- |
| `apcalcab-frq-u13-002` | A graph is fully specified with line segments and open/closed points; authored topic is “Estimating Limit Values from Graphs.” Existing database image decision says `no_not_needed`. | Draw exactly those segments and endpoints, with axes. Flag the conflict for curriculum review rather than silently overriding the existing image decision. Do not annotate the requested limits or discontinuity classifications. |
| `apcalcab-frq-u13g-1-3` | Topic 1.3; prose lists segments, isolated points and an asymptote. All queried limits are recoverable, but students read them in prose. | Draw the stated segments/points and two unbounded curve branches. Interior curve shapes are not uniquely specified: choose a reviewed illustrative interpolation preserving every stated endpoint, continuity and limit. Do not add solution annotations. |
| `apcalcab-oht-1.3` | Topic 1.3 teaching item: the line, filled point and quadratic branch are supplied as equations/prose, with no drawn graph. | Draw only the given branches/domains and open/closed endpoints. Keep the limit/inference in the worked answer, not in the prompt caption or alt. |
| `apchem-oht-3.8` | Teaching item says diagram 1 has eight particles in 100 mL and diagram 2 has sixteen in 200 mL; neither diagram is supplied. Numerical ratios are complete. | Draw two labelled solution containers with exactly 8 and 16 particles and the supplied volumes. Use comparable symbol sizes; do not let arbitrary container scaling assert a new physical relationship. Leave the concentration comparison to the answer. |

These are answerable authored questions. The recommendation is to restore visual interpretation where the intended topic/task calls for it, not to call them impossible to answer. An independent subject reviewer must determine whether each should become a visual repair or remain an intentional prose task.

## One reference dependency

`apchem-frq-u13g-1-8` explicitly instructs students to use the periodic table and justify with positions/valence electrons. No periodic-table asset is attached to the question. Check the actual approved reference surface before commissioning anything; a delivered shared periodic table may satisfy it. Do not classify it as a confirmed missing image on source inspection alone.

## Audit-query correction

The original inventory selected `frq_criteria.learner_facing_text` as `part_prompts`. In real legacy rows those fields contain scoring answers, such as calculated pressures, not question prompts. Its “no answer keys” comment was therefore too strong. This source review encountered those fields before discovering the problem and is **not a blind independent review**.

The query now takes only authored `parts[].prompt` / `prompt_text` strings from `prompt_json` or the item package and never uses FRQ criteria as prompts. The corrected query returned all 91 pinned versions; 16 have separate authored parts, while the other FRQs already carry their prompts in the stem. The saved per-question review uses corrected inputs only. The historical initial snapshot and its query digest/456-signal count remain evidence of the old query, not current clean-review counts.

## Evidence and next action

`scripts/image_readiness/question_image_pilot_review.json` records a classification, reason, exact version, content digest and the reviewed stem/stimulus/choices/authored parts for **each of the 91**. It contains no copied rubric/scoring criteria. This is one conductor's source review, not QA acceptance or a release verdict. Mathematical correctness of the item/key was not re-certified.

**Next owner:** independent subject reviewer / audit conductor. Adjudicate the four representation concerns, check periodic-table delivery, and verify tables/FRQ prompts on the actual student route. The ten unit-unresolved candidates need a separate scope determination. No images, schema changes, content writes or deployments have been performed.
