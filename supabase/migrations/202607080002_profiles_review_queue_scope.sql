-- Explicit queue-access capability for reviewer surfaces.
--
-- Keep the ordinary reviewer role ordinary. Queue-wide visibility is a
-- separate capability that can be granted to ops/admin users without turning
-- every reviewer into an admin.

begin;

alter table app.profiles
  add column if not exists review_queue_scope text not null default 'my_queue';

alter table app.profiles
  add constraint profiles_review_queue_scope_check
    check (review_queue_scope in ('my_queue', 'all_pending'));

commit;
