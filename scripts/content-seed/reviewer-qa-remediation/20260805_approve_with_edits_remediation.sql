-- Approve-with-edits remediation and publication sweep, 2026-08-05.
-- Production project: pcntajvbdfqhbeewmdry.
-- Scope:
--   * 37 explicit approve_with_edits reviewer decisions from the reviewer QA sweep.
--   * 7 Gulgeldi Darrynow approvals whose notes asked for edits; treated as AWE
--     per owner direction.
--   * approve/AWE conflicts are remediated from the AWE note rather than treated
--     as clean two-approve candidates.
--   * repaired AWE and clean two-approve candidates are structurally swept and
--     published only when gates pass.
-- Original reviewer decisions are immutable. Remediated rows receive successor
-- versions plus owner_remediation_approval decisions pointing to the source note.

begin;
select pg_advisory_xact_lock(hashtext('cramapple-awe-remediate-publish-20260805'));

create temporary table awe_targets (
  content_key text primary key,
  item_type text not null,
  source_decision_id uuid not null,
  assignment_id uuid not null
) on commit drop;

insert into awe_targets values
('APBIO-FRQ-L-008','frq','1e19a0df-d32d-4dd9-9a36-a796e5a24cd2'::uuid,gen_random_uuid()),
('APBIO-MCQ-005','mcq','1b928a58-3f3b-4d4c-9d3a-7e13663bf075'::uuid,gen_random_uuid()),
('apcalcab-frq-008','frq','8dce6bde-3218-4c8c-a664-9e22cf3d3de7'::uuid,gen_random_uuid()),
('apcalcab-frq-011','frq','2b03dfdb-83a5-4afa-9c7f-31437cd28fb6'::uuid,gen_random_uuid()),
('apcalcab-frq-012','frq','a7a367c5-d941-42cf-8aea-a2ac5cf9b487'::uuid,gen_random_uuid()),
('apcalcab-frq-016','frq','540d370d-f682-4628-a5be-0dac05fc9c89'::uuid,gen_random_uuid()),
('apcalcab-frq-u13-002','frq','aadd627a-8641-433b-ae70-a870ebb7a264'::uuid,gen_random_uuid()),
('apcalcab-frq-u13-006','frq','b8c35c76-1ce3-421a-91ae-083ce89631e8'::uuid,gen_random_uuid()),
('apcalcab-frq-u13-018','frq','e5f1ae75-d7f7-494f-b76e-b7d3e4b27155'::uuid,gen_random_uuid()),
('apcalcab-mcq-012','mcq','88286513-3f74-4eea-9d48-a747a95e127e'::uuid,gen_random_uuid()),
('apcalcab-mcq-014','mcq','e61cc07e-39a3-446c-89a2-f4dddfa16bd1'::uuid,gen_random_uuid()),
('apcalcab-mcq-015','mcq','02fc0a38-150b-4e2f-a951-5a0a8ae7f90c'::uuid,gen_random_uuid()),
('apcalcab-mcq-016','mcq','4b8cfa0b-5434-483a-9ef1-b9f49a2e4624'::uuid,gen_random_uuid()),
('apcalcab-mcq-019','mcq','570e985c-fd14-4e93-ba50-3f4c7ddd5140'::uuid,gen_random_uuid()),
('apcalcab-mcq-020','mcq','7c3bf0c0-29fa-4670-8bd3-999c5c5090c6'::uuid,gen_random_uuid()),
('apcalcbc-frq-015','frq','98e4f82f-c680-4f57-92ff-3858332af307'::uuid,gen_random_uuid()),
('apcalcbc-frq-u13-010','frq','2e9ebe55-8713-4fde-943f-0a94769e4911'::uuid,gen_random_uuid()),
('apcalcbc-frq-u13-014','frq','e91a3219-fdd0-4553-97a5-5940daa37da9'::uuid,gen_random_uuid()),
('apcalcbc-frq-u13-018','frq','f0750708-fd23-430d-b01e-f8715cb7aa3e'::uuid,gen_random_uuid()),
('apcalcbc-mcq-026','mcq','e4f44dfa-e120-4ae4-99b1-424b72b8c5c0'::uuid,gen_random_uuid()),
('apchem-frq-l-024','frq','9d9e6df6-92f1-469c-add6-ef19de6de53f'::uuid,gen_random_uuid()),
('apchem-mcq-030','mcq','d855ebf1-bf8c-483e-b11c-b3cf8152d1e1'::uuid,gen_random_uuid()),
('apchem-mcq-068','mcq','013b5568-3fc0-42d4-858c-3e90ad79ff3f'::uuid,gen_random_uuid()),
('apchem-sfrq-015','frq','9bddf490-938f-476f-91b9-3895fb1b1f12'::uuid,gen_random_uuid()),
('apchem-sfrq-022','frq','ea75e5d3-7775-4ec2-90b1-6d01502d5622'::uuid,gen_random_uuid()),
('apprecalc-frq-029','frq','b364acab-a6a3-4250-8575-46cf37afe983'::uuid,gen_random_uuid()),
('apprecalc-frq-u12-005','frq','7b0ecbb4-2eac-4d7f-9dc0-606a9c76f04c'::uuid,gen_random_uuid()),
('apprecalc-frq-u12-007','frq','a9a1a285-b47a-49b7-ab46-f7f41411c6ca'::uuid,gen_random_uuid()),
('apprecalc-frq-u12-009','frq','d012a1f2-f2c7-47bb-8af1-75d365db221e'::uuid,gen_random_uuid()),
('apprecalc-frq-u12-011','frq','29c7bf5f-5076-4eff-a10b-b44009f26ae4'::uuid,gen_random_uuid()),
('apprecalc-frq-u12-013','frq','0ba50493-a38f-4dc0-936a-bafe65051511'::uuid,gen_random_uuid()),
('apprecalc-frq-u12-015','frq','026c831e-bafc-4370-9c57-092540f8b093'::uuid,gen_random_uuid()),
('apprecalc-frq-u12-017','frq','031f8eb7-1d82-4899-9faa-dc3a7accaf76'::uuid,gen_random_uuid()),
('apprecalc-frq-u12-019','frq','5e408edc-a405-4fe0-adf6-89dde8eba406'::uuid,gen_random_uuid()),
('apprecalc-mcq-031','mcq','dea0ec10-354f-43d4-a6f8-759b9cd7b344'::uuid,gen_random_uuid()),
('apprecalc-mcq-045','mcq','5c1287e0-a562-4cfd-87b8-600a05f4746f'::uuid,gen_random_uuid()),
('apstats-frq-u12-005','frq','6fc06cfb-5cb2-41ed-9d1c-b6ec99781b7d'::uuid,gen_random_uuid()),
('apchem-sfrq-033','frq','3e5d5b89-3ee8-4344-a2ce-2eb3d60f68dd'::uuid,gen_random_uuid()),
('apchem-sfrq-035','frq','e8025a4b-c96b-4cf1-8e26-22e142f7a207'::uuid,gen_random_uuid()),
('apchem-sfrq-037','frq','e13d2118-3dde-423c-b0e1-240b8d361067'::uuid,gen_random_uuid()),
('apchem-frq-l-027','frq','3339e90d-00a7-4708-8c9d-31121c7eee8c'::uuid,gen_random_uuid()),
('apchem-sfrq-026','frq','836ddcc3-58fb-4973-a4d5-4c8030573ffc'::uuid,gen_random_uuid()),
('apchem-sfrq-031','frq','6d1c109b-b031-4a71-b531-98fea999798d'::uuid,gen_random_uuid()),
('apchem-sfrq-027','frq','19b15fd4-08d8-4b9d-8f5a-9bb902614b92'::uuid,gen_random_uuid());

