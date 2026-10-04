begin;
select pg_advisory_xact_lock(hashtext('cramapple-held-four-release-20261004'));
create temporary table tx (content_key text primary key, pack uuid, tsv uuid, old_vid uuid, old_stem_md5 text, new_stem text, strip boolean, unit integer, req integer[], topic text, skill text) on commit drop;
insert into tx values
('apphycem-mcq-003','841a88cc-773c-44e5-97fa-6504f8667689'::uuid,'ef9618c9-de85-4941-8837-4dce4c755e62'::uuid,'310c3aab-790a-43c6-a2d8-75a617d6f2d5'::uuid,'7f623d5efe393327fb94a0b8d2cbec0c','A closed Gaussian surface encloses only a charge-free region of space. The net electric flux through this surface is',false,8,'{8}'::integer[],'8.6','3.B'),
('apphycm-mcq-023','ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9'::uuid,'d77d7801-441d-49bb-a2cf-a02f6bff407d'::uuid,'18ada83c-3177-4506-b8b6-1200358df615'::uuid,'0fe79b5d5b65449498d49b9307e65c4d','A block slides down a frictionless incline at angle θ. The normal force on the block is',true,2,'{2}'::integer[],'2.2',null),
('apphycm-mcq-031','ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9'::uuid,'d77d7801-441d-49bb-a2cf-a02f6bff407d'::uuid,'53067725-5cab-4423-b089-fa4992dba508'::uuid,'1e1968d71f896c76089a201786bc06f5','For constant mass m and v(t), net force equals',true,2,'{1,2}'::integer[],'2.5','3.B'),
('apphy2-mcq-001','f584ab0d-114a-4520-9649-42e3e9a2fd22'::uuid,'b3e41b93-95d8-40c6-bef5-98cc99111915'::uuid,'da82cdbc-afc0-4e9c-85b1-a6c10b5eb761'::uuid,'9177ed0ea4eb10f2c8b42510be3a07b4','For an ideal gas at fixed volume, doubling absolute temperature makes pressure',true,9,'{9}'::integer[],'9.2','2.D');
create temporary table cur on commit drop as
select x.*, ci.id item_id, civ.stem old_stem, civ.version_num old_vnum
from tx x join app.content_items ci on ci.content_key=x.content_key and ci.exam_pack_version_id=x.pack and ci.item_type='mcq' and ci.status='published'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.status='published' and civ.id=x.old_vid and md5(civ.stem)=x.old_stem_md5;
create temporary table lab0 on commit drop as
select c.content_key, l.content_taxonomy_label_id old_label, l.label_status old_status, (select max(m.label_version) from app.content_taxonomy_labels m where m.content_item_id=c.item_id and m.label_scope='serving') max_ver
from cur c join app.content_taxonomy_labels l on l.content_item_id=c.item_id and l.label_scope='serving' and l.superseded_by is null and l.label_status='held' and l.primary_unit is null and l.source='vercel_ai_gateway_two_model_serving_lane';
do $$ begin
 if (select count(*) from cur)<>4 then raise exception 'expected 4 items (published version id and stem md5 guard), got %',(select count(*) from cur); end if;
 if (select count(*) from cur where strip)<>3 then raise exception 'expected 3 strip-only items'; end if;
 if exists (select 1 from cur where strip and rtrim(regexp_replace(old_stem, E'\\n\\s*A[\\.\\)]\\s[\\s\\S]*$', ''))<>new_stem) then raise exception 'a strip-only stem differs from the old stem minus its A-D list'; end if;
 if exists (select 1 from cur where not strip and (old_stem<>new_stem or old_stem ~ E'\\n\\s*A[\\.\\)]\\s')) then raise exception 'the no-new-version item has an inline list or differs'; end if;
 if (select count(*) from lab0)<>4 then raise exception 'expected 4 current held serving labels, got %',(select count(*) from lab0); end if;
 if exists (select 1 from app.content_item_cells c join cur u on u.item_id=c.content_item_id) then raise exception 'a target already has cells'; end if;
 if (select count(*) from app.mcq_choices c join cur u on u.old_vid=c.content_item_version_id)<>16 then raise exception 'choice rows not 16'; end if; end $$;
