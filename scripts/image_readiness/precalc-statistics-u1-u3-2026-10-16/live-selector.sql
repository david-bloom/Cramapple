CREATE OR REPLACE FUNCTION public.select_student_practice_items(_exam_pack_version_id uuid, _current_unit integer, _user_id uuid, _practice_format text DEFAULT NULL::text, _item_type text DEFAULT NULL::text, _topic_code text DEFAULT NULL::text, _limit integer DEFAULT 20, _offset integer DEFAULT 0)
 RETURNS TABLE(content_item_version_id uuid, content_item_id uuid, content_key text, title text, item_type text, stem text, stimulus text, stimulus_image_path text, prompt_json jsonb, frq_form text, practice_format text, response_policy text, required_units integer[], max_required_unit integer, label_version integer, published_at timestamp with time zone, topic_match boolean)
 LANGUAGE plpgsql
 STABLE SECURITY DEFINER
 SET search_path TO 'pg_catalog'
AS $function$
declare
  v_allowed_units integer[];
begin
  if _exam_pack_version_id is null then
    raise exception 'unit_serving:exam_pack_required' using errcode = '22023';
  end if;
  if _current_unit is null then
    raise exception 'unit_serving:current_unit_required' using errcode = '22023';
  end if;
  if _user_id is null then
    raise exception 'unit_serving:user_required' using errcode = '22023';
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
  ), answered as (
    select distinct av.content_item_id
    from app.attempts a
    join app.content_item_versions av on av.id = a.content_item_version_id
    where a.user_id = _user_id
      and a.status in ('submitted', 'graded')
  ), revealed as (
    select distinct e.content_item_id
    from app.open_hand_scoring_exclusions e
    where e.user_id = _user_id
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
    ci.response_policy,
    label.required_units,
    label.max_required_unit,
    label.label_version,
    civ.published_at,
    (_topic_code is not null and exists (
      select 1 from app.content_item_topic_resolution r
      where r.content_item_version_id = civ.id
        and r.is_primary
        and r.topic_code = _topic_code
    )) as topic_match
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
    -- Hand-drawn items are served here on purpose (2026-10-09): the Practice
    -- FRQ screen renders a capture control for response_policy =
    -- 'photo_required'. The TASK-0038 exclusion stays on the legacy /session
    -- selectors only.
    and not app.content_item_is_teaching(ci.id)
    and not exists (select 1 from answered an where an.content_item_id = ci.id)
    and not exists (select 1 from revealed rv where rv.content_item_id = ci.id)
  order by 17 desc, label.max_required_unit desc, civ.published_at nulls last, ci.content_key
  offset greatest(0, coalesce(_offset, 0))
  limit greatest(1, least(coalesce(_limit, 20), 51));
end;
$function$
