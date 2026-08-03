-- Two 25-question AP Chemistry packets for Gulgeldi Darrynow (2026-08-02),
-- per owner instruction after his 70-decision QA (retained: "adequate, worth
-- continuing").
--
-- Chemistry inventory reality: he has already reviewed nearly every clean
-- item. What remains without his involvement is dominated by items carrying
-- peer edit-requests or disapprovals — which doubles as calibration material:
-- every packet item has at least one known peer finding to compare his read
-- against, directly probing the weaknesses his QA found (note-free MCQ
-- approvals, zero lifetime disapprovals).
--
-- Packet A (25 MCQ, label gulgeldi-apchem-packet-a-2026-08-02): third reads
-- on MCQs where Zeeshan and Saood split (approve vs approve_with_edits).
-- Packet B (25 mixed, label gulgeldi-apchem-packet-b-2026-08-02): 2 MCQs
-- including the corrected apchem-mcq-038 v2 (re-test of his one confirmed
-- false clear) + 23 FRQs under open edit-requests.
--
-- Requires 20260802_gulgeldi_qa_fixes.sql applied first (creates mcq-038 v2).

begin;
select pg_advisory_xact_lock(hashtext('cramapple-gulgeldi-two-packets-20260802'));

create temporary table packet_keys (
  content_key text primary key,
  packet char(1) not null
) on commit drop;

insert into packet_keys values
  -- Packet A: 25 MCQs, Zeeshan/Saood split decisions.
  ('apchem-mcq-021','A'),('apchem-mcq-023','A'),('apchem-mcq-027','A'),
  ('apchem-mcq-028','A'),('apchem-mcq-030','A'),('apchem-mcq-033','A'),
  ('apchem-mcq-035','A'),('apchem-mcq-037','A'),('apchem-mcq-039','A'),
  ('apchem-mcq-042','A'),('apchem-mcq-043','A'),('apchem-mcq-044','A'),
  ('apchem-mcq-046','A'),('apchem-mcq-049','A'),('apchem-mcq-051','A'),
  ('apchem-mcq-052','A'),('apchem-mcq-055','A'),('apchem-mcq-056','A'),
  ('apchem-mcq-057','A'),('apchem-mcq-059','A'),('apchem-mcq-062','A'),
  ('apchem-mcq-066','A'),('apchem-mcq-067','A'),('apchem-mcq-069','A'),
  ('apchem-mcq-070','A'),
  -- Packet B: corrected mcq-038 v2 re-test + mcq-068 + 23 FRQs.
  ('apchem-mcq-038','B'),('apchem-mcq-068','B'),
  ('apchem-frq-l-003','B'),('apchem-frq-l-004','B'),('apchem-frq-l-005','B'),
  ('apchem-frq-l-024','B'),('apchem-frq-l-025','B'),('apchem-frq-l-027','B'),
  ('apchem-sfrq-003','B'),('apchem-sfrq-006','B'),('apchem-sfrq-014','B'),
  ('apchem-sfrq-015','B'),('apchem-sfrq-022','B'),('apchem-sfrq-023','B'),
  ('apchem-sfrq-026','B'),('apchem-sfrq-027','B'),('apchem-sfrq-030','B'),
  ('apchem-sfrq-031','B'),('apchem-sfrq-032','B'),('apchem-sfrq-033','B'),
  ('apchem-sfrq-034','B'),('apchem-sfrq-035','B'),('apchem-sfrq-036','B'),
  ('apchem-sfrq-037','B'),('apchem-sfrq-038','B');

create temporary table packet_versions on commit drop as
select pk.content_key, pk.packet, ci.id content_item_id, civ.id content_item_version_id,
       civ.item_type
from packet_keys pk
join app.content_items ci on ci.content_key = pk.content_key
join app.content_item_versions civ on civ.content_item_id = ci.id
where civ.status <> 'retired'
  and civ.version_num = (select max(n.version_num) from app.content_item_versions n
                         where n.content_item_id = ci.id);

do $$
declare v_total int; v_a int; v_b int; v_conflict int; v_qualified boolean;
begin
  select count(*), count(*) filter (where packet='A'), count(*) filter (where packet='B')
  into v_total, v_a, v_b from packet_versions;
  if (v_total, v_a, v_b) <> (50, 25, 25) then
    raise exception 'packet resolution failed: total %, A %, B %', v_total, v_a, v_b;
  end if;

  -- Gulgeldi must have no existing decision on the item and no open assignment.
  -- apchem-mcq-038 is deliberately excluded: it is the intentional re-test of
  -- his prior false clear (v1) on the corrected v2, so a prior decision on
  -- the item is expected, not a packet-building error.
  select count(*) into v_conflict
  from packet_versions pv
  where pv.content_key <> 'apchem-mcq-038'
    and (exists (select 1 from app.content_review_decisions d
      join app.content_item_versions dv on dv.id=d.content_item_version_id
      where d.reviewer_id='119817d1-96c9-4cbc-8fdc-4962e03b1b12'
        and dv.content_item_id=pv.content_item_id)
     or exists (select 1 from app.content_review_assignments a
      where a.reviewer_id='119817d1-96c9-4cbc-8fdc-4962e03b1b12'
        and a.content_item_version_id=pv.content_item_version_id
        and a.status in ('pending','in_progress')));
  if v_conflict <> 0 then
    raise exception '% packet items already have Gulgeldi involvement', v_conflict;
  end if;

  if exists (select 1 from app.content_review_assignments a
      where a.reviewer_id='119817d1-96c9-4cbc-8fdc-4962e03b1b12'
        and a.content_item_version_id=(select content_item_version_id from packet_versions where content_key='apchem-mcq-038')
        and a.status in ('pending','in_progress')) then
    raise exception 'apchem-mcq-038 v2 already assigned to Gulgeldi';
  end if;

  select exists (
    select 1 from app.validator_qualifications vq
    where vq.reviewer_id='119817d1-96c9-4cbc-8fdc-4962e03b1b12'
      and vq.status='active'
      and 'bfb1b3d3-21b4-49c5-b2f6-6b5b6ed16afe'::uuid = any(vq.exam_ids)
      and vq.effective_at <= now() and vq.expires_at > now())
  into v_qualified;
  if not v_qualified then
    raise exception 'Gulgeldi Darrynow does not have an active AP Chemistry qualification';
  end if;
end $$;

insert into app.content_review_assignments (
  content_item_version_id, reviewer_id, review_stage, review_kind, status,
  assignment_purpose, created_by)
select pv.content_item_version_id,
  '119817d1-96c9-4cbc-8fdc-4962e03b1b12'::uuid,
  'tutor_question', pv.item_type, 'pending', 'subject_review',
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from packet_versions pv;

insert into app.content_labels (exam_pack_id, label_key, label_name, label_type, status, created_by)
values
  ('bfb1b3d3-21b4-49c5-b2f6-6b5b6ed16afe'::uuid,
   'gulgeldi-apchem-packet-a-2026-08-02',
   'Gulgeldi AP Chemistry packet A (25 MCQ third reads)',
   'workflow','published','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid),
  ('bfb1b3d3-21b4-49c5-b2f6-6b5b6ed16afe'::uuid,
   'gulgeldi-apchem-packet-b-2026-08-02',
   'Gulgeldi AP Chemistry packet B (mcq-038 v2 re-test + 23 FRQs)',
   'workflow','published','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid);

insert into app.content_item_labels (content_item_id, content_label_id)
select pv.content_item_id, cl.id
from packet_versions pv
join app.content_labels cl
  on cl.label_key = case pv.packet
       when 'A' then 'gulgeldi-apchem-packet-a-2026-08-02'
       else 'gulgeldi-apchem-packet-b-2026-08-02' end
on conflict do nothing;

do $$ declare n int; begin
  select count(*) into n
  from app.content_review_assignments a
  join packet_versions pv on pv.content_item_version_id=a.content_item_version_id
  where a.reviewer_id='119817d1-96c9-4cbc-8fdc-4962e03b1b12' and a.status='pending';
  if n <> 50 then raise exception 'assignment verification failed: %/50', n; end if;
end $$;

commit;