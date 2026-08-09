-- Tier 1 QA sweep repair: genuine content defects across the changes_requested
-- backlog, 2026-08-09. See docs/Q&A/CHANGES_REQUESTED_QA_2026_08_09.md for the
-- full independent re-derivation behind each fix.
--
-- Scope: 11 of 13 items originally triaged as Tier 1 "genuine defect" (not
-- rubric-granularity or wording-precision). apcalcab-mcq-048 and
-- apcalcab-mcq-049 are EXCLUDED here -- extensive independent re-derivation
-- (Fresnel-integral-level computation for -049; multiple mechanism attempts
-- for -048's three unconfirmed distractors) could not cleanly reproduce a
-- correct mechanism for their flagged distractors, and per protocol
-- (never repair on an unverified basis) they are left in changes_requested,
-- flagged for full author-level reconstruction rather than a spot-fix.
--
-- Each item: independently re-derived the correct answer AND each flagged
-- distractor's actual reproducible value/mechanism from scratch (not read
-- from the reviewer's note and trusted) before writing the fix. Per-item
-- math is documented in the QA sweep doc; this script applies the results.

begin;
select pg_advisory_xact_lock(hashtext('cramapple-tier1-genuine-defects-20260809'));

-- =============================================================================
-- 1) APBIO-FRQ-S-068 -- clownfish/anemone is scientifically mutualistic, not
--    commensal as the stem requires students to conclude. Replaced with a
--    genuinely commensal example (barnacles on whales).
-- =============================================================================
do $$
declare
  v_admin uuid := 'f5a26c6b-3566-4d58-9e97-979fbb947564';
  v_item app.content_items%rowtype;
  v_old app.content_item_versions%rowtype;
  v_new uuid := gen_random_uuid();
  v_assignment uuid := gen_random_uuid();
begin
  select * into strict v_item from app.content_items where content_key='APBIO-FRQ-S-068' for update;
  select * into strict v_old from app.content_item_versions
  where content_item_id=v_item.id order by version_num desc limit 1 for update;

  update app.content_item_versions set status='retired', updated_at=now() where id=v_old.id;

  insert into app.content_item_versions (
    id,content_item_id,version_num,stem,stimulus,prompt_json,
    explanation,help_text,content_hash,status,created_by,
    canonical_answer_1,canonical_answer_2,review_status,
    rubric_type,evaluator_strategy,stimulus_image_path
  ) values (
    v_new,v_item.id,v_old.version_num+1,
    'Barnacles attach to the skin of whales. The barnacles gain access to nutrient-rich waters as the whale swims; the whale is neither helped nor harmed by their presence.',
    v_old.stimulus,
    coalesce(v_old.prompt_json,'{}'::jsonb) || jsonb_build_object(
      'content_version',v_old.version_num+1,
      'qa_remediation','2026-08-09 changes_requested QA sweep -- replaced non-commensal example (clownfish/anemone is mutualistic)'
    ),
    v_old.explanation,v_old.help_text,md5('APBIO-FRQ-S-068-v'||(v_old.version_num+1)),
    'draft',v_admin,
    v_old.canonical_answer_1,v_old.canonical_answer_2,null,
    v_old.rubric_type,v_old.evaluator_strategy,v_old.stimulus_image_path
  );

  insert into app.frq_criteria (
    content_item_version_id,criterion_key,learner_facing_text,points_possible,evidence_requirements,minimum_fix,accepted_variants
  )
  select v_new,criterion_key,learner_facing_text,points_possible,evidence_requirements,minimum_fix,accepted_variants
  from app.frq_criteria where content_item_version_id=v_old.id;

  update app.frq_criteria
  set learner_facing_text='Classify the relationship between barnacle and whale and justify your answer.',
      evidence_requirements='States commensalism (+/0); barnacles benefit from improved feeding access, whale is neither helped nor harmed.',
      minimum_fix='This is commensalism: the barnacles benefit by gaining access to nutrient-rich waters as the whale swims, and the whale is unaffected.'
  where content_item_version_id=v_new and criterion_key='a';

  update app.content_item_versions civ
  set content_hash=md5(
    coalesce(civ.stem,'')||E'\n'||coalesce(civ.stimulus,'')||E'\n'||
    coalesce((select string_agg(f.criterion_key||':'||f.points_possible::text||':'||f.learner_facing_text||':'||
      coalesce(f.evidence_requirements,'')||':'||coalesce(f.minimum_fix,''), E'\n' order by f.criterion_key)
      from app.frq_criteria f where f.content_item_version_id=civ.id),'')
  ) where civ.id=v_new;

  insert into app.content_review_assignments (
    content_review_assignment_id,content_item_version_id,reviewer_id,review_stage,review_kind,status,assignment_purpose,created_by
  ) values (v_assignment,v_new,v_admin,'tutor_question','frq','pending','owner_remediation_approval',v_admin);

  insert into app.content_review_decisions (
    content_review_assignment_id,content_item_version_id,reviewer_id,review_stage,tutor_score,difficulty_label,
    diagnostic_flag,concern_codes,note,tutor_decision,decision_payload,decision_hash,created_by
  ) values (
    v_assignment,v_new,v_admin,'tutor_question',1,'Medium',false,array[]::text[],
    'owner_remediation_approval: replaced clownfish/anemone (scientifically mutualistic, not commensal) with barnacle/whale, a genuinely commensal relationship. Per Adil Abbasi''s 2026-08 accuracy flag.',
    'approve',
    jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','changes_requested_qa_sweep_tier1','qa_date','2026-08-09'),
    encode(extensions.digest('APBIO-FRQ-S-068-fix-20260809','sha256'),'hex'),v_admin
  );

  update app.content_item_versions set status='reviewed_approved', review_status='question_review_approved',
    approved_at=now(), approved_by=v_admin, updated_at=now() where id=v_new;
  update app.content_items set status='reviewed_approved', updated_at=now() where id=v_item.id;
