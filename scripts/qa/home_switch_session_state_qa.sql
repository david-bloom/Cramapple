begin;

create temporary table home_switch_session_state_qa_ids (
  key text primary key,
  id uuid not null
) on commit drop;

insert into home_switch_session_state_qa_ids (key, id)
select 'user', user_id
from app.profiles
where user_id is not null
limit 1;

grant select on home_switch_session_state_qa_ids to authenticated;

select set_config(
  'request.jwt.claims',
  json_build_object(
    'sub', (select id from home_switch_session_state_qa_ids where key = 'user'),
    'role', 'authenticated'
  )::text,
  true
);
set local role authenticated;

select public.set_active_exam_pack_version(
  '4852aded-78eb-4ffd-a0df-97065357aa77'::uuid
) as switched_to_biology;

select public.set_active_exam_pack_version(
  '16000000-0000-4000-8000-000000000003'::uuid
) as switched_to_statistics;

select *
from app.start_home_learning_session_for_user(
  (select id from home_switch_session_state_qa_ids where key = 'user'),
  15,
  'qa-home-switch-session-state'
);

rollback;
