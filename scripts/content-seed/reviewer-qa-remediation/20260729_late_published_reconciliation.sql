-- Reconcile late-window decisions submitted against retired source versions
-- whose published successors still contain residual defects.

begin;

select pg_advisory_xact_lock(
  hashtext('cramapple-reviewer-qa-20260729-late-published')
);

create temporary table qa_corrected (
  content_key text primary key,
  old_version_id uuid not null,
  new_version_id uuid not null,
  source_decision_id uuid not null,
  assignment_id uuid not null
) on commit drop;

do $$
declare
  v_key text;
  v_item app.content_items%rowtype;
  v_old app.content_item_versions%rowtype;
  v_source app.content_review_decisions%rowtype;
  v_new_id uuid;
  v_assignment_id uuid;
  v_prompt jsonb;
begin
  foreach v_key in array array[
    'APBIO-FRQ-L-003',
    'APBIO-FRQ-L-025',
    'apphy1-frq-014'
  ] loop
    select * into strict v_item
    from app.content_items
    where lower(content_key)=lower(v_key)
    for update;

    select * into strict v_old
    from app.content_item_versions
    where content_item_id=v_item.id
    order by version_num desc,created_at desc
    limit 1
    for update;

    if v_old.prompt_json->>'qa_remediation'=
       '2026-07-29 late published reconciliation' then
      continue;
    end if;

    select d.* into strict v_source
    from app.content_review_decisions d
    join app.content_review_assignments a
      on a.content_review_assignment_id=d.content_review_assignment_id
    where d.content_item_version_id in (
        select id from app.content_item_versions
        where content_item_id=v_item.id
      )
      and d.submitted_at >= timestamptz '2026-07-28 22:18:23.390454+00'
      and a.assignment_purpose='subject_review'
    order by d.submitted_at desc
    limit 1;

    v_new_id := gen_random_uuid();
    v_assignment_id := gen_random_uuid();
    v_prompt := coalesce(v_old.prompt_json,'{}'::jsonb) ||
      jsonb_build_object(
        'content_version',v_old.version_num+1,
        'qa_remediation','2026-07-29 late published reconciliation',
        'qa_source_decision_id',v_source.content_review_decision_id
      );

    update app.content_item_versions set status='retired' where id=v_old.id;
    update app.content_items set status='draft' where id=v_item.id;

    insert into app.content_item_versions (
      id,content_item_id,version_num,stem,stimulus,prompt_json,
      explanation,help_text,content_hash,status,created_by,
      canonical_answer_1,canonical_answer_2,review_status,
      rubric_type,evaluator_strategy,stimulus_image_path
    ) values (
      v_new_id,v_item.id,v_old.version_num+1,v_old.stem,v_old.stimulus,v_prompt,
      v_old.explanation,v_old.help_text,md5(v_old.stem),'draft',
      'f5a26c6b-3566-4d58-9e97-979fbb947564',
      v_old.canonical_answer_1,v_old.canonical_answer_2,null,
      v_old.rubric_type,v_old.evaluator_strategy,v_old.stimulus_image_path
    );

    insert into app.frq_criteria (
      content_item_version_id,criterion_key,learner_facing_text,
      points_possible,evidence_requirements,minimum_fix,accepted_variants
    )
    select v_new_id,criterion_key,learner_facing_text,points_possible,
           evidence_requirements,minimum_fix,accepted_variants
    from app.frq_criteria
    where content_item_version_id=v_old.id;

    if lower(v_key)='apbio-frq-l-003' then
      update app.content_item_versions
      set stem=replace(
            replace(
              v_old.stem,
              'Explain why the actual offspring frequencies would differ from a 1:1:1:1 ratio if these genes were unlinked.',
              'Explain why the linked loci produce offspring frequencies that differ from the 1:1:1:1 ratio expected if the loci were unlinked.'
            ),
            'Explain how nondisjunction during meiosis II in one parent could produce a child with two copies of the chromosome 7 allele from that parent (uniparental isodisomy). Describe at what stage nondisjunction would have to occur and what type of gamete would result.',
            'Explain how nondisjunction of chromosome 7 during meiosis II changes the chromosome number of the resulting gametes. Predict the chromosome number of a zygote formed when an abnormal gamete containing two copies of chromosome 7 is fertilized by a normal gamete.'
          ),
          prompt_json=jsonb_set(
            jsonb_set(prompt_json,'{total_points}','10'::jsonb),
            '{criteria}',
            jsonb_build_array(
              jsonb_build_object(
                'criterion_key','a','points_possible',2,
                'learner_facing_text',
                'Determine autosomal-recessive inheritance from pedigree evidence and assign the four requested genotypes.'
              ),
              jsonb_build_object(
                'criterion_key','b','points_possible',3,
                'learner_facing_text',
                'Determine the affected-child probability and complete the chi-square analysis against the 1:1 expectation.'
              ),
              jsonb_build_object(
                'criterion_key','c','points_possible',3,
                'learner_facing_text',
                'Predict the four linked testcross classes and explain their departure from the unlinked 1:1:1:1 expectation.'
              ),
              jsonb_build_object(
                'criterion_key','d','points_possible',2,
                'learner_facing_text',
                'Explain meiosis-II nondisjunction and predict the resulting abnormal gamete and zygote chromosome numbers.'
              )
            )
          )
      where id=v_new_id;

      update app.frq_criteria
      set points_possible=2,
          learner_facing_text=
            'Determines autosomal-recessive inheritance using pedigree evidence and assigns I-1=aa, I-2=Aa, II-3=aa, and II-4=Aa.',
          evidence_requirements=
            'Identifies autosomal recessive; supports it with affected and unaffected offspring of both sexes and exclusion of X-linked recessive; gives all four genotypes.',
          minimum_fix=
            'State autosomal recessive with pedigree evidence and give I-1=aa, I-2=Aa, II-3=aa, II-4=Aa.'
      where content_item_version_id=v_new_id and criterion_key='a';

      update app.frq_criteria
      set learner_facing_text=
            'Determines a 1/2 affected-child probability and completes a chi-square analysis of 3 unaffected and 1 affected child against the 1:1 expectation.',
          evidence_requirements=
            'aa x Aa gives 1/2 affected. Expected counts are 2 and 2; chi-square=1.0; because 1.0<3.84, fails to reject the 1:1 model.',
          minimum_fix=
            'Give probability 1/2, expected counts 2 and 2, chi-square=1.0, and the correct conclusion.'
      where content_item_version_id=v_new_id and criterion_key='b';

      update app.frq_criteria
      set learner_facing_text=
            'Predicts linked-testcross offspring counts of 92, 92, 8, and 8 and explains why linkage causes departure from the unlinked 1:1:1:1 expectation.',
          evidence_requirements=
            'Uses 8% recombination: two parental classes at 46% each and two recombinant classes at 4% each; contrasts linkage with independent assortment.',
          minimum_fix=
            'Give 92, 92, 8, and 8 and explain why parental classes exceed recombinant classes.'
      where content_item_version_id=v_new_id and criterion_key='c';

      update app.frq_criteria
      set learner_facing_text=
            'Explains that failure of sister chromatids to separate in meiosis II produces one gamete with two copies of chromosome 7 and one with none; fertilization of the disomic gamete by a normal gamete produces a trisomic zygote.',
          evidence_requirements=
            'Names anaphase II/sister-chromatid nondisjunction; identifies n+1 and n-1 gametes; predicts three copies of chromosome 7 in the zygote formed with the n+1 gamete.',
          minimum_fix=
            'Describe meiosis-II sister-chromatid nondisjunction and the n+1 gamete and trisomic zygote.'
      where content_item_version_id=v_new_id and criterion_key='d';

    elsif lower(v_key)='apbio-frq-l-025' then
      update app.content_item_versions
      set prompt_json=jsonb_set(
            jsonb_set(prompt_json,'{total_points}','10'::jsonb),
            '{criteria}',
            jsonb_build_array(
              jsonb_build_object(
                'criterion_key','a','points_possible',2,
                'learner_facing_text',
                'Define synapomorphy, construct the cladogram with an outgroup justification, and explain parsimony.'
              ),
              jsonb_build_object(
                'criterion_key','b','points_possible',3,
                'learner_facing_text',
                'Explain the molecular clock, calculate an 8.0-Mya Human-Gorilla estimate, and describe two limitations.'
              ),
              jsonb_build_object(
                'criterion_key','c','points_possible',2,
                'learner_facing_text',
                'Explain homoplasy, why molecular evidence can improve deep phylogeny, and give a valid example.'
              ),
              jsonb_build_object(
                'criterion_key','d','points_possible',3,
                'learner_facing_text',
                'Describe and interpret three valid lines of evidence for species versus subspecies status.'
              )
            )
          )
      where id=v_new_id;

      update app.frq_criteria
      set points_possible=2,
          learner_facing_text=
            'Defines synapomorphy, constructs A as outgroup with topology (A,(B,(C,(D,E)))), and explains that parsimony minimizes evolutionary changes.',
          evidence_requirements=
            'Shared-derived-character definition; correct nested topology and outgroup; correct fewest-changes explanation.',
          minimum_fix=
            'Give the definition, topology/outgroup, and parsimony interpretation.'
      where content_item_version_id=v_new_id and criterion_key='a';

      update app.frq_criteria
      set learner_facing_text=
            'Explains neutral-mutation accumulation, calculates 4.0% x 2 Mya/% = 8.0 Mya for Human-Gorilla divergence, and describes two valid rate limitations.',
          evidence_requirements=
            'Neutral mutation/drift mechanism; 8.0-Mya calculation using the supplied calibration; two valid limitations such as generation time, selection, repair, or calibration uncertainty.',
          minimum_fix=
            'Give the clock mechanism, 8.0-Mya estimate, and two valid limitations.'
      where content_item_version_id=v_new_id and criterion_key='b';

      update app.frq_criteria
      set points_possible=2
      where content_item_version_id=v_new_id and criterion_key='c';

      update app.frq_criteria
      set points_possible=3,
          learner_facing_text=
            'Describes three valid evidence types—genetic divergence, reproductive isolation, and consistent morphological/ecological differentiation—and explains how each bears on species versus subspecies status.',
          evidence_requirements=
            'One point for each distinct evidence type paired with a scientifically sound interpretation, up to three points.',
          minimum_fix=
            'Provide three distinct evidence types and explain what each would indicate.'
      where content_item_version_id=v_new_id and criterion_key='d';

    elsif lower(v_key)='apphy1-frq-014' then
      update app.content_item_versions
      set stimulus=
            'A solid cylinder starts from rest and rolls without slipping down an incline through a vertical height h.'
      where id=v_new_id;
    end if;

    update app.content_item_versions civ
    set content_hash=md5(
      coalesce(civ.stem,'')||E'\n'||coalesce(civ.stimulus,'')||E'\n'||
      coalesce(civ.canonical_answer_1,'')||E'\n'||
      coalesce((
        select string_agg(
          f.criterion_key||':'||f.points_possible::text||':'||
          f.learner_facing_text||':'||
          coalesce(f.evidence_requirements,'')||':'||
          coalesce(f.minimum_fix,''),
          E'\n' order by f.criterion_key
        )
        from app.frq_criteria f
        where f.content_item_version_id=civ.id
      ),'')
    )
    where civ.id=v_new_id;

    insert into qa_corrected values (
      v_key,v_old.id,v_new_id,
      v_source.content_review_decision_id,v_assignment_id
    );
  end loop;
