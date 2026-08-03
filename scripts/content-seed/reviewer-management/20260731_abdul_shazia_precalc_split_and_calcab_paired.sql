-- Three review packets for Abdul Hanan and Shazia Fazal (2026-07-31).
--
-- Owner instruction (David Bloom): Abdul and Shazia continue; Qamar Ul Zaman
-- receives no further packets. Qamar has zero pending assignments, so no
-- reassignment is required — packets are push-assigned, and simply not
-- including him removes him from the queue.
--
-- Packet 1  Abdul Hanan   — 25 AP Precalculus drafts (10 FRQ + 15 MCQ), odd half
-- Packet 2  Shazia Fazal  — 25 AP Precalculus drafts (10 FRQ + 15 MCQ), even half
-- Packet 3  BOTH          — the same 25 AP Calculus AB drafts (10 FRQ + 15 MCQ),
--                           blind-paired so every item gets two independent reads
--
-- Precalculus is split by row-number parity over content_key so each reviewer
-- gets an interleaved spread of the bank rather than a contiguous block, which
-- would correlate with authoring order. The two halves are disjoint: 50 drafts
-- covered, one read each.
--
-- Calculus AB is paired rather than split. Neither reviewer has worked this
-- subject before, so the shared 25 double as a calibration baseline. This is a
-- deliberate coverage trade: 25 items with two reads instead of 50 with one.
--
-- Reviewer ids
--   Abdul Hanan   002e94ca-c634-4086-bea8-37390c0d3edf
--   Shazia Fazal  1e6f9c8e-d6ad-4b39-b33b-b31a93020945
--   created_by    f5a26c6b-3566-4d58-9e97-979fbb947564  (dbloom01, admin)
-- Exam packs
--   ap_precalculus  72afc44a-7a56-4d45-ae3c-621c926ed6ab
--   ap_calculus_ab  73bf288d-10f1-42aa-8d97-0f5e5e4dd50e

begin;

select pg_advisory_xact_lock(
  hashtext('cramapple-abdul-shazia-packets-20260731')
);

-- Eligible pool: draft versions with no live review coverage.
create temporary table pool on commit drop as
select ep.exam_code,
       ci.item_type,
       ci.content_key,
       civ.id as content_item_version_id,
       row_number() over (
         partition by ep.exam_code, ci.item_type order by ci.content_key
       ) as rn
from app.content_items ci
join app.content_item_versions civ on civ.content_item_id = ci.id
join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
join app.exam_packs ep on ep.id = epv.exam_pack_id
where ep.exam_code in ('ap_precalculus', 'ap_calculus_ab')
  and civ.status = 'draft'
  and not exists (
    select 1 from app.content_review_assignments a
    where a.content_item_version_id = civ.id
      and a.status in ('pending', 'in_progress', 'submitted')
  );

-- Guard the pool shape and both reviewers' qualifications before writing.
do $$
declare
  v_pc_frq int; v_pc_mcq int; v_ab_frq int; v_ab_mcq int; v_ok boolean;
begin
  select count(*) filter (where exam_code='ap_precalculus' and item_type='frq'),
         count(*) filter (where exam_code='ap_precalculus' and item_type='mcq'),
         count(*) filter (where exam_code='ap_calculus_ab' and item_type='frq'),
         count(*) filter (where exam_code='ap_calculus_ab' and item_type='mcq')
    into v_pc_frq, v_pc_mcq, v_ab_frq, v_ab_mcq
  from pool;

  if (v_pc_frq, v_pc_mcq, v_ab_frq, v_ab_mcq) <> (20, 30, 20, 30) then
    raise exception
      'pool changed: precalc %/% frq/mcq, calcab %/% frq/mcq',
      v_pc_frq, v_pc_mcq, v_ab_frq, v_ab_mcq;
  end if;

  select bool_and(x) into v_ok from (
    select exists (
      select 1 from app.validator_qualifications vq
      where vq.reviewer_id = r.id and vq.status='active'
        and e.pack = any(vq.exam_ids)
        and vq.effective_at <= now() and vq.expires_at > now()
    ) as x
    from (values
      ('002e94ca-c634-4086-bea8-37390c0d3edf'::uuid),
      ('1e6f9c8e-d6ad-4b39-b33b-b31a93020945'::uuid)) r(id)
    cross join (values
      ('72afc44a-7a56-4d45-ae3c-621c926ed6ab'::uuid),
      ('73bf288d-10f1-42aa-8d97-0f5e5e4dd50e'::uuid)) e(pack)
  ) q;

  if not v_ok then
    raise exception 'Abdul or Shazia lacks an active Precalculus/Calculus AB qualification';
  end if;
end $$;

-- Packet membership. Precalculus splits on parity; Calculus AB takes the first
-- 10 FRQ and 15 MCQ by content_key and carries one shared blind group per item.
create temporary table packet on commit drop as
select content_item_version_id, content_key, item_type,
       'abdul-precalculus-25-draft-sweep-2026-07-31' as label_key,
       '72afc44a-7a56-4d45-ae3c-621c926ed6ab'::uuid as exam_pack_id,
       array['002e94ca-c634-4086-bea8-37390c0d3edf'::uuid] as reviewers,
       gen_random_uuid() as blind_group_id
from pool
where exam_code='ap_precalculus' and rn % 2 = 1
  and ((item_type='frq' and rn <= 19) or (item_type='mcq' and rn <= 29))
