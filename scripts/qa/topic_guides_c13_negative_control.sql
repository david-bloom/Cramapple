-- Negative control for C13a in topic_guides_database_qa.sql.
--
-- Purpose:
--   Prove the C13a hard rule actually trips. It moves the cutoff to a date
--   before the existing rows were published, so the exact brief/explainer
--   twins already in the database are treated as "new". No app data is
--   written (the cutoff lives in a temp table), so no table triggers fire.
--
-- EXPECTED RESULT: this file FAILS with a message starting
--   'EXPECTED FAILURE: C13a tripped'.
--   - 'CONTROL BROKEN' means the hard rule did not trip: C13a is not working.
--   - Any other error means the control itself did not run.
--
-- Not part of the normal QA run (it is expected to fail). Run on Development:
--   supabase db query --linked \
--     --file scripts/qa/topic_guides_c13_negative_control.sql \
--     --workdir /Users/davidbloom/Documents/Cramapple.nosync
-- (confirm `cat supabase/.temp/project-ref` is the Development ref first)

begin;

create temporary table topic_guides_qa_c13_config (
  hard_from timestamptz not null
) on commit drop;
insert into topic_guides_qa_c13_config values ('2026-01-01');

do $$
declare
  v_n integer;
  v_cutoff timestamptz;
begin
  select hard_from into v_cutoff from topic_guides_qa_c13_config;

  -- Same predicate as C13a in topic_guides_database_qa.sql; keep in sync.
  select count(*) into v_n
  from app.topic_point_briefs b
  join app.topic_explainers x
    on x.subject_key=b.subject_key and x.topic_code=b.topic_code
  where b.status='published' and x.status='published'
    and greatest(b.published_at, x.published_at) >= v_cutoff
    and coalesce(x.source_note,'') not like '%overlap-waived%'
    and (x.core_idea = b.what_it_is
      or x.what_students_need_to_understand = b.why_it_matters
      or x.how_this_becomes_points = b.how_points_are_earned);

  if v_n > 0 then
    raise exception 'EXPECTED FAILURE: C13a tripped on % exact-twin row(s) with the cutoff moved to 2026-01-01', v_n;
  else
    raise exception 'CONTROL BROKEN: C13a found no exact twins even with the cutoff moved back';
  end if;
end;
$$;

rollback;