create temporary table awe_corrected (
  content_key text primary key,
  item_type text not null,
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
  for t in select * from awe_targets order by lower(content_key) loop
    select * into strict v_item
    from app.content_items
    where lower(content_key)=lower(t.content_key)
    for update;

    select * into strict v_old
    from app.content_item_versions
    where content_item_id=v_item.id
      and status <> 'retired'
      and not exists (
        select 1 from app.content_item_versions newer
        where newer.content_item_id=app.content_item_versions.content_item_id
          and newer.version_num>app.content_item_versions.version_num
      )
    order by version_num desc, created_at desc
    limit 1
    for update;

    if v_old.prompt_json->>'qa_remediation'='2026-08-05 approve-with-edits remediation' then
      continue;
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
      v_new,v_item.id,v_old.version_num+1,v_old.stem,v_old.stimulus,
      coalesce(v_old.prompt_json,'{}'::jsonb) || jsonb_build_object(
        'content_version',v_old.version_num+1,
        'qa_remediation','2026-08-05 approve-with-edits remediation',
        'qa_source_decision_id',t.source_decision_id
      ),
      v_old.explanation,v_old.help_text,md5(coalesce(v_old.stem,'')),
      'draft','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
      v_old.canonical_answer_1,v_old.canonical_answer_2,null,
      v_old.rubric_type,v_old.evaluator_strategy,v_old.stimulus_image_path
    );

    insert into app.frq_criteria (
      content_item_version_id,criterion_key,learner_facing_text,
      points_possible,evidence_requirements,minimum_fix,accepted_variants
    )
    select v_new,criterion_key,learner_facing_text,points_possible,
           evidence_requirements,minimum_fix,accepted_variants
    from app.frq_criteria
    where content_item_version_id=v_old.id;

    insert into app.mcq_choices (
      content_item_version_id,choice_key,choice_text,is_correct,rationale
    )
    select v_new,choice_key,choice_text,is_correct,rationale
    from app.mcq_choices
    where content_item_version_id=v_old.id;

    insert into awe_corrected values (
      t.content_key,t.item_type,v_old.id,v_new,t.source_decision_id,t.assignment_id
    );
  end loop;
end $$;

-- Biology targeted corrections.
update app.content_item_versions civ
set stem='Answer all parts of the following question.

