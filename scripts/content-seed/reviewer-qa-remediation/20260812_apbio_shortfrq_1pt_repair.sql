-- Short-FRQ 1-point-per-part repair, 2026-08-12.
--
-- Context: docs CED cross-check this session found the AP Biology CED specifies
-- every part (A-D) of a short FRQ (Q3-Q6, 4 points) is worth EXACTLY 1 point --
-- no exceptions. 29 items in the bank instead used a 2-criterion structure
-- ("a"=2pt, "b"=2pt), inconsistent with both the CED and this bank's own
-- already-correct convention elsewhere (see APBIO-FRQ-S-019/036/038/046/066/080/
-- 084/086/087/095/101/102/103, which already split into a1/a2/b1/b2 at 1pt each).
-- This repairs the remaining 29 to match that convention. Split content reuses
-- this session's own earlier element-decomposition drafts for these exact
-- criteria (each was already broken into two distinct sub-facts for gold-set
-- purposes before this defect was found) -- no new biology content invented.
--
-- Owner-directed: "Do everything else you recommend" (chat instruction
-- following the CED point-structure cross-check).

begin;
select pg_advisory_xact_lock(hashtext('cramapple-shortfrq-1pt-repair-20260812'));

create temporary table repair_targets (
  content_key text primary key
) on commit drop;

insert into repair_targets values
('APBIO-FRQ-S-009'),
('APBIO-FRQ-S-010'),
('APBIO-FRQ-S-011'),
('APBIO-FRQ-S-016'),
('APBIO-FRQ-S-017'),
('APBIO-FRQ-S-020'),
('APBIO-FRQ-S-021'),
('APBIO-FRQ-S-023'),
('APBIO-FRQ-S-025'),
('APBIO-FRQ-S-026'),
('APBIO-FRQ-S-028'),
('APBIO-FRQ-S-032'),
('APBIO-FRQ-S-033'),
('APBIO-FRQ-S-040'),
('APBIO-FRQ-S-047'),
('APBIO-FRQ-S-048'),
('APBIO-FRQ-S-051'),
('APBIO-FRQ-S-052'),
('APBIO-FRQ-S-058'),
('APBIO-FRQ-S-061'),
('APBIO-FRQ-S-063'),
('APBIO-FRQ-S-064'),
('APBIO-FRQ-S-068'),
('APBIO-FRQ-S-070'),
('APBIO-FRQ-S-071'),
('APBIO-FRQ-S-081'),
('APBIO-FRQ-S-089'),
('APBIO-FRQ-S-090'),
('APBIO-FRQ-S-097');

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
    where content_key=t.content_key and item_type='frq'
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
        'qa_remediation','2026-08-12 short-FRQ 1-point-per-part repair (CED cross-check)',
        'qa_source_version_id',v_old.id
      ),
      v_old.explanation,v_old.help_text,v_old.content_hash,
      'draft','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
      v_old.canonical_answer_1,v_old.canonical_answer_2,null,
      v_old.rubric_type,v_old.evaluator_strategy,v_old.stimulus_image_path
    );

    insert into repaired values (t.content_key,v_old.id,v_new);
  end loop;
end $$;


-- APBIO-FRQ-S-009
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
select r.new_version_id, x.criterion_key, x.learner_facing_text, 1, x.evidence_requirements, x.minimum_fix
from repaired r, (values
  ('a1', $q$A 5-prime 7-methylguanosine cap is added to the 5-prime end of the pre-mRNA.$q$, $q$A 5-prime 7-methylguanosine cap is added to the 5-prime end of the pre-mRNA.$q$, $q$State that a 5-prime 7-methylguanosine cap is added to the 5-prime end of the pre-mRNA.$q$),
  ('a2', $q$A poly-A tail of adenine nucleotides is added to the 3-prime end of the pre-mRNA.$q$, $q$A poly-A tail of adenine nucleotides is added to the 3-prime end of the pre-mRNA.$q$, $q$State that a poly-A tail of adenine nucleotides is added to the 3-prime end of the pre-mRNA.$q$),
  ('b1', $q$Different exons can be included or excluded from the mature mRNA in different cell types or at different developmental stages.$q$, $q$Different exons can be included or excluded from the mature mRNA in different cell types or at different developmental stages.$q$, $q$State that different exons can be included or excluded from the mature mRNA in different cell types or at different developmental stages.$q$),
  ('b2', $q$Each combination of exons produces a different mRNA, which is translated into a different polypeptide with a different amino acid sequence and potentially different function.$q$, $q$Each combination of exons produces a different mRNA, which is translated into a different polypeptide with a different amino acid sequence and potentially different function.$q$, $q$State that each combination of exons produces a different mRNA, which is translated into a different polypeptide with a different amino acid sequence and potentially different function.$q$)
) as x(criterion_key, learner_facing_text, evidence_requirements, minimum_fix)
where r.content_key = 'APBIO-FRQ-S-009';

-- APBIO-FRQ-S-010
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
select r.new_version_id, x.criterion_key, x.learner_facing_text, 1, x.evidence_requirements, x.minimum_fix
from repaired r, (values
  ('a1', $q$The bark-colored phenotype confers a higher survival and reproduction rate than the green-colored phenotype.$q$, $q$The bark-colored phenotype confers a higher survival and reproduction rate than the green-colored phenotype.$q$, $q$State that the bark-colored phenotype confers a higher survival and reproduction rate than the green-colored phenotype.$q$),
  ('a2', $q$Individuals with alleles for bark color contribute more offspring each generation, so the allele frequency for bark color increases over many generations.$q$, $q$Individuals with alleles for bark color contribute more offspring each generation, so the allele frequency for bark color increases over many generations.$q$, $q$State that individuals with alleles for bark color contribute more offspring each generation, so the allele frequency for bark color increases over many generations.$q$),
  ('b1', $q$Relative fitness is the reproductive success of a genotype or phenotype compared to the most reproductively successful phenotype in the population.$q$, $q$Relative fitness is the reproductive success of a genotype or phenotype compared to the most reproductively successful phenotype in the population.$q$, $q$State that relative fitness is the reproductive success of a genotype or phenotype compared to the most reproductively successful phenotype in the population.$q$),
  ('b2', $q$Relative fitness would be measured by comparing survival rate to reproductive age and the number of viable offspring produced by bark-colored vs. green-colored beetles per generation.$q$, $q$Relative fitness would be measured by comparing survival rate to reproductive age and the number of viable offspring produced by bark-colored vs. green-colored beetles per generation.$q$, $q$State that relative fitness would be measured by comparing survival rate to reproductive age and the number of viable offspring produced by bark-colored vs. green-colored beetles per generation.$q$)
) as x(criterion_key, learner_facing_text, evidence_requirements, minimum_fix)
where r.content_key = 'APBIO-FRQ-S-010';

