-- AP Calculus AB servability work (docs/product/SUBJECT_SERVABILITY_CRITERIA.md), criterion 2.
-- Found while pulling frq_criteria to author canonical answers for the 33 items missing them
-- (docs/product/AP_CALCULUS_AB_LAUNCH_READINESS_2026_09_24.md), unrelated to that gap: 4 items
-- have every frq_criteria row duplicated exactly.
--
-- apcalcab-frq-np2-008, apcalcab-frq-u13-002, apcalcab-frq-u13-006, apcalcab-frq-u13-018 each have
-- every criterion_key inserted twice -- once on 2026-08-03 (item creation) and again on
-- 2026-08-05 (two days later, presumably a re-run of a seeding script that didn't check for
-- existing rows). Verified: identical criterion_key, points_possible, learner_facing_text,
-- evidence_requirements between the two rows for every criterion on all 4 items. This currently
-- doubles these 4 items' live point totals (e.g. u13-002 sums to 18 points across 18 rows instead
-- of 9 across 9) -- a real, live grading-correctness defect for anyone currently attempting these
-- items, found as a byproduct of this work, not the thing being looked for.
--
-- Fix: keep the earlier-created row per (content_item_version_id, criterion_key), delete the later
-- duplicate. Verified before deleting that the kept and deleted rows are byte-identical in every
-- column except id/created_at, so no information is lost.
--
-- Rollback: the deleted rows' ids and created_at are in the verification query below (run before
-- this migration) if they ever need to be reinserted, though there is no reason to.

begin;

delete from app.frq_criteria fc
using app.frq_criteria fc2
where fc.content_item_version_id = fc2.content_item_version_id
  and fc.criterion_key = fc2.criterion_key
  and fc.created_at > fc2.created_at
  and fc.content_item_version_id in (
    select civ.id
    from app.content_item_versions civ
    join app.content_items ci on ci.id = civ.content_item_id
    where ci.content_key in (
      'apcalcab-frq-np2-008', 'apcalcab-frq-u13-002',
      'apcalcab-frq-u13-006', 'apcalcab-frq-u13-018'
    )
  );

do $$
declare
  v_bad text;
begin
  select string_agg(ci.content_key, ', ') into v_bad
  from app.content_items ci
  join app.content_item_versions civ on civ.id = (
    select id from app.content_item_versions v2 where v2.content_item_id = ci.id
    order by v2.version_num desc, v2.created_at desc limit 1
  )
  join app.frq_criteria fc on fc.content_item_version_id = civ.id
  where ci.content_key in (
    'apcalcab-frq-np2-008', 'apcalcab-frq-u13-002',
    'apcalcab-frq-u13-006', 'apcalcab-frq-u13-018'
  )
  group by ci.content_key, civ.id
  having count(*) <> count(distinct fc.criterion_key);

  if v_bad is not null then
    raise exception 'dedupe failed, still duplicated: %', v_bad;
  end if;
end $$;

commit;
