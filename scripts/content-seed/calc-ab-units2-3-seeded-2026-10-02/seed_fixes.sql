-- APPROVAL-0071 (Product Owner chat instruction 2026-10-02: "fix them"). Two fixes on live AP Calc AB seeds.
-- (1) apcalcab-mcq-026 choice C: "e^2" has no derivation (no error pattern produces it), so the distractor is replaced by the value a real
--     error gives: differentiating only the x^2 factor, 2x e^x = 2e at x=1. Key B (3e) and is_correct flags unchanged. New version, never in place;
--     the stem's embedded option line is resynced. The item's validated serving label is carried forward (re-pointed at the new version, original
--     validation record restored), as in APPROVAL-0066.
-- (2) apcalcab-mcq-028 serving label: Production said required units [2,5] (max 5); all three blind models (6 of 6 samples, on the seed and its three
--     variants) say [1,2] and Unit 5 is not needed to answer "differentiable implies continuous". New label version [1,2], primary unit 2, topic 2.4 unchanged.
begin;
select pg_advisory_xact_lock(hashtext('cramapple-apcalcab-seed-fixes-20261002'));
create temporary table prior on commit drop as
select ci.id item_id, l.content_taxonomy_label_id label_id, l.label_status, l.validated_by vby, l.validated_at vat, l.validation_decision_id vdec
from app.content_items ci join app.content_taxonomy_labels l on l.content_item_id=ci.id and l.label_scope='serving' and l.superseded_by is null
where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key='apcalcab-mcq-026';
do $$ begin if (select count(*) from prior)<>1 or (select label_status from prior)<>'validated' or (select vby from prior) is null then raise exception 'unexpected prior label state for 026'; end if; end $$;
do $$
declare v_item app.content_items%rowtype; v_old app.content_item_versions%rowtype; v_new uuid := gen_random_uuid(); n int; v_assign uuid := gen_random_uuid();
begin
  select * into strict v_item from app.content_items where content_key='apcalcab-mcq-026' and exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and item_type='mcq' for update;
  select * into strict v_old from app.content_item_versions where content_item_id=v_item.id and status='published' order by version_num desc limit 1 for update;
  update app.content_review_assignments set status='skipped' where content_item_version_id=v_old.id and assignment_purpose='subject_review' and status in ('pending','in_progress');
  update app.content_item_versions set status='retired', updated_at=now() where id=v_old.id;
  update app.content_items set status='draft', updated_at=now() where id=v_item.id;
  insert into app.content_item_versions (id,content_item_id,version_num,stem,stimulus,prompt_json,explanation,help_text,content_hash,status,created_by,canonical_answer_1,canonical_answer_2,review_status,rubric_type,evaluator_strategy,stimulus_image_path)
  values (v_new,v_item.id,v_old.version_num+1,v_old.stem,v_old.stimulus,
    coalesce(v_old.prompt_json,'{}'::jsonb) || jsonb_build_object('content_version',v_old.version_num+1,'qa_remediation','2026-10-02 026 choice C distractor repair (APPROVAL-0071)','qa_source_version_id',v_old.id),
    v_old.explanation,v_old.help_text,md5(coalesce(v_old.stem,'')),'draft','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,v_old.canonical_answer_1,v_old.canonical_answer_2,null,v_old.rubric_type,v_old.evaluator_strategy,v_old.stimulus_image_path);
  insert into app.mcq_choices (content_item_version_id,choice_key,choice_text,is_correct,rationale) select v_new,choice_key,choice_text,is_correct,rationale from app.mcq_choices where content_item_version_id=v_old.id;
  update app.mcq_choices set choice_text='2e', rationale='Differentiates only the x² factor, giving 2x·e^x, which equals 2e at x=1, and leaves out x²·e^x.' where content_item_version_id=v_new and choice_text='e²';
  get diagnostics n = row_count; if n<>1 then raise exception 'choice C edit matched %', n; end if;
  update app.content_item_versions set stem=app.mcq_stem_choice_resync(v_new, v_old.stem) where id=v_new;
  insert into app.content_item_cells (content_item_version_id,content_item_id,taxonomy_source_version,topic_code,skill_code,is_primary,assignment_status,source,model_run_id,validated_by,validated_at,validation_decision_id)
    select v_new,content_item_id,taxonomy_source_version,topic_code,skill_code,is_primary,assignment_status,source,model_run_id,validated_by,validated_at,validation_decision_id from app.content_item_cells where content_item_version_id=v_old.id and superseded_by is null;
  insert into app.content_item_difficulty (content_item_version_id,difficulty,basis,attainment_ratio,ratio_source,subject_cut_points,source_value,rationale,confidence,proposal_run,created_by)
    select v_new,difficulty,basis,attainment_ratio,ratio_source,subject_cut_points,source_value,rationale,confidence,proposal_run,created_by from app.content_item_difficulty where content_item_version_id=v_old.id;
  update app.content_item_versions civ set content_hash = md5(coalesce(civ.stem,'')||E'\n'||coalesce(civ.stimulus,'')||E'\n'||coalesce((select string_agg(m.choice_key||':'||m.choice_text||':'||m.is_correct::text||':'||coalesce(m.rationale,''), E'\n' order by m.choice_key) from app.mcq_choices m where m.content_item_version_id=civ.id),'')) where civ.id=v_new;
  insert into app.content_review_assignments (content_review_assignment_id,content_item_version_id,reviewer_id,review_stage,review_kind,status,assignment_purpose,created_by)
    values (v_assign,v_new,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,'tutor_question','mcq','pending','owner_remediation_approval','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid);
  insert into app.content_review_decisions (content_review_assignment_id,content_item_version_id,reviewer_id,review_stage,tutor_score,difficulty_label,diagnostic_flag,concern_codes,note,tutor_decision,decision_payload,decision_hash,created_by)
    values (v_assign,v_new,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,'tutor_question',1,'Medium',false,array[]::text[],
     'Owner-approved repair 2026-10-02 (APPROVAL-0071): choice C e^2 had no derivation; replaced by 2e (differentiates only x^2). Key unchanged.','approve',
     jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','seed_audit_rationale_repair','content_key','apcalcab-mcq-026','qa_date','2026-10-02'),
     md5(v_new::text||'f5a26c6b-3566-4d58-9e97-979fbb947564'||'apcalcab-seed-fixes-20261002'),'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid);
  update app.content_item_versions set status='reviewed_approved', review_status='question_review_approved', approved_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, approved_at=coalesce(approved_at,now()), updated_at=now() where id=v_new;
  update app.content_items set status='reviewed_approved', updated_at=now() where id=v_item.id;
  update app.content_item_versions set status='published', published_at=coalesce(published_at,now()), updated_at=now() where id=v_new;
  update app.content_items set status='published', updated_at=now() where id=v_item.id;
  -- carry the validated label forward (the repair's stale-marking trigger nulled validated_by/at/decision): restore the original record and re-point
  update app.content_taxonomy_labels l set label_status='validated', validated_by=p.vby, validated_at=p.vat, validation_decision_id=p.vdec,
    validated_against_version_id=v_new, validated_against_taxo_hash=app.taxonomy_relevant_hash(v_new),
    source_payload = l.source_payload || jsonb_build_object('carried_forward', jsonb_build_object('from_version_id', v_old.id, 'to_version_id', v_new, 'reason','026 choice C distractor repair; unit and topic unchanged','approval_ref','APPROVAL-0071'))
  from prior p where l.content_taxonomy_label_id=p.label_id;
  -- assertions
  if (select count(*) from app.mcq_choices where content_item_version_id=v_new and is_correct)<>1 or (select canonical_answer_1 from app.content_item_versions where id=v_new) is distinct from (select choice_key from app.mcq_choices where content_item_version_id=v_new and is_correct) then raise exception '026 key/letter mismatch'; end if;
  if exists (select 1 from app.mcq_choices o join app.mcq_choices w on w.content_item_version_id=v_new and w.choice_key=o.choice_key where o.content_item_version_id=v_old.id and w.is_correct<>o.is_correct) then raise exception '026 is_correct changed'; end if;
  if array_length(app.mcq_stem_choice_desync(v_new,(select stem from app.content_item_versions where id=v_new)),1) > 0 then raise exception '026 stem desync'; end if;
  if (select count(*) from app.content_item_versions where content_item_id=v_item.id and status='published')<>1 then raise exception '026 published version count'; end if;
  if (select count(*) from app.content_taxonomy_labels l where l.content_item_id=v_item.id and l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(v_new))<>1 then raise exception '026 label not validated and hash-fresh'; end if;
end $$;
-- (2) 028 label: new version [1,2]
create temporary table t28 on commit drop as
select ci.id item_id, civ.id version_id, l.content_taxonomy_label_id old_label_id, l.label_version old_ver, l.label_status old_status, l.required_units old_req, gen_random_uuid() new_label_id, gen_random_uuid() vd_id
from app.content_items ci join app.content_item_versions civ on civ.content_item_id=ci.id and civ.status='published'
join app.content_taxonomy_labels l on l.content_item_id=ci.id and l.label_scope='serving' and l.superseded_by is null
where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key='apcalcab-mcq-028';
do $$ begin if (select count(*) from t28)<>1 or (select old_req from t28)<>array[2,5] then raise exception 'unexpected 028 state'; end if; end $$;
insert into app.content_taxonomy_labels (content_taxonomy_label_id, content_item_id, label_version, label_scope, required_units, max_required_unit, primary_unit, assessed_topics, taxonomy_source_version, taxonomy_confidence, label_status, source, source_payload, model_run_id, created_by)
select new_label_id, item_id, old_ver+1, 'serving', array[1,2], 2, 2, array[]::text[], '33b4408b-0ecc-4c7a-b0b1-612db81164a1'::uuid, 'provisional', 'provisional_model', 'apcalcab_seed_fixes_2026_10_02',
 jsonb_build_object('origin','three_model_blind_probe_plus_po_instruction','was','required_units [2,5], provisional_model','models','gemini-3.8-flash, deepseek-v4-pro, gpt-6.1-sol','support','6/6 samples [1,2] on the seed; same on all three variants','report','scripts/content-seed/calc-ab-units2-3-seeded-2026-10-02/PILOT_REPORT.md'),
 'apcalcab-seed-fixes-2026-10-02','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from t28;
update app.content_taxonomy_labels l set superseded_by=t.new_label_id from t28 t where l.content_taxonomy_label_id=t.old_label_id;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, new_label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'automated_spot_check', 2, array[1,2],
 'Product Owner chat instruction 2026-10-02 (APPROVAL-0071): fix the 028 unit set. 3-model blind probe, 6 of 6 samples [1,2]; the S0a audit found the item correct. Unit 5 is not required.' from t28;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id,
 validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from t28 t where l.content_taxonomy_label_id=t.new_label_id;
do $$ begin
  if (select count(*) from app.content_taxonomy_labels l join t28 t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.required_units=array[1,2] and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id))<>1 then raise exception '028 label post-check'; end if;
end $$;
select 'ok' r, (select choice_text from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items i on i.id=v.content_item_id where i.content_key='apcalcab-mcq-026' and i.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and v.status='published' and m.choice_key='C') c_text;
