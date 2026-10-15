-- SELECT only, published content. Emulate guide reference alias/order and
-- figure linkage so local contract.ts can measure exact JSON.stringify size.
with q as (
 select distinct s.subject_key,cell.topic_code,cell.unit_number
 from app.content_items ci join app.content_item_versions v on v.content_item_id=ci.id
 join app.exam_pack_versions epv on epv.id=ci.exam_pack_version_id
 join app.exam_packs ep on ep.id=epv.exam_pack_id
 join app.subjects s on s.id=ep.subject_id
 cross join lateral (select cc.topic_code,tt.unit_number from app.content_item_cells cc
  left join app.taxonomy_topics tt on tt.taxonomy_source_version=cc.taxonomy_source_version and tt.topic_code=cc.topic_code
  where cc.content_item_version_id=v.id and cc.superseded_by is null
  order by cc.is_primary desc nulls last,cc.created_at limit 1) cell
 where ci.status='published' and v.status='published'
 and s.subject_key in ('ap-calculus-ab','ap-calculus-bc','ap-chemistry') and cell.topic_code is not null
), refs as (
 select q.subject_key request_subject,q.topic_code requested_topic,r.* from q join app.unit_reference_entries r on r.status='published' and q.topic_code=any(r.topic_codes)
 where r.subject_key=replace(q.subject_key,'-','_') or exists (
  select 1 from app.subject_reference_aliases a where a.subject_key=replace(q.subject_key,'-','_')
  and a.source_subject_key=r.subject_key and r.unit_number between a.unit_from and a.unit_to
  and not exists(select 1 from app.unit_reference_entries own where own.subject_key=a.subject_key and own.status='published'
    and own.owner_topic_code=r.owner_topic_code and own.kind=r.kind and own.title=r.title)
  and exists(select 1 from app.taxonomy_topics t where t.topic_code=r.owner_topic_code and t.taxonomy_source_version=(
   select tsv.taxonomy_source_version from app.taxonomy_source_versions tsv where tsv.subject_key=a.subject_key
   order by tsv.verified_at desc nulls last,tsv.created_at desc limit 1)))
)
select q.subject_key,q.topic_code,q.unit_number,
 coalesce((select jsonb_agg(jsonb_build_object('id',r.reference_entry_id,'kind',r.kind,'title',r.title,'body',r.body,
 'items',r.items,'caution',r.caution,'ownerTopicCode',r.owner_topic_code,'topicCodes',r.topic_codes,
 'memoryHooks',coalesce((select jsonb_agg(jsonb_build_object('id',h.memory_hook_id,'kind',h.kind,'hookText',h.hook_text,
  'expandsTo',h.expands_to,'whenToUse',h.when_to_use,'caution',h.caution) order by h.created_at)
  from app.topic_memory_hooks h where h.reference_entry_id=r.reference_entry_id and h.status='published'),'[]'::jsonb))
 order by array_position(array['formula','vocabulary','list_sequence','convention','diagram'],r.kind),r.unit_number,
 split_part(r.owner_topic_code,'.',1)::integer,split_part(r.owner_topic_code,'.',2)::integer,r.title)
 from refs r where r.request_subject=q.subject_key and r.requested_topic=q.topic_code),'[]'::jsonb) reference,
 coalesce((select jsonb_agg(jsonb_build_object('figureId',f.figure_id,'family',f.family,'title',f.title,'shortTitle',f.short_title,
 'subtitle',f.subtitle,'caption',f.caption,'alt',f.alt,'xLabel',f.x_label,'yLabel',f.y_label,'note',f.note,'synthetic',f.synthetic,
 'valuesNote',f.values_note,'labels',f.labels,'params',f.params,'yTickFmt',f.y_tick_fmt,'xTickFmt',f.x_tick_fmt,
 'usedBy',(select jsonb_agg(jsonb_build_object('kind','reference_entry','id',u.reference_entry_id,'role',u.role) order by u.created_at)
  from app.figure_uses u where u.figure_id=f.figure_id and exists(select 1 from refs r where r.reference_entry_id=u.reference_entry_id
   and r.request_subject=q.subject_key and r.requested_topic=q.topic_code))) order by f.figure_id)
 from app.figures f where f.status='published' and exists(select 1 from app.figure_uses u join refs r on r.reference_entry_id=u.reference_entry_id
 where u.figure_id=f.figure_id and r.request_subject=q.subject_key and r.requested_topic=q.topic_code)),'[]'::jsonb) figures
from q order by q.subject_key,q.topic_code;
