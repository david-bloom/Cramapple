-- TASK-0044 AP Statistics ordinary combined selector integration coverage.
-- Run after both TASK-0044 selector migrations. Read-only.

begin;

do $$
declare
  v_statistics_epv uuid;
  v_other_epv uuid;
  v_seed_one constant uuid := '11111111-1111-4111-8111-111111111111';
  v_seed_two constant uuid := '22222222-2222-4222-8222-222222222222';
  v_total integer;
  v_frq integer;
  v_mcq integer;
  v_bad_type integer;
  v_hand_drawn integer;
  v_unanswerable integer;
  v_columns text[];
  v_first uuid[];
  v_repeat uuid[];
  v_rotated uuid[];
  v_definition text;
begin
  if to_regprocedure(
    'app.select_ordinary_combined_practice_items(uuid,text,uuid,integer)'
  ) is null then
    raise exception 'TASK-0044 selector missing: apply both migrations first';
  end if;

  if has_function_privilege(
    'public',
    'app.select_ordinary_combined_practice_items(uuid,text,uuid,integer)',
    'execute'
  ) then
    raise exception 'PUBLIC must not execute combined selector';
  end if;
  if has_function_privilege(
    'anon',
    'app.select_ordinary_combined_practice_items(uuid,text,uuid,integer)',
    'execute'
  ) then
    raise exception 'anon must not execute combined selector';
  end if;
  if has_function_privilege(
    'authenticated',
    'app.select_ordinary_combined_practice_items(uuid,text,uuid,integer)',
    'execute'
  ) then
    raise exception 'authenticated must not execute combined selector';
  end if;
  if not has_function_privilege(
    'service_role',
    'app.select_ordinary_combined_practice_items(uuid,text,uuid,integer)',
    'execute'
  ) then
    raise exception 'service_role must execute combined selector';
  end if;

  select pg_get_functiondef(p.oid)
    into v_definition
  from pg_proc p
  join pg_namespace n on n.oid = p.pronamespace
  where n.nspname = 'app'
    and p.proname = 'select_ordinary_combined_practice_items'
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
    and p.proname = 'select_ordinary_combined_practice_items'
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
    into v_statistics_epv
  from app.exam_pack_versions epv
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  where ep.exam_code = 'ap_statistics'
    and epv.status = 'published'
    and epv.retired_at is null
  order by epv.created_at desc
  limit 1;
  if v_statistics_epv is null then
    raise exception 'published AP Statistics exam pack version not found';
  end if;

  select epv.id
    into v_other_epv
  from app.exam_pack_versions epv
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  where ep.exam_code <> 'ap_statistics'
    and epv.status = 'published'
    and epv.retired_at is null
  order by ep.exam_code, epv.created_at desc
  limit 1;

  select
    count(*)::integer,
    count(*) filter (where item_type = 'frq')::integer,
    count(*) filter (where item_type = 'mcq')::integer,
    count(*) filter (where item_type not in ('frq', 'mcq'))::integer,
    count(*) filter (
      where coalesce((prompt_json->>'hand_drawn')::boolean, false) is true
    )::integer,
    count(*) filter (
      where item_type = 'mcq' and not exists (
        select 1 from app.mcq_choices choice
        where choice.content_item_version_id = served.content_item_version_id
          and choice.is_correct is true
      )
    )::integer
  into v_total, v_frq, v_mcq, v_bad_type, v_hand_drawn, v_unanswerable
  from app.select_ordinary_combined_practice_items(
    v_statistics_epv, 'mcq', v_seed_one, 20
  ) served;

  if (v_total, v_frq, v_mcq) is distinct from (20, 0, 20) then
    raise exception
      'expected mcq mode 20 = 0 FRQ + 20 MCQ, got % = % FRQ + % MCQ',
      v_total, v_frq, v_mcq;
  end if;
  if v_bad_type <> 0 or v_hand_drawn <> 0 or v_unanswerable <> 0 then
    raise exception
      'selector safety failure: bad_type %, hand_drawn %, unanswerable %',
      v_bad_type, v_hand_drawn, v_unanswerable;
  end if;

  select array_agg(content_item_version_id order by ordinality)
    into v_first
  from app.select_ordinary_combined_practice_items(
    v_statistics_epv, 'mcq', v_seed_one, 20
  ) with ordinality;
  select array_agg(content_item_version_id order by ordinality)
    into v_repeat
  from app.select_ordinary_combined_practice_items(
    v_statistics_epv, 'mcq', v_seed_one, 20
  ) with ordinality;
  select array_agg(content_item_version_id order by ordinality)
    into v_rotated
  from app.select_ordinary_combined_practice_items(
    v_statistics_epv, 'mcq', v_seed_two, 20
  ) with ordinality;

  if v_first is distinct from v_repeat then
    raise exception 'same selection seed did not return stable order';
  end if;
  if v_first is not distinct from v_rotated then
    raise exception 'different selection seed did not rotate the queue';
  end if;
  if exists (
    select 1 from app.select_ordinary_combined_practice_items(
      v_statistics_epv, 'unsupported', v_seed_one, 20
    )
  ) then
    raise exception 'unsupported practice format must fail closed';
  end if;
  if exists (
    select 1 from app.select_ordinary_combined_practice_items(
      v_statistics_epv, 'mcq', null, 20
    )
  ) then
    raise exception 'NULL selection seed must fail closed';
  end if;
  if v_other_epv is not null and exists (
    select 1 from app.select_ordinary_combined_practice_items(
      v_other_epv, 'mcq', v_seed_one, 20
    ) served
    where served.item_type <> 'mcq'
  ) then
    raise exception 'mcq mode returned a non-MCQ for another published pack';
  end if;

  raise notice 'task0044_statistics_combined_selector: all assertions passed';
end $$;

rollback;
