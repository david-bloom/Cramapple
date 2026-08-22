-- TASK-0027: mirror the "Publish gate + FRQ pipeline" cluster (10 objects)
-- from Production into Development. Approved by the Product Owner 2026-08-22,
-- acting on Codex's P1-P4 answer: this cluster is governance-critical and
-- Development is not a trustworthy content-pipeline QA mirror without it.
--
-- This migration is Dev-only in effect: every statement uses IF NOT EXISTS /
-- OR REPLACE / DROP ... IF EXISTS, so re-running it (or running it against
-- Production, where all ten objects already exist unchanged) is a no-op.
--
-- Definitions below were pulled verbatim from Production via
-- pg_get_functiondef/pg_get_triggerdef on 2026-08-22, not retyped from the
-- original repo migrations, so they include the 2026-08-08/09 refinements
-- Production received after those migrations first landed (the wider
-- review_status allowlist in enforce_publish_gate, the tg_op/old.status
-- re-publish guard, and the search_path hardening applied earlier today).
--
-- Prerequisite schema gap found and closed here: app.content_items in
-- Development was missing practice_format/frq_archetype entirely (the
-- Physics full-exam-FRQ columns), which validate_full_exam_frq_version,
-- prevent_live_frq_reclassification and tg_require_practice_format_at_publish
-- all depend on. Both are nullable with no default, so adding them is
-- instant and touches no existing row.
--
-- Checked before applying: only 1 of Development's 8 published
-- content_item_versions rows has a review_status outside the publish-gate
-- allowlist. The gate is not retroactive - that row stays published; it
-- would just need review_status fixed before its next re-publish.

alter table app.content_items
  add column if not exists practice_format text,
  add column if not exists frq_archetype text;

alter table app.content_items
  add constraint content_items_practice_format_check
  check (
    (practice_format is null)
    or (item_type = 'frq' and practice_format = any (array['targeted_drill', 'full_exam_frq']))
  );

alter table app.content_items
  add constraint content_items_full_exam_archetype_check
  check (
    (practice_format <> 'full_exam_frq')
    or (frq_form = 'long' and frq_archetype is not null and btrim(frq_archetype) <> '')
  );

create or replace function app.content_item_is_published(p_content_item_id uuid)
returns boolean
language sql
stable security definer
set search_path to 'app', 'pg_temp'
as $function$
  select exists (
    select 1
    from app.content_items ci
    join app.exam_pack_versions epv
      on epv.id = ci.exam_pack_version_id
    where ci.id = p_content_item_id
      and ci.status = 'published'
      and epv.status = 'published'
  );
$function$;

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

create or replace function app.enforce_full_exam_frq_version()
returns trigger
language plpgsql
set search_path to 'pg_catalog'
as $function$
begin
  perform app.validate_full_exam_frq_version(new.id);
  return new;
end
$function$;

create or replace function app.enforce_full_exam_frq_criteria()
returns trigger
language plpgsql
set search_path to 'pg_catalog'
as $function$
begin
  perform app.validate_full_exam_frq_version(
    case
      when tg_op = 'DELETE' then old.content_item_version_id
      else new.content_item_version_id
    end
  );
  if tg_op = 'DELETE' then
    return old;
  end if;
  return new;
end
$function$;

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

create or replace function app.tg_require_practice_format_at_publish()
returns trigger
language plpgsql
security definer
set search_path to 'app', 'pg_temp'
as $function$
declare
  v_hand_drawn boolean;
begin
  if new.status = 'published'
     and old.status is distinct from 'published'
     and new.item_type = 'frq'
     and new.practice_format is null
  then
    select coalesce((civ.prompt_json ->> 'hand_drawn')::boolean, false)
      into v_hand_drawn
    from app.content_item_versions civ
    where civ.content_item_id = new.id
      and civ.status = 'published'
    order by civ.version_num desc
    limit 1;

    if not coalesce(v_hand_drawn, false) then
      raise exception
        'practice_format_required_at_publish: FRQ % (content_key %) cannot publish with practice_format IS NULL — set targeted_drill or full_exam_frq before publishing, or confirm it is a hand-drawn item (prompt_json.hand_drawn = true) if it should stay unreachable via select_practice_frqs',
        new.id, new.content_key;
    end if;
  end if;
  return new;
end;
$function$;

create or replace function app.enforce_publish_gate()
returns trigger
language plpgsql
set search_path to 'app', 'pg_catalog'
as $function$
begin
  if new.status = 'published'
     and (tg_op = 'INSERT' or old.status is distinct from 'published')
     and (new.review_status is null or new.review_status not in (
       'question_review_approved',
       'difficulty_confirmed',
       'answer_approved',
       'mcq_answer_review_complete'
     ))
  then
    raise exception
      'publish_gate: status=published requires review_status in the approved allowlist (question_review_approved, difficulty_confirmed, answer_approved, mcq_answer_review_complete); got %',
      coalesce(new.review_status, 'NULL')
      using errcode = 'P0001';
  end if;
  return new;
