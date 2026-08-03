-- DECISION-0045: gold-set verification backend.
--
-- Readers verify AI-generated answers against rubric elements to certify the
-- automated labelling pipeline. The scientific validity of that certification
-- depends on the reader never seeing the writer's script, the machine
-- verifiers' marks, the grader's output, the writing model, the route an
-- answer took, or the item's canonical answer.
--
-- That guarantee is enforced HERE, not in the UI. app.gold_set_answers holds
-- the contaminating columns and is reachable only by service_role. The reader
-- reaches their queue exclusively through public.gold_set_verification_next(),
-- which projects a fixed, safe column list. A frontend bug cannot leak what the
-- contract never sends.
--
-- Protocol: docs/research/GOLD_SET_GENERATION_PROTOCOL.md (Phase 4)

begin;

-- ── Corpus ───────────────────────────────────────────────────────────────────

create table app.gold_set_answers (
  gold_set_answer_id uuid primary key default gen_random_uuid(),
  set_key text not null,
  content_item_version_id uuid not null
    references app.content_item_versions(id) on delete restrict,
  answer_type text not null,
  answer_text text not null,
  -- Contaminating columns. Never projected to a reader.
  writer_family text not null,
  script jsonb not null,
  script_hash text not null,
  route text not null,
  -- Freeze guard (protocol 0.3): the item hash the answer was written against.
  item_content_hash text not null,
  created_at timestamptz not null default now(),
  constraint gold_set_answers_set_key_check
    check (set_key in ('A', 'B', 'C')),
  constraint gold_set_answers_answer_type_check
    check (answer_type in ('A1','A2','A3','A4','A5','A6','A7','A8')),
  constraint gold_set_answers_writer_family_check
    check (writer_family in ('anthropic','google','moonshot','deepseek','bank')),
  constraint gold_set_answers_route_check
    check (route in ('provisional_accept','reader_queue')),
  constraint gold_set_answers_answer_text_check
    check (char_length(btrim(answer_text)) > 0),
  constraint gold_set_answers_script_object_check
    check (jsonb_typeof(script) = 'object')
);

comment on column app.gold_set_answers.writer_family is
  'Protocol R1/R2: never openai. A1 answers come from the bank (canonical_answer_1).';

create index gold_set_answers_version_idx
  on app.gold_set_answers (content_item_version_id);

-- ── Elements ─────────────────────────────────────────────────────────────────
--
-- One row per point. Set B (single-point criteria) is 1:1 with frq_criteria.
-- Set A (multi-point) expands one criterion into several, from the
-- reader-confirmed decomposition. The reader-facing contract is identical for
-- both, so the verification screen does not change when Set A arrives.

create table app.gold_set_elements (
  gold_set_element_id uuid primary key default gen_random_uuid(),
  frq_criterion_id uuid not null
    references app.frq_criteria(id) on delete cascade,
  content_item_version_id uuid not null
    references app.content_item_versions(id) on delete restrict,
  element_index integer not null,
  element_label text not null,
  confirmed_by uuid references app.profiles(user_id),
  confirmed_at timestamptz,
  created_at timestamptz not null default now(),
  constraint gold_set_elements_index_check check (element_index > 0),
  constraint gold_set_elements_label_check
    check (char_length(btrim(element_label)) > 0),
  constraint gold_set_elements_confirmation_check
    check ((confirmed_by is null) = (confirmed_at is null)),
  constraint gold_set_elements_unique_index
    unique (frq_criterion_id, element_index)
);

create index gold_set_elements_version_idx
  on app.gold_set_elements (content_item_version_id, element_index);

-- ── Assignments ──────────────────────────────────────────────────────────────

create table app.gold_set_verification_assignments (
  gold_set_verification_assignment_id uuid primary key default gen_random_uuid(),
  gold_set_answer_id uuid not null
    references app.gold_set_answers(gold_set_answer_id) on delete cascade,
  reviewer_id uuid not null
    references app.profiles(user_id) on delete cascade,
  seq integer not null,
  status text not null default 'pending',
  assigned_at timestamptz not null default now(),
  submitted_at timestamptz,
  constraint gold_set_verification_assignments_status_check
    check (status in ('pending','submitted','flagged_contaminated')),
  constraint gold_set_verification_assignments_seq_check check (seq > 0),
  constraint gold_set_verification_assignments_terminal_check
    check (
      (status = 'pending' and submitted_at is null)
      or (status <> 'pending' and submitted_at is not null)
    ),
  constraint gold_set_verification_assignments_unique_seq
    unique (reviewer_id, seq) deferrable initially deferred,
  constraint gold_set_verification_assignments_unique_answer
    unique (reviewer_id, gold_set_answer_id)
);

create index gold_set_verification_assignments_queue_idx
  on app.gold_set_verification_assignments (reviewer_id, status, seq);

