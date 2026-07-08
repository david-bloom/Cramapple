-- Subject defaults + persistent student memory + session context.
--
-- This migration adds the missing durable learner-memory layer and a
-- canonical runtime context composer that merges:
--   1) subject guidance defaults,
--   2) student-specific memory state, and
--   3) live session state.

begin;

create table if not exists app.subject_guidance_profiles (
  subject_id uuid primary key references app.subjects(id) on delete cascade,
  profile_version text not null default '2026-07-07',
  guidance_defaults jsonb not null default '{}'::jsonb,
  status text not null default 'published',
  created_by uuid references app.profiles(user_id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint subject_guidance_profiles_status_check
    check (status in ('draft', 'published', 'retired'))
);

create trigger subject_guidance_profiles_set_updated_at
before update on app.subject_guidance_profiles
for each row execute function app.set_updated_at();

alter table app.subject_guidance_profiles enable row level security;

create policy "subject_guidance_profiles_service_all"
on app.subject_guidance_profiles
for all
to service_role
using (true)
with check (true);

grant select, insert, update, delete on app.subject_guidance_profiles to service_role;

with subject_defaults(subject_key, profile_version, guidance_defaults) as (
  values
    (
      'ap-biology',
      '2026-07-07',
      jsonb_build_object(
        'help_style', 'evidence_first',
        'feedback_density', 'balanced',
        'preferred_repair_style', 'minimum_fix',
        'preferred_representation_order',
          jsonb_build_array('diagram', 'graph', 'table', 'text'),
        'default_session_mode', 'focused',
        'default_entry_path', 'recommend',
        'session_summary_style', 'criterion_level'
      )
    ),
    (
      'ap-statistics',
      '2026-07-07',
      jsonb_build_object(
        'help_style', 'calculation_first',
        'feedback_density', 'balanced',
        'preferred_repair_style', 'show_work',
        'preferred_representation_order',
          jsonb_build_array('table', 'formula', 'graph', 'text'),
        'default_session_mode', 'focused',
        'default_entry_path', 'recommend',
        'session_summary_style', 'criterion_level',
        'subject_specific_checks',
          jsonb_build_array('units', 'notation', 'calculation_steps')
      )
    ),
    (
      'ap-chemistry',
      '2026-07-07',
      jsonb_build_object(
        'help_style', 'equation_and_units_first',
        'feedback_density', 'balanced',
        'preferred_repair_style', 'notation_and_unit_check',
        'preferred_representation_order',
          jsonb_build_array('equation', 'particle_model', 'table', 'text'),
        'default_session_mode', 'focused',
        'default_entry_path', 'recommend',
        'session_summary_style', 'criterion_level',
        'subject_specific_checks',
          jsonb_build_array('equation_balance', 'units', 'sig_figs', 'particle_reasoning')
      )
    ),
    (
      'ap-physics-1',
      '2026-07-07',
      jsonb_build_object(
        'help_style', 'diagram_first',
        'feedback_density', 'balanced',
        'preferred_repair_style', 'diagram_and_sign_convention',
        'preferred_representation_order',
          jsonb_build_array('free_body_diagram', 'vector_diagram', 'equation', 'text'),
        'default_session_mode', 'focused',
        'default_entry_path', 'recommend',
        'session_summary_style', 'criterion_level',
        'subject_specific_checks',
          jsonb_build_array('sign_convention', 'units', 'symbolic_manipulation', 'diagram_reasoning')
      )
    )
)
insert into app.subject_guidance_profiles (
  subject_id,
  profile_version,
  guidance_defaults,
  status
)
select
  s.id,
  d.profile_version,
  d.guidance_defaults,
  'published'
from subject_defaults d
join app.subjects s
  on s.subject_key = d.subject_key
on conflict (subject_id)
do update set
  profile_version = excluded.profile_version,
  guidance_defaults = excluded.guidance_defaults,
  status = excluded.status;

create table if not exists app.student_memory_events (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references app.profiles(user_id) on delete cascade,
  subject_id uuid not null references app.subjects(id) on delete cascade,
  event_kind text not null,
  source_session_id uuid references app.learning_sessions(id) on delete set null,
  source_attempt_id uuid references app.attempts(id) on delete set null,
  event_payload jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  constraint student_memory_events_kind_check
    check (
      event_kind in (
        'session_summary',
        'grading_result',
        'manual_preference',
        'stuck_choice',
        'review_outcome'
      )
    )
);

create index if not exists student_memory_events_user_subject_created_idx
  on app.student_memory_events (user_id, subject_id, created_at desc);

alter table app.student_memory_events enable row level security;

create policy "student_memory_events_service_all"
on app.student_memory_events
for all
to service_role
using (true)
with check (true);

grant select, insert, update, delete on app.student_memory_events to service_role;

create table if not exists app.student_memory_snapshots (
  user_id uuid not null references app.profiles(user_id) on delete cascade,
  subject_id uuid not null references app.subjects(id) on delete cascade,
  memory_state jsonb not null default '{}'::jsonb,
  state_version text not null default '2026-07-07',
  evidence_count integer not null default 0,
  last_event_id uuid references app.student_memory_events(id) on delete set null,
  last_event_kind text,
  last_event_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint student_memory_snapshots_pkey primary key (user_id, subject_id)
);

create trigger student_memory_snapshots_set_updated_at
before update on app.student_memory_snapshots
for each row execute function app.set_updated_at();

alter table app.student_memory_snapshots enable row level security;

create policy "student_memory_snapshots_service_all"
on app.student_memory_snapshots
for all
to service_role
using (true)
with check (true);

grant select, insert, update, delete on app.student_memory_snapshots to service_role;

create or replace function app.apply_student_memory_event()
returns trigger
language plpgsql
as $$
declare
  next_state jsonb;
  next_event_at timestamptz;
  next_event_kind text;
begin
  next_state := coalesce(new.event_payload -> 'memory_state', '{}'::jsonb);
  next_event_at := coalesce(
    (new.event_payload ->> 'event_at')::timestamptz,
    new.created_at
  );
  next_event_kind := coalesce(
    new.event_payload ->> 'event_kind',
    new.event_kind
  );

  insert into app.student_memory_snapshots (
    user_id,
    subject_id,
    memory_state,
    state_version,
    evidence_count,
    last_event_id,
    last_event_kind,
    last_event_at
  )
  values (
    new.user_id,
    new.subject_id,
    next_state,
    '2026-07-07',
    1,
    new.id,
    next_event_kind,
    next_event_at
  )
  on conflict (user_id, subject_id)
  do update set
    memory_state = excluded.memory_state,
    state_version = excluded.state_version,
    evidence_count = app.student_memory_snapshots.evidence_count + 1,
    last_event_id = excluded.last_event_id,
    last_event_kind = excluded.last_event_kind,
    last_event_at = excluded.last_event_at,
    updated_at = now();

  return new;
end;
$$;

drop trigger if exists student_memory_events_apply_snapshot on app.student_memory_events;
create trigger student_memory_events_apply_snapshot
after insert on app.student_memory_events
for each row execute function app.apply_student_memory_event();

create or replace function app.compose_learning_runtime_context(
  p_session_id uuid
)
returns jsonb
language sql
stable
security invoker
set search_path = app, public
as $$
  with session_row as (
    select
      ls.id,
      ls.user_id,
      ls.exam_pack_version_id,
      ls.entry_path,
      ls.session_mode,
      ls.available_minutes,
      ls.status,
      ls.started_at,
      ls.ended_at,
      ls.created_at,
      ls.updated_at
    from app.learning_sessions ls
    where ls.id = p_session_id
  ),
  exam_pack_version_row as (
    select
      epv.id,
      epv.exam_pack_id,
      epv.school_year,
      epv.official_exam_date,
      epv.status,
      epv.source_uri,
      epv.source_published_at,
      epv.released_at,
      epv.created_at,
      epv.updated_at
    from app.exam_pack_versions epv
    join session_row sr on sr.exam_pack_version_id = epv.id
  ),
  exam_pack_row as (
    select
      ep.id,
      ep.exam_code,
      ep.exam_name,
      ep.subject_id,
      ep.created_at,
      ep.updated_at
    from app.exam_packs ep
    join exam_pack_version_row epv on epv.exam_pack_id = ep.id
  ),
  subject_row as (
    select
      s.id,
      s.subject_key,
      s.display_name,
      s.status,
      s.created_at,
      s.updated_at
    from app.subjects s
    join exam_pack_row ep on ep.subject_id = s.id
  ),
  guidance_row as (
    select
      sgp.profile_version,
      sgp.guidance_defaults,
      sgp.status,
      sgp.created_at,
      sgp.updated_at
    from app.subject_guidance_profiles sgp
    join subject_row s on sgp.subject_id = s.id
    order by sgp.updated_at desc
    limit 1
  ),
  memory_row as (
    select
      sms.memory_state,
      sms.state_version,
      sms.evidence_count,
      sms.last_event_id,
      sms.last_event_kind,
      sms.last_event_at,
      sms.created_at,
      sms.updated_at
    from app.student_memory_snapshots sms
    join session_row sr on sms.user_id = sr.user_id
    join subject_row s on sms.subject_id = s.id
  ),
  recent_attempts as (
    select coalesce(
      jsonb_agg(
        jsonb_build_object(
          'id', a.id,
          'content_item_version_id', a.content_item_version_id,
          'attempt_mode', a.attempt_mode,
          'status', a.status,
          'assistance_state', a.assistance_state,
          'started_at', a.started_at,
          'submitted_at', a.submitted_at,
          'graded_at', a.graded_at,
          'score_points', a.score_points,
          'score_possible', a.score_possible,
          'confidence_level', a.confidence_level,
          'result_state', a.result_state,
          'result_summary', a.result_summary
        )
        order by a.started_at desc
      ),
      '[]'::jsonb
    ) as items
    from (
      select
        a.id,
        a.content_item_version_id,
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
        a.result_summary
      from app.attempts a
      join session_row sr on a.learning_session_id = sr.id
      order by a.started_at desc
      limit 5
    ) a
  )
  select jsonb_build_object(
    'context_version', '2026-07-07',
    'subject_defaults',
      jsonb_build_object(
        'subject', jsonb_build_object(
          'id', subject_row.id,
          'subject_key', subject_row.subject_key,
          'display_name', subject_row.display_name,
          'status', subject_row.status
        ),
        'exam_pack', jsonb_build_object(
          'id', exam_pack_row.id,
          'exam_code', exam_pack_row.exam_code,
          'exam_name', exam_pack_row.exam_name
        ),
        'exam_pack_version', jsonb_build_object(
          'id', exam_pack_version_row.id,
          'school_year', exam_pack_version_row.school_year,
          'official_exam_date', exam_pack_version_row.official_exam_date,
          'status', exam_pack_version_row.status
        ),
        'guidance_defaults', coalesce(guidance_row.guidance_defaults, '{}'::jsonb)
      ),
    'student_memory',
      jsonb_build_object(
        'memory_state', coalesce(memory_row.memory_state, '{}'::jsonb),
        'state_version', coalesce(memory_row.state_version, '2026-07-07'),
        'evidence_count', coalesce(memory_row.evidence_count, 0),
        'last_event_id', memory_row.last_event_id,
        'last_event_kind', memory_row.last_event_kind,
        'last_event_at', memory_row.last_event_at
      ),
    'session_state',
      jsonb_build_object(
        'id', session_row.id,
        'user_id', session_row.user_id,
        'exam_pack_version_id', session_row.exam_pack_version_id,
        'entry_path', session_row.entry_path,
        'session_mode', session_row.session_mode,
        'available_minutes', session_row.available_minutes,
        'status', session_row.status,
        'started_at', session_row.started_at,
        'ended_at', session_row.ended_at,
        'recent_attempts', recent_attempts.items
      ),
    'effective_guidance',
      coalesce(guidance_row.guidance_defaults, '{}'::jsonb)
      || coalesce(memory_row.memory_state, '{}'::jsonb)
      || jsonb_build_object(
        'current_session_mode', session_row.session_mode,
        'current_entry_path', session_row.entry_path,
        'available_minutes', session_row.available_minutes,
        'session_status', session_row.status
      )
  )
  from session_row
  join exam_pack_version_row on true
  join exam_pack_row on true
  join subject_row on true
  left join guidance_row on true
  left join memory_row on true
  left join recent_attempts on true;
$$;

grant execute on function app.compose_learning_runtime_context(uuid) to service_role;

commit;