end $$;

-- =============================================================================
-- 2) apchem-sfrq-003 -- missing standard-state degree symbols throughout;
--    criteria state formula+answer but not the substituted computation;
--    standard-state description imprecise ("1 atm" instead of activities).
--    All underlying chemistry independently re-verified correct (dG=-48.2
--    kJ/mol, K=2.9e8) -- this is a precision/completeness fix, not a
--    correctness fix.
-- =============================================================================
do $$
declare
  v_admin uuid := 'f5a26c6b-3566-4d58-9e97-979fbb947564';
  v_item app.content_items%rowtype;
  v_old app.content_item_versions%rowtype;
  v_new uuid := gen_random_uuid();
  v_assignment uuid := gen_random_uuid();
begin
  select * into strict v_item from app.content_items where content_key='apchem-sfrq-003' for update;
  select * into strict v_old from app.content_item_versions
  where content_item_id=v_item.id order by version_num desc limit 1 for update;

  update app.content_item_versions set status='retired', updated_at=now() where id=v_old.id;

  insert into app.content_item_versions (
    id,content_item_id,version_num,stem,stimulus,prompt_json,
    explanation,help_text,content_hash,status,created_by,
    canonical_answer_1,canonical_answer_2,review_status,
    rubric_type,evaluator_strategy,stimulus_image_path
  ) values (
    v_new,v_item.id,v_old.version_num+1,
    'Answer all parts of the following question.'||E'\n\n'||
    '(a) Calculate ΔG° and connect its sign to spontaneity.'||E'\n\n'||
    '(b) Explain how the relationship ΔG°=−nFE° connects the standard cell potential to the standard free energy change, and state the standard-state assumptions (unit activities: approximately 1 M for solutes, 1 bar for gases, at 25°C).'||E'\n\n'||
    '(c) Calculate the equilibrium constant K for this cell reaction at 25°C using the relationship between ΔG°, E°, and K.'||E'\n\n'||
    '(d) Explain why doubling all the stoichiometric coefficients of the balanced cell reaction (while E° stays the same) would double ΔG° but leave E° unchanged.',
    v_old.stimulus,
    coalesce(v_old.prompt_json,'{}'::jsonb) || jsonb_build_object(
      'content_version',v_old.version_num+1,
      'qa_remediation','2026-08-09 changes_requested QA sweep -- degree symbols, substituted values, standard-state precision'
    ),
    v_old.explanation,v_old.help_text,md5('apchem-sfrq-003-v'||(v_old.version_num+1)),
    'draft',v_admin,
    v_old.canonical_answer_1,v_old.canonical_answer_2,null,
    v_old.rubric_type,v_old.evaluator_strategy,v_old.stimulus_image_path
  );

  insert into app.frq_criteria (
    content_item_version_id,criterion_key,learner_facing_text,points_possible,evidence_requirements,minimum_fix,accepted_variants
  )
  select v_new,criterion_key,learner_facing_text,points_possible,evidence_requirements,minimum_fix,accepted_variants
  from app.frq_criteria where content_item_version_id=v_old.id;

  update app.frq_criteria set
    learner_facing_text='ΔG°=−nFE°=−(2)(96,485 C/mol)(0.250 V)≈−48.2 kJ/mol, so the standard reaction is favorable.',
    evidence_requirements='Response substitutes n, F, and E° into ΔG°=−nFE°, shows the computation, and connects the negative sign to spontaneity.',
    minimum_fix='To earn this point, show ΔG°=−(2)(96,485)(0.250)≈−48.2 kJ/mol and state the reaction is spontaneous under standard conditions.'
  where content_item_version_id=v_new and criterion_key='part-a';

  update app.frq_criteria set
    learner_facing_text='ΔG°=−nFE° converts the standard cell potential into standard free energy, assuming standard-state conditions (unit activities: ~1 M for solutes, 1 bar for gases, at 25°C) hold.',
    evidence_requirements='Response explains the ΔG°=−nFE° relationship and states the standard-state assumption using activities, not "1 atm".',
    minimum_fix='To earn this point, cite ΔG°=−nFE° and the standard-state assumption (unit activities, 25°C).'
  where content_item_version_id=v_new and criterion_key='part-b';

  update app.frq_criteria set
    learner_facing_text='K=e^(nFE°/RT)=e^((2)(96,485)(0.250)/((8.314)(298.15)))≈2.9×10^8 (very large, consistent with a spontaneous, product-favored reaction).',
    evidence_requirements='Response substitutes n, F, E°, R, T into K=e^(nFE°/RT) or ΔG°=−RTlnK, shows the computation, and obtains K on the order of 10^8.',
    minimum_fix='To earn this point, show K=e^(nFE°/RT)≈2.9×10^8 (accept 10^8–10^9 range).'
  where content_item_version_id=v_new and criterion_key='part-c';

  update app.frq_criteria set
    learner_facing_text='E° is intensive (per mole of electrons transferred) and unaffected by scaling the equation, while ΔG° is extensive and scales directly with n.',
    evidence_requirements='Response correctly distinguishes E° (intensive, unchanged) from ΔG° (extensive, doubles) when coefficients double.',
    minimum_fix='To earn this point, state that E° stays the same (intensive) while ΔG° doubles (extensive, since ΔG°=−nFE° and n doubles).'
  where content_item_version_id=v_new and criterion_key='part-d';

  update app.content_item_versions civ
  set content_hash=md5(
    coalesce(civ.stem,'')||E'\n'||coalesce(civ.stimulus,'')||E'\n'||
    coalesce((select string_agg(f.criterion_key||':'||f.points_possible::text||':'||f.learner_facing_text||':'||
      coalesce(f.evidence_requirements,'')||':'||coalesce(f.minimum_fix,''), E'\n' order by f.criterion_key)
      from app.frq_criteria f where f.content_item_version_id=civ.id),'')
  ) where civ.id=v_new;

  insert into app.content_review_assignments (
    content_review_assignment_id,content_item_version_id,reviewer_id,review_stage,review_kind,status,assignment_purpose,created_by
  ) values (v_assignment,v_new,v_admin,'tutor_question','frq','pending','owner_remediation_approval',v_admin);

  insert into app.content_review_decisions (
    content_review_assignment_id,content_item_version_id,reviewer_id,review_stage,tutor_score,difficulty_label,
    diagnostic_flag,concern_codes,note,tutor_decision,decision_payload,decision_hash,created_by
  ) values (
    v_assignment,v_new,v_admin,'tutor_question',1,'Medium',false,array[]::text[],
    'owner_remediation_approval: added degree symbols, substituted-value computations, and precise standard-state language per Gulgeldi Darrynow, Muhammad Zeeshan, and Muhammad Saood''s independent notes. Chemistry re-verified correct (dG=-48.2kJ/mol, K=2.9e8); this is a precision fix.',
    'approve',
    jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','changes_requested_qa_sweep_tier1','qa_date','2026-08-09'),
    encode(extensions.digest('apchem-sfrq-003-fix-20260809','sha256'),'hex'),v_admin
  );

  update app.content_item_versions set status='reviewed_approved', review_status='question_review_approved',
    approved_at=now(), approved_by=v_admin, updated_at=now() where id=v_new;
  update app.content_items set status='reviewed_approved', updated_at=now() where id=v_item.id;
