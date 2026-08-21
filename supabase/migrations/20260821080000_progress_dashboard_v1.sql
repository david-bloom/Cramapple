-- Progress Dashboard v1
-- ---------------------------------------------------------------------------
-- Backend becomes the sole producer of student progress metrics. Lovable is
-- display-only: it calls public.get_student_progress_dashboard and renders the
-- returned fields verbatim.
--
-- v1 scope decisions (Product Owner, 2026-08-21):
--   * Computed LIVE on every call. app.progress_snapshots is left in place for
--     a later history/trend version but is not read or written here. A
--     read-or-empty snapshot cache would show an empty page to a student who
--     actually has evidence, which the honest-empty-state principle forbids.
--   * topics[] and per-unit / per-topic score breakdowns are CUT. There is no
--     join path from a student attempt to a taxonomy topic anywhere in the
--     schema (topic_code exists only on app.taxonomy_topics,
--     app.topic_explainers and app.topic_point_briefs), so any topic figure
--     would be invented.
--   * summary.frq.estimatedScore1To5 IS included, under DECISION-0003, with
--     its four required qualifiers carried in the payload and a minimum
--     evidence floor below which it returns null.
--   * All ten subjects ship. Subjects with no evidence return a valid,
--     explicitly empty payload rather than an error.
--
-- Evidence source: app.grading_results joined through app.attempts.
-- app.attempts.score_points / graded_at are never written by the grading path
-- (0 of 44 rows populated in production on 2026-08-21), so reading attempts
-- alone would return all zeros.
--
-- Unit attribution is deliberately NOT derived from app.content_labels
-- (label_type='unit'). AP Statistics is the only subject with substantial unit
-- labels (200 of 296 items) and those labels use the legacy nine-unit
-- structure, while the verified 2026-2027 taxonomy for AP Statistics has five
-- units with different titles. Mapping label unit_3 onto taxonomy unit 3 would
-- produce confidently wrong attribution, which is worse than none. Units are
-- therefore listed from the verified taxonomy with an explicit
-- 'attribution_unavailable' status.

-- ---------------------------------------------------------------------------
-- Indexes for the live read path
-- ---------------------------------------------------------------------------

create index if not exists attempts_user_pack_idx
  on app.attempts (user_id, exam_pack_version_id, submitted_at desc);

create index if not exists grading_results_attempt_created_idx
  on app.grading_results (attempt_id, created_at desc);

create index if not exists learning_sessions_user_pack_idx
  on app.learning_sessions (user_id, exam_pack_version_id, started_at desc);

-- Retained from the original plan: harmless today (0 rows) and required by the
-- snapshot-backed history version this migration deliberately defers.
create index if not exists progress_snapshots_latest_idx
  on app.progress_snapshots (user_id, exam_pack_version_id, snapshot_kind, generated_at desc);

-- ---------------------------------------------------------------------------
-- Scoring helpers (versioned with the payload contract)
-- ---------------------------------------------------------------------------

-- Non-official estimated AP score band from an earned/possible free-response
-- ratio. This mapping is a heuristic band, NOT a calibrated concordance
-- against College Board score data; callers must surface that gap. See
-- DECISION-0003 follow-up "Establish expert review and calibration standards".
create or replace function app.progress_estimated_ap_score(
  _earned integer,
  _possible integer
)
returns integer
language sql
immutable
set search_path to 'pg_catalog'
as $$
  select case
    when _possible is null or _possible <= 0 then null
    when coalesce(_earned, 0)::numeric / _possible >= 0.75 then 5
    when coalesce(_earned, 0)::numeric / _possible >= 0.60 then 4
    when coalesce(_earned, 0)::numeric / _possible >= 0.45 then 3
    when coalesce(_earned, 0)::numeric / _possible >= 0.30 then 2
    else 1
  end;
$$;

-- Semantic status token. Deliberately NOT a colour: colour is a presentation
-- concern and baking it into the data contract breaks theming, dark mode and
-- accessibility. Lovable maps token -> colour.
--
-- 'red' from the original plan is intentionally absent: it conflated weak
-- performance with thin evidence, and UX-007's approved principle is that
-- incomplete work is never framed as learner failure.
create or replace function app.progress_status_token(
  _graded_items integer,
  _earned integer,
  _possible integer
)
returns text
language sql
immutable
set search_path to 'pg_catalog'
as $$
  select case
    when coalesce(_graded_items, 0) = 0 then 'no_evidence'
    when coalesce(_graded_items, 0) < 3 then 'insufficient_evidence'
    when coalesce(_possible, 0) <= 0 then 'insufficient_evidence'
    when coalesce(_earned, 0)::numeric / _possible >= 0.70 then 'strong'
    else 'developing'
  end;
