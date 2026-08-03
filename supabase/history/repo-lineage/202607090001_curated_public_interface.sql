-- Curated public interface for the consolidated backend.
--
-- This migration adds the small app.config KV table and a read-only public
-- interface over the authoritative app schema. The goal is to let the
-- frontend consume a compact, curated contract without exposing the private
-- ops tables directly.

begin;

create extension if not exists pgcrypto;

-- ---------------------------------------------------------------------------
-- app.config
-- ---------------------------------------------------------------------------

create table if not exists app.config (
  config_key text primary key,
  config_value jsonb not null default '{}'::jsonb,
  is_public boolean not null default false,
  description text,
  created_by uuid references app.profiles(user_id),
  updated_by uuid references app.profiles(user_id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create trigger config_set_updated_at
before update on app.config
for each row execute function app.set_updated_at();

alter table app.config enable row level security;

create policy "config_service_all"
on app.config
for all
to service_role
using (true)
with check (true);

create policy "config_select_public"
on app.config
for select
to authenticated
using (is_public);

grant select, insert, update, delete on app.config to service_role;
grant select on app.config to authenticated;

-- ---------------------------------------------------------------------------
-- Curated public views
-- ---------------------------------------------------------------------------

create or replace view public.profiles
with (security_invoker = true)
as
select
  p.user_id,
  p.full_name,
  p.role,
  p.review_queue_scope,
  p.timezone,
  p.locale,
  p.onboarding_completed_at,
  p.created_at,
  p.updated_at
from app.profiles p;

grant select on public.profiles to authenticated;

create or replace view public.subjects
with (security_invoker = true)
as
select
  s.id,
  s.subject_key,
  s.display_name,
  s.status,
  s.created_at,
  s.updated_at
from app.subjects s;

grant select on public.subjects to authenticated;

create or replace view public.exam_packs
with (security_invoker = true)
as
select
  ep.id,
  ep.exam_code,
  ep.exam_name,
  ep.subject_id,
  s.subject_key,
  s.display_name as subject_name,
  ep.created_at,
  ep.updated_at
from app.exam_packs ep
join app.subjects s
  on s.id = ep.subject_id;

grant select on public.exam_packs to authenticated;

create or replace view public.exam_pack_versions
with (security_invoker = true)
as
select
  epv.id,
  epv.exam_pack_id,
  ep.exam_code,
  ep.exam_name,
  ep.subject_id,
  s.subject_key,
  s.display_name as subject_name,
  epv.school_year,
  epv.official_exam_date,
  epv.status,
  epv.source_uri,
  epv.source_published_at,
  epv.released_at,
  epv.retired_at,
  epv.created_by,
  epv.created_at,
  epv.updated_at
from app.exam_pack_versions epv
join app.exam_packs ep
  on ep.id = epv.exam_pack_id
join app.subjects s
  on s.id = ep.subject_id;

grant select on public.exam_pack_versions to authenticated;

create or replace view public.content_labels
with (security_invoker = true)
as
select
  cl.id,
  cl.exam_pack_id,
  ep.exam_code,
  ep.exam_name,
  ep.subject_id,
  s.subject_key,
  s.display_name as subject_name,
  cl.label_key,
  cl.label_name,
  cl.label_type,
  cl.status,
  cl.created_by,
  cl.created_at,
  cl.updated_at
from app.content_labels cl
join app.exam_packs ep
  on ep.id = cl.exam_pack_id
join app.subjects s
  on s.id = ep.subject_id;

grant select on public.content_labels to authenticated;

create or replace view public.content_items
with (security_invoker = true)
as
select
  ci.id,
  ci.exam_pack_version_id,
  epv.exam_pack_id,
  ep.exam_code,
  ep.exam_name,
  ep.subject_id,
  s.subject_key,
  s.display_name as subject_name,
  ci.content_key,
  ci.item_type,
  ci.frq_form,
  ci.title,
  ci.status,
  ci.created_by,
  ci.created_at,
  ci.updated_at
from app.content_items ci
join app.exam_pack_versions epv
  on epv.id = ci.exam_pack_version_id
join app.exam_packs ep
  on ep.id = epv.exam_pack_id
join app.subjects s
  on s.id = ep.subject_id;

grant select on public.content_items to authenticated;

create or replace view public.content_item_versions
with (security_invoker = true)
as
select
  civ.id,
  civ.content_item_id,
  ci.exam_pack_version_id,
  epv.exam_pack_id,
  ep.exam_code,
  ep.exam_name,
  ep.subject_id,
  s.subject_key,
  s.display_name as subject_name,
  ci.content_key,
  ci.item_type,
  ci.frq_form,
  ci.title,
  civ.version_num,
  civ.stem,
  civ.stimulus,
  civ.prompt_json,
  civ.explanation,
  civ.help_text,
  civ.content_hash,
  civ.canonical_answer_1,
  civ.canonical_answer_2,
  civ.review_status,
  civ.status,
  civ.approved_at,
  civ.approved_by,
  civ.published_at,
  civ.created_by,
  civ.created_at,
  civ.updated_at
from app.content_item_versions civ
join app.content_items ci
  on ci.id = civ.content_item_id
join app.exam_pack_versions epv
  on epv.id = ci.exam_pack_version_id
join app.exam_packs ep
  on ep.id = epv.exam_pack_id
join app.subjects s
  on s.id = ep.subject_id;

grant select on public.content_item_versions to authenticated;

create or replace view public.mcq_choices
with (security_invoker = true)
as
select
  mc.id,
  mc.content_item_version_id,
  civ.content_item_id,
  ci.exam_pack_version_id,
  epv.exam_pack_id,
  ep.exam_code,
  ep.exam_name,
  ep.subject_id,
  s.subject_key,
  s.display_name as subject_name,
  ci.content_key,
  ci.item_type,
  ci.title,
  mc.choice_key,
  mc.choice_text,
  mc.is_correct,
  mc.rationale,
  mc.created_at
from app.mcq_choices mc
join app.content_item_versions civ
  on civ.id = mc.content_item_version_id
join app.content_items ci
  on ci.id = civ.content_item_id
join app.exam_pack_versions epv
  on epv.id = ci.exam_pack_version_id
join app.exam_packs ep
  on ep.id = epv.exam_pack_id
join app.subjects s
  on s.id = ep.subject_id;

grant select on public.mcq_choices to authenticated;

create or replace view public.frq_criteria
with (security_invoker = true)
as
select
  fc.id,
  fc.content_item_version_id,
  civ.content_item_id,
  ci.exam_pack_version_id,
  epv.exam_pack_id,
  ep.exam_code,
  ep.exam_name,
  ep.subject_id,
  s.subject_key,
  s.display_name as subject_name,
  ci.content_key,
  ci.item_type,
  ci.title,
  fc.criterion_key,
  fc.learner_facing_text,
  fc.points_possible,
  fc.evidence_requirements,
  fc.minimum_fix,
  fc.accepted_variants,
  fc.created_at
from app.frq_criteria fc
join app.content_item_versions civ
  on civ.id = fc.content_item_version_id
join app.content_items ci
  on ci.id = civ.content_item_id
join app.exam_pack_versions epv
  on epv.id = ci.exam_pack_version_id
join app.exam_packs ep
  on ep.id = epv.exam_pack_id
join app.subjects s
  on s.id = ep.subject_id;

grant select on public.frq_criteria to authenticated;

create or replace view public.content_item_labels
with (security_invoker = true)
as
select
  cil.content_item_id,
  ci.content_key,
  ci.title,
  cil.content_label_id,
  cl.label_key,
  cl.label_name,
  cl.label_type
from app.content_item_labels cil
join app.content_items ci
  on ci.id = cil.content_item_id
join app.content_labels cl
  on cl.id = cil.content_label_id;

grant select on public.content_item_labels to authenticated;

create or replace view public.learning_sessions
with (security_invoker = true)
as
select
  ls.id,
  ls.user_id,
  ls.exam_pack_version_id,
  epv.exam_pack_id,
  ep.exam_code,
  ep.exam_name,
  ep.subject_id,
  s.subject_key,
  s.display_name as subject_name,
  ls.entry_path,
  ls.session_mode,
  ls.available_minutes,
  ls.status,
  ls.started_at,
  ls.ended_at,
  ls.created_at,
  ls.updated_at
from app.learning_sessions ls
join app.exam_pack_versions epv
  on epv.id = ls.exam_pack_version_id
join app.exam_packs ep
  on ep.id = epv.exam_pack_id
join app.subjects s
  on s.id = ep.subject_id;

grant select on public.learning_sessions to authenticated;

create or replace view public.attempts
with (security_invoker = true)
as
select
  a.id,
  a.user_id,
  a.learning_session_id,
  a.exam_pack_version_id,
  epv.exam_pack_id,
  ep.exam_code,
  ep.exam_name,
  ep.subject_id,
  s.subject_key,
  s.display_name as subject_name,
  a.content_item_version_id,
  a.artifact_version_id,
  a.attempt_mode,
  a.status,
  a.assistance_state,
  a.started_at,
  a.submitted_at,
  a.graded_at,
  a.score_points,
  a.score_possible,
  a.confidence_level,
  a.result_state,
  a.result_summary,
  a.created_at,
  a.updated_at
from app.attempts a
join app.exam_pack_versions epv
  on epv.id = a.exam_pack_version_id
join app.exam_packs ep
  on ep.id = epv.exam_pack_id
join app.subjects s
  on s.id = ep.subject_id;

grant select on public.attempts to authenticated;

create or replace view public.response_versions
with (security_invoker = true)
as
select
  rv.id,
  rv.attempt_id,
  a.user_id,
  a.learning_session_id,
  a.exam_pack_version_id,
  epv.exam_pack_id,
  ep.exam_code,
  ep.exam_name,
  ep.subject_id,
  s.subject_key,
  s.display_name as subject_name,
  a.content_item_version_id,
  rv.parent_response_version_id,
  rv.response_text,
  rv.response_parts,
  rv.version_number,
  rv.is_submitted,
  rv.created_by,
  rv.created_at,
  rv.updated_at
from app.response_versions rv
join app.attempts a
  on a.id = rv.attempt_id
join app.exam_pack_versions epv
  on epv.id = a.exam_pack_version_id
join app.exam_packs ep
  on ep.id = epv.exam_pack_id
join app.subjects s
  on s.id = ep.subject_id;

grant select on public.response_versions to authenticated;

create or replace view public.attempt_criterion_results
with (security_invoker = true)
as
select
  acr.id,
  acr.attempt_id,
  a.user_id,
  a.learning_session_id,
  a.exam_pack_version_id,
  epv.exam_pack_id,
  ep.exam_code,
  ep.exam_name,
  ep.subject_id,
  s.subject_key,
  s.display_name as subject_name,
  a.content_item_version_id,
  acr.criterion_key,
  acr.status,
  acr.points_awarded,
  acr.evidence_quote,
  acr.decision_explanation,
  acr.minimum_fix,
  acr.evaluator_version,
  acr.created_at
from app.attempt_criterion_results acr
join app.attempts a
  on a.id = acr.attempt_id
join app.exam_pack_versions epv
  on epv.id = a.exam_pack_version_id
join app.exam_packs ep
  on ep.id = epv.exam_pack_id
join app.subjects s
  on s.id = ep.subject_id;

grant select on public.attempt_criterion_results to authenticated;

create or replace view public.progress_snapshots
with (security_invoker = true)
as
select
  ps.id,
  ps.user_id,
  ps.exam_pack_version_id,
  epv.exam_pack_id,
  ep.exam_code,
  ep.exam_name,
  ep.subject_id,
  s.subject_key,
  s.display_name as subject_name,
  ps.snapshot_kind,
  ps.snapshot_json,
  ps.source_version,
  ps.generated_at
from app.progress_snapshots ps
join app.exam_pack_versions epv
  on epv.id = ps.exam_pack_version_id
join app.exam_packs ep
  on ep.id = epv.exam_pack_id
join app.subjects s
  on s.id = ep.subject_id;

grant select on public.progress_snapshots to authenticated;

create or replace view public.grading_results
with (security_invoker = true)
as
select
  gr.id,
  gr.request_id,
  gr.request_hash,
  gr.attempt_id,
  a.user_id,
  a.learning_session_id,
  a.exam_pack_version_id,
  epv.exam_pack_id,
  ep.exam_code,
  ep.exam_name,
  ep.subject_id,
  s.subject_key,
  s.display_name as subject_name,
  a.content_item_version_id,
  ci.content_key,
  ci.item_type,
  ci.frq_form,
  ci.title,
  gr.response_version_id,
  gr.operation,
  gr.status,
  gr.points_earned,
  gr.points_available,
  gr.criterion_results,
  gr.highest_value_gap,
  gr.predicted_label,
  gr.predicted_point_gain,
  gr.actual_point_gain,
  gr.prediction_outcome,
  gr.confidence,
  gr.uncertainty_reason,
  gr.created_at,
  gr.updated_at
from app.grading_results gr
join app.attempts a
  on a.id = gr.attempt_id
join app.content_item_versions civ
  on civ.id = a.content_item_version_id
join app.content_items ci
  on ci.id = civ.content_item_id
join app.exam_pack_versions epv
  on epv.id = a.exam_pack_version_id
join app.exam_packs ep
  on ep.id = epv.exam_pack_id
join app.subjects s
  on s.id = ep.subject_id;

grant select on public.grading_results to authenticated;

create or replace view public.content_review_assignments
with (security_invoker = true)
as
select
  cra.content_review_assignment_id,
  cra.content_item_version_id,
  civ.content_item_id,
  ci.exam_pack_version_id,
  epv.exam_pack_id,
  ep.exam_code,
  ep.exam_name,
  ep.subject_id,
  s.subject_key,
  s.display_name as subject_name,
  ci.content_key,
  ci.item_type,
  ci.frq_form,
  ci.title,
  cra.reviewer_id,
  cra.review_stage,
  cra.blind_group_id,
  cra.status,
  cra.assigned_at,
  cra.due_at,
  cra.created_at,
  cra.created_by
from app.content_review_assignments cra
join app.content_item_versions civ
  on civ.id = cra.content_item_version_id
join app.content_items ci
  on ci.id = civ.content_item_id
join app.exam_pack_versions epv
  on epv.id = ci.exam_pack_version_id
join app.exam_packs ep
  on ep.id = epv.exam_pack_id
join app.subjects s
  on s.id = ep.subject_id;

grant select on public.content_review_assignments to authenticated;

create or replace view public.content_review_decisions
with (security_invoker = true)
as
select
  crd.content_review_decision_id,
  crd.content_review_assignment_id,
  cra.content_item_version_id,
  civ.content_item_id,
  ci.exam_pack_version_id,
  epv.exam_pack_id,
  ep.exam_code,
  ep.exam_name,
  ep.subject_id,
  s.subject_key,
  s.display_name as subject_name,
  ci.content_key,
  ci.item_type,
  ci.frq_form,
  ci.title,
  crd.reviewer_id,
  crd.supersedes_id,
  crd.review_stage,
  crd.tutor_score,
  crd.difficulty_label,
  crd.diagnostic_flag,
  crd.concern_codes,
  crd.note,
  crd.topic_selections,
  crd.answer_key,
  crd.answer_approval,
  crd.canonical_decision,
  crd.reader_decision,
  crd.decision_payload,
  crd.decision_hash,
  crd.submitted_at,
  crd.created_at,
  crd.created_by
from app.content_review_decisions crd
join app.content_review_assignments cra
  on cra.content_review_assignment_id = crd.content_review_assignment_id
join app.content_item_versions civ
  on civ.id = cra.content_item_version_id
join app.content_items ci
  on ci.id = civ.content_item_id
join app.exam_pack_versions epv
  on epv.id = ci.exam_pack_version_id
join app.exam_packs ep
  on ep.id = epv.exam_pack_id
join app.subjects s
  on s.id = ep.subject_id;

grant select on public.content_review_decisions to authenticated;

create or replace view public.config
with (security_invoker = true)
as
select
  c.config_key,
  c.config_value,
  c.description,
  c.created_at,
  c.updated_at
from app.config c
where c.is_public;

grant select on public.config to authenticated;

-- ---------------------------------------------------------------------------
-- Dashboard summary views
-- ---------------------------------------------------------------------------

create or replace view public.dashboard_overview_v1
as
with visible_subjects as (
  select count(*) as active_subjects_count
  from app.subjects s
  where s.status = 'active'
),
visible_content as (
  select
    count(distinct ci.id) filter (where ci.status = 'published') as published_content_items_count,
    count(distinct civ.id) filter (where civ.status = 'published') as published_content_versions_count
  from app.content_items ci
  join app.content_item_versions civ
    on civ.content_item_id = ci.id
),
visible_sessions as (
  select count(*) as active_learning_sessions_count
  from app.learning_sessions ls
  where ls.status = 'active'
),
visible_reviews as (
  select count(*) as open_review_assignments_count
  from app.content_review_assignments cra
  where cra.status in ('pending', 'in_progress')
),
visible_grading as (
  select count(*) as active_grading_results_count
  from app.grading_results gr
  where gr.status in ('processing', 'failed', 'uncertain')
),
visible_attention as (
  select count(*) as overdue_review_assignments_count
  from app.content_review_assignments cra
  where cra.status in ('pending', 'in_progress')
    and cra.due_at is not null
    and cra.due_at < now()
)
select
  visible_subjects.active_subjects_count,
  visible_content.published_content_items_count,
  visible_content.published_content_versions_count,
  visible_sessions.active_learning_sessions_count,
  visible_reviews.open_review_assignments_count,
  visible_grading.active_grading_results_count,
  visible_attention.overdue_review_assignments_count,
  now() as generated_at
from visible_subjects
cross join visible_content
cross join visible_sessions
cross join visible_reviews
cross join visible_grading
cross join visible_attention
where exists (
  select 1
  from app.profiles p
  where p.user_id = auth.uid()
    and p.role in (
      'content_author',
      'tutor',
      'reader',
      'validator',
      'support',
      'admin'
    )
);

grant select on public.dashboard_overview_v1 to authenticated;

create or replace view public.dashboard_subjects_v1
as
select
  s.id as subject_id,
  s.subject_key,
  s.display_name as subject_name,
  count(distinct ep.id) as exam_packs_count,
  count(distinct ci.id) filter (where ci.status = 'published') as published_content_items_count,
  count(distinct civ.id) filter (where civ.status = 'published') as published_content_versions_count,
  count(distinct ls.id) filter (where ls.status = 'active') as active_learning_sessions_count,
  count(distinct a.id) filter (where a.status in ('draft', 'submitted', 'grading', 'graded', 'uncertain', 'failed')) as attempts_count,
  count(distinct cra.content_review_assignment_id) filter (where cra.status in ('pending', 'in_progress')) as open_review_assignments_count,
  count(distinct gr.id) filter (where gr.status in ('processing', 'failed', 'uncertain')) as grading_results_count,
  greatest(
    coalesce(max(s.updated_at), s.created_at),
    coalesce(max(ep.updated_at), s.created_at),
    coalesce(max(ci.updated_at), s.created_at),
    coalesce(max(civ.updated_at), s.created_at),
    coalesce(max(ls.updated_at), s.created_at),
    coalesce(max(a.updated_at), s.created_at),
    coalesce(max(cra.created_at), s.created_at),
    coalesce(max(gr.updated_at), s.created_at)
  ) as latest_update_at
from app.subjects s
left join app.exam_packs ep
  on ep.subject_id = s.id
left join app.exam_pack_versions epv
  on epv.exam_pack_id = ep.id
left join app.content_items ci
  on ci.exam_pack_version_id = epv.id
left join app.content_item_versions civ
  on civ.content_item_id = ci.id
left join app.learning_sessions ls
  on ls.exam_pack_version_id = epv.id
left join app.attempts a
  on a.exam_pack_version_id = epv.id
left join app.content_review_assignments cra
  on cra.content_item_version_id = civ.id
left join app.grading_results gr
  on gr.attempt_id = a.id
where s.status = 'active'
  and exists (
    select 1
    from app.profiles p
    where p.user_id = auth.uid()
      and p.role in (
        'content_author',
        'tutor',
        'reader',
        'validator',
        'support',
        'admin'
      )
  )
group by s.id, s.subject_key, s.display_name;

grant select on public.dashboard_subjects_v1 to authenticated;

create or replace view public.dashboard_pipeline_v1
as
select
  ci.item_type,
  ci.frq_form,
  count(*) as total_versions_count,
  count(*) filter (where civ.status = 'draft') as draft_versions_count,
  count(*) filter (where civ.status = 'published') as published_versions_count,
  count(*) filter (where civ.status = 'retired') as retired_versions_count,
  count(*) filter (
    where civ.review_status in (
      'tutor_review_pending',
      'tutor_review_partial',
      'ap_reader_pending',
      'difficulty_discussion',
      'answer_tutor_review_pending',
      'answer_ap_reader_pending'
    )
  ) as in_review_versions_count,
  count(*) filter (
    where civ.review_status in (
      'modification_reserved',
      'excluded',
      'answer_modification_reserved',
      'mcq_package_excluded'
    )
  ) as blocked_versions_count,
  count(*) filter (
    where civ.status = 'published'
      and civ.review_status in (
        'question_review_approved',
        'difficulty_confirmed',
        'answer_approved',
        'mcq_answer_review_complete'
      )
  ) as ready_to_ship_versions_count,
  max(civ.updated_at) as latest_update_at
from app.content_item_versions civ
join app.content_items ci
  on ci.id = civ.content_item_id
where exists (
  select 1
  from app.profiles p
  where p.user_id = auth.uid()
    and p.role in (
      'content_author',
      'tutor',
      'reader',
      'validator',
      'support',
      'admin'
    )
)
group by ci.item_type, ci.frq_form
order by ci.item_type, ci.frq_form;

grant select on public.dashboard_pipeline_v1 to authenticated;

create or replace view public.dashboard_engagement_v1
as
with windowed_sessions as (
  select
    ls.user_id,
    ls.started_at,
    ls.ended_at,
    ls.status
  from app.learning_sessions ls
  where ls.started_at >= now() - interval '30 days'
),
active_students as (
  select count(distinct user_id) as active_students_count
  from windowed_sessions
),
session_counts as (
  select
    count(*) as sessions_started_count,
    count(*) filter (where status = 'completed') as sessions_completed_count
  from windowed_sessions
),
attempt_counts as (
  select count(*) as attempts_count
  from app.attempts a
  where a.started_at >= now() - interval '30 days'
),
returning_students as (
  select count(*) as returning_students_count
  from (
    select ws.user_id
    from windowed_sessions ws
    group by ws.user_id
    having count(*) >= 2
  ) repeated
)
select
  active_students.active_students_count,
  session_counts.sessions_started_count,
  session_counts.sessions_completed_count,
  attempt_counts.attempts_count,
  case
    when active_students.active_students_count = 0 then null
    else round(
      attempt_counts.attempts_count::numeric /
      active_students.active_students_count::numeric,
      2
    )
  end as attempts_per_active_student,
  case
    when active_students.active_students_count = 0 then null
    else round(
      returning_students.returning_students_count::numeric /
      active_students.active_students_count::numeric,
      4
    )
  end as return_rate,
  now() as generated_at
from active_students
cross join session_counts
cross join attempt_counts
cross join returning_students
where exists (
  select 1
  from app.profiles p
  where p.user_id = auth.uid()
    and p.role in (
      'content_author',
      'tutor',
      'reader',
      'validator',
      'support',
      'admin'
    )
);

grant select on public.dashboard_engagement_v1 to authenticated;

create or replace view public.dashboard_quality_v1
as
with quality_rows as (
  select
    s.id as subject_id,
    s.subject_key,
    s.display_name as subject_name,
    ci.item_type,
    ci.frq_form,
    gr.latency_ms,
    gr.estimated_cost_usd,
    gr.prediction_outcome
  from app.grading_results gr
  join app.attempts a
    on a.id = gr.attempt_id
  join app.content_item_versions civ
    on civ.id = a.content_item_version_id
  join app.content_items ci
    on ci.id = civ.content_item_id
  join app.exam_pack_versions epv
    on epv.id = a.exam_pack_version_id
  join app.exam_packs ep
    on ep.id = epv.exam_pack_id
  join app.subjects s
    on s.id = ep.subject_id
  where gr.status in ('graded', 'uncertain', 'failed')
    and exists (
      select 1
      from app.profiles p
      where p.user_id = auth.uid()
        and p.role in (
          'content_author',
          'tutor',
          'reader',
          'validator',
          'support',
          'admin'
        )
    )
)
select
  subject_id,
  subject_key,
  subject_name,
  item_type,
  frq_form,
  count(*) as grading_results_count,
  round(
    (percentile_cont(0.5) within group (order by latency_ms))::numeric,
    0
  ) as latency_p50_ms,
  round(
    (percentile_cont(0.9) within group (order by latency_ms))::numeric,
    0
  ) as latency_p90_ms,
  round(
    (percentile_cont(0.99) within group (order by latency_ms))::numeric,
    0
  ) as latency_p99_ms,
  round(avg(estimated_cost_usd)::numeric, 4) as average_cost_usd,
  null::numeric as rubric_agreement_rate,
  max(case when prediction_outcome is not null then 1 else 0 end) as has_prediction_outcomes
from quality_rows
group by subject_id, subject_key, subject_name, item_type, frq_form
order by subject_name, item_type, frq_form;

grant select on public.dashboard_quality_v1 to authenticated;

create or replace view public.dashboard_attention_v1
as
with attention_rows as (
  select
    s.id as subject_id,
    s.subject_key,
    s.display_name as subject_name,
    count(distinct cra.content_review_assignment_id) filter (
      where cra.status in ('pending', 'in_progress')
        and cra.due_at is not null
        and cra.due_at < now()
    ) as overdue_review_assignments_count,
    count(distinct cra.content_review_assignment_id) filter (
      where cra.status in ('pending', 'in_progress')
    ) as open_review_assignments_count,
    count(distinct civ.id) filter (
      where civ.review_status in (
        'modification_reserved',
        'excluded',
        'answer_modification_reserved',
        'mcq_package_excluded'
      )
    ) as blocked_content_versions_count,
    count(distinct gr.id) filter (
      where gr.status in ('failed', 'uncertain')
    ) as unresolved_grading_results_count,
    greatest(
      coalesce(max(cra.created_at), s.created_at),
      coalesce(max(civ.updated_at), s.created_at),
      coalesce(max(gr.updated_at), s.created_at)
    ) as latest_update_at
  from app.subjects s
  left join app.exam_packs ep
    on ep.subject_id = s.id
  left join app.exam_pack_versions epv
    on epv.exam_pack_id = ep.id
  left join app.content_items ci
    on ci.exam_pack_version_id = epv.id
  left join app.content_item_versions civ
    on civ.content_item_id = ci.id
  left join app.content_review_assignments cra
    on cra.content_item_version_id = civ.id
  left join app.attempts a
    on a.content_item_version_id = civ.id
  left join app.grading_results gr
    on gr.attempt_id = a.id
  where s.status = 'active'
    and exists (
      select 1
      from app.profiles p
      where p.user_id = auth.uid()
        and p.role in (
          'content_author',
          'tutor',
          'reader',
          'validator',
          'support',
          'admin'
        )
    )
  group by s.id, s.subject_key, s.display_name
)
select
  subject_id,
  subject_key,
  subject_name,
  overdue_review_assignments_count,
  open_review_assignments_count,
  blocked_content_versions_count,
  unresolved_grading_results_count,
  latest_update_at
from attention_rows
order by overdue_review_assignments_count desc,
         blocked_content_versions_count desc,
         subject_name;

grant select on public.dashboard_attention_v1 to authenticated;

commit;
