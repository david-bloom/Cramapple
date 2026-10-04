begin;
select pg_advisory_xact_lock(hashtext('cramapple-apphycem-u13-seedfix-20261003'));
create temporary table fx_stem (content_key text primary key, old_vid uuid, old_stem_md5 text, new_stem text, strip boolean) on commit drop;
insert into fx_stem values
('apphycem-mcq-001','40d8dda2-58c4-4c30-a2af-6f48693fc0da'::uuid,'ee7a624edc16dd4e24461f463e35f8a5','Gauss''s law states the electric flux through a closed surface is',true),
('apphycem-mcq-005','f776acc1-c315-4d81-84d0-053e20ada34e'::uuid,'5f4b247c6f4236fb220ea6799b0a776d','For electrostatics in one dimension, the x-component of the electric field is related to the electric potential V(x) by',false),
('apphycem-mcq-006','b27d1b43-4dd0-49bd-a0d8-8a4768cfdef0'::uuid,'f8bb904d72c5fbdbfdfc08d6974631ca','At a point on the x-axis where the electric potential V(x) has a stationary point (dV/dx = 0), which statement must be true?',false),
('apphycem-mcq-007','683d2a99-cc8b-455a-8c57-6a0414f3341c'::uuid,'6a852cee287877c7eb4445de93a01708','Capacitance of parallel plates neglecting edges is',false),
('apphycem-mcq-008','d08e0b09-0ff5-4195-9516-c99e5ba9c0fd'::uuid,'bd7785a41c62ecea61effb8ddba98456','Energy stored in a capacitor is',true),
('apphycem-mcq-009','c2521186-1279-4703-9b51-6a583a3fd95f'::uuid,'dd13c7b8a7a80a1bd950ab912cb18c73','In electrostatic equilibrium, within the conducting material of a conductor, E is',true),
('apphycem-mcq-021','323e62f1-a874-4a4b-8ac5-0a961436e554'::uuid,'e515bdb87837ed1c68411714b449e991','Two point charges remain fixed while their separation triples. The force magnitude becomes',true),
('apphycem-mcq-022','fd38da62-4043-41ce-9a6a-3587b37d3f47'::uuid,'c0a6afd3f853447acbd1762b7fc6a27f','The electric field due to an isolated negative point charge points',true),
('apphycem-mcq-023','e0817ceb-7257-4284-8976-72615341b827'::uuid,'b34f9af25923edd772525fb95013df85','For a line charge λ(s), the differential charge element is',true),
('apphycem-mcq-024','12c4d0cc-aaa6-48be-a9e4-3e619b10804a'::uuid,'0ea2bc0c2b0bef3cdc31f830c5d2317b','Uniform E crosses flat area A whose normal makes angle θ with E. Electric flux is',true),
('apphycem-mcq-025','edc2da0d-97ad-464f-85be-cc218b51a578'::uuid,'7f09c16ea88e674da2bfa7e4b7594d40','Charges outside a closed Gaussian surface contribute to',true),
('apphycem-mcq-026','9973664a-5a58-4def-9e92-05517ac0af8f'::uuid,'3ee94cd22d8351c0575363d8419de68d','Two positive point charges are brought closer together. Their electric potential energy',true),
('apphycem-mcq-027','e430dc7b-f183-4750-81b1-f76017511120'::uuid,'33903329954ee12dc6099787a1317193','With V(∞)=0, point-charge potential is',false),
('apphycem-mcq-028','41f074ee-841c-47fc-a263-a8ccc023aa2b'::uuid,'d9833179aa33905efb66b64c3a8fb3f8','A positive charge is released from rest and acted on only by a static electric field. It tends toward',true),
('apphycem-mcq-029','b4febe3d-44f9-4a5c-96e4-02c8075526e0'::uuid,'6a2aae2f000292b837e2d6d96bf74bdc','In electrostatic equilibrium, the electric field just outside a conductor is',true),
('apphycem-mcq-030','2c73534a-508b-4c62-b215-af4faa83467f'::uuid,'baec69cef4f08aefc98694242b3c0aad','A dielectric with κ>1 fully fills a capacitor that remains connected to an ideal battery. Stored energy',false),
('apphycem-mcq-np1-001','1d1dda5d-5f15-42fa-a61d-e1f26cccbf6f'::uuid,'9934450436a8d800642d66e7e5d89a9f','An infinitely long, uniformly charged wire has linear charge density lambda > 0. Using Gauss''s law with a cylindrical Gaussian surface of length L, which expression correctly gives the electric field magnitude at a perpendicular distance r from the wire?',false),
('apphycem-mcq-np1-006','b8f1500b-8378-4e9f-9eef-bd5228e719cb'::uuid,'a1b99a3966eac0bd369c42a30fb0e1da','A solid insulating sphere of radius R has uniform volume charge density rho. What is the electric field magnitude at a distance r = R/2 from the center (inside the sphere)?',false),
('apphycem-mcq-np1-010','6d3b2e63-94b2-4e3f-8e3e-4b26f36a9574'::uuid,'b302af21303831bd33a15974511f2843','A point charge +Q sits at the exact center of a cubical Gaussian surface. What is the electric flux through one face of the cube?',false);
create temporary table fx_ch (content_key text, choice_key text, new_text text, new_rat text) on commit drop;
insert into fx_ch values
('apphycem-mcq-005','A','E_x = dV/dx','This drops the negative sign: the field points toward decreasing potential, so E_x = -dV/dx.'),
('apphycem-mcq-005','B','E_x = -dV/dx','The field component is the negative derivative of the potential with respect to position.'),
('apphycem-mcq-005','C','E_x = -V/x','This treats the field as the ratio of V to position, which would equal -dV/dx only if V were linear in x and zero at x = 0; in general the field is the derivative of V, not a ratio.'),
('apphycem-mcq-005','D','E_x = ∫V dt','This substitutes a time integral for the spatial gradient, conflating a static field relation with time dependence.'),
('apphycem-mcq-006','A','The field component E_x is zero there.','Since E_x = -dV/dx, a stationary point of V, where dV/dx = 0, has E_x = 0.'),
('apphycem-mcq-006','B','The potential V must equal zero there.','This confuses a vanishing slope of V with the value of V itself being zero; V can have any value at a maximum or minimum.'),
('apphycem-mcq-006','C','An infinite charge must be located there.','A stationary point requires only that the slope of V vanish, not an infinite charge source.'),
('apphycem-mcq-006','D','The field component E_x must be nonzero there.','This reverses the relation E_x = -dV/dx: a zero slope of V gives a zero field component, not a nonzero one.'),
('apphycem-mcq-007','C','Ad/ε','This puts ε in the denominator and both A and d in the numerator; capacitance increases with plate area and decreases with plate separation, so A and d cannot both appear in the numerator.'),
('apphycem-mcq-027','B','kq/r²','This has the 1/r² dependence of the point-charge field magnitude k|q|/r², not the 1/r dependence of the potential.'),
('apphycem-mcq-030','D','increases by κ²','With the voltage held fixed by the battery, U = (1/2)CV² changes only through C, which increases by κ, so the stored energy increases by κ; the charge on the plates also increases by κ, but that is already reflected in the factor κ and does not produce an additional κ².'),
('apphycem-mcq-np1-001','B','lambda/(4*pi*epsilon_0*r^2)','This uses the 1/r² dependence of a spherically symmetric (point-charge) field, which does not apply to a long cylindrical charge distribution, whose field falls off as 1/r.'),
('apphycem-mcq-np1-001','C','lambda*L/(2*pi*epsilon_0*r)','This leaves the length L in the answer; the enclosed charge λL and the lateral area 2πrL both contain L, so it cancels and the field cannot depend on the arbitrary length of the Gaussian cylinder.'),
('apphycem-mcq-np1-001','D','lambda/(pi*epsilon_0*r^2)','This has the wrong r-dependence (1/r² instead of 1/r) and the wrong numerical factor; the lateral area of the cylinder is 2πrL, giving E = λ/(2πε₀r).'),
('apphycem-mcq-np1-006','C','rho*R/(12*epsilon_0)','This is half the correct value, as if the factor of 1/2 from r = R/2 were applied a second time to ρr/(3ε₀).'),
('apphycem-mcq-np1-006','D','rho*R/(2*epsilon_0)','This omits the factor of 1/3: Gauss''s law gives E(4πr²) = ρ(4/3)πr³/ε₀, so E = ρr/(3ε₀), not ρr/ε₀; the incorrect form ρr/ε₀ evaluates to ρR/(2ε₀) at r = R/2.'),
('apphycem-mcq-np1-010','C','Q/(4*pi*epsilon_0)','This is the flux through a portion of the surface that subtends one steradian (the total flux divided by 4π), not the flux through one face of the cube; a cube face subtends 4π/6 steradians as seen from the center.');
create temporary table tcv (content_key text primary key, topic text) on commit drop;
insert into tcv values ('apphycem-mcq-001','8.6'),('apphycem-mcq-002','8.6'),('apphycem-mcq-005','9.2'),('apphycem-mcq-006','9.2'),('apphycem-mcq-007','10.3'),('apphycem-mcq-008','10.3'),('apphycem-mcq-009','10.1'),('apphycem-mcq-021','8.1'),('apphycem-mcq-022','8.3'),('apphycem-mcq-023','8.4'),('apphycem-mcq-024','8.5'),('apphycem-mcq-025','8.6'),('apphycem-mcq-026','9.1'),('apphycem-mcq-027','9.2'),('apphycem-mcq-029','10.1'),('apphycem-mcq-030','10.4'),('apphycem-mcq-np1-001','8.6'),('apphycem-mcq-np1-002','8.6'),('apphycem-mcq-np1-003','9.2'),('apphycem-mcq-np1-004','9.2'),('apphycem-mcq-np1-006','8.6'),('apphycem-mcq-np1-009','10.1'),('apphycem-mcq-np1-010','8.6');
create temporary table mod on commit drop as
select ci.content_key, ci.id item_id, civ.id old_vid, f.strip, f.new_stem, civ.stem old_stem from app.content_items ci join app.content_item_versions civ on civ.content_item_id=ci.id and civ.status='published'
join fx_stem f on f.content_key=ci.content_key and f.old_vid=civ.id and f.old_stem_md5=md5(civ.stem)
where ci.exam_pack_version_id='841a88cc-773c-44e5-97fa-6504f8667689' and ci.item_type='mcq' and ci.status='published';
create temporary table lab0 on commit drop as
select m.content_key, l.content_taxonomy_label_id old_label, l.label_version old_ver, l.label_status old_status, l.taxonomy_source_version tsv, l.required_units req, l.primary_unit pu, l.assessed_topics
from mod m join app.content_taxonomy_labels l on l.content_item_id=m.item_id and l.label_scope='serving' and l.superseded_by is null;
do $$ begin
 if (select count(*) from mod)<>19 then raise exception 'expected 19 items to change (version id/stem md5 guard), got %',(select count(*) from mod); end if;
 if (select count(*) from mod where strip)<>11 then raise exception 'expected 11 strip-only items'; end if;
 if exists (select 1 from mod where strip and rtrim(regexp_replace(old_stem, E'\\n\\s*A[\\.\\)]\\s[\\s\\S]*$', ''))<>new_stem) then raise exception 'a strip-only stem differs from the old stem minus its A-D list'; end if;
 if (select count(*) from lab0)<>19 or exists (select 1 from lab0 where old_status<>'validated') then raise exception 'a target lacks exactly one current validated serving label'; end if;
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
      coalesce(v_old.prompt_json,'{}'::jsonb) || jsonb_build_object('content_version',v_old.version_num+1,'qa_remediation','2026-10-03 AP Physics C: Electricity and Magnetism Units 8-10 (course Units 1-3) audit: rationale/distractor/stem defects repaired and duplicated A-D list removed from the stem; keys unchanged','qa_source_version_id',v_old.id),
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
  'Owner-approved repair 2026-10-03 (AP Physics C: Electricity and Magnetism Units 8-10 (course Units 1-3) audit): rationale, distractor and stem defects corrected (two-checker re-audit clean) and the duplicated A-D list removed from the stem; keys unchanged. ' || r.content_key,'approve',
  jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','seed_audit_rationale_and_stem_repair','content_key',r.content_key,'qa_date','2026-10-03'),
  md5(r.new_version_id::text||'f5a26c6b-3566-4d58-9e97-979fbb947564'||'apphycem-u13-seedfix-20261003'),'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from changed r join app.content_review_assignments cra on cra.content_item_version_id=r.new_version_id and cra.assignment_purpose='owner_remediation_approval' and cra.status='pending';
