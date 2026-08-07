-- Publish the remaining 9 AP Biology items from the 2026-08-06
-- owner-adjudicated remediation batch (5 MCQs, 4 FRQs), all still sitting at
-- reviewed_approved with an existing admin approve decision.
--
-- Owner instruction, 2026-08-06: "Publish the rest of the reviewed_approved
-- AP Biology items too."

begin;
select pg_advisory_xact_lock(hashtext('cramapple-publish-apbio-owner-adjudicated-batch-20260806'));

create temporary table target on commit drop as
select ci.id content_item_id, ci.content_key, ci.item_type,
       civ.id content_item_version_id
from app.content_items ci
join app.content_item_versions civ on civ.content_item_id=ci.id
where ci.content_key in ('APBIO-MCQ-008','APBIO-MCQ-011','APBIO-MCQ-014','APBIO-MCQ-016','APBIO-MCQ-026','APBIO-FRQ-L-016','APBIO-FRQ-L-026','APBIO-FRQ-L-030','APBIO-FRQ-L-036')
  and ci.status='reviewed_approved'
  and civ.status='reviewed_approved'
  and civ.version_num=(select max(n.version_num) from app.content_item_versions n where n.content_item_id=ci.id)
  and not exists (
    select 1
    from app.content_item_versions other
    where other.content_item_id=ci.id
      and other.id<>civ.id
      and other.status='published'
  );

do $$
declare
  v_count integer;
  v_bad_mcq integer;
  v_bad_frq integer;
  v_not_admin_approved integer;
begin
  select count(*) into v_count from target;
  if v_count<>9 then
    raise exception 'expected exactly 9 AP Biology targets, found %', v_count;
  end if;

  select count(*) into v_bad_mcq
  from target t
  where t.item_type='mcq'
    and (
      (select count(*) from app.mcq_choices m where m.content_item_version_id=t.content_item_version_id)<>4
      or (select count(distinct lower(trim(m.choice_text))) from app.mcq_choices m where m.content_item_version_id=t.content_item_version_id)<>4
      or (select count(*) from app.mcq_choices m where m.content_item_version_id=t.content_item_version_id and m.is_correct)<>1
      or exists (
        select 1 from app.mcq_choices m
        where m.content_item_version_id=t.content_item_version_id
          and nullif(trim(coalesce(m.rationale,'')),'') is null
      )
    );
  if v_bad_mcq<>0 then
    raise exception 'AP Biology MCQ structural gate failed for % item(s)', v_bad_mcq;
  end if;

  select count(*) into v_bad_frq
  from target t
  where t.item_type='frq'
    and (
      (select count(*) from app.frq_criteria f where f.content_item_version_id=t.content_item_version_id) = 0
      or exists (
        select 1 from app.frq_criteria f
        where f.content_item_version_id=t.content_item_version_id
          and nullif(trim(coalesce(f.learner_facing_text,'')),'') is null
      )
    );
  if v_bad_frq<>0 then
    raise exception 'AP Biology FRQ structural gate failed for % item(s)', v_bad_frq;
  end if;

  select count(*) into v_not_admin_approved
  from target t
  where not exists (
    select 1
    from app.content_review_decisions d
    join app.profiles p on p.user_id=d.reviewer_id and p.role='admin'
    where d.content_item_version_id=t.content_item_version_id
      and d.tutor_decision='approve'
  );
  if v_not_admin_approved<>0 then
    raise exception '% AP Biology target(s) missing an admin approve decision', v_not_admin_approved;
  end if;
end $$;

update app.content_item_versions civ
set status='published',
    review_status=case when civ.review_status is null then
        (case when t.item_type='mcq' then 'question_review_approved' else 'question_review_approved' end)
      else civ.review_status end,
    approved_by=coalesce(civ.approved_by,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid),
    approved_at=coalesce(civ.approved_at,now()),
    published_at=coalesce(civ.published_at,now()),
    updated_at=now()
from target t
where civ.id=t.content_item_version_id;

update app.content_items ci
set status='published',
    updated_at=now()
from target t
where ci.id=t.content_item_id;

do $$
declare
  v_published integer;
  v_dupes integer;
begin
  select count(*) into v_published
  from target t
  join app.content_items ci on ci.id=t.content_item_id
  join app.content_item_versions civ on civ.id=t.content_item_version_id
  where ci.status='published' and civ.status='published';

  if v_published<>9 then
    raise exception 'AP Biology publish verification failed: %', v_published;
  end if;

  select count(*) into v_dupes
  from (
    select content_item_id
    from app.content_item_versions
    where status='published'
      and content_item_id in (select content_item_id from target)
    group by content_item_id
    having count(*)>1
  ) d;

  if v_dupes<>0 then
    raise exception 'duplicate published item versions detected: %', v_dupes;
  end if;
end $$;

select content_key, item_type, content_item_version_id, 'published' as status
from target
order by content_key;

commit;
