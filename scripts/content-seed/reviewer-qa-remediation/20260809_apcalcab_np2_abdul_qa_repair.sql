-- QA sweep of Abdul Hanan's np2 batch (AP Calculus AB + AP Precalculus,
-- scripts/content-seed/replication-batch-2026-08-08/), 2026-08-09.
--
-- Abdul reviewed all 40 np2 items 2026-08-08 (54 approve / 6 approve_with_edits
-- across the full sweep window, per docs/Q&A/REVIEWER_QA_SWEEP_2026_08_08.md).
-- All 40 items were already published at review_status='question_review_approved'
-- without the approve_with_edits notes ever being applied -- his 6 flagged edits
-- were recorded as decisions but never turned into a repaired version. This
-- session re-derived each flagged item from scratch per protocol
-- CONTENT_AUTHORING_AND_QA_PROTOCOL.md Section 9 (independent re-derivation, not
-- reading the stored answer and checking it "looks right") before repairing.
--
-- Findings, one per item (see docs/Q&A/REVIEWER_QA_SWEEP_2026_08_09.md for the
-- full writeup):
--   apcalcab-frq-np2-008 (part-b-criterion-01): genuine numeric error, confirmed.
--     P(t)=2000e^(0.04t); P(10)=2000e^0.4. With e^0.4=1.491824698 (to 9 places),
--     P(10)=2983.649396 -> 2983.649 to 3 places, not the stored 2983.653. Abdul's
--     flagged value is correct; parts (a) and (c) were independently re-verified
--     and are unchanged.
--   apcalcab-mcq-np2-001 (choice D, "6*pi"): rationale was generic ("does not
--     correctly apply the chain rule"). Re-derived: 6*pi = pi*(3)*(2), i.e.
--     stacking B's error (treating dV/dr as proportional to r, not r^2) and C's
--     error (dropping the coefficient 4) into a single dV/dr=pi*r mistake.
--   apcalcab-mcq-np2-005 (choice D, "42"): rationale was generic. Re-derived:
--     42 = (1)(5)+(3)(9)+(1)(10), i.e. using the right endpoint's x-value (3) as
--     the width of the [1,3] subinterval instead of its actual width (3-1=2) --
--     matches Abdul's traced mechanism exactly.
--   apcalcab-mcq-np2-006 (choice C, "e^3"): rationale was generic, and unlike the
--     other three flagged MCQs, no mechanical path to e^3 could be independently
--     reproduced from the stated ODE (dy/dx=2xy, y(0)=3) -- confirmed Abdul's own
--     finding that he "was unable to construct a clean mechanical path to this
--     value." Per his second recommendation ("replace C with a distractor with a
--     clear derivable error"), replaced with a genuinely common, derivable error:
--     omitting the initial condition when solving for the constant of
--     integration (C=0 instead of C=ln 3), giving y=e^(x^2) and y(1)=e.
--   apcalcab-mcq-np2-007 (choice D, "18"): rationale was generic. Re-derived:
--     18 = (g(0)+g(6))/2 = (0+36)/2, i.e. averaging the two endpoint function
--     values as if g were linear, instead of computing the actual average value
--     (1/6)*integral -- matches Abdul's traced mechanism exactly.
--
-- apprecalc-mcq-np2-007 (also approve_with_edits, concern "Ambiguity") was
-- independently checked and NOT touched: the stored rationales for choices C and
-- D already state the precise mechanism Abdul asked for ("uses the sine
-- reference value for pi/6 instead of the cosine reference value"), not the
-- vaguer "sign omission" framing his note described -- no defect found.
--
-- Pattern: new admin-authored version per item (old published version retired,
-- never edited in place), owner_remediation_approval admin decision referencing
-- Abdul's original decision, structural QA gate, then the standard two-step
-- publish (reviewed_approved -> published), per
-- scripts/content-seed/reviewer-qa-remediation/20260808_apcalc_rubric_architecture_fixes.sql
-- and .../20260806_apcalcbc_mcq_distractor_repair.sql. Admin UUID
-- f5a26c6b-3566-4d58-9e97-979fbb947564 matches the DECISION-0044 / TASK-0022
-- remediation precedent.

begin;
select pg_advisory_xact_lock(hashtext('cramapple-apcalcab-np2-abdul-qa-repair-20260809'));

-- =============================================================================
-- Part 1: apcalcab-frq-np2-008, part-b-criterion-01 numeric fix.
-- =============================================================================

do $$
declare
  v_admin uuid := 'f5a26c6b-3566-4d58-9e97-979fbb947564';
  v_item app.content_items%rowtype;
  v_old app.content_item_versions%rowtype;
  v_new uuid := gen_random_uuid();
  v_assignment uuid := gen_random_uuid();
  v_source uuid := '86bdd195-9bdc-4f25-9707-3c68542a0b78';
begin
  select * into strict v_item from app.content_items where content_key='apcalcab-frq-np2-008' for update;
  select * into strict v_old from app.content_item_versions
  where content_item_id=v_item.id and status='published'
  order by version_num desc limit 1 for update;

  update app.content_item_versions set status='retired', updated_at=now() where id=v_old.id;
  update app.content_items set status='draft', updated_at=now() where id=v_item.id;

  insert into app.content_item_versions (
    id,content_item_id,version_num,stem,stimulus,prompt_json,
    explanation,help_text,content_hash,status,created_by,
    canonical_answer_1,canonical_answer_2,review_status,
    rubric_type,evaluator_strategy,stimulus_image_path
  ) values (
    v_new,v_item.id,v_old.version_num+1,v_old.stem,v_old.stimulus,
    coalesce(v_old.prompt_json,'{}'::jsonb) || jsonb_build_object(
      'content_version',v_old.version_num+1,
      'qa_remediation','2026-08-09 Abdul np2 QA sweep -- P(10) rubric value corrected',
      'qa_source_decision_id',v_source
    ),
    v_old.explanation,v_old.help_text,md5(coalesce(v_old.stem,'')),
    'draft',v_admin,
    v_old.canonical_answer_1,v_old.canonical_answer_2,null,
    v_old.rubric_type,v_old.evaluator_strategy,v_old.stimulus_image_path
  );

  insert into app.frq_criteria (
    content_item_version_id,criterion_key,learner_facing_text,
    points_possible,evidence_requirements,minimum_fix,accepted_variants
  )
  select v_new,criterion_key,learner_facing_text,points_possible,
         evidence_requirements,minimum_fix,accepted_variants
  from app.frq_criteria where content_item_version_id=v_old.id;

  update app.frq_criteria
  set learner_facing_text='Correctly evaluates P(10) is approximately 2983.649.'
  where content_item_version_id=v_new and criterion_key='part-b-criterion-01';

  update app.content_item_versions civ
  set content_hash=md5(
    coalesce(civ.stem,'')||E'\n'||coalesce(civ.stimulus,'')||E'\n'||
    coalesce((
      select string_agg(
        f.criterion_key||':'||f.points_possible::text||':'||f.learner_facing_text||':'||
        coalesce(f.evidence_requirements,'')||':'||coalesce(f.minimum_fix,''),
        E'\n' order by f.criterion_key
      )
      from app.frq_criteria f where f.content_item_version_id=civ.id
    ),'')
  )
  where civ.id=v_new;

  insert into app.content_review_assignments (
    content_review_assignment_id,content_item_version_id,reviewer_id,
    review_stage,review_kind,status,assignment_purpose,created_by
  ) values (
    v_assignment,v_new,v_admin,'tutor_question','frq','pending','owner_remediation_approval',v_admin
  );

  insert into app.content_review_decisions (
    content_review_assignment_id,content_item_version_id,reviewer_id,
    supersedes_id,review_stage,tutor_score,difficulty_label,diagnostic_flag,
    concern_codes,note,tutor_decision,decision_payload,decision_hash,created_by
  ) values (
    v_assignment,v_new,v_admin,v_source,'tutor_question',1,'Medium',false,array[]::text[],
    'owner_remediation_approval: corrected P(10) rubric target from 2983.653 to 2983.649 '||
    '(P(10)=2000e^0.4, independently re-derived to high precision) per Abdul Hanan''s '||
    '2026-08-08 approve_with_edits note on apcalcab-frq-np2-008.',
    'approve',
    jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve',
      'approval_basis','apcalcab_np2_abdul_qa_repair','source_review_decision_id',v_source,'qa_date','2026-08-09'),
    encode(extensions.digest('apcalcab-frq-np2-008-fix-20260809','sha256'),'hex'),v_admin
  );

  if not exists (
    select 1 from app.frq_criteria f
    where f.content_item_version_id=v_new and f.criterion_key='part-b-criterion-01'
      and f.learner_facing_text like '%2983.649%'
  ) then
    raise exception 'apcalcab-frq-np2-008 fix failed to apply';
  end if;

  update app.content_item_versions set status='reviewed_approved', updated_at=now() where id=v_new;
  update app.content_item_versions set status='published', review_status='question_review_approved',
    approved_at=now(), approved_by=v_admin, published_at=now(), updated_at=now() where id=v_new;
  update app.content_items set status='published', updated_at=now() where id=v_item.id;
end $$;

-- =============================================================================
-- Part 2: apcalcab-mcq-np2-{001,005,006,007}, distractor-rationale sharpening.
-- =============================================================================

create temporary table repair_targets (
  content_key text primary key,
  source_decision_id uuid not null,
  assignment_id uuid not null
) on commit drop;

insert into repair_targets values
('apcalcab-mcq-np2-001','3a0ca3e6-aceb-47b7-ba7d-20f6423aa390'::uuid,gen_random_uuid()),
('apcalcab-mcq-np2-005','620f6772-7964-42b5-ad9b-71225f654775'::uuid,gen_random_uuid()),
('apcalcab-mcq-np2-006','c9ccfab8-84da-4da5-a414-60bbca89a3cc'::uuid,gen_random_uuid()),
('apcalcab-mcq-np2-007','6d3f710e-764f-48ef-90b6-1c330f516b4b'::uuid,gen_random_uuid());

create temporary table repaired (
  content_key text primary key,
  old_version_id uuid not null,
  new_version_id uuid not null,
  source_decision_id uuid not null,
  assignment_id uuid not null
) on commit drop;

do $$
declare
  t record;
  v_item app.content_items%rowtype;
  v_old app.content_item_versions%rowtype;
  v_new uuid;
begin
  for t in select * from repair_targets order by content_key loop
    select * into strict v_item from app.content_items
    where content_key=t.content_key and item_type='mcq' for update;

    select * into strict v_old from app.content_item_versions
    where content_item_id=v_item.id and status='published'
    order by version_num desc limit 1 for update;

    v_new := gen_random_uuid();

    update app.content_item_versions set status='retired', updated_at=now() where id=v_old.id;
    update app.content_items set status='draft', updated_at=now() where id=v_item.id;

    insert into app.content_item_versions (
      id,content_item_id,version_num,stem,stimulus,prompt_json,
      explanation,help_text,content_hash,status,created_by,
      canonical_answer_1,canonical_answer_2,review_status,
      rubric_type,evaluator_strategy,stimulus_image_path
    ) values (
      v_new,v_item.id,v_old.version_num+1,v_old.stem,v_old.stimulus,
      coalesce(v_old.prompt_json,'{}'::jsonb) || jsonb_build_object(
        'content_version',v_old.version_num+1,
        'qa_remediation','2026-08-09 Abdul np2 QA sweep -- distractor rationale sharpened',
        'qa_source_decision_id',t.source_decision_id
      ),
      v_old.explanation,v_old.help_text,md5(coalesce(v_old.stem,'')),
      'draft','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
      v_old.canonical_answer_1,v_old.canonical_answer_2,null,
      v_old.rubric_type,v_old.evaluator_strategy,v_old.stimulus_image_path
    );

    insert into app.mcq_choices (content_item_version_id,choice_key,choice_text,is_correct,rationale)
    select v_new,choice_key,choice_text,is_correct,rationale
    from app.mcq_choices where content_item_version_id=v_old.id;

    insert into repaired values (t.content_key,v_old.id,v_new,t.source_decision_id,t.assignment_id);
  end loop;
end $$;

-- Per-item repairs. Values recomputed and verified independently this session
-- (not read from Abdul's note and trusted); see the header comment.

update app.mcq_choices m
set rationale='Incorrect. Stacks two separate errors: treating dV/dr as proportional to r rather than r^2 (as in B) and dropping the coefficient 4 (as in C), i.e. dV/dr=pi*r instead of 4*pi*r^2: pi(3)(2)=6*pi.'
from repaired r where r.content_key='apcalcab-mcq-np2-001' and m.content_item_version_id=r.new_version_id and m.choice_key='D';

update app.mcq_choices m
set rationale='Incorrect. Uses the right endpoint''s x-value (3) as the width of the [1,3] subinterval instead of its actual width (3-1=2): (1)(5)+(3)(9)+(1)(10)=42.'
from repaired r where r.content_key='apcalcab-mcq-np2-005' and m.content_item_version_id=r.new_version_id and m.choice_key='D';

update app.mcq_choices m
set choice_text='e', rationale='Incorrect. Omits the initial condition when solving for the constant of integration: setting C=0 instead of C=ln 3 gives y=e^(x^2), so y(1)=e -- a common error of forgetting to apply y(0)=3.'
from repaired r where r.content_key='apcalcab-mcq-np2-006' and m.content_item_version_id=r.new_version_id and m.choice_key='C';

update app.mcq_choices m
set rationale='Incorrect. Averages the two endpoint function values as if g were linear, instead of computing the actual average value: (g(0)+g(6))/2=(0+36)/2=18.'
from repaired r where r.content_key='apcalcab-mcq-np2-007' and m.content_item_version_id=r.new_version_id and m.choice_key='D';

update app.content_item_versions civ
set content_hash=md5(coalesce(civ.stem,'')||E'\n'||coalesce(civ.stimulus,'')||E'\n'||
  coalesce((select string_agg(m.choice_key||':'||m.choice_text||':'||m.is_correct::text||':'||coalesce(m.rationale,''), E'\n' order by m.choice_key)
            from app.mcq_choices m where m.content_item_version_id=civ.id),''))
from repaired r where civ.id=r.new_version_id;

insert into app.content_review_assignments (
  content_review_assignment_id, content_item_version_id, reviewer_id,
  review_stage, review_kind, status, assignment_purpose, created_by
)
select assignment_id,new_version_id,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
       'tutor_question','mcq','pending','owner_remediation_approval','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from repaired;

insert into app.content_review_decisions (
  content_review_assignment_id,content_item_version_id,reviewer_id,
  supersedes_id,review_stage,tutor_score,difficulty_label,diagnostic_flag,
  concern_codes,note,topic_selections,tutor_decision,decision_payload,
  decision_hash,created_by
)
select r.assignment_id,r.new_version_id,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
       r.source_decision_id,'tutor_question',1,
       coalesce(src.difficulty_label,'Hard'),false,array[]::text[],
       'AP Calc AB MCQ distractor-rationale repair applied and owner QA verified against Abdul Hanan''s 2026-08-08 np2 approve_with_edits notes.',
       src.topic_selections,'approve',
       jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apcalcab_np2_abdul_qa_repair','source_review_decision_id',r.source_decision_id,'qa_date','2026-08-09'),
       encode(extensions.digest(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apcalcab_np2_abdul_qa_repair','source_review_decision_id',r.source_decision_id,'qa_date','2026-08-09')::text,'sha256'),'hex'),
       'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from repaired r
join app.content_review_decisions src on src.content_review_decision_id=r.source_decision_id;

create temporary table qa_blocked as
select r.content_key,
  case
    when nullif(trim(civ.stem),'') is null then 'blank stem'
    when (select count(*) from app.mcq_choices m where m.content_item_version_id=civ.id)<>4 then 'choice count'
    when (select count(distinct lower(trim(m.choice_text))) from app.mcq_choices m where m.content_item_version_id=civ.id)<>4 then 'duplicate choice text'
    when (select count(*) from app.mcq_choices m where m.content_item_version_id=civ.id and m.is_correct)<>1 then 'correct key count'
    when exists (select 1 from app.mcq_choices m where m.content_item_version_id=civ.id and nullif(trim(coalesce(m.rationale,'')),'') is null) then 'blank rationale'
    when exists (select 1 from app.content_item_versions other where other.content_item_id=civ.content_item_id and other.id<>civ.id and other.status='published') then 'competing published version'
  end reason
from repaired r
join app.content_item_versions civ on civ.id=r.new_version_id;
delete from qa_blocked where reason is null;

create temporary table approve_set on commit drop as
select r.content_key, r.new_version_id
from repaired r
where not exists (select 1 from qa_blocked b where b.content_key=r.content_key);

update app.content_item_versions civ
set status='reviewed_approved', review_status='question_review_approved',
    approved_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
    approved_at=coalesce(civ.approved_at,now()), updated_at=now()
from approve_set p where civ.id=p.new_version_id;

update app.content_items ci
set status='reviewed_approved', updated_at=now()
from approve_set p join app.content_item_versions civ on civ.id=p.new_version_id
where ci.id=civ.content_item_id;

update app.content_item_versions civ
set status='published', review_status='question_review_approved',
    approved_by=coalesce(civ.approved_by,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid),
    approved_at=coalesce(civ.approved_at,now()), published_at=coalesce(civ.published_at,now()),
    updated_at=now()
from approve_set p where civ.id=p.new_version_id;

update app.content_items ci
set status='published', updated_at=now()
from approve_set p join app.content_item_versions civ on civ.id=p.new_version_id
where ci.id=civ.content_item_id;

do $$
declare n integer;
begin
  select count(*) into n from repaired;
  if n<>4 then raise exception 'expected 4 repaired AP Calc AB np2 MCQs, got %', n; end if;

  select count(*) into n from qa_blocked;
  if n<>0 then raise exception 'AP Calc AB np2 MCQ repair blocked by structural QA gate: %',
    (select string_agg(content_key||':'||reason, ', ' order by content_key) from qa_blocked);
  end if;

  select count(*) into n from (
    select content_item_id from app.content_item_versions where status='published'
    group by content_item_id having count(*)>1
  ) d;
  if n<>0 then raise exception 'duplicate published versions after AP Calc AB np2 MCQ repair: %', n; end if;
end $$;

select 'repaired_mcq' metric, count(*)::text value from repaired
union all select 'published_mcq', count(*)::text from approve_set
union all select 'qa_blocked', count(*)::text from qa_blocked
union all select 'published_keys', string_agg(content_key, ', ' order by content_key) from approve_set;

commit;
