-- TASK-0067 Phase A + TASK-0066 Phase A (DECISION-0104, DECISION-0105; APPROVAL-0136, APPROVAL-0137).
-- Unit reference entries (formulas, vocabulary, lists/sequences, conventions, diagrams) and the
-- memory hooks that attach to them. Keyed on (subject_key, topic_code) text exactly as
-- app.topic_explainers is, because TASK-0054's taxonomy FK has not landed; convert both together
-- when it does. Student reads go through public.get_topic_point_guides (added keys only) and two
-- security_invoker views created here in the same migration.

begin;

-- ---------------------------------------------------------------------------
-- 1. app.unit_reference_entries
-- ---------------------------------------------------------------------------

create table app.unit_reference_entries (
  reference_entry_id uuid primary key default gen_random_uuid(),
  subject_key text not null,
  unit_number integer not null,
  owner_topic_code text not null,
  topic_codes text[] not null,
  kind text not null,
  title text not null,
  body text not null,
  items jsonb not null default '[]'::jsonb,
  visual_asset_ref text,
  caution text,
  status text not null default 'draft',
  source_note text not null default 'cramapple-authored',
  published_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint unit_reference_entries_subject_key_check
    check (subject_key ~ '^[a-z0-9][a-z0-9_]*$'),
  constraint unit_reference_entries_unit_check check (unit_number > 0),
  constraint unit_reference_entries_owner_topic_code_check
    check (owner_topic_code ~ '^[0-9]+\.[0-9]+$'),
  constraint unit_reference_entries_topic_codes_check
    check (
      cardinality(topic_codes) >= 1
      and owner_topic_code = any (topic_codes)
      and array_to_string(topic_codes, ',') ~ '^[0-9]+\.[0-9]+(,[0-9]+\.[0-9]+)*$'
    ),
  constraint unit_reference_entries_kind_check
    check (kind in ('formula', 'vocabulary', 'list_sequence', 'convention', 'diagram')),
  constraint unit_reference_entries_title_check check (length(btrim(title)) between 1 and 160),
  constraint unit_reference_entries_body_check check (length(btrim(body)) >= 1),
  constraint unit_reference_entries_items_check check (jsonb_typeof(items) = 'array'),
  constraint unit_reference_entries_visual_asset_kind_check
    check (visual_asset_ref is null or kind = 'diagram'),
  constraint unit_reference_entries_status_check
    check (status in ('draft', 'published', 'retired')),
  constraint unit_reference_entries_unique_entry
    unique (subject_key, owner_topic_code, kind, title)
);

comment on table app.unit_reference_entries is
  'TASK-0067: the formulas, vocabulary, lists/sequences, conventions and CED-required diagrams a student may look up. Owned by the topic that introduces the entry (owner_topic_code); topic_codes lists every topic that reuses it; unit_number is the owner topic''s unit. Memory hooks (app.topic_memory_hooks) attach here.';
comment on column app.unit_reference_entries.body is
  'formula: LaTeX; vocabulary: the definition; convention: one line; list_sequence/diagram: a one-line description, with the ordered members in items.';
comment on column app.unit_reference_entries.items is
  'Ordered array of {"label","meaning"} for list_sequence and diagram (the labelled parts); [] otherwise.';
comment on column app.unit_reference_entries.visual_asset_ref is
  'diagram only: a reference to an existing visual-stimulus asset (TASK-0006 governed-diagram lane). Null means the entry renders as text until an asset exists.';
comment on column app.unit_reference_entries.caution is
  'CED-language note shown with the entry when the reference wording is not the wording that earns the point.';

create index unit_reference_entries_subject_unit_idx
  on app.unit_reference_entries (subject_key, unit_number, status);
create index unit_reference_entries_topic_codes_idx
  on app.unit_reference_entries using gin (topic_codes);

create trigger unit_reference_entries_set_updated_at
  before update on app.unit_reference_entries
  for each row execute function app.set_updated_at();

