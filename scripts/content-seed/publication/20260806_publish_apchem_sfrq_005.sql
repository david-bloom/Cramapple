-- Publish apchem-sfrq-005 v4 (owner-adjudicated stoichiometry fix, upheld
-- Zeeshan over Gulgeldi) to Production, replacing the retired v3 that was
-- live with the defect.
--
-- Owner instruction, 2026-08-06: "Publish apchem-sfrq-005 now."

begin;
select pg_advisory_xact_lock(hashtext('cramapple-publish-apchem-sfrq-005-20260806'));

create temporary table target on commit drop as
select ci.id content_item_id, ci.content_key, ci.item_type,
       civ.id content_item_version_id
from app.content_items ci
join app.content_item_versions civ on civ.content_item_id=ci.id
where ci.content_key='apchem-sfrq-005'
  and ci.status='reviewed_approved'
  and civ.status='reviewed_approved'
  and civ.version_num=4
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
  v_bad integer;
  v_admin_approved integer;
begin
  select count(*) into v_count from target;
  if v_count<>1 then
    raise exception 'expected exactly apchem-sfrq-005 v4 target, found %', v_count;
  end if;

  select count(*) into v_bad
  from target t
  where (select count(*) from app.frq_criteria f where f.content_item_version_id=t.content_item_version_id) = 0
     or exists (
       select 1 from app.frq_criteria f
       where f.content_item_version_id=t.content_item_version_id
         and nullif(trim(coalesce(f.learner_facing_text,'')),'') is null
     );
  if v_bad<>0 then
    raise exception 'apchem-sfrq-005 failed FRQ structural gate';
  end if;

  select count(*) into v_admin_approved
  from target t
  join app.content_review_decisions d on d.content_item_version_id=t.content_item_version_id
  join app.profiles p on p.user_id=d.reviewer_id and p.role='admin'
  where d.tutor_decision='approve';
  if v_admin_approved=0 then
    raise exception 'apchem-sfrq-005 v4 has no admin approve decision on record';
  end if;
end $$;

update app.content_item_versions civ
set status='published',
    review_status='question_review_approved',
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

  if v_published<>1 then
    raise exception 'apchem-sfrq-005 publish verification failed: %', v_published;
  end if;

  select count(*) into v_dupes
  from (
    select content_item_id
    from app.content_item_versions
    where status='published'
    group by content_item_id
    having count(*)>1
  ) d
  where d.content_item_id=(select content_item_id from target);

  if v_dupes<>0 then
    raise exception 'duplicate published item versions detected for apchem-sfrq-005: %', v_dupes;
  end if;
end $$;

select content_key, content_item_version_id, 'published' as status
from target;

commit;
