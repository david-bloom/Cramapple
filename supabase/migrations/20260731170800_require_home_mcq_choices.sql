-- A Home-eligible MCQ must be serveable by the broad practice loader. A
-- published stem without answer choices is not compatible content.
create or replace view public.home_quick_start_subjects
with (security_invoker = true, security_barrier = true)
as
select
  epv.id as exam_pack_version_id,
  s.subject_key,
  s.display_name,
  epv.official_exam_date,
  m.minimum_published_items,
  count(distinct ci.id) filter (
    where ci.status = 'published'
      and civ.status = 'published'
      and ci.item_type = 'mcq'
      and exists (
        select 1 from app.mcq_choices choice
        where choice.content_item_version_id = civ.id
      )
  )::integer as compatible_published_items,
  m.allowed_unit_numbers,
  m.criterion_starter_enabled,
  (
    m.quick_start_enabled
    and epv.status = 'published'
    and epv.retired_at is null
    and s.status = 'active'
    and count(distinct ci.id) filter (
      where ci.status = 'published'
        and civ.status = 'published'
        and ci.item_type = 'mcq'
        and exists (
          select 1 from app.mcq_choices choice
          where choice.content_item_version_id = civ.id
        )
    ) >= m.minimum_published_items
  ) as eligible
from app.home_release_manifest m
join app.exam_pack_versions epv on epv.id = m.exam_pack_version_id
join app.exam_packs ep on ep.id = epv.exam_pack_id
join app.subjects s on s.id = ep.subject_id
left join app.content_items ci on ci.exam_pack_version_id = epv.id
left join app.content_item_versions civ on civ.content_item_id = ci.id
group by epv.id, s.subject_key, s.display_name, epv.official_exam_date,
  epv.status, epv.retired_at, s.status, m.minimum_published_items,
  m.allowed_unit_numbers, m.criterion_starter_enabled, m.quick_start_enabled;

grant select on public.home_quick_start_subjects to authenticated;
