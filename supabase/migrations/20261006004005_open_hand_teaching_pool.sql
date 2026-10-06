-- TASK-0064 — Open Hand teaching pool: questions shown with everything face-up
-- in Open Hand and NEVER scored.
--
-- Open Hand is a teaching method that shows everything (CONTENT_AND_PEDAGOGY.md).
-- Showing scored items burns them (DECISION-0086/0087), and inventory is too
-- thin to absorb that (TASK-0064 counts). So Open Hand draws only from a
-- designated teaching pool, and a teaching item is removed from scoring for
-- everyone:
--   * student-session-items drops teaching items from every served list
--     (_shared/student-item-delivery.ts dropTeachingItems);
--   * the trigger below refuses to create an attempt on a teaching item, as a
--     backstop that does not depend on any edge function.
-- Releasing an item (released_at set) returns it to the scored pool.
--
-- Safe to re-run: every statement is create-if-not-exists or create-or-replace.

create table if not exists app.open_hand_teaching_items (
  content_item_id uuid primary key
    references app.content_items(id) on delete cascade,
  topic_code text not null,
  source text not null check (source in ('spare', 'generated')),
  designated_at timestamptz not null default now(),
  released_at timestamptz,
  note text
);

create index if not exists open_hand_teaching_items_topic_idx
  on app.open_hand_teaching_items (topic_code)
  where released_at is null;

comment on table app.open_hand_teaching_items is
  'TASK-0064. Items reserved for Open Hand, shown with the full key and never '
  'scored. Active while released_at is null. Served lists exclude them and an '
  'attempt on one is refused by trg_refuse_attempt_on_teaching_item.';

alter table app.open_hand_teaching_items enable row level security;
alter table app.open_hand_teaching_items force row level security;
revoke all on app.open_hand_teaching_items from public, anon, authenticated;
grant select on app.open_hand_teaching_items to service_role;

create or replace function app.content_item_is_teaching(p_content_item_id uuid)
returns boolean
language sql
stable
security definer
set search_path = pg_catalog
as $$
  select exists (
    select 1 from app.open_hand_teaching_items t
    where t.content_item_id = p_content_item_id
      and t.released_at is null
  );
$$;

revoke all on function app.content_item_is_teaching(uuid) from public, anon, authenticated;
grant execute on function app.content_item_is_teaching(uuid) to service_role;

-- Backstop: no attempt may be created on a teaching item.
create or replace function app.refuse_attempt_on_teaching_item()
returns trigger
language plpgsql
security definer
set search_path = pg_catalog
as $$
begin
  if exists (
    select 1
    from app.content_item_versions civ
    join app.open_hand_teaching_items t on t.content_item_id = civ.content_item_id
    where civ.id = new.content_item_version_id
      and t.released_at is null
  ) then
    raise exception 'open_hand_item_not_scorable' using errcode = '42501';
  end if;
  return new;
end;
$$;

create or replace trigger trg_refuse_attempt_on_teaching_item
  before insert on app.attempts
  for each row execute function app.refuse_attempt_on_teaching_item();

-- Open Hand's one read: the active teaching item for a subject + topic, with the
-- full key. Entitlement-scoped like get_open_hand_item; staff/QA bypass. Writes
-- no exclusion row because a teaching item is never scored. Returns null when
-- the topic has no teaching item yet.
create or replace function public.get_open_hand_teaching_item(
  p_subject_key text,
  p_topic_code text
)
returns jsonb
language plpgsql
stable
security definer
set search_path = pg_catalog
as $$
declare
  v_user_id uuid := auth.uid();
  v_role text;
  v_is_staff boolean;
  v_subject_id uuid;
  v_civ_id uuid;
  v_ci_id uuid;
  v_result jsonb;
