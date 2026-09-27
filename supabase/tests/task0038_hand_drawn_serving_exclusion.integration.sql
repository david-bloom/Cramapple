-- TASK-0038 Phase 1 — hand-drawn items must never come back from the real
-- text-answer student selectors (select_practice_frqs /
-- select_unit_gated_practice_items). Read-only: calls the functions, makes
-- no writes, nothing to roll back.
--
-- Deliberately data-dependent rather than fixture-based: content_items /
-- content_item_versions carry several BEFORE INSERT/UPDATE publish-gate
-- triggers (enforce_publish_gate, tg_content_pipeline_guard_publish,
-- tg_require_practice_format_at_publish, prevent_live_frq_reclassification)
-- that a synthetic "published" fixture would have to satisfy exactly to be
-- representative -- and a fixture that quietly diverges from those real
-- gates would prove less than it looks like it proves. This instead asserts
-- against whatever real published hand-drawn content the target database
-- actually has, and skips (not fails) when none exists, so it is safe to run
-- against Development (which currently has none) and meaningful against
-- Production (which does, per the audit that opened TASK-0038).

begin;

do $$
declare
  v_pack        record;
  v_leaked      int;
  v_any_pack    boolean := false;
begin
  for v_pack in
    select distinct ci.exam_pack_version_id
    from app.content_items ci
    join app.content_item_versions civ on civ.content_item_id = ci.id
    where ci.status = 'published'
      and civ.status = 'published'
      and ci.practice_format = 'targeted_drill'
      and coalesce((civ.prompt_json->>'hand_drawn')::boolean, false) is true
  loop
    v_any_pack := true;

    select count(*) into v_leaked
    from public.select_practice_frqs(v_pack.exam_pack_version_id, 'targeted_drill', 50) r
    where coalesce((r.prompt_json->>'hand_drawn')::boolean, false) is true;

    if v_leaked <> 0 then
      raise exception
        'select_practice_frqs leaked % hand-drawn item(s) for exam_pack_version_id %',
        v_leaked, v_pack.exam_pack_version_id;
    end if;

    select count(*) into v_leaked
    from public.select_practice_frqs(v_pack.exam_pack_version_id, 'full_exam_frq', 50) r
    where coalesce((r.prompt_json->>'hand_drawn')::boolean, false) is true;

    if v_leaked <> 0 then
      raise exception
        'select_practice_frqs (full_exam_frq) leaked % hand-drawn item(s) for exam_pack_version_id %',
        v_leaked, v_pack.exam_pack_version_id;
    end if;
  end loop;

  if not v_any_pack then
    raise notice
      'task0038_hand_drawn_serving_exclusion: no published targeted_drill hand-drawn content in this database -- selector-exclusion assertions skipped (not failed). Run against Production for real coverage.';
  else
    raise notice 'task0038_hand_drawn_serving_exclusion: select_practice_frqs assertions passed';
  end if;
end $$;

-- Same check for select_unit_gated_practice_items, whose serving-eligibility
-- additionally requires a validated app.content_taxonomy_labels row per
-- item -- most real hand-drawn content has none yet (see TASK-0025's own
-- notes on this selector returning zero rows in Production), so this loop
-- is expected to skip on every database until that changes. It stays here
-- so the assertion fires automatically the moment it becomes reachable.
do $$
declare
  v_pack     record;
  v_leaked   int;
  v_any_pack boolean := false;
begin
  for v_pack in
    select distinct ci.exam_pack_version_id
    from app.content_items ci
    join app.content_item_versions civ on civ.content_item_id = ci.id
    join app.content_taxonomy_labels ctl
      on ctl.content_item_id = ci.id
     and ctl.label_scope = 'serving'
     and ctl.label_status = 'validated'
     and ctl.superseded_by is null
    where ci.status = 'published'
      and civ.status = 'published'
      and coalesce((civ.prompt_json->>'hand_drawn')::boolean, false) is true
  loop
    v_any_pack := true;

    select count(*) into v_leaked
    from public.select_unit_gated_practice_items(v_pack.exam_pack_version_id, 12, null, null, 50) r
    where coalesce((r.prompt_json->>'hand_drawn')::boolean, false) is true;

    if v_leaked <> 0 then
      raise exception
        'select_unit_gated_practice_items leaked % hand-drawn item(s) for exam_pack_version_id %',
        v_leaked, v_pack.exam_pack_version_id;
    end if;
  end loop;

  if not v_any_pack then
    raise notice
      'task0038_hand_drawn_serving_exclusion: no validated-taxonomy-labeled hand-drawn content in this database -- select_unit_gated_practice_items assertion skipped (not failed).';
  else
    raise notice 'task0038_hand_drawn_serving_exclusion: select_unit_gated_practice_items assertions passed';
  end if;
end $$;

rollback;
