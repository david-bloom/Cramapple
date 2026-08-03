-- Exported from Production migration history (supabase_migrations.schema_migrations)
-- version: 20260719201212
-- recorded name: content_item_versions_view_stimulus_image_path
-- statements: 1
-- This file is a faithful transcript of what Production actually ran.
-- Do not edit to "improve" it; corrections belong in a new forward migration.

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
