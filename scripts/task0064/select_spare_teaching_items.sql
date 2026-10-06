-- TASK-0064 — choose one "spare" Open Hand teaching item per topic.
-- Read-only. Run, review, then insert the chosen rows into
-- app.open_hand_teaching_items with source = 'spare'.
--
-- Eligible topic: >= 5 published MCQs (primary topic label) on an active
-- subject's published, non-retired pack. Eligible item: >= 4 choices, every
-- choice rationale >= 25 characters, stem does not repeat the choices inline.
-- Pick: longest shortest-rationale (weakest explanation is strongest), then
-- oldest item, so the choice is deterministic.
with servable as (
  select civ.id as civ_id, ci.id as ci_id, ci.content_key, ci.created_at,
         s.subject_key, civ.stem,
         (select r.topic_code from app.content_item_topic_resolution r
           where r.content_item_version_id = civ.id and r.is_primary limit 1) as topic_code
  from app.content_item_versions civ
  join app.content_items ci on ci.id = civ.content_item_id
  join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  join app.subjects s on s.id = ep.subject_id
  where civ.status = 'published' and ci.status = 'published'
    and epv.status = 'published' and epv.retired_at is null
    and s.status = 'active' and ci.item_type = 'mcq'
    and not exists (select 1 from app.open_hand_teaching_items t
                    where t.content_item_id = ci.id and t.released_at is null)
), scored as (
  select sv.*,
    (select count(*) from app.mcq_choices mc where mc.content_item_version_id = sv.civ_id) as n_choices,
    (select min(length(trim(coalesce(mc.rationale, ''))))
       from app.mcq_choices mc where mc.content_item_version_id = sv.civ_id) as min_rationale,
    count(*) over (partition by sv.subject_key, sv.topic_code) as topic_mcqs
  from servable sv
  where sv.topic_code is not null
), eligible as (
  select * from scored
  where topic_mcqs >= 5 and n_choices >= 4 and min_rationale >= 25
    and coalesce(stem, '') !~* '(^|\s)A[.)]\s.*(^|\s)B[.)]\s'
)
select distinct on (subject_key, topic_code)
  subject_key, topic_code, ci_id as content_item_id, content_key, topic_mcqs, min_rationale
from eligible
order by subject_key, topic_code, min_rationale desc, created_at, ci_id;
