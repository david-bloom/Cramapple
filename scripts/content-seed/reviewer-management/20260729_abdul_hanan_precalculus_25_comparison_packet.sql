-- Assign Abdul Hanan a 25-question AP Precalculus comparison packet.
--
-- Every version in this packet was previously reviewed and submitted by
-- Muhammad Saood. The packet contains all 20 distinct MCQs Saood reviewed and
-- 5 FRQs selected across all three assessed units and four difficulty bands.
-- Abdul's review remains independent; Saood's assignments and decisions are
-- not modified.

begin;

select pg_advisory_xact_lock(
  hashtext('cramapple-abdul-hanan-precalculus-25-comparison-20260729')
);

create temporary table packet_versions (
  content_item_id uuid primary key,
  content_item_version_id uuid unique not null,
  content_key text unique not null,
  item_type text not null,
  unit_key text not null,
  difficulty text not null
) on commit drop;

insert into packet_versions (
  content_item_id,
  content_item_version_id,
  content_key,
  item_type,
  unit_key,
  difficulty
)
values
  -- Five FRQs: all three units; Easy, Medium, Hard, and Very Hard represented.
  ('a0a31592-8448-4ebb-bff4-6e047a358540', '8cf724d0-8c3c-4028-a562-f0a7d0bd5e7b', 'apprecalc-frq-001', 'frq', 'unit-1-polynomial-and-rational-functions',        'Easy'),
  ('fb7bdc5c-ad0c-47a0-b02d-8a3263726cf6', '6d969ff3-9cc5-499d-bb33-c6a5d01d76a3', 'apprecalc-frq-004', 'frq', 'unit-1-polynomial-and-rational-functions',        'Medium'),
  ('ebcc3300-7c1c-4a92-9410-db134babd4a2', 'f4e57f34-3f08-4006-bfca-0eb40357cc55', 'apprecalc-frq-007', 'frq', 'unit-2-exponential-and-logarithmic-functions',    'Hard'),
  ('b15f31e5-dc3e-4a25-98d3-87d970ca1f63', '4bd24714-e7a9-4f0d-89a0-24592a2d9223', 'apprecalc-frq-008', 'frq', 'unit-2-exponential-and-logarithmic-functions',    'Very Hard'),
  ('c86c0f52-8efd-47f5-8c12-f2dc825e6429', '84e2a207-ae56-4351-9186-1549aff27762', 'apprecalc-frq-012', 'frq', 'unit-3-trigonometric-and-polar-functions',        'Very Hard'),

  -- All 20 distinct MCQs previously reviewed by Saood.
  ('8d4ffc83-2de5-4313-88db-c0c4e05568d9', '4bc0ca14-819e-4cb5-b943-475144240855', 'apprecalc-mcq-001', 'mcq', 'unit-1-polynomial-and-rational-functions',        'Easy'),
  ('59e9d5ed-a7c3-4029-974f-aa9ed2db77a8', '75878da0-4881-4cd6-b6e1-a46a177ff6fc', 'apprecalc-mcq-002', 'mcq', 'unit-1-polynomial-and-rational-functions',        'Medium'),
  ('7c67499f-eb06-435a-b680-f906c1b03a17', '58ea3472-e4ea-4fc4-a9c2-fd8848044534', 'apprecalc-mcq-003', 'mcq', 'unit-1-polynomial-and-rational-functions',        'Medium'),
  ('bc650703-b06b-4b82-8098-3189b297560a', '95daa0ae-0637-4383-b15a-1ffbe8dfb769', 'apprecalc-mcq-004', 'mcq', 'unit-1-polynomial-and-rational-functions',        'Hard'),
  ('23e2183f-35d7-4f17-9afe-55091bfb93ef', '8a117b2f-28e4-45d3-a066-c70df240825b', 'apprecalc-mcq-005', 'mcq', 'unit-1-polynomial-and-rational-functions',        'Medium'),
  ('0b48cdbe-70d2-4778-abc2-58b9dbb37fcf', '7d7de511-761c-4ad5-91ed-d898ea0b5cc1', 'apprecalc-mcq-006', 'mcq', 'unit-1-polynomial-and-rational-functions',        'Hard'),
  ('eeff4f64-6714-48f7-ab91-9188090c5b44', 'db4e7d67-9e5b-4806-8ddf-9ea933024ef5', 'apprecalc-mcq-007', 'mcq', 'unit-1-polynomial-and-rational-functions',        'Very Hard'),
  ('1f1463e0-02c9-45aa-9989-2ac827fc7b7f', '8cf47932-7788-485b-936b-6523b4839944', 'apprecalc-mcq-008', 'mcq', 'unit-2-exponential-and-logarithmic-functions',    'Easy'),
  ('5f7153d8-1847-4b48-ac4e-fc3ea7a22300', '49df68cb-6eac-4008-a748-4cb5eca8df2c', 'apprecalc-mcq-009', 'mcq', 'unit-2-exponential-and-logarithmic-functions',    'Medium'),
  ('52d9e355-21e0-4cbf-8fff-9ca41df05141', '0bd7c6f4-4e79-4f9d-b4d8-55f7d7dc1279', 'apprecalc-mcq-010', 'mcq', 'unit-2-exponential-and-logarithmic-functions',    'Medium'),
  ('936f3260-6acc-47b1-83e3-2823d454365a', 'baa544a6-6f5a-4a8b-a08a-50e27e9b0906', 'apprecalc-mcq-011', 'mcq', 'unit-2-exponential-and-logarithmic-functions',    'Hard'),
  ('ae772233-4acc-4026-a3a5-e81fcd23e3b8', '44faf9f2-1803-4975-ad11-617ff3fe53dd', 'apprecalc-mcq-012', 'mcq', 'unit-2-exponential-and-logarithmic-functions',    'Hard'),
  ('82c12233-a38d-44b9-a88a-975ee56b8067', 'ad7657b3-e4c2-42a7-8665-c6478054537d', 'apprecalc-mcq-013', 'mcq', 'unit-2-exponential-and-logarithmic-functions',    'Easy'),
  ('ffc6ba57-f497-44f2-b415-d6cabb14d731', '0107c7cf-3cdd-4dac-8c15-68afd51abc50', 'apprecalc-mcq-014', 'mcq', 'unit-2-exponential-and-logarithmic-functions',    'Very Hard'),
  ('5a20746d-6ccf-41eb-92a9-023ca0d7b48e', 'a1f63e82-1230-44fe-8310-dce757e79ea5', 'apprecalc-mcq-015', 'mcq', 'unit-3-trigonometric-and-polar-functions',        'Easy'),
  ('ab2c24de-134b-48f5-b5f9-0e0fd53cea1c', '2da1d8b6-740a-4986-98f1-353626b5d4fb', 'apprecalc-mcq-016', 'mcq', 'unit-3-trigonometric-and-polar-functions',        'Medium'),
  ('087fea54-0fac-492c-a1f7-6b018171718f', '8f4d3521-2ffe-41d9-b984-0ad794740c85', 'apprecalc-mcq-017', 'mcq', 'unit-3-trigonometric-and-polar-functions',        'Hard'),
  ('6dd47853-40a8-421b-a870-56da47d0385e', '997ef4a5-dde2-4b96-a6f3-9b02e7162137', 'apprecalc-mcq-018', 'mcq', 'unit-3-trigonometric-and-polar-functions',        'Medium'),
  ('90ddfb94-7b62-4ad7-8415-967c2a62ee64', 'bfe94dae-e683-4a3b-b772-3a7c948af4e5', 'apprecalc-mcq-019', 'mcq', 'unit-3-trigonometric-and-polar-functions',        'Hard'),
  ('960cf041-d338-4251-88a0-5e5e8571f655', '62f4499f-0651-422f-9678-548a88cfd8a0', 'apprecalc-mcq-020', 'mcq', 'unit-3-trigonometric-and-polar-functions',        'Medium');

