-- Exported from Production migration history (supabase_migrations.schema_migrations)
-- version: 20260630114253
-- recorded name: seed_long_frqs_l035_l038
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

  -- L-035: Dihybrid cross / gene linkage and recombination frequency
  insert into app.content_items (exam_pack_version_id, content_key, item_type, frq_form, title, status)
  values (v_epv_id, 'APBIO-FRQ-L-035', 'frq', 'long', 'APBIO-FRQ-L-035', 'draft')
  on conflict (exam_pack_version_id, content_key) do nothing returning id into v_ci_id;
  if v_ci_id is null then select id into v_ci_id from app.content_items
    where exam_pack_version_id = v_epv_id and content_key = 'APBIO-FRQ-L-035'; end if;

  insert into app.content_item_versions (content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status)
  values (v_ci_id, 1,
    'Answer all parts of the following question.

(a) State the expected phenotypic ratio of a dihybrid testcross (AaBb x aabb) if the two genes assort independently, and explain the chromosomal basis for independent assortment.

(b) Using the observed data from the testcross, calculate the recombination frequency between gene A and gene B. Show your work.

(c) Based on your answer to part (b), evaluate whether genes A and B are likely on the same chromosome or different chromosomes, and explain your reasoning, including what the recombination frequency indicates about the physical distance between the genes if they are linked.

(d) Explain, at the chromosomal level, how the recombinant offspring genotypes (Ab and aB) are produced during meiosis in the heterozygous (AaBb) parent, despite the genes being linked.',
    'A fruit fly heterozygous for two genes (A = gray body dominant over a = black body; B = normal wings dominant over b = vestigial wings) is testcrossed to a doubly homozygous recessive fly (aabb). The phenotypes of 1,000 offspring are recorded.

Offspring phenotype       | Genotype | Number observed
Gray body, normal wings   | AaBb     | 420
Black body, vestigial     | aabb     | 410
Gray body, vestigial      | Aabb     | 85
Black body, normal wings  | aaBb     | 85',
    '{"modules":["5"],"frq_type":"long","subtopics":["5.4 Linked Genes","5.5 Meiosis and Genetic Diversity"],"total_points":10}'::jsonb,
    md5('APBIO-FRQ-L-035'), 'draft')
  on conflict (content_item_id, version_num) do nothing returning id into v_civ_id;
  if v_civ_id is null then select id into v_civ_id from app.content_item_versions
    where content_item_id = v_ci_id and version_num = 1; end if;

  insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants) values
    (v_civ_id, 'a',
     'State the expected ratio for independent assortment and explain the chromosomal basis.',
     2,
     'Expected ratio is 1:1:1:1 across the four phenotype classes. Chromosomal basis: genes on different (nonhomologous) chromosomes are distributed to gametes independently because homologous chromosome pairs orient randomly relative to each other during metaphase I, so the segregation of one gene pair does not influence the segregation of the other.',
     '1:1:1:1 ratio expected; this occurs because genes on different chromosomes assort independently due to random orientation of homologous pairs during meiosis I.',
     '["1:1:1:1 ratio", "independent assortment", "random orientation at metaphase I", "different chromosomes segregate independently"]'::jsonb),
    (v_civ_id, 'b',
     'Calculate recombination frequency from the data.',
     2,
     'Recombinant offspring are Aabb and aaBb (the non-parental classes) = 85 + 85 = 170. Recombination frequency = 170/1000 x 100 = 17%.',
     'Recombination frequency = (85+85)/1000 x 100 = 17%.',
     '["17% recombination frequency", "170 recombinants out of 1000", "recombinant classes are Aabb and aaBb"]'::jsonb),
    (v_civ_id, 'c',
     'Evaluate linkage based on recombination frequency and explain distance implications.',
     2,
     'Because the observed ratio (420:410:85:85) deviates substantially from the 1:1:1:1 ratio expected for independent assortment, and recombination frequency (17%) is well below 50%, genes A and B are likely linked on the same chromosome. A recombination frequency of 17% (less than 50%) indicates the genes are relatively close together on the chromosome (using 1% recombination frequency approximately 1 map unit, the genes are roughly 17 map units apart); the lower the recombination frequency, the closer the genes.',
     'The data deviate from 1:1:1:1 and recombination frequency (17%) is below 50%, indicating the genes are linked on the same chromosome, roughly 17 map units apart.',
     '["genes are linked", "same chromosome", "recombination frequency below 50% indicates linkage", "17 map units apart", "closer genes have lower recombination frequency"]'::jsonb),
    (v_civ_id, 'd',
     'Explain how recombinant genotypes are produced during meiosis despite linkage.',
     2,
     'During prophase I of meiosis, homologous chromosomes pair up and undergo crossing over (chiasma formation) at random points along their length; if a crossover occurs between the loci of gene A and gene B, the maternal and paternal alleles are exchanged between non-sister chromatids, producing chromosomes with new (recombinant) combinations of alleles (Ab and aB) that differ from the original parental combinations (AB and ab).',
     'Crossing over between non-sister chromatids during prophase I exchanges segments of the chromosome between the A and B loci, producing recombinant Ab and aB chromosomes despite the genes being linked.',
     '["crossing over during prophase I", "exchange between non-sister chromatids", "chiasma formation", "produces new allele combinations"]'::jsonb)
  on conflict (content_item_version_id, criterion_key) do nothing;
  v_ci_id := null; v_civ_id := null;

  -- L-036: Operon model with reporter gene and inducer
  insert into app.content_items (exam_pack_version_id, content_key, item_type, frq_form, title, status)
  values (v_epv_id, 'APBIO-FRQ-L-036', 'frq', 'long', 'APBIO-FRQ-L-036', 'draft')
  on conflict (exam_pack_version_id, content_key) do nothing returning id into v_ci_id;
  if v_ci_id is null then select id into v_ci_id from app.content_items
    where exam_pack_version_id = v_epv_id and content_key = 'APBIO-FRQ-L-036'; end if;

  insert into app.content_item_versions (content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status)
  values (v_ci_id, 1,
    'Answer all parts of the following question.

(a) Using the data, describe the effect of inducer concentration on reporter enzyme activity in the wild-type strain.

(b) Explain, in terms of repressor protein and operator binding, why reporter enzyme activity is low when inducer is absent and increases when inducer is added.

(c) Strain 2 carries a mutation in the repressor gene such that the repressor protein can no longer bind the inducer molecule but can still bind the operator normally. Using the data for Strain 2, evaluate whether this prediction is supported, and explain the molecular reasoning.

(d) Strain 3 carries a different mutation that deletes the operator sequence entirely. Predict the pattern of reporter enzyme activity you would expect across all inducer concentrations for Strain 3, and explain your prediction in terms of RNA polymerase binding and repressor function.',
    'Researchers engineer a bacterial operon in which the structural gene is replaced with a reporter gene whose enzyme activity is easily measured. Three strains are grown in increasing concentrations of inducer molecule, and reporter enzyme activity is measured after 2 hours.

Inducer (mM) | Wild-type activity (units) | Strain 2 activity (units)
0            | 5                          | 4
0.1          | 40                         | 5
1.0          | 95                         | 6
10.0         | 98                         | 5',
    '{"modules":["6"],"frq_type":"long","subtopics":["6.3 Gene Regulation","6.4 Operons"],"total_points":10}'::jsonb,
    md5('APBIO-FRQ-L-036'), 'draft')
  on conflict (content_item_id, version_num) do nothing returning id into v_civ_id;
  if v_civ_id is null then select id into v_civ_id from app.content_item_versions
    where content_item_id = v_ci_id and version_num = 1; end if;

  insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants) values
    (v_civ_id, 'a',
     'Describe the effect of inducer concentration on wild-type reporter activity.',
     2,
     'As inducer concentration increases from 0 to 10.0 mM, reporter enzyme activity increases (from 5 to 98 units), then levels off (plateaus) between 1.0 and 10.0 mM (95 to 98 units) — a positive, saturating dose-response relationship.',
     'Reporter activity increases as inducer concentration increases, then plateaus at higher concentrations (between 1.0 and 10.0 mM), showing a saturating positive relationship.',
     '["activity increases with inducer", "plateaus at high inducer", "positive dose-response", "saturating relationship"]'::jsonb),
    (v_civ_id, 'b',
     'Explain low activity without inducer and increased activity with inducer in terms of repressor and operator.',
     2,
     'Without inducer, the repressor protein binds to the operator sequence, physically blocking RNA polymerase from transcribing the (reporter) structural gene, keeping activity low. When inducer is added, it binds to the repressor protein, changing its shape (allosteric change) so it can no longer bind the operator; the repressor releases from the operator, allowing RNA polymerase to transcribe the gene, increasing reporter enzyme activity.',
     'Without inducer the repressor binds the operator and blocks transcription; inducer binds the repressor, changes its shape, and causes it to release the operator, allowing transcription and increased reporter activity.',
     '["repressor binds operator without inducer", "blocks RNA polymerase", "inducer binds repressor allosterically", "repressor releases operator with inducer"]'::jsonb),
    (v_civ_id, 'c',
     'Evaluate whether Strain 2 data support the repressor-cannot-bind-inducer mutation hypothesis.',
     2,
     'The data support the hypothesis. Strain 2 shows consistently low reporter activity (4-6 units) across all inducer concentrations, with no increase even at high inducer (10.0 mM gives only 5 units, vs. 98 in wild type). This is consistent with a repressor that can still bind and block the operator (since baseline matches wild-type baseline) but cannot respond to inducer (since activity never increases), meaning the repressor stays bound to the operator and blocks transcription regardless of inducer concentration.',
     'The data support the hypothesis: Strain 2 activity stays low (4-6 units) at all inducer concentrations, consistent with a repressor that still blocks the operator but can no longer be released by inducer binding.',
     '["Strain 2 activity stays low at all inducer levels", "repressor still binds operator", "repressor cannot respond to inducer", "data support the hypothesis"]'::jsonb),
    (v_civ_id, 'd',
     'Predict Strain 3 (operator deletion) activity pattern across inducer concentrations and explain.',
     2,
     'Strain 3 (operator deleted) would show high reporter enzyme activity at ALL inducer concentrations, including 0 mM, because without an operator sequence the repressor protein has nowhere to bind, regardless of whether it is bound to inducer or not; RNA polymerase can access the promoter and transcribe the gene continuously (constitutive expression), unaffected by inducer presence or absence.',
     'Strain 3 would show consistently high activity at all inducer concentrations because, without an operator, the repressor cannot block transcription regardless of inducer — expression becomes constitutive.',
     '["constitutively high activity", "no operator means repressor cannot bind", "expression unaffected by inducer", "RNA polymerase transcribes continuously"]'::jsonb)
  on conflict (content_item_version_id, criterion_key) do nothing;
  v_ci_id := null; v_civ_id := null;

  -- L-037: Biotechnology: gel electrophoresis / restriction enzyme mapping
  insert into app.content_items (exam_pack_version_id, content_key, item_type, frq_form, title, status)
  values (v_epv_id, 'APBIO-FRQ-L-037', 'frq', 'long', 'APBIO-FRQ-L-037', 'draft')
  on conflict (exam_pack_version_id, content_key) do nothing returning id into v_ci_id;
  if v_ci_id is null then select id into v_ci_id from app.content_items
    where exam_pack_version_id = v_epv_id and content_key = 'APBIO-FRQ-L-037'; end if;

  insert into app.content_item_versions (content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status)
  values (v_ci_id, 1,
    'Answer all parts of the following question.

(a) Explain how gel electrophoresis separates DNA fragments, including the role of the gel matrix and the electric field, and explain why DNA fragments move toward the positive electrode.

(b) Using the fragment sizes observed for the single-enzyme digests and the double digest, construct a restriction map of the original plasmid showing the order and approximate spacing of the EcoRI and HindIII sites. Show your reasoning.

(c) A student claims the plasmid must be circular rather than linear because the sum of the double-digest fragment sizes equals the sum of either single-digest''s fragment sizes. Evaluate this claim and explain the reasoning that supports or refutes it.

(d) Predict what additional fragment size(s) would appear if a third restriction enzyme that cuts the plasmid only once, at a site located exactly between one EcoRI site and the nearest HindIII site, were added to the double digest. Explain your prediction.',
    'A circular plasmid (6,000 base pairs total) is digested separately with EcoRI, HindIII, and both enzymes together, then run on an agarose gel.

EcoRI alone: fragments of 4,000 bp and 2,000 bp
HindIII alone: fragments of 3,500 bp and 2,500 bp
EcoRI + HindIII together: fragments of 2,500 bp, 1,500 bp, 1,000 bp, and 1,000 bp',
    '{"modules":["6"],"frq_type":"long","subtopics":["6.7 Biotechnology","6.8 Restriction Enzymes and Gel Electrophoresis"],"total_points":10}'::jsonb,
    md5('APBIO-FRQ-L-037'), 'draft')
  on conflict (content_item_id, version_num) do nothing returning id into v_civ_id;
  if v_civ_id is null then select id into v_civ_id from app.content_item_versions
    where content_item_id = v_ci_id and version_num = 1; end if;

  insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants) values
    (v_civ_id, 'a',
     'Explain how gel electrophoresis separates DNA fragments and why they move toward the positive electrode.',
     2,
     'The gel matrix (agarose) acts as a molecular sieve; smaller DNA fragments move through the pores more easily/quickly than larger fragments, so fragments separate by size as they migrate, with smaller fragments traveling farther in a given time. DNA is negatively charged (due to phosphate groups in the backbone), so in an electric field DNA fragments migrate toward the positive electrode (anode).',
     'Smaller fragments move faster through the gel matrix pores than larger fragments, separating DNA by size; DNA moves toward the positive electrode because its phosphate backbone gives it a negative charge.',
     '["smaller fragments move faster/farther", "gel acts as molecular sieve", "DNA is negatively charged from phosphate groups", "moves toward positive electrode/anode"]'::jsonb),
    (v_civ_id, 'b',
     'Construct a restriction map showing site order and spacing.',
     2,
     'Working from the double digest (2500, 1500, 1000, 1000 = 6000 total, consistent with circular plasmid), and comparing to single digests: the EcoRI sites are 4000 bp apart in one direction and 2000 bp apart the other way around the circle; HindIII sites are 3500 and 2500 bp apart. A consistent map: starting at EcoRI site 1, going 1000 bp to a HindIII site, then 1500 bp to EcoRI site 2 (total 2500 = matches one HindIII fragment), then continuing 1000 bp to the second HindIII site, then 2500 bp back to EcoRI site 1 (totals to 6000 bp circle, and each single-enzyme fragment sum (4000+2000=6000 for EcoRI; 3500+2500=6000 for HindIII) is consistent). Accept any internally consistent map where the four double-digest fragments (2500,1500,1000,1000) sum correctly and reconstruct both single-digest fragment sets when sites are merged appropriately.',
     'A circular map with two EcoRI sites and two HindIII sites alternating around the plasmid, with segment lengths of 1000, 1500, 1000, and 2500 bp between consecutive sites (matching the double-digest fragments and summing correctly to reconstruct each single-digest pattern).',
     '["circular map with 4 segments", "1000, 1500, 1000, 2500 bp segments", "sites alternate EcoRI and HindIII", "segments sum to single-digest fragment sizes"]'::jsonb),
    (v_civ_id, 'c',
     'Evaluate the student''s claim that equal fragment sums prove a circular plasmid.',
     2,
     'The claim is not well supported as stated: the total fragment size from a digest equals the total plasmid size regardless of whether the plasmid is circular or linear, because every base pair of the original molecule ends up in some fragment either way. The fact that fragment sums are equal across single and double digests is expected for ANY plasmid (circular or linear) cut by the same enzymes, since digestion does not add or remove any base pairs. The number of fragments produced by n cut sites (n fragments for a circular molecule vs n+1 fragments for a linear molecule of the same size) is what is more informative for determining circularity, not the fragment-size sum.',
     'The claim is not valid reasoning: equal fragment sums occur for any plasmid, circular or linear, because cutting does not change total base pairs. Circularity is better inferred from the fragment count relative to the number of cut sites (n cuts give n fragments if circular, n+1 if linear).',
     '["fragment sums are equal regardless of circularity", "cutting does not remove base pairs", "fragment count vs cut site count is the better indicator", "claim is not well supported"]'::jsonb),
    (v_civ_id, 'd',
     'Predict the new fragment(s) from adding a third enzyme cutting between an EcoRI and HindIII site, and explain.',
     2,
     'Adding a cut site exactly between two existing sites would split whichever fragment contains that site into two smaller fragments whose lengths sum to the original fragment length; for example, if the new site falls in the middle of the 1000 bp fragment between an EcoRI and HindIII site, that fragment would be replaced by two new fragments of approximately 500 bp each, while all other fragments (2500, 1500, 1000) remain unchanged, since the new enzyme only cuts once at that specified location.',
     'The fragment containing the new cut site would split into two fragments whose sizes sum to the original fragment length (e.g., a 1000 bp fragment cut exactly in half would yield two 500 bp fragments), while the other existing fragments would remain unchanged.',
     '["one fragment splits into two", "new fragment sizes sum to original", "other fragments unchanged", "single new cut site adds one more fragment overall"]'::jsonb)
  on conflict (content_item_version_id, criterion_key) do nothing;
  v_ci_id := null; v_civ_id := null;

  -- L-038: Phylogenetics / cladogram from molecular data
  insert into app.content_items (exam_pack_version_id, content_key, item_type, frq_form, title, status)
  values (v_epv_id, 'APBIO-FRQ-L-038', 'frq', 'long', 'APBIO-FRQ-L-038', 'draft')
  on conflict (exam_pack_version_id, content_key) do nothing returning id into v_ci_id;
  if v_ci_id is null then select id into v_ci_id from app.content_items
    where exam_pack_version_id = v_epv_id and content_key = 'APBIO-FRQ-L-038'; end if;

  insert into app.content_item_versions (content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status)
  values (v_ci_id, 1,
    'Answer all parts of the following question.

(a) Using the table, identify which two species are most closely related based on number of nucleotide differences, and explain the reasoning connecting sequence similarity to evolutionary relatedness.

(b) Construct a cladogram (or describe, in words, the branching pattern) showing the evolutionary relationships among Species 1-4 based on the data, using Species 5 as the outgroup. Justify the placement of each branch point.

(c) The molecular data show that Species 2 and Species 3 differ by only 2 nucleotides out of 500 examined. Explain how this small number of differences can still represent millions of years of independent evolution, referencing the concept of a molecular clock and mutation rate.

(d) A morphological study (based on limb structure) groups Species 1 and Species 4 together as closely related, conflicting with the molecular data. Propose a biological explanation for how morphological and molecular data could disagree, and explain which type of data is generally considered more reliable for distant evolutionary relationships and why.',
    'Researchers compare a 500-nucleotide region of a homologous gene across five related species. The table shows the number of nucleotide differences between each pair of species.

Species pair      | Nucleotide differences
1 vs 2             | 45
1 vs 3             | 48
1 vs 4             | 50
1 vs 5 (outgroup)  | 90
2 vs 3             | 2
2 vs 4             | 47
2 vs 5 (outgroup)  | 88
3 vs 4             | 46
3 vs 5 (outgroup)  | 89
4 vs 5 (outgroup)  | 91',
    '{"modules":["7"],"frq_type":"long","subtopics":["7.13 Phylogeny","7.14 Molecular Evidence of Evolution"],"total_points":10}'::jsonb,
    md5('APBIO-FRQ-L-038'), 'draft')
  on conflict (content_item_id, version_num) do nothing returning id into v_civ_id;
  if v_civ_id is null then select id into v_civ_id from app.content_item_versions
    where content_item_id = v_ci_id and version_num = 1; end if;

  insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants) values
    (v_civ_id, 'a',
     'Identify the most closely related species pair and explain the reasoning.',
     2,
     'Species 2 and Species 3 are most closely related, having only 2 nucleotide differences (the fewest of any pair). Fewer nucleotide (sequence) differences indicate less time has passed since the two species shared a common ancestor (less accumulated mutation), so the species with the fewest differences are inferred to be the most closely related (most recent common ancestor).',
     'Species 2 and 3 are most closely related (only 2 differences); fewer sequence differences indicate a more recent common ancestor and less time for mutations to accumulate.',
     '["Species 2 and 3 most closely related", "fewest nucleotide differences", "fewer differences = more recent common ancestor", "sequence similarity reflects relatedness"]'::jsonb),
    (v_civ_id, 'b',
     'Construct/describe a cladogram with Species 5 as outgroup and justify branch points.',
     2,
     'Species 5 branches off first (outgroup, most differences from all others, ~88-91). Among the remaining four, Species 2 and 3 form the most recent (tightest) clade (2 differences). Species 1 branches next, being similarly distant from 2/3 (45,48) and from 4 (50). Species 4 is roughly equidistant from 1, 2, and 3 (47-50), suggesting it diverged around the same time as Species 1, branching off after Species 5 but before or near the 1/(2,3) split. A reasonable cladogram: ((((2,3),1),4),5) or ((((2,3),4),1),5) — accept either ordering of 1 and 4 as long as Species 5 is outermost outgroup and (2,3) form the innermost clade, with reasoning based on difference counts provided.',
     'Species 5 is the outgroup (most different from all). Species 2 and 3 form the most recent clade (only 2 differences). Species 1 and 4 branch off earlier, each being more distantly related to the (2,3) clade and to each other.',
     '["Species 5 as outgroup branches first", "Species 2 and 3 form innermost clade", "Species 1 and 4 branch off earlier", "branch order based on number of differences"]'::jsonb),
    (v_civ_id, 'c',
     'Explain how few nucleotide differences can still represent millions of years using molecular clock concept.',
     2,
     'The molecular clock concept assumes mutations accumulate at a roughly constant rate over time for a given gene/region; because mutation rates are typically very low per generation, even a small number of fixed differences (2 out of 500, or 0.4%) can correspond to a substantial number of generations and potentially millions of years, since the absolute mutation rate per site per generation is small, so few changes does not mean little time has passed, just that a slow, steady clock has been ticking.',
     'Mutations accumulate slowly and at a roughly constant rate (molecular clock); because the mutation rate per site is very low, even a small number of differences (2/500) can still correspond to millions of years of independent evolution.',
     '["molecular clock assumes constant mutation rate", "low mutation rate per generation", "few changes can still mean long time", "0.4% difference can represent long divergence"]'::jsonb),
    (v_civ_id, 'd',
     'Propose an explanation for morphological/molecular conflict and state which is more reliable for distant relationships.',
     2,
     'Possible explanation: convergent evolution — Species 1 and 4 may have independently evolved similar limb structures due to similar selective pressures/environments (analogous structures) rather than inheriting them from a recent common ancestor (homologous structures), creating a misleading morphological signal. Molecular (DNA sequence) data are generally considered more reliable for distant evolutionary relationships because morphological traits are more subject to convergent evolution and selective pressure can cause unrelated lineages to evolve similar structures, while neutral or near-neutral DNA changes accumulate more consistently with time independent of selective pressure on visible traits.',
     'Species 1 and 4 likely evolved similar limb structures independently through convergent evolution (analogous, not homologous, structures) due to similar environments. Molecular data are generally more reliable for distant relationships because morphology is more prone to convergent evolution under similar selective pressures.',
     '["convergent evolution explains conflict", "analogous vs homologous structures", "molecular data more reliable for distant relationships", "morphology subject to selective pressure/convergence"]'::jsonb)
  on conflict (content_item_version_id, criterion_key) do nothing;
  v_ci_id := null; v_civ_id := null;

end $$;