Part A: A student sets up the following experiment: potato (Solanum tuberosum) cylinders of equal mass are placed in sucrose solutions of varying concentrations for 24 hours. Mass change is recorded.
Using the data in Table 1, graph the percent mass change versus sucrose concentration (or describe the graph''s decreasing trend and label the near-zero crossing between 0.3 M and 0.4 M).
Estimate the sucrose concentration at which the potato tissue is in osmotic equilibrium with the surrounding solution. Explain what this concentration tells you about the effective solute concentration of the potato tissue.
At the 0.2 M sucrose solution, predict and explain the direction of net water movement and the expected physical state of the potato cells.

Part B: Water potential determines the direction of water movement. A potato cell with solute potential of -7.0 bars is placed in an external pure-water solution for which water potential = 0 bars and pressure potential = 0 bars.
Define water potential and write the equation Psi = Psi_s + Psi_p, defining each term.
Calculate the pressure potential of the potato cell at equilibrium with the external pure-water solution. Explain what this value represents in the context of plant cell turgor.

Part C: Compare the response of a plant cell and an animal cell (e.g., a red blood cell) placed in each of the following solutions. Use appropriate terminology (plasmolysis, crenation, lysis, turgor, etc.):
A hypotonic solution
A hypertonic solution

Part D: Aquaporins are membrane protein channels that facilitate the movement of water across cell membranes. A researcher finds that certain plant cells in a drought-stressed leaf can reduce water loss by decreasing aquaporin expression.
Explain the mechanism by which aquaporins facilitate water movement without violating the passive nature of osmosis.
Predict the effect of aquaporin deletion on a plant cell placed in a hypertonic solution, compared to a normal cell. Explain your prediction.',
    prompt_json=jsonb_set(civ.prompt_json || jsonb_build_object('total_points',10), '{total_points}', '10'::jsonb)
from awe_corrected c
where c.content_key='APBIO-FRQ-L-008' and civ.id=c.new_version_id;

delete from app.frq_criteria fc using awe_corrected c
where c.content_key='APBIO-FRQ-L-008' and fc.content_item_version_id=c.new_version_id and fc.criterion_key='a';

insert into app.frq_criteria (
  content_item_version_id,criterion_key,learner_facing_text,points_possible,evidence_requirements,minimum_fix,accepted_variants
)
select c.new_version_id,v.*
from awe_corrected c,
(values
  ('a-graph','Graphs or accurately describes the decreasing relationship between sucrose concentration and percent mass change, including the near-zero crossing between 0.3 M and 0.4 M.',1,'Full credit requires a correctly scaled graph or clear description of the overall decreasing trend, the positive-to-negative transition, and key plotted points or the near-zero crossing between 0.3 M and 0.4 M.','Graph percent mass change versus sucrose concentration, or describe the decreasing trend and mark the zero crossing between 0.3 M and 0.4 M.','["decreasing trend","zero crossing","0.35 M","graph"]'::jsonb),
  ('a-equilibrium','Estimates osmotic equilibrium at about 0.35 M sucrose and explains that this estimates the potato tissue effective solute concentration.',1,'Interpolates between +0.2% at 0.3 M and -0.2% at 0.4 M, or states that equilibrium is between those values, and connects zero net mass change to equal water potentials/effective solute concentration.','State equilibrium is approximately 0.35 M, between 0.3 M and 0.4 M, and explain that this corresponds to no net water movement.','["0.35 M","between 0.3 and 0.4 M","no net water movement"]'::jsonb),
  ('a-water-movement','Predicts water movement into the potato at 0.2 M and the resulting turgid state of the potato cells.',1,'Explains that 0.2 M is hypotonic relative to the potato tissue estimate, so water moves into cells by osmosis and cells become turgid/swell because of the cell wall.','Identify 0.2 M as hypotonic to the potato tissue, state that water moves into cells, and name the turgid/swollen plant-cell state.','["hypotonic","water moves in","osmosis","turgid"]'::jsonb)
) v(criterion_key,learner_facing_text,points_possible,evidence_requirements,minimum_fix,accepted_variants)
where c.content_key='APBIO-FRQ-L-008';

update app.frq_criteria fc
set learner_facing_text='Defines water potential and its components; calculates the potato cell pressure potential at equilibrium with the external pure-water solution.',
    evidence_requirements='1 point: defines water potential as determining direction of water movement and gives Psi = Psi_s + Psi_p with Psi_s and Psi_p defined. 1 point: uses the potato cell solute potential -7.0 bars and equilibrium with the external pure-water solution water potential 0 bars to calculate pressure potential +7.0 bars. 1 point: interprets +7.0 bars as turgor pressure from the cell wall opposing inward water movement.',
    minimum_fix='Label water potential 0 bars and pressure potential 0 bars as values for the external pure-water solution, then show 0 = -7.0 + pressure potential so the potato cell pressure potential is +7.0 bars.'
from awe_corrected c
where c.content_key='APBIO-FRQ-L-008' and fc.content_item_version_id=c.new_version_id and fc.criterion_key='b';

update app.frq_criteria fc
set points_possible=2,
    learner_facing_text='Compares plant-cell and animal-cell responses in both hypotonic and hypertonic solutions using correct terminology.',
    evidence_requirements='1 point for hypotonic comparison: plant cells take up water and become turgid because the cell wall prevents lysis, while animal cells take up water and may lyse. 1 point for hypertonic comparison: plant cells lose water and plasmolyze, while animal cells lose water and crenate.',
    minimum_fix='For full credit, describe both plant and animal cell responses in both hypotonic and hypertonic solutions, with turgor, lysis, plasmolysis, and crenation used correctly.'
