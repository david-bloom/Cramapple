begin;
select pg_advisory_xact_lock(hashtext('cramapple-apphycm-u13-seedfix-20261003'));
create temporary table fx_stem (content_key text primary key, old_vid uuid, old_stem_md5 text, new_stem text, strip boolean) on commit drop;
insert into fx_stem values
('apphycm-mcq-001','db2e6c78-ef6f-46a1-a4fb-1dbbb906f2e6'::uuid,'5b07a99805cd15f260e0b6e218f5dda1','If v(t)=3t² in SI units, the acceleration at t=2 s is',false),
('apphycm-mcq-002','7cfdacff-5cb8-417c-9e45-0cd579e98c76'::uuid,'a08cf565ac09f6d055507e9ed5cab28f','The displacement from t=0 to T for v(t)=kt is',false),
('apphycm-mcq-003','afa57d5f-9865-4994-abe8-5417da1b27db'::uuid,'8e20232b84f3bf51c5a60dd1d0861da4','A force F(x)=ax acts in one dimension. The work from 0 to L is',false),
('apphycm-mcq-006','1bf78f57-14be-4400-8f4a-ef79e6f7b01d'::uuid,'289cd937cfafea3f34fb3e8b93247de8','A particle moves in one dimension under a conservative force with potential energy U(x). The force on the particle is given by which of the following?',false),
('apphycm-mcq-007','ae4db131-c654-4d7a-a9c7-7b54e994341c'::uuid,'2472ea99f210f8b61fadc0ee89884271','A power law P(t)=ct² delivers energy from 0 to T equal to',true),
('apphycm-mcq-008','856ead17-947c-4e0f-9592-a2da10b0ade6'::uuid,'24335487f3d75309305488716d52ef78','At a stable equilibrium x₀, U(x) has',true),
('apphycm-mcq-017','69deeb0b-611a-45fd-8e64-defec3e092f4'::uuid,'48a043436c3537193317b494ee0599f6','If x(t)=At³-Bt, velocity is',false),
('apphycm-mcq-018','9604811c-40a7-46b2-9340-80f09c38e5d0'::uuid,'44813fb93ec996ffe82be059163f6b12','A force F(x)=F₀e^{-x/L} acts along the direction of displacement, with L a positive constant. The work done as the object moves from x=0 to x→∞ is',true),
('apphycm-mcq-021','2b6e1aa8-7f08-43b1-b7f0-fffa0bbe380d'::uuid,'7f52f8887434c49a0815c157e0960fec','For x(t)=Ct⁴, acceleration is',false),
('apphycm-mcq-022','b7950289-62d4-4275-9b06-bcf1e5523221'::uuid,'d2bcf4dff21f17396d943e6d7f11c5d9','The signed area under a velocity-versus-time graph equals',true),
('apphycm-mcq-024','54867242-0e93-4bf4-81d1-a54d044bc394'::uuid,'653e6c08f0a805df67acc5fa856b3841','For U(x)=(1/2)kx² with k>0, x=0 is stable because',true),
('apphycm-mcq-025','c6bc1dcb-e4be-4a4a-bdcf-cf908d8aff43'::uuid,'b666f37d87d201c0372f8622c193011c','For m dv/dt=-bv, the characteristic decay time is',true),
('apphycm-mcq-026','20aa73d9-a25a-4836-a602-ba540df33334'::uuid,'3490578e22851e88d7169aa22a6b2143','A particle in uniform circular motion has',true),
('apphycm-mcq-027','a9e501c1-c9e1-4237-b40f-07cee0b30fb3'::uuid,'deea4065b29de0e965ae9ce78856a0e4','The work done from x=a to x=b by F(x) is',false),
('apphycm-mcq-028','6876d1f1-f40b-4415-beb3-bae7898459ff'::uuid,'017f2b0ce0a127d7e421f95dc7f03f4c','For U(x)=Ax³, the force is',true),
('apphycm-mcq-029','4276e4d3-afac-4f10-8232-1c1c05f563f8'::uuid,'3ae13e815293832ccbfb2b0dce1c19d4','At a one-dimensional classical turning point with total energy E,',true),
('apphycm-mcq-030','dc3bec4a-550a-47d9-85f3-7eedc09c996f'::uuid,'26791f35060e2a91dd7e461fc70c0263','A force F acts on a particle with velocity v. Instantaneous power is',false);
create temporary table fx_ch (content_key text, choice_key text, new_text text, new_rat text) on commit drop;
insert into fx_ch values
('apphycm-mcq-001','A','3 m/s²','Reads the coefficient 3 in v(t)=3t² as the acceleration itself, as if v were proportional to t, instead of differentiating v(t) with respect to time.'),
('apphycm-mcq-002','A','kT','Gives the final velocity v(T)=kT, which has units of speed rather than displacement; displacement requires integrating the linearly increasing velocity over the interval.'),
('apphycm-mcq-002','D','k/T','Divides the constant k by T, a quantity with units of acceleration per unit time, instead of integrating the velocity over the interval; it is not a displacement.'),
('apphycm-mcq-003','D','a/L','Divides the force gradient a by L instead of integrating the force over the displacement; integrating ax always produces a term proportional to L², never a/L.'),
('apphycm-mcq-006','C','-U/x','Divides U by x instead of differentiating; -U/x equals -dU/dx only when U is directly proportional to x, so it is wrong for a general potential energy function.'),
('apphycm-mcq-006','D','+d^2U/dx^2','This differentiates U twice. The second derivative is the curvature (stiffness) of the potential well and equals minus the rate of change of the force with position; it is not the force itself, which is −dU/dx.'),
('apphycm-mcq-017','D','A t³','Gives only the cubic term At³ and drops the −Bt term; no derivative has been taken, so this is not a velocity expression at all.'),
('apphycm-mcq-021','C','24Ct','This differentiates a third time, one differentiation too many: d³x/dt³ = 24Ct.'),
('apphycm-mcq-027','C','(1/2)[F(a)+F(b)](b-a) always','Averaging the endpoint forces is not valid for every F(x); it equals the integral only in special cases such as a force that is linear in position, so the word ''always'' makes this false.'),
('apphycm-mcq-030','D','F·a','Power is the rate of work, F·v; the product of force and acceleration F·a does not have units of power and is not the rate of energy transfer.');
create temporary table tcv (content_key text primary key, topic text) on commit drop;
insert into tcv values ('apphycm-mcq-001','1.2'),('apphycm-mcq-002','1.2'),('apphycm-mcq-003','3.2'),('apphycm-mcq-006','3.3'),('apphycm-mcq-007','3.5'),('apphycm-mcq-008','3.3'),('apphycm-mcq-017','1.2'),('apphycm-mcq-018','3.2'),('apphycm-mcq-021','1.2'),('apphycm-mcq-022','1.3'),('apphycm-mcq-024','3.3'),('apphycm-mcq-025','2.9'),('apphycm-mcq-026','2.10'),('apphycm-mcq-027','3.2'),('apphycm-mcq-028','3.3'),('apphycm-mcq-029','3.4'),('apphycm-mcq-030','3.5');
create temporary table mod on commit drop as
select ci.content_key, ci.id item_id, civ.id old_vid, f.strip, f.new_stem, civ.stem old_stem from app.content_items ci join app.content_item_versions civ on civ.content_item_id=ci.id and civ.status='published'
join fx_stem f on f.content_key=ci.content_key and f.old_vid=civ.id and f.old_stem_md5=md5(civ.stem)
where ci.exam_pack_version_id='ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9' and ci.item_type='mcq' and ci.status='published';
create temporary table lab0 on commit drop as
select m.content_key, l.content_taxonomy_label_id old_label, l.label_version old_ver, l.label_status old_status, l.taxonomy_source_version tsv, l.required_units req, l.primary_unit pu, l.assessed_topics
from mod m join app.content_taxonomy_labels l on l.content_item_id=m.item_id and l.label_scope='serving' and l.superseded_by is null;
do $$ begin
 if (select count(*) from mod)<>17 then raise exception 'expected 17 items to change (version id/stem md5 guard), got %',(select count(*) from mod); end if;
 if (select count(*) from mod where strip)<>9 then raise exception 'expected 9 strip-only items'; end if;
 if exists (select 1 from mod where strip and rtrim(regexp_replace(old_stem, E'\\n\\s*A[\\.\\)]\\s[\\s\\S]*$', ''))<>new_stem) then raise exception 'a strip-only stem differs from the old stem minus its A-D list'; end if;
 if (select count(*) from lab0)<>17 or exists (select 1 from lab0 where old_status<>'validated') then raise exception 'a target lacks exactly one current validated serving label'; end if;
 if exists (select 1 from app.content_item_cells c join mod m on m.old_vid=c.content_item_version_id where c.superseded_by is null) then raise exception 'target already has cells'; end if; end $$;
