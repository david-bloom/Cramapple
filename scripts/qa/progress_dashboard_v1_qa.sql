-- Progress Dashboard v1 — QA suite
-- Run against any environment that has 20260821080000_progress_dashboard_v1.sql
-- applied. Read-only: the RPC is STABLE and this script writes nothing.
--
-- Usage: execute as a service role / postgres. Each check raises on failure and
-- emits a PASS notice otherwise. Substitute the two user UUIDs below for the
-- environment under test.
--
-- KNOWN ENVIRONMENT LIMITATION (2026-08-21): the Development project
-- wmgjsdkphcyhngaffbqf does NOT have app.taxonomy_source_versions, even though
-- its migration ledger records 20260804170000 (the migration that creates it)
-- as applied. The ledger and the schema disagree. Dev also carries five 0-row
-- taxonomy_scheme*/taxonomy_node* tables that exist in no repo migration.
-- This is pre-existing drift, not caused by the progress work:
-- public.get_student_taxonomy fails in Dev with the same 42P01. (That RPC has
-- no consumers; the topic-guide surface is served by get_topic_point_guides,
-- which does not read the taxonomy tables.)
-- QA-UNITS below therefore cannot pass on Dev until that is reconciled; see
-- docs/product/PROGRESS_DASHBOARD_V1_PLAN_2026_08_21.md section 9.

\set user_with_evidence '76705295-a203-4ce3-a2d4-218183024f05'
\set user_without_evidence 'f5a26c6b-3566-4d58-9e97-979fbb947564'
\set subject 'ap_biology'

-- QA1 + QA2: authentication and input validation ----------------------------
do $$
begin
  begin
    perform public.get_student_progress_dashboard('ap_biology');
    raise exception 'QA1 FAIL: unauthenticated call was allowed';
  exception when sqlstate '28000' then
    raise notice 'QA1 PASS: unauthenticated rejected (not_authenticated)';
  end;

  perform set_config('request.jwt.claims',
    '{"sub":"76705295-a203-4ce3-a2d4-218183024f05","role":"authenticated"}', true);
  begin
    perform public.get_student_progress_dashboard('bad key; drop table');
    raise exception 'QA2 FAIL: invalid subject key accepted';
  exception when sqlstate '22023' then
    raise notice 'QA2 PASS: invalid subject key rejected';
  end;
end $$;

-- QA3 + QA4: entitlement gate and honest empty state ------------------------
do $$
declare v jsonb;
begin
  perform set_config('request.jwt.claims',
    '{"sub":"00000000-0000-4000-8000-0000000000ff","role":"authenticated"}', true);
  begin
    v := public.get_student_progress_dashboard('ap_biology');
    raise exception 'QA3 FAIL: unentitled user received state=%', v->>'state';
  exception when sqlstate '42501' then
    raise notice 'QA3 PASS: unentitled user rejected (not_entitled)';
  end;

  v := public.get_student_progress_dashboard(null);
  if v->>'state' <> 'no_subject' then
    raise exception 'QA4 FAIL: expected no_subject, got %', v->>'state';
  end if;
  if not (v ? 'version' and v ? 'generatedAt' and v ? 'units' and v ? 'recentActivity') then
    raise exception 'QA4 FAIL: empty-state payload is missing required top-level keys';
  end if;
  raise notice 'QA4 PASS: no-subject empty state is a valid payload, not an error';
end $$;

