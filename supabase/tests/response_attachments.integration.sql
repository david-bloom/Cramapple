-- TASK-0011 / TASK-0020 Program B: app.response_attachments verification.
-- Run against Development only. The transaction rolls back every fixture.
--
-- Covers what the migration is actually load-bearing for: the one-current-
-- original constraint (session-contract invariant "a capture-image original
-- cannot be bound to two capture sessions"), the immutable-fields trigger,
-- and owner-scoped RLS select with no client write path. Does not exercise
-- the storage.objects policy tightening (would require inserting real
-- storage.objects rows, which needs the storage extension's own triggers on
-- the target database) -- that half of this migration is unverified here
-- and should be checked manually against a real upload before relying on it.

begin;

create temporary table response_attachments_test_ids (
  key text primary key,
  id uuid not null
) on commit drop;

insert into response_attachments_test_ids (key, id)
select 'user_a', user_id
from app.profiles
where role = 'student'
order by created_at
limit 1;

insert into response_attachments_test_ids (key, id)
select 'user_b', user_id
from app.profiles
where role = 'student'
  and user_id <> (select id from response_attachments_test_ids where key = 'user_a')
order by created_at
limit 1;

insert into response_attachments_test_ids (key, id)
select 'content_item_version', civ.id
from app.content_item_versions civ
join app.content_items ci on ci.id = civ.content_item_id
where civ.status = 'published'
  and ci.status = 'published'
order by civ.id
limit 1;

insert into response_attachments_test_ids (key, id)
select 'exam_pack_version', ci.exam_pack_version_id
from app.content_item_versions civ
join app.content_items ci on ci.id = civ.content_item_id
where civ.id = (select id from response_attachments_test_ids where key = 'content_item_version');

insert into response_attachments_test_ids (key, id)
values
  ('attempt', gen_random_uuid()),
  ('response_version', gen_random_uuid()),
  ('attachment_1', gen_random_uuid()),
  ('attachment_2', gen_random_uuid());

grant select on response_attachments_test_ids to authenticated;

do $$
begin
  if (select count(*) from response_attachments_test_ids) <> 8 then
    raise exception 'response_attachments test requires two student profiles and one published item version';
  end if;
end;
$$;

insert into app.attempts (
  id, user_id, exam_pack_version_id, content_item_version_id, attempt_mode, status
)
values (
  (select id from response_attachments_test_ids where key = 'attempt'),
  (select id from response_attachments_test_ids where key = 'user_a'),
  (select id from response_attachments_test_ids where key = 'exam_pack_version'),
  (select id from response_attachments_test_ids where key = 'content_item_version'),
  'frq',
  'draft'
);

insert into app.response_versions (
  id, attempt_id, response_text, version_number, is_submitted, created_by
)
values (
  (select id from response_attachments_test_ids where key = 'response_version'),
  (select id from response_attachments_test_ids where key = 'attempt'),
  '',
  1,
  false,
  (select id from response_attachments_test_ids where key = 'user_a')
);

-- 1. A normal ORIGINAL insert, as the service/administration role, succeeds.
insert into app.response_attachments (
  id, response_version_id, attempt_id, content_item_version_id, kind,
  storage_path, media_type, byte_size, pixel_width, pixel_height,
  sha256_digest, captured_by
)
values (
  (select id from response_attachments_test_ids where key = 'attachment_1'),
  (select id from response_attachments_test_ids where key = 'response_version'),
  (select id from response_attachments_test_ids where key = 'attempt'),
  (select id from response_attachments_test_ids where key = 'content_item_version'),
  'original',
  (select id from response_attachments_test_ids where key = 'user_a')::text || '/captures/one.jpg',
  'image/jpeg',
  204800,
  1200,
  1600,
  repeat('a', 64),
  (select id from response_attachments_test_ids where key = 'user_a')
);

do $$
begin
  -- 2. A second concurrent-current ORIGINAL for the same response_version
  -- must violate response_attachments_one_current_original.
  begin
    insert into app.response_attachments (
      id, response_version_id, attempt_id, content_item_version_id, kind,
      storage_path, media_type, byte_size, sha256_digest, captured_by
    )
    values (
      (select id from response_attachments_test_ids where key = 'attachment_2'),
      (select id from response_attachments_test_ids where key = 'response_version'),
      (select id from response_attachments_test_ids where key = 'attempt'),
      (select id from response_attachments_test_ids where key = 'content_item_version'),
      'original',
      (select id from response_attachments_test_ids where key = 'user_a')::text || '/captures/two.jpg',
      'image/jpeg',
      204800,
      repeat('b', 64),
      (select id from response_attachments_test_ids where key = 'user_a')
    );
    raise exception 'a second current original was accepted for one response_version';
  exception
    when unique_violation then null;
  end;

  -- 3. Mutating an immutable field (storage_path) must be rejected even for
  -- the administration role -- retakes are new rows, not edits.
  begin
    update app.response_attachments
    set storage_path = 'tampered/path.jpg'
    where id = (select id from response_attachments_test_ids where key = 'attachment_1');
    raise exception 'storage_path mutation was accepted';
  exception
    when others then
      if sqlerrm not like '%only capture_quality_state, is_current, and reviewed_at may change%' then
        raise;
      end if;
  end;

  -- 4. capture_quality_state IS an allowed mutation.
  update app.response_attachments
  set capture_quality_state = 'acceptable'
  where id = (select id from response_attachments_test_ids where key = 'attachment_1');
  if (
    select capture_quality_state from app.response_attachments
    where id = (select id from response_attachments_test_ids where key = 'attachment_1')
  ) <> 'acceptable' then
    raise exception 'capture_quality_state update did not persist';
  end if;
end;
$$;

-- 5. Owner-scoped RLS: user_a sees exactly their own attachment.
select set_config(
  'request.jwt.claims',
  json_build_object(
    'sub', (select id from response_attachments_test_ids where key = 'user_a'),
    'role', 'authenticated'
  )::text,
  true
);
set local role authenticated;

do $$
begin
  if (select count(*) from app.response_attachments) <> 1 then
    raise exception 'owner select returned an unexpected row count';
  end if;

  -- 6. No insert policy exists for authenticated -- a direct client insert
  -- must fail (RLS denies rather than silently no-op-ing).
  begin
    insert into app.response_attachments (
      response_version_id, attempt_id, content_item_version_id, kind,
      storage_path, media_type, byte_size, sha256_digest, captured_by
    )
    values (
      (select id from response_attachments_test_ids where key = 'response_version'),
      (select id from response_attachments_test_ids where key = 'attempt'),
      (select id from response_attachments_test_ids where key = 'content_item_version'),
      'derived',
      (select id from response_attachments_test_ids where key = 'user_a')::text || '/captures/client-direct.jpg',
      'image/jpeg',
      204800,
      repeat('c', 64),
      (select id from response_attachments_test_ids where key = 'user_a')
    );
    raise exception 'authenticated client inserted a response_attachments row directly';
  exception
    when insufficient_privilege then null;
    when others then
      -- RLS with no matching policy typically surfaces as a row-security
      -- violation rather than insufficient_privilege; accept either.
      if sqlerrm not ilike '%row-level security%' then
        raise;
      end if;
  end;
end;
$$;

reset role;

select set_config(
  'request.jwt.claims',
  json_build_object(
    'sub', (select id from response_attachments_test_ids where key = 'user_b'),
    'role', 'authenticated'
  )::text,
  true
);
set local role authenticated;

do $$
begin
  -- 7. user_b, who owns none of this attempt's rows, sees nothing.
  if (select count(*) from app.response_attachments) <> 0 then
    raise exception 'RLS leaked another learner''s response attachment';
  end if;
end;
$$;

reset role;

rollback;
