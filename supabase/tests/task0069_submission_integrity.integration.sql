-- TASK-0069 — submission integrity for photographed FRQ answers
-- (remediation of docs/qa/QA_TASK0069_CODEX_2026_10_09.md, P1-a, P1-b
-- sequential, P2-a, reserved keys).
--
-- Runs in ONE transaction and always rolls back (the final RAISE carries the
-- results). Uses a real Development student, session, and published FRQ;
-- creates its own attempt, response versions, and attachment rows inside the
-- transaction. Run with:
--   supabase db query --linked --workdir <repo root> -f supabase/tests/task0069_submission_integrity.integration.sql
-- or the Supabase MCP execute_sql. Expected: an error whose message begins
-- "TASK0069_INTEGRITY ALL PASS".

begin;

do $$
declare
  v_user uuid;
  v_session uuid;
  v_pack uuid;
  v_civ uuid;
  v_ci uuid;
  v_attempt uuid;
  v_rv uuid;
  v_att_a uuid;
  v_att_b uuid;
  v_digest_a text := repeat('a', 64);
  v_digest_b text := repeat('b', 64);
  v_attempt2 uuid;
  v_rv2 uuid;
  v_attempt3 uuid;
  v_rv3 uuid;
  v_results text[] := '{}';
  v_fail int := 0;
  v_msg text;
  v_row app.response_versions;
