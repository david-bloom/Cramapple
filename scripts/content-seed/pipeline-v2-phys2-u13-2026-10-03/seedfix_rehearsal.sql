begin;
select pg_advisory_xact_lock(hashtext('cramapple-apphy2-u13-seedfix-20261003'));
create temporary table fx_stem (content_key text primary key, old_vid uuid, old_stem_md5 text, new_stem text, strip boolean) on commit drop;
insert into fx_stem values
('apphy2-mcq-002','79a6b93d-55d9-4ae0-b884-4dd334e8dfac'::uuid,'886ab86f51bfd3bcf0fe61fbe4e4c482','During an isothermal expansion of an ideal gas, its internal-energy change is',false),
('apphy2-mcq-003','70984727-0772-45e4-a04a-8ee28c582513'::uuid,'dc7a50faae98d902ef90307f4beef749','Which of the following best explains why energy is spontaneously transferred from a hot object to a cold object?',false),
('apphy2-mcq-004','0e153951-2152-4c66-9e46-947b7c72a92a'::uuid,'ec2d7f8ce11cc2c744dd1bc836d0b766','The electric field direction at a point is the direction of force on',false),
('apphy2-mcq-005','58f46bfd-3a78-43b4-a6fe-30f506e84c75'::uuid,'7b6159c9420f8b750d7ca57348854270','Moving a positive charge opposite a uniform electric field causes electric potential energy to',false),
('apphy2-mcq-006','a437632c-4747-43f4-bc98-86f4bd5f490e'::uuid,'f0f76d961cd07dcf56fed68cffd2f76e','Two identical positive point charges are placed on a horizontal line, one to the left of the other. At the midpoint between them, the electric field is',false),
('apphy2-mcq-007','3f988f70-a49e-4a96-a66a-2cd9e9afedd5'::uuid,'95de5e2c606a3115213000da07834509','Two resistors 3 Ω and 6 Ω in parallel have equivalent resistance',true),
('apphy2-mcq-008','ff54dff1-7b63-4f09-864e-88125f0638da'::uuid,'a86753372523db6ca1ec3467f8e6bb1c','A 12 V battery drives 3 A through a resistor. Its resistance is',true),
('apphy2-mcq-009','b8dd7e16-c158-4213-8642-0fa0b878af86'::uuid,'8040ca08c64e518880c67d0de32cdc5d','Immediately after an uncharged capacitor is connected through a resistor to a battery, the capacitor behaves approximately like',false),
('apphy2-mcq-021','798ef9d6-60f6-44b1-91d4-586756066360'::uuid,'63da2096924a0148ebae3c4d8a015865','At fixed temperature and volume, doubling the number of ideal-gas molecules makes pressure',true),
('apphy2-mcq-022','d8be3521-4876-4b15-97ae-16aced23753a'::uuid,'6671e917b419bc1fec8982f597ccb671','Two rods have equal dimensions and temperature difference. Rod A has twice Rod B''s thermal conductivity. The steady conduction rate through A is',true),
('apphy2-mcq-023','c4991223-bfc1-4484-985f-1a9916cb4513'::uuid,'1d2581e6398707518adbe7620c4a873f','Two different ideal gases initially separated at the same temperature mix in an insulated container. The total entropy',true),
('apphy2-mcq-024','aef222f0-de71-41ad-8e4a-67aff59afe92'::uuid,'12c3032b808b12b34c65420fe44aa93f','Identical isolated conducting spheres carry charges +6Q and 0. They touch and separate. After separating, the two spheres'' charges are',true),
('apphy2-mcq-025','8b4127b8-7472-456c-bb72-df136bbd5896'::uuid,'96167ac29932b600438aaabbaca02aae','At a point where electric potential is zero, the electric field',false),
('apphy2-mcq-026','7531ab19-6d04-4235-8f80-e9468fa5f048'::uuid,'e49fa15618fddd2fce04e482116bb447','An electron accelerated from rest through a potential difference of magnitude ΔV gains kinetic energy equal to',false),
('apphy2-mcq-027','2661f0f4-ab40-4e36-8069-f3c67a278cbb'::uuid,'579c166c3070f1d72e3d4eebfc68523a','The voltage across a fixed resistor is doubled. Its power dissipation becomes',true),
('apphy2-mcq-028','478b5762-d4b2-4c77-b73c-34cfe38ca585'::uuid,'eb917277c7b373cfa48455b9297cdda3','Traversing an ideal battery from its negative terminal to its positive terminal in a loop equation contributes',true),
('apphy2-mcq-029','0714f061-39d4-477c-937d-5d544bd089db'::uuid,'6298df530e88a1af4310909e11ebded1','Currents 2.0 A and 3.5 A enter a junction. If one current leaves, its magnitude is',true),
('apphy2-mcq-030','6bdafdc6-94e1-4d2b-a304-cd2487a7af30'::uuid,'63ae96e451d9cf7d1e855ce62fd59ce9','A capacitor in series with a resistor has been connected to a DC battery for a very long time. The circuit current is',false);
create temporary table fx_ch (content_key text, choice_key text, new_text text, new_rat text) on commit drop;
insert into fx_ch values
('apphy2-mcq-002','A','positive','Assumes the gas gains internal energy because it takes in heat while expanding, ignoring that for an ideal gas at constant temperature the heat absorbed is converted entirely to work.'),
('apphy2-mcq-003','A','The transfer decreases the total entropy of the system','Reverses the direction required by the second law of thermodynamics for a spontaneous process.'),
('apphy2-mcq-003','B','The transfer increases the total entropy of the system','spontaneous heat transfer increases total entropy'),
('apphy2-mcq-003','C','The transfer violates conservation of energy','Confuses entropy increase with a violation of energy conservation, when heat flow conserves energy while still increasing entropy.'),
('apphy2-mcq-003','D','The transfer decreases the entropy of the cold object','Reverses the actual effect: heat flowing into the cold object increases its entropy, and because the cold object is at the lower temperature (ΔS ≈ Q/T_c for a small transfer) that increase is larger than the hot object''s decrease (≈ Q/T_h), so the total entropy increases.'),
('apphy2-mcq-004','C','any neutral object','A neutral object has no sign of charge, so the force on it cannot define the field direction, whereas the field direction is defined by the force on a positive test charge.'),
('apphy2-mcq-004','D','an electron only','Treats the definition as applying to one particular particle. The field direction is defined by the force on a positive test charge, whatever the sign of the charges that create the field; the force on an electron points opposite to the field.'),
('apphy2-mcq-005','B','increase','Moving a positive charge opposite the field requires positive work by an external force, so the electric potential energy of the charge increases.'),
('apphy2-mcq-005','C','remain zero','Potential energy would stay constant only for motion perpendicular to the field (along an equipotential). Moving opposite the field requires positive work by an external force, so the potential energy changes.'),
('apphy2-mcq-005','D','become negative regardless of the starting value','Assumes the change always produces a negative value. Moving against the field adds energy equal to the positive external work, so the potential energy rises from whatever it was; the sign of the final value depends on the starting value and the reference point.'),
('apphy2-mcq-009','D','a resistor with the same resistance as the series resistor','Treats the capacitor as additional resistance that limits the current. At the first instant the uncharged capacitor has zero potential difference, so it adds no opposition and the current is set by the resistor alone, battery voltage divided by R.'),
('apphy2-mcq-025','B','must be constant nearby','Zero potential at one point says nothing about whether the field is uniform. The field is set by how quickly the potential changes with position, and that can differ from point to point near the zero-potential point.'),
('apphy2-mcq-026','C','2eΔV','This introduces an unnecessary factor of two. The magnitude of the electric potential-energy change is |q|ΔV = eΔV, and by conservation of energy that equals the kinetic energy gained.'),
('apphy2-mcq-026','D','-eΔV','This is the signed potential-energy change, not the kinetic-energy gain. The electron (q = −e) moves to higher potential, so ΔU = qΔV = −eΔV; conservation of energy gives ΔK = −ΔU = +eΔV, and kinetic energy gained from rest cannot be negative.'),
('apphy2-mcq-030','C','infinite','Infinite current is impossible here: the series resistor limits the current to at most V/R even if the capacitor were treated as a short, and at long times the fully charged capacitor blocks DC current rather than shorting it.');
create temporary table tcv (content_key text primary key, topic text) on commit drop;
insert into tcv values ('apphy2-mcq-007','11.5'),('apphy2-mcq-002','9.4'),('apphy2-mcq-003','9.6'),('apphy2-mcq-004','10.3'),('apphy2-mcq-005','10.4'),('apphy2-mcq-006','10.3'),('apphy2-mcq-008','11.3'),('apphy2-mcq-009','11.8'),('apphy2-mcq-021','9.2'),('apphy2-mcq-022','9.5'),('apphy2-mcq-023','9.6'),('apphy2-mcq-024','10.2'),('apphy2-mcq-025','10.5'),('apphy2-mcq-026','10.7'),('apphy2-mcq-027','11.4'),('apphy2-mcq-028','11.6'),('apphy2-mcq-029','11.7'),('apphy2-mcq-030','11.8');
create temporary table mod on commit drop as
select ci.content_key, ci.id item_id, civ.id old_vid, f.strip, f.new_stem, civ.stem old_stem from app.content_items ci join app.content_item_versions civ on civ.content_item_id=ci.id and civ.status='published'
join fx_stem f on f.content_key=ci.content_key and f.old_vid=civ.id and f.old_stem_md5=md5(civ.stem)
where ci.exam_pack_version_id='f584ab0d-114a-4520-9649-42e3e9a2fd22' and ci.item_type='mcq' and ci.status='published';
create temporary table lab0 on commit drop as
select m.content_key, l.content_taxonomy_label_id old_label, l.label_version old_ver, l.label_status old_status, l.taxonomy_source_version tsv, l.required_units req, l.primary_unit pu, l.assessed_topics
from mod m join app.content_taxonomy_labels l on l.content_item_id=m.item_id and l.label_scope='serving' and l.superseded_by is null;
do $$ begin
 if (select count(*) from mod)<>18 then raise exception 'expected 18 items to change (version id/stem md5 guard), got %',(select count(*) from mod); end if;
 if (select count(*) from mod where strip)<>9 then raise exception 'expected 9 strip-only items'; end if;
 if exists (select 1 from mod where strip and rtrim(regexp_replace(old_stem, E'\\n\\s*A[\\.\\)]\\s[\\s\\S]*$', ''))<>new_stem) then raise exception 'a strip-only stem differs from the old stem minus its A-D list'; end if;
 if (select count(*) from lab0)<>18 or exists (select 1 from lab0 where old_status<>'validated') then raise exception 'a target lacks exactly one current validated serving label'; end if;
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
      coalesce(v_old.prompt_json,'{}'::jsonb) || jsonb_build_object('content_version',v_old.version_num+1,'qa_remediation','2026-10-03 AP Physics 2 Units 9-11 audit: rationale/distractor/stem defects repaired and duplicated A-D list removed from the stem; keys unchanged','qa_source_version_id',v_old.id),
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
  'Owner-approved repair 2026-10-03 (AP Physics 2 Units 9-11 audit): rationale, distractor and stem defects corrected (two-checker re-audit clean) and the duplicated A-D list removed from the stem; keys unchanged. ' || r.content_key,'approve',
  jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','seed_audit_rationale_and_stem_repair','content_key',r.content_key,'qa_date','2026-10-03'),
  md5(r.new_version_id::text||'f5a26c6b-3566-4d58-9e97-979fbb947564'||'apphy2-u13-seedfix-20261003'),'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from changed r join app.content_review_assignments cra on cra.content_item_version_id=r.new_version_id and cra.assignment_purpose='owner_remediation_approval' and cra.status='pending';