update app.content_item_versions civ set status='reviewed_approved', review_status='question_review_approved', approved_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, approved_at=coalesce(civ.approved_at,now()), updated_at=now() from changed r where civ.id=r.new_version_id;
update app.content_items ci set status='reviewed_approved', updated_at=now() from changed r join app.content_item_versions civ on civ.id=r.new_version_id where ci.id=civ.content_item_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from changed r where civ.id=r.new_version_id;
update app.content_items ci set status='published', updated_at=now() from changed r join app.content_item_versions civ on civ.id=r.new_version_id where ci.id=civ.content_item_id;
-- carry the validated serving label forward to the new versions
create temporary table tgt on commit drop as
select r.content_key, civ.content_item_id item_id, r.new_version_id version_id, o.old_label, o.old_ver, o.old_status, o.tsv, o.req, o.pu, o.assessed_topics, gen_random_uuid() new_label_id, gen_random_uuid() vd_id
from changed r join app.content_item_versions civ on civ.id=r.new_version_id join lab0 o on o.content_key=r.content_key;
do $$ begin if (select count(*) from tgt)<>19 then raise exception 'label target mismatch: %', (select count(*) from tgt); end if; end $$;
insert into app.content_taxonomy_labels (content_taxonomy_label_id,content_item_id,label_version,label_scope,required_units,max_required_unit,primary_unit,assessed_topics,taxonomy_source_version,taxonomy_confidence,label_status,source,source_payload,model_run_id,created_by)
select new_label_id,item_id,old_ver+1,'serving',req,(select max(u) from unnest(req) u),pu,coalesce(assessed_topics,array[]::text[]),tsv,'provisional','provisional_model','apphycem_u13_pipeline_2026_10_03',
 jsonb_build_object('origin','carry_forward','note','unit and required units carried forward from the current validated label after a rationale/stem repair','supersedes_status',old_status),'apphycem-u13-pipeline-2026-10-03','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
