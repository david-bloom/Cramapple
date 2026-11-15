-- Structured explainer pieces (recommendation #3), batch 2026-11-13. Guarded on each row still holding the text it was built on.
begin;
update app.topic_explainers set
  core_idea = $q$- Water's polar covalent O-H bonds let it form hydrogen bonds with other water molecules and with polar or charged solutes.
- Breaking many hydrogen bonds absorbs a lot of energy, so water resists rapid temperature swings (high specific heat).
- It carries away much heat when it evaporates (high heat of vaporization), which is why sweating cools the body.$q$,
  what_students_need_to_understand = $q$- Water properties explain cohesion, adhesion, surface tension, temperature stability, solvent behavior, and cellular chemistry in aqueous environments.
- High specific heat keeps aquatic and cellular environments thermally stable.
- High heat of vaporization powers evaporative cooling in sweating and transpiration.$q$,
  how_this_becomes_points = $q$1. Name the specific water property in the question (specific heat, heat of vaporization, cohesion, adhesion, or surface tension).
2. Trace it to hydrogen bonding between polar water molecules.
3. State the resulting biological consequence.$q$,
  point_attaining_answer = $q$Water molecules are held to each other by hydrogen bonds due to their polarity.

Breaking those hydrogen bonds to let a water molecule escape into the gas phase requires absorbing a large amount of energy (water's high heat of vaporization).

The evaporating molecules carry that absorbed thermal energy away with them, so the skin loses heat and its temperature drops -- this is evaporative cooling.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_biology/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=1 and topic_code='1.1' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='a5ef8b8fc927bcb46f769d2ce3561fa8';
update app.topic_explainers set
  core_idea = $q$- Living systems are built mostly from carbon, hydrogen, and oxygen, with nitrogen, phosphorus, and sulfur playing specific structural roles.
- Nitrogen is required in nucleic acids and amino acids, phosphorus in phospholipids and nucleic acids, and sulfur in some proteins via certain amino acid side chains.$q$,
  what_students_need_to_understand = $q$- Element composition explains why particular molecules can store energy, carry information, form membranes, or build cellular structures.
- Phosphorus appears in both phospholipid heads and nucleotide backbones.
- Nitrogen appears in nucleotides and amino groups; sulfur appears in certain amino acid side chains.$q$,
  how_this_becomes_points = $q$1. Link a named element to the specific molecule or structure it supports.
2. Phosphorus: nucleic acids and phospholipids; nitrogen: nucleic acids and amino acids; sulfur: certain proteins.
3. Do not list CHNOPS generically.$q$,
  point_attaining_answer = $q$| Macromolecule class | Role of phosphorus |
| Nucleic acids | Phosphate group of each nucleotide, linking the sugar-phosphate backbone |
| Phospholipids | Phosphate group in the hydrophilic head |

So the classmate is only partly right -- DNA is one phosphorus-containing macromolecule, but phospholipids, essential to every cell membrane, also depend on phosphorus.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_biology/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=1 and topic_code='1.2' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='ac390db748ac01a819e20cd64355704b';
update app.topic_explainers set
  core_idea = $q$- Macromolecules are polymers built from monomer subunits.
- Dehydration synthesis forms a covalent bond between two monomers by removing a water molecule; repeating it chains monomers into a polymer.
- Hydrolysis reverses this exactly, adding a water molecule across the bond: an H goes to one monomer and an OH to the other as the bond breaks.$q$,
  what_students_need_to_understand = $q$- This gives a reusable way to think about carbohydrates, proteins, nucleic acids, and many digestion or biosynthesis contexts.
- Dehydration synthesis releases one water molecule per bond formed.
- Hydrolysis consumes one water molecule per bond broken.$q$,
  how_this_becomes_points = $q$1. Identify whether the system is building or breaking a polymer.
2. Name dehydration synthesis or hydrolysis correctly.
3. State what happens to the water: released when a bond forms, or split with H and OH going to opposite monomers when a bond breaks.$q$,
  point_attaining_answer = $q$This is hydrolysis: a water molecule is added across the bond linking the two glucose monomers, splitting it.

One glucose monomer receives the water's H, and the other receives its OH, so the covalent bond breaks and two separate, complete glucose molecules result.

This is the reverse of dehydration synthesis, which would have joined those two monomers by removing a water molecule.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_biology/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=1 and topic_code='1.3' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='bc089d52feac65a36910ed80ae188d24';
update app.topic_explainers set
  core_idea = $q$- Monosaccharides are the monomers of polysaccharides such as cellulose, starch, and glycogen, covalently joined into linear or branched arrangements.
- The AP Exam does not require the specific molecular structure of these polymers.
- It requires only that bond arrangement and branching determine whether a carbohydrate serves storage or structural support.$q$,
  what_students_need_to_understand = $q$- AP Biology often rewards structure-function reasoning.
- The same glucose subunit can form branched glycogen and starch (accessible energy storage) or linear cellulose (structural rigidity).
- Connect bond/organization pattern to function rather than naming a specific sugar.$q$,
  how_this_becomes_points = $q$1. Connect organization (linear versus branched monosaccharide arrangement) to biological role.
2. Roles: glucose for immediate energy, starch or glycogen for storage, cellulose for structural support.
3. Skip exact polymer bond geometry; it is beyond exam scope.$q$,
  point_attaining_answer = $q$Both are glucose polysaccharides; they differ in how the monomers are covalently joined and arranged into linear or branched chains.

| Polysaccharide | Monomer | Result of its organization |
| Starch | glucose | readily broken down for energy storage and release |
| Cellulose | glucose | resistant to breakdown; gives the plant cell wall structural rigidity |

The exam does not require naming the specific bond geometry, only that organization determines function.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_biology/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=1 and topic_code='1.4' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='89bbd71d01823c83be6422dadc4a96bf';
update app.topic_explainers set
  core_idea = $q$- Saturated fatty acids have only single carbon-carbon bonds, allowing tight, straight packing.
- Unsaturated ones have one or more carbon-carbon double bonds, which kink the chain.
- More double bonds mean more kinks, looser packing, and liquid fat at room temperature: plant oils (more unsaturated) are liquid, animal fats (more saturated) are solid.$q$,
  what_students_need_to_understand = $q$- Lipids connect Unit 1 chemistry to membranes, energy storage, insulation, signaling, and cell compartment boundaries.
- Steroids like cholesterol stabilize animal cell membranes and act as hormone signals.
- Phospholipids' amphipathic structure lets them form the lipid bilayer that becomes the cell membrane in Unit 2.$q$,
  how_this_becomes_points = $q$1. Connect fatty acid saturation (single bonds only versus one or more double bonds) to physical packing.
2. State the consequence: solid versus liquid at room temperature for fats, or amphipathic structure for phospholipid membrane formation.
3. Do not describe exact lipid molecular structure (beyond exam scope).$q$,
  point_attaining_answer = $q$| Feature | Butter | Olive oil |
| Fatty acids | mostly saturated | largely unsaturated |
| Carbon-carbon bonds | only single | one or more double |
| Chain shape | straight, tight packing | kinked, loose packing |
| At room temperature | solid | liquid |

Olive oil's kinks prevent tight packing, so its molecules stay more loosely arranged and the fat remains liquid; butter's chains pack tightly against each other, favoring a solid state.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_biology/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=1 and topic_code='1.5' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='b7485ef9b144f8e3025045146393c5c0';
update app.topic_explainers set
  core_idea = $q$- DNA is an antiparallel double helix held together by hydrogen bonds between complementary bases: adenine with thymine, cytosine with guanine.
- RNA is typically single-stranded and pairs adenine with uracil; DNA uses deoxyribose and RNA uses ribose.
- Each strand has directionality: new nucleotides are added only to the 3' end during synthesis.$q$,
  what_students_need_to_understand = $q$- This topic starts the information theme that returns in DNA replication, gene expression, biotechnology, inheritance, and evolution.
- Complementary base pairing (A-T/A-U and C-G) makes nucleotide sequence copyable and readable.
- Strand directionality (5' to 3' synthesis) governs how DNA replication and RNA synthesis proceed.$q$,
  how_this_becomes_points = $q$1. Connect nucleotide sequence to information storage.
2. Name the pairing rule: A-T and C-G in DNA, A-U in RNA.
3. State strand directionality (5' to 3'), or a DNA-versus-RNA difference (deoxyribose/ribose, thymine/uracil, double/single-stranded).$q$,
  point_attaining_answer = $q$Base pairing requires A with T and C with G, so the complement of ATGC is TACG.

Because DNA strands are antiparallel, the complementary strand must be written running the opposite way: 3'-TACG-5', which read 5' to 3' is 5'-GCAT-3'.

Each strand's sugar-phosphate backbone has an inherent directionality, and new nucleotides can only be added to a growing strand's 3' end, so the two strands must be oriented oppositely to be synthesizable and to pair correctly base-by-base.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_biology/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=1 and topic_code='1.6' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='5d42996bd2d1788cca82193018fec312';
update app.topic_explainers set
  core_idea = $q$- Four levels, each with its own driver: primary is the amino acid sequence; secondary (alpha-helices, beta-sheets) comes from backbone hydrogen bonds.
- Tertiary is the overall 3D shape, driven by R-group hydrogen bonds, hydrophobic and ionic interactions, and disulfide bridges.
- Quaternary arises only in multi-chain proteins, from chains interacting.$q$,
  what_students_need_to_understand = $q$- Proteins are central to enzymes, transport, signaling, structure, movement, and regulation.
- Each of the four levels depends on a distinct interaction, so a change at any level can propagate into a change in function.$q$,
  how_this_becomes_points = $q$1. Name the structural level affected (primary, secondary, tertiary, or quaternary).
2. Name the interaction driving it (peptide bonds, backbone hydrogen bonds, R-group hydrogen/hydrophobic/ionic interactions, disulfide bridges, or inter-chain interactions).
3. Trace the change to a functional consequence.$q$,
  point_attaining_answer = $q$| Level | Effect of breaking the disulfide bridges |
| Primary | unaffected; no peptide bonds were broken |
| Secondary | likely disrupted if the distortion pulls apart hydrogen-bonded regions |
| Tertiary | disrupted; disulfide bridges are R-group interactions holding one chain's 3D shape |
| Quaternary | chains stay associated, but one chain's tertiary shape is wrong, so the functional complex is compromised |$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_biology/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=1 and topic_code='1.7' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='6bf513b5c930d044eca0096626c1df95';
update app.topic_explainers set
  core_idea = $q$- Cell structures have shapes and locations that support specific functions.
- Rough ER is ribosome-studded and builds proteins destined for secretion or membranes; smooth ER lacks ribosomes and handles detoxification and lipid synthesis.
- The Golgi's stacked flattened sacs then fold, modify, and package those proteins for delivery.$q$,
  what_students_need_to_understand = $q$- The endomembrane system is a production line: nucleus, rough ER, Golgi, lysosomes, vacuoles, and plasma membrane each has its own step in making, modifying, packaging, and delivering products.
- Mitochondria's folded inner membrane increases surface area for ATP synthesis.
- Lysosomes' hydrolytic enzymes digest material and drive programmed cell death.$q$,
  how_this_becomes_points = $q$1. Name the specific organelle involved.
2. Describe the structural feature that makes its role possible (ribosome-studded membrane, folded inner membrane, stacked sacs, enzyme-filled sac).
3. Connect that feature to the process it performs.$q$,
  point_attaining_answer = $q$1. Ribosomes attached to the rough ER synthesize the enzyme; the ER folds the growing polypeptide into the ER lumen.
2. Transport vesicles carry it to the Golgi apparatus, whose stacked flattened sacs modify and package it into a secretory vesicle.
3. The vesicle moves to the plasma membrane and fuses with it, releasing the enzyme outside the cell by exocytosis.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_biology/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=2 and topic_code='2.1' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='13792498184f4e32938cf218354b261f';
update app.topic_explainers set
  core_idea = $q$- Cell size is constrained by surface area-to-volume ratio and the need to exchange materials efficiently.
- Surface area scales with the square of linear dimension, volume with the cube: doubling diameter increases exchange surface only 4-fold while resource demand grows 8-fold.
- So cells that grow past a certain size divide rather than keep expanding.$q$,
  what_students_need_to_understand = $q$- As volume grows faster than surface area, SA:V drops and the membrane keeps up less well with the exchange (nutrients, waste, heat) that more cytoplasm demands.
- Membrane folds (microvilli, mitochondrial cristae) add surface area without adding volume.$q$,
  how_this_becomes_points = $q$1. Calculate or compare surface area and volume as size changes.
2. Connect the size change to surface area, volume, exchange rate, and limits on cellular function.$q$,
  point_attaining_answer = $q$| Measure | Cell A | Cell B |
| Surface area | 6 x (2x2) = 24 square micrometers | 6 x (4x4) = 96 square micrometers |
| Volume | 2x2x2 = 8 cubic micrometers | 4x4x4 = 64 cubic micrometers |
| SA:V ratio | 3:1 | 1.5:1 |

Cell B has more total surface area, but its lower ratio means each unit of its cytoplasm has less membrane for exchange, so Cell A is the more efficient exchanger per unit of volume.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_biology/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=2 and topic_code='2.2' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='52c4a98c091dd53bdb8f45f02cf2882e';
update app.topic_explainers set
  core_idea = $q$- The plasma membrane (phospholipid bilayer with embedded proteins) separates internal and external environments.
- Phospholipids are amphipathic: hydrophilic phosphate heads face watery cytoplasm or extracellular fluid, hydrophobic fatty-acid tails face inward.
- Embedded proteins orient hydrophilic regions toward water, hydrophobic ones into the bilayer.$q$,
  what_students_need_to_understand = $q$- Fluid mosaic model: a phospholipid framework studded with mobile proteins, steroids like cholesterol, glycoproteins, and glycolipids.
- All of these components can drift within the bilayer.
- Their orientation is not random; it is set by which parts of each molecule are hydrophilic versus hydrophobic.$q$,
  how_this_becomes_points = $q$1. Connect phospholipid amphipathic structure and membrane proteins to selective movement or communication.
2. Explain why specific regions of proteins or lipids face inward or outward.$q$,
  point_attaining_answer = $q$| Protein region | Position | Why |
| Nonpolar middle stretch | hydrophobic interior of the bilayer, among the fatty-acid tails | repelled by water; stabilized by hydrophobic interactions with the tails |
| Polar and charged ends | outward, contacting the hydrophilic phospholipid heads and the watery cytoplasm or extracellular fluid on either side | stabilized by contact with water rather than lipid tails |$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_biology/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=2 and topic_code='2.3' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='17b3fdf921daee9e0053d0161d9b96c2';
update app.topic_explainers set
  core_idea = $q$- Permeability depends on size, polarity, charge, and available transport proteins.
- Small nonpolar molecules (O2, CO2, N2) dissolve through the hydrophobic interior, crossing freely; small polar uncharged ones (H2O, NH3) pass in smaller amounts.
- Hydrophilic or charged substances are blocked by hydrocarbon tails and need a channel or transport protein.$q$,
  what_students_need_to_understand = $q$- Use this topic to predict which molecules cross membranes and why.
- It also covers the cell wall: in bacteria, archaea, fungi, and plants it sits outside the plasma membrane as a structural boundary and permeability barrier that protects the cell from osmotic lysis when water enters.$q$,
  how_this_becomes_points = $q$1. Explain movement from molecular properties (size, polarity, charge) and membrane composition.
2. Separate substances that cross the lipid bilayer directly from those that need a transport protein.$q$,
  point_attaining_answer = $q$| Molecule | Properties | How it crosses |
| CO2 | small, nonpolar | dissolves through the hydrophobic fatty-acid tails and diffuses across; no protein needed |
| Glucose | large, polar | repelled by the hydrophobic interior; cannot pass the hydrocarbon tails alone, so needs a specific transport protein (carrier or channel) |$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_biology/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=2 and topic_code='2.4' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='5734a328d6af4e96f048c953f3ec2afb';
update app.topic_explainers set
  core_idea = $q$- Passive transport is net movement from high to low concentration with no direct energy input.
- Active transport uses energy (typically ATP) to move a substance from low to high concentration, against its gradient.$q$,
  what_students_need_to_understand = $q$- Transport is central to homeostasis, signaling, and cellular energy use.
- Bulk transport of large molecules or particles differs: endocytosis folds the membrane inward to engulf material from outside; exocytosis fuses a vesicle with the membrane to release material outside.
- Both require energy whether the substance moves up or down a gradient.$q$,
  how_this_becomes_points = $q$1. Identify the gradient, direction of movement, energy requirement, and protein involvement.
2. State whether the mechanism is passive, active, or bulk transport (endocytosis/exocytosis).$q$,
  point_attaining_answer = $q$This is active transport, not passive: glucose moves from low concentration outside the cell to high concentration inside, against its concentration gradient.

Moving a solute against its gradient requires energy input (commonly supplied by ATP or by coupling to another ion's gradient). That is the defining feature of active transport, regardless of whether a membrane protein is involved.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_biology/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=2 and topic_code='2.5' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='43636f923068ffa4f64e5eeb92d4f6b8';
update app.topic_explainers set
  core_idea = $q$- Facilitated diffusion uses membrane proteins to move substances down their concentration gradients without direct energy input.
- Charged ions like Na+ and K+ need specific channel proteins to cross the hydrophobic bilayer.
- Aquaporins are channel proteins that let large quantities of water cross far faster than through the lipid bilayer alone.$q$,
  what_students_need_to_understand = $q$- It links protein structure to membrane permeability and homeostasis.
- Facilitated diffusion is still diffusion: it always moves a substance from high to low concentration and never requires ATP.
- The channel provides a path, not a driving force, so the rate still depends on the size of the concentration gradient.$q$,
  how_this_becomes_points = $q$1. Explain that a specific channel or carrier allows movement down the gradient.
2. Identify the transport protein type: channel versus carrier, or aquaporin specifically for water.$q$,
  point_attaining_answer = $q$Aquaporins are channel proteins that form a specific passage through the hydrophobic bilayer, letting water cross far more quickly than by diffusing through the lipid tails directly.

Water still moves down its own concentration (or water potential) gradient, so this is facilitated diffusion, not active transport, and it requires no ATP.

The aquaporin simply provides a faster path for water that would move in that direction anyway.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_biology/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=2 and topic_code='2.6' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='dcbc9e261a8994c1d0343e3d84612c33';
update app.topic_explainers set
  core_idea = $q$- Tonicity describes how surrounding solute concentration affects water movement across membranes.
- Water potential combines pressure potential and solute potential: Psi = Psi_p + Psi_s, with Psi_s = -iCRT.
- Water always moves from the solution with higher (less negative) water potential to the one with lower (more negative) water potential.$q$,
  what_students_need_to_understand = $q$- This is a common AP context for predicting cell volume changes and homeostatic regulation.
- More dissolved solute gives a more negative solute potential, lowering water potential and pulling water toward it.
- So cells in a hypertonic solution lose water and shrink; in a hypotonic solution they gain water and can swell or lyse.$q$,
  how_this_becomes_points = $q$1. Identify the relative solute concentrations.
2. Calculate or compare water potential.
3. Predict water movement toward the more negative Psi.
4. Explain the effect on the cell.$q$,
  point_attaining_answer = $q$1. The cell's water potential is Psi = Psi_p + Psi_s = 0 + (-0.5) = -0.5 MPa.
2. The surrounding solution's water potential is -0.2 MPa, so the cell's water potential is lower (more negative).
3. Water moves from higher (less negative) to lower (more negative) water potential, so water will move into the cell from the solution, not out of it.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_biology/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=2 and topic_code='2.7' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='9cd0fdfee021bccea80d82d811bd9836';
update app.topic_explainers set
  core_idea = $q$- Cells use channels, carriers, pumps, endocytosis, and exocytosis to move materials across membranes.
- The Na+/K+ pump is a specific ATPase that uses ATP to actively transport Na+ out of the cell and K+ in, against their gradients.
- This maintains the membrane potential and keeps electrochemical gradients available for other transport.$q$,
  what_students_need_to_understand = $q$- Different mechanisms match different molecule types, gradient directions, and energy demands.
- The Na+/K+ pump continuously moves ions against their gradients, so it requires a steady supply of ATP.
- If ATP production stops, the pump fails and the membrane potential needed for signaling and other transport cannot be maintained.$q$,
  how_this_becomes_points = $q$1. Choose the mechanism that fits the substance and explain why it is needed.
2. For pump items, name the ATP requirement.
3. Name the resulting membrane potential.$q$,
  point_attaining_answer = $q$The pump requires ATP because it moves both ions against their gradients; moving any solute against its gradient requires energy input, which the pump gets by hydrolyzing ATP.

| Ion | Moves from | Moves to |
| Na+ | low concentration inside | high concentration outside |
| K+ | low concentration outside | high concentration inside |

It exports 3 positive charges for every 2 it imports, making the cell's interior more negative relative to the outside, helping establish and maintain the membrane potential.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_biology/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=2 and topic_code='2.8' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='57d875dc8ae5d09004e3adaface21ce4';
update app.topic_explainers set
  core_idea = $q$- Compartmentalization separates cellular processes into membrane-bound spaces with distinct conditions.
- Internal membranes minimize competing interactions between reactions that would interfere if they shared one open space.
- They also increase the total surface area available for reactions on or across a membrane.$q$,
  what_students_need_to_understand = $q$- It explains how eukaryotic cells increase efficiency, regulate reactions, and maintain incompatible environments.
- A compartment can maintain conditions, such as pH or enzyme concentration, that would disrupt reactions elsewhere in the cell.
- Isolating a process behind a membrane can make it both faster and safer for the rest of the cell.$q$,
  how_this_becomes_points = $q$1. Link a compartment to the process it supports.
2. Name the advantage of separation: reduced competing interactions or increased reaction surface area.$q$,
  point_attaining_answer = $q$The lysosome's hydrolytic enzymes work optimally at the low, acidic pH maintained inside it, but that acidic, protein-degrading environment would damage other cellular components if it existed freely in the cytosol.

Enclosing the enzymes in a compartment held at a different pH than the cytosol minimizes competing interactions: they digest their intended targets without breaking down proteins and structures elsewhere in the cell.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_biology/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=2 and topic_code='2.9' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='cc443845def9aaa9c18298f12cdf8130';
update app.topic_explainers set
  core_idea = $q$- Endosymbiotic theory explains the origin of mitochondria and chloroplasts from ancestral prokaryotes.
- Evidence: double membranes (one from the engulfed prokaryote, one from the host's vesicle) and circular DNA like bacterial chromosomes.
- Also their own ribosomes, distinct from cytoplasmic ones, and independent division like bacterial binary fission.$q$,
  what_students_need_to_understand = $q$- This topic connects cell structure to evolution and evidence-based biological claims.
- Prokaryotes typically lack membrane-bound organelles but have specialized internal regions; eukaryotic internal membranes partition the cell.
- Mitochondria and chloroplasts are the clearest evidence that some compartments began as separate free-living organisms.$q$,
  how_this_becomes_points = $q$1. Cite evidence such as double membranes, circular DNA, ribosomes, or division by binary fission.
2. Connect it to ancestry.
3. Ideally name more than one line of evidence rather than just asserting the theory.$q$,
  point_attaining_answer = $q$| Observation | Why it supports the theory |
| Double membrane | inner membrane from the engulfed free-living prokaryote, outer from the host's engulfing vesicle |
| Circular DNA, distinct from linear nuclear DNA | matches the circular chromosome typical of bacteria |
| Ribosomes differing in size from cytoplasmic ones | resemble prokaryotic, not eukaryotic, ribosomes |

Together, these three independent features point to mitochondria originating as free-living prokaryotes permanently incorporated into a host cell.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_biology/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=2 and topic_code='2.10' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='bc1d5e87f25a78785b3908eeff77b190';
update app.topic_explainers set
  core_idea = $q$- Enzymes are protein catalysts that speed reactions by lowering the activation energy required.
- In the enzyme-substrate complex model, a substrate's shape and charge must fit the active site for catalysis to occur.
- Fit is often through induced fit, where the active site changes shape slightly as it binds.$q$,
  what_students_need_to_understand = $q$- Enzyme questions connect protein structure, reaction rate, regulation, and environmental conditions.
- Catalysis requires a specific molecular fit between an active site and its substrate.
- Induced fit often refines it: the site closes slightly around the bound substrate to stabilize the transition state.$q$,
  how_this_becomes_points = $q$1. Connect active-site shape, substrate specificity, and activation energy to reaction outcomes.
2. Explicitly invoke the enzyme-substrate complex or induced-fit model when asked why an enzyme works on one substrate but not another.$q$,
  point_attaining_answer = $q$| Substrate | Fit with sucrase's active site | Result |
| Sucrose | complementary shape and charge distribution | binds; enzyme-substrate complex forms |
| Lactose | different molecular shape and charge arrangement | cannot bind; no reaction occurs |

This specificity is what makes sucrase effective only on its matching substrate, not sugars in general.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_biology/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=3 and topic_code='3.1' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='cd9371223f463a31cc8a5ab6a483f041';
update app.topic_explainers set
  core_idea = $q$- Temperature, pH, salinity, and other conditions can alter enzyme shape and activity.
- Outside an enzyme's optimum range they disrupt the hydrogen bonds holding its three-dimensional shape together: denaturation.
- Denaturation is sometimes reversible if conditions return to normal before the structure is permanently disrupted.$q$,
  what_students_need_to_understand = $q$- This is a recurring experimental context: connect data trends to molecular explanation.
- Relative substrate/product concentration also affects reaction efficiency.
- Competitive inhibitors bind reversibly at the active site itself; noncompetitive inhibitors bind at a separate allosteric site and still reduce activity.$q$,
  how_this_becomes_points = $q$1. Link the environmental change to protein structure, active-site fit, and reaction rate.
2. Distinguish reversible denaturation from permanent loss of function, or competitive from noncompetitive inhibition, when the question requires it.$q$,
  point_attaining_answer = $q$At pH 7, the enzyme's hydrogen bonds maintain the three-dimensional shape its active site needs to bind substrate, giving maximum activity.

| pH | Effect | After return to pH 7 |
| 4 | shift from optimum disrupts hydrogen bonds, altering shape and reducing catalytic ability (denaturation) | partial recovery: reversible, hydrogen bonds able to reform correctly |
| 10 | same disruption of hydrogen bonds | no recovery: more permanent disruption of structure |$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_biology/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=3 and topic_code='3.2' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='ed25a909d93eb2ef34455a6b5094ac76';
update app.topic_explainers set
  core_idea = $q$- Cells use energy coupling and ATP to drive processes that require energy input.
- Highly ordered living systems must continually take in more energy than they lose, consistent with the first and second laws of thermodynamics.
- ATP hydrolysis releases energy in a stepwise sequence where each pathway's product typically becomes the next step's reactant.$q$,
  what_students_need_to_understand = $q$- This supports understanding of transport, biosynthesis, movement, photosynthesis, and respiration.
- Core metabolic pathways such as glycolysis and oxidative phosphorylation are conserved across Archaea, Bacteria, and Eukarya.
- So this energy-coupling logic is evidence of the pathways' common ancestry across all three domains of life.$q$,
  how_this_becomes_points = $q$1. Explain how ATP hydrolysis or coupled reactions make an unfavorable process possible.
2. Recognize that a pathway's steps are sequential, with one step's product serving as the next step's reactant.$q$,
  point_attaining_answer = $q$1. ATP hydrolysis breaks the bond to its terminal phosphate group, releasing energy and transferring that phosphate to the transport protein in a coupled reaction.
2. This phosphorylation changes the transport protein's shape, driving the energetically unfavorable movement of the solute against its gradient.

The energy-releasing hydrolysis of ATP is directly coupled to the energy-requiring transport step, rather than the two happening independently.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_biology/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=3 and topic_code='3.3' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='338eca7340d6cde0b528eddf2f3613b9';
update app.topic_explainers set
  core_idea = $q$- Photosynthesis converts light energy into chemical energy in sugars via linked light reactions and carbon fixation.
- It first evolved in prokaryotes; cyanobacteria produced Earth's oxygenated atmosphere.
- Light reactions: chlorophyll boosts electrons in photosystems II and I; splitting water replaces electrons lost at photosystem II and releases oxygen.$q$,
  what_students_need_to_understand = $q$- It connects energy flow, organelle structure, electron transport, carbon cycling, and environmental inputs.
- Light reactions: thylakoid membranes (organized into grana); Calvin cycle: stroma.
- The electron transport chain's proton gradient is converted to ATP by chemiosmosis through ATP synthase, as in cellular respiration.$q$,
  how_this_becomes_points = $q$1. Link inputs, locations, products, and energy transformations across the two stages.
2. Name the thylakoid membrane and stroma as the sites and describe the proton-gradient/ATP-synthase mechanism.
3. Calvin-cycle step names and molecule structures are outside the tested scope.$q$,
  point_attaining_answer = $q$1. In the thylakoid membrane, chlorophyll absorbs light energy and an electron transport chain moves electrons from photosystem II to photosystem I, establishing a proton gradient across it.
2. Chemiosmosis through ATP synthase uses that gradient to generate ATP; electrons reduce NADP+ to NADPH at photosystem I.
3. ATP and NADPH diffuse into the stroma, supplying the energy and reducing power the Calvin cycle needs to build carbohydrates from carbon dioxide (no Calvin-cycle step names needed).$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_biology/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=3 and topic_code='3.4' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='69e822cfb3033df1b43854d1e8551d7f';
update app.topic_explainers set
  core_idea = $q$- Cellular respiration transfers energy from organic molecules to ATP through glycolysis, oxidation steps, and electron transport.
- Fermentation lets glycolysis continue without oxygen by producing alcohol or lactic acid.
- This core process, with fermentation, occurs in some form across all living organisms, not only those with mitochondria.$q$,
  what_students_need_to_understand = $q$- A heavily tested energetics topic, often in data and experiment questions.
- The Krebs cycle (matrix) reduces NAD+ and FAD, releasing CO2; NADH and FADH2 carry electrons to the electron transport chain.
- The chain's proton gradient across the inner membrane (matrix at higher pH than intermembrane space) is converted to ATP by ATP synthase (chemiosmosis).$q$,
  how_this_becomes_points = $q$1. Connect molecule breakdown, electron carriers, proton gradients, oxygen, and ATP production.
2. Locate each stage: glycolysis in the cytosol, the Krebs cycle in the matrix, the electron transport chain across the inner mitochondrial membrane.$q$,
  point_attaining_answer = $q$1. Glycolysis does not require oxygen and continues in the cytosol, producing a small amount of ATP and NADH directly from glucose.
2. Without oxygen as the final electron acceptor, the electron transport chain backs up and NADH cannot be reoxidized to NAD+ fast enough to keep glycolysis running.
3. The cell shifts to fermentation, converting pyruvate to lactic acid or alcohol, which regenerates NAD+ so glycolysis keeps producing its smaller amount of ATP.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_biology/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=3 and topic_code='3.5' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='b3a621cfb9f226c975e5f613520b28f6';
update app.topic_explainers set
  core_idea = $q$- Cell communication uses signals, receptors, and responses to coordinate activity across cells.
- Three main modes: direct contact between adjacent cells; short-distance local (paracrine) signaling to nearby cells; and long-distance signaling, where a signal travels through the body to a distant target cell.$q$,
  what_students_need_to_understand = $q$- It supports explanations of development, immune responses, homeostasis, and environmental response.
- Local regulators act on nearby cells over a short distance.
- Long-distance signals such as hormones can travel through the bloodstream to reach specific target cells elsewhere in the body.$q$,
  how_this_becomes_points = $q$1. Connect signal reception to a cellular response and explain how specificity is achieved.
2. Classify a described signaling event as direct contact, short-distance/local, or long-distance, by how far the signal travels and how it reaches its target.$q$,
  point_attaining_answer = $q$| Signal | How it travels | Reach |
| Endocrine gland's hormone | released into the bloodstream, travels throughout the body | only cells with a matching receptor, however far away: long-distance signaling |
| Injured cell's local regulator | diffuses through extracellular fluid but is broken down or diluted before it travels far | only cells in its immediate vicinity: short-distance/local (paracrine) signaling |

Both rely on receptor specificity to pick responding cells; distance depends on delivery.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_biology/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=4 and topic_code='4.1' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='8727a420e762b44df38bf6f019c2ac91';
update app.topic_explainers set
  core_idea = $q$- Signal transduction converts an external or internal signal into intracellular molecular changes in three stages: reception, transduction, and response.
- It begins when a ligand binds a receptor with a highly specific binding domain, such as a G-protein-coupled receptor (GPCR) on the cell surface.$q$,
  what_students_need_to_understand = $q$- It is the mechanism that turns communication into altered cell behavior.
- Receptors can sit on the cell surface, in the cytoplasm, or in the nucleus, depending on whether the ligand can cross the plasma membrane.
- Many pathways relay the signal through a phosphorylation cascade or second messengers like cAMP.$q$,
  how_this_becomes_points = $q$1. Explain the sequence reception -> transduction -> response.
2. Match the ligand's chemical properties to its receptor's location.
3. Hydrophobic ligands cross the membrane to intracellular or nuclear receptors; hydrophilic ligands bind surface receptors like GPCRs.$q$,
  point_attaining_answer = $q$| Feature | Steroid hormone | Peptide hormone |
| Property | lipid-soluble | hydrophilic; cannot cross the membrane |
| Receptor | inside the cytoplasm or nucleus | G-protein-coupled receptor on the cell surface |
| Effect | diffuses across the phospholipid bilayer; directly affects gene expression | triggers an intracellular cascade, often with a second messenger like cAMP, without the hormone itself entering |$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_biology/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=4 and topic_code='4.2' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='5cfde000019209e7bd03d162d3c3e036';
update app.topic_explainers set
  core_idea = $q$- Signal transduction pathways often use cascades, phosphorylation, second messengers, and amplification.
- Changing any single component, through mutation or a chemical that activates or inhibits it, can alter every downstream step.
- The end result can be changed gene expression, cell phenotype, or even apoptosis.$q$,
  what_students_need_to_understand = $q$- AP questions reward mechanistic explanations of how a small signal produces a larger or specific response.
- A pathway's downstream response can turn genes on or off, change the cell's phenotype, or initiate programmed cell death (apoptosis), depending on which genes or proteins the cascade ultimately affects.$q$,
  how_this_becomes_points = $q$1. Trace the pathway order.
2. Explain how a change to one component affects the downstream response.
3. Predict what happens when a mutation locks a component permanently on or off regardless of the original signal.$q$,
  point_attaining_answer = $q$1. The kinase is locked in its active form, so it keeps phosphorylating and activating the next component in the cascade continuously, whether or not the original ligand has bound its receptor.
2. The transcription factor at the end of the pathway is activated without the normal upstream signal, so the growth genes are switched on constitutively.
3. The cell receives an uncontrolled 'grow' signal independent of outside conditions, which can drive unregulated proliferation.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_biology/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=4 and topic_code='4.3' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='e04c27f51ea9a0f72734df63b3bf983d';
update app.topic_explainers set
  core_idea = $q$- Feedback loops regulate systems by using outputs to influence earlier steps; the direction of that influence defines the loop.
- Negative feedback reduces a stimulus back toward a set point to maintain homeostasis.
- Positive feedback amplifies the original stimulus until a decisive endpoint, such as childbirth or blood clotting, is reached.$q$,
  what_students_need_to_understand = $q$- Negative feedback supports homeostasis; positive feedback amplifies a process toward an endpoint.
- Most regulatory systems, like temperature and blood glucose control, rely on negative feedback.
- Positive feedback is reserved for processes that must reach a specific conclusion quickly, like labor contractions or clot formation.$q$,
  how_this_becomes_points = $q$1. Identify the variable, stimulus, and response.
2. State whether the loop reduces or amplifies the original change.
3. Justify the classification with the response's specific effect on the original stimulus, not just a loop-type name.$q$,
  point_attaining_answer = $q$| | Blood glucose | Labor |
| Stimulus | rising blood glucose | cervical stretching |
| Response | insulin release lowers blood glucose | oxytocin release increases contraction strength |
| Effect on stimulus | reduces the very stimulus that caused it, driving the system back toward its set point | increases cervical stretching even further, amplifying the process until birth occurs |
| Type | negative feedback | positive feedback |

Labor is positive: the response strengthens, not reverses, the stimulus.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_biology/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=4 and topic_code='4.4' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='4d0f0c8d261049037ebc011953214b3d';
update app.topic_explainers set
  core_idea = $q$- The cell cycle coordinates growth, DNA replication, and division through ordered phases.
- Interphase has three sub-phases: G1 (organelle and cytosolic growth), S (DNA replicates into sister chromatids), and G2 (further protein synthesis, ATP production, and centrosome replication).
- The cell then enters mitosis.$q$,
  what_students_need_to_understand = $q$- It connects cellular reproduction to inheritance, development, and regulation.
- Cells that stop dividing can exit the cycle into a non-dividing G0 state.
- Checkpoints throughout the cycle can hold a cell in place until conditions are appropriate to proceed.$q$,
  how_this_becomes_points = $q$1. Place events in the correct phase and explain why ordering matters for accurate division.
2. Use specific evidence, such as DNA content or centrosome/spindle status, to justify the exact phase.
3. Do not stop at a broad label like 'interphase.'$q$,
  point_attaining_answer = $q$| Evidence | Meaning |
| Doubled DNA content | S phase has already completed, ruling out G1 |
| Doubled centrosomes | consistent with G2, when centrosome replication occurs alongside more protein synthesis and ATP production to prepare for division |
| Nuclear envelope intact, no spindle fibers | not yet prophase of mitosis, where the envelope breaks down and the spindle assembles |

So this cell is in G2 of interphase, not mitosis.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_biology/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=4 and topic_code='4.5' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='aa7e9521ba4f4c1c6c85c2c426dbd34d';
update app.topic_explainers set
  core_idea = $q$- Checkpoints and regulatory proteins help prevent division when DNA or cell conditions are not ready.
- This control relies on cyclin and cyclin-dependent kinase (CDK) interactions.
- When checkpoints fail, a cell can keep dividing with damaged DNA, which can lead to cancer or, if the damage is severe enough, trigger apoptosis instead.$q$,
  what_students_need_to_understand = $q$- This topic links signaling, mutation, cancer, and inheritance of cellular errors.
- Internal checkpoints monitor conditions like DNA integrity before allowing the cycle to proceed.
- Cyclin-CDK activity enforces those checkpoints; there is no need to name specific cyclin-CDK pairs.$q$,
  how_this_becomes_points = $q$1. Describe the normal cyclin-CDK-based checkpoint function first.
2. Then explain how checkpoint failure or regulatory disruption changes cell division outcomes.$q$,
  point_attaining_answer = $q$| | Normal checkpoint | With the checkpoint mutation |
| Control | cyclin-CDK activity detects DNA damage during S phase and halts the cycle | cyclin-CDK-based control is bypassed |
| Outcome | time to repair the damage, or apoptosis if it is too severe, so damaged DNA is never passed on | cell replicates and divides despite the damage, passing mutations to daughter cells |

This kind of checkpoint failure, allowing continued division of cells with accumulating damage, is a key mechanism underlying cancer.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_biology/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=4 and topic_code='4.6' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='4a94dc0029753da0ed76a883ee107f34';
update app.topic_explainers set
  core_idea = $q$- Meiosis produces haploid gametes.
- It does so through two divisions after one round of DNA replication.$q$,
  what_students_need_to_understand = $q$- It is the foundation for inheritance.
- It also underlies genetic diversity and allele segregation.$q$,
  how_this_becomes_points = $q$1. Track homologous chromosomes and sister chromatids.
2. Track ploidy.
3. Track gamete outcomes across meiosis I and II.$q$,
  point_attaining_answer = $q$Separate meiosis I from meiosis II.

| Division | What separates |
| Meiosis I | homologs |
| Meiosis II | sister chromatids |

Then make the scoring connection explicit: track homologous chromosomes, sister chromatids, ploidy, and gamete outcomes across meiosis I and II.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_biology/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=5 and topic_code='5.1' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='0bc3a71683451a40a40908881f6e7c46';
update app.topic_explainers set
  core_idea = $q$- Crossing over creates genetic variation among gametes.
- Independent assortment also creates genetic variation among gametes.$q$,
  what_students_need_to_understand = $q$- This topic explains how sexual reproduction increases variation.
- That variation is what later evolution can act on.$q$,
  how_this_becomes_points = $q$1. Name a meiotic event.
2. Connect it to new allele combinations in gametes or offspring.$q$,
  point_attaining_answer = $q$1. Name crossing over or independent assortment.
2. Explain the specific source of variation.

Then make the scoring connection explicit: connect a meiotic event to new allele combinations in gametes or offspring.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_biology/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=5 and topic_code='5.2' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='dd5a166cc63000aad4faa07f22c5cfff';
update app.topic_explainers set
  core_idea = $q$- Mendelian genetics predicts inheritance patterns for traits controlled by alleles.
- Those alleles segregate and assort.$q$,
  what_students_need_to_understand = $q$- It is a common quantitative and reasoning context.
- It connects meiosis to offspring outcomes.$q$,
  how_this_becomes_points = $q$1. Assign genotypes.
2. Set up crosses.
3. Interpret probabilities or phenotypic ratios.$q$,
  point_attaining_answer = $q$1. Define alleles and parental genotypes.
2. Then build the Punnett square or probability setup.

Then make the scoring connection explicit: assign genotypes, set up crosses, and interpret probabilities or phenotypic ratios.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_biology/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=5 and topic_code='5.3' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='b14c5b3699e09b5f888f6220454c169c';
update app.topic_explainers set
  core_idea = $q$- Non-Mendelian patterns are inheritance that does not follow simple expectations.
- Those expectations are simple dominant-recessive, single-gene inheritance.$q$,
  what_students_need_to_understand = $q$- It broadens genetics reasoning to sex linkage, codominance, and incomplete dominance.
- It also covers polygenic traits and environmental interactions.$q$,
  how_this_becomes_points = $q$1. Identify the inheritance pattern from evidence.
2. Adjust genotype-to-phenotype reasoning accordingly.$q$,
  point_attaining_answer = $q$1. Use the data pattern to choose the inheritance model.
2. Then calculate outcomes.

Then make the scoring connection explicit: identify the inheritance pattern from evidence and adjust genotype-to-phenotype reasoning accordingly.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_biology/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=5 and topic_code='5.4' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='0b404ece8f81651ca046e32b706bb77b';
update app.topic_explainers set
  core_idea = $q$- Phenotype results from genotype interacting with environmental conditions.
- Genotype sets a potential, which the environment shifts.$q$,
  what_students_need_to_understand = $q$- This topic prevents oversimplified genetic explanations.
- It connects heredity to variation and natural selection.$q$,
  how_this_becomes_points = $q$1. Identify the environmental factor.
2. Explain how it changes gene expression, development, or observable trait value.$q$,
  point_attaining_answer = $q$1. State genotype potential.
2. Then explain how the environment shifts the phenotype.

Then make the scoring connection explicit: explain how an environmental factor changes gene expression, development, or observable trait value.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_biology/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=5 and topic_code='5.5' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='a8392d269b35dfc22e817de04246a1eb';
do $$ begin if (select count(*) from app.topic_explainers where subject_key='ap_biology' and topic_code in ('1.1','1.2','1.3','1.4','1.5','1.6','1.7','2.1','2.2','2.3','2.4','2.5','2.6','2.7','2.8','2.9','2.10','3.1','3.2','3.3','3.4','3.5','4.1','4.2','4.3','4.4','4.5','4.6','5.1','5.2','5.3','5.4','5.5') and source_note like '%Structured 2026-11-13 (recommendation #3%')<>33 then raise exception 'expected 33 rows updated'; end if; end $$;
commit;
