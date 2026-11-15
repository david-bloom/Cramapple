begin;
select pg_advisory_xact_lock(hashtext('cramapple-apstats-u3-harder-retire-20261111'));
create temporary table old on commit drop as
select ci.id item_id, civ.id version_id, ci.content_key
from app.content_items ci join app.content_item_versions civ on civ.content_item_id=ci.id and civ.status='published'
where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.item_type='mcq' and ci.status='published' and ci.content_key in ('APSTATS-MCQ-060','APSTATS-MCQ-SV-060-v1','APSTATS-MCQ-SV-060-v2','APSTATS-MCQ-SV-060-v3','APSTATS-MCQ-061','APSTATS-MCQ-SV-061-v1','APSTATS-MCQ-SV-061-v2','APSTATS-MCQ-SV-061-v3','APSTATS-MCQ-067','APSTATS-MCQ-SV-067-v1','APSTATS-MCQ-SV-067-v2','APSTATS-MCQ-SV-067-v3','APSTATS-MCQ-063','APSTATS-MCQ-SV-063-v1','APSTATS-MCQ-SV-063-v2','APSTATS-MCQ-SV-063-v3','APSTATS-MCQ-071','APSTATS-MCQ-SV-071-v1','APSTATS-MCQ-SV-071-v2','APSTATS-MCQ-SV-071-v3','APSTATS-MCQ-092','APSTATS-MCQ-SV-092-v1','APSTATS-MCQ-SV-092-v2','APSTATS-MCQ-SV-092-v3','APSTATS-MCQ-076','APSTATS-MCQ-SV-076-v1','APSTATS-MCQ-SV-076-v2','APSTATS-MCQ-SV-076-v3','APSTATS-MCQ-066','APSTATS-MCQ-080','APSTATS-MCQ-SV-080-v1','APSTATS-MCQ-SV-080-v3','APSTATS-MCQ-011-CAL','APSTATS-OHT-3.3','APSTATS-MCQ-SV-058-v1','APSTATS-MCQ-SV-058-v2','APSTATS-MCQ-SV-058-v3');
do $$ begin
 if (select count(*) from old)<>37 then raise exception 'expected 37 published superseded items, got %', (select count(*) from old); end if;
 if (select count(*) from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and status='published' and (content_key like 'APSTATS-MCQ-H-3.%' or content_key like 'APSTATS-MCQ-SV-H-3.%'))<>76 then raise exception 'the 76 new items are not all published; publish first'; end if;
end $$;
update app.content_review_assignments set status='skipped' where content_item_version_id in (select version_id from old) and assignment_purpose='subject_review' and status in ('pending','in_progress');
update app.content_item_versions set status='retired', updated_at=now() where id in (select version_id from old);
update app.content_items set status='retired', updated_at=now() where id in (select item_id from old);
do $$ declare n int; begin
 select count(*) into n from app.content_items where id in (select item_id from old) and status='retired'; if n<>37 then raise exception 'retire count %', n; end if;
 select count(*) into n from app.content_items ci where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.status='published' and not exists (select 1 from app.content_item_versions v where v.content_item_id=ci.id and v.status='published') and ci.item_type='mcq'; 
 raise notice 'published MCQ items without a published version (pre-existing defects count too): %', n;
end $$;
do $$ begin raise exception 'REHEARSAL OK (rolled back): retired=%', (select count(*) from old); end $$;
rollback;
