-- Truth snapshot for the overnight QA harness (work orders A, B, C, D).
-- Run each block READ-ONLY against Cramapple - Production (pcntajvbdfqhbeewmdry) and save the
-- result as the named file under the harness's --truth directory. The harness is then fully
-- offline: it never needs credentials and cannot touch Production while verifying.
--
-- The point of a separate snapshot is independence. The harness must NOT trust the builder's
-- packet.jsonl; it re-derives Production state here and diffs the packet against it.

-- ===========================================================================
-- items.json  — latest published version per item, for every subject the four
--               work orders touch.
-- ===========================================================================
with pub as (
  select distinct on (civ.content_item_id)
         civ.content_item_id, civ.id as version_id, civ.version_num,
         civ.content_key, civ.subject_key, civ.item_type,
         civ.canonical_answer_1, civ.canonical_answer_2,
         civ.stem, civ.stimulus,
         civ.prompt_json->>'topic'        as prompt_topic,
         civ.prompt_json->>'total_points' as stated_total_points,
         (civ.prompt_json ? 'split_from') as has_split_from,
         civ.prompt_json->>'split_from'   as split_from
  from public.content_item_versions civ
  where civ.status = 'published'
    and civ.subject_key in ('biology','ap-statistics','ap-calculus-ab','ap-chemistry')
  order by civ.content_item_id, civ.version_num desc
)
select p.*,
       coalesce((
         select jsonb_agg(jsonb_build_object(
                  'criterion_key', f.criterion_key,
                  'points_possible', f.points_possible,
                  'learner_facing_text', f.learner_facing_text)
                order by f.criterion_key)
         from public.frq_criteria f
         where f.content_item_version_id = p.version_id), '[]'::jsonb) as criteria
from pub p
order by p.subject_key, p.content_key;

-- ===========================================================================
-- prior_versions.json — every superseded/retired version of an in-scope item.
--                       Work order A recovers from these; the harness must be
--                       able to confirm a "recovered" span really came from one.
-- ===========================================================================
with pub as (
  select distinct on (civ.content_item_id) civ.content_item_id, civ.version_num,
         civ.prompt_json->>'split_from' as split_from
  from public.content_item_versions civ
  where civ.status='published'
    and civ.subject_key in ('biology','ap-statistics','ap-calculus-ab','ap-chemistry')
  order by civ.content_item_id, civ.version_num desc

), priors as (
  select v.content_item_id, v.id as version_id, v.version_num, v.status, v.content_key,
         v.canonical_answer_1, v.canonical_answer_2,
         (select count(*) from public.frq_criteria f where f.content_item_version_id = v.id) as criteria_count
  from public.content_item_versions v
  join pub p on p.content_item_id = v.content_item_id and v.version_num < p.version_num
), parents as (
  -- Retired PARENTS named by prompt_json.split_from. These have no published version, so they are
  -- neither in the published set nor a prior version of one -- and work order A recovers from them
  -- (APBIO-FRQ-S-101/102/103 <- APBIO-FRQ-L-025). Omitting them makes every parent recovery read
  -- as an unresolvable source. This block was added after that false positive was observed.
  select distinct on (v.content_item_id, v.id)
         v.content_item_id, v.id as version_id, v.version_num, v.status, v.content_key,
         v.canonical_answer_1, v.canonical_answer_2,
         (select count(*) from public.frq_criteria f where f.content_item_version_id = v.id) as criteria_count
  from public.content_item_versions v
  where v.content_key in (select distinct split_from from pub where split_from is not null)
)
select * from priors
union all
select * from parents
order by content_item_id, version_num;

-- ===========================================================================
-- closed_list.json — the CED closed lists, with the registry subject_key
--                    normalised to the content subject_key. The registry uses
--                    underscores (ap_biology) and content uses hyphens or a
--                    bare name (biology); joining without normalising matches
--                    zero rows.
-- ===========================================================================
select case
         when sv.subject_key = 'ap_biology' then 'biology'
         else replace(sv.subject_key, '_', '-')
       end                              as subject_key,
       sv.taxonomy_source_version,
       sv.school_year, sv.taxonomy_confidence,
       tt.topic_code, tt.unit_number, tt.topic_title
from app.taxonomy_topics tt
join app.taxonomy_source_versions sv using (taxonomy_source_version)
where sv.subject_key in ('ap_biology','ap_statistics','ap_calculus_ab','ap_chemistry')
order by 1, tt.unit_number, tt.topic_code;
