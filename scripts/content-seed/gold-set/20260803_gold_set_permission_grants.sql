-- DECISION-0045 — grant gold-set review permission.
--
-- Schema/gating: supabase/migrations/20260803140000_gold_set_review_permission.sql
-- Pilot:         docs/research/GOLD_SET_PILOT_STATS_PHYSICS_2026_08_03.md
--
-- Named grantees for the Set B pilot:
--   Jill Schmidlkofer   — AP Statistics (sole Statistics reviewer)
--   Muhammad Saood      — AP Physics 1 / 2 / C-Mech / C-E&M
--
-- Admin users are NOT granted rows: app.gold_set_reader_is_eligible admits
-- role='admin' directly, so a future admin needs no provisioning, and revoking
-- an admin's access means changing their role rather than hunting a flag.
--
-- No expiry. This is a durable permission for a staffed exercise, not a rollout
-- flag — an expiry firing mid-pilot would strand a reader's queue silently.
--
-- Re-runnable. Resolves users by name against role-qualified profiles and aborts
-- rather than granting the wrong person.

begin;

do $$
declare
  v_ids uuid[];
  v_count integer;
  v_assigned_by uuid;
begin
  select array_agg(user_id), count(*)
    into v_ids, v_count
  from app.profiles
  where full_name in ('Jill Schmidlkofer', 'Muhammad Saood')
    and role in ('tutor', 'reader');

  if v_count is distinct from 2 then
    raise exception 'gold_set_grantees_unresolved'
      using detail = format(
        'expected exactly 2 role-qualified grantees, resolved %s', coalesce(v_count, 0)
      );
  end if;

  select user_id into v_assigned_by
  from app.profiles
  where role = 'admin' and full_name = 'David Bloom'
  limit 1;

  insert into app.feature_flag_assignments (
    feature_key, user_id, enabled, expires_at, assigned_by
  )
  select 'gold-set-review', u, true, null, v_assigned_by
  from unnest(v_ids) u
  on conflict (feature_key, user_id) do update
    set enabled = true,
        expires_at = null,
        assigned_by = coalesce(excluded.assigned_by, app.feature_flag_assignments.assigned_by),
        updated_at = pg_catalog.now();
end $$;

commit;

-- Verification.
select p.full_name, p.role, f.enabled, f.expires_at,
       app.gold_set_reader_is_eligible(p.user_id) as eligible
from app.feature_flag_assignments f
join app.profiles p on p.user_id = f.user_id
where f.feature_key = 'gold-set-review'
order by p.full_name;
