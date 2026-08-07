-- Owner-adjudicated remediation batch, 2026-08-06 (session 2).
--
-- Three items adjudicated per docs/Q&A/REVIEWER_QA_SWEEP_2026_08_06.md
-- follow-ups. Each creates a new draft version (never edits a version
-- already exposed to a reviewer decision in place), retires the old
-- version, records an owner_remediation_approval decision referencing the
-- original flagging decision, and leaves the repaired version at
-- 'reviewed_approved' -- publishing apchem-sfrq-005's replacement (it is
-- currently live/published) is a separate, later action, same as the prior
-- AP Calc BC distractor batch.
--
-- 1. apchem-sfrq-005 (AP Chemistry, currently published v3): tie-break
--    adjudication upheld Muhammad Zeeshan's stoichiometry correction over
--    Gulgeldi Darrynow's clean approve. Stem (b) falsely claimed moles-acid
--    = moles-base at equivalence, which only holds for 1:1 titrant:analyte
--    stoichiometry; the item's own canonical_answer_1 already used the
--    general mole-ratio language, so only the stem needed the fix.
--
-- 2. apcalcbc-mcq-049 (AP Calculus BC, v1, reviewed_disapproved): folded
--    into the standing AP Calc BC distractor-repair batch
--    (scripts/content-seed/reviewer-qa-remediation/20260806_apcalcbc_mcq_distractor_repair.sql).
--    Muhammad Saood found a genuine two-valid-answer defect: since sin(x)'s
--    Maclaurin series has a zero 6th-degree coefficient, the degree-5 poly
--    IS the degree-6 poly, so both choice B (0.7^6/6!, the intended answer)
--    and choice C (0.7^7/7!, meant as a wrong "skipped a term" distractor)
--    are legitimate Lagrange bounds. Replaced C with 0.7^6/7! -- a power/
--    factorial mismatch that cannot arise from any legitimate remainder
--    derivation (a real n would pair x^(n+1) with (n+1)!). Also dropped the
--    "graphing calculator required" stimulus per Saood's note -- the item is
--    purely symbolic.
--
-- 3. apphy1-frq-047 (AP Physics 1, v1, reviewed_disapproved): folded into
--    the same standing batch (renamed AP Calc BC / Physics 1 remediation
--    batch per owner instruction). Saood's part (a) work/power derivation
--    was already correct (W=2240 J, P_avg=448 W); part (b)'s claim that
--    instantaneous power at t=5s (896 W) exceeds average power is only
--    guaranteed under constant acceleration, which the stimulus never
--    stated. Added "accelerating uniformly (constant acceleration)" to the
--    stimulus per Saood's exact suggested fix. No criteria change needed --
--    b-explanation was already written to match constant-acceleration
--    physics.
--
-- Owner instructions, 2026-08-06: "check apchem-sfrq-005 -- adjudicate as
-- tie breaker Zeeshan's stoichiometry correction should versus Gulgeldi's
-- clean approve" and "Fold Saood's distractor-rationale fixes into a
-- standing AP Calc BC / Physics 1 remediation batch."

begin;
select pg_advisory_xact_lock(hashtext('cramapple-owner-adjudicated-remediation-batch-20260806b'));

create temporary table repair_targets (
  content_key text primary key,
  item_type text not null,
  source_decision_id uuid not null,
  assignment_id uuid not null
) on commit drop;

insert into repair_targets values
('apchem-sfrq-005','frq','ff0e21fd-0000-0000-0000-000000000000'::uuid,gen_random_uuid()),
('apcalcbc-mcq-049','mcq','00000000-0000-0000-0000-000000000000'::uuid,gen_random_uuid()),
('apphy1-frq-047','frq','00000000-0000-0000-0000-000000000000'::uuid,gen_random_uuid());

create temporary table repaired (
  content_key text primary key,
  old_version_id uuid not null,
  new_version_id uuid not null,
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
    select * into strict v_item
    from app.content_items
    where content_key=t.content_key and item_type=t.item_type
    for update;

    select * into strict v_old
    from app.content_item_versions
    where content_item_id=v_item.id
      and not exists (
        select 1 from app.content_item_versions newer
        where newer.content_item_id=app.content_item_versions.content_item_id
          and newer.version_num>app.content_item_versions.version_num
      )
    order by version_num desc, created_at desc
    limit 1
    for update;

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
      v_new,v_item.id,v_old.version_num+1,v_old.stem,v_old.stimulus,
      coalesce(v_old.prompt_json,'{}'::jsonb) || jsonb_build_object(
        'content_version',v_old.version_num+1,
        'qa_remediation','2026-08-06 owner-adjudicated remediation batch'
      ),
      v_old.explanation,v_old.help_text,md5(coalesce(v_old.stem,'')),
      'draft','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
      v_old.canonical_answer_1,v_old.canonical_answer_2,null,
      v_old.rubric_type,v_old.evaluator_strategy,v_old.stimulus_image_path
    );

    if t.item_type='mcq' then
      insert into app.mcq_choices (
        content_item_version_id,choice_key,choice_text,is_correct,rationale
      )
      select v_new,choice_key,choice_text,is_correct,rationale
      from app.mcq_choices
      where content_item_version_id=v_old.id;
    else
      insert into app.frq_criteria (
        content_item_version_id,criterion_key,learner_facing_text,
        points_possible,evidence_requirements,minimum_fix,accepted_variants
      )
      select v_new,criterion_key,learner_facing_text,
        points_possible,evidence_requirements,minimum_fix,accepted_variants
      from app.frq_criteria
      where content_item_version_id=v_old.id;
    end if;

    insert into repaired values (t.content_key,v_old.id,v_new,t.assignment_id);
  end loop;
