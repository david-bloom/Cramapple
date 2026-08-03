-- Exported from Production migration history (supabase_migrations.schema_migrations)
-- version: 20260728005749
-- recorded name: correct_approve_with_edits_state
-- statements: 1
-- This file is a faithful transcript of what Production actually ran.
-- Do not edit to "improve" it; corrections belong in a new forward migration.

-- Fix approve_with_edits being treated as immediately approved.
--
-- tutor_score: 1=approve, 2=approve_with_edits, 3=disapprove.
-- Score 2 now means changes_requested. A corrected question becomes approved
-- through a later immutable score-1 decision; the score-2 audit row remains.

begin;

select pg_advisory_xact_lock(
  hashtext('cramapple-correct-approve-with-edits-state-20260728')
);

-- Add the missing lifecycle state.
alter table app.content_items
  drop constraint if exists content_items_status_check;
alter table app.content_items
  add constraint content_items_status_check
  check (status = any (array[
    'draft', 'assigned', 'changes_requested', 'reviewed_approved',
    'reviewed_disapproved', 'published', 'retired'
  ]));

alter table app.content_item_versions
  drop constraint if exists content_item_versions_status_check;
alter table app.content_item_versions
  add constraint content_item_versions_status_check
  check (status = any (array[
    'draft', 'assigned', 'changes_requested', 'reviewed_approved',
    'reviewed_disapproved', 'published', 'retired'
  ]));

-- Resolve blind tutor pairs as a pair. A single non-blind administrative
-- remediation decision uses the direct 1/2/3 mapping. Only a decision on the
-- latest version may change the parent item state.
create or replace function app.tg_content_pipeline_on_decision()
returns trigger
language plpgsql
security definer
set search_path = app, pg_temp
as $$
declare
  v_item_id uuid;
  v_outcome text;
  v_review_status text;
  v_blind_group_id uuid;
  v_assignment_count integer;
  v_submitted_count integer;
  v_group_score integer;
  v_is_latest boolean;
begin
  if new.content_item_version_id is null then
    return new;
  end if;

  if new.review_stage = 'tutor_question' then
    select blind_group_id
      into v_blind_group_id
      from app.content_review_assignments
     where content_review_assignment_id = new.content_review_assignment_id;

    if v_blind_group_id is null then
      if new.tutor_score = 1 then
        v_outcome := 'reviewed_approved';
        v_review_status := 'question_review_approved';
      elsif new.tutor_score = 2 then
        v_outcome := 'changes_requested';
        v_review_status := 'modification_reserved';
      elsif new.tutor_score = 3 then
        v_outcome := 'reviewed_disapproved';
        v_review_status := 'excluded';
      else
        return new;
      end if;
    else
      select count(*), count(*) filter (where status = 'submitted')
        into v_assignment_count, v_submitted_count
        from app.content_review_assignments
       where blind_group_id = v_blind_group_id
         and review_stage = 'tutor_question';

      if v_assignment_count <> 2 or v_submitted_count <> 2 then
        return new;
      end if;

      select sum(d.tutor_score)
        into v_group_score
        from app.content_review_assignments a
        join app.content_review_decisions d
          on d.content_review_assignment_id =
             a.content_review_assignment_id
       where a.blind_group_id = v_blind_group_id
         and a.review_stage = 'tutor_question'
         and not exists (
           select 1
             from app.content_review_decisions newer
            where newer.supersedes_id = d.content_review_decision_id
         );

      if v_group_score = 2 then
        v_outcome := 'reviewed_approved';
        v_review_status := 'ap_reader_pending';
      elsif v_group_score = 3 then
        v_outcome := 'changes_requested';
        v_review_status := 'modification_reserved';
      elsif v_group_score between 4 and 6 then
        v_outcome := 'reviewed_disapproved';
        v_review_status := 'excluded';
      else
        return new;
      end if;
    end if;
  elsif new.review_stage = 'reader_question' then
    if new.reader_decision = 'agree' or new.tutor_score = 1 then
      v_outcome := 'reviewed_approved';
      v_review_status := 'question_review_approved';
    elsif new.tutor_score = 2 then
      v_outcome := 'changes_requested';
      v_review_status := 'modification_reserved';
    elsif new.reader_decision = 'disagree' or new.tutor_score = 3 then
      v_outcome := 'reviewed_disapproved';
      v_review_status := 'excluded';
    else
      return new;
    end if;
  else
    return new;
  end if;

  update app.content_item_versions
     set status = case
           when status in (
             'draft', 'assigned', 'changes_requested',
             'reviewed_approved', 'reviewed_disapproved'
           ) then v_outcome
           else status
         end,
         review_status = v_review_status
   where id = new.content_item_version_id;

  select civ.content_item_id,
         not exists (
           select 1
             from app.content_item_versions newer
            where newer.content_item_id = civ.content_item_id
              and (
                newer.version_num > civ.version_num
                or (
                  newer.version_num = civ.version_num
                  and newer.created_at > civ.created_at
                )
              )
         )
    into v_item_id, v_is_latest
    from app.content_item_versions civ
   where civ.id = new.content_item_version_id;

  if v_item_id is not null and v_is_latest then
    update app.content_items
       set status = case
             when status in (
               'draft', 'assigned', 'changes_requested',
               'reviewed_approved', 'reviewed_disapproved'
             ) then v_outcome
             else status
           end
     where id = v_item_id;
  end if;

  return new;
