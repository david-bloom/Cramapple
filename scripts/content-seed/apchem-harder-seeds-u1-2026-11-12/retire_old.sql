begin;
select pg_advisory_xact_lock(hashtext('cramapple-apchem-u1-2026-11-12-retire-20261112'));
create temporary table old on commit drop as
select ci.id item_id, civ.id version_id, ci.content_key
from app.content_items ci join app.content_item_versions civ on civ.content_item_id=ci.id and civ.status='published'
where ci.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and ci.item_type='mcq' and ci.status='published' and ci.content_key in ('apchem-mcq-001','apchem-mcq-021','apchem-mcq-081','apchem-mcq-084','apchem-mcq-sv-001-v1','apchem-mcq-sv-001-v2','apchem-mcq-sv-001-v3','apchem-mcq-sv-021-v1','apchem-mcq-sv-021-v2','apchem-mcq-sv-021-v3','apchem-mcq-sv-081-v1','apchem-mcq-sv-084-v1');
do $$ begin
 if (select count(*) from old)<>12 then raise exception 'expected 12 published superseded items, got %', (select count(*) from old); end if;
 if (select count(*) from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and status='published' and (content_key like 'apchem-mcq-b6-h-1.%' or content_key like 'apchem-mcq-b6-sv-h-1.%'))<>64 then raise exception 'the 64 new items are not all published; publish first'; end if;
end $$;
update app.content_review_assignments set status='skipped' where content_item_version_id in (select version_id from old) and assignment_purpose='subject_review' and status in ('pending','in_progress');
update app.content_item_versions set status='retired', updated_at=now() where id in (select version_id from old);
update app.content_items set status='retired', updated_at=now() where id in (select item_id from old);
do $$ declare n int; begin
 select count(*) into n from app.content_items where id in (select item_id from old) and status='retired'; if n<>12 then raise exception 'retire count %', n; end if;
 select count(*) into n from app.content_items ci where ci.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and ci.status='published' and not exists (select 1 from app.content_item_versions v where v.content_item_id=ci.id and v.status='published') and ci.item_type='mcq'; 
 raise notice 'published MCQ items without a published version (pre-existing defects count too): %', n;
end $$;
select count(*) retired from old;
commit;