end $$;

-- =============================================================================
-- 3) apchem-sfrq-036 -- missing degree symbols on DeltaH/DeltaS/DeltaG (standard
--    conditions at 298K are specified); criterion a2 oversimplifies the
--    entropy justification (Saood: doesn't address hydration's ordering
--    effect on nearby water).
-- =============================================================================
do $$
declare
  v_admin uuid := 'f5a26c6b-3566-4d58-9e97-979fbb947564';
  v_item app.content_items%rowtype;
  v_old app.content_item_versions%rowtype;
  v_new uuid := gen_random_uuid();
  v_assignment uuid := gen_random_uuid();
begin
  select * into strict v_item from app.content_items where content_key='apchem-sfrq-036' for update;
  select * into strict v_old from app.content_item_versions
  where content_item_id=v_item.id order by version_num desc limit 1 for update;

  update app.content_item_versions set status='retired', updated_at=now() where id=v_old.id;

  insert into app.content_item_versions (
    id,content_item_id,version_num,stem,stimulus,prompt_json,
    explanation,help_text,content_hash,status,created_by,
    canonical_answer_1,canonical_answer_2,review_status,
    rubric_type,evaluator_strategy,stimulus_image_path
  ) values (
    v_new,v_item.id,v_old.version_num+1,
    'Solid ammonium nitrate dissolves in water according to the equation below. This process is the basis for single-use instant cold packs, which feel cold to the touch as the solid dissolves.'||E'\n\n'||
    'NH4NO3(s) -> NH4+(aq) + NO3-(aq)'||E'\n\n'||
    '(a) Predict the sign of ΔS° for this process and justify your prediction in terms of the particles present before and after dissolution.'||E'\n\n'||
    '(b) The dissolution of NH4NO3(s) is endothermic (ΔH°>0) yet occurs spontaneously at room temperature. Using the relationship ΔG°=ΔH°−TΔS°, explain why this process is thermodynamically favorable at 298 K despite being endothermic.',
    v_old.stimulus,
    coalesce(v_old.prompt_json,'{}'::jsonb) || jsonb_build_object(
      'content_version',v_old.version_num+1,
      'qa_remediation','2026-08-09 changes_requested QA sweep -- degree symbols; entropy justification sharpened for hydration effect'
    ),
    v_old.explanation,v_old.help_text,md5('apchem-sfrq-036-v'||(v_old.version_num+1)),
    'draft',v_admin,
    v_old.canonical_answer_1,v_old.canonical_answer_2,null,
    v_old.rubric_type,v_old.evaluator_strategy,v_old.stimulus_image_path
  );

  insert into app.frq_criteria (
    content_item_version_id,criterion_key,learner_facing_text,points_possible,evidence_requirements,minimum_fix,accepted_variants
  )
  select v_new,criterion_key,learner_facing_text,points_possible,evidence_requirements,minimum_fix,accepted_variants
  from app.frq_criteria where content_item_version_id=v_old.id;

  update app.frq_criteria set
    learner_facing_text='Justifies the sign by noting that the net increase in entropy from crystal-lattice disruption and dispersal of the solid into two moles of mobile aqueous ions exceeds any ordering of nearby water molecules caused by hydration.',
    evidence_requirements='Justifies the sign by noting that the net increase in entropy from crystal-lattice disruption and ion dispersal exceeds hydration''s ordering effect on surrounding water.',
    minimum_fix='To earn this point, explicitly show: the net entropy increase from lattice disruption and ion dispersal exceeds any hydration-caused ordering of water.'
  where content_item_version_id=v_new and criterion_key='a2';

  update app.frq_criteria set
    learner_facing_text='Identifies that because ΔS°>0, the −TΔS° term is negative, and at 298 K this term is large enough in magnitude to outweigh the positive ΔH° term.',
    evidence_requirements='Identifies that because ΔS°>0, the −TΔS° term is negative, and at 298 K this term is large enough in magnitude to outweigh the positive ΔH° term.',
    minimum_fix='To earn this point, explicitly show: because ΔS°>0, the −TΔS° term is negative, and at 298 K this term outweighs the positive ΔH° term.'
  where content_item_version_id=v_new and criterion_key='b1';

  update app.frq_criteria set
    learner_facing_text='Concludes that the combination of these terms makes ΔG°<0, so the process is thermodynamically favorable at room temperature even though it absorbs heat.',
    evidence_requirements='Concludes that the combination of these terms makes ΔG°<0, so the process is thermodynamically favorable at room temperature even though it absorbs heat.',
    minimum_fix='To earn this point, explicitly show: the combination of terms makes ΔG°<0, so the process is favorable despite being endothermic.'
  where content_item_version_id=v_new and criterion_key='b2';

  update app.content_item_versions civ
  set content_hash=md5(
    coalesce(civ.stem,'')||E'\n'||coalesce(civ.stimulus,'')||E'\n'||
    coalesce((select string_agg(f.criterion_key||':'||f.points_possible::text||':'||f.learner_facing_text||':'||
      coalesce(f.evidence_requirements,'')||':'||coalesce(f.minimum_fix,''), E'\n' order by f.criterion_key)
      from app.frq_criteria f where f.content_item_version_id=civ.id),'')
  ) where civ.id=v_new;

  insert into app.content_review_assignments (
    content_review_assignment_id,content_item_version_id,reviewer_id,review_stage,review_kind,status,assignment_purpose,created_by
  ) values (v_assignment,v_new,v_admin,'tutor_question','frq','pending','owner_remediation_approval',v_admin);

  insert into app.content_review_decisions (
    content_review_assignment_id,content_item_version_id,reviewer_id,review_stage,tutor_score,difficulty_label,
    diagnostic_flag,concern_codes,note,tutor_decision,decision_payload,decision_hash,created_by
  ) values (
    v_assignment,v_new,v_admin,'tutor_question',1,'Medium',false,array[]::text[],
    'owner_remediation_approval: added degree symbols per Gulgeldi Darrynow; sharpened a2 entropy justification for hydration-ordering nuance per Muhammad Saood.',
    'approve',
    jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','changes_requested_qa_sweep_tier1','qa_date','2026-08-09'),
    encode(extensions.digest('apchem-sfrq-036-fix-20260809','sha256'),'hex'),v_admin
  );

  update app.content_item_versions set status='reviewed_approved', review_status='question_review_approved',
    approved_at=now(), approved_by=v_admin, updated_at=now() where id=v_new;
  update app.content_items set status='reviewed_approved', updated_at=now() where id=v_item.id;
