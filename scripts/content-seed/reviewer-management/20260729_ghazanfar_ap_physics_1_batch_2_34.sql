-- Assign Ghazanfar Ali a second 34-question AP Physics 1 packet.
--
-- Mirrors his original packet's 20 MCQ / 14 FRQ composition. Every selected
-- current version has one prior independent tutor-question decision, so this
-- packet also provides exact-version second-reader calibration data.

begin;

select pg_advisory_xact_lock(
  hashtext('cramapple-ghazanfar-ap-physics-1-batch-2-34-20260729')
);

create temporary table eligible_versions on commit drop as
select
  ci.id content_item_id,
  civ.id content_item_version_id,
  ci.content_key,
  ci.item_type,
  coalesce(civ.prompt_json->>'difficulty','(none)') difficulty,
  d.tutor_score prior_score
from app.content_items ci
join lateral (
  select *
  from app.content_item_versions v
  where v.content_item_id=ci.id
  order by v.version_num desc,v.created_at desc
  limit 1
) civ on true
join app.exam_pack_versions epv
  on epv.id=ci.exam_pack_version_id
join app.exam_packs ep
  on ep.id=epv.exam_pack_id
join app.content_review_assignments prior_assignment
  on prior_assignment.content_item_version_id=civ.id
 and prior_assignment.review_stage='tutor_question'
join app.content_review_decisions d
  on d.content_review_assignment_id=
       prior_assignment.content_review_assignment_id
 and d.content_item_version_id=civ.id
 and d.review_stage='tutor_question'
where ep.exam_code='ap_physics_1'
  and civ.status<>'retired'
  and not exists (
    select 1
    from app.content_review_assignments existing
    join app.content_item_versions assigned_version
      on assigned_version.id=existing.content_item_version_id
    where existing.reviewer_id=
            '8328a005-eea2-4f0a-a540-8fe739f88be8'::uuid
      and assigned_version.content_item_id=ci.id
  )
  and (
    select count(*)
    from app.content_review_assignments other_assignment
    where other_assignment.content_item_version_id=civ.id
      and other_assignment.review_stage='tutor_question'
  )=1
  and (
    select count(*)
    from app.content_review_decisions other_decision
    where other_decision.content_item_version_id=civ.id
      and other_decision.review_stage='tutor_question'
  )=1;

create temporary table packet_versions (
  content_item_id uuid primary key,
  content_item_version_id uuid unique not null,
  content_key text unique not null,
  item_type text not null,
  difficulty text not null,
  prior_score integer not null
) on commit drop;

-- MCQs: retain all 16 with explicit difficulty metadata, then add four legacy
-- MCQs without a difficulty field. Prior score 2 is preferred for calibration.
insert into packet_versions
select *
from eligible_versions
where item_type='mcq'
  and difficulty<>'(none)';

insert into packet_versions
select *
from eligible_versions
where item_type='mcq'
  and difficulty='(none)'
order by prior_score desc,content_key
limit 4;

-- FRQs: all two legacy items, all three Easy, all four Hard, and five Medium.
insert into packet_versions
select *
from eligible_versions
where item_type='frq'
  and difficulty in ('(none)','Easy','Hard');

insert into packet_versions
select *
from eligible_versions
where item_type='frq'
  and difficulty='Medium'
order by prior_score desc,content_key
limit 5;

do $$
declare
  v_total integer;
  v_mcq integer;
  v_frq integer;
  v_prior_edits integer;
  v_existing integer;
  v_qualified boolean;
