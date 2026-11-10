-- Cardless single-subject trial (trial_v2): Development integration test
-- (docs/product/FREE_TRIAL_NO_CARD_BACKEND_DESIGN_SPEC_2026_11_09.md §11).
-- Development ONLY (wmgjsdkphcyhngaffbqf), one transaction, always rolled back:
-- the final statement raises CARDLESS_TRIAL_TESTS_PASSED (<n> checks).
-- Paste the body into the Supabase MCP execute_sql tool for Development.
do $$
declare
  n int := 0;
  v_u1 uuid := gen_random_uuid(); v_u2 uuid := gen_random_uuid(); v_u3 uuid := gen_random_uuid();
  v_u4 uuid := gen_random_uuid();
  v_bio uuid; v_stats uuid; v_pack uuid;
  v_state jsonb; v_err text; v_i int;
  v_attempt uuid;
begin
  select id into v_bio from app.subjects where subject_key = 'biology';
  select id into v_stats from app.subjects where subject_key = 'ap-statistics';
  select v.id into v_pack from app.exam_packs p join app.exam_pack_versions v on v.exam_pack_id = p.id
    join app.home_release_manifest m on m.exam_pack_version_id = v.id where p.subject_id = v_bio limit 1;
  if v_bio is null or v_stats is null or v_pack is null then raise exception 'fixture subjects missing'; end if;

  insert into auth.users (id, email, instance_id, aud, role, raw_user_meta_data, created_at, updated_at) values
    (v_u1, 'trial-test-1@example.invalid', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', '{}'::jsonb, now(), now()),
    (v_u2, 'trial-test-2@example.invalid', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', '{}'::jsonb, now(), now()),
    (v_u3, 'TRIAL-TEST-1@example.invalid ', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', '{}'::jsonb, now(), now()),
    (v_u4, 'trial-test-4@example.invalid', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', '{}'::jsonb, now(), now());
  if not exists (select 1 from app.profiles where user_id = v_u1 and role::text = 'student') then raise exception 'profile trigger did not run'; end if;

  -- 1 switch off → disabled; state blocked/disabled
  update app.config set config_value = 'false'::jsonb where config_key = 'cardless_trial_enabled';
  begin
    perform app.start_subject_trial(v_u1, 'biology', '2026-11-09');
    raise exception 'expected trial:disabled';
  exception when others then
    if sqlerrm <> 'trial:disabled' then raise; end if;
  end; n := n + 1;
  v_state := app.trial_v2_state(v_u1);
  if v_state->>'phase' <> 'blocked' or v_state->>'blocked_reason' <> 'disabled' then raise exception 'state off: %', v_state; end if; n := n + 1;

  update app.config set config_value = 'true'::jsonb where config_key = 'cardless_trial_enabled';

  -- 2 fresh student: none/can_start
  v_state := app.trial_v2_state(v_u1);
  if v_state->>'phase' <> 'none' or (v_state->>'can_start')::boolean is not true then raise exception 'state none: %', v_state; end if; n := n + 1;
  if app.has_study_subject_access(v_u1, 'biology') then raise exception 'access before start'; end if; n := n + 1;

  -- 3 unknown subject
  begin
    perform app.start_subject_trial(v_u1, 'ap-underwater-basket-weaving', '2026-11-09');
    raise exception 'expected trial:subject_unavailable';
  exception when others then
    if sqlerrm <> 'trial:subject_unavailable' then raise; end if;
  end; n := n + 1;

  -- 4 start → active, one row, 7 days, hash consumed, event queued
  v_state := app.start_subject_trial(v_u1, 'biology', '2026-11-09', '{"utm_source":"t"}'::jsonb, null);
  if v_state->>'phase' <> 'active' or v_state->>'subject_key' <> 'biology' or (v_state->>'days_remaining')::int <> 7
     or v_state->>'checkout_subject_key' <> 'biology' then raise exception 'start state: %', v_state; end if; n := n + 1;
  if (select count(*) from app.subject_entitlements where user_id = v_u1 and source = 'trial_v2') <> 1 then raise exception 'row count'; end if; n := n + 1;
  if (select ends_at - starts_at from app.subject_entitlements where user_id = v_u1 and source = 'trial_v2') <> interval '7 days' then raise exception 'duration'; end if; n := n + 1;
  if not app.trial_email_consumed('trial-test-1@example.invalid') then raise exception 'hash not consumed'; end if; n := n + 1;
  if (select privacy_notice_version from app.acquisition_profiles where user_id = v_u1) <> '2026-11-09' then raise exception 'acquisition profile'; end if; n := n + 1;
  -- QA finding 1: touches are allow-listed (bogus key and non-string dropped, value trimmed), notice must be YYYY-MM-DD
  if (select first_touch from app.acquisition_profiles where user_id = v_u1) <> '{"utm_source":"t"}'::jsonb then raise exception 'touch stored as-is: %', (select first_touch from app.acquisition_profiles where user_id = v_u1); end if; n := n + 1;
  if app.sanitize_trial_touch('{"utm_source":"  r ","email":"minor@example.invalid","promo":5,"rdt_cid":"x"}'::jsonb) <> '{"utm_source":"r","rdt_cid":"x"}'::jsonb then raise exception 'sanitize'; end if; n := n + 1;
  if length(app.sanitize_trial_touch(jsonb_build_object('utm_campaign', repeat('a', 500)))->>'utm_campaign') <> 200 then raise exception 'trim'; end if; n := n + 1;
  if app.sanitize_trial_touch('"not an object"'::jsonb) <> '{}'::jsonb then raise exception 'non-object'; end if; n := n + 1;
  begin
    perform app.start_subject_trial(v_u2, 'biology', 'bogus-notice');
    raise exception 'expected trial:invalid_privacy_notice_version';
  exception when others then
    if sqlerrm <> 'trial:invalid_privacy_notice_version' then raise; end if;
  end; n := n + 1;
  if not exists (select 1 from app.growth_event_outbox where dedupe_key = 'trial_v2:' || v_u1::text and event_name = 'trial_started') then raise exception 'growth event'; end if; n := n + 1;

  -- 5 gates: the subject admitted, another denied; grading entitled
  if not app.has_study_subject_access(v_u1, 'biology') then raise exception 'no access to trial subject'; end if; n := n + 1;
  if app.has_study_subject_access(v_u1, 'ap-statistics') then raise exception 'access to other subject'; end if; n := n + 1;
  if not app.has_study_pack_access(v_u1, v_pack) then raise exception 'no pack access'; end if; n := n + 1;

  -- 6 replay same subject: same state, no second row, no second hash; other subject flagged
  v_state := app.start_subject_trial(v_u1, 'biology', '2026-11-09');
  if v_state->>'phase' <> 'active' or (select count(*) from app.subject_entitlements where user_id = v_u1 and source = 'trial_v2') <> 1 then raise exception 'replay'; end if; n := n + 1;
  v_state := app.start_subject_trial(v_u1, 'ap-statistics', '2026-11-09');
  if (v_state->>'replayed_other_subject')::boolean is not true or v_state->>'subject_key' <> 'biology' then raise exception 'other-subject replay: %', v_state; end if; n := n + 1;

  -- 7 same email, different case/whitespace, another account → already_used
  begin
    perform app.start_subject_trial(v_u3, 'biology', '2026-11-09');
    raise exception 'expected trial:already_used';
  exception when others then
    if sqlerrm <> 'trial:already_used' then raise; end if;
  end; n := n + 1;
  v_state := app.trial_v2_state(v_u3);
  if v_state->>'phase' <> 'blocked' or v_state->>'blocked_reason' <> 'already_used' then raise exception 'blocked state: %', v_state; end if; n := n + 1;

  -- 8 a legacy trial_v1 email counts (simulate the TASK-0077 backfill)
  insert into app.trial_consumed_emails (email_hash, source, consumed_at) values (app.trial_email_hash('trial-test-2@example.invalid'), 'trial_v1', now());
  begin
    perform app.start_subject_trial(v_u2, 'biology', '2026-11-09');
    raise exception 'expected trial:already_used (trial_v1)';
  exception when others then
    if sqlerrm <> 'trial:already_used' then raise; end if;
  end; n := n + 1;

  -- 9 paid student of the subject → superseded, nothing consumed
  insert into app.subject_entitlements (user_id, subject_id, access_tier, status, source, starts_at, ends_at)
  values (v_u4, v_bio, 'paid', 'active', 'test', now() - interval '1 day', null);
  v_state := app.start_subject_trial(v_u4, 'biology', '2026-11-09');
  if v_state->>'phase' <> 'superseded' then raise exception 'superseded: %', v_state; end if; n := n + 1;
  if app.trial_email_consumed('trial-test-4@example.invalid') then raise exception 'paid student consumed a trial'; end if; n := n + 1;
  if exists (select 1 from app.subject_entitlements where user_id = v_u4 and source = 'trial_v2') then raise exception 'trial row for paid student'; end if; n := n + 1;
  -- QA finding 3: a paying account whose email once consumed a trial is 'superseded', never 'already_used'
  insert into app.trial_consumed_emails (email_hash, source, consumed_at) values (app.trial_email_hash('trial-test-4@example.invalid'), 'trial_v1', now());
  v_state := app.trial_v2_state(v_u4);
  if v_state->>'phase' <> 'superseded' or (v_state->>'has_regular_entitlement')::boolean is not true or v_state->>'blocked_reason' is not null then raise exception 'paying account state: %', v_state; end if; n := n + 1;
  delete from app.trial_consumed_emails where email_hash = app.trial_email_hash('trial-test-4@example.invalid');

  -- 10 daily ceiling: cap 3 for the test; 3 pass, 4th denied, replay of an id passes, submit_response not counted
  update app.config set config_value = '3'::jsonb where config_key = 'trial_daily_grading_cap';
  for v_i in 1..3 loop
    if app.trial_grading_gate(v_u1, v_bio, 'grade_initial_attempt', 'req-' || v_i) <> 'entitled' then raise exception 'gate %', v_i; end if;
  end loop; n := n + 1;
  if app.trial_grading_gate(v_u1, v_bio, 'submit_response', 'req-sub') <> 'entitled' then raise exception 'submit counted'; end if; n := n + 1;
  -- QA finding 2: the per-user advisory lock is held for the transaction after a counted call
  if not exists (select 1 from pg_locks l where l.locktype = 'advisory' and l.pid = pg_backend_pid() and l.objsubid = 1
                   and l.classid = ((hashtextextended('trial_grading:' || v_u1::text, 0) >> 32) & 4294967295)::oid
                   and l.objid = (hashtextextended('trial_grading:' || v_u1::text, 0) & 4294967295)::oid) then
    raise exception 'ceiling lock not taken'; end if; n := n + 1;
  begin
    perform app.trial_grading_gate(v_u1, v_bio, 'grade_revision', 'req-4');
    raise exception 'expected trial_daily_cap';
  exception when others then
    if sqlerrm <> 'grading_access:trial_daily_cap' then raise; end if;
  end; n := n + 1;
  if app.trial_grading_gate(v_u1, v_bio, 'grade_initial_attempt', 'req-2') <> 'entitled' then raise exception 'replay denied'; end if; n := n + 1;
  if app.trial_grading_gate(v_u4, v_bio, 'grade_initial_attempt', 'req-paid') <> 'entitled' then raise exception 'paid capped'; end if; n := n + 1;
  if strpos(pg_get_functiondef('app.authorize_grading_access(uuid,uuid,text,text)'::regprocedure), 'trial_grading_gate') = 0 then raise exception 'authorize_grading_access not patched'; end if; n := n + 1;

  -- 11 day 7: gates deny, readback stays, state ended with 0 days
  update app.subject_entitlements set starts_at = now() - interval '8 days', ends_at = now() - interval '1 day' where user_id = v_u1 and source = 'trial_v2';
  if app.has_study_subject_access(v_u1, 'biology') then raise exception 'access after end'; end if; n := n + 1;
  if not app.has_study_readback_access(v_u1, v_pack) then raise exception 'readback lost after end'; end if; n := n + 1;
  v_state := app.trial_v2_state(v_u1);
  if v_state->>'phase' <> 'ended' or (v_state->>'days_remaining')::int <> 0 or (v_state->>'seconds_remaining')::int <> 0 then raise exception 'ended state: %', v_state; end if; n := n + 1;

  -- 12 pay after the trial → superseded
  insert into app.subject_entitlements (user_id, subject_id, access_tier, status, source, starts_at, ends_at)
  values (v_u1, v_bio, 'paid', 'active', 'test', now(), null);
  v_state := app.trial_v2_state(v_u1);
  if v_state->>'phase' <> 'superseded' or (v_state->>'has_regular_entitlement')::boolean is not true then raise exception 'post-pay: %', v_state; end if; n := n + 1;
  if not app.has_study_subject_access(v_u1, 'biology') then raise exception 'paid access'; end if; n := n + 1;

  -- 13 card-trial machinery ignores trial_v2 rows
  if exists (select 1 from app.trial_claim_due(25)) then raise exception 'trial_claim_due returned an order'; end if; n := n + 1;
  perform app.trial_sweep();
  if (select count(*) from app.subject_entitlements where source = 'trial_v2' and user_id = v_u1 and ends_at > now()) <> 0 then raise exception 'sweep extended a trial_v2 row'; end if; n := n + 1;

  -- 14 the sample supersede trigger is wired on subject_entitlements and treats the trial tier as superseding
  if not exists (select 1 from pg_trigger t join pg_class c on c.oid = t.tgrelid join pg_namespace ns on ns.oid = c.relnamespace
                 join pg_proc p on p.oid = t.tgfoid where ns.nspname = 'app' and c.relname = 'subject_entitlements'
                   and p.proname = 'sample_supersede_on_entitlement' and not t.tgisinternal) then
    raise exception 'sample supersede trigger missing'; end if; n := n + 1;
  if strpos(pg_get_functiondef('app.sample_supersede_on_entitlement()'::regprocedure), 'trial') = 0 then raise exception 'trigger ignores trial tier'; end if; n := n + 1;

  -- 15 public wrappers under a simulated JWT
  perform set_config('request.jwt.claims', jsonb_build_object('sub', v_u1, 'role', 'authenticated')::text, true);
  perform set_config('request.jwt.claim.sub', v_u1::text, true);
  if (public.get_trial_state())->>'phase' <> 'superseded' then raise exception 'public read'; end if; n := n + 1;
  begin
    perform public.start_subject_trial('biology', '');
    raise exception 'expected missing_privacy_notice_version';
  exception when others then
    if sqlerrm <> 'trial:missing_privacy_notice_version' then raise; end if;
  end; n := n + 1;

  raise exception 'CARDLESS_TRIAL_TESTS_PASSED (% checks)', n;
end $$;
