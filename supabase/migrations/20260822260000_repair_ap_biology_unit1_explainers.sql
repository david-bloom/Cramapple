begin;

-- Repair AP Biology Unit 1 (Chemistry of Life) Learn More explainers -- all 7
-- were template-generated debt (core_idea verbatim-matching their brief's
-- what_it_is, and mini_example_question / weak_answer shared boilerplate
-- duplicated across ~150 other rows corpus-wide, per the 2026-08-21 bulk
-- audit; the exact weak_answer "I would name the biology term and give a
-- general statement." appears on 60 different AP Biology rows alone).
-- Confirmed via SQL before authoring: all 7 rows carried source_note
-- 'generated-from-brief:legacy; grandfathered-2026-08-21' with no
-- "repaired" marker, and a direct read of the current rows showed core_idea
-- byte-identical to the paired brief's what_it_is on every row, plus the
-- exact boilerplate weak_answer and mini_example_question (title-
-- interpolation template: "A free-response prompt asks you to explain an
-- observed biological pattern using <Title>. What should your answer make
-- explicit?") on every row -- so all 7 are genuine debt; none were an
-- outlier that already had hand-authored content. Briefs for this unit are
-- genuinely hand-authored and correct; NOT touched here.
--
-- Grounded in docs/product/AP_BIOLOGY_CED_FACT_PACK.md Unit 1 section
-- (starting line 317): 1.1's specific-heat/heat-of-vaporization mechanism
-- (breaking many hydrogen bonds absorbs a lot of energy, giving water
-- thermal stability and evaporative cooling), applied to a sweating/
-- evaporative-cooling worked example; 1.2's specific element-to-
-- macromolecule mapping (phosphorus in nucleic acids AND phospholipids,
-- nitrogen in nucleic acids and amino acids, sulfur in certain proteins),
-- applied to a phosphorus-in-DNA-vs-phospholipids contrast; 1.3's precise
-- water-addition-vs-removal directionality (dehydration synthesis releases
-- one water molecule per bond formed; hydrolysis adds one water molecule
-- per bond broken, with H going to one monomer and OH to the other),
-- applied to a maltose-hydrolysis worked example; 1.4's linear-vs-branched
-- polysaccharide organization fact plus its explicit exclusion of specific
-- carbohydrate polymer molecular structure, applied to a starch-vs-
-- cellulose (same monomer, different organization, different function)
-- contrast; 1.5's saturated-vs-unsaturated fatty acid structure fact
-- (double bonds cause kinks that prevent tight packing, so more
-- unsaturated fat stays liquid at room temperature) plus its exclusion of
-- specific lipid molecular structure, applied to a butter-vs-olive-oil
-- worked example; 1.6's base-pairing rules (A-T and C-G in DNA, A-U in
-- RNA), antiparallel strand directionality, and DNA-vs-RNA structural
-- differences (deoxyribose vs ribose, thymine vs uracil), applied to a
-- complementary-strand-with-directionality worked example; and 1.7's four
-- distinct protein structure levels and the specific interaction driving
-- each (peptide bonds for primary, backbone hydrogen bonds for secondary,
-- R-group interactions including disulfide bridges for tertiary,
-- inter-chain interactions for quaternary), applied to a disulfide-bridge-
-- disruption worked example that requires identifying which structural
-- levels are and are not affected. All facts (base-pairing rules, amino
-- acid R-group structure claims, saturated-vs-unsaturated fat chemistry,
-- element-to-macromolecule mapping) were independently verified during
-- authoring against the fact pack; no biology facts required correction.
--
-- Before-state not separately captured for this batch (no prior
-- before-state export file exists for AP Biology Unit 1); the pre-repair
-- content is fully recoverable from git history for this table's rows if a
-- rollback is ever needed.
--
-- Every new explainer is genuinely topic-specific: core_idea differs from
-- what_it_is on every row (expands it with a new grounded fact from the
-- fact pack rather than restating it). answer_move and common_point_loss
-- are preserved verbatim from the paired brief per protocol section 4
-- ("the same topic-specific answer_move" / "the same or refined
-- common_point_loss") -- the Unit 1 briefs already carry specific, correct,
-- non-templated point-earning language, so no refinement was needed.
-- mini_example_question / weak_answer / point_attaining_answer /
-- practice_bridge are original per-row text that was checked corpus-wide
-- before this migration was written and repeats nowhere else in the
-- published corpus (zero collisions found; the only matches on the shared
-- boilerplate weak_answer string were the still-unrepaired rows this batch
-- does not touch).

with explainer_updates (
  topic_code, core_idea, what_students_need_to_understand,
  how_this_becomes_points, answer_move, mini_example_question, weak_answer,
  point_attaining_answer, common_point_loss, practice_bridge
) as (
  values
  ('1.1',
   'Water''s polar covalent O-H bonds let it form hydrogen bonds with other water molecules and with polar or charged solutes -- and because breaking many hydrogen bonds absorbs a lot of energy, water resists rapid temperature swings (high specific heat) and carries away large amounts of heat when it evaporates (high heat of vaporization), which is why sweating cools the body.',
   'Water properties explain biological patterns such as cohesion, adhesion, surface tension, temperature stability, solvent behavior, and cellular chemistry in aqueous environments. Water''s high specific heat keeps aquatic and cellular environments thermally stable, while its high heat of vaporization powers evaporative cooling in sweating and transpiration.',
   'You earn points by naming the specific water property in the question (specific heat, heat of vaporization, cohesion, adhesion, or surface tension), tracing it to hydrogen bonding between polar water molecules, and stating the resulting biological consequence.',
   'Use a three-step chain: water is polar -> hydrogen bonds form -> this causes the biological property or effect.',
   'A sweating athlete''s skin temperature drops as perspiration evaporates from her skin on a hot day. Explain, at the molecular level, why evaporation cools the body.',
   'Sweat evaporates and that cools you down.',
   'Water molecules are held to each other by hydrogen bonds due to their polarity. Breaking those hydrogen bonds to let a water molecule escape into the gas phase requires absorbing a large amount of energy (water''s high heat of vaporization). The water molecules that evaporate carry that absorbed thermal energy away with them, so the skin loses heat and its temperature drops -- this is evaporative cooling.',
   'Naming a water property without explaining how polarity or hydrogen bonding produces it.',
   'Return to practice and, on every water-property item, name the hydrogen bonds first, then trace the specific energy cost of breaking them into the biological effect being asked about.'),
  ('1.2',
   'Living systems are built mostly from carbon, hydrogen, and oxygen, with nitrogen, phosphorus, and sulfur playing specific structural roles: nitrogen is required in nucleic acids and amino acids, phosphorus in phospholipids and nucleic acids, and sulfur in some proteins via certain amino acid side chains.',
   'Element composition helps students explain why particular molecules can store energy, carry information, form membranes, or build cellular structures. Phosphorus specifically appears in both phospholipid heads and nucleotide backbones, nitrogen specifically appears in nucleotides and amino groups, and sulfur specifically appears in certain amino acid side chains.',
   'You earn points by linking a named element to the specific molecule or structure it supports -- phosphorus in nucleic acids and phospholipids, nitrogen in nucleic acids and amino acids, sulfur in certain proteins -- rather than listing CHNOPS generically.',
   'Do not just list elements. Connect the element to a biological molecule and the molecule to its function.',
   'A biochemist finds that a molecule contains phosphorus but a classmate insists ''phosphorus is only in DNA.'' Name two macromolecule classes that require phosphorus and explain why the classmate is only partly right.',
   'Phosphorus is in DNA, so the classmate is right.',
   'Phosphorus is required to build both nucleic acids (as part of each nucleotide''s phosphate group, linking the sugar-phosphate backbone) and phospholipids (as the phosphate group in the hydrophilic head). So the classmate is only partly right -- DNA is one phosphorus-containing macromolecule, but phospholipids, essential to every cell membrane, also depend on phosphorus.',
   'Reciting CHNOPS without explaining what those elements let cells build or do.',
   'Back to practice: on every elements-of-life item, name the specific element, then name the specific macromolecule class it builds, not just ''proteins and DNA'' in general.'),
  ('1.3',
   'Macromolecules are polymers built from monomer subunits. Dehydration synthesis forms a covalent bond between two monomers by removing a water molecule, and repeating this reaction chains monomers into a polymer; hydrolysis reverses this exactly by adding a water molecule across the bond, attaching an H to one monomer and an OH to the other as the bond breaks.',
   'This topic gives students a reusable way to think about carbohydrates, proteins, nucleic acids, and many digestion or biosynthesis contexts. Dehydration synthesis releases one water molecule per bond formed, and hydrolysis consumes one water molecule per bond broken.',
   'You earn points by identifying whether a system is building or breaking a polymer, naming dehydration synthesis or hydrolysis correctly, and stating precisely what happens to the water molecule -- released during bond formation, or split with H and OH going to opposite monomers during bond breaking.',
   'Ask: is the cell building a larger molecule or breaking one apart? Then name dehydration synthesis or hydrolysis and state what happens to water.',
   'During digestion, an enzyme breaks a bond linking two glucose monomers in maltose, releasing two separate glucose molecules. Name the reaction and explain what happens to a water molecule during it.',
   'Digestion uses hydrolysis to break down maltose into glucose.',
   'This is hydrolysis: a water molecule is added across the bond linking the two glucose monomers, splitting it. One glucose monomer receives the water''s H, and the other receives its OH, so the covalent bond breaks and two separate, complete glucose molecules result. This is the reverse of dehydration synthesis, which would have joined those two monomers by removing a water molecule.',
   'Mixing up dehydration synthesis and hydrolysis, especially the direction of water movement.',
   'Head to practice and, on every macromolecule-reaction item, state explicitly whether water is added (hydrolysis) or removed (dehydration synthesis), and which monomer gets which piece of the water molecule.'),
  ('1.4',
   'Monosaccharides are the monomer units for polysaccharides such as cellulose, starch, and glycogen, which are built from the same basic sugar subunits joined by covalent bonds into either linear or branched arrangements -- the AP Exam does not require knowing the specific molecular structure of these polymers, only that bond arrangement and branching pattern determine whether a carbohydrate functions for storage or structural support.',
   'AP Biology often rewards structure-function reasoning. The same basic glucose subunit can be linked into different arrangements -- branched glycogen and starch for accessible energy storage, or linear cellulose for structural rigidity -- so a question rewards connecting bond/organization pattern to function rather than naming a specific sugar.',
   'You earn points by connecting carbohydrate organization (linear versus branched arrangement of monosaccharide monomers) to its biological role -- glucose for immediate energy, starch or glycogen for storage, cellulose for structural support -- without needing to describe the exact polymer bond geometry, which is beyond exam scope.',
   'Name the carbohydrate type, identify the structural feature, and connect it to energy storage, energy use, or support.',
   'Starch and cellulose are both polysaccharides built from glucose monomers, yet starch is readily digested for energy while cellulose provides rigid structural support in plant cell walls. Explain how two polysaccharides built from the same monomer can serve such different functions, without describing their specific bond geometry.',
   'Starch and cellulose are different because starch is for energy and cellulose is for structure.',
   'Both starch and cellulose are polysaccharides of the same monosaccharide (glucose), but they differ in how those monomers are covalently joined and arranged into linear or branched chains. That difference in linkage and organization -- not a different starting sugar -- is what makes starch readily broken down for energy storage and release, while making cellulose resistant to breakdown and suited to giving the plant cell wall structural rigidity. The exam does not require naming the specific bond geometry, only that organization determines function.',
   'Saying carbohydrates are only for energy and missing structural roles such as cellulose.',
   'Return to practice and, on every carbohydrate item, connect structure (linear versus branched, storage versus building-block) to function -- energy, storage, or support -- without trying to name specific bond geometry the exam doesn''t test.'),
  ('1.5',
   'Fatty acids are saturated (only single carbon-carbon bonds, allowing tight, straight packing) or unsaturated (containing one or more carbon-carbon double bonds that introduce a kink in the chain); more double bonds mean more kinks, looser packing, and a fat that stays liquid at room temperature, which is why plant oils (more unsaturated) are liquid while animal fats (more saturated) are solid.',
   'Lipids connect Unit 1 chemistry to membranes, energy storage, insulation, signaling, and cell compartment boundaries later in the course. Steroids like cholesterol stabilize animal cell membranes and act as hormone signals, and phospholipids'' amphipathic structure lets them form the lipid bilayer that becomes the cell membrane in Unit 2.',
   'You earn points by connecting fatty acid saturation (single bonds only, versus one or more double bonds) to physical packing and biological consequence -- solid versus liquid at room temperature for fats, or amphipathic structure for phospholipid membrane formation -- without describing exact lipid molecular structure, which is beyond exam scope.',
   'Start with polarity: hydrophobic or amphipathic? Then connect that property to membrane behavior, storage, insulation, or signaling.',
   'Butter (from animal fat) is solid at room temperature, while olive oil (from plants) is liquid at the same temperature. Explain this difference in terms of fatty acid structure.',
   'Butter and olive oil are different because they''re different kinds of fat.',
   'Butter''s fatty acids are mostly saturated, containing only single carbon-carbon bonds, which lets the chains pack tightly and straight against each other, favoring a solid state at room temperature. Olive oil''s fatty acids are largely unsaturated, containing one or more carbon-carbon double bonds that introduce kinks in the chain; those kinks prevent tight packing, so the molecules stay more loosely arranged and the fat remains liquid at room temperature.',
   'Treating all lipids as the same instead of distinguishing fats, phospholipids, and steroids by structure and function.',
   'Back to practice and, on every lipid-structure item, name saturated or unsaturated explicitly and trace the double-bond-kink-packing chain to the physical state or function being asked about.'),
  ('1.6',
   'DNA is an antiparallel double helix held together by hydrogen bonds between complementary bases -- adenine pairs with thymine, and cytosine pairs with guanine -- while RNA is typically single-stranded and pairs adenine with uracil instead of thymine; DNA uses deoxyribose sugar and RNA uses ribose. Each strand also has directionality, with new nucleotides added only to the 3'' end during synthesis.',
   'This topic starts the information theme that returns in DNA replication, gene expression, biotechnology, inheritance, and evolution. Complementary base pairing (A-T/A-U and C-G) makes nucleotide sequence copyable and readable, and strand directionality (5'' to 3'' synthesis) governs how DNA replication and RNA synthesis proceed.',
   'You earn points by connecting nucleotide sequence to information storage, naming the correct base-pairing rule (A-T and C-G in DNA, A-U in RNA), stating strand directionality (5'' to 3''), or naming a specific DNA-versus-RNA structural difference (deoxyribose versus ribose, thymine versus uracil, typically double- versus single-stranded).',
   'When asked about DNA or RNA, connect structure to information: sequence stores instructions, base pairing supports copying, and strand direction affects synthesis.',
   'A DNA strand reads 5''-ATGC-3''. Write the sequence and directionality of its complementary strand, and explain why the two strands run in opposite directions.',
   'The complementary strand is TACG, matching each base.',
   'Base pairing requires A with T and C with G, so the complement of ATGC is TACG -- but because DNA strands are antiparallel, the complementary strand must be written running in the opposite direction: 3''-TACG-5'', which read 5'' to 3'' is 5''-GCAT-3''. The two strands run antiparallel because each strand''s sugar-phosphate backbone has an inherent directionality, and new nucleotides can only be added to a growing strand''s 3'' end, so the two strands of the double helix must be oriented in opposite directions for both to be synthesizable and to pair correctly base-by-base.',
   'Describing nucleic acids only as genetic material without explaining how sequence, base pairing, or strand structure supports the function.',
   'Go to practice and, on every nucleic-acid item, state the base-pairing rule (A-T or A-U, C-G) and the strand directionality (5'' to 3'') explicitly rather than describing DNA only as ''the genetic material.'''),
  ('1.7',
   'Protein structure builds in four levels, each driven by a different kind of interaction: primary structure is just the amino acid sequence; secondary structure (alpha-helices and beta-sheets) forms from hydrogen bonds between backbone atoms; tertiary structure is the overall 3D shape, driven by R-group interactions -- hydrogen bonds, hydrophobic interactions, ionic interactions, and disulfide bridges; and quaternary structure arises only in proteins built from multiple polypeptide chains interacting with each other.',
   'Proteins are central to enzymes, transport, signaling, structure, movement, and regulation. Each of the four structure levels depends on a distinct interaction, so a change at any level can propagate into a change in function.',
   'You earn points by naming the specific structural level affected (primary, secondary, tertiary, or quaternary) and the specific interaction driving it (peptide bonds, backbone hydrogen bonds, R-group hydrogen/hydrophobic/ionic interactions, disulfide bridges, or inter-chain interactions), then tracing that structural change to a functional consequence.',
   'Use the chain: sequence -> folding/shape -> function. If a mutation or environmental change appears, explain how it could alter that chain.',
   'A protein made of two separate polypeptide chains loses function when a chemical breaks the disulfide bridges holding one chain''s shape together, even though the two chains remain associated. Which levels of protein structure are disrupted, and which remain intact?',
   'The protein''s structure is disrupted and it becomes denatured, so it stops working.',
   'Disulfide bridges are one of the R-group interactions that hold tertiary structure -- a single polypeptide''s overall 3D shape -- together, so breaking them disrupts that chain''s tertiary structure and likely its secondary structure as well if the shape distortion pulls apart hydrogen-bonded regions. Primary structure (the amino acid sequence itself) is unaffected, since no peptide bonds were broken. Quaternary structure, which depends on interactions between the two separate polypeptide chains, remains structurally present in the sense that the chains stay associated, but since one chain''s tertiary shape is now wrong, the overall functional quaternary complex is compromised.',
   'Saying a protein is denatured or changed without connecting the structural change to a functional consequence.',
   'Return to practice and, on every protein-structure item, name which of the four levels is involved and which specific interaction (H-bonds, hydrophobic, ionic, disulfide, or peptide bonds) drives that level.')
)
update app.topic_explainers e
set
  core_idea = u.core_idea,
  what_students_need_to_understand = u.what_students_need_to_understand,
  how_this_becomes_points = u.how_this_becomes_points,
  answer_move = u.answer_move,
  mini_example_question = u.mini_example_question,
  weak_answer = u.weak_answer,
  point_attaining_answer = u.point_attaining_answer,
  common_point_loss = u.common_point_loss,
  practice_bridge = u.practice_bridge,
  source_note = 'cramapple-authored; repaired 2026-08-22 replacing a template-generated explainer (previously generated-from-brief, grandfathered per the 2026-08-21 bulk audit) with topic-specific content grounded in AP_BIOLOGY_CED_FACT_PACK.md Unit 1 section (line 317): the specific-heat/heat-of-vaporization hydrogen-bond-energy mechanism for 1.1, applied to a sweating/evaporative-cooling worked example; the specific element-to-macromolecule mapping (phosphorus in nucleic acids and phospholipids) for 1.2, applied to a phosphorus-in-DNA-vs-phospholipids contrast; the precise water-addition-vs-removal directionality (H to one monomer, OH to the other) for 1.3, applied to a maltose-hydrolysis worked example; the linear-vs-branched polysaccharide organization fact and its verbatim exclusion of specific carbohydrate polymer structure for 1.4, applied to a starch-vs-cellulose contrast; the saturated-vs-unsaturated fatty-acid packing fact and its verbatim exclusion of specific lipid molecular structure for 1.5, applied to a butter-vs-olive-oil worked example; the A-T/C-G and A-U base-pairing rules plus antiparallel strand directionality for 1.6, applied to a complementary-strand worked example; and the four protein structure levels with their driving interactions for 1.7, applied to a disulfide-bridge-disruption worked example. All facts were independently verified against the fact pack during authoring; no biology facts required correction. briefs for this unit are genuinely hand-authored and were NOT touched. batch 2026-08-22-ap-biology-unit1-explainer-repair; author=reviewer same session, no independent human review yet'
from explainer_updates u
where e.subject_key = 'ap_biology'
  and e.unit_number = 1
  and e.topic_code = u.topic_code;

do $$
declare
  v_repaired integer;
  v_core_matches integer;
begin
  select count(*) into v_repaired from app.topic_explainers
    where subject_key='ap_biology' and unit_number=1 and status='published'
      and source_note like '%unit1-explainer-repair%';
  if v_repaired <> 7 then
    raise exception 'expected 7 repaired AP Biology Unit 1 explainers, got %', v_repaired;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e on e.subject_key=b.subject_key and e.topic_code=b.topic_code
  where b.subject_key='ap_biology' and b.unit_number=1 and b.status='published'
    and e.status='published' and e.core_idea = b.what_it_is;
  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Biology Unit 1 explainers matching their brief verbatim, got %', v_core_matches;
  end if;
end $$;

commit;
