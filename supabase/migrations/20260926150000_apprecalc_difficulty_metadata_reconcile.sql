-- Fixes the residual finding from Codex's second cross-QA pass on PR #198 (AP Precalculus Tier 3
-- remediation): the 2026-09-26 difficulty correction (20260926140000_apprecalc_difficulty_correction_batch_01.sql)
-- only updated the 30 rows whose difficulty BAND actually changed after fixing the classifier's item-level
-- cue-leakage bug. The other 87 rows kept their correct band but still carried stale `rationale`/`basis`/
-- `proposal_run` metadata computed by the known-buggy whole-item classifier (e.g. `apprecalc-frq-005` and
-- `apprecalc-frq-013` still showed rationale text like "modal of 6 criteria: {'Hard': 6}" even though their
-- band was already correct by coincidence). Since `rationale`/`proposal_run` are durable audit/provenance
-- fields, not just display text, this reconciles all still-stale rows to the corrected classifier's actual
-- output in docs/research/apbio_difficulty_calibration_2026_09_22/APPRECALC_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv.
-- No difficulty band is changed by this migration -- the `where` clause only touches rows whose current
-- band already matches the corrected CSV's band, as a safety check against accidentally re-deriving a band
-- change here instead of through the proper classifier-correction path.

begin;

with corrected(content_key, difficulty, basis, confidence, rationale) as (
  values
  ('apprecalc-frq-001', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via part-a stem instruction, modal with upward tie-break: Easy=0, Medium=6, Hard=0; criteria_with_no_cue=0/6.'),
  ('apprecalc-frq-002', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via part-a stem instruction, modal with upward tie-break: Easy=2, Medium=4, Hard=0; criteria_with_no_cue=0/6.'),
  ('apprecalc-frq-003', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via part-a stem instruction, modal with upward tie-break: Easy=2, Medium=4, Hard=0; criteria_with_no_cue=0/6.'),
  ('apprecalc-frq-004', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via part-a stem instruction, modal with upward tie-break: Easy=0, Medium=6, Hard=0; criteria_with_no_cue=0/6.'),
  ('apprecalc-frq-005', 'Hard', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via part-a stem instruction, modal with upward tie-break: Easy=0, Medium=2, Hard=4; criteria_with_no_cue=0/6.'),
  ('apprecalc-frq-006', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via part-a stem instruction, modal with upward tie-break: Easy=0, Medium=6, Hard=0; criteria_with_no_cue=0/6.'),
  ('apprecalc-frq-007', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via part-a stem instruction, modal with upward tie-break: Easy=0, Medium=4, Hard=2; criteria_with_no_cue=0/6.'),
  ('apprecalc-frq-009', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via part-a stem instruction, modal with upward tie-break: Easy=0, Medium=6, Hard=0; criteria_with_no_cue=0/6.'),
  ('apprecalc-frq-010', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via part-a stem instruction, modal with upward tie-break: Easy=2, Medium=4, Hard=0; criteria_with_no_cue=0/6.'),
  ('apprecalc-frq-011', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via part-a stem instruction, modal with upward tie-break: Easy=2, Medium=4, Hard=0; criteria_with_no_cue=0/6.'),
  ('apprecalc-frq-012', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via part-a stem instruction, modal with upward tie-break: Easy=2, Medium=4, Hard=0; criteria_with_no_cue=0/6.'),
  ('apprecalc-frq-013', 'Hard', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via part-a stem instruction, modal with upward tie-break: Easy=2, Medium=2, Hard=2; criteria_with_no_cue=0/6.'),
  ('apprecalc-frq-014', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via part-a stem instruction, modal with upward tie-break: Easy=0, Medium=4, Hard=2; criteria_with_no_cue=0/6.'),
  ('apprecalc-frq-015', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via part-a stem instruction, modal with upward tie-break: Easy=2, Medium=4, Hard=0; criteria_with_no_cue=0/6.'),
  ('apprecalc-frq-016', 'Hard', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via part-a stem instruction, modal with upward tie-break: Easy=2, Medium=2, Hard=2; criteria_with_no_cue=0/6.'),
  ('apprecalc-frq-017', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via part-a stem instruction, modal with upward tie-break: Easy=0, Medium=4, Hard=2; criteria_with_no_cue=0/6.'),
  ('apprecalc-frq-018', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via part-a stem instruction, modal with upward tie-break: Easy=2, Medium=4, Hard=0; criteria_with_no_cue=0/6.'),
  ('apprecalc-frq-019', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via part-a stem instruction, modal with upward tie-break: Easy=2, Medium=4, Hard=0; criteria_with_no_cue=0/6.'),
  ('apprecalc-frq-020', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via part-a stem instruction, modal with upward tie-break: Easy=0, Medium=2, Hard=1; criteria_with_no_cue=0/3.'),
  ('apprecalc-frq-021', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via part-a stem instruction, modal with upward tie-break: Easy=0, Medium=6, Hard=0; criteria_with_no_cue=0/6.'),
  ('apprecalc-frq-022', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via part-a stem instruction, modal with upward tie-break: Easy=0, Medium=2, Hard=1; criteria_with_no_cue=0/3.'),
  ('apprecalc-frq-023', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via part-a stem instruction, modal with upward tie-break: Easy=0, Medium=4, Hard=2; criteria_with_no_cue=0/6.'),
  ('apprecalc-frq-024', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via part-a stem instruction, modal with upward tie-break: Easy=0, Medium=2, Hard=1; criteria_with_no_cue=0/3.'),
  ('apprecalc-frq-025', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via part-a stem instruction, modal with upward tie-break: Easy=0, Medium=4, Hard=2; criteria_with_no_cue=0/6.'),
  ('apprecalc-frq-026', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via part-a stem instruction, modal with upward tie-break: Easy=0, Medium=2, Hard=1; criteria_with_no_cue=0/3.'),
  ('apprecalc-frq-027', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via part-a stem instruction, modal with upward tie-break: Easy=0, Medium=6, Hard=0; criteria_with_no_cue=0/6.'),
  ('apprecalc-frq-028', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via part-a stem instruction, modal with upward tie-break: Easy=0, Medium=3, Hard=0; criteria_with_no_cue=0/3.'),
  ('apprecalc-frq-029', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via part-a stem instruction, modal with upward tie-break: Easy=0, Medium=6, Hard=0; criteria_with_no_cue=0/6.'),
  ('apprecalc-frq-030', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via part-a stem instruction, modal with upward tie-break: Easy=0, Medium=3, Hard=0; criteria_with_no_cue=0/3.'),
  ('apprecalc-frq-031', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via part-a stem instruction, modal with upward tie-break: Easy=0, Medium=6, Hard=0; criteria_with_no_cue=0/6.'),
  ('apprecalc-frq-032', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via part-a stem instruction, modal with upward tie-break: Easy=0, Medium=3, Hard=0; criteria_with_no_cue=0/3.'),
  ('apprecalc-frq-033', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via part-a stem instruction, modal with upward tie-break: Easy=0, Medium=6, Hard=0; criteria_with_no_cue=0/6.'),
  ('apprecalc-frq-034', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via part-a stem instruction, modal with upward tie-break: Easy=0, Medium=3, Hard=0; criteria_with_no_cue=0/3.'),
  ('apprecalc-frq-035', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via part-a stem instruction, modal with upward tie-break: Easy=0, Medium=6, Hard=0; criteria_with_no_cue=0/6.'),
  ('apprecalc-frq-036', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via part-a stem instruction, modal with upward tie-break: Easy=0, Medium=6, Hard=0; criteria_with_no_cue=0/6.'),
  ('apprecalc-frq-np2-001', 'Hard', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via part-a stem instruction, modal with upward tie-break: Easy=0, Medium=2, Hard=2; criteria_with_no_cue=2/6.'),
  ('apprecalc-frq-np2-002', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via part-a stem instruction, modal with upward tie-break: Easy=0, Medium=4, Hard=2; criteria_with_no_cue=0/6.'),
  ('apprecalc-frq-np2-003', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via part-a stem instruction, modal with upward tie-break: Easy=0, Medium=6, Hard=0; criteria_with_no_cue=0/6.'),
  ('apprecalc-frq-np2-004', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via part-a stem instruction, modal with upward tie-break: Easy=0, Medium=6, Hard=0; criteria_with_no_cue=0/6.'),
  ('apprecalc-frq-np2-005', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via part-a stem instruction, modal with upward tie-break: Easy=0, Medium=6, Hard=0; criteria_with_no_cue=0/6.'),
  ('apprecalc-frq-np2-006', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via part-a stem instruction, modal with upward tie-break: Easy=0, Medium=6, Hard=0; criteria_with_no_cue=0/6.'),
  ('apprecalc-frq-np2-007', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via part-a stem instruction, modal with upward tie-break: Easy=0, Medium=6, Hard=0; criteria_with_no_cue=0/6.'),
  ('apprecalc-frq-np2-008', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via part-a stem instruction, modal with upward tie-break: Easy=0, Medium=4, Hard=2; criteria_with_no_cue=0/6.'),
  ('apprecalc-frq-np2-009', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via part-a stem instruction, modal with upward tie-break: Easy=0, Medium=4, Hard=2; criteria_with_no_cue=0/6.'),
  ('apprecalc-frq-np2-010', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via part-a stem instruction, modal with upward tie-break: Easy=0, Medium=6, Hard=0; criteria_with_no_cue=0/6.'),
  ('apprecalc-frq-u12-002', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via criterion''s own learner_facing_text (no stem part breakdown), modal with upward tie-break: Easy=1, Medium=2, Hard=0; criteria_with_no_cue=3/6.'),
  ('apprecalc-frq-u12-003', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via criterion''s own learner_facing_text (no stem part breakdown), modal with upward tie-break: Easy=1, Medium=2, Hard=1; criteria_with_no_cue=2/6.'),
  ('apprecalc-frq-u12-004', 'Easy', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via criterion''s own learner_facing_text (no stem part breakdown), modal with upward tie-break: Easy=3, Medium=1, Hard=1; criteria_with_no_cue=1/6.'),
  ('apprecalc-frq-u12-005', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via criterion''s own learner_facing_text (no stem part breakdown), modal with upward tie-break: Easy=1, Medium=5, Hard=0; criteria_with_no_cue=0/6.'),
  ('apprecalc-frq-u12-006', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via criterion''s own learner_facing_text (no stem part breakdown), modal with upward tie-break: Easy=0, Medium=4, Hard=0; criteria_with_no_cue=2/6.'),
  ('apprecalc-frq-u12-007', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via criterion''s own learner_facing_text (no stem part breakdown), modal with upward tie-break: Easy=0, Medium=3, Hard=0; criteria_with_no_cue=3/6.'),
  ('apprecalc-frq-u12-008', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via criterion''s own learner_facing_text (no stem part breakdown), modal with upward tie-break: Easy=1, Medium=3, Hard=0; criteria_with_no_cue=2/6.'),
  ('apprecalc-frq-u12-009', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via criterion''s own learner_facing_text (no stem part breakdown), modal with upward tie-break: Easy=1, Medium=4, Hard=0; criteria_with_no_cue=1/6.'),
  ('apprecalc-frq-u12-010', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via criterion''s own learner_facing_text (no stem part breakdown), modal with upward tie-break: Easy=1, Medium=4, Hard=1; criteria_with_no_cue=0/6.'),
  ('apprecalc-frq-u12-011', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via criterion''s own learner_facing_text (no stem part breakdown), modal with upward tie-break: Easy=0, Medium=5, Hard=0; criteria_with_no_cue=1/6.'),
  ('apprecalc-frq-u12-012', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via criterion''s own learner_facing_text (no stem part breakdown), modal with upward tie-break: Easy=0, Medium=3, Hard=0; criteria_with_no_cue=3/6.'),
  ('apprecalc-frq-u12-013', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via criterion''s own learner_facing_text (no stem part breakdown), modal with upward tie-break: Easy=2, Medium=4, Hard=0; criteria_with_no_cue=0/6.'),
  ('apprecalc-frq-u12-014', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via criterion''s own learner_facing_text (no stem part breakdown), modal with upward tie-break: Easy=1, Medium=3, Hard=0; criteria_with_no_cue=2/6.'),
  ('apprecalc-frq-u12-015', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via criterion''s own learner_facing_text (no stem part breakdown), modal with upward tie-break: Easy=1, Medium=5, Hard=0; criteria_with_no_cue=0/6.'),
  ('apprecalc-frq-u12-016', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via criterion''s own learner_facing_text (no stem part breakdown), modal with upward tie-break: Easy=0, Medium=3, Hard=1; criteria_with_no_cue=2/6.'),
  ('apprecalc-frq-u12-017', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via criterion''s own learner_facing_text (no stem part breakdown), modal with upward tie-break: Easy=1, Medium=4, Hard=0; criteria_with_no_cue=1/6.'),
  ('apprecalc-frq-u12-018', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via criterion''s own learner_facing_text (no stem part breakdown), modal with upward tie-break: Easy=1, Medium=3, Hard=1; criteria_with_no_cue=1/6.'),
  ('apprecalc-frq-u12-019', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via criterion''s own learner_facing_text (no stem part breakdown), modal with upward tie-break: Easy=0, Medium=5, Hard=0; criteria_with_no_cue=1/6.'),
  ('apprecalc-frq-u12-020', 'Medium', 'calibrated_task_verb', 'medium', 'Per-criterion cue tiers via criterion''s own learner_facing_text (no stem part breakdown), modal with upward tie-break: Easy=0, Medium=3, Hard=0; criteria_with_no_cue=3/6.'),
  ('apprecalc-mcq-001', 'Medium', 'calibrated_task_verb', 'medium', 'Medium cue in MCQ stem.'),
  ('apprecalc-mcq-002', 'Medium', 'calibrated_judgement', 'low', 'No decisive cue; standard one-concept MCQ judged Medium.'),
  ('apprecalc-mcq-003', 'Medium', 'calibrated_task_verb', 'medium', 'Medium cue in MCQ stem.'),
  ('apprecalc-mcq-004', 'Medium', 'calibrated_judgement', 'low', 'No decisive cue; standard one-concept MCQ judged Medium.'),
  ('apprecalc-mcq-005', 'Hard', 'calibrated_task_verb', 'medium', 'Hard cue in MCQ stem.'),
  ('apprecalc-mcq-006', 'Medium', 'calibrated_judgement', 'low', 'No decisive cue; standard one-concept MCQ judged Medium.'),
  ('apprecalc-mcq-007', 'Medium', 'calibrated_judgement', 'low', 'No decisive cue; standard one-concept MCQ judged Medium.'),
  ('apprecalc-mcq-008', 'Medium', 'calibrated_judgement', 'low', 'No decisive cue; standard one-concept MCQ judged Medium.'),
  ('apprecalc-mcq-009', 'Medium', 'calibrated_task_verb', 'medium', 'Medium cue in MCQ stem.'),
  ('apprecalc-mcq-010', 'Medium', 'calibrated_judgement', 'low', 'No decisive cue; standard one-concept MCQ judged Medium.'),
  ('apprecalc-mcq-011', 'Medium', 'calibrated_judgement', 'low', 'No decisive cue; standard one-concept MCQ judged Medium.'),
  ('apprecalc-mcq-012', 'Hard', 'calibrated_task_verb', 'medium', 'Hard cue in MCQ stem.'),
  ('apprecalc-mcq-013', 'Medium', 'calibrated_judgement', 'low', 'No decisive cue; standard one-concept MCQ judged Medium.'),
  ('apprecalc-mcq-014', 'Medium', 'calibrated_judgement', 'low', 'No decisive cue; standard one-concept MCQ judged Medium.'),
  ('apprecalc-mcq-015', 'Medium', 'calibrated_task_verb', 'medium', 'Medium cue in MCQ stem.'),
  ('apprecalc-mcq-016', 'Medium', 'calibrated_judgement', 'low', 'No decisive cue; standard one-concept MCQ judged Medium.'),
  ('apprecalc-mcq-017', 'Medium', 'calibrated_judgement', 'low', 'No decisive cue; standard one-concept MCQ judged Medium.'),
  ('apprecalc-mcq-018', 'Medium', 'calibrated_judgement', 'low', 'No decisive cue; standard one-concept MCQ judged Medium.'),
  ('apprecalc-mcq-019', 'Medium', 'calibrated_judgement', 'low', 'No decisive cue; standard one-concept MCQ judged Medium.'),
  ('apprecalc-mcq-020', 'Medium', 'calibrated_judgement', 'low', 'No decisive cue; standard one-concept MCQ judged Medium.'),
  ('apprecalc-mcq-022', 'Medium', 'calibrated_judgement', 'low', 'No decisive cue; standard one-concept MCQ judged Medium.'),
  ('apprecalc-mcq-023', 'Medium', 'calibrated_task_verb', 'medium', 'Medium cue in MCQ stem.'),
  ('apprecalc-mcq-024', 'Medium', 'calibrated_judgement', 'low', 'No decisive cue; standard one-concept MCQ judged Medium.'),
  ('apprecalc-mcq-025', 'Medium', 'calibrated_task_verb', 'medium', 'Medium cue in MCQ stem.'),
  ('apprecalc-mcq-026', 'Medium', 'calibrated_task_verb', 'medium', 'Medium cue in MCQ stem.'),
  ('apprecalc-mcq-027', 'Medium', 'calibrated_judgement', 'low', 'No decisive cue; standard one-concept MCQ judged Medium.'),
  ('apprecalc-mcq-028', 'Medium', 'calibrated_task_verb', 'medium', 'Medium cue in MCQ stem.'),
  ('apprecalc-mcq-029', 'Medium', 'calibrated_judgement', 'low', 'No decisive cue; standard one-concept MCQ judged Medium.'),
  ('apprecalc-mcq-030', 'Medium', 'calibrated_task_verb', 'medium', 'Medium cue in MCQ stem.'),
  ('apprecalc-mcq-031', 'Medium', 'calibrated_task_verb', 'medium', 'Medium cue in MCQ stem.'),
  ('apprecalc-mcq-032', 'Medium', 'calibrated_judgement', 'low', 'No decisive cue; standard one-concept MCQ judged Medium.'),
  ('apprecalc-mcq-033', 'Medium', 'calibrated_task_verb', 'medium', 'Medium cue in MCQ stem.'),
  ('apprecalc-mcq-034', 'Medium', 'calibrated_judgement', 'low', 'No decisive cue; standard one-concept MCQ judged Medium.'),
  ('apprecalc-mcq-035', 'Medium', 'calibrated_judgement', 'low', 'No decisive cue; standard one-concept MCQ judged Medium.'),
  ('apprecalc-mcq-036', 'Medium', 'calibrated_judgement', 'low', 'No decisive cue; standard one-concept MCQ judged Medium.'),
  ('apprecalc-mcq-037', 'Medium', 'calibrated_judgement', 'low', 'No decisive cue; standard one-concept MCQ judged Medium.'),
  ('apprecalc-mcq-038', 'Medium', 'calibrated_task_verb', 'medium', 'Medium cue in MCQ stem.'),
  ('apprecalc-mcq-040', 'Medium', 'calibrated_judgement', 'low', 'No decisive cue; standard one-concept MCQ judged Medium.'),
  ('apprecalc-mcq-041', 'Medium', 'calibrated_judgement', 'low', 'No decisive cue; standard one-concept MCQ judged Medium.'),
  ('apprecalc-mcq-043', 'Medium', 'calibrated_judgement', 'low', 'No decisive cue; standard one-concept MCQ judged Medium.'),
  ('apprecalc-mcq-045', 'Medium', 'calibrated_judgement', 'low', 'No decisive cue; standard one-concept MCQ judged Medium.'),
  ('apprecalc-mcq-047', 'Medium', 'calibrated_task_verb', 'medium', 'Medium cue in MCQ stem.'),
  ('apprecalc-mcq-049', 'Medium', 'calibrated_task_verb', 'medium', 'Medium cue in MCQ stem.'),
  ('apprecalc-mcq-np2-001', 'Medium', 'calibrated_judgement', 'low', 'No decisive cue; standard one-concept MCQ judged Medium.'),
  ('apprecalc-mcq-np2-002', 'Medium', 'calibrated_task_verb', 'medium', 'Medium cue in MCQ stem.'),
  ('apprecalc-mcq-np2-003', 'Hard', 'calibrated_task_verb', 'medium', 'Hard cue in MCQ stem.'),
  ('apprecalc-mcq-np2-004', 'Medium', 'calibrated_task_verb', 'medium', 'Medium cue in MCQ stem.'),
  ('apprecalc-mcq-np2-005', 'Medium', 'calibrated_judgement', 'low', 'No decisive cue; standard one-concept MCQ judged Medium.'),
  ('apprecalc-mcq-np2-006', 'Medium', 'calibrated_judgement', 'low', 'No decisive cue; standard one-concept MCQ judged Medium.'),
  ('apprecalc-mcq-np2-007', 'Medium', 'calibrated_judgement', 'low', 'No decisive cue; standard one-concept MCQ judged Medium.'),
  ('apprecalc-mcq-np2-008', 'Medium', 'calibrated_task_verb', 'medium', 'Medium cue in MCQ stem.'),
  ('apprecalc-mcq-np2-009', 'Medium', 'calibrated_judgement', 'low', 'No decisive cue; standard one-concept MCQ judged Medium.'),
  ('apprecalc-mcq-np2-010', 'Medium', 'calibrated_judgement', 'low', 'No decisive cue; standard one-concept MCQ judged Medium.')
),
targets as (
  select d.content_item_difficulty_id, ci.content_key,
         d.difficulty as current_difficulty, c.difficulty as csv_difficulty,
         c.basis, c.confidence, c.rationale
  from app.content_item_difficulty d
  join content_item_versions civ on civ.id = d.content_item_version_id
  join content_items ci on ci.id = civ.content_item_id
  join exam_pack_versions epv on epv.id = ci.exam_pack_version_id
  join exam_packs ep on ep.id = epv.exam_pack_id
  join corrected c on c.content_key = ci.content_key
  where ep.exam_code = 'ap_precalculus'
    and epv.retired_at is null
    and d.proposal_run = 'apprecalc_tier3_2026_09_25'
)
update app.content_item_difficulty d
set basis = t.basis,
    confidence = t.confidence,
    rationale = t.rationale,
    proposal_run = 'apprecalc_tier3_2026_09_25_metadata_reconcile_2026_09_26'
from targets t
where d.content_item_difficulty_id = t.content_item_difficulty_id
  and t.current_difficulty = t.csv_difficulty;

commit;
