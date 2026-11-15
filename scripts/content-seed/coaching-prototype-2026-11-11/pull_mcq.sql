with base as (
  select s.subject_key, case when s.subject_key='biology' then 'ap_biology' else 'ap_statistics' end brief_key,
         ci.content_key id, v.id vid, v.stem, c.topic_code,
         row_number() over (partition by s.subject_key, c.topic_code order by md5(ci.content_key)) rn
  from app.content_items ci
  join app.exam_pack_versions epv on epv.id=ci.exam_pack_version_id and epv.retired_at is null
  join app.exam_packs ep on ep.id=epv.exam_pack_id
  join app.subjects s on s.id=ep.subject_id and s.subject_key in ('biology','ap-statistics')
  join app.content_item_versions v on v.content_item_id=ci.id and v.status='published'
  join app.content_item_cells c on c.content_item_version_id=v.id and c.is_primary and c.superseded_by is null
  where ci.item_type='mcq' and ci.status='published' and v.stem is not null and length(v.stem) between 60 and 900
    and v.stimulus is null and v.stimulus_image_path is null
    and ci.content_key not in ('APSTATS-MCQ-H-2.8-A','APSTATS-MCQ-H-4.5-A','APSTATS-MCQ-H-2.5-A','apstats-mcq-b6-h-1.12-a','apbio-mcq-b4-h-4.4-a','APBIO-MCQ-136','apbio-mcq-b4-h-4.2-a','APBIO-MCQ-128')
    and (select count(*) from app.mcq_choices m where m.content_item_version_id=v.id)=4
), pick as (
  select *, row_number() over (partition by subject_key order by md5(id)) k from base b
  where rn=1 and exists (select 1 from app.topic_point_briefs bb where bb.subject_key=b.brief_key and bb.topic_code=b.topic_code and bb.status='published')
)
select json_agg(json_build_object(
  'id', p.id, 'subject', case when p.subject_key='biology' then 'AP Biology' else 'AP Statistics' end,
  'topic', p.topic_code || ' ' || coalesce((select b.title from app.topic_point_briefs b where b.subject_key=p.brief_key and b.topic_code=p.topic_code limit 1),''),
  'stem', p.stem,
  'choices', (select json_agg(json_build_object('k',m.choice_key,'t',m.choice_text,'ok',m.is_correct,'r',m.rationale) order by m.choice_key) from app.mcq_choices m where m.content_item_version_id=p.vid),
  'brief', (select json_build_object('earned',b.how_points_are_earned,'move',b.answer_move,'loss',b.common_point_loss) from app.topic_point_briefs b where b.subject_key=p.brief_key and b.topic_code=p.topic_code limit 1),
  'core', (select e.core_idea from app.topic_explainers e where e.subject_key=p.brief_key and e.topic_code=p.topic_code limit 1)
)) as items from pick p where p.k<=15;
