-- Resolve PL/pgSQL output-column ambiguity in the original UPSERT.

create or replace function public.set_course_position(
  _unit_id integer,
  _source text
)
returns table (
  exam_pack_version_id uuid,
  unit_id integer,
  source text,
  updated_at timestamptz
)
language plpgsql
security definer
set search_path = pg_catalog
as $$
declare
  v_user_id uuid := auth.uid();
  v_exam_pack_version_id uuid;
  v_allowed_units integer[];
  v_source text;
begin
  if v_user_id is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;

  select p.active_exam_pack_version_id
    into v_exam_pack_version_id
  from app.profiles p
  where p.user_id = v_user_id;

  if v_exam_pack_version_id is null then
    raise exception 'no_active_subject' using errcode = '22023';
  end if;

  if not app.exam_pack_version_is_selectable(v_exam_pack_version_id) then
    raise exception 'invalid_active_subject' using errcode = '22023';
  end if;

  select m.allowed_unit_numbers
    into v_allowed_units
  from app.home_release_manifest m
  where m.exam_pack_version_id = v_exam_pack_version_id;

  if v_allowed_units is null then
    raise exception 'subject_taxonomy_unavailable' using errcode = '22023';
  end if;

  if _unit_id is not null
     and not (_unit_id = any(v_allowed_units)) then
    raise exception 'unit_not_in_active_subject' using errcode = '22023';
  end if;

  if _unit_id is null then
    v_source := 'unknown';
  elsif _source in ('confirmed', 'estimated') then
    v_source := _source;
  else
    raise exception 'invalid_course_position_source' using errcode = '22023';
  end if;

  return query
  insert into app.student_course_positions as positions (
    user_id,
    exam_pack_version_id,
    unit_id,
    source
  )
  values (
    v_user_id,
    v_exam_pack_version_id,
    _unit_id,
    v_source
  )
  on conflict on constraint student_course_positions_pkey do update
  set
    unit_id = excluded.unit_id,
    source = excluded.source
  returning
    positions.exam_pack_version_id,
    positions.unit_id,
    positions.source,
    positions.updated_at;
end;
$$;

revoke all on function public.set_course_position(integer, text)
  from public, anon;
grant execute on function public.set_course_position(integer, text)
  to authenticated;
