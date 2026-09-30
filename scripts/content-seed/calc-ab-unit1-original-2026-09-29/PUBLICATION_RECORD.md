# AP Calc AB Unit 1 batch: Production publication record (2026-09-30)

Executed on Production (`pcntajvbdfqhbeewmdry`) under the Product Owner's 2026-09-30 chat authorization
("Execute all with my permission as product owner"; human review waived for this batch).

| Step | Result |
|---|---|
| Load 136 drafts (14 atomic chunks) | 136/136 md5-exact vs. source (`load/verify_hashes.sql`), 0 letter/key inconsistencies |
| Title fix 017-v1 | "Continuous Calibration Curve on [-3, 4]" (DB and source) |
| Owner approval (`owner_remediation_approval`, tutor_score 1, note records the waiver) | 136 versions/items `reviewed_approved`; structural QA gate clean |
| Serving labels | 136 written as `provisional_model`, then promoted to `validated` (decision_source `automated_spot_check` for pipeline/inherited, `chat_review` for the 8 Unit 2 items), hash-fresh |
| Difficulty | 119 rows (`calibrated_judgement`); 17 held (no consensus) |
| Cells (`provisional_model`) | 126 topic cells, 62 skill cells (skill only where the (topic, skill) pair is registered; 48 wanted pairs unregistered, stayed topic-only); 10 items have no topic (held) |
| Publish | 136 versions and items `published`; no duplicate published versions |

Census after (Calc AB): published 255 (was 119), unit-gated 172 (was 36), targeted drill 64 (was 44),
full-exam FRQ 18 (unchanged), validated serving labels 174 (was 38). Selftest: no mismatches (only cap-skips).
Answer-key column grants for anon/authenticated on `mcq_choices` (`is_correct`, `rationale`): none.

Not yet done: DECISION/APPROVAL/ACTIVITY log entries; commit of this folder (branch `claude/task-0056-qa-brief`).
