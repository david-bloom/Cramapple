-- Topic guide database QA
--
-- Purpose:
--   Verify the Production/Development Supabase database changes for the new
--   Topic Point Briefs and Topic Explainers surfaces used by Lovable.
--
-- Safe to run:
--   This script is read-only against persistent data. It uses a transaction,
--   temporary tables, SET LOCAL ROLE, and ROLLBACK.
--
-- Example:
--   supabase db query --linked \
--     --file scripts/qa/topic_guides_database_qa.sql \
--     --workdir /Users/davidbloom/Documents/Cramapple

begin;

create temporary table topic_guides_qa_profile (
  user_id uuid primary key
) on commit drop;

insert into topic_guides_qa_profile (user_id)
select p.user_id
from app.profiles p
order by p.created_at
limit 1;

grant select on topic_guides_qa_profile to authenticated;

do $$
declare
  v_public_brief_count integer;
  v_public_explainer_count integer;
  v_app_brief_count integer;
  v_app_explainer_count integer;
  v_missing_columns text[];
  v_error text;
begin
  raise notice 'QA 1: required relations exist';

  if to_regclass('app.topic_point_briefs') is null then
    raise exception 'missing app.topic_point_briefs';
  end if;

  if to_regclass('app.topic_explainers') is null then
    raise exception 'missing app.topic_explainers';
  end if;

  if to_regclass('public.topic_point_briefs') is null then
    raise exception 'missing public.topic_point_briefs';
  end if;

  if to_regclass('public.topic_explainers') is null then
    raise exception 'missing public.topic_explainers';
  end if;

  if not exists (select 1 from topic_guides_qa_profile) then
    raise exception 'QA requires at least one app.profiles row to simulate an authenticated student';
  end if;

  raise notice 'QA 2: expected source and public row counts';

  select count(*) into v_app_brief_count
  from app.topic_point_briefs
  where status = 'published';

  select count(*) into v_app_explainer_count
  from app.topic_explainers
  where status = 'published';

  select count(*) into v_public_brief_count
  from public.topic_point_briefs;

  select count(*) into v_public_explainer_count
  from public.topic_explainers;

  if v_app_brief_count <> 306 or v_public_brief_count <> 306 then
    raise exception 'expected 306 source/service-visible published topic point briefs, got app=% public=%',
      v_app_brief_count,
      v_public_brief_count;
  end if;

  if v_app_explainer_count <> 306 or v_public_explainer_count <> 306 then
    raise exception 'expected 306 source/service-visible published topic explainers, got app=% public=%',
      v_app_explainer_count,
      v_public_explainer_count;
  end if;

  if exists (
    select 1
    from app.topic_point_briefs app_brief
    left join app.topic_explainers app_explainer
      on app_explainer.subject_key = app_brief.subject_key
     and app_explainer.topic_code = app_brief.topic_code
     and app_explainer.status = 'published'
    where app_brief.status = 'published'
      and app_explainer.topic_explainer_id is null
  ) then
    raise exception 'a published topic point brief is missing a published topic explainer';
  end if;

  if exists (
    select 1
    from app.topic_explainers app_explainer
    left join app.topic_point_briefs app_brief
      on app_brief.subject_key = app_explainer.subject_key
     and app_brief.topic_code = app_explainer.topic_code
     and app_brief.status = 'published'
    where app_explainer.status = 'published'
      and app_brief.topic_point_brief_id is null
  ) then
    raise exception 'a published topic explainer has no matching published topic point brief';
  end if;

  raise notice 'QA 3: expected subject/unit distribution';

  if (
    select count(*)
    from public.topic_point_briefs
    where subject_key = 'ap-calculus-ab'
      and canonical_subject_key = 'ap_calculus_ab'
  ) <> 85 then
    raise exception 'expected 85 AP Calculus AB public topic point briefs';
  end if;

  if (
    select count(*)
    from public.topic_explainers
    where subject_key = 'ap-calculus-ab'
      and canonical_subject_key = 'ap_calculus_ab'
      and unit_number = 1
  ) <> 16 then
    raise exception 'expected 16 AP Calculus AB Unit 1 public topic explainers';
  end if;

  if (
    select count(*)
    from public.topic_point_briefs
    where subject_key = 'biology'
      and canonical_subject_key = 'ap_biology'
  ) <> 60 then
    raise exception 'expected 60 AP Biology public topic point briefs';
  end if;

  if (
    select count(*)
    from public.topic_point_briefs
    where subject_key = 'ap-calculus-bc'
      and canonical_subject_key = 'ap_calculus_bc'
      and unit_number = 1
  ) <> 16 then
    raise exception 'expected 16 AP Calculus BC Unit 1 public topic point briefs';
  end if;

  if (
    select count(*)
    from public.topic_point_briefs
    where subject_key = 'ap-precalculus'
      and canonical_subject_key = 'ap_precalculus'
      and unit_number = 1
  ) <> 14 then
    raise exception 'expected 14 AP Precalculus Unit 1 public topic point briefs';
  end if;

  if (
    select count(*)
    from public.topic_explainers
    where subject_key = 'ap-calculus-ab'
      and canonical_subject_key = 'ap_calculus_ab'
  ) <> 85 then
    raise exception 'expected 85 AP Calculus AB public topic explainers';
  end if;

  if (
    select count(*)
    from public.topic_explainers
    where subject_key = 'biology'
      and canonical_subject_key = 'ap_biology'
  ) <> 60 then
    raise exception 'expected 60 AP Biology public topic explainers';
  end if;

  if (
    select count(*)
    from public.topic_point_briefs
    where subject_key = 'ap-chemistry'
      and canonical_subject_key = 'ap_chemistry'
      and unit_number = 1
  ) <> 8 then
    raise exception 'expected 8 AP Chemistry Unit 1 public topic point briefs';
  end if;

  if (
    select count(*)
    from public.topic_explainers
    where subject_key = 'ap-chemistry'
      and canonical_subject_key = 'ap_chemistry'
      and unit_number = 1
  ) <> 8 then
    raise exception 'expected 8 AP Chemistry Unit 1 public topic explainers';
  end if;

  if (
    select count(*)
    from public.topic_point_briefs
    where subject_key = 'ap-statistics'
      and canonical_subject_key = 'ap_statistics'
      and unit_number = 1
  ) <> 13 then
    raise exception 'expected 13 AP Statistics Unit 1 public topic point briefs';
  end if;

  if (
    select count(*)
    from public.topic_explainers
    where subject_key = 'ap-statistics'
      and canonical_subject_key = 'ap_statistics'
      and unit_number = 1
  ) <> 13 then
    raise exception 'expected 13 AP Statistics Unit 1 public topic explainers';
  end if;

  raise notice 'QA 4: Lovable-facing public view column contract';

  select array_agg(expected_column order by expected_column)
  into v_missing_columns
  from (
    values
      ('id'),
      ('subject_key'),
      ('unit_number'),
      ('unit_id'),
      ('topic_id'),
      ('title'),
      ('class_importance'),
      ('exam_importance'),
      ('what_it_is'),
      ('why_it_matters'),
      ('how_points_are_earned'),
      ('answer_move'),
      ('common_point_loss'),
      ('learn_more_path'),
      ('practice_subject_key'),
      ('practice_unit_number'),
      ('practice_topic_code'),
      ('practice_params'),
      ('created_at'),
      ('updated_at'),
      ('published_at'),
      ('topic_sort_major'),
      ('topic_sort_minor'),
      ('topic_sort_key'),
      ('canonical_subject_key')
  ) as expected(expected_column)
  where not exists (
    select 1
    from information_schema.columns c
    where c.table_schema = 'public'
      and c.table_name = 'topic_point_briefs'
      and c.column_name = expected.expected_column
  );

  if coalesce(array_length(v_missing_columns, 1), 0) > 0 then
    raise exception 'public.topic_point_briefs missing expected columns: %',
      v_missing_columns;
  end if;

  select array_agg(expected_column order by expected_column)
  into v_missing_columns
  from (
    values
      ('id'),
      ('subject_key'),
      ('unit_number'),
      ('unit_id'),
      ('topic_id'),
      ('title'),
      ('core_idea'),
      ('what_students_need_to_understand'),
      ('how_this_becomes_points'),
      ('answer_move'),
      ('mini_example_question'),
      ('weak_answer'),
      ('point_attaining_answer'),
      ('common_point_loss'),
      ('practice_bridge'),
      ('mini_example'),
      ('created_at'),
      ('updated_at'),
      ('published_at'),
      ('topic_sort_major'),
      ('topic_sort_minor'),
      ('topic_sort_key'),
      ('canonical_subject_key')
  ) as expected(expected_column)
  where not exists (
    select 1
    from information_schema.columns c
    where c.table_schema = 'public'
      and c.table_name = 'topic_explainers'
      and c.column_name = expected.expected_column
  );

  if coalesce(array_length(v_missing_columns, 1), 0) > 0 then
    raise exception 'public.topic_explainers missing expected columns: %',
      v_missing_columns;
  end if;

  raise notice 'QA 5: representative row shape';

  if not exists (
    select 1
    from public.topic_point_briefs
    where subject_key = 'ap-calculus-ab'
      and canonical_subject_key = 'ap_calculus_ab'
      and unit_number = 1
      and topic_id = '1.1'
      and unit_id = 'unit-1'
      and topic_sort_major = 1
      and topic_sort_minor = 1
      and topic_sort_key = 1001
      and class_importance in ('not-important', 'somewhat-important', 'very-important')
      and exam_importance in ('not-important', 'somewhat-important', 'very-important')
      and learn_more_path = '/learn/ap-calculus-ab/unit-1/instantaneous-change'
      and practice_params = jsonb_build_object(
        'subject', 'ap_calculus_ab',
        'unit', '1',
        'topic', '1.1'
      )
  ) then
    raise exception 'AP Calculus AB 1.1 public topic point brief shape is wrong';
  end if;

  if not exists (
    select 1
    from public.topic_explainers
    where subject_key = 'ap-calculus-ab'
      and canonical_subject_key = 'ap_calculus_ab'
      and unit_number = 1
      and topic_id = '1.1'
      and unit_id = 'unit-1'
      and topic_sort_major = 1
      and topic_sort_minor = 1
      and topic_sort_key = 1001
      and mini_example ? 'question'
      and mini_example ? 'weakAnswer'
      and mini_example ? 'pointAttainingAnswer'
  ) then
    raise exception 'AP Calculus AB 1.1 public topic explainer shape is wrong';
  end if;

  raise notice 'QA 6: published-only public views';

  if exists (
    select 1
    from app.topic_point_briefs app_brief
    left join public.topic_point_briefs public_brief
      on public_brief.id = app_brief.topic_point_brief_id
    where app_brief.status = 'published'
      and public_brief.id is null
  ) then
    raise exception 'a published app.topic_point_briefs row is missing from public.topic_point_briefs';
  end if;

  if exists (
    select 1
    from public.topic_point_briefs public_brief
    join app.topic_point_briefs app_brief
      on app_brief.topic_point_brief_id = public_brief.id
    where app_brief.status <> 'published'
  ) then
    raise exception 'public.topic_point_briefs exposed a non-published row';
  end if;

  if exists (
    select 1
    from public.topic_explainers public_explainer
    join app.topic_explainers app_explainer
      on app_explainer.topic_explainer_id = public_explainer.id
    where app_explainer.status <> 'published'
  ) then
    raise exception 'public.topic_explainers exposed a non-published row';
  end if;

  raise notice 'QA 7: direct grants are read-only and authenticated-only';

  if has_table_privilege('anon', 'public.topic_point_briefs', 'SELECT')
     or has_table_privilege('anon', 'public.topic_explainers', 'SELECT') then
    raise exception 'anon should not have SELECT on public topic guide views';
  end if;

  if not has_table_privilege('authenticated', 'public.topic_point_briefs', 'SELECT')
     or not has_table_privilege('authenticated', 'public.topic_explainers', 'SELECT') then
    raise exception 'authenticated should have SELECT on public topic guide views';
  end if;

  if has_table_privilege('authenticated', 'public.topic_point_briefs', 'INSERT')
     or has_table_privilege('authenticated', 'public.topic_point_briefs', 'UPDATE')
     or has_table_privilege('authenticated', 'public.topic_point_briefs', 'DELETE')
     or has_table_privilege('authenticated', 'public.topic_explainers', 'INSERT')
     or has_table_privilege('authenticated', 'public.topic_explainers', 'UPDATE')
     or has_table_privilege('authenticated', 'public.topic_explainers', 'DELETE') then
    raise exception 'authenticated should have SELECT-only access to public topic guide views';
  end if;

  raise notice 'QA 8: RPCs enforce authentication';

  begin
    perform public.get_student_taxonomy('ap_calculus_ab');
  exception
    when sqlstate '28000' then
      v_error := 'not_authenticated';
  end;

  if v_error is distinct from 'not_authenticated' then
    raise exception 'expected get_student_taxonomy to reject unauthenticated calls, got %',
      coalesce(v_error, '<no error>');
  end if;

  v_error := null;

  begin
    perform public.get_topic_point_guides('ap_calculus_ab', 1, null);
  exception
    when sqlstate '28000' then
      v_error := 'not_authenticated';
  end;

  if v_error is distinct from 'not_authenticated' then
    raise exception 'expected get_topic_point_guides to reject unauthenticated calls, got %',
      coalesce(v_error, '<no error>');
  end if;
