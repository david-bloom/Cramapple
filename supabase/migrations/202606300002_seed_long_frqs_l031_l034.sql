do $$
declare
  v_epv_id uuid;
  v_ci_id  uuid;
  v_civ_id uuid;
begin
  select epv.id into strict v_epv_id
  from app.exam_pack_versions epv
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  where ep.exam_code = 'ap_biology' and epv.school_year = '2026';

  -- L-031: Enzyme kinetics (Vmax/Km, competitive inhibition)
  insert into app.content_items (exam_pack_version_id, content_key, item_type, frq_form, title, status)
  values (v_epv_id, 'APBIO-FRQ-L-031', 'frq', 'long', 'APBIO-FRQ-L-031', 'draft')
  on conflict (exam_pack_version_id, content_key) do nothing returning id into v_ci_id;
  if v_ci_id is null then select id into v_ci_id from app.content_items
    where exam_pack_version_id = v_epv_id and content_key = 'APBIO-FRQ-L-031'; end if;

  insert into app.content_item_versions (content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status)
  values (v_ci_id, 1,
    'Answer all parts of the following question.

(a) (i) Using the data in the table, estimate the Vmax and Km of the uninhibited enzyme reaction.
    (ii) Explain why reaction rate plateaus at high substrate concentration even though substrate is not limiting.

(b) A competitive inhibitor is added at a fixed concentration and the experiment is repeated. Predict how Vmax and Km would change relative to the uninhibited reaction, and explain why, based on the mechanism of competitive inhibition.

(c) Researchers raise the substrate concentration to 50 times the original Km in the presence of the same competitive inhibitor. Predict what happens to reaction rate relative to the uninhibited Vmax and explain your reasoning.

(d) Propose a modification to the experiment that would distinguish a competitive inhibitor from a noncompetitive inhibitor using only reaction-rate data, and explain what result would confirm each mechanism.',
    'A biochemist measures the initial reaction rate of an enzyme at increasing substrate concentrations, holding enzyme concentration, pH, and temperature constant.

Substrate concentration (mM) | Initial reaction rate (micromol/min)
0.5                          | 12
1.0                          | 20
2.0                          | 30
4.0                          | 40
8.0                          | 46
16.0                         | 49
32.0                         | 50',
    '{"modules":["1","2"],"frq_type":"long","subtopics":["1.1 Enzymes","2.1 Cell Structure and Function"],"total_points":10}'::jsonb,
    md5('APBIO-FRQ-L-031'), 'draft')
  on conflict (content_item_id, version_num) do nothing returning id into v_civ_id;
  if v_civ_id is null then select id into v_civ_id from app.content_item_versions
    where content_item_id = v_ci_id and version_num = 1; end if;

  insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants) values
    (v_civ_id, 'a_i',
     'Estimate Vmax and Km from the data table.',
     2,
     'Vmax approximately 50 micromol/min (the plateau value approached at high substrate). Km is the substrate concentration at half-Vmax (approximately 25 micromol/min), which falls between 1.0 and 2.0 mM, roughly 1.5-2.0 mM. Accept reasonable estimates within range with correct method shown.',
     'Vmax is about 50 micromol/min (the plateau); Km is the substrate concentration giving half that rate, roughly 1.5-2.0 mM.',
     '["Vmax approximately 50", "Km approximately 1.5-2 mM", "half-Vmax method", "plateau value is Vmax"]'::jsonb),
    (v_civ_id, 'a_ii',
     'Explain why reaction rate plateaus at high substrate concentration.',
     2,
     'At high substrate concentration, all (or nearly all) enzyme active sites are saturated/occupied at any given moment; the enzyme is working at its maximum turnover rate; adding more substrate cannot increase rate because no free active sites are available to bind it.',
     'At high substrate concentration the enzyme active sites are saturated, so the enzyme is working as fast as it can regardless of additional substrate.',
     '["active sites saturated", "enzyme is rate-limiting", "all enzyme molecules are occupied", "maximum turnover reached"]'::jsonb),
    (v_civ_id, 'b',
     'Predict how Vmax and Km change with a competitive inhibitor and explain why.',
     2,
     'Vmax stays the same (unchanged) because, given enough substrate, substrate will outcompete the inhibitor for the active site and full enzyme activity can still be achieved. Km increases (apparent Km is higher) because more substrate is needed to reach half-Vmax due to competition between substrate and inhibitor for the same active site.',
     'Vmax is unchanged because excess substrate can outcompete the inhibitor; Km increases because more substrate is needed to overcome competition for the active site.',
     '["Vmax unchanged", "Km increases", "competition for active site", "excess substrate outcompetes inhibitor"]'::jsonb),
    (v_civ_id, 'c',
     'Predict reaction rate at very high substrate concentration with competitive inhibitor present.',
     2,
     'At 50x Km, substrate concentration is high enough to outcompete the inhibitor for the active site; reaction rate approaches the same Vmax as the uninhibited reaction (approximately 50 micromol/min), because competitive inhibition can be overcome by sufficiently high substrate concentration.',
     'Reaction rate approaches the original Vmax (about 50 micromol/min) because the high substrate concentration outcompetes the inhibitor for active sites.',
     '["rate approaches original Vmax", "high substrate overcomes inhibition", "competitive inhibition is overcome at high [S]"]'::jsonb),
    (v_civ_id, 'd',
     'Propose an experiment to distinguish competitive from noncompetitive inhibition using reaction-rate data.',
     2,
     'Repeat the substrate titration with the inhibitor present and compare to uninhibited curve: if Vmax is restored (unchanged) at high substrate but Km increases, inhibition is competitive. If Vmax is lower than uninhibited even at very high substrate concentration (Km roughly unchanged), inhibition is noncompetitive (inhibitor binds a site other than the active site and cannot be outcompeted by substrate).',
     'Run the same substrate titration with the inhibitor present: if high substrate restores the original Vmax, the inhibition is competitive; if Vmax remains lowered even at high substrate, the inhibition is noncompetitive.',
     '["compare Vmax at high substrate", "competitive: Vmax restored", "noncompetitive: Vmax stays reduced", "noncompetitive inhibitor binds elsewhere not active site"]'::jsonb)
  on conflict (content_item_version_id, criterion_key) do nothing;
  v_ci_id := null; v_civ_id := null;

  -- L-032: Water potential / osmosis in potato cores
  insert into app.content_items (exam_pack_version_id, content_key, item_type, frq_form, title, status)
  values (v_epv_id, 'APBIO-FRQ-L-032', 'frq', 'long', 'APBIO-FRQ-L-032', 'draft')
  on conflict (exam_pack_version_id, content_key) do nothing returning id into v_ci_id;
  if v_ci_id is null then select id into v_ci_id from app.content_items
    where exam_pack_version_id = v_epv_id and content_key = 'APBIO-FRQ-L-032'; end if;

  insert into app.content_item_versions (content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status)
  values (v_ci_id, 1,
    'Answer all parts of the following question.

(a) Using the data, identify the sucrose concentration at which the potato core experienced no net change in mass, and explain what this indicates about the water potential of the potato cells.

(b) Calculate the percent change in mass for the core placed in 0.6 M sucrose, showing your work. Explain the direction of water movement that produced this result.

(c) The solute potential of the 0.6 M sucrose solution is -1.5 MPa and the experiment was conducted at atmospheric pressure (pressure potential of the solution = 0). Calculate the water potential of the solution, then use your answer to part (b) to determine whether the potato cells'' water potential was higher or lower than -1.5 MPa, and explain your reasoning.

(d) Predict how the results would change if the experiment were repeated using core samples from a wilted (flaccid) plant rather than a fresh one, and justify your prediction in terms of pressure potential.',
    'A student cuts uniform potato cores, blots and weighs each, then submerges them in sucrose solutions of varying molarity for 90 minutes. Cores are reweighed and percent change in mass is calculated.

Sucrose concentration (M) | Initial mass (g) | Final mass (g)
0.0                       | 5.00              | 5.65
0.2                       | 5.00              | 5.30
0.4                       | 5.00              | 5.05
0.6                       | 5.00              | 4.70
0.8                       | 5.00              | 4.40
1.0                       | 5.00              | 4.15',
    '{"modules":["2"],"frq_type":"long","subtopics":["2.5 Membrane Permeability","2.6 Cell Membrane Transport"],"total_points":10}'::jsonb,
    md5('APBIO-FRQ-L-032'), 'draft')
  on conflict (content_item_id, version_num) do nothing returning id into v_civ_id;
  if v_civ_id is null then select id into v_civ_id from app.content_item_versions
    where content_item_id = v_ci_id and version_num = 1; end if;

  insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants) values
    (v_civ_id, 'a',
     'Identify the sucrose concentration producing no net mass change and explain what it indicates about cell water potential.',
     2,
     'No net change occurs between 0.4 M (mass increased slightly) and the trend approaching zero around 0.4-0.45 M; closest measured point is 0.4 M with minimal change (5.05 from 5.00, nearly isotonic). At this concentration the solution water potential equals the water potential of the potato cells (no net water movement), so this identifies the water potential of the potato tissue.',
     'Approximately 0.4 M sucrose produces near-zero net change, indicating the solution''s water potential is approximately equal to the potato cells'' water potential at that concentration.',
     '["approximately 0.4 M is isotonic point", "solution and cell water potential are equal", "no net water movement at that concentration"]'::jsonb),
    (v_civ_id, 'b',
     'Calculate percent change in mass for the 0.6 M core and explain the direction of water movement.',
     2,
     'Percent change = (4.70 - 5.00)/5.00 x 100 = -6.0%. The core lost mass, meaning water moved OUT of the potato cells into the surrounding solution, because the solution has a lower (more negative) water potential than the cells at this concentration.',
     'Percent change = -6.0%; the core lost water because the 0.6 M solution has lower water potential than the cell, so water moved out of the cells by osmosis.',
     '["-6.0% change", "water moved out of cells", "solution has lower water potential", "mass decreased"]'::jsonb),
    (v_civ_id, 'c',
     'Calculate the water potential of the 0.6 M solution and compare it to the potato cells'' water potential.',
     2,
     'Water potential = solute potential + pressure potential = -1.5 MPa + 0 = -1.5 MPa. Since the core LOST water (mass decreased) in this solution, water moved from the cells into the solution, meaning the cells'' water potential must have been HIGHER (less negative) than -1.5 MPa.',
     'Solution water potential = -1.5 MPa. Since the potato lost water in this solution, the potato cells'' water potential must be higher (less negative) than -1.5 MPa.',
     '["water potential = -1.5 MPa", "cell water potential higher than solution", "water moves high to low water potential", "cells lost water so cell psi > solution psi"]'::jsonb),
    (v_civ_id, 'd',
     'Predict how results would differ using cores from a wilted plant and justify using pressure potential.',
     2,
     'A wilted (flaccid) plant cell has lower turgor pressure (pressure potential near zero) compared to a fully turgid cell. Lower pressure potential means lower (more negative) overall water potential in the starting tissue (water potential = solute potential + pressure potential). With a more negative starting water potential, the cores would gain more mass (or lose less mass) at any given sucrose concentration than fresh, turgid cores, because the gradient favoring water entry is steeper (or the gradient favoring water loss is less steep).',
     'Wilted cores have lower pressure potential and thus more negative starting water potential, so they would tend to gain more mass (or lose less) than fresh cores at the same sucrose concentrations because more water would move in (or less would move out).',
     '["wilted cells have lower pressure potential", "more negative starting water potential", "cores would gain more mass or lose less", "turgor pressure affects water potential"]'::jsonb)
  on conflict (content_item_version_id, criterion_key) do nothing;
  v_ci_id := null; v_civ_id := null;

  -- L-033: Cellular respiration / fermentation in yeast at varying temperature
  insert into app.content_items (exam_pack_version_id, content_key, item_type, frq_form, title, status)
  values (v_epv_id, 'APBIO-FRQ-L-033', 'frq', 'long', 'APBIO-FRQ-L-033', 'draft')
  on conflict (exam_pack_version_id, content_key) do nothing returning id into v_ci_id;
  if v_ci_id is null then select id into v_ci_id from app.content_items
    where exam_pack_version_id = v_epv_id and content_key = 'APBIO-FRQ-L-033'; end if;

  insert into app.content_item_versions (content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status)
  values (v_ci_id, 1,
    'Answer all parts of the following question.

(a) (i) Identify the temperature at which CO2 production rate was highest, and describe the overall trend in the data from 5C to 45C.
    (ii) Explain, in terms of enzyme function, why CO2 production declines at temperatures above the optimum.

(b) The fermentation tubes contained no dissolved oxygen. Identify the metabolic pathway(s) yeast used to produce the measured CO2, and explain why CO2 is produced by this pathway in yeast specifically (as opposed to a pathway that does not release CO2).

(c) A second trial is run with oxygen bubbled continuously into the yeast culture at 35C. Predict how the rate of CO2 production would compare to the anaerobic 35C trial, and explain your prediction in terms of ATP yield per glucose and NADH shuttling.

(d) Propose a modification to the original experimental setup that would allow the researcher to distinguish CO2 produced by fermentation from CO2 that might be produced by aerobic respiration if a small amount of oxygen leaked into the tubes, and explain how the modification would resolve the ambiguity.',
    'A student incubates identical yeast-glucose suspensions in sealed fermentation tubes at six temperatures and measures CO2 gas produced (collected in an inverted graduated tube) after 30 minutes.

Temperature (C) | CO2 produced (mL)
5                | 0.5
15               | 2.0
25               | 5.5
35               | 9.0
40               | 7.0
45               | 1.5',
    '{"modules":["3"],"frq_type":"long","subtopics":["3.4 Cellular Respiration","3.5 Fermentation"],"total_points":10}'::jsonb,
    md5('APBIO-FRQ-L-033'), 'draft')
  on conflict (content_item_id, version_num) do nothing returning id into v_civ_id;
  if v_civ_id is null then select id into v_civ_id from app.content_item_versions
    where content_item_id = v_ci_id and version_num = 1; end if;

  insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants) values
    (v_civ_id, 'a_i',
     'Identify the optimal temperature and describe the overall trend.',
     2,
     'Optimal temperature is 35C (highest CO2 production, 9.0 mL). Trend: CO2 production increases from 5C to 35C, then declines from 35C to 45C (rises then falls / inverted-U shape).',
     'CO2 production peaks at 35C; it increases from 5C to 35C then decreases from 35C to 45C.',
     '["35C is optimum", "increases then decreases", "peak at 35C", "inverted U shape"]'::jsonb),
    (v_civ_id, 'a_ii',
     'Explain why CO2 production declines above the optimum temperature.',
     2,
     'Above the optimal temperature, heat begins to disrupt the weak bonds (hydrogen bonds, hydrophobic interactions) maintaining the tertiary structure of glycolytic and fermentation enzymes; enzymes begin to denature, losing their functional active-site shape; fewer functional enzyme molecules are available to catalyze the reactions producing CO2, so the rate declines.',
     'High temperatures denature the enzymes involved in glycolysis and fermentation, disrupting their active sites and reducing catalytic activity, so CO2 production falls.',
     '["enzyme denaturation", "disrupted active site", "broken hydrogen bonds", "loss of tertiary structure"]'::jsonb),
    (v_civ_id, 'b',
     'Identify the metabolic pathway producing CO2 and explain why this pathway releases CO2 in yeast.',
     2,
     'Yeast use glycolysis followed by alcoholic (ethanol) fermentation. CO2 is released specifically during the conversion of pyruvate to acetaldehyde by pyruvate decarboxylase (a decarboxylation step unique to ethanol fermentation, not lactic acid fermentation), before acetaldehyde is reduced to ethanol by alcohol dehydrogenase using NADH, regenerating NAD+ for glycolysis to continue.',
     'Yeast perform glycolysis and alcoholic fermentation; CO2 is released when pyruvate is decarboxylated to acetaldehyde, a step specific to ethanol fermentation that regenerates NAD+ for glycolysis.',
     '["glycolysis and alcoholic fermentation", "pyruvate decarboxylase releases CO2", "pyruvate to acetaldehyde to ethanol", "regenerates NAD+"]'::jsonb),
    (v_civ_id, 'c',
     'Predict CO2 production with oxygen present at 35C and explain using ATP yield and NADH.',
     2,
     'With oxygen present, yeast would shift toward aerobic respiration (Pasteur effect); CO2 would still be produced, but now primarily from the Krebs cycle (more CO2 per glucose: 6 CO2 vs 2 from fermentation pathway via decarboxylation), though the rate of glucose consumption typically slows because aerobic respiration yields far more ATP per glucose (~30-32 ATP vs 2 ATP), so less glucose needs to be processed to meet energy demand; NADH is now shuttled into the mitochondria and oxidized via the electron transport chain rather than being used to reduce acetaldehyde to ethanol.',
     'With oxygen, yeast would shift to aerobic respiration; more CO2 would be produced per glucose molecule (6 from Krebs cycle vs effectively 2 from fermentation) because aerobic respiration extracts more energy and NADH is oxidized via the ETC instead of fermentation.',
     '["shift to aerobic respiration", "more ATP per glucose aerobically", "NADH oxidized by ETC instead of fermentation", "more CO2 per glucose from Krebs cycle", "Pasteur effect"]'::jsonb),
    (v_civ_id, 'd',
     'Propose a modification to distinguish fermentation-CO2 from aerobic-CO2 if oxygen leaked in.',
     2,
     'Add an indicator for ethanol production (e.g., test the solution for ethanol concentration, or use a colorimetric assay) alongside the CO2 measurement; if fermentation occurred, ethanol should accumulate in proportion to CO2 produced (1:1 stoichiometry from pyruvate decarboxylation), while CO2 from aerobic respiration would not produce a matching increase in ethanol. Alternatively, monitor O2 consumption directly; if O2 is being consumed, some CO2 is from aerobic respiration, not exclusively fermentation.',
     'Measure ethanol production alongside CO2; CO2 from fermentation should correspond to ethanol produced in roughly 1:1 ratio, while CO2 from aerobic respiration would not, allowing the researcher to distinguish the two sources.',
     '["measure ethanol production", "monitor oxygen consumption", "fermentation produces ethanol 1:1 with CO2", "aerobic respiration consumes O2"]'::jsonb)
  on conflict (content_item_version_id, criterion_key) do nothing;
  v_ci_id := null; v_civ_id := null;

  -- L-034: Cell signaling and apoptosis pathway with chemical inhibitor
  insert into app.content_items (exam_pack_version_id, content_key, item_type, frq_form, title, status)
  values (v_epv_id, 'APBIO-FRQ-L-034', 'frq', 'long', 'APBIO-FRQ-L-034', 'draft')
  on conflict (exam_pack_version_id, content_key) do nothing returning id into v_ci_id;
  if v_ci_id is null then select id into v_ci_id from app.content_items
    where exam_pack_version_id = v_epv_id and content_key = 'APBIO-FRQ-L-034'; end if;

  insert into app.content_item_versions (content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status)
  values (v_ci_id, 1,
    'Answer all parts of the following question.

(a) Using the data, describe the relationship between Death Ligand concentration and the percentage of apoptotic cells in the untreated (no inhibitor) condition.

(b) Explain how binding of Death Ligand to its cell-surface receptor ultimately activates the caspase cascade that leads to apoptosis. Include at least two named components of the pathway in your answer.

(c) Drug X is a small molecule that binds directly to and blocks the active site of caspase-9. Using the data for the Drug X condition, evaluate whether the data support the hypothesis that Drug X blocks the apoptosis pathway downstream of caspase-9 activation, downstream of receptor binding, or has no effect on the pathway. Justify your evaluation using specific data.

(d) Propose a follow-up experiment, using a molecular technique other than the ligand-treatment assay already described, that would provide independent evidence for where in the pathway Drug X acts. Describe the expected result that would support your hypothesis from part (c).',
    'Researchers treat cultured cells with increasing concentrations of Death Ligand (a pro-apoptotic signaling molecule) for 24 hours, with and without Drug X (a candidate caspase-9 inhibitor) added 1 hour before treatment. Percentage of apoptotic cells is measured by flow cytometry.

Death Ligand (ng/mL) | % Apoptotic (no drug) | % Apoptotic (+ Drug X)
0                     | 3                      | 3
10                    | 18                     | 4
25                    | 42                     | 5
50                    | 68                     | 6
100                   | 85                     | 7',
    '{"modules":["4"],"frq_type":"long","subtopics":["4.5 Cell Signaling and Apoptosis","4.2 Signal Transduction"],"total_points":10}'::jsonb,
    md5('APBIO-FRQ-L-034'), 'draft')
  on conflict (content_item_id, version_num) do nothing returning id into v_civ_id;
  if v_civ_id is null then select id into v_civ_id from app.content_item_versions
    where content_item_id = v_ci_id and version_num = 1; end if;

  insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants) values
    (v_civ_id, 'a',
     'Describe the relationship between Death Ligand concentration and percent apoptosis without drug.',
     2,
     'As Death Ligand concentration increases from 0 to 100 ng/mL, the percentage of apoptotic cells increases (positive/direct relationship), from 3% to 85%; the increase appears dose-dependent across the range tested.',
     'Percent apoptotic cells increases as Death Ligand concentration increases — a positive, dose-dependent relationship, from 3% at 0 ng/mL to 85% at 100 ng/mL.',
     '["positive relationship", "dose-dependent increase", "more ligand causes more apoptosis", "directly proportional trend"]'::jsonb),
    (v_civ_id, 'b',
     'Explain how Death Ligand binding activates the caspase cascade, naming at least two pathway components.',
     2,
     'Death Ligand binds its cell-surface death receptor, causing receptor clustering/conformational change; this recruits adaptor proteins (e.g., FADD) which recruit and activate initiator caspases (e.g., caspase-8 or caspase-9 depending on pathway, often via formation of a death-inducing signaling complex, DISC); activated initiator caspases cleave and activate executioner caspases (e.g., caspase-3); executioner caspases cleave cellular substrates (structural proteins, DNA repair enzymes), leading to the controlled dismantling of the cell (apoptosis).',
     'Death Ligand binds its receptor, recruiting adaptor proteins and activating initiator caspases (e.g., caspase-8/9), which activate executioner caspases (e.g., caspase-3) that cleave cellular proteins, causing apoptosis.',
     '["receptor binding recruits adaptor proteins", "initiator caspases activated", "executioner caspases", "caspase cascade", "caspase-3", "caspase-8 or caspase-9"]'::jsonb),
    (v_civ_id, 'c',
     'Evaluate whether the data support Drug X acting downstream of caspase-9, downstream of receptor binding generally, or having no effect.',
     2,
     'The data support that Drug X strongly blocks the apoptosis pathway, consistent with its proposed mechanism of inhibiting caspase-9: even at the highest Death Ligand concentration (100 ng/mL), apoptosis remains low (7%) with Drug X compared to 85% without it. Because apoptosis is almost completely blocked regardless of ligand concentration, the data are consistent with Drug X acting downstream of receptor binding (since receptor binding and upstream signaling presumably still occur, but the downstream caspase activity needed to execute apoptosis is blocked) — supporting the caspase-9 inhibition hypothesis rather than no effect.',
     'The data support Drug X blocking the pathway: apoptosis stays low (4-7%) across all ligand concentrations with Drug X, consistent with blocking a downstream step (caspase-9) rather than having no effect.',
     '["Drug X blocks apoptosis at all ligand levels", "consistent with downstream caspase-9 inhibition", "apoptosis remains low even at high ligand", "data reject no-effect hypothesis"]'::jsonb),
    (v_civ_id, 'd',
     'Propose an independent molecular technique to test where Drug X acts, with expected supporting result.',
     2,
     'Any reasonable molecular approach, e.g.: use a Western blot with an antibody specific to cleaved (activated) caspase-9 vs. cleaved caspase-3 after Death Ligand treatment with and without Drug X. Expected result supporting the hypothesis: cleaved/active caspase-9 would still be present (or only mildly reduced) with Drug X (since Drug X blocks caspase-9''s catalytic activity, not its activation/cleavage), but cleaved/active caspase-3 (downstream of caspase-9) would be absent or strongly reduced with Drug X, confirming the block occurs at or just after caspase-9.',
     'Run a Western blot for cleaved caspase-9 and cleaved caspase-3 with and without Drug X; finding cleaved caspase-9 present but cleaved caspase-3 absent with Drug X would confirm Drug X blocks caspase-9 activity downstream of its activation.',
     '["Western blot for cleaved caspases", "caspase-9 cleaved but caspase-3 not activated", "directly tests catalytic activity vs activation", "confirms block at caspase-9 step"]'::jsonb)
  on conflict (content_item_version_id, criterion_key) do nothing;
  v_ci_id := null; v_civ_id := null;

end $$;
