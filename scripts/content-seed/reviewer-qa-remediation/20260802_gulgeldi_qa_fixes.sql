-- Gulgeldi QA follow-up fixes (2026-08-02), per owner instruction.
--
-- 1. apchem-mcq-038 v2: v1 keyed simple distillation as fully separating
--    ethanol/water, whose 95.6% azeotrope makes complete separation by simple
--    distillation impossible; the stem's "significantly different boiling
--    points" premise was also wrong (78.4 vs 100 C, a 22 C gap). Confirmed
--    defect: Saood disapproval 2026-07-30 + owner QA 2026-07-31 + Gulgeldi QA
--    2026-08-02. v2 uses acetone/water (44 C gap, no azeotrope) so the keyed
--    distillation reasoning is correct. v2 lands as draft and is assigned to
--    Gulgeldi (packet B) and to Saood (the v1 disapprover) for re-review.
--
-- 2. apchem-sfrq-008 v3: applies ALL outstanding reviewer edits that were
--    stranded in note text: Gulgeldi 2026-08-02 (parts (b)/(d) leak their own
--    answers; filed as plain approve so the edit never entered the workflow),
--    Saood 2026-07-31 (part (d) scenario is wrong for solid-into-solution;
--    must be X- added to an already-saturated solution; add dissolution
--    equation + no-side-reactions assumption; (a)/(b) overlap), Zeeshan
--    2026-07-28 (rubric criteria must show the full worked answers).
--
-- 3. apchem-sfrq-018 v2: applies Saood 2026-07-30 edits (stem's "similar
--    molar mass" claim is factually wrong: ethanol 46.1 vs diethyl ether
--    74.1 g/mol; part (c) justification must use the evaporation/condensation
--    equilibrium, not evaporation rate alone; degree notation) plus the
--    rubric relabel (a1-a3 -> part-a/b/c) that both Saood and Gulgeldi
--    requested, Gulgeldi's copy stranded in a plain-approve note.
--
-- Original reviewer decisions are not modified. Predecessors are retired and
-- their open assignments skipped, following the 2026-07-31 remediation pattern.

begin;
select pg_advisory_xact_lock(hashtext('cramapple-gulgeldi-qa-fixes-20260802'));

create temporary table fix_map on commit drop as
select ci.id item_id, civ.id old_vid, ci.content_key,
       gen_random_uuid() new_vid, civ.version_num+1 nv
from app.content_items ci
join app.content_item_versions civ on civ.content_item_id=ci.id
where ci.content_key in ('apchem-mcq-038','apchem-sfrq-008','apchem-sfrq-018')
  and civ.status<>'retired'
  and not exists (select 1 from app.content_item_versions n
                  where n.content_item_id=ci.id and n.version_num>civ.version_num);

do $$ declare n int; begin
  select count(*) into n from fix_map;
  if n<>3 then raise exception 'expected 3 fix targets, found %', n; end if;
end $$;

-- New versions: copy predecessor, override stem/stimulus per fix.
insert into app.content_item_versions (
  id,content_item_id,version_num,stem,stimulus,prompt_json,explanation,help_text,
  content_hash,status,created_by,canonical_answer_1,canonical_answer_2,
  review_status,rubric_type,evaluator_strategy,stimulus_image_path)
select m.new_vid, m.item_id, m.nv,
  case m.content_key
    when 'apchem-mcq-038' then
'A chemist needs to recover acetone (boiling point 56 °C) from a homogeneous mixture of acetone and water (boiling point 100 °C). The two liquids are miscible and do not form an azeotrope. Which technique is most appropriate, and why?

A. Filtration, because it separates the two liquids based on differences in particle size.
B. Distillation, because heating the mixture selectively vaporizes the lower-boiling acetone, which can then be condensed and collected separately from the higher-boiling water.
C. Paper chromatography, because it separates substances based on their particle size as they pass through the paper.
D. Recrystallization, because cooling the mixture causes the higher-boiling liquid to solidify out of solution.'
    when 'apchem-sfrq-008' then
'Answer all parts of the following question.

(a) Write the solubility-product expression for MX and calculate its molar solubility, s, in pure water.

(b) Identify one assumption about the pure-water solution that is required for your calculation in part (a) to be valid, and explain why it is needed.

(c) Calculate the molar solubility of MX in a solution that is already 0.010 M in X⁻. Justify any approximation you make.

(d) A saturated solution of MX is at equilibrium. A small amount of a soluble salt containing X⁻ is then dissolved in the solution. Using a comparison of Qsp and Ksp, predict what will be observed and explain your reasoning.'
    when 'apchem-sfrq-018' then
'The table above shows the vapor pressure of two small oxygen-containing molecular liquids, measured at the same temperature.

(a) Identify the strongest intermolecular force present in diethyl ether and the strongest intermolecular force present in ethanol.

(b) Explain why diethyl ether has a much higher vapor pressure than ethanol at 20 °C, even though ethanol has the smaller molar mass.

