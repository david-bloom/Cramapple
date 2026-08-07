-- Assign Muhammad Saood the AP Calculus AB/BC items with exactly one human
-- tutor_question decision (approve or approve_with_edits) on the latest
-- active version, where the item is not published and Saood is not the
-- reviewer who made that decision. All 25 qualifying items were sole-reviewed
-- by Abdul Hanan (all AP Calculus AB); none exist in AP Calculus BC. Saood is
-- qualified for both subjects.
--
-- Owner instruction, 2026-08-06: "look for any calculus subject question with
-- is not published AND has been reviewed by one reviewer AND has a label
-- Approved or Approved with Edits AND was not reviewed by Saood. Assign those
-- questions to Saood."

begin;
select pg_advisory_xact_lock(hashtext('cramapple-saood-calculus-single-reviewed-packet-20260806'));

create temporary table packet_versions on commit drop as
with calc as (
  select
    ci.id content_item_id, ci.content_key, ci.item_type,
    civ.id content_item_version_id, civ.version_num, civ.status version_status
  from app.content_items ci
  join app.content_item_versions civ on civ.content_item_id=ci.id
  join app.exam_pack_versions epv on epv.id=ci.exam_pack_version_id
  join app.exam_packs ep on ep.id=epv.exam_pack_id
  join app.subjects s on s.id=ep.subject_id
  where s.display_name in ('AP Calculus AB','AP Calculus BC')
    and ci.status <> 'published'
    and civ.status <> 'retired'
    and civ.version_num=(
      select max(n.version_num)
      from app.content_item_versions n
      where n.content_item_id=ci.id
    )
), decided_current as (
  select a.*, d.reviewer_id, p.full_name reviewer_name,
    coalesce(
      d.tutor_decision,
      case d.tutor_score
        when 1 then 'approve'
        when 2 then 'approve_with_edits'
        when 3 then 'disapprove'
      end
    ) decision
  from calc a
  join app.content_review_decisions d
    on d.content_item_version_id=a.content_item_version_id
   and d.review_stage='tutor_question'
  join app.content_review_assignments cra
    on cra.content_review_assignment_id=d.content_review_assignment_id
   and cra.assignment_purpose='subject_review'
  join app.profiles p on p.user_id=d.reviewer_id
), agg as (
  select content_item_id, content_key, item_type, content_item_version_id,
    count(*) total_decisions,
    string_agg(distinct reviewer_name, ', ') reviewer_names,
    bool_and(decision in ('approve','approve_with_edits')) all_approve_or_awe
  from decided_current
  group by content_item_id, content_key, item_type, content_item_version_id
), eligible as (
  select content_item_id, content_key, item_type, content_item_version_id
  from agg
  where total_decisions=1
    and all_approve_or_awe
    and reviewer_names <> 'Muhammad Saood'
), saood_any_version as (
  select distinct ci.id content_item_id
  from app.content_items ci
  join app.content_item_versions civ on civ.content_item_id=ci.id
  join app.content_review_decisions d on d.content_item_version_id=civ.id and d.review_stage='tutor_question'
  join app.content_review_assignments cra
    on cra.content_review_assignment_id=d.content_review_assignment_id
   and cra.assignment_purpose='subject_review'
  join app.profiles p on p.user_id=d.reviewer_id
  where p.full_name='Muhammad Saood'
)
select e.content_item_id, e.content_key, e.item_type, e.content_item_version_id
from eligible e
where not exists (select 1 from saood_any_version av where av.content_item_id=e.content_item_id)
  and not exists (
    select 1
    from app.content_review_assignments existing
    where existing.content_item_version_id=e.content_item_version_id
      and existing.reviewer_id='cee0cee4-fc59-4084-9a83-b24ccca940b9'::uuid
      and existing.status in ('pending','in_progress')
  );

do $$
declare
  v_total integer;
  v_qualified boolean;
begin
  select count(*) into v_total from packet_versions;

  if v_total <> 25 then
    raise exception 'expected 25 single-reviewed AP Calculus AB/BC targets, found %', v_total;
  end if;

  select exists (
    select 1
    from app.validator_qualifications vq
    join app.exam_packs ep on ep.id = any(select unnest(vq.exam_ids))
    join app.subjects s on s.id=ep.subject_id
    where vq.reviewer_id='cee0cee4-fc59-4084-9a83-b24ccca940b9'::uuid
      and vq.status='active'
      and vq.effective_at <= now()
      and (vq.expires_at is null or vq.expires_at > now())
      and s.display_name in ('AP Calculus AB','AP Calculus BC')
    group by vq.reviewer_id
    having count(distinct s.display_name)=2
  ) into v_qualified;

  if not v_qualified then
    raise exception 'Muhammad Saood does not hold active qualifications for both calculus subjects';
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
  'cee0cee4-fc59-4084-9a83-b24ccca940b9'::uuid,
  'tutor_question',
  item_type,
  'pending',
  'subject_review',
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from packet_versions;

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
  'saood-calc-single-reviewed-2026-08-06',
  'Muhammad Saood second-reviewer packet: single-reviewed AP Calculus AB/BC items',
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
 and a.reviewer_id='cee0cee4-fc59-4084-9a83-b24ccca940b9'::uuid
 and a.review_stage='tutor_question'
 and a.assignment_purpose='subject_review'
 and a.status='pending'
join app.content_items ci on ci.id=pv.content_item_id
join app.exam_pack_versions epv on epv.id=ci.exam_pack_version_id
join app.content_labels l
  on l.exam_pack_id=epv.exam_pack_id
 and l.label_key='saood-calc-single-reviewed-2026-08-06'
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
   and a.reviewer_id='cee0cee4-fc59-4084-9a83-b24ccca940b9'::uuid
   and a.status='pending'
   and a.assignment_purpose='subject_review';

  if v_assignments <> 25 then
    raise exception 'assignment verification failed: pending %, expected 25', v_assignments;
  end if;
end $$;

select
  s.display_name as subject,
  count(*)::integer as assigned_count
from packet_versions pv
join app.content_items ci on ci.id=pv.content_item_id
join app.exam_pack_versions epv on epv.id=ci.exam_pack_version_id
join app.exam_packs ep on ep.id=epv.exam_pack_id
join app.subjects s on s.id=ep.subject_id
group by s.display_name
order by s.display_name;

commit;
