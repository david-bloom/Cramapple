-- Course Mode live write hook — per-attempt idempotency for student_cell_state.
--
-- Fable QA finding 2 (PR #101): re-grading the SAME attempt under a new
-- idempotency key (a client retry that regenerates its key, an admin re-run, or
-- the grade_revision repair flow) re-fires persistCellState and double-counts
-- evidence — the grading_results short-circuit only dedupes per request_id, and
-- nothing tied a cell-state evidence event to the attempt row.
--
-- Track the attempt whose grade produced the row's current state so the write
-- hook can skip a repeat of the SAME attempt: at-most-once per (cell, attempt),
-- first grade wins. Additive + nullable; the Dev table is empty and Prod has no
-- rows (content_item_cells is unpopulated pending release), so existing data is
-- unaffected. MUST be applied before the evaluate-attempt edge function that
-- reads/writes this column is deployed.

alter table app.student_cell_state
  add column if not exists last_attempt_id uuid;

comment on column app.student_cell_state.last_attempt_id is
  'The attempts.id whose grade produced this row''s current state. The live '
  'write hook (persistCellState) skips a re-grade of the same attempt so one '
  'attempt contributes at most one evidence event to a cell (Fable QA finding 2, '
  'PR #101).';
