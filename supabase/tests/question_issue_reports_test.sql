-- Run in Development only; all fixtures and reports roll back.
begin;
do $$
declare
  u uuid := gen_random_uuid();
  sid uuid := gen_random_uuid();
  vid uuid;
  teaching_id uuid;
  teaching_subject uuid;
  pack uuid;
  request_id uuid := gen_random_uuid();
  receipt jsonb;
  retry jsonb;
begin
  select civ.id, ci.exam_pack_version_id into vid, pack
  from app.content_item_versions civ join app.content_items ci on ci.id=civ.content_item_id
  where civ.status='published' limit 1;
  if vid is null then raise exception 'QA requires a published question'; end if;
  insert into auth.users(id,email,raw_user_meta_data,raw_app_meta_data,created_at,updated_at)
  values(u,'question-report-qa-'||u::text||'@example.invalid','{}','{}',now(),now());
  insert into app.learning_sessions(id,user_id,exam_pack_version_id,entry_path,session_mode,available_minutes,status)
  values(sid,u,pack,'topic','quick',10,'active');
  insert into app.learning_session_items(learning_session_id,ordinal,content_item_version_id) values(sid,1,vid);
  receipt := public.reserve_question_issue_report(u,request_id,sid,vid,'practice','');
  if receipt->>'state' <> 'reserved' then raise exception 'owner empty-comment reservation failed: %',receipt; end if;
  retry := public.reserve_question_issue_report(u,request_id,sid,vid,'practice','');
  if retry->>'error' <> 'delivery_in_progress' then raise exception 'concurrent send not blocked'; end if;
  retry := public.reserve_question_issue_report(u,request_id,sid,vid,'practice','edited');
  if retry->>'error' <> 'request_conflict' then raise exception 'idempotency payload mutation accepted'; end if;
  retry := public.reserve_question_issue_report(gen_random_uuid(),gen_random_uuid(),sid,vid,'practice','');
  if retry->>'error' <> 'question_not_owned' then raise exception 'foreign user accepted'; end if;
  retry := public.reserve_question_issue_report(u,gen_random_uuid(),sid,gen_random_uuid(),'practice','');
  if retry->>'error' <> 'question_not_owned' then raise exception 'unserved question accepted'; end if;
  update app.question_issue_reports set notification_state='failed',lease_until=null where id=(receipt->>'id')::uuid;
  retry := public.reserve_question_issue_report(u,request_id,sid,vid,'practice','');
  if retry->>'id' <> receipt->>'id' or retry->>'state' <> 'reserved' then raise exception 'retry lost original receipt'; end if;
  update app.question_issue_reports set notification_state='sent',lease_until=null where id=(receipt->>'id')::uuid;
  retry := public.reserve_question_issue_report(u,request_id,sid,vid,'practice','');
  if retry->>'state' <> 'sent' then raise exception 'sent receipt not idempotent'; end if;
  select civ.id, ep.subject_id into teaching_id, teaching_subject from app.open_hand_teaching_items t
    join app.content_items ci on ci.id=t.content_item_id
    join app.content_item_versions civ on civ.content_item_id=ci.id
    join app.exam_pack_versions epv on epv.id=ci.exam_pack_version_id
    join app.exam_packs ep on ep.id=epv.exam_pack_id
    join app.subjects subj on subj.id=ep.subject_id
    where t.released_at is null and civ.status='published' and ci.status='published'
      and epv.status='published' and epv.retired_at is null and subj.status='active' limit 1;
  if teaching_id is null then raise exception 'QA requires a teaching question'; end if;
  retry := public.reserve_question_issue_report(u,gen_random_uuid(),null,teaching_id,'worked','');
  if retry->>'error' <> 'question_not_owned' then raise exception 'unentitled teaching report accepted'; end if;
  insert into app.subject_entitlements(user_id,subject_id,access_tier,source,ends_at)
    values(u,teaching_subject,'trial','question-report-qa',now()+interval '1 hour');
  retry := public.reserve_question_issue_report(u,gen_random_uuid(),null,teaching_id,'worked','');
  if retry->>'state' <> 'reserved' then raise exception 'entitled teaching report failed: %',retry; end if;
  for n in 1..8 loop
    perform public.reserve_question_issue_report(u,gen_random_uuid(),sid,vid,'review','QA '||n);
  end loop;
  retry := public.reserve_question_issue_report(u,gen_random_uuid(),sid,vid,'review','extra');
  if retry->>'error' <> 'rate_limited' then raise exception 'hourly limit missing'; end if;
end $$;
rollback;
select 'all question-report database assertions passed; fixtures rolled back' as result;
