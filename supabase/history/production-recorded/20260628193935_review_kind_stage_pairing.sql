-- Exported from Production migration history (supabase_migrations.schema_migrations)
-- version: 20260628193935
-- recorded name: review_kind_stage_pairing
-- statements: 1
-- This file is a faithful transcript of what Production actually ran.
-- Do not edit to "improve" it; corrections belong in a new forward migration.

alter table app.content_review_assignments
  add constraint cra_review_kind_stage_check
  check (
    review_kind is null
    or (
      review_kind = 'mcq'
      and review_stage in ('tutor_question', 'tutor_answer', 'reader_question')
    )
    or (
      review_kind = 'frq'
      and review_stage in ('tutor_question', 'tutor_frq_canonical', 'reader_question')
    )
  );
