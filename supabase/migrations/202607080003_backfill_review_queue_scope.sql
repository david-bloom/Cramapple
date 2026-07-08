-- Backfill explicit queue visibility for known ops/admin users.
--
-- David Bloom is an admin and should see the all-pending CC view.
-- Ordinary reviewers stay on the default `my_queue` scope.

begin;

update app.profiles p
set review_queue_scope = 'all_pending'
where exists (
  select 1
  from auth.users u
  where u.id = p.user_id
    and u.email = 'dbloom01@gmail.com'
)
and p.role = 'admin';

commit;
