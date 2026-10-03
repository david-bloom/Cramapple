begin;
select pg_advisory_xact_lock(hashtext('cramapple-apchem-u13-repair2-20261002'));
create temporary table edits (content_key text, old_text text, new_text text, new_rationale text) on commit drop;
insert into edits values
('apchem-mcq-027','−2','−2','Incorrect. This comes from counting both electrons of the single bond instead of half: FC = 6 − (6 nonbonding + 2 bonding) = −2.'),
('apchem-mcq-027','+1','+1','Incorrect. This comes from counting only two lone pairs (4 nonbonding electrons) on the singly bonded oxygen: FC = 6 − (4 + 1) = +1.'),
('apchem-mcq-025','Cs–F','Cs–F','Correct. Cs (0.79) and F (3.98) differ by 3.19, the largest difference among the pairs (C–H 0.35, O–F 0.54, N–O 0.40), so Cs–F has the greatest ionic character: Cs gives up its valence electron to F, forming Cs⁺ and F⁻.');
create temporary table targets (content_key text primary key) on commit drop;
insert into targets select distinct content_key from edits;
create temporary table repaired (content_key text primary key, old_version_id uuid not null, new_version_id uuid not null) on commit drop;
do $$
declare t record; e record; v_item app.content_items%rowtype; v_old app.content_item_versions%rowtype; v_new uuid; v_hits int;
begin
  for t in select * from targets order by content_key loop
    select * into strict v_item from app.content_items where content_key=t.content_key and item_type='mcq' for update;
    select * into strict v_old from app.content_item_versions where content_item_id=v_item.id and status='published' order by version_num desc limit 1 for update;
    v_new := gen_random_uuid();
    update app.content_review_assignments set status='skipped' where content_item_version_id=v_old.id and assignment_purpose='subject_review' and status in ('pending','in_progress');
    update app.content_item_versions set status='retired', updated_at=now() where id=v_old.id;
    update app.content_items set status='draft', updated_at=now() where id=v_item.id;
    insert into app.content_item_versions (id,content_item_id,version_num,stem,stimulus,prompt_json,explanation,help_text,content_hash,status,created_by,canonical_answer_1,canonical_answer_2,review_status,rubric_type,evaluator_strategy,stimulus_image_path)
    values (v_new,v_item.id,v_old.version_num+1,v_old.stem,v_old.stimulus,
      coalesce(v_old.prompt_json,'{}'::jsonb) || jsonb_build_object('content_version',v_old.version_num+1,'qa_remediation','2026-10-02 Chemistry Units 1-3 audit repair, round 2 (APPROVAL-0074)','qa_source_version_id',v_old.id),
      v_old.explanation,v_old.help_text,md5(coalesce(v_old.stem,'')),'draft','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,v_old.canonical_answer_1,v_old.canonical_answer_2,null,v_old.rubric_type,v_old.evaluator_strategy,v_old.stimulus_image_path);
    insert into app.mcq_choices (content_item_version_id,choice_key,choice_text,is_correct,rationale) select v_new,choice_key,choice_text,is_correct,rationale from app.mcq_choices where content_item_version_id=v_old.id;
    for e in select * from edits where content_key=t.content_key loop
      update app.mcq_choices set choice_text=e.new_text, rationale=e.new_rationale where content_item_version_id=v_new and choice_text=e.old_text;
      get diagnostics v_hits = row_count;
      if v_hits<>1 then raise exception 'edit for % (%) matched % choices, expected 1', t.content_key, e.old_text, v_hits; end if;
    end loop;
    insert into app.content_item_cells (content_item_version_id,content_item_id,taxonomy_source_version,topic_code,skill_code,is_primary,assignment_status,source,model_run_id,validated_by,validated_at,validation_decision_id)
      select v_new,content_item_id,taxonomy_source_version,topic_code,skill_code,is_primary,assignment_status,source,model_run_id,validated_by,validated_at,validation_decision_id from app.content_item_cells where content_item_version_id=v_old.id and superseded_by is null;
    insert into app.content_item_difficulty (content_item_version_id,difficulty,basis,attainment_ratio,ratio_source,subject_cut_points,source_value,rationale,confidence,proposal_run,created_by)
      select v_new,difficulty,basis,attainment_ratio,ratio_source,subject_cut_points,source_value,rationale,confidence,proposal_run,created_by from app.content_item_difficulty where content_item_version_id=v_old.id;
    insert into repaired values (t.content_key,v_old.id,v_new);
  end loop;
end $$;
update app.content_item_versions civ set content_hash = md5(coalesce(civ.stem,'')||E'\n'||coalesce(civ.stimulus,'')||E'\n'||coalesce((select string_agg(m.choice_key||':'||m.choice_text||':'||m.is_correct::text||':'||coalesce(m.rationale,''), E'\n' order by m.choice_key) from app.mcq_choices m where m.content_item_version_id=civ.id),''))
from repaired r where civ.id=r.new_version_id;
insert into app.content_review_assignments (content_review_assignment_id,content_item_version_id,reviewer_id,review_stage,review_kind,status,assignment_purpose,created_by)
select gen_random_uuid(),new_version_id,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,'tutor_question','mcq','pending','owner_remediation_approval','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from repaired;
insert into app.content_review_decisions (content_review_assignment_id,content_item_version_id,reviewer_id,review_stage,tutor_score,difficulty_label,diagnostic_flag,concern_codes,note,tutor_decision,decision_payload,decision_hash,created_by)
select cra.content_review_assignment_id,r.new_version_id,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,'tutor_question',1,'Medium',false,array[]::text[],
  'Owner-approved repair 2026-10-02 round 2 (Chemistry Units 1-3 audit, found while authoring variants): distractor/correct rationales rewritten, keys unchanged. ' || r.content_key,'approve',
  jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','seed_audit_rationale_repair','content_key',r.content_key,'qa_date','2026-10-02'),
  md5(r.new_version_id::text||'f5a26c6b-3566-4d58-9e97-979fbb947564'||'apchem-u13-audit2-20261002'),'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from repaired r join app.content_review_assignments cra on cra.content_item_version_id=r.new_version_id and cra.assignment_purpose='owner_remediation_approval' and cra.status='pending';
update app.content_item_versions civ set status='reviewed_approved', review_status='question_review_approved', approved_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, approved_at=coalesce(civ.approved_at,now()), updated_at=now() from repaired r where civ.id=r.new_version_id;
update app.content_items ci set status='reviewed_approved', updated_at=now() from repaired r join app.content_item_versions civ on civ.id=r.new_version_id where ci.id=civ.content_item_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from repaired r where civ.id=r.new_version_id;
update app.content_items ci set status='published', updated_at=now() from repaired r join app.content_item_versions civ on civ.id=r.new_version_id where ci.id=civ.content_item_id;
-- the repair makes each serving label stale: write a fresh validated version (same unit and topic as the step-4 consensus)
create temporary table lab (content_key text primary key, primary_unit int, req int[], topic text) on commit drop;
insert into lab values ('apchem-mcq-025',2,'{2}'::int[],'2.1'),('apchem-mcq-027',2,'{2}'::int[],'2.6');
create temporary table tgt on commit drop as
select l.*, ci.id item_id, r.new_version_id version_id, (select max(x.label_version) from app.content_taxonomy_labels x where x.content_item_id=ci.id and x.label_scope='serving') old_ver,
  (select (array_agg(x.taxonomy_source_version order by x.label_version desc))[1] from app.content_taxonomy_labels x where x.content_item_id=ci.id and x.label_scope='serving') tsv, gen_random_uuid() new_label_id, gen_random_uuid() vd_id
from lab l join app.content_items ci on ci.content_key=l.content_key join repaired r on r.content_key=l.content_key;
insert into app.content_taxonomy_labels (content_taxonomy_label_id, content_item_id, label_version, label_scope, required_units, max_required_unit, primary_unit, assessed_topics, taxonomy_source_version, taxonomy_confidence, label_status, source, source_payload, model_run_id, created_by)
select new_label_id, item_id, old_ver+1, 'serving', req, 2, primary_unit, array[]::text[], tsv, 'provisional', 'provisional_model', 'apchem_u13_pipeline_2026_10_02', jsonb_build_object('origin','relabel after round-2 repair','consensus_topic',topic), 'apchem-u13-pipeline-2026-10-02','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
update app.content_taxonomy_labels l set superseded_by=t.new_label_id from tgt t where l.content_item_id=t.item_id and l.label_scope='serving' and l.superseded_by is null and l.content_taxonomy_label_id<>t.new_label_id;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, new_label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'automated_spot_check', primary_unit, req, 'APPROVAL-0074 round 2: relabel after rationale repair; unit and topic unchanged from the step-4 three-family consensus.' from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.new_label_id;
do $$ declare n int; begin
  select count(*) into n from repaired; if n<>2 then raise exception 'expected 2 repaired, got %', n; end if;
  select count(*) into n from repaired r join app.content_item_versions civ on civ.id=r.new_version_id where (select count(*) from app.mcq_choices m where m.content_item_version_id=civ.id and m.is_correct)<>1 or (civ.canonical_answer_1 is not null and civ.canonical_answer_1 is distinct from (select m.choice_key from app.mcq_choices m where m.content_item_version_id=civ.id and m.is_correct));
  if n<>0 then raise exception 'key mismatch'; end if;
  select count(*) into n from repaired r join app.mcq_choices o on o.content_item_version_id=r.old_version_id join app.mcq_choices w on w.content_item_version_id=r.new_version_id and w.choice_key=o.choice_key where w.is_correct<>o.is_correct; if n<>0 then raise exception 'is_correct changed'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>2 then raise exception 'label post-check %', n; end if;
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions'; end if;
end $$;
select 'repaired' m, count(*)::text v from repaired;