end
$$;

insert into app.content_review_assignments (
  content_review_assignment_id,content_item_version_id,reviewer_id,
  review_stage,review_kind,status,assignment_purpose,created_by
)
select assignment_id,new_version_id,
  'f5a26c6b-3566-4d58-9e97-979fbb947564',
  'tutor_question','frq','pending','owner_remediation_approval',
  'f5a26c6b-3566-4d58-9e97-979fbb947564'
from qa_corrected;

insert into app.content_review_decisions (
  content_review_assignment_id,content_item_version_id,reviewer_id,
  supersedes_id,review_stage,tutor_score,difficulty_label,diagnostic_flag,
  concern_codes,note,topic_selections,tutor_decision,decision_payload,
  decision_hash,created_by
)
select
  c.assignment_id,c.new_version_id,
  'f5a26c6b-3566-4d58-9e97-979fbb947564',
  c.source_decision_id,'tutor_question',1,
  coalesce(source.difficulty_label,'Medium'),false,array[]::text[],
  'Late-window published-successor QA correction verified; immutable source review preserved.',
  source.topic_selections,'approve',
  jsonb_build_object(
    'review_stage','tutor_question',
    'tutor_score',1,
    'tutor_decision','approve',
    'approval_basis','independent_reviewer_decision_qa',
    'source_review_decision_id',c.source_decision_id,
    'qa_window_start','2026-07-28T22:18:23.390454Z',
    'qa_date','2026-07-29',
    'reconciliation','late_published_successor'
  ),
  encode(extensions.digest(jsonb_build_object(
    'review_stage','tutor_question',
    'tutor_score',1,
    'tutor_decision','approve',
    'approval_basis','independent_reviewer_decision_qa',
    'source_review_decision_id',c.source_decision_id,
    'qa_window_start','2026-07-28T22:18:23.390454Z',
    'qa_date','2026-07-29',
    'reconciliation','late_published_successor'
  )::text,'sha256'),'hex'),
  'f5a26c6b-3566-4d58-9e97-979fbb947564'
from qa_corrected c
join app.content_review_decisions source
  on source.content_review_decision_id=c.source_decision_id;

do $$
declare
  v_count integer;
begin
  select count(*) into v_count
  from qa_corrected c
  join app.content_item_versions civ on civ.id=c.new_version_id
  join app.content_items ci on ci.id=civ.content_item_id
  where civ.status='reviewed_approved'
    and civ.review_status='question_review_approved'
    and ci.status='reviewed_approved';

  if v_count<>3 then
    raise exception 'late published reconciliation failed: %/3',v_count;
  end if;
end
$$;

commit;
