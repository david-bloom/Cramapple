-- Exported from Production migration history (supabase_migrations.schema_migrations)
-- version: 20260627191226
-- recorded name: seed_short_frqs_s001_s010
-- statements: 1
-- This file is a faithful transcript of what Production actually ran.
-- Do not edit to "improve" it; corrections belong in a new forward migration.

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

  -- S-001: Osmosis and membrane permeability
  insert into app.content_items (exam_pack_version_id, content_key, item_type, frq_form, title, status)
  values (v_epv_id, 'APBIO-FRQ-S-001', 'frq', 'short', 'APBIO-FRQ-S-001', 'draft')
  on conflict (exam_pack_version_id, content_key) do nothing returning id into v_ci_id;
  if v_ci_id is null then select id into v_ci_id from app.content_items
    where exam_pack_version_id = v_epv_id and content_key = 'APBIO-FRQ-S-001'; end if;

  insert into app.content_item_versions (content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status)
  values (v_ci_id, 1,
    'A researcher studying cell volume regulation places human red blood cells in solutions of different solute concentrations and observes changes in cell size.',
    'A student places a red blood cell in a hypotonic solution and records that the cell swells and eventually lyses.',
    '{"modules":["2"]}'::jsonb, md5('APBIO-FRQ-S-001'), 'draft')
  on conflict (content_item_id, version_num) do nothing returning id into v_civ_id;
  if v_civ_id is null then select id into v_civ_id from app.content_item_versions
    where content_item_id = v_ci_id and version_num = 1; end if;

  insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants) values
    (v_civ_id, 'a',
     'Predict the direction of water movement when a cell is placed in a hypotonic solution and explain why.',
     2,
     'States water moves INTO the cell; explains water moves from low solute concentration (high water potential) to high solute concentration (low water potential) by osmosis.',
     'Water moves into the cell because the solution has a lower solute concentration than the cytoplasm.',
     '["water enters the cell", "osmosis drives water into the cell", "net movement of water is into the cell"]'::jsonb),
    (v_civ_id, 'b',
     'Describe one structural feature of the plasma membrane that limits the rate of water movement through the lipid bilayer itself (not through aquaporins).',
     2,
     'Identifies the hydrophobic interior (nonpolar fatty acid tails) of the phospholipid bilayer as a barrier to polar water molecules.',
     'The hydrophobic core of the bilayer repels polar water molecules, slowing osmosis through the membrane lipids.',
     '["hydrophobic interior", "nonpolar fatty acid tails", "phospholipid bilayer is hydrophobic"]'::jsonb)
  on conflict (content_item_version_id, criterion_key) do nothing;
  v_ci_id := null; v_civ_id := null;

  -- S-002: Enzyme activity and temperature / denaturation
  insert into app.content_items (exam_pack_version_id, content_key, item_type, frq_form, title, status)
  values (v_epv_id, 'APBIO-FRQ-S-002', 'frq', 'short', 'APBIO-FRQ-S-002', 'draft')
  on conflict (exam_pack_version_id, content_key) do nothing returning id into v_ci_id;
  if v_ci_id is null then select id into v_ci_id from app.content_items
    where exam_pack_version_id = v_epv_id and content_key = 'APBIO-FRQ-S-002'; end if;

  insert into app.content_item_versions (content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status)
  values (v_ci_id, 1,
    'An experiment measures the rate of a catalase-catalyzed reaction at temperatures from 10 degrees C to 70 degrees C.',
    'A graph shows reaction rate peaking near 37 degrees C and declining sharply above 50 degrees C, approaching zero by 65 degrees C.',
    '{"modules":["1","2"]}'::jsonb, md5('APBIO-FRQ-S-002'), 'draft')
  on conflict (content_item_id, version_num) do nothing returning id into v_civ_id;
  if v_civ_id is null then select id into v_civ_id from app.content_item_versions
    where content_item_id = v_ci_id and version_num = 1; end if;

  insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants) values
    (v_civ_id, 'a',
     'Explain why enzyme-catalyzed reaction rate increases as temperature rises from 10 degrees C to the optimum temperature.',
     2,
     'Higher temperature increases kinetic energy of substrate molecules, leading to more frequent collisions with the enzyme active site and a higher reaction rate.',
     'Higher temperature gives molecules more kinetic energy, increasing collision frequency with the active site.',
     '["more kinetic energy", "more frequent collisions", "molecules move faster", "faster substrate-enzyme collisions"]'::jsonb),
    (v_civ_id, 'b',
     'Explain the molecular basis for the sharp decline in enzyme activity above 50 degrees C.',
     2,
     'High temperatures disrupt weak bonds (hydrogen bonds, hydrophobic interactions) that maintain enzyme tertiary structure, causing denaturation and loss of active site shape so substrate cannot bind.',
     'Heat breaks hydrogen bonds and other weak interactions that maintain the enzyme tertiary structure; denaturation distorts the active site so substrate cannot bind.',
     '["denaturation", "break hydrogen bonds", "active site changes shape", "tertiary structure disrupted"]'::jsonb)
  on conflict (content_item_version_id, criterion_key) do nothing;
  v_ci_id := null; v_civ_id := null;

  -- S-003: Light-dependent reactions / chemiosmosis
  insert into app.content_items (exam_pack_version_id, content_key, item_type, frq_form, title, status)
  values (v_epv_id, 'APBIO-FRQ-S-003', 'frq', 'short', 'APBIO-FRQ-S-003', 'draft')
  on conflict (exam_pack_version_id, content_key) do nothing returning id into v_ci_id;
  if v_ci_id is null then select id into v_ci_id from app.content_items
    where exam_pack_version_id = v_epv_id and content_key = 'APBIO-FRQ-S-003'; end if;

  insert into app.content_item_versions (content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status)
  values (v_ci_id, 1,
    'Light energy absorbed by chlorophyll in the thylakoid membrane drives production of ATP and NADPH during the light-dependent reactions of photosynthesis.',
    'A diagram shows the thylakoid membrane with Photosystem II, the electron transport chain, Photosystem I, and ATP synthase.',
    '{"modules":["3"]}'::jsonb, md5('APBIO-FRQ-S-003'), 'draft')
  on conflict (content_item_id, version_num) do nothing returning id into v_civ_id;
  if v_civ_id is null then select id into v_civ_id from app.content_item_versions
    where content_item_id = v_ci_id and version_num = 1; end if;

  insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants) values
    (v_civ_id, 'a',
     'Trace the path of electrons from water to NADP+ during the light-dependent reactions, naming at least two electron carriers or complexes.',
     2,
     'Water is split at PSII releasing electrons; electrons flow through plastoquinone, cytochrome b6f complex, plastocyanin; reach PSI; re-energized; transferred via ferredoxin to NADP+ reductase to reduce NADP+ to NADPH.',
     'Electrons from water oxidation at PSII flow through the electron transport chain to PSI, then reduce NADP+ to NADPH.',
     '["water to PSII to ETC to PSI to NADPH", "photolysis of water", "electrons reduce NADP+ to NADPH"]'::jsonb),
    (v_civ_id, 'b',
     'Explain how the proton gradient across the thylakoid membrane is established and how it drives ATP synthesis.',
     2,
     'H+ accumulates in thylakoid lumen from water splitting and ETC proton pumping; electrochemical gradient drives H+ through ATP synthase back into stroma; flow powers phosphorylation of ADP to ATP (chemiosmosis).',
     'Electron transfer pumps H+ into the thylakoid lumen; the resulting concentration gradient drives H+ through ATP synthase, powering ATP synthesis by chemiosmosis.',
     '["proton gradient", "chemiosmosis", "H+ flows through ATP synthase", "electrochemical gradient drives ATP synthesis"]'::jsonb)
  on conflict (content_item_version_id, criterion_key) do nothing;
  v_ci_id := null; v_civ_id := null;

  -- S-004: Glycolysis and fermentation
  insert into app.content_items (exam_pack_version_id, content_key, item_type, frq_form, title, status)
  values (v_epv_id, 'APBIO-FRQ-S-004', 'frq', 'short', 'APBIO-FRQ-S-004', 'draft')
  on conflict (exam_pack_version_id, content_key) do nothing returning id into v_ci_id;
  if v_ci_id is null then select id into v_ci_id from app.content_items
    where exam_pack_version_id = v_epv_id and content_key = 'APBIO-FRQ-S-004'; end if;

  insert into app.content_item_versions (content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status)
  values (v_ci_id, 1,
    'A cell lacking functional mitochondria can still generate ATP through glycolysis in the cytoplasm.',
    'A researcher treats yeast cells with a drug that destroys mitochondrial function and measures ATP production with and without oxygen.',
    '{"modules":["3"]}'::jsonb, md5('APBIO-FRQ-S-004'), 'draft')
  on conflict (content_item_id, version_num) do nothing returning id into v_civ_id;
  if v_civ_id is null then select id into v_civ_id from app.content_item_versions
    where content_item_id = v_ci_id and version_num = 1; end if;

  insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants) values
    (v_civ_id, 'a',
     'Identify the net ATP yield from glycolysis per molecule of glucose and explain how this ATP is produced.',
     2,
     'Net yield is 2 ATP per glucose; produced by substrate-level phosphorylation at the phosphoglycerate kinase and pyruvate kinase steps.',
     '2 net ATP per glucose are produced by substrate-level phosphorylation during glycolysis.',
     '["2 net ATP", "substrate-level phosphorylation", "direct phosphate transfer to ADP", "not by ETC"]'::jsonb),
    (v_civ_id, 'b',
     'Explain why fermentation is necessary to sustain glycolysis in the absence of oxygen.',
     2,
     'Glycolysis requires NAD+ to accept electrons; NADH produced during glycolysis must be re-oxidized to NAD+ for glycolysis to continue; fermentation regenerates NAD+ from NADH without oxygen.',
     'Fermentation regenerates NAD+ from NADH, allowing glycolysis to continue producing ATP when oxygen (and the ETC) is unavailable.',
     '["regenerates NAD+", "oxidizes NADH back to NAD+", "NAD+ is required for glycolysis to continue"]'::jsonb)
  on conflict (content_item_version_id, criterion_key) do nothing;
  v_ci_id := null; v_civ_id := null;

  -- S-005: Signal transduction
  insert into app.content_items (exam_pack_version_id, content_key, item_type, frq_form, title, status)
  values (v_epv_id, 'APBIO-FRQ-S-005', 'frq', 'short', 'APBIO-FRQ-S-005', 'draft')
  on conflict (exam_pack_version_id, content_key) do nothing returning id into v_ci_id;
  if v_ci_id is null then select id into v_ci_id from app.content_items
    where exam_pack_version_id = v_epv_id and content_key = 'APBIO-FRQ-S-005'; end if;

  insert into app.content_item_versions (content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status)
  values (v_ci_id, 1,
    'A signaling molecule binds to a G protein-coupled receptor on the cell surface and triggers a phosphorylation cascade inside the cell.',
    'A diagram shows: signal molecule to GPCR, G protein activation, adenylyl cyclase, cAMP production, protein kinase A activation, and multiple phosphorylated downstream targets.',
    '{"modules":["4"]}'::jsonb, md5('APBIO-FRQ-S-005'), 'draft')
  on conflict (content_item_id, version_num) do nothing returning id into v_civ_id;
  if v_civ_id is null then select id into v_civ_id from app.content_item_versions
    where content_item_id = v_ci_id and version_num = 1; end if;

  insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants) values
    (v_civ_id, 'a',
     'Explain how a single signaling molecule binding one receptor can produce a large amplified cellular response.',
     2,
     'Each activated receptor activates multiple G proteins; each G protein activates adenylyl cyclase; each adenylyl cyclase produces many cAMP molecules; each PKA phosphorylates many substrates — the signal is amplified at each step of the cascade.',
     'At each step in the cascade, one activated molecule activates many downstream molecules, exponentially amplifying the original signal.',
     '["signal amplification", "cascade amplifies at each step", "one receptor activates many G proteins", "second messengers multiply signal"]'::jsonb),
    (v_civ_id, 'b',
     'Identify one mechanism by which a cell terminates a signal transduction cascade after the signaling molecule is removed.',
     2,
     'Any one of: phosphodiesterase degrades cAMP to AMP; protein phosphatases remove phosphate groups from substrates; receptor undergoes endocytosis (internalization); GTPase activity of G protein hydrolyzes GTP to GDP, inactivating G protein.',
     'Phosphodiesterase degrades cAMP, ending protein kinase A activation when the signaling molecule is no longer bound.',
     '["phosphodiesterase degrades cAMP", "protein phosphatase", "receptor internalization", "GTP hydrolysis by G protein"]'::jsonb)
  on conflict (content_item_version_id, criterion_key) do nothing;
  v_ci_id := null; v_civ_id := null;

  -- S-006: Mitosis vs meiosis / crossing over
  insert into app.content_items (exam_pack_version_id, content_key, item_type, frq_form, title, status)
  values (v_epv_id, 'APBIO-FRQ-S-006', 'frq', 'short', 'APBIO-FRQ-S-006', 'draft')
  on conflict (exam_pack_version_id, content_key) do nothing returning id into v_ci_id;
  if v_ci_id is null then select id into v_ci_id from app.content_items
    where exam_pack_version_id = v_epv_id and content_key = 'APBIO-FRQ-S-006'; end if;

  insert into app.content_item_versions (content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status)
  values (v_ci_id, 1,
    'A diploid organism with chromosome number 2n = 6 undergoes cell division under different conditions.',
    'A table compares the number of divisions, ploidy of resulting cells, and occurrence of crossing over in mitosis versus meiosis.',
    '{"modules":["4","5"]}'::jsonb, md5('APBIO-FRQ-S-006'), 'draft')
  on conflict (content_item_id, version_num) do nothing returning id into v_civ_id;
  if v_civ_id is null then select id into v_civ_id from app.content_item_versions
    where content_item_id = v_ci_id and version_num = 1; end if;

  insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants) values
    (v_civ_id, 'a',
     'Compare the chromosome number of cells produced by mitosis to the chromosome number of cells produced at the end of meiosis II for this organism.',
     2,
     'Mitosis produces 2 diploid cells each with 6 chromosomes (2n = 6). Meiosis II produces 4 haploid cells each with 3 chromosomes (n = 3).',
     'Mitosis yields cells with 6 chromosomes (2n = 6); meiosis II yields cells with 3 chromosomes (n = 3).',
     '["mitosis 2n=6, meiosis n=3", "diploid vs haploid products", "6 vs 3 chromosomes"]'::jsonb),
    (v_civ_id, 'b',
     'Explain how crossing over during meiosis I increases genetic variation among offspring.',
     2,
     'During prophase I, homologous chromosomes pair and exchange chromosome segments at chiasmata; new combinations of alleles on chromatids are created that were not present in either parent, increasing allele diversity in gametes and offspring.',
     'Crossing over exchanges segments between homologous chromosomes during prophase I, creating new combinations of alleles on chromatids that differ from either parental chromosome.',
     '["new allele combinations", "recombination at chiasmata", "exchange of segments between homologs", "increases gamete diversity"]'::jsonb)
  on conflict (content_item_version_id, criterion_key) do nothing;
  v_ci_id := null; v_civ_id := null;

  -- S-007: Monohybrid cross / principle of segregation
  insert into app.content_items (exam_pack_version_id, content_key, item_type, frq_form, title, status)
  values (v_epv_id, 'APBIO-FRQ-S-007', 'frq', 'short', 'APBIO-FRQ-S-007', 'draft')
  on conflict (exam_pack_version_id, content_key) do nothing returning id into v_ci_id;
  if v_ci_id is null then select id into v_ci_id from app.content_items
    where exam_pack_version_id = v_epv_id and content_key = 'APBIO-FRQ-S-007'; end if;

  insert into app.content_item_versions (content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status)
  values (v_ci_id, 1,
    'In a hypothetical plant species, purple flower color (allele A) is dominant over white flower color (allele a). Two heterozygous plants are crossed.',
    'Parental cross: Aa x Aa. Students predict offspring phenotypes and genotypes.',
    '{"modules":["5"]}'::jsonb, md5('APBIO-FRQ-S-007'), 'draft')
  on conflict (content_item_id, version_num) do nothing returning id into v_civ_id;
  if v_civ_id is null then select id into v_civ_id from app.content_item_versions
    where content_item_id = v_ci_id and version_num = 1; end if;

  insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants) values
    (v_civ_id, 'a',
     'Construct a Punnett square for the Aa x Aa cross and predict the expected phenotypic ratio in the offspring.',
     2,
     'Correct 2x2 Punnett square showing AA, Aa, Aa, aa. Phenotypic ratio: 3 purple : 1 white (or 75% purple, 25% white).',
     'The Punnett square gives a 1:2:1 genotypic ratio (AA:Aa:aa) and a 3:1 phenotypic ratio (purple:white).',
     '["3:1 phenotypic ratio", "75% purple 25% white", "1:2:1 genotypic ratio AA:Aa:aa"]'::jsonb),
    (v_civ_id, 'b',
     'State the principle of segregation and explain how meiosis accounts for it at the cellular level.',
     2,
     'Principle of Segregation: the two alleles for a gene separate during gamete formation so each gamete carries one allele. Meiosis accounts for this because homologous chromosomes (each carrying one allele) separate during meiosis I, placing one allele into each gamete.',
     'The principle of segregation states alleles separate during gamete formation; homologous chromosomes separate at meiosis I, delivering one allele to each gamete.',
     '["alleles separate during gamete formation", "meiosis I separates homologs", "one allele per gamete"]'::jsonb)
  on conflict (content_item_version_id, criterion_key) do nothing;
  v_ci_id := null; v_civ_id := null;

  -- S-008: DNA replication
  insert into app.content_items (exam_pack_version_id, content_key, item_type, frq_form, title, status)
  values (v_epv_id, 'APBIO-FRQ-S-008', 'frq', 'short', 'APBIO-FRQ-S-008', 'draft')
  on conflict (exam_pack_version_id, content_key) do nothing returning id into v_ci_id;
  if v_ci_id is null then select id into v_ci_id from app.content_items
    where exam_pack_version_id = v_epv_id and content_key = 'APBIO-FRQ-S-008'; end if;

  insert into app.content_item_versions (content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status)
  values (v_ci_id, 1,
    'During DNA replication, both strands of the parental double helix serve as templates for synthesis of two new daughter strands.',
    'A diagram of a replication fork shows the parental DNA being unwound, with arrows indicating the leading and lagging strands and the locations of helicase and DNA polymerase.',
    '{"modules":["6"]}'::jsonb, md5('APBIO-FRQ-S-008'), 'draft')
  on conflict (content_item_id, version_num) do nothing returning id into v_civ_id;
  if v_civ_id is null then select id into v_civ_id from app.content_item_versions
    where content_item_id = v_ci_id and version_num = 1; end if;

  insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants) values
    (v_civ_id, 'a',
     'Describe the roles of helicase and DNA polymerase at the replication fork.',
     2,
     'Helicase unwinds the double helix by breaking hydrogen bonds between base pairs. DNA polymerase adds complementary deoxyribonucleotides to the 3-prime end of the growing strand, synthesizing new DNA in the 5-prime to 3-prime direction using each parental strand as a template.',
     'Helicase unwinds the double helix; DNA polymerase adds nucleotides in the 5-prime to 3-prime direction using the template strand.',
     '["helicase unwinds DNA at replication fork", "polymerase adds nucleotides 5 to 3", "complementary base pairing", "template-directed synthesis"]'::jsonb),
    (v_civ_id, 'b',
     'Explain why the lagging strand is synthesized in short fragments and describe how these fragments are joined into a continuous strand.',
     2,
     'DNA polymerase can only add nucleotides in the 5-prime to 3-prime direction; the lagging strand template runs antiparallel (3-prime to 5-prime) away from the fork, so synthesis must proceed in short Okazaki fragments, each primed by an RNA primer. Primers are later replaced with DNA by DNA polymerase and gaps are sealed by DNA ligase.',
     'DNA polymerase only synthesizes 5 to 3; the lagging strand template runs away from the fork, requiring discontinuous synthesis as Okazaki fragments; DNA ligase seals the nicks between fragments after primer removal.',
     '["5 to 3 directionality", "Okazaki fragments", "DNA ligase seals nicks", "synthesized away from fork in fragments"]'::jsonb)
  on conflict (content_item_version_id, criterion_key) do nothing;
  v_ci_id := null; v_civ_id := null;

  -- S-009: mRNA processing / alternative splicing
  insert into app.content_items (exam_pack_version_id, content_key, item_type, frq_form, title, status)
  values (v_epv_id, 'APBIO-FRQ-S-009', 'frq', 'short', 'APBIO-FRQ-S-009', 'draft')
  on conflict (exam_pack_version_id, content_key) do nothing returning id into v_ci_id;
  if v_ci_id is null then select id into v_ci_id from app.content_items
    where exam_pack_version_id = v_epv_id and content_key = 'APBIO-FRQ-S-009'; end if;

  insert into app.content_item_versions (content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status)
  values (v_ci_id, 1,
    'In eukaryotic cells, the primary RNA transcript undergoes several modifications in the nucleus before export to the cytoplasm for translation.',
    'A diagram shows a pre-mRNA with labeled exons (E1, E2, E3) and introns (I1, I2) before processing, and two alternative mature mRNA products after splicing.',
    '{"modules":["6"]}'::jsonb, md5('APBIO-FRQ-S-009'), 'draft')
  on conflict (content_item_id, version_num) do nothing returning id into v_civ_id;
  if v_civ_id is null then select id into v_civ_id from app.content_item_versions
    where content_item_id = v_ci_id and version_num = 1; end if;

  insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants) values
    (v_civ_id, 'a',
     'Identify two modifications made to pre-mRNA during RNA processing in eukaryotes other than splicing.',
     2,
     'Any two of: (1) a 5-prime 7-methylguanosine cap is added to the 5-prime end; (2) a poly-A tail of adenine nucleotides is added to the 3-prime end.',
     'A 5-prime methylguanosine cap is added to protect the mRNA and aid ribosome attachment; a poly-A tail is added to the 3-prime end to protect from degradation.',
     '["5-prime cap", "poly-A tail", "7-methylguanosine cap", "3-prime polyadenylation"]'::jsonb),
    (v_civ_id, 'b',
     'Explain how alternative splicing of a single gene can produce multiple different proteins.',
     2,
     'Different exons can be included or excluded from the mature mRNA in different cell types or at different developmental stages; each combination of exons produces a different mRNA, which is translated into a different polypeptide with a different amino acid sequence and potentially different function.',
     'Alternative splicing joins different combinations of exons to produce different mRNAs from the same gene; each mRNA encodes a different protein.',
     '["different exon combinations", "different mRNAs from same gene", "different proteins translated", "cell-type-specific splicing"]'::jsonb)
  on conflict (content_item_version_id, criterion_key) do nothing;
  v_ci_id := null; v_civ_id := null;

  -- S-010: Natural selection / relative fitness
  insert into app.content_items (exam_pack_version_id, content_key, item_type, frq_form, title, status)
  values (v_epv_id, 'APBIO-FRQ-S-010', 'frq', 'short', 'APBIO-FRQ-S-010', 'draft')
  on conflict (exam_pack_version_id, content_key) do nothing returning id into v_ci_id;
  if v_ci_id is null then select id into v_ci_id from app.content_items
    where exam_pack_version_id = v_epv_id and content_key = 'APBIO-FRQ-S-010'; end if;

  insert into app.content_item_versions (content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status)
  values (v_ci_id, 1,
    'In a forest ecosystem, bark-colored beetles survive predation by insectivorous birds at a higher rate than green-colored beetles resting on tree bark.',
    'Over 10 generations, the proportion of bark-colored beetles in the population increases from 20 percent to 75 percent.',
    '{"modules":["7"]}'::jsonb, md5('APBIO-FRQ-S-010'), 'draft')
  on conflict (content_item_id, version_num) do nothing returning id into v_civ_id;
  if v_civ_id is null then select id into v_civ_id from app.content_item_versions
    where content_item_id = v_ci_id and version_num = 1; end if;

  insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants) values
    (v_civ_id, 'a',
     'Explain how natural selection acting on phenotypic variation in beetle color changes allele frequencies over generations.',
     2,
     'Bark-colored phenotype confers higher survival and reproduction rate; individuals with alleles for bark color contribute more offspring to each generation; over many generations the allele frequency for bark color increases in the population.',
     'Bark-colored beetles survive and reproduce at higher rates; alleles producing bark color are passed to more offspring each generation, increasing allele frequency over time.',
     '["differential survival and reproduction", "alleles for bark color increase in frequency", "natural selection changes allele frequency", "heritable phenotypic variation"]'::jsonb),
    (v_civ_id, 'b',
     'Define relative fitness and explain how it would be measured in the beetle population described above.',
     2,
     'Relative fitness is the reproductive success of a genotype or phenotype compared to the most reproductively successful phenotype in the population. Measured by comparing survival rate to reproductive age and number of viable offspring produced by bark-colored vs. green-colored beetles per generation.',
     'Relative fitness is reproductive success compared to the most fit phenotype; measured by comparing the number of surviving offspring produced by bark-colored versus green-colored beetles.',
     '["relative fitness = reproductive success compared to most fit", "compare offspring numbers between phenotypes", "survival to reproduction rate"]'::jsonb)
  on conflict (content_item_version_id, criterion_key) do nothing;
  v_ci_id := null; v_civ_id := null;

end $$;
