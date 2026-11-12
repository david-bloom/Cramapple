begin;
select pg_advisory_xact_lock(hashtext('cramapple-apcalcbc-u2-2026-11-12-retire-20261112'));
create temporary table old on commit drop as
select ci.id item_id, civ.id version_id, ci.content_key
from app.content_items ci join app.content_item_versions civ on civ.content_item_id=ci.id and civ.status='published'
where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.item_type='mcq' and ci.status='published' and ci.content_key in ('apcalcbc-mcq-080','apcalcbc-mcq-ab-025','apcalcbc-mcq-ab-028','apcalcbc-mcq-ab-sv-025-v2','apcalcbc-mcq-ab-sv-025-v3','apcalcbc-mcq-ab-sv-028-v1','apcalcbc-mcq-ab-sv-028-v2','apcalcbc-mcq-ab-sv-028-v3','apcalcbc-mcq-ab-u2n-001','apcalcbc-mcq-ab-u2n-001-v1','apcalcbc-mcq-ab-u2n-001-v2','apcalcbc-mcq-ab-u2n-001-v3','apcalcbc-mcq-ab-u2n-004','apcalcbc-mcq-ab-u2n-004-v1','apcalcbc-mcq-ab-u2n-004-v2','apcalcbc-mcq-ab-u2n-004-v3','apcalcbc-mcq-ab-u2n-006','apcalcbc-mcq-ab-u2n-006-v1','apcalcbc-mcq-ab-u2n-006-v2','apcalcbc-mcq-ab-u2n-006-v3','apcalcbc-mcq-ab-u2n-008','apcalcbc-mcq-ab-u2n-008-v1','apcalcbc-mcq-ab-u2n-008-v2','apcalcbc-mcq-ab-u2n-008-v3','apcalcbc-mcq-ab-u2n-009','apcalcbc-mcq-ab-u2n-009-v1','apcalcbc-mcq-ab-u2n-009-v2','apcalcbc-mcq-ab-u2n-009-v3','apcalcbc-mcq-ab-u3n-014','apcalcbc-mcq-ab-u3n-014-v1','apcalcbc-mcq-ab-u3n-014-v2','apcalcbc-mcq-ab-u3n-014-v3','apcalcbc-mcq-np1-004');
do $$ begin
 if (select count(*) from old)<>33 then raise exception 'expected 33 published superseded items, got %', (select count(*) from old); end if;
 if (select count(*) from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and status='published' and (content_key like 'apcalcbc-mcq-b5-h-2.%' or content_key like 'apcalcbc-mcq-b5-sv-h-2.%'))<>80 then raise exception 'the 80 new items are not all published; publish first'; end if;
end $$;
update app.content_review_assignments set status='skipped' where content_item_version_id in (select version_id from old) and assignment_purpose='subject_review' and status in ('pending','in_progress');
update app.content_item_versions set status='retired', updated_at=now() where id in (select version_id from old);
update app.content_items set status='retired', updated_at=now() where id in (select item_id from old);
do $$ declare n int; begin
 select count(*) into n from app.content_items where id in (select item_id from old) and status='retired'; if n<>33 then raise exception 'retire count %', n; end if;
 select count(*) into n from app.content_items ci where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.status='published' and not exists (select 1 from app.content_item_versions v where v.content_item_id=ci.id and v.status='published') and ci.item_type='mcq'; 
 raise notice 'published MCQ items without a published version (pre-existing defects count too): %', n;
end $$;
do $$ begin raise exception 'REHEARSAL OK (rolled back): retired=%', (select count(*) from old); end $$;
rollback;
