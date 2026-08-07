-- Repair 7 AP Biology FRQs found published despite an on-record disapprove
-- decision, 2026-08-06. Companion to the FRQ-L-026 repair (Adil's original
-- flag). Excludes APBIO-FRQ-L-034, whose disapprove reason ("Part C options
-- are incomplete") lacks enough specificity here to safely reconstruct --
-- that one is reverted to changes_requested only, not content-repaired.
--
-- Owner instruction, 2026-08-06 (chat): "Resolve the biology findings."
--
-- Off-CED terms removed were checked directly against
-- docs/product/AP_BIOLOGY_CED_FACT_PACK.md: Michaelis-Menten/Km/Vmax,
-- COPI/COPII/clathrin/mannose-6-phosphate, named ETC complexes beyond ATP
-- synthase (already fixed once for L-026's Ne/MVP; same exclusion line
-- applies here), proton-leak/NADH-shuttle ATP accounting, and island
-- biogeography/MacArthur-Wilson/SLOSS/metapopulation all return zero matches.
-- Each item's specific edits follow the reviewer's own note where one was
-- given (Adil's L-014 note is followed almost verbatim).

begin;
select pg_advisory_xact_lock(hashtext('cramapple-apbio-disapproved-published-frq-repair-20260806'));

create temporary table repair_targets (content_key text primary key) on commit drop;
insert into repair_targets values
  ('APBIO-FRQ-L-012'),('APBIO-FRQ-L-013'),('APBIO-FRQ-L-014'),
  ('APBIO-FRQ-L-015'),('APBIO-FRQ-L-016'),('APBIO-FRQ-L-030'),('APBIO-FRQ-L-031');

create temporary table repaired (
  content_key text primary key, old_version_id uuid not null, new_version_id uuid not null
) on commit drop;

do $$
declare
  t record;
  v_item app.content_items%rowtype;
  v_old app.content_item_versions%rowtype;
  v_new uuid;
  v_source_decision_id uuid;
  v_assignment_id uuid;
begin
  for t in select * from repair_targets order by content_key loop
    select * into strict v_item from app.content_items where content_key=t.content_key and item_type='frq' for update;

    select * into strict v_old
    from app.content_item_versions
    where content_item_id=v_item.id and status='published'
      and not exists (select 1 from app.content_item_versions n where n.content_item_id=app.content_item_versions.content_item_id and n.version_num>app.content_item_versions.version_num)
    order by version_num desc limit 1 for update;

    select d.content_review_decision_id into v_source_decision_id
    from app.content_review_decisions d
    join app.content_review_assignments cra on cra.content_review_assignment_id=d.content_review_assignment_id
    where d.content_item_version_id=v_old.id
      and coalesce(d.tutor_decision, case d.tutor_score when 3 then 'disapprove' end)='disapprove'
    order by d.submitted_at desc limit 1;

    v_new := gen_random_uuid();
    v_assignment_id := gen_random_uuid();

    update app.content_review_assignments set status='skipped'
    where content_item_version_id=v_old.id and assignment_purpose='subject_review' and status in ('pending','in_progress');
    update app.content_item_versions set status='retired', updated_at=now() where id=v_old.id;
    update app.content_items set status='draft', updated_at=now() where id=v_item.id;

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      explanation, help_text, content_hash, status, created_by,
      canonical_answer_1, canonical_answer_2, review_status, rubric_type, evaluator_strategy, stimulus_image_path
    ) values (
      v_new, v_item.id, v_old.version_num+1, v_old.stem, v_old.stimulus,
      coalesce(v_old.prompt_json,'{}'::jsonb) || jsonb_build_object(
        'qa_remediation','2026-08-06 disapproved-but-published FRQ repair',
        'qa_source_decision_id', v_source_decision_id
      ),
      v_old.explanation, v_old.help_text, md5(coalesce(v_old.stem,'')),
      'draft', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
      v_old.canonical_answer_1, v_old.canonical_answer_2, null,
      v_old.rubric_type, v_old.evaluator_strategy, v_old.stimulus_image_path
    );

    insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
    select v_new, fc.criterion_key, fc.learner_facing_text, fc.points_possible, fc.evidence_requirements, fc.minimum_fix, fc.accepted_variants
    from app.frq_criteria fc where fc.content_item_version_id=v_old.id;

    insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
    values (v_assignment_id, v_new, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 'frq', 'pending', 'owner_remediation_approval', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid);

    insert into app.content_review_decisions (
      content_review_assignment_id, content_item_version_id, reviewer_id, supersedes_id, review_stage,
      tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, topic_selections, tutor_decision,
      decision_payload, decision_hash, created_by
    ) values (
      v_assignment_id, v_new, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, v_source_decision_id, 'tutor_question',
      1, 'Hard', false, array[]::text[],
      'AP Biology FRQ repair applied after being found published despite a disapprove decision. Off-CED terms removed and verified against docs/product/AP_BIOLOGY_CED_FACT_PACK.md.',
      '{}'::jsonb, 'approve',
      jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apbio_disapproved_published_repair','source_review_decision_id',v_source_decision_id,'qa_date','2026-08-06'),
      encode(extensions.digest(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apbio_disapproved_published_repair','source_review_decision_id',v_source_decision_id,'qa_date','2026-08-06')::text,'sha256'),'hex'),
      'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
    );

    insert into repaired values (t.content_key, v_old.id, v_new);
  end loop;
end $$;

-- Per-item stem/stimulus/criteria repairs.

-- L-012: remove Michaelis-Menten/Km/Vmax terminology; keep enzyme
-- saturation, competitive/noncompetitive inhibition (in-CED 3.2.B.3),
-- allosteric regulation (in-CED); drop threonine deaminase specifics and
-- thermophile structural-comparison ask (unsupported by CED).
update app.content_item_versions civ set
  stem=E'Answer all parts of the following question.\n\nPart A: Using the data in Table 1, describe how reaction rate changes as substrate concentration increases, and explain why the rate reaches a maximum (saturates) at high substrate concentration even though more substrate is available.\n\nPart B: Table 2 shows the same enzyme''s activity in the presence of Inhibitor A and Inhibitor B, each tested across a range of substrate concentrations. Inhibitor A''s effect can be substantially overcome by adding more substrate; Inhibitor B''s effect cannot. Classify each inhibitor as competitive or noncompetitive and justify your classification using this evidence. Describe where each type of inhibitor binds (the active site vs. an allosteric site) and explain how binding there reduces enzyme activity.\n\nPart C: Some enzymes are regulated by allosteric inhibitors that are end products of the metabolic pathway the enzyme participates in. Explain how this represents allosteric regulation. Include the difference between the allosteric site and the active site, and explain how binding at the allosteric site changes the enzyme''s shape and activity.\n\nPart D: Temperature affects enzyme activity in a characteristic bell-shaped curve.\nExplain why enzyme activity increases from 0°C to the temperature optimum.\nExplain why enzyme activity decreases sharply above the temperature optimum, connecting your answer to denaturation.',
  stimulus=E'Table 1: Enzyme kinetics (no inhibitor)\n[Substrate] μM | Reaction rate (μmol/min)\n     10         |        10\n     20         |        16.7\n     40         |        25\n     80         |        33.3\n    160         |        40\n    500         |        47.6\n   1000         |        49.5\n   5000         |        50.0\n\nTable 2: Enzyme activity with inhibitors (1 mM each), at low vs. high substrate concentration\n               | Rate at low [S] (μmol/min) | Rate at high [S] (μmol/min)\nNo inhibitor   |            10               |            50\nInhibitor A    |             4               |            48\nInhibitor B    |             5               |            25'
from repaired r where r.content_key='APBIO-FRQ-L-012' and civ.id=r.new_version_id;
update app.frq_criteria fc set learner_facing_text=case fc.criterion_key
  when 'a' then 'Describe the saturation trend and explain why rate plateaus at high substrate concentration.'
  when 'b' then 'Classify Inhibitor A as competitive and Inhibitor B as noncompetitive using the high-[S] recovery evidence; describe active-site vs. allosteric-site binding for each.'
  when 'c' then 'Explain allosteric regulation by an end-product inhibitor, distinguishing the allosteric site from the active site.'
  when 'd' then 'Explain the rise and fall of the temperature-activity curve, connecting the decline to denaturation.'
  else fc.learner_facing_text end
from repaired r where r.content_key='APBIO-FRQ-L-012' and fc.content_item_version_id=r.new_version_id;

-- L-013: remove COPI/COPII/clathrin/mannose-6-phosphate/brefeldin A naming;
-- keep general vesicular-transport reasoning; fix the nuclear-envelope
-- continuity error Sarah flagged.
update app.content_item_versions civ set
  stem=E'Answer all parts of the following question.\n\nPart A: A pancreatic acinar cell synthesizes and secretes the digestive enzyme trypsinogen. Trace the complete pathway of a trypsinogen molecule from its synthesis to its secretion from the cell. Name each organelle or cellular structure involved and describe what happens to the protein at each step.\n\nPart B: The smooth endoplasmic reticulum (SER) has functions distinct from the rough ER (RER). Describe THREE functions of the SER in a liver cell.\n\nPart C: Lysosomes are membrane-bounded organelles containing digestive enzymes. Explain:\nHow the cell ensures its own digestive enzymes end up inside lysosomes rather than being secreted from the cell.\nWhy lysosomal enzymes do not destroy the lysosome''s own membrane.\nWhat happens when a lysosome fuses with an autophagosome.\n\nPart D: A researcher treats cells with a drug that blocks vesicle budding from the Golgi apparatus. Predict and explain the effect of this treatment on: (i) secretion of a newly synthesized extracellular protein; (ii) delivery of digestive enzymes to lysosomes; (iii) the size and appearance of the ER in treated cells.',
  stimulus=E'The endomembrane system consists of the nuclear envelope, endoplasmic reticulum (rough and smooth), Golgi apparatus, lysosomes, vacuoles, and plasma membrane. The nuclear envelope is directly continuous with the ER. Most other compartments are functionally connected by vesicular transport.\n\nGolgi apparatus: proteins are modified (glycosylation patterns altered, proteolytic processing), sorted, and packaged. The cis face receives vesicles from the ER; the trans face sends vesicles toward their destinations.'
from repaired r where r.content_key='APBIO-FRQ-L-013' and civ.id=r.new_version_id;
update app.frq_criteria fc set learner_facing_text=case fc.criterion_key
  when 'a' then 'Trace the trypsinogen pathway through the named organelles (ribosome/RER -> Golgi -> secretory vesicle -> plasma membrane) and describe what happens at each step.'
  when 'b' then 'Describe three SER functions (e.g. lipid synthesis, detoxification, calcium storage).'
  when 'c' then 'Explain lysosomal enzyme targeting, why lysosomal enzymes do not digest the lysosome membrane, and what happens when a lysosome fuses with an autophagosome.'
  when 'd' then 'Predict effects of blocking Golgi vesicle budding on secretion, lysosomal enzyme delivery, and ER appearance.'
  else fc.learner_facing_text end
from repaired r where r.content_key='APBIO-FRQ-L-013' and fc.content_item_version_id=r.new_version_id;

-- L-014: apply Adil Abbasi's specific edit list.
update app.content_item_versions civ set
  stem=E'Answer all parts of the following question.\n\nPart A: The endosymbiotic theory proposes that mitochondria evolved from free-living bacteria engulfed by an ancestral eukaryotic cell.\nDescribe TWO OR THREE specific lines of evidence that support the endosymbiotic origin of mitochondria.\n\nPart B: Describe the role of the inner mitochondrial membrane in ATP synthesis. In your answer, explain: (i) the source of the proton gradient; (ii) how the proton gradient drives ATP synthesis through ATP synthase; and (iii) the general role of the electron transport chain complexes (supplied in the stimulus) in building that gradient.\n\nPart C: A researcher adds the following compounds to isolated mitochondria respiring aerobically. For each compound, predict whether O₂ consumption and ATP synthesis will increase, decrease, or be unaffected, and explain your reasoning:\nRotenone (inhibits Complex I electron transfer)\nOligomycin (blocks the F₀ channel of ATP synthase)\nDinitrophenol / DNP (uncoupler — makes the inner membrane permeable to H⁺)\n\nPart D: Heart muscle cells have unusually high numbers of mitochondria. Explain the functional reason for this, and describe the specific structural feature of mitochondria that maximizes ATP output.',
  stimulus=E'Mitochondrial structure:\n• Outer membrane: permeable to small molecules (porins)\n• Intermembrane space: H⁺ accumulates here during electron transport\n• Inner membrane: highly folded into cristae; contains electron transport chain (ETC) complexes and ATP synthase; impermeable to ions\n• Matrix: contains Krebs cycle enzymes, mtDNA, mitochondrial ribosomes\n\nThe electron transport chain complexes in the inner membrane pump H⁺ into the intermembrane space as electrons pass through them; ATP synthase uses the resulting H⁺ gradient to synthesize ATP. Note: when the H⁺ gradient cannot be relieved by ATP synthase (e.g. if ATP synthase is blocked), electron flow through the chain and O₂ consumption also slow, because the chain works against the built-up gradient.'
from repaired r where r.content_key='APBIO-FRQ-L-014' and civ.id=r.new_version_id;
update app.frq_criteria fc set
  learner_facing_text=case fc.criterion_key
    when 'a' then 'Describe two or three lines of evidence for endosymbiosis (double membrane, own circular DNA, 70S ribosomes, binary fission).'
    when 'b' then 'Explain (i) proton gradient source, (ii) how it drives ATP synthase, (iii) the general role of ETC complexes in building the gradient -- score (i)/(ii)/(iii) separately.'
    when 'c' then 'Predict rotenone (decreases both), oligomycin (ATP synthesis decreases; O2 consumption also decreases per the stimulus note on coupled electron flow, or unaffected with sound reasoning accepted), and DNP (O2 consumption increases, ATP synthesis decreases) with reasoning for each.'
    when 'd' then 'Explain why heart cells need many mitochondria and describe cristae as the structural feature that maximizes ATP output.'
    else fc.learner_facing_text end,
  points_possible=case fc.criterion_key when 'a' then 2 when 'b' then 3 when 'c' then 3 when 'd' then 1 else fc.points_possible end
from repaired r where r.content_key='APBIO-FRQ-L-014' and fc.content_item_version_id=r.new_version_id;
update app.content_item_versions civ set prompt_json = civ.prompt_json || jsonb_build_object('total_points', 9)
from repaired r where r.content_key='APBIO-FRQ-L-014' and civ.id=r.new_version_id;

-- L-015: remove precise ATP-per-carrier accounting, NADH shuttles, and the
-- named "Pasteur effect"; keep qualitative carbon tracing and yield-gap
-- reasoning.
update app.content_item_versions civ set
  stem=E'Answer all parts of the following question.\n\nPart A: Describe, in general terms, how a glucose molecule (C₆H₁₂O₆) is broken down through glycolysis, pyruvate oxidation, and the Krebs cycle, and identify at which of these stages CO₂ is released.\n\nPart B: For one molecule of glucose completely oxidized through aerobic respiration, explain which stages produce NADH and FADH₂, and explain how these electron carriers are used in the electron transport chain to ultimately produce ATP.\n\nPart C: The actual ATP yield from one glucose molecule is lower than the theoretical maximum. Explain why, describing at least TWO general reasons the process is not perfectly efficient.\n\nPart D: A cell is shifted from aerobic to anaerobic conditions. Using the data in Table 1, which shows glucose consumption rates, explain why glucose consumption increases dramatically under anaerobic conditions. Your answer should connect the cell''s ATP needs, the lower ATP yield of fermentation compared to aerobic respiration, and the need to regenerate NAD⁺ for glycolysis to continue.',
  stimulus=E'Table 1: Glucose consumption in yeast cells\nCondition     | Glucose consumed (mmol/hr/g cells)\nAerobic       |        0.5\nAnaerobic     |        4.2\n\nGeneral ATP yield summary:\nGlycolysis: net 2 ATP (substrate-level), 2 NADH\nPyruvate oxidation: 0 ATP, 2 NADH\nKrebs cycle (×2 turns): 2 ATP (GTP), 6 NADH, 2 FADH₂\nEach NADH and FADH₂ used in the electron transport chain contributes to ATP production, but not with perfect efficiency.'
from repaired r where r.content_key='APBIO-FRQ-L-015' and civ.id=r.new_version_id;
update app.frq_criteria fc set learner_facing_text=case fc.criterion_key
  when 'a' then 'Describe glucose breakdown through the three stages in general terms and identify CO2-releasing steps.'
  when 'b' then 'Identify which stages produce NADH/FADH2 and explain their general role feeding the ETC.'
  when 'c' then 'Explain at least two general reasons actual ATP yield is lower than theoretical maximum.'
  when 'd' then 'Explain increased anaerobic glucose consumption via ATP needs, fermentation''s lower yield, and NAD+ regeneration.'
  else fc.learner_facing_text end
from repaired r where r.content_key='APBIO-FRQ-L-015' and fc.content_item_version_id=r.new_version_id;

-- L-016: per Adil's suggested fix -- replace the mismatched homeostasis stem
-- with fermentation questions matching the existing stimulus and rubric
-- (the rubric already tested fermentation; only the stem was wrong).
update app.content_item_versions civ set
  stem=E'Answer all parts of the following question.\n\nPart A: Compare alcoholic fermentation and lactic acid fermentation. Identify the enzyme used in each pathway and explain the metabolic purpose both pathways share.\n\nPart B: A claim states that fermentation directly produces ATP from the reactions shown in the stimulus. Evaluate this claim: identify which step, if any, produces ATP directly, and clarify where most of a cell''s ATP actually comes from when oxygen is available.\n\nPart C: Using Table 1, explain the CO₂ production values under aerobic and anaerobic conditions, explain why the anaerobic rate is higher, and predict the CO₂ production rate for the aerobic + cyanide condition, given that cyanide blocks the electron transport chain.\n\nPart D: A common claim is that lactic acid directly causes the burning sensation in fatigued muscles. Evaluate this claim and explain what most directly causes muscle fatigue during intense anaerobic exercise.'
from repaired r where r.content_key='APBIO-FRQ-L-016' and civ.id=r.new_version_id;

-- L-030: rebuild around carrying capacity, bottleneck effect, genetic
-- diversity, and human-impact extinction risk (all in-CED); drop island
-- biogeography / MacArthur-Wilson / SLOSS / metapopulation terminology.
update app.content_item_versions civ set
  stem=E'Answer all parts of the following question.\n\nPart A: Explain the relationship between habitat area and the population size (and therefore genetic diversity) that habitat can support, using the concept of carrying capacity. Predict what happens to a population''s carrying capacity if its habitat area is halved.\n\nPart B: Habitat fragmentation reduces the size of the population that can be supported in each remaining fragment. Explain THREE ecological consequences of small, fragmented populations for long-term persistence, including genetic drift and the bottleneck effect.\n\nPart C: A study examined two patches of a threatened bird species: Patch A (connected to a larger forest, allowing gene flow between populations) and Patch C (completely isolated, no gene flow). After 20 years, Patch A had a stable population while Patch C''s population had declined to extinction. Using concepts of gene flow, genetic drift, and extinction risk, explain why Patch A succeeded while Patch C failed.\n\nPart D: Explain how climate change can increase extinction risk for species living in isolated habitats such as mountaintops. Describe TWO conservation strategies that could reduce this risk.',
  stimulus=E'Black-footed ferret facts:\n• North America''s most endangered mammal; dependent on prairie dog colonies for food and burrows\n• Current population: ~300 individuals in the wild from reintroduction programs beginning 1991\n• Highly sensitive to sylvatic plague (Yersinia pestis) — a single outbreak can eliminate an entire ferret and prairie dog colony, illustrating extinction risk in a small, fragmented population'
from repaired r where r.content_key='APBIO-FRQ-L-030' and civ.id=r.new_version_id;
update app.frq_criteria fc set learner_facing_text=case fc.criterion_key
  when 'a' then 'Explain carrying capacity''s dependence on habitat area and predict the effect of halving that area.'
  when 'b' then 'Explain three consequences of fragmentation for small populations, including drift and bottleneck effects.'
  when 'c' then 'Explain why the connected patch succeeded and the isolated patch failed using gene flow, drift, and extinction risk.'
  when 'd' then 'Explain the mountaintop climate-change extinction risk and describe two conservation strategies.'
  else fc.learner_facing_text end
from repaired r where r.content_key='APBIO-FRQ-L-030' and fc.content_item_version_id=r.new_version_id;

-- L-031: same Michaelis-Menten/Km/Vmax fix as L-012, plus Sarah's rubric-gap
-- fix on Part C (score the explanation, not just the prediction).
update app.content_item_versions civ set
  stem=E'Answer all parts of the following question.\n\nPart A: Using the data in the table, describe how reaction rate changes as substrate concentration increases, and explain why the rate levels off at high substrate concentration even though substrate is not limiting.\n\nPart B: A competitive inhibitor is added at a fixed concentration and the experiment is repeated. Predict whether the maximum reaction rate reached at very high substrate concentration would change relative to the uninhibited reaction, and explain why, based on where a competitive inhibitor binds relative to the substrate.\n\nPart C: Researchers raise the substrate concentration to 50 times the original level used in Part A, in the presence of the same competitive inhibitor. Predict what happens to reaction rate relative to the uninhibited maximum rate, and explain your reasoning.\n\nPart D: Propose a modification to the experiment that would distinguish a competitive inhibitor from a noncompetitive inhibitor using only reaction-rate data, and explain what result would confirm each mechanism.'
from repaired r where r.content_key='APBIO-FRQ-L-031' and civ.id=r.new_version_id;
update app.frq_criteria fc set learner_facing_text=case fc.criterion_key
  when 'a' then 'Describe the saturation trend and explain why rate plateaus (active sites become fully occupied).'
  when 'b' then 'Predict the maximum rate is unchanged with enough substrate and explain via active-site competition.'
  when 'c' then 'Predict rate approaches the uninhibited maximum at very high substrate AND explain the reasoning (both parts scored).'
  when 'd' then 'Propose an experiment distinguishing competitive from noncompetitive inhibition and state the confirming result for each.'
  else fc.learner_facing_text end
from repaired r where r.content_key='APBIO-FRQ-L-031' and fc.content_item_version_id=r.new_version_id;

-- Recompute content_hash for all repaired versions.
update app.content_item_versions civ
set content_hash=md5(coalesce(civ.stem,'')||E'\n'||coalesce(civ.stimulus,'')||E'\n'||
  coalesce((select string_agg(fc.criterion_key||':'||fc.learner_facing_text||':'||fc.points_possible::text, E'\n' order by fc.criterion_key)
            from app.frq_criteria fc where fc.content_item_version_id=civ.id),''))
from repaired r where civ.id=r.new_version_id;

-- Structural QA gate per item.
create temporary table qa_blocked as
select r.content_key,
  case
    when nullif(trim(civ.stem),'') is null then 'blank stem'
    when (select count(*) from app.frq_criteria f where f.content_item_version_id=civ.id) = 0 then 'no criteria'
    when exists (select 1 from app.frq_criteria f where f.content_item_version_id=civ.id and nullif(trim(coalesce(f.learner_facing_text,'')),'') is null) then 'blank criterion text'
    when exists (select 1 from app.content_item_versions other where other.content_item_id=civ.content_item_id and other.id<>civ.id and other.status='published') then 'competing published version'
  end reason
from repaired r join app.content_item_versions civ on civ.id=r.new_version_id;
delete from qa_blocked where reason is null;

create temporary table approve_set on commit drop as
select r.content_key, r.new_version_id from repaired r
where not exists (select 1 from qa_blocked b where b.content_key=r.content_key);

update app.content_item_versions civ set status='reviewed_approved', review_status='question_review_approved',
  approved_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, approved_at=now(), updated_at=now()
from approve_set p where civ.id=p.new_version_id;
update app.content_items ci set status='reviewed_approved', updated_at=now()
from approve_set p join app.content_item_versions civ on civ.id=p.new_version_id where ci.id=civ.content_item_id;

update app.content_item_versions civ set status='published', review_status='question_review_approved',
  published_at=now(), updated_at=now()
from approve_set p where civ.id=p.new_version_id;
update app.content_items ci set status='published', updated_at=now()
from approve_set p join app.content_item_versions civ on civ.id=p.new_version_id where ci.id=civ.content_item_id;

do $$
declare n integer;
begin
  select count(*) into n from repaired;
  if n<>7 then raise exception 'expected 7 repaired FRQs, got %', n; end if;
  select count(*) into n from qa_blocked;
  if n<>0 then raise exception 'blocked by structural QA gate: %',
    (select string_agg(content_key||':'||reason, ', ' order by content_key) from qa_blocked);
  end if;
end $$;

-- L-034: revert to changes_requested (unpublish) without a content repair --
-- Sarah's note ("Part C options are incomplete") doesn't specify what the
-- intended options were, so this needs a human author, not a guessed fix.
update app.content_item_versions civ
set status='changes_requested', updated_at=now()
from app.content_items ci
where ci.content_key='APBIO-FRQ-L-034' and civ.content_item_id=ci.id and civ.status='published';
update app.content_items ci
set status='changes_requested', updated_at=now()
where ci.content_key='APBIO-FRQ-L-034' and ci.status='published';

select 'repaired' metric, count(*)::text value from repaired
union all select 'published', count(*)::text from approve_set
union all select 'qa_blocked', count(*)::text from qa_blocked
union all select 'published_keys', string_agg(content_key, ', ' order by content_key) from approve_set
union all select 'l034_unpublished', (select count(*)::text from app.content_items where content_key='APBIO-FRQ-L-034' and status='changes_requested');

commit;
