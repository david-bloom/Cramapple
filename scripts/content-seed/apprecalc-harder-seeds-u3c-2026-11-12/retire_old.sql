begin;
select pg_advisory_xact_lock(hashtext('cramapple-apprecalc-u3c-2026-11-12-retire-20261112'));
create temporary table old on commit drop as
select ci.id item_id, civ.id version_id, ci.content_key
from app.content_items ci join app.content_item_versions civ on civ.content_item_id=ci.id and civ.status='published'
where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.item_type='mcq' and ci.status='published' and ci.content_key in ('apprecalc-mcq-017','apprecalc-mcq-sv-017-v1','apprecalc-mcq-sv-017-v2','apprecalc-mcq-sv-017-v3','apprecalc-mcq-np2-010','apprecalc-mcq-sv-np2-010-v1','apprecalc-mcq-sv-np2-010-v2','apprecalc-mcq-sv-np2-010-v3','apprecalc-mcq-047','apprecalc-mcq-sv-047-v1','apprecalc-mcq-sv-047-v2','apprecalc-mcq-sv-047-v3','apprecalc-mcq-019','apprecalc-mcq-np2-008','apprecalc-mcq-sv-019-v1','apprecalc-mcq-sv-019-v2','apprecalc-mcq-sv-019-v3','apprecalc-mcq-sv-np2-008-v1','apprecalc-mcq-sv-np2-008-v3','apprecalc-mcq-020','apprecalc-mcq-049','apprecalc-mcq-sv-020-v1','apprecalc-mcq-sv-020-v2','apprecalc-mcq-sv-020-v3','apprecalc-mcq-sv-049-v1','apprecalc-mcq-sv-049-v3');
do $$ begin
 if (select count(*) from old)<>26 then raise exception 'expected 26 published superseded items, got %', (select count(*) from old); end if;
 if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and status='published' and (content_key like 'apprecalc-mcq-b3-h-3.%' or content_key like 'apprecalc-mcq-b3-sv-h-3.%'))<>48 then raise exception 'the 48 new items are not all published; publish first'; end if;
end $$;
update app.content_review_assignments set status='skipped' where content_item_version_id in (select version_id from old) and assignment_purpose='subject_review' and status in ('pending','in_progress');
update app.content_item_versions set status='retired', updated_at=now() where id in (select version_id from old);
update app.content_items set status='retired', updated_at=now() where id in (select item_id from old);
do $$ declare n int; begin
 select count(*) into n from app.content_items where id in (select item_id from old) and status='retired'; if n<>26 then raise exception 'retire count %', n; end if;
 select count(*) into n from app.content_items ci where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.status='published' and not exists (select 1 from app.content_item_versions v where v.content_item_id=ci.id and v.status='published') and ci.item_type='mcq'; 
 raise notice 'published MCQ items without a published version (pre-existing defects count too): %', n;
end $$;
select count(*) retired from old;
commit;
