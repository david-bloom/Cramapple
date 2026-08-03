-- Exported from Production migration history (supabase_migrations.schema_migrations)
-- version: 20260727145328
-- recorded name: fix_full_exam_frq_validator_null_practice_format
-- statements: 1
-- This file is a faithful transcript of what Production actually ran.
-- Do not edit to "improve" it; corrections belong in a new forward migration.

create or replace function app.validate_full_exam_frq_version(p_content_item_version_id uuid)
returns void
language plpgsql
set search_path to 'pg_catalog'
as $function$
declare
  v_item record;
  v_expected_points integer;
  v_expected_parts jsonb;
  v_actual_parts jsonb;
  v_criteria_points integer;
  v_bad_part_count integer;
begin
  select
    civ.id as version_id,
    civ.status as version_status,
    civ.prompt_json,
    ci.id as item_id,
    ci.content_key,
    ci.item_type,
    ci.frq_form,
    ci.practice_format,
    ci.frq_archetype,
    ep.exam_code
  into v_item
  from app.content_item_versions civ
  join app.content_items ci on ci.id = civ.content_item_id
  join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  where civ.id = p_content_item_version_id;

  if not found
    or v_item.version_status <> 'published'
    or v_item.practice_format is distinct from 'full_exam_frq'
  then
    return;
  end if;

  if v_item.exam_code not in (
    'ap_physics_1',
    'ap_physics_2',
    'ap_physics_c_mechanics',
    'ap_physics_c_em'
  ) then
    return;
  end if;

  case v_item.frq_archetype
    when 'Mathematical Routines' then
      v_expected_points := 10;
      v_expected_parts := '[7,3]'::jsonb;
    when 'Translation Between Representations' then
      v_expected_points := 12;
      v_expected_parts := '[3,4,3,2]'::jsonb;
    when 'Experimental Design and Analysis' then
      v_expected_points := 10;
      v_expected_parts := '[2,2,4,2]'::jsonb;
    when 'Qualitative/Quantitative Translation' then
      v_expected_points := 8;
      v_expected_parts := '[3,3,2]'::jsonb;
    else
      raise exception 'full_exam_frq_invalid_archetype:%:%', v_item.content_key, coalesce(v_item.frq_archetype, '<null>');
  end case;

  if v_item.item_type <> 'frq' or v_item.frq_form <> 'long' then
    raise exception 'full_exam_frq_invalid_form:%', v_item.content_key;
  end if;

  if coalesce(v_item.prompt_json ->> 'archetype', '') <> v_item.frq_archetype then
    raise exception 'full_exam_frq_archetype_mismatch:%', v_item.content_key;
  end if;

  if jsonb_typeof(v_item.prompt_json -> 'parts') <> 'array' then
    raise exception 'full_exam_frq_missing_parts:%', v_item.content_key;
  end if;

  select coalesce(jsonb_agg((part ->> 'points')::integer order by ordinal), '[]'::jsonb)
  into v_actual_parts
  from jsonb_array_elements(v_item.prompt_json -> 'parts') with ordinality as p(part, ordinal);

  if v_actual_parts <> v_expected_parts then
    raise exception 'full_exam_frq_part_contract_mismatch:%:expected=%:actual=%', v_item.content_key, v_expected_parts, v_actual_parts;
  end if;

  select count(*)
  into v_bad_part_count
  from jsonb_array_elements(v_item.prompt_json -> 'parts') part
  where coalesce(part ->> 'part_key', '') !~ '^part-[a-d]$'
    or coalesce(part ->> 'prompt', '') = ''
    or jsonb_typeof(part -> 'criteria') <> 'array'
    or coalesce((
      select sum((criterion ->> 'points')::integer)
      from jsonb_array_elements(part -> 'criteria') criterion
    ), 0) <> (part ->> 'points')::integer;

  if v_bad_part_count <> 0 then
    raise exception 'full_exam_frq_invalid_part_payload:%', v_item.content_key;
  end if;

  select coalesce(sum(fc.points_possible), 0)
  into v_criteria_points
  from app.frq_criteria fc
  where fc.content_item_version_id = v_item.version_id;

  if v_criteria_points <> v_expected_points then
    raise exception 'full_exam_frq_criteria_total_mismatch:%:expected=%:actual=%', v_item.content_key, v_expected_points, v_criteria_points;
  end if;

  if exists (
    select 1
    from jsonb_array_elements(v_item.prompt_json -> 'parts') part
    where coalesce((
      select sum(fc.points_possible)
      from app.frq_criteria fc
      where fc.content_item_version_id = v_item.version_id
        and fc.criterion_key like (part ->> 'part_key') || '-criterion-%'
    ), 0) <> (part ->> 'points')::integer
  ) then
    raise exception 'full_exam_frq_criterion_part_mismatch:%', v_item.content_key;
  end if;
end
$function$;