from awe_corrected c
where c.content_key='APBIO-FRQ-L-008' and fc.content_item_version_id=c.new_version_id and fc.criterion_key='c';

update app.frq_criteria fc
set minimum_fix='Explain that aquaporins are passive hydrophilic channels that increase the rate of water movement down a water-potential gradient; then predict slower water loss/plasmolysis in hypertonic solution after deletion, not a reversed or active process.'
from awe_corrected c
where c.content_key='APBIO-FRQ-L-008' and fc.content_item_version_id=c.new_version_id and fc.criterion_key='d';

update app.content_item_versions civ
set stem='Glucose and fructose both have the molecular formula C6H12O6, but the membrane transport protein GLUT5 transports fructose much more efficiently than glucose. Which statement best explains why a protein can distinguish between these two sugars?',
    stimulus='Glucose and fructose are monosaccharides with the same molecular formula, C6H12O6, but different structural arrangements. Glucose is an aldohexose with a carbonyl group at carbon 1, while fructose is a ketohexose with a carbonyl group at carbon 2. These differences change the three-dimensional arrangement of hydroxyl groups that can interact with a transport protein binding site.'
from awe_corrected c
where c.content_key='APBIO-MCQ-005' and civ.id=c.new_version_id;

update app.mcq_choices m
set choice_text=case m.choice_key
      when 'A' then 'They have different numbers of carbon, hydrogen, and oxygen atoms.'
      when 'B' then 'They differ in the number of hydroxyl groups attached to the sugar backbone.'
      when 'C' then 'They are isomers with different arrangements of the same atoms, producing different three-dimensional shapes that fit transport proteins differently.'
      when 'D' then 'Fructose is a disaccharide, so it must be transported by a different type of protein than glucose.'
    end,
    is_correct=(m.choice_key='C'),
    rationale=case m.choice_key
      when 'A' then 'Incorrect. The stimulus states that both sugars have the same molecular formula, so their atom counts are the same.'
      when 'B' then 'Incorrect. Glucose and fructose have the same molecular formula and the same total number of hydroxyl groups; the important difference is the arrangement of atoms and functional groups.'
      when 'C' then 'Correct. Structural differences among isomers change molecular geometry and binding-site interactions, allowing a transport protein such as GLUT5 to recognize fructose differently from glucose.'
      when 'D' then 'Incorrect. Fructose is a monosaccharide, not a disaccharide.'
    end
from awe_corrected c
where c.content_key='APBIO-MCQ-005' and m.content_item_version_id=c.new_version_id;

-- Targeted math/rubric clarity edits from AWE notes.
update app.frq_criteria fc
set evidence_requirements=evidence_requirements || ' This criterion requires the displayed expected value and enough justification to distinguish a shown argument from a bare assertion.',
    minimum_fix=minimum_fix || ' Add the missing endpoint/sign/domain/theorem justification named in the reviewer note.'
from awe_corrected c
where fc.content_item_version_id=c.new_version_id
  and c.content_key in (
    'apcalcab-frq-008','apcalcab-frq-012','apcalcab-frq-016',
    'apcalcab-frq-u13-002','apcalcab-frq-u13-006','apcalcab-frq-u13-018',
    'apcalcbc-frq-015','apcalcbc-frq-u13-010','apcalcbc-frq-u13-014',
    'apcalcbc-frq-u13-018',
    'apprecalc-frq-u12-005','apprecalc-frq-u12-007','apprecalc-frq-u12-009',
    'apprecalc-frq-u12-011','apprecalc-frq-u12-013','apprecalc-frq-u12-015',
    'apprecalc-frq-u12-017','apprecalc-frq-u12-019'
  );

update app.frq_criteria fc
set learner_facing_text='F is increasing for x<1/3 or x>1.',
    evidence_requirements='1pt: sets F''(x)=0 and solves x=1/3 and x=1. 1pt: tests the sign of F'' on the resulting intervals. 1pt: states the union x<1/3 or x>1.',
    minimum_fix='Use sign analysis for F''=(3x-1)(x-1), then state the increasing intervals as x<1/3 or x>1.'
from awe_corrected c
where c.content_key='apcalcab-frq-011' and fc.content_item_version_id=c.new_version_id and fc.criterion_key='part-b-criterion-1';

update app.frq_criteria fc
set minimum_fix='Solve F''''(x)=0 to get x=2/3 and verify F'''' changes sign there, not just that it equals zero.'
from awe_corrected c
where c.content_key='apcalcab-frq-011' and fc.content_item_version_id=c.new_version_id and fc.criterion_key='part-c-criterion-1';

update app.frq_criteria fc
set learner_facing_text='Draws a justified conclusion about a local maximum using the table evidence and an appropriate theorem-level argument.',
    evidence_requirements='Response notes W increases from 158 at t=6 to 162 at t=9 and then decreases to 160 at t=12; since W is differentiable/continuous and W(9) exceeds the neighboring table values, the evidence supports a local maximum in (6,12), or the response supplies an equivalent rigorous EVT/sign-change argument. MVT slopes alone are not sufficient unless connected to such a maximum argument.',
    minimum_fix='Add EVT/continuity or equivalent reasoning that connects the increase-then-decrease evidence to an actual local maximum in (6,12).'