update app.content_item_versions civ set status='reviewed_approved', review_status='question_review_approved', approved_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, approved_at=coalesce(civ.approved_at,now()), updated_at=now() from changed r where civ.id=r.new_version_id;
update app.content_items ci set status='reviewed_approved', updated_at=now() from changed r join app.content_item_versions civ on civ.id=r.new_version_id where ci.id=civ.content_item_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from changed r where civ.id=r.new_version_id;
update app.content_items ci set status='published', updated_at=now() from changed r join app.content_item_versions civ on civ.id=r.new_version_id where ci.id=civ.content_item_id;
-- carry the validated serving label forward to the new versions
create temporary table tgt on commit drop as
select r.content_key, civ.content_item_id item_id, r.new_version_id version_id, o.old_label, o.old_ver, o.old_status, o.tsv, o.req, o.pu, o.assessed_topics, gen_random_uuid() new_label_id, gen_random_uuid() vd_id
from changed r join app.content_item_versions civ on civ.id=r.new_version_id join lab0 o on o.content_key=r.content_key;
do $$ begin if (select count(*) from tgt)<>18 then raise exception 'label target mismatch: %', (select count(*) from tgt); end if; end $$;
insert into app.content_taxonomy_labels (content_taxonomy_label_id,content_item_id,label_version,label_scope,required_units,max_required_unit,primary_unit,assessed_topics,taxonomy_source_version,taxonomy_confidence,label_status,source,source_payload,model_run_id,created_by)
select new_label_id,item_id,old_ver+1,'serving',req,(select max(u) from unnest(req) u),pu,coalesce(assessed_topics,array[]::text[]),tsv,'provisional','provisional_model','apphy2_u13_pipeline_2026_10_03',
 jsonb_build_object('origin','carry_forward','note','unit and required units carried forward from the current validated label after a rationale/stem repair','supersedes_status',old_status),'apphy2-u13-pipeline-2026-10-03','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
