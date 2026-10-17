import json
from pathlib import Path
p=Path(__file__).parent
t=json.loads((p/'release-plan.json').read_text());assert len(t)==23 and sum(x['kind']=='choice_repair' for x in t)==20
j=json.dumps(t,ensure_ascii=False);owner="'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid"
setup=f'''-- APPROVAL-0194: owner-authorized 20 graphical-choice releases + 3 teaching images.
begin;
set local lock_timeout='3s'; set local statement_timeout='60s';
select pg_advisory_xact_lock(hashtext('stats-precalc-visual-release-20261017'));
create temporary table visual_targets on commit drop as
select * from jsonb_to_recordset($packet${j}$packet$::jsonb)
as t(content_key text,kind text,old_version_id uuid,new_version_id uuid,new_version_num int,item_id uuid,pack_id uuid,version_hash text,item_hash text,choices_hash text,old_taxonomy_hash text,old_path text,png text,storage_path text,sha256 text,bytes bigint,alt_text text,long_description text,stimulus text,choices jsonb,package jsonb);
'''
guard=f'''do $g$ begin
if (select count(*) from visual_targets)<>23 or (select count(*) from visual_targets where kind='choice_repair')<>20 then raise exception 'Bounded batch cardinality'; end if;
if not exists(select 1 from app.profiles where user_id={owner} and role='admin') then raise exception 'Owner approver missing'; end if;
perform ci.id from app.content_items ci join visual_targets t on t.item_id=ci.id order by ci.id for update of ci;
perform v.id from app.content_item_versions v join visual_targets t on t.old_version_id=v.id order by v.id for update of v;
if (select count(*) from visual_targets t join app.content_item_versions v on v.id=t.old_version_id join app.content_items ci on ci.id=t.item_id where v.content_item_id=ci.id and ci.content_key=t.content_key and ci.status='published' and v.status='published' and md5(to_jsonb(v)::text)=t.version_hash and md5(to_jsonb(ci)::text)=t.item_hash and (select md5(jsonb_agg(to_jsonb(c) order by c.choice_key)::text) from app.mcq_choices c where c.content_item_version_id=v.id)=t.choices_hash)<>23 then raise exception 'Current source/item/key drift'; end if;
if exists(select 1 from visual_targets t join app.content_item_versions v on v.content_item_id=t.item_id where t.kind='choice_repair' and v.version_num>=t.new_version_num) then raise exception 'A successor version already exists'; end if;
if exists(select 1 from visual_targets t join app.content_asset_metadata a on a.content_item_version_id=t.old_version_id) or exists(select 1 from visual_targets t join app.content_visual_requirements r on r.content_item_version_id=t.old_version_id) then raise exception 'Unexpected existing visual history'; end if;
if exists(select 1 from visual_targets t left join storage.objects o on o.bucket_id='content-assets' and o.name=t.storage_path left join storage.buckets b on b.id=o.bucket_id where o.id is null or b.public is distinct from false or (o.metadata->>'size')::bigint<>t.bytes or o.metadata->>'mimetype'<>'image/png') then raise exception 'Reviewed private PNG absent'; end if;
if exists(select 1 from visual_targets t join app.content_taxonomy_labels l on l.content_item_id=t.item_id and l.superseded_by is null where t.kind='choice_repair') then raise exception 'New serving labels require explicit revalidation path'; end if;
if exists(select 1 from visual_targets t where t.kind='choice_repair' and (select count(*) from app.content_item_cells c where c.content_item_version_id=t.old_version_id and c.superseded_by is null and c.is_primary)<>1) then raise exception 'Missing predecessor primary cell'; end if;
end $g$;
create temporary table old_sources on commit drop as select v.id,to_jsonb(v) data from app.content_item_versions v join visual_targets t on t.old_version_id=v.id;
'''
write=f'''insert into app.content_item_versions(id,content_item_id,version_num,stem,stimulus,prompt_json,explanation,help_text,content_hash,status,created_by,canonical_answer_1,canonical_answer_2,review_status,rubric_type,evaluator_strategy,stimulus_image_path,item_package_schema_version,item_package_payload,item_package_sha256)
select t.new_version_id,t.item_id,t.new_version_num,v.stem,t.stimulus,v.prompt_json||jsonb_build_object('content_version',t.new_version_num,'qa_remediation','2026-10-17 graphical histogram choices APPROVAL-0194','qa_source_version_id',v.id,'choice_presentation','shared_all_choices_sheet'),v.explanation,v.help_text,v.content_hash,'draft',v.created_by,v.canonical_answer_1,v.canonical_answer_2,null,v.rubric_type,v.evaluator_strategy,t.storage_path,v.item_package_schema_version,t.package,encode(extensions.digest(t.package::text,'sha256'),'hex')
from visual_targets t join app.content_item_versions v on v.id=t.old_version_id where t.kind='choice_repair';
insert into app.mcq_choices(content_item_version_id,choice_key,choice_text,is_correct,rationale)
select t.new_version_id,c.choice_key,c.choice_text,c.is_correct,c.rationale from visual_targets t cross join lateral jsonb_to_recordset(t.choices) as c(choice_key text,choice_text text,is_correct boolean,rationale text) where t.kind='choice_repair';
update app.content_item_versions v set content_hash=md5(v.stem||E'\\n'||v.stimulus||E'\\n'||(select string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text,E'\\n' order by c.choice_key) from app.mcq_choices c where c.content_item_version_id=v.id)) from visual_targets t where t.kind='choice_repair' and v.id=t.new_version_id;
insert into app.content_item_cells(content_item_version_id,content_item_id,taxonomy_source_version,topic_code,skill_code,is_primary,assignment_status,source,model_run_id,validated_by,validated_at,validation_decision_id)
select t.new_version_id,c.content_item_id,c.taxonomy_source_version,c.topic_code,c.skill_code,c.is_primary,c.assignment_status,c.source,c.model_run_id,c.validated_by,c.validated_at,c.validation_decision_id from visual_targets t join app.content_item_cells c on c.content_item_version_id=t.old_version_id and c.superseded_by is null where t.kind='choice_repair';
insert into app.content_asset_metadata(content_item_version_id,storage_bucket,storage_path,alt_text,long_description,approved_by,approved_at)
select new_version_id,'content-assets',storage_path,alt_text,long_description,{owner},now() from visual_targets;
insert into app.content_visual_requirements(content_item_version_id,image_needed,image_approval,decided_by,decided_at)
select new_version_id,'yes','approved',{owner},now() from visual_targets;
update app.content_item_versions v set stimulus_image_path=t.storage_path from visual_targets t where t.kind='teaching_image' and v.id=t.old_version_id;
insert into app.content_review_assignments(content_review_assignment_id,content_item_version_id,reviewer_id,review_stage,review_kind,status,assignment_purpose,created_by)
select gen_random_uuid(),new_version_id,{owner},'tutor_question','mcq','pending','owner_remediation_approval',{owner} from visual_targets where kind='choice_repair';
insert into app.content_review_decisions(content_review_assignment_id,content_item_version_id,reviewer_id,review_stage,tutor_score,difficulty_label,diagnostic_flag,concern_codes,note,tutor_decision,decision_payload,decision_hash,created_by)
select cra.content_review_assignment_id,t.new_version_id,{owner},'tutor_question',1,'Medium',false,array[]::text[],'Owner-directed APPROVAL-0194 visual release: all four histogram choices, reviewed frequency-error distractors, original stem/data/key preserved. Independent QA evidence recorded in release packet.','approve',jsonb_build_object('approval_basis','APPROVAL-0194','content_key',t.content_key,'source_version_id',t.old_version_id),md5(t.new_version_id::text||'APPROVAL-0194'),{owner}
from visual_targets t join app.content_review_assignments cra on cra.content_item_version_id=t.new_version_id and cra.assignment_purpose='owner_remediation_approval' and cra.status='pending' where t.kind='choice_repair';
update app.content_item_versions v set status='retired' from visual_targets t where t.kind='choice_repair' and v.id=t.old_version_id;
update app.content_item_versions v set status='reviewed_approved',review_status='question_review_approved',approved_by={owner},approved_at=now() from visual_targets t where t.kind='choice_repair' and v.id=t.new_version_id;
update app.content_item_versions v set status='published',published_at=now() from visual_targets t where t.kind='choice_repair' and v.id=t.new_version_id;
'''
verify='''do $v$ begin
if (select count(*) from visual_targets t join app.content_item_versions v on v.id=t.new_version_id join app.content_asset_metadata a on a.content_item_version_id=v.id and a.storage_path=v.stimulus_image_path join app.content_visual_requirements r on r.content_item_version_id=v.id where v.status='published' and v.stimulus_image_path=t.storage_path and a.approved_at is not null and a.alt_text=t.alt_text and r.image_needed='yes' and r.image_approval='approved')<>23 then raise exception '23 published approved image contracts expected'; end if;
if exists(select 1 from visual_targets t join app.content_item_versions v on v.id=t.old_version_id join old_sources o on o.id=v.id where (to_jsonb(v)-'status'-'updated_at'-'stimulus_image_path')<>(o.data-'status'-'updated_at'-'stimulus_image_path')) then raise exception 'Predecessor content changed'; end if;
if exists(select 1 from visual_targets t join app.content_item_versions v on v.id=t.new_version_id join old_sources o on o.id=t.old_version_id where v.stem<>o.data->>'stem' or (t.kind='teaching_image' and app.taxonomy_relevant_hash(v.id)<>t.old_taxonomy_hash)) then raise exception 'Stem or teaching taxonomy drift'; end if;
if exists(select 1 from visual_targets t where (select count(*) from app.content_item_versions v where v.content_item_id=t.item_id and v.status='published')<>1) then raise exception 'Publication cardinality'; end if;
if exists(select 1 from visual_targets t where t.kind='choice_repair' and ((select string_agg(choice_key,',' order by choice_key) from app.mcq_choices c where c.content_item_version_id=t.new_version_id and c.is_correct) is distinct from (select string_agg(choice_key,',' order by choice_key) from app.mcq_choices c where c.content_item_version_id=t.old_version_id and c.is_correct) or (select count(*) from app.mcq_choices c where c.content_item_version_id=t.new_version_id)<>4)) then raise exception 'Key/cardinality mismatch'; end if;
if exists(select 1 from visual_targets t where t.kind='choice_repair' and (select count(*) from app.content_item_cells c where c.content_item_version_id=t.new_version_id and c.superseded_by is null)<>(select count(*) from app.content_item_cells c where c.content_item_version_id=t.old_version_id and c.superseded_by is null)) then raise exception 'Serving cell copy incomplete'; end if;
if exists(select 1 from visual_targets t join app.content_items ci on ci.id=t.item_id where md5(to_jsonb(ci)::text)<>t.item_hash) then raise exception 'Parent item changed'; end if;
end $v$;
'''
receipt="select jsonb_build_object('checked_at',now(),'approval','APPROVAL-0194','published_choice_revisions',20,'teaching_images',3,'approved_images',23,'source_stems_and_answer_keys_preserved',true,'prior_versions_and_objects_retained',true) as result;\n"
# Rollback exercise restores old paths/status, keeps inserted histories until outer ROLLBACK.
restore='''update app.content_item_versions v set status='retired' from visual_targets t where t.kind='choice_repair' and v.id=t.new_version_id;
update app.content_item_versions v set status='published' from visual_targets t where t.kind='choice_repair' and v.id=t.old_version_id;
update app.content_item_versions v set stimulus_image_path=t.old_path from visual_targets t where t.kind='teaching_image' and v.id=t.old_version_id;
delete from app.content_visual_requirements r using visual_targets t where t.kind='teaching_image' and r.content_item_version_id=t.old_version_id and r.image_needed='yes' and r.image_approval='approved';
do $r$ begin
if (select count(*) from visual_targets t join app.content_item_versions v on v.id=t.old_version_id where v.status='published' and v.stimulus_image_path is not distinct from t.old_path)<>23 then raise exception 'Recovery incomplete'; end if;
end $r$;
'''
(p/'publish-production.sql').write_text(setup+guard+write+verify+receipt+'commit;\n')
(p/'rehearse.sql').write_text(setup+guard+write+verify+restore+receipt+'rollback;\n')
recoveryguard='''do $g$ begin
if (select count(*) from visual_targets t join app.content_item_versions v on v.id=t.new_version_id where v.status='published' and v.stimulus_image_path=t.storage_path)<>23 then raise exception 'Recovery exact-current-path guard'; end if;
if exists(select 1 from visual_targets t join app.content_item_versions v on v.id=t.new_version_id where t.kind='choice_repair' and (v.stimulus<>t.stimulus or v.item_package_payload<>t.package or v.prompt_json->>'qa_source_version_id'<>t.old_version_id::text or (select jsonb_agg(jsonb_build_object('choice_key',c.choice_key,'choice_text',c.choice_text,'is_correct',c.is_correct,'rationale',c.rationale) order by c.choice_key) from app.mcq_choices c where c.content_item_version_id=v.id)<>t.choices)) then raise exception 'Recovery revised content drift'; end if;
end $g$;
'''
(p/'recover-production.sql').write_text(setup+recoveryguard+restore+'-- Retain every asset/metadata/review/new-version record. No learner state changed.\ncommit;\n')
print('Prepared bounded guarded publish/rehearsal/recovery SQL.')