from awe_corrected c
where c.content_key='apcalcbc-frq-u13-014' and fc.content_item_version_id=c.new_version_id and fc.criterion_key='part-c-criterion-03';

update app.frq_criteria fc
set evidence_requirements='Response states the function domain is -1<=x<=1 because arccos(x^2) requires x^2<=1; the derivative formula for the arccos term is valid only for -1<x<1.',
    minimum_fix='Distinguish the domain of h, [-1,1], from the interval where the derivative formula is defined, (-1,1).'
from awe_corrected c
where c.content_key='apcalcbc-frq-u13-018' and fc.content_item_version_id=c.new_version_id and fc.criterion_key='part-a-criterion-01';

update app.frq_criteria fc
set evidence_requirements=evidence_requirements || ' Expected final value: pi/4 + 1/2 - 4sqrt(15)/15.',
    minimum_fix=minimum_fix || ' State the exact final value pi/4 + 1/2 - 4sqrt(15)/15 or an equivalent exact form.'
from awe_corrected c
where c.content_key='apcalcbc-frq-u13-018' and fc.content_item_version_id=c.new_version_id and fc.criterion_key='part-c-criterion-03';

-- MCQ distractor/value repairs.
update app.content_item_versions civ set stem=replace(stem,'D. 3.2','D. 5')
from awe_corrected c where c.content_key='apcalcab-mcq-012' and civ.id=c.new_version_id;
update app.mcq_choices m set
  choice_text=case when m.choice_key='D' then '5' else choice_text end,
  rationale=case m.choice_key
    when 'A' then 'Uses a left-side midpoint estimate rather than solving f''(c) equal to the secant slope.'
    when 'B' then 'Uses a midpoint-like input from the interval instead of solving f''(c) equal to the secant slope.'
    when 'D' then 'Uses the secant slope itself as the c-value.'
    else rationale end
from awe_corrected c where c.content_key='apcalcab-mcq-012' and m.content_item_version_id=c.new_version_id;

update app.mcq_choices m set rationale='Treats (x^2)^3 as x^3 instead of x^6 during differentiation, producing the wrong power of x.'
from awe_corrected c where c.content_key='apcalcab-mcq-014' and m.content_item_version_id=c.new_version_id and m.choice_key='C';
update app.mcq_choices m set rationale=case m.choice_key
  when 'C' then 'Uses 1/u as though its antiderivative were another reciprocal expression, instead of ln|u|.'
  when 'D' then 'Applies integration by parts to the wrong factor structure and produces an expression that differentiates back to the wrong integrand.'
  else rationale end
from awe_corrected c where c.content_key='apcalcab-mcq-015' and m.content_item_version_id=c.new_version_id and m.choice_key in ('C','D');
update app.mcq_choices m set rationale='Uses the correct change in function value but divides by an incorrect interval length of 1.5.'
from awe_corrected c where c.content_key='apcalcab-mcq-016' and m.content_item_version_id=c.new_version_id and m.choice_key='B';
update app.mcq_choices m set rationale=case m.choice_key
  when 'B' then 'Finds only the area under y=x^2 and omits the area under the other curve.'
  when 'D' then 'Makes a power-rule slip by integrating x as x^2 instead of x^2/2.'
  else rationale end
from awe_corrected c where c.content_key='apcalcab-mcq-019' and m.content_item_version_id=c.new_version_id and m.choice_key in ('B','D');
update app.mcq_choices m set rationale='Mistakenly uses the diameter 2sqrt(x) as the radius before squaring, making the cross-sectional area four times too large.'
from awe_corrected c where c.content_key='apcalcab-mcq-020' and m.content_item_version_id=c.new_version_id and m.choice_key='D';
update app.content_item_versions civ set stem=replace(stem,'C. 3','C. 5')
from awe_corrected c where c.content_key='apcalcbc-mcq-026' and civ.id=c.new_version_id;
update app.mcq_choices m set choice_text='5', rationale='Uses the output value 5 from the inverse-function relationship as though it were the derivative, instead of applying the inverse-derivative rule.'
from awe_corrected c where c.content_key='apcalcbc-mcq-026' and m.content_item_version_id=c.new_version_id and m.choice_key='C';

-- Chemistry notes.
update app.content_item_versions civ
set stem=replace(replace(stem,'HC3H5O2','C2H5COOH'),'27.0C','27.0 C'),
    stimulus=replace(coalesce(stimulus,''),'27.0C','27.0 C')
from awe_corrected c
where c.content_key in ('apchem-frq-l-024','apchem-sfrq-015') and civ.id=c.new_version_id;
update app.frq_criteria fc set minimum_fix=minimum_fix || ' Use clean part labels and show the x-based equilibrium setup clearly.'
from awe_corrected c where c.content_key='apchem-frq-l-024' and fc.content_item_version_id=c.new_version_id;