(c) Predict how the equilibrium vapor pressure of ethanol would change if the temperature were increased from 20 °C to 40 °C. Justify your prediction using particle-level reasoning.'
  end,
  case m.content_key
    when 'apchem-sfrq-008' then
'The solubility-product constant for MX is Ksp = 4.0×10⁻¹². MX dissolves according to MX(s) ⇌ M⁺(aq) + X⁻(aq). Assume no acid–base reactions, complex-ion formation, or other side reactions occur.'
    else o.stimulus
  end,
  coalesce(o.prompt_json,'{}'::jsonb) || jsonb_build_object(
    'content_version', m.nv,
    'qa_remediation', '2026-08-02 Gulgeldi QA follow-up (owner-directed): '
      || case m.content_key
           when 'apchem-mcq-038' then 'azeotrope-flawed premise replaced with acetone/water'
           when 'apchem-sfrq-008' then 'answer leaks removed; part (d) scenario corrected; worked rubric'
           when 'apchem-sfrq-018' then 'false molar-mass claim removed; equilibrium framing; rubric relabel'
         end),
  o.explanation, o.help_text, md5(coalesce(o.stem,'')||m.content_key||m.nv::text),
  'draft', 'f5a26c6b-3566-4d58-9e97-979fbb947564',
  o.canonical_answer_1, o.canonical_answer_2, null,
  o.rubric_type, o.evaluator_strategy, o.stimulus_image_path
from fix_map m join app.content_item_versions o on o.id=m.old_vid;

-- mcq-038 v2 choices.
insert into app.mcq_choices (content_item_version_id,choice_key,choice_text,is_correct,rationale)
select m.new_vid, v.k, v.txt, v.ok, v.rat
from fix_map m,
(values
  ('A','Filtration, because it separates the two liquids based on differences in particle size.',false,
   'Incorrect. Filtration separates insoluble solids from liquids based on particle size; it cannot separate two liquids that are miscible with each other.'),
  ('B','Distillation, because heating the mixture selectively vaporizes the lower-boiling acetone, which can then be condensed and collected separately from the higher-boiling water.',true,
   'Correct. Acetone and water differ in boiling point by about 44 °C and do not form an azeotrope, so heating selectively vaporizes the lower-boiling acetone; the vapor is condensed and collected, leaving the higher-boiling water behind.'),
  ('C','Paper chromatography, because it separates substances based on their particle size as they pass through the paper.',false,
   'Incorrect. Chromatography separates components by differential partitioning between a stationary and a mobile phase, not particle size, and is an analytical-scale technique poorly suited to bulk recovery of a liquid.'),
  ('D','Recrystallization, because cooling the mixture causes the higher-boiling liquid to solidify out of solution.',false,
   'Incorrect. Recrystallization purifies solids using temperature-dependent solubility; it does not apply to separating two miscible liquids.')
) v(k,txt,ok,rat)
where m.content_key='apchem-mcq-038';

-- sfrq-008 v3 rubric: full worked answers (Zeeshan), corrected (d) (Saood), no leaks (Gulgeldi).
insert into app.frq_criteria (content_item_version_id,criterion_key,learner_facing_text,points_possible,evidence_requirements,minimum_fix,accepted_variants)
select m.new_vid, v.k, v.txt, v.pts, v.ev, v.fix, v.var
from fix_map m,
(values
  ('part-a','Writes Ksp = [M⁺][X⁻]; in pure water the only source of ions is MX, so [M⁺] = [X⁻] = s and Ksp = s². Solves s = √(4.0×10⁻¹²) = 2.0×10⁻⁶ M.',1,
   'Correct Ksp expression, the s² substitution, and the value 2.0×10⁻⁶ M.',
   'State Ksp = s² for the 1:1 salt and compute s = 2.0×10⁻⁶ M.',
   'Any algebraically equivalent setup; 1 significant-figure tolerance on the value.'),
  ('part-b','States the required assumption: the pure water initially contains no M⁺ or X⁻ from any other source (no common ion and no side reactions), so the dissolved MX alone fixes [M⁺] = [X⁻] = s; without it the s² substitution is invalid.',1,
   'Identifies the no-other-ion-source (no common ion) assumption and links it to the validity of [M⁺] = [X⁻].',
   'Name the no-common-ion assumption.',
   'Equivalent phrasing such as "all M⁺ and X⁻ come from dissolving MX" is acceptable.'),
  ('part-c','Sets Ksp = s(0.010 + s), justifies neglecting s because s ≪ 0.010 M, and computes s ≈ Ksp/0.010 = 4.0×10⁻¹²/0.010 = 4.0×10⁻¹⁰ M.',1,
   'The exact expression or its justified approximation, plus the value 4.0×10⁻¹⁰ M.',
   'Compute s = Ksp/0.010 = 4.0×10⁻¹⁰ M with the smallness justification.',
   'Accept unjustified s(0.010) setup only if the final value is correct and s ≪ 0.010 is stated anywhere.'),
  ('part-d','Predicts that additional solid MX forms (precipitation): the added X⁻ raises [X⁻], so Qsp = [M⁺][X⁻] > Ksp; the net reaction runs toward solid MX until Qsp = Ksp is restored, leaving a lower dissolved [M⁺] (lower solubility).',1,
   'The Qsp > Ksp comparison, the direction of shift, and the observable outcome (solid forms / solubility decreases).',
   'State Qsp > Ksp after the addition and that MX precipitates until Qsp = Ksp.',
   'Le Châtelier phrasing acceptable if the Qsp/Ksp comparison is explicit.')
) v(k,txt,pts,ev,fix,var)
where m.content_key='apchem-sfrq-008';

