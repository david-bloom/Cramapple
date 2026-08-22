begin;

-- Repair AP Biology Unit 2 (Cells) Learn More explainers -- all 10 were
-- template-generated debt (core_idea verbatim-matching their brief's
-- what_it_is, and mini_example_question / weak_answer shared boilerplate
-- duplicated across ~150 other rows corpus-wide, per the 2026-08-21 bulk
-- audit; the exact weak_answer "I would name the biology term and give a
-- general statement." and the exact title-interpolation mini_example_question
-- template appear on many other AP Biology rows). Confirmed via SQL before
-- authoring: all 10 rows carried source_note
-- 'generated-from-brief:legacy; grandfathered-2026-08-21' with no
-- "repaired" marker, and a direct read of the current rows showed core_idea
-- byte-identical to the paired brief's what_it_is on every row, plus the
-- exact boilerplate weak_answer and mini_example_question template on every
-- row -- so all 10 are genuine debt; none were an outlier that already had
-- hand-authored content. Briefs for this unit are genuinely hand-authored
-- and correct; NOT touched here.
--
-- Grounded in docs/product/AP_BIOLOGY_CED_FACT_PACK.md Unit 2 section
-- (starting line 388): 2.1's specific organelle function list (rough ER
-- ribosome-studded for protein synthesis vs. smooth ER for detox/lipid
-- synthesis; Golgi as flattened sacs folding/modifying/packaging proteins;
-- mitochondria's convoluted inner membrane for efficient ATP synthesis;
-- lysosomes as hydrolytic-enzyme sacs driving digestion and apoptosis;
-- plant vacuoles maintaining turgor pressure vs. smaller/more numerous
-- animal vacuoles), applied to a rough-ER-vs-Golgi worked example on a
-- secreted protein; 2.2's SA:V mechanics (smaller cells have higher SA:V
-- and more efficient exchange; as volume grows SA:V drops), applied to an
-- actual SA:V calculation comparing two differently sized cube-shaped
-- cells; 2.3's phospholipid orientation (hydrophilic heads out, hydrophobic
-- tails in) and embedded-protein orientation fact, applied to a membrane-
-- protein-orientation worked example; 2.4's specific permeability rules
-- (small nonpolar molecules N2/O2/CO2 cross freely; small polar uncharged
-- molecules like H2O/NH3 pass in small amounts; hydrophilic/charged
-- substances need transport proteins) plus the cell wall's role preventing
-- osmotic lysis, applied to a glucose-vs-CO2 permeability contrast; 2.5's
-- passive-vs-active transport distinction (net high-to-low needs no direct
-- energy; active transport can move low-to-high and requires energy) plus
-- endocytosis/exocytosis using energy for bulk transport, applied to a
-- glucose-uptake-against-its-gradient worked example; 2.6's facilitated
-- diffusion mechanics (channel proteins move large/charged/polar molecules
-- down their gradient with no energy input; aquaporins move large
-- quantities of water) applied to an aquaporin-in-a-kidney-cell worked
-- example; 2.7's tonicity/water-potential formulas (Psi = Psi_p + Psi_s;
-- Psi_s = -iCRT; water moves toward more negative/lower water potential)
-- applied to an actual water-potential calculation comparing two solutions;
-- 2.8's Na+/K+ pump and ATPase mechanism (metabolic energy required for
-- active transport and maintaining the electrochemical gradient/membrane
-- potential) applied to a Na+/K+ pump stoichiometry worked example; 2.9's
-- compartmentalization rationale (internal membranes minimize competing
-- interactions and increase reaction surface area) applied to a lysosome-
-- pH-vs-cytosol-pH contrast; and 2.10's endosymbiosis evidence (double
-- membranes, circular DNA, own ribosomes, division by binary fission)
-- applied to a worked example requiring the student to name and explain
-- three separate lines of evidence. All facts (organelle functions,
-- passive-vs-active transport distinctions, water-potential formula
-- application, SA:V math, endosymbiosis evidence) were independently
-- verified during authoring against the fact pack; no biology facts
-- required correction.
--
-- Before-state not separately captured for this batch (no prior
-- before-state export file exists for AP Biology Unit 2); the pre-repair
-- content is fully recoverable from git history for this table's rows if a
-- rollback is ever needed.
--
-- Every new explainer is genuinely topic-specific: core_idea differs from
-- what_it_is on every row (expands it with a new grounded fact from the
-- fact pack rather than restating it). answer_move and common_point_loss
-- are preserved verbatim from the paired brief per protocol section 4
-- ("the same topic-specific answer_move" / "the same or refined
-- common_point_loss") -- the Unit 2 briefs already carry specific, correct,
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
  ('2.1',
   'Cells contain specialized structures whose shapes and locations support specific biological functions -- for example, rough ER is ribosome-studded and builds proteins destined for secretion or membranes, while smooth ER lacks ribosomes and instead handles detoxification and lipid synthesis, and the Golgi apparatus''s stacked flattened sacs then fold, modify, and package those proteins for delivery.',
   'The endomembrane system works as a coordinated production line: the nucleus, rough ER, Golgi, lysosomes, vacuoles, and plasma membrane each contribute a distinct step in making, modifying, packaging, and delivering cell products. Mitochondria''s highly folded inner membrane increases surface area for ATP synthesis, and lysosomes'' hydrolytic enzymes digest material and drive programmed cell death.',
   'You earn points by naming the specific organelle involved, describing the structural feature that makes its role possible (ribosome-studded membrane, folded inner membrane, stacked sacs, enzyme-filled sac), and connecting that feature to the process it performs.',
   'Name the structure, name the function, then explain the feature that makes the function possible.',
   'A pancreatic cell secretes large quantities of digestive enzymes. Trace the pathway of one enzyme molecule from its synthesis to its release from the cell, naming each organelle involved.',
   'The enzyme is made in the cell and then sent outside through the membrane.',
   'The enzyme is synthesized by ribosomes attached to the rough ER, which folds the growing polypeptide into the ER lumen. Transport vesicles then carry it to the Golgi apparatus, whose stacked flattened sacs modify and package it into a secretory vesicle. That vesicle moves to the plasma membrane and releases its contents by exocytosis, fusing with the membrane to secrete the enzyme outside the cell.',
   'Listing organelles without connecting structure to function.',
   'Return to practice and, on every organelle item, name the specific structural feature (ribosome-studded, folded, stacked, enzyme-filled) before stating the function it enables.'),
  ('2.2',
   'Cell size is constrained by surface area-to-volume ratio and the need to exchange materials efficiently -- because surface area scales with the square of a cell''s linear dimension while volume scales with the cube, doubling a cell''s diameter increases its exchange surface only 4-fold while its resource demand grows 8-fold, which is why cells that grow past a certain size divide rather than keep expanding.',
   'This topic explains real constraints on cell size and shape: as a cell''s volume grows faster than its surface area, its SA:V ratio drops and the membrane becomes less able to keep up with the exchange (nutrients, waste, heat) that a bigger volume of cytoplasm demands. Membrane folds (like microvilli or the mitochondrion''s cristae) compensate by adding surface area without adding volume.',
   'You earn points by calculating or comparing surface area and volume as size changes, then connecting size changes to surface area, volume, exchange rate, and limits on cellular function.',
   'Compare surface area and volume as size changes, then state the effect on exchange efficiency.',
   'Cell A is a cube with 2 micrometer sides. Cell B is a cube with 4 micrometer sides. Calculate each cell''s surface area-to-volume ratio and explain which cell can exchange nutrients and waste more efficiently per unit of volume.',
   'Cell B is bigger, so it has more surface area and exchanges materials better.',
   'Cell A has surface area 6 x (2x2) = 24 square micrometers and volume 2x2x2 = 8 cubic micrometers, giving an SA:V ratio of 3:1. Cell B has surface area 6 x (4x4) = 96 square micrometers and volume 4x4x4 = 64 cubic micrometers, giving an SA:V ratio of 1.5:1. Even though Cell B has more total surface area, its ratio of surface area to volume is lower, so each unit of its cytoplasm has less membrane available for exchange -- making Cell A the more efficient exchanger per unit of volume.',
   'Saying small cells are efficient without explaining the surface area-to-volume relationship.',
   'Head to practice and, on every cell-size item, actually compute or compare the surface-area-to-volume ratio rather than asserting one cell is ''more efficient'' without the numbers.'),
  ('2.3',
   'The plasma membrane is a phospholipid bilayer with embedded proteins that separates internal and external environments -- each phospholipid is amphipathic, so its hydrophilic phosphate head faces the watery cytoplasm or extracellular fluid while its hydrophobic fatty-acid tails face inward, and embedded proteins orient themselves so any hydrophilic regions face water while hydrophobic regions stay buried in the bilayer''s interior.',
   'The fluid mosaic model describes the membrane as a phospholipid framework studded with mobile proteins, steroids like cholesterol, glycoproteins, and glycolipids -- all of these components can drift within the bilayer, and their orientation is not random but is determined by which parts of each molecule are hydrophilic versus hydrophobic.',
   'You earn points by connecting phospholipid amphipathic structure and membrane proteins to selective movement or communication, including explaining why specific regions of proteins or lipids face inward or outward.',
   'Start with bilayer structure, then identify the protein or lipid feature responsible for the observed function.',
   'A membrane protein has a long stretch of nonpolar amino acids in its middle and polar/charged amino acids at both ends. Predict how this protein is oriented within the plasma membrane and explain why.',
   'The protein sits in the membrane because membrane proteins are embedded in the phospholipid bilayer.',
   'The nonpolar middle stretch of the protein will be positioned within the hydrophobic interior of the bilayer, formed by the phospholipids'' fatty-acid tails, because nonpolar regions are repelled by water and stabilized by hydrophobic interactions with the tails. The polar and charged ends of the protein will instead face outward, contacting the hydrophilic phospholipid heads and the watery cytoplasm or extracellular fluid on either side, since polar/charged groups are stabilized by contact with water rather than lipid tails.',
   'Calling the membrane a barrier without explaining selective permeability.',
   'Back to practice and, on every membrane-structure item, name which part of the molecule is hydrophilic and which is hydrophobic before predicting its position in the bilayer.'),
  ('2.4',
   'Membrane permeability depends on molecule size, polarity, charge, and whether transport proteins are available -- small nonpolar molecules such as O2, CO2, and N2 dissolve through the hydrophobic bilayer interior and cross freely, small polar uncharged molecules such as H2O and NH3 pass through in smaller amounts, and hydrophilic or charged substances are blocked by the hydrocarbon tails and require a channel or transport protein.',
   'This topic helps students predict which molecules cross membranes and why, and it also explains the cell wall''s role: in bacteria, archaea, fungi, and plants, the cell wall sits outside the plasma membrane and acts as a structural boundary and permeability barrier that protects the cell from osmotic lysis when water enters.',
   'You earn points by explaining movement based on molecular properties (size, polarity, charge) and membrane composition, correctly separating substances that cross the lipid bilayer directly from those that need a transport protein.',
   'Ask whether the molecule is small/nonpolar, polar, charged, or large, then decide if a protein is needed.',
   'Compare glucose (a large polar sugar) and CO2 (a small nonpolar gas) crossing the plasma membrane of a cell. Explain why one requires a transport protein and the other does not.',
   'Glucose and CO2 both need to get into the cell, so they both use transport proteins.',
   'CO2 is a small, nonpolar molecule, so it can dissolve directly through the hydrophobic fatty-acid tails in the bilayer''s interior and diffuse across the membrane with no protein needed. Glucose is large and polar, so its structure is repelled by the hydrophobic interior of the bilayer -- it cannot pass through the hydrocarbon tails on its own and instead requires a specific transport protein (a carrier or channel) to cross the membrane.',
   'Saying molecules cross because the cell needs them instead of because their properties allow it.',
   'Go to practice and, on every permeability item, classify the molecule by size/polarity/charge first, then decide whether it crosses freely or needs a transport protein.'),
  ('2.5',
   'Membrane transport includes passive movement down gradients and active movement requiring energy to move against gradients -- passive transport is net movement from high to low concentration with no direct energy input, while active transport uses energy (typically ATP) to move a substance from low to high concentration, against its gradient.',
   'Transport is central to homeostasis, signaling, and cellular energy use. Bulk transport of large molecules or particles uses a different mechanism entirely: endocytosis folds the membrane inward to engulf material from outside the cell, and exocytosis fuses a vesicle with the membrane to release material outside -- both processes require energy regardless of whether the transported substance itself is moving up or down a concentration gradient.',
   'You earn points by identifying the gradient, direction of movement, energy requirement, and protein involvement, and by correctly stating whether the mechanism is passive, active, or bulk transport (endocytosis/exocytosis).',
   'State high-to-low or low-to-high relative to the gradient, then name passive or active transport.',
   'A kidney cell moves glucose from the fluid outside the cell, where glucose concentration is low, into the cytoplasm, where glucose concentration is already high. Identify whether this is passive or active transport and explain your reasoning.',
   'This is passive transport because the glucose moves through a protein channel in the membrane.',
   'This is active transport, not passive, because the glucose is moving from an area of low concentration outside the cell to an area of high concentration inside the cell -- against its concentration gradient. Moving a solute against its gradient requires energy input (commonly supplied by ATP or by coupling to another ion''s gradient), which is the defining feature of active transport regardless of whether a membrane protein is involved.',
   'Ignoring gradient direction or claiming all protein transport requires ATP.',
   'Return to practice and, on every transport item, state the direction of movement relative to the gradient first, since that -- not just protein involvement -- is what determines passive versus active.'),
  ('2.6',
   'Facilitated diffusion uses membrane proteins to move substances down their concentration gradients without direct energy input -- charged ions like Na+ and K+ require specific channel proteins to cross the hydrophobic bilayer, and aquaporins are specialized channel proteins that allow large quantities of water to cross the membrane far faster than water could pass through the lipid bilayer alone.',
   'It links protein structure to membrane permeability and homeostasis. Because facilitated diffusion is still diffusion, it always moves a substance from high to low concentration and never requires ATP -- the protein channel only provides a path, not a driving force, so the rate still depends on the size of the concentration gradient.',
   'You earn points by explaining that a specific channel or carrier allows movement down the gradient, and by clearly identifying the transport protein type (channel vs. carrier, or aquaporin specifically for water).',
   'Name the transport protein type and make clear the movement is passive and down gradient.',
   'A kidney cell has a very high density of aquaporin proteins in its plasma membrane. Explain how aquaporins allow this cell to move large quantities of water quickly, and state whether this process requires ATP.',
   'Aquaporins pump water into the cell using energy from ATP because moving that much water needs active transport.',
   'Aquaporins are channel proteins that form a specific passage through the hydrophobic bilayer, letting water molecules cross far more quickly than they could by diffusing through the lipid tails directly. Because water still moves down its own concentration (or water potential) gradient through the channel, this is facilitated diffusion, not active transport, so it requires no ATP -- the aquaporin simply provides a faster path for water that would move in that direction anyway.',
   'Calling facilitated diffusion active transport because a protein is involved.',
   'Head back to practice and, on every facilitated-diffusion item, confirm the direction is down the gradient and explicitly state that no energy is required, even though a protein is involved.'),
  ('2.7',
   'Tonicity describes how surrounding solute concentration affects water movement across membranes -- water potential (Psi) combines pressure potential (Psi_p) and solute potential (Psi_s), so Psi = Psi_p + Psi_s, and solute potential can be calculated as Psi_s = -iCRT, where water always moves from the solution with the higher (less negative) water potential to the one with the lower (more negative) water potential.',
   'It is a common AP context for predicting cell volume changes and homeostatic regulation. A solution with more dissolved solute has a more negative solute potential, which lowers its overall water potential and pulls water toward it -- this is why cells placed in a hypertonic solution lose water and shrink, while cells in a hypotonic solution gain water and can swell or lyse.',
   'You earn points by identifying the relative solute concentrations, calculating or comparing water potential, predicting water movement toward the more negative Psi, and explaining the effect on the cell.',
   'Compare solute inside and outside, then move water toward the higher solute concentration.',
   'A cell with pressure potential of 0 MPa and solute potential of -0.5 MPa is placed in a solution with a water potential of -0.2 MPa. Calculate the cell''s water potential and predict which way water will move.',
   'Water moves out of the cell because the cell has more solute than the surrounding solution.',
   'The cell''s water potential is Psi = Psi_p + Psi_s = 0 + (-0.5) = -0.5 MPa. Comparing this to the surrounding solution''s water potential of -0.2 MPa, the cell''s water potential is lower (more negative) than the solution''s. Since water moves from higher (less negative) water potential to lower (more negative) water potential, water will move into the cell from the surrounding solution, not out of it.',
   'Moving solute instead of water when answering an osmosis question.',
   'Back to practice and, on every tonicity item, calculate or compare actual water potential values (Psi = Psi_p + Psi_s) rather than reasoning from solute concentration alone.'),
  ('2.8',
   'Cells use channels, carriers, pumps, endocytosis, and exocytosis to move materials across membranes -- the Na+/K+ pump is a specific ATPase that uses metabolic energy from ATP to actively transport Na+ out of the cell and K+ into the cell against their gradients, which both maintains the cell''s membrane potential and keeps the electrochemical gradients available for other transport processes.',
   'Different mechanisms match different molecule types, gradient directions, and energy demands. Because the Na+/K+ pump continuously moves ions against their gradients, it requires a steady supply of ATP, and if ATP production stops, the pump fails and the membrane potential the cell depends on for signaling and other transport cannot be maintained.',
   'You earn points by choosing the mechanism that fits the substance and explaining why that mechanism is needed, and for pump-specific items, by naming the ATP requirement and the resulting membrane potential.',
   'Match molecule size and gradient direction to channel, carrier, pump, endocytosis, or exocytosis.',
   'A neuron''s Na+/K+ pump moves 3 Na+ ions out of the cell and 2 K+ ions into the cell for every ATP molecule hydrolyzed. Explain why this process requires ATP and what effect it has on the cell''s membrane potential.',
   'The pump requires ATP because all protein transport across the membrane needs energy.',
   'The Na+/K+ pump requires ATP because it moves both ions against their concentration gradients -- Na+ from low concentration inside to high concentration outside, and K+ from low concentration outside to high concentration inside -- and moving any solute against its gradient requires energy input, which the pump gets by hydrolyzing ATP. Because the pump exports 3 positive charges for every 2 it imports, it makes the cell''s interior more negative relative to the outside, helping establish and maintain the membrane potential.',
   'Naming a mechanism without justifying why the cell would use it for that material.',
   'Return to practice and, on every active-transport item, state explicitly which direction is against the gradient and why that specific movement requires ATP.'),
  ('2.9',
   'Compartmentalization separates cellular processes into membrane-bound spaces with distinct conditions -- internal membranes minimize competing interactions between reactions that would otherwise interfere with each other if they occurred in the same open space, and they increase the total surface area available for reactions that occur on or across a membrane.',
   'It explains how eukaryotic cells increase efficiency, regulate reactions, and maintain incompatible environments. A compartment can maintain conditions, such as pH or enzyme concentration, that would disrupt other reactions happening elsewhere in the cell, which is why isolating a process behind a membrane can make that process both faster and safer for the rest of the cell.',
   'You earn points by linking a compartment to the process it supports and the advantage of separation, specifically naming either reduced competing interactions or increased reaction surface area as the mechanism.',
   'Identify the compartment, the process inside it, and the benefit of separating that process.',
   'A lysosome maintains an internal pH of about 4.5, while the surrounding cytosol has a pH of about 7.2. Explain why keeping the lysosome''s hydrolytic enzymes in a separate, more acidic compartment benefits the cell.',
   'The lysosome is a specialized organelle, so it needs its own compartment to do its job.',
   'The lysosome''s hydrolytic enzymes work optimally at the low, acidic pH maintained inside the lysosome, but that same acidic, protein-degrading environment would damage other cellular components if it existed freely in the cytosol. By enclosing these enzymes in a membrane-bound compartment held at a different pH than the surrounding cytosol, the cell minimizes competing interactions -- the enzymes can digest their intended targets efficiently without breaking down proteins and structures elsewhere in the cell.',
   'Saying organelles are specialized without explaining the advantage of compartment boundaries.',
   'Head to practice and, on every compartmentalization item, name the specific advantage -- reduced competing interactions or increased reaction surface area -- rather than just saying the compartment is specialized.'),
  ('2.10',
   'Endosymbiotic theory explains the origin of mitochondria and chloroplasts from ancestral prokaryotes -- the evidence includes their double membranes (consistent with one membrane from the engulfed prokaryote and one from the host cell''s engulfing vesicle), their own circular DNA similar to bacterial chromosomes, their own ribosomes distinct from the cell''s cytoplasmic ribosomes, and their ability to divide independently by a process resembling bacterial binary fission.',
   'This topic connects cell structure to evolution and evidence-based biological claims. Prokaryotes typically lack membrane-bound organelles, though they do have specialized internal regions, while eukaryotic internal membranes partition the cell into specialized compartments -- and mitochondria and chloroplasts are the clearest evidence that some of those eukaryotic compartments began as separate free-living organisms.',
   'You earn points by citing evidence such as double membranes, circular DNA, ribosomes, or division by binary fission and connecting it to ancestry, ideally naming more than one line of evidence rather than just asserting the theory.',
   'Name a specific evidence feature and explain how it supports endosymbiosis.',
   'A biologist examining mitochondria under a microscope finds a double membrane, a small circular DNA molecule distinct from the cell''s nuclear DNA, and ribosomes different in size from the cell''s cytoplasmic ribosomes. Explain how these three observations support endosymbiotic theory.',
   'Mitochondria have their own DNA and membranes because they evolved to make energy for the cell.',
   'Each observation independently supports endosymbiotic theory. The double membrane is consistent with an ancestral free-living prokaryote being engulfed by a host cell: the inner membrane derives from the original prokaryote''s own membrane, and the outer membrane derives from the host''s engulfing vesicle. The circular DNA, distinct from the cell''s linear nuclear DNA, matches the circular chromosome structure typical of bacteria. The ribosomes, differing in size from the cell''s cytoplasmic ribosomes, resemble prokaryotic ribosomes rather than eukaryotic ones. Together, these three independent structural features point to mitochondria having originated as free-living prokaryotic cells that became permanently incorporated into a host cell.',
   'Listing mitochondria and chloroplasts as examples without providing evidence for their origin.',
   'Back to practice and, on every endosymbiosis item, name at least one specific structural piece of evidence (double membrane, circular DNA, own ribosomes, binary fission) rather than restating the theory itself.')
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
  source_note = 'cramapple-authored; repaired 2026-08-22 replacing a template-generated explainer (previously generated-from-brief, grandfathered per the 2026-08-21 bulk audit) with topic-specific content grounded in AP_BIOLOGY_CED_FACT_PACK.md Unit 2 section (line 388): the specific organelle function list (rough ER vs. smooth ER, Golgi, mitochondria, lysosomes, plant vs. animal vacuoles) for 2.1, applied to a rough-ER-to-Golgi-to-exocytosis secretion worked example; the SA:V scaling mechanics for 2.2, applied to an actual surface-area-to-volume calculation on two differently sized cube cells; the phospholipid/protein orientation facts for 2.3, applied to a membrane-protein-orientation worked example; the specific permeability rules (small nonpolar molecules cross freely, small polar uncharged molecules cross in small amounts, hydrophilic/charged substances need transport proteins) for 2.4, applied to a glucose-vs-CO2 contrast; the passive-vs-active transport distinction and bulk-transport energy requirement for 2.5, applied to a glucose-against-its-gradient worked example; the facilitated-diffusion and aquaporin facts for 2.6, applied to a kidney-cell aquaporin worked example; the water-potential formulas (Psi = Psi_p + Psi_s; Psi_s = -iCRT) for 2.7, applied to an actual water-potential calculation; the Na+/K+ pump/ATPase mechanism for 2.8, applied to a pump-stoichiometry worked example; the compartmentalization rationale (reduced competing interactions, increased reaction surface area) for 2.9, applied to a lysosome-pH-vs-cytosol contrast; and the endosymbiosis evidence (double membranes, circular DNA, own ribosomes, binary fission) for 2.10, applied to a three-evidence worked example. All facts were independently verified against the fact pack during authoring; no biology facts required correction. Briefs for this unit are genuinely hand-authored and were NOT touched. batch 2026-08-22-ap-biology-unit2-explainer-repair; author=reviewer same session, no independent human review yet'
from explainer_updates u
where e.subject_key = 'ap_biology'
  and e.unit_number = 2
  and e.topic_code = u.topic_code;

do $$
declare
  v_repaired integer;
  v_core_matches integer;
begin
  select count(*) into v_repaired from app.topic_explainers
    where subject_key='ap_biology' and unit_number=2 and status='published'
      and source_note like '%unit2-explainer-repair%';
  if v_repaired <> 10 then
    raise exception 'expected 10 repaired AP Biology Unit 2 explainers, got %', v_repaired;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e on e.subject_key=b.subject_key and e.topic_code=b.topic_code
  where b.subject_key='ap_biology' and b.unit_number=2 and b.status='published'
    and e.status='published' and e.core_idea = b.what_it_is;
  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Biology Unit 2 explainers matching their brief verbatim, got %', v_core_matches;
  end if;
end $$;

commit;