alter table app.unit_reference_entries enable row level security;
alter table app.unit_reference_entries force row level security;
revoke all on app.unit_reference_entries from public, anon, authenticated;
grant select, insert, update, delete on app.unit_reference_entries to service_role;
grant select on app.unit_reference_entries to authenticated;

create policy unit_reference_entries_select_published
on app.unit_reference_entries
for select
to authenticated
using (
  status = 'published'
  and exists (
    select 1
    from app.subjects s
    where app.normalize_student_subject_key(s.subject_key) = unit_reference_entries.subject_key
      and s.status = 'active'
  )
);

-- ---------------------------------------------------------------------------
-- 2. app.topic_memory_hooks (DECISION-0105 R2: every hook points at an entry)
-- ---------------------------------------------------------------------------

create table app.topic_memory_hooks (
  memory_hook_id uuid primary key default gen_random_uuid(),
  reference_entry_id uuid not null
    references app.unit_reference_entries(reference_entry_id) on delete restrict,
  kind text not null,
  hook_text text not null,
  expands_to jsonb not null default '[]'::jsonb,
  when_to_use text not null,
  caution text,
  status text not null default 'draft',
  source_note text not null default 'cramapple-authored',
  published_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint topic_memory_hooks_kind_check
    check (kind in ('acronym', 'acrostic', 'phrase', 'formula_sentence', 'visual', 'diagram_parts')),
  constraint topic_memory_hooks_hook_text_check check (length(btrim(hook_text)) between 1 and 200),
  constraint topic_memory_hooks_when_to_use_check check (length(btrim(when_to_use)) >= 1),
  constraint topic_memory_hooks_expands_to_check check (jsonb_typeof(expands_to) = 'array'),
  constraint topic_memory_hooks_status_check
    check (status in ('draft', 'published', 'retired')),
  constraint topic_memory_hooks_source_note_check
    check (source_note in ('cramapple-authored', 'public-domain-common', 'generated-checked')),
  constraint topic_memory_hooks_unique_hook unique (reference_entry_id, hook_text)
);

comment on table app.topic_memory_hooks is
  'TASK-0066: a memory device (acronym, acrostic, phrase, formula sentence, visual cue, diagram parts) for recalling exactly one unit reference entry. Subject, owner topic, topic_codes and unit are inherited from the entry. A hook is for recall; the exam answer is written in CED language (see caution).';
comment on column app.topic_memory_hooks.expands_to is
  'Ordered array of {"cue","means"}: what each letter or beat of the hook stands for.';

create index topic_memory_hooks_entry_idx
  on app.topic_memory_hooks (reference_entry_id, status);

create trigger topic_memory_hooks_set_updated_at
  before update on app.topic_memory_hooks
  for each row execute function app.set_updated_at();

alter table app.topic_memory_hooks enable row level security;
alter table app.topic_memory_hooks force row level security;
revoke all on app.topic_memory_hooks from public, anon, authenticated;
grant select, insert, update, delete on app.topic_memory_hooks to service_role;
grant select on app.topic_memory_hooks to authenticated;

create policy topic_memory_hooks_select_published
on app.topic_memory_hooks
for select
to authenticated
using (
  status = 'published'
  and exists (
    select 1
    from app.unit_reference_entries ure
    join app.subjects s
      on app.normalize_student_subject_key(s.subject_key) = ure.subject_key
     and s.status = 'active'
    where ure.reference_entry_id = topic_memory_hooks.reference_entry_id
      and ure.status = 'published'
  )
);

-- A hook can only be published against a published entry; an entry cannot leave 'published'
-- while a published hook still points at it.

create or replace function app.guard_memory_hook_publish()
returns trigger
language plpgsql
security definer
set search_path = pg_catalog
as $$
declare
  v_entry_status text;
begin
  if new.status = 'published' then
    select ure.status into v_entry_status
    from app.unit_reference_entries ure
    where ure.reference_entry_id = new.reference_entry_id;
    if v_entry_status is distinct from 'published' then
      raise exception 'memory_hooks:entry_not_published'
        using errcode = '23514',
              detail = format('reference_entry_id %s has status %s', new.reference_entry_id, coalesce(v_entry_status, 'missing'));
    end if;
    if new.published_at is null then
      new.published_at := now();
    end if;
  end if;
  return new;
