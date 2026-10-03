-- AP Biology: set item status to 'retired' on 38 items whose every version is already retired, 2026-10-03.   APPLIED to Production under APPROVAL-0095 (run while the id was still numbered APPROVAL-0093; renumbered at merge because the AP Precalculus session took 0093. The id string below is the one that ran; nothing persisted it).
-- Why: 42 Biology items were marked 'published' at item level while no version was published (20 FRQ + 22 MCQ; item rows last touched 2026-07-16 to 2026-08-13).
-- The practice selector (select_unit_gated_practice_items) and the census require BOTH the item and its version to be 'published', so none of the 42 was being served;
-- servable_items_census already counts "item published, version not published" as its own bucket. This aligns the record with reality; no student-visible change.
-- Rule: Biology item, item status published, no published version, no non-retired version, no attempts on any version. 38 items match.
-- Deliberately NOT touched (4): APBIO-FRQ-L-028 (5 attempts), APBIO-MCQ-012 (1 attempt), APBIO-FRQ-L-038 and APBIO-FRQ-L-041 (each has an unretired
-- 'reviewed_approved' version 1 alongside retired versions 2 and 3: unresolved lineage, not a plain leftover). Versions, labels, cells and attempts are untouched.

begin;
select pg_advisory_xact_lock(hashtext('cramapple-apbio-align-orphan-item-status-20261003'));

create temporary table approval (ref text) on commit drop;
insert into approval values ('APPROVAL-0093');
do $$ begin if (select ref from approval) = 'PENDING' then raise exception 'not approved: enter the Product Owner approval reference above'; end if; end $$;

create temporary table before_counts on commit drop as
  select (select count(*) from app.content_items where content_key like 'APBIO-%' and status='published') as published_items,
         (select count(*) from app.content_items ci where ci.content_key like 'APBIO-%' and ci.status='published'
            and exists (select 1 from app.content_item_versions v where v.content_item_id=ci.id and v.status='published')) as with_published_version,
         (select count(*) from app.content_taxonomy_labels l join app.content_items ci on ci.id=l.content_item_id where ci.content_key like 'APBIO-%' and l.superseded_by is null and l.label_scope='serving' and l.label_status='validated') as validated_serving,
         (select count(*) from app.content_item_versions v join app.content_items ci on ci.id=v.content_item_id where ci.content_key like 'APBIO-%' and v.status='published') as published_versions;

create temporary table target on commit drop as
  select ci.id as item_id, ci.content_key
  from app.content_items ci
  where ci.content_key like 'APBIO-%' and ci.status='published'
    and not exists (select 1 from app.content_item_versions v where v.content_item_id=ci.id and v.status<>'retired')
    and not exists (select 1 from public.attempts a join app.content_item_versions v on v.id=a.content_item_version_id where v.content_item_id=ci.id)
    and not exists (select 1 from app.attempts a join app.content_item_versions v on v.id=a.content_item_version_id where v.content_item_id=ci.id);

do $$
declare n int;
begin
  select count(*) into n from target; if n<>38 then raise exception 'expected 38 target items, found %', n; end if;
  select count(*) into n from target where content_key in ('APBIO-FRQ-L-028','APBIO-MCQ-012','APBIO-FRQ-L-038','APBIO-FRQ-L-041');
  if n<>0 then raise exception 'one of the four excluded items is in the target set'; end if;
  select count(*) into n from target t where exists (select 1 from app.content_item_versions v where v.content_item_id=t.item_id and v.status='published');
  if n<>0 then raise exception '% target items have a published version', n; end if;
end $$;

update app.content_items ci set status='retired', updated_at=now() from target t where ci.id=t.item_id;

do $$
declare n int; b record;
begin
  select * into b from before_counts;
  select count(*) into n from app.content_items ci join target t on t.item_id=ci.id where ci.status='retired';
  if n<>38 then raise exception 'expected 38 retired, got %', n; end if;
  select count(*) into n from app.content_items where content_key like 'APBIO-%' and status='published';
  if n<>b.published_items-38 then raise exception 'published Biology items should fall by exactly 38 (was %, now %)', b.published_items, n; end if;
  select count(*) into n from app.content_items ci where ci.content_key like 'APBIO-%' and ci.status='published' and exists (select 1 from app.content_item_versions v where v.content_item_id=ci.id and v.status='published');
  if n<>b.with_published_version then raise exception 'items with a published version changed (% to %)', b.with_published_version, n; end if;
  select count(*) into n from app.content_taxonomy_labels l join app.content_items ci on ci.id=l.content_item_id where ci.content_key like 'APBIO-%' and l.superseded_by is null and l.label_scope='serving' and l.label_status='validated';
  if n<>b.validated_serving then raise exception 'validated serving labels changed (% to %)', b.validated_serving, n; end if;
  select count(*) into n from app.content_item_versions v join app.content_items ci on ci.id=v.content_item_id where ci.content_key like 'APBIO-%' and v.status='published';
  if n<>b.published_versions then raise exception 'published versions changed (% to %)', b.published_versions, n; end if;
  select count(*) into n from app.content_items ci where ci.content_key like 'APBIO-%' and ci.status='published' and not exists (select 1 from app.content_item_versions v where v.content_item_id=ci.id and v.status='published');
  if n<>4 then raise exception 'expected 4 left published without a published version, got %', n; end if;
end $$;

select jsonb_build_object('retired',(select count(*) from target),'biology_published_items_before',(select published_items from before_counts),'biology_published_items_after',(select count(*) from app.content_items where content_key like 'APBIO-%' and status='published'),'still_published_without_published_version',(select count(*) from app.content_items ci where ci.content_key like 'APBIO-%' and ci.status='published' and not exists (select 1 from app.content_item_versions v where v.content_item_id=ci.id and v.status='published'))) as result;
commit;
