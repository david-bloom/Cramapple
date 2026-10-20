-- public.get_practice_topic_availability: per-topic count of practice questions this student could be
-- served, so the question page can suggest the nearest topic (before or after) that still has questions
-- when the requested topic has none. Read-only. The eligibility predicate is the one in
-- public.select_student_practice_items (published item + version, validated serving label against the
-- current taxonomy hash, servable item types, not an Open Hand teaching item, not already answered or
-- revealed by this student). It is repeated here because that function returns a capped page (≤51 rows),
-- not counts; keep the two predicates identical when either changes.

begin;

create or replace function public.get_practice_topic_availability(
  p_exam_pack_version_id uuid,
  p_item_type text default null,
  p_practice_format text default null
)
returns jsonb
language plpgsql
stable
security definer
set search_path = pg_catalog
as $$
declare
  v_user_id uuid := auth.uid();
  v_current_unit integer;
  v_taxonomy uuid;
begin
  if v_user_id is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;
  if p_exam_pack_version_id is null then
    raise exception 'topic_availability:exam_pack_required' using errcode = '22023';
  end if;
  if p_item_type is not null and p_item_type not in ('mcq', 'frq', 'quantitative') then
    raise exception 'topic_availability:invalid_item_type' using errcode = '22023';
  end if;

  -- Same unit source as student-session-items (course position, default 1).
  select coalesce(p.unit_id, 1) into v_current_unit
  from app.student_course_positions p
  where p.user_id = v_user_id and p.exam_pack_version_id = p_exam_pack_version_id;
  v_current_unit := coalesce(v_current_unit, 1);

  -- The pack's taxonomy, from its items' primary topic assignments (UUID join, no subject_key text).
  select r.taxonomy_source_version into v_taxonomy
  from app.content_item_topic_resolution r
  join app.content_items ci on ci.id = r.content_item_id
  where ci.exam_pack_version_id = p_exam_pack_version_id and r.is_primary
  group by r.taxonomy_source_version
  order by count(*) desc
  limit 1;

  return (
    with latest as (
      select distinct on (civ.content_item_id) civ.*
      from app.content_item_versions civ
      order by civ.content_item_id, civ.version_num desc
    ), active_labels as (
      select distinct on (ctl.content_item_id) ctl.*
      from app.content_taxonomy_labels ctl
      where ctl.label_scope = 'serving' and ctl.label_status = 'validated' and ctl.superseded_by is null
      order by ctl.content_item_id, ctl.label_version desc
    ), answered as (
      select distinct av.content_item_id
      from app.attempts a join app.content_item_versions av on av.id = a.content_item_version_id
      where a.user_id = v_user_id and a.status in ('submitted', 'graded')
    ), revealed as (
      select distinct e.content_item_id from app.open_hand_scoring_exclusions e where e.user_id = v_user_id
    ), eligible as (
      select r.topic_code, label.max_required_unit
      from app.content_items ci
      join latest civ on civ.content_item_id = ci.id
      join active_labels label on label.content_item_id = ci.id
      join app.content_item_topic_resolution r on r.content_item_version_id = civ.id and r.is_primary
      where ci.exam_pack_version_id = p_exam_pack_version_id
        and ci.status = 'published' and civ.status = 'published'
        and label.validated_against_taxo_hash = app.taxonomy_relevant_hash(civ.id)
        and (p_practice_format is null or ci.practice_format = p_practice_format)
        and (p_item_type is null or ci.item_type = p_item_type)
        and (ci.item_type in ('mcq', 'quantitative') or (ci.item_type = 'frq' and ci.frq_form in ('short', 'long')))
        and not app.content_item_is_teaching(ci.id)
        and not exists (select 1 from answered an where an.content_item_id = ci.id)
        and not exists (select 1 from revealed rv where rv.content_item_id = ci.id)
    ), counts as (
      select topic_code,
             count(*) filter (where max_required_unit <= v_current_unit) as available_now,
             count(*) filter (where max_required_unit > v_current_unit) as available_later,
             min(max_required_unit) filter (where max_required_unit > v_current_unit) as unlocks_at_unit
      from eligible group by topic_code
    )
    select jsonb_build_object(
      'currentUnit', v_current_unit,
      'itemType', p_item_type,
      'topics', coalesce((
        select jsonb_agg(jsonb_build_object(
          'unitNumber', tt.unit_number,
          'topicCode', tt.topic_code,
          'topicTitle', tt.topic_title,
          'availableNow', coalesce(c.available_now, 0),
          'availableLater', coalesce(c.available_later, 0),
          'unlocksAtUnit', c.unlocks_at_unit)
          order by tt.unit_number, split_part(tt.topic_code, '.', 1)::integer, split_part(tt.topic_code, '.', 2)::integer)
        from app.taxonomy_topics tt
        left join counts c on c.topic_code = tt.topic_code
        where tt.taxonomy_source_version = v_taxonomy), '[]'::jsonb))
  );
end;
$$;

revoke all on function public.get_practice_topic_availability(uuid, text, text) from public, anon;
grant execute on function public.get_practice_topic_availability(uuid, text, text) to authenticated, service_role;

commit;
