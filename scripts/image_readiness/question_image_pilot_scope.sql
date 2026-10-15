-- READ ONLY: reproduces the original candidate rule for the owner-selected subjects.
-- Classify returned unit evidence using the rule in question_image_pilot_scope.json.
with latest as (
 select distinct on (v.content_item_id) v.* from app.content_item_versions v
 order by v.content_item_id,v.version_num desc,v.created_at desc
), candidates as (
 select s.subject_key,ci.content_key,ci.item_type,ci.id as content_item_id,
 v.id as content_item_version_id,v.version_num,v.stem,v.stimulus,v.prompt_json
 from app.content_items ci join latest v on v.content_item_id=ci.id
 join app.exam_pack_versions epv on epv.id=ci.exam_pack_version_id
 join app.exam_packs ep on ep.id=epv.exam_pack_id join app.subjects s on s.id=ep.subject_id
 where ci.status='published' and v.status='published'
 and s.subject_key in ('ap-chemistry','ap-calculus-ab')
 and nullif(btrim(v.stimulus_image_path),'') is null
 and not (coalesce(v.prompt_json,'{}'::jsonb) ?| array['stimulus_table','stimuli','expected_graph_spec'])
 and concat_ws(' ',ci.title,v.stem,v.stimulus) ~* '\m(figure|image|diagram|graph|chart|plot|scatterplot|histogram|boxplot|dotplot|residual plot|tree diagram|display|table|map|shown above|shown below)\M'
), scoped as (
 select c.*,
 (select jsonb_agg(distinct r.unit_number) from app.content_item_topic_resolution r where r.content_item_version_id=c.content_item_version_id and r.is_primary) as primary_units,
 (select jsonb_agg(distinct r.topic_code) from app.content_item_topic_resolution r where r.content_item_version_id=c.content_item_version_id and r.is_primary) as topics
 from candidates c
)
select s.subject_key,s.content_key,s.content_item_version_id,s.item_type,s.primary_units,s.topics,
 coalesce((select jsonb_agg(jsonb_build_object('units',l.required_units,'status',l.label_status,'superseded',l.superseded_by is not null) order by l.label_status)
 from app.content_taxonomy_labels l where l.content_item_id=s.content_item_id and l.label_scope='serving'),'[]'::jsonb) as serving_labels
from scoped s order by s.subject_key,s.content_key;
