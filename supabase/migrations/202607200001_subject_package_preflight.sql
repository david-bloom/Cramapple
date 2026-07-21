-- Close the subject-harness ingestion bypass: validate package completeness
-- before a content_item_version insert can project MCQ/FRQ detail rows.

create or replace function app.assert_subject_item_package_preflight()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_payload jsonb := new.prompt_json;
  v_choice jsonb;
  v_criterion jsonb;
  v_choice_count integer := 0;
  v_correct_count integer := 0;
  v_criterion_count integer := 0;
begin
  if v_payload->>'item_type' = 'mcq' then
    if coalesce(pg_catalog.jsonb_typeof(v_payload->'mcq_choices'), 'null') <> 'array' then
      raise exception 'content_preflight:mcq_choices_required';
    end if;
    for v_choice in select value from pg_catalog.jsonb_array_elements(v_payload->'mcq_choices') loop
      v_choice_count := v_choice_count + 1;
      if coalesce((v_choice->>'is_correct')::boolean, false) then
        v_correct_count := v_correct_count + 1;
      end if;
      if nullif(pg_catalog.btrim(v_choice->>'choice_text'), '') is null
        or nullif(pg_catalog.btrim(v_choice->>'rationale'), '') is null then
        raise exception 'content_preflight:mcq_choice_incomplete';
      end if;
    end loop;
    if v_choice_count < 2 or v_correct_count <> 1 then
      raise exception 'content_preflight:mcq_contract_failed';
    end if;
  elsif v_payload->>'item_type' = 'frq' then
    for v_criterion in
      select value from pg_catalog.jsonb_path_query(v_payload, '$.parts.**.criteria[*]')
    loop
      v_criterion_count := v_criterion_count + 1;
      if nullif(pg_catalog.btrim(v_criterion->>'criterion_key'), '') is null
        or nullif(pg_catalog.btrim(v_criterion->>'description'), '') is null
        or nullif(pg_catalog.btrim(v_criterion->>'minimum_fix'), '') is null
        or case
          when coalesce(v_criterion->>'points', '') ~ '^[0-9]+$'
            then (v_criterion->>'points')::integer < 1
          else true
        end
        or pg_catalog.jsonb_array_length(case
          when pg_catalog.jsonb_typeof(v_criterion->'required_evidence') = 'array'
            then v_criterion->'required_evidence'
          else '[]'::jsonb
        end) = 0 then
        raise exception 'content_preflight:frq_criterion_incomplete';
      end if;
    end loop;
    if v_criterion_count = 0 then
      raise exception 'content_preflight:frq_criteria_required';
    end if;
  else
    raise exception 'content_preflight:item_type_invalid';
  end if;
  return new;
end;
$$;

drop trigger if exists content_item_versions_preflight_item_package
  on app.content_item_versions;
create trigger content_item_versions_preflight_item_package
before insert on app.content_item_versions
for each row when (new.item_package_payload is not null)
execute function app.assert_subject_item_package_preflight();

-- Repair rows previously projected from subject packages before minimum_fix
-- was part of the source contract. required_evidence remains the grading
-- boundary; minimum_fix turns that exact boundary into learner-facing next-step
-- coaching instead of the former generic fallback.
with source_criteria as (
  select civ.id as content_item_version_id,
    criterion->>'criterion_key' as criterion_key,
    array_to_string(array(
      select pg_catalog.jsonb_array_elements_text(criterion->'required_evidence')
    ), '; ') as evidence_requirements,
    coalesce(
      nullif(pg_catalog.btrim(criterion->>'minimum_fix'), ''),
      'To earn this point, explicitly show ' || array_to_string(array(
        select pg_catalog.jsonb_array_elements_text(criterion->'required_evidence')
      ), '; ') || '.'
    ) as minimum_fix
  from app.content_item_versions civ
  cross join lateral pg_catalog.jsonb_path_query(
    civ.prompt_json,
    '$.parts.**.criteria[*]'
  ) criterion
  where civ.item_package_payload is not null
)
update app.frq_criteria target
set evidence_requirements = case
      when nullif(pg_catalog.btrim(target.evidence_requirements), '') is null
        then source.evidence_requirements
      else target.evidence_requirements
    end,
    minimum_fix = case
      when nullif(pg_catalog.btrim(target.minimum_fix), '') is null
        then source.minimum_fix
      else target.minimum_fix
    end
from source_criteria source
where target.content_item_version_id = source.content_item_version_id
  and target.criterion_key = source.criterion_key
  and (
    nullif(pg_catalog.btrim(target.evidence_requirements), '') is null
    or nullif(pg_catalog.btrim(target.minimum_fix), '') is null
  );

do $$
begin
  if exists (
    select 1
    from app.frq_criteria criterion
    join app.content_item_versions civ
      on civ.id = criterion.content_item_version_id
    where civ.item_package_payload is not null
      and (
        nullif(pg_catalog.btrim(criterion.learner_facing_text), '') is null
        or nullif(pg_catalog.btrim(criterion.evidence_requirements), '') is null
        or nullif(pg_catalog.btrim(criterion.minimum_fix), '') is null
        or criterion.points_possible is null
        or criterion.points_possible < 1
        or criterion.points_possible <> pg_catalog.trunc(criterion.points_possible)
      )
  ) then
    raise exception 'content_preflight:legacy_subject_rows_still_incomplete';
  end if;
end;
$$;

-- Projection must preserve the authored coaching contract. The old fallback
-- made every minimum_fix identical and allowed source packages to omit it.
create or replace function app.project_item_package_details()
returns trigger language plpgsql security invoker set search_path = '' as $$
declare
  v_choice jsonb;
  v_criterion jsonb;
  v_answers jsonb := coalesce(new.prompt_json->'canonical_answers', '[]'::jsonb);
begin
  update app.content_item_versions
  set canonical_answer_1 = v_answers->>0,
      canonical_answer_2 = v_answers->>1,
      rubric_type = case when new.prompt_json->>'item_type' = 'frq' then 'criterion' else rubric_type end,
      evaluator_strategy = case when new.prompt_json->>'item_type' = 'mcq' then 'mcq-key' else 'science-frq-rubric' end
  where id = new.id;

  for v_choice in select value from jsonb_array_elements(coalesce(new.prompt_json->'mcq_choices','[]'::jsonb)) loop
    insert into app.mcq_choices(content_item_version_id,choice_key,choice_text,is_correct,rationale)
    values(new.id,v_choice->>'choice_key',v_choice->>'choice_text',(v_choice->>'is_correct')::boolean,v_choice->>'rationale')
    on conflict(content_item_version_id,choice_key) do nothing;
  end loop;

  for v_criterion in
    select value from jsonb_path_query(new.prompt_json, '$.parts.**.criteria[*]')
  loop
    insert into app.frq_criteria(
      content_item_version_id,criterion_key,learner_facing_text,points_possible,
      evidence_requirements,minimum_fix,accepted_variants
    )
    select new.id,v_criterion->>'criterion_key',v_criterion->>'description',
      (v_criterion->>'points')::integer,
      array_to_string(array(select jsonb_array_elements_text(v_criterion->'required_evidence')), '; '),
      v_criterion->>'minimum_fix',
      coalesce(v_criterion->'accepted_variants','[]'::jsonb)
    where new.prompt_json->>'item_type' = 'frq'
    on conflict(content_item_version_id,criterion_key) do nothing;
  end loop;
  return null;
end;
$$;
