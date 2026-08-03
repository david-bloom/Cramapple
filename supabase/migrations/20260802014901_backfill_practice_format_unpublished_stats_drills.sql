-- AP Statistics FRQ remediation, Phase 2a.
-- Plan: docs/research/AP_STATISTICS_FRQ_REMEDIATION_PLAN_2026_08_01.md
-- Backfills practice_format = 'targeted_drill' on category B/C/D AP Statistics
-- FRQs (4-point multi-part, undersized "long", and hand-drawn-graph items) that
-- are NOT currently published and carry no content_item_version row with
-- status = 'published' -- i.e. items where old.practice_format IS NULL and no
-- prevent_live_frq_reclassification concern applies under any reading, because
-- these items have never been servable through select_practice_frqs (which
-- requires an exact, non-null practice_format match) and were never live.
--
-- Deliberately excludes two items that otherwise match category B/C/D and are
-- not currently 'published' but DO carry a stale published-version row and so
-- fall under the same guard as the 48 currently-published items, pending a
-- separate decision (2b vs 2c) on those 50 items as a group:
--   APSTATS-HDG-2026-GRAPH-005 (status: reviewed_approved)
--   APSTATS-SFRQ-018           (status: retired)
--
-- Selection count verified pre-execution: 18 items.

with latest as (
  select ci.id, ci.content_key, ci.status,
         (select v.id from app.content_item_versions v
          where v.content_item_id = ci.id order by v.version_num desc limit 1) as vid
  from app.content_items ci
  where ci.item_type = 'frq'
    and split_part(ci.content_key, '-', 1) in ('APSTAT', 'APSTATS', 'STATS')
), agg as (
  select l.id, l.content_key, l.status, count(fc.id) as n_crit,
         coalesce(sum(fc.points_possible), 0) as pts,
         (l.content_key like 'APSTATS-HDG-%') as is_hdg
  from latest l
  left join app.frq_criteria fc on fc.content_item_version_id = l.vid
  group by 1, 2, 3, 6
), eligible as (
  select id
  from agg
  where status <> 'published'
    and (is_hdg or (pts = 4 and n_crit = 4) or (not is_hdg and pts <> 1 and pts <> 4))
    and not exists (
      select 1 from app.content_item_versions v
      where v.content_item_id = agg.id and v.status = 'published'
    )
)
update app.content_items
set practice_format = 'targeted_drill'
where id in (select id from eligible)
  and practice_format is null;
