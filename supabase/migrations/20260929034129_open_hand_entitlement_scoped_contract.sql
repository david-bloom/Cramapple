-- TASK-0051 / DECISION-0086 — amend the Open Hand answer-key contract.
--
-- Supersedes the access model in 20260928023843_open_hand_answer_key_contract.sql,
-- which implemented option D1(a): the caller had to own an ACTIVE LEARNING SESSION
-- containing the item, and there was deliberately no staff bypass. David chose
-- D1(c) on 2026-09-29: access is ENTITLEMENT-scoped, and staff/QA may view the key
-- WITHOUT an exclusion being written (excluding a reviewer from scoring is
-- meaningless).
--
-- Four changes, all of them required by that decision:
--
--  1. learning_session_id becomes NULLABLE. An entitlement-scoped caller may have
--     no learning session at all; leaving it NOT NULL would force every caller to
--     have one, which collapses D1(c) back into D1(a) in practice.
--  2. content_item_id is stored alongside the version, and evaluate-attempt checks
--     on ITEM id. Republishing an item mints a new content_item_version_id, so a
--     version-only exclusion would let a student who read v1's key be scored on v2
--     of the same question.
--  3. The entitlement predicate and the staff/QA exemption live HERE, in SQL, not
--     in the edge function. public.get_open_hand_item is granted to `authenticated`,
--     so a student can call it directly through PostgREST and bypass the function
--     entirely: the RPC, not the edge function, is the real security boundary. The
--     exemption is derived from app.profiles.role and is never caller-supplied.
--  4. canonical_answer_spans moves into the RPC payload. Spans are credited-response
--     text — answer-bearing — and were previously read directly by the edge
--     function, i.e. outside the atomic disclose-and-exclude path.
--
-- Parameters change, so the old function is DROPPED first: create or replace
-- cannot rename or drop parameters, and leaving the old signature in place would
-- create a second overload and make PostgREST calls ambiguous.
--
-- Written to be safe on a database that already has the D1(a) objects (Development)
-- and on one that has none of them (Production, as of 2026-09-29).
--
-- MIGRATION ORDERING — this file is self-sufficient, and that matters.
--
-- 20260928023843_open_hand_answer_key_contract.sql sorts BEFORE eight migrations
-- already applied to Production (20260928130000 … 20260928191213), so `db push`
-- would skip it there without --include-all. That is fine and requires no special
-- handling, because THIS file needs none of it: `create table if not exists` plus
-- `add column if not exists` plus a full `create function` build the whole contract
-- from nothing. Production needs only this migration. The earlier file is, in
-- effect, a Development-only historical artifact.
--
-- Its filename is 20260929034129 to match the version Development actually
-- recorded. The MCP apply_migration tool stamps its own version at call time
-- rather than using the filename, so the file was renamed after applying (the
-- same drift TASK-0039's BYOQ migrations hit). It sorts after every
-- Production-applied migration, so a plain `db push` picks it up.
--
-- Re-running is safe: every DDL statement is guarded (`if not exists`,
-- `drop function if exists` before `create function`), and the backfill is a
-- no-op once content_item_id is populated.

begin;

-- ---------------------------------------------------------------------------
-- 1. Table: create if absent (Production), amend if present (Development).
-- ---------------------------------------------------------------------------

create table if not exists app.open_hand_scoring_exclusions (
  user_id uuid not null references auth.users(id) on delete cascade,
  content_item_version_id uuid not null
    references app.content_item_versions(id) on delete cascade,
  learning_session_id uuid
    references app.learning_sessions(id) on delete restrict,
  disclosed_at timestamptz not null default now(),
  primary key (user_id, content_item_version_id)
);

alter table app.open_hand_scoring_exclusions
  alter column learning_session_id drop not null;

alter table app.open_hand_scoring_exclusions
  add column if not exists content_item_id uuid
    references app.content_items(id) on delete cascade;

-- Backfill any pre-existing rows (Development had 0 as of 2026-09-29, so this is
-- a no-op there; it is written to be correct rather than to rely on that).
update app.open_hand_scoring_exclusions ohse
set content_item_id = civ.content_item_id
from app.content_item_versions civ
where civ.id = ohse.content_item_version_id
  and ohse.content_item_id is null;

alter table app.open_hand_scoring_exclusions
  alter column content_item_id set not null;

-- The scoring check is by (user, item), so index it that way.
create index if not exists open_hand_scoring_exclusions_user_item_idx
  on app.open_hand_scoring_exclusions (user_id, content_item_id);

comment on table app.open_hand_scoring_exclusions is
  'Permanent per-user scoring exclusions, created atomically when '
  'get_open_hand_item discloses an answer key. Keyed on content_item_id as well '
  'as content_item_version_id: evaluate-attempt rejects on ITEM id, so '
  'republishing an item cannot restore scorability for a student who has seen '
  'its key. learning_session_id is nullable because access is entitlement-scoped '
  '(DECISION-0086) and a caller need not be in a session. Staff/QA callers are '
  'exempt and write no row. evaluate-attempt rejects matches with HTTP 409 and '
  'error=open_hand_item_not_scorable before reading any answer-key table.';

alter table app.open_hand_scoring_exclusions enable row level security;
alter table app.open_hand_scoring_exclusions force row level security;

revoke all on app.open_hand_scoring_exclusions
  from public, anon, authenticated;
grant select on app.open_hand_scoring_exclusions to service_role;

-- ---------------------------------------------------------------------------
-- 2. Drop the D1(a) function. Its parameter list changes, so replace is not an
--    option and an overload would make PostgREST ambiguous.
-- ---------------------------------------------------------------------------

drop function if exists public.get_open_hand_item(uuid, uuid);

-- ---------------------------------------------------------------------------
-- 3. The entitlement-scoped function.
--
--    p_learning_session_id is optional and recorded only for provenance; it is
--    NOT an access gate any more. Passing a session the caller does not own is
--    rejected rather than silently ignored, so it cannot become a quiet way to
--    write a misleading provenance row.
-- ---------------------------------------------------------------------------

create function public.get_open_hand_item(
  p_content_item_version_id uuid,
  p_learning_session_id uuid default null
)
returns jsonb
language plpgsql
volatile
security definer
set search_path = pg_catalog
as $$
declare
  v_user_id uuid := auth.uid();
  v_role text;
  v_is_staff boolean;
  v_content_item_id uuid;
  v_item_type text;
  v_subject_id uuid;
  v_canonical_answer_1 text;
  v_canonical_answer_2 text;
  v_entitled boolean;
  v_result jsonb;
begin
  if v_user_id is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;

  if p_content_item_version_id is null then
    raise exception 'open_hand:missing_identity' using errcode = '22023';
  end if;

  -- Role is read from app.profiles, never accepted from the caller. Mirrors
  -- STAFF_QA_ROLES in _shared/student-item-delivery.ts. 'support' is
  -- deliberately excluded: it is not a content-facing role.
  select p.role into v_role
  from app.profiles p
  where p.user_id = v_user_id;

  v_is_staff := coalesce(v_role, '') = any (array[
    'admin', 'content_author', 'tutor', 'reader', 'validator'
  ]);

  -- The item must be published, in a published and not-soft-retired pack, whose
  -- subject is itself active. status alone is insufficient: a version can be
  -- published while carrying a non-null retired_at.
  select civ.content_item_id,
         ci.item_type,
         s.id,
         civ.canonical_answer_1,
         civ.canonical_answer_2
  into v_content_item_id, v_item_type, v_subject_id,
       v_canonical_answer_1, v_canonical_answer_2
  from app.content_item_versions civ
  join app.content_items ci on ci.id = civ.content_item_id
  join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  join app.subjects s on s.id = ep.subject_id
  where civ.id = p_content_item_version_id
    and civ.status = 'published'
    and ci.status = 'published'
    and epv.status = 'published'
    and epv.retired_at is null
    and s.status = 'active';

  if v_item_type is null then
    raise exception 'open_hand:item_not_accessible' using errcode = '42501';
  end if;

  -- Entitlement gate. Staff/QA bypass it; everyone else needs an active
  -- entitlement for this subject (or an all-subjects grant) inside its window.
  if not v_is_staff then
    select exists (
      select 1
      from app.subject_entitlements se
      where se.user_id = v_user_id
        and se.status = 'active'
        and (se.all_subjects is true or se.subject_id = v_subject_id)
        and (se.starts_at is null or se.starts_at <= now())
        and (se.ends_at is null or se.ends_at > now())
    ) into v_entitled;

    if not v_entitled then
      raise exception 'open_hand:entitlement_required' using errcode = '42501';
    end if;
  end if;

  -- Provenance only. A session that is not the caller's own is an error, not
  -- something to record or quietly drop.
  if p_learning_session_id is not null then
    if not exists (
      select 1 from app.learning_sessions ls
      where ls.id = p_learning_session_id
        and ls.user_id = v_user_id
    ) then
      raise exception 'open_hand:session_not_accessible' using errcode = '42501';
    end if;
  end if;

  -- Disclose and exclude in one statement. Staff/QA write nothing: excluding a
  -- reviewer from scoring is meaningless (DECISION-0086 D1(c)).
  if not v_is_staff then
    insert into app.open_hand_scoring_exclusions (
      user_id,
      content_item_version_id,
      content_item_id,
      learning_session_id
    ) values (
      v_user_id,
      p_content_item_version_id,
      v_content_item_id,
      p_learning_session_id
    )
    on conflict (user_id, content_item_version_id) do nothing;
  end if;

  select jsonb_build_object(
    'content_item_version_id', p_content_item_version_id,
    'content_item_id', v_content_item_id,
    'item_type', v_item_type,
    'scoring_eligible', false,
    'exclusion_recorded', not v_is_staff,
    'canonical_answers', jsonb_strip_nulls(jsonb_build_object(
      'answer_1', v_canonical_answer_1,
      'answer_2', v_canonical_answer_2
    )),
    'mcq_choices', coalesce((
      select jsonb_agg(
        jsonb_build_object(
          'choice_key', mc.choice_key,
          'choice_text', mc.choice_text,
          'is_correct', mc.is_correct,
          'rationale', mc.rationale,
          -- O9: no new authoring requirement. The authored rationale doubles as
          -- the Open Hand per-choice correction line.
          'minimum_fix', mc.rationale
        ) order by mc.choice_key
      )
      from app.mcq_choices mc
      where mc.content_item_version_id = p_content_item_version_id
    ), '[]'::jsonb),
    'frq_criteria', coalesce((
      select jsonb_agg(
        jsonb_build_object(
          'criterion_key', fc.criterion_key,
          'learner_facing_text', fc.learner_facing_text,
          'points_possible', fc.points_possible,
          'evidence_requirements', fc.evidence_requirements,
          'accepted_variants', fc.accepted_variants,
          'minimum_fix', fc.minimum_fix
        ) order by fc.criterion_key
      )
      from app.frq_criteria fc
      where fc.content_item_version_id = p_content_item_version_id
    ), '[]'::jsonb),
    -- Credited-response spans are answer-bearing and therefore belong inside the
    -- atomic disclose-and-exclude path, not in a separate direct read.
    'credited_response_spans', coalesce((
      select jsonb_agg(
        jsonb_build_object(
          'answer_field', cas.answer_field,
          'span_ordinal', cas.span_ordinal,
          'span_text', cas.span_text,
          'criterion_keys', cas.criterion_keys
        ) order by cas.answer_field, cas.span_ordinal
      )
      from app.canonical_answer_spans cas
      where cas.content_item_version_id = p_content_item_version_id
    ), '[]'::jsonb)
  )
  into v_result;

  return v_result;
end;
$$;

revoke all on function public.get_open_hand_item(uuid, uuid)
  from public, anon;
grant execute on function public.get_open_hand_item(uuid, uuid)
  to authenticated, service_role;

comment on function public.get_open_hand_item(uuid, uuid) is
  'DECISION-0086 / TASK-0051. Returns the full MCQ/FRQ answer key (choices with '
  'is_correct and rationale, FRQ criteria, canonical answers, credited-response '
  'spans) for a published item on a published, non-retired pack of an active '
  'subject, to a caller holding an active entitlement for that subject. In the '
  'same transaction it idempotently records a permanent (user, item) scoring '
  'exclusion, so evaluate-attempt then rejects that item with HTTP 409 '
  'open_hand_item_not_scorable. Staff/QA roles (admin, content_author, tutor, '
  'reader, validator) may read the key and write NO exclusion. This function is '
  'the security boundary: it is granted to authenticated and is callable directly '
  'through PostgREST, so the entitlement and staff checks live here and are read '
  'from app.profiles, never supplied by the caller. p_learning_session_id is '
  'optional provenance, validated as owned when present, and is not an access gate.';

commit;