end $$;

-- =============================================================================
-- 4) MCQ distractor repairs -- apcalcab-mcq-036, 040, 044, 045, 047, 050, and
--    apphycem-mcq-np1-006. Each rationale/value pair below was independently
--    re-derived (see QA sweep doc for full per-item math); only choices with
--    a confirmed mismatch are touched.
-- =============================================================================

create temporary table mcq_repair_targets (content_key text primary key, assignment_id uuid not null) on commit drop;
insert into mcq_repair_targets values
('apcalcab-mcq-036',gen_random_uuid()),
('apcalcab-mcq-040',gen_random_uuid()),
('apcalcab-mcq-044',gen_random_uuid()),
('apcalcab-mcq-045',gen_random_uuid()),
('apcalcab-mcq-047',gen_random_uuid()),
('apcalcab-mcq-050',gen_random_uuid()),
('apphycem-mcq-np1-006',gen_random_uuid());

create temporary table mcq_repaired (
  content_key text primary key, old_version_id uuid not null, new_version_id uuid not null, assignment_id uuid not null
) on commit drop;

do $$
declare
  t record;
  v_item app.content_items%rowtype;
  v_old app.content_item_versions%rowtype;
  v_new uuid;
begin
  for t in select * from mcq_repair_targets order by content_key loop
    select * into strict v_item from app.content_items where content_key=t.content_key and item_type='mcq' for update;
    select * into strict v_old from app.content_item_versions
    where content_item_id=v_item.id order by version_num desc limit 1 for update;

    v_new := gen_random_uuid();

    update app.content_item_versions set status='retired', updated_at=now() where id=v_old.id;

    insert into app.content_item_versions (
      id,content_item_id,version_num,stem,stimulus,prompt_json,
      explanation,help_text,content_hash,status,created_by,
      canonical_answer_1,canonical_answer_2,review_status,
      rubric_type,evaluator_strategy,stimulus_image_path
    ) values (
      v_new,v_item.id,v_old.version_num+1,v_old.stem,v_old.stimulus,
      coalesce(v_old.prompt_json,'{}'::jsonb) || jsonb_build_object(
        'content_version',v_old.version_num+1,
        'qa_remediation','2026-08-09 changes_requested QA sweep Tier 1 -- distractor mismatch repair'
      ),
      v_old.explanation,v_old.help_text,md5(t.content_key||'-v'||(v_old.version_num+1)),
      'draft','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
      v_old.canonical_answer_1,v_old.canonical_answer_2,null,
      v_old.rubric_type,v_old.evaluator_strategy,v_old.stimulus_image_path
    );

    insert into app.mcq_choices (content_item_version_id,choice_key,choice_text,is_correct,rationale)
    select v_new,choice_key,choice_text,is_correct,rationale from app.mcq_choices where content_item_version_id=v_old.id;

    insert into mcq_repaired values (t.content_key,v_old.id,v_new,t.assignment_id);
  end loop;
