-- Extend the entitlement backfill to non-student roles.
--
-- Runs immediately after 20260731160200_free_score_check_growth_funnel, which
-- creates app.subject_entitlements and — critically — replaces the
-- `attempts_owner_insert` RLS policy with `attempts_entitled_owner_insert`,
-- requiring an active entitlement to create an attempt.
--
-- That migration's own backfill covers only `role = 'student'`. In Production
-- that is 7 of 25 profiles (verified 2026-07-31). Without this migration the
-- policy swap revokes attempt-insert from the remaining 18 — 15 tutor, 2 admin,
-- 1 reader — including one admin profile that already has attempts, and every
-- staff account needed for TASK-0018 staff validation.
--
-- All 15 tutors have zero attempts, so nothing they do today breaks; the risk is
-- to admin accounts and to staff QA, not to reviewer workflow.
--
-- Scope note
--   A universal grant makes subject_entitlements a no-op as access control on
--   day one. That is deliberate: this is a migration-safety device so the policy
--   swap cannot lock anyone out. It is NOT an entitlement policy. How a student
--   becomes entitled, and to what, remains an open product decision that must be
--   settled before any student cohort.

begin;

-- Non-student roles only. `role = 'student'` is already covered by
-- 20260731160200 under source 'migration_20260720_existing_student'; a distinct
-- source here avoids duplicate rows under the
-- (user_id, subject_id, access_tier, source) unique constraint while keeping
-- provenance honest.
insert into app.subject_entitlements (
  user_id,
  subject_id,
  access_tier,
  source
)
select
  p.user_id,
  s.id,
  'beta',
  'migration_20260731_staff_backfill'
from app.profiles p
cross join app.subjects s
where p.role is distinct from 'student'
  and s.status = 'active'
on conflict do nothing;

-- Fail closed: after this migration no existing profile may lack an active
-- entitlement, or the attempts policy swap has locked someone out.
do $$
declare unentitled integer;
begin
  select count(*) into unentitled
  from app.profiles p
  where not exists (
    select 1
    from app.subject_entitlements se
    where se.user_id = p.user_id
      and se.status = 'active'
      and se.starts_at <= now()
      and (se.ends_at is null or se.ends_at > now())
  );
  if unentitled > 0 then
    raise exception
      'entitlement backfill incomplete: % profile(s) would lose attempt-insert', unentitled;
  end if;
end
$$;

commit;

-- Verification after apply (read-only):
--   select p.role, count(distinct p.user_id) as profiles,
--          count(distinct se.user_id) as entitled
--   from app.profiles p
--   left join app.subject_entitlements se
--     on se.user_id = p.user_id and se.status = 'active'
--   group by p.role order by p.role;
--   -- entitled must equal profiles for every role
