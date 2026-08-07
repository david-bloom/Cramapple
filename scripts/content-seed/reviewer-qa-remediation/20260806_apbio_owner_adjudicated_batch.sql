-- AP Biology owner-adjudicated remediation batch, 2026-08-06.
--
-- Covers 5 MCQs and 4 FRQs adjudicated via two fresh independent QA passes
-- (Adil Abbasi's 4 disapprovals CED-check; APBIO-MCQ-008/011/014/016/026
-- adjudication). Each item gets a new draft version (never edits a version
-- already exposed to a reviewer decision in place), retires the old
-- version, records an owner_remediation_approval decision, and lands at
-- 'reviewed_approved' -- publishing is a separate, later action except
-- where noted the item was already live and the fix corrects it in place.
--
-- MCQ-008: stimulus gave away the answer verbatim; distractor A was
--   non-functional (gravity irrelevant at cellular scale). Trimmed stimulus,
--   replaced A with a functional misconception, trimmed B's rationale of
--   out-of-depth "hydrophobic effect" terminology, retagged 1.4->1.7.
-- MCQ-011: Sarah's "not AP aligned" was wrong -- RNA world IS in CED
--   (EK 7.12.A.2); Adil's fix was right: replace Km/kcat kinetics (out of
--   scope, CED enzyme treatment is qualitative) with plain-language rate
--   comparison, trim the 3x-long key D, retag to 7.12, downgrade difficulty.
-- MCQ-014: length/completeness cue -- key C was the only option not
--   self-refuted by the stimulus AND the longest. Shortened C.
-- MCQ-016: v2 fixed the factual defect (0.9% NaCl isotonic-to-cytoplasm
--   claim); replaced remaining eliminable distractor C with a live
--   misconception and retagged 2.5->2.7.
-- MCQ-026: v2 fixed the off-CED paracrine/autocrine vocabulary; glossed the
--   remaining non-CED term "synaptic" in the keyed option.
-- FRQ-L-016: v2 fixed the stimulus/stem/rubric mismatch, but Part A still
--   required naming enzymes (pyruvate decarboxylase, alcohol dehydrogenase,
--   LDH), which LO 3.5.A/3.5.B exclude. Dropped the enzyme-identification
--   requirement from the stem and the graded evidence requirements.
-- FRQ-L-026: v2 fixed the stem, but canonical_answer_1 and the graded
--   evidence_requirements/minimum_fix were never updated and still scored
--   students on off-CED Ne, minimum viable population, the purging
--   hypothesis, and MHC-allele counts that do not even appear in the
--   stimulus table. Rewrote (a)-(d) to match what the fixed stem actually
--   asks, using only in-CED bottleneck/drift/inbreeding-depression content.
-- FRQ-L-030: same defect -- stem was fixed to ask about carrying capacity
--   and fragmentation-driven drift/bottleneck/inbreeding, but the rubric
--   still graded island-biogeography species-area math, SLOSS, and
--   corridors that the fixed stem no longer asks about. Rewrote (a) and (b)
--   to match; trimmed leftover "island biogeography"/"metapopation" jargon
--   from (c)/(d) while keeping their substantively-correct content.
-- FRQ-L-036: still at v1, unfixed. Relabeled trp-operon/tryptophan language
--   to the lac operon/allolactose (the data show induction, i.e. activity
--   rising with inducer -- trp is a repressible/corepressor system and
--   cannot produce this pattern; lac's inducible mechanism matches exactly).
--   Fixed Part C's backwards phrasing ("interacts with the repressor to
--   allow operator binding" -> "to cause its release from the operator").
--   Fixed the μM/mM unit mismatch between Part A and the data table (now
--   0/0.1/1.0/10.0 mM throughout). Remapped the rubric, which was mapped in
--   reverse (criterion a<->d, b<->c) relative to the stem parts it actually
--   answers.
--
-- Owner instructions, 2026-08-06 (chat): "execute the Biology fixes."

begin;
select pg_advisory_xact_lock(hashtext('cramapple-apbio-owner-adjudicated-batch-20260806'));

create temporary table repair_targets (
  content_key text primary key,
  item_type text not null
) on commit drop;

insert into repair_targets values
('APBIO-MCQ-008','mcq'),
('APBIO-MCQ-011','mcq'),
('APBIO-MCQ-014','mcq'),
('APBIO-MCQ-016','mcq'),
('APBIO-MCQ-026','mcq'),
('APBIO-FRQ-L-016','frq'),
('APBIO-FRQ-L-026','frq'),
('APBIO-FRQ-L-030','frq'),
('APBIO-FRQ-L-036','frq');

create temporary table criterion_key_remap (
  content_key text not null,
  old_key text not null,
  new_key text not null
) on commit drop;

insert into criterion_key_remap values
('APBIO-FRQ-L-036','a','d'),
('APBIO-FRQ-L-036','b','c'),
('APBIO-FRQ-L-036','c','b'),
('APBIO-FRQ-L-036','d','a');

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
        'qa_remediation','2026-08-06 AP Biology owner-adjudicated batch'
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
      select v_new,
        coalesce(remap.new_key, fc.criterion_key),
        fc.learner_facing_text,fc.points_possible,
        fc.evidence_requirements,fc.minimum_fix,fc.accepted_variants
      from app.frq_criteria fc
      left join criterion_key_remap remap
        on remap.content_key=t.content_key and remap.old_key=fc.criterion_key
      where fc.content_item_version_id=v_old.id;
    end if;

    insert into repaired values (t.content_key,v_old.id,v_new);
  end loop;
end $$;

-- ===== MCQ-008 =====
update app.content_item_versions civ
set stimulus = replace(stimulus, ' Structural studies show that deoxygenated HbS exposes a hydrophobic patch on its surface that complementarily fits a hydrophobic pocket on adjacent HbS molecules.', ''),
    prompt_json = jsonb_set(prompt_json, '{subtopics}', '["1.7 Proteins"]'::jsonb)
from repaired r where r.content_key='APBIO-MCQ-008' and civ.id=r.new_version_id;

update app.mcq_choices m
set choice_text='Valine''s smaller side chain leaves a gap that destabilizes β-globin''s alpha-helix, unfolding HbS into fibers',
    rationale='Incorrect. The Glu6Val substitution does not disrupt β-globin''s secondary structure -- HbS folds normally into the same alpha-helical/quaternary structure as HbA. Polymerization occurs through an intact fold''s surface chemistry, not helix unfolding.'
from repaired r where r.content_key='APBIO-MCQ-008' and m.content_item_version_id=r.new_version_id and m.choice_key='A';

update app.mcq_choices m
set rationale='Deoxygenation causes a conformational change in HbS that exposes a hydrophobic pocket. Valine''s nonpolar side chain associates with this pocket rather than contacting water, promoting chain formation. HbA''s glutamic acid at position 6 is charged and cannot insert into this hydrophobic pocket.'
from repaired r where r.content_key='APBIO-MCQ-008' and m.content_item_version_id=r.new_version_id and m.choice_key='B';

-- ===== MCQ-011 =====
update app.content_item_versions civ
set stimulus = replace(
    stimulus,
    'kinetic data for a self-replicating ribozyme: Km = 0.8 mM (similar to protein enzymes), kcat = 0.003 s⁻¹ (≈10,000× lower than typical protein enzymes), with 50-fold kcat enhancement upon adding Mg²⁺.',
    'a self-replicating ribozyme catalyzes its reaction roughly 10,000× more slowly than a typical protein enzyme, and its rate increases about 50-fold when Mg²⁺ is added.'
  ),
  prompt_json = (prompt_json - 'subtopics') || jsonb_build_object('subtopics','["7.12 Origins of Life on Earth"]'::jsonb, 'intended_difficulty','Hard')
from repaired r where r.content_key='APBIO-MCQ-011' and civ.id=r.new_version_id;

update app.mcq_choices m
set choice_text='RNA likely served as both the informational and catalytic molecule before proteins; proteins later took over most catalysis because they are faster, while RNA''s catalytic role in translation was retained',
    rationale='Ribozymes can self-replicate (information + catalysis combined), and RNA''s catalytic role in translation (the ribosome) was conserved even after protein enzymes evolved. Proteins superseded RNA catalytically because they are far faster, while Mg²⁺-assisted RNA catalysis was sufficient in pre-biotic conditions.'
from repaired r where r.content_key='APBIO-MCQ-011' and m.content_item_version_id=r.new_version_id and m.choice_key='D';

-- ===== MCQ-014 =====
update app.mcq_choices m
set choice_text='Cell 1 is prokaryotic and Cell 2 is eukaryotic.'
from repaired r where r.content_key='APBIO-MCQ-014' and m.content_item_version_id=r.new_version_id and m.choice_key='C';

-- ===== MCQ-016 =====
update app.content_item_versions civ
set prompt_json = jsonb_set(prompt_json, '{subtopics}', '["2.7 Tonicity and Osmoregulation"]'::jsonb)
from repaired r where r.content_key='APBIO-MCQ-016' and civ.id=r.new_version_id;

update app.mcq_choices m
set choice_text='Water enters until the cytoplasm becomes isotonic with the surrounding water, at which point net movement stops and the cell stays intact.',
    rationale='Incorrect. Net water movement stops when rising turgor pressure counteracts the osmotic gradient, not when the cytoplasm becomes isotonic with distilled water -- true isotonicity with distilled water is never reached in an intact walled cell.'
from repaired r where r.content_key='APBIO-MCQ-016' and m.content_item_version_id=r.new_version_id and m.choice_key='C';

-- ===== MCQ-026 =====
update app.mcq_choices m
set choice_text='Insulin = endocrine; prostaglandin = local signaling; acetylcholine = synaptic (short-distance) signaling'
from repaired r where r.content_key='APBIO-MCQ-026' and m.content_item_version_id=r.new_version_id and m.choice_key='A';

-- ===== FRQ-L-016: drop enzyme-identification requirement (LO 3.5.A/3.5.B exclusion) =====
update app.content_item_versions civ
set stem = replace(
  stem,
  'Part A: Compare alcoholic fermentation and lactic acid fermentation. Identify the enzyme used in each pathway and explain the metabolic purpose both pathways share.',
  'Part A: Compare alcoholic fermentation and lactic acid fermentation, and explain the metabolic purpose both pathways share.'
)
from repaired r where r.content_key='APBIO-FRQ-L-016' and civ.id=r.new_version_id;

update app.frq_criteria fc
set learner_facing_text='Describe alcoholic and lactic acid fermentation pathways and explain the metabolic purpose they share.',
    evidence_requirements='(i) Alcoholic fermentation (yeast): glucose -> 2 pyruvate -> 2 acetaldehyde + 2 CO2 -> 2 ethanol + 2 NAD+; net C6H12O6 -> 2 C2H5OH + 2 CO2 + 2 ATP; CO2 is a byproduct. (ii) Lactic acid fermentation (exercising muscle): glucose -> 2 pyruvate -> 2 lactate + 2 NAD+; net C6H12O6 -> 2 C3H6O3 + 2 ATP; no CO2 produced; lactate can be exported to the liver (Cori cycle). Purpose shared by both pathways: regenerate NAD+ from NADH so glycolysis can continue producing ATP anaerobically -- not to make lactate/ethanol as an end in itself. 1 pt for correct pathway/products for both types; 1 pt for correctly stating the shared metabolic purpose as NAD+ regeneration.',
    minimum_fix='Alcoholic: pyruvate -> acetaldehyde + CO2 -> ethanol + NAD+. Lactic acid: pyruvate -> lactate + NAD+. Purpose of both: regenerate NAD+ to allow glycolysis to continue producing ATP without O2.'
from repaired r where r.content_key='APBIO-FRQ-L-016' and fc.content_item_version_id=r.new_version_id and fc.criterion_key='a';

-- ===== FRQ-L-026: rewrite canonical_answer_1 and evidence_requirements/minimum_fix to drop
-- off-CED Ne / minimum viable population / purging hypothesis / MHC (the last of which is not
-- even present in the stimulus table) and match what the already-fixed stem actually asks. =====
update app.content_item_versions civ
set canonical_answer_1 =
'(a)(i) A bottleneck is a sudden, drastic reduction in population size that leaves only a small, random subset of the original gene pool; which alleles survive is a matter of chance, unrelated to their fitness effects, so rare alleles are often lost regardless of whether they were helpful, harmful, or neutral. Natural selection instead changes allele frequencies in a consistent, fitness-driven direction: alleles that improve survival/reproduction become more common and alleles that reduce fitness become less common. A bottleneck reduces diversity non-directionally; selection changes frequencies directionally based on adaptive value.
(a)(ii) That cheetahs can accept skin grafts from virtually any unrelated cheetah shows they are genetically extremely similar to one another -- the self-recognition proteins on their cells are nearly identical across the population, so the immune system does not detect transplanted tissue as foreign. This is the signature of a population that lost most of its genetic variation in a severe bottleneck; a genetically diverse population would reject grafts between unrelated individuals.
(a)(iii) Genetic diversity is set by how many different alleles were present among the individuals who actually contributed offspring, which for the elephant seals was capped at roughly 20 survivors during the bottleneck. Regaining numbers afterward does not add back alleles that were already lost -- diversity can only be recovered slowly, through new mutation accumulating over many generations, not simply by the population growing larger. The modern population, despite its size, still carries only the reduced genetic variation of the ~20 individuals that founded its recovery.

(b)(i) Inbreeding increases the chance that an offspring inherits two identical copies of the same allele (one from each related parent), raising homozygosity across the genome. Most seriously harmful alleles are recessive and normally masked in heterozygotes; increased homozygosity exposes these recessive deleterious alleles in the phenotype, lowering fitness (survival, fertility) -- this is inbreeding depression.
(b)(ii) Population B has much lower mean heterozygosity (0.01 vs. 0.04) and lower allelic richness (1.8 vs. 3.2 alleles/locus) than Population A, along with far higher rates of kinked tails (85% vs. 50%) and cryptic testes (90% vs. 55%). This pattern indicates Population B has undergone substantially more inbreeding. Predicted consequences: reduced male fertility (cryptic testes impair sperm production), possible impaired mobility from the tail defect, and lower overall reproductive success and offspring survival -- the expected signs of inbreeding depression.

(c)(i) Genetic rescue works by breeding in unrelated individuals carrying different alleles than the inbred population. Offspring of these crosses are heterozygous at many loci where residents were homozygous, so functional alleles from the immigrants mask the residents'' harmful recessive alleles, producing a fitness increase (heterosis/hybrid vigor) that offsets inbreeding depression.
(c)(ii) Two risks: (1) Outbreeding depression -- the introduced subspecies may carry alleles or trait combinations adapted to a different environment, so hybrid offspring may be less well-suited to Florida conditions than pure-bred residents. (2) Loss of local genetic distinctiveness ("genetic swamping") -- if introduced alleles spread widely, the unique genetic identity of the original Florida subspecies could be diluted or lost.
(c)(iii) Hybrid (puma x panther) offspring should show higher heterozygosity and higher cub survival than pure panther offspring, because the puma parent''s alleles mask homozygous deleterious recessive alleles inherited from the inbred panther lineage (heterosis). This matches the historical data: cub survival rose from 20% to 50% after the 1995 introduction.

(d)(i) Genetic diversity is the raw material selection needs to respond to change: when a new pathogen or environmental shift occurs, a genetically diverse population is more likely to already contain individuals whose alleles happen to confer resistance or tolerance, allowing selection to increase those alleles'' frequency so the population adapts. A population with very low genetic diversity has few alternative alleles available, so if the existing alleles are poorly suited to the new challenge, the population has little capacity to adapt and faces a much higher risk of decline.
(d)(ii) One additional risk of low genetic diversity: continued inbreeding depression -- with little variation left, most matings are effectively between genetically similar individuals, so harmful recessive alleles keep being exposed in homozygous offspring, suppressing fertility and survival even without any new environmental threat.'
from repaired r where r.content_key='APBIO-FRQ-L-026' and civ.id=r.new_version_id;

update app.frq_criteria fc
set evidence_requirements=case fc.criterion_key
  when 'a' then 'Bottleneck vs. selection: bottleneck randomly reduces diversity regardless of fitness; selection changes frequencies directionally by fitness. Cheetah skin grafts: near-identical self-recognition proteins from a severe bottleneck explain graft acceptance (no MHC terminology required). Elephant seal paradox: current diversity reflects the ~20 bottleneck survivors; regained census size does not restore lost alleles, only new mutation over generations does. 1 pt per two sub-points correctly explained.'
  when 'b' then 'Inbreeding depression mechanism: increased homozygosity from mating between relatives exposes recessive deleterious alleles, reducing fitness. Population B data: lower heterozygosity (0.01 vs 0.04), lower allelic richness (1.8 vs 3.2), higher kinked-tail (85% vs 50%) and cryptic-testes (90% vs 55%) frequencies indicate severe inbreeding; predicted consequences include reduced male fertility and lower reproductive success/offspring survival. Do not require MHC-allele-count claims -- the stimulus table supplies no such data.'
  when 'c' then 'Rescue mechanism: outbred immigrants raise heterozygosity, masking residents'' recessive deleterious alleles (heterosis). Two risks: (1) outbreeding depression (maladapted introduced alleles); (2) genetic swamping (loss of local genetic distinctiveness). Hybrid offspring prediction: higher heterozygosity, higher cub survival than pure offspring, consistent with the 20%->50% cub-survival data.'
  when 'd' then 'Explains that genetic diversity provides the raw material for selection to act on when a new pathogen or climate shift occurs, so low-diversity populations have little capacity to adapt. Describes one additional risk beyond disease/climate vulnerability -- continued inbreeding depression is the expected answer, but any well-reasoned genetic (not demographic-only) risk of low diversity should be credited.'
  end,
  minimum_fix=case fc.criterion_key
  when 'a' then 'Bottleneck = random loss of alleles regardless of fitness. Cheetah grafts: near-identical self-recognition proteins from a bottleneck. Elephant seals: diversity still reflects ~20 founders; census recovery alone does not restore it.'
  when 'b' then 'Inbreeding depression: homozygosity exposes recessive deleterious alleles. Population B: lower heterozygosity/allelic richness, higher defect frequencies -> predicted reduced fertility and reproductive success.'
  when 'c' then 'Rescue: outbred alleles mask residents'' recessive alleles (heterosis). Risks: outbreeding depression; genetic swamping. Hybrids: higher heterozygosity and cub survival than pure offspring.'
  when 'd' then 'Diversity = raw material for adaptation to new pathogens/climate. One more risk: continued inbreeding depression from residual low diversity.'
  end
from repaired r where r.content_key='APBIO-FRQ-L-026' and fc.content_item_version_id=r.new_version_id;

-- ===== FRQ-L-030: rewrite (a) and (b) to match the already-fixed carrying-capacity/
-- fragmentation stem; trim leftover island-biogeography/metapopulation jargon from (c)/(d). =====
update app.content_item_versions civ
set canonical_answer_1 =
'(a) A larger habitat area can support a larger population because it provides more food, space, and other resources -- this maximum sustainable population size is the habitat''s carrying capacity. A larger population retains more genetic diversity and is less vulnerable to genetic drift and stochastic extinction than a small one. If habitat area is halved, the resources available are roughly halved as well, so carrying capacity is expected to decrease correspondingly -- the population the habitat can sustain shrinks, which in turn increases the population''s vulnerability to genetic drift, inbreeding, and chance demographic/environmental events that can drive a small population extinct.

(b) Three ecological consequences of small, fragmented populations for long-term persistence: (1) Increased genetic drift -- in a small population, allele frequencies change substantially from generation to generation by chance alone, and rare alleles are easily lost, reducing genetic diversity faster than in a large population. (2) Bottleneck-like founder effects -- when a fragment supports only a small population, the diversity present is capped by however many individuals happen to be in that fragment, similar to a bottleneck, and that reduced diversity persists even if the fragment''s population later grows. (3) Increased inbreeding -- with fewer potential mates available within an isolated fragment, related individuals are more likely to breed with each other, increasing homozygosity and the expression of harmful recessive alleles (inbreeding depression). Together, these genetic and demographic effects make small fragmented populations more vulnerable to decline and local extinction than a single large, continuous population of the same total size.

(c) Patch A, connected by a corridor, keeps receiving individuals from Patch B: this maintains gene flow, preventing inbreeding and preserving heterozygosity, and allows the population to be replenished if it declines. Patch C, though the same size, is fully isolated, so no immigration can replenish or diversify it. With a small founding population and no gene flow, Patch C''s ferrets are especially vulnerable to genetic drift and inbreeding depression -- increased mating among relatives raises homozygosity of deleterious recessive alleles, reducing fertility, disease resistance, and offspring survival -- compounding demographic problems (such as vulnerability to a single disease outbreak) and driving the reintroduction to failure, exactly as the connected-versus-isolated comparison predicts.

(d)(i) Mountaintop habitats function like islands of suitable habitat surrounded by a climatically unsuitable lowland "sea." As climate warms, the montane climate zone a species needs shifts upslope, but because mountains taper toward their summit, the available habitat area shrinks as elevation increases -- so species are pushed into progressively smaller, more isolated patches, and eventually run out of mountain entirely with no higher ground left to colonize. Unlike lowland species, mountaintop species cannot simply shift latitude across a large, continuous landmass.
(d)(ii) As the suitable thermal zone shifts from 800-1200 m to 1000-1400 m, the lower portion of the current range (800-1000 m) becomes climatically unsuitable, causing increased mortality and reduced recruitment there, while newly suitable habitat opens up at 1200-1400 m. The population can only avoid net decline if individuals or seeds can disperse upslope into the new zone fast enough to track the shifting climate; if dispersal is too slow relative to the pace of warming, the population will suffer a net range contraction and increased extinction risk.
(d)(iii) Two climate-aware conservation strategies: (1) Establish or protect habitat corridors along elevational and latitudinal gradients so species can physically track shifting climate conditions over time. (2) Use assisted migration/translocation -- deliberately moving individuals or propagules beyond their natural dispersal range into newly climatically suitable habitat they could not reach on their own.'
from repaired r where r.content_key='APBIO-FRQ-L-030' and civ.id=r.new_version_id;

update app.frq_criteria fc
set evidence_requirements=case fc.criterion_key
  when 'a' then 'Larger habitat area -> more resources -> higher carrying capacity -> larger sustainable population -> more retained genetic diversity, lower drift/extinction vulnerability. Halving area is predicted to roughly halve available resources and correspondingly reduce carrying capacity, increasing vulnerability to drift and demographic/environmental stochasticity. No species-area equation is supplied or required.'
  when 'b' then 'Three genetic/demographic consequences of fragmentation, framed around drift and the bottleneck effect: (1) increased genetic drift in small fragment populations; (2) bottleneck-like founder effects capping diversity at whatever the fragment happens to hold; (3) increased inbreeding from a restricted local mate pool, causing inbreeding depression.'
  else fc.evidence_requirements
  end,
  minimum_fix=case fc.criterion_key
  when 'a' then 'Smaller area -> lower carrying capacity -> smaller population -> more drift/extinction risk. Halving area roughly halves carrying capacity.'
  when 'b' then 'Three effects: increased drift; bottleneck-like founder effect; increased inbreeding (inbreeding depression) in small fragments.'
  else fc.minimum_fix
  end
from repaired r where r.content_key='APBIO-FRQ-L-030' and fc.content_item_version_id=r.new_version_id;

-- ===== FRQ-L-036: relabel trp/tryptophan -> lac operon/allolactose, fix Part C's backwards
-- phrasing, fix the μM/mM unit mismatch, and reorder the model answer to match the rubric
-- remap already applied in the copy step above. =====
update app.content_item_versions civ
set stem =
'Answer all parts of the following question.

Part A: The lac operon in bacteria is repressed by default and is induced (turned on) when the inducer allolactose is present. Predict the activity pattern of a Strain 3 mutant (operator deletion) across a range of inducer concentrations (0 mM, 0.1 mM, 1.0 mM, 10.0 mM). Explain why your predictions differ from the wild-type strain.

Part B: In Strain 2, the repressor protein is mutated so that it cannot bind to the inducer molecule (allolactose). Evaluate whether the Strain 2 experimental data support this hypothesis. Discuss what this mutation would mean for the cell''s ability to regulate lactose-metabolizing gene expression in response to inducer availability.

Part C: Explain why the wild-type strain exhibits low reporter activity (low transcription) when inducer is absent and increased reporter activity when inducer is added. In your answer, describe the role of the repressor protein and explain how the inducer molecule interacts with the repressor to cause its release from the operator.

Part D: Describe how reporter activity changes across different inducer concentrations for the wild-type strain and explain what this dose-dependent response indicates about the sensitivity of the operon to inducer levels.',
canonical_answer_1 =
'(a) Strain 3 (operator deleted): predicted high reporter activity at ALL inducer concentrations, including 0 mM, because without an operator sequence the repressor protein has nowhere to bind, regardless of whether it is bound to inducer or not; RNA polymerase can access the promoter and transcribe the gene continuously (constitutively), unaffected by inducer presence or absence. This differs from the wild-type strain, whose activity rises from low (5 units, no inducer) to high (95-98 units, saturating) as inducer increases, because the wild-type repressor can still bind and release the (intact) operator in response to inducer.

(b) The data support the hypothesis. Strain 2 activity stays low and essentially flat across all inducer concentrations (4-6 units), showing no meaningful induction response, unlike the wild type''s rise from 5 to 98 units. This is consistent with a repressor that can still bind the operator (matching the wild-type baseline near 0 mM) but can no longer be released by inducer, since it never responds to rising inducer concentration -- it stays bound to the operator and continues blocking RNA polymerase regardless of how much inducer is present.

(c) Without inducer, the repressor protein is in its active, operator-binding conformation and binds tightly to the operator, which is positioned so that a bound repressor blocks RNA polymerase from transcribing the reporter gene -- so transcription (and reporter activity) stays low. When inducer (allolactose) is added, it binds allosterically to the repressor, changing the repressor''s shape so it can no longer bind the operator; the repressor releases from the operator, freeing the promoter region so RNA polymerase can bind and transcribe the gene, sharply increasing reporter activity as inducer concentration rises.

(d) As inducer concentration increases from 0 to 10.0 mM, wild-type reporter activity increases (from 5 to 98 units), then levels off (plateaus) between 1.0 and 10.0 mM (95 to 98 units) -- a positive, saturating dose-response relationship. This shows the operon is highly sensitive to low/moderate inducer levels (large activity increase between 0 and 1.0 mM) but becomes saturated at higher concentrations, where essentially all repressor molecules are already inducer-bound and released from the operator, so additional inducer has little further effect.'
from repaired r where r.content_key='APBIO-FRQ-L-036' and civ.id=r.new_version_id;

-- Recompute content_hash for touched versions.
update app.content_item_versions civ
set content_hash = case
  when exists (select 1 from app.mcq_choices where content_item_version_id=civ.id)
    then md5(coalesce(civ.stem,'')||E'\n'||coalesce(civ.stimulus,'')||E'\n'||
      coalesce((select string_agg(m.choice_key||':'||m.choice_text||':'||m.is_correct::text||':'||coalesce(m.rationale,''), E'\n' order by m.choice_key)
                from app.mcq_choices m where m.content_item_version_id=civ.id),''))
  else md5(coalesce(civ.stem,'')||E'\n'||coalesce(civ.stimulus,'')||E'\n'||coalesce(civ.canonical_answer_1,''))
end
from repaired r where civ.id=r.new_version_id;

insert into app.content_review_assignments (
  content_review_assignment_id, content_item_version_id, reviewer_id,
  review_stage, review_kind, status, assignment_purpose, created_by
)
select gen_random_uuid(), r.new_version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
  'tutor_question',
  (select item_type from repair_targets rt where rt.content_key=r.content_key),
  'pending','owner_remediation_approval','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from repaired r
returning content_review_assignment_id, content_item_version_id;

create temporary table remediation_assignments as
select cra.content_review_assignment_id, cra.content_item_version_id, r.content_key
from app.content_review_assignments cra
join repaired r on r.new_version_id=cra.content_item_version_id
where cra.assignment_purpose='owner_remediation_approval'
  and cra.reviewer_id='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
  and cra.status='pending';

insert into app.content_review_decisions (
  content_review_assignment_id, content_item_version_id, reviewer_id,
  review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes,
  note, tutor_decision, decision_payload, decision_hash, created_by
)
select ra.content_review_assignment_id, ra.content_item_version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
  'tutor_question', 1, 'Medium', false, array[]::text[],
  'owner_remediation_approval: AP Biology owner-adjudicated batch, 2026-08-06 -- ' || ra.content_key,
  'approve',
  jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apbio_owner_adjudicated_batch','qa_date','2026-08-06','content_key',ra.content_key),
  encode(extensions.digest(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apbio_owner_adjudicated_batch','qa_date','2026-08-06','content_key',ra.content_key)::text,'sha256'),'hex'),
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from remediation_assignments ra;

update app.content_item_versions civ
set status='reviewed_approved', updated_at=now()
from repaired r where civ.id=r.new_version_id;

update app.content_items ci
set status='reviewed_approved', updated_at=now()
from repaired r
join app.content_item_versions civ on civ.id=r.new_version_id
where ci.id=civ.content_item_id;

do $$
declare v_count integer;
begin
  select count(*) into v_count from repaired;
  if v_count <> 9 then
    raise exception 'apbio_owner_adjudicated_batch_incomplete:%', v_count;
  end if;
end $$;

select ci.content_key, civ.version_num, civ.status
from repaired r
join app.content_item_versions civ on civ.id=r.new_version_id
join app.content_items ci on ci.id=civ.content_item_id
order by ci.content_key;

commit;