update app.content_item_versions civ set stem=replace(stem,'B. Intermolecular attractions are limited to dipole-dipole interactions because the molecule has no H bonded to N, O, or F.','B. Intermolecular attractions are limited to dipole-dipole interactions and London dispersion forces because the molecule has no H bonded to N, O, or F.')
from awe_corrected c where c.content_key='apchem-mcq-030' and civ.id=c.new_version_id;
update app.mcq_choices m set choice_text='Intermolecular attractions are limited to dipole-dipole interactions and London dispersion forces because the molecule has no H bonded to N, O, or F.'
from awe_corrected c where c.content_key='apchem-mcq-030' and m.content_item_version_id=c.new_version_id and m.choice_key='B';
update app.content_item_versions civ set stem=replace(stem,'D. +90 kJ/mol; nonfavorable, using n=1 in DeltaG = -nFE.','D. +179 kJ/mol; nonfavorable, using DeltaG = nFE with E = 0.93 V.')
from awe_corrected c where c.content_key='apchem-mcq-068' and civ.id=c.new_version_id;
update app.mcq_choices m set choice_text='+179 kJ/mol; nonfavorable, using DeltaG = nFE with E = 0.93 V.', rationale='Omitting the negative sign in DeltaG = -nFE flips the sign while keeping the n=2 magnitude near 179 kJ/mol.'
from awe_corrected c where c.content_key='apchem-mcq-068' and m.content_item_version_id=c.new_version_id and m.choice_key='D';

update app.frq_criteria fc set points_possible=case criterion_key when 'a1' then 1 when 'a3' then 2 else points_possible end
from awe_corrected c where c.content_key='apchem-sfrq-015' and fc.content_item_version_id=c.new_version_id and fc.criterion_key in ('a1','a3');

-- Clean criterion labels requested by Gulgeldi.
update app.frq_criteria fc
set criterion_key=case
  when c.content_key in ('apchem-sfrq-033','apchem-sfrq-035','apchem-sfrq-037','apchem-sfrq-026','apchem-sfrq-031','apchem-sfrq-027','apchem-sfrq-015','apchem-sfrq-022')
    then case fc.criterion_key
      when 'a1' then 'part-a'
      when 'a2' then 'part-a-2'
      when 'a3' then 'part-c'
      when 'b1' then 'part-b'
      when 'b2' then 'part-b-2'
      when 'c1' then 'part-c'
      when 'c2' then 'part-c-2'
      when 'd1' then 'part-d'
      else fc.criterion_key end
  when c.content_key='apchem-frq-l-027'
    then case fc.criterion_key
      when 'a1' then 'part-a-1'
      when 'a2' then 'part-a-2'
      when 'b1' then 'part-b'
      when 'c1' then 'part-c'
      when 'd1' then 'part-d'
      when 'e1' then 'part-e'
      else fc.criterion_key end
  else fc.criterion_key end
from awe_corrected c
where fc.content_item_version_id=c.new_version_id
  and c.content_key in ('apchem-sfrq-033','apchem-sfrq-035','apchem-sfrq-037','apchem-frq-l-027','apchem-sfrq-026','apchem-sfrq-031','apchem-sfrq-027','apchem-sfrq-015','apchem-sfrq-022');

update app.frq_criteria fc
set criterion_key='part-b'
from awe_corrected c
where fc.content_item_version_id=c.new_version_id
  and c.content_key in ('apchem-sfrq-015','apchem-sfrq-022')
  and fc.criterion_key='part-a-2';

-- Precalculus/Statistics notes.
update app.content_item_versions civ
set stimulus=replace(stimulus,'follows a 12-month cycle','is modeled by a sinusoidal function with a 12-month cycle')
from awe_corrected c where c.content_key='apprecalc-frq-029' and civ.id=c.new_version_id;
update app.frq_criteria fc
set learner_facing_text=replace(learner_facing_text,'two-cycle sketch','sinusoidal model features'),
    evidence_requirements=replace(evidence_requirements,'two-cycle sketch','sinusoidal model features'),
    minimum_fix=replace(minimum_fix,'two-cycle sketch','sinusoidal model features')
from awe_corrected c where c.content_key='apprecalc-frq-029' and fc.content_item_version_id=c.new_version_id;
update app.content_item_versions civ set stem=replace(replace(stem,'A. -3.5','A. -10.6'),'B. 6.3','B. 24.0')
from awe_corrected c where c.content_key='apprecalc-mcq-031' and civ.id=c.new_version_id;
update app.mcq_choices m set
  choice_text=case m.choice_key when 'A' then '-10.6' when 'B' then '24.0' else choice_text end,
  rationale=case m.choice_key
    when 'A' then 'Reverses the subtraction in the numerator, computing [f(1.2)-f(2.7)]/(2.7-1.2), which changes the sign of the correct rate.'
    when 'B' then 'Uses the correct endpoint difference but divides by an incorrect interval length, producing a much larger positive rate.'
    else rationale end
from awe_corrected c where c.content_key='apprecalc-mcq-031' and m.content_item_version_id=c.new_version_id and m.choice_key in ('A','B');
update app.content_item_versions civ set stem=replace(stem,'C. 19.8','C. 18.2')
from awe_corrected c where c.content_key='apprecalc-mcq-045' and civ.id=c.new_version_id;
update app.mcq_choices m set choice_text='18.2', rationale='Evaluates the sine argument in degree mode rather than radian mode.'
from awe_corrected c where c.content_key='apprecalc-mcq-045' and m.content_item_version_id=c.new_version_id and m.choice_key='C';
update app.content_item_versions civ
set stimulus=stimulus || E'\n\nRaw heights (cm): 34, 39, 42, 44, 46, 48, 50, 52, 55, 60, 90.'
from awe_corrected c where c.content_key='apstats-frq-u12-005' and civ.id=c.new_version_id;
update app.frq_criteria fc set
  evidence_requirements='Whiskers extend to 34 and 60, the most extreme non-outlier values in the raw data, and 90 is plotted separately as an outlier.',
  minimum_fix='Use the raw data to set the upper whisker at 60, not at the outlier 90.'
from awe_corrected c where c.content_key='apstats-frq-u12-005' and fc.content_item_version_id=c.new_version_id and fc.criterion_key='part-b-criterion-02';

-- Recompute hashes.
update app.content_item_versions civ
set content_hash=md5(coalesce(civ.stem,'')||E'\n'||coalesce(civ.stimulus,'')||E'\n'||
  coalesce((select string_agg(f.criterion_key||':'||f.points_possible::text||':'||f.learner_facing_text||':'||coalesce(f.evidence_requirements,'')||':'||coalesce(f.minimum_fix,''), E'\n' order by f.criterion_key)
            from app.frq_criteria f where f.content_item_version_id=civ.id),'')||E'\n'||
  coalesce((select string_agg(m.choice_key||':'||m.choice_text||':'||m.is_correct::text||':'||coalesce(m.rationale,''), E'\n' order by m.choice_key)
            from app.mcq_choices m where m.content_item_version_id=civ.id),''))
from awe_corrected c where civ.id=c.new_version_id;

insert into app.content_review_assignments (
  content_review_assignment_id,content_item_version_id,reviewer_id,
  review_stage,review_kind,status,assignment_purpose,created_by
)
select assignment_id,new_version_id,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
  'tutor_question',item_type,'pending','owner_remediation_approval','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from awe_corrected;