begin
  if v_user_id is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;
  if p_subject_key is null or p_topic_code is null then
    raise exception 'open_hand:missing_identity' using errcode = '22023';
  end if;

  select s.id into v_subject_id
  from app.subjects s
  where s.subject_key = p_subject_key and s.status = 'active';
  if v_subject_id is null then
    raise exception 'open_hand:item_not_accessible' using errcode = '42501';
  end if;

  select p.role into v_role from app.profiles p where p.user_id = v_user_id;
  v_is_staff := coalesce(v_role, '') = any (array[
    'admin', 'content_author', 'tutor', 'reader', 'validator'
  ]);

  if not v_is_staff and not exists (
    select 1 from app.subject_entitlements se
    where se.user_id = v_user_id
      and se.status = 'active'
      and (se.all_subjects is true or se.subject_id = v_subject_id)
      and (se.starts_at is null or se.starts_at <= now())
      and (se.ends_at is null or se.ends_at > now())
  ) then
    raise exception 'open_hand:entitlement_required' using errcode = '42501';
  end if;

  select civ.id, ci.id into v_civ_id, v_ci_id
  from app.open_hand_teaching_items t
  join app.content_items ci on ci.id = t.content_item_id
  join app.content_item_versions civ on civ.content_item_id = ci.id
  join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  where t.released_at is null
    and t.topic_code = p_topic_code
    and ep.subject_id = v_subject_id
    and civ.status = 'published'
    and ci.status = 'published'
    and epv.status = 'published'
    and epv.retired_at is null
  order by t.source = 'generated' desc, t.designated_at
  limit 1;

  if v_civ_id is null then
    return null;
  end if;

  select jsonb_build_object(
    'content_item_version_id', civ.id,
    'content_item_id', ci.id,
    'item_type', ci.item_type,
    'subject_key', p_subject_key,
    'topic_code', p_topic_code,
    'topic_title', (select r.topic_title from app.content_item_topic_resolution r
                    where r.content_item_version_id = civ.id and r.is_primary limit 1),
    'unit_number', (select r.unit_number from app.content_item_topic_resolution r
                    where r.content_item_version_id = civ.id and r.is_primary limit 1),
    'stem', civ.stem,
    'stimulus', civ.stimulus,
    'stimulus_image_path', civ.stimulus_image_path,
    'scoring_eligible', false,
    'canonical_answers', jsonb_strip_nulls(jsonb_build_object(
      'answer_1', civ.canonical_answer_1, 'answer_2', civ.canonical_answer_2)),
    'mcq_choices', coalesce((
      select jsonb_agg(jsonb_build_object(
        'choice_key', mc.choice_key, 'choice_text', mc.choice_text,
        'is_correct', mc.is_correct, 'rationale', mc.rationale,
        'minimum_fix', mc.rationale) order by mc.choice_key)
      from app.mcq_choices mc where mc.content_item_version_id = civ.id
    ), '[]'::jsonb),
    'frq_criteria', coalesce((
      select jsonb_agg(jsonb_build_object(
        'criterion_key', fc.criterion_key, 'learner_facing_text', fc.learner_facing_text,
        'points_possible', fc.points_possible, 'evidence_requirements', fc.evidence_requirements,
        'accepted_variants', fc.accepted_variants, 'minimum_fix', fc.minimum_fix)
        order by fc.criterion_key)
      from app.frq_criteria fc where fc.content_item_version_id = civ.id
    ), '[]'::jsonb),
    'credited_response_spans', coalesce((
      select jsonb_agg(jsonb_build_object(
        'answer_field', cas.answer_field, 'span_ordinal', cas.span_ordinal,
        'span_text', cas.span_text, 'criterion_keys', cas.criterion_keys)
        order by cas.answer_field, cas.span_ordinal)
      from app.canonical_answer_spans cas where cas.content_item_version_id = civ.id
    ), '[]'::jsonb)
  )
  into v_result
  from app.content_item_versions civ
  join app.content_items ci on ci.id = civ.content_item_id
  where civ.id = v_civ_id;

  return v_result;
end;
$$;

revoke all on function public.get_open_hand_teaching_item(text, text) from public, anon;
grant execute on function public.get_open_hand_teaching_item(text, text) to authenticated, service_role;

comment on function public.get_open_hand_teaching_item(text, text) is
  'TASK-0064. Returns the active Open Hand teaching item for a subject and topic '
  'with its full key, or null when the topic has none yet. Entitlement-scoped; '
  'staff/QA bypass. Teaching items are never scored, so no exclusion is written.';
