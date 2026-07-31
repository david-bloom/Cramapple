-- Development still contains pre-normalization subject keys (`biology` and
-- `ap-statistics`). Keep the release manifest compatible without rewriting the
-- applied TASK-0018 migration. Quick start remains disabled.

begin;

insert into app.home_release_manifest (
  exam_pack_version_id,
  quick_start_enabled,
  minimum_published_items,
  allowed_unit_numbers,
  criterion_starter_enabled
)
select
  epv.id,
  false,
  10,
  case
    when lower(replace(s.subject_key, '-', '_')) in ('biology', 'ap_biology')
      then array[1,2,3,4,5,6,7,8]
    when lower(replace(s.subject_key, '-', '_')) in ('statistics', 'ap_statistics')
      then array[1,2,3,4,5,6,7,8,9]
    else '{}'::integer[]
  end,
  false
from app.exam_pack_versions epv
join app.exam_packs ep on ep.id = epv.exam_pack_id
join app.subjects s on s.id = ep.subject_id
where epv.status = 'published'
  and epv.retired_at is null
  and lower(replace(s.subject_key, '-', '_')) in (
    'biology',
    'ap_biology',
    'statistics',
    'ap_statistics'
  )
on conflict (exam_pack_version_id) do nothing;

commit;