$$;

create or replace function app.progress_status_label(_token text)
returns text
language sql
immutable
set search_path to 'pg_catalog'
as $$
  select case _token
    when 'no_evidence' then 'No evidence yet'
    when 'insufficient_evidence' then 'Not enough evidence yet'
    when 'developing' then 'Developing'
    when 'strong' then 'Strong'
    when 'attribution_unavailable' then 'Unit-level breakdown not available yet'
    else 'Unknown'
  end;
$$;

-- ---------------------------------------------------------------------------
-- Display RPC
-- ---------------------------------------------------------------------------

create or replace function public.get_student_progress_dashboard(
  _subject_key text default null
)
returns jsonb
language plpgsql
stable
security definer
set search_path to 'pg_catalog'
as $$
declare
  c_version constant text := 'progress_dashboard_v1_2026_08_21';
  -- DECISION-0003: minimum evidence before any estimate is displayed.
  c_min_frq_items constant integer := 3;
  c_min_frq_points constant integer := 10;

  v_user_id uuid := auth.uid();
  v_requested text := nullif(app.normalize_student_subject_key(_subject_key), '');
  v_version_id uuid;
  v_subject_id uuid;
  v_subject_key text;
  v_display_name text;
  v_school_year text;
  v_exam_date date;
  v_taxonomy_version uuid;

  v_mcq_attempted integer := 0;
  v_mcq_correct integer := 0;
  v_mcq_uncertain integer := 0;
  v_frq_items integer := 0;
  v_frq_earned integer := 0;
  v_frq_possible integer := 0;
  v_frq_uncertain integer := 0;
  v_excluded_non_independent integer := 0;
  v_excluded_other_format integer := 0;

  v_sessions integer := 0;
  v_minutes integer := 0;
  v_sessions_no_duration integer := 0;

  v_est integer;
  v_confidence text;
  v_gaps jsonb := '[]'::jsonb;
  v_units jsonb := '[]'::jsonb;
  v_recent jsonb := '[]'::jsonb;
