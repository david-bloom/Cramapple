-- P0-B flagged-batch repair, 2026-08-12.
--
-- Context: docs/Q&A/REVIEWER_QA_SWEEP_2026_08_12.md. The 08-10->08-12 window's P0-B
-- net check (published content with review_status IN ('excluded','modification_reserved'))
-- surfaced 17 items -- 9 AP Biology MCQs from Sarah Sohail's first pass, 8 Physics MCQs
-- from Ahmed Ali's dimensional-analysis-distractor pass -- plus a 9th Physics MCQ
-- (apphycem-mcq-011) that Ahmed disapproved on a stale, already-superseded version but
-- whose live content carries the same defect he named (pure symbol recall, duplicate of
-- apphycem-mcq-010/017). apphycm-frq-044, the window's other disapproval, was already
-- independently repaired 2026-08-11 (see its own decision history) and needs no action
-- here. This script fixes all 18 remaining items in one owner_remediation_approval batch,
-- per protocol section 9.4's insertion discipline (never edit a version in place; insert
-- a new one), plus a 19th item (apphycem-mcq-012) that Ahmed flagged with no stated
-- content defect ("Best alinged item") -- that one is closed by a fresh approval decision
-- on its existing published version, no content change, no new version.
--
-- Per-item fix source: every Physics edit below implements Ahmed Ali's own specified
-- replacement text from his 2026-08-11 review note (dimensionally-consistent distractor
-- swaps, or the exact stem/choice text he wrote out) -- this script does not invent new
-- physics, it transcribes his prescribed fix. Every Biology edit implements Sarah
-- Sohail's specific wording requests (softening absolute claims, fixing genotype
-- notation, adding missing context) plus, for APBIO-MCQ-086, a full rewrite that removes
-- the CED-out-of-scope cladistics jargon (synapomorphy/symplesiomorphy) she flagged and
-- corrects the factual error (lampreys are vertebrates) while keeping the same underlying
-- concept (a trait's phylogenetic informativeness depends on the level of comparison).
--
-- Owner-directed: "Remediate and run the publishing protocol" (chat instruction following
-- the 2026-08-12 reviewer QA sweep).

begin;
select pg_advisory_xact_lock(hashtext('cramapple-p0b-flagged-batch-repair-20260812'));

create temporary table repair_targets (
  content_key text primary key,
  source_decision_id uuid not null,
  note text not null
) on commit drop;

insert into repair_targets values
('APBIO-MCQ-043','1c59289f-b570-4365-b6af-5f491300c20f'::uuid,
 $q$Softened absolute claims ("genetically identical", "always maintains chromosome number") and specified metaphase I / anaphase I when describing homolog behavior, per Sarah Sohail's 2026-08-11 review note.$q$),
('APBIO-MCQ-054','c0f427f5-deb7-4329-add7-a0f7c6ad9db7'::uuid,
 $q$Replaced the "blending of expression levels" phrasing (risked reading as blending inheritance, refuted elsewhere in the same item), switched option B's notation from C^R C^W to C^R C^r to avoid implying codominance-style notation, and softened the "single functional allele" claim to a dosage framing not asserting a specific molecular mechanism, per Sarah Sohail's 2026-08-11 review note.$q$),
('APBIO-MCQ-056','0a5b4bef-593f-48ad-98a7-df82500286dc'::uuid,
 $q$Added the implied parental genotypes (CCpp x ccPP) to the stimulus and softened option C's "statistically implausible" wording, per Sarah Sohail's 2026-08-11 review note.$q$),
('APBIO-MCQ-084','ab1f19d6-fd0b-451a-a60b-e0ade7d72eff'::uuid,
 $q$Removed the unsupported "most common" claim about allopatric speciation and replaced "gene flow is blocked" with "gene flow is significantly reduced or interrupted" in option B's text and rationale, per Sarah Sohail's 2026-08-11 review note.$q$),
('APBIO-MCQ-086','24e7a82e-f69a-439f-9cf1-63a719a2df2f'::uuid,
 $q$Full rewrite: corrected the factual error (lampreys are vertebrates, not an exception to "vertebral column present in all"), removed formal cladistics jargon (synapomorphy/symplesiomorphy/apomorphic/plesiomorphic) that AP Biology Unit 7 Topic 7.9 does not require, and rewrote the stem/choices to actively use the example taxa (previously ignored by the question), per Sarah Sohail's 2026-08-11 disapproval.$q$),
('APBIO-MCQ-088','b15e4743-857d-4ce0-9e69-73096f1e7d59'::uuid,
 $q$Reworded option B to avoid implying relatedness guarantees (rather than makes more likely) that a relative carries the altruistic allele; corrected the Haldane example from "just exceeding" to a breakeven/equality framing and hedged the quotation's attribution, per Sarah Sohail's 2026-08-11 review note.$q$),
('APBIO-MCQ-093','7ac98ba4-e1b8-4013-845a-14669e581cc1'::uuid,
 $q$Softened option B's "entire community structure collapses" / "control the entire kelp forest community" overstatement, and corrected option C's rationale to describe otters controlling kelp indirectly (through urchins) rather than directly, per Sarah Sohail's 2026-08-11 review note.$q$),
('APBIO-MCQ-097','c499e510-bd7d-4ae3-934b-5cc927027877'::uuid,
 $q$Softened the stimulus and option A/C framing of r/K selection from a strict binary to a continuum, and softened "maximizes fitness" to "tends to be a more effective strategy," per Sarah Sohail's 2026-08-11 review note.$q$),
('APBIO-MCQ-099','03b9fb50-1c25-4ecb-96b6-0765dd3b7a78'::uuid,
 $q$Softened causal-certainty language in the stimulus and option D, disentangled the sampling effect from the complementarity effect in option B, softened "permanently reduces biodiversity," and noted that the carbon-storage figure is an estimate, per Sarah Sohail's 2026-08-11 review note.$q$),
('apphy1-mcq-021','d3c25977-8715-457c-a44f-dcf9e6857b08'::uuid,
 $q$Replaced distractors B and D with the dimensionally-consistent traps Ahmed Ali specified (escape-velocity confusion, uncancelled satellite mass) so the item requires the force-balance derivation rather than unit-inspection alone, per his 2026-08-11 review note.$q$),
('apphy2-mcq-010','a28cb9ad-8b55-4a88-9d26-aad7d6a10820'::uuid,
 $q$Rewrote the stem and replaced distractors B and D with Ahmed Ali's specified dimensionally-legal (qvB-magnitude) direction traps, so every option carries force units and the student must reason about the angle between v and B, per his 2026-08-11 review note.$q$),
('apphy2-mcq-013','f1b6034a-deca-42e1-8aa2-062b5bf64c9f'::uuid,
 $q$Replaced the "becomes zero" dead-weight distractor D with Ahmed Ali's specified geometry trap ("changes only if the angle of incidence is nonzero"), per his 2026-08-11 review note.$q$),
('apphycem-mcq-011','48e3dff7-19c8-4e74-a952-34747e8d64c2'::uuid,
 $q$Rebuilt as an applied numeric RC-discharge computation (Ahmed Ali's specified scenario and answer set) to stop duplicating apphycem-mcq-010/017's bare symbol recall and add a real reasoning step, per his 2026-08-11 review note. His decision landed on an already-superseded version (created 07-20, superseded 08-08 before his 08-11 review); the live content carried the identical defect, confirmed independently before this repair.$q$),
('apphycem-mcq-016','f42cfccb-1428-4a86-8dd5-65019ecb2177'::uuid,
 $q$Rewrote the stem to show the line integral the "integral form" label promises, fixed Phi_B subscript rendering throughout, and replaced distractors C and D with Ahmed Ali's specified traps (ratio-vs-derivative error, Ampere's-law cross-confusion), per his 2026-08-11 review note.$q$),
('apphycm-mcq-006','36480e4a-33af-49c1-ab79-4ce1334b1eaf'::uuid,
 $q$Rewrote the stem and replaced distractors C and D with Ahmed Ali's specified dimensionally-legal traps (division-instead-of-differentiation, second-derivative-with-dropped-sign), per his 2026-08-11 review note. The near-duplicate apphycm-mcq-012 concern he raised is carried forward as a follow-up, not addressed here (out of this batch's scope).$q$),
('apphycm-mcq-014','5d142960-1fe5-4567-a647-102650655e8d'::uuid,
 $q$Rewrote the stem and replaced distractors B, C, and D with Ahmed Ali's specified dimensionally-legal traps (Iw confused with L itself, ratio-vs-derivative error, spurious w-squared dependence), per his 2026-08-11 review note.$q$),
('apphycm-mcq-020','1fa53865-053b-499a-9c40-123b34494022'::uuid,
 $q$Added the variable definitions (d = pivot-to-center-of-mass distance, I = moment of inertia about the pivot) Ahmed Ali specified as required for the item to be answerable by CED standards, per his 2026-08-11 review note.$q$);

create temporary table repaired (
  content_key text primary key,
  old_version_id uuid not null,
  new_version_id uuid not null,
  source_decision_id uuid not null,
  note text not null
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
    where content_key=t.content_key and item_type='mcq'
    for update;

    select * into strict v_old
    from app.content_item_versions
    where content_item_id=v_item.id and status='published'
    order by version_num desc
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
        'qa_remediation','2026-08-12 P0-B flagged-batch repair (docs/Q&A/REVIEWER_QA_SWEEP_2026_08_12.md)',
        'qa_source_version_id',v_old.id
      ),
      v_old.explanation,v_old.help_text,v_old.content_hash,
      'draft','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
      v_old.canonical_answer_1,v_old.canonical_answer_2,null,
      v_old.rubric_type,v_old.evaluator_strategy,v_old.stimulus_image_path
    );

    insert into app.mcq_choices (
      content_item_version_id,choice_key,choice_text,is_correct,rationale
    )
    select v_new,choice_key,choice_text,is_correct,rationale
    from app.mcq_choices
    where content_item_version_id=v_old.id;

    insert into repaired values (t.content_key,v_old.id,v_new,t.source_decision_id,t.note);
  end loop;
end $$;

-- ============================================================================
-- Per-item content fixes.
-- ============================================================================

-- APBIO-MCQ-043
update app.content_item_versions civ
set stimulus=$q$A species with a diploid number of 8 (2n = 8) is studied. Cell type P divides in 2 hours and produces two daughter cells, each with 8 chromosomes. Cell type Q undergoes two sequential nuclear divisions over 18 hours and produces four daughter cells, each with 4 chromosomes. During the first division of type Q (meiosis I), homologous chromosome pairs align together at the equatorial plate during metaphase I and then separate during anaphase I. During the second division of type Q (meiosis II), sister chromatids separate.$q$
from repaired r where r.content_key='APBIO-MCQ-043' and civ.id=r.new_version_id;

update app.mcq_choices m
set rationale=$q$Mitosis: one division, daughter cells matching the parent's chromosome number (2n = 8 -> 8 chromosomes per daughter). Meiosis: two divisions, homologs separate in meiosis I, sister chromatids separate in meiosis II, producing haploid cells (n = 4). The behavioral description -- homologs aligning together during metaphase I, then separating during anaphase I -- is the defining hallmark of meiosis I, distinguishing it from mitosis where homologs do not pair.$q$
from repaired r where r.content_key='APBIO-MCQ-043' and m.content_item_version_id=r.new_version_id and m.choice_key='B';
update app.mcq_choices m
set rationale=$q$Mitosis maintains chromosome number in its daughter cells -- it does not reduce it. The reduction in chromosome number in cell type Q is the result of meiotic mechanisms: homolog pairing and separation in meiosis I, without DNA replication between the two divisions.$q$
from repaired r where r.content_key='APBIO-MCQ-043' and m.content_item_version_id=r.new_version_id and m.choice_key='D';

-- APBIO-MCQ-054
update app.mcq_choices m
set rationale=$q$Codominance produces distinct simultaneous expression of both alleles in separate regions (e.g., red AND white patches on the same petal). The F1 plants are uniformly pink -- an intermediate phenotype resulting from reduced total pigment, not a mosaic of red and white. The biochemical data (half the pigment protein) are consistent with a gene-dosage effect between the two alleles, not separate spatial domains.$q$
from repaired r where r.content_key='APBIO-MCQ-054' and m.content_item_version_id=r.new_version_id and m.choice_key='A';
update app.mcq_choices m
set choice_text=$q$Incomplete dominance; the F1 genotype is C^R C^r (heterozygous for the pigment gene), and having one copy of the pigment-producing allele instead of two yields half the pigment dose, producing an intermediate pink phenotype$q$,
    rationale=$q$Incomplete dominance: neither allele fully masks the other in heterozygotes, producing an intermediate phenotype. Key evidence: (1) F1 are uniformly pink (not red or white) -- intermediate; (2) F2 ratio is 1 red : 2 pink : 1 white -- the heterozygous class is phenotypically distinct from both homozygotes; (3) biochemical data are consistent with a gene-dosage relationship (2 copies of the pigment-producing allele = full red, 1 copy = half pigment = pink, 0 copies = white).$q$
from repaired r where r.content_key='APBIO-MCQ-054' and m.content_item_version_id=r.new_version_id and m.choice_key='B';

-- APBIO-MCQ-056
update app.content_item_versions civ
set stimulus=$q$In a flower color experiment, two true-breeding white-flowered plants from different strains are crossed. All F1 offspring have purple flowers. When F1 plants are self-fertilized, the F2 generation shows 9/16 purple and 7/16 white -- not the classic 9:3:3:1 ratio. Biochemical analysis reveals: a colorless precursor is converted to a purple pigment by two sequential enzymes, each encoded by a separate gene (gene C and gene P). Both enzymes are required to produce any purple pigment. The cross is consistent with true-breeding parental genotypes CCpp x ccPP (or the reciprocal cross), producing CcPp F1 offspring.$q$
from repaired r where r.content_key='APBIO-MCQ-056' and civ.id=r.new_version_id;

update app.mcq_choices m
set rationale=$q$De novo mutation producing purple in all F1 offspring is not the best explanation here. The cross of two different white strains producing purple F1 is explained by complementation: one parent provides gene C, the other provides gene P, and F1 heterozygotes (CcPp) have both functional alleles for the first time.$q$
from repaired r where r.content_key='APBIO-MCQ-056' and m.content_item_version_id=r.new_version_id and m.choice_key='C';

-- APBIO-MCQ-084
update app.mcq_choices m
set choice_text=$q$Allopatric speciation involves a geographic barrier that significantly reduces or interrupts gene flow between populations, allowing them to diverge independently through selection and drift until reproductive isolation evolves; sympatric speciation occurs within the same geographic range and typically requires other isolating mechanisms (ecological, behavioral, polyploidy) to reduce gene flow between diverging populations$q$,
    rationale=$q$Allopatric speciation: a physical barrier (mountain range, river, ocean) splits a population -> gene flow is significantly reduced or interrupted -> populations evolve independently (different selection pressures, drift) -> reproductive isolation accumulates as a byproduct of genetic divergence -> if populations later contact each other, they no longer interbreed freely. Sympatric speciation: no geographic barrier; isolating mechanisms include ecological specialization (different host plants), sexual selection, or polyploidy (instantaneous speciation in plants via allopolyploidy -- e.g., wheat). Sympatric speciation is more controversial and typically requires mechanisms that reduce gene flow within the same area.$q$
from repaired r where r.content_key='APBIO-MCQ-084' and m.content_item_version_id=r.new_version_id and m.choice_key='B';

-- APBIO-MCQ-086 -- full rewrite.
update app.content_item_versions civ
set stem=$q$Which correctly distinguishes a trait that identifies a specific subgroup within these taxa from a trait that is shared broadly but does not distinguish subgroups?$q$,
    stimulus=$q$Biologists classify organisms partly by comparing shared traits and asking, relative to a given set of taxa, whether a trait arose recently (in the most recent common ancestor of a subset) or was already present in a much older common ancestor. Example taxa: lamprey, shark, frog, cat, human. A vertebral column is present in all five taxa, including the lamprey (lampreys are jawless vertebrates, class Agnatha). Four limbs are present in frog, cat, and human but not shark or lamprey. Hair is present only in cat and human.$q$
from repaired r where r.content_key='APBIO-MCQ-086' and civ.id=r.new_version_id;

update app.mcq_choices m
set choice_text=$q$A trait shared by all five taxa is always more useful for identifying a specific subgroup than a trait shared by only two or three of them, because more shared taxa means stronger evidence$q$,
    is_correct=false,
    rationale=$q$How many taxa share a trait is not what makes it useful for identifying a subgroup. A vertebral column is shared by all five taxa here, precisely because it is old enough to have already been present in their common ancestor -- that makes it useless for distinguishing any subgroup among them. Hair, shared by only two taxa (cat and human), is far more informative because it arose recently, in the common ancestor of just that pair.$q$
from repaired r where r.content_key='APBIO-MCQ-086' and m.content_item_version_id=r.new_version_id and m.choice_key='A';
update app.mcq_choices m
set choice_text=$q$A trait that arose in the most recent common ancestor of a specific subgroup -- such as four limbs, present in frog, cat, and human but not shark or lamprey -- identifies that subgroup. A trait present in all five taxa, such as the vertebral column, was already present in a much older common ancestor and does not distinguish any subgroup among them, even though every taxon in the set has it.$q$,
    is_correct=true,
    rationale=$q$Four limbs is informative here because it marks off frog+cat+human (the tetrapod lineage) from shark and lamprey -- it arose once, in the common ancestor of that subgroup. The vertebral column illustrates the same trait behaving differently depending on which taxa are being compared: it is shared by all five taxa in this set (lampreys are vertebrates), so within this set it says nothing about subgroup relationships -- but if an invertebrate were added to the comparison, the same vertebral column would become informative for separating vertebrates from that invertebrate. Whether a shared trait is informative depends on the level of comparison, not on the trait itself.$q$
from repaired r where r.content_key='APBIO-MCQ-086' and m.content_item_version_id=r.new_version_id and m.choice_key='B';
update app.mcq_choices m
set choice_text=$q$Hair, present only in cat and human, is less informative than the vertebral column, present in all five taxa, because a trait needs to be widely shared to be a reliable basis for classification$q$,
    is_correct=false,
    rationale=$q$This reverses which trait is informative. Because the vertebral column is shared by every taxon being compared here, it cannot distinguish any subgroup within the set -- it is uninformative for this particular comparison. Hair, despite being rarer, marks off exactly the mammalian pair (cat, human) from the other three, making it the more useful trait for classification at this level.$q$
from repaired r where r.content_key='APBIO-MCQ-086' and m.content_item_version_id=r.new_version_id and m.choice_key='C';
update app.mcq_choices m
set choice_text=$q$Four limbs cannot be used to classify these taxa because sharks also live in water alongside limbed and limbless organisms, so limb presence reflects habitat, not ancestry$q$,
    is_correct=false,
    rationale=$q$Limb presence here tracks shared ancestry, not current habitat -- frog, cat, and human all descend from a four-limbed common ancestor (the tetrapod lineage), regardless of whether they currently live in water, on land, or both. Shark's lack of limbs reflects that sharks branched off before limbs evolved, not a habitat effect.$q$
from repaired r where r.content_key='APBIO-MCQ-086' and m.content_item_version_id=r.new_version_id and m.choice_key='D';

-- APBIO-MCQ-088
update app.mcq_choices m
set choice_text=$q$Altruism is favored when rB > C: the benefit to the recipient (B), discounted by the probability of shared ancestry (r), must exceed the cost to the actor (C); even if the actor loses direct fitness, the same allele is more likely to be present -- and thus propagated -- in the relative, so the altruistic allele can increase in frequency if it causes enough copies of itself to survive in relatives$q$,
    rationale=$q$Hamilton's rule rB > C unpacked: r (coefficient of relatedness) weights the benefit by how likely the recipient shares the altruistic allele -- full sibling r=0.5, offspring r=0.5, first cousin r=0.125. Even at personal cost, an actor can propagate copies of its alleles through relatives. Classic example: a worker honeybee (r=0.75 to sisters in a haplodiploid colony) sacrifices direct reproduction but raises sisters who share 3/4 of its genes -- rB may exceed C. This is kin selection. A remark often attributed to J.B.S. Haldane (exact wording varies by source) captures the logic: he would risk his life for two brothers or eight cousins -- both give rB = 1, at the breakeven threshold with C = 1 for one life.$q$
from repaired r where r.content_key='APBIO-MCQ-088' and m.content_item_version_id=r.new_version_id and m.choice_key='B';

-- APBIO-MCQ-093
update app.mcq_choices m
set rationale=$q$A trophic cascade is an indirect effect that propagates through trophic levels: top predator (otter) -> mesoconsumer (urchin) -> primary producer (kelp). Removing the top predator releases the mesoconsumer from predation control -> mesoconsumer population explodes -> intensified herbivory sharply reduces the dominant primary producer -> the community shifts toward an urchin-dominated state. A keystone species has an effect on community structure disproportionate to its biomass. Sea otters constitute a small fraction of ecosystem biomass but exert outsized influence on the kelp forest community through their regulatory role. Otter reintroduction reverses the cascade.$q$
from repaired r where r.content_key='APBIO-MCQ-093' and m.content_item_version_id=r.new_version_id and m.choice_key='B';
update app.mcq_choices m
set rationale=$q$The spatial comparison (areas with otters have kelp; areas without otters have urchin barrens) and the temporal recovery following otter reintroduction provide strong evidence for the trophic cascade: otters control urchins, and urchin grazing pressure in turn controls kelp -- otters influence kelp forest structure indirectly, through that chain, not by acting on kelp directly. The reversibility of the effect with otter return demonstrates the causal role of the cascade, not abiotic factors.$q$
from repaired r where r.content_key='APBIO-MCQ-093' and m.content_item_version_id=r.new_version_id and m.choice_key='C';

-- APBIO-MCQ-097
update app.content_item_versions civ
set stimulus=$q$Ecologists recognize a continuum of reproductive strategies from r-strategists (high reproductive rate, low parental investment, short lifespan) to K-strategists (low reproductive rate, high parental investment, long lifespan); most real species fall somewhere along this continuum rather than fitting cleanly into either category. The names derive from the logistic growth equation: r = intrinsic rate of increase; K = carrying capacity. r-strategists tend to favor traits that maximize r; K-strategists tend to favor traits suited to living near K.$q$
from repaired r where r.content_key='APBIO-MCQ-097' and civ.id=r.new_version_id;

update app.mcq_choices m
set choice_text=$q$Few offspring, extensive parental care, delayed reproduction, large body size, long lifespan -- these traits tend to be favored when resources are limited and competition is intense near K, because investing heavily in few high-quality offspring that can compete for limited resources tends to be a more effective strategy than producing many low-investment offspring$q$,
    rationale=$q$K-strategist life history rationale: near carrying capacity, resources are limiting and competition is intense. In this environment, offspring quality tends to matter more than quantity -- offspring capable of competing for scarce resources are more likely to survive. K-strategists allocate resources to parental care, increasing each offspring's survival probability. Few offspring plus high investment per offspring tends to be favored in this setting, though real species fall along a continuum rather than sorting cleanly into two types. Examples toward the K end: elephants (1 calf per 4-5 years, 10-15 years to maturity), great apes, humans, whales, large trees (oak). These populations grow slowly, recover slowly from disturbance, and are vulnerable to overexploitation.$q$
from repaired r where r.content_key='APBIO-MCQ-097' and m.content_item_version_id=r.new_version_id and m.choice_key='A';
update app.mcq_choices m
set rationale=$q$Continuous year-round reproduction is not a defining K-selected trait. Many K-selected species (bears, elephants, deer) have highly seasonal reproduction timed to favorable resource conditions (when offspring survival is maximized). Reproductive timing and seasonality vary independently of where a species falls on the r/K continuum -- the K-selected strategy is defined by offspring quality and investment per offspring, not by timing or continuity of reproduction.$q$
from repaired r where r.content_key='APBIO-MCQ-097' and m.content_item_version_id=r.new_version_id and m.choice_key='C';

-- APBIO-MCQ-099
update app.content_item_versions civ
set stimulus=$q$Ecosystem services are the benefits that humans derive from ecosystems. Tropical forests cover ~7% of Earth's land surface but contain ~50% of all terrestrial species and store roughly 250 billion metric tons of carbon in biomass and soil (estimates vary across studies and methods). Deforestation of tropical forests releases stored carbon as CO2 and sharply reduces biodiversity, with recovery -- where it happens at all -- occurring over long timescales. A research consortium tracking 300,000 tree plots across the tropics found that plots with higher tree species diversity had significantly greater carbon storage per hectare than monoculture plantations of similar tree density.$q$
from repaired r where r.content_key='APBIO-MCQ-099' and civ.id=r.new_version_id;

update app.mcq_choices m
set choice_text=$q$Higher tree species diversity enhances carbon sequestration in part through niche complementarity: diverse species use light, water, and nutrients at different vertical canopy layers, rooting depths, and phenological timings -- more completely exploiting available resources and sustaining higher total biomass production than monocultures$q$,
    rationale=$q$Niche complementarity is one of the main ecological mechanisms proposed to explain the biodiversity-ecosystem function relationship. In diverse forests: canopy species capture light at different heights (vertical stratification); deep-rooted and shallow-rooted species access different soil water and nutrient pools; species with different leaf-out times reduce seasonal gaps in carbon uptake; diverse soil microbiomes (maintained by diverse litter inputs) improve nutrient cycling. This complementarity effect (diverse species jointly using resources more completely) is conceptually distinct from the sampling effect (a diverse plot has a higher chance of including one especially productive species) -- both are documented in biodiversity-ecosystem function research, and field studies typically cannot fully separate their individual contributions. Together they help explain why total resource capture, biomass, and carbon storage in diverse plots exceed that of comparable monocultures.$q$
from repaired r where r.content_key='APBIO-MCQ-099' and m.content_item_version_id=r.new_version_id and m.choice_key='B';
update app.mcq_choices m
set rationale=$q$While correlation does not always imply causation, controlled experiments (Biodiversity Ecosystem Function experiments, BIODEPTH) and the tree plot data (comparing diverse plots to monocultures at similar densities, an approach designed to reduce, though not fully eliminate, the influence of other confounding factors) provide evidence for a causal relationship, not merely a correlational one. The niche complementarity and sampling-effect mechanisms provide biologically plausible causal explanations for why diversity is associated with higher productivity and higher carbon storage.$q$
from repaired r where r.content_key='APBIO-MCQ-099' and m.content_item_version_id=r.new_version_id and m.choice_key='D';

-- apphy1-mcq-021
update app.content_item_versions civ
set stem=$q$A satellite of mass m orbits a planet of mass M in a circular orbit of radius r. Which expression gives the satellite's orbital speed?

A. √(GM/r)
B. √(2GM/r)
C. √(GM/r²)
D. √(GMm/r)$q$
from repaired r where r.content_key='apphy1-mcq-021' and civ.id=r.new_version_id;

update app.mcq_choices m
set choice_text=$q$√(2GM/r)$q$,
    rationale=$q$This is the escape-velocity expression, obtained by setting total mechanical energy to zero rather than by equating gravitational force to centripetal force (GMm/r^2 = mv^2/r) -- a common mix-up between two related but distinct derivations.$q$
from repaired r where r.content_key='apphy1-mcq-021' and m.content_item_version_id=r.new_version_id and m.choice_key='B';
update app.mcq_choices m
set choice_text=$q$√(GMm/r)$q$,
    rationale=$q$This carries an uncancelled factor of the satellite's own mass m. In the correct derivation, GMm/r^2 = mv^2/r, the satellite mass m appears on both sides and cancels before solving for v; an expression that still contains m has not completed that cancellation.$q$
from repaired r where r.content_key='apphy1-mcq-021' and m.content_item_version_id=r.new_version_id and m.choice_key='D';

-- apphy2-mcq-010
update app.content_item_versions civ
set stem=$q$A particle with charge q moves with speed v in a direction parallel to a uniform magnetic field of magnitude B. The magnetic force on the particle is--

A. qvB
B. qvB, directed parallel to v
C. zero
D. qvB, directed perpendicular to both v and B$q$
from repaired r where r.content_key='apphy2-mcq-010' and civ.id=r.new_version_id;

update app.mcq_choices m
set rationale=$q$Uses the general-motion magnitude formula qvB but ignores the angle between v and B -- the full expression is qvB sin(theta), which is zero here because theta=0 when velocity is parallel to the field.$q$
from repaired r where r.content_key='apphy2-mcq-010' and m.content_item_version_id=r.new_version_id and m.choice_key='A';
update app.mcq_choices m
set choice_text=$q$qvB, directed parallel to v$q$,
    rationale=$q$The magnetic force F = qv x B is always perpendicular to v by construction, so a force parallel to v is impossible regardless of magnitude -- and here the magnitude is zero besides.$q$
from repaired r where r.content_key='apphy2-mcq-010' and m.content_item_version_id=r.new_version_id and m.choice_key='B';
update app.mcq_choices m
set choice_text=$q$qvB, directed perpendicular to both v and B$q$,
    rationale=$q$Correctly states the general direction rule for F = qv x B (perpendicular to both v and B) but misses that the magnitude, qvB sin(theta), is zero when theta=0 -- the direction rule only describes a force that has nonzero magnitude to begin with.$q$
from repaired r where r.content_key='apphy2-mcq-010' and m.content_item_version_id=r.new_version_id and m.choice_key='D';

-- apphy2-mcq-013
update app.content_item_versions civ
set stem=$q$A beam of monochromatic light travels from air into glass. As the light crosses the boundary, its frequency--

A. increases
B. decreases
C. stays the same
D. changes only if the angle of incidence is nonzero$q$
from repaired r where r.content_key='apphy2-mcq-013' and civ.id=r.new_version_id;

update app.mcq_choices m
set choice_text=$q$changes only if the angle of incidence is nonzero$q$,
    rationale=$q$Ties frequency to the geometry of refraction, but frequency is set by the source and preserved by continuity of the wave across the boundary regardless of the incidence angle -- only the ray's direction (and its wavelength and speed within the glass) depend on that angle, not its frequency.$q$
from repaired r where r.content_key='apphy2-mcq-013' and m.content_item_version_id=r.new_version_id and m.choice_key='D';

-- apphycem-mcq-011 -- full rebuild (applied numeric problem, replacing bare symbol recall).
update app.content_item_versions civ
set stem=$q$A 2.0 uF capacitor, initially charged to 12 V, discharges through a 500 kOhm resistor. Approximately how long does it take for the charge to fall to 37% of its initial value?

A. 0.25 s
B. 1.0 s
C. 2.5 s
D. 4.0 s$q$
from repaired r where r.content_key='apphycem-mcq-011' and civ.id=r.new_version_id;

update app.mcq_choices m
set choice_text=$q$0.25 s$q$, is_correct=false,
    rationale=$q$This is one-quarter of the correct time constant -- a plausible slip if the exponential decay is set up as t/(4RC)=1 instead of t/RC=1.$q$
from repaired r where r.content_key='apphycem-mcq-011' and m.content_item_version_id=r.new_version_id and m.choice_key='A';
update app.mcq_choices m
set choice_text=$q$1.0 s$q$, is_correct=true,
    rationale=$q$The time constant is tau = RC = (5.0x10^5 Ohm)(2.0x10^-6 F) = 1.0 s. Since Q(t) = Q0 e^(-t/RC), the charge falls to Q0/e, about 0.37 Q0, at exactly t = tau = 1.0 s. The initial 12 V charging voltage does not affect this timing -- the time constant depends only on R and C.$q$
from repaired r where r.content_key='apphycem-mcq-011' and m.content_item_version_id=r.new_version_id and m.choice_key='B';
update app.mcq_choices m
set choice_text=$q$2.5 s$q$, is_correct=false,
    rationale=$q$This matches RC computed with C mistakenly read as 5.0 uF instead of the given 2.0 uF: (5.0x10^5 Ohm)(5.0x10^-6 F) = 2.5 s.$q$
from repaired r where r.content_key='apphycem-mcq-011' and m.content_item_version_id=r.new_version_id and m.choice_key='C';
update app.mcq_choices m
set choice_text=$q$4.0 s$q$, is_correct=false,
    rationale=$q$This is 4 tau, the time by which the charge has fallen to roughly 2% of its initial value (a common "essentially fully discharged" benchmark) -- mistakenly applied here instead of the 1 tau point, where 37% of the charge remains.$q$
from repaired r where r.content_key='apphycem-mcq-011' and m.content_item_version_id=r.new_version_id and m.choice_key='D';

-- apphycem-mcq-016
update app.content_item_versions civ
set stem=$q$Faraday's law in integral form states that the emf around a closed loop, the line integral of E around the loop, is equal to--

A. dΦ_B/dt
B. -dΦ_B/dt
C. -Φ_B/t
D. -μ₀I_enc$q$
from repaired r where r.content_key='apphycem-mcq-016' and civ.id=r.new_version_id;

update app.mcq_choices m
set choice_text=$q$dΦ_B/dt$q$,
    rationale=$q$This drops the negative sign that encodes Lenz's law in Faraday's law.$q$
from repaired r where r.content_key='apphycem-mcq-016' and m.content_item_version_id=r.new_version_id and m.choice_key='A';
update app.mcq_choices m
set choice_text=$q$-dΦ_B/dt$q$
from repaired r where r.content_key='apphycem-mcq-016' and m.content_item_version_id=r.new_version_id and m.choice_key='B';
update app.mcq_choices m
set choice_text=$q$-Φ_B/t$q$,
    rationale=$q$This treats the rate of change as a simple ratio of flux to elapsed time rather than the true time derivative -- Φ_B/t equals dΦ_B/dt only in the special case where flux grows linearly from zero.$q$
from repaired r where r.content_key='apphycem-mcq-016' and m.content_item_version_id=r.new_version_id and m.choice_key='C';
update app.mcq_choices m
set choice_text=$q$-μ₀I_enc$q$,
    rationale=$q$This is (the negative of) the right-hand side of Ampere's law, a different circulation law relating B to enclosed current -- a cross-law confusion, not a Faraday's-law expression.$q$
from repaired r where r.content_key='apphycem-mcq-016' and m.content_item_version_id=r.new_version_id and m.choice_key='D';

-- apphycm-mcq-006
update app.content_item_versions civ
set stem=$q$A particle moves in one dimension under a conservative force with potential energy U(x). The force on the particle is given by which of the following?

A. dU/dx
B. -dU/dx
C. -U/x
D. +d^2U/dx^2$q$
from repaired r where r.content_key='apphycm-mcq-006' and civ.id=r.new_version_id;

update app.mcq_choices m
set choice_text=$q$-U/x$q$,
    rationale=$q$This has the correct sign but treats the relationship as simple division rather than differentiation, as though U were directly proportional to x -- it agrees with -dU/dx only in that special case.$q$
from repaired r where r.content_key='apphycm-mcq-006' and m.content_item_version_id=r.new_version_id and m.choice_key='C';
update app.mcq_choices m
set choice_text=$q$+d^2U/dx^2$q$,
    rationale=$q$This differentiates U twice and drops the sign. The second derivative describes how steeply the force itself changes with position (related to the stiffness of the potential well), not the force.$q$
from repaired r where r.content_key='apphycm-mcq-006' and m.content_item_version_id=r.new_version_id and m.choice_key='D';

-- apphycm-mcq-014
update app.content_item_versions civ
set stem=$q$A system experiences zero net external torque. Which of the following is true of dL/dt?

A. zero
B. I*omega (constant, nonzero)
C. L/t
D. proportional to omega^2$q$
from repaired r where r.content_key='apphycm-mcq-014' and civ.id=r.new_version_id;

update app.mcq_choices m
set choice_text=$q$I*omega (constant, nonzero)$q$,
    rationale=$q$I*omega is the angular momentum L itself, not its time derivative -- this confuses the conserved quantity with its (zero) rate of change.$q$
from repaired r where r.content_key='apphycm-mcq-014' and m.content_item_version_id=r.new_version_id and m.choice_key='B';
update app.mcq_choices m
set choice_text=$q$L/t$q$,
    rationale=$q$Treats the derivative as a simple ratio of L to elapsed time rather than an instantaneous rate of change -- L/t equals dL/dt only if L grows linearly from zero, which contradicts L being constant here.$q$
from repaired r where r.content_key='apphycm-mcq-014' and m.content_item_version_id=r.new_version_id and m.choice_key='C';
update app.mcq_choices m
set choice_text=$q$proportional to omega^2$q$,
    rationale=$q$Introduces a dependence resembling rotational kinetic energy (KE_rot = (1/2) I omega^2) that has no basis in the torque-angular-momentum relation tau = dL/dt; with zero net torque, dL/dt is exactly zero regardless of omega.$q$
from repaired r where r.content_key='apphycm-mcq-014' and m.content_item_version_id=r.new_version_id and m.choice_key='D';

-- apphycm-mcq-020
update app.content_item_versions civ
set stem=$q$For a physical pendulum undergoing small-angle oscillation, omega^2 equals which of the following, where d is the distance from the pivot to the center of mass and I is the moment of inertia about the pivot?

A. mgd/I
B. I/mgd
C. g/I
D. mgI/d$q$
from repaired r where r.content_key='apphycm-mcq-020' and civ.id=r.new_version_id;

-- ============================================================================
-- Recompute content_hash, then re-run the structure/integrity gate (protocol
-- Phase 2) before any of these 18 versions can be approved or published.
-- ============================================================================

update app.content_item_versions civ
set content_hash = md5(coalesce(civ.stem,'')||E'\n'||coalesce(civ.stimulus,'')||E'\n'||
  coalesce((select string_agg(m.choice_key||':'||m.choice_text||':'||m.is_correct::text||':'||coalesce(m.rationale,''), E'\n' order by m.choice_key)
            from app.mcq_choices m where m.content_item_version_id=civ.id),''))
from repaired r where civ.id=r.new_version_id;

create temporary table qa_blocked as
select r.content_key,
  case
    when nullif(trim(civ.stem),'') is null then 'blank stem'
    when (select count(*) from app.mcq_choices m where m.content_item_version_id=civ.id)<>4 then 'choice count'
    when (select count(distinct lower(trim(m.choice_text))) from app.mcq_choices m where m.content_item_version_id=civ.id)<>4 then 'duplicate choice text'
    when (select count(*) from app.mcq_choices m where m.content_item_version_id=civ.id and m.is_correct)<>1 then 'correct key count'
    when exists (select 1 from app.mcq_choices m where m.content_item_version_id=civ.id and nullif(trim(coalesce(m.rationale,'')),'') is null) then 'blank rationale'
    when exists (select 1 from app.content_item_versions other where other.content_item_id=civ.content_item_id and other.id<>civ.id and other.status='published') then 'competing published version'
  end reason
from repaired r
join app.content_item_versions civ on civ.id=r.new_version_id;
delete from qa_blocked where reason is null;

create temporary table approve_set on commit drop as
select r.content_key, r.new_version_id, r.source_decision_id, r.note
from repaired r
where not exists (select 1 from qa_blocked b where b.content_key=r.content_key);

-- ============================================================================
-- owner_remediation_approval: assignment + decision + approve + publish.
-- ============================================================================

insert into app.content_review_assignments (
  content_review_assignment_id, content_item_version_id, reviewer_id,
  review_stage, review_kind, status, assignment_purpose, created_by
)
select gen_random_uuid(),new_version_id,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
       'tutor_question','mcq','pending','owner_remediation_approval','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from approve_set;

insert into app.content_review_decisions (
  content_review_assignment_id,content_item_version_id,reviewer_id,
  supersedes_id,review_stage,tutor_score,difficulty_label,diagnostic_flag,
  concern_codes,note,tutor_decision,decision_payload,
  decision_hash,created_by
)
select cra.content_review_assignment_id,p.new_version_id,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
       p.source_decision_id,'tutor_question',1,'Medium',false,array[]::text[],
       'Owner-directed P0-B flagged-batch repair, 2026-08-12 (docs/Q&A/REVIEWER_QA_SWEEP_2026_08_12.md). ' || p.note,
       'approve',
       jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','p0b_flagged_batch_repair','content_key',p.content_key,'source_decision_id',p.source_decision_id,'qa_date','2026-08-12'),
       encode(extensions.digest(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','p0b_flagged_batch_repair','content_key',p.content_key,'source_decision_id',p.source_decision_id,'qa_date','2026-08-12')::text,'sha256'),'hex'),
       'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from approve_set p
join app.content_review_assignments cra on cra.content_item_version_id=p.new_version_id and cra.assignment_purpose='owner_remediation_approval' and cra.status='pending';

update app.content_item_versions civ
set status='reviewed_approved',
    review_status='question_review_approved',
    approved_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
    approved_at=coalesce(civ.approved_at,now()),
    updated_at=now()
from approve_set p
where civ.id=p.new_version_id;

update app.content_items ci
set status='reviewed_approved', updated_at=now()
from approve_set p
join app.content_item_versions civ on civ.id=p.new_version_id
where ci.id=civ.content_item_id;

update app.content_item_versions civ
set status='published',
    published_at=coalesce(civ.published_at,now()),
    updated_at=now()
from approve_set p
where civ.id=p.new_version_id;

update app.content_items ci
set status='published', updated_at=now()
from approve_set p
join app.content_item_versions civ on civ.id=p.new_version_id
where ci.id=civ.content_item_id;

-- ============================================================================
-- apphycem-mcq-012: no content defect identified (Ahmed Ali: "Best alinged
-- item"). No new version -- close the modification_reserved flag with a fresh
-- owner decision on the existing published version.
-- ============================================================================

do $$
declare
  v_version_id uuid;
  v_assignment_id uuid;
begin
  select id into strict v_version_id
  from app.content_item_versions
  where content_item_id=(select id from app.content_items where content_key='apphycem-mcq-012' and item_type='mcq')
    and status='published';

  v_assignment_id := gen_random_uuid();

  insert into app.content_review_assignments (
    content_review_assignment_id, content_item_version_id, reviewer_id,
    review_stage, review_kind, status, assignment_purpose, created_by
  ) values (
    v_assignment_id, v_version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
    'tutor_question','mcq','pending','owner_remediation_approval','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
  );

  insert into app.content_review_decisions (
    content_review_assignment_id,content_item_version_id,reviewer_id,
    supersedes_id,review_stage,tutor_score,difficulty_label,diagnostic_flag,
    concern_codes,note,tutor_decision,decision_payload,
    decision_hash,created_by
  ) values (
    v_assignment_id, v_version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
    '024b7942-9241-49bf-815d-bb47b9b8daf4'::uuid,'tutor_question',1,'Easy',false,array[]::text[],
    'Owner-directed P0-B flagged-batch review, 2026-08-12 (docs/Q&A/REVIEWER_QA_SWEEP_2026_08_12.md). Ahmed Ali flagged this item with no stated content defect ("Best alinged item") -- independently re-read stem/choices/rationales, found no correctness or CED-scope issue. No content change; closing the modification_reserved flag.',
    'approve',
    jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','p0b_flagged_batch_repair_no_defect','content_key','apphycem-mcq-012','qa_date','2026-08-12'),
    encode(extensions.digest(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','p0b_flagged_batch_repair_no_defect','content_key','apphycem-mcq-012','qa_date','2026-08-12')::text,'sha256'),'hex'),
    'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
  );

  update app.content_item_versions
  set review_status='question_review_approved',
      approved_by=coalesce(approved_by,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid),
      approved_at=coalesce(approved_at,now()),
      updated_at=now()
  where id=v_version_id;
end $$;

-- ============================================================================
-- Assertions.
-- ============================================================================

do $$
declare n integer;
begin
  select count(*) into n from repaired;
  if n<>17 then raise exception 'expected 17 repaired items, got %', n; end if;

  select count(*) into n from qa_blocked;
  if n<>0 then raise exception 'P0-B flagged-batch repair blocked by structural QA gate: %',
    (select string_agg(content_key||':'||reason, ', ' order by content_key) from qa_blocked);
  end if;

  select count(*) into n from approve_set;
  if n<>17 then raise exception 'expected 17 approved+published items, got %', n; end if;

  select count(*) into n from (
    select content_item_id from app.content_item_versions where status='published'
    group by content_item_id having count(*)>1
  ) d;
  if n<>0 then raise exception 'duplicate published versions after P0-B flagged-batch repair: %', n; end if;

  select count(*) into n
  from app.content_item_versions v
  join app.content_items ci on ci.id=v.content_item_id
  where ci.content_key='apphycem-mcq-012' and v.status='published' and v.review_status='question_review_approved';
  if n<>1 then raise exception 'apphycem-mcq-012 no-defect re-approval did not land as expected'; end if;

  select count(*) into n
  from app.content_item_versions v
  join app.content_items ci on ci.id=v.content_item_id
  where ci.content_key in (
    'APBIO-MCQ-043','APBIO-MCQ-054','APBIO-MCQ-056','APBIO-MCQ-084','APBIO-MCQ-086',
    'APBIO-MCQ-088','APBIO-MCQ-093','APBIO-MCQ-097','APBIO-MCQ-099',
    'apphy1-mcq-021','apphy2-mcq-010','apphy2-mcq-013','apphycem-mcq-011',
    'apphycem-mcq-016','apphycm-mcq-006','apphycm-mcq-014','apphycm-mcq-020','apphycem-mcq-012'
  )
  and v.status='published' and v.review_status IN ('excluded','modification_reserved');
  if n<>0 then raise exception 'still-flagged published items after repair: %', n; end if;
end $$;

select 'repaired' metric, count(*)::text value from repaired
union all select 'published', count(*)::text from approve_set
union all select 'qa_blocked', count(*)::text from qa_blocked
union all select 'published_keys', string_agg(content_key, ', ' order by content_key) from approve_set;

commit;
