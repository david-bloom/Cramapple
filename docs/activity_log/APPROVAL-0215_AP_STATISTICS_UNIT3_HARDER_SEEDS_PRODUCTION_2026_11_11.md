# APPROVAL-0215 — AP Statistics Unit 3 harder seeds and variants: 76 items published, 37 superseded items retired (granted and executed 2026-11-11)

- **Status:** **Granted by David in chat ("Blind solve, then push", 2026-11-11) and executed.**
- **Tier:** Production content write (student-facing questions).
- **Basis:** Same finding as APPROVAL-0214, applied to Unit 3. Audit of the 60 published Unit 3 MCQs: 9 of 26 seed families were one-step recall (R1), covering 32 of 60 items; two duplicate or near-twin seeds; one variant family with no seed; topics 3.7 and 3.9 to 3.14 had one MCQ each. David asked to rewrite all R1 seeds as R3, remove the duplication, clean up, and add seeds for the thin topics.

## Scope
Production `pcntajvbdfqhbeewmdry`, AP Statistics pack `548f06be-ccf4-426d-b82b-b424137a4438`.
- **Loaded and published 76 MCQs** (19 seeds + 57 variants). Keys `APSTATS-MCQ-H-3.<n>-<A|B>` and `APSTATS-MCQ-SV-H-3.<n>-<A|B>-v1..3`. Correct-answer position balanced 19 each of A to D.
  - Replace R1 seeds: 3.1-A, 3.2-A, 3.5-A, 3.6-A, 3.6-B, 3.8-A, 3.8-B, 3.8-C, 3.15-A.
  - Fix duplicates: 3.4-B replaces 011-CAL (byte-identical to 011); 3.3-B replaces OHT-3.3 (near-twin of 058-v3); 3.3-A replaces the seedless 058 family.
  - New seeds: 3.7-A, 3.9-A, 3.10-A, 3.11-A, 3.12-A, 3.13-A, 3.14-A.
- **Retired 37 superseded items:** families 060, 061, 067, 063, 071, 092, 076 (seed + v1..v3 each), `APSTATS-MCQ-066`, `APSTATS-MCQ-080` with v1 and v3, `APSTATS-MCQ-011-CAL`, `APSTATS-OHT-3.3`, and `APSTATS-MCQ-SV-058-v1..v3`. Rows retired, not deleted; student history intact. Kept on purpose: 010-CAL, 011 and its variants, 095, and the other OHT items.
- Package and generator: `scripts/content-seed/ap-statistics-unit3-harder-seeds-2026-11-11/`.

## Verification before the write
- **Blind solve (2026-11-11):** DeepSeek V4 Pro and Kimi K3.1 Pro each solved all 76 items with keys and rationales hidden; **both agreed with the stored key on 76 of 76.** This checks keys only; rationales were not model-audited.
- Author's own Python arithmetic check on every number before the solve; read-only Production preflight (all 37 retire keys published, no new key existing).
- **Not done, by owner decision (as for APPROVAL-0214):** two-checker rationale audit, topic/skill vote, CED scope check. Topics are the author's design intent; skill_code null.

## Execution record
- 9 load chunks: no errors. `verify_hashes.sql`: 76 of 76 `ok`, all draft.
- `publish_rehearsal.sql`: `REHEARSAL OK (rolled back): published=76, validated_labels=76, topic_cells=76`. `publish.sql`: committed, same counts.
- `retire_old_rehearsal.sql`: `REHEARSAL OK ... retired=37`. `retire_old.sql`: `retired = 37`. `verify_hashes.sql` after: 76 of 76 `ok`, published.
- **After (verified):** published Unit 3 MCQs 60 → 99 (60 + 76 − 37). Per topic 3.1 to 3.15: 5, 8, 8, 8, 5, 9, 5, 16, 5, 5, 5, 5, 5, 5, 5.
- Labels: serving, `required_units {3}`, `primary_unit 3`, taxonomy source version `dae3c72e-82ca-4960-9552-1b034bd347e5`; validation decision source `chat_review`.

## Not verified
- **Student-facing delivery was not exercised** (no live session check that new items are served and retired ones are not).
- No content reviewer read the final student-facing text; rationales were not independently audited.
- Student attempt history on the 37 retired items was not inspected.
- Topics 3.7 and 3.9 to 3.14 now have five MCQs each (one seed family of four plus the existing OHT item); a second seed per topic was not added.

## Rollback
Retire the 76 new items (pattern in `retire_old.sql`, keyed on `APSTATS-MCQ-H-3.%` and `APSTATS-MCQ-SV-H-3.%`) and re-publish the 37 retired versions (rows retained).
