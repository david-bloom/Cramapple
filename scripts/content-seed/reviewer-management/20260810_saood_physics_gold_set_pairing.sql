-- Add Muhammad Saood to the physics gold-set-verification roster, 2026-08-10.
--
-- Owner directed: "Add Saood to the physics gold set."
--
-- Saood already holds the 'gold-set-review' feature flag (from his AP Statistics
-- gold-set work, 70 submitted) and is qualified for all four physics exams per
-- app.validator_qualifications (Physics 1, Physics 2, Physics C: Mechanics,
-- Physics C: Electricity and Magnetism -- same grant that also covers Calculus
-- AB/BC, Precalculus, and Chemistry). Prior to this script, each physics subject's
-- gold-set-verification pool had exactly two paired answers (one each to Ahmed Ali
-- and Chisom Anuba, both still pending) out of a much larger unpaired backlog
-- (11/16/14/9 total gold-set answers for Physics 1/2/C-E&M/C-Mechanics
-- respectively). This pairs Saood with one previously-unpaired answer per
-- physics subject, the same one-answer-per-subject pattern used for Ahmed,
-- Chisom, and Abdul's initial pairings (20260809_gold_set_flags_and_pairing.sql).

-- Single statement -- the seeding function uses an on-commit-drop temp table
-- internally, so this must run standalone rather than inside an explicit
-- begin/commit block with other statements.
select app.seed_gold_set_verification_assignments(
  (select user_id from app.profiles where full_name='Muhammad Saood'),
  array[
    '76bcd9de-403a-4df0-b67d-4e9fa894e2a5', -- AP Physics 1, apphy1-frq-025
    '58ae9ef6-6697-49f7-bc5e-4046a2d7e880', -- AP Physics 2, apphy2-frq-027
    'afd98074-0ae7-43f8-a5ad-0a44aac84cc8', -- AP Physics C: E&M, apphycem-frq-003
    '6b031ab4-2821-4086-992f-a6b44deb7462'  -- AP Physics C: Mechanics, apphycm-frq-019
  ]::uuid[],
  1
);
