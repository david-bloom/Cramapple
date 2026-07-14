-- 202607140001_review_decision_categorical_scoring.sql
--
-- Review scoring model change (DECISION-0038):
--   * Replace the numeric tutor score (1 Yes | 2 Maybe | 3 No) with a
--     categorical decision: approve | approve_with_edits | disapprove.
--   * Difficulty becomes an agree/propose action against the item's
--     intended difficulty, instead of every reviewer cold-labeling.
--
-- SAFETY / SEQUENCING:
--   This migration is ADDITIVE and reversible. It adds new columns and
--   backfills them from the existing data; it does NOT drop tutor_score or
--   difficulty_label, so existing rows and the current edge functions keep
--   working until the coordinated changes land.
--   DO NOT APPLY IN ISOLATION to a live environment: the review-decision /
--   review-queue edge functions (see prompts/CODEX_REVIEW_DECISION_CATEGORICAL_SCORING.md)
--   and the Lovable reviewer UI (prompts/LOVABLE_UX002_REVIEW_SCORING_UPDATE.md)
--   must be updated in the same release, and the change must pass QA and the
--   Database Migrations hard gate (STANDING_APPROVAL_LANES Lane 3) before it
--   reaches production. Prepared, not yet applied.

begin;

-- ── Categorical suitability decision ────────────────────────────────────────
alter table app.content_review_decisions
  add column if not exists tutor_decision text;

alter table app.content_review_decisions
  add constraint crd_tutor_decision_check
  check (
    tutor_decision is null
    or tutor_decision in ('approve', 'approve_with_edits', 'disapprove')
  );

-- Backfill from the legacy numeric score: 1 Yes → approve,
-- 2 Maybe → approve_with_edits, 3 No → disapprove.
update app.content_review_decisions
set tutor_decision = case tutor_score
    when 1 then 'approve'
    when 2 then 'approve_with_edits'
    when 3 then 'disapprove'
    else tutor_decision
  end
where tutor_score is not null
  and tutor_decision is null;

-- ── Difficulty agree/propose action ─────────────────────────────────────────
-- The reviewer either agrees with the item's intended difficulty or proposes a
-- different level (supplied in the existing difficulty_label column). Historical
-- rows predate this action and keep difficulty_action null.
alter table app.content_review_decisions
  add column if not exists difficulty_action text;

alter table app.content_review_decisions
  add constraint crd_difficulty_action_check
  check (
    difficulty_action is null
    or difficulty_action in ('agree', 'propose')
  );

-- ── Reader stage: extend to the same categorical vocabulary ──────────────────
-- reader_decision kept for back-compat ('agree'|'disagree'); allow the new
-- categorical values so the AP Reader stage can use the same model. The edge
-- function maps agree→approve and disagree→disapprove for legacy rows.
alter table app.content_review_decisions
  drop constraint if exists crd_reader_decision_check;

alter table app.content_review_decisions
  add constraint crd_reader_decision_check
  check (
    reader_decision is null
    or reader_decision in (
      'agree', 'disagree',                 -- legacy
      'approve', 'approve_with_edits', 'disapprove'
    )
  );

commit;

-- ── Rollback (manual) ────────────────────────────────────────────────────────
-- alter table app.content_review_decisions drop constraint crd_tutor_decision_check;
-- alter table app.content_review_decisions drop column tutor_decision;
-- alter table app.content_review_decisions drop constraint crd_difficulty_action_check;
-- alter table app.content_review_decisions drop column difficulty_action;
-- (restore the original crd_reader_decision_check to ('agree','disagree'))