end;
$$;

drop trigger if exists content_pipeline_on_decision
  on app.content_review_decisions;
create trigger content_pipeline_on_decision
after insert on app.content_review_decisions
for each row execute function app.tg_content_pipeline_on_decision();

revoke execute on function app.tg_content_pipeline_on_decision()
  from public, anon, authenticated;

comment on function app.tg_content_pipeline_on_decision() is
  'Maps approve_with_edits to changes_requested, resolves blind tutor pairs as a pair, and changes parent state only for the latest version.';

-- Keep owner-confirmed remediation approval distinct from ordinary subject
-- review. Normal assignments still require an active exam qualification.
alter table app.content_review_assignments
  add column if not exists assignment_purpose text
    not null default 'subject_review';

alter table app.content_review_assignments
  drop constraint if exists content_review_assignments_purpose_check;
alter table app.content_review_assignments
  add constraint content_review_assignments_purpose_check
  check (assignment_purpose in (
    'subject_review',
    'owner_remediation_approval'
  ));

create or replace function app.tg_enforce_content_review_qualification()
returns trigger
language plpgsql
set search_path = app, pg_temp
as $$
declare
  target_exam_id uuid;
begin
  if new.content_item_version_id is null then
    return new;
  end if;

  if new.assignment_purpose = 'owner_remediation_approval' then
    if new.reviewer_id is distinct from new.created_by
       or new.blind_group_id is not null
       or new.review_stage <> 'tutor_question'
       or not exists (
         select 1
           from app.profiles p
          where p.user_id = new.reviewer_id
            and p.role = 'admin'
       )
    then
      raise exception using
        errcode = '23514',
        constraint =
          'content_review_assignments_owner_remediation_approval_check',
        message =
          'owner remediation approval requires a non-blind admin self-assignment';
    end if;
    return new;
  end if;

  select epv.exam_pack_id
    into target_exam_id
    from app.content_item_versions civ
    join app.content_items ci
      on ci.id = civ.content_item_id
    join app.exam_pack_versions epv
      on epv.id = ci.exam_pack_version_id
   where civ.id = new.content_item_version_id;

  if target_exam_id is null then
    raise exception using
      errcode = '23514',
      constraint = 'content_review_assignments_reviewer_qualification_check',
      message = format(
        'content review assignment %s has no resolvable exam scope',
        new.content_review_assignment_id
      );
  end if;

  if not exists (
    select 1
      from app.validator_qualifications vq
     where vq.reviewer_id = new.reviewer_id
       and vq.status = 'active'
       and target_exam_id = any(vq.exam_ids)
       and vq.effective_at <= now()
       and vq.expires_at > now()
  ) then
    raise exception using
      errcode = '23514',
      constraint = 'content_review_assignments_reviewer_qualification_check',
      message = format(
        'reviewer %s lacks an active qualification for exam %s',
        new.reviewer_id,
        target_exam_id
      );
  end if;

  return new;
end;
$$;

comment on function app.tg_enforce_content_review_qualification() is
  'Requires exam qualification for subject review; permits only explicit, non-blind admin self-assignments for owner-confirmed remediation approval.';

-- Freeze the owner-confirmed repair set. Twenty-seven questions have a later
-- immutable QA-remediated version after approve_with_edits. apphy1-frq-025 is
-- included because its current six criterion rows visibly contain the exact
-- numeric results and criterion split requested by the tutor.
create temporary table corrected_question_keys (
  content_key text primary key
) on commit drop;