-- ── Marks ────────────────────────────────────────────────────────────────────

create table app.gold_set_element_marks (
  gold_set_element_mark_id uuid primary key default gen_random_uuid(),
  gold_set_verification_assignment_id uuid not null
    references app.gold_set_verification_assignments(
      gold_set_verification_assignment_id
    ) on delete cascade,
  gold_set_element_id uuid not null
    references app.gold_set_elements(gold_set_element_id) on delete restrict,
  present boolean not null,
  evidence_quote text,
  created_at timestamptz not null default now(),
  -- A present mark must cite the words that satisfy the element. An absent
  -- mark cites nothing: there is nothing to quote.
  constraint gold_set_element_marks_evidence_check
    check (
      (present and char_length(btrim(coalesce(evidence_quote, ''))) > 0)
      or (not present and coalesce(btrim(evidence_quote), '') = '')
    ),
  constraint gold_set_element_marks_quote_length_check
    check (char_length(coalesce(evidence_quote, '')) <= 300),
  constraint gold_set_element_marks_unique_element
    unique (gold_set_verification_assignment_id, gold_set_element_id)
);

-- ── Immutability ─────────────────────────────────────────────────────────────
--
-- A reader's cold marking is evidence. It is written once and never revised:
-- a reader who can go back and adjust after seeing later answers is no longer
-- marking each one independently.

create or replace function app.gold_set_marks_are_immutable()
returns trigger
language plpgsql
set search_path = pg_catalog
as $$
begin
  raise exception 'gold_set_marks_immutable'
    using errcode = '0A000',
          detail = 'Element marks are write-once; corrections are not permitted.';
end;
$$;

-- UPDATE only, deliberately. DELETE is governed by grants (service_role alone),
-- so operational cleanup and reseeding still work — a BEFORE DELETE trigger
-- here would also fire on the assignment cascade and make an aborted pilot
-- impossible to tear down.
create trigger tg_gold_set_element_marks_immutable
  before update on app.gold_set_element_marks
  for each row execute function app.gold_set_marks_are_immutable();

alter table app.gold_set_answers enable row level security;
alter table app.gold_set_answers force row level security;
alter table app.gold_set_elements enable row level security;
alter table app.gold_set_elements force row level security;
alter table app.gold_set_verification_assignments enable row level security;
alter table app.gold_set_verification_assignments force row level security;
alter table app.gold_set_element_marks enable row level security;
alter table app.gold_set_element_marks force row level security;

-- No policies for anon/authenticated on any of these tables. Reader access is
-- exclusively through the definer RPCs below, which is what makes the safe
-- column projection unbypassable.
revoke all on app.gold_set_answers from public, anon, authenticated;
revoke all on app.gold_set_elements from public, anon, authenticated;
revoke all on app.gold_set_verification_assignments
  from public, anon, authenticated;
revoke all on app.gold_set_element_marks from public, anon, authenticated;

grant select, insert, update, delete on app.gold_set_answers to service_role;
grant select, insert, update, delete on app.gold_set_elements to service_role;
grant select, insert, update, delete
  on app.gold_set_verification_assignments to service_role;
grant select, insert on app.gold_set_element_marks to service_role;

-- ── Reader contract ──────────────────────────────────────────────────────────

create or replace function app.gold_set_reader_is_eligible(p_user_id uuid)
returns boolean
language sql
stable
security definer
set search_path = pg_catalog
as $$
  select exists (
    select 1
    from app.profiles p
    where p.user_id = p_user_id
      and p.role in ('admin', 'tutor', 'reader')
  );
$$;

revoke all on function app.gold_set_reader_is_eligible(uuid)
  from public, anon, authenticated;
grant execute on function app.gold_set_reader_is_eligible(uuid) to service_role;

-- The single read surface for a verifying reader.
--
-- Projects a FIXED column list. Adding a column here is the only way to leak
-- contaminating data to a reader, so any change to this projection must be
-- reviewed against protocol §3 (R3) before it ships.
create or replace function public.gold_set_verification_next()
returns jsonb
language plpgsql
stable
security definer
set search_path = pg_catalog
as $$
declare
  v_user_id uuid := auth.uid();
  v_result jsonb;
