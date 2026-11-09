-- Paywall sample access: Development integration test
-- (docs/product/PAYWALL_BACKEND_DESIGN_SPEC_2026_11_08.md). Runs against the
-- Development project ONLY (wmgjsdkphcyhngaffbqf), inside one transaction that
-- is always rolled back: the final statement raises
--   SAMPLE_ACCESS_TESTS_PASSED (<n> checks)
-- so nothing is committed and the message is the result. Any earlier failure
-- surfaces as its own exception.
--
-- Run (Development): supabase db query --linked --workdir <repo root> -f <abs path>,
-- or paste the body into the Supabase MCP execute_sql tool for project
-- wmgjsdkphcyhngaffbqf. Never run against Production.
--
-- Data assumptions (Development as of 2026-11-08): ap-statistics has a
-- selectable pack whose unit 1 holds >= 9 eligible MCQs and >= 1 targeted-drill
-- FRQ (app.sample_unit_availability reports it eligible); unit 5 holds an MCQ
-- (the out-of-unit probe). The test reads these from the database.

do $t$
declare
  n integer := 0;
  v_avail jsonb; v_pack uuid; v_subject uuid;
  v_tok1 text := repeat('a', 64); v_tok2 text := repeat('b', 64); v_tok3 text := repeat('c', 64);
  v_res jsonb; v_try1 uuid; v_civ1 uuid; v_item1 uuid; v_pick text; v_correct text;
  v_user1 uuid := gen_random_uuid(); v_user2 uuid := gen_random_uuid(); v_user3 uuid := gen_random_uuid();
  v_state jsonb; v_grant app.sample_grants; v_session uuid; v_attempt uuid; v_qx jsonb;
  v_unit1_versions uuid[]; v_unit5_version uuid; v_frq_version uuid; v_civ uuid; i integer;
  v_text text; v_count integer; v_a uuid; v_scope jsonb;
  procedure_fail text;
