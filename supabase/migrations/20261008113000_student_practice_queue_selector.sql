-- Student practice queue selector (2026-10-08).
-- Findings: QA_OPEN_HAND_PRACTICE_TEMPLATES_2026_10_08.md F2, F9;
-- QA_OPEN_HAND_PRACTICE_CHALLENGE_2026_10_08.md A2, A3.
--
-- 1. public.select_student_practice_items: the unit-gated selector with three
--    additions, for student-session-items (service role only):
--      * excludes items the student has already submitted (app.attempts status
--        submitted/graded, any version) and items whose key they saw in Open
--        Hand (app.open_hand_scoring_exclusions), so a fetch always returns
--        unanswered items and the "same 50 forever" ceiling disappears;
--      * puts items on a requested topic first (content_item_topic_resolution,
--        primary row), so the lesson the student picked is reachable even when
--        the pool is larger than one page;
--      * accepts an offset so the client can page past items it skipped.
--    Everything else (manifest unit check, validated serving label, taxonomy
--    hash, practice_format/item_type filters, teaching-pool exclusion) is the
--    same as select_unit_gated_practice_items. No caller-identity guard: the
--    edge function passes the session owner's id with the service role.
-- 2. public.count_practice_frqs_available: an integer the hub may read to decide
--    whether to show the "Practice FRQs" door. Counts FRQs that will actually
--    render (authored prompt on every part) and are servable (validated label,
--    not teaching). Returns a number only; no content, no keys.
-- 3. public.get_open_hand_item is no longer callable by students. The only
--    screen that used it (/open-hand-frq) revealed scored FRQs and burned them;
--    Open Hand now serves the never-scored teaching pool through
--    get_open_hand_teaching_item.

create or replace function public.select_student_practice_items(
  _exam_pack_version_id uuid,
  _current_unit integer,
  _user_id uuid,
  _practice_format text default null,
  _item_type text default null,
  _topic_code text default null,
  _limit integer default 20,
  _offset integer default 0
)
returns table(
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
  published_at timestamptz,
  topic_match boolean
)
language plpgsql
stable
security definer
set search_path = pg_catalog
as $$
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
    and coalesce((civ.prompt_json->>'hand_drawn')::boolean, false) is not true
    and not app.content_item_is_teaching(ci.id)
    and not exists (select 1 from answered an where an.content_item_id = ci.id)
    and not exists (select 1 from revealed rv where rv.content_item_id = ci.id)
  order by 16 desc, label.max_required_unit desc, civ.published_at nulls last, ci.content_key
  offset greatest(0, coalesce(_offset, 0))
  limit greatest(1, least(coalesce(_limit, 20), 51));
end;
$$;

revoke all on function public.select_student_practice_items(uuid, integer, uuid, text, text, text, integer, integer)
  from public, anon, authenticated;
grant execute on function public.select_student_practice_items(uuid, integer, uuid, text, text, text, integer, integer)
  to service_role;

comment on function public.select_student_practice_items(uuid, integer, uuid, text, text, text, integer, integer) is
  'Unit-gated practice selector for student-session-items (service role). Excludes the student''s submitted and Open-Hand-revealed items, puts a requested topic first, pages by offset. 2026-10-08.';

create or replace function public.count_practice_frqs_available(_exam_pack_version_id uuid)
returns integer
language plpgsql
stable
security definer
set search_path = pg_catalog
as $$
declare
  v_user_id uuid := auth.uid();
  v_count integer;
begin
  if v_user_id is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;
  if _exam_pack_version_id is null then
    return 0;
  end if;
  if not exists (
    select 1 from app.profiles p
    where p.user_id = v_user_id
      and (
        p.active_exam_pack_version_id = _exam_pack_version_id
        or coalesce(p.role, '') = any (array['admin', 'content_author', 'tutor', 'reader', 'validator'])
      )
  ) then
    return 0;
  end if;

  select count(*) into v_count
  from app.content_items ci
  join lateral (
    select civ.prompt_json
    from app.content_item_versions civ
    where civ.content_item_id = ci.id and civ.status = 'published'
    order by civ.version_num desc
    limit 1
  ) civ on true
  where ci.exam_pack_version_id = _exam_pack_version_id
    and ci.status = 'published'
    and ci.item_type = 'frq'
    and ci.practice_format = 'targeted_drill'
    and ci.frq_form in ('short', 'long')
    and not app.content_item_is_teaching(ci.id)
    and exists (
      select 1 from app.content_taxonomy_labels l
      where l.content_item_id = ci.id
        and l.label_scope = 'serving'
        and l.label_status = 'validated'
        and l.superseded_by is null
    )
    and jsonb_typeof(civ.prompt_json->'parts') = 'array'
    and jsonb_array_length(civ.prompt_json->'parts') > 0
    and not exists (
      select 1 from jsonb_array_elements(civ.prompt_json->'parts') p
      where coalesce(nullif(btrim(p->>'prompt'), ''), nullif(btrim(p->>'prompt_text'), '')) is null
    );

  return coalesce(v_count, 0);
end;
$$;

revoke all on function public.count_practice_frqs_available(uuid) from public, anon;
grant execute on function public.count_practice_frqs_available(uuid) to authenticated, service_role;

comment on function public.count_practice_frqs_available(uuid) is
  'Number of FRQs the signed-in student''s active pack can actually render in Practice (authored prompt on every part, validated serving label, not teaching). Integer only. 2026-10-08.';

-- 3. Students may no longer open scored items face-up.
revoke execute on function public.get_open_hand_item(uuid, uuid) from public, anon, authenticated;
grant execute on function public.get_open_hand_item(uuid, uuid) to service_role;
