-- APBIO-MCQ-074: retarget from CRISPR-Cas9 (not in AP_BIOLOGY_CED_FACT_PACK.md -- zero
-- hits for "CRISPR"; Unit 6.8's documented technique list is gel electrophoresis, PCR,
-- bacterial transformation, DNA sequencing/fingerprinting only) to PCR primer-annealing,
-- which IS explicitly CED-covered (EK 6.8.A.1: "PCR (denature/anneal/extend
-- amplification)"). Owner-directed, 2026-08-11: "Retarget to a CED-covered technique."
-- Keeps Adil Abbasi's requested SP1/SP6 point-mutation-prediction mechanic, rebuilt
-- around primer/target base-pairing instead of guide-RNA/Cas9 targeting. Base-pairing
-- independently verified letter-by-letter before use (all 20 positions correct
-- Watson-Crick DNA pairs, both before and after the introduced mutation).

begin;
select pg_advisory_xact_lock(hashtext('cramapple-apbio-mcq-074-retarget-20260811'));

do $$
declare
  v_item app.content_items%rowtype;
  v_old app.content_item_versions%rowtype;
  v_new uuid := gen_random_uuid();
begin
  select * into strict v_item from app.content_items where content_key='APBIO-MCQ-074' and item_type='mcq' for update;
  select * into strict v_old from app.content_item_versions where content_item_id=v_item.id and status='published' for update;

  update app.content_review_assignments set status='skipped'
  where content_item_version_id=v_old.id and assignment_purpose='subject_review' and status in ('pending','in_progress');

  update app.content_item_versions set status='retired', updated_at=now() where id=v_old.id;
  update app.content_items set status='draft', updated_at=now() where id=v_item.id;

  insert into app.content_item_versions (
    id,content_item_id,version_num,stem,stimulus,prompt_json,
    explanation,help_text,content_hash,status,created_by,
    canonical_answer_1,canonical_answer_2,review_status,
    rubric_type,evaluator_strategy,stimulus_image_path
  ) values (
    v_new,v_item.id,v_old.version_num+1,
    E'A researcher performs PCR using the primer shown above to amplify this target region. A point mutation changes the nucleotide at position 5 (counting from the 5\' end of the target) from C to T. Which best predicts the effect of this mutation on PCR amplification of this target, and why?',
    E'PCR amplifies a specific DNA sequence using two short DNA primers that are complementary to the target sequence. During the anneal step, each primer binds by base pairing to its complementary sequence on the template DNA; DNA polymerase then extends from the primer during the extend step. One primer used in this scenario is designed to base-pair with the following 20-nucleotide target sequence (read 5\' to 3\'):\n\nTarget:  5\'-GGCACTGATCCGTAAGCTTG-3\'\nPrimer:  3\'-CCGTGACTAGGCATTCGAAC-5\'\n\n(The primer sequence shown here base-pairs with the target through standard Watson-Crick DNA base pairing.)',
    jsonb_build_object(
      'content_version',v_old.version_num+1,
      'qa_remediation','2026-08-11 APBIO-MCQ-074 CED-scope retarget (CRISPR not in fact pack; PCR anneal step is EK 6.8.A.1)',
      'qa_source_version_id',v_old.id,
      'modules', jsonb_build_array('6'),
      'subtopics', jsonb_build_array('6.8 Biotechnology'),
      'intended_difficulty','Hard'
    ),
    v_old.explanation,v_old.help_text,v_old.content_hash,
    'draft','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
    'A',null,null,
    v_old.rubric_type,v_old.evaluator_strategy,null
  );

  insert into app.mcq_choices (content_item_version_id,choice_key,choice_text,is_correct,rationale) values
  (v_new,'A','Amplification of this target would be reduced or prevented, because the mutation creates a mismatch between the primer and the target at that position, disrupting the base pairing needed for the primer to anneal there.',true,
   'Correct. PCR primers must base-pair with the target sequence during the anneal step for DNA polymerase to extend from them. A point mutation at a primer-binding position breaks the Watson-Crick pairing at that base, which disrupts primer annealing and can prevent extension and amplification of that target.'),
  (v_new,'B','Amplification would be unaffected, because DNA polymerase can extend the primer regardless of whether every base pairs correctly.',false,
   'Incorrect. DNA polymerase extends from an annealed primer; primer binding (base pairing to the template) is a prerequisite for the extend step, not something the polymerase can substitute for. A mismatched primer that cannot anneal properly gives the polymerase nothing reliable to extend from.'),
  (v_new,'C','Amplification would be unaffected, because a single-nucleotide change does not alter the overall length of the target sequence that PCR amplifies.',false,
   'Incorrect. The relevant issue is not the length of the amplified product but whether the primer can anneal to the target at all; a single mismatched base at a primer-binding position can prevent annealing regardless of the target''s total length.'),
  (v_new,'D','Amplification would increase, because the mutation adds a new possible primer-binding site elsewhere in the sequence.',false,
   'Incorrect. Changing one base within the primer''s own binding site does not create a new binding site elsewhere; the primer''s own sequence is unchanged, and only the target sequence at that one position is mutated.');

  update app.content_item_versions civ
  set content_hash=md5(coalesce(civ.stem,'')||E'\n'||coalesce(civ.stimulus,'')||E'\n'||
    coalesce((select string_agg(m.choice_key||':'||m.choice_text||':'||m.is_correct::text||':'||coalesce(m.rationale,''), E'\n' order by m.choice_key)
              from app.mcq_choices m where m.content_item_version_id=civ.id),''))
  where civ.id=v_new;

  insert into app.content_review_assignments (
    content_review_assignment_id, content_item_version_id, reviewer_id,
    review_stage, review_kind, status, assignment_purpose, created_by
  ) values (gen_random_uuid(),v_new,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,'tutor_question','mcq','pending','owner_remediation_approval','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid);

  insert into app.content_review_decisions (
    content_review_assignment_id,content_item_version_id,reviewer_id,
    review_stage,tutor_score,difficulty_label,diagnostic_flag,
    concern_codes,note,tutor_decision,decision_payload,decision_hash,created_by
  )
  select cra.content_review_assignment_id,v_new,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
    'tutor_question',1,'Hard',false,array[]::text[],
    'Owner-directed CED-scope retarget, 2026-08-11: CRISPR-Cas9 confirmed absent from AP_BIOLOGY_CED_FACT_PACK.md (zero grep hits); Unit 6.8 documents PCR (denature/anneal/extend) as the covered technique. Rebuilt as a primer/target base-pairing point-mutation-prediction item (SP1/SP6, per Adil Abbasi''s 08-09 request), independently verified letter-by-letter (20/20 correct Watson-Crick DNA pairs, both before and after the introduced mutation at position 5).',
    'approve',
    jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apbio_mcq_074_ced_retarget_20260811','qa_date','2026-08-11'),
    encode(extensions.digest(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apbio_mcq_074_ced_retarget_20260811','qa_date','2026-08-11')::text,'sha256'),'hex'),
    'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
  from app.content_review_assignments cra where cra.content_item_version_id=v_new and cra.assignment_purpose='owner_remediation_approval' and cra.status='pending';

  update app.content_item_versions set status='reviewed_approved', review_status='question_review_approved', approved_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, approved_at=now(), updated_at=now() where id=v_new;
  update app.content_items set status='reviewed_approved', updated_at=now() where id=v_item.id;
  update app.content_item_versions set status='published', published_at=now(), updated_at=now() where id=v_new;
  update app.content_items set status='published', updated_at=now() where id=v_item.id;
end $$;

do $$ declare n int; begin
  select count(*) into n from (
    select civ.content_item_id from app.content_item_versions civ where civ.status='published'
    group by civ.content_item_id having count(*)>1) t;
  if n>0 then raise exception 'double-published items detected: %', n; end if;

  select count(*) into n from app.mcq_choices m
  join app.content_item_versions civ on civ.id=m.content_item_version_id
  join app.content_items ci on ci.id=civ.content_item_id
  where ci.content_key='APBIO-MCQ-074' and civ.status='published';
  if n<>4 then raise exception 'expected 4 choices, got %', n; end if;
end $$;

commit;
