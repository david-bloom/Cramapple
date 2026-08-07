-- Publish the 9 AP Statistics multi-point redecomposition items from
-- TASK-0022 pass 2 (apstats-frq-u12-005, APSTATS-SFRQ-002/003/004/011/012/
-- 013/014/016). Does NOT touch the 32 spatial hand-drawn-graph items or the
-- 24 reviewed_approved-but-not-yet-published items -- both explicitly out
-- of scope per owner instruction.
--
-- Owner instruction, 2026-08-07: "publish the 9 items ... do not touch the
-- 32 spatial items or the 24 not-yet-published ones."

begin;
select pg_advisory_xact_lock(hashtext('cramapple-publish-apstats-multipoint-pass2-20260807'));

create temporary table target on commit drop as
select ci.id content_item_id, ci.content_key, civ.id content_item_version_id
from app.content_items ci
join app.content_item_versions civ on civ.content_item_id=ci.id
where ci.content_key in (
  'apstats-frq-u12-005','APSTATS-SFRQ-002','APSTATS-SFRQ-003','APSTATS-SFRQ-004',
  'APSTATS-SFRQ-011','APSTATS-SFRQ-012','APSTATS-SFRQ-013','APSTATS-SFRQ-014','APSTATS-SFRQ-016'
)
  and ci.status='reviewed_approved' and civ.status='reviewed_approved'
  and civ.version_num=(select max(n.version_num) from app.content_item_versions n where n.content_item_id=ci.id)
  and not exists (select 1 from app.content_item_versions o where o.content_item_id=ci.id and o.id<>civ.id and o.status='published');

do $$
declare v_count integer; v_bad integer; v_admin integer;
begin
  select count(*) into v_count from target;
  if v_count<>9 then raise exception 'expected 9 targets, found %', v_count; end if;

  select count(*) into v_bad
  from target t
  where (select count(*) from app.frq_criteria f where f.content_item_version_id=t.content_item_version_id)=0
     or exists (select 1 from app.frq_criteria f where f.content_item_version_id=t.content_item_version_id and nullif(trim(coalesce(f.learner_facing_text,'')),'') is null);
  if v_bad<>0 then raise exception 'FRQ structural gate failed for % item(s)', v_bad; end if;

  select count(*) into v_admin
  from target t
  where not exists (select 1 from app.content_review_decisions d join app.profiles p on p.user_id=d.reviewer_id and p.role='admin' where d.content_item_version_id=t.content_item_version_id and d.tutor_decision='approve');
  if v_admin<>0 then raise exception '% target(s) missing admin approve decision', v_admin; end if;
end $$;

update app.content_item_versions civ
set status='published', review_status=coalesce(civ.review_status,'question_review_approved'),
    approved_by=coalesce(civ.approved_by,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid),
    approved_at=coalesce(civ.approved_at,now()), published_at=coalesce(civ.published_at,now()), updated_at=now()
from target t where civ.id=t.content_item_version_id;

update app.content_items ci set status='published', updated_at=now() from target t where ci.id=t.content_item_id;

do $$
declare v_published integer; v_dupes integer;
begin
  select count(*) into v_published
  from target t join app.content_items ci on ci.id=t.content_item_id join app.content_item_versions civ on civ.id=t.content_item_version_id
  where ci.status='published' and civ.status='published';
  if v_published<>9 then raise exception 'publish verification failed: %', v_published; end if;

  select count(*) into v_dupes
  from (
    select content_item_id from app.content_item_versions
    where status='published' and content_item_id in (select content_item_id from target)
    group by content_item_id having count(*)>1
  ) d;
  if v_dupes<>0 then raise exception 'duplicate published item versions detected: %', v_dupes; end if;
end $$;

select content_key, content_item_version_id, 'published' as status from target order by content_key;
commit;
