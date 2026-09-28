-- TASK-0039: structural guarantees of the byoq_* tables.
-- Run against Development only. Everything rolls back.
--
-- Covers: DECISION-0057's "no answer column" rule extended into the choices
-- jsonb; the answer-leak gate on `ready`; composite-FK owner pinning; the
-- atomic claim/bind RPCs and one-current-page rule; RLS (owner sees own rows,
-- a different authenticated user sees zero, anon has no grant).
-- Each assertion raises on failure; reaching the final SELECT means pass.

begin;

create temporary table t_ids (key text primary key, id uuid not null) on commit drop;
grant select on t_ids to authenticated;

do $$
declare
  v_user_a uuid;
  v_user_b uuid;
  v_anon uuid;
  v_rec uuid;
  v_item uuid;
  v_item_b uuid;
  v_resp uuid;
  v_tok app.byoq_capture_pairing_tokens;
  v_att app.byoq_attachments;
  v_att2 app.byoq_attachments;
  v_failed boolean;
begin
  select user_id into v_user_a from app.profiles order by created_at limit 1;
  select user_id into v_user_b from app.profiles where user_id <> v_user_a order by created_at limit 1;
  if v_user_a is null or v_user_b is null then
    raise exception 'fixture: need two profiles';
  end if;

  insert into app.byoq_owners (key_sha256) values (repeat('a', 64)) returning id into v_anon;
  insert into app.byoq_owners (user_id) values (v_user_a) returning id into v_rec;

  -- Owner must have an identity.
  begin
    insert into app.byoq_owners (key_sha256, user_id) values (null, null);
    raise exception 'FAIL: identity-less owner accepted';
  exception when check_violation then null;
  end;

  -- Anonymous item, draft with no stem (photo-first intake).
  insert into app.byoq_items (owner_id, code, source_kind)
    values (v_anon, 'BQ-ABCDEF', 'photo_single') returning id into v_item;

  -- Recognized item for user A.
  insert into app.byoq_items (owner_id, user_id, code, item_type, stem, status)
    values (v_rec, v_user_a, 'BQ-ABCDEF', 'frq', 'Describe the association.', 'ready')
    returning id into v_item_b;

  -- DECISION-0057: an is_correct key inside choices is rejected.
  begin
    update app.byoq_items set item_type = 'mcq', stem = 'Q?',
      choices = '[{"choice_key":"A","choice_text":"x","is_correct":true},{"choice_key":"B","choice_text":"y"}]'
      where id = v_item;
    raise exception 'FAIL: is_correct accepted in choices';
  exception when check_violation then null;
  end;

  -- Valid MCQ choices accepted; ready gate refuses while leak flags exist.
  update app.byoq_items set item_type = 'mcq', stem = 'Which? Answer: B',
    choices = '[{"choice_key":"A","choice_text":"x"},{"choice_key":"B","choice_text":"y"}]',
    leak_flags = '[{"field":"stem","start":8,"end":17,"rule":"answer_label"}]'
    where id = v_item;
  begin
    update app.byoq_items set status = 'ready' where id = v_item;
    raise exception 'FAIL: ready accepted with leak flags';
  exception when check_violation then null;
  end;
  update app.byoq_items set stem = 'Which?', leak_flags = '[]', status = 'ready' where id = v_item;

  -- MCQ with one choice cannot be ready.
  begin
    update app.byoq_items set choices = '[{"choice_key":"A","choice_text":"x"}]' where id = v_item;
    raise exception 'FAIL: ready MCQ with one choice accepted';
  exception when check_violation then null;
  end;

  -- Composite FK: a response cannot claim a different owner than its item.
  begin
    insert into app.byoq_responses (item_id, owner_id, attempt_number, version_number)
      values (v_item, v_rec, 1, 1);
    raise exception 'FAIL: cross-owner response accepted';
  exception when foreign_key_violation then null;
  end;

  insert into app.byoq_responses (item_id, owner_id, attempt_number, version_number, response_text)
    values (v_item_b, v_rec, 1, 1, 'my work') returning id into v_resp;

  -- Response token must name a response of the SAME item.
  begin
    insert into app.byoq_capture_pairing_tokens
      (handle_sha256, owner_id, item_id, capture_role, response_id, expires_at)
      values (repeat('b', 64), v_anon, v_item, 'response', v_resp, now() + interval '15 minutes');
    raise exception 'FAIL: token bound to another item''s response accepted';
  exception when foreign_key_violation then null;
  end;

  -- Question token -> claim -> bind two pages -> retake page 1.
  insert into app.byoq_capture_pairing_tokens
    (handle_sha256, owner_id, item_id, capture_role, expires_at)
    values (repeat('c', 64), v_anon, v_item, 'question', now() + interval '15 minutes')
    returning * into v_tok;

  -- Only one live token per slot.
  begin
    insert into app.byoq_capture_pairing_tokens
      (handle_sha256, owner_id, item_id, capture_role, expires_at)
      values (repeat('d', 64), v_anon, v_item, 'question', now() + interval '15 minutes');
    raise exception 'FAIL: second live token for same slot accepted';
  exception when unique_violation then null;
  end;

  -- Binding fields immutable.
  begin
    update app.byoq_capture_pairing_tokens set item_id = v_item_b where id = v_tok.id;
    raise exception 'FAIL: token rebinding accepted';
  exception when raise_exception then
    if sqlerrm like 'FAIL:%' then raise; end if;
  end;

  -- Bind before claim is refused (state issued).
  v_failed := false;
  begin
    perform app.bind_byoq_attachment(v_tok.id, 'byoq-anon/x/p0.jpg', 'image/jpeg', 2000, 10, 10, repeat('e', 64), 'STRIPPED', null, 20);
  exception when raise_exception then v_failed := sqlerrm = 'byoq_bind:pairing_not_live';
  end;
  if not v_failed then raise exception 'FAIL: bind on unclaimed token'; end if;

  select * into v_tok from app.claim_byoq_capture_upload(repeat('c', 64), 10, 'QR');
  if v_tok.state <> 'paired' or v_tok.redemption_attempts <> 1 then
    raise exception 'FAIL: claim state % attempts %', v_tok.state, v_tok.redemption_attempts;
  end if;

  select * into v_att from app.bind_byoq_attachment(v_tok.id, 'byoq-anon/x/p1.jpg', 'image/jpeg', 2000, 10, 10, repeat('e', 64), 'STRIPPED', null, 20);
  select * into v_att2 from app.bind_byoq_attachment(v_tok.id, 'byoq-anon/x/p2.jpg', 'image/jpeg', 2000, 10, 10, repeat('f', 64), 'STRIPPED', null, 20);
  if v_att.page_sequence <> 1 or v_att2.page_sequence <> 2 then
    raise exception 'FAIL: page sequence % %', v_att.page_sequence, v_att2.page_sequence;
  end if;
  if v_att.owner_id <> v_anon or v_att.item_id <> v_item or v_att.capture_role <> 'question' then
    raise exception 'FAIL: bind did not derive binding from token';
  end if;

  select * into v_att2 from app.bind_byoq_attachment(v_tok.id, 'byoq-anon/x/p1b.jpg', 'image/jpeg', 2000, 10, 10, repeat('1', 64), 'STRIPPED', v_att.id, 20);
  if v_att2.page_sequence <> 1 or v_att2.replaces_attachment_id <> v_att.id then
    raise exception 'FAIL: retake did not replace page 1';
  end if;
  if (select is_current from app.byoq_attachments where id = v_att.id) then
    raise exception 'FAIL: replaced page still current';
  end if;

  -- Stale retake target refused.
  v_failed := false;
  begin
    perform app.bind_byoq_attachment(v_tok.id, 'byoq-anon/x/p1c.jpg', 'image/jpeg', 2000, 10, 10, repeat('2', 64), 'STRIPPED', v_att.id, 20);
  exception when raise_exception then v_failed := sqlerrm = 'byoq_bind:stale_retake_target';
  end;
  if not v_failed then raise exception 'FAIL: stale retake accepted'; end if;

  -- Page cap enforced.
  v_failed := false;
  begin
    perform app.bind_byoq_attachment(v_tok.id, 'byoq-anon/x/p3.jpg', 'image/jpeg', 2000, 10, 10, repeat('3', 64), 'STRIPPED', null, 2);
  exception when raise_exception then v_failed := sqlerrm = 'byoq_bind:page_limit_reached';
  end;
  if not v_failed then raise exception 'FAIL: page cap not enforced'; end if;

  -- Expired token: claim commits 'expired' and returns it.
  insert into app.byoq_capture_pairing_tokens
    (handle_sha256, owner_id, item_id, capture_role, response_id, expires_at)
    values (repeat('9', 64), v_rec, v_item_b, 'response', v_resp, now() - interval '1 second')
    returning * into v_tok;
  select * into v_tok from app.claim_byoq_capture_upload(repeat('9', 64), 10, 'QR');
  if v_tok.state <> 'expired' then raise exception 'FAIL: expired claim state %', v_tok.state; end if;

  insert into t_ids values ('user_a', v_user_a), ('user_b', v_user_b), ('item_b', v_item_b), ('item_anon', v_item);
