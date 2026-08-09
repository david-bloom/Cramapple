-- Backlog §9 QA defect repair, 2026-08-09.
--
-- Context: docs/research/QA_PROTOCOL_SECTION9_POOL1_POOL2_RUN_2026_08_09.md
-- follow-up. Owner directed a full §9 independent re-derivation pass over
-- all 167 items sitting at status='reviewed_approved' (never published) --
-- the backlog behind the reviewer dashboard showing >200 "review approved"
-- items. 13 parallel agents found 162 clean, 2 confirmed content defects,
-- and 1 minor internally-inconsistent stimulus value. This script repairs
-- the 3 before the full batch publishes.
--
-- 1. apchem-sfrq-014, criterion c3: learner_facing_text correctly asks
--    about polarity (matching stem part c), but evidence_requirements/
--    minimum_fix asked for Xe hybridization (sp3d2) instead -- never asked
--    anywhere in the stem. Split the existing learner_facing_text's two
--    claims (identifies nonpolar; justifies via dipole cancellation) into
--    two explicit 1-point elements matching the 2 points_possible already
--    on this criterion.
-- 2. STATS-MOD3-M007: criterion's third disjunct ("or describes z-score
--    standardization") let a response earn full credit by merely defining
--    z-scores, without justifying why normal-based probability statements
--    remain valid for non-normal populations. Removed; CLT-based
--    sample-mean-normality justification is now the only path to credit.
-- 3. APSTAT-MOD4-H001-INV: part (d) states "the researcher finds a
--    significant result (p = 0.02)", but that value doesn't match the
--    p-value implied by part (c)'s own numbers (t=4/sqrt(36/25+25/25)=2.56,
--    df~46-48, two-tailed p~0.013-0.014). Corrected the stated p-value for
--    internal consistency with the item's own data.

begin;
select pg_advisory_xact_lock(hashtext('cramapple-backlog-defects-repair-20260809'));

create temporary table repair_targets (content_key text primary key, item_type text) on commit drop;
insert into repair_targets values
  ('apchem-sfrq-014','frq'),
  ('STATS-MOD3-M007','frq'),
  ('APSTAT-MOD4-H001-INV','frq');

create temporary table repaired (
  content_key text primary key,
  old_version_id uuid not null,
  new_version_id uuid not null
) on commit drop;

do $$
declare
  t record;
  v_item app.content_items%rowtype;
  v_old app.content_item_versions%rowtype;
  v_new uuid;
  v_new_stem text;
begin
  for t in select * from repair_targets order by content_key loop
    select * into strict v_item
    from app.content_items
    where content_key=t.content_key and item_type=t.item_type
    for update;

    select * into strict v_old
    from app.content_item_versions
    where content_item_id=v_item.id and status='reviewed_approved'
    order by version_num desc
    limit 1
    for update;

    if t.content_key = 'APSTAT-MOD4-H001-INV' then
      v_new_stem := replace(v_old.stem, 'p = 0.02', 'p is approximately 0.014');
    else
      v_new_stem := v_old.stem;
    end if;

    v_new := gen_random_uuid();

    update app.content_review_assignments
    set status='skipped'
    where content_item_version_id=v_old.id
      and assignment_purpose='subject_review'
      and status in ('pending','in_progress');

    update app.content_item_versions
    set status='retired', updated_at=now()
    where id=v_old.id;

    update app.content_items
    set status='draft', updated_at=now()
    where id=v_item.id;

    insert into app.content_item_versions (
      id,content_item_id,version_num,stem,stimulus,prompt_json,
      explanation,help_text,content_hash,status,created_by,
      canonical_answer_1,canonical_answer_2,review_status,
      rubric_type,evaluator_strategy,stimulus_image_path
    ) values (
      v_new,v_item.id,v_old.version_num+1,v_new_stem,v_old.stimulus,
      coalesce(v_old.prompt_json,'{}'::jsonb) || jsonb_build_object(
        'content_version', v_old.version_num+1,
        'qa_remediation', '2026-08-09 backlog §9 QA defect repair (protocol §9 follow-up)',
        'qa_source_version_id', v_old.id
      ),
      v_old.explanation,v_old.help_text,md5(coalesce(v_new_stem,'')),
      'draft','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
      v_old.canonical_answer_1,v_old.canonical_answer_2,null,
      v_old.rubric_type,v_old.evaluator_strategy,v_old.stimulus_image_path
    );

    insert into app.frq_criteria (
      content_item_version_id,criterion_key,learner_facing_text,points_possible,
      evidence_requirements,minimum_fix,accepted_variants
    )
    select v_new,criterion_key,learner_facing_text,points_possible,
      evidence_requirements,minimum_fix,accepted_variants
    from app.frq_criteria
    where content_item_version_id=v_old.id;

    insert into repaired values (t.content_key,v_old.id,v_new);
  end loop;