union all
select content_item_version_id, content_key, item_type,
       'shazia-precalculus-25-draft-sweep-2026-07-31',
       '72afc44a-7a56-4d45-ae3c-621c926ed6ab'::uuid,
       array['1e6f9c8e-d6ad-4b39-b33b-b31a93020945'::uuid],
       gen_random_uuid()
from pool
where exam_code='ap_precalculus' and rn % 2 = 0
  and ((item_type='frq' and rn <= 20) or (item_type='mcq' and rn <= 30))
union all
select content_item_version_id, content_key, item_type,
       'abdul-shazia-calculus-ab-25-paired-2026-07-31',
       '73bf288d-10f1-42aa-8d97-0f5e5e4dd50e'::uuid,
       array['002e94ca-c634-4086-bea8-37390c0d3edf'::uuid,
             '1e6f9c8e-d6ad-4b39-b33b-b31a93020945'::uuid],
       gen_random_uuid()
from pool
where exam_code='ap_calculus_ab'
  and ((item_type='frq' and rn <= 10) or (item_type='mcq' and rn <= 15));

insert into app.content_labels (
  exam_pack_id, label_key, label_name, label_type, status, created_by)
values
  ('72afc44a-7a56-4d45-ae3c-621c926ed6ab'::uuid,
   'abdul-precalculus-25-draft-sweep-2026-07-31',
   'Abdul Hanan Precalculus 25-question draft sweep', 'workflow', 'published',
   'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid),
  ('72afc44a-7a56-4d45-ae3c-621c926ed6ab'::uuid,
   'shazia-precalculus-25-draft-sweep-2026-07-31',
   'Shazia Fazal Precalculus 25-question draft sweep', 'workflow', 'published',
   'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid),
  ('73bf288d-10f1-42aa-8d97-0f5e5e4dd50e'::uuid,
   'abdul-shazia-calculus-ab-25-paired-2026-07-31',
   'Abdul Hanan / Shazia Fazal Calculus AB 25-question blind pair',
   'workflow', 'published', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid)
on conflict (exam_pack_id, label_key) do update
set label_name = excluded.label_name,
    label_type = excluded.label_type,
    status = excluded.status;

insert into app.content_review_assignments (
  content_item_version_id, reviewer_id, review_stage, review_kind,
  blind_group_id, status, assignment_purpose, created_by)
select p.content_item_version_id, r.reviewer_id, 'tutor_question', p.item_type,
       p.blind_group_id, 'pending', 'subject_review',
       'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from packet p
cross join lateral unnest(p.reviewers) as r(reviewer_id);

insert into app.content_review_assignment_labels (
  content_review_assignment_id, content_label_id, created_by)
select a.content_review_assignment_id, l.id,
       'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from packet p
cross join lateral unnest(p.reviewers) as r(reviewer_id)
join app.content_review_assignments a
  on a.content_item_version_id = p.content_item_version_id
 and a.reviewer_id = r.reviewer_id
 and a.review_stage = 'tutor_question'
 and a.status = 'pending'
join app.content_labels l
  on l.exam_pack_id = p.exam_pack_id and l.label_key = p.label_key;

-- Verify: 25 + 25 + (25 x 2) = 100 pending assignments, all labeled, and every
-- Calculus AB item carrying exactly two readers in one blind group.
do $$
declare
  v_abdul_pc int; v_shazia_pc int; v_ab int; v_labeled int; v_paired int; v_overlap int;
begin
  select count(*) filter (where l.label_key='abdul-precalculus-25-draft-sweep-2026-07-31'),
         count(*) filter (where l.label_key='shazia-precalculus-25-draft-sweep-2026-07-31'),
         count(*) filter (where l.label_key='abdul-shazia-calculus-ab-25-paired-2026-07-31'),
         count(*)
    into v_abdul_pc, v_shazia_pc, v_ab, v_labeled
  from app.content_review_assignment_labels al
  join app.content_labels l on l.id = al.content_label_id
  join app.content_review_assignments a
    on a.content_review_assignment_id = al.content_review_assignment_id
  where l.label_key in (
    'abdul-precalculus-25-draft-sweep-2026-07-31',
    'shazia-precalculus-25-draft-sweep-2026-07-31',
    'abdul-shazia-calculus-ab-25-paired-2026-07-31');

  select count(*) into v_paired from (
    select p.blind_group_id from packet p
    where p.label_key='abdul-shazia-calculus-ab-25-paired-2026-07-31'
      and (select count(distinct a.reviewer_id) from app.content_review_assignments a
           where a.blind_group_id = p.blind_group_id) = 2) z;

  -- the two Precalculus halves must not intersect
  select count(*) into v_overlap
  from packet a join packet b
    on a.content_item_version_id = b.content_item_version_id
   and a.label_key <> b.label_key
  where a.label_key like '%precalculus%' and b.label_key like '%precalculus%';

  if (v_abdul_pc, v_shazia_pc, v_ab, v_labeled, v_paired, v_overlap)
     <> (25, 25, 50, 100, 25, 0) then
    raise exception
      'packet verification failed: abdul %, shazia %, calcab %, labeled %, paired %, overlap %',
      v_abdul_pc, v_shazia_pc, v_ab, v_labeled, v_paired, v_overlap;
  end if;
end $$;

commit;
