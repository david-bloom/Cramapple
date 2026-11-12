begin;
select pg_advisory_xact_lock(hashtext('cramapple-apphycm-u1-2026-11-12-retire-20261112'));
create temporary table old on commit drop as
select ci.id item_id, civ.id version_id, ci.content_key
from app.content_items ci join app.content_item_versions civ on civ.content_item_id=ci.id and civ.status='published'
where ci.exam_pack_version_id='ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9' and ci.item_type='mcq' and ci.status='published' and ci.content_key in ('apphycm-mcq-043','apphycm-mcq-044','apphycm-mcq-sv-043-v1','apphycm-mcq-sv-043-v2','apphycm-mcq-sv-043-v3','apphycm-mcq-sv-044-v1','apphycm-mcq-sv-044-v2','apphycm-mcq-sv-044-v3','apphycm-mcq-001','apphycm-mcq-002','apphycm-mcq-017','apphycm-mcq-sv-001-v1','apphycm-mcq-sv-001-v2','apphycm-mcq-sv-001-v3','apphycm-mcq-sv-002-v3','apphycm-mcq-sv-017-v1','apphycm-mcq-sv-017-v2','apphycm-mcq-sv-017-v3','apphycm-mcq-022');
do $$ begin
 if (select count(*) from old)<>19 then raise exception 'expected 19 published superseded items, got %', (select count(*) from old); end if;
 if (select count(*) from app.content_items where exam_pack_version_id='ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9' and status='published' and (content_key like 'apphycm-mcq-b6-h-1.%' or content_key like 'apphycm-mcq-b6-sv-h-1.%'))<>40 then raise exception 'the 40 new items are not all published; publish first'; end if;
end $$;
update app.content_review_assignments set status='skipped' where content_item_version_id in (select version_id from old) and assignment_purpose='subject_review' and status in ('pending','in_progress');
update app.content_item_versions set status='retired', updated_at=now() where id in (select version_id from old);
update app.content_items set status='retired', updated_at=now() where id in (select item_id from old);
do $$ declare n int; begin
 select count(*) into n from app.content_items where id in (select item_id from old) and status='retired'; if n<>19 then raise exception 'retire count %', n; end if;
 select count(*) into n from app.content_items ci where ci.exam_pack_version_id='ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9' and ci.status='published' and not exists (select 1 from app.content_item_versions v where v.content_item_id=ci.id and v.status='published') and ci.item_type='mcq'; 
 raise notice 'published MCQ items without a published version (pre-existing defects count too): %', n;
end $$;
do $$ begin raise exception 'REHEARSAL OK (rolled back): retired=%', (select count(*) from old); end $$;
rollback;
