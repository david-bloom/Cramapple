-- AP Biology: APBIO-MCQ-023 choice A rationale repair (one choice, one item), 2026-10-01.
-- Evidence: scripts/content-seed/apbio-seeded-pilot-2026-09-30/S0A_AUDIT_REPORT.md. Both checkers (Gemini 3.5 Flash, DeepSeek V4 Pro) flagged choice A's rationale; verified by hand:
-- the old text said "not being labeled by impermeant biotin does not distinguish extracellular vs. cytoplasmic facing for a transmembrane protein", which is false
-- (impermeant biotin labels extracellular-facing domains). The key (D) is correct and unchanged; only choice A's rationale text changes.
-- Pattern: owner_remediation_approval (new version, never in place), as in 20260930_apcalcab_037_key_and_distractor_rationale_repair.sql. The item's labels (a validated
-- serving label and a provisional coverage label) are captured IN THIS TRANSACTION before the version change and restored, re-pointed, after it, with the approval
-- reference recorded in each label's source_payload. Approval: APPROVAL-0067 (Product Owner, 2026-10-01).

begin;
select pg_advisory_xact_lock(hashtext('cramapple-apbio-023-rationale-repair-20261001'));

create temporary table approval (ref text) on commit drop;
insert into approval values ('APPROVAL-0067');
do $$ begin if (select ref from approval) = 'PENDING' then raise exception 'not approved'; end if; end $$;

create temporary table repaired (content_key text primary key, old_version_id uuid not null, new_version_id uuid not null) on commit drop;
create temporary table prior_labels on commit drop as
  select l.content_taxonomy_label_id, l.label_scope, l.label_status, l.validated_by, l.validated_at, l.validation_decision_id,
         (l.validated_against_version_id is not null) as was_pointed
  from app.content_taxonomy_labels l join app.content_items ci on ci.id = l.content_item_id
  where ci.content_key = 'APBIO-MCQ-023' and l.superseded_by is null;

do $$
declare
  v_item app.content_items%rowtype; v_old app.content_item_versions%rowtype; v_new uuid := gen_random_uuid(); v_hits int;
  v_new_text constant text := 'Incorrect. Integral transmembrane proteins are released only by detergent (Triton X-100), but this protein was released by a high-salt wash and was absent from the detergent micelles. Also, a domain on the extracellular face would have been labeled by the impermeant biotin, and this protein was not labeled.';
begin
  select * into strict v_item from app.content_items where content_key='APBIO-MCQ-023' and item_type='mcq' for update;
  select * into strict v_old from app.content_item_versions where content_item_id=v_item.id and status='published' order by version_num desc limit 1 for update;

  update app.content_review_assignments set status='skipped'
    where content_item_version_id=v_old.id and assignment_purpose='subject_review' and status in ('pending','in_progress');
  update app.content_item_versions set status='retired', updated_at=now() where id=v_old.id;
  update app.content_items set status='draft', updated_at=now() where id=v_item.id;

  insert into app.content_item_versions (id,content_item_id,version_num,stem,stimulus,prompt_json,explanation,help_text,content_hash,status,created_by,
    canonical_answer_1,canonical_answer_2,review_status,rubric_type,evaluator_strategy,stimulus_image_path)
  values (v_new,v_item.id,v_old.version_num+1,v_old.stem,v_old.stimulus,
    coalesce(v_old.prompt_json,'{}'::jsonb) || jsonb_build_object('content_version',v_old.version_num+1,
      'qa_remediation','2026-10-01 choice A rationale repair (Biology S0a seed audit)','qa_source_version_id',v_old.id),
    v_old.explanation,v_old.help_text,md5(coalesce(v_old.stem,'')),'draft','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
    v_old.canonical_answer_1,v_old.canonical_answer_2,null,v_old.rubric_type,v_old.evaluator_strategy,v_old.stimulus_image_path);

  insert into app.mcq_choices (content_item_version_id,choice_key,choice_text,is_correct,rationale)
    select v_new,choice_key,choice_text,is_correct,rationale from app.mcq_choices where content_item_version_id=v_old.id;
  update app.mcq_choices set rationale=v_new_text
    where content_item_version_id=v_new and choice_text='An integral transmembrane protein with its primary domain on the extracellular face';
  get diagnostics v_hits = row_count;
  if v_hits<>1 then raise exception 'choice A matched % rows, expected 1', v_hits; end if;

  insert into app.content_item_cells (content_item_version_id,content_item_id,taxonomy_source_version,topic_code,skill_code,is_primary,assignment_status,source,model_run_id,validated_by,validated_at,validation_decision_id)
    select v_new,content_item_id,taxonomy_source_version,topic_code,skill_code,is_primary,assignment_status,source,model_run_id,validated_by,validated_at,validation_decision_id
    from app.content_item_cells where content_item_version_id=v_old.id and superseded_by is null;
  insert into app.content_item_difficulty (content_item_version_id,difficulty,basis,attainment_ratio,ratio_source,subject_cut_points,source_value,rationale,confidence,proposal_run,created_by)
    select v_new,difficulty,basis,attainment_ratio,ratio_source,subject_cut_points,source_value,rationale,confidence,proposal_run,created_by
    from app.content_item_difficulty where content_item_version_id=v_old.id;

  insert into repaired values ('APBIO-MCQ-023', v_old.id, v_new);
end $$;