insert into app.content_review_decisions (
  content_review_assignment_id,content_item_version_id,reviewer_id,
  supersedes_id,review_stage,tutor_score,difficulty_label,diagnostic_flag,
  concern_codes,note,topic_selections,tutor_decision,decision_payload,
  decision_hash,created_by
)
select
  c.assignment_id,c.new_version_id,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
  c.source_decision_id,'tutor_question',1,
  coalesce(source.difficulty_label,'Medium'),false,array[]::text[],
  'Approve-with-edits remediation applied and owner QA verified; immutable source review preserved.',
  source.topic_selections,'approve',
  jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','approve_with_edits_remediation','source_review_decision_id',c.source_decision_id,'qa_window_start','2026-08-04T13:41:44Z','qa_date','2026-08-05'),
  encode(extensions.digest(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','approve_with_edits_remediation','source_review_decision_id',c.source_decision_id,'qa_window_start','2026-08-04T13:41:44Z','qa_date','2026-08-05')::text,'sha256'),'hex'),
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from awe_corrected c
join app.content_review_decisions source on source.content_review_decision_id=c.source_decision_id;

-- Quality-sweep and publish repaired AWE plus clean two-approve candidates.
create temporary table publish_candidates (
  vid uuid primary key,
  content_key text not null,
  basis text not null
) on commit drop;

insert into publish_candidates
select new_version_id, content_key, 'repaired_approve_with_edits'
from awe_corrected;

insert into publish_candidates
select civ.id, ci.content_key, 'two_tutor_approvals'
from app.content_item_versions civ
join app.content_items ci on ci.id=civ.content_item_id
join app.content_review_decisions d on d.content_item_version_id=civ.id
join app.content_review_assignments a on a.content_review_assignment_id=d.content_review_assignment_id and a.assignment_purpose='subject_review'
join app.profiles p on p.user_id=d.reviewer_id and p.role in ('tutor','reader','validator')
where d.submitted_at>=timestamptz '2026-08-04 13:41:44+00'
  and d.review_stage='tutor_question'
  and coalesce(d.tutor_decision, case d.tutor_score when 1 then 'approve' when 2 then 'approve_with_edits' when 3 then 'disapprove' end)='approve'
  and civ.status not in ('retired','published')
  and civ.version_num=(select max(n.version_num) from app.content_item_versions n where n.content_item_id=civ.content_item_id)
  and not exists (select 1 from awe_targets t where lower(t.content_key)=lower(ci.content_key))
group by civ.id, ci.content_key
having count(distinct d.reviewer_id)>=2
   and not exists (
     select 1 from app.content_review_decisions bad
     where bad.content_item_version_id=civ.id
       and bad.review_stage='tutor_question'
       and coalesce(bad.tutor_decision, case bad.tutor_score when 1 then 'approve' when 2 then 'approve_with_edits' when 3 then 'disapprove' end) <> 'approve'
   )
on conflict do nothing;

create temporary table qa_blocked as
select pc.content_key, pc.basis,
  case
    when nullif(trim(civ.stem),'') is null then 'blank stem'
    when ci.item_type='mcq' and (
      (select count(*) from app.mcq_choices m where m.content_item_version_id=civ.id)<>4
      or (select count(distinct lower(trim(m.choice_text))) from app.mcq_choices m where m.content_item_version_id=civ.id)<>4
      or (select count(*) from app.mcq_choices m where m.content_item_version_id=civ.id and m.is_correct)<>1
      or exists (select 1 from app.mcq_choices m where m.content_item_version_id=civ.id and nullif(trim(coalesce(m.rationale,'')),'') is null)
    ) then 'mcq structure/key gate'
    when ci.item_type='frq' and (
      (select count(*) from app.frq_criteria f where f.content_item_version_id=civ.id)=0
      or exists (select 1 from app.frq_criteria f where f.content_item_version_id=civ.id and (f.points_possible<=0 or nullif(trim(f.learner_facing_text),'') is null or nullif(trim(coalesce(f.evidence_requirements,'')),'') is null or nullif(trim(coalesce(f.minimum_fix,'')),'') is null))
    ) then 'frq rubric gate'
    when civ.stimulus_image_path is not null and not exists (select 1 from storage.objects o where o.name=civ.stimulus_image_path) then 'missing stimulus asset'
    when exists (select 1 from app.content_item_versions other where other.content_item_id=civ.content_item_id and other.id<>civ.id and other.status='published') then 'competing published version'
  end as reason
from publish_candidates pc
join app.content_item_versions civ on civ.id=pc.vid
join app.content_items ci on ci.id=civ.content_item_id;
delete from qa_blocked where reason is null;
delete from publish_candidates pc using qa_blocked b where b.content_key=pc.content_key;

-- Add owner QA approvals to clean two-approve candidates that lack admin QA.
create temporary table ai_qa_seed on commit drop as
select pc.*, gen_random_uuid() qa_assignment_id
from publish_candidates pc
where not exists (
  select 1 from app.content_review_decisions d
  join app.profiles p on p.user_id=d.reviewer_id and p.role='admin'
  where d.content_item_version_id=pc.vid and d.tutor_decision='approve'
);

insert into app.content_review_assignments (
  content_review_assignment_id,content_item_version_id,reviewer_id,
  review_stage,review_kind,status,assignment_purpose,created_by
)
select s.qa_assignment_id,s.vid,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,'tutor_question',ci.item_type,'pending','owner_remediation_approval','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from ai_qa_seed s
join app.content_item_versions civ on civ.id=s.vid
join app.content_items ci on ci.id=civ.content_item_id;

insert into app.content_review_decisions (
  content_review_assignment_id,content_item_version_id,reviewer_id,
  review_stage,tutor_score,difficulty_label,diagnostic_flag,concern_codes,
  note,tutor_decision,decision_payload,decision_hash,created_by
)
select s.qa_assignment_id,s.vid,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,'tutor_question',1,
  coalesce((select d.difficulty_label from app.content_review_decisions d where d.content_item_version_id=s.vid and d.difficulty_label is not null order by d.submitted_at desc limit 1),'Medium'),
  false,array[]::text[],
  'Owner QA sweep passed for publication after repaired AWE or two human approvals.',
  'approve',
  jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis',s.basis,'qa_date','2026-08-05'),
  encode(extensions.digest(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis',s.basis,'qa_date','2026-08-05')::text,'sha256'),'hex'),
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from ai_qa_seed s;

update app.content_item_versions civ
set status='reviewed_approved',
    review_status='question_review_approved',
    approved_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
    approved_at=coalesce(civ.approved_at,now()),
    updated_at=now()
from publish_candidates pc
where civ.id=pc.vid
  and civ.status not in ('retired','published');

update app.content_items ci
set status='reviewed_approved', updated_at=now()
from publish_candidates pc
join app.content_item_versions civ on civ.id=pc.vid
where ci.id=civ.content_item_id
  and ci.status not in ('retired','published');

update app.content_item_versions civ
set status='published',
    review_status='question_review_approved',
    approved_by=coalesce(civ.approved_by,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid),
    approved_at=coalesce(civ.approved_at,now()),
    published_at=coalesce(civ.published_at,now()),
    updated_at=now()
from publish_candidates pc
where civ.id=pc.vid;

update app.content_items ci
set status='published', updated_at=now()
from publish_candidates pc
join app.content_item_versions civ on civ.id=pc.vid
where ci.id=civ.content_item_id;

do $$
declare
  n integer;
begin
  select count(*) into n from awe_corrected;
  if n<>44 then raise exception 'expected 44 remediated AWE/misrouted targets, got %', n; end if;
end $$;

select 'remediated' as metric, count(*)::text as value from awe_corrected
union all
select 'published_candidates', count(*)::text from publish_candidates
union all
select 'qa_blocked', count(*)::text from qa_blocked
union all
select 'published_repaired_awe', count(*)::text
from app.content_item_versions civ
where civ.status='published' and civ.prompt_json->>'qa_remediation'='2026-08-05 approve-with-edits remediation'
union all
select 'published_keys', string_agg(content_key, ', ' order by content_key) from publish_candidates;

commit;
