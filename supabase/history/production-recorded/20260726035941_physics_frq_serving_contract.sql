-- Exported from Production migration history (supabase_migrations.schema_migrations)
-- version: 20260726035941
-- recorded name: physics_frq_serving_contract
-- statements: 1
-- This file is a faithful transcript of what Production actually ran.
-- Do not edit to "improve" it; corrections belong in a new forward migration.

-- AP Physics FRQ serving contract.
--
-- Option B preserves the existing short Physics FRQs as targeted drills and
-- creates a separate bank of full exam-representative FRQs. This migration
-- makes that distinction canonical and fail-closed at selection/publication.

alter table app.content_items
  add column if not exists practice_format text,
  add column if not exists frq_archetype text;

alter table app.content_items
  drop constraint if exists content_items_practice_format_check,
  add constraint content_items_practice_format_check
    check (
      practice_format is null
      or (
        item_type = 'frq'
        and practice_format in ('targeted_drill', 'full_exam_frq')
      )
    ),
  drop constraint if exists content_items_full_exam_archetype_check,
  add constraint content_items_full_exam_archetype_check
    check (
      practice_format <> 'full_exam_frq'
      or (
        frq_form = 'long'
        and frq_archetype is not null
        and btrim(frq_archetype) <> ''
      )
    );

alter table app.learning_sessions
  add column if not exists practice_format text;

alter table app.learning_sessions
  drop constraint if exists learning_sessions_practice_format_check,
  add constraint learning_sessions_practice_format_check
    check (
      practice_format is null
      or practice_format in ('targeted_drill', 'full_exam_frq')
    );

create index if not exists content_items_exam_pack_practice_format_idx
  on app.content_items (exam_pack_version_id, item_type, practice_format, status);

-- Normalize the current Physics bank. These are use-classification changes on
-- stable item identities, not edits to reviewed stems/rubrics, so review
-- decisions remain attached to their original immutable versions.
with physics_frqs as (
  select
    ci.id,
    ci.content_key,
    civ.prompt_json ->> 'archetype' as raw_archetype
  from app.content_items ci
  join app.exam_pack_versions epv
    on epv.id = ci.exam_pack_version_id
  join app.exam_packs ep
    on ep.id = epv.exam_pack_id
  join lateral (
    select v.prompt_json
    from app.content_item_versions v
    where v.content_item_id = ci.id
    order by v.version_num desc
    limit 1
  ) civ on true
  where ep.exam_code in (
    'ap_physics_1',
    'ap_physics_2',
    'ap_physics_c_mechanics',
    'ap_physics_c_em'
  )
    and ci.item_type = 'frq'
)
update app.content_items ci
set
  practice_format = 'targeted_drill',
  frq_archetype = case
    when pf.content_key = 'apphy1-frq-017'
      then 'Mathematical Routines'
    when pf.content_key = 'apphy1-frq-018'
      then 'Translation Between Representations'
    when pf.raw_archetype in (
      'Mathematical Routines',
      'Translation Between Representations',
      'Experimental Design and Analysis',
      'Qualitative/Quantitative Translation'
    )
      then pf.raw_archetype
    when lower(coalesce(pf.raw_archetype, '')) like '%-frq-math'
      then 'Mathematical Routines'
    when lower(coalesce(pf.raw_archetype, '')) like '%-frq-representation'
      then 'Translation Between Representations'
    when lower(coalesce(pf.raw_archetype, '')) like '%-frq-experimental'
      then 'Experimental Design and Analysis'
    when lower(coalesce(pf.raw_archetype, '')) like '%-frq-translation'
      then 'Qualitative/Quantitative Translation'
    else null
  end,
  updated_at = now()
from physics_frqs pf
where ci.id = pf.id;

do $$
declare
  v_unclassified integer;
begin
  select count(*)
  into v_unclassified
  from app.content_items ci
  join app.exam_pack_versions epv
    on epv.id = ci.exam_pack_version_id
  join app.exam_packs ep
    on ep.id = epv.exam_pack_id
  where ep.exam_code in (
    'ap_physics_1',
    'ap_physics_2',
    'ap_physics_c_mechanics',
    'ap_physics_c_em'
  )
    and ci.item_type = 'frq'
    and (
      ci.practice_format <> 'targeted_drill'
      or ci.frq_archetype is null
    );

  if v_unclassified <> 0 then
    raise exception
      'physics_frq_serving_contract: % existing Physics FRQs remain unclassified',
      v_unclassified;
  end if;
end
$$;

