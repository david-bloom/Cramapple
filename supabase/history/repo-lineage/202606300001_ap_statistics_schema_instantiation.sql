-- Phase 2: seed AP Statistics as a second subject.
-- AP Statistics exam date follows the current College Board AP Central page:
-- Thu, May 7, 2026, 12 PM local.

begin;

with upserted_subject as (
  insert into app.subjects (subject_key, display_name, status)
  values ('ap-statistics', 'AP Statistics', 'active')
  on conflict (subject_key)
  do update set
    display_name = excluded.display_name,
    status = excluded.status
  returning id
),
upserted_pack as (
  insert into app.exam_packs (exam_code, exam_name, subject_id)
  select
    'ap_statistics',
    'AP Statistics',
    id
  from upserted_subject
  on conflict (exam_code)
  do update set
    exam_name = excluded.exam_name,
    subject_id = excluded.subject_id
  returning id
),
upserted_version as (
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
    date '2026-05-07',
    'draft',
    null,
    null,
    null
  from upserted_pack
  on conflict (exam_pack_id, school_year)
  do update set
    official_exam_date = excluded.official_exam_date,
    status = excluded.status,
    source_uri = excluded.source_uri,
    source_published_at = excluded.source_published_at,
    released_at = excluded.released_at
  returning id, exam_pack_id
)
insert into app.content_labels (
  exam_pack_id,
  label_key,
  label_name,
  label_type,
  status
)
select
  upserted_pack.id,
  unit_label.label_key,
  unit_label.label_name,
  'unit',
  'draft'
from upserted_pack
cross join upserted_version
cross join (
  values
    ('unit_1', 'AP Statistics Unit 1'),
    ('unit_2', 'AP Statistics Unit 2'),
    ('unit_3', 'AP Statistics Unit 3'),
    ('unit_4', 'AP Statistics Unit 4'),
    ('unit_5', 'AP Statistics Unit 5'),
    ('unit_6', 'AP Statistics Unit 6'),
    ('unit_7', 'AP Statistics Unit 7'),
    ('unit_8', 'AP Statistics Unit 8'),
    ('unit_9', 'AP Statistics Unit 9')
) as unit_label(label_key, label_name)
on conflict (exam_pack_id, label_key)
do update set
  label_name = excluded.label_name,
  label_type = excluded.label_type,
  status = excluded.status;

commit;