update app.content_taxonomy_labels l set superseded_by=t.new_label_id from tgt t where l.content_taxonomy_label_id=t.old_label;
insert into app.content_taxonomy_validation_decisions (validation_decision_id,content_taxonomy_label_id,decided_by,decision,decision_source,reviewed_primary_unit,reviewed_required_units,notes)
select vd_id,new_label_id,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,'confirmed','automated_spot_check',pu,req,'Product Owner chat instruction 2026-10-03 (continue: Units 1-3 pipeline, AP Physics 2). Carry-forward of the validated serving label after repair; both blind checkers placed the repaired item in the same unit.' from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.new_label_id;
-- primary topic cells (18 items, stage-1 topic votes >= 5 of 6) on the published versions
create temporary table tc on commit drop as
select v.*, ci.id item_id, civ.id version_id from tcv v join app.content_items ci on ci.content_key=v.content_key and ci.exam_pack_version_id='f584ab0d-114a-4520-9649-42e3e9a2fd22' and ci.status='published'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.status='published';
do $$ begin
 if (select count(*) from tc)<>18 then raise exception 'expected 18 topic targets, got %', (select count(*) from tc);end if;
 if exists (select 1 from tc join app.content_item_cells c on c.content_item_version_id=tc.version_id and c.is_primary and c.superseded_by is null) then raise exception 'a topic target already has a primary cell'; end if;