-- QA5: required payload keys and closed status enum -------------------------
do $$
declare v jsonb; tok text;
begin
  perform set_config('request.jwt.claims',
    '{"sub":"76705295-a203-4ce3-a2d4-218183024f05","role":"authenticated"}', true);
  v := public.get_student_progress_dashboard('ap_biology');

  if v->>'state' <> 'ready' then
    raise exception 'QA5 FAIL: expected ready, got %', v->>'state';
  end if;
  if not (v ? 'version' and v ? 'generatedAt' and v ? 'subject'
          and v ? 'summary' and v ? 'units' and v ? 'recentActivity' and v ? 'notes') then
    raise exception 'QA5 FAIL: payload missing required top-level keys';
  end if;
  if v->>'version' <> 'progress_dashboard_v1_2026_08_21' then
    raise exception 'QA5 FAIL: unexpected contract version %', v->>'version';
  end if;

  -- topics[] must NOT be present: there is no attempt -> topic join path.
  if v ? 'topics' then
    raise exception 'QA5 FAIL: topics[] present but is unbuildable in v1';
  end if;

  for tok in
    select jsonb_array_elements(v->'units')->>'status'
    union all select v->'summary'->'mcq'->>'status'
    union all select v->'summary'->'frq'->>'status'
  loop
    if tok not in ('no_evidence','insufficient_evidence','developing','strong',
                   'attribution_unavailable') then
      raise exception 'QA5 FAIL: status token % is outside the approved set', tok;
    end if;
  end loop;
  raise notice 'QA5 PASS: payload shape and status enum are closed';
end $$;

-- QA6: no cross-user leakage ------------------------------------------------
do $$
declare a jsonb; b jsonb;
begin
  perform set_config('request.jwt.claims',
    '{"sub":"76705295-a203-4ce3-a2d4-218183024f05","role":"authenticated"}', true);
  a := public.get_student_progress_dashboard('ap_biology')->'summary';

  perform set_config('request.jwt.claims',
    '{"sub":"f5a26c6b-3566-4d58-9e97-979fbb947564","role":"authenticated"}', true);
  b := public.get_student_progress_dashboard('ap_biology')->'summary';

  if a = b then
    raise exception 'QA6 FAIL: two different students received identical summaries';
  end if;
  raise notice 'QA6 PASS: per-student isolation holds';
end $$;

-- QA7: de-duplication math matches an independent recomputation -------------
-- One attempt can be graded many times, and one item can be attempted many
-- times. The RPC must count the LATEST grade per attempt and the FIRST
-- independent attempt per item. Anything else multiply-counts.
do $$
declare rpc_items int; rpc_earned int; rpc_possible int;
        ref_items int; ref_earned int; ref_possible int;
        v jsonb;
begin
  perform set_config('request.jwt.claims',
    '{"sub":"76705295-a203-4ce3-a2d4-218183024f05","role":"authenticated"}', true);
  v := public.get_student_progress_dashboard('ap_biology')->'summary'->'frq';
  rpc_items    := (v->>'gradedItems')::int;
  rpc_earned   := (v->>'earnedPoints')::int;
  rpc_possible := (v->>'possiblePoints')::int;

  with lg as (
    select distinct on (g.attempt_id)
           g.attempt_id, g.status, g.points_earned, g.points_available
      from app.grading_results g
      join app.attempts a on a.id = g.attempt_id
     where a.user_id = '76705295-a203-4ce3-a2d4-218183024f05'
       and a.exam_pack_version_id = (
         select epv.id from app.exam_pack_versions epv
          join app.exam_packs ep on ep.id = epv.exam_pack_id
          join app.subjects s on s.id = ep.subject_id
         where app.normalize_student_subject_key(s.subject_key) = 'ap_biology'
           and epv.status = 'published'
         order by epv.school_year desc limit 1)
     order by g.attempt_id, g.created_at desc
  ), s as (
    select civ.content_item_id, a.attempt_mode,
           coalesce(a.assistance_state,'independent') ast,
           lg.status, lg.points_earned, lg.points_available,
           coalesce(a.submitted_at, a.created_at) at
      from app.attempts a
      join lg on lg.attempt_id = a.id
      join app.content_item_versions civ on civ.id = a.content_item_version_id
  ), f as (
    select distinct on (content_item_id) * from s
     where ast = 'independent' and attempt_mode in ('mcq','frq')
     order by content_item_id, at asc
  )
  select count(*) filter (where attempt_mode='frq' and status='graded'),
         coalesce(sum(points_earned) filter (where attempt_mode='frq' and status='graded'),0),
         coalesce(sum(points_available) filter (where attempt_mode='frq' and status='graded'),0)
    into ref_items, ref_earned, ref_possible
    from f;

  if (rpc_items, rpc_earned, rpc_possible) is distinct from (ref_items, ref_earned, ref_possible) then
    raise exception 'QA7 FAIL: rpc (%,%,%) <> reference (%,%,%)',
      rpc_items, rpc_earned, rpc_possible, ref_items, ref_earned, ref_possible;
  end if;
  raise notice 'QA7 PASS: de-duplication math matches independent recomputation';
