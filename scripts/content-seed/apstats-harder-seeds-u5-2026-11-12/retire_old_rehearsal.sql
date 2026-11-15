begin;
select pg_advisory_xact_lock(hashtext('cramapple-apstats-u5-2026-11-12-retire-20261112'));
create temporary table old on commit drop as
select ci.id item_id, civ.id version_id, ci.content_key
from app.content_items ci join app.content_item_versions civ on civ.content_item_id=ci.id and civ.status='published'
where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.item_type='mcq' and ci.status='published' and ci.content_key in ('APSTATS-MCQ-087','APSTATS-MCQ-028','APSTATS-MCQ-033','APSTATS-MCQ-036','APSTATS-MCQ-030','APSTATS-MCQ-031','APSTATS-MCQ-032','APSTATS-MCQ-082','APSTATS-MCQ-083','APSTATS-MCQ-084','APSTATS-MCQ-029','APSTATS-MCQ-085','APSTATS-MCQ-034','APSTATS-MCQ-035','APSTATS-MCQ-090');
do $$ begin
 if (select count(*) from old)<>15 then raise exception 'expected 15 published superseded items, got %', (select count(*) from old); end if;
 if (select count(*) from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and status='published' and (content_key like 'apstats-mcq-b8-h-5.%' or content_key like 'apstats-mcq-b8-sv-h-5.%'))<>60 then raise exception 'the 60 new items are not all published; publish first'; end if;
end $$;
update app.content_review_assignments set status='skipped' where content_item_version_id in (select version_id from old) and assignment_purpose='subject_review' and status in ('pending','in_progress');
update app.content_item_versions set status='retired', updated_at=now() where id in (select version_id from old);
update app.content_items set status='retired', updated_at=now() where id in (select item_id from old);
do $$ declare n int; begin
 select count(*) into n from app.content_items where id in (select item_id from old) and status='retired'; if n<>15 then raise exception 'retire count %', n; end if;
 select count(*) into n from app.content_items ci where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.status='published' and not exists (select 1 from app.content_item_versions v where v.content_item_id=ci.id and v.status='published') and ci.item_type='mcq';
 raise notice 'published MCQ items without a published version (pre-existing defects count too): %', n;
end $$;
do $$ begin raise exception 'REHEARSAL OK (rolled back): retired=%', (select count(*) from old); end $$;
rollback;