update app.content_item_versions civ
set content_hash = md5(coalesce(civ.stem,'')||E'\n'||coalesce(civ.stimulus,'')||E'\n'||
  coalesce((select string_agg(m.choice_key||':'||m.choice_text||':'||m.is_correct::text||':'||coalesce(m.rationale,''), E'\n' order by m.choice_key)
            from app.mcq_choices m where m.content_item_version_id=civ.id),''))
from repaired r where civ.id=r.new_version_id;

insert into app.content_review_assignments (content_review_assignment_id,content_item_version_id,reviewer_id,review_stage,review_kind,status,assignment_purpose,created_by)
select gen_random_uuid(),new_version_id,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,'tutor_question','mcq','pending','owner_remediation_approval','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from repaired;

insert into app.content_review_decisions (content_review_assignment_id,content_item_version_id,reviewer_id,review_stage,tutor_score,difficulty_label,diagnostic_flag,
  concern_codes,note,tutor_decision,decision_payload,decision_hash,created_by)
select cra.content_review_assignment_id,r.new_version_id,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,'tutor_question',1,'Hard',false,array[]::text[],
  'Owner-approved repair 2026-10-01 (APPROVAL-0067) from the Biology S0a seed audit: key verified correct; choice A rationale corrected. APBIO-MCQ-023',
  'approve',
  jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','seed_audit_rationale_repair','content_key','APBIO-MCQ-023','qa_date','2026-10-01'),
  md5(r.new_version_id::text||'f5a26c6b-3566-4d58-9e97-979fbb947564'||'apbio-seed-audit-20261001'),
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from repaired r
join app.content_review_assignments cra on cra.content_item_version_id=r.new_version_id and cra.assignment_purpose='owner_remediation_approval' and cra.status='pending';

update app.content_item_versions civ set status='reviewed_approved', review_status='question_review_approved',
  approved_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, approved_at=coalesce(civ.approved_at,now()), updated_at=now()
from repaired r where civ.id=r.new_version_id;
update app.content_items ci set status='reviewed_approved', updated_at=now()
from repaired r join app.content_item_versions civ on civ.id=r.new_version_id where ci.id=civ.content_item_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now()
from repaired r where civ.id=r.new_version_id;
update app.content_items ci set status='published', updated_at=now()
from repaired r join app.content_item_versions civ on civ.id=r.new_version_id where ci.id=civ.content_item_id;

-- restore the labels that the version change made stale, re-pointed at the new version
update app.content_taxonomy_labels l
set label_status = p.label_status,
    validated_by = p.validated_by, validated_at = p.validated_at, validation_decision_id = p.validation_decision_id,
    validated_against_version_id = case when p.was_pointed then r.new_version_id else l.validated_against_version_id end,
    validated_against_taxo_hash  = case when p.was_pointed then app.taxonomy_relevant_hash(r.new_version_id) else l.validated_against_taxo_hash end,
    source_payload = l.source_payload || jsonb_build_object('carried_forward', jsonb_build_object(
        'from_version_id', l.validated_against_version_id, 'to_version_id', r.new_version_id,
        'reason', 'choice A rationale repair from the Biology S0a seed audit; unit and topic meaning unchanged; no relabelling',
        'approval_ref', (select ref from approval), 'prior_status', p.label_status))
from prior_labels p, repaired r
where l.content_taxonomy_label_id = p.content_taxonomy_label_id;

do $$
declare n int;
begin
  select count(*) into n from repaired; if n<>1 then raise exception 'expected 1 repaired item, got %', n; end if;
  -- exactly one correct choice, it is still D, and only choice A's rationale changed (no choice text or flag changed)
  select count(*) into n from repaired r join app.mcq_choices w on w.content_item_version_id=r.new_version_id where w.is_correct and w.choice_key<>'D';
  if n<>0 then raise exception 'correct choice is no longer D'; end if;
  select count(*) into n from repaired r join app.mcq_choices o on o.content_item_version_id=r.old_version_id
    join app.mcq_choices w on w.content_item_version_id=r.new_version_id and w.choice_key=o.choice_key
   where w.is_correct<>o.is_correct or w.choice_text<>o.choice_text;
  if n<>0 then raise exception 'choice text or is_correct changed on % choices', n; end if;
  select count(*) into n from repaired r join app.mcq_choices o on o.content_item_version_id=r.old_version_id
    join app.mcq_choices w on w.content_item_version_id=r.new_version_id and w.choice_key=o.choice_key
   where w.rationale is distinct from o.rationale;
  if n<>1 then raise exception 'expected exactly 1 changed rationale, got %', n; end if;
  select count(*) into n from repaired r join app.content_item_versions civ on civ.id=r.new_version_id
   where array_length(app.mcq_stem_choice_desync(civ.id, civ.stem),1) > 0;
  if n<>0 then raise exception 'stem/choice desync after repair'; end if;
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d;
  if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  -- every pre-existing label is back to its prior status and fresh if it was pointed
  select count(*) into n from prior_labels p join app.content_taxonomy_labels l on l.content_taxonomy_label_id=p.content_taxonomy_label_id
    join repaired r on true
   where l.label_status<>p.label_status
      or (p.was_pointed and (l.validated_against_version_id<>r.new_version_id or l.validated_against_taxo_hash<>app.taxonomy_relevant_hash(r.new_version_id)));
  if n<>0 then raise exception '% labels not restored/fresh', n; end if;
end $$;

select jsonb_build_object('repaired',(select count(*) from repaired),'labels_restored',(select count(*) from prior_labels)) as result;
commit;