-- APBIO-FRQ-S-011
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
select r.new_version_id, x.criterion_key, x.learner_facing_text, 1, x.evidence_requirements, x.minimum_fix
from repaired r, (values
  ('a1', $q$q^2 = 80/500 = 0.16, so q = 0.4 and p = 1 - 0.4 = 0.6.$q$, $q$q^2 = 80/500 = 0.16, so q = 0.4 and p = 1 - 0.4 = 0.6.$q$, $q$State that q^2 = 80/500 = 0.16, so q = 0.4 and p = 1 - 0.4 = 0.6.$q$),
  ('a2', $q$Heterozygote frequency = 2pq = 2(0.6)(0.4) = 0.48 (48%).$q$, $q$Heterozygote frequency = 2pq = 2(0.6)(0.4) = 0.48 (48%).$q$, $q$State that heterozygote frequency = 2pq = 2(0.6)(0.4) = 0.48 (48%).$q$),
  ('b1', $q$Large population size is required because it prevents genetic drift from randomly changing allele frequencies.$q$, $q$Large population size is required because it prevents genetic drift from randomly changing allele frequencies.$q$, $q$State that large population size is required because it prevents genetic drift from randomly changing allele frequencies.$q$),
  ('b2', $q$Random mating is required because it ensures allele combinations occur according to probability (no non-random pairing of genotypes).$q$, $q$Random mating is required because it ensures allele combinations occur according to probability (no non-random pairing of genotypes).$q$, $q$State that random mating is required because it ensures allele combinations occur according to probability (no non-random pairing of genotypes).$q$)
) as x(criterion_key, learner_facing_text, evidence_requirements, minimum_fix)
where r.content_key = 'APBIO-FRQ-S-011';

-- APBIO-FRQ-S-016
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
select r.new_version_id, x.criterion_key, x.learner_facing_text, 1, x.evidence_requirements, x.minimum_fix
from repaired r, (values
  ('a1', $q$Geographic isolation (the mountain range) prevents gene flow between the two populations.$q$, $q$Geographic isolation (the mountain range) prevents gene flow between the two populations.$q$, $q$State that geographic isolation (the mountain range) prevents gene flow between the two populations.$q$),
  ('a2', $q$Each population accumulates different mutations and evolves under different selection pressures until genetic differences accumulate enough that the two groups can no longer interbreed successfully even if barriers were removed.$q$, $q$Each population accumulates different mutations and evolves under different selection pressures until genetic differences accumulate enough that the two groups can no longer interbreed successfully even if barriers were removed.$q$, $q$State that each population accumulates different mutations and evolves under different selection pressures until genetic differences accumulate enough that the two groups can no longer interbreed successfully even if barriers were removed.$q$),
  ('b1', $q$Prezygotic mechanism: behavioral isolation, where different mating displays or pheromones prevent courtship between the groups.$q$, $q$Prezygotic mechanism: behavioral isolation, where different mating displays or pheromones prevent courtship between the groups.$q$, $q$State that prezygotic mechanism: behavioral isolation, where different mating displays or pheromones prevent courtship between the groups.$q$),
  ('b2', $q$Postzygotic mechanism: hybrid inviability or hybrid sterility, where hybrid offspring die before reproducing or are sterile.$q$, $q$Postzygotic mechanism: hybrid inviability or hybrid sterility, where hybrid offspring die before reproducing or are sterile.$q$, $q$State that postzygotic mechanism: hybrid inviability or hybrid sterility, where hybrid offspring die before reproducing or are sterile.$q$)
) as x(criterion_key, learner_facing_text, evidence_requirements, minimum_fix)
where r.content_key = 'APBIO-FRQ-S-016';

-- APBIO-FRQ-S-017
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
select r.new_version_id, x.criterion_key, x.learner_facing_text, 1, x.evidence_requirements, x.minimum_fix
from repaired r, (values
  ('a1', $q$Most energy consumed at each trophic level is lost as heat during cellular respiration and used for metabolism, growth, and reproduction, or excreted as waste.$q$, $q$Most energy consumed at each trophic level is lost as heat during cellular respiration and used for metabolism, growth, and reproduction, or excreted as waste.$q$, $q$State that most energy consumed at each trophic level is lost as heat during cellular respiration and used for metabolism, growth, and reproduction, or excreted as waste.$q$),
  ('a2', $q$Only the energy stored in new biomass (approximately 10%) is available to the next trophic level.$q$, $q$Only the energy stored in new biomass (approximately 10%) is available to the next trophic level.$q$, $q$State that only the energy stored in new biomass (approximately 10%) is available to the next trophic level.$q$),
  ('b1', $q$Fewer grasshoppers means less energy available to frogs, so the frog population declines.$q$, $q$Fewer grasshoppers means less energy available to frogs, so the frog population declines.$q$, $q$State that fewer grasshoppers means less energy available to frogs, so the frog population declines.$q$),
  ('b2', $q$The reduced frog population provides less energy to hawks, so the hawk population decreases (birth rate falls and/or death rate rises).$q$, $q$The reduced frog population provides less energy to hawks, so the hawk population decreases (birth rate falls and/or death rate rises).$q$, $q$State that the reduced frog population provides less energy to hawks, so the hawk population decreases (birth rate falls and/or death rate rises).$q$)
) as x(criterion_key, learner_facing_text, evidence_requirements, minimum_fix)
where r.content_key = 'APBIO-FRQ-S-017';

-- APBIO-FRQ-S-020
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
select r.new_version_id, x.criterion_key, x.learner_facing_text, 1, x.evidence_requirements, x.minimum_fix
from repaired r, (values
  ('a1', $q$Rising blood glucose above the set point is detected by pancreatic beta cells, which secrete insulin.$q$, $q$Rising blood glucose above the set point is detected by pancreatic beta cells, which secrete insulin.$q$, $q$State that rising blood glucose above the set point is detected by pancreatic beta cells, which secrete insulin.$q$),
  ('a2', $q$Insulin stimulates muscle and adipose cells to take up glucose and the liver to store it as glycogen, returning blood glucose to the set point and reducing further insulin secretion.$q$, $q$Insulin stimulates muscle and adipose cells to take up glucose and the liver to store it as glycogen, returning blood glucose to the set point and reducing further insulin secretion.$q$, $q$State that insulin stimulates muscle and adipose cells to take up glucose and the liver to store it as glycogen, returning blood glucose to the set point and reducing further insulin secretion.$q$),
  ('b1', $q$A valid example of positive feedback is childbirth: oxytocin promotes uterine contractions, and stronger contractions trigger more oxytocin release, escalating the cycle.$q$, $q$A valid example of positive feedback is childbirth: oxytocin promotes uterine contractions, and stronger contractions trigger more oxytocin release, escalating the cycle.$q$, $q$State that a valid example of positive feedback is childbirth: oxytocin promotes uterine contractions, and stronger contractions trigger more oxytocin release, escalating the cycle.$q$),
  ('b2', $q$This amplification is adaptive because it drives the process to rapid completion (e.g., delivery) rather than stalling, and it stops once the triggering event ends.$q$, $q$This amplification is adaptive because it drives the process to rapid completion (e.g., delivery) rather than stalling, and it stops once the triggering event ends.$q$, $q$State that this amplification is adaptive because it drives the process to rapid completion (e.g., delivery) rather than stalling, and it stops once the triggering event ends.$q$)
) as x(criterion_key, learner_facing_text, evidence_requirements, minimum_fix)
where r.content_key = 'APBIO-FRQ-S-020';

