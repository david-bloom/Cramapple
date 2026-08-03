-- AP Statistics FRQ remediation, Phase 1.
-- Plan: docs/research/AP_STATISTICS_FRQ_REMEDIATION_PLAN_2026_08_01.md
-- Retires category-A items: AP Statistics FRQs whose latest content_item_version
-- has exactly one frq_criteria row (single-criterion, 1-point "short answer" items
-- that are neither exam-shaped nor multi-part drills). Reviewer (Jill) explicitly
-- flagged this category on 2026-08-01. Confirmed unaffected by
-- prevent_live_frq_reclassification (only status changes; practice_format,
-- frq_archetype, frq_form untouched) and by content_pipeline_guard_publish (only
-- guards transitions INTO 'published').
--
-- Pre-execution checks completed 2026-08-01:
--  - No hardcoded content_key reference to any selected item found in application
--    source (frontend worktrees, edge functions) — only frozen research JSON
--    snapshots and one unrelated test-fixture string.
--  - 15 of the 90 have synthetic grading-pilot attempt history
--    (user grading-pilot-20260728-...+test, 2026-07-28) against 3 content_keys;
--    confirmed non-production test account, zero real-student exposure.
--
-- Audit / rollback: pre-change state captured in this comment block below.
-- Rollback: UPDATE app.content_items SET status = 'published' WHERE content_key IN
-- (the subset below that was 'published' pre-change) -- do not blanket-restore
-- retired-from-other-statuses rows to 'published'.

with latest as (
  select ci.id, ci.content_key,
         (select v.id from app.content_item_versions v
          where v.content_item_id = ci.id order by v.version_num desc limit 1) as vid
  from app.content_items ci
  where ci.item_type = 'frq'
    and split_part(ci.content_key, '-', 1) in ('APSTAT', 'APSTATS', 'STATS')
    and ci.content_key not like 'APSTATS-HDG-%'
), single_criterion as (
  select l.id
  from latest l
  join app.frq_criteria fc on fc.content_item_version_id = l.vid
  group by l.id
  having count(fc.id) = 1 and sum(fc.points_possible) = 1
)
update app.content_items
set status = 'retired'
where id in (select id from single_criterion)
  and status <> 'retired';