end $$;
insert into app.content_item_cells (content_item_version_id,content_item_id,taxonomy_source_version,topic_code,skill_code,is_primary,assignment_status,source,model_run_id,validated_by,validated_at,validation_decision_id)
select version_id,item_id,'b3e41b93-95d8-40c6-bef5-98cc99111915'::uuid,topic,null,true,'validated','apphy2_u13_topic_2026_10_03','apphy2-topic-probe-2026-10-03 (gemini-3.8-flash + deepseek-v4-pro + gpt-6.1-sol, 2 samples each; topic agreement >= 5 of 6)',null,now(),gen_random_uuid() from tc;
do $$ declare n int; begin
  select count(*) into n from changed; if n<>18 then raise exception 'expected 18 changed, got %', n; end if;
  select count(*) into n from changed r join app.mcq_choices o on o.content_item_version_id=r.old_version_id join app.mcq_choices w on w.content_item_version_id=r.new_version_id and w.choice_key=o.choice_key where w.is_correct<>o.is_correct; if n<>0 then raise exception 'a key changed'; end if;
  select count(*) into n from app.mcq_choices c join changed r on r.new_version_id=c.content_item_version_id; if n<>72 then raise exception 'choice rows %', n; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>(select count(*) from tgt) then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_versions v join changed r on r.new_version_id=v.id where v.stem ~ E'\\n\\s*A[\\.\\)]\\s' or v.status<>'published'; if n<>0 then raise exception 'a new stem has a list or is not published'; end if;
  select count(*) into n from (select v.content_item_id from app.content_item_versions v where v.status='published' and v.content_item_id in (select item_id from tgt) group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions'; end if;
  select count(*) into n from app.content_item_cells where source='apphy2_u13_topic_2026_10_03' and is_primary and superseded_by is null; if n<>18 then raise exception 'topic cell count %', n; end if;
end $$;
do $$ begin raise exception 'REHEARSAL OK (rolled back): versions_changed=%, labels_written=%, topic_cells=%', (select count(*) from changed), (select count(*) from tgt), (select count(*) from tc); end $$;
rollback;
