-- Expose content_item_versions.stimulus_image_path through the curated
-- public view.
--
-- 202607121001 added app.content_item_versions.stimulus_image_path, but
-- public.content_item_versions (defined in 202607090001) has an explicit
-- column list and was never updated -- same gap pattern as
-- 202607120001 for public.grading_results. Without this, neither the
-- reviewer portal nor the student session frontend (which read through
-- public.content_item_versions, not app.content_item_versions directly)
-- can see the new column.
--
-- Postgres refuses `create or replace view` when the new column list isn't
-- a pure trailing append (here stimulus_image_path is inserted next to
-- civ.stimulus, not appended after created_at/updated_at), so this must
-- drop and recreate rather than replace. Confirmed no other view depends
-- on public.content_item_versions before drop (checked via pg_depend on
-- Production).

begin;

drop view public.content_item_versions;

create view public.content_item_versions
with (security_invoker = true)
as
select
  civ.id,
  civ.content_item_id,
  ci.exam_pack_version_id,
  epv.exam_pack_id,
  ep.exam_code,
  ep.exam_name,
  ep.subject_id,
  s.subject_key,
  s.display_name as subject_name,
  ci.content_key,
  ci.item_type,
  ci.frq_form,
  ci.title,
  civ.version_num,
  civ.stem,
  civ.stimulus,
  civ.stimulus_image_path,
  civ.prompt_json,
  civ.explanation,
  civ.help_text,
  civ.content_hash,
  civ.canonical_answer_1,
  civ.canonical_answer_2,
  civ.review_status,
  civ.status,
  civ.approved_at,
  civ.approved_by,
  civ.published_at,
  civ.created_by,
  civ.created_at,
  civ.updated_at
from app.content_item_versions civ
join app.content_items ci
  on ci.id = civ.content_item_id
join app.exam_pack_versions epv
  on epv.id = ci.exam_pack_version_id
join app.exam_packs ep
  on ep.id = epv.exam_pack_id
join app.subjects s
  on s.id = ep.subject_id;

grant select on public.content_item_versions to authenticated;

commit;
