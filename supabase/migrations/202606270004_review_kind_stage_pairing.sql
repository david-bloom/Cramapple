-- Enforce valid (review_kind, review_stage) pairings on assignments.
--
-- Without this constraint the schema allows nonsensical combinations:
--   review_kind='mcq' + review_stage='tutor_frq_canonical'
--   review_kind='frq' + review_stage='tutor_answer'
--
-- Valid pairings:
--   mcq → tutor_question | tutor_answer | reader_question
--   frq → tutor_question | tutor_frq_canonical | reader_question
--   null → any stage (review_kind not yet resolved at assignment time)

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
