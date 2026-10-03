-- AP Biology: set item status to 'retired' on the last 4 items marked published with no published version, 2026-10-03.   APPLIED to Production under APPROVAL-0096 (run while the id was still numbered APPROVAL-0094; renumbered at merge because the AP Precalculus session took 0094. The id string below is the one that ran; nothing persisted it).
-- Why: APPROVAL-0093 aligned 38 of 42 such items and held these four. The Product Owner then ruled: "The attempts were tests- not real students. No risk to flipping.
-- The latest label is retired. Those two should be retired." Read as: the two with test attempts (APBIO-FRQ-L-028: 5, APBIO-MCQ-012: 1) are safe to flip, and the two whose
-- latest version is retired (APBIO-FRQ-L-038, APBIO-FRQ-L-041; their version 1 is an old unretired 'reviewed_approved') should be retired. All four are retired at item level.
-- Only content_items.status and updated_at change. Versions (including the old reviewed_approved v1 of 038 and 041), labels, cells and attempts are untouched.

begin;
select pg_advisory_xact_lock(hashtext('cramapple-apbio-retire-last-four-orphans-20261003'));

create temporary table approval (ref text) on commit drop;
insert into approval values ('APPROVAL-0094');
do $$ begin if (select ref from approval) = 'PENDING' then raise exception 'not approved: enter the Product Owner approval reference above'; end if; end $$;

create temporary table target (content_key text primary key) on commit drop;
insert into target values ('APBIO-FRQ-L-028'),('APBIO-MCQ-012'),('APBIO-FRQ-L-038'),('APBIO-FRQ-L-041');

create temporary table before_counts on commit drop as
  select (select count(*) from app.content_items where content_key like 'APBIO-%' and status='published') as published_items,
         (select count(*) from app.content_taxonomy_labels l join app.content_items ci on ci.id=l.content_item_id where ci.content_key like 'APBIO-%' and l.superseded_by is null and l.label_scope='serving' and l.label_status='validated') as validated_serving,
         (select count(*) from app.content_item_versions v join app.content_items ci on ci.id=v.content_item_id where ci.content_key like 'APBIO-%' and v.status='published') as published_versions,
         (select count(*) from public.attempts a join app.content_item_versions v on v.id=a.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.content_key in (select content_key from target)) as attempts_public,
         (select count(*) from app.attempts a join app.content_item_versions v on v.id=a.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.content_key in (select content_key from target)) as attempts_app;

do $$
declare n int;
begin
  select count(*) into n from target t join app.content_items ci on ci.content_key=t.content_key and ci.status='published';
  if n<>4 then raise exception 'expected 4 published target items, found %', n; end if;
  select count(*) into n from target t join app.content_items ci on ci.content_key=t.content_key
    where exists (select 1 from app.content_item_versions v where v.content_item_id=ci.id and v.status='published');
  if n<>0 then raise exception '% target items have a published version', n; end if;
  -- the newest version of every target is retired
  select count(*) into n from target t join app.content_items ci on ci.content_key=t.content_key
    where (select v.status from app.content_item_versions v where v.content_item_id=ci.id order by v.version_num desc limit 1) <> 'retired';
  if n<>0 then raise exception '% target items have a newest version that is not retired', n; end if;
  -- these four are the only Biology items published with no published version
  select count(*) into n from app.content_items ci where ci.content_key like 'APBIO-%' and ci.status='published' and not exists (select 1 from app.content_item_versions v where v.content_item_id=ci.id and v.status='published');
  if n<>4 then raise exception 'expected exactly 4 such Biology items, found %', n; end if;
end $$;

update app.content_items ci set status='retired', updated_at=now() from target t where ci.content_key=t.content_key;

do $$
declare n int; b record;
begin
  select * into b from before_counts;
  select count(*) into n from target t join app.content_items ci on ci.content_key=t.content_key where ci.status='retired';
  if n<>4 then raise exception 'expected 4 retired, got %', n; end if;
  select count(*) into n from app.content_items where content_key like 'APBIO-%' and status='published';
  if n<>b.published_items-4 then raise exception 'published Biology items should fall by exactly 4 (was %, now %)', b.published_items, n; end if;
  select count(*) into n from app.content_taxonomy_labels l join app.content_items ci on ci.id=l.content_item_id where ci.content_key like 'APBIO-%' and l.superseded_by is null and l.label_scope='serving' and l.label_status='validated';
  if n<>b.validated_serving then raise exception 'validated serving labels changed (% to %)', b.validated_serving, n; end if;
  select count(*) into n from app.content_item_versions v join app.content_items ci on ci.id=v.content_item_id where ci.content_key like 'APBIO-%' and v.status='published';
  if n<>b.published_versions then raise exception 'published versions changed (% to %)', b.published_versions, n; end if;
  select count(*) into n from public.attempts a join app.content_item_versions v on v.id=a.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.content_key in (select content_key from target);
  if n<>b.attempts_public then raise exception 'attempts changed (% to %)', b.attempts_public, n; end if;
  select count(*) into n from app.content_items ci where ci.content_key like 'APBIO-%' and ci.status='published' and not exists (select 1 from app.content_item_versions v where v.content_item_id=ci.id and v.status='published');
  if n<>0 then raise exception '% Biology items still published without a published version', n; end if;
end $$;

select jsonb_build_object('retired',(select count(*) from target),'biology_published_items_before',(select published_items from before_counts),'biology_published_items_after',(select count(*) from app.content_items where content_key like 'APBIO-%' and status='published'),'still_published_without_published_version',(select count(*) from app.content_items ci where ci.content_key like 'APBIO-%' and ci.status='published' and not exists (select 1 from app.content_item_versions v where v.content_item_id=ci.id and v.status='published'))) as result;
commit;