update app.content_taxonomy_labels l set superseded_by=t.new_label_id from tgt t where l.content_taxonomy_label_id=t.old_label;
insert into app.content_taxonomy_validation_decisions (validation_decision_id,content_taxonomy_label_id,decided_by,decision,decision_source,reviewed_primary_unit,reviewed_required_units,notes)
select vd_id,new_label_id,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,'confirmed','automated_spot_check',pu,req,'Product Owner chat instruction 2026-10-03 (continue: Units 1-3 pipeline, AP Physics C: Electricity and Magnetism). Carry-forward of the validated serving label after repair; both blind checkers placed the repaired item in the same unit.' from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.new_label_id;
-- primary topic cells (23 items, stage-1 topic votes >= 5 of 6) on the published versions
create temporary table tc on commit drop as
select v.*, ci.id item_id, civ.id version_id from tcv v join app.content_items ci on ci.content_key=v.content_key and ci.exam_pack_version_id='841a88cc-773c-44e5-97fa-6504f8667689' and ci.status='published'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.status='published';
do $$ begin
 if (select count(*) from tc)<>23 then raise exception 'expected 23 topic targets, got %', (select count(*) from tc);end if;
 if exists (select 1 from tc join app.content_item_cells c on c.content_item_version_id=tc.version_id and c.is_primary and c.superseded_by is null) then raise exception 'a topic target already has a primary cell'; end if;