end $$;

-- QA8: withheld (uncertain) grades never ship a point score -----------------
do $$
declare v jsonb; bad int;
begin
  perform set_config('request.jwt.claims',
    '{"sub":"76705295-a203-4ce3-a2d4-218183024f05","role":"authenticated"}', true);
  v := public.get_student_progress_dashboard('ap_biology');

  select count(*) into bad
    from jsonb_array_elements(v->'recentActivity') e
   where e->>'gradeState' = 'uncertain'
     and e->'pointsEarned' <> 'null'::jsonb;

  if bad > 0 then
    raise exception 'QA8 FAIL: % uncertain row(s) carry a point score', bad;
  end if;
  raise notice 'QA8 PASS: uncertain grades are withheld, not scored';
end $$;

-- QA9: estimated score respects its evidence floor and boundaries -----------
do $$
declare v jsonb;
begin
  if app.progress_estimated_ap_score(75,100) <> 5
     or app.progress_estimated_ap_score(74,100) <> 4
     or app.progress_estimated_ap_score(60,100) <> 4
     or app.progress_estimated_ap_score(45,100) <> 3
     or app.progress_estimated_ap_score(30,100) <> 2
     or app.progress_estimated_ap_score(0,100)  <> 1 then
    raise exception 'QA9 FAIL: score band boundaries drifted';
  end if;
  if app.progress_estimated_ap_score(5,0) is not null
     or app.progress_estimated_ap_score(null,null) is not null then
    raise exception 'QA9 FAIL: score mapping is not null-safe';
  end if;

  perform set_config('request.jwt.claims',
    '{"sub":"76705295-a203-4ce3-a2d4-218183024f05","role":"authenticated"}', true);
  v := public.get_student_progress_dashboard('ap_biology')->'summary'->'frq';

  -- DECISION-0003 requires evidence minimums, non-official labelling,
  -- disclosed gaps and a next action whenever an estimate is shown.
  if (v->>'estimatedScore1To5') is not null and (v->>'gradedItems')::int < 3 then
    raise exception 'QA9 FAIL: estimate shown below the evidence floor';
  end if;
  if (v->>'isOfficial')::boolean is not false then
    raise exception 'QA9 FAIL: estimate is not labelled non-official';
  end if;
  if coalesce(jsonb_array_length(v->'evidenceGaps'),0) = 0 then
    raise exception 'QA9 FAIL: estimate ships with no disclosed evidence gaps';
  end if;
  if coalesce(v->>'nextAction','') = '' then
    raise exception 'QA9 FAIL: estimate ships with no next action';
  end if;
  raise notice 'QA9 PASS: estimated score honours DECISION-0003 conditions';
end $$;

-- QA-UNITS: units come from the verified taxonomy, with no invented evidence -
do $$
declare v jsonb;
begin
  perform set_config('request.jwt.claims',
    '{"sub":"76705295-a203-4ce3-a2d4-218183024f05","role":"authenticated"}', true);
  v := public.get_student_progress_dashboard('ap_biology');

  if jsonb_array_length(v->'units') = 0 then
    raise exception 'QA-UNITS FAIL: no units returned for a subject with verified taxonomy';
  end if;
  if (v->'summary'->'activity'->>'unitAttributionAvailable')::boolean is not false then
    raise exception 'QA-UNITS FAIL: unit attribution claimed but not available';
  end if;
  if v->'summary'->'activity'->'unitsWithEvidence' <> 'null'::jsonb then
    raise exception 'QA-UNITS FAIL: unitsWithEvidence must be null (uncomputable), not 0';
  end if;
  raise notice 'QA-UNITS PASS: units listed from taxonomy with attribution honestly absent';
end $$;
