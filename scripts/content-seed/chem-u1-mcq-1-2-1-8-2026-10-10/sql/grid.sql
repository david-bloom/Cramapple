with tsv as (
  select distinct c.taxonomy_source_version v
  from app.content_item_cells c join app.content_items ci on ci.id = c.content_item_id
  where ci.content_key like 'apchem-mcq-07%' and c.superseded_by is null)
select tc.topic_code, tc.taxonomy_source_version, string_agg(tc.skill_code, ',' order by tc.skill_code) skills
from app.taxonomy_cells tc
where tc.topic_code in ('1.2', '1.8') and tc.taxonomy_source_version in (select v from tsv)
group by 1, 2