end $$;

-- 1. apchem-sfrq-005: remove the false 1:1-equivalence claim from stem (b).
update app.content_item_versions civ
set stem = replace(
  stem,
  '(b) Explain how stoichiometric equivalence (moles of acid equal moles of base at the equivalence point) supports the titration calculation, and state the assumption that the indicator changes color at the true equivalence point.',
  '(b) Explain how stoichiometric equivalence -- relating moles of titrant to moles of analyte through the mole ratio in the balanced equation -- supports the titration calculation, and state the assumption that the indicator endpoint approximates the true equivalence point.'
)
from repaired r where r.content_key='apchem-sfrq-005' and civ.id=r.new_version_id;

-- 2. apcalcbc-mcq-049: replace choice C (no longer a legitimate distractor)
-- and drop the unnecessary calculator stimulus.
update app.mcq_choices m
set choice_text='0.7⁶/7!', rationale='Incorrect. Pairs the correct numerator power (6) with the next term''s factorial (7) -- no value of n in the Lagrange remainder formula x^(n+1)/(n+1)! produces a mismatched power/factorial pair, so this cannot follow from any legitimate remainder calculation.'
from repaired r where r.content_key='apcalcbc-mcq-049' and m.content_item_version_id=r.new_version_id and m.choice_key='C';

update app.content_item_versions civ
set stem = replace(stem, 'C. 0.7⁷/7!', 'C. 0.7⁶/7!'),
    stimulus = null
from repaired r where r.content_key='apcalcbc-mcq-049' and civ.id=r.new_version_id;

-- 3. apphy1-frq-047: state the constant-acceleration assumption explicitly.
update app.content_item_versions civ
set stimulus = 'A 70.0 kg cyclist, accelerating uniformly (constant acceleration), accelerates from rest to 8.00 m/s in 5.00 s on level ground; assume negligible resistive forces.'
from repaired r where r.content_key='apphy1-frq-047' and civ.id=r.new_version_id;

-- Recompute content_hash for touched versions.
update app.content_item_versions civ
set content_hash = case
  when exists (select 1 from app.mcq_choices where content_item_version_id=civ.id)
    then md5(coalesce(civ.stem,'')||E'\n'||coalesce(civ.stimulus,'')||E'\n'||
      coalesce((select string_agg(m.choice_key||':'||m.choice_text||':'||m.is_correct::text||':'||coalesce(m.rationale,''), E'\n' order by m.choice_key)
                from app.mcq_choices m where m.content_item_version_id=civ.id),''))
  else md5(coalesce(civ.stem,'')||E'\n'||coalesce(civ.stimulus,''))
end
from repaired r where civ.id=r.new_version_id;

insert into app.content_review_assignments (
  content_review_assignment_id, content_item_version_id, reviewer_id,
  review_stage, review_kind, status, assignment_purpose, created_by
)
select assignment_id, new_version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
  'tutor_question',
  (select item_type from repair_targets rt where rt.content_key=r.content_key),
  'pending','owner_remediation_approval','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from repaired r;

insert into app.content_review_decisions (
  content_review_assignment_id, content_item_version_id, reviewer_id,
  review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes,
  note, tutor_decision, decision_payload, decision_hash, created_by
)
select r.assignment_id, r.new_version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
  'tutor_question', 1, 'Medium', false, array[]::text[],
  'owner_remediation_approval: ' || case r.content_key
    when 'apchem-sfrq-005' then 'tie-break adjudication upheld Zeeshan''s stoichiometry correction over Gulgeldi''s clean approve; removed false 1:1-equivalence claim from stem (b).'
    when 'apcalcbc-mcq-049' then 'folded into standing AP Calc BC / Physics 1 remediation batch; replaced choice C per Saood''s two-valid-answer finding; dropped unneeded calculator stimulus.'
    when 'apphy1-frq-047' then 'folded into standing AP Calc BC / Physics 1 remediation batch; added constant-acceleration assumption to stimulus per Saood''s finding.'
  end,
  'approve',
  jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','owner_adjudicated_remediation_batch','qa_date','2026-08-06'),
  encode(extensions.digest(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','owner_adjudicated_remediation_batch','qa_date','2026-08-06','content_key',r.content_key)::text,'sha256'),'hex'),
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from repaired r;

update app.content_item_versions civ
set status='reviewed_approved', updated_at=now()
from repaired r where civ.id=r.new_version_id;

update app.content_items ci
set status='reviewed_approved', updated_at=now()
from repaired r where ci.id=(select content_item_id from app.content_item_versions where id=r.new_version_id);

do $$
declare v_count integer;
begin
  select count(*) into v_count from repaired;
  if v_count <> 3 then
    raise exception 'owner_adjudicated_remediation_batch_incomplete:%', v_count;
  end if;
end $$;

select ci.content_key, civ.version_num, civ.status
from repaired r
join app.content_item_versions civ on civ.id=r.new_version_id
join app.content_items ci on ci.id=civ.content_item_id
order by ci.content_key;

commit;