end;
$$;

select set_config(
  'request.jwt.claims',
  json_build_object(
    'sub', (select user_id from topic_guides_qa_profile limit 1),
    'role', 'authenticated'
  )::text,
  true
);
set local role authenticated;

do $$
declare
  v_payload jsonb;
  v_has_taxonomy_registry boolean;
begin
  raise notice 'QA 9: public views return rows as an authenticated student';

  if (
    select count(*)
    from public.topic_point_briefs
  ) <> 306 then
    raise exception 'expected authenticated student to see 306 release-gated public topic point briefs';
  end if;

  if (
    select count(*)
    from public.topic_explainers
  ) <> 306 then
    raise exception 'expected authenticated student to see 306 release-gated public topic explainers';
  end if;

  if (
    select count(*)
    from public.topic_point_briefs
    where subject_key = 'ap-calculus-ab'
      and canonical_subject_key = 'ap_calculus_ab'
  ) <> 85 then
    raise exception 'expected authenticated student to see 85 AP Calculus AB public briefs';
  end if;

  if (
    select count(*)
    from public.topic_explainers
    where subject_key = 'ap-calculus-ab'
      and canonical_subject_key = 'ap_calculus_ab'
  ) <> 85 then
    raise exception 'expected authenticated student to see 85 AP Calculus AB public explainers';
  end if;

  if (
    select count(*)
    from public.topic_point_briefs
    where subject_key = 'biology'
      and canonical_subject_key = 'ap_biology'
  ) <> 60 then
    raise exception 'expected authenticated student to see 60 AP Biology public briefs';
  end if;

  if (
    select count(*)
    from public.topic_explainers
    where subject_key = 'biology'
      and canonical_subject_key = 'ap_biology'
  ) <> 60 then
    raise exception 'expected authenticated student to see 60 AP Biology public explainers';
  end if;

  if (
    select count(*)
    from public.topic_point_briefs
    where subject_key = 'ap-chemistry'
      and canonical_subject_key = 'ap_chemistry'
      and unit_number = 1
  ) <> 8 then
    raise exception 'expected authenticated student to see 8 AP Chemistry Unit 1 public briefs';
  end if;

  if (
    select count(*)
    from public.topic_explainers
    where subject_key = 'ap-chemistry'
      and canonical_subject_key = 'ap_chemistry'
      and unit_number = 1
  ) <> 8 then
    raise exception 'expected authenticated student to see 8 AP Chemistry Unit 1 public explainers';
  end if;

  if (
    select count(*)
    from public.topic_point_briefs
    where subject_key = 'ap-statistics'
      and canonical_subject_key = 'ap_statistics'
      and unit_number = 1
  ) <> 13 then
    raise exception 'expected authenticated student to see 13 AP Statistics Unit 1 public briefs';
  end if;

  if (
    select count(*)
    from public.topic_explainers
    where subject_key = 'ap-statistics'
      and canonical_subject_key = 'ap_statistics'
      and unit_number = 1
  ) <> 13 then
    raise exception 'expected authenticated student to see 13 AP Statistics Unit 1 public explainers';
  end if;

  if (
    select count(*)
    from public.topic_point_briefs
    where subject_key = 'ap-calculus-bc'
      and canonical_subject_key = 'ap_calculus_bc'
      and unit_number = 1
  ) <> 16 then
    raise exception 'expected authenticated student to see 16 AP Calculus BC Unit 1 public briefs';
  end if;

  if (
    select count(*)
    from public.topic_point_briefs
    where subject_key = 'ap-precalculus'
      and canonical_subject_key = 'ap_precalculus'
      and unit_number = 1
  ) <> 14 then
    raise exception 'expected authenticated student to see 14 AP Precalculus Unit 1 public briefs';
  end if;

  if not exists (
    select 1
    from public.topic_point_briefs
    where subject_key = 'ap-calculus-ab'
      and canonical_subject_key = 'ap_calculus_ab'
      and unit_number = 1
      and topic_id = '1.1'
      and topic_sort_key = 1001
      and practice_params = jsonb_build_object(
        'subject', 'ap_calculus_ab',
        'unit', '1',
        'topic', '1.1'
      )
  ) then
    raise exception 'authenticated student cannot see the AP Calculus AB 1.1 public brief';
  end if;

  if (
    select array_agg(topic_id order by unit_number, topic_sort_major, topic_sort_minor)
    from public.topic_point_briefs
    where subject_key = 'ap-calculus-ab'
      and canonical_subject_key = 'ap_calculus_ab'
      and unit_number = 1
      and topic_id in ('1.1', '1.2', '1.10')
  ) <> array['1.1', '1.2', '1.10']::text[] then
    raise exception 'topic sort fields do not produce numeric topic order';
  end if;

  raise notice 'QA 10: RPCs return expected authenticated payloads';

  v_has_taxonomy_registry :=
    to_regclass('app.taxonomy_source_versions') is not null
    and to_regclass('app.taxonomy_units') is not null
    and to_regclass('app.taxonomy_topics') is not null;

  if v_has_taxonomy_registry then
    v_payload := public.get_student_taxonomy('ap_calculus_ab');

    if jsonb_array_length(v_payload->'subjects') <> 1 then
      raise exception 'expected one AP Calculus AB taxonomy subject, got %',
        v_payload;
    end if;

    if jsonb_array_length(v_payload #> '{subjects,0,units,0,topics}') <> 16 then
      raise exception 'expected 16 AP Calculus AB Unit 1 topics, got %',
        v_payload #> '{subjects,0,units,0,topics}';
    end if;

    if coalesce((v_payload #>> '{subjects,0,units,0,topics,0,hasPointBrief}')::boolean, false) is not true then
      raise exception 'expected AP Calculus AB topic 1.1 to advertise hasPointBrief';
    end if;

    v_payload := public.get_student_taxonomy('ap-calculus-ab');

    if jsonb_array_length(v_payload->'subjects') <> 1 then
      raise exception 'expected hyphenated AP Calculus AB taxonomy key to normalize, got %',
        v_payload;
    end if;
  else
    raise notice 'QA 10: skipping taxonomy RPC checks because taxonomy registry tables are absent in this environment';
  end if;

  v_payload := public.get_topic_point_guides('ap_calculus_ab', 1, null);

  if jsonb_array_length(v_payload->'briefs') <> 16 then
    raise exception 'expected get_topic_point_guides to return 16 Calc AB Unit 1 briefs, got %',
      jsonb_array_length(v_payload->'briefs');
  end if;

  if jsonb_array_length(v_payload->'explainers') <> 16 then
    raise exception 'expected get_topic_point_guides to return 16 Calc AB Unit 1 explainers, got %',
      jsonb_array_length(v_payload->'explainers');
  end if;

  v_payload := public.get_topic_point_guides('ap-calculus-ab', 1, null);

  if jsonb_array_length(v_payload->'briefs') <> 16
     or jsonb_array_length(v_payload->'explainers') <> 16 then
    raise exception 'expected hyphenated AP Calculus AB guide key to normalize, got %',
      v_payload;
  end if;

  v_payload := public.get_topic_point_guides('ap_calculus_ab', 2, '2.1');

  if jsonb_array_length(v_payload->'briefs') <> 1
     or jsonb_array_length(v_payload->'explainers') <> 1 then
    raise exception 'expected one brief and one explainer for Calc AB topic 2.1, got %',
      v_payload;
  end if;

  v_payload := public.get_topic_point_guides('ap_biology', 1, null);

  if jsonb_array_length(v_payload->'briefs') <> 7 then
    raise exception 'expected get_topic_point_guides to return 7 AP Biology Unit 1 briefs, got %',
      jsonb_array_length(v_payload->'briefs');
  end if;

  if jsonb_array_length(v_payload->'explainers') <> 7 then
    raise exception 'expected get_topic_point_guides to return 7 AP Biology Unit 1 explainers, got %',
      jsonb_array_length(v_payload->'explainers');
  end if;

  v_payload := public.get_topic_point_guides('ap_biology', 8, '8.7');

  if jsonb_array_length(v_payload->'briefs') <> 1
     or jsonb_array_length(v_payload->'explainers') <> 1 then
    raise exception 'expected one brief and one explainer for AP Biology topic 8.7, got %',
      v_payload;
  end if;

  v_payload := public.get_topic_point_guides('ap-chemistry', 1, null);

  if jsonb_array_length(v_payload->'briefs') <> 8
     or jsonb_array_length(v_payload->'explainers') <> 8 then
    raise exception 'expected 8 briefs and 8 explainers for AP Chemistry Unit 1, got %',
      v_payload;
  end if;

  v_payload := public.get_topic_point_guides('ap-statistics', 1, null);

  if jsonb_array_length(v_payload->'briefs') <> 13
     or jsonb_array_length(v_payload->'explainers') <> 13 then
    raise exception 'expected 13 briefs and 13 explainers for AP Statistics Unit 1, got %',
      v_payload;
  end if;

  v_payload := public.get_topic_point_guides('ap-calculus-bc', 1, null);

  if jsonb_array_length(v_payload->'briefs') <> 16
     or jsonb_array_length(v_payload->'explainers') <> 16 then
    raise exception 'expected 16 briefs and 16 explainers for AP Calculus BC Unit 1, got %',
      v_payload;
  end if;

  v_payload := public.get_topic_point_guides('ap-precalculus', 1, null);

  if jsonb_array_length(v_payload->'briefs') <> 14
     or jsonb_array_length(v_payload->'explainers') <> 14 then
    raise exception 'expected 14 briefs and 14 explainers for AP Precalculus Unit 1, got %',
      v_payload;
  end if;

  v_payload := public.get_topic_point_guides('biology', 1, null);

  if jsonb_array_length(v_payload->'briefs') <> 7
     or jsonb_array_length(v_payload->'explainers') <> 7 then
    raise exception 'expected registry Biology guide key to normalize, got %',
      v_payload;
  end if;

  begin
    perform public.get_student_taxonomy('missing subject');
    raise exception 'invalid subject key unexpectedly succeeded';
  exception
    when sqlstate '22023' then null;
  end;

  raise notice 'QA PASS: topic guide database changes are working correctly';
end;
$$;

reset role;

rollback;
