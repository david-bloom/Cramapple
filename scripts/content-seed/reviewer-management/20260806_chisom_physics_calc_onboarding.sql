-- Onboard Chisom Anuba (US-based AP Physics / Calculus tutor) with a first
-- round of gold-set marking and a published-content spot check.
--
-- Owner instruction, 2026-08-06: "please assign him 1 of each of the 4
-- physics questions (4 total) for gold set work, and 5 physics and 5
-- calculus questions which are published to do a quality spot check."
--
-- Chisom already exists as a tutor (user_id 1cb76137-fe12-4973-877b-f1e32e9e4cfc)
-- with an active 'grading' validator_qualification covering all 4 AP Physics
-- courses, both AP Calculus courses, and AP Precalculus (granted same day,
-- 2026-08-06). This script:
--   1. Grants the `gold-set-review` feature flag (gates access to the
--      gold-set queue; see 20260803_gold_set_permission_grants.sql for the
--      original two grantees, Jill Schmidlkofer and Muhammad Saood).
--   2. Seeds 4 gold-set verification assignments via
--      app.seed_gold_set_verification_assignments -- one A1 answer from each
--      of the 4 Physics item pools already loaded (apphy1-frq-002,
--      apphy2-frq-001, apphycem-frq-019, apphycm-frq-002). No physics
--      gold-set answers have been assigned to any reviewer before this.
--   3. Assigns a subject_review/tutor_question spot-check packet: 5 randomly
--      sampled published Physics items + 5 randomly sampled published Calc
--      (AB/BC) items, restricted to items Chisom has never reviewed (any
--      version, any status).

begin;
select pg_advisory_xact_lock(hashtext('cramapple-chisom-physics-calc-onboarding-20260806'));

-- 1. Gold-set access.
do $$
declare
  v_chisom uuid := '1cb76137-fe12-4973-877b-f1e32e9e4cfc';
  v_assigned_by uuid;
begin
  if not exists (
    select 1 from app.profiles where user_id = v_chisom and full_name = 'Chisom Anuba'
  ) then
    raise exception 'chisom_profile_not_found';
  end if;

  select user_id into v_assigned_by
  from app.profiles
  where role = 'admin' and full_name = 'David'
  limit 1;

  insert into app.feature_flag_assignments (
    feature_key, user_id, enabled, expires_at, assigned_by
  )
  values ('gold-set-review', v_chisom, true, null, v_assigned_by)
  on conflict (feature_key, user_id) do update
    set enabled = true,
        expires_at = null,
        assigned_by = coalesce(excluded.assigned_by, app.feature_flag_assignments.assigned_by),
        updated_at = pg_catalog.now();
end $$;

-- 2. Gold-set answers: one A1 answer per Physics course.
select app.seed_gold_set_verification_assignments(
  '1cb76137-fe12-4973-877b-f1e32e9e4cfc'::uuid,
  array[
    '4d1742c5-a7e0-4371-87f5-061ec5d601d8', -- AP Physics 1, apphy1-frq-002, A1
    '2a982ce8-1c69-475b-a34a-0f56bd6f6791', -- AP Physics 2, apphy2-frq-001, A1
    '219ab99f-bc3e-43c5-bf29-60f8fc6a4e16', -- AP Physics C: E&M, apphycem-frq-019, A1
    'bec29523-1c59-4944-a875-ee0824bf5606'  -- AP Physics C: Mechanics, apphycm-frq-002, A1
  ]::uuid[],
  1 -- only 4 answers across 4 distinct items; sibling spacing is moot
) as gold_set_assignments_created;

