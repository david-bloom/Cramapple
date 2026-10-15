-- Transactional runtime regression. Run as SQL admin AFTER staging the migration.
-- Replace QA placeholders with an existing task-owned synthetic identity and ten
-- owned/entitled served-question fixtures. No real student identity/work is used.
-- Fixture JSON: [{"subject":"biology","session":"uuid","version":"uuid"},...]
-- Include Physics2 registry units9-11 and C:E&M8-10; no numeric unit<=3 gate.
-- Each actual reservation is rolled back inside its own subtransaction, keeping
-- burst/delivery counters independent across the ten subjects. No model calls.
begin;
do $guard$
begin
  if not exists(select 1 from auth.users where id='__QA_USER__'::uuid
    and email='__QA_EMAIL__') then raise exception 'Synthetic QA identity mismatch'; end if;
  perform set_config('more_help.all_subject_fixtures',$fixtures$__QA_FIXTURES_JSON__$fixtures$,true);
  perform set_config('more_help.all_subject_user','__QA_USER__',true);
  perform set_config('request.jwt.claim.sub','__QA_USER__',true);
end;
$guard$;
set local role service_role;
do $test$
declare
  fixture jsonb;
  fixtures jsonb:=current_setting('more_help.all_subject_fixtures')::jsonb;
  u uuid:=current_setting('more_help.all_subject_user')::uuid;
  r jsonb;
  request_id uuid;
  registry_subject text;
begin
  if current_user<>'service_role' then raise exception 'Wrong runtime role'; end if;
  if jsonb_array_length(fixtures)<>10 or
    (select count(distinct x->>'subject') from jsonb_array_elements(fixtures) x)<>10 then
    raise exception 'Expected ten distinct subject fixtures'; end if;
  if exists(select 1 from unnest(array['biology','ap-calculus-ab','ap-calculus-bc','ap-chemistry',
    'ap-precalculus','ap-statistics','ap-physics-1','ap-physics-2',
    'ap-physics-c-mechanics','ap-physics-c-em']) subject
    where not exists(select 1 from jsonb_array_elements(fixtures) x where x->>'subject'=subject)) then
    raise exception 'Registry fixture coverage mismatch'; end if;
  if has_function_privilege('authenticated','public.reserve_question_help_delivery(uuid,uuid,uuid,uuid,text)','EXECUTE')
    or has_function_privilege('anon','public.reserve_question_help_delivery(uuid,uuid,uuid,uuid,text)','EXECUTE') then
    raise exception 'Reservation became publicly callable'; end if;
  for fixture in select value from jsonb_array_elements(fixtures) loop
    select s.subject_key into registry_subject from app.learning_sessions ls
      join app.exam_pack_versions epv on epv.id=ls.exam_pack_version_id
      join app.exam_packs ep on ep.id=epv.exam_pack_id
      join app.subjects s on s.id=ep.subject_id
      where ls.id=(fixture->>'session')::uuid and ls.user_id=u;
    if registry_subject is distinct from fixture->>'subject' then
      raise exception 'Fixture does not belong to asserted registry subject'; end if;
    begin
      request_id:=gen_random_uuid();
      r:=public.reserve_question_help_delivery(u,request_id,
        (fixture->>'session')::uuid,(fixture->>'version')::uuid,repeat('a',64));
      if r->>'state' is distinct from 'reserved' or r->>'generation' is distinct from '1' then
        raise exception 'Subject % reservation failed: %',registry_subject,r; end if;
      if public.has_question_help((fixture->>'session')::uuid,(fixture->>'version')::uuid) then
        raise exception 'QA fixture already assisted or reserve disclosed assistance'; end if;
      perform public.fail_question_help(u,request_id,1);
      r:=public.reserve_question_help_delivery(gen_random_uuid(),gen_random_uuid(),
        (fixture->>'session')::uuid,(fixture->>'version')::uuid,repeat('a',64));
      if r->>'error' is distinct from 'question_not_owned' then
        raise exception 'Foreign session accepted for %',registry_subject; end if;
      -- Roll back this case's receipt/call, without resetting anyone's counters.
      raise exception using errcode='ZX001',message='rollback successful case';
    exception when sqlstate 'ZX001' then null;
    end;
  end loop;
end;
$test$;
reset role;
rollback;