-- sfrq-018 v2 rubric: relabeled, part (b) molar-mass contrast, part (c) equilibrium framing.
insert into app.frq_criteria (content_item_version_id,criterion_key,learner_facing_text,points_possible,evidence_requirements,minimum_fix,accepted_variants)
select m.new_vid, v.k, v.txt, v.pts, v.ev, v.fix, v.var
from fix_map m,
(values
  ('part-a','Correctly identifies dipole-dipole forces as the strongest intermolecular force in diethyl ether and hydrogen bonding as the strongest intermolecular force in ethanol.',1,
   'Both identifications must be present and correctly paired to the liquids.',
   'Name dipole-dipole for diethyl ether and hydrogen bonding for ethanol.',
   'Mentioning London dispersion in addition is acceptable and not required.'),
  ('part-b','Explains that ethanol molecules hydrogen bond through the O–H group while diethyl ether molecules cannot act as hydrogen-bond donors and experience only weaker dipole-dipole (plus dispersion) attractions; the stronger attractions in ethanol make escape into the vapor phase less favorable, so ethanol has the far lower vapor pressure even though its molar mass (≈46 g/mol) is smaller than diethyl ether''s (≈74 g/mol).',2,
   'Links the specific intermolecular-force difference to relative ease of escape into the vapor phase; notes the comparison holds despite ethanol''s smaller molar mass.',
   'Attribute the vapor-pressure gap to hydrogen bonding in ethanol vs weaker attractions in diethyl ether.',
   'The molar-mass contrast may be implicit if the hydrogen-bonding explanation is complete.'),
  ('part-c','Predicts that ethanol''s equilibrium vapor pressure increases at 40 °C: higher temperature raises the average kinetic energy so a greater fraction of molecules can escape the liquid; evaporation initially exceeds condensation until a new dynamic equilibrium is established at a higher vapor concentration and pressure.',1,
   'Direction (increase) plus particle-level reasoning that reaches the new evaporation/condensation equilibrium, not evaporation rate alone.',
   'State the increase and the kinetic-energy/escaping-fraction mechanism with the new equilibrium.',
   'Boltzmann-distribution phrasing acceptable.')
) v(k,txt,pts,ev,fix,var)
where m.content_key='apchem-sfrq-018';

-- Point-preservation and structure checks on the new versions.
do $$ declare bad text; begin
  select string_agg(t.content_key,', ') into bad from (
    select m.content_key from fix_map m
    where (m.content_key='apchem-mcq-038' and (
            (select count(*) from app.mcq_choices c where c.content_item_version_id=m.new_vid)<>4
         or (select count(*) from app.mcq_choices c where c.content_item_version_id=m.new_vid and c.is_correct)<>1))
       or (m.content_key='apchem-sfrq-008' and
            (select coalesce(sum(f.points_possible),0) from app.frq_criteria f where f.content_item_version_id=m.new_vid)<>4)
       or (m.content_key='apchem-sfrq-018' and
            (select coalesce(sum(f.points_possible),0) from app.frq_criteria f where f.content_item_version_id=m.new_vid)<>4)
  ) t;
  if bad is not null then raise exception 'fix structure check failed: %', bad; end if;
end $$;

-- Retire predecessors, skip their open assignments, reset item status.
update app.content_review_assignments set status='skipped'
where content_item_version_id in (select old_vid from fix_map)
  and status in ('pending','in_progress');

update app.content_item_versions set status='retired', updated_at=now()
where id in (select old_vid from fix_map);

update app.content_items set status='draft', updated_at=now()
where id in (select item_id from fix_map);

-- mcq-038 v2 re-review by the v1 disapprover (Saood). Gulgeldi's assignment
-- comes with packet B (20260802_gulgeldi_two_packets_25.sql).
insert into app.content_review_assignments (
  content_item_version_id, reviewer_id, review_stage, review_kind, status,
  assignment_purpose, created_by)
select m.new_vid, p.user_id, 'tutor_question', 'mcq', 'pending',
  'subject_review', 'f5a26c6b-3566-4d58-9e97-979fbb947564'
from fix_map m
join app.profiles p on p.full_name='Muhammad Saood' and p.role='tutor'
where m.content_key='apchem-mcq-038';

commit;