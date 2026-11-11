# APPROVAL-0216 — AP Statistics Units 2 to 4 serving-label audit: 2 held labels validated (granted and executed 2026-11-11)

- **Status:** Granted by David in chat ("Evaluate and fix any problems with serving labels in unit 2-4", 2026-11-11) and executed.
- **Tier:** Production label write on live questions.

## Method
Read-only audit of every published AP Statistics item whose primary topic is in Units 2 to 4 (Production `pcntajvbdfqhbeewmdry`, pack `548f06be-ccf4-426d-b82b-b424137a4438`): serving label present, validated, hash current, and required units / primary unit / max unit consistent with the topic. The student selector `public.select_student_practice_items` serves only items with a validated serving label whose `validated_against_taxo_hash` is current and whose `max_required_unit` is at or below the student's unit, and it skips teaching items (`app.content_item_is_teaching`).

## Findings
- **Units 2 and 3 MCQs: clean.** Every non-teaching published MCQ has a validated, current label matching its topic unit.
- **OHT items (about 21 in Units 2 and 3) have no serving label by design:** they are teaching items, excluded from practice, so no fix.
- **Multi-unit FRQ labels (for example `{1,3}`, `{2,4}`) are correct:** required units list the prerequisite units; max and primary unit equal the topic unit.
- **`required_units` is the set of units needed to answer, not the topic's unit.** Several Unit 4 items carry `{2}` or `{3}` for that reason (057 and 059 on the CLT, 058 a proportion item filed under a means topic). Those are not label defects; 058's defect is its topic cell, and all of these are retired in the Unit 4 package (not part of this approval).
- **Two live, non-teaching Unit 4 items were held and therefore never served:** `APSTATS-MCQ-079` (SE = σ/√n, solve for n) and `APSTATS-SFRQ-010` (sampling distribution of x-bar, FRQ). The 2026-09-25 two-model run held both on a Unit 2 versus Unit 4 disagreement (topics 2.12 and 4.1).
- **Left unresolved (not touched):** `APSTAT-MOD7-H002-INV` (3.15 FRQ) has a provisional label `{1,2,3}` and is not served. TASK-0049 (2026-09-28) deliberately excluded it: the review proposed `[2,3]` but its own stored criterion evidence cites Unit 1, so the units need a real re-examination. `APSTATS-MCQ-010-CAL` and `APSTATS-MCQ-009` are teaching items; 009's `{2}` label (consensus topic 2.12) is not served on the practice path, so left as is.

## Change
Both held labels updated in place to validated, `required_units {4}`, `primary_unit 4`, `max_required_unit 4`, with a `corrected` validation decision (`chat_review`) and the current taxonomy hash. Choice of Unit 4: matches their validated primary topic 4.1 and is the conservative option, since they are served only once a student reaches Unit 4. Pattern follows TASK-0049 batch B.
- Rehearsal in a rolled-back transaction passed; the real selector returned both items for a Unit 4 student.
- Re-verified after the write by an independent query: both validated, `{4}`, hash current.
- Scripts: `scripts/content-seed/ap-statistics-serving-label-fixes-2026-11-11/`.

## Not done
No live student session was run. Whether 079 and SFRQ-010 belong at Unit 2 instead is a judgement call; it is a one-row change each if you disagree. The MOD7-H002-INV question is open.
