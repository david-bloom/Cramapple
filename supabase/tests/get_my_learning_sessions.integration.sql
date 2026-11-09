-- get_my_learning_sessions: Development integration test (rolled back).
-- Paste the body into the Supabase MCP execute_sql tool for wmgjsdkphcyhngaffbqf.
do $$
declare
  n int := 0;
  v_u1 uuid := gen_random_uuid(); v_u2 uuid := gen_random_uuid();
  v_bio uuid; v_pack uuid; v_civ uuid; v_s1 uuid; v_s2 uuid; v_s3 uuid;
  v_rows jsonb;
begin
  select id into v_bio from app.subjects where subject_key = 'biology';
  select v.id into v_pack from app.exam_packs p join app.exam_pack_versions v on v.exam_pack_id = p.id
    join app.home_release_manifest m on m.exam_pack_version_id = v.id where p.subject_id = v_bio limit 1;
  select civ.id into v_civ from app.content_item_versions civ join app.content_items ci on ci.id = civ.content_item_id
    where ci.item_type = 'mcq' and civ.status = 'published' limit 1;
  if v_bio is null or v_pack is null or v_civ is null then raise exception 'fixtures missing'; end if;

  insert into auth.users (id, email, instance_id, aud, role, raw_user_meta_data, created_at, updated_at) values
    (v_u1, 'sessions-test-1@example.invalid', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', '{}'::jsonb, now(), now()),
    (v_u2, 'sessions-test-2@example.invalid', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', '{}'::jsonb, now(), now());

  -- three sessions for u1: two with items (one older), one empty; one session for u2
  insert into app.learning_sessions (id, user_id, exam_pack_version_id, entry_path, session_mode, available_minutes, status, started_at)
  values (gen_random_uuid(), v_u1, v_pack, 'topic', 'quick', 15, 'completed', now() - interval '2 days') returning id into v_s1;
  insert into app.learning_sessions (id, user_id, exam_pack_version_id, entry_path, session_mode, available_minutes, status, started_at)
  values (gen_random_uuid(), v_u1, v_pack, 'topic', 'quick', 15, 'active', now() - interval '1 hour') returning id into v_s2;
  insert into app.learning_sessions (id, user_id, exam_pack_version_id, entry_path, session_mode, available_minutes, status, started_at)
  values (gen_random_uuid(), v_u1, v_pack, 'topic', 'quick', 15, 'active', now()) returning id into v_s3;  -- no items: hidden
  insert into app.learning_session_items (learning_session_id, ordinal, content_item_version_id) values (v_s1, 1, v_civ), (v_s2, 1, v_civ);
  insert into app.learning_sessions (user_id, exam_pack_version_id, entry_path, session_mode, available_minutes, status, started_at)
  values (v_u2, v_pack, 'topic', 'quick', 15, 'active', now());

  -- anonymous → not_authenticated
  perform set_config('request.jwt.claims', '{}', true); perform set_config('request.jwt.claim.sub', '', true);
  begin
    perform public.get_my_learning_sessions();
    raise exception 'expected not_authenticated';
  exception when others then
    if sqlerrm <> 'not_authenticated' then raise; end if;
  end; n := n + 1;

  perform set_config('request.jwt.claims', jsonb_build_object('sub', v_u1, 'role', 'authenticated')::text, true);
  perform set_config('request.jwt.claim.sub', v_u1::text, true);

  v_rows := public.get_my_learning_sessions();
  if jsonb_array_length(v_rows) <> 2 then raise exception 'expected 2 own sessions with items, got %', v_rows; end if; n := n + 1;
  if (v_rows->0->>'learningSessionId')::uuid <> v_s2 then raise exception 'newest first'; end if; n := n + 1;
  if v_rows->0->>'subjectKey' <> 'biology' or v_rows->0->>'firstItemType' <> 'mcq' or (v_rows->0->>'itemCount')::int <> 1
     or (v_rows->0->>'submittedCount')::int <> 0 then raise exception 'row shape: %', v_rows->0; end if; n := n + 1;
  -- no entitlement at all: listed, but readable=false (get_question_experience would deny)
  if (v_rows->0->>'readable')::boolean is not false then raise exception 'readable should be false without access'; end if; n := n + 1;
  -- an ended trial_v2 row makes them readable
  insert into app.subject_entitlements (user_id, subject_id, access_tier, status, source, starts_at, ends_at)
  values (v_u1, v_bio, 'trial', 'active', 'trial_v2', now() - interval '8 days', now() - interval '1 day');
  v_rows := public.get_my_learning_sessions('biology', 1);
  if jsonb_array_length(v_rows) <> 1 or (v_rows->0->>'readable')::boolean is not true then raise exception 'readable with ended trial: %', v_rows; end if; n := n + 1;
  -- subject filter: hyphen/underscore both resolve; unknown subject → []
  if jsonb_array_length(public.get_my_learning_sessions('ap_statistics')) <> 0 then raise exception 'subject filter'; end if; n := n + 1;
  -- limit is capped server-side at 50 and floored at 1
  if jsonb_array_length(public.get_my_learning_sessions(null, 0)) <> 1 then raise exception 'limit floor'; end if; n := n + 1;
  if jsonb_array_length(public.get_my_learning_sessions(null, 999)) <> 2 then raise exception 'limit cap'; end if; n := n + 1;
  -- never another user's rows
  if exists (select 1 from jsonb_array_elements(public.get_my_learning_sessions()) e
             where (e->>'learningSessionId')::uuid in (select id from app.learning_sessions where user_id = v_u2)) then
    raise exception 'leaked another user''s session'; end if; n := n + 1;

  raise exception 'GET_MY_LEARNING_SESSIONS_TESTS_PASSED (% checks)', n;
end $$;
