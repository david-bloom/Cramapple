-- AP Statistics FRQ remediation, Phase 2 (2c), part 2 of 2: the backfill itself.
-- Plan: docs/research/AP_STATISTICS_FRQ_REMEDIATION_PLAN_2026_08_01.md
-- Same rule as the Phase 2a migration (backfill_practice_format_unpublished_stats_drills),
-- now unblocked by the preceding trigger migration for the 50 items that carry
-- (or carried) a published content_item_version row: 48 currently 'published',
-- plus APSTATS-HDG-2026-GRAPH-005 (reviewed_approved) and APSTATS-SFRQ-018
-- (retired), both of which have a published version in history despite their
-- current item status. This is only frq_archetype/frq_form-neutral, so the
-- trigger exception applies cleanly.
--
-- Excludes category A (single-criterion) items, including the 90 retired in
-- Phase 1 and APSTATS-SFRQ-018's neighbors -- category A items are not drills
-- and do not get practice_format set.
--
-- Selection count verified pre-execution: 50 items.

with latest as (
  select ci.id, ci.content_key, ci.status,
         (select v.id from app.content_item_versions v
          where v.content_item_id = ci.id order by v.version_num desc limit 1) as vid
  from app.content_items ci
  where ci.item_type = 'frq'
    and split_part(ci.content_key, '-', 1) in ('APSTAT', 'APSTATS', 'STATS')
    and ci.practice_format is null
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
  where (is_hdg or (pts = 4 and n_crit = 4) or (not is_hdg and pts <> 1 and pts <> 4))
)
update app.content_items
set practice_format = 'targeted_drill'
where id in (select id from eligible)
  and practice_format is null;
