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

  -- L-039: Hardy-Weinberg with selection (peppered-moth-style)
  insert into app.content_items (exam_pack_version_id, content_key, item_type, frq_form, title, status)
  values (v_epv_id, 'APBIO-FRQ-L-039', 'frq', 'long', 'APBIO-FRQ-L-039', 'draft')
  on conflict (exam_pack_version_id, content_key) do nothing returning id into v_ci_id;
  if v_ci_id is null then select id into v_ci_id from app.content_items
    where exam_pack_version_id = v_epv_id and content_key = 'APBIO-FRQ-L-039'; end if;

  insert into app.content_item_versions (content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status)
  values (v_ci_id, 1,
    'Answer all parts of the following question.

(a) Using the Year 1 data, calculate the allele frequencies of the dark-colored allele (D) and the light-colored allele (d) in the moth population, assuming Hardy-Weinberg proportions and that dark color is dominant. Show your work.

(b) Calculate the expected number of dark and light moths in Year 1 if the population were in Hardy-Weinberg equilibrium, and compare this to the observed numbers. State whether the population appears to be in Hardy-Weinberg equilibrium in Year 1.

(c) Industrial pollution darkens tree bark over the next 20 years, and bird predation increasingly favors dark moths through camouflage. Using the Year 20 data, calculate the new allele frequencies and explain, in terms of natural selection and relative fitness, why the allele frequencies changed in this direction.

(d) Identify and explain one additional piece of evidence (other than allele frequency change alone) a researcher could collect to confirm that natural selection, rather than genetic drift, caused the shift in allele frequencies between Year 1 and Year 20.',
    'A population of peppered moths is sampled in Year 1 and again in Year 20 after a nearby factory began emitting soot that darkened tree bark. Light coloration is recessive (genotype dd); dark coloration is dominant (DD or Dd). Population size both years: 1,000 moths.

Year 1: 160 light-colored moths observed, 840 dark-colored moths observed.
Year 20: 40 light-colored moths observed, 960 dark-colored moths observed.',
    '{"modules":["7"],"frq_type":"long","subtopics":["7.2 Natural Selection","7.4 Population Genetics","7.5 Hardy-Weinberg"],"total_points":10}'::jsonb,
    md5('APBIO-FRQ-L-039'), 'draft')
  on conflict (content_item_id, version_num) do nothing returning id into v_civ_id;
  if v_civ_id is null then select id into v_civ_id from app.content_item_versions
    where content_item_id = v_ci_id and version_num = 1; end if;

  insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants) values
    (v_civ_id, 'a',
     'Calculate Year 1 allele frequencies using Hardy-Weinberg.',
     2,
     'q^2 = 160/1000 = 0.16, so q = 0.4 (frequency of d). p = 1 - 0.4 = 0.6 (frequency of D).',
     'q (d allele) = sqrt(0.16) = 0.4; p (D allele) = 1 - 0.4 = 0.6.',
     '["q=0.4, p=0.6", "q^2=0.16 gives q=0.4", "allele frequencies 0.6 and 0.4"]'::jsonb),
    (v_civ_id, 'b',
     'Calculate expected genotype counts under HWE and compare to observed; state whether population is in equilibrium.',
     2,
     'Expected: p^2 (DD) = 0.36 x 1000 = 360; 2pq (Dd) = 2(0.6)(0.4) x 1000 = 480; q^2 (dd) = 0.16 x 1000 = 160. Expected dark (DD+Dd) = 360+480 = 840; expected light (dd) = 160. These match the observed values (840 dark, 160 light) exactly, so the population appears to be in Hardy-Weinberg equilibrium in Year 1.',
     'Expected dark = 840, expected light = 160 under HWE, matching the observed Year 1 counts exactly, so the population is in Hardy-Weinberg equilibrium in Year 1.',
     '["expected matches observed", "840 dark and 160 light expected", "population in HWE in Year 1"]'::jsonb),
    (v_civ_id, 'c',
     'Calculate Year 20 allele frequencies and explain the shift using natural selection and relative fitness.',
     2,
     'Year 20: q^2 = 40/1000 = 0.04, so q = 0.2 (d allele); p = 1 - 0.2 = 0.8 (D allele). The d allele frequency decreased (0.4 to 0.2) and D increased (0.6 to 0.8) because darker tree bark (from pollution) made light-colored moths more visible to bird predators (lower camouflage), reducing their survival and reproduction (lower relative fitness), while dark moths were better camouflaged and had higher relative fitness/survival; over generations, more D alleles than d alleles were passed to offspring, shifting the population allele frequencies toward D.',
     'Year 20: q = sqrt(0.04) = 0.2, p = 0.8. The d allele decreased because darker bark made light moths easier for birds to spot and eat (lower fitness), so dark moths (with allele D) survived and reproduced more, increasing D frequency over time.',
     '["q=0.2, p=0.8 in Year 20", "dark moths better camouflaged on dark bark", "light moths have lower relative fitness", "differential survival drives allele frequency change"]'::jsonb),
    (v_civ_id, 'd',
     'Propose additional evidence to confirm selection rather than drift caused the shift.',
     2,
     'Any reasonable proposal, e.g.: directly measure bird predation rates on light vs. dark moths placed on dark tree bark (mark-recapture or direct observation) — a significant difference in survival/predation rate between morphs would support selection (not drift, which would not produce a consistent directional, environmentally-linked difference); or compare allele frequency shifts across multiple independent populations exposed to the same pollution — if all show the same directional shift, this is inconsistent with drift (which is random and would not be expected to act consistently in the same direction across independent populations) and supports selection.',
     'Directly measure predation/survival rates of light vs. dark moths on darkened bark; a consistent survival difference favoring dark moths (or a consistent directional shift across multiple independent populations) would support selection rather than the random, non-directional pattern expected from genetic drift.',
     '["measure predation rates directly", "compare multiple independent populations", "drift is random and non-directional", "consistent directional shift supports selection not drift"]'::jsonb)
  on conflict (content_item_version_id, criterion_key) do nothing;
  v_ci_id := null; v_civ_id := null;

  -- L-040: Predator-prey population dynamics
  insert into app.content_items (exam_pack_version_id, content_key, item_type, frq_form, title, status)
  values (v_epv_id, 'APBIO-FRQ-L-040', 'frq', 'long', 'APBIO-FRQ-L-040', 'draft')
  on conflict (exam_pack_version_id, content_key) do nothing returning id into v_ci_id;
  if v_ci_id is null then select id into v_ci_id from app.content_items
    where exam_pack_version_id = v_epv_id and content_key = 'APBIO-FRQ-L-040'; end if;

  insert into app.content_item_versions (content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status)
  values (v_ci_id, 1,
    'Answer all parts of the following question.

(a) Using the data, describe the relationship in timing between peaks in the hare population and peaks in the lynx population across the 16-year record.

(b) Explain, in terms of resource availability and predation pressure, why the lynx population peak consistently lags behind the hare population peak rather than occurring at the same time.

(c) Explain why the hare population declines sharply after each of its peaks, referencing both food resource limitation (bottom-up control) and predation (top-down control) as possible contributing causes, and describe an experiment (involving a predator exclosure) that could determine the relative importance of each cause.

(d) Predict what would happen to both population cycles over the following 20 years if the lynx were completely removed from the ecosystem (e.g., by hunting), and justify your prediction in terms of carrying capacity and resource limitation for hares.',
    'Wildlife biologists track snowshoe hare and Canada lynx population sizes (estimated number of individuals per 100 km^2) over a 16-year period in a boreal forest ecosystem.

Year | Hare population | Lynx population
1    | 20,000           | 2,000
3    | 80,000           | 3,500
5    | 25,000           | 6,500
7    | 60,000           | 2,000
9    | 90,000           | 3,000
11   | 30,000           | 7,000
13   | 65,000           | 2,500
15   | 85,000           | 3,200',
    '{"modules":["8"],"frq_type":"long","subtopics":["8.2 Population Ecology","8.3 Community Ecology and Interactions"],"total_points":10}'::jsonb,
    md5('APBIO-FRQ-L-040'), 'draft')
  on conflict (content_item_id, version_num) do nothing returning id into v_civ_id;
  if v_civ_id is null then select id into v_civ_id from app.content_item_versions
    where content_item_id = v_ci_id and version_num = 1; end if;

  insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants) values
    (v_civ_id, 'a',
     'Describe the timing relationship between hare and lynx population peaks.',
     2,
     'The lynx population peaks occur shortly after (lag behind) the hare population peaks; both populations cycle, with hare peaks at approximately years 3, 9, and 15, and lynx peaks following at approximately years 5, 11 (a lag of about 2 years).',
     'Lynx population peaks lag a few years behind hare population peaks; both populations cycle in a repeating pattern, with lynx tracking hare abundance with a delay.',
     '["lynx peaks lag behind hare peaks", "cyclical pattern", "about 2 year lag", "lynx tracks hare population with delay"]'::jsonb),
    (v_civ_id, 'b',
     'Explain why the lynx peak lags the hare peak using resource availability and predation pressure.',
     2,
     'As hare population grows, more food is available for lynx, supporting increased lynx survival and reproduction; however, it takes time for this increased food supply to translate into more lynx offspring surviving to reproductive age, so the lynx population increase trails behind the hare increase. The growing lynx population then increases predation pressure on hares (more lynx eating hares), which eventually drives the hare population down; with less prey available, lynx reproduction and survival decline some time later, causing the lynx population to also decline — producing the lag in both directions.',
     'Lynx population growth lags because it takes time for increased hare (food) availability to translate into more surviving lynx offspring; the time delay between cause (more food) and effect (more lynx) produces the lag in lynx peaks relative to hare peaks.',
     '["time delay between food availability and lynx reproduction", "lynx population responds to hare abundance with delay", "increased predation eventually reduces hare population", "lagged numerical response"]'::jsonb),
    (v_civ_id, 'c',
     'Explain the post-peak hare decline using bottom-up and top-down control, and propose an exclosure experiment.',
     2,
     'Bottom-up: as hare population grows near its peak, food resources (vegetation) become depleted/overgrazed, reducing food availability per hare, which can lower hare survival/reproduction and contribute to population decline. Top-down: increased lynx (and other predator) numbers, which grew in response to the high hare population, increase predation pressure, directly removing more hares from the population and contributing to the decline. Experiment: set up predator-exclosure plots (fenced areas that exclude lynx and other predators but allow hares in) alongside open control plots; compare hare population decline rates inside vs. outside the exclosures — if hares decline similarly in both treatments, food limitation (bottom-up) is likely the dominant cause; if hares decline much less inside the exclosure (where predation is removed), predation (top-down) is the dominant cause.',
     'Both food limitation (overgrazed vegetation reduces survival) and increased predation from the growing lynx population contribute to hare decline. A predator-exclosure experiment, comparing hare decline in fenced (predator-free) vs. open plots, could separate the two effects: similar decline in both = bottom-up driven; much less decline in exclosure = top-down driven.',
     '["bottom-up: food/vegetation depletion", "top-down: increased predation", "predator exclosure experiment", "compare hare decline with and without predators"]'::jsonb),
    (v_civ_id, 'd',
     'Predict the effect of removing lynx on both population cycles and justify using carrying capacity.',
     2,
     'Without lynx, the major top-down control on the hare population would be removed; the hare population would likely grow largely unchecked by predation until it is limited primarily by food availability (bottom-up control / carrying capacity of the vegetation), so the hare population would rise to and then fluctuate near a higher, more food-limited carrying capacity rather than showing the same sharp boom-bust cycles tied to lynx predation. The cyclical, lagged pattern between hare and lynx would disappear since lynx are no longer present to drive the cycle; hare numbers would likely still fluctuate somewhat due to food resource cycles (vegetation regrowth) but without the predator-driven oscillation.',
     'Without lynx predation, hares would grow until limited mainly by food resources (their carrying capacity), likely stabilizing or fluctuating at a higher level than before, and the predator-prey cycling pattern would disappear since lynx are no longer regulating hare numbers.',
     '["hares no longer regulated by predation", "hares limited by food carrying capacity instead", "cycling pattern disappears without lynx", "hare population may stabilize at higher level"]'::jsonb)
  on conflict (content_item_version_id, criterion_key) do nothing;
  v_ci_id := null; v_civ_id := null;

  -- L-041: Community ecology / succession and diversity index
  insert into app.content_items (exam_pack_version_id, content_key, item_type, frq_form, title, status)
  values (v_epv_id, 'APBIO-FRQ-L-041', 'frq', 'long', 'APBIO-FRQ-L-041', 'draft')
  on conflict (exam_pack_version_id, content_key) do nothing returning id into v_ci_id;
  if v_ci_id is null then select id into v_ci_id from app.content_items
    where exam_pack_version_id = v_epv_id and content_key = 'APBIO-FRQ-L-041'; end if;

  insert into app.content_item_versions (content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status)
  values (v_ci_id, 1,
    'Answer all parts of the following question.

(a) Using the species richness and total individual counts in the table, calculate the Simpson''s Diversity Index (D = 1 - sum of (ni/N)^2) for Plot A (5 years post-fire) and Plot C (50 years post-fire). Show your work for at least one plot.

(b) Describe the overall trend in species diversity across the chronosequence from Plot A to Plot C, and explain this trend in terms of ecological succession.

(c) Explain why species richness alone (the simple count of species) can be a misleading measure of diversity compared to an index like Simpson''s, using the data provided to illustrate your point.

(d) Propose a mechanism (other than simply more time passing) that explains why early-successional plots are typically dominated by a small number of fast-growing species, and explain why these species are eventually replaced by a more diverse community in later succession.',
    'Ecologists sample three plots of forest at different times since a wildfire (a fire chronosequence) and record the number of individuals of each plant species present in a standardized survey area.

Plot A (5 years post-fire): Species 1 = 85 individuals, Species 2 = 10 individuals, Species 3 = 5 individuals. Total N = 100, richness = 3 species.

Plot B (20 years post-fire): Species 1 = 30, Species 2 = 25, Species 3 = 20, Species 4 = 15, Species 5 = 10. Total N = 100, richness = 5 species.

Plot C (50 years post-fire): Species 1 = 15, Species 2 = 14, Species 3 = 13, Species 4 = 12, Species 5 = 12, Species 6 = 11, Species 7 = 11, Species 8 = 12. Total N = 100, richness = 8 species.',
    '{"modules":["8"],"frq_type":"long","subtopics":["8.4 Ecological Succession","8.1 Biodiversity"],"total_points":10}'::jsonb,
    md5('APBIO-FRQ-L-041'), 'draft')
  on conflict (content_item_id, version_num) do nothing returning id into v_civ_id;
  if v_civ_id is null then select id into v_civ_id from app.content_item_versions
    where content_item_id = v_ci_id and version_num = 1; end if;

  insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants) values
    (v_civ_id, 'a',
     'Calculate Simpson''s Diversity Index for at least one plot.',
     2,
     'Plot A: sum(ni/N)^2 = (85/100)^2 + (10/100)^2 + (5/100)^2 = 0.7225 + 0.01 + 0.0025 = 0.735. D = 1 - 0.735 = 0.265. Plot C: sum(ni/N)^2 = (0.15^2+0.14^2+0.13^2+0.12^2+0.12^2+0.11^2+0.11^2+0.12^2) = 0.0225+0.0196+0.0169+0.0144+0.0144+0.0121+0.0121+0.0144 = 0.1264. D = 1 - 0.1264 = 0.8736. Accept correct calculation and formula application for at least one plot with correct work shown.',
     'Plot A: D = 1 - [(0.85)^2+(0.10)^2+(0.05)^2] = 1 - 0.735 = 0.265. Plot C: D = 1 - 0.1264 = 0.874 (approximately).',
     '["Plot A D approximately 0.265", "Plot C D approximately 0.87", "correctly applies Simpsons formula"]'::jsonb),
    (v_civ_id, 'b',
     'Describe the trend in diversity from Plot A to Plot C and explain via succession.',
     2,
     'Diversity (both species richness and Simpson''s Index) increases from Plot A to Plot C as time since the fire increases. This reflects ecological succession: early-successional communities are typically dominated by a few fast-colonizing, fast-growing pioneer species (low diversity); over time, as soil, shade, and microhabitat conditions develop and pioneer species modify the environment, more species are able to colonize and coexist, leading to a more even, diverse community in later succession.',
     'Diversity increases over time from Plot A to Plot C, consistent with ecological succession: early pioneer species dominate right after disturbance, while more species accumulate and coexist as the community matures over decades.',
     '["diversity increases with time since fire", "succession explains the pattern", "pioneer species dominate early", "more species coexist later in succession"]'::jsonb),
    (v_civ_id, 'c',
     'Explain why species richness alone can be misleading, using the data.',
     2,
     'Species richness only counts the number of species present, ignoring how evenly individuals are distributed among them. For example, if Plot A had close to even distribution rather than the actual heavily skewed one (85/10/5), it would still report the same richness (3 species) but would be far more diverse in a functional sense. Simpson''s Index accounts for both richness AND evenness, giving a more complete picture; the data show Plot A is dominated by Species 1 (85%), so although it has 3 species, the community functions much like a near-monoculture, which a simple richness count of 3 would not reveal.',
     'Richness alone ignores evenness — a plot could have several species but be dominated by one (as in Plot A, where Species 1 makes up 85% of individuals), which richness counts the same as an evenly distributed community; Simpson''s Index captures this difference because it accounts for relative abundance, not just species count.',
     '["richness ignores evenness", "Plot A is dominated by one species despite having 3 species", "Simpsons accounts for relative abundance", "two communities with same richness can have very different diversity"]'::jsonb),
    (v_civ_id, 'd',
     'Propose a mechanism for early dominance by few species and explain later replacement.',
     2,
     'Early-successional environments (e.g., bare, recently burned soil) favor species with traits like rapid growth, high seed production/dispersal, and tolerance of high light and disturbed soil (r-selected, pioneer traits) — these species can quickly colonize and monopolize the open space and resources, outcompeting slower-growing species initially. Over time, pioneer species alter the environment (adding organic matter, creating shade, changing soil structure) in ways that reduce conditions favorable to themselves but create niches suitable for a wider range of species (including slower-growing, more shade-tolerant species), allowing those species to establish and increasing diversity — and eventually pioneer species may be outcompeted and replaced as conditions change (facilitation/competition model of succession).',
     'Pioneer species have traits (fast growth, high dispersal, disturbance tolerance) that let them colonize quickly and dominate bare, post-fire ground. As they grow, they change the environment (more shade, richer soil), creating conditions that allow more species to establish, increasing diversity over time and eventually displacing some pioneers.',
     '["pioneer species traits: fast growth, high dispersal, disturbance tolerance", "pioneers modify environment", "facilitation allows later species to establish", "increasing diversity over successional time"]'::jsonb)
  on conflict (content_item_version_id, criterion_key) do nothing;
  v_ci_id := null; v_civ_id := null;

  -- L-042: Biogeochemical cycling (nitrogen cycle)
  insert into app.content_items (exam_pack_version_id, content_key, item_type, frq_form, title, status)
  values (v_epv_id, 'APBIO-FRQ-L-042', 'frq', 'long', 'APBIO-FRQ-L-042', 'draft')
  on conflict (exam_pack_version_id, content_key) do nothing returning id into v_ci_id;
  if v_ci_id is null then select id into v_ci_id from app.content_items
    where exam_pack_version_id = v_epv_id and content_key = 'APBIO-FRQ-L-042'; end if;

  insert into app.content_item_versions (content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status)
  values (v_ci_id, 1,
    'Answer all parts of the following question.

(a) Using the data, identify which plot (Fertilized or Control) had higher soil nitrate (NO3-) concentration and higher nitrous oxide (N2O) emissions, and explain the biological process most directly responsible for the elevated N2O emissions in that plot.

(b) Explain the role of nitrogen-fixing bacteria in making atmospheric N2 available to plants, including the chemical conversion they perform and why this process is necessary given that plants cannot directly use atmospheric N2.

(c) Explain the process of nitrification, including the two bacterial conversions involved, and explain why nitrification increases the risk of nitrogen loss from the soil through leaching, using the relative solubility/charge of the molecules involved.

(d) Propose a land-management practice that could reduce N2O emissions and nitrate leaching from the fertilized plot while still maintaining adequate nitrogen availability for crop growth, and explain the biological or chemical reasoning behind why your proposed practice would work.',
    'Agricultural researchers compare a heavily fertilized crop field to an adjacent unfertilized control field, measuring soil nitrate concentration and nitrous oxide (N2O) gas emissions (a byproduct of denitrification) over one growing season.

Plot       | Soil nitrate (mg/kg) | N2O emissions (kg N/hectare/season)
Control    | 8                    | 0.5
Fertilized | 65                   | 4.8',
    '{"modules":["8"],"frq_type":"long","subtopics":["8.7 Biogeochemical Cycles","8.8 Nitrogen Cycle"],"total_points":10}'::jsonb,
    md5('APBIO-FRQ-L-042'), 'draft')
  on conflict (content_item_id, version_num) do nothing returning id into v_civ_id;
  if v_civ_id is null then select id into v_civ_id from app.content_item_versions
    where content_item_id = v_ci_id and version_num = 1; end if;

  insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants) values
    (v_civ_id, 'a',
     'Identify which plot has higher nitrate and N2O, and explain the process responsible for elevated N2O.',
     2,
     'The Fertilized plot has both higher soil nitrate (65 vs 8 mg/kg) and higher N2O emissions (4.8 vs 0.5 kg N/hectare/season). The elevated N2O is most directly the result of denitrification, a process performed by soil bacteria that convert nitrate (NO3-) back into nitrogen gases (including N2O and N2), especially under anaerobic/low-oxygen soil conditions; the larger nitrate pool in the fertilized plot provides more substrate for denitrifying bacteria, increasing N2O production.',
     'Fertilized plot has higher nitrate and higher N2O emissions; denitrification (bacterial conversion of nitrate back to N2O/N2 gas) is responsible, and more nitrate substrate in the fertilized plot drives more denitrification.',
     '["fertilized plot higher in both nitrate and N2O", "denitrification converts nitrate to N2O", "more nitrate substrate increases denitrification rate"]'::jsonb),
    (v_civ_id, 'b',
     'Explain the role of nitrogen-fixing bacteria and why fixation is necessary.',
     2,
     'Nitrogen-fixing bacteria (e.g., Rhizobium in root nodules, or free-living soil bacteria) convert atmospheric nitrogen gas (N2), which is chemically inert due to its strong triple bond, into ammonia (NH3) or ammonium (NH4+) through the enzyme nitrogenase; this is necessary because plants lack the enzymes needed to break the strong N≡N triple bond and cannot use N2 gas directly, so nitrogen must first be "fixed" into a chemically reactive, plant-usable form (ammonium, and later nitrate via nitrification) before it can be absorbed by roots and incorporated into amino acids and nucleic acids.',
     'Nitrogen-fixing bacteria convert inert atmospheric N2 into ammonia/ammonium using the enzyme nitrogenase; this is necessary because plants cannot break the strong triple bond in N2 and can only take up nitrogen in fixed forms like ammonium or nitrate.',
     '["nitrogen-fixing bacteria convert N2 to ammonia/ammonium", "nitrogenase enzyme", "plants cannot use N2 directly", "triple bond makes N2 inert"]'::jsonb),
    (v_civ_id, 'c',
     'Explain nitrification and why it increases leaching risk.',
     2,
     'Nitrification is a two-step process performed by soil bacteria: first, ammonia/ammonium (NH3/NH4+) is oxidized to nitrite (NO2-) by bacteria such as Nitrosomonas; second, nitrite is oxidized to nitrate (NO3-) by bacteria such as Nitrobacter. This increases leaching risk because nitrate (NO3-) is negatively charged and does not bind well to negatively charged soil clay/organic particles (unlike positively charged ammonium, which is electrostatically attracted to and held by soil particles), so nitrate remains dissolved in soil water and is easily washed (leached) downward out of the root zone and into groundwater.',
     'Nitrification converts ammonium to nitrite (by Nitrosomonas) then nitrate (by Nitrobacter). Nitrate is negatively charged and is not held by negatively charged soil particles like ammonium is, so it stays dissolved in soil water and leaches away easily.',
     '["ammonium to nitrite to nitrate", "Nitrosomonas and Nitrobacter", "nitrate is negatively charged and not retained by soil", "ammonium binds to soil particles but nitrate does not"]'::jsonb),
    (v_civ_id, 'd',
     'Propose a management practice to reduce N2O and leaching while maintaining nitrogen availability, with reasoning.',
     2,
     'Any reasonable proposal with correct mechanism, e.g.: split fertilizer application into smaller doses applied at multiple times matched to crop uptake (rather than one large application) — this keeps soil nitrate concentrations lower at any given time, reducing both the substrate available for denitrification (lowering N2O) and the excess nitrate available to leach, while still supplying enough nitrogen overall for the crop across the growing season. Alternative: use slow-release fertilizer or nitrification inhibitors that slow the conversion of ammonium to nitrate, keeping more nitrogen in the less mobile, less denitrification-prone ammonium form for longer.',
     'Apply fertilizer in smaller, split doses timed to crop nitrogen demand rather than one large application; this keeps soil nitrate levels lower at any time, reducing the substrate available for denitrification (less N2O) and for leaching, while still meeting the crop''s total seasonal nitrogen need.',
     '["split/timed fertilizer application", "reduces excess nitrate available for denitrification or leaching", "matches nitrogen supply to crop uptake", "slow-release fertilizer or nitrification inhibitor"]'::jsonb)
  on conflict (content_item_version_id, criterion_key) do nothing;
  v_ci_id := null; v_civ_id := null;

end $$;
