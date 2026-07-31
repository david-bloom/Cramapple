-- TASK-0019 repeatable rollback-only integration coverage.
--
-- Run as postgres/service administration after all TASK-0019 migrations.
-- This creates only target/session rows and rolls every change back.

begin;

do $$
declare
  v_user_id uuid;
  v_other_user_id uuid;
  v_pack_id uuid;
  v_other_pack_id uuid;
  v_item_id uuid;
  v_issued jsonb;
  v_replayed jsonb;
  v_consumed jsonb;
  v_target_id uuid;
  v_session_id uuid;
  v_practice_format text;
  v_before integer;
  v_after integer;
  v_index integer;
  v_quota_target_id uuid;
begin
  if (
    select count(*)
    from pg_class c
    join pg_namespace n on n.oid = c.relnamespace
    where c.relname = 'session_targets'
      and c.relkind in ('r', 'p', 'v', 'm')
  ) <> 1
     or to_regclass('app.session_targets') is null
     or to_regclass('public.session_targets') is not null then
    raise exception 'TASK0019 requires exactly app.session_targets';
  end if;

  if has_table_privilege(
       'service_role',
       'app.session_target_items',
       'update'
     )
     or has_table_privilege(
       'service_role',
       'app.session_target_items',
       'delete'
     ) then
    raise exception 'TASK0019 target item mutation privileges are too broad';
  end if;

  select
    se.user_id,
    epv.id,
    civ.id
  into v_user_id, v_pack_id, v_item_id
  from app.subject_entitlements se
  join app.exam_packs ep on ep.subject_id = se.subject_id
  join app.exam_pack_versions epv on epv.exam_pack_id = ep.id
  join app.content_items ci on ci.exam_pack_version_id = epv.id
  join app.content_item_versions civ on civ.content_item_id = ci.id
  join app.mcq_choices choice on choice.content_item_version_id = civ.id
  join app.home_release_manifest m on m.exam_pack_version_id = epv.id
  where se.status = 'active'
    and se.starts_at <= now()
    and (se.ends_at is null or se.ends_at > now())
    and epv.status = 'published'
    and ci.status = 'published'
    and civ.status = 'published'
    and ci.item_type = 'mcq'
    and not exists (
      select 1
      from app.learning_sessions ls
      where ls.user_id = se.user_id
        and ls.status = 'active'
    )
  order by se.user_id, epv.id, civ.id
  limit 1;

  if v_user_id is null then
    raise exception 'TASK0019 test requires an entitled user with one published MCQ';
  end if;

  update app.home_release_manifest
  set quick_start_enabled = true,
      minimum_published_items = 1
  where exam_pack_version_id = v_pack_id;

  update app.profiles
  set active_exam_pack_version_id = v_pack_id
  where user_id = v_user_id;

  select user_id
  into v_other_user_id
  from app.profiles
  where user_id <> v_user_id
  order by user_id
  limit 1;

  if v_other_user_id is null then
    raise exception 'TASK0019 test requires a second profile';
  end if;

  select id
  into v_other_pack_id
  from app.exam_pack_versions
  where id <> v_pack_id
    and status = 'published'
  order by id
  limit 1;

  select count(*) into v_before
  from app.session_targets
  where user_id = v_user_id;

  begin
    perform public.issue_session_target(
      v_user_id,
      v_pack_id,
      'first_session',
      'qa-invalid-uuid',
      '[{"content_item_version_id":"not-a-uuid"}]'::jsonb,
      '{}'::jsonb,
      '{}'::jsonb,
      '{"mode":"reissue"}'::jsonb,
      5,
      900
    );
    raise exception 'TASK0019 malformed UUID unexpectedly succeeded';
  exception
    when others then
      if position('session_target:invalid_items' in sqlerrm) = 0 then
        raise;
      end if;
  end;

  select count(*) into v_after
  from app.session_targets
  where user_id = v_user_id;
  if v_after <> v_before then
    raise exception 'TASK0019 malformed input wrote a target';
  end if;

  begin
    perform public.issue_session_target(
      v_user_id,
      v_pack_id,
      'first_session',
      'qa-non-object-item',
      '["not-an-object"]'::jsonb,
      '{}'::jsonb,
      '{}'::jsonb,
      '{"mode":"reissue"}'::jsonb,
      5,
      900
    );
    raise exception 'TASK0019 non-object item unexpectedly succeeded';
  exception
    when others then
      if position('session_target:invalid_items' in sqlerrm) = 0 then
        raise;
      end if;
  end;

  v_issued := public.issue_session_target(
    v_user_id,
    v_pack_id,
    'first_session',
    'qa-primary-target',
    jsonb_build_array(jsonb_build_object(
      'content_item_version_id', v_item_id
    )),
    '{"formats":["mcq"]}'::jsonb,
    '{"source":"task0019_qa"}'::jsonb,
    '{"mode":"reissue"}'::jsonb,
    5,
    900
  );
  v_target_id := (v_issued->>'target_id')::uuid;

  v_replayed := public.issue_session_target(
    v_user_id,
    v_pack_id,
    'first_session',
    'qa-primary-target',
    jsonb_build_array(jsonb_build_object(
      'content_item_version_id', v_item_id
    )),
    '{"formats":["mcq"]}'::jsonb,
    '{"source":"task0019_qa"}'::jsonb,
    '{"mode":"reissue"}'::jsonb,
    5,
    900
  );
  if v_replayed->>'target_id' <> v_issued->>'target_id' then
    raise exception 'TASK0019 issuance replay returned another target';
  end if;

  if (
    public.consume_session_target(v_other_user_id, v_target_id, v_pack_id)
      ->>'code'
  ) <> 'target_not_found' then
    raise exception 'TASK0019 cross-user consume disclosed a target';
  end if;

  if v_other_pack_id is not null
     and (
       public.consume_session_target(
         v_user_id,
         v_target_id,
         v_other_pack_id
       )->>'code'
     ) <> 'target_wrong_pack' then
    raise exception 'TASK0019 wrong-pack consume did not fail closed';
  end if;

  v_consumed := public.consume_session_target(
    v_user_id,
    v_target_id,
    v_pack_id
  );
  if v_consumed->>'ok' <> 'true'
     or v_consumed->>'idempotent_replay' <> 'false' then
    raise exception 'TASK0019 first consume failed: %', v_consumed;
  end if;
  v_session_id := (v_consumed->>'learning_session_id')::uuid;

  select practice_format
  into v_practice_format
  from app.learning_sessions
  where id = v_session_id;
  if v_practice_format <> 'mcq' then
    raise exception
      'TASK0019 session practice_format mismatch: %',
      v_practice_format;
  end if;

  v_replayed := public.consume_session_target(
    v_user_id,
    v_target_id,
    v_pack_id
  );
  if v_replayed->>'ok' <> 'true'
     or v_replayed->>'idempotent_replay' <> 'true'
     or v_replayed->>'learning_session_id' <> v_session_id::text then
    raise exception 'TASK0019 consume replay was not idempotent: %', v_replayed;
  end if;

  for v_index in 1..10 loop
    v_replayed := public.issue_session_target(
      v_user_id,
      v_pack_id,
      'first_session',
      'qa-quota-' || lpad(v_index::text, 2, '0'),
      jsonb_build_array(jsonb_build_object(
        'content_item_version_id', v_item_id
      )),
      '{"formats":["mcq"]}'::jsonb,
      jsonb_build_object('source', 'task0019_qa', 'ordinal', v_index),
      '{"mode":"reissue"}'::jsonb,
      5,
      900
    );
    if v_index = 1 then
      v_quota_target_id := (v_replayed->>'target_id')::uuid;
    end if;
  end loop;

  if (
    public.consume_session_target(
      v_user_id,
      v_quota_target_id,
      v_pack_id
    )->>'code'
  ) <> 'target_active_session_exists' then
    raise exception 'TASK0019 allowed a second active learning session';
  end if;

  begin
    perform public.issue_session_target(
      v_user_id,
      v_pack_id,
      'first_session',
      'qa-quota-overflow',
      jsonb_build_array(jsonb_build_object(
        'content_item_version_id', v_item_id
      )),
      '{"formats":["mcq"]}'::jsonb,
      '{"source":"task0019_qa"}'::jsonb,
      '{"mode":"reissue"}'::jsonb,
      5,
      900
    );
    raise exception 'TASK0019 active-target quota unexpectedly allowed N+1';
  exception
    when others then
      if position('session_target:too_many_active_targets' in sqlerrm) = 0 then
        raise;
      end if;
  end;
end;
$$;

rollback;
