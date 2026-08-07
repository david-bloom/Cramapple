-- Assign Sarah Sohail the AP Biology items with exactly one human
-- tutor_question decision (approve or approve_with_edits) on the latest
-- active version, where Sarah has never reviewed the item (any version).
--
-- Owner instruction, 2026-08-06: "Are there any Biology questions which have
-- exactly one review which is approve or approve with edits AND Sarah is not
-- the reviewer? If so, assign them to Sarah."
--
-- 26 of the 41 targets already carry a prior 'skipped' subject_review
-- assignment for Sarah (unrelated to this packet). Owner instruction,
-- 2026-08-06: "Re-assign all 41, overriding prior skips" -- those 26 rows are
-- reset to 'pending' in place; the remaining 15 get a fresh assignment row.

begin;
select pg_advisory_xact_lock(hashtext('cramapple-sarah-biology-single-reviewed-packet-20260806'));

create temporary table packet_versions on commit drop as
with bio as (
  select
    ci.id content_item_id, ci.content_key, ci.item_type,
    civ.id content_item_version_id, civ.version_num
  from app.content_items ci
  join app.content_item_versions civ on civ.content_item_id=ci.id
  join app.exam_pack_versions epv on epv.id=ci.exam_pack_version_id
  join app.exam_packs ep on ep.id=epv.exam_pack_id
  join app.subjects s on s.id=ep.subject_id
  where s.display_name = 'AP Biology'
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
  from bio a
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
    and reviewer_names <> 'Sarah Sohail'
), sarah_any_version as (
  select distinct ci.id content_item_id
  from app.content_items ci
  join app.content_item_versions civ on civ.content_item_id=ci.id
  join app.content_review_decisions d on d.content_item_version_id=civ.id and d.review_stage='tutor_question'
  join app.content_review_assignments cra
    on cra.content_review_assignment_id=d.content_review_assignment_id
   and cra.assignment_purpose='subject_review'
  join app.profiles p on p.user_id=d.reviewer_id
  where p.full_name='Sarah Sohail'
)
select e.content_item_id, e.content_key, e.item_type, e.content_item_version_id
from eligible e
where not exists (select 1 from sarah_any_version av where av.content_item_id=e.content_item_id);

do $$
declare
  v_total integer;
  v_qualified boolean;
begin
  select count(*) into v_total from packet_versions;

  -- Live reviewer activity moves this count between read and write (seen
  -- 41 -> 42 within minutes during authoring); sanity-range instead of an
  -- exact match so a concurrent decision doesn't abort a correct run.
  if v_total < 30 or v_total > 55 then
    raise exception 'single-reviewed AP Biology target count out of expected range: %', v_total;
  end if;

  select exists (
    select 1
    from app.validator_qualifications vq
    join app.exam_packs ep on ep.id = any(select unnest(vq.exam_ids))
    join app.subjects s on s.id=ep.subject_id
    where vq.reviewer_id='c1d12a8d-1489-4f90-990f-2f1ae2d54199'::uuid
      and vq.status='active'
      and vq.effective_at <= now()
      and (vq.expires_at is null or vq.expires_at > now())
      and s.display_name='AP Biology'
  ) into v_qualified;

  if not v_qualified then
    raise exception 'Sarah Sohail does not hold an active AP Biology qualification';
  end if;
end $$;

-- 26 of the 41 targets already have an assignment row for Sarah (prior
-- 'skipped' state); reset those in place rather than violating the
-- (content_item_version_id, reviewer_id, review_stage) unique constraint.
update app.content_review_assignments cra
set status='pending',
    assignment_purpose='subject_review',
    review_kind=pv.item_type
from packet_versions pv
where cra.content_item_version_id=pv.content_item_version_id
  and cra.reviewer_id='c1d12a8d-1489-4f90-990f-2f1ae2d54199'::uuid
  and cra.review_stage='tutor_question';

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
  'c1d12a8d-1489-4f90-990f-2f1ae2d54199'::uuid,
  'tutor_question',
  pv.item_type,
  'pending',
  'subject_review',
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from packet_versions pv
where not exists (
  select 1 from app.content_review_assignments existing
  where existing.content_item_version_id=pv.content_item_version_id
    and existing.reviewer_id='c1d12a8d-1489-4f90-990f-2f1ae2d54199'::uuid
    and existing.review_stage='tutor_question'
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
  'sarah-biology-single-reviewed-2026-08-06',
  'Sarah Sohail second-reviewer packet: single-reviewed AP Biology items',
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
 and a.reviewer_id='c1d12a8d-1489-4f90-990f-2f1ae2d54199'::uuid
 and a.review_stage='tutor_question'
 and a.assignment_purpose='subject_review'
 and a.status='pending'
join app.content_items ci on ci.id=pv.content_item_id
join app.exam_pack_versions epv on epv.id=ci.exam_pack_version_id
join app.content_labels l
  on l.exam_pack_id=epv.exam_pack_id
 and l.label_key='sarah-biology-single-reviewed-2026-08-06'
on conflict do nothing;

do $$
declare
  v_assignments integer;
  v_total integer;
begin
  select count(*) into v_total from packet_versions;
  select count(*)
  into v_assignments
  from packet_versions pv
  join app.content_review_assignments a
    on a.content_item_version_id=pv.content_item_version_id
   and a.reviewer_id='c1d12a8d-1489-4f90-990f-2f1ae2d54199'::uuid
   and a.status='pending'
   and a.assignment_purpose='subject_review';

  if v_assignments <> v_total then
    raise exception 'assignment verification failed: pending %, expected % (every packet item)', v_assignments, v_total;
  end if;
end $$;

select
  item_type,
  count(*)::integer as assigned_count
from packet_versions
group by item_type
order by item_type;

commit;
