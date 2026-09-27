-- content_item_topic_resolution status gate — integration coverage.
--
-- Run after 20260927004700_content_item_topic_resolution_view.sql against a
-- target carrying real content_item_cells data. Read-only; makes no data
-- changes. Verifies the safety property that cannot be exercised from the
-- Deno mock test suite in supabase/functions/student-session-items/
-- index_test.ts, because the filter lives entirely in this SQL view, not in
-- application code: an unvalidated (provisional_model / legacy_unvalidated /
-- stale / held) row must never appear through the view, regardless of how
-- many such rows exist in the underlying table. This is the property
-- CONTENT_TAXONOMY_RATIONALIZATION_PLAN_2026_09_26.md decision #2 requires
-- (deferred to post-launch, not resolved) and DECISION-0067 (2026-09-24)
-- already established for the predecessor system this view replaced.

begin;

do $$
declare
  v_unvalidated_visible integer;
  v_authored_visible integer;
  v_validated_visible integer;
  v_total_cells integer;
begin
  if to_regclass('app.content_item_topic_resolution') is null then
    raise exception 'content_item_topic_resolution missing: apply the migration first';
  end if;

  select count(*) into v_total_cells from app.content_item_cells;

  -- The core property: nothing with an unvalidated status is visible,
  -- however many such rows exist underneath.
  select count(*) into v_unvalidated_visible
  from app.content_item_topic_resolution r
  join app.content_item_cells c on c.content_item_cell_id = r.content_item_cell_id
  where c.assignment_status not in ('validated', 'authored');

  if v_unvalidated_visible > 0 then
    raise exception
      'SAFETY VIOLATION: % row(s) with an unvalidated assignment_status are visible through content_item_topic_resolution -- decision #2 requires these stay hidden until validated',
      v_unvalidated_visible;
  end if;

  -- Sanity check the filter isn't accidentally hiding everything (a filter
  -- so strict it always returns zero rows would also "pass" the check
  -- above without proving anything).
  select count(*) into v_authored_visible
  from app.content_item_topic_resolution r
  join app.content_item_cells c on c.content_item_cell_id = r.content_item_cell_id
  where c.assignment_status = 'authored';

  select count(*) into v_validated_visible
  from app.content_item_topic_resolution r
  join app.content_item_cells c on c.content_item_cell_id = r.content_item_cell_id
  where c.assignment_status = 'validated';

  if v_total_cells > 0 and (v_authored_visible + v_validated_visible) = 0 then
    raise exception
      'content_item_topic_resolution returned zero rows against a non-empty content_item_cells table (%) -- the view or its status filter may be broken, not just conservative',
      v_total_cells;
  end if;

  raise notice
    'content_item_topic_resolution status gate OK: % cells total, % authored visible, % validated visible, 0 unvalidated visible',
    v_total_cells, v_authored_visible, v_validated_visible;
end $$;

rollback;