begin
  if v_user_id is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;

  if v_requested is not null and v_requested !~ '^[a-z0-9][a-z0-9_]*$' then
    raise exception 'progress:invalid_subject_key' using errcode = '22023';
  end if;

  -- --- Resolve the exam pack version --------------------------------------
  -- A null subject key means "the student's active subject", not "all
  -- subjects" (which is what get_student_taxonomy's null means).
  if v_requested is null then
    select p.active_exam_pack_version_id
      into v_version_id
      from app.profiles p
     where p.user_id = v_user_id;
  else
    select epv.id
      into v_version_id
      from app.exam_pack_versions epv
      join app.exam_packs ep on ep.id = epv.exam_pack_id
      join app.subjects s on s.id = ep.subject_id
     where app.normalize_student_subject_key(s.subject_key) = v_requested
       and epv.status = 'published'
     order by epv.school_year desc, epv.released_at desc nulls last, epv.created_at desc
     limit 1;
  end if;

  if v_version_id is null then
    return jsonb_build_object(
      'version', c_version,
      'generatedAt', now(),
      'state', 'no_subject',
      'subject', null,
      'summary', null,
      'units', '[]'::jsonb,
      'recentActivity', '[]'::jsonb,
      'notes', jsonb_build_array(
        'No active subject is selected for this student.'
      )
    );
  end if;

  -- --- Subject identity ----------------------------------------------------
  select s.id,
         app.normalize_student_subject_key(s.subject_key),
         s.display_name,
         epv.school_year,
         epv.official_exam_date
    into v_subject_id, v_subject_key, v_display_name, v_school_year, v_exam_date
    from app.exam_pack_versions epv
    join app.exam_packs ep on ep.id = epv.exam_pack_id
    join app.subjects s on s.id = ep.subject_id
   where epv.id = v_version_id;

  if v_subject_id is null then
    raise exception 'progress:unresolvable_subject' using errcode = '22023';
  end if;

  -- --- Entitlement ---------------------------------------------------------
  if not exists (
    select 1
      from app.subject_entitlements e
     where e.user_id = v_user_id
       and e.status = 'active'
       and (e.all_subjects or e.subject_id = v_subject_id)
       and (e.starts_at is null or e.starts_at <= now())
       and (e.ends_at is null or e.ends_at > now())
  ) then
    raise exception 'progress:not_entitled' using errcode = '42501';
  end if;

  -- --- Evidence ------------------------------------------------------------
  -- Two layers of de-duplication, both load-bearing:
  --   1. latest_grade   -- one attempt can be graded many times (production
  --                        has 10 grading rows across 3 items for one user).
  --   2. first_per_item -- only the FIRST graded attempt on an item counts as
  --                        cold independent evidence; later attempts are
  --                        repairs and must not inflate the numbers. This
  --                        mirrors isQualifyingAttempt() in home-snapshot.ts.
  -- Uncertain grades are excluded from both numerator and denominator and
  -- reported separately, per UX-007's explicit-withheld-evidence requirement.
  with latest_grade as (
    select distinct on (g.attempt_id)
           g.attempt_id,
           g.status,
           g.points_earned,
           g.points_available
      from app.grading_results g
      join app.attempts a2 on a2.id = g.attempt_id
     where a2.user_id = v_user_id
       and a2.exam_pack_version_id = v_version_id
     order by g.attempt_id, g.created_at desc
  ),
  scoped as (
    select a.id as attempt_id,
           civ.content_item_id,
           a.attempt_mode,
           coalesce(a.assistance_state, 'independent') as assistance_state,
           lg.status,
           lg.points_earned,
           lg.points_available,
           coalesce(a.submitted_at, a.created_at) as attempted_at
      from app.attempts a
      join latest_grade lg on lg.attempt_id = a.id
      join app.content_item_versions civ on civ.id = a.content_item_version_id
  ),
  -- Dedupe WITHIN the countable set. Deduping first and filtering after would
  -- drop a student's real independent evidence whenever their first pass on an
  -- item happened to be coached.
  first_per_item as (
    select distinct on (s.content_item_id) s.*
      from scoped s
     where s.assistance_state = 'independent'
       and s.attempt_mode in ('mcq', 'frq')
     order by s.content_item_id, s.attempted_at asc
  ),
  -- Anything the metrics cannot count is reported rather than silently
  -- dropped. attempt_mode allows 'quantitative' and assistance_state allows
  -- 'coached' and 'exam_practice'; none of those feed the figures above.
  excluded as (
    select
      count(distinct s.content_item_id)
        filter (where s.assistance_state <> 'independent') as non_independent_items,
      count(distinct s.content_item_id)
        filter (where s.attempt_mode not in ('mcq', 'frq')) as other_format_items
      from scoped s
  )
  select
    count(*) filter (
      where attempt_mode = 'mcq' and status = 'graded' and coalesce(points_available, 0) > 0),
    count(*) filter (
      where attempt_mode = 'mcq' and status = 'graded' and coalesce(points_available, 0) > 0
        and coalesce(points_earned, 0) >= points_available),
    count(*) filter (where attempt_mode = 'mcq' and status = 'uncertain'),
    count(*) filter (where attempt_mode = 'frq' and status = 'graded'),
    coalesce(sum(points_earned) filter (where attempt_mode = 'frq' and status = 'graded'), 0),
    coalesce(sum(points_available) filter (where attempt_mode = 'frq' and status = 'graded'), 0),
    count(*) filter (where attempt_mode = 'frq' and status = 'uncertain'),
    max(x.non_independent_items),
    max(x.other_format_items)
    into v_mcq_attempted, v_mcq_correct, v_mcq_uncertain,
         v_frq_items, v_frq_earned, v_frq_possible, v_frq_uncertain,
         v_excluded_non_independent, v_excluded_other_format
    from first_per_item
    right join excluded x on true;

  -- --- Activity ------------------------------------------------------------
  -- Planned minutes (available_minutes) are NOT summed into actual minutes.
  -- Mixing planned and actual produces a number nobody can interpret.
  select count(*),
         coalesce(round(sum(
           extract(epoch from (ls.ended_at - ls.started_at)) / 60.0
         ) filter (where ls.ended_at is not null and ls.started_at is not null))::integer, 0),
         count(*) filter (where ls.ended_at is null or ls.started_at is null)
    into v_sessions, v_minutes, v_sessions_no_duration
    from app.learning_sessions ls
   where ls.user_id = v_user_id
     and ls.exam_pack_version_id = v_version_id;

  -- --- Estimated AP score (DECISION-0003) ----------------------------------
  if v_frq_items >= c_min_frq_items and v_frq_possible >= c_min_frq_points then
    v_est := app.progress_estimated_ap_score(v_frq_earned, v_frq_possible);
    -- Confidence is capped at 'low' for the whole of v1: DECISION-0003's
    -- calibration follow-up is still open, so no higher claim is defensible.
    v_confidence := 'low';
  else
    v_est := null;
    v_confidence := 'none';
  end if;

  if v_frq_items < c_min_frq_items then
    v_gaps := v_gaps || to_jsonb(format(
      'Based on %s independently graded free-response item(s); %s are needed before an estimate is shown.',
      v_frq_items, c_min_frq_items));
  end if;

  if v_frq_possible < c_min_frq_points then
    v_gaps := v_gaps || to_jsonb(format(
      'Only %s free-response point(s) attempted; %s are needed before an estimate is shown.',
      v_frq_possible, c_min_frq_points));
  end if;

  if v_frq_uncertain > 0 or v_mcq_uncertain > 0 then
    v_gaps := v_gaps || to_jsonb(format(
      '%s grade(s) were withheld as uncertain and are excluded from these figures.',
      v_frq_uncertain + v_mcq_uncertain));
  end if;

  if v_est is not null then
    v_gaps := v_gaps || to_jsonb(
      'This estimate has not been calibrated against official College Board score data.'::text);
  end if;

  if coalesce(v_excluded_non_independent, 0) > 0 then
    v_gaps := v_gaps || to_jsonb(format(
      '%s item(s) were worked with help or in exam-practice mode and are excluded from independent evidence.',
      v_excluded_non_independent));
  end if;

  if coalesce(v_excluded_other_format, 0) > 0 then
    v_gaps := v_gaps || to_jsonb(format(
      '%s item(s) in a format v1 does not score are excluded from these figures.',
      v_excluded_other_format));
  end if;

  v_gaps := v_gaps || to_jsonb(
    'Unit-level attribution is unavailable, so this figure is not weighted by exam unit.'::text);

  -- --- Units ---------------------------------------------------------------
  select tsv.taxonomy_source_version
    into v_taxonomy_version
    from app.taxonomy_source_versions tsv
   where tsv.subject_key = v_subject_key
     and tsv.taxonomy_confidence = 'verified'
     and exists (
       select 1 from app.taxonomy_units tu
        where tu.taxonomy_source_version = tsv.taxonomy_source_version
     )
   order by tsv.school_year desc, tsv.verified_at desc nulls last, tsv.created_at desc
   limit 1;

  if v_taxonomy_version is not null then
    select coalesce(jsonb_agg(
             jsonb_build_object(
               'unitNumber', tu.unit_number,
               'unitTitle', tu.unit_title,
               'isExamAssessed', tu.is_exam_assessed,
               'status', 'attribution_unavailable',
               'statusLabel', app.progress_status_label('attribution_unavailable')
             ) order by tu.unit_number
           ), '[]'::jsonb)
      into v_units
      from app.taxonomy_units tu
     where tu.taxonomy_source_version = v_taxonomy_version;
  end if;

  -- --- Recent activity -----------------------------------------------------
  with latest_grade as (
    select distinct on (g.attempt_id)
           g.attempt_id, g.status, g.points_earned, g.points_available, g.confidence
      from app.grading_results g
      join app.attempts a2 on a2.id = g.attempt_id
     where a2.user_id = v_user_id
       and a2.exam_pack_version_id = v_version_id
     order by g.attempt_id, g.created_at desc
  ),
  recent as (
    select ci.content_key,
           a.attempt_mode,
           lg.status,
           lg.points_earned,
           lg.points_available,
           lg.confidence,
           coalesce(a.submitted_at, a.created_at) as attempted_at
      from app.attempts a
      join latest_grade lg on lg.attempt_id = a.id
      join app.content_item_versions civ on civ.id = a.content_item_version_id
      join app.content_items ci on ci.id = civ.content_item_id
     order by coalesce(a.submitted_at, a.created_at) desc
     limit 10
  )
  select coalesce(jsonb_agg(
           jsonb_build_object(
             'contentKey', r.content_key,
             'format', r.attempt_mode,
             'gradeState', r.status,
             'gradeConfidence', r.confidence,
             -- A grade the system withheld as uncertain must not ship a point
             -- score the UI could render as a result (UX-007 regression area:
             -- "uncertain grades affecting progress").
             'pointsEarned', case when r.status = 'uncertain' then null else r.points_earned end,
             'pointsAvailable', r.points_available,
             'pointsWithheld', (r.status = 'uncertain'),
             'attemptedAt', r.attempted_at
           ) order by r.attempted_at desc
         ), '[]'::jsonb)
    into v_recent
    from recent r;

  -- --- Payload -------------------------------------------------------------
  return jsonb_build_object(
    'version', c_version,
    'generatedAt', now(),
    'state', 'ready',
    'subject', jsonb_build_object(
      'subjectKey', v_subject_key,
      'displayName', coalesce(v_display_name, v_subject_key),
      'examPackVersionId', v_version_id,
      'schoolYear', v_school_year,
      'officialExamDate', v_exam_date
    ),
    'summary', jsonb_build_object(
      'mcq', jsonb_build_object(
        'correct', v_mcq_correct,
        'attempted', v_mcq_attempted,
        'percentCorrect', case
          when v_mcq_attempted > 0
          then round((v_mcq_correct::numeric / v_mcq_attempted) * 100)::integer
          else null end,
        'uncertainExcluded', v_mcq_uncertain,
        'status', app.progress_status_token(v_mcq_attempted, v_mcq_correct, v_mcq_attempted),
        'statusLabel', app.progress_status_label(
          app.progress_status_token(v_mcq_attempted, v_mcq_correct, v_mcq_attempted))
      ),
      'frq', jsonb_build_object(
        'gradedItems', v_frq_items,
        'earnedPoints', v_frq_earned,
        'possiblePoints', v_frq_possible,
        'uncertainExcluded', v_frq_uncertain,
        'estimatedScore1To5', v_est,
        'confidence', v_confidence,
        'isOfficial', false,
        'qualifier', 'Cramapple estimate, not an official College Board score.',
        'evidenceGaps', v_gaps,
        'nextAction', case
          when v_est is null
          then 'Complete a few more free-response items to unlock an estimate.'
          else 'Work the criteria you are losing points on to move this estimate.'
        end,
        'status', app.progress_status_token(v_frq_items, v_frq_earned, v_frq_possible),
        'statusLabel', app.progress_status_label(
          app.progress_status_token(v_frq_items, v_frq_earned, v_frq_possible))
      ),
      'activity', jsonb_build_object(
        'sessions', v_sessions,
        'actualMinutes', v_minutes,
        'sessionsWithoutDuration', v_sessions_no_duration,
        'unitsWithEvidence', null,
        'unitAttributionAvailable', false,
        'excludedNonIndependentItems', coalesce(v_excluded_non_independent, 0),
        'excludedOtherFormatItems', coalesce(v_excluded_other_format, 0)
      )
    ),
    'units', v_units,
    'recentActivity', v_recent,
    'notes', jsonb_build_array(
      'Unit-level evidence attribution is not available in v1. Units are listed from the verified course taxonomy with no per-unit evidence.',
      'Topic-level progress is not available in v1.'
    )
  );
end;
$$;

comment on function public.get_student_progress_dashboard(text) is
  'Progress Dashboard v1. Live-computed, display-only contract for the student /progress page. Auth + subject entitlement enforced; returns data only for auth.uid().';

-- ---------------------------------------------------------------------------
-- Grants
-- ---------------------------------------------------------------------------

revoke all on function public.get_student_progress_dashboard(text) from public;
-- Supabase's default privileges grant EXECUTE to `anon` at creation time, and
-- `revoke ... from public` does NOT remove that explicit grant. Without this
-- line the database linter flags the function as anon-executable
-- (0028_anon_security_definer_function_executable). The function still refuses
-- unauthenticated callers on its own, but the grant should not exist at all.
revoke execute on function public.get_student_progress_dashboard(text) from anon;
grant execute on function public.get_student_progress_dashboard(text) to authenticated;

revoke all on function app.progress_estimated_ap_score(integer, integer) from public;
revoke all on function app.progress_status_token(integer, integer, integer) from public;
revoke all on function app.progress_status_label(text) from public;