begin
  -- ---------------------------------------------------------------- flag off
  begin
    perform app.sample_try_start('ap-statistics', 1, null, v_tok1, 'ip', '{}'::jsonb);
    raise exception 'expected sample_try:disabled';
  exception when others then
    if sqlerrm not like 'sample_try:disabled%' then raise; end if;
  end;
  n := n + 1;

  update app.config set config_value = 'true'::jsonb where config_key = 'sample_access_enabled';
  if not app.sample_access_enabled() then raise exception 'flag did not flip'; end if;
  n := n + 1;

  -- ------------------------------------------------------- availability/select
  v_avail := app.sample_unit_availability('ap-statistics');
  if not exists (select 1 from jsonb_array_elements(v_avail) u where (u->>'unit_number')::int = 1 and (u->>'eligible')::boolean) then
    raise exception 'unit 1 not eligible on this database: %', v_avail;
  end if;
  v_subject := app.sample_subject_id('ap-statistics');
  v_pack := app.sample_pack_for_subject(v_subject);
  n := n + 1;

  -- ---------------------------------------------------------------- try start
  v_res := app.sample_try_start('ap-statistics', 1, null, v_tok1, 'ip-hmac', '{"ad_tracking_allowed": false, "first_touch": {"utm_source": "reddit"}}'::jsonb);
  if v_res->>'outcome' <> 'created' or (v_res->>'issued_new_token')::boolean is not true then raise exception 'start: %', v_res; end if;
  v_try1 := (v_res->'try'->>'try_id')::uuid;
  v_civ1 := (v_res->'try'->'question'->>'content_item_version_id')::uuid;
  if v_res->'try'->'question'->'choices'->0 ? 'is_correct' or v_res::text like '%rationale%' then
    raise exception 'answer truth leaked before answer: %', v_res;
  end if;
  if (v_res->'try'->'question'->'topic'->>'unit_number')::int <> 1 then raise exception 'served item not in unit 1'; end if;
  n := n + 1;

  -- resume: same token, same subject/unit -> same try
  v_res := app.sample_try_start('ap-statistics', 1, v_tok1, v_tok2, 'ip', '{}'::jsonb);
  if v_res->>'outcome' <> 'resumed' or (v_res->'try'->>'try_id')::uuid <> v_try1 then raise exception 'resume: %', v_res; end if;
  if exists (select 1 from app.sample_tries where token_hash = v_tok2) then raise exception 'resume minted a token'; end if;
  n := n + 1;

  -- ineligible unit refused with the availability list in detail
  begin
    perform app.sample_try_start('ap-statistics', 99, null, v_tok2, 'ip', '{}'::jsonb);
    raise exception 'expected unit_unavailable';
  exception when others then
    if sqlerrm not like 'sample_try:unit_unavailable%' then raise; end if;
  end;
  n := n + 1;

  -- --------------------------------------------------------------- try answer
  select max(choice_key) filter (where is_correct), max(choice_key) filter (where not is_correct)
    into v_correct, v_pick from app.mcq_choices where content_item_version_id = v_civ1;
  begin
    perform app.sample_try_answer(v_tok1, 'ZZ');
    raise exception 'expected invalid_choice';
  exception when others then
    if sqlerrm not like 'sample_try:invalid_choice%' then raise; end if;
  end;
  v_res := app.sample_try_answer(v_tok1, v_pick);   -- a wrong answer, deliberately
  if v_res->>'outcome' <> 'answered' or (v_res->'try'->'feedback'->>'earned')::int <> 0 then raise exception 'answer: %', v_res; end if;
  if not (v_res->'try'->'feedback'->'choices'->0 ? 'is_correct') then raise exception 'feedback lacks truth'; end if;
  -- idempotent replay with the same key; a different key is refused
  v_res := app.sample_try_answer(v_tok1, v_pick);
  if v_res->>'outcome' <> 'replayed' then raise exception 'replay: %', v_res; end if;
  begin
    perform app.sample_try_answer(v_tok1, v_correct);
    raise exception 'expected already_answered';
  exception when others then
    if sqlerrm not like 'sample_try:already_answered%' then raise; end if;
  end;
  -- an answered token cannot start another free question
  v_res := app.sample_try_start('ap-statistics', 1, v_tok1, v_tok2, 'ip', '{}'::jsonb);
  if v_res->>'outcome' <> 'register_required' then raise exception 'register_required: %', v_res; end if;
  n := n + 1;

  -- ------------------------------------------------------------ users (rolled back)
  insert into auth.users (id, email, instance_id, aud, role, raw_user_meta_data, created_at, updated_at)
  values (v_user1, 'sample-test-1@example.invalid', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', '{}'::jsonb, now(), now()),
         (v_user2, 'sample-test-2@example.invalid', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', '{}'::jsonb, now(), now()),
         (v_user3, 'sample-test-3@example.invalid', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', '{}'::jsonb, now(), now());
  if not exists (select 1 from app.profiles where user_id = v_user1 and role::text = 'student') then raise exception 'profile trigger did not run'; end if;
  -- a brand-new student has no study access before the claim
  if app.has_study_subject_access(v_user1, 'ap-statistics') then raise exception 'unexpected access before claim'; end if;
  n := n + 1;

  -- ---------------------------------------------------------------- claim
  begin
    perform app.claim_sample_try(v_user1, v_tok3);
    raise exception 'expected try_not_found';
  exception when others then
    if sqlerrm not like 'sample:try_not_found%' then raise; end if;
  end;
  v_state := app.claim_sample_try(v_user1, v_tok1);
  if (v_state->>'has_grant')::boolean is not true then raise exception 'claim: %', v_state; end if;
  select * into v_grant from app.sample_grants where user_id = v_user1;
  if v_grant.expires_at <> v_grant.activated_at + interval '72 hours' or v_grant.grace_ends_at <> v_grant.expires_at + interval '72 hours' then
    raise exception 'clock not fixed at +72h/+144h';
  end if;
  if (v_state->'grant'->'mcq'->>'used')::int <> 1 or (v_state->'grant'->'mcq'->>'remaining')::int <> 7
     or (v_state->'grant'->'frq'->>'remaining')::int <> 1 then raise exception 'allowance after claim: %', v_state->'grant'; end if;
  if v_state->'grant'->>'phase' <> 'active' then raise exception 'phase: %', v_state; end if;
  if (v_state->'offer_context'->'attribution'->'first_touch'->>'utm_source') <> 'reddit' then raise exception 'attribution not preserved'; end if;
  v_session := (v_state->'grant'->>'learning_session_id')::uuid;
  select entry_path into v_text from app.learning_sessions where id = v_session;
  if v_text <> 'sample' then raise exception 'session entry_path %', v_text; end if;
  -- serving alignment (2026-11-09): imported session is format-less; course position = grant unit
  if (select practice_format from app.learning_sessions where id = v_session) is not null then raise exception 'imported session must be format-less'; end if;
  if not exists (select 1 from app.student_course_positions where user_id = v_user1 and exam_pack_version_id = v_pack and unit_id = 1 and source = 'confirmed') then
    raise exception 'claim did not set the course position to the grant unit';
  end if;
  if (select x->>'basis' from jsonb_array_elements(v_avail) x where (x->>'unit_number')::int = 1) not in ('serving', 'content') then
    raise exception 'availability rows must state their basis';
  end if;
  select id into v_attempt from app.attempts where user_id = v_user1 and content_item_version_id = v_civ1;
  if not exists (select 1 from app.grading_results where attempt_id = v_attempt and status = 'graded' and points_earned = 0) then raise exception 'grading row missing'; end if;
  if not exists (select 1 from app.response_versions where attempt_id = v_attempt and is_submitted and response_text = v_pick) then raise exception 'response row missing'; end if;
  if (select status from app.sample_tries where id = v_try1) <> 'claimed' then raise exception 'try not marked claimed'; end if;
  if not exists (select 1 from app.audit_events where action = 'sample.claim' and object_id = v_grant.id) then raise exception 'audit row missing'; end if;
  n := n + 1;

  -- idempotent replay, and no second grant
  v_state := app.claim_sample_try(v_user1, v_tok1);
  if (select count(*) from app.sample_grants where user_id = v_user1) <> 1 then raise exception 'duplicate grant'; end if;
  -- another user cannot claim the same try
  begin
    perform app.claim_sample_try(v_user2, v_tok1);
    raise exception 'expected try_claimed_elsewhere';
  exception when others then
    if sqlerrm not like 'sample:try_claimed_elsewhere%' then raise; end if;
  end;
  n := n + 1;

  -- study access: grant subject while active; no other subject
  if not app.has_study_subject_access(v_user1, 'ap-statistics') then raise exception 'no study access after claim'; end if;
  if app.has_study_subject_access(v_user1, 'biology') then raise exception 'sample leaked to another subject'; end if;
  if not app.has_study_pack_access(v_user1, v_pack) then raise exception 'no pack access'; end if;
  n := n + 1;

  -- readback as the student (auth.uid via request.jwt.claims)
  perform set_config('request.jwt.claims', jsonb_build_object('sub', v_user1, 'role', 'authenticated')::text, true);
  perform set_config('request.jwt.claim.sub', v_user1::text, true);
  v_qx := public.get_question_experience(v_session, 1);
  if v_qx->'mcqFeedback' is null or v_qx->'mcqFeedback' = 'null'::jsonb then raise exception 'readback lacks mcqFeedback: %', v_qx->'resume'; end if;
  if v_qx->'resume'->>'action' <> 'review_feedback' then raise exception 'resume action %', v_qx->'resume'; end if;
  -- guides: grant unit only
  begin
    perform public.get_study_topic_point_guides('ap-statistics', 3, null);
    raise exception 'expected unit_locked';
  exception when others then
    if sqlerrm not like 'sample:unit_locked%' then raise; end if;
  end;
  v_state := public.get_sample_access_state();
  if (v_state->>'has_grant')::boolean is not true then raise exception 'public state'; end if;
  perform set_config('request.jwt.claims', '', true);
  perform set_config('request.jwt.claim.sub', '', true);
  n := n + 1;

  -- -------------------------------------------------- attempt gate: unit + allowance
  select array_agg(civ.id order by civ.id) into v_unit1_versions
  from app.content_items ci join app.content_item_versions civ on civ.content_item_id = ci.id and civ.status = 'published'
  join app.content_item_topic_resolution r on r.content_item_version_id = civ.id
  where ci.exam_pack_version_id = v_pack and ci.status = 'published' and ci.item_type = 'mcq' and r.unit_number = 1
    and civ.id <> v_civ1
    and not exists (select 1 from app.open_hand_teaching_items t where t.content_item_id = ci.id and t.released_at is null);
  if coalesce(array_length(v_unit1_versions, 1), 0) < 8 then raise exception 'need >= 8 more unit-1 MCQs, have %', array_length(v_unit1_versions, 1); end if;
  select civ.id into v_unit5_version
  from app.content_items ci join app.content_item_versions civ on civ.content_item_id = ci.id and civ.status = 'published'
  join app.content_item_topic_resolution r on r.content_item_version_id = civ.id
  where ci.exam_pack_version_id = v_pack and ci.status = 'published' and ci.item_type = 'mcq' and r.unit_number <> 1 limit 1;
  if v_unit5_version is null then raise exception 'need an out-of-unit MCQ'; end if;

  begin
    insert into app.attempts (user_id, learning_session_id, exam_pack_version_id, content_item_version_id, attempt_mode)
    values (v_user1, v_session, v_pack, v_unit5_version, 'mcq');
    raise exception 'expected item_outside_unit';
  exception when others then
    if sqlerrm not like 'sample:item_outside_unit%' then raise; end if;
  end;
  n := n + 1;

  -- seven more MCQs consume the allowance; the eighth distinct item is refused
  for i in 1..7 loop
    insert into app.attempts (user_id, learning_session_id, exam_pack_version_id, content_item_version_id, attempt_mode)
    values (v_user1, v_session, v_pack, v_unit1_versions[i], 'mcq');
  end loop;
  select count(*) into v_count from app.sample_consumptions c join app.sample_grants g on g.id = c.grant_id where g.user_id = v_user1 and c.kind = 'mcq';
  if v_count <> 8 then raise exception 'mcq consumptions = %', v_count; end if;
  -- a retried create on an already-consumed item consumes nothing
  insert into app.attempts (user_id, learning_session_id, exam_pack_version_id, content_item_version_id, attempt_mode)
  values (v_user1, v_session, v_pack, v_unit1_versions[1], 'mcq');
  select count(*) into v_count from app.sample_consumptions c join app.sample_grants g on g.id = c.grant_id where g.user_id = v_user1 and c.kind = 'mcq';
  if v_count <> 8 then raise exception 'retry double-consumed'; end if;
  begin
    insert into app.attempts (user_id, learning_session_id, exam_pack_version_id, content_item_version_id, attempt_mode)
    values (v_user1, v_session, v_pack, v_unit1_versions[8], 'mcq');
    raise exception 'expected mcq_allowance_exhausted';
  exception when others then
    if sqlerrm not like 'sample:mcq_allowance_exhausted%' then raise; end if;
  end;
  v_scope := app.sample_serving_scope(v_user1, v_pack);
  if (v_scope->>'mcq_remaining')::int <> 0 or (v_scope->>'frq_remaining')::int <> 1 or (v_scope->>'unit_number')::int <> 1 then
    raise exception 'serving scope: %', v_scope;
  end if;
  n := n + 1;

  -- FRQ allowance: one, shared
  select civ.id into v_frq_version
  from app.content_items ci join app.content_item_versions civ on civ.content_item_id = ci.id and civ.status = 'published'
  join app.content_item_topic_resolution r on r.content_item_version_id = civ.id
  where ci.exam_pack_version_id = v_pack and ci.status = 'published' and ci.item_type = 'frq'
    and ci.practice_format = 'targeted_drill' and coalesce(ci.response_policy, '') <> 'photo_required' and r.unit_number = 1 limit 1;
  if v_frq_version is null then raise exception 'need a unit-1 FRQ'; end if;
  insert into app.attempts (user_id, learning_session_id, exam_pack_version_id, content_item_version_id, attempt_mode)
  values (v_user1, v_session, v_pack, v_frq_version, 'frq') returning id into v_a;
  if (app.sample_serving_scope(v_user1, v_pack)->>'frq_remaining')::int <> 0 then raise exception 'frq not consumed'; end if;
  n := n + 1;

  -- grading authorization: sample, bounded requests, no revision
  if app.authorize_grading_access(v_user1, v_a, 'submit_response', 'req-s') <> 'sample' then raise exception 'authorize submit'; end if;
  perform app.authorize_grading_access(v_user1, v_a, 'grade_initial_attempt', 'req-1');
  perform app.authorize_grading_access(v_user1, v_a, 'grade_initial_attempt', 'req-1');  -- replay, not counted
  perform app.authorize_grading_access(v_user1, v_a, 'grade_initial_attempt', 'req-2');
  perform app.authorize_grading_access(v_user1, v_a, 'grade_initial_attempt', 'req-3');
  begin
    perform app.authorize_grading_access(v_user1, v_a, 'grade_initial_attempt', 'req-4');
    raise exception 'expected sample_grading_limit_reached';
  exception when others then
    if sqlerrm not like 'grading_access:sample_grading_limit_reached%' then raise; end if;
  end;
  begin
    perform app.authorize_grading_access(v_user1, v_a, 'grade_revision', 'req-r');
    raise exception 'expected sample_operation_not_included';
  exception when others then
    if sqlerrm not like 'grading_access:sample_operation_not_included%' then raise; end if;
  end;
  -- photo runs: three, then refused
  perform app.sample_take_photo_run(v_user1, v_a); perform app.sample_take_photo_run(v_user1, v_a); perform app.sample_take_photo_run(v_user1, v_a);
  begin
    perform app.sample_take_photo_run(v_user1, v_a);
    raise exception 'expected extraction_limit_reached';
  exception when others then
    if sqlerrm not like 'sample:extraction_limit_reached%' then raise; end if;
  end;
  n := n + 1;

  -- ------------------------------------------------------------ grace / expiry
  update app.sample_grants set activated_at = now() - interval '73 hours', expires_at = now() - interval '1 hour', grace_ends_at = now() + interval '71 hours' where user_id = v_user1;
  if app.sample_grant_phase((select g from app.sample_grants g where user_id = v_user1)) <> 'grace' then raise exception 'phase should be grace'; end if;
  if app.has_study_subject_access(v_user1, 'ap-statistics') then raise exception 'grace must not admit new study'; end if;
  if not app.has_study_readback_access(v_user1, v_pack) then raise exception 'grace must keep readback'; end if;
  if app.authorize_grading_access(v_user1, v_a, 'submit_response', 'req-g') <> 'sample_grace' then raise exception 'grace grading'; end if;
  begin
    -- the consumption's own fixed deadline, not the grant row, decides
    update app.sample_consumptions set grace_deadline = now() - interval '1 minute' where first_attempt_id = v_a;
    perform app.authorize_grading_access(v_user1, v_a, 'submit_response', 'req-g2');
    raise exception 'expected sample_expired (consumption deadline)';
  exception when others then
    if sqlerrm not like 'grading_access:sample_expired%' then raise; end if;
  end;
  begin
    insert into app.attempts (user_id, learning_session_id, exam_pack_version_id, content_item_version_id, attempt_mode)
    values (v_user1, v_session, v_pack, v_unit1_versions[8], 'mcq');
    raise exception 'expected grace_no_new_questions';
  exception when others then
    if sqlerrm not like 'sample:grace_no_new_questions%' then raise; end if;
  end;
  update app.sample_grants set grace_ends_at = now() - interval '1 minute' where user_id = v_user1;
  if app.sample_grant_phase((select g from app.sample_grants g where user_id = v_user1)) <> 'expired' then raise exception 'phase should be expired'; end if;
  if not app.has_study_readback_access(v_user1, v_pack) then raise exception 'expired must keep readback'; end if;
  begin
    perform app.authorize_grading_access(v_user1, v_a, 'submit_response', 'req-e');
    raise exception 'expected sample_expired';
  exception when others then
    if sqlerrm not like 'grading_access:sample_expired%' then raise; end if;
  end;
  n := n + 1;

  -- ------------------------------------------------ trial supersedes permanently
  update app.sample_grants set activated_at = now(), expires_at = now() + interval '72 hours', grace_ends_at = now() + interval '144 hours' where user_id = v_user1;
  insert into app.subject_entitlements (user_id, subject_id, access_tier, status, source, external_reference, starts_at, ends_at)
  values (v_user1, v_subject, 'trial', 'active', 'stripe_trial_v1', 'test-order', now(), now() + interval '7 days');
  if (select status from app.sample_grants where user_id = v_user1) <> 'superseded' then raise exception 'trial did not supersede'; end if;
  if app.authorize_grading_access(v_user1, v_a, 'grade_initial_attempt', 'req-t') <> 'entitled' then raise exception 'trial should be entitled'; end if;
  -- cancel the trial the DECISION-0126 way (status revoked): sample practice does not come back
  update app.subject_entitlements set status = 'revoked', ends_at = greatest(now(), starts_at + interval '1 millisecond') where user_id = v_user1 and access_tier = 'trial';
  if app.has_study_subject_access(v_user1, 'ap-statistics') then raise exception 'cancelled trial revived sample'; end if;
  begin
    perform app.authorize_grading_access(v_user1, v_a, 'submit_response', 'req-c');
    raise exception 'expected sample_superseded';
  exception when others then
    if sqlerrm not like 'grading_access:sample_superseded%' then raise; end if;
  end;
  if not app.has_study_readback_access(v_user1, v_pack) then raise exception 'superseded must keep readback'; end if;
  n := n + 1;

  -- ------------------------------------------------------- eligibility rules
  -- user2: prior entitlement row (any status) -> not eligible
  v_res := app.sample_try_start('ap-statistics', 1, null, v_tok2, 'ip', '{}'::jsonb);
  select max(choice_key) into v_pick from app.mcq_choices where content_item_version_id = (v_res->'try'->'question'->>'content_item_version_id')::uuid;
  perform app.sample_try_answer(v_tok2, v_pick);
  insert into app.subject_entitlements (user_id, subject_id, access_tier, status, source, starts_at, ends_at)
  values (v_user2, v_subject, 'trial', 'expired', 'trial_v1', now() - interval '30 days', now() - interval '23 days');
  begin
    perform app.claim_sample_try(v_user2, v_tok2);
    raise exception 'expected not_eligible_prior_access';
  exception when others then
    if sqlerrm not like 'sample:not_eligible_prior_access%' then raise; end if;
  end;
  if exists (select 1 from app.sample_grants where user_id = v_user2) then raise exception 'refused claim left a grant'; end if;
  -- user3: a consumed trial email -> not eligible; then clean and succeed
  insert into app.trial_consumed_emails (email_hash, source) values (app.trial_email_hash('sample-test-3@example.invalid'), 'stripe_trial_v1');
  begin
    perform app.claim_sample_try(v_user3, v_tok2);
    raise exception 'expected not_eligible_prior_trial';
  exception when others then
    if sqlerrm not like 'sample:not_eligible_prior_trial%' then raise; end if;
  end;
  delete from app.trial_consumed_emails where email_hash = app.trial_email_hash('sample-test-3@example.invalid');
  v_state := app.claim_sample_try(v_user3, v_tok2);
  if (v_state->>'has_grant')::boolean is not true then raise exception 'user3 claim'; end if;
  n := n + 1;

  -- ----------------------------------------------------------- kill switch
  update app.config set config_value = 'false'::jsonb where config_key in ('sample_access_enabled', 'sample_access_honor_existing');
  if app.sample_grant_phase((select g from app.sample_grants g where user_id = v_user3)) <> 'disabled' then raise exception 'disabled phase'; end if;
  if app.has_study_subject_access(v_user3, 'ap-statistics') then raise exception 'disabled must not admit'; end if;
  if not app.has_study_readback_access(v_user3, v_pack) then raise exception 'disabled must keep readback'; end if;
  begin
    perform app.claim_sample_try(v_user1, v_tok3);
    raise exception 'expected sample:disabled';
  exception when others then
    if sqlerrm not like 'sample:disabled%' then raise; end if;
  end;
  n := n + 1;

  -- a regular student is untouched by every sample gate
  if app.sample_serving_scope(v_user2, v_pack) is not null then raise exception 'scope leaked to a non-sample user'; end if;
  n := n + 1;

  -- ------------------------------ QA finding 1 (2026-11-09): future-start entitlement supersedes
  -- user3's grant is still 'active' underneath the kill switch. A paid row that
  -- starts tomorrow must supersede it at insert, and ending that row later must
  -- not revive the sample.
  update app.config set config_value = 'true'::jsonb where config_key in ('sample_access_enabled', 'sample_access_honor_existing');
  if (select status from app.sample_grants where user_id = v_user3) <> 'active' then raise exception 'user3 grant should still be active'; end if;
  insert into app.subject_entitlements (user_id, subject_id, access_tier, status, source, external_reference, starts_at, ends_at)
  values (v_user3, v_subject, 'paid', 'active', 'stripe_checkout_v1', 'test-future', now() + interval '1 day', now() + interval '31 days');
  if (select status from app.sample_grants where user_id = v_user3) <> 'superseded' then raise exception 'future-start entitlement did not supersede'; end if;
  if (select superseded_by from app.sample_grants where user_id = v_user3) <> 'paid' then raise exception 'superseded_by should be paid'; end if;
  update app.subject_entitlements set status = 'revoked', ends_at = greatest(now(), starts_at + interval '1 millisecond')
  where user_id = v_user3 and external_reference = 'test-future';
  if app.has_study_subject_access(v_user3, 'ap-statistics') then raise exception 'ended future-start entitlement revived the sample'; end if;
  if app.sample_grant_phase((select g from app.sample_grants g where user_id = v_user3)) <> 'superseded' then raise exception 'phase should stay superseded'; end if;
  if not app.has_study_readback_access(v_user3, v_pack) then raise exception 'superseded must keep readback (future-start)'; end if;
  n := n + 1;

  raise exception 'SAMPLE_ACCESS_TESTS_PASSED (% checks)', n;
end;
$t$;
