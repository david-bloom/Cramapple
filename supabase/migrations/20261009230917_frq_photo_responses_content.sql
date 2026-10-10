-- Hand-drawn responses on every FRQ -- content model (plan §3, §6;
-- docs/product/HAND_DRAWN_RESPONSES_ALL_FRQS_PLAN_2026_10_09.md;
-- DECISION-0109/0110/0111, APPROVAL-0142 for the decisions; the build itself
-- is presented for Product Owner review as a PR).
--
-- 1. app.content_items.response_policy -- every FRQ declares whether a photo
--    of the student's work is allowed ('photo_allowed', the default for all
--    FRQs), required ('photo_required', the construct-a-graph items), or not
--    applicable ('typed_only', reserved). An ITEM-level column, deliberately
--    NOT a prompt_json key: app.taxonomy_relevant_hash() hashes prompt_json,
--    so writing into prompt_json would invalidate every validated serving
--    label and empty the practice queue (the stale-label trap recorded in
--    feedback_content_pipeline_db_and_process_traps).
-- 2. Future FRQs inherit the default on insert (trigger) and the publish gate
--    corrects a hand-drawn item to 'photo_required' and refuses an FRQ with no
--    policy at all, so the generation pipeline needs no per-item work.
-- 3. app.frq_criteria.judgement_kind -- 'text' (gradable from the confirmed
--    transcript) or 'image' (needs the picture). Informational in Phase 1
--    (hand-drawn items stay human-graded end to end); the grading UI shows
--    it, Phase 2 routes on it.
-- 4. select_student_practice_items (the live Practice selector, 2026-10-08)
--    now returns response_policy and no longer excludes hand-drawn items:
--    the Practice FRQ screen renders a capture control for them. The legacy
--    /session selectors (select_practice_frqs, select_unit_gated_practice_items)
--    keep their TASK-0038 exclusion because that surface still has no
--    transcript step.

-- ---------------------------------------------------------------------------
-- 1. response_policy
-- ---------------------------------------------------------------------------
alter table app.content_items
  add column if not exists response_policy text
  check (response_policy is null or response_policy in ('typed_only', 'photo_allowed', 'photo_required'));

comment on column app.content_items.response_policy is
  'FRQ answer intake: photo_allowed (default for every FRQ: typed, photographed, or both), photo_required (the rubric needs a constructed visual), typed_only (reserved). NULL for non-FRQ items. Item-level on purpose: prompt_json is hashed into serving labels. HAND_DRAWN_RESPONSES_ALL_FRQS_PLAN_2026_10_09 §3.';

-- Backfill. A hand-drawn construction item (any version flagged hand_drawn)
-- requires a photo; every other FRQ allows one.
update app.content_items ci
   set response_policy = 'photo_required'
 where ci.item_type = 'frq'
   and ci.response_policy is null
   and exists (
     select 1 from app.content_item_versions civ
      where civ.content_item_id = ci.id
        and coalesce((civ.prompt_json ->> 'hand_drawn')::boolean, false)
   );

update app.content_items
   set response_policy = 'photo_allowed'
 where item_type = 'frq'
   and response_policy is null;

-- Default for FRQs inserted from now on (the generation pipeline inserts
-- content_items without this column).
create or replace function app.tg_default_response_policy()
returns trigger
language plpgsql
set search_path to 'app', 'pg_temp'
as $$
begin
  if new.item_type = 'frq' and new.response_policy is null then
    new.response_policy := 'photo_allowed';
  end if;
  if new.item_type <> 'frq' then
    new.response_policy := null;
  end if;
  return new;
end;
$$;

drop trigger if exists content_items_default_response_policy on app.content_items;
create trigger content_items_default_response_policy
  before insert or update of item_type, response_policy on app.content_items
  for each row execute function app.tg_default_response_policy();

-- ---------------------------------------------------------------------------
-- 2. Publish gate: an FRQ publishes with a policy, and a hand-drawn item
--    publishes as photo_required. Extends the 20260805140000 gate in place.
-- ---------------------------------------------------------------------------
create or replace function app.tg_require_practice_format_at_publish()
returns trigger
language plpgsql
security definer
set search_path to 'app', 'pg_temp'
as $$
declare
  v_hand_drawn boolean;