end $$;
insert into app.content_item_cells (content_item_version_id,content_item_id,taxonomy_source_version,topic_code,skill_code,is_primary,assignment_status,source,model_run_id,validated_by,validated_at,validation_decision_id)
select version_id,item_id,'ef9618c9-de85-4941-8837-4dce4c755e62'::uuid,topic,null,true,'validated','apphycem_u13_topic_2026_10_03','apphycem-topic-probe-2026-10-03 (gemini-3.8-flash + deepseek-v4-pro + gpt-6.1-sol, 2 samples each; topic agreement >= 5 of 6)',null,now(),gen_random_uuid() from tc;
do $$ declare n int; begin
  select count(*) into n from changed; if n<>19 then raise exception 'expected 19 changed, got %', n; end if;
  select count(*) into n from changed r join app.mcq_choices o on o.content_item_version_id=r.old_version_id join app.mcq_choices w on w.content_item_version_id=r.new_version_id and w.choice_key=o.choice_key where w.is_correct<>o.is_correct; if n<>0 then raise exception 'a key changed'; end if;
  select count(*) into n from app.mcq_choices c join changed r on r.new_version_id=c.content_item_version_id; if n<>76 then raise exception 'choice rows %', n; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>(select count(*) from tgt) then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_versions v join changed r on r.new_version_id=v.id where v.stem ~ E'\\n\\s*A[\\.\\)]\\s' or v.status<>'published'; if n<>0 then raise exception 'a new stem has a list or is not published'; end if;
  select count(*) into n from (select v.content_item_id from app.content_item_versions v where v.status='published' and v.content_item_id in (select item_id from tgt) group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions'; end if;
  select count(*) into n from app.content_item_cells where source='apphycem_u13_topic_2026_10_03' and is_primary and superseded_by is null; if n<>23 then raise exception 'topic cell count %', n; end if;
end $$;
do $$ begin raise exception 'REHEARSAL OK (rolled back): versions_changed=%, labels_written=%, topic_cells=%', (select count(*) from changed), (select count(*) from tgt), (select count(*) from tc); end $$;
rollback;
