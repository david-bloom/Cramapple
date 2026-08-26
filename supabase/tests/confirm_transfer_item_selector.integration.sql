-- Course Mode — confirm-transfer selector integration coverage (read-only).
--
-- Run as postgres/service administration AFTER
-- 20260826120000_course_mode_confirm_transfer_item_selector.sql and with the
-- AP Statistics Unit-1 pilot content released (200 published MCQs across the 10
-- cells). app.select_confirm_transfer_item is read-only, so this asserts its
-- behavior against the seeded pilot and rolls back (no writes are made).
--
-- Covers: same-cell / different-item selection, the numeric-cell exclusions
-- (1.7×3.B, 1.9×3.B), that 1.9×4.B is NOT excluded, and service-role-only ACL.

begin;

do $$
declare
  v_epv        uuid;
  v_src        uuid;
  v_src_item   uuid;
  v_pick_civ   uuid;
  v_pick_item  uuid;
  v_pick_topic text;
  v_pick_skill text;
  v_pick_type  text;
  v_pick_status text;
  v_count      int;
begin
  -- Function must exist and be service-role only.
  if to_regprocedure('app.select_confirm_transfer_item(uuid,uuid)') is null then
    raise exception 'confirm-transfer selector missing: apply the migration first';
  end if;
  if has_function_privilege(
       'authenticated',
       'app.select_confirm_transfer_item(uuid,uuid)',
       'execute'
     ) then
    raise exception 'select_confirm_transfer_item must not be executable by authenticated';
  end if;
  if not has_function_privilege(
       'service_role',
       'app.select_confirm_transfer_item(uuid,uuid)',
       'execute'
     ) then
    raise exception 'select_confirm_transfer_item must be executable by service_role';
  end if;

  select epv.id into v_epv
  from app.exam_pack_versions epv
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  where ep.exam_code = 'ap_statistics' and epv.school_year = '2026-27';
  if v_epv is null then
    raise exception 'ap_statistics 2026-27 exam pack version not found (seed required)';
  end if;

  ------------------------------------------------------------------------------
  -- Helper: pick a published source version in a given cell.
  ------------------------------------------------------------------------------
  -- [1] Non-numeric cell (1.2 × 2.A): expect exactly one same-cell DIFFERENT item.
  select civ.id, civ.content_item_id into v_src, v_src_item
  from app.content_item_versions civ
  join app.content_items ci on ci.id = civ.content_item_id
  join app.content_item_cells cic on cic.content_item_version_id = civ.id
  where ci.exam_pack_version_id = v_epv
    and ci.status = 'published' and civ.status = 'published'
    and cic.topic_code = '1.2' and cic.skill_code = '2.A'
  limit 1;
  if v_src is null then
    raise exception 'no published 1.2x2.A source item (seed required)';
  end if;

  select count(*) into v_count
  from app.select_confirm_transfer_item(v_epv, v_src);
  if v_count <> 1 then
    raise exception '1.2x2.A: expected exactly 1 transfer item, got %', v_count;
  end if;

  select t.content_item_version_id, t.content_item_id
    into v_pick_civ, v_pick_item
  from app.select_confirm_transfer_item(v_epv, v_src) t;

  if v_pick_civ = v_src then
    raise exception '1.2x2.A: transfer item must be a different version';
  end if;
  if v_pick_item = v_src_item then
    raise exception '1.2x2.A: transfer item must be a different content item';
  end if;

  -- The picked item must be a published MCQ tagged to the SAME cell.
  select cic.topic_code, cic.skill_code, ci.item_type, civ.status
    into v_pick_topic, v_pick_skill, v_pick_type, v_pick_status
  from app.content_item_versions civ
  join app.content_items ci on ci.id = civ.content_item_id
  join app.content_item_cells cic on cic.content_item_version_id = civ.id
  where civ.id = v_pick_civ;
  if v_pick_topic <> '1.2' or v_pick_skill <> '2.A' then
    raise exception '1.2x2.A: transfer item is in the wrong cell (% x %)',
      v_pick_topic, v_pick_skill;
  end if;
  if v_pick_type <> 'mcq' or v_pick_status <> 'published' then
    raise exception '1.2x2.A: transfer item must be a published MCQ (% / %)',
      v_pick_type, v_pick_status;
  end if;

  -- Determinism: same source resolves to the same pick.
  if (select content_item_version_id from app.select_confirm_transfer_item(v_epv, v_src))
     is distinct from v_pick_civ then
    raise exception '1.2x2.A: selector is not deterministic for a fixed source';
  end if;

  ------------------------------------------------------------------------------
  -- [2] Numeric cell 1.7 × 3.B (summary_stats): excluded -> fail closed.
  ------------------------------------------------------------------------------
  select civ.id into v_src
  from app.content_item_versions civ
  join app.content_items ci on ci.id = civ.content_item_id
  join app.content_item_cells cic on cic.content_item_version_id = civ.id
  where ci.exam_pack_version_id = v_epv
    and ci.status = 'published' and civ.status = 'published'
    and cic.topic_code = '1.7' and cic.skill_code = '3.B'
  limit 1;
  if v_src is null then
    raise exception 'no published 1.7x3.B source item (seed required)';
  end if;
  select count(*) into v_count from app.select_confirm_transfer_item(v_epv, v_src);
  if v_count <> 0 then
    raise exception '1.7x3.B is numeric-excluded: expected 0 items, got %', v_count;
  end if;

  ------------------------------------------------------------------------------
  -- [3] Numeric cell 1.9 × 3.B (compare_stats): excluded -> fail closed.
  ------------------------------------------------------------------------------
  select civ.id into v_src
  from app.content_item_versions civ
  join app.content_items ci on ci.id = civ.content_item_id
  join app.content_item_cells cic on cic.content_item_version_id = civ.id
  where ci.exam_pack_version_id = v_epv
    and ci.status = 'published' and civ.status = 'published'
    and cic.topic_code = '1.9' and cic.skill_code = '3.B'
  limit 1;
  if v_src is null then
    raise exception 'no published 1.9x3.B source item (seed required)';
  end if;
  select count(*) into v_count from app.select_confirm_transfer_item(v_epv, v_src);
  if v_count <> 0 then
    raise exception '1.9x3.B is numeric-excluded: expected 0 items, got %', v_count;
  end if;

  ------------------------------------------------------------------------------
  -- [4] Same topic, different skill 1.9 × 4.B (slotframe_4b_compare): NOT excluded.
  ------------------------------------------------------------------------------
  select civ.id into v_src
  from app.content_item_versions civ
  join app.content_items ci on ci.id = civ.content_item_id
  join app.content_item_cells cic on cic.content_item_version_id = civ.id
  where ci.exam_pack_version_id = v_epv
    and ci.status = 'published' and civ.status = 'published'
    and cic.topic_code = '1.9' and cic.skill_code = '4.B'
  limit 1;
  if v_src is null then
    raise exception 'no published 1.9x4.B source item (seed required)';
  end if;
  select count(*) into v_count from app.select_confirm_transfer_item(v_epv, v_src);
  if v_count <> 1 then
    raise exception '1.9x4.B is not excluded: expected 1 item, got %', v_count;
  end if;

  raise notice 'confirm_transfer_item_selector: all assertions passed';
end $$;

rollback;
