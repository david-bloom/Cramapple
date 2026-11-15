begin;
select pg_advisory_xact_lock(hashtext('cramapple-apstats-u2-harder-retire-20261110'));
create temporary table old on commit drop as
select ci.id item_id, civ.id version_id, ci.content_key
from app.content_items ci join app.content_item_versions civ on civ.content_item_id=ci.id and civ.status='published'
where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.item_type='mcq' and ci.status='published' and ci.content_key in ('APSTATS-MCQ-050','APSTATS-MCQ-SV-050-v1','APSTATS-MCQ-SV-050-v2','APSTATS-MCQ-SV-050-v3','APSTATS-MCQ-051','APSTATS-MCQ-SV-051-v1','APSTATS-MCQ-SV-051-v2','APSTATS-MCQ-SV-051-v3','APSTATS-MCQ-046','APSTATS-MCQ-SV-046-v1','APSTATS-MCQ-SV-046-v2','APSTATS-MCQ-SV-046-v3','APSTATS-MCQ-048','APSTATS-MCQ-SV-048-v1','APSTATS-MCQ-SV-048-v2','APSTATS-MCQ-SV-048-v3','APSTATS-MCQ-054','APSTATS-MCQ-SV-054-v1','APSTATS-MCQ-SV-054-v2','APSTATS-MCQ-SV-054-v3','APSTATS-MCQ-049','APSTATS-MCQ-SV-049-v1','APSTATS-MCQ-SV-049-v2','APSTATS-MCQ-SV-049-v3','APSTATS-MCQ-081','APSTATS-MCQ-SV-081-v1','APSTATS-MCQ-SV-081-v2','APSTATS-MCQ-SV-081-v3','APSTATS-MCQ-052','APSTATS-MCQ-SV-052-v1','APSTATS-MCQ-SV-052-v2','APSTATS-MCQ-SV-052-v3','APSTATS-MCQ-073');
do $$ begin
 if (select count(*) from old)<>33 then raise exception 'expected 33 published superseded items, got %', (select count(*) from old); end if;
 if (select count(*) from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and status='published' and (content_key like 'APSTATS-MCQ-H-%' or content_key like 'APSTATS-MCQ-SV-H-%'))<>96 then raise exception 'the 96 new items are not all published; publish first'; end if;
end $$;
update app.content_review_assignments set status='skipped' where content_item_version_id in (select version_id from old) and assignment_purpose='subject_review' and status in ('pending','in_progress');
update app.content_item_versions set status='retired', updated_at=now() where id in (select version_id from old);
update app.content_items set status='retired', updated_at=now() where id in (select item_id from old);
do $$ declare n int; begin
 select count(*) into n from app.content_items where id in (select item_id from old) and status='retired'; if n<>33 then raise exception 'retire count %', n; end if;
 select count(*) into n from app.content_items ci where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.status='published' and not exists (select 1 from app.content_item_versions v where v.content_item_id=ci.id and v.status='published') and ci.item_type='mcq'; 
 raise notice 'published MCQ items without a published version (pre-existing defects count too): %', n;
end $$;
select count(*) retired from old;
commit;