end;
$$;

create trigger topic_memory_hooks_guard_publish
  before insert or update on app.topic_memory_hooks
  for each row execute function app.guard_memory_hook_publish();

create or replace function app.guard_reference_entry_unpublish()
returns trigger
language plpgsql
security definer
set search_path = pg_catalog
as $$
begin
  if old.status = 'published' and new.status <> 'published'
     and exists (
       select 1 from app.topic_memory_hooks h
       where h.reference_entry_id = old.reference_entry_id and h.status = 'published'
     ) then
    raise exception 'reference_entries:published_hooks_attached'
      using errcode = '23514',
            detail = format('retire or unpublish the hooks on %s first', old.reference_entry_id);
  end if;
  if new.status = 'published' and new.published_at is null then
    new.published_at := now();
  end if;
  return new;
end;
$$;

create trigger unit_reference_entries_guard_unpublish
  before insert or update on app.unit_reference_entries
  for each row execute function app.guard_reference_entry_unpublish();

-- ---------------------------------------------------------------------------
-- 3. Public views (same migration: public views do not pick up columns on their own)
-- ---------------------------------------------------------------------------

create or replace view public.unit_reference_entries
with (security_invoker = true, security_barrier = true)
as
select
  ure.reference_entry_id as id,
  coalesce(registry_subject.subject_key, ure.subject_key) as subject_key,
  ure.unit_number,
  'unit-' || ure.unit_number::text as unit_id,
  ure.owner_topic_code as topic_id,
  ure.owner_topic_code,
  ure.topic_codes,
  ure.kind,
  ure.title,
  ure.body,
  ure.items,
  ure.visual_asset_ref,
  ure.caution,
  ure.source_note,
  ure.created_at,
  ure.updated_at,
  ure.published_at,
  split_part(ure.owner_topic_code, '.', 1)::integer as topic_sort_major,
  split_part(ure.owner_topic_code, '.', 2)::integer as topic_sort_minor,
  (split_part(ure.owner_topic_code, '.', 1)::integer * 1000)
    + split_part(ure.owner_topic_code, '.', 2)::integer as topic_sort_key,
  ure.subject_key as canonical_subject_key
from app.unit_reference_entries ure
left join lateral (
  select s.subject_key
  from app.subjects s
  where app.normalize_student_subject_key(s.subject_key) = ure.subject_key
    and s.status = 'active'
  order by s.created_at nulls last, s.subject_key
  limit 1
) registry_subject on true
where ure.status = 'published';

create or replace view public.topic_memory_hooks
with (security_invoker = true, security_barrier = true)
as
select
  h.memory_hook_id as id,
  h.reference_entry_id,
  coalesce(registry_subject.subject_key, ure.subject_key) as subject_key,
  ure.unit_number,
  ure.owner_topic_code,
  ure.topic_codes,
  ure.kind as reference_kind,
  ure.title as reference_title,
  h.kind,
  h.hook_text,
  h.expands_to,
  h.when_to_use,
  h.caution,
  h.source_note,
  h.created_at,
  h.updated_at,
  h.published_at,
  ure.subject_key as canonical_subject_key
from app.topic_memory_hooks h
join app.unit_reference_entries ure on ure.reference_entry_id = h.reference_entry_id
left join lateral (
  select s.subject_key
  from app.subjects s
  where app.normalize_student_subject_key(s.subject_key) = ure.subject_key
    and s.status = 'active'
  order by s.created_at nulls last, s.subject_key
  limit 1
) registry_subject on true
where h.status = 'published'
  and ure.status = 'published';

revoke all on public.unit_reference_entries
  from public, anon, authenticated, service_role;
revoke all on public.topic_memory_hooks
  from public, anon, authenticated, service_role;
grant select on public.unit_reference_entries to authenticated, service_role;
grant select on public.topic_memory_hooks to authenticated, service_role;