begin
  if new.status = 'published'
     and old.status is distinct from 'published'
     and new.item_type = 'frq'
  then
    select coalesce((civ.prompt_json ->> 'hand_drawn')::boolean, false)
      into v_hand_drawn
    from app.content_item_versions civ
    where civ.content_item_id = new.id
      and civ.status = 'published'
    order by civ.version_num desc
    limit 1;

    if new.practice_format is null and not coalesce(v_hand_drawn, false) then
      raise exception
        'practice_format_required_at_publish: FRQ % (content_key %) cannot publish with practice_format IS NULL — set targeted_drill or full_exam_frq before publishing, or confirm it is a hand-drawn item (prompt_json.hand_drawn = true) if it should stay unreachable via select_practice_frqs',
        new.id, new.content_key;
    end if;

    -- A constructed-visual item always requires a photo, whatever the row says.
    if coalesce(v_hand_drawn, false) then
      new.response_policy := 'photo_required';
    end if;

    if new.response_policy is null then
      raise exception
        'response_policy_required_at_publish: FRQ % (content_key %) cannot publish with response_policy IS NULL — photo_allowed, photo_required, or typed_only (HAND_DRAWN_RESPONSES_ALL_FRQS_PLAN_2026_10_09 §3)',
        new.id, new.content_key;
    end if;
  end if;
  return new;
end;
$$;

comment on function app.tg_require_practice_format_at_publish() is
  'Blocks publishing an FRQ with practice_format IS NULL unless it is a hand-drawn construction item; requires response_policy on every FRQ at publish and forces photo_required on hand-drawn items (2026-10-09).';

-- ---------------------------------------------------------------------------
-- 3. judgement_kind on criteria
-- ---------------------------------------------------------------------------
alter table app.frq_criteria
  add column if not exists judgement_kind text not null default 'text'
  check (judgement_kind in ('text', 'image'));

comment on column app.frq_criteria.judgement_kind is
  'text: the criterion can be applied to the student''s words, numbers, and equations (a confirmed transcript suffices). image: the criterion needs the picture (shape, placement, bar geometry). Phase 1 informational; Phase 2 routing. HAND_DRAWN_RESPONSES_ALL_FRQS_PLAN_2026_10_09 §5.';

update app.frq_criteria c
   set judgement_kind = 'image'
  from app.content_item_versions civ
 where civ.id = c.content_item_version_id
   and coalesce((civ.prompt_json ->> 'hand_drawn')::boolean, false)
   and c.criterion_key in (
     'POINTS_PLOTTED',
     'TREND_LINE',
     'SEGMENTED_BARS',
     'WIDTHS_BY_TOTAL',
     'HEIGHTS_BY_CONDITIONAL_PROPORTION',
     'DOT_COUNTS',
     'BOXPLOT_SCALE',
     'AXIS_SCALE',
     'FIVE_NUMBER_VALUES',
     'RELATIVE_FREQUENCIES'
   );

-- ---------------------------------------------------------------------------
-- 4. Live Practice selector: return response_policy, serve hand-drawn items.
--    The return type changes, so the function is dropped and recreated with
--    the 2026-10-08 body otherwise unchanged.
-- ---------------------------------------------------------------------------
drop function if exists public.select_student_practice_items(uuid, integer, uuid, text, text, text, integer, integer);

create function public.select_student_practice_items(
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
  response_policy text,
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
$$;

revoke all on function public.select_student_practice_items(uuid, integer, uuid, text, text, text, integer, integer)
  from public, anon, authenticated;
grant execute on function public.select_student_practice_items(uuid, integer, uuid, text, text, text, integer, integer)
  to service_role;

comment on function public.select_student_practice_items(uuid, integer, uuid, text, text, text, integer, integer) is
  'Unit-gated practice selector for student-session-items (service role). Excludes the student''s submitted and Open-Hand-revealed items, puts a requested topic first, pages by offset. Returns response_policy and serves hand-drawn items (2026-10-09; was 2026-10-08).';
