begin;

create or replace function app.home_exam_pack_compatible_published_item_count(
  _exam_pack_version_id uuid
)
returns integer
language sql
stable
security definer
set search_path = pg_catalog
as $$
  select count(distinct ci.id)::integer
  from app.content_items ci
  join app.content_item_versions civ
    on civ.content_item_id = ci.id
  where ci.exam_pack_version_id = _exam_pack_version_id
    and ci.status = 'published'
    and ci.item_type = 'mcq'
    and civ.status = 'published'
    and exists (
      select 1
      from app.mcq_choices choice
      where choice.content_item_version_id = civ.id
    );
$$;

revoke all on function app.home_exam_pack_compatible_published_item_count(uuid)
  from public, anon;
grant execute on function app.home_exam_pack_compatible_published_item_count(uuid)
  to authenticated, service_role;

comment on function app.home_exam_pack_compatible_published_item_count(uuid) is
  'Returns the published MCQ item count used by Home subject eligibility without exposing recursive content table RLS to authenticated view readers.';

create or replace view public.home_quick_start_subjects
with (security_invoker = true, security_barrier = true)
as
select
  epv.id as exam_pack_version_id,
  s.subject_key,
  s.display_name,
  epv.official_exam_date,
  m.minimum_published_items,
  compatible_counts.compatible_published_items,
  m.allowed_unit_numbers,
  m.criterion_starter_enabled,
  (
    m.quick_start_enabled
    and epv.status = 'published'
    and epv.retired_at is null
    and s.status = 'active'
    and compatible_counts.compatible_published_items >= m.minimum_published_items
  ) as eligible
from app.home_release_manifest m
join app.exam_pack_versions epv on epv.id = m.exam_pack_version_id
join app.exam_packs ep on ep.id = epv.exam_pack_id
join app.subjects s on s.id = ep.subject_id
cross join lateral (
  select app.home_exam_pack_compatible_published_item_count(epv.id) as compatible_published_items
) compatible_counts;

revoke all on public.home_quick_start_subjects
  from public, anon, authenticated, service_role;
grant select on public.home_quick_start_subjects to authenticated, service_role;

comment on view public.home_quick_start_subjects is
  'Authenticated Home subject switch/options view. Uses an aggregate helper to avoid recursive content_item_versions RLS.';

commit;
