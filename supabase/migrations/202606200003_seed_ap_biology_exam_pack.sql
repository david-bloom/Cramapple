-- Seed the initial AP Biology exam pack and version for the production project.

begin;

with upserted_pack as (
  insert into app.exam_packs (exam_code, exam_name, subject)
  values ('ap_biology', 'AP Biology', 'biology')
  on conflict (exam_code)
  do update set
    exam_name = excluded.exam_name,
    subject = excluded.subject
  returning id
)
insert into app.exam_pack_versions (
  exam_pack_id,
  school_year,
  official_exam_date,
  status,
  source_uri,
  source_published_at,
  released_at
)
select
  id,
  '2026',
  date '2026-05-04',
  'published',
  null,
  null,
  now()
from upserted_pack
on conflict (exam_pack_id, school_year)
do update set
  official_exam_date = excluded.official_exam_date,
  status = excluded.status,
  source_uri = excluded.source_uri,
  source_published_at = excluded.source_published_at,
  released_at = excluded.released_at;

commit;