do $$
declare
  v_total integer;
  v_mcq integer;
  v_frq integer;
  v_units integer;
  v_easy integer;
  v_medium integer;
  v_hard integer;
  v_very_hard integer;
  v_invalid integer;
  v_saood_reviewed integer;
  v_abdul_existing integer;
  v_qualified boolean;
begin
  select
    count(*),
    count(*) filter (where item_type = 'mcq'),
    count(*) filter (where item_type = 'frq'),
    count(distinct unit_key),
    count(*) filter (where difficulty = 'Easy'),
    count(*) filter (where difficulty = 'Medium'),
    count(*) filter (where difficulty = 'Hard'),
    count(*) filter (where difficulty = 'Very Hard')
  into
    v_total, v_mcq, v_frq, v_units,
    v_easy, v_medium, v_hard, v_very_hard
  from packet_versions;

  if (v_total, v_mcq, v_frq, v_units, v_easy, v_medium, v_hard, v_very_hard)
     <> (25, 20, 5, 3, 5, 9, 7, 4) then
    raise exception
      'Precalculus packet distribution changed: total %, MCQ %, FRQ %, units %, difficulty %/%/%/%',
      v_total, v_mcq, v_frq, v_units, v_easy, v_medium, v_hard, v_very_hard;
  end if;

  select count(*)
  into v_invalid
  from packet_versions pv
  left join app.content_items ci
    on ci.id = pv.content_item_id
  left join app.content_item_versions civ
    on civ.id = pv.content_item_version_id
   and civ.content_item_id = ci.id
  left join app.exam_pack_versions epv
    on epv.id = ci.exam_pack_version_id
  where ci.id is null
     or civ.id is null
     or ci.content_key <> pv.content_key
     or ci.item_type <> pv.item_type
     or civ.prompt_json->>'difficulty' <> pv.difficulty
     or civ.prompt_json#>>'{taxonomy_refs,0,node_key}' <> pv.unit_key
     or epv.exam_pack_id <> '72afc44a-7a56-4d45-ae3c-621c926ed6ab'::uuid;

  if v_invalid <> 0 then
    raise exception
      'Precalculus packet contains % missing or metadata-mismatched versions',
      v_invalid;
  end if;

  select count(*)
  into v_saood_reviewed
  from packet_versions pv
  where exists (
    select 1
    from app.content_review_decisions d
    where d.content_item_version_id = pv.content_item_version_id
      and d.reviewer_id =
        'cee0cee4-fc59-4084-9a83-b24ccca940b9'::uuid
      and d.review_stage = 'tutor_question'
  );

  if v_saood_reviewed <> 25 then
    raise exception
      'Comparison invariant failed: only % of 25 versions have a Saood decision',
      v_saood_reviewed;
  end if;

  select count(*)
  into v_abdul_existing
  from packet_versions pv
  join app.content_review_assignments a
    on a.content_item_version_id = pv.content_item_version_id
   and a.reviewer_id =
     '002e94ca-c634-4086-bea8-37390c0d3edf'::uuid
   and a.review_stage = 'tutor_question';

  if v_abdul_existing <> 0 then
    raise exception
      'Abdul already has % assignments from the intended packet',
      v_abdul_existing;
  end if;

  select exists (
    select 1
    from app.validator_qualifications vq
    where vq.reviewer_id =
      '002e94ca-c634-4086-bea8-37390c0d3edf'::uuid
      and vq.status = 'active'
      and '72afc44a-7a56-4d45-ae3c-621c926ed6ab'::uuid = any(vq.exam_ids)
      and vq.effective_at <= now()
      and vq.expires_at > now()
  )
  into v_qualified;

  if not v_qualified then
    raise exception 'Abdul Hanan does not have an active AP Precalculus qualification';
  end if;