create temporary table changed (content_key text primary key, old_version_id uuid not null, new_version_id uuid not null) on commit drop;
do $$
declare t record; v_old app.content_item_versions%rowtype; v_new uuid; v_stem text; e record; v_hits int;
begin
  for t in select * from mod order by content_key loop
    select * into strict v_old from app.content_item_versions where id=t.old_vid for update;
    select new_stem into strict v_stem from fx_stem where content_key=t.content_key;
    perform 1 from app.content_items where id=t.item_id for update;
    v_new := gen_random_uuid();
    update app.content_review_assignments set status='skipped' where content_item_version_id=v_old.id and assignment_purpose='subject_review' and status in ('pending','in_progress');
    update app.content_item_versions set status='retired', updated_at=now() where id=v_old.id;
    update app.content_items set status='draft', updated_at=now() where id=t.item_id;
    insert into app.content_item_versions (id,content_item_id,version_num,stem,stimulus,prompt_json,explanation,help_text,content_hash,status,created_by,canonical_answer_1,canonical_answer_2,review_status,rubric_type,evaluator_strategy,stimulus_image_path)
    values (v_new,t.item_id,v_old.version_num+1,v_stem,v_old.stimulus,
      coalesce(v_old.prompt_json,'{}'::jsonb) || jsonb_build_object('content_version',v_old.version_num+1,'qa_remediation','2026-10-03 AP Physics C: Mechanics Units 1-3 audit: rationale/distractor/stem defects repaired and duplicated A-D list removed from the stem; keys unchanged','qa_source_version_id',v_old.id),
      v_old.explanation,v_old.help_text,md5(v_stem),'draft','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,v_old.canonical_answer_1,v_old.canonical_answer_2,null,v_old.rubric_type,v_old.evaluator_strategy,v_old.stimulus_image_path);
    insert into app.mcq_choices (content_item_version_id,choice_key,choice_text,is_correct,rationale) select v_new,choice_key,choice_text,is_correct,rationale from app.mcq_choices where content_item_version_id=v_old.id;
    for e in select * from fx_ch where content_key=t.content_key loop
      update app.mcq_choices set choice_text=e.new_text, rationale=e.new_rat where content_item_version_id=v_new and choice_key=e.choice_key;
      get diagnostics v_hits = row_count;
      if v_hits<>1 then raise exception 'fix for % choice % matched % rows', t.content_key, e.choice_key, v_hits; end if;
    end loop;
    insert into app.content_item_cells (content_item_version_id,content_item_id,taxonomy_source_version,topic_code,skill_code,is_primary,assignment_status,source,model_run_id,validated_by,validated_at,validation_decision_id)
      select v_new,content_item_id,taxonomy_source_version,topic_code,skill_code,is_primary,assignment_status,source,model_run_id,validated_by,validated_at,validation_decision_id from app.content_item_cells where content_item_version_id=v_old.id and superseded_by is null;
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
  'Owner-approved repair 2026-10-03 (AP Physics C: Mechanics Units 1-3 audit): rationale, distractor and stem defects corrected (two-checker re-audit clean) and the duplicated A-D list removed from the stem; keys unchanged. ' || r.content_key,'approve',
  jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','seed_audit_rationale_and_stem_repair','content_key',r.content_key,'qa_date','2026-10-03'),
  md5(r.new_version_id::text||'f5a26c6b-3566-4d58-9e97-979fbb947564'||'apphycm-u13-seedfix-20261003'),'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from changed r join app.content_review_assignments cra on cra.content_item_version_id=r.new_version_id and cra.assignment_purpose='owner_remediation_approval' and cra.status='pending';
update app.content_item_versions civ set status='reviewed_approved', review_status='question_review_approved', approved_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, approved_at=coalesce(civ.approved_at,now()), updated_at=now() from changed r where civ.id=r.new_version_id;
update app.content_items ci set status='reviewed_approved', updated_at=now() from changed r join app.content_item_versions civ on civ.id=r.new_version_id where ci.id=civ.content_item_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from changed r where civ.id=r.new_version_id;
update app.content_items ci set status='published', updated_at=now() from changed r join app.content_item_versions civ on civ.id=r.new_version_id where ci.id=civ.content_item_id;
-- carry the validated serving label forward to the new versions
create temporary table tgt on commit drop as
select r.content_key, civ.content_item_id item_id, r.new_version_id version_id, o.old_label, o.old_ver, o.old_status, o.tsv, o.req, o.pu, o.assessed_topics, gen_random_uuid() new_label_id, gen_random_uuid() vd_id
from changed r join app.content_item_versions civ on civ.id=r.new_version_id join lab0 o on o.content_key=r.content_key;
do $$ begin if (select count(*) from tgt)<>17 then raise exception 'label target mismatch: %', (select count(*) from tgt); end if; end $$;
insert into app.content_taxonomy_labels (content_taxonomy_label_id,content_item_id,label_version,label_scope,required_units,max_required_unit,primary_unit,assessed_topics,taxonomy_source_version,taxonomy_confidence,label_status,source,source_payload,model_run_id,created_by)
select new_label_id,item_id,old_ver+1,'serving',req,(select max(u) from unnest(req) u),pu,coalesce(assessed_topics,array[]::text[]),tsv,'provisional','provisional_model','apphycm_u13_pipeline_2026_10_03',
 jsonb_build_object('origin','carry_forward','note','unit and required units carried forward from the current validated label after a rationale/stem repair','supersedes_status',old_status),'apphycm-u13-pipeline-2026-10-03','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
update app.content_taxonomy_labels l set superseded_by=t.new_label_id from tgt t where l.content_taxonomy_label_id=t.old_label;
insert into app.content_taxonomy_validation_decisions (validation_decision_id,content_taxonomy_label_id,decided_by,decision,decision_source,reviewed_primary_unit,reviewed_required_units,notes)
select vd_id,new_label_id,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,'confirmed','automated_spot_check',pu,req,'Product Owner chat instruction 2026-10-03 (continue: Units 1-3 pipeline, AP Physics C: Mechanics). Carry-forward of the validated serving label after repair; both blind checkers placed the repaired item in the same unit.' from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.new_label_id;
-- primary topic cells (17 items, stage-1 topic votes >= 5 of 6) on the published versions
create temporary table tc on commit drop as
select v.*, ci.id item_id, civ.id version_id from tcv v join app.content_items ci on ci.content_key=v.content_key and ci.exam_pack_version_id='ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9' and ci.status='published'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.status='published';
do $$ begin
 if (select count(*) from tc)<>17 then raise exception 'expected 17 topic targets, got %', (select count(*) from tc);end if;
 if exists (select 1 from tc join app.content_item_cells c on c.content_item_version_id=tc.version_id and c.is_primary and c.superseded_by is null) then raise exception 'a topic target already has a primary cell'; end if;
end $$;
insert into app.content_item_cells (content_item_version_id,content_item_id,taxonomy_source_version,topic_code,skill_code,is_primary,assignment_status,source,model_run_id,validated_by,validated_at,validation_decision_id)
select version_id,item_id,'d77d7801-441d-49bb-a2cf-a02f6bff407d'::uuid,topic,null,true,'validated','apphycm_u13_topic_2026_10_03','apphycm-topic-probe-2026-10-03 (gemini-3.8-flash + deepseek-v4-pro + gpt-6.1-sol, 2 samples each; topic agreement >= 5 of 6)',null,now(),gen_random_uuid() from tc;
do $$ declare n int; begin
  select count(*) into n from changed; if n<>17 then raise exception 'expected 17 changed, got %', n; end if;
  select count(*) into n from changed r join app.mcq_choices o on o.content_item_version_id=r.old_version_id join app.mcq_choices w on w.content_item_version_id=r.new_version_id and w.choice_key=o.choice_key where w.is_correct<>o.is_correct; if n<>0 then raise exception 'a key changed'; end if;
  select count(*) into n from app.mcq_choices c join changed r on r.new_version_id=c.content_item_version_id; if n<>68 then raise exception 'choice rows %', n; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>(select count(*) from tgt) then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_versions v join changed r on r.new_version_id=v.id where v.stem ~ E'\\n\\s*A[\\.\\)]\\s' or v.status<>'published'; if n<>0 then raise exception 'a new stem has a list or is not published'; end if;
  select count(*) into n from (select v.content_item_id from app.content_item_versions v where v.status='published' and v.content_item_id in (select item_id from tgt) group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions'; end if;
  select count(*) into n from app.content_item_cells where source='apphycm_u13_topic_2026_10_03' and is_primary and superseded_by is null; if n<>17 then raise exception 'topic cell count %', n; end if;
end $$;
do $$ begin raise exception 'REHEARSAL OK (rolled back): versions_changed=%, labels_written=%, topic_cells=%', (select count(*) from changed), (select count(*) from tgt), (select count(*) from tc); end $$;
rollback;