end $$;

-- apchem-sfrq-014 criterion c3: fix evidence_requirements/minimum_fix to match
-- learner_facing_text (polarity), split into the 2 elements already implied
-- by points_possible=2.
update app.frq_criteria fc
set
  evidence_requirements='Two required elements, 1 point each: (1) correctly identifies XeF4 as a nonpolar molecule; (2) justifies this by explaining that the four Xe-F bond dipoles are symmetrically arranged (square planar geometry) and cancel by symmetry, giving no net molecular dipole moment. Award 1 point per element present.',
  minimum_fix='To earn full credit, explicitly show: (1) XeF4 is nonpolar; (2) the four symmetric Xe-F bond dipoles cancel by symmetry in the square-planar geometry, giving zero net dipole moment.'
from repaired r
where r.content_key='apchem-sfrq-014' and fc.content_item_version_id=r.new_version_id and fc.criterion_key='c3';

-- STATS-MOD3-M007: remove the over-permissive z-score-only disjunct.
update app.frq_criteria fc
set
  learner_facing_text='References the Central Limit Theorem and explains that sample means are approximately normally distributed for a sufficiently large sample size, regardless of the population''s own shape.',
  evidence_requirements='Earns when the response references the Central Limit Theorem and explains that the sampling distribution of the sample mean is approximately normal for a large enough sample size, regardless of the shape of the population distribution. Accept equivalent correct wording. Does not earn if the response only describes z-score standardization without this justification, or if the required element is missing, incorrect, or contradicted elsewhere in the response.',
  minimum_fix='To earn this point, make sure your response references the Central Limit Theorem and explains that sample means become approximately normal for large samples regardless of the population''s shape -- merely defining a z-score is not sufficient.'
from repaired r
where r.content_key='STATS-MOD3-M007' and fc.content_item_version_id=r.new_version_id;

update app.content_item_versions civ
set content_hash=md5(coalesce(civ.stem,'')||E'\n'||coalesce(civ.stimulus,'')||E'\n'||
  coalesce((select string_agg(fc.criterion_key||':'||fc.learner_facing_text, E'\n' order by fc.criterion_key)
            from app.frq_criteria fc where fc.content_item_version_id=civ.id),''))
from repaired r where civ.id=r.new_version_id;

insert into app.content_review_assignments (
  content_review_assignment_id, content_item_version_id, reviewer_id,
  review_stage, review_kind, status, assignment_purpose, created_by
)
select gen_random_uuid(),new_version_id,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
       'tutor_question','frq','pending','owner_remediation_approval','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from repaired;

insert into app.content_review_decisions (
  content_review_assignment_id,content_item_version_id,reviewer_id,
  review_stage,tutor_score,difficulty_label,diagnostic_flag,
  concern_codes,note,tutor_decision,decision_payload,
  decision_hash,created_by
)
select cra.content_review_assignment_id,r.new_version_id,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
       'tutor_question',1,'Medium',false,array[]::text[],
       'Owner-directed backlog §9 QA defect repair, 2026-08-09 -- ' || r.content_key,
       'approve',
       jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','backlog_qa_defect_repair','content_key',r.content_key,'qa_date','2026-08-09'),
       encode(extensions.digest(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','backlog_qa_defect_repair','content_key',r.content_key,'qa_date','2026-08-09')::text,'sha256'),'hex'),
       'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from repaired r
join app.content_review_assignments cra on cra.content_item_version_id=r.new_version_id and cra.assignment_purpose='owner_remediation_approval' and cra.status='pending';

update app.content_item_versions civ
set status='reviewed_approved',
    review_status='question_review_approved',
    approved_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
    approved_at=coalesce(civ.approved_at,now()),
    updated_at=now()
from repaired r where civ.id=r.new_version_id;

update app.content_items ci
set status='reviewed_approved', updated_at=now()
from repaired r join app.content_item_versions civ on civ.id=r.new_version_id
where ci.id=civ.content_item_id;

do $$
declare n integer;
begin
  select count(*) into n from repaired;
  if n<>3 then raise exception 'expected 3 repaired items, got %', n; end if;
end $$;

select ci.content_key, v.version_num, v.status, v.review_status
from repaired r
join app.content_item_versions v on v.id=r.new_version_id
join app.content_items ci on ci.id=v.content_item_id;

commit;