-- APBIO-FRQ-S-021
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
select r.new_version_id, x.criterion_key, x.learner_facing_text, 1, x.evidence_requirements, x.minimum_fix
from repaired r, (values
  ('a1', $q$A peptide bond forms between the carboxyl group of one amino acid and the amino group of the adjacent amino acid.$q$, $q$A peptide bond forms between the carboxyl group of one amino acid and the amino group of the adjacent amino acid.$q$, $q$State that a peptide bond forms between the carboxyl group of one amino acid and the amino group of the adjacent amino acid.$q$),
  ('a2', $q$This bond-forming reaction releases a water molecule (dehydration synthesis).$q$, $q$This bond-forming reaction releases a water molecule (dehydration synthesis).$q$, $q$State that this bond-forming reaction releases a water molecule (dehydration synthesis).$q$),
  ('b1', $q$A fatty acid has a long nonpolar hydrocarbon tail.$q$, $q$A fatty acid has a long nonpolar hydrocarbon tail.$q$, $q$State that a fatty acid has a long nonpolar hydrocarbon tail.$q$),
  ('b2', $q$This nonpolar tail cannot form hydrogen bonds with water, making the fatty acid hydrophobic.$q$, $q$This nonpolar tail cannot form hydrogen bonds with water, making the fatty acid hydrophobic.$q$, $q$State that this nonpolar tail cannot form hydrogen bonds with water, making the fatty acid hydrophobic.$q$)
) as x(criterion_key, learner_facing_text, evidence_requirements, minimum_fix)
where r.content_key = 'APBIO-FRQ-S-021';