begin
  select
    count(*),
    count(*) filter(where item_type='mcq'),
    count(*) filter(where item_type='frq'),
    count(*) filter(where prior_score=2)
  into v_total,v_mcq,v_frq,v_prior_edits
  from packet_versions;

  if (v_total,v_mcq,v_frq)<>(34,20,14) then
    raise exception
      'Ghazanfar packet distribution changed: total %, MCQ %, FRQ %',
      v_total,v_mcq,v_frq;
  end if;

  if v_prior_edits=0 then
    raise exception
      'Ghazanfar packet lacks prior approve-with-edits calibration examples';
  end if;

  select count(*)
  into v_existing
  from packet_versions pv
  join app.content_review_assignments a
    on a.content_item_version_id=pv.content_item_version_id
   and a.reviewer_id=
       '8328a005-eea2-4f0a-a540-8fe739f88be8'::uuid
   and a.review_stage='tutor_question';

  if v_existing<>0 then
    raise exception
      'Ghazanfar already has % assignments from the intended packet',
      v_existing;
  end if;

  select exists (
    select 1
    from app.validator_qualifications vq
    where vq.reviewer_id=
            '8328a005-eea2-4f0a-a540-8fe739f88be8'::uuid
      and vq.status='active'
      and 'a90e3381-dc0b-4e62-8e7a-cc9a3b1cc3cc'::uuid=
          any(vq.exam_ids)
      and vq.effective_at<=now()
      and vq.expires_at>now()
  )
  into v_qualified;

  if not v_qualified then
    raise exception
      'Ghazanfar Ali does not have an active AP Physics 1 qualification';
  end if;
end
$$;

insert into app.content_review_assignments (
  content_item_version_id,
  reviewer_id,
  review_stage,
  review_kind,
  blind_group_id,
  status,
  assignment_purpose,
  created_by
)
select
  pv.content_item_version_id,
  '8328a005-eea2-4f0a-a540-8fe739f88be8'::uuid,
  'tutor_question',
  pv.item_type,
  gen_random_uuid(),
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
  'a90e3381-dc0b-4e62-8e7a-cc9a3b1cc3cc'::uuid,
  'ghazanfar-ap-physics-1-batch-2-34-2026-07-29',
  'Ghazanfar AP Physics 1 batch 2 — 34 questions',
  'workflow',
  'published',
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
)
on conflict (exam_pack_id,label_key) do update
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
 and a.reviewer_id='8328a005-eea2-4f0a-a540-8fe739f88be8'::uuid
 and a.review_stage='tutor_question'
join app.content_labels l
  on l.exam_pack_id='a90e3381-dc0b-4e62-8e7a-cc9a3b1cc3cc'::uuid
 and l.label_key='ghazanfar-ap-physics-1-batch-2-34-2026-07-29';

do $$
declare
  v_assignments integer;
  v_pending integer;
  v_labeled integer;
  v_exact_overlap integer;
  v_distinct_groups integer;
begin
  select
    count(*),
    count(*) filter(where a.status='pending'),
    count(distinct a.blind_group_id)
  into v_assignments,v_pending,v_distinct_groups
  from packet_versions pv
  join app.content_review_assignments a
    on a.content_item_version_id=pv.content_item_version_id
   and a.reviewer_id=
       '8328a005-eea2-4f0a-a540-8fe739f88be8'::uuid
   and a.review_stage='tutor_question'
   and a.review_kind=pv.item_type
   and a.assignment_purpose='subject_review';

  select count(*)
  into v_labeled
  from packet_versions pv
  join app.content_review_assignments a
    on a.content_item_version_id=pv.content_item_version_id
   and a.reviewer_id=
       '8328a005-eea2-4f0a-a540-8fe739f88be8'::uuid
   and a.review_stage='tutor_question'
  join app.content_review_assignment_labels al
    on al.content_review_assignment_id=a.content_review_assignment_id
  join app.content_labels l
    on l.id=al.content_label_id
   and l.label_key=
       'ghazanfar-ap-physics-1-batch-2-34-2026-07-29';

  select count(*)
  into v_exact_overlap
  from packet_versions pv
  where exists (
    select 1
    from app.content_review_decisions d
    where d.content_item_version_id=pv.content_item_version_id
      and d.reviewer_id<>
          '8328a005-eea2-4f0a-a540-8fe739f88be8'::uuid
      and d.review_stage='tutor_question'
  );

  if (v_assignments,v_pending,v_labeled,v_exact_overlap,v_distinct_groups)
     <>(34,34,34,34,34) then
    raise exception
      'Ghazanfar batch reconciliation failed: assignments %, pending %, labeled %, overlap %, groups %',
      v_assignments,v_pending,v_labeled,v_exact_overlap,v_distinct_groups;
  end if;
end
$$;

commit;
