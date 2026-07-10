-- Promote dbloom01@gmail.com to admin for reviewer CC visibility and
-- staff-level operations.
--
-- This only updates an existing profile row. If the auth user does not exist
-- in the target database yet, create/invite the account first through the
-- server-side auth admin flow.

begin;

update app.profiles p
set role = 'admin',
    review_queue_scope = 'all_pending'
where exists (
  select 1
  from auth.users u
  where u.id = p.user_id
    and u.email = 'dbloom01@gmail.com'
);

commit;