create or replace function app.validate_full_exam_frq_version(
  p_content_item_version_id uuid
)
returns void
language plpgsql
security invoker
set search_path = pg_catalog
as $$
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
  join app.content_items ci
    on ci.id = civ.content_item_id
  join app.exam_pack_versions epv
    on epv.id = ci.exam_pack_version_id
  join app.exam_packs ep
    on ep.id = epv.exam_pack_id
  where civ.id = p_content_item_version_id;

  if not found
    or v_item.version_status <> 'published'
    or v_item.practice_format <> 'full_exam_frq'
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
      raise exception
        'full_exam_frq_invalid_archetype:%:%',
        v_item.content_key,
        coalesce(v_item.frq_archetype, '<null>');
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
  from jsonb_array_elements(v_item.prompt_json -> 'parts')
    with ordinality as p(part, ordinal);

  if v_actual_parts <> v_expected_parts then
    raise exception
      'full_exam_frq_part_contract_mismatch:%:expected=%:actual=%',
      v_item.content_key,
      v_expected_parts,
      v_actual_parts;
  end if;

  select count(*)
  into v_bad_part_count
  from jsonb_array_elements(v_item.prompt_json -> 'parts') part
  where
    coalesce(part ->> 'part_key', '') !~ '^part-[a-d]$'
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
    raise exception
      'full_exam_frq_criteria_total_mismatch:%:expected=%:actual=%',
      v_item.content_key,
      v_expected_points,
      v_criteria_points;
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
$$;

create or replace function app.enforce_full_exam_frq_version()
returns trigger
language plpgsql
security invoker
set search_path = pg_catalog
as $$
begin
  perform app.validate_full_exam_frq_version(new.id);
  return new;
end
$$;

drop trigger if exists enforce_full_exam_frq_version
  on app.content_item_versions;
create constraint trigger enforce_full_exam_frq_version
after insert or update of status, prompt_json
on app.content_item_versions
deferrable initially deferred
for each row
execute function app.enforce_full_exam_frq_version();

create or replace function app.enforce_full_exam_frq_criteria()
returns trigger
language plpgsql
security invoker
set search_path = pg_catalog
as $$
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
$$;

drop trigger if exists enforce_full_exam_frq_criteria
  on app.frq_criteria;
create constraint trigger enforce_full_exam_frq_criteria
after insert or update or delete
on app.frq_criteria
deferrable initially deferred
for each row
execute function app.enforce_full_exam_frq_criteria();

create or replace function app.prevent_live_frq_reclassification()
returns trigger
language plpgsql
security invoker
set search_path = pg_catalog
as $$
begin
  if (
    new.practice_format is distinct from old.practice_format
    or new.frq_archetype is distinct from old.frq_archetype
    or new.frq_form is distinct from old.frq_form
  ) and exists (
    select 1
    from app.content_item_versions civ
    where civ.content_item_id = old.id
      and civ.status = 'published'
  ) then
    raise exception
      'published_frq_reclassification_requires_retirement:%',
      old.content_key;
  end if;
  return new;
end
$$;

drop trigger if exists prevent_live_frq_reclassification
  on app.content_items;
create trigger prevent_live_frq_reclassification
before update of practice_format, frq_archetype, frq_form
on app.content_items
for each row
when (old.item_type = 'frq')
execute function app.prevent_live_frq_reclassification();

create or replace function public.select_practice_frqs(
  _exam_pack_version_id uuid,
  _practice_format text,
  _limit integer default 20
)
returns table (
  content_item_version_id uuid,
  content_item_id uuid,
  content_key text,
  title text,
  stem text,
  stimulus text,
  stimulus_image_path text,
  prompt_json jsonb,
  frq_form text,
  practice_format text,
  frq_archetype text,
  published_at timestamptz
)
language sql
stable
security invoker
set search_path = pg_catalog
as $$
  select
    civ.id,
    ci.id,
    ci.content_key,
    ci.title,
    civ.stem,
    civ.stimulus,
    civ.stimulus_image_path,
    civ.prompt_json,
    ci.frq_form,
    ci.practice_format,
    ci.frq_archetype,
    civ.published_at
  from app.content_items ci
  join app.content_item_versions civ
    on civ.content_item_id = ci.id
  where ci.exam_pack_version_id = _exam_pack_version_id
    and ci.item_type = 'frq'
    and ci.status = 'published'
    and civ.status = 'published'
    and ci.practice_format = _practice_format
    and _practice_format in ('targeted_drill', 'full_exam_frq')
  order by civ.published_at, ci.content_key
  limit greatest(1, least(coalesce(_limit, 20), 50));
$$;

revoke all on function public.select_practice_frqs(uuid, text, integer)
  from public, anon;
grant execute on function public.select_practice_frqs(uuid, text, integer)
  to authenticated, service_role;

comment on column app.content_items.practice_format is
  'Serving contract: targeted_drill or full_exam_frq for FRQs.';
comment on column app.content_items.frq_archetype is
  'Canonical subject-specific FRQ archetype; separate from serving format.';
comment on column app.learning_sessions.practice_format is
  'Requested FRQ serving format enforced again at attempt creation.';
comment on function public.select_practice_frqs(uuid, text, integer) is
  'Fail-closed student FRQ candidate selector scoped by exam pack and practice format.';
;