begin
  -- Fixture: the most recent smoke student with a session in a pack that has a published FRQ.
  select ls.user_id, ls.id, ls.exam_pack_version_id
    into v_user, v_session, v_pack
    from app.learning_sessions ls
    join auth.users u on u.id = ls.user_id
   where u.email like 'smoke+frqphoto-student-%'
     and exists (select 1 from app.content_items ci
                  join app.content_item_versions civ on civ.content_item_id = ci.id and civ.status = 'published'
                 where ci.exam_pack_version_id = ls.exam_pack_version_id and ci.item_type = 'frq' and ci.status = 'published')
   order by ls.created_at desc
   limit 1;
  if v_user is null then
    raise exception 'TASK0069_INTEGRITY SKIP: no smoke student session found; run scripts/frq_photo_smoke.mjs first';
  end if;
  select civ.id, ci.id into v_civ, v_ci
    from app.content_items ci
    join app.content_item_versions civ on civ.content_item_id = ci.id and civ.status = 'published'
   where ci.exam_pack_version_id = v_pack and ci.item_type = 'frq' and ci.status = 'published'
   order by ci.content_key limit 1;

  -- Every write below runs as the service role, as the Edge Functions do.
  execute 'set local role service_role';

  insert into app.attempts (user_id, learning_session_id, exam_pack_version_id, content_item_version_id, attempt_mode, status, assistance_state)
  values (v_user, v_session, v_pack, v_civ, 'frq', 'draft', 'independent') returning id into v_attempt;
  insert into app.response_versions (attempt_id, response_parts, version_number, is_submitted, created_by)
  values (v_attempt, '{"capture":"pending"}'::jsonb, 1, false, v_user) returning id into v_rv;
  select id into v_att_a from app.bind_response_attachment(v_rv, v_attempt, v_civ, 'original', null,
    v_user::text || '/integration/' || v_rv::text || '-a.png', 'image/png', 2048, 800, 600, v_digest_a, v_user);

  -- 1. A bound photo with no confirmation cannot be submitted.
  begin
    perform app.submit_response(v_attempt, v_rv, v_user, 'student', 'it-' || gen_random_uuid(), 'h1');
    v_results := array_append(v_results, 'FAIL 1 unconfirmed photo submitted'::text); v_fail := v_fail + 1;
  exception when others then
    if sqlerrm like '%submit_response:transcript_confirmation_required%' then v_results := array_append(v_results, 'PASS 1 unconfirmed refused'::text);
    else v_results := array_append(v_results, ('FAIL 1 wrong error: ' || sqlerrm)::text); v_fail := v_fail + 1; end if;
  end;

  -- 2. Confirming against a different photo digest is refused.
  begin
    perform app.confirm_response_transcript(v_attempt, v_rv, v_user, '{"response":"answer A"}'::jsonb, 'answer A', '{}'::jsonb, v_digest_b, now());
    v_results := array_append(v_results, 'FAIL 2 confirm with wrong photo accepted'::text); v_fail := v_fail + 1;
  exception when others then
    if sqlerrm like '%confirm_transcript:photo_changed%' then v_results := array_append(v_results, 'PASS 2 photo_changed'::text);
    else v_results := array_append(v_results, ('FAIL 2 wrong error: ' || sqlerrm)::text); v_fail := v_fail + 1; end if;
  end;

  -- 3. Confirm A properly; the content digest is stored server-side.
  select * into v_row from app.confirm_response_transcript(v_attempt, v_rv, v_user, '{"response":"answer A"}'::jsonb, 'answer A', '{}'::jsonb, v_digest_a, now());
  if v_row.response_parts ? '_confirmed_content_digest'
     and v_row.response_parts ->> '_confirmed_content_digest' = app.response_content_digest(v_row.response_text, v_row.response_parts)
     and not (v_row.response_parts ? 'capture') then
    v_results := array_append(v_results, 'PASS 3 confirmed with content digest'::text);
  else
    v_results := array_append(v_results, 'FAIL 3 confirmation row malformed'::text); v_fail := v_fail + 1;
  end if;

  -- 4. (QA P1-a) The OWNER edits the confirmed text through their RLS path; submission is refused.
  execute 'reset role';
  perform set_config('request.jwt.claim.sub', v_user::text, true);
  perform set_config('request.jwt.claims', json_build_object('sub', v_user, 'role', 'authenticated')::text, true);
  execute 'set local role authenticated';
  update app.response_versions set response_text = 'answer B' where id = v_rv;
  get diagnostics v_msg = row_count;
  -- reserved keys stay server-only for the owner
  begin
    update app.response_versions set response_parts = response_parts || '{"_confirmed_content_digest":"forged"}'::jsonb where id = v_rv;
    v_results := array_append(v_results, 'FAIL 4b owner wrote a reserved key'::text); v_fail := v_fail + 1;
  exception when others then
    if sqlerrm like '%reserved_keys_are_server_only%' then v_results := array_append(v_results, 'PASS 4b owner cannot write reserved keys'::text);
    else v_results := array_append(v_results, ('FAIL 4b wrong error: ' || sqlerrm)::text); v_fail := v_fail + 1; end if;
  end;
  execute 'reset role';
  execute 'set local role service_role';
  if v_msg <> '1' then
    v_results := array_append(v_results, ('NOTE 4 owner update touched ' || v_msg || ' rows (RLS)')::text);
  end if;
  begin
    perform app.submit_response(v_attempt, v_rv, v_user, 'student', 'it-' || gen_random_uuid(), 'h4');
    v_results := array_append(v_results, 'FAIL 4 edited-after-confirm text submitted'::text); v_fail := v_fail + 1;
  exception when others then
    if sqlerrm like '%submit_response:transcript_confirmation_required%' then v_results := array_append(v_results, 'PASS 4 post-confirm edit refused'::text);
    else v_results := array_append(v_results, ('FAIL 4 wrong error: ' || sqlerrm)::text); v_fail := v_fail + 1; end if;
  end;

  -- 5. Re-confirm, then RETAKE (photo B) before submitting: refused (sequential P1-b).
  perform app.confirm_response_transcript(v_attempt, v_rv, v_user, '{"response":"answer A"}'::jsonb, 'answer A', '{}'::jsonb, v_digest_a, now());
  select id into v_att_b from app.bind_response_attachment(v_rv, v_attempt, v_civ, 'original', v_att_a,
    v_user::text || '/integration/' || v_rv::text || '-b.png', 'image/png', 2048, 800, 600, v_digest_b, v_user);
  begin
    perform app.submit_response(v_attempt, v_rv, v_user, 'student', 'it-' || gen_random_uuid(), 'h5');
    v_results := array_append(v_results, 'FAIL 5 stale confirmation submitted after retake'::text); v_fail := v_fail + 1;
  exception when others then
    if sqlerrm like '%submit_response:transcript_confirmation_required%' then v_results := array_append(v_results, 'PASS 5 retake re-closes the gate'::text);
    else v_results := array_append(v_results, ('FAIL 5 wrong error: ' || sqlerrm)::text); v_fail := v_fail + 1; end if;
  end;

  -- 6. Confirm for photo B; submission now succeeds.
  perform app.confirm_response_transcript(v_attempt, v_rv, v_user, '{"response":"answer from B"}'::jsonb, 'answer from B', '{}'::jsonb, v_digest_b, now());
  begin
    perform app.submit_response(v_attempt, v_rv, v_user, 'student', 'it-' || gen_random_uuid(), 'h6');
    v_results := array_append(v_results, 'PASS 6 confirmed photo submits'::text);
  exception when others then
    v_results := array_append(v_results, ('FAIL 6 confirmed submit refused: ' || sqlerrm)::text); v_fail := v_fail + 1;
  end;

  -- 7. (QA P2-a) A photo_required item with no photo cannot be submitted typed.
  execute 'reset role';
  update app.content_items set response_policy = 'photo_required' where id = v_ci;
  execute 'set local role service_role';
  insert into app.attempts (user_id, learning_session_id, exam_pack_version_id, content_item_version_id, attempt_mode, status, assistance_state)
  values (v_user, v_session, v_pack, v_civ, 'frq', 'draft', 'independent') returning id into v_attempt2;
  insert into app.response_versions (attempt_id, response_text, response_parts, version_number, is_submitted, created_by)
  values (v_attempt2, 'typed only', '{"response":"typed only"}'::jsonb, 1, false, v_user) returning id into v_rv2;
  begin
    perform app.submit_response(v_attempt2, v_rv2, v_user, 'student', 'it-' || gen_random_uuid(), 'h7');
    v_results := array_append(v_results, 'FAIL 7 photo_required typed submit accepted'::text); v_fail := v_fail + 1;
  exception when others then
    if sqlerrm like '%submit_response:photo_required%' then v_results := array_append(v_results, 'PASS 7 photo_required needs a photo'::text);
    else v_results := array_append(v_results, ('FAIL 7 wrong error: ' || sqlerrm)::text); v_fail := v_fail + 1; end if;
  end;

  -- 8. An ordinary photo_allowed FRQ still submits typed, with no photo.
  execute 'reset role';
  update app.content_items set response_policy = 'photo_allowed' where id = v_ci;
  execute 'set local role service_role';
  insert into app.attempts (user_id, learning_session_id, exam_pack_version_id, content_item_version_id, attempt_mode, status, assistance_state)
  values (v_user, v_session, v_pack, v_civ, 'frq', 'draft', 'independent') returning id into v_attempt3;
  insert into app.response_versions (attempt_id, response_text, response_parts, version_number, is_submitted, created_by)
  values (v_attempt3, 'typed answer', '{"response":"typed answer"}'::jsonb, 1, false, v_user) returning id into v_rv3;
  begin
    perform app.submit_response(v_attempt3, v_rv3, v_user, 'student', 'it-' || gen_random_uuid(), 'h8');
    v_results := array_append(v_results, 'PASS 8 typed photo_allowed submits'::text);
  exception when others then
    v_results := array_append(v_results, ('FAIL 8 typed submit refused: ' || sqlerrm)::text); v_fail := v_fail + 1;
  end;

  execute 'reset role';
  raise exception 'TASK0069_INTEGRITY % | %',
    case when v_fail = 0 then 'ALL PASS' else v_fail || ' FAILED' end,
    array_to_string(v_results, ' ; ');
end $$;

rollback;
