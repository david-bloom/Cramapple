-- DECISION-0045: gate gold-set verification behind an explicit permission.
--
-- 20260803120000 admitted any profile with role admin/tutor/reader. That is too
-- broad: the gold set is a small, deliberately-staffed certification exercise,
-- and an unbriefed tutor wandering into the queue would consume answers that
-- can never be re-verified cold by anyone else. A consumed answer is not
-- recoverable — marks are write-once — so access has to be opt-in per person.
--
-- Reuses app.feature_flag_assignments (the home-v2 mechanism) rather than a
-- parallel permission table, so grants and revocations are ordinary data
-- changes rather than migrations.
--
-- Grants are seeded separately in
-- scripts/content-seed/gold-set/20260803_gold_set_permission_grants.sql.

begin;

-- Admins qualify by role so a new admin needs no provisioning. Everyone else
-- needs an unexpired, enabled 'gold-set-review' flag.
create or replace function app.gold_set_reader_is_eligible(p_user_id uuid)
returns boolean
language sql
stable
security definer
set search_path = pg_catalog
as $$
  select exists (
    select 1 from app.profiles p
    where p.user_id = p_user_id and p.role = 'admin'
  ) or exists (
    select 1 from app.feature_flag_assignments f
    join app.profiles p on p.user_id = f.user_id
    where f.user_id = p_user_id
      and f.feature_key = 'gold-set-review'
      and f.enabled
      and (f.expires_at is null or f.expires_at > pg_catalog.now())
      and p.role in ('admin', 'tutor', 'reader')
  );
$$;

comment on function app.gold_set_reader_is_eligible(uuid) is
  'Gold-set access: admin by role, or an unexpired gold-set-review flag on a '
  'reviewer profile. Gates both the reader RPCs and queue seeding.';

revoke all on function app.gold_set_reader_is_eligible(uuid)
  from public, anon, authenticated;
grant execute on function app.gold_set_reader_is_eligible(uuid) to service_role;

-- Lets the reviewer portal decide whether to show the gold-set entry at all,
-- without the client having to interpret roles or flag expiry itself.
create or replace function public.gold_set_access()
returns boolean
language plpgsql
stable
security definer
set search_path = pg_catalog
as $$
declare
  v_user_id uuid := auth.uid();
begin
  if v_user_id is null then
    return false;
  end if;
  return app.gold_set_reader_is_eligible(v_user_id);
end;
$$;

revoke all on function public.gold_set_access() from public, anon;
grant execute on function public.gold_set_access() to authenticated;

commit;
