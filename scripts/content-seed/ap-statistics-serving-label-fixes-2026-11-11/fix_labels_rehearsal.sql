begin;
select pg_advisory_xact_lock(hashtext('cramapple-apstats-label-fixes-20261111'));
create temporary table fix (content_key text primary key) on commit drop;
insert into fix values ('APSTATS-MCQ-079'),('APSTATS-SFRQ-010');
create temporary table r on commit drop as
select ctl.content_taxonomy_label_id lid, civ.id vid, app.taxonomy_relevant_hash(civ.id) h, gen_random_uuid() vd, f.content_key
from fix f join app.content_items ci on ci.content_key=f.content_key and ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.status='published'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.status='published'
join app.content_taxonomy_labels ctl on ctl.content_item_id=ci.id and ctl.label_scope='serving' and ctl.superseded_by is null;
do $$ begin
 if (select count(*) from r)<>2 then raise exception 'expected 2 targets, got %', (select count(*) from r); end if;
 if exists (select 1 from r join app.content_taxonomy_labels l on l.content_taxonomy_label_id=r.lid where l.label_status<>'held') then raise exception 'a target label is not held'; end if;
 if exists (select 1 from r join app.content_item_cells c on c.content_item_version_id=r.vid and c.is_primary and c.superseded_by is null where c.topic_code<>'4.1') then raise exception 'primary topic is not 4.1'; end if;
end $$;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decided_at, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd, lid, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, now(), 'corrected', 'chat_review', 4, array[4],
 'Product Owner chat instruction 2026-11-11 (fix serving labels, Statistics Units 2 to 4). The two-model serving run held this item on a Unit 2 versus Unit 4 disagreement (sampling distribution of x-bar, topics 2.12 and 4.1). Resolved to Unit 4 to match its validated primary topic 4.1, the conservative choice: it is served only once a student reaches Unit 4.' from r;
update app.content_taxonomy_labels l set required_units=array[4], primary_unit=4, max_required_unit=4, label_status='validated', validation_decision_id=r.vd, validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validated_against_version_id=r.vid, validated_against_taxo_hash=r.h from r where l.content_taxonomy_label_id=r.lid;
do $$ declare n int; begin
 select count(*) into n from app.content_taxonomy_labels l join r on r.lid=l.content_taxonomy_label_id where l.label_status='validated' and l.required_units=array[4] and l.max_required_unit=4 and l.primary_unit=4 and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(r.vid);
 if n<>2 then raise exception 'post-check failed: %', n; end if;
 -- call the real selector for a unit-4 student with no history
 select count(*) into n from public.select_student_practice_items('548f06be-ccf4-426d-b82b-b424137a4438'::uuid, 4, gen_random_uuid(), null, null, null, 51, 0) s where s.content_key in ('APSTATS-MCQ-079','APSTATS-SFRQ-010');
 raise notice 'selector returns % of the 2 fixed items for a unit-4 student', n;
end $$;
do $$ begin raise exception 'REHEARSAL OK (rolled back): selector returns % of 2 fixed items', (select count(*) from public.select_student_practice_items('548f06be-ccf4-426d-b82b-b424137a4438'::uuid, 4, gen_random_uuid(), null, null, null, 51, 0) s where s.content_key in ('APSTATS-MCQ-079','APSTATS-SFRQ-010')); end $$;
rollback;
