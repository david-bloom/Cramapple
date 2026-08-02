-- AP Statistics FRQ remediation, Phase 2 (2c), part 1 of 2: guard exception.
-- Plan: docs/research/AP_STATISTICS_FRQ_REMEDIATION_PLAN_2026_08_01.md
-- Decision: David Bloom, 2026-08-01, choosing 2c over 2b (full retire/re-review
-- cycle) and over deferring. Both independent model reviews flagged this as the
-- largest remaining judgment call in the plan.
--
-- prevent_live_frq_reclassification exists to stop a served FRQ's shape from
-- changing under students who already attempted it. This adds ONE narrow,
-- precisely-scoped exception: backfilling practice_format from NULL is not a
-- reclassification, because select_practice_frqs (the only FRQ practice-session
-- serving RPC; verified live in Production 2026-08-01) requires an exact,
-- non-null practice_format match with no NULL fallback -- an item with
-- practice_format IS NULL was structurally never reachable through that path
-- under any format, so there is no served state to protect.
--
-- The exception applies ONLY when practice_format is the sole thing changing.
-- frq_archetype and frq_form remain fully guarded in every case, including this
-- one -- a change to either of those columns still raises, even when
-- old.practice_format was null. This is a deliberately narrower carve-out than
-- "if old.practice_format is null, skip the whole check."
--
-- Bypass-surface check completed 2026-08-01: free-score-check is the only
-- student-facing surface reading content_items/content_item_versions directly
-- (outside this RPC), and it is hardcoded to subject_key = 'biology' in three
-- places; it cannot reach an AP Statistics row. use-published-mcq.ts filters
-- item_type = 'mcq' and structurally cannot read FRQ rows. No other
-- student-facing surface was found.

create or replace function app.prevent_live_frq_reclassification()
 returns trigger
 language plpgsql
 set search_path to 'pg_catalog'
as $function$
begin
  if (
    new.practice_format is distinct from old.practice_format
    or new.frq_archetype is distinct from old.frq_archetype
    or new.frq_form is distinct from old.frq_form
  )
  and exists (
    select 1
    from app.content_item_versions civ
    where civ.content_item_id = old.id
      and civ.status = 'published'
  )
  and not (
    old.practice_format is null
    and new.frq_archetype is not distinct from old.frq_archetype
    and new.frq_form is not distinct from old.frq_form
  )
  then
    raise exception
      'published_frq_reclassification_requires_retirement:%',
      old.content_key;
  end if;
  return new;
end
$function$;
