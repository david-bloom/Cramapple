begin;
select pg_advisory_xact_lock(hashtext('cramapple-apprecalc-u1a-2026-11-12-retire-20261112'));
create temporary table old on commit drop as
select ci.id item_id, civ.id version_id, ci.content_key
from app.content_items ci join app.content_item_versions civ on civ.content_item_id=ci.id and civ.status='published'
where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.item_type='mcq' and ci.status='published' and ci.content_key in ('apprecalc-mcq-002','apprecalc-mcq-004','apprecalc-mcq-023','apprecalc-mcq-028','apprecalc-mcq-051','apprecalc-mcq-052','apprecalc-mcq-053','apprecalc-mcq-np2-001','apprecalc-mcq-np2-009','apprecalc-mcq-sv-002-v1','apprecalc-mcq-sv-002-v2','apprecalc-mcq-sv-002-v3','apprecalc-mcq-sv-004-v1','apprecalc-mcq-sv-004-v2','apprecalc-mcq-sv-004-v3','apprecalc-mcq-sv-023-v1','apprecalc-mcq-sv-023-v2','apprecalc-mcq-sv-023-v3','apprecalc-mcq-sv-028-v1','apprecalc-mcq-sv-028-v2','apprecalc-mcq-sv-028-v3','apprecalc-mcq-sv-051-v1','apprecalc-mcq-sv-051-v2','apprecalc-mcq-sv-051-v3','apprecalc-mcq-sv-052-v1','apprecalc-mcq-sv-052-v2','apprecalc-mcq-sv-052-v3','apprecalc-mcq-sv-053-v1','apprecalc-mcq-sv-053-v2','apprecalc-mcq-sv-053-v3','apprecalc-mcq-sv-np2-001-v1','apprecalc-mcq-sv-np2-001-v2','apprecalc-mcq-sv-np2-001-v3','apprecalc-mcq-sv-np2-009-v1','apprecalc-mcq-sv-np2-009-v2','apprecalc-mcq-sv-np2-009-v3');
do $$ begin
 if (select count(*) from old)<>36 then raise exception 'expected 36 published superseded items, got %', (select count(*) from old); end if;
 if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and status='published' and (content_key like 'apprecalc-mcq-b10-h-1.%' or content_key like 'apprecalc-mcq-b10-sv-h-1.%'))<>56 then raise exception 'the 56 new items are not all published; publish first'; end if;
end $$;
update app.content_review_assignments set status='skipped' where content_item_version_id in (select version_id from old) and assignment_purpose='subject_review' and status in ('pending','in_progress');
update app.content_item_versions set status='retired', updated_at=now() where id in (select version_id from old);
update app.content_items set status='retired', updated_at=now() where id in (select item_id from old);
do $$ declare n int; begin
 select count(*) into n from app.content_items where id in (select item_id from old) and status='retired'; if n<>36 then raise exception 'retire count %', n; end if;
 select count(*) into n from app.content_items ci where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.status='published' and not exists (select 1 from app.content_item_versions v where v.content_item_id=ci.id and v.status='published') and ci.item_type='mcq'; 
 raise notice 'published MCQ items without a published version (pre-existing defects count too): %', n;
end $$;
select count(*) retired from old;
commit;