end $$;

-- apcalcab-mcq-036: MVT for f(x)=x^2 on [1,3]. c=2 is correct (verified: f'(c)=(f(3)-f(1))/2=4, 2c=4).
-- Original B=3/2 rationale ("midpoint of the output values") does not reproduce 3/2
-- (midpoint of outputs is 5, giving c=sqrt(5), not 3/2) -- no clean path to 3/2 found
-- after exhaustive attempts. Replaced with a verified common error: reporting the
-- average rate of change itself (4) as if it were the c-value, skipping the "solve
-- for c" step entirely.
update app.mcq_choices m
set choice_text='4', rationale='Incorrect. Reports the average rate of change itself (4) as if it were the guaranteed c-value, without solving f''(c)=4 for c: 2c=4 is skipped.'
from mcq_repaired r where r.content_key='apcalcab-mcq-036' and m.content_item_version_id=r.new_version_id and m.choice_key='B';

-- apcalcab-mcq-040: right Riemann sum with widths (0.7,1.2,1.1) and right values
-- (2.8,1.6,3.4) = 7.62 (keyed D, confirmed correct).
-- A=6.20 ("incorrect interval widths") and B=7.56 ("equally spaced") do not
-- reproduce their claimed mechanisms. C=8.04 ("left endpoint") does not match a
-- correct-width left sum either. All three independently recomputed:
update app.mcq_choices m
set choice_text='6.5', rationale='Incorrect. Uses the LEFT Riemann sum treating the three subintervals as equally spaced (width 1 each): 1(2.1)+1(2.8)+1(1.6)=6.5.'
from mcq_repaired r where r.content_key='apcalcab-mcq-040' and m.content_item_version_id=r.new_version_id and m.choice_key='A';
update app.mcq_choices m
set choice_text='7.8', rationale='Incorrect. Treats the three subintervals as equally spaced (width 1 each) with right-endpoint values: 1(2.8)+1(1.6)+1(3.4)=7.8.'
from mcq_repaired r where r.content_key='apcalcab-mcq-040' and m.content_item_version_id=r.new_version_id and m.choice_key='B';
update app.mcq_choices m
set choice_text='6.59', rationale='Incorrect. Uses the LEFT Riemann sum with the correct nonuniform widths: 0.7(2.1)+1.2(2.8)+1.1(1.6)=6.59.'
from mcq_repaired r where r.content_key='apcalcab-mcq-040' and m.content_item_version_id=r.new_version_id and m.choice_key='C';

-- apcalcab-mcq-044: average value of e^(-x^2) on [0,1.6] = 0.541 (keyed D, confirmed
-- correct via numerical integration). B=0.866's rationale ("left endpoint as
-- constant," which would give exactly 1.0) does not match; 0.866 is actually the
-- raw definite integral (~0.865) reported without dividing by the interval length.
update app.mcq_choices m
set rationale='Incorrect. Reports the raw definite integral (approximately 0.865) without dividing by the interval length 1.6, rather than computing the average value.'
from mcq_repaired r where r.content_key='apcalcab-mcq-044' and m.content_item_version_id=r.new_version_id and m.choice_key='B';

-- apcalcab-mcq-045: Euler's method, y'=x+y, y(0)=1, h=0.5. y(1)=2.5 (keyed A,
-- confirmed correct). C=1.75's rationale ("uses the initial slope for both
-- steps") actually reproduces 2.0 (=B), not 1.75 -- confirmed mismatch. 1.75 is
-- exactly reproduced by one step of the improved-Euler (Heun's) method, mistakenly
-- reported as the final answer instead of continuing to a second step.
update app.mcq_choices m
set rationale='Incorrect. Uses one step of the improved-Euler (Heun''s) method and stops: predictor y=1.5, corrected slope=(1+2.0)/2=1.5, giving y(0.5)=1+0.5(1.5)=1.75, mistakenly reported as y(1).'
from mcq_repaired r where r.content_key='apcalcab-mcq-045' and m.content_item_version_id=r.new_version_id and m.choice_key='C';

-- apcalcab-mcq-047: area between y=x and y=x^2 on [0,1] = 1/6 (keyed C, confirmed
-- correct). B=1/4 ("subtracts endpoint values") gives 0, not 1/4 -- replaced with
-- a verified mechanism. D=1/2 ("adds the two elementary areas") actually gives
-- 1/2+1/3=5/6, not 1/2 -- value corrected to match its own stated rationale.
update app.mcq_choices m
set choice_text='1/2', rationale='Incorrect. Computes only the area under the upper curve, integral of x dx from 0 to 1 = 1/2, forgetting to subtract the area under y=x^2 entirely.'
from mcq_repaired r where r.content_key='apcalcab-mcq-047' and m.content_item_version_id=r.new_version_id and m.choice_key='B';
update app.mcq_choices m
set choice_text='5/6'
from mcq_repaired r where r.content_key='apcalcab-mcq-047' and m.content_item_version_id=r.new_version_id and m.choice_key='D';

-- apcalcab-mcq-050: arc length of y=x^2 from 0 to 1.4 = 2.520 (keyed B, confirmed
-- correct). A=2.800's rationale ("overlarge linear estimate") was vague and
-- unverifiable by chord length (2.409) or Manhattan distance (3.36); 2.800 is
-- exactly reproduced by doubling the horizontal interval length.
update app.mcq_choices m
set rationale='Incorrect. Doubles the horizontal interval length instead of computing arc length: 2(1.4)=2.800.'
from mcq_repaired r where r.content_key='apcalcab-mcq-050' and m.content_item_version_id=r.new_version_id and m.choice_key='A';

-- apphycem-mcq-np1-006: E inside a uniformly charged sphere at r=R/2 = rho*R/(6*eps0)
-- (keyed A, confirmed correct). D's rationale ("does not follow from the correct
-- formula") was generic; rho*R/(2*eps0) is exactly reproduced by conflating the
-- volume-charge sphere formula with the infinite-sheet formula E=sigma/(2*eps0),
-- substituting sigma=rho*R.
update app.mcq_choices m
set rationale='Incorrect. Conflates the volume-charge sphere formula with the infinite-sheet-of-charge formula E=sigma/(2*epsilon_0), substituting sigma=rho*R: rho*R/(2*epsilon_0).'
from mcq_repaired r where r.content_key='apphycem-mcq-np1-006' and m.content_item_version_id=r.new_version_id and m.choice_key='D';

-- Recompute content_hash for all repaired MCQ versions.
update app.content_item_versions civ
set content_hash=md5(coalesce(civ.stem,'')||E'\n'||coalesce(civ.stimulus,'')||E'\n'||
  coalesce((select string_agg(m.choice_key||':'||m.choice_text||':'||m.is_correct::text||':'||coalesce(m.rationale,''), E'\n' order by m.choice_key)
            from app.mcq_choices m where m.content_item_version_id=civ.id),''))
from mcq_repaired r where civ.id=r.new_version_id;

insert into app.content_review_assignments (
  content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by
)
select assignment_id,new_version_id,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
       'tutor_question','mcq','pending','owner_remediation_approval','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from mcq_repaired;

insert into app.content_review_decisions (
  content_review_assignment_id,content_item_version_id,reviewer_id,review_stage,tutor_score,difficulty_label,
  diagnostic_flag,concern_codes,note,tutor_decision,decision_payload,decision_hash,created_by
)
select r.assignment_id,r.new_version_id,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,'tutor_question',1,'Hard',false,array[]::text[],
  'owner_remediation_approval: distractor rationale/value mismatch independently re-derived and repaired. Tier 1 changes_requested QA sweep, 2026-08-09.',
  'approve',
  jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','changes_requested_qa_sweep_tier1','qa_date','2026-08-09'),
  encode(extensions.digest(r.content_key||'-tier1-fix-20260809','sha256'),'hex'),
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from mcq_repaired r;

-- Structural QA gate.
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
from mcq_repaired r
join app.content_item_versions civ on civ.id=r.new_version_id;
delete from qa_blocked where reason is null;

create temporary table approve_set on commit drop as
select r.content_key, r.new_version_id from mcq_repaired r
where not exists (select 1 from qa_blocked b where b.content_key=r.content_key);

update app.content_item_versions civ
set status='reviewed_approved', review_status='question_review_approved',
    approved_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, approved_at=coalesce(civ.approved_at,now()), updated_at=now()
from approve_set p where civ.id=p.new_version_id;

update app.content_items ci
set status='reviewed_approved', updated_at=now()
from approve_set p join app.content_item_versions civ on civ.id=p.new_version_id
where ci.id=civ.content_item_id;

do $$
declare n integer;
begin
  select count(*) into n from mcq_repaired;
  if n<>7 then raise exception 'expected 7 repaired MCQs, got %', n; end if;
  select count(*) into n from qa_blocked;
  if n<>0 then raise exception 'Tier 1 MCQ repair blocked by structural QA gate: %',
    (select string_agg(content_key||':'||reason, ', ' order by content_key) from qa_blocked);
  end if;
end $$;

select 'tier1_frq_reviewed_approved' as metric,
  count(*)::text as value
from app.content_items where content_key in ('APBIO-FRQ-S-068','apchem-sfrq-003','apchem-sfrq-036') and status='reviewed_approved'
union all
select 'tier1_mcq_reviewed_approved', count(*)::text from approve_set
union all
select 'tier1_mcq_blocked', count(*)::text from qa_blocked;

commit;