insert into corrected_question_keys values
  ('APBIO-FRQ-L-001'),
  ('APBIO-FRQ-L-003'),
  ('APBIO-FRQ-L-005'),
  ('APBIO-FRQ-L-007'),
  ('APBIO-FRQ-L-009'),
  ('APBIO-FRQ-L-025'),
  ('APBIO-FRQ-L-031'),
  ('APBIO-FRQ-L-038'),
  ('APBIO-FRQ-L-041'),
  ('APBIO-HDG-2026-GRAPH-004'),
  ('APBIO-HDG-2026-GRAPH-008'),
  ('APBIO-HDG-2026-GRAPH-011'),
  ('APBIO-HDG-2026-GRAPH-012'),
  ('apchem-frq-l-003'),
  ('apchem-frq-l-005'),
  ('apphy1-frq-025'),
  ('apprecalc-frq-001'),
  ('apprecalc-frq-005'),
  ('apprecalc-frq-007'),
  ('apprecalc-frq-008'),
  ('apprecalc-frq-009'),
  ('apprecalc-frq-010'),
  ('apprecalc-frq-013'),
  ('apprecalc-frq-014'),
  ('apprecalc-frq-016'),
  ('apprecalc-mcq-010'),
  ('APSTAT-MOD4-M004'),
  ('APSTATS-SFRQ-008');

create temporary table corrected_question_context
on commit drop
as
with latest_versions as (
  select distinct on (ci.id)
    ci.id as content_item_id,
    ci.content_key,
    ci.item_type,
    civ.id as content_item_version_id,
    civ.version_num,
    civ.prompt_json,
    civ.created_by as approval_actor_id
  from corrected_question_keys k
  join app.content_items ci
    on lower(ci.content_key) = lower(k.content_key)
  join app.content_item_versions civ
    on civ.content_item_id = ci.id
  order by ci.id, civ.version_num desc, civ.created_at desc
),
source_edits as (
  select distinct on (lv.content_item_id)
    lv.content_item_id,
    d.content_review_decision_id as source_decision_id,
    d.difficulty_label,
    d.topic_selections,
    source_version.version_num as source_version_num
  from latest_versions lv
  join app.content_item_versions source_version
    on source_version.content_item_id = lv.content_item_id
  join app.content_review_decisions d
    on d.content_item_version_id = source_version.id
  where d.review_stage = 'tutor_question'
    and d.tutor_decision = 'approve_with_edits'
    and not exists (
      select 1
        from app.content_review_decisions newer
       where newer.supersedes_id = d.content_review_decision_id
    )
  order by lv.content_item_id, source_version.version_num desc,
           d.submitted_at desc
)
select
  lv.*,
  se.source_decision_id,
  se.difficulty_label,
  se.topic_selections,
  se.source_version_num,
  gen_random_uuid() as approval_assignment_id
from latest_versions lv
join source_edits se using (content_item_id);

do $$
declare
  v_count integer;
begin
  select count(*) into v_count from corrected_question_context;
  if v_count <> 28 then
    raise exception
      'repair aborted: expected 28 correction-backed questions, found %',
      v_count;
  end if;

  if exists (
    select 1
      from corrected_question_context c
      left join app.profiles p on p.user_id = c.approval_actor_id
     where p.role is distinct from 'admin'
  ) then
    raise exception 'repair aborted: correction actor is not an admin';
  end if;

  if exists (
    select 1
      from corrected_question_context c
     where lower(c.content_key) <> 'apphy1-frq-025'
       and (
         c.version_num <= c.source_version_num
         or not (c.prompt_json ? 'qa_remediation')
       )
  ) then
    raise exception 'repair aborted: missing later QA-remediation evidence';
  end if;

  if exists (
    select 1
      from corrected_question_context c
      join app.content_review_decisions d
        on d.content_item_version_id = c.content_item_version_id
     where d.review_stage = 'tutor_question'
       and d.tutor_decision = 'approve'
       and not exists (
         select 1
           from app.content_review_decisions newer
          where newer.supersedes_id = d.content_review_decision_id
       )
  ) then
    raise exception 'repair aborted: target already has current approval';
  end if;
end
$$;

-- Create one admin remediation assignment per corrected latest version. The
-- insert trigger atomically marks each assignment submitted when its immutable
-- approval decision is inserted.
insert into app.content_review_assignments (
  content_review_assignment_id, content_item_version_id, reviewer_id,
  review_stage, review_kind, blind_group_id, status, assignment_purpose,
  created_by
)
select
  approval_assignment_id, content_item_version_id, approval_actor_id,
  'tutor_question', item_type, null, 'pending',
  'owner_remediation_approval', approval_actor_id
from corrected_question_context;