begin
  if v_user_id is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;

  if not app.gold_set_reader_is_eligible(v_user_id) then
    raise exception 'not_authorized' using errcode = '42501';
  end if;

  select jsonb_build_object(
    'assignment_id', a.gold_set_verification_assignment_id,
    'seq', a.seq,
    'stem', civ.stem,
    'stimulus', civ.stimulus,
    'stimulus_image_path', civ.stimulus_image_path,
    'answer_text', ans.answer_text,
    'elements', coalesce(
      (
        select jsonb_agg(
          jsonb_build_object(
            'element_id', e.gold_set_element_id,
            'criterion_key', fc.criterion_key,
            'element_label', e.element_label,
            'element_index', e.element_index
          )
          order by fc.criterion_key, e.element_index
        )
        from app.gold_set_elements e
        join app.frq_criteria fc on fc.id = e.frq_criterion_id
        where e.content_item_version_id = ans.content_item_version_id
      ),
      '[]'::jsonb
    )
  )
  into v_result
  from app.gold_set_verification_assignments a
  join app.gold_set_answers ans
    on ans.gold_set_answer_id = a.gold_set_answer_id
  join app.content_item_versions civ
    on civ.id = ans.content_item_version_id
  where a.reviewer_id = v_user_id
    and a.status = 'pending'
  order by a.seq
  limit 1;

  -- Null means the queue is drained, not an error.
  return v_result;
end;
$$;

revoke all on function public.gold_set_verification_next() from public, anon;
grant execute on function public.gold_set_verification_next() to authenticated;

create or replace function public.gold_set_verification_progress()
returns jsonb
language plpgsql
stable
security definer
set search_path = pg_catalog
as $$
declare
  v_user_id uuid := auth.uid();
  v_done integer;
  v_total integer;
begin
  if v_user_id is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;

  select
    count(*) filter (where status <> 'pending'),
    count(*)
  into v_done, v_total
  from app.gold_set_verification_assignments
  where reviewer_id = v_user_id;

  return jsonb_build_object('done', coalesce(v_done, 0), 'total', coalesce(v_total, 0));
end;
$$;

revoke all on function public.gold_set_verification_progress() from public, anon;
grant execute on function public.gold_set_verification_progress() to authenticated;

-- Atomic submit. Function body is one transaction, so marks and the status
-- flip commit together or not at all.
--
-- Idempotent by design: resubmitting an already-closed assignment returns
-- status 'already_submitted' rather than raising, so a double-tap or a retry
-- after a dropped response advances the reader instead of showing an error.
create or replace function public.submit_gold_set_verification(
  p_assignment_id uuid,
  p_marks jsonb,
  p_flagged_contaminated boolean default false
)
returns jsonb
language plpgsql
security definer
set search_path = pg_catalog
as $$
declare
  v_user_id uuid := auth.uid();
  v_assignment app.gold_set_verification_assignments%rowtype;
  v_version_id uuid;
  v_expected_elements integer;
  v_supplied_elements integer;
  v_status text;
begin
  if v_user_id is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;

  select * into v_assignment
  from app.gold_set_verification_assignments
  where gold_set_verification_assignment_id = p_assignment_id
  for update;

  if not found then
    raise exception 'assignment_not_found' using errcode = 'P0002';
  end if;

  if v_assignment.reviewer_id <> v_user_id then
    raise exception 'not_authorized' using errcode = '42501';
  end if;

  if v_assignment.status <> 'pending' then
    return jsonb_build_object(
      'status', 'already_submitted',
      'assignment_id', p_assignment_id
    );
  end if;

  if jsonb_typeof(p_marks) <> 'array' then
    raise exception 'invalid_marks' using errcode = '22023';
  end if;

  select ans.content_item_version_id into v_version_id
  from app.gold_set_answers ans
  where ans.gold_set_answer_id = v_assignment.gold_set_answer_id;

  v_status := case
    when p_flagged_contaminated then 'flagged_contaminated'
    else 'submitted'
  end;

  -- A contaminated answer is set aside; partial or empty marks are expected
  -- and are not evidence, so completeness is not required on that path.
  if not p_flagged_contaminated then
    select count(*) into v_expected_elements
    from app.gold_set_elements
    where content_item_version_id = v_version_id;

    -- An item with no seeded elements would otherwise accept an empty marking
    -- and record it as a completed verification.
    if v_expected_elements = 0 then
      raise exception 'no_elements_seeded'
        using errcode = '23514',
              detail = 'This item has no gold_set_elements; seed them before verification.';
    end if;

    select count(*) into v_supplied_elements
    from jsonb_array_elements(p_marks) m
    where (m ->> 'element_id') is not null;

    if v_supplied_elements <> v_expected_elements then
      raise exception 'incomplete_marks'
        using errcode = '23514',
              detail = format(
                'expected %s element marks, received %s',
                v_expected_elements, v_supplied_elements
              );
    end if;
  end if;

  insert into app.gold_set_element_marks (
    gold_set_verification_assignment_id,
    gold_set_element_id,
    present,
    evidence_quote
  )
  select
    p_assignment_id,
    (m ->> 'element_id')::uuid,
    (m ->> 'present')::boolean,
    nullif(btrim(coalesce(m ->> 'evidence_quote', '')), '')
  from jsonb_array_elements(p_marks) m
  where (m ->> 'element_id') is not null;

  -- Every mark must belong to an element of THIS answer's item. Without this,
  -- a malformed client could file marks against another item's elements.
  if exists (
    select 1
    from app.gold_set_element_marks mk
    join app.gold_set_elements e
      on e.gold_set_element_id = mk.gold_set_element_id
    where mk.gold_set_verification_assignment_id = p_assignment_id
      and e.content_item_version_id is distinct from v_version_id
  ) then
    raise exception 'element_item_mismatch' using errcode = '23514';
  end if;

  update app.gold_set_verification_assignments
  set status = v_status,
      submitted_at = pg_catalog.now()
  where gold_set_verification_assignment_id = p_assignment_id;

  return jsonb_build_object(
    'status', v_status,
    'assignment_id', p_assignment_id
  );
