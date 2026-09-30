# Seeded variants: Production publication record (2026-09-30)

Executed on Production (`pcntajvbdfqhbeewmdry`) after the Product Owner's chat approval ("I approve putting all of these questions in front of students").
Scope read as: the 24 MCQ variants from the pilot (16) and the Unit 3 run (8). The 12 seeds were already published and are untouched.
Content keys `apcalcab-mcq-sv-<seed>-vK`. Seed rationale defects are being repaired separately (task); these variants do not copy them.

| Step | Result |
|---|---|
| Load 24 drafts (3 atomic chunks) | 24 of 24 md5-exact against the source (`load/verify_hashes.sql`), stimulus exact, 0 letter/key inconsistencies |
| Wording fix before load | `031-v1/v2` stimulus "A graphing calculator is required." -> "is permitted." (the arithmetic is easy by hand) |
| Owner approval (tutor_score 1, note records the PO approval and the checks run) | 24 versions/items `reviewed_approved`; structural QA clean |
| Serving labels | 24 written `provisional_model` then promoted to `validated` (`automated_spot_check`), fresh hash; units inherited from each seed's database label after a 3-model x 2-sample check (Gemini 3.8 Flash, DeepSeek V4 Pro, GPT-6.1 Sol): 24 of 24 agree |
| Label dimensions inherited | topic 22 of 24, skill 20 of 24, difficulty 20 of 24 (held where variant and seed disagreed; `label_inheritance.json`) |
| Difficulty rows | 20 (`calibrated_judgement`) |
| Cells (provisional) | 22 topic, 18 skill (skill only where the (topic, skill) pair is registered) |
| Publish | 24 versions and items `published`; no duplicate published versions |

Census after (Calc AB): published 279 (was 255), unit-gated 196 (was 172), targeted drill 64 and full-exam FRQ 18 (both unchanged), validated serving labels 198 (was 174).
Selftest: only capped skips, no mismatches. Hash freshness: 0 stale. Answer-key column grants for `anon`/`authenticated`: none.

Checks behind these items (all in this repo): `../calc-ab-pilot-2026-09-30/PILOT_REPORT.md`, `../calc-ab-unit3-variants-2026-09-30/UNIT3_REPORT.md`, `../calc-ab-fable-calibration-2026-09-30/CALIBRATION_REPORT.md`.
Not yet done: DECISION/APPROVAL/ACTIVITY log entries; the separate repair tasks for published seeds (`mcq-037` key, 10 rationale repairs).
