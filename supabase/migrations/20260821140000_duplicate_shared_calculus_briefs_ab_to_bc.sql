-- Duplicate the shared AB topic content into BC-owned rows.
-- ---------------------------------------------------------------------------
-- AP Calculus AB and BC share most of Units 1-8. AB has full coverage (81
-- briefs, 81 explainers); BC had only 26. This copies every AB brief and
-- explainer whose topic_code BC also owns, creating BC-owned rows.
--
-- Content architecture rule (Product Owner, 2026-08-21): AB and BC each get
-- their own row even when the content is identical, so either can be edited
-- without affecting the other. This deliberately duplicates rather than
-- sharing or referencing.
--
-- Rewritten on copy: subject_key, practice_subject_key, and learn_more_path
-- (/learn/ap-calculus-ab/... -> /learn/ap-calculus-bc/...). practice_bridge on
-- explainers is generic and unchanged. Each copy's source_note records where
-- it came from, so a later edit to either side is traceable.
--
-- Scope: 59 topics. Only BC topics that (a) exist in BC's taxonomy and (b) have
-- no BC row yet are copied, so this is idempotent and cannot overwrite BC
-- content that has since been edited independently.
--
-- NOT covered: 26 BC topics with no AB counterpart — 6.12, 6.13 and all of
-- Units 9 and 10. Those require authoring and are out of scope here.

-- --- Briefs ----------------------------------------------------------------
insert into app.topic_point_briefs (
  subject_key, unit_number, topic_code, title, class_importance, exam_importance,
  what_it_is, why_it_matters, how_points_are_earned, answer_move, common_point_loss,
  learn_more_path, practice_subject_key, practice_unit_number, practice_topic_code,
  status, source_note, published_at
)
select 'ap_calculus_bc', b.unit_number, b.topic_code, b.title, b.class_importance,
       b.exam_importance, b.what_it_is, b.why_it_matters, b.how_points_are_earned,
       b.answer_move, b.common_point_loss,
       replace(b.learn_more_path, '/ap-calculus-ab/', '/ap-calculus-bc/'),
       'ap_calculus_bc', b.practice_unit_number, b.practice_topic_code,
       b.status,
       coalesce(b.source_note || ' ', '') ||
         'Duplicated from ap_calculus_ab 2026-08-21 (shared AB/BC topic); BC-owned copy, edit independently.',
       b.published_at
from app.topic_point_briefs b
where b.subject_key = 'ap_calculus_ab'
  and b.status = 'published'
  and exists (
    select 1 from app.taxonomy_topics tt
      join app.taxonomy_source_versions tsv using (taxonomy_source_version)
     where tsv.subject_key = 'ap_calculus_bc' and tt.topic_code = b.topic_code)
  and not exists (
    select 1 from app.topic_point_briefs x
     where x.subject_key = 'ap_calculus_bc' and x.topic_code = b.topic_code)
on conflict (subject_key, topic_code) do nothing;

-- --- Explainers ------------------------------------------------------------
insert into app.topic_explainers (
  subject_key, unit_number, topic_code, title, core_idea,
  what_students_need_to_understand, how_this_becomes_points, answer_move,
  mini_example_question, weak_answer, point_attaining_answer, common_point_loss,
  practice_bridge, status, source_note, published_at
)
select 'ap_calculus_bc', e.unit_number, e.topic_code, e.title, e.core_idea,
       e.what_students_need_to_understand, e.how_this_becomes_points, e.answer_move,
       e.mini_example_question, e.weak_answer, e.point_attaining_answer,
       e.common_point_loss, e.practice_bridge, e.status,
       coalesce(e.source_note || ' ', '') ||
         'Duplicated from ap_calculus_ab 2026-08-21 (shared AB/BC topic); BC-owned copy, edit independently.',
       e.published_at
from app.topic_explainers e
where e.subject_key = 'ap_calculus_ab'
  and e.status = 'published'
  and exists (
    select 1 from app.taxonomy_topics tt
      join app.taxonomy_source_versions tsv using (taxonomy_source_version)
     where tsv.subject_key = 'ap_calculus_bc' and tt.topic_code = e.topic_code)
  and not exists (
    select 1 from app.topic_explainers x
     where x.subject_key = 'ap_calculus_bc' and x.topic_code = e.topic_code)
on conflict (subject_key, topic_code) do nothing;

-- --- Post-assertions -------------------------------------------------------
do $$
declare bc_briefs int; bc_expl int; ab_briefs int; orphans int; bad_path int; remaining int;
begin
  select count(*) into bc_briefs from app.topic_point_briefs
   where subject_key='ap_calculus_bc' and status='published';
  select count(*) into bc_expl from app.topic_explainers
   where subject_key='ap_calculus_bc' and status='published';
  select count(*) into ab_briefs from app.topic_point_briefs
   where subject_key='ap_calculus_ab' and status='published';

  if bc_briefs <> 85 or bc_expl <> 85 then
    raise exception 'POST FAIL: BC has % briefs and % explainers, expected 85 each', bc_briefs, bc_expl;
  end if;
  if ab_briefs <> 81 then
    raise exception 'POST FAIL: AB brief count changed to %, expected 81', ab_briefs;
  end if;

  -- no BC row may still point at an AB path or AB practice subject
  select count(*) into bad_path from app.topic_point_briefs
   where subject_key='ap_calculus_bc'
     and (learn_more_path like '%ap-calculus-ab%' or practice_subject_key <> 'ap_calculus_bc');
  if bad_path > 0 then
    raise exception 'POST FAIL: % BC brief(s) still reference AB', bad_path;
  end if;

  -- every BC brief must map to a BC taxonomy topic
  select count(*) into orphans from app.topic_point_briefs b
   where b.subject_key='ap_calculus_bc' and b.status='published'
     and not exists (select 1 from app.taxonomy_topics tt
       join app.taxonomy_source_versions tsv using (taxonomy_source_version)
       where tsv.subject_key='ap_calculus_bc' and tt.topic_code=b.topic_code);
  if orphans > 0 then
    raise exception 'POST FAIL: % orphaned BC brief(s)', orphans;
  end if;

  select count(*) into remaining from app.taxonomy_topics tt
    join app.taxonomy_source_versions tsv using (taxonomy_source_version)
   where tsv.subject_key='ap_calculus_bc'
     and not exists (select 1 from app.topic_point_briefs b
       where b.subject_key='ap_calculus_bc' and b.topic_code=tt.topic_code);
  raise notice 'POST OK: BC briefs=% explainers=%; % topic(s) still need authoring',
    bc_briefs, bc_expl, remaining;
end $$;