-- 3. Published spot-check packet: 5 Physics + 5 Calc (AB/BC), random,
-- excluding anything Chisom has already reviewed at any version.
create temporary table spotcheck_pool on commit drop as
with candidates as (
  select
    ci.id content_item_id, ci.content_key, ci.item_type,
    civ.id content_item_version_id, s.display_name subject,
    case when s.display_name like 'AP Physics%' then 'physics' else 'calc' end pool
  from app.content_items ci
  join app.content_item_versions civ on civ.content_item_id = ci.id
  join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  join app.subjects s on s.id = ep.subject_id
  where civ.status = 'published'
    and s.display_name in (
      'AP Physics 1', 'AP Physics 2',
      'AP Physics C: Mechanics', 'AP Physics C: Electricity and Magnetism',
      'AP Calculus AB', 'AP Calculus BC'
    )
    and civ.version_num = (
      select max(n.version_num) from app.content_item_versions n
      where n.content_item_id = ci.id
    )
), chisom_reviewed as (
  select distinct ci.id content_item_id
  from app.content_items ci
  join app.content_item_versions civ on civ.content_item_id = ci.id
  join app.content_review_decisions d on d.content_item_version_id = civ.id
   and d.review_stage = 'tutor_question'
  where d.reviewer_id = '1cb76137-fe12-4973-877b-f1e32e9e4cfc'::uuid
), eligible as (
  select c.* from candidates c
  where not exists (
    select 1 from chisom_reviewed r where r.content_item_id = c.content_item_id
  )
), ranked as (
  select *, row_number() over (partition by pool order by random()) rn
  from eligible
)
select content_item_id, content_key, item_type, content_item_version_id, subject, pool
from ranked
where rn <= 5;

do $$
declare
  v_physics integer;
  v_calc integer;
begin
  select count(*) into v_physics from spotcheck_pool where pool = 'physics';
  select count(*) into v_calc from spotcheck_pool where pool = 'calc';
  if v_physics <> 5 or v_calc <> 5 then
    raise exception 'spotcheck_pool_size_mismatch: physics=%, calc=%', v_physics, v_calc;
  end if;
end $$;

insert into app.content_review_assignments (
  content_item_version_id,
  reviewer_id,
  review_stage,
  review_kind,
  status,
  assignment_purpose,
  created_by
)
select
  content_item_version_id,
  '1cb76137-fe12-4973-877b-f1e32e9e4cfc'::uuid,
  'tutor_question',
  item_type,
  'pending',
  'subject_review',
  (select user_id from app.profiles where role = 'admin' and full_name = 'David' limit 1)
from spotcheck_pool pv
where not exists (
  select 1 from app.content_review_assignments existing
  where existing.content_item_version_id = pv.content_item_version_id
    and existing.reviewer_id = '1cb76137-fe12-4973-877b-f1e32e9e4cfc'::uuid
    and existing.review_stage = 'tutor_question'
);

insert into app.content_labels (
  exam_pack_id, label_key, label_name, label_type, status, created_by
)
select distinct
  ep.id,
  'chisom-published-spotcheck-2026-08-06',
  'Chisom Anuba published-content spot check: 5 Physics + 5 Calc, 2026-08-06',
  'workflow',
  'published',
  (select user_id from app.profiles where role = 'admin' and full_name = 'David' limit 1)
from spotcheck_pool pv
join app.content_items ci on ci.id = pv.content_item_id
join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
join app.exam_packs ep on ep.id = epv.exam_pack_id
on conflict (exam_pack_id, label_key) do update
set label_name = excluded.label_name,
    label_type = excluded.label_type,
    status = excluded.status;

insert into app.content_review_assignment_labels (
  content_review_assignment_id, content_label_id, created_by
)
select
  a.content_review_assignment_id,
  l.id,
  (select user_id from app.profiles where role = 'admin' and full_name = 'David' limit 1)
from spotcheck_pool pv
join app.content_review_assignments a
  on a.content_item_version_id = pv.content_item_version_id
 and a.reviewer_id = '1cb76137-fe12-4973-877b-f1e32e9e4cfc'::uuid
 and a.review_stage = 'tutor_question'
 and a.assignment_purpose = 'subject_review'
 and a.status = 'pending'
join app.content_items ci on ci.id = pv.content_item_id
join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
join app.content_labels l
  on l.exam_pack_id = epv.exam_pack_id
 and l.label_key = 'chisom-published-spotcheck-2026-08-06'
on conflict do nothing;

-- Verification.
select pool, count(*)::integer assigned_count
from spotcheck_pool
group by pool
order by pool;

select subject, content_key, item_type from spotcheck_pool order by pool, subject, content_key;

commit;
