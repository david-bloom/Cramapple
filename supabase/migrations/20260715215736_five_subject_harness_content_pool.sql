-- Five-subject draft content projection and unclaimed Tutor review pools.
-- Dev application only; this migration creates no publication path.

insert into app.platform_capabilities(capability_kind, capability_code, support_status)
values ('grader', 'science-frq-rubric', 'supported')
on conflict (capability_kind, capability_code) do nothing;

create table app.content_review_batches (
  content_review_batch_id uuid primary key default gen_random_uuid(),
  batch_key text not null unique,
  exam_pack_version_id uuid not null references app.exam_pack_versions(id) on delete cascade,
  subject_id uuid not null references app.subjects(id) on delete cascade,
  status text not null default 'open' check (status in ('draft','open','closed')),
  review_stage text not null default 'tutor_question' check (review_stage in (
    'tutor_question','tutor_answer','tutor_frq_canonical','reader_question'
  )),
  target_mcq_count integer not null check (target_mcq_count >= 0),
  target_frq_count integer not null check (target_frq_count >= 0),
  created_by uuid not null references app.profiles(user_id),
  created_at timestamptz not null default now(),
  closed_at timestamptz,
  constraint content_review_batches_close_state check (
    (status = 'closed' and closed_at is not null) or
    (status <> 'closed' and closed_at is null)
  )
);

create index content_review_batches_pack_status_idx
  on app.content_review_batches(exam_pack_version_id, status);

create table app.content_review_pool_items (
  content_review_pool_item_id uuid primary key default gen_random_uuid(),
  content_review_batch_id uuid not null references app.content_review_batches(content_review_batch_id) on delete cascade,
  content_item_version_id uuid not null references app.content_item_versions(id) on delete cascade,
  item_type text not null check (item_type in ('mcq','frq')),
  pool_ordinal integer not null check (pool_ordinal > 0),
  claimed_assignment_id uuid unique references app.content_review_assignments(content_review_assignment_id) on delete restrict,
  created_at timestamptz not null default now(),
  unique(content_review_batch_id, content_item_version_id),
  unique(content_review_batch_id, pool_ordinal)
);

create index content_review_pool_items_unclaimed_idx
  on app.content_review_pool_items(content_review_batch_id, item_type, pool_ordinal)
  where claimed_assignment_id is null;

alter table app.content_review_batches enable row level security;
alter table app.content_review_pool_items enable row level security;
grant select, insert, update, delete on app.content_review_batches to service_role;
grant select, insert, update, delete on app.content_review_pool_items to service_role;

create or replace function app.enforce_content_items_frq_form()
returns trigger language plpgsql security invoker set search_path = '' as $$
declare
  v_plan jsonb;
  v_package jsonb;
begin
  if new.item_type = 'frq' and new.frq_form is null then
    v_plan := nullif(pg_catalog.current_setting('app.subject_harness_plan', true), '')::jsonb;
    select candidate->'package' into v_package
    from jsonb_array_elements(coalesce(v_plan->'items', '[]'::jsonb)) candidate
    where candidate#>>'{package,content_key}' = new.content_key
    limit 1;
    new.frq_form := v_package->>'frq_form';
  end if;
  if new.item_type = 'frq' and new.frq_form not in ('short','long') then
    raise exception 'content_items:frq_form_required';
  end if;
  if new.item_type <> 'frq' and new.frq_form is not null then
    raise exception 'content_items:frq_form_only_for_frq';
  end if;
  return new;
end;
$$;

alter function app.apply_subject_package_atomic(jsonb,uuid,text,text)
  rename to apply_subject_package_atomic_v1;

create function app.apply_subject_package_atomic(
  p_compiled_plan jsonb,
  p_actor_id uuid,
  p_environment text,
  p_approval_id text default null
) returns jsonb
language plpgsql security invoker set search_path = '' as $$
begin
  perform pg_catalog.set_config('app.subject_harness_plan', p_compiled_plan::text, true);
  return app.apply_subject_package_atomic_v1(
    p_compiled_plan, p_actor_id, p_environment, p_approval_id
  );
end;
$$;

revoke all on function app.apply_subject_package_atomic_v1(jsonb,uuid,text,text) from public,anon,authenticated;
revoke all on function app.apply_subject_package_atomic(jsonb,uuid,text,text) from public,anon,authenticated;
grant execute on function app.apply_subject_package_atomic(jsonb,uuid,text,text) to service_role;

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
      'Add the missing evidence identified by this criterion.',
      coalesce(v_criterion->'accepted_variants','[]'::jsonb)
    where new.prompt_json->>'item_type' = 'frq'
    on conflict(content_item_version_id,criterion_key) do nothing;
  end loop;
  return null;
end;
$$;

create trigger content_item_versions_project_item_package_details
after insert on app.content_item_versions
for each row when (new.item_package_payload is not null)
execute function app.project_item_package_details();

create or replace function app.create_five_subject_review_pool(
  p_exam_pack_version_id uuid,
  p_batch_key text,
  p_actor_id uuid
) returns uuid
language plpgsql security invoker set search_path = '' as $$
declare
  v_batch_id uuid;
  v_subject_id uuid;
begin
  if not exists(select 1 from app.profiles where user_id=p_actor_id and role='admin') then
    raise exception 'review_pool:admin_actor_required';
  end if;
  select ep.subject_id into v_subject_id
  from app.exam_pack_versions epv join app.exam_packs ep on ep.id=epv.exam_pack_id
  where epv.id=p_exam_pack_version_id and epv.status='draft';
  if v_subject_id is null then raise exception 'review_pool:draft_pack_required'; end if;

  insert into app.content_review_batches(
    batch_key,exam_pack_version_id,subject_id,status,review_stage,
    target_mcq_count,target_frq_count,created_by
  ) values(p_batch_key,p_exam_pack_version_id,v_subject_id,'open','tutor_question',10,10,p_actor_id)
  on conflict(batch_key) do update set batch_key=excluded.batch_key
  returning content_review_batch_id into v_batch_id;

  insert into app.content_review_pool_items(
    content_review_batch_id,content_item_version_id,item_type,pool_ordinal
  )
  select v_batch_id, ranked.id, ranked.item_type, ranked.pool_ordinal
  from (
    select civ.id,ci.item_type,
      row_number() over(order by case ci.item_type when 'mcq' then 0 else 1 end,ci.content_key)::integer pool_ordinal,
      row_number() over(partition by ci.item_type order by ci.content_key) type_ordinal
    from app.content_item_versions civ
    join app.content_items ci on ci.id=civ.content_item_id
    where ci.exam_pack_version_id=p_exam_pack_version_id
      and ci.status='draft' and civ.status='draft' and ci.item_type in ('mcq','frq')
  ) ranked
  where ranked.type_ordinal <= 10
  on conflict(content_review_batch_id,content_item_version_id) do nothing;

  if (select count(*) from app.content_review_pool_items where content_review_batch_id=v_batch_id) <> 20 then
    raise exception 'review_pool:requires_exactly_10_mcq_and_10_frq';
  end if;
  return v_batch_id;
end;
$$;

revoke all on function app.create_five_subject_review_pool(uuid,text,uuid) from public,anon,authenticated;
grant execute on function app.create_five_subject_review_pool(uuid,text,uuid) to service_role;