insert into app.content_review_decisions (
  content_review_assignment_id, content_item_version_id, reviewer_id,
  supersedes_id, review_stage, tutor_score, difficulty_label,
  diagnostic_flag, concern_codes, note, topic_selections, answer_approvals,
  tutor_decision, decision_payload, decision_hash, created_by
)
select
  c.approval_assignment_id,
  c.content_item_version_id,
  c.approval_actor_id,
  c.source_decision_id,
  'tutor_question',
  1,
  coalesce(c.difficulty_label, 'Medium'),
  false,
  array[]::text[],
  'Product Owner confirmed that correction-backed approve_with_edits questions become approved. Historical edit request preserved via supersedes_id.',
  c.topic_selections,
  case when c.item_type = 'mcq' then (
    select jsonb_agg(
      jsonb_build_object('choice_key', choice_key, 'approved', true)
      order by choice_key
    )
    from app.mcq_choices
    where content_item_version_id = c.content_item_version_id
  ) else null end,
  'approve',
  jsonb_build_object(
    'review_stage', 'tutor_question',
    'tutor_score', 1,
    'tutor_decision', 'approve',
    'approval_basis', 'owner_confirmed_defect_correction',
    'source_approve_with_edits_decision_id', c.source_decision_id,
    'corrected_content_item_version_id', c.content_item_version_id,
    'qa_remediation', c.prompt_json->>'qa_remediation',
    'approved_on', '2026-07-27'
  ),
  encode(
    extensions.digest(
      jsonb_build_object(
        'review_stage', 'tutor_question',
        'tutor_score', 1,
        'tutor_decision', 'approve',
        'approval_basis', 'owner_confirmed_defect_correction',
        'source_approve_with_edits_decision_id', c.source_decision_id,
        'corrected_content_item_version_id', c.content_item_version_id,
        'qa_remediation', c.prompt_json->>'qa_remediation',
        'approved_on', '2026-07-27'
      )::text,
      'sha256'
    ),
    'hex'
  ),
  c.approval_actor_id
from corrected_question_context c;

-- Correct falsely-approved unresolved latest versions. Published questions are
-- not silently removed because older in-place repairs were not reliably
-- tracked; they are still flagged modification_reserved for follow-up.
with latest_versions as (
  select distinct on (content_item_id)
    content_item_id, id as content_item_version_id
  from app.content_item_versions
  order by content_item_id, version_num desc, created_at desc
),
active_labels as (
  select
    d.content_item_version_id,
    bool_or(d.tutor_decision = 'approve') as has_approve,
    bool_or(d.tutor_decision = 'approve_with_edits') as has_edits
  from app.content_review_decisions d
  where d.review_stage = 'tutor_question'
    and not exists (
      select 1
        from app.content_review_decisions newer
       where newer.supersedes_id = d.content_review_decision_id
    )
  group by d.content_item_version_id
),
unresolved as (
  select lv.content_item_id, lv.content_item_version_id
  from latest_versions lv
  join active_labels al using (content_item_version_id)
  where al.has_edits and not al.has_approve
)
update app.content_item_versions civ
   set status = case
         when civ.status = 'reviewed_approved' then 'changes_requested'
         else civ.status
       end,
       review_status = 'modification_reserved'
  from unresolved u
 where civ.id = u.content_item_version_id;

with latest_versions as (
  select distinct on (content_item_id)
    content_item_id, id as content_item_version_id, status
  from app.content_item_versions
  order by content_item_id, version_num desc, created_at desc
),
active_labels as (
  select
    d.content_item_version_id,
    bool_or(d.tutor_decision = 'approve') as has_approve,
    bool_or(d.tutor_decision = 'approve_with_edits') as has_edits
  from app.content_review_decisions d
  where d.review_stage = 'tutor_question'
    and not exists (
      select 1
        from app.content_review_decisions newer
       where newer.supersedes_id = d.content_review_decision_id
    )
  group by d.content_item_version_id
),
unresolved as (
  select lv.content_item_id, lv.status
  from latest_versions lv
  join active_labels al using (content_item_version_id)
  where al.has_edits and not al.has_approve
)
update app.content_items ci
   set status = u.status
  from unresolved u
 where ci.id = u.content_item_id
   and ci.status in (
     'draft', 'assigned', 'changes_requested',
     'reviewed_approved', 'reviewed_disapproved'
   )
   and ci.status is distinct from u.status;

do $$
declare
  v_approved integer;
  v_submitted integer;
begin
  select count(*) into v_approved
  from corrected_question_context c
  join app.content_review_decisions d
    on d.content_item_version_id = c.content_item_version_id
  where d.tutor_decision = 'approve'
    and d.decision_payload->>'approval_basis' =
        'owner_confirmed_defect_correction';

  if v_approved <> 28 then
    raise exception
      'repair verification failed: expected 28 approvals, found %', v_approved;
  end if;

  select count(*) into v_submitted
  from corrected_question_context c
  join app.content_review_assignments a
    on a.content_review_assignment_id = c.approval_assignment_id
  where a.status = 'submitted';

  if v_submitted <> 28 then
    raise exception
      'repair verification failed: expected 28 submitted assignments, found %',
      v_submitted;
  end if;
end
$$;

commit;
;
