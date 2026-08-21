begin;

create or replace function app.normalize_student_subject_key(_subject_key text)
returns text
language sql
immutable
strict
set search_path = pg_catalog
as $$
  select case
    when replace(lower(btrim(_subject_key)), '-', '_') = 'biology'
      then 'ap_biology'
    else replace(lower(btrim(_subject_key)), '-', '_')
  end;
$$;

revoke all on function app.normalize_student_subject_key(text)
  from public, anon, authenticated;
grant execute on function app.normalize_student_subject_key(text)
  to authenticated, service_role;

drop policy if exists topic_point_briefs_select_published
  on app.topic_point_briefs;

create policy topic_point_briefs_select_published
on app.topic_point_briefs
for select
to authenticated
using (
  status = 'published'
  and exists (
    select 1
    from app.subjects s
    where app.normalize_student_subject_key(s.subject_key) = topic_point_briefs.subject_key
      and s.status = 'active'
  )
);

drop policy if exists topic_explainers_select_published
  on app.topic_explainers;

create policy topic_explainers_select_published
on app.topic_explainers
for select
to authenticated
using (
  status = 'published'
  and exists (
    select 1
    from app.subjects s
    where app.normalize_student_subject_key(s.subject_key) = topic_explainers.subject_key
      and s.status = 'active'
  )
);

create or replace function public.get_student_taxonomy(
  _subject_key text default null
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
  v_payload jsonb;
begin
  if v_user_id is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;
  if v_subject_key is not null
     and v_subject_key !~ '^[a-z0-9][a-z0-9_]*$' then
    raise exception 'taxonomy:invalid_subject_key' using errcode = '22023';
  end if;

  with latest_sources as (
    select distinct on (tsv.subject_key)
      tsv.taxonomy_source_version,
      tsv.subject_key,
      tsv.school_year,
      tsv.source_title,
      tsv.taxonomy_confidence,
      tsv.source_citation,
      tsv.verified_at
    from app.taxonomy_source_versions tsv
    where tsv.taxonomy_confidence = 'verified'
      and (v_subject_key is null or tsv.subject_key = v_subject_key)
      and exists (
        select 1
        from app.taxonomy_units tu
        where tu.taxonomy_source_version = tsv.taxonomy_source_version
      )
    order by
      tsv.subject_key,
      tsv.school_year desc,
      tsv.verified_at desc nulls last,
      tsv.created_at desc
  ), subject_rows as (
    select
      latest_sources.*,
      coalesce(
        (
          select s.display_name
          from app.subjects s
          where app.normalize_student_subject_key(s.subject_key) = latest_sources.subject_key
            and s.status = 'active'
          limit 1
        ),
        initcap(replace(latest_sources.subject_key, '_', ' '))
      ) as display_name
    from latest_sources
  )
  select jsonb_build_object(
    'subjects',
    coalesce(
      jsonb_agg(
        jsonb_build_object(
          'subjectKey', sr.subject_key,
          'displayName', sr.display_name,
          'schoolYear', sr.school_year,
          'sourceTitle', sr.source_title,
          'taxonomyConfidence', sr.taxonomy_confidence,
          'verifiedAt', sr.verified_at,
          'units', coalesce((
            select jsonb_agg(
              jsonb_build_object(
                'unitNumber', tu.unit_number,
                'unitTitle', tu.unit_title,
                'isExamAssessed', tu.is_exam_assessed,
                'topics', coalesce((
                  select jsonb_agg(
                    jsonb_build_object(
                      'topicCode', tt.topic_code,
                      'topicTitle', tt.topic_title,
                      'hasPointBrief', exists (
                        select 1
                        from app.topic_point_briefs tpb
                        where tpb.subject_key = sr.subject_key
                          and tpb.topic_code = tt.topic_code
                          and tpb.status = 'published'
                      ),
                      'hasExplainer', exists (
                        select 1
                        from app.topic_explainers te
                        where te.subject_key = sr.subject_key
                          and te.topic_code = tt.topic_code
                          and te.status = 'published'
                      )
                    )
                    order by
                      split_part(tt.topic_code, '.', 1)::integer,
                      split_part(tt.topic_code, '.', 2)::integer
                  )
                  from app.taxonomy_topics tt
                  where tt.taxonomy_source_version = sr.taxonomy_source_version
                    and tt.unit_number = tu.unit_number
                ), '[]'::jsonb)
              )
              order by tu.unit_number
            )
            from app.taxonomy_units tu
            where tu.taxonomy_source_version = sr.taxonomy_source_version
          ), '[]'::jsonb)
        )
        order by sr.display_name
      ),
      '[]'::jsonb
    )
  )
  into v_payload
  from subject_rows sr;

  return coalesce(v_payload, jsonb_build_object('subjects', '[]'::jsonb));
end;
$$;

revoke all on function public.get_student_taxonomy(text) from public, anon;
grant execute on function public.get_student_taxonomy(text)
  to authenticated, service_role;

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

comment on function app.normalize_student_subject_key(text) is
  'Normalizes app subject registry keys and guide/taxonomy keys to the student guide namespace, e.g. ap-calculus-ab -> ap_calculus_ab and biology -> ap_biology.';

commit;