create temporary table mod on commit drop as select * from cur where strip;
create temporary table changed (content_key text primary key, old_version_id uuid not null, new_version_id uuid not null) on commit drop;
do $$
declare t record; v_old app.content_item_versions%rowtype; v_new uuid; v_stem text;
begin
  for t in select * from mod order by content_key loop
    select * into strict v_old from app.content_item_versions where id=t.old_vid for update;
    v_stem := t.new_stem;
    perform 1 from app.content_items where id=t.item_id for update;
    v_new := gen_random_uuid();
    update app.content_review_assignments set status='skipped' where content_item_version_id=v_old.id and assignment_purpose='subject_review' and status in ('pending','in_progress');
    update app.content_item_versions set status='retired', updated_at=now() where id=v_old.id;
    update app.content_items set status='draft', updated_at=now() where id=t.item_id;
    insert into app.content_item_versions (id,content_item_id,version_num,stem,stimulus,prompt_json,explanation,help_text,content_hash,status,created_by,canonical_answer_1,canonical_answer_2,review_status,rubric_type,evaluator_strategy,stimulus_image_path)
    values (v_new,t.item_id,v_old.version_num+1,v_stem,v_old.stimulus,
      coalesce(v_old.prompt_json,'{}'::jsonb) || jsonb_build_object('content_version',v_old.version_num+1,'qa_remediation','2026-10-04 held-item release: duplicated A-D list removed from the stem; choices, key and rationales unchanged','qa_source_version_id',v_old.id),
      v_old.explanation,v_old.help_text,md5(v_stem),'draft','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,v_old.canonical_answer_1,v_old.canonical_answer_2,null,v_old.rubric_type,v_old.evaluator_strategy,v_old.stimulus_image_path);
    insert into app.mcq_choices (content_item_version_id,choice_key,choice_text,is_correct,rationale) select v_new,choice_key,choice_text,is_correct,rationale from app.mcq_choices where content_item_version_id=v_old.id;
    insert into app.content_item_difficulty (content_item_version_id,difficulty,basis,attainment_ratio,ratio_source,subject_cut_points,source_value,rationale,confidence,proposal_run,created_by)
      select v_new,difficulty,basis,attainment_ratio,ratio_source,subject_cut_points,source_value,rationale,confidence,proposal_run,created_by from app.content_item_difficulty where content_item_version_id=v_old.id;
    insert into changed values (t.content_key,v_old.id,v_new);
  end loop;
end $$;
update app.content_item_versions civ set content_hash = md5(coalesce(civ.stem,'')||E'\n'||coalesce(civ.stimulus,'')||E'\n'||coalesce((select string_agg(m.choice_key||':'||m.choice_text||':'||m.is_correct::text||':'||coalesce(m.rationale,''), E'\n' order by m.choice_key) from app.mcq_choices m where m.content_item_version_id=civ.id),'')) from changed r where civ.id=r.new_version_id;
insert into app.content_review_assignments (content_review_assignment_id,content_item_version_id,reviewer_id,review_stage,review_kind,status,assignment_purpose,created_by)
select gen_random_uuid(),new_version_id,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,'tutor_question','mcq','pending','owner_remediation_approval','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from changed;
insert into app.content_review_decisions (content_review_assignment_id,content_item_version_id,reviewer_id,review_stage,tutor_score,difficulty_label,diagnostic_flag,concern_codes,note,tutor_decision,decision_payload,decision_hash,created_by)
select cra.content_review_assignment_id,r.new_version_id,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,'tutor_question',1,'Medium',false,array[]::text[],
  'Owner-approved strip-only repair 2026-10-04 (held-item release): duplicated A-D list removed from the stem; choices, key and rationales unchanged. ' || r.content_key,'approve',
  jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','held_release_stem_strip','content_key',r.content_key,'qa_date','2026-10-04'),
  md5(r.new_version_id::text||'f5a26c6b-3566-4d58-9e97-979fbb947564'||'held-release-20261004'),'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from changed r join app.content_review_assignments cra on cra.content_item_version_id=r.new_version_id and cra.assignment_purpose='owner_remediation_approval' and cra.status='pending';
update app.content_item_versions civ set status='reviewed_approved', review_status='question_review_approved', approved_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, approved_at=coalesce(civ.approved_at,now()), updated_at=now() from changed r where civ.id=r.new_version_id;
update app.content_items ci set status='reviewed_approved', updated_at=now() from changed r join app.content_item_versions civ on civ.id=r.new_version_id where ci.id=civ.content_item_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from changed r where civ.id=r.new_version_id;
update app.content_items ci set status='published', updated_at=now() from changed r join app.content_item_versions civ on civ.id=r.new_version_id where ci.id=civ.content_item_id;
-- validated serving labels for all four items on their final published version
create temporary table tgt on commit drop as
select c.content_key, c.item_id, coalesce(r.new_version_id,c.old_vid) version_id, c.tsv, c.unit, c.req, o.old_label, o.old_status, o.max_ver, gen_random_uuid() new_label_id, gen_random_uuid() vd_id
from cur c join lab0 o on o.content_key=c.content_key left join changed r on r.content_key=c.content_key;
do $$ begin if (select count(*) from tgt)<>4 or exists (select 1 from tgt t join app.content_item_versions v on v.id=t.version_id where v.status<>'published') then raise exception 'label target mismatch'; end if; end $$;
insert into app.content_taxonomy_labels (content_taxonomy_label_id,content_item_id,label_version,label_scope,required_units,max_required_unit,primary_unit,assessed_topics,taxonomy_source_version,taxonomy_confidence,label_status,source,source_payload,model_run_id,created_by)
select new_label_id,item_id,max_ver+1,'serving',req,(select max(u) from unnest(req) u),unit,array[]::text[],tsv,'provisional','provisional_model','held_release_2026_10_04',
 jsonb_build_object('origin','held_release','note','replaces a held serving label; unit assigned by four-model vote and validated by the Product Owner release','supersedes_status',old_status),'held-release-2026-10-04','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
update app.content_taxonomy_labels l set superseded_by=t.new_label_id from tgt t where l.content_taxonomy_label_id=t.old_label;
insert into app.content_taxonomy_validation_decisions (validation_decision_id,content_taxonomy_label_id,decided_by,decision,decision_source,reviewed_primary_unit,reviewed_required_units,notes)
select vd_id,new_label_id,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,'confirmed','automated_spot_check',unit,req,'Product Owner chat instruction 2026-10-04: release of four held published MCQs to validated serving labels (four-model vote on unit and topic).' from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.new_label_id;
-- cells
create temporary table tc on commit drop as select t.*, c.topic, c.skill from tgt t join cur c on c.content_key=t.content_key;
insert into app.content_item_cells (content_item_version_id,content_item_id,taxonomy_source_version,topic_code,skill_code,is_primary,assignment_status,source,model_run_id,validated_by,validated_at,validation_decision_id)
select version_id,item_id,tsv,topic,null,true,'validated','held_release_topic_2026_10_04','held-release-topic-2026-10-04 (four-model vote)',null,now(),gen_random_uuid() from tc;
create temporary table sk on commit drop as select * from tc where skill is not null;
insert into app.content_item_cells (content_item_version_id,content_item_id,taxonomy_source_version,topic_code,skill_code,is_primary,assignment_status,source,model_run_id,validated_by,validated_at,validation_decision_id)
select version_id,item_id,tsv,topic,skill,false,'validated','held_release_skill_2026_10_04:4of4','held-release-skill-2026-10-04 (four-model vote, 4 of 4)',null,now(),gen_random_uuid() from sk;
do $$ declare n int; begin
  select count(*) into n from changed; if n<>3 then raise exception 'expected 3 changed, got %', n; end if;
  select count(*) into n from changed r join app.mcq_choices o on o.content_item_version_id=r.old_version_id join app.mcq_choices w on w.content_item_version_id=r.new_version_id and w.choice_key=o.choice_key where w.is_correct<>o.is_correct or w.choice_text<>o.choice_text or w.rationale is distinct from o.rationale; if n<>0 then raise exception 'a choice changed'; end if;
  select count(*) into n from app.mcq_choices c join changed r on r.new_version_id=c.content_item_version_id; if n<>12 then raise exception 'choice rows %', n; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.source='held_release_2026_10_04' and l.primary_unit=t.unit and l.required_units=t.req and l.validated_against_version_id=t.version_id and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>4 then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.old_label=l.content_taxonomy_label_id where l.superseded_by is not null; if n<>4 then raise exception 'old labels not superseded'; end if;
  select count(*) into n from app.content_item_versions v join tgt t on t.version_id=v.id where v.stem ~ E'\\n\\s*A[\\.\\)]\\s' or v.status<>'published'; if n<>0 then raise exception 'a stem has a list or is not published'; end if;
  select count(*) into n from (select v.content_item_id from app.content_item_versions v where v.status='published' and v.content_item_id in (select item_id from tgt) group by 1 having count(*)<>1) d; if n<>0 then raise exception 'published version count wrong'; end if;
  select count(*) into n from app.content_item_cells where source='held_release_topic_2026_10_04' and is_primary and superseded_by is null and assignment_status='validated'; if n<>4 then raise exception 'topic cell count %', n; end if;
  select count(*) into n from app.content_item_cells where source='held_release_skill_2026_10_04:4of4' and not is_primary and skill_code is not null and superseded_by is null and assignment_status='validated'; if n<>3 then raise exception 'skill cell count %', n; end if;
end $$;
do $$ begin raise exception 'REHEARSAL OK (rolled back): versions_changed=%, labels_written=%, topic_cells=%, skill_cells=%', (select count(*) from changed), (select count(*) from tgt), (select count(*) from tc), (select count(*) from sk); end $$;
rollback;
