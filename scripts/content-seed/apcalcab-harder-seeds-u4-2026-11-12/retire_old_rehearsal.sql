begin;
select pg_advisory_xact_lock(hashtext('cramapple-apcalcab-u4-2026-11-12-retire-20261112'));
create temporary table old on commit drop as
select ci.id item_id, civ.id version_id, ci.content_key
from app.content_items ci join app.content_item_versions civ on civ.content_item_id=ci.id and civ.status='published'
where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.item_type='mcq' and ci.status='published' and ci.content_key in ('apcalcab-mcq-031','apcalcab-mcq-sv-031-v1','apcalcab-mcq-sv-031-v2','apcalcab-mcq-009','apcalcab-mcq-032','apcalcab-mcq-np2-001','apcalcab-mcq-033','apcalcab-mcq-np2-010','apcalcab-mcq-034','apcalcab-mcq-np2-002');
do $$ begin
 if (select count(*) from old)<>10 then raise exception 'expected 10 published superseded items, got %', (select count(*) from old); end if;
 if (select count(*) from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and status='published' and (content_key like 'apcalcab-mcq-b4-h-4.%' or content_key like 'apcalcab-mcq-b4-sv-h-4.%'))<>56 then raise exception 'the 56 new items are not all published; publish first'; end if;
end $$;
update app.content_review_assignments set status='skipped' where content_item_version_id in (select version_id from old) and assignment_purpose='subject_review' and status in ('pending','in_progress');
update app.content_item_versions set status='retired', updated_at=now() where id in (select version_id from old);
update app.content_items set status='retired', updated_at=now() where id in (select item_id from old);
do $$ declare n int; begin
 select count(*) into n from app.content_items where id in (select item_id from old) and status='retired'; if n<>10 then raise exception 'retire count %', n; end if;
 select count(*) into n from app.content_items ci where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.status='published' and not exists (select 1 from app.content_item_versions v where v.content_item_id=ci.id and v.status='published') and ci.item_type='mcq'; 
 raise notice 'published MCQ items without a published version (pre-existing defects count too): %', n;
end $$;
do $$ begin raise exception 'REHEARSAL OK (rolled back): retired=%', (select count(*) from old); end $$;
rollback;
