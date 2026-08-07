-- AP Statistics multi-point rubric redecomposition -- TASK-0022.
--
-- Context: every published AP Statistics FRQ criterion in Production
-- (573 rows, 182 items) is points_possible=1, unlike Biology/Chemistry/
-- Calculus AB/BC which have genuine 2-3pt criteria. There is no documented
-- decision authorizing this uniform atomization; it blocks the gold-set
-- pipeline's decomposition-confirmation step (Phase 0.5,
-- docs/research/GOLD_SET_GENERATION_PROTOCOL.md) from ever running against
-- Statistics content.
--
-- This re-bundles 4 already-published AP Statistics short FRQs
-- (APSTATS-SFRQ-007/008/009/010, none previously in the gold-set pilot) using
-- two standard, defensible AP Statistics scoring patterns already present in
-- the CED task-verb conventions: (1) "compute the mean and standard
-- deviation together" as one bundled point, and (2) "describe the sampling
-- distribution" (mean + standard deviation + condition check) as one bundled
-- point. No new claims are introduced -- the same facts that were previously
-- four independent 1pt criteria are regrouped into 2pt/3pt criteria plus the
-- remaining independent 1pt skill(s), preserving each item's total points.
--
--   SFRQ-007 (binomial X~Bin(20,0.25)): a(1pt, conditions) + b(2pt, mean+SD)
--     + c(1pt, P(X=5)). Total 4.
--   SFRQ-008 (raffle payoff X): a(2pt, E[X]+SD) + b(1pt, interpret in
--     context) + c(1pt, EV describes repetitions). Total 4.
--   SFRQ-009 (sampling distribution of p-hat): a(3pt, mean+SD+conditions)
--     + b(1pt, doubling-n effect). Total 4.
--   SFRQ-010 (sampling distribution of x-bar): a(3pt, mean+SD+CLT
--     condition) + b(1pt, halving-n effect). Total 4.
--
-- Each new criterion's gold_set_elements decomposition is drafted here
-- (Phase 0.5's AI-draft step) and left unconfirmed (confirmed_by IS NULL)
-- for Jill to confirm during her cold-verification pass -- this is the exact
-- decomposition-confirmation work the pipeline has never had Stats material
-- to exercise.
--
-- Owner instruction, 2026-08-07: "pick a small number of Stats FRQs to
-- properly re-decompose into genuine multi-point criteria."

begin;
select pg_advisory_xact_lock(hashtext('cramapple-apstats-multipoint-redecomposition-20260807'));

create temporary table repair_targets (content_key text primary key) on commit drop;
insert into repair_targets values ('APSTATS-SFRQ-007'),('APSTATS-SFRQ-008'),('APSTATS-SFRQ-009'),('APSTATS-SFRQ-010');

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
begin
  for t in select * from repair_targets order by content_key loop
    select * into strict v_item from app.content_items where content_key=t.content_key and item_type='frq' for update;
    select * into strict v_old from app.content_item_versions
      where content_item_id=v_item.id
        and not exists (select 1 from app.content_item_versions n where n.content_item_id=app.content_item_versions.content_item_id and n.version_num>app.content_item_versions.version_num)
      order by version_num desc limit 1 for update;

    v_new := gen_random_uuid();

    update app.content_review_assignments set status='skipped'
      where content_item_version_id=v_old.id and assignment_purpose='subject_review' and status in ('pending','in_progress');
    update app.content_item_versions set status='retired', updated_at=now() where id=v_old.id;
    update app.content_items set status='draft', updated_at=now() where id=v_item.id;

    insert into app.content_item_versions (
      id,content_item_id,version_num,stem,stimulus,prompt_json,explanation,help_text,content_hash,status,created_by,
      canonical_answer_1,canonical_answer_2,review_status,rubric_type,evaluator_strategy,stimulus_image_path
    ) values (
      v_new,v_item.id,v_old.version_num+1,v_old.stem,v_old.stimulus,
      coalesce(v_old.prompt_json,'{}'::jsonb) || jsonb_build_object('content_version',v_old.version_num+1,'qa_remediation','2026-08-07 AP Statistics multi-point redecomposition (TASK-0022)'),
      v_old.explanation,v_old.help_text,md5(coalesce(v_old.stem,'')),'draft','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
      v_old.canonical_answer_1,v_old.canonical_answer_2,null,v_old.rubric_type,v_old.evaluator_strategy,v_old.stimulus_image_path
    );

    insert into repaired values (t.content_key,v_old.id,v_new);
  end loop;
end $$;

-- SFRQ-007: a(1pt) + b(2pt: mean+SD) + c(1pt: P(X=5))
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
select r.new_version_id, x.criterion_key, x.learner_facing_text, x.points_possible, x.evidence_requirements, x.minimum_fix
from repaired r, (values
  ('a','States fixed n, two outcomes per question, independent trials, and constant p = 0.25.',1,
   'Earns when the response states fixed n, two outcomes per question, independent trials, and constant p = 0.25.',
   'State fixed n, two outcomes per question, independent trials, and constant p = 0.25.'),
  ('b','Computes the mean and standard deviation of X.',2,
   'Two required elements, 1 point each: (1) computes the mean as 5 correct answers; (2) computes the standard deviation as about 1.94. Award 1 point per element present.',
   'Compute the mean (np=5) and the standard deviation (sqrt(np(1-p))~1.94).'),
  ('c','Computes P(X = 5) as about 0.202.',1,
   'Earns when the response computes P(X = 5) as about 0.202.',
   'Compute P(X=5) using the binomial pmf; about 0.202.')
) as x(criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
where r.content_key='APSTATS-SFRQ-007';

-- SFRQ-008: a(2pt: E[X]+SD) + b(1pt) + c(1pt)
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
select r.new_version_id, x.criterion_key, x.learner_facing_text, x.points_possible, x.evidence_requirements, x.minimum_fix
from repaired r, (values
  ('a','Computes the expected value and standard deviation of the payoff X.',2,
   'Two required elements, 1 point each: (1) computes the expected value as -1.40 dollars; (2) computes the standard deviation as about 4.48 dollars. Award 1 point per element present.',
   'Compute E[X]=-1.40 dollars and SD~4.48 dollars.'),
  ('b','Explains that the long-run average net gain is -1.40 dollars per ticket for the buyer.',1,
   'Earns when the response interprets -1.40 dollars as the buyer''s long-run mean net gain per ticket.',
   'Interpret -1.40 dollars as the buyer''s long-run average net gain per ticket.'),
  ('c','Explains that expected value describes many repetitions, not the outcome of one ticket purchase.',1,
   'Earns when the response explains that expected value describes many repetitions, not the outcome of one ticket purchase.',
   'Explain that expected value describes the long-run average over many repetitions, not a single ticket.')
) as x(criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
where r.content_key='APSTATS-SFRQ-008';

-- SFRQ-009: a(3pt: mean+SD+conditions) + b(1pt: doubling n)
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
select r.new_version_id, x.criterion_key, x.learner_facing_text, x.points_possible, x.evidence_requirements, x.minimum_fix
from repaired r, (values
  ('a','Describes the sampling distribution of p-hat: states the mean, computes the standard deviation, and verifies the Normal approximation conditions.',3,
   'Three required elements, 1 point each: (1) states that the mean of the sampling distribution is 0.28; (2) computes the standard deviation as about 0.0225; (3) explains that np and n(1-p) are both at least 10. Award 1 point per element present.',
   'State mean=0.28, compute SD~0.0225, and verify np>=10 and n(1-p)>=10.'),
  ('b','Explains that doubling n would reduce the standard deviation because it is divided by the square root of n.',1,
   'Earns when the response explains that doubling n would reduce the standard deviation because it is divided by the square root of n.',
   'Explain that the standard deviation is divided by sqrt(n), so doubling n reduces it.')
) as x(criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
where r.content_key='APSTATS-SFRQ-009';

-- SFRQ-010: a(3pt: mean+SD+CLT condition) + b(1pt: halving n)
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
select r.new_version_id, x.criterion_key, x.learner_facing_text, x.points_possible, x.evidence_requirements, x.minimum_fix
from repaired r, (values
  ('a','Describes the sampling distribution of x-bar: states the mean, computes the standard deviation, and verifies the condition for the CLT to apply.',3,
   'Three required elements, 1 point each: (1) states that the mean of the sampling distribution is 7.2 hours; (2) computes the standard deviation as 0.3 hours; (3) explains that the sample size is large enough for the CLT to apply. Award 1 point per element present.',
   'State mean=7.2 hours, compute SD=0.3 hours, and verify n is large enough for the CLT.'),
  ('b','Explains that the standard deviation would increase to 0.6 hours because the sample size is smaller.',1,
   'Earns when the response explains that the standard deviation would increase to 0.6 hours because the sample size is smaller.',
   'Explain that a smaller sample size (n=9) increases the standard deviation to 0.6 hours.')
) as x(criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
where r.content_key='APSTATS-SFRQ-010';

-- Draft the element decomposition for each new multi-point criterion (Phase
-- 0.5's AI-draft step). Left unconfirmed for Jill to confirm.
insert into app.gold_set_elements (frq_criterion_id, content_item_version_id, element_index, element_label)
select fc.id, r.new_version_id, x.element_index, x.element_label
from repaired r
join app.frq_criteria fc on fc.content_item_version_id=r.new_version_id
join (values
  ('APSTATS-SFRQ-007','a',1,'States fixed n, two outcomes per question, independent trials, and constant p = 0.25.'),
  ('APSTATS-SFRQ-007','b',1,'Computes the mean as 5 correct answers.'),
  ('APSTATS-SFRQ-007','b',2,'Computes the standard deviation as about 1.94.'),
  ('APSTATS-SFRQ-007','c',1,'Computes P(X = 5) as about 0.202.'),
  ('APSTATS-SFRQ-008','a',1,'Computes the expected value as -1.40 dollars.'),
  ('APSTATS-SFRQ-008','a',2,'Computes the standard deviation as about 4.48 dollars.'),
  ('APSTATS-SFRQ-008','b',1,'Explains that the long-run average net gain is -1.40 dollars per ticket for the buyer.'),
  ('APSTATS-SFRQ-008','c',1,'Explains that expected value describes many repetitions, not the outcome of one ticket purchase.'),
  ('APSTATS-SFRQ-009','a',1,'States that the mean of the sampling distribution is 0.28.'),
  ('APSTATS-SFRQ-009','a',2,'Computes the standard deviation as about 0.0225.'),
  ('APSTATS-SFRQ-009','a',3,'Explains that np and n(1-p) are both at least 10.'),
  ('APSTATS-SFRQ-009','b',1,'Explains that doubling n would reduce the standard deviation because it is divided by the square root of n.'),
  ('APSTATS-SFRQ-010','a',1,'States that the mean of the sampling distribution is 7.2 hours.'),
  ('APSTATS-SFRQ-010','a',2,'Computes the standard deviation as 0.3 hours.'),
  ('APSTATS-SFRQ-010','a',3,'Explains that the sample size is large enough for the CLT to apply.'),
  ('APSTATS-SFRQ-010','b',1,'Explains that the standard deviation would increase to 0.6 hours because the sample size is smaller.')
) as x(content_key, criterion_key, element_index, element_label)
  on x.content_key=r.content_key and x.criterion_key=fc.criterion_key;

update app.content_item_versions civ
set content_hash = md5(coalesce(civ.stem,'')||E'\n'||coalesce(civ.stimulus,'')||E'\n'||coalesce(civ.canonical_answer_1,''))
from repaired r where civ.id=r.new_version_id;

insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select gen_random_uuid(), r.new_version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 'frq', 'pending', 'owner_remediation_approval', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from repaired r;

insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, tutor_decision, decision_payload, decision_hash, created_by)
select cra.content_review_assignment_id, cra.content_item_version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 1, 'Medium', false, array[]::text[],
  'owner_remediation_approval: TASK-0022 AP Statistics multi-point rubric redecomposition -- ' || r.content_key,
  'approve',
  jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apstats_multipoint_redecomposition','task','TASK-0022','content_key',r.content_key),
  encode(extensions.digest(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apstats_multipoint_redecomposition','task','TASK-0022','content_key',r.content_key)::text,'sha256'),'hex'),
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from repaired r
join app.content_review_assignments cra on cra.content_item_version_id=r.new_version_id and cra.assignment_purpose='owner_remediation_approval' and cra.status='pending';

update app.content_item_versions civ set status='reviewed_approved', updated_at=now() from repaired r where civ.id=r.new_version_id;
update app.content_items ci set status='reviewed_approved', updated_at=now() from repaired r join app.content_item_versions civ on civ.id=r.new_version_id where ci.id=civ.content_item_id;

do $$
declare v_count integer; v_bad integer;
begin
  select count(*) into v_count from repaired;
  if v_count<>4 then raise exception 'expected 4 redecomposed AP Statistics FRQs, found %', v_count; end if;

  select count(*) into v_bad
  from (
    select r.content_key, sum(fc.points_possible) total_points
    from repaired r
    join app.frq_criteria fc on fc.content_item_version_id=r.new_version_id
    group by r.content_key
  ) totals
  where total_points<>4;
  if v_bad<>0 then raise exception 'point total drifted from original 4 for % item(s)', v_bad; end if;

  select count(*) into v_bad
  from repaired r
  join app.frq_criteria fc on fc.content_item_version_id=r.new_version_id
  where fc.points_possible>1
    and (select count(*) from app.gold_set_elements ge where ge.frq_criterion_id=fc.id) <> fc.points_possible;
  if v_bad<>0 then raise exception '% multi-point criteria missing a matching element decomposition', v_bad; end if;
end $$;

select ci.content_key, fc.criterion_key, fc.points_possible,
  (select count(*) from app.gold_set_elements ge where ge.frq_criterion_id=fc.id) n_elements
from repaired r
join app.content_item_versions civ on civ.id=r.new_version_id
join app.content_items ci on ci.id=civ.content_item_id
join app.frq_criteria fc on fc.content_item_version_id=civ.id
order by ci.content_key, fc.criterion_key;

commit;