comment on view public.unit_reference_entries is
  'Authenticated read view for published unit reference entries. subject_key is the student-facing registry key; canonical_subject_key is the app content key.';
comment on view public.topic_memory_hooks is
  'Authenticated read view for published memory hooks joined to their published reference entry.';

-- ---------------------------------------------------------------------------
-- 4. public.get_topic_point_guides: existing keys unchanged; adds reference[] and memoryHooks[]
--    A topic call (topic given) ignores the unit filter for reference entries so an entry owned by
--    an earlier unit that lists this topic in topic_codes still appears (DECISION-0105 R2 reuse).
-- ---------------------------------------------------------------------------

create or replace function public.get_topic_point_guides(
  _subject_key text,
  _unit_number integer default null,
  _topic_code text default null
)
returns jsonb
language plpgsql
stable
security definer
set search_path = pg_catalog
as $$
declare
  v_user_id uuid := auth.uid();
  v_subject_key text := nullif(app.normalize_student_subject_key(_subject_key), '');
  v_topic_code text := nullif(btrim(_topic_code), '');
  v_payload jsonb;
begin
  if v_user_id is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;
  if v_subject_key is null then
    raise exception 'topic_guides:subject_required' using errcode = '22023';
  end if;
  if v_subject_key !~ '^[a-z0-9][a-z0-9_]*$' then
    raise exception 'topic_guides:invalid_subject_key' using errcode = '22023';
  end if;
  if _unit_number is not null and _unit_number <= 0 then
    raise exception 'topic_guides:invalid_unit' using errcode = '22023';
  end if;
  if v_topic_code is not null and v_topic_code !~ '^[0-9]+\.[0-9]+$' then
    raise exception 'topic_guides:invalid_topic_code' using errcode = '22023';
  end if;

  with published_briefs as (
    select *
    from app.topic_point_briefs tpb
    where tpb.subject_key = v_subject_key
      and tpb.status = 'published'
      and (_unit_number is null or tpb.unit_number = _unit_number)
      and (v_topic_code is null or tpb.topic_code = v_topic_code)
  ), published_explainers as (
    select *
    from app.topic_explainers te
    where te.subject_key = v_subject_key
      and te.status = 'published'
      and (_unit_number is null or te.unit_number = _unit_number)
      and (v_topic_code is null or te.topic_code = v_topic_code)
  ), published_reference as (
    select *
    from app.unit_reference_entries ure
    where ure.subject_key = v_subject_key
      and ure.status = 'published'
      and (
        (v_topic_code is not null and v_topic_code = any (ure.topic_codes))
        or (v_topic_code is null and (_unit_number is null or ure.unit_number = _unit_number))
      )
  ), published_hooks as (
    select h.*, pr.owner_topic_code, pr.unit_number, pr.title as reference_title, pr.kind as reference_kind
    from app.topic_memory_hooks h
    join published_reference pr on pr.reference_entry_id = h.reference_entry_id
    where h.status = 'published'
  )
  select jsonb_build_object(
    'subjectKey', v_subject_key,
    'unitNumber', _unit_number,
    'topicCode', v_topic_code,
    'briefs', coalesce((
      select jsonb_agg(
        jsonb_build_object(
          'subjectKey', tpb.subject_key,
          'unitId', 'unit-' || tpb.unit_number::text,
          'unitNumber', tpb.unit_number,
          'topicId', tpb.topic_code,
          'topicCode', tpb.topic_code,
          'title', tpb.title,
          'classImportance', tpb.class_importance,
          'examImportance', tpb.exam_importance,
          'whatItIs', tpb.what_it_is,
          'whyItMatters', tpb.why_it_matters,
          'howPointsAreEarned', tpb.how_points_are_earned,
          'answerMove', tpb.answer_move,
          'commonPointLoss', tpb.common_point_loss,
          'learnMorePath', tpb.learn_more_path,
          'practiceParams', jsonb_build_object(
            'subject', tpb.practice_subject_key,
            'unit', tpb.practice_unit_number::text,
            'topic', tpb.practice_topic_code
          )
        )
        order by
          tpb.unit_number,
          split_part(tpb.topic_code, '.', 1)::integer,
          split_part(tpb.topic_code, '.', 2)::integer
      )
      from published_briefs tpb
    ), '[]'::jsonb),
    'explainers', coalesce((
      select jsonb_agg(
        jsonb_build_object(
          'subject', te.subject_key,
          'subjectKey', te.subject_key,
          'unitId', 'unit-' || te.unit_number::text,
          'unitNumber', te.unit_number,
          'topicId', te.topic_code,
          'topicCode', te.topic_code,
          'title', te.title,
          'coreIdea', te.core_idea,
          'whatStudentsNeedToUnderstand', te.what_students_need_to_understand,
          'howThisBecomesPoints', te.how_this_becomes_points,
          'answerMove', te.answer_move,
          'miniExample', jsonb_build_object(
            'question', te.mini_example_question,
            'weakAnswer', te.weak_answer,
            'pointAttainingAnswer', te.point_attaining_answer
          ),
          'commonPointLoss', te.common_point_loss,
          'practiceBridge', te.practice_bridge
        )
        order by
          te.unit_number,
          split_part(te.topic_code, '.', 1)::integer,
          split_part(te.topic_code, '.', 2)::integer
      )
      from published_explainers te
    ), '[]'::jsonb),
    'reference', coalesce((
      select jsonb_agg(
        jsonb_build_object(
          'id', pr.reference_entry_id,
          'subjectKey', pr.subject_key,
          'unitNumber', pr.unit_number,
          'ownerTopicCode', pr.owner_topic_code,
          'topicCodes', to_jsonb(pr.topic_codes),
          'kind', pr.kind,
          'title', pr.title,
          'body', pr.body,
          'items', pr.items,
          'visualAssetRef', pr.visual_asset_ref,
          'caution', pr.caution,
          'sourceNote', pr.source_note,
          'memoryHooks', coalesce((
            select jsonb_agg(
              jsonb_build_object(
                'id', ph.memory_hook_id,
                'kind', ph.kind,
                'hookText', ph.hook_text,
                'expandsTo', ph.expands_to,
                'whenToUse', ph.when_to_use,
                'caution', ph.caution,
                'sourceNote', ph.source_note
              )
              order by ph.created_at
            )
            from published_hooks ph
            where ph.reference_entry_id = pr.reference_entry_id
          ), '[]'::jsonb)
        )
        order by
          array_position(array['formula', 'vocabulary', 'list_sequence', 'convention', 'diagram'], pr.kind),
          pr.unit_number,
          split_part(pr.owner_topic_code, '.', 1)::integer,
          split_part(pr.owner_topic_code, '.', 2)::integer,
          pr.title
      )
      from published_reference pr
    ), '[]'::jsonb),
    'memoryHooks', coalesce((
      select jsonb_agg(
        jsonb_build_object(
          'id', ph.memory_hook_id,
          'referenceEntryId', ph.reference_entry_id,
          'referenceTitle', ph.reference_title,
          'referenceKind', ph.reference_kind,
          'ownerTopicCode', ph.owner_topic_code,
          'unitNumber', ph.unit_number,
          'kind', ph.kind,
          'hookText', ph.hook_text,
          'expandsTo', ph.expands_to,
          'whenToUse', ph.when_to_use,
          'caution', ph.caution,
          'sourceNote', ph.source_note
        )
        order by
          ph.unit_number,
          split_part(ph.owner_topic_code, '.', 1)::integer,
          split_part(ph.owner_topic_code, '.', 2)::integer,
          ph.created_at
      )
      from published_hooks ph
    ), '[]'::jsonb)
  )
  into v_payload;

  return v_payload;
end;
$$;

revoke all on function public.get_topic_point_guides(text, integer, text)
  from public, anon;
grant execute on function public.get_topic_point_guides(text, integer, text)
  to authenticated, service_role;

commit;
