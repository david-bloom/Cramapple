begin;
select pg_advisory_xact_lock(hashtext('cramapple-apchem-u3b-2026-11-12-retire-20261112'));
create temporary table old on commit drop as
select ci.id item_id, civ.id version_id, ci.content_key
from app.content_items ci join app.content_item_versions civ on civ.content_item_id=ci.id and civ.status='published'
where ci.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and ci.item_type='mcq' and ci.status='published' and ci.content_key in ('apchem-mcq-008','apchem-mcq-032','apchem-mcq-sv-008-v1','apchem-mcq-sv-008-v2','apchem-mcq-sv-008-v3','apchem-mcq-sv-032-v1','apchem-mcq-sv-032-v3','apchem-mcq-005','apchem-mcq-033','apchem-mcq-sv-005-v1','apchem-mcq-sv-005-v3','apchem-mcq-sv-033-v1','apchem-mcq-sv-033-v2','apchem-mcq-sv-033-v3','apchem-mcq-034','apchem-mcq-sv-034-v1','apchem-mcq-sv-034-v2','apchem-mcq-sv-034-v3','apchem-mcq-039','apchem-mcq-sv-039-v1','apchem-mcq-sv-039-v2','apchem-mcq-sv-039-v3','apchem-mcq-038','apchem-mcq-sv-038-v1','apchem-mcq-sv-038-v2','apchem-mcq-sv-038-v3','apchem-mcq-007','apchem-mcq-035','apchem-mcq-sv-035-v1','apchem-mcq-sv-035-v3','apchem-mcq-037','apchem-mcq-sv-037-v1','apchem-mcq-sv-037-v2','apchem-mcq-sv-037-v3','apchem-mcq-006','apchem-mcq-036','apchem-mcq-sv-006-v1','apchem-mcq-sv-006-v3','apchem-mcq-sv-036-v1','apchem-mcq-sv-036-v2','apchem-mcq-sv-036-v3');
do $$ begin
 if (select count(*) from old)<>41 then raise exception 'expected 41 published superseded items, got %', (select count(*) from old); end if;
 if (select count(*) from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and status='published' and (content_key like 'apchem-mcq-b2-h-3.%' or content_key like 'apchem-mcq-b2-sv-h-3.%'))<>80 then raise exception 'the 80 new items are not all published; publish first'; end if;
end $$;
update app.content_review_assignments set status='skipped' where content_item_version_id in (select version_id from old) and assignment_purpose='subject_review' and status in ('pending','in_progress');
update app.content_item_versions set status='retired', updated_at=now() where id in (select version_id from old);
update app.content_items set status='retired', updated_at=now() where id in (select item_id from old);
do $$ declare n int; begin
 select count(*) into n from app.content_items where id in (select item_id from old) and status='retired'; if n<>41 then raise exception 'retire count %', n; end if;
 select count(*) into n from app.content_items ci where ci.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and ci.status='published' and not exists (select 1 from app.content_item_versions v where v.content_item_id=ci.id and v.status='published') and ci.item_type='mcq'; 
 raise notice 'published MCQ items without a published version (pre-existing defects count too): %', n;
end $$;
do $$ begin raise exception 'REHEARSAL OK (rolled back): retired=%', (select count(*) from old); end $$;
rollback;
