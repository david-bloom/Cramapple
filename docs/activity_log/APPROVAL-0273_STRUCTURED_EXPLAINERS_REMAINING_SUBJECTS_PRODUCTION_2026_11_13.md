# APPROVAL-0273 — Structured explainer text (recommendation #3) for six more subjects, applied to Production

- **Date:** 2026-11-13 (UTC).
- **Authorization:** David, in chat: "Approve all six", after being shown counts, checker results and rulings. Physics 2 and Physics C excluded by David.
- **What is written (Production, project `pcntajvbdfqhbeewmdry`):** four text fields (`core_idea`, `what_students_need_to_understand`, `how_this_becomes_points`, `point_attaining_answer`) reshaped into bullets, numbered steps and tables on 317 published rows in `app.topic_explainers`: Biology 6-8 (27), Chemistry 6-9 (43), Calculus AB (35; units 1, 6, 7, 8 skipped as one-idea text), Calculus BC 1-10 (111), Physics 1 (43), Precalculus (58). Text markers only, no schema change; `source_note` appended.
- **Guard:** each update matched only if the row still held the four-field md5 from the Production snapshot it was built on; a count check raises unless every row in the set carries the note. Applied one subject at a time with `--workdir /Users/davidbloom` (ref confirmed with `--debug`).
- **Evidence:** `scripts/content-seed/structured-explainers-rest-2026-11-13/` (current_*.json from Production, proposed_*.json, migration_*.sql, RULINGS.md, check_out/, readback.sql, expected_md5.json). Authored in session; two checker families over every topic with a planted control caught by both; 4 real defects fixed (Biology 7.2, 7.10; BC 5.11, 5.12) and rechecked clean; 11 separator-row findings ruled non-defects.
- **Read-back:** independent query of Production: 317 of 317 four-field md5s equal the proposed text; the other published rows were not changed by this write.
- **Known weak spots:** no human review; not seen rendered; source defect left as is: Calculus AB 5.6 (likely 5.7-5.9, 5.11) lost second-derivative primes (f'' reads f').
- **Rollback:** restore the four fields from `current_*.json` in the same folder (guarded by the new md5s).
- **Numbering check:** highest APPROVAL found on origin branches was 0271; 0272 is this session's quick_take record (uncommitted).
