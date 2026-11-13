begin;
select pg_advisory_xact_lock(hashtext('cramapple-apphysics1-u3b-2026-11-12-retire-20261112'));
create temporary table old on commit drop as
select ci.id item_id, civ.id version_id, ci.content_key
from app.content_items ci join app.content_item_versions civ on civ.content_item_id=ci.id and civ.status='published'
where ci.exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and ci.item_type='mcq' and ci.status='published' and ci.content_key in ('apphy1-mcq-007','apphy1-mcq-036','apphy1-mcq-np1-009','apphy1-mcq-sv-007-v1','apphy1-mcq-sv-007-v2','apphy1-mcq-sv-007-v3','apphy1-mcq-sv-036-v1','apphy1-mcq-sv-036-v2','apphy1-mcq-sv-036-v3','apphy1-mcq-sv-np1-009-v1','apphy1-mcq-sv-np1-009-v2','apphy1-mcq-006','apphy1-mcq-020','apphy1-mcq-037','apphy1-mcq-np1-007','apphy1-mcq-sv-006-v1','apphy1-mcq-sv-006-v2','apphy1-mcq-sv-006-v3','apphy1-mcq-sv-020-v3','apphy1-mcq-sv-037-v1','apphy1-mcq-sv-037-v2','apphy1-mcq-sv-037-v3','apphy1-mcq-sv-np1-007-v1','apphy1-mcq-sv-np1-007-v2','apphy1-mcq-sv-np1-007-v3','apphy1-mcq-008','apphy1-mcq-038','apphy1-mcq-sv-008-v1','apphy1-mcq-sv-008-v2','apphy1-mcq-sv-008-v3','apphy1-mcq-sv-038-v2','apphy1-mcq-sv-038-v3','apphy1-mcq-039','apphy1-mcq-041','apphy1-mcq-sv-039-v1','apphy1-mcq-sv-039-v2','apphy1-mcq-sv-039-v3','apphy1-mcq-sv-041-v2','apphy1-mcq-sv-041-v3','apphy1-mcq-sv-np1-010-v1','apphy1-mcq-sv-np1-010-v2','apphy1-mcq-sv-np1-010-v3');
do $$ begin
 if (select count(*) from old)<>42 then raise exception 'expected 42 published superseded items, got %', (select count(*) from old); end if;
 if (select count(*) from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and status='published' and (content_key like 'apphysics1-mcq-b2-h-3.%' or content_key like 'apphysics1-mcq-b2-sv-h-3.%'))<>40 then raise exception 'the 40 new items are not all published; publish first'; end if;
end $$;
update app.content_review_assignments set status='skipped' where content_item_version_id in (select version_id from old) and assignment_purpose='subject_review' and status in ('pending','in_progress');
update app.content_item_versions set status='retired', updated_at=now() where id in (select version_id from old);
update app.content_items set status='retired', updated_at=now() where id in (select item_id from old);
do $$ declare n int; begin
 select count(*) into n from app.content_items where id in (select item_id from old) and status='retired'; if n<>42 then raise exception 'retire count %', n; end if;
 select count(*) into n from app.content_items ci where ci.exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and ci.status='published' and not exists (select 1 from app.content_item_versions v where v.content_item_id=ci.id and v.status='published') and ci.item_type='mcq'; 
 raise notice 'published MCQ items without a published version (pre-existing defects count too): %', n;
end $$;
do $$ begin raise exception 'REHEARSAL OK (rolled back): retired=%', (select count(*) from old); end $$;
rollback;
