select s.subject_key, epv.id pack, epv.status, count(ci.id) items,
  max(case when ci.content_key ~ '^apchem-mcq-[0-9]+$' then substring(ci.content_key from '([0-9]+)$')::int end) max_seed_num,
  (select count(*) from app.taxonomy_cells tc where tc.topic_code in ('1.2','1.8')) grid_rows_any_tsv
from app.subjects s join app.exam_packs ep on ep.subject_id = s.id join app.exam_pack_versions epv on epv.exam_pack_id = ep.id
left join app.content_items ci on ci.exam_pack_version_id = epv.id
where s.subject_key = 'ap-chemistry'
group by 1, 2, 3