end;
$$;

-- RLS: user A sees their recognized item and its response; not the anonymous one.
set local role authenticated;
select set_config('request.jwt.claims',
  json_build_object('sub', (select id from t_ids where key = 'user_a'), 'role', 'authenticated')::text, true);
do $$
begin
  if (select count(*) from app.byoq_items) <> 1 then
    raise exception 'FAIL: owner sees % items', (select count(*) from app.byoq_items);
  end if;
  if (select count(*) from app.byoq_responses) <> 1 then
    raise exception 'FAIL: owner sees % responses', (select count(*) from app.byoq_responses);
  end if;
  begin
    perform 1 from app.byoq_owners;
    raise exception 'FAIL: authenticated can read byoq_owners';
  exception when insufficient_privilege then null;
  end;
  begin
    perform 1 from app.byoq_capture_pairing_tokens;
    raise exception 'FAIL: authenticated can read pairing tokens';
  exception when insufficient_privilege then null;
  end;
  begin
    insert into app.byoq_responses (item_id, owner_id, attempt_number, version_number)
      select id, owner_id, 9, 9 from app.byoq_items limit 1;
    raise exception 'FAIL: authenticated can write responses';
  exception when insufficient_privilege then null;
  end;
end;
$$;

-- RLS: user B (non-owner) sees zero rows.
select set_config('request.jwt.claims',
  json_build_object('sub', (select id from t_ids where key = 'user_b'), 'role', 'authenticated')::text, true);
do $$
begin
  if (select count(*) from app.byoq_items) <> 0
    or (select count(*) from app.byoq_responses) <> 0
    or (select count(*) from app.byoq_attachments) <> 0 then
    raise exception 'FAIL: non-owner sees BYOQ rows';
  end if;
end;
$$;

reset role;
set local role anon;
do $$
begin
  perform 1 from app.byoq_items;
  raise exception 'FAIL: anon can read byoq_items';
exception when insufficient_privilege then null;
end;
$$;
reset role;

select 'task0039_byoq_core: all assertions passed' as result;

rollback;
