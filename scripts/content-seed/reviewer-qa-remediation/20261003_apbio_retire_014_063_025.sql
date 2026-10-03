-- AP Biology: retire 3 published seed-style MCQs that fall outside the CED, 2026-10-03.   APPLIED to Production under APPROVAL-0092.
-- Why: the Product Owner ruled (DECISION-0095) that items stay within CED vocabulary and, on 2026-10-03, "Retire all 3". A read-only scan of the 41 published
-- AP Biology seed-style MCQs for terms confirmed absent from the CED V.1 text found two: APBIO-MCQ-014 (70S, 80S ribosomes) and APBIO-MCQ-063 (signal sequence).
-- APBIO-MCQ-025 (kidney ADH / aquaporin-2) was recorded in APPROVAL-0080 as resting on physiology outside the fact pack with a weak choice D rationale.
-- Pattern: as in APPROVAL-0077 and APPROVAL-0091: item status and version status set to 'retired'. Nothing is deleted; labels, cells and review records stay.

begin;
select pg_advisory_xact_lock(hashtext('cramapple-apbio-retire-014-063-025-20261003'));

create temporary table approval (ref text) on commit drop;
insert into approval values ('APPROVAL-0092');
do $$ begin if (select ref from approval) = 'PENDING' then raise exception 'not approved: enter the Product Owner approval reference above'; end if; end $$;

create temporary table target (content_key text primary key, reason text not null) on commit drop;
insert into target values
 ('APBIO-MCQ-014','70S, 80S ribosomes'),
 ('APBIO-MCQ-063','signal sequence'),
 ('APBIO-MCQ-025','kidney ADH / aquaporin-2 physiology outside the pack; weak choice D rationale (APPROVAL-0080)');

create temporary table touched (content_key text primary key, item_id uuid not null, version_id uuid not null) on commit drop;
create temporary table before_counts on commit drop as
  select (select count(*) from app.content_items where content_key like 'APBIO-%' and status='published') as published_items,
         -- pre-existing: Biology items marked published whose versions are all retired (42 on 2026-10-03; 20 FRQ + 22 MCQ). Not caused by this script; compared before and after.
         (select count(*) from app.content_items ci where ci.status='published' and ci.content_key like 'APBIO-%'
            and not exists (select 1 from app.content_item_versions v where v.content_item_id=ci.id and v.status='published')) as orphans;

do $$
declare n int;
begin
  select count(*) into n from target t join app.content_items ci on ci.content_key=t.content_key and ci.item_type='mcq' and ci.status='published';
  if n<>3 then raise exception 'expected 3 published target items, found %', n; end if;
  insert into touched
    select t.content_key, ci.id, civ.id
    from target t join app.content_items ci on ci.content_key=t.content_key
    join app.content_item_versions civ on civ.content_item_id=ci.id and civ.status='published';
  select count(*) into n from touched; if n<>3 then raise exception 'expected 3 published versions, found %', n; end if;
  select count(*) into n from touched k where (select count(*) from public.attempts a where a.content_item_version_id=k.version_id)>0
     or (select count(*) from app.attempts a where a.content_item_version_id=k.version_id)>0;
  if n<>0 then raise exception '% target items have attempts; refusing to retire', n; end if;
end $$;

update app.content_item_versions civ set status='retired', updated_at=now() from touched k where civ.id=k.version_id;
update app.content_items ci set status='retired', updated_at=now() from touched k where ci.id=k.item_id;

do $$
declare n int; b int;
begin
  select count(*) into n from touched k join app.content_items ci on ci.id=k.item_id join app.content_item_versions civ on civ.id=k.version_id
   where ci.status='retired' and civ.status='retired';
  if n<>3 then raise exception 'expected 3 retired, got %', n; end if;
  select published_items into b from before_counts;
  select count(*) into n from app.content_items where content_key like 'APBIO-%' and status='published';
  if n<>b-3 then raise exception 'published Biology items should fall by exactly 3 (was %, now %)', b, n; end if;
  select count(*) into n from app.content_items ci where ci.status='published' and not exists (select 1 from app.content_item_versions v where v.content_item_id=ci.id and v.status='published') and ci.content_key like 'APBIO-%';
  if n<>(select orphans from before_counts) then raise exception 'items published without a published version changed from % to %', (select orphans from before_counts), n; end if;
end $$;

select jsonb_build_object('retired',(select count(*) from touched),'biology_published_items_before',(select published_items from before_counts),'biology_published_items_after',(select count(*) from app.content_items where content_key like 'APBIO-%' and status='published')) as result;
commit;
