-- Allow 'partially_earned' as a criterion result status.
--
-- Partial credit is intended product behaviour (owner decision, 2026-07-28),
-- including error carry forward. 601 of 2,969 Production criteria are worth
-- more than one point (382 at 2 points, 219 at 3), and 124 of those sit on
-- already-published items.
--
-- Note on urgency: app.attempt_criterion_results has no writer today --
-- evaluate-attempt persists criterion results as jsonb into
-- app.grading_results.criterion_results, so this CHECK is not currently on the
-- grading path and the table is empty. This migration is therefore not
-- unblocking anything right now; it exists so the constraint does not become a
-- silent landmine the first time that table is wired up, at which point every
-- partially-earned criterion would fail to insert.
--
-- Rewriting the constraint is safe on an empty table and, more generally, only
-- widens the accepted set, so no existing row can be invalidated.

alter table app.attempt_criterion_results
  drop constraint if exists attempt_criterion_results_status_check;

alter table app.attempt_criterion_results
  add constraint attempt_criterion_results_status_check
  check (
    status = any (
      array[
        'earned'::text,
        'partially_earned'::text,
        'not_yet_earned'::text,
        'unable_to_determine'::text,
        'not_applicable'::text
      ]
    )
  );
