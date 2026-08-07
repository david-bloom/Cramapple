-- Assign Chisom Anuba to review three named AP Calculus AB FRQs on their
-- latest active version: apcalcab-frq-005 (changes_requested), apcalcab-frq-012
-- (published), apcalcab-frq-014 (reviewed_disapproved). Chisom holds an active
-- AP Calculus AB qualification and has no prior assignment or decision on any
-- of the three.
--
-- Owner instruction, 2026-08-06: "Assign apcalcab-frq-005, apcalcab-frq-012,
-- and apcalcab-frq-014 to Chisom." apcalcab-frq-012 is already published;
-- owner confirmed including it anyway.

begin;
select pg_advisory_xact_lock(hashtext('cramapple-chisom-apcalcab-frq-005-012-014-20260806'));

create temporary table packet_versions on commit drop as
select ci.id content_item_id, ci.content_key, ci.item_type, civ.id content_item_version_id
from app.content_items ci
join app.content_item_versions civ on civ.content_item_id=ci.id
where ci.content_key in ('apcalcab-frq-005','apcalcab-frq-012','apcalcab-frq-014')
  and civ.version_num=(select max(n.version_num) from app.content_item_versions n where n.content_item_id=ci.id);

do $$
declare
  v_total integer;
  v_qualified boolean;
begin
  select count(*) into v_total from packet_versions;
  if v_total <> 3 then
    raise exception 'expected 3 named AP Calculus AB targets, found %', v_total;
  end if;

  select exists (
    select 1
    from app.validator_qualifications vq
    join app.exam_packs ep on ep.id = any(select unnest(vq.exam_ids))
    join app.subjects s on s.id=ep.subject_id
    where vq.reviewer_id='1cb76137-fe12-4973-877b-f1e32e9e4cfc'::uuid
      and vq.status='active'
      and vq.effective_at <= now()
      and (vq.expires_at is null or vq.expires_at > now())
      and s.display_name='AP Calculus AB'
  ) into v_qualified;

  if not v_qualified then
    raise exception 'Chisom Anuba does not hold an active AP Calculus AB qualification';
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
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from packet_versions
on conflict (content_item_version_id, reviewer_id, review_stage)
where content_item_version_id is not null
do update set status = 'pending'
where app.content_review_assignments.status <> 'submitted'
  and not exists (
    select 1 from app.content_review_decisions d
    where d.content_review_assignment_id
        = app.content_review_assignments.content_review_assignment_id
  );

insert into app.content_labels (
  exam_pack_id,
  label_key,
  label_name,
  label_type,
  status,
  created_by
)
select distinct
  ep.id,
  'chisom-apcalcab-frq-005-012-014-2026-08-06',
  'Chisom Anuba: apcalcab-frq-005/012/014 named packet',
  'workflow',
  'published',
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from packet_versions pv
join app.content_items ci on ci.id=pv.content_item_id
join app.exam_pack_versions epv on epv.id=ci.exam_pack_version_id
join app.exam_packs ep on ep.id=epv.exam_pack_id
on conflict (exam_pack_id, label_key) do update
set label_name=excluded.label_name,
    label_type=excluded.label_type,
    status=excluded.status;

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
  on a.content_item_version_id=pv.content_item_version_id
 and a.reviewer_id='1cb76137-fe12-4973-877b-f1e32e9e4cfc'::uuid
 and a.review_stage='tutor_question'
 and a.assignment_purpose='subject_review'
 and a.status='pending'
join app.content_items ci on ci.id=pv.content_item_id
join app.exam_pack_versions epv on epv.id=ci.exam_pack_version_id
join app.content_labels l
  on l.exam_pack_id=epv.exam_pack_id
 and l.label_key='chisom-apcalcab-frq-005-012-014-2026-08-06'
on conflict do nothing;

do $$
declare
  v_assignments integer;
begin
  select count(*)
  into v_assignments
  from packet_versions pv
  join app.content_review_assignments a
    on a.content_item_version_id=pv.content_item_version_id
   and a.reviewer_id='1cb76137-fe12-4973-877b-f1e32e9e4cfc'::uuid
   and a.status='pending'
   and a.assignment_purpose='subject_review';

  if v_assignments <> 3 then
    raise exception 'assignment verification failed: pending %, expected 3', v_assignments;
  end if;
end $$;

select ci.content_key, a.status
from packet_versions pv
join app.content_items ci on ci.id=pv.content_item_id
join app.content_review_assignments a
  on a.content_item_version_id=pv.content_item_version_id
 and a.reviewer_id='1cb76137-fe12-4973-877b-f1e32e9e4cfc'::uuid
 and a.assignment_purpose='subject_review'
order by ci.content_key;

commit;
