-- CONTENT_TAXONOMY_RATIONALIZATION_PLAN_2026_09_26.md Phase 1 step 2.
-- The "one place to look" (plan §3, F3): one row per published version with
-- resolved topic/skill identity, joined to the registry for titles.
--
-- SAFETY-CRITICAL FILTER, not an afterthought: assignment_status must be
-- restricted to ('validated', 'authored'). Decision #2 in the rationalization
-- plan (whether provisional_model AI topic guesses may drive student-facing
-- surfaces) was explicitly deferred to a post-launch fast-follow, not
-- resolved -- the same posture DECISION-0067 (2026-09-24) already took. This
-- view is read directly by student-session-items to select breadcrumb/brief/
-- explainer content, so without this filter every provisional_model row
-- (112 AP Biology topic-only cells as of this migration) would become
-- student-visible. The first version of this view (superseded here, same
-- session) omitted the filter -- caught and fixed before any code that
-- depended on it was deployed.
create or replace view app.content_item_topic_resolution as
select
  cic.content_item_cell_id,
  cic.content_item_id,
  cic.content_item_version_id,
  cic.taxonomy_source_version,
  cic.topic_code,
  cic.skill_code,
  tt.topic_title,
  tt.unit_number,
  cic.is_primary,
  cic.assignment_status
from app.content_item_cells cic
join app.taxonomy_topics tt
  on tt.taxonomy_source_version = cic.taxonomy_source_version
  and tt.topic_code = cic.topic_code
where cic.is_primary
  and cic.assignment_status in ('validated', 'authored');

grant select on app.content_item_topic_resolution to service_role;