end;
$function$;

create or replace function app.mcq_stem_choice_desync(p_version_id uuid, p_stem text)
returns text[]
language plpgsql
stable
set search_path to 'app', 'pg_catalog'
as $function$
declare
  v_matches text[];
  v_letter text;
  v_embedded text;
  v_stored text;
  v_mismatches text[] := array[]::text[];
begin
  if p_stem is null then
    return v_mismatches;
  end if;

  for v_matches in
    select regexp_matches(p_stem, '(?m)^\s*([A-D])[\.\)]\s*(.+?)\s*$', 'g')
  loop
    v_letter := v_matches[1];
    v_embedded := btrim(v_matches[2]);

    select btrim(mc.choice_text) into v_stored
    from app.mcq_choices mc
    where mc.content_item_version_id = p_version_id
      and mc.choice_key = v_letter;

    if v_stored is not null and v_stored <> v_embedded then
      v_mismatches := v_mismatches || (v_letter || ': stem says "' || v_embedded || '", mcq_choices says "' || v_stored || '"');
    end if;
  end loop;

  return v_mismatches;
end;
$function$;

create or replace function app.mcq_stem_choice_resync(p_version_id uuid, p_stem text)
returns text
language plpgsql
stable
set search_path to 'app', 'pg_catalog'
as $function$
declare
  v_matches text[];
  v_letter text;
  v_embedded text;
  v_stored text;
  v_result text := p_stem;
begin
  if p_stem is null then
    return p_stem;
  end if;

  for v_matches in
    select regexp_matches(p_stem, '(?m)^(\s*)([A-D])([\.\)])(\s*)(.+?)(\s*)$', 'g')
  loop
    v_letter := v_matches[2];
    v_embedded := btrim(v_matches[5]);

    select btrim(mc.choice_text) into v_stored
    from app.mcq_choices mc
    where mc.content_item_version_id = p_version_id
      and mc.choice_key = v_letter;

    if v_stored is not null and v_stored <> v_embedded then
      v_result := regexp_replace(
        v_result,
        '(?m)^(\s*' || v_letter || '[\.\)]\s*)' || regexp_replace(v_embedded, '([.^$*+?()\[\]{}|\\])', '\\\1', 'g') || '(\s*)$',
        '\1' || replace(v_stored, '\', '\\') || '\2'
      );
    end if;
  end loop;

  return v_result;
end;
$function$;

create or replace function app.enforce_mcq_stem_choice_sync()
returns trigger
language plpgsql
set search_path to 'app', 'pg_catalog'
as $function$
declare
  v_item_type text;
  v_mismatches text[];
begin
  if new.status <> 'published' then
    return new;
  end if;

  select ci.item_type into v_item_type
  from app.content_items ci
  where ci.id = new.content_item_id;

  if v_item_type <> 'mcq' then
    return new;
  end if;

  v_mismatches := app.mcq_stem_choice_desync(new.id, new.stem);

  if array_length(v_mismatches, 1) > 0 then
    raise exception
      'mcq_stem_choice_sync: stem embeds option text that does not match app.mcq_choices for version %: %',
      new.id, array_to_string(v_mismatches, '; ')
      using errcode = 'P0001';
  end if;

  return new;
end;
$function$;

drop trigger if exists content_item_versions_publish_gate on app.content_item_versions;
create trigger content_item_versions_publish_gate
  before insert or update of status, review_status on app.content_item_versions
  for each row
  execute function app.enforce_publish_gate();

drop trigger if exists content_item_versions_mcq_stem_choice_sync on app.content_item_versions;
create trigger content_item_versions_mcq_stem_choice_sync
  before insert or update of status, stem on app.content_item_versions
  for each row
  execute function app.enforce_mcq_stem_choice_sync();

drop trigger if exists enforce_full_exam_frq_version on app.content_item_versions;
create constraint trigger enforce_full_exam_frq_version
  after insert or update of status, prompt_json on app.content_item_versions
  deferrable initially deferred
  for each row
  execute function app.enforce_full_exam_frq_version();

drop trigger if exists enforce_full_exam_frq_criteria on app.frq_criteria;
create constraint trigger enforce_full_exam_frq_criteria
  after insert or delete or update on app.frq_criteria
  deferrable initially deferred
  for each row
  execute function app.enforce_full_exam_frq_criteria();

drop trigger if exists prevent_live_frq_reclassification on app.content_items;
create trigger prevent_live_frq_reclassification
  before update of practice_format, frq_archetype, frq_form on app.content_items
  for each row
  when (old.item_type = 'frq')
  execute function app.prevent_live_frq_reclassification();

drop trigger if exists require_practice_format_at_publish on app.content_items;
create trigger require_practice_format_at_publish
  before update on app.content_items
  for each row
  execute function app.tg_require_practice_format_at_publish();