end
$$;

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
  pv.content_item_version_id,
  '002e94ca-c634-4086-bea8-37390c0d3edf'::uuid,
  'tutor_question',
  pv.item_type,
  'pending',
  'subject_review',
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from packet_versions pv;

insert into app.content_labels (
  exam_pack_id,
  label_key,
  label_name,
  label_type,
  status,
  created_by
)
values (
  '72afc44a-7a56-4d45-ae3c-621c926ed6ab'::uuid,
  'abdul-hanan-precalculus-25-comparison-2026-07-29',
  'Abdul Hanan Precalculus 25-question review',
  'workflow',
  'published',
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
)
on conflict (exam_pack_id, label_key) do update
set label_name = excluded.label_name,
    label_type = excluded.label_type,
    status = excluded.status;

insert into app.content_review_assignment_labels (
  content_review_assignment_id,
  content_label_id,
  created_by
)
select
  a.content_review_assignment_id,
  l.id,
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from packet_versions pv
join app.content_review_assignments a
  on a.content_item_version_id = pv.content_item_version_id
 and a.reviewer_id = '002e94ca-c634-4086-bea8-37390c0d3edf'::uuid
 and a.review_stage = 'tutor_question'
join app.content_labels l
  on l.exam_pack_id = '72afc44a-7a56-4d45-ae3c-621c926ed6ab'::uuid
 and l.label_key = 'abdul-hanan-precalculus-25-comparison-2026-07-29';

do $$
declare
  v_assignments integer;
  v_pending integer;
  v_labeled integer;
  v_overlap integer;
begin
  select
    count(*),
    count(*) filter (where a.status = 'pending')
  into v_assignments, v_pending
  from packet_versions pv
  join app.content_review_assignments a
    on a.content_item_version_id = pv.content_item_version_id
   and a.reviewer_id = '002e94ca-c634-4086-bea8-37390c0d3edf'::uuid
   and a.review_stage = 'tutor_question'
   and a.review_kind = pv.item_type
   and a.assignment_purpose = 'subject_review';

  select count(*)
  into v_labeled
  from packet_versions pv
  join app.content_review_assignments a
    on a.content_item_version_id = pv.content_item_version_id
   and a.reviewer_id = '002e94ca-c634-4086-bea8-37390c0d3edf'::uuid
   and a.review_stage = 'tutor_question'
  join app.content_review_assignment_labels al
    on al.content_review_assignment_id = a.content_review_assignment_id
  join app.content_labels l
    on l.id = al.content_label_id
   and l.label_key =
     'abdul-hanan-precalculus-25-comparison-2026-07-29';

  select count(*)
  into v_overlap
  from packet_versions pv
  where exists (
    select 1
    from app.content_review_decisions d
    where d.content_item_version_id = pv.content_item_version_id
      and d.reviewer_id =
        'cee0cee4-fc59-4084-9a83-b24ccca940b9'::uuid
      and d.review_stage = 'tutor_question'
  );

  if (v_assignments, v_pending, v_labeled, v_overlap)
     <> (25, 25, 25, 25) then
    raise exception
      'Precalculus comparison reconciliation failed: assignments %, pending %, labeled %, Saood overlap %',
      v_assignments, v_pending, v_labeled, v_overlap;
  end if;
end
$$;

commit;