-- APBIO-FRQ-S-023
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
select r.new_version_id, x.criterion_key, x.learner_facing_text, 1, x.evidence_requirements, x.minimum_fix
from repaired r, (values
  ('a1', $q$The acidic environment (pH 2) maintains the ionic and hydrogen bonds that shape pepsin's active site.$q$, $q$The acidic environment (pH 2) maintains the ionic and hydrogen bonds that shape pepsin's active site.$q$, $q$State that the acidic environment (pH 2) maintains the ionic and hydrogen bonds that shape pepsin's active site.$q$),
  ('a2', $q$This conformation optimizes the active site for substrate binding, allowing pepsin to function optimally at pH 2.$q$, $q$This conformation optimizes the active site for substrate binding, allowing pepsin to function optimally at pH 2.$q$, $q$State that this conformation optimizes the active site for substrate binding, allowing pepsin to function optimally at pH 2.$q$),
  ('b1', $q$Trypsin activity decreases or ceases at pH 2.$q$, $q$Trypsin activity decreases or ceases at pH 2.$q$, $q$State that trypsin activity decreases or ceases at pH 2.$q$),
  ('b2', $q$Low pH disrupts the hydrogen and ionic bonds maintaining trypsin's active site conformation, causing denaturation.$q$, $q$Low pH disrupts the hydrogen and ionic bonds maintaining trypsin's active site conformation, causing denaturation.$q$, $q$State that low pH disrupts the hydrogen and ionic bonds maintaining trypsin's active site conformation, causing denaturation.$q$)
) as x(criterion_key, learner_facing_text, evidence_requirements, minimum_fix)
where r.content_key = 'APBIO-FRQ-S-023';

-- APBIO-FRQ-S-025
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
select r.new_version_id, x.criterion_key, x.learner_facing_text, 1, x.evidence_requirements, x.minimum_fix
from repaired r, (values
  ('a1', $q$Breaking hydrogen bonds between water molecules requires energy input.$q$, $q$Breaking hydrogen bonds between water molecules requires energy input.$q$, $q$State that breaking hydrogen bonds between water molecules requires energy input.$q$),
  ('a2', $q$Water absorbs a large amount of heat before its temperature rises, stabilizing temperatures.$q$, $q$Water absorbs a large amount of heat before its temperature rises, stabilizing temperatures.$q$, $q$State that water absorbs a large amount of heat before its temperature rises, stabilizing temperatures.$q$),
  ('b1', $q$Polar water molecules surround and separate ions in solution.$q$, $q$Polar water molecules surround and separate ions in solution.$q$, $q$State that polar water molecules surround and separate ions in solution.$q$),
  ('b2', $q$The positive (hydrogen) ends of water attract Cl-, and the negative (oxygen) ends attract Na+.$q$, $q$The positive (hydrogen) ends of water attract Cl-, and the negative (oxygen) ends attract Na+.$q$, $q$State that the positive (hydrogen) ends of water attract Cl-, and the negative (oxygen) ends attract Na+.$q$)
) as x(criterion_key, learner_facing_text, evidence_requirements, minimum_fix)
where r.content_key = 'APBIO-FRQ-S-025';

-- APBIO-FRQ-S-026
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
select r.new_version_id, x.criterion_key, x.learner_facing_text, 1, x.evidence_requirements, x.minimum_fix
from repaired r, (values
  ('a1', $q$Identifies two structures present in plant cells but absent in bacterial cells (e.g., nucleus, mitochondria, chloroplast, ER, Golgi, vacuole).$q$, $q$Identifies two structures present in plant cells but absent in bacterial cells (e.g., nucleus, mitochondria, chloroplast, ER, Golgi, vacuole).$q$, $q$Identify two structures present in plant cells but absent in bacterial cells (e.g., nucleus, mitochondria, chloroplast, ER, Golgi, vacuole).$q$),
  ('a2', $q$Explains the function of one of the identified structures (e.g., the nucleus houses DNA for gene regulation).$q$, $q$Explains the function of one of the identified structures (e.g., the nucleus houses DNA for gene regulation).$q$, $q$Explain the function of one of the identified structures (e.g., the nucleus houses DNA for gene regulation).$q$),
  ('b1', $q$Lacking membrane-bound organelles reduces the energy and material cost of building the cell.$q$, $q$Lacking membrane-bound organelles reduces the energy and material cost of building the cell.$q$, $q$State that lacking membrane-bound organelles reduces the energy and material cost of building the cell.$q$),
  ('b2', $q$The simpler cell structure allows prokaryotes to replicate faster.$q$, $q$The simpler cell structure allows prokaryotes to replicate faster.$q$, $q$State that the simpler cell structure allows prokaryotes to replicate faster.$q$)
) as x(criterion_key, learner_facing_text, evidence_requirements, minimum_fix)
where r.content_key = 'APBIO-FRQ-S-026';

-- APBIO-FRQ-S-028
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
select r.new_version_id, x.criterion_key, x.learner_facing_text, 1, x.evidence_requirements, x.minimum_fix
from repaired r, (values
  ('a1', $q$Identifies one piece of evidence for endosymbiotic origin (e.g., double membrane or similar size to bacteria).$q$, $q$Identifies one piece of evidence for endosymbiotic origin (e.g., double membrane or similar size to bacteria).$q$, $q$Identify one piece of evidence for endosymbiotic origin (e.g., double membrane or similar size to bacteria).$q$),
  ('a2', $q$Identifies a second piece of evidence (e.g., own circular DNA, 70S ribosomes, or division by binary fission).$q$, $q$Identifies a second piece of evidence (e.g., own circular DNA, 70S ribosomes, or division by binary fission).$q$, $q$Identify a second piece of evidence (e.g., own circular DNA, 70S ribosomes, or division by binary fission).$q$),
  ('b1', $q$The outer mitochondrial membrane is derived from the host cell's engulfment vesicle.$q$, $q$The outer mitochondrial membrane is derived from the host cell's engulfment vesicle.$q$, $q$State that the outer mitochondrial membrane is derived from the host cell's engulfment vesicle.$q$),
  ('b2', $q$The inner mitochondrial membrane is the original bacterial plasma membrane.$q$, $q$The inner mitochondrial membrane is the original bacterial plasma membrane.$q$, $q$State that the inner mitochondrial membrane is the original bacterial plasma membrane.$q$)
) as x(criterion_key, learner_facing_text, evidence_requirements, minimum_fix)
where r.content_key = 'APBIO-FRQ-S-028';

-- APBIO-FRQ-S-032
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
select r.new_version_id, x.criterion_key, x.learner_facing_text, 1, x.evidence_requirements, x.minimum_fix
from repaired r, (values
  ('a1', $q$Glucose is a large, polar molecule.$q$, $q$Glucose is a large, polar molecule.$q$, $q$State that glucose is a large, polar molecule.$q$),
  ('a2', $q$The hydrophobic interior of the phospholipid bilayer repels polar molecules like glucose.$q$, $q$The hydrophobic interior of the phospholipid bilayer repels polar molecules like glucose.$q$, $q$State that the hydrophobic interior of the phospholipid bilayer repels polar molecules like glucose.$q$),
  ('b1', $q$Facilitated diffusion moves molecules down their concentration gradient without using ATP.$q$, $q$Facilitated diffusion moves molecules down their concentration gradient without using ATP.$q$, $q$State that facilitated diffusion moves molecules down their concentration gradient without using ATP.$q$),
  ('b2', $q$Active transport moves molecules against their concentration gradient and requires ATP.$q$, $q$Active transport moves molecules against their concentration gradient and requires ATP.$q$, $q$State that active transport moves molecules against their concentration gradient and requires ATP.$q$)
) as x(criterion_key, learner_facing_text, evidence_requirements, minimum_fix)
where r.content_key = 'APBIO-FRQ-S-032';

-- APBIO-FRQ-S-033
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
select r.new_version_id, x.criterion_key, x.learner_facing_text, 1, x.evidence_requirements, x.minimum_fix
from repaired r, (values
  ('a1', $q$The ligand binds to a specific receptor on the cell membrane.$q$, $q$The ligand binds to a specific receptor on the cell membrane.$q$, $q$State that the ligand binds to a specific receptor on the cell membrane.$q$),
  ('a2', $q$The membrane invaginates and a vesicle pinches off, carrying the ligand into the cytoplasm.$q$, $q$The membrane invaginates and a vesicle pinches off, carrying the ligand into the cytoplasm.$q$, $q$State that the membrane invaginates and a vesicle pinches off, carrying the ligand into the cytoplasm.$q$),
  ('b1', $q$Only molecules that match the shape of a specific cell-surface receptor bind and are taken up.$q$, $q$Only molecules that match the shape of a specific cell-surface receptor bind and are taken up.$q$, $q$State that only molecules that match the shape of a specific cell-surface receptor bind and are taken up.$q$),
  ('b2', $q$This selective binding gives the cell control over which molecules enter, unlike non-specific uptake.$q$, $q$This selective binding gives the cell control over which molecules enter, unlike non-specific uptake.$q$, $q$State that this selective binding gives the cell control over which molecules enter, unlike non-specific uptake.$q$)
) as x(criterion_key, learner_facing_text, evidence_requirements, minimum_fix)
where r.content_key = 'APBIO-FRQ-S-033';

-- APBIO-FRQ-S-040
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
select r.new_version_id, x.criterion_key, x.learner_facing_text, 1, x.evidence_requirements, x.minimum_fix
from repaired r, (values
  ('a1', $q$Ligand binding causes two RTK monomers to dimerize.$q$, $q$Ligand binding causes two RTK monomers to dimerize.$q$, $q$State that ligand binding causes two RTK monomers to dimerize.$q$),
  ('a2', $q$The dimerized RTKs autophosphorylate tyrosine residues, creating docking sites for relay proteins.$q$, $q$The dimerized RTKs autophosphorylate tyrosine residues, creating docking sites for relay proteins.$q$, $q$State that the dimerized RTKs autophosphorylate tyrosine residues, creating docking sites for relay proteins.$q$),
  ('b1', $q$A permanently active RTK sends continuous growth signals even without growth factor present.$q$, $q$A permanently active RTK sends continuous growth signals even without growth factor present.$q$, $q$State that a permanently active RTK sends continuous growth signals even without growth factor present.$q$),
  ('b2', $q$This continuous signaling drives uncontrolled cell division, a hallmark of cancer.$q$, $q$This continuous signaling drives uncontrolled cell division, a hallmark of cancer.$q$, $q$State that this continuous signaling drives uncontrolled cell division, a hallmark of cancer.$q$)
) as x(criterion_key, learner_facing_text, evidence_requirements, minimum_fix)
where r.content_key = 'APBIO-FRQ-S-040';

-- APBIO-FRQ-S-047
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
select r.new_version_id, x.criterion_key, x.learner_facing_text, 1, x.evidence_requirements, x.minimum_fix
from repaired r, (values
  ('a1', $q$Neither the red nor white allele completely masks the other (no dominance).$q$, $q$Neither the red nor white allele completely masks the other (no dominance).$q$, $q$State that neither the red nor white allele completely masks the other (no dominance).$q$),
  ('a2', $q$The heterozygote produces an intermediate amount of red pigment, resulting in a pink phenotype.$q$, $q$The heterozygote produces an intermediate amount of red pigment, resulting in a pink phenotype.$q$, $q$State that the heterozygote produces an intermediate amount of red pigment, resulting in a pink phenotype.$q$),
  ('b1', $q$The cross RW x RW produces genotypes in a 1 RR : 2 RW : 1 WW ratio.$q$, $q$The cross RW x RW produces genotypes in a 1 RR : 2 RW : 1 WW ratio.$q$, $q$State that the cross RW x RW produces genotypes in a 1 RR : 2 RW : 1 WW ratio.$q$),
  ('b2', $q$This corresponds to a 1:2:1 phenotypic ratio of red : pink : white.$q$, $q$This corresponds to a 1:2:1 phenotypic ratio of red : pink : white.$q$, $q$State that this corresponds to a 1:2:1 phenotypic ratio of red : pink : white.$q$)
) as x(criterion_key, learner_facing_text, evidence_requirements, minimum_fix)
where r.content_key = 'APBIO-FRQ-S-047';

-- APBIO-FRQ-S-048
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
select r.new_version_id, x.criterion_key, x.learner_facing_text, 1, x.evidence_requirements, x.minimum_fix
from repaired r, (values
  ('a1', $q$In codominance, both alleles are fully expressed (e.g., type AB blood has both A and B antigens).$q$, $q$In codominance, both alleles are fully expressed (e.g., type AB blood has both A and B antigens).$q$, $q$State that in codominance, both alleles are fully expressed (e.g., type AB blood has both A and B antigens).$q$),
  ('a2', $q$In incomplete dominance, neither allele is fully expressed, producing an intermediate phenotype.$q$, $q$In incomplete dominance, neither allele is fully expressed, producing an intermediate phenotype.$q$, $q$State that in incomplete dominance, neither allele is fully expressed, producing an intermediate phenotype.$q$),
  ('b1', $q$The cross can produce genotypes I^A I^B (type AB) and I^A i (type A).$q$, $q$The cross can produce genotypes I^A I^B (type AB) and I^A i (type A).$q$, $q$State that the cross can produce genotypes I^A I^B (type AB) and I^A i (type A).$q$),
  ('b2', $q$The cross can also produce genotypes I^B i (type B) and ii (type O).$q$, $q$The cross can also produce genotypes I^B i (type B) and ii (type O).$q$, $q$State that the cross can also produce genotypes I^B i (type B) and ii (type O).$q$)
) as x(criterion_key, learner_facing_text, evidence_requirements, minimum_fix)
where r.content_key = 'APBIO-FRQ-S-048';

-- APBIO-FRQ-S-051
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
select r.new_version_id, x.criterion_key, x.learner_facing_text, 1, x.evidence_requirements, x.minimum_fix
from repaired r, (values
  ('a1', $q$Both homologous chromosomes go into the same cell during meiosis I nondisjunction.$q$, $q$Both homologous chromosomes go into the same cell during meiosis I nondisjunction.$q$, $q$State that both homologous chromosomes go into the same cell during meiosis I nondisjunction.$q$),
  ('a2', $q$This produces gametes with an extra chromosome (n+1) and gametes missing a chromosome (n-1).$q$, $q$This produces gametes with an extra chromosome (n+1) and gametes missing a chromosome (n-1).$q$, $q$State that this produces gametes with an extra chromosome (n+1) and gametes missing a chromosome (n-1).$q$),
  ('b1', $q$Chromosome 21 is the smallest autosome and carries the fewest genes.$q$, $q$Chromosome 21 is the smallest autosome and carries the fewest genes.$q$, $q$State that chromosome 21 is the smallest autosome and carries the fewest genes.$q$),
  ('b2', $q$Triplication of larger chromosomes disrupts too many genes to be viable, making most other trisomies lethal.$q$, $q$Triplication of larger chromosomes disrupts too many genes to be viable, making most other trisomies lethal.$q$, $q$State that triplication of larger chromosomes disrupts too many genes to be viable, making most other trisomies lethal.$q$)
) as x(criterion_key, learner_facing_text, evidence_requirements, minimum_fix)
where r.content_key = 'APBIO-FRQ-S-051';

-- APBIO-FRQ-S-052
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
select r.new_version_id, x.criterion_key, x.learner_facing_text, 1, x.evidence_requirements, x.minimum_fix
from repaired r, (values
  ('a1', $q$Transcription factors bind to the promoter (TATA box).$q$, $q$Transcription factors bind to the promoter (TATA box).$q$, $q$State that transcription factors bind to the promoter (TATA box).$q$),
  ('a2', $q$RNA polymerase is recruited to the complex and unwinds the DNA to begin RNA synthesis.$q$, $q$RNA polymerase is recruited to the complex and unwinds the DNA to begin RNA synthesis.$q$, $q$State that RNA polymerase is recruited to the complex and unwinds the DNA to begin RNA synthesis.$q$),
  ('b1', $q$The 5' cap protects mRNA from degradation and assists ribosome binding.$q$, $q$The 5' cap protects mRNA from degradation and assists ribosome binding.$q$, $q$State that the 5' cap protects mRNA from degradation and assists ribosome binding.$q$),
  ('b2', $q$The poly-A tail protects mRNA from degradation and aids nuclear export.$q$, $q$The poly-A tail protects mRNA from degradation and aids nuclear export.$q$, $q$State that the poly-A tail protects mRNA from degradation and aids nuclear export.$q$)
) as x(criterion_key, learner_facing_text, evidence_requirements, minimum_fix)
where r.content_key = 'APBIO-FRQ-S-052';

-- APBIO-FRQ-S-058
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
select r.new_version_id, x.criterion_key, x.learner_facing_text, 1, x.evidence_requirements, x.minimum_fix
from repaired r, (values
  ('a1', $q$A bottleneck drastically reduces population size, causing allele frequencies to shift by chance.$q$, $q$A bottleneck drastically reduces population size, causing allele frequencies to shift by chance.$q$, $q$State that a bottleneck drastically reduces population size, causing allele frequencies to shift by chance.$q$),
  ('a2', $q$Rare alleles may be lost entirely while common alleles become overrepresented in survivors.$q$, $q$Rare alleles may be lost entirely while common alleles become overrepresented in survivors.$q$, $q$State that rare alleles may be lost entirely while common alleles become overrepresented in survivors.$q$),
  ('b1', $q$With less genetic variation, individuals in the population are more genetically similar to one another.$q$, $q$With less genetic variation, individuals in the population are more genetically similar to one another.$q$, $q$State that with less genetic variation, individuals in the population are more genetically similar to one another.$q$),
  ('b2', $q$If a new disease or environmental change occurs, most individuals may be similarly susceptible, threatening the population.$q$, $q$If a new disease or environmental change occurs, most individuals may be similarly susceptible, threatening the population.$q$, $q$State that if a new disease or environmental change occurs, most individuals may be similarly susceptible, threatening the population.$q$)
) as x(criterion_key, learner_facing_text, evidence_requirements, minimum_fix)
where r.content_key = 'APBIO-FRQ-S-058';

-- APBIO-FRQ-S-061
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
select r.new_version_id, x.criterion_key, x.learner_facing_text, 1, x.evidence_requirements, x.minimum_fix
from repaired r, (values
  ('a1', $q$A geographic barrier prevents gene flow between the two populations.$q$, $q$A geographic barrier prevents gene flow between the two populations.$q$, $q$State that a geographic barrier prevents gene flow between the two populations.$q$),
  ('a2', $q$Each population independently accumulates different mutations and adaptations until reproductively isolated.$q$, $q$Each population independently accumulates different mutations and adaptations until reproductively isolated.$q$, $q$State that each population independently accumulates different mutations and adaptations until reproductively isolated.$q$),
  ('b1', $q$Identifies one mechanism of reproductive isolation (prezygotic: mating call/timing/habitat differences, or postzygotic: hybrid inviability/sterility).$q$, $q$Identifies one mechanism of reproductive isolation (prezygotic: mating call/timing/habitat differences, or postzygotic: hybrid inviability/sterility).$q$, $q$Identify one mechanism of reproductive isolation (prezygotic: mating call/timing/habitat differences, or postzygotic: hybrid inviability/sterility).$q$),
  ('b2', $q$Explains how that mechanism specifically prevents the two populations from successfully interbreeding.$q$, $q$Explains how that mechanism specifically prevents the two populations from successfully interbreeding.$q$, $q$Explain how that mechanism specifically prevents the two populations from successfully interbreeding.$q$)
) as x(criterion_key, learner_facing_text, evidence_requirements, minimum_fix)
where r.content_key = 'APBIO-FRQ-S-061';

-- APBIO-FRQ-S-063
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
select r.new_version_id, x.criterion_key, x.learner_facing_text, 1, x.evidence_requirements, x.minimum_fix
from repaired r, (values
  ('a1', $q$States energy is lost as heat through cellular respiration$q$, $q$States energy is lost as heat through cellular respiration$q$, $q$State energy is lost as heat through cellular respiration$q$),
  ('a2', $q$States energy is lost via movement and/or undigested material excreted as waste$q$, $q$States energy is lost via movement and/or undigested material excreted as waste$q$, $q$State energy is lost via movement and/or undigested material excreted as waste$q$),
  ('b1', $q$Correctly applies the 10% rule at each trophic transfer (birds need 100 kJ, caterpillars need 1000 kJ)$q$, $q$Correctly applies the 10% rule at each trophic transfer (birds need 100 kJ, caterpillars need 1000 kJ)$q$, $q$Correctly apply the 10% rule at each trophic transfer (birds need 100 kJ, caterpillars need 1000 kJ)$q$),
  ('b2', $q$Calculates the final plant energy requirement of 10,000 kJ to support the hawk$q$, $q$Calculates the final plant energy requirement of 10,000 kJ to support the hawk$q$, $q$Calculate the final plant energy requirement of 10,000 kJ to support the hawk$q$)
) as x(criterion_key, learner_facing_text, evidence_requirements, minimum_fix)
where r.content_key = 'APBIO-FRQ-S-063';

-- APBIO-FRQ-S-064
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
select r.new_version_id, x.criterion_key, x.learner_facing_text, 1, x.evidence_requirements, x.minimum_fix
from repaired r, (values
  ('a1', $q$States excess nitrogen causes an algal bloom, and the algae subsequently die$q$, $q$States excess nitrogen causes an algal bloom, and the algae subsequently die$q$, $q$State excess nitrogen causes an algal bloom, and the algae subsequently die$q$),
  ('a2', $q$States decomposers consume oxygen breaking down the dead algae, depleting O2 and causing fish/other organisms to die$q$, $q$States decomposers consume oxygen breaking down the dead algae, depleting O2 and causing fish/other organisms to die$q$, $q$State decomposers consume oxygen breaking down the dead algae, depleting O2 and causing fish/other organisms to die$q$),
  ('b1', $q$Identifies algae as primary producers (trophic level 1)$q$, $q$Identifies algae as primary producers (trophic level 1)$q$, $q$Identify algae as primary producers (trophic level 1)$q$),
  ('b2', $q$States algae fix solar/light energy into organic matter via photosynthesis$q$, $q$States algae fix solar/light energy into organic matter via photosynthesis$q$, $q$State algae fix solar/light energy into organic matter via photosynthesis$q$)
) as x(criterion_key, learner_facing_text, evidence_requirements, minimum_fix)
where r.content_key = 'APBIO-FRQ-S-064';

-- APBIO-FRQ-S-068
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
select r.new_version_id, x.criterion_key, x.learner_facing_text, 1, x.evidence_requirements, x.minimum_fix
from repaired r, (values
  ('a1', $q$Classifies the relationship as commensalism (+/0)$q$, $q$Classifies the relationship as commensalism (+/0)$q$, $q$Classify the relationship as commensalism (+/0)$q$),
  ('a2', $q$States barnacles benefit from improved access to nutrient-rich water while the whale is neither helped nor harmed$q$, $q$States barnacles benefit from improved access to nutrient-rich water while the whale is neither helped nor harmed$q$, $q$State barnacles benefit from improved access to nutrient-rich water while the whale is neither helped nor harmed$q$),
  ('b1', $q$Names a valid example of mutualism (e.g., bees and flowers, mycorrhizae and plants, or nitrogen-fixing bacteria and legumes)$q$, $q$Names a valid example of mutualism (e.g., bees and flowers, mycorrhizae and plants, or nitrogen-fixing bacteria and legumes)$q$, $q$Name a valid example of mutualism (e.g., bees and flowers, mycorrhizae and plants, or nitrogen-fixing bacteria and legumes)$q$),
  ('b2', $q$States that both species benefit in a mutualistic relationship, unlike commensalism$q$, $q$States that both species benefit in a mutualistic relationship, unlike commensalism$q$, $q$State that both species benefit in a mutualistic relationship, unlike commensalism$q$)
) as x(criterion_key, learner_facing_text, evidence_requirements, minimum_fix)
where r.content_key = 'APBIO-FRQ-S-068';

-- APBIO-FRQ-S-070
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
select r.new_version_id, x.criterion_key, x.learner_facing_text, 1, x.evidence_requirements, x.minimum_fix
from repaired r, (values
  ('a1', $q$States more moose provide more food for wolves, so the wolf population increases and predation on moose rises$q$, $q$States more moose provide more food for wolves, so the wolf population increases and predation on moose rises$q$, $q$State more moose provide more food for wolves, so the wolf population increases and predation on moose rises$q$),
  ('a2', $q$States increased predation reduces moose, causing wolves to decline, which allows moose to recover and the cycle to repeat$q$, $q$States increased predation reduces moose, causing wolves to decline, which allows moose to recover and the cycle to repeat$q$, $q$State increased predation reduces moose, causing wolves to decline, which allows moose to recover and the cycle to repeat$q$),
  ('b1', $q$States moose population would increase rapidly and overshoot carrying capacity (K) without wolf predation$q$, $q$States moose population would increase rapidly and overshoot carrying capacity (K) without wolf predation$q$, $q$State moose population would increase rapidly and overshoot carrying capacity (K) without wolf predation$q$),
  ('b2', $q$States the population would then decline due to overgrazing and/or starvation$q$, $q$States the population would then decline due to overgrazing and/or starvation$q$, $q$State the population would then decline due to overgrazing and/or starvation$q$)
) as x(criterion_key, learner_facing_text, evidence_requirements, minimum_fix)
where r.content_key = 'APBIO-FRQ-S-070';

-- APBIO-FRQ-S-071
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
select r.new_version_id, x.criterion_key, x.learner_facing_text, 1, x.evidence_requirements, x.minimum_fix
from repaired r, (values
  ('a1', $q$States water moves from the soil into the plant cell$q$, $q$States water moves from the soil into the plant cell$q$, $q$State water moves from the soil into the plant cell$q$),
  ('a2', $q$States this movement is by osmosis, from higher/less negative water potential (soil) to lower/more negative water potential (cell)$q$, $q$States this movement is by osmosis, from higher/less negative water potential (soil) to lower/more negative water potential (cell)$q$, $q$State this movement is by osmosis, from higher/less negative water potential (soil) to lower/more negative water potential (cell)$q$),
  ('b1', $q$States turgor pressure increases as water enters the cell$q$, $q$States turgor pressure increases as water enters the cell$q$, $q$State turgor pressure increases as water enters the cell$q$),
  ('b2', $q$States increased turgor pressure raises the cell's water potential, reducing the gradient and slowing water uptake until equilibrium$q$, $q$States increased turgor pressure raises the cell's water potential, reducing the gradient and slowing water uptake until equilibrium$q$, $q$State increased turgor pressure raises the cell's water potential, reducing the gradient and slowing water uptake until equilibrium$q$)
) as x(criterion_key, learner_facing_text, evidence_requirements, minimum_fix)
where r.content_key = 'APBIO-FRQ-S-071';

-- APBIO-FRQ-S-081
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
select r.new_version_id, x.criterion_key, x.learner_facing_text, 1, x.evidence_requirements, x.minimum_fix
from repaired r, (values
  ('a1', $q$States somatic cells are body cells that are not passed on to offspring$q$, $q$States somatic cells are body cells that are not passed on to offspring$q$, $q$State somatic cells are body cells that are not passed on to offspring$q$),
  ('a2', $q$States only mutations in gametes (egg or sperm) are heritable$q$, $q$States only mutations in gametes (egg or sperm) are heritable$q$, $q$State only mutations in gametes (egg or sperm) are heritable$q$),
  ('b1', $q$States a proto-oncogene mutation causes overactive/uncontrolled growth signaling (stuck "gas pedal")$q$, $q$States a proto-oncogene mutation causes overactive/uncontrolled growth signaling (stuck "gas pedal")$q$, $q$State a proto-oncogene mutation causes overactive/uncontrolled growth signaling (stuck "gas pedal")$q$),
  ('b2', $q$States a tumor suppressor mutation removes the ability to halt division (lost "brake"), and both mutations together are needed to bypass cell cycle controls$q$, $q$States a tumor suppressor mutation removes the ability to halt division (lost "brake"), and both mutations together are needed to bypass cell cycle controls$q$, $q$State a tumor suppressor mutation removes the ability to halt division (lost "brake"), and both mutations together are needed to bypass cell cycle controls$q$)
) as x(criterion_key, learner_facing_text, evidence_requirements, minimum_fix)
where r.content_key = 'APBIO-FRQ-S-081';

-- APBIO-FRQ-S-089
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
select r.new_version_id, x.criterion_key, x.learner_facing_text, 1, x.evidence_requirements, x.minimum_fix
from repaired r, (values
  ('a1', $q$States the biological species concept: organisms that can interbreed and produce viable (fertile) offspring are the same species$q$, $q$States the biological species concept: organisms that can interbreed and produce viable (fertile) offspring are the same species$q$, $q$State the biological species concept: organisms that can interbreed and produce viable (fertile) offspring are the same species$q$),
  ('a2', $q$Concludes the two moth populations are one species because they can still interbreed$q$, $q$Concludes the two moth populations are one species because they can still interbreed$q$, $q$Conclude the two moth populations are one species because they can still interbreed$q$),
  ('b1', $q$States the river prevents migration between populations, stopping gene flow$q$, $q$States the river prevents migration between populations, stopping gene flow$q$, $q$State the river prevents migration between populations, stopping gene flow$q$),
  ('b2', $q$States each population then independently accumulates different mutations/adaptations via selection and genetic drift, which can lead to speciation$q$, $q$States each population then independently accumulates different mutations/adaptations via selection and genetic drift, which can lead to speciation$q$, $q$State each population then independently accumulates different mutations/adaptations via selection and genetic drift, which can lead to speciation$q$)
) as x(criterion_key, learner_facing_text, evidence_requirements, minimum_fix)
where r.content_key = 'APBIO-FRQ-S-089';

-- APBIO-FRQ-S-090
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
select r.new_version_id, x.criterion_key, x.learner_facing_text, 1, x.evidence_requirements, x.minimum_fix
from repaired r, (values
  ('a1', $q$Defines GPP as total energy fixed by photosynthesis and NPP as GPP minus energy used in autotroph respiration$q$, $q$Defines GPP as total energy fixed by photosynthesis and NPP as GPP minus energy used in autotroph respiration$q$, $q$Define GPP as total energy fixed by photosynthesis and NPP as GPP minus energy used in autotroph respiration$q$),
  ('a2', $q$States only NPP energy is stored as biomass and available to consumers$q$, $q$States only NPP energy is stored as biomass and available to consumers$q$, $q$State only NPP energy is stored as biomass and available to consumers$q$),
  ('b1', $q$States reduced light lowers the rate of photosynthesis, causing both GPP and NPP to fall$q$, $q$States reduced light lowers the rate of photosynthesis, causing both GPP and NPP to fall$q$, $q$State reduced light lowers the rate of photosynthesis, causing both GPP and NPP to fall$q$),
  ('b2', $q$States this reduces the energy available to support consumer populations$q$, $q$States this reduces the energy available to support consumer populations$q$, $q$State this reduces the energy available to support consumer populations$q$)
) as x(criterion_key, learner_facing_text, evidence_requirements, minimum_fix)
where r.content_key = 'APBIO-FRQ-S-090';

-- APBIO-FRQ-S-097
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
select r.new_version_id, x.criterion_key, x.learner_facing_text, 1, x.evidence_requirements, x.minimum_fix
from repaired r, (values
  ('a1', $q$States the guide RNA contains a ~20-nucleotide sequence complementary to the target DNA$q$, $q$States the guide RNA contains a ~20-nucleotide sequence complementary to the target DNA$q$, $q$State the guide RNA contains a ~20-nucleotide sequence complementary to the target DNA$q$),
  ('a2', $q$States the guide RNA base-pairs with the target DNA strand, positioning Cas9 to cut at that site$q$, $q$States the guide RNA base-pairs with the target DNA strand, positioning Cas9 to cut at that site$q$, $q$State the guide RNA base-pairs with the target DNA strand, positioning Cas9 to cut at that site$q$),
  ('b1', $q$States the tumor suppressor gene normally halts cell division in response to DNA damage or errors$q$, $q$States the tumor suppressor gene normally halts cell division in response to DNA damage or errors$q$, $q$State the tumor suppressor gene normally halts cell division in response to DNA damage or errors$q$),
  ('b2', $q$States that without the tumor suppressor, damaged cells proliferate unchecked, leading to tumor formation$q$, $q$States that without the tumor suppressor, damaged cells proliferate unchecked, leading to tumor formation$q$, $q$State that without the tumor suppressor, damaged cells proliferate unchecked, leading to tumor formation$q$)
) as x(criterion_key, learner_facing_text, evidence_requirements, minimum_fix)
where r.content_key = 'APBIO-FRQ-S-097';


update app.content_item_versions civ
set content_hash = md5(coalesce(civ.stem,'')||E'\n'||coalesce(civ.stimulus,'')||E'\n'||
  coalesce((select string_agg(fc.criterion_key||':'||fc.learner_facing_text||':'||fc.points_possible::text, E'\n' order by fc.criterion_key)
            from app.frq_criteria fc where fc.content_item_version_id=civ.id),''))
from repaired r where civ.id=r.new_version_id;

create temporary table qa_blocked as
select r.content_key,
  case
    when (select count(*) from app.frq_criteria fc where fc.content_item_version_id=civ.id) <> 4 then 'expected 4 criteria'
    when (select sum(fc.points_possible) from app.frq_criteria fc where fc.content_item_version_id=civ.id) <> 4 then 'points do not sum to 4'
    when exists (select 1 from app.frq_criteria fc where fc.content_item_version_id=civ.id and nullif(trim(fc.learner_facing_text),'') is null) then 'blank criterion text'
    when exists (select 1 from app.content_item_versions other where other.content_item_id=civ.content_item_id and other.id<>civ.id and other.status='published') then 'competing published version'
  end reason
from repaired r
join app.content_item_versions civ on civ.id=r.new_version_id;
delete from qa_blocked where reason is null;

create temporary table approve_set on commit drop as
select r.content_key, r.new_version_id
from repaired r
where not exists (select 1 from qa_blocked b where b.content_key=r.content_key);

insert into app.content_review_assignments (
  content_review_assignment_id, content_item_version_id, reviewer_id,
  review_stage, review_kind, status, assignment_purpose, created_by
)
select gen_random_uuid(),new_version_id,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
       'tutor_question','frq','pending','owner_remediation_approval','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from approve_set;

insert into app.content_review_decisions (
  content_review_assignment_id,content_item_version_id,reviewer_id,
  review_stage,tutor_score,difficulty_label,diagnostic_flag,
  concern_codes,note,tutor_decision,decision_payload,
  decision_hash,created_by
)
select cra.content_review_assignment_id,p.new_version_id,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
       'tutor_question',1,'Medium',false,array[]::text[],
       'Owner-directed short-FRQ 1-point-per-part repair, 2026-08-12: split the item''s 2-point a/b criteria into 1-point-each a1/a2/b1/b2 per the AP Biology CED (every short-FRQ part is exactly 1 point). Content unchanged in substance -- ' || p.content_key,
       'approve',
       jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','shortfrq_1pt_repair','content_key',p.content_key,'qa_date','2026-08-12'),
       encode(extensions.digest(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','shortfrq_1pt_repair','content_key',p.content_key,'qa_date','2026-08-12')::text,'sha256'),'hex'),
       'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from approve_set p
join app.content_review_assignments cra on cra.content_item_version_id=p.new_version_id and cra.assignment_purpose='owner_remediation_approval' and cra.status='pending';

update app.content_item_versions civ
set status='reviewed_approved', review_status='question_review_approved',
    approved_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
    approved_at=coalesce(civ.approved_at,now()), updated_at=now()
from approve_set p where civ.id=p.new_version_id;

update app.content_items ci
set status='reviewed_approved', updated_at=now()
from approve_set p join app.content_item_versions civ on civ.id=p.new_version_id
where ci.id=civ.content_item_id;

update app.content_item_versions civ
set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now()
from approve_set p where civ.id=p.new_version_id;

update app.content_items ci
set status='published', updated_at=now()
from approve_set p join app.content_item_versions civ on civ.id=p.new_version_id
where ci.id=civ.content_item_id;

do $$
declare n integer;
begin
  select count(*) into n from repaired;
  if n<>29 then raise exception 'expected 29 repaired items, got %', n; end if;

  select count(*) into n from qa_blocked;
  if n<>0 then raise exception 'short-FRQ repair blocked by structural QA gate: %',
    (select string_agg(content_key||':'||reason, ', ' order by content_key) from qa_blocked);
  end if;

  select count(*) into n from approve_set;
  if n<>29 then raise exception 'expected 29 approved+published items, got %', n; end if;

  select count(*) into n from (
    select content_item_id from app.content_item_versions where status='published'
    group by content_item_id having count(*)>1
  ) d;
  if n<>0 then raise exception 'duplicate published versions after short-FRQ repair: %', n; end if;
end $$;

select 'repaired' metric, count(*)::text value from repaired
union all select 'published', count(*)::text from approve_set
union all select 'qa_blocked', count(*)::text from qa_blocked
union all select 'published_keys', string_agg(content_key, ', ' order by content_key) from approve_set;

commit;
