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

  -- S-011: Hardy-Weinberg equilibrium
  insert into app.content_items (exam_pack_version_id, content_key, item_type, frq_form, title, status)
  values (v_epv_id, 'APBIO-FRQ-S-011', 'frq', 'short', 'APBIO-FRQ-S-011', 'draft')
  on conflict (exam_pack_version_id, content_key) do nothing returning id into v_ci_id;
  if v_ci_id is null then select id into v_ci_id from app.content_items
    where exam_pack_version_id = v_epv_id and content_key = 'APBIO-FRQ-S-011'; end if;

  insert into app.content_item_versions (content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status)
  values (v_ci_id, 1,
    'A botanist surveys a large, randomly mating population of 500 plants for flower color. Red flower (rr, homozygous recessive) plants number 80; all others have white flowers.',
    'Students must use Hardy-Weinberg equations (p + q = 1 and p^2 + 2pq + q^2 = 1) to calculate genotype frequencies.',
    '{"modules":["7"]}'::jsonb, md5('APBIO-FRQ-S-011'), 'draft')
  on conflict (content_item_id, version_num) do nothing returning id into v_civ_id;
  if v_civ_id is null then select id into v_civ_id from app.content_item_versions
    where content_item_id = v_ci_id and version_num = 1; end if;

  insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants) values
    (v_civ_id, 'a',
     'Calculate the expected frequency of heterozygotes (Rr) in this population assuming Hardy-Weinberg equilibrium. Show your work.',
     2,
     'q^2 = 80/500 = 0.16; q = 0.4; p = 1 - 0.4 = 0.6; 2pq = 2(0.6)(0.4) = 0.48. Heterozygote frequency = 0.48 (48%).',
     'q^2 = 0.16, so q = 0.4; p = 0.6; 2pq = 0.48; expected heterozygote frequency is 48 percent.',
     '["2pq = 0.48", "48% heterozygotes", "q=0.4, p=0.6, 2pq=0.48"]'::jsonb),
    (v_civ_id, 'b',
     'Identify two conditions required for a population to remain in Hardy-Weinberg equilibrium and explain why each is necessary.',
     2,
     'Any two of: large population size (prevents genetic drift); random mating (ensures random allele combination); no mutation (allele frequencies unchanged); no gene flow (no alleles entering or leaving); no natural selection (all genotypes equally fit). Each condition explained mechanistically.',
     'Large population size prevents genetic drift from randomly changing allele frequencies; random mating ensures allele frequencies combine according to probability.',
     '["no selection", "random mating", "large population", "no mutation", "no gene flow"]'::jsonb)
  on conflict (content_item_version_id, criterion_key) do nothing;
  v_ci_id := null; v_civ_id := null;

  -- S-012: Population growth / logistic growth / carrying capacity
  insert into app.content_items (exam_pack_version_id, content_key, item_type, frq_form, title, status)
  values (v_epv_id, 'APBIO-FRQ-S-012', 'frq', 'short', 'APBIO-FRQ-S-012', 'draft')
  on conflict (exam_pack_version_id, content_key) do nothing returning id into v_ci_id;
  if v_ci_id is null then select id into v_ci_id from app.content_items
    where exam_pack_version_id = v_epv_id and content_key = 'APBIO-FRQ-S-012'; end if;

  insert into app.content_item_versions (content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status)
  values (v_ci_id, 1,
    'A rabbit population colonizes an island with limited food and space resources. Its growth is tracked over 50 years.',
    'A graph shows logistic growth: rapid initial increase, then a leveling off as the population approaches carrying capacity K.',
    '{"modules":["8"]}'::jsonb, md5('APBIO-FRQ-S-012'), 'draft')
  on conflict (content_item_id, version_num) do nothing returning id into v_civ_id;
  if v_civ_id is null then select id into v_civ_id from app.content_item_versions
    where content_item_id = v_ci_id and version_num = 1; end if;

  insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants) values
    (v_civ_id, 'a',
     'Explain why the rabbit population growth rate slows as the population size approaches the carrying capacity K.',
     2,
     'As population size approaches K, resources per individual (food, space, nesting sites) decrease; competition intensifies; birth rate falls and/or death rate rises; the (K - N)/K term in the logistic equation approaches zero, reducing growth rate.',
     'As N approaches K, limited resources increase competition among individuals, reducing birth rates and/or increasing death rates until growth rate approaches zero.',
     '["resources become limiting", "increased competition", "(K-N)/K approaches zero", "birth rate falls or death rate rises near K"]'::jsonb),
    (v_civ_id, 'b',
     'Identify one density-dependent factor and one density-independent factor that could limit the rabbit population and explain how each acts.',
     2,
     'Density-dependent: e.g., food competition, predation, disease — effect increases as population density increases. Density-independent: e.g., drought, hurricane, wildfire — effect is unrelated to population density; kills individuals regardless of how crowded the population is.',
     'Density-dependent: predation increases as rabbits become more concentrated, removing more individuals at higher densities. Density-independent: a drought reduces food availability for all rabbits regardless of population size.',
     '["density-dependent examples: predation, disease, competition", "density-independent examples: drought, fire, storm", "density-dependent effect scales with density"]'::jsonb)
  on conflict (content_item_version_id, criterion_key) do nothing;
  v_ci_id := null; v_civ_id := null;

  -- S-013: Water potential in plant cells
  insert into app.content_items (exam_pack_version_id, content_key, item_type, frq_form, title, status)
  values (v_epv_id, 'APBIO-FRQ-S-013', 'frq', 'short', 'APBIO-FRQ-S-013', 'draft')
  on conflict (exam_pack_version_id, content_key) do nothing returning id into v_ci_id;
  if v_ci_id is null then select id into v_ci_id from app.content_items
    where exam_pack_version_id = v_epv_id and content_key = 'APBIO-FRQ-S-013'; end if;

  insert into app.content_item_versions (content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status)
  values (v_ci_id, 1,
    'A plant scientist soaks potato cubes of known mass in salt solutions of varying concentration and measures mass change after 24 hours.',
    'Data show that cubes gain mass in dilute solutions, lose mass in concentrated solutions, and show no change at an intermediate concentration.',
    '{"modules":["2"]}'::jsonb, md5('APBIO-FRQ-S-013'), 'draft')
  on conflict (content_item_id, version_num) do nothing returning id into v_civ_id;
  if v_civ_id is null then select id into v_civ_id from app.content_item_versions
    where content_item_id = v_ci_id and version_num = 1; end if;

  insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants) values
    (v_civ_id, 'a',
     'Define water potential and explain how increasing solute concentration in a solution affects its water potential.',
     2,
     'Water potential (psi) is the tendency of water to move from one area to another; measured in megapascals (MPa). Adding solute decreases (makes more negative) the solute potential component (psi-s), thereby decreasing overall water potential — water is less likely to leave a region with high solute concentration.',
     'Water potential is the free energy of water per unit volume; higher solute concentration lowers (makes more negative) water potential by reducing solute potential.',
     '["water potential = solute potential + pressure potential", "solutes lower water potential", "more solute = more negative psi", "water moves from high to low water potential"]'::jsonb),
    (v_civ_id, 'b',
     'Predict whether a plant cell with a water potential of negative 0.5 MPa placed in a solution with a water potential of negative 0.3 MPa will gain or lose water, and justify your prediction.',
     2,
     'The cell will lose water. Water moves from high (less negative) to low (more negative) water potential. The solution has higher water potential (-0.3 MPa) than the cell (-0.5 MPa); water therefore moves from solution into the cell is WRONG — water moves from -0.3 (solution, higher) INTO the cell is CORRECT. Wait: -0.3 > -0.5, so solution has higher water potential; water moves from solution into cell. Cell GAINS water.',
     'The cell will GAIN water because the solution (-0.3 MPa) has a higher water potential than the cell (-0.5 MPa); water moves from higher to lower water potential, so water enters the cell.',
     '["cell gains water", "water moves from solution into cell", "solution has higher water potential (-0.3 > -0.5)", "water moves high to low water potential"]'::jsonb)
  on conflict (content_item_version_id, criterion_key) do nothing;
  v_ci_id := null; v_civ_id := null;

  -- S-014: Electron transport chain / chemiosmosis
  insert into app.content_items (exam_pack_version_id, content_key, item_type, frq_form, title, status)
  values (v_epv_id, 'APBIO-FRQ-S-014', 'frq', 'short', 'APBIO-FRQ-S-014', 'draft')
  on conflict (exam_pack_version_id, content_key) do nothing returning id into v_ci_id;
  if v_ci_id is null then select id into v_ci_id from app.content_items
    where exam_pack_version_id = v_epv_id and content_key = 'APBIO-FRQ-S-014'; end if;

  insert into app.content_item_versions (content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status)
  values (v_ci_id, 1,
    'Most ATP produced during aerobic respiration is generated at the inner mitochondrial membrane through the electron transport chain and ATP synthase.',
    'A diagram shows the inner mitochondrial membrane with Complexes I, II, III, and IV, plus ATP synthase, and arrows indicating electron flow and proton pumping.',
    '{"modules":["3"]}'::jsonb, md5('APBIO-FRQ-S-014'), 'draft')
  on conflict (content_item_id, version_num) do nothing returning id into v_civ_id;
  if v_civ_id is null then select id into v_civ_id from app.content_item_versions
    where content_item_id = v_ci_id and version_num = 1; end if;

  insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants) values
    (v_civ_id, 'a',
     'Describe how electrons move through the electron transport chain and explain what drives ATP synthesis.',
     2,
     'NADH and FADH2 donate electrons to the ETC; electrons pass through protein complexes (I, III, IV), releasing energy that pumps H+ from matrix to intermembrane space; H+ gradient (electrochemical) drives H+ back through ATP synthase; flow of H+ powers phosphorylation of ADP to ATP by chemiosmosis.',
     'Electrons from NADH and FADH2 flow through ETC complexes to oxygen; energy released pumps H+ into the intermembrane space; H+ gradient drives ATP synthesis through ATP synthase by chemiosmosis.',
     '["NADH/FADH2 donate electrons", "proton gradient drives ATP synthase", "chemiosmosis", "oxygen is final electron acceptor"]'::jsonb),
    (v_civ_id, 'b',
     'Predict what would happen to ATP production if a chemical inhibitor blocked Complex IV (cytochrome c oxidase) and explain why.',
     2,
     'ETC would halt because electrons cannot be transferred to oxygen (final acceptor); H+ pumping stops; proton gradient dissipates; ATP synthase cannot make ATP; NADH and FADH2 cannot be re-oxidized; Krebs cycle and glycolysis would slow. Net result: ATP synthesis drops dramatically.',
     'Blocking Complex IV halts electron flow through the entire ETC; proton pumping stops; the proton gradient is not maintained; ATP synthase cannot produce ATP; aerobic respiration nearly ceases.',
     '["ETC halts", "proton gradient dissipates", "ATP synthesis stops", "oxygen cannot accept electrons"]'::jsonb)
  on conflict (content_item_version_id, criterion_key) do nothing;
  v_ci_id := null; v_civ_id := null;

  -- S-015: lac operon regulation
  insert into app.content_items (exam_pack_version_id, content_key, item_type, frq_form, title, status)
  values (v_epv_id, 'APBIO-FRQ-S-015', 'frq', 'short', 'APBIO-FRQ-S-015', 'draft')
  on conflict (exam_pack_version_id, content_key) do nothing returning id into v_ci_id;
  if v_ci_id is null then select id into v_ci_id from app.content_items
    where exam_pack_version_id = v_epv_id and content_key = 'APBIO-FRQ-S-015'; end if;

  insert into app.content_item_versions (content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status)
  values (v_ci_id, 1,
    'In E. coli, genes that encode lactose-metabolizing enzymes are controlled by the lac operon, a cluster of genes with shared regulatory sequences.',
    'A diagram shows the lac operon with the regulatory gene (lacI), promoter, operator, and structural genes (lacZ, lacY, lacA), plus the repressor protein and allolactose.',
    '{"modules":["6"]}'::jsonb, md5('APBIO-FRQ-S-015'), 'draft')
  on conflict (content_item_id, version_num) do nothing returning id into v_civ_id;
  if v_civ_id is null then select id into v_civ_id from app.content_item_versions
    where content_item_id = v_ci_id and version_num = 1; end if;

  insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants) values
    (v_civ_id, 'a',
     'Describe what happens to lac operon transcription when lactose is absent from the environment.',
     2,
     'When lactose is absent, the lac repressor (lacI gene product) binds to the operator sequence, physically blocking RNA polymerase from transcribing the structural genes; lacZ, lacY, and lacA are not transcribed and lactase enzymes are not produced.',
     'Without lactose, the lac repressor binds the operator and blocks RNA polymerase, so the structural genes are not transcribed.',
     '["repressor binds operator", "RNA polymerase blocked", "structural genes not transcribed", "no lactase produced"]'::jsonb),
    (v_civ_id, 'b',
     'Explain why glucose deprivation also increases lac operon expression (catabolite repression / positive control).',
     2,
     'When glucose is absent, adenylyl cyclase is active and cAMP levels rise; cAMP binds to CAP (catabolite activator protein); CAP-cAMP complex binds to the CAP site upstream of the lac promoter and stimulates RNA polymerase binding, increasing transcription of the structural genes — this is positive control on top of negative (repressor) control.',
     'Low glucose raises cAMP levels; cAMP-CAP complex binds upstream of the promoter and enhances RNA polymerase binding, increasing transcription of the lac structural genes.',
     '["high cAMP when glucose is low", "CAP-cAMP stimulates transcription", "positive control", "catabolite activator protein binds promoter region"]'::jsonb)
  on conflict (content_item_version_id, criterion_key) do nothing;
  v_ci_id := null; v_civ_id := null;

  -- S-016: Allopatric speciation / reproductive isolation
  insert into app.content_items (exam_pack_version_id, content_key, item_type, frq_form, title, status)
  values (v_epv_id, 'APBIO-FRQ-S-016', 'frq', 'short', 'APBIO-FRQ-S-016', 'draft')
  on conflict (exam_pack_version_id, content_key) do nothing returning id into v_ci_id;
  if v_ci_id is null then select id into v_ci_id from app.content_items
    where exam_pack_version_id = v_epv_id and content_key = 'APBIO-FRQ-S-016'; end if;

  insert into app.content_item_versions (content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status)
  values (v_ci_id, 1,
    'A mountain range formed 2 million years ago divided a formerly continuous lizard population into two geographically isolated groups.',
    'Present-day descendants of the two groups have morphological and behavioral differences. When brought into contact in the lab, they rarely interbreed and hybrids have reduced survival.',
    '{"modules":["7"]}'::jsonb, md5('APBIO-FRQ-S-016'), 'draft')
  on conflict (content_item_id, version_num) do nothing returning id into v_civ_id;
  if v_civ_id is null then select id into v_civ_id from app.content_item_versions
    where content_item_id = v_ci_id and version_num = 1; end if;

  insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants) values
    (v_civ_id, 'a',
     'Explain how allopatric speciation could produce two distinct species from a single ancestral population.',
     2,
     'Geographic isolation (mountain range) prevents gene flow between populations; each population accumulates different mutations and evolves under different selection pressures; over time genetic differences accumulate to the point where the two groups can no longer interbreed successfully even if barriers were removed.',
     'Physical separation prevented gene flow; each population independently accumulated genetic differences through mutation and natural selection; eventually reproductive isolation arose, producing two distinct species.',
     '["geographic isolation prevents gene flow", "independent evolution via mutation and selection", "reproductive isolation develops over time", "speciation = inability to interbreed"]'::jsonb),
    (v_civ_id, 'b',
     'Describe one prezygotic and one postzygotic reproductive isolating mechanism that could prevent interbreeding between the two lizard groups if they came back into contact.',
     2,
     'Prezygotic: behavioral isolation (different mating displays or pheromones prevent courtship); or temporal isolation (different mating seasons); or mechanical isolation (incompatible genitalia). Postzygotic: hybrid inviability (hybrid offspring die before reproducing); or hybrid sterility (hybrids are sterile, as in the scenario).',
     'Prezygotic: behavioral isolation — the two groups do not recognize each other as potential mates, preventing mating attempts. Postzygotic: hybrid inviability — offspring from mixed-group matings have reduced survival or fertility.',
     '["prezygotic: behavioral, temporal, or mechanical isolation", "postzygotic: hybrid inviability or sterility", "prevents gene flow between groups"]'::jsonb)
  on conflict (content_item_version_id, criterion_key) do nothing;
  v_ci_id := null; v_civ_id := null;

  -- S-017: Energy flow / 10% rule / trophic levels
  insert into app.content_items (exam_pack_version_id, content_key, item_type, frq_form, title, status)
  values (v_epv_id, 'APBIO-FRQ-S-017', 'frq', 'short', 'APBIO-FRQ-S-017', 'draft')
  on conflict (exam_pack_version_id, content_key) do nothing returning id into v_ci_id;
  if v_ci_id is null then select id into v_ci_id from app.content_items
    where exam_pack_version_id = v_epv_id and content_key = 'APBIO-FRQ-S-017'; end if;

  insert into app.content_item_versions (content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status)
  values (v_ci_id, 1,
    'Ecologists studying a meadow ecosystem measure biomass and energy at each trophic level of the food chain: grass to grasshopper to frog to hawk.',
    'A pyramid of energy shows: grass 10,000 kcal, grasshoppers 1,000 kcal, frogs 100 kcal, hawks 10 kcal.',
    '{"modules":["8"]}'::jsonb, md5('APBIO-FRQ-S-017'), 'draft')
  on conflict (content_item_id, version_num) do nothing returning id into v_civ_id;
  if v_civ_id is null then select id into v_civ_id from app.content_item_versions
    where content_item_id = v_ci_id and version_num = 1; end if;

  insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants) values
    (v_civ_id, 'a',
     'Explain why only approximately 10 percent of the energy at one trophic level is available to the next trophic level.',
     2,
     'Most energy consumed at each trophic level is lost as heat during cellular respiration; some is used for metabolism, growth, and reproduction; some is excreted as waste; only the energy stored in new biomass (approximately 10%) is available to the next trophic level.',
     'About 90 percent of energy is lost as heat through cellular respiration and metabolic processes at each trophic level; only about 10 percent is stored in new biomass available to the next level.',
     '["heat loss through cellular respiration", "10% transferred to next level", "metabolic losses", "energy not stored is lost as heat"]'::jsonb),
    (v_civ_id, 'b',
     'Predict how the hawk population would be affected if the grasshopper population declined sharply, and explain using energy flow principles.',
     2,
     'Hawk population would decrease. Fewer grasshoppers means less energy available to frogs (the trophic level below hawks); frog population declines; less energy available to hawks; hawk birth rate falls and/or death rate rises; hawk population shrinks. Loss of energy at one trophic level cascades up the food chain.',
     'Fewer grasshoppers reduces energy available to frogs; frog population declines; reduced frog population provides less energy to hawks; hawk population decreases due to reduced food supply.',
     '["hawk population decreases", "cascade effect up food chain", "less energy to frogs then to hawks", "trophic cascade"]'::jsonb)
  on conflict (content_item_version_id, criterion_key) do nothing;
  v_ci_id := null; v_civ_id := null;

  -- S-018: Gap junctions vs plasmodesmata
  insert into app.content_items (exam_pack_version_id, content_key, item_type, frq_form, title, status)
  values (v_epv_id, 'APBIO-FRQ-S-018', 'frq', 'short', 'APBIO-FRQ-S-018', 'draft')
  on conflict (exam_pack_version_id, content_key) do nothing returning id into v_ci_id;
  if v_ci_id is null then select id into v_ci_id from app.content_items
    where exam_pack_version_id = v_epv_id and content_key = 'APBIO-FRQ-S-018'; end if;

  insert into app.content_item_versions (content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status)
  values (v_ci_id, 1,
    'Cells in multicellular organisms communicate and exchange materials through direct cell-to-cell connections.',
    'A diagram shows two animal cells joined by gap junctions (connexin channels) and two plant cells joined by plasmodesmata passing through the cell wall.',
    '{"modules":["4"]}'::jsonb, md5('APBIO-FRQ-S-018'), 'draft')
  on conflict (content_item_id, version_num) do nothing returning id into v_civ_id;
  if v_civ_id is null then select id into v_civ_id from app.content_item_versions
    where content_item_id = v_ci_id and version_num = 1; end if;

  insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants) values
    (v_civ_id, 'a',
     'Compare the structure of gap junctions in animal cells to plasmodesmata in plant cells.',
     2,
     'Gap junctions: protein channels (connexins) span both plasma membranes of adjacent animal cells, forming a direct cytoplasmic connection; no cell wall involved. Plasmodesmata: channels lined with plasma membrane that pass through the cell walls of adjacent plant cells, connecting cytoplasm; may contain desmotubule (ER strand).',
     'Gap junctions are protein-lined channels through adjacent animal cell plasma membranes; plasmodesmata are channels through plant cell walls lined with plasma membrane, directly connecting plant cell cytoplasm.',
     '["gap junctions: connexin proteins, no cell wall", "plasmodesmata: through cell wall, membrane-lined", "both allow cytoplasmic communication"]'::jsonb),
    (v_civ_id, 'b',
     'Explain how gap junctions allow cardiac muscle cells to contract in a coordinated wave.',
     2,
     'Gap junctions allow ions (Na+, Ca2+, K+) and small molecules to pass directly between cardiac muscle cells; an electrical signal (action potential) depolarizes one cell and ions flow through gap junctions to the next cell, triggering its depolarization; the signal propagates cell-to-cell as a wave without requiring neuromuscular junctions at each cell.',
     'Gap junctions allow ions to pass directly between cardiac muscle cells; an electrical signal in one cell spreads to adjacent cells through gap junctions, causing coordinated depolarization and contraction across the heart tissue.',
     '["ions pass through gap junctions", "action potential propagates cell to cell", "coordinated depolarization", "electrical coupling via gap junctions"]'::jsonb)
  on conflict (content_item_version_id, criterion_key) do nothing;
  v_ci_id := null; v_civ_id := null;

  -- S-019: Endosymbiotic theory
  insert into app.content_items (exam_pack_version_id, content_key, item_type, frq_form, title, status)
  values (v_epv_id, 'APBIO-FRQ-S-019', 'frq', 'short', 'APBIO-FRQ-S-019', 'draft')
  on conflict (exam_pack_version_id, content_key) do nothing returning id into v_ci_id;
  if v_ci_id is null then select id into v_ci_id from app.content_items
    where exam_pack_version_id = v_epv_id and content_key = 'APBIO-FRQ-S-019'; end if;

  insert into app.content_item_versions (content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status)
  values (v_ci_id, 1,
    'The endosymbiotic theory proposes that mitochondria and chloroplasts evolved from free-living prokaryotes that were engulfed by a host cell and eventually became permanent organelles.',
    'No additional stimulus provided. Students answer based on knowledge of mitochondrial structure, genetics, and biochemistry.',
    '{"modules":["2"]}'::jsonb, md5('APBIO-FRQ-S-019'), 'draft')
  on conflict (content_item_id, version_num) do nothing returning id into v_civ_id;
  if v_civ_id is null then select id into v_civ_id from app.content_item_versions
    where content_item_id = v_ci_id and version_num = 1; end if;

  insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants) values
    (v_civ_id, 'a',
     'Describe two pieces of evidence from mitochondria that support the endosymbiotic theory.',
     2,
     'Any two of: (1) mitochondria have their own circular DNA, resembling prokaryotic chromosomes; (2) mitochondria have 70S ribosomes similar to bacteria, not 80S eukaryotic ribosomes; (3) mitochondria reproduce by binary fission; (4) mitochondria have inner membranes similar in composition to bacterial plasma membranes; (5) mitochondria are similar in size to bacteria.',
     'Mitochondria contain their own circular DNA similar to bacterial chromosomes; mitochondria have 70S ribosomes like bacteria, not the 80S ribosomes of the eukaryotic cytoplasm.',
     '["circular mitochondrial DNA", "70S ribosomes", "binary fission", "similar size to bacteria", "inner membrane resembles bacterial plasma membrane"]'::jsonb),
    (v_civ_id, 'b',
     'Explain how the double membrane of the mitochondrion is consistent with the endosymbiotic theory.',
     2,
     'The outer membrane is derived from the host cell membrane that surrounded the engulfed prokaryote during endocytosis; the inner membrane is derived from the original prokaryotic plasma membrane. Two separate membrane origins produce the double-membrane structure.',
     'The outer mitochondrial membrane came from the host cell plasma membrane when the prokaryote was engulfed; the inner membrane is the remnant of the original prokaryotic plasma membrane — two distinct origins explain the double membrane.',
     '["outer membrane from host cell endocytosis", "inner membrane from prokaryote plasma membrane", "two membranes from two different origins"]'::jsonb)
  on conflict (content_item_version_id, criterion_key) do nothing;
  v_ci_id := null; v_civ_id := null;

  -- S-020: Negative and positive feedback loops / homeostasis
  insert into app.content_items (exam_pack_version_id, content_key, item_type, frq_form, title, status)
  values (v_epv_id, 'APBIO-FRQ-S-020', 'frq', 'short', 'APBIO-FRQ-S-020', 'draft')
  on conflict (exam_pack_version_id, content_key) do nothing returning id into v_ci_id;
  if v_ci_id is null then select id into v_ci_id from app.content_items
    where exam_pack_version_id = v_epv_id and content_key = 'APBIO-FRQ-S-020'; end if;

  insert into app.content_item_versions (content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status)
  values (v_ci_id, 1,
    'The human body maintains blood glucose concentration within a narrow range through hormonal feedback mechanisms.',
    'A graph shows blood glucose rising after a carbohydrate-rich meal, then returning to the set point over approximately 2 hours.',
    '{"modules":["4"]}'::jsonb, md5('APBIO-FRQ-S-020'), 'draft')
  on conflict (content_item_id, version_num) do nothing returning id into v_civ_id;
  if v_civ_id is null then select id into v_civ_id from app.content_item_versions
    where content_item_id = v_ci_id and version_num = 1; end if;

  insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants) values
    (v_civ_id, 'a',
     'Describe how a negative feedback loop returns blood glucose to the set point after a carbohydrate-rich meal.',
     2,
     'Blood glucose rises above set point; pancreatic beta cells detect elevated glucose; insulin is secreted; insulin stimulates muscle and adipose cells to take up glucose and liver to store glucose as glycogen; blood glucose falls back to set point; falling glucose reduces insulin secretion, completing the negative feedback loop.',
     'Rising blood glucose triggers insulin secretion from beta cells; insulin signals cells to take up glucose and convert it to glycogen; blood glucose returns to set point; reduced glucose lowers insulin release.',
     '["insulin released when glucose rises", "cells take up glucose", "glycogen stored in liver", "glucose returns to set point", "negative feedback = response opposes stimulus"]'::jsonb),
    (v_civ_id, 'b',
     'Identify one example of positive feedback in human physiology and explain why it is adaptive despite amplifying a deviation from a baseline.',
     2,
     'Any valid example: (1) childbirth — oxytocin promotes uterine contractions; stronger contractions release more oxytocin; cycle escalates until baby is delivered, then stops (adaptive: ensures delivery is completed quickly); (2) blood clotting — platelets activate more platelets to rapidly seal a wound; (3) action potential depolarization — Na+ influx opens more Na+ channels. In each case the amplification drives a specific process to rapid completion, which is beneficial.',
     'During childbirth, oxytocin promotes uterine contractions; contractions stimulate more oxytocin release, amplifying contractions until delivery — positive feedback is adaptive because it drives labor to completion quickly rather than stalling.',
     '["childbirth/oxytocin", "blood clotting", "action potential", "positive feedback drives process to completion", "adaptive because completes a rapid necessary event"]'::jsonb)
  on conflict (content_item_version_id, criterion_key) do nothing;
  v_ci_id := null; v_civ_id := null;

end $$;