end;
$$;

revoke all on function public.submit_gold_set_verification(uuid, jsonb, boolean)
  from public, anon;
grant execute on function public.submit_gold_set_verification(uuid, jsonb, boolean)
  to authenticated;

-- ── Seeding (service_role only) ──────────────────────────────────────────────

-- Materialize Set B elements: single-point criteria map 1:1 to elements.
create or replace function app.seed_gold_set_elements_single_point(
  p_content_item_version_id uuid
)
returns integer
language plpgsql
security definer
set search_path = pg_catalog
as $$
declare
  v_inserted integer;
begin
  if exists (
    select 1 from app.frq_criteria
    where content_item_version_id = p_content_item_version_id
      and points_possible > 1
  ) then
    raise exception 'multi_point_criterion_requires_decomposition'
      using errcode = '23514',
            detail = 'Use the Set A decomposition path; do not auto-map multi-point criteria.';
  end if;

  insert into app.gold_set_elements (
    frq_criterion_id, content_item_version_id, element_index, element_label
  )
  select fc.id, fc.content_item_version_id, 1, fc.learner_facing_text
  from app.frq_criteria fc
  where fc.content_item_version_id = p_content_item_version_id
  on conflict (frq_criterion_id, element_index) do nothing;

  get diagnostics v_inserted = row_count;
  return v_inserted;
end;
$$;

revoke all on function app.seed_gold_set_elements_single_point(uuid)
  from public, anon, authenticated;
grant execute on function app.seed_gold_set_elements_single_point(uuid)
  to service_role;

-- Assign a reader's queue with sibling separation.
--
-- Answers from the same item are interleaved round-robin, so two answers to
-- the same question are always exactly (number of distinct items) apart. Seeing
-- siblings back to back anchors the reader's marking, and that bias is
-- systematic rather than random, so it does not average out.
create or replace function app.seed_gold_set_verification_assignments(
  p_reviewer_id uuid,
  p_answer_ids uuid[],
  p_min_sibling_gap integer default 3
)
returns integer
language plpgsql
security definer
set search_path = pg_catalog
as $$
declare
  v_distinct_items integer;
  v_inserted integer;
  v_seq_offset integer;
begin
  if not app.gold_set_reader_is_eligible(p_reviewer_id) then
    raise exception 'reviewer_not_eligible' using errcode = '42501';
  end if;

  select count(distinct ans.content_item_version_id) into v_distinct_items
  from app.gold_set_answers ans
  where ans.gold_set_answer_id = any(p_answer_ids);

  if v_distinct_items < p_min_sibling_gap then
    raise exception 'insufficient_items_for_sibling_gap'
      using errcode = '23514',
            detail = format(
              '%s distinct items cannot guarantee a sibling gap of %s',
              v_distinct_items, p_min_sibling_gap
            );
  end if;

  select coalesce(max(seq), 0) into v_seq_offset
  from app.gold_set_verification_assignments
  where reviewer_id = p_reviewer_id;

  with ordered as (
    select
      ans.gold_set_answer_id,
      row_number() over (
        partition by ans.content_item_version_id order by random()
      ) as rank_in_item,
      dense_rank() over (order by ans.content_item_version_id) as item_pos
    from app.gold_set_answers ans
    where ans.gold_set_answer_id = any(p_answer_ids)
  )
  insert into app.gold_set_verification_assignments (
    gold_set_answer_id, reviewer_id, seq
  )
  select
    o.gold_set_answer_id,
    p_reviewer_id,
    v_seq_offset + row_number() over (order by o.rank_in_item, o.item_pos)
  from ordered o
  on conflict (reviewer_id, gold_set_answer_id) do nothing;

  get diagnostics v_inserted = row_count;
  return v_inserted;
end;
$$;

revoke all on function app.seed_gold_set_verification_assignments(uuid, uuid[], integer)
  from public, anon, authenticated;
grant execute on function app.seed_gold_set_verification_assignments(uuid, uuid[], integer)
  to service_role;

commit;
