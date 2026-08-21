-- Move four BC-only topics out of AP Calculus AB and into AP Calculus BC.
-- ---------------------------------------------------------------------------
-- The AP Calculus AB and BC courses share one CED and one topic numbering. The
-- CED marks certain topics "BC ONLY"; AB's registry must exclude them.
--
-- AB's taxonomy correctly excluded 6.12 and 6.13 but wrongly included four
-- others, and had published briefs AND explainers for all four — so AP
-- Calculus AB students were being served Learn More content for material that
-- is not on their exam:
--
--   6.11  Integrating Using Integration by Parts          (CED: BC ONLY)
--   7.5   Approximating Solutions Using Euler's Method    (CED: BC ONLY)
--   7.9   Logistic Models with Differential Equations     (CED: BC ONLY)
--   8.13  Arc Length of a Smooth Planar Curve             (CED: BC ONLY)
--
-- Source: AP Calculus AB and BC Course and Exam Description, Course at a
-- Glance, printed p. 20 (docs/teaching/ap-calculus-ab-and-bc-course-and-exam-description.pdf).
--
-- The content itself is valid — it is BC content that was filed under AB. BC
-- has a taxonomy topic for each of the four but no brief or explainer, so this
-- migration MOVES the content rather than deleting it: copy to BC first, then
-- remove from AB.
--
-- Per the content architecture rule (Product Owner, 2026-08-21): AB and BC each
-- own their own rows, duplicated rather than shared, so either can be edited
-- without affecting the other. The copies created here are BC-owned rows.
--
-- Rewrites on copy: subject_key, learn_more_path (/learn/ap-calculus-ab/... ->
-- /learn/ap-calculus-bc/...) and practice_subject_key. practice_bridge on
-- explainers is generic and needs no change.
--
-- Idempotent. Safe to re-run.

-- --- Preconditions ---------------------------------------------------------
do $$
declare n int;
begin
  select count(*) into n from app.topic_point_briefs
   where subject_key='ap_calculus_bc' and topic_code in ('6.11','7.5','7.9','8.13');
  if n > 0 then
    raise notice 'BC already has %/4 of these briefs; move already applied (idempotent)', n;
  end if;

  select count(*) into n from app.taxonomy_topics tt
    join app.taxonomy_source_versions tsv using (taxonomy_source_version)
   where tsv.subject_key='ap_calculus_bc' and tt.topic_code in ('6.11','7.5','7.9','8.13');
  if n <> 4 then
    raise exception 'PRECONDITION FAIL: BC taxonomy is missing one of the four topics (found %/4)', n;
  end if;
end $$;

-- --- Copy briefs to BC -----------------------------------------------------
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
         'Moved from ap_calculus_ab 2026-08-21: the CED marks this topic BC ONLY.',
       b.published_at
from app.topic_point_briefs b
where b.subject_key = 'ap_calculus_ab'
  and b.topic_code in ('6.11','7.5','7.9','8.13')
on conflict (subject_key, topic_code) do nothing;

-- --- Copy explainers to BC -------------------------------------------------
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
         'Moved from ap_calculus_ab 2026-08-21: the CED marks this topic BC ONLY.',
       e.published_at
from app.topic_explainers e
where e.subject_key = 'ap_calculus_ab'
  and e.topic_code in ('6.11','7.5','7.9','8.13')
on conflict (subject_key, topic_code) do nothing;

-- --- Remove from AB, only once BC holds the copies -------------------------
do $$
declare nb int; ne int;
begin
  select count(*) into nb from app.topic_point_briefs
   where subject_key='ap_calculus_bc' and topic_code in ('6.11','7.5','7.9','8.13');
  select count(*) into ne from app.topic_explainers
   where subject_key='ap_calculus_bc' and topic_code in ('6.11','7.5','7.9','8.13');
  if nb <> 4 or ne <> 4 then
    raise exception 'REFUSING TO DELETE: BC holds %/4 briefs and %/4 explainers', nb, ne;
  end if;
  raise notice 'BC now holds all 4 briefs and all 4 explainers; safe to remove from AB';
end $$;

delete from app.topic_point_briefs
 where subject_key='ap_calculus_ab' and topic_code in ('6.11','7.5','7.9','8.13');

delete from app.topic_explainers
 where subject_key='ap_calculus_ab' and topic_code in ('6.11','7.5','7.9','8.13');

delete from app.taxonomy_topics tt
 using app.taxonomy_source_versions tsv
 where tsv.taxonomy_source_version = tt.taxonomy_source_version
   and tsv.subject_key = 'ap_calculus_ab'
   and tt.topic_code in ('6.11','7.5','7.9','8.13');

-- --- Post-assertions -------------------------------------------------------
do $$
declare ab_topics int; ab_briefs int; ab_expl int; bc_briefs int; bc_expl int; leftover int;
begin
  select count(*) into ab_topics from app.taxonomy_topics tt
    join app.taxonomy_source_versions tsv using (taxonomy_source_version)
   where tsv.subject_key='ap_calculus_ab';
  if ab_topics <> 81 then
    raise exception 'POST FAIL: ap_calculus_ab has % topics, expected 81', ab_topics;
  end if;

  select count(*) into leftover from app.taxonomy_topics tt
    join app.taxonomy_source_versions tsv using (taxonomy_source_version)
   where tsv.subject_key='ap_calculus_ab'
     and tt.topic_code = any (array['6.11','6.12','6.13','7.5','7.9','8.13']);
  if leftover > 0 then
    raise exception 'POST FAIL: % BC-only topic(s) still in AB', leftover;
  end if;

  select count(*) into ab_briefs from app.topic_point_briefs
   where subject_key='ap_calculus_ab' and status='published';
  select count(*) into ab_expl from app.topic_explainers
   where subject_key='ap_calculus_ab' and status='published';
  select count(*) into bc_briefs from app.topic_point_briefs
   where subject_key='ap_calculus_bc' and status='published';
  select count(*) into bc_expl from app.topic_explainers
   where subject_key='ap_calculus_bc' and status='published';

  -- No published AB brief or explainer may reference a topic AB no longer owns.
  select count(*) into leftover from app.topic_point_briefs b
   where b.subject_key='ap_calculus_ab' and b.status='published'
     and not exists (select 1 from app.taxonomy_topics tt
       join app.taxonomy_source_versions tsv using (taxonomy_source_version)
       where tsv.subject_key='ap_calculus_ab' and tt.topic_code=b.topic_code);
  if leftover > 0 then
    raise exception 'POST FAIL: % orphaned AB brief(s)', leftover;
  end if;

  raise notice 'POST OK: AB topics=81 briefs=% explainers=%; BC briefs=% explainers=%',
    ab_briefs, ab_expl, bc_briefs, bc_expl;
end $$;
