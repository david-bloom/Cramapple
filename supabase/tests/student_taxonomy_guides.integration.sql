-- Student taxonomy and topic guide API verification.
--
-- Run after applying 20260820192400_student_readable_taxonomy_and_topic_guides.
-- The transaction rolls back every fixture-independent check.

begin;

create temporary table student_taxonomy_guides_ids (
  key text primary key,
  id uuid not null
) on commit drop;

insert into student_taxonomy_guides_ids (key, id)
select 'user', user_id
from app.profiles
order by created_at
limit 1;

grant select on student_taxonomy_guides_ids to authenticated;

do $$
begin
  if not exists (select 1 from student_taxonomy_guides_ids where key = 'user') then
    raise exception 'student_taxonomy_guides test requires at least one profile';
  end if;
end;
$$;

select set_config(
  'request.jwt.claims',
  json_build_object(
    'sub', (select id from student_taxonomy_guides_ids where key = 'user'),
    'role', 'authenticated'
  )::text,
  true
);
set local role authenticated;

do $$
declare
  v_taxonomy jsonb;
  v_guides jsonb;
begin
  v_taxonomy := public.get_student_taxonomy('ap_calculus_ab');
  if jsonb_array_length(v_taxonomy->'subjects') <> 1 then
    raise exception 'expected one AP Calculus AB taxonomy subject, got %', v_taxonomy;
  end if;

  if jsonb_array_length(v_taxonomy #> '{subjects,0,units}') < 8 then
    raise exception 'expected AP Calculus AB unit taxonomy, got %', v_taxonomy #> '{subjects,0,units}';
  end if;

  if jsonb_array_length(v_taxonomy #> '{subjects,0,units,0,topics}') <> 16 then
    raise exception 'expected 16 Unit 1 AP Calculus AB topics, got %', v_taxonomy #> '{subjects,0,units,0,topics}';
  end if;

  if coalesce((v_taxonomy #>> '{subjects,0,units,0,topics,0,hasPointBrief}')::boolean, false) is not true then
    raise exception 'expected AP Calculus AB topic 1.1 to advertise a point brief';
  end if;

  v_guides := public.get_topic_point_guides('ap_calculus_ab', 1, null);
  if jsonb_array_length(v_guides->'briefs') <> 16 then
    raise exception 'expected 16 published Unit 1 briefs, got %', jsonb_array_length(v_guides->'briefs');
  end if;
  if jsonb_array_length(v_guides->'explainers') <> 16 then
    raise exception 'expected 16 published Unit 1 explainers, got %', jsonb_array_length(v_guides->'explainers');
  end if;

  if (
    select count(*)
    from public.topic_point_briefs
    where subject_key = 'ap-calculus-ab'
      and canonical_subject_key = 'ap_calculus_ab'
      and unit_number = 1
  ) <> 16 then
    raise exception 'expected public.topic_point_briefs to expose 16 AP Calculus AB Unit 1 rows';
  end if;

  if (
    select count(*)
    from public.topic_explainers
    where subject_key = 'ap-calculus-ab'
      and canonical_subject_key = 'ap_calculus_ab'
      and unit_number = 1
  ) <> 16 then
    raise exception 'expected public.topic_explainers to expose 16 AP Calculus AB Unit 1 rows';
  end if;

  v_guides := public.get_topic_point_guides('ap_calculus_ab', 2, '2.1');
  if jsonb_array_length(v_guides->'briefs') <> 1
     or jsonb_array_length(v_guides->'explainers') <> 1 then
    raise exception 'expected one guide pair for topic 2.1, got %', v_guides;
  end if;

  v_taxonomy := public.get_student_taxonomy('ap_biology');
  if jsonb_array_length(v_taxonomy->'subjects') <> 1 then
    raise exception 'expected one AP Biology taxonomy subject, got %', v_taxonomy;
  end if;

  if jsonb_array_length(v_taxonomy #> '{subjects,0,units,0,topics}') <> 7 then
    raise exception 'expected 7 Unit 1 AP Biology topics, got %', v_taxonomy #> '{subjects,0,units,0,topics}';
  end if;

  if coalesce((v_taxonomy #>> '{subjects,0,units,0,topics,0,hasPointBrief}')::boolean, false) is not true then
    raise exception 'expected AP Biology topic 1.1 to advertise a point brief';
  end if;

  v_guides := public.get_topic_point_guides('ap_biology', 1, null);
  if jsonb_array_length(v_guides->'briefs') <> 7 then
    raise exception 'expected 7 published AP Biology Unit 1 briefs, got %', jsonb_array_length(v_guides->'briefs');
  end if;
  if jsonb_array_length(v_guides->'explainers') <> 7 then
    raise exception 'expected 7 AP Biology Unit 1 explainers, got %', jsonb_array_length(v_guides->'explainers');
  end if;

  if (
    select count(*)
    from public.topic_point_briefs
    where subject_key = 'biology'
      and canonical_subject_key = 'ap_biology'
      and unit_number = 1
  ) <> 7 then
    raise exception 'expected public.topic_point_briefs to expose 7 AP Biology Unit 1 rows';
  end if;

  begin
    perform public.get_student_taxonomy('missing subject');
    raise exception 'invalid subject key unexpectedly succeeded';
  exception
    when sqlstate '22023' then null;
  end;
end;
$$;

reset role;

rollback;
