-- Unit-gated serving selector.
--
-- This intentionally uses only validated serving-scope taxonomy labels. Legacy,
-- provisional, stale, held, missing, or hash-mismatched labels fail closed.
-- Topic coverage labels are not read here.

begin;

create or replace function public.select_unit_gated_practice_items(
  _exam_pack_version_id uuid,
  _current_unit integer,
  _practice_format text default null,
  _item_type text default null,
  _limit integer default 20
)
returns table (
  content_item_version_id uuid,
  content_item_id uuid,
  content_key text,
  title text,
  item_type text,
  stem text,
  stimulus text,
  stimulus_image_path text,
  prompt_json jsonb,
  frq_form text,
  practice_format text,
  required_units integer[],
  max_required_unit integer,
  label_version integer,
  published_at timestamptz
)
language plpgsql
stable
security definer
set search_path = pg_catalog
as $$
declare
  v_user_id uuid := auth.uid();
  v_allowed_units integer[];
begin
  if _exam_pack_version_id is null then
    raise exception 'unit_serving:exam_pack_required' using errcode = '22023';
  end if;
  if _current_unit is null then
    raise exception 'unit_serving:current_unit_required' using errcode = '22023';
  end if;

  select m.allowed_unit_numbers
    into v_allowed_units
  from app.home_release_manifest m
  where m.exam_pack_version_id = _exam_pack_version_id;

  if v_allowed_units is null then
    raise exception 'unit_serving:subject_taxonomy_unavailable' using errcode = '22023';
  end if;
  if not (_current_unit = any(v_allowed_units)) then
    raise exception 'unit_serving:unit_not_in_subject' using errcode = '22023';
  end if;

  if v_user_id is not null
     and not exists (
       select 1
       from app.profiles p
       where p.user_id = v_user_id
         and p.active_exam_pack_version_id = _exam_pack_version_id
     ) then
    raise exception 'unit_serving:active_subject_mismatch' using errcode = '42501';
  end if;

  return query
  with latest as (
    select distinct on (civ.content_item_id)
      civ.*
    from app.content_item_versions civ
    order by civ.content_item_id, civ.version_num desc
  ), active_labels as (
    select distinct on (ctl.content_item_id)
      ctl.*
    from app.content_taxonomy_labels ctl
    where ctl.label_scope = 'serving'
      and ctl.label_status = 'validated'
      and ctl.superseded_by is null
    order by ctl.content_item_id, ctl.label_version desc
  )
  select
    civ.id,
    ci.id,
    ci.content_key,
    ci.title,
    ci.item_type,
    civ.stem,
    civ.stimulus,
    civ.stimulus_image_path,
    civ.prompt_json,
    ci.frq_form,
    ci.practice_format,
    label.required_units,
    label.max_required_unit,
    label.label_version,
    civ.published_at
  from app.content_items ci
  join latest civ
    on civ.content_item_id = ci.id
  join active_labels label
    on label.content_item_id = ci.id
  where ci.exam_pack_version_id = _exam_pack_version_id
    and ci.status = 'published'
    and civ.status = 'published'
    and label.max_required_unit <= _current_unit
    and label.validated_against_taxo_hash = app.taxonomy_relevant_hash(civ.id)
    and (_practice_format is null or ci.practice_format = _practice_format)
    and (_item_type is null or ci.item_type = _item_type)
    and (
      ci.item_type in ('mcq', 'quantitative')
      or (ci.item_type = 'frq' and ci.frq_form in ('short', 'long'))
    )
  order by label.max_required_unit desc, civ.published_at nulls last, ci.content_key
  limit greatest(1, least(coalesce(_limit, 20), 50));
end;
$$;

revoke all on function public.select_unit_gated_practice_items(
  uuid, integer, text, text, integer
) from public, anon;
grant execute on function public.select_unit_gated_practice_items(
  uuid, integer, text, text, integer
) to authenticated, service_role;

comment on function public.select_unit_gated_practice_items(
  uuid, integer, text, text, integer
) is
  'Fail-closed unit-gated item selector. Reads validated serving labels only; topic coverage labels are not used.';

commit;
