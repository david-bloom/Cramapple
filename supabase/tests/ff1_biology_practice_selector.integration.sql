-- FF-1 — Biology combined practice selector integration coverage.
--
-- Run after 20260924200000_ff1_biology_combined_practice_selector.sql against
-- a target carrying the current Production Biology corpus. The selector is
-- read-only; this test makes no data changes.

begin;

do $$
declare
  v_biology_epv uuid;
  v_other_epv uuid;
  v_seed_one constant uuid := '11111111-1111-4111-8111-111111111111';
  v_seed_two constant uuid := '22222222-2222-4222-8222-222222222222';
  v_total integer;
  v_frq integer;
  v_mcq integer;
  v_bad_type integer;
  v_hand_drawn integer;
  v_columns text[];
  v_first uuid[];
  v_repeat uuid[];
  v_rotated uuid[];
  v_definition text;
  v_mcq_version uuid;
begin
  if to_regprocedure(
    'app.select_biology_practice_items(uuid,text,uuid,integer)'
  ) is null then
    raise exception 'FF-1 selector missing: apply the migration first';
  end if;

  -- Function security and execution boundary.
  if has_function_privilege(
    'public',
    'app.select_biology_practice_items(uuid,text,uuid,integer)',
    'execute'
  ) then
    raise exception 'PUBLIC must not execute select_biology_practice_items';
  end if;
  if has_function_privilege(
    'anon',
    'app.select_biology_practice_items(uuid,text,uuid,integer)',
    'execute'
  ) then
    raise exception 'anon must not execute select_biology_practice_items';
  end if;
  if has_function_privilege(
    'authenticated',
    'app.select_biology_practice_items(uuid,text,uuid,integer)',
    'execute'
  ) then
    raise exception 'authenticated must not execute select_biology_practice_items';
  end if;
  if not has_function_privilege(
    'service_role',
    'app.select_biology_practice_items(uuid,text,uuid,integer)',
    'execute'
  ) then
    raise exception 'service_role must execute select_biology_practice_items';
  end if;

  select pg_get_functiondef(p.oid)
    into v_definition
  from pg_proc p
  join pg_namespace n on n.oid = p.pronamespace
  where n.nspname = 'app'
    and p.proname = 'select_biology_practice_items'
    and p.proargtypes = '2950 25 2950 23'::oidvector
    and p.prosecdef is false
    and p.provolatile = 's'
    and p.proconfig = array['search_path=pg_catalog'];
  if v_definition is null then
    raise exception
      'selector must be STABLE SECURITY INVOKER with search_path=pg_catalog';
  end if;
  if lower(v_definition) like '%select *%' then
    raise exception 'selector definition must never use SELECT *';
  end if;

  select p.proargnames[5:17]
    into v_columns
  from pg_proc p
  join pg_namespace n on n.oid = p.pronamespace
  where n.nspname = 'app'
    and p.proname = 'select_biology_practice_items'
    and p.proargtypes = '2950 25 2950 23'::oidvector;
  if v_columns is distinct from array[
    'content_item_version_id', 'content_item_id', 'content_key', 'title',
    'item_type', 'stem', 'stimulus', 'stimulus_image_path', 'prompt_json',
    'frq_form', 'practice_format', 'frq_archetype', 'published_at'
  ]::text[] then
    raise exception 'unexpected selector columns: %', v_columns;
  end if;
  if v_columns && array[
    'is_correct', 'rationale', 'explanation', 'canonical_answer_1',
    'canonical_answer_2'
  ]::text[] then
    raise exception 'answer-bearing field present in selector columns: %', v_columns;
  end if;

  select epv.id
    into v_biology_epv
  from app.exam_pack_versions epv
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  where ep.exam_code = 'ap_biology'
    and epv.status = 'published'
  order by epv.created_at desc
  limit 1;
  if v_biology_epv is null then
    raise exception 'published AP Biology exam pack version not found';
  end if;

  select epv.id
    into v_other_epv
  from app.exam_pack_versions epv
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  where ep.exam_code <> 'ap_biology'
    and epv.status = 'published'
  order by ep.exam_code, epv.created_at desc
  limit 1;

  select
    count(*)::integer,
    count(*) filter (where item_type = 'frq')::integer,
    count(*) filter (where item_type = 'mcq')::integer,
    count(*) filter (where item_type not in ('frq', 'mcq'))::integer,
    count(*) filter (
      where coalesce((prompt_json->>'hand_drawn')::boolean, false) is true
    )::integer
  into v_total, v_frq, v_mcq, v_bad_type, v_hand_drawn
  from app.select_biology_practice_items(
    v_biology_epv, 'targeted_drill', v_seed_one, 20
  );

  if (v_total, v_frq, v_mcq) is distinct from (20, 12, 8) then
    raise exception
      'expected current-pool mix 20 = 12 FRQ + 8 MCQ, got % = % FRQ + % MCQ',
      v_total, v_frq, v_mcq;
  end if;
  if v_bad_type <> 0 then
    raise exception 'selector returned % rows without explicit FRQ/MCQ item_type', v_bad_type;
  end if;
  if v_hand_drawn <> 0 then
    raise exception 'selector leaked % hand-drawn item(s)', v_hand_drawn;
  end if;

  select array_agg(content_item_version_id order by ordinality)
    into v_first
  from app.select_biology_practice_items(
    v_biology_epv, 'targeted_drill', v_seed_one, 20
  ) with ordinality;
  select array_agg(content_item_version_id order by ordinality)
    into v_repeat
  from app.select_biology_practice_items(
    v_biology_epv, 'targeted_drill', v_seed_one, 20
  ) with ordinality;
  select array_agg(content_item_version_id order by ordinality)
    into v_rotated
  from app.select_biology_practice_items(
    v_biology_epv, 'targeted_drill', v_seed_two, 20
  ) with ordinality;

  if v_first is distinct from v_repeat then
    raise exception 'same selection seed did not return stable order';
  end if;
  if v_first is not distinct from v_rotated then
    raise exception 'different selection seed did not rotate the queue';
  end if;

  if exists (
    select 1
    from app.select_biology_practice_items(
      v_biology_epv, 'full_exam_frq', v_seed_one, 20
    )
  ) then
    raise exception 'non-targeted format must fail closed';
  end if;
  if v_other_epv is not null and exists (
    select 1
    from app.select_biology_practice_items(
      v_other_epv, 'targeted_drill', v_seed_one, 20
    )
  ) then
    raise exception 'non-Biology pack must fail closed';
  end if;
  if exists (
    select 1
    from app.select_biology_practice_items(
      v_biology_epv, 'targeted_drill', null, 20
    )
  ) then
    raise exception 'NULL selection seed must fail closed';
  end if;

  -- Turn one otherwise-eligible MCQ into a hand-drawn item inside this
  -- transaction, then prove the selector excludes that exact row. ROLLBACK
  -- below restores the fixture.
  select civ.id
    into v_mcq_version
  from app.content_items ci
  join app.content_item_versions civ on civ.content_item_id = ci.id
  where ci.exam_pack_version_id = v_biology_epv
    and ci.item_type = 'mcq'
    and ci.status = 'published'
    and civ.status = 'published'
    and coalesce((civ.prompt_json->>'hand_drawn')::boolean, false) is not true
  order by civ.id
  limit 1;
  if v_mcq_version is null then
    raise exception 'eligible Biology MCQ fixture not found';
  end if;

  update app.content_item_versions
  set prompt_json = jsonb_set(
    coalesce(prompt_json, '{}'::jsonb),
    '{hand_drawn}',
    'true'::jsonb,
    true
  )
  where id = v_mcq_version;

  if exists (
    select 1
    from app.select_biology_practice_items(
      v_biology_epv, 'targeted_drill', v_seed_one, 50
    ) served
    where served.content_item_version_id = v_mcq_version
  ) then
    raise exception 'published hand-drawn Biology MCQ was served';
  end if;

  raise notice 'ff1_biology_practice_selector: all assertions passed';
end $$;

rollback;
