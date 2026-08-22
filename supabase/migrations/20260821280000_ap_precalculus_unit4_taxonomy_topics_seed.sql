begin;

-- Seed AP Precalculus Unit 4 (Functions Involving Parameters, Vectors, and
-- Matrices) taxonomy topics -- 0 of 14 existed before this migration. Unit 4
-- is not assessed on the AP Exam (0% weighting, per the CED and
-- docs/product/AP_PRECALCULUS_CED_FACT_PACK.md's own "Course and exam scope"
-- section), which is why the fact pack's original deep-tier pass never
-- transcribed it -- that pass explicitly scoped to "all three assessed
-- units." This migration only adds the taxonomy row (topic_code + title),
-- not point briefs or Learn More explainers, matching how other out-of-scope
-- non-exam-assessed unit gaps are handled elsewhere in the corpus (e.g. AP
-- Calculus BC's Units 9-10 zero-coverage topics): the taxonomy should be
-- complete so units/topics render correctly, but new student-facing content
-- authoring for a non-assessed unit is a separate, larger decision.
--
-- Verified directly against the primary-source CED PDF at
-- docs/teaching/ap-precalculus-course-and-exam-description.pdf, "UNIT AT A
-- GLANCE" table for Unit 4 (pages ~105-108) and cross-checked against the
-- "Course at a Glance" summary table (page 17). Topic count (14) confirmed
-- against Owner-supplied ground truth before writing.

with topic_seed (topic_code, topic_title) as (
  values
  ('4.1', 'Parametric Functions'),
  ('4.2', 'Parametric Functions Modeling Planar Motion'),
  ('4.3', 'Parametric Functions and Rates of Change'),
  ('4.4', 'Parametrically Defined Circles and Lines'),
  ('4.5', 'Implicitly Defined Functions'),
  ('4.6', 'Conic Sections'),
  ('4.7', 'Parametrization of Implicitly Defined Functions'),
  ('4.8', 'Vectors'),
  ('4.9', 'Vector-Valued Functions'),
  ('4.10', 'Matrices'),
  ('4.11', 'The Inverse and Determinant of a Matrix'),
  ('4.12', 'Linear Transformations and Matrices'),
  ('4.13', 'Matrices as Functions'),
  ('4.14', 'Matrices Modeling Contexts')
)
insert into app.taxonomy_topics (
  taxonomy_source_version, unit_number, unit_title, topic_code, topic_title
)
select
  '16383753-6775-430d-960a-544cd6ee0972', 4, 'Functions Involving Parameters, Vectors, and Matrices',
  topic_code, topic_title
from topic_seed
on conflict (taxonomy_source_version, topic_code) do update
set
  unit_number = excluded.unit_number,
  unit_title = excluded.unit_title,
  topic_title = excluded.topic_title;

do $$
declare
  v_count integer;
begin
  select count(*) into v_count
  from app.taxonomy_topics
  where taxonomy_source_version='16383753-6775-430d-960a-544cd6ee0972' and unit_number=4;
  if v_count <> 14 then
    raise exception 'expected 14 AP Precalculus Unit 4 taxonomy topics, got %', v_count;
  end if;
end $$;

commit;
