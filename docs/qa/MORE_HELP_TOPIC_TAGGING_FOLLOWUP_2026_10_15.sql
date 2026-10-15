
-- Adjacent keyword triage (bounded, not semantic certification).
with l as(select distinct on(content_item_id) * from app.content_taxonomy_labels where label_scope='serving' and label_status='validated' and superseded_by is null order by content_item_id,label_version desc)
select ci.content_key,left(v.stem,1100) stem,cc.topic_code,cc.assignment_status,cc.source
from app.content_items ci join app.content_item_versions v on v.content_item_id=ci.id join app.exam_pack_versions epv on epv.id=ci.exam_pack_version_id join app.exam_packs ep on ep.id=epv.exam_pack_id join app.subjects s on s.id=ep.subject_id
left join lateral(select c.topic_code,c.assignment_status,c.source from app.content_item_cells c where c.content_item_version_id=v.id and c.superseded_by is null order by c.is_primary desc nulls last,c.created_at limit 1) cc on true
where s.subject_key='ap-chemistry' and ci.status='published' and v.status='published'
and (cc.topic_code is null or cc.topic_code in('2.1','2.6','2.7'))
and v.stem ~* 'Lewis|octet|valence electrons|lone pair'
order by cc.topic_code nulls first,ci.content_key limit 35;

-- Affected provenance-family counts.
select cc.source,cc.assignment_status,count(distinct ci.id) items,count(distinct ci.id) filter(where cc.is_primary) primary_items from app.content_items ci join app.content_item_versions v on v.content_item_id=ci.id join app.content_item_cells cc on cc.content_item_version_id=v.id and cc.superseded_by is null join app.exam_pack_versions epv on epv.id=ci.exam_pack_version_id join app.exam_packs ep on ep.id=epv.exam_pack_id join app.subjects s on s.id=ep.subject_id where s.subject_key='ap-chemistry' and ci.status='published' and v.status='published' and (cc.source like 'apchem_topic_probe_2026_10_02%' or cc.source='apchem_variants_topic_2026_10_02') group by cc.source,cc.assignment_status order by cc.source;

