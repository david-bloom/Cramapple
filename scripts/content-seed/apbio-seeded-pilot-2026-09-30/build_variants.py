# Builds variants_items.json from the texts below. DO NOT RE-RUN after the file has been checked or loaded anywhere:
# correct-answer letters are drawn at random on every run (seeded per item here, but any edit to a choice changes the draw).
import json, random, sys, os
OUT = os.path.join(os.path.dirname(__file__), "variants_items.json")
if os.path.exists(OUT) and "--force" not in sys.argv:
    sys.exit("variants_items.json exists; refusing to rebuild (letters would be redrawn). Use --force only before any check or load.")
L = "ABCD"
# (key, seed, unit, topic, change, stimulus, question, correct(text, rationale), [distractors (text, rationale)] )
V = []
def v(key, seed, unit, topic, change, stim, q, correct, distractors): V.append((key, seed, unit, topic, change, stim, q, correct, distractors))

v("apbio-mcq-sv-005-v1","APBIO-MCQ-005",1,"1.3","fructose/GLUT5 -> galactose/bacterial transport protein; same sugar-isomer principle, transport protein kept (an enzyme framing drifted to Unit 3)",
 "Glucose and galactose are monosaccharides with the same molecular formula, C6H12O6. They differ only in the orientation of the hydroxyl group on carbon 4, which points in opposite directions in the two sugars. A transport protein in the plasma membrane of a bacterium moves galactose into the cell efficiently but moves glucose across the membrane very poorly.",
 "Which statement best explains how this transport protein can distinguish between the two sugars?",
 ("They are isomers, and one hydroxyl group's different orientation gives each sugar a different shape, so only galactose fits the binding site.",
  "Correct. Isomers have the same atoms in different spatial arrangements, so they have different three-dimensional shapes, and a transport protein's binding site can fit one and not the other."),
 [("Galactose contains more carbon, hydrogen, and oxygen atoms than glucose, so the transport protein binds it more strongly.",
   "Incorrect. The stimulus states that both sugars have the molecular formula C6H12O6, so their atom counts are identical."),
  ("Galactose carries an extra hydroxyl group that glucose lacks, and the transport protein specifically recognizes that additional group.",
   "Incorrect. Both sugars have the same number of hydroxyl groups; what differs is the orientation of the one on carbon 4."),
  ("Galactose is a disaccharide, so a different kind of transport protein is required than the one that moves glucose.",
   "Incorrect. Galactose is a monosaccharide, like glucose, not a disaccharide.")])
v("apbio-mcq-sv-005-v2","APBIO-MCQ-005",1,"1.3","fructose/GLUT5 -> mannose/bacterial surface protein; amino-acid version dropped (specific amino acid structure is an explicit CED exclusion)",
 "Glucose and mannose are monosaccharides with the same molecular formula, C6H12O6. They differ only in the orientation of the hydroxyl group on carbon 2. A protein on the surface of a bacterium attaches tightly to mannose on the surface of host cells but attaches only weakly to glucose.",
 "Which statement best explains how this protein can distinguish between the two sugars?",
 ("They are isomers, and one hydroxyl group's different orientation gives each sugar a different shape, so only mannose fits the binding site.",
  "Correct. Isomers have the same atoms in different arrangements, which gives them different three-dimensional shapes and lets a binding site discriminate between them."),
 [("Mannose has a different molecular formula than glucose, so its atoms interact differently with the protein's binding site.",
   "Incorrect. The stimulus states that both sugars have the molecular formula C6H12O6, so they contain the same atoms."),
  ("Only mannose has a hydroxyl group on carbon 2, and the protein must make direct contact with that specific group.",
   "Incorrect. Both sugars have a hydroxyl group on carbon 2; the difference is how it is oriented."),
  ("Glucose is a polysaccharide, so it is too large to fit into the binding site of the protein on the bacterium.",
   "Incorrect. Glucose is a monosaccharide, not a polysaccharide.")])
v("apbio-mcq-sv-008-v1","APBIO-MCQ-008",1,"1.1","Glu6Val sickle hemoglobin -> surface Thr->Ile on a soluble enzyme; low-oxygen fibers -> clumping at high concentration",
 "A soluble bacterial enzyme normally stays dissolved even at high concentration. A mutant form has a single amino acid substitution in which a surface-exposed threonine (polar, uncharged) is replaced by isoleucine (nonpolar, hydrophobic). At high concentration the mutant enzyme forms insoluble clumps, while the normal enzyme does not. Both forms fold into the same overall three-dimensional shape and are fully active when dissolved.",
 "Which best explains why the mutant enzyme forms clumps?",
 ("The exposed nonpolar isoleucine side chains on different enzyme molecules associate through hydrophobic interactions, away from the surrounding water.",
  "Correct. A nonpolar group on the protein's surface tends to avoid water and to associate with nonpolar groups on other molecules, which can build insoluble aggregates without changing each protein's fold."),
 [("Isoleucine's larger side chain disrupts the enzyme's overall fold, so the mutant partly unfolds and tangles with other enzyme molecules in solution.",
   "Incorrect. The stimulus states that both forms fold into the same overall shape; the change acts through the surface chemistry, not through unfolding."),
  ("Isoleucine forms disulfide bonds between separate enzyme molecules, linking them together in a way that threonine cannot.",
   "Incorrect. Disulfide bonds form between cysteine residues; isoleucine contains no sulfur and cannot form them."),
  ("The substitution damages the enzyme's catalytic site, and the resulting loss of activity makes the protein precipitate out of solution.",
   "Incorrect. The stimulus states that the mutant is fully active when dissolved; clumping is not caused by loss of catalytic function.")])
v("apbio-mcq-sv-008-v2","APBIO-MCQ-008",1,"1.1","hydrophobic gain-of-aggregation -> charged substitution that reduces aggregation (reverse direction)",
 "A therapeutic protein tends to clump when stored at high concentration. The clumping occurs through contacts between nonpolar leucine side chains that are exposed on the protein's surface. Engineers make a single substitution that replaces one of these surface leucines with glutamate (negatively charged at physiological pH). The modified protein folds into the same shape and stays dissolved at high concentration.",
 "Which best explains why the substitution reduces clumping?",
 ("Glutamate's charged side chain interacts with water and repels neighboring proteins, which removes a nonpolar contact that held molecules together.",
  "Correct. A charged surface group is favorably hydrated and repels like charges on other molecules, so the hydrophobic contact that drove aggregation is lost."),
 [("Glutamate forms covalent peptide bonds with neighboring proteins that lock each protein into a single compact shape.",
   "Incorrect. Peptide bonds link amino acids within a polypeptide chain; a side chain does not form them between separate proteins, and the stimulus says the fold is unchanged."),
  ("Glutamate makes the protein fold into a smaller shape that buries its other nonpolar groups in the interior.",
   "Incorrect. The stimulus states that the modified protein folds into the same shape as before."),
  ("Glutamate is also nonpolar, so it strengthens the hydrophobic core and stabilizes the protein against clumping.",
   "Incorrect. Glutamate is charged and polar, not nonpolar, and the substituted residue is on the surface, not in the core.")])
v("apbio-mcq-sv-014-v1","APBIO-MCQ-014",2,"2.1","bacterium vs animal-like cell -> cyanobacterium vs algal cell; photosynthetic internal membranes as the trap",
 "Two photosynthetic cells are compared under electron microscopy. Cell 1 is approximately 3 μm in diameter and has a single circular chromosome in the cytoplasm and photosynthetic pigments embedded in folded internal membranes. It has no nucleus and no chloroplasts. Cell 2 is approximately 12 μm in diameter and has multiple linear chromosomes inside a double-membrane nucleus and chloroplasts.",
 "Which conclusion about cell classification is most directly supported by the observations?",
 ("Cell 1 is prokaryotic because it has no nucleus, and Cell 2 is eukaryotic because it has a nucleus and membrane-bound chloroplasts.",
  "Correct. Cell 1 has a circular chromosome in the cytoplasm and no nucleus or membrane-bound organelles, which supports prokaryotic classification. Cell 2 has a nucleus, linear chromosomes, and chloroplasts, which support eukaryotic classification."),
 [("Cell 1 is eukaryotic because it carries out photosynthesis on internal membranes, which only organelles can provide.",
   "Incorrect. Some prokaryotes, such as cyanobacteria, photosynthesize on folded internal membranes without having membrane-bound organelles or a nucleus."),
  ("Cell 2 is prokaryotic because chloroplasts carry out photosynthesis, a process that bacteria also perform.",
   "Incorrect. Sharing a process does not decide classification; the nucleus, linear chromosomes, 80S ribosomes, and chloroplasts show that Cell 2 is eukaryotic."),
  ("Both cells are eukaryotic because both are photosynthetic and both contain DNA.",
   "Incorrect. Both prokaryotes and eukaryotes contain DNA, and photosynthesis occurs in both groups, so neither feature classifies a cell.")])
v("apbio-mcq-sv-014-v2","APBIO-MCQ-014",2,"2.1","bacterium vs eukaryote -> bacterium vs yeast; cell wall and plasmid as the traps",
 "A microscopist compares two single-celled organisms. Organism 1 is approximately 1 μm long and has one circular chromosome in a region of cytoplasm with no surrounding membrane, a small circular plasmid, and a peptidoglycan cell wall. Organism 2 is approximately 6 μm in diameter and has linear chromosomes enclosed in a nuclear envelope, mitochondria, and a cell wall made of chitin.",
 "Which conclusion about how these organisms should be classified is most directly supported by the observations?",
 ("Organism 1 is prokaryotic because its DNA lacks a surrounding membrane, and Organism 2 is eukaryotic because it has a nucleus.",
  "Correct. A chromosome in an unbounded region of cytoplasm indicates a prokaryote. A nuclear envelope and mitochondria indicate a eukaryote."),
 [("Organism 2 is prokaryotic because it has a cell wall, just as Organism 1 does, and cell walls are a prokaryotic feature.",
   "Incorrect. Cell walls occur in prokaryotes, fungi, and plants, so a wall does not decide classification; the nucleus and mitochondria show that Organism 2 is eukaryotic."),
  ("Organism 1 is eukaryotic because it has two separate DNA molecules, the main chromosome and a small plasmid, in the same cell.",
   "Incorrect. Many prokaryotes carry plasmids; being eukaryotic depends on having a nucleus and membrane-bound organelles, not on the number of DNA molecules."),
  ("Both organisms are prokaryotic because both are single-celled, and single-celled organisms are always prokaryotes.",
   "Incorrect. Many eukaryotes, such as yeast, are single-celled; cell number does not decide classification.")])
v("apbio-mcq-sv-016-v1","APBIO-MCQ-016",2,"2.7","celery strips in three solutions -> potato cores with mass data; stops gaining mass and does not burst",
 "A student weighs potato cores before and after placing them in solutions for 60 minutes. A core in distilled water gains 9% in mass and becomes stiff. A core in 0.2 M sucrose changes very little in mass. A core in 0.8 M sucrose loses 18% of its mass and becomes limp. The student notes that the core in distilled water stops gaining mass after about 45 minutes and that its cells do not burst.",
 "Which best explains why the core in distilled water stops gaining mass and its cells do not burst?",
 ("As water enters, the cell wall resists expansion and turgor pressure rises until it opposes further net water entry.",
  "Correct. Distilled water is hypotonic to the cells, so water enters by osmosis. The wall resists expansion, and the resulting turgor pressure balances the tendency of water to enter, so net movement stops before the membrane ruptures."),
 [("The plasma membranes of the potato cells become impermeable to water once the core is stiff, so osmosis stops.",
   "Incorrect. The membranes remain permeable to water. Net water movement stops because turgor pressure balances the osmotic gradient, not because the membrane blocks water."),
  ("Water keeps entering until the solute concentration inside the cells equals that of distilled water, and then net movement stops.",
   "Incorrect. The cell contents never become as dilute as pure water. Net movement stops when rising turgor pressure counteracts the osmotic gradient."),
  ("Potato cells have the same solute concentration as distilled water, so they neither gain nor lose water.",
   "Incorrect. The core in distilled water gained 9% in mass, so water entered; distilled water is hypotonic to the cells. The solution that changed the mass very little (0.2 M sucrose) is the one closest to isotonic.")])
v("apbio-mcq-sv-016-v2","APBIO-MCQ-016",2,"2.7","turgor in hypotonic solution -> plasmolysis in hypertonic solution (the converse); onion epidermis",
 "A student mounts onion epidermal tissue in distilled water and views it under a microscope. The cells are firm, and the plasma membrane presses against the cell wall. The student replaces the water with a 1 M salt solution. Within minutes the cells shrink, and in the corners of each cell the plasma membrane pulls away from the cell wall, leaving gaps. The plasma membrane remains intact.",
 "Which best explains why the plasma membrane pulls away from the cell wall in the salt solution?",
 ("Water leaves the cells by osmosis toward the more concentrated solution, so the cell contents shrink while the rigid wall keeps its shape.",
  "Correct. Water moves out of the cells toward the more concentrated solution, so the volume of the cell contents decreases. The rigid cell wall does not shrink with them, which leaves a gap."),
 [("Salt enters the cells and dissolves the cell wall, which releases the plasma membrane from its surface.",
   "Incorrect. Salt does not dissolve the cellulose cell wall, and the wall is still present in the observation; it is the cell contents that shrink."),
  ("The cell wall contracts when it contacts the salt solution and pulls itself away from the plasma membrane.",
   "Incorrect. The wall is rigid and does not contract; it is the cell contents inside the wall that decrease in volume."),
  ("Active transport pumps water out of the cells against its concentration gradient, which shrinks the cell contents.",
   "Incorrect. Water crosses membranes passively by osmosis, down its concentration gradient; cells do not actively pump water.")])
v("apbio-mcq-sv-018-v1","APBIO-MCQ-018",2,"2.5","LDL receptor / FH -> transferrin receptor / iron uptake in developing red blood cells",
 "Developing red blood cells obtain iron through receptor-mediated endocytosis. Iron-bound transferrin in the blood binds transferrin receptors, which cluster in clathrin-coated pits on the plasma membrane. The complex is internalized in an endocytic vesicle. In the acidic endosome the iron is released from transferrin and transported into the cytoplasm, and the receptor, still carrying its transferrin, returns to the plasma membrane. A rare inherited mutation prevents transferrin receptors from reaching the cell surface of developing red blood cells.",
 "Which prediction about individuals with this mutation is best supported by the described mechanism?",
 ("Iron-bound transferrin will remain in the blood at high levels because developing red blood cells cannot specifically bind and internalize it.",
  "Correct. Without surface receptors, clathrin-coated pits cannot concentrate iron-bound transferrin for internalization, so it is not cleared from the blood by these cells."),
 [("Developing red blood cells will compensate by increasing nonspecific phagocytosis of iron-bound transferrin.",
   "Incorrect. Nonspecific uptake does not selectively replace a missing receptor, and the description gives no evidence that such a pathway would supply enough iron."),
  ("Hemoglobin synthesis will increase because more iron stays outside the cells, where it can diffuse freely into the cytoplasm.",
   "Incorrect. Iron-bound transferrin cannot diffuse across the plasma membrane. Less iron entering the cells means less heme and hemoglobin synthesis, not more."),
  ("Endosomes in these cells will fill with undigested transferrin because the receptor recycling pathway is blocked.",
   "Incorrect. Without surface receptors, almost no transferrin is taken up, so there is little to accumulate in endosomes. The missing step is binding and internalization at the cell surface, not recycling.")])
v("apbio-mcq-sv-018-v2","APBIO-MCQ-018",2,"2.5","absent receptor -> receptor that cannot release its cargo; predict receptor loss and rising blood LDL",
 "Liver cells remove LDL particles from the blood by receptor-mediated endocytosis. LDL receptors in clathrin-coated pits bind LDL and are internalized in endocytic vesicles. In the acidic endosome, LDL normally detaches from its receptor and is sent to the lysosome, while free receptors return to the plasma membrane to bind more LDL. A mutant form of the receptor holds on to LDL even at acidic pH. Receptors that stay bound to LDL travel with it to the lysosome and are degraded.",
 "Which prediction about liver cells with the mutant receptor is best supported by the described mechanism?",
 ("Fewer receptors will be at the plasma membrane over time, because bound receptors are degraded instead of recycled, so less LDL is cleared.",
  "Correct. Each trip removes a receptor from circulation in the cell instead of returning it to the surface, so the number of surface receptors falls and LDL clearance declines."),
 [("Receptors will return to the plasma membrane faster than normal, so the liver cells will take up more LDL than usual.",
   "Incorrect. Receptors that stay bound to LDL are carried to the lysosome and degraded, so they do not return to the surface."),
  ("Liver cells will keep taking up LDL normally over time, because the mutation affects only what happens after internalization.",
   "Incorrect. Uptake at first is normal, but because receptors are lost after each cycle, the number of surface receptors falls and uptake declines."),
  ("Cholesterol synthesis in liver cells will decrease, because more LDL-derived cholesterol is delivered to the lysosome.",
   "Incorrect. Fewer receptors means less LDL-derived cholesterol is delivered over time, which weakens the feedback inhibition of cholesterol synthesis rather than strengthening it.")])
v("apbio-mcq-sv-021-v1","APBIO-MCQ-021",2,"2.1","deleted signal peptide on a generic secretory enzyme -> non-binding signal peptide on pancreatic amylase",
 "Pancreatic acinar cells secrete the digestive enzyme amylase. Like other secretory proteins, amylase is targeted to the rough ER during translation by a hydrophobic N-terminal signal peptide. A signal recognition particle (SRP) binds the signal peptide and brings the ribosome to the ER membrane, and the growing polypeptide is threaded into the ER lumen. A researcher replaces the hydrophobic residues of amylase's signal peptide with charged residues, so that the SRP can no longer bind it.",
 "Which outcome for the mutant amylase is most likely?",
 ("Amylase is completed on free ribosomes in the cytoplasm, does not enter the ER, and is not secreted from the cell.",
  "Correct. Without SRP binding, the ribosome is not directed to the rough ER. The protein is completed in the cytoplasm and never enters the secretory pathway."),
 [("Amylase enters the ER lumen normally, because the rest of the polypeptide is still recognized by the SRP.",
   "Incorrect. The SRP recognizes the signal peptide; once it can no longer bind, nothing else in the polypeptide directs the ribosome to the ER."),
  ("Amylase is made on ribosomes attached to the ER, but it stays trapped in the ER lumen instead of being secreted.",
   "Incorrect. Without a functional signal peptide the ribosome is never attached to the ER, so the protein does not reach the lumen at all."),
  ("Amylase is packaged directly into secretory vesicles at the plasma membrane without passing through the ER or Golgi apparatus.",
   "Incorrect. Secretory vesicles carry cargo that has already entered the ER and passed through the Golgi; free cytoplasmic proteins are not loaded into them.")])
v("apbio-mcq-sv-021-v2","APBIO-MCQ-021",2,"2.1","signal peptide deleted -> signal peptide ADDED to a cytoplasmic enzyme (the converse; stays inside ER targeting, replaces an out-of-scope nuclear-import version)",
 "Secretory proteins are targeted to the rough ER during translation by a hydrophobic N-terminal signal peptide. As the ribosome synthesizes the signal peptide, a signal recognition particle (SRP) binds it and brings the ribosome to the rough ER membrane, and the growing polypeptide is threaded into the ER lumen. A glycolytic enzyme is normally made on free ribosomes and stays in the cytoplasm. A researcher adds the signal peptide of a secretory protein to the start of this enzyme.",
 "Which outcome for the modified enzyme is most likely?",
 ("The modified enzyme is made at the rough ER and enters the ER lumen, so it no longer stays in the cytoplasm.",
  "Correct. The added signal peptide is recognized by the SRP as it emerges from the ribosome, which brings the ribosome to the rough ER and threads the polypeptide into the lumen."),
 [("The modified enzyme is still made on free ribosomes and stays in the cytoplasm, because the signal peptide is cut off before translation finishes.",
   "Incorrect. The SRP binds the signal peptide as soon as it emerges, so targeting happens during translation, before any cleavage. Nothing in the description says that the sequence is removed first."),
  ("The modified enzyme is finished in the cytoplasm and then moved into the ER lumen after translation is complete.",
   "Incorrect. In the process described, the SRP brings the ribosome to the rough ER during translation, so the enzyme is not completed in the cytoplasm first."),
  ("The modified enzyme is made at the rough ER but stays outside the ER, because only secretory proteins can enter the lumen.",
   "Incorrect. Entry depends on the signal peptide, not on what kind of protein it is; the modified enzyme now carries the signal that directs it into the lumen.")])
v("apbio-mcq-sv-022-v1","APBIO-MCQ-022",2,"2.1","mitochondria -> chloroplasts / cyanobacterium; same mechanism-versus-ancestry question",
 "Evidence supporting the endosymbiotic origin of chloroplasts includes: (1) chloroplasts have a double membrane, with an inner membrane resembling the plasma membrane of a cyanobacterium and an outer membrane resembling the host's endomembrane; (2) chloroplasts contain 70S ribosomes that are inhibited by the antibiotic chloramphenicol, which does not inhibit 80S cytoplasmic ribosomes; (3) chloroplasts have their own circular DNA that lacks histones; (4) chloroplasts replicate by binary fission independently of nuclear division.",
 "Which single piece of evidence most specifically supports the mechanism of endosymbiosis, in which a host cell engulfed a cyanobacterium, rather than simply demonstrating bacterial ancestry?",
 ("The double membrane, with an inner layer like a cyanobacterial plasma membrane and an outer layer like host endomembrane, matches engulfment by a host vesicle.",
  "Correct. Evidence (1) is the one that describes the physical result of engulfment: the inner membrane is the engulfed cell's own, and the outer membrane comes from the host vesicle. Evidence (2) to (4) show bacterial ancestry but not how the cell came to be inside."),
 [("Circular DNA lacking histones shows that chloroplasts are still capable of surviving independently outside plant cells and without help from the host.",
   "Incorrect. Circular, histone-free DNA shows bacterial ancestry, but chloroplasts have transferred most of their genes to the nucleus and cannot survive on their own."),
  ("Replication by binary fission shows that chloroplasts today are still free-living cyanobacteria that happen to live inside plant cells.",
   "Incorrect. Binary fission is consistent with bacterial ancestry, but chloroplasts are no longer free-living; they depend on the host cell."),
  ("Sensitivity to chloramphenicol shows that chloroplasts are currently bacteria that merely live inside the plant cell without depending on it.",
   "Incorrect. Antibiotic sensitivity reflects the type of ribosome, which supports ancestry; it does not show that modern chloroplasts are independent bacteria.")])
v("apbio-mcq-sv-022-v2","APBIO-MCQ-022",2,"2.1","evidence list -> two competing hypotheses (endosymbiosis vs infolding) decided by a sequence comparison",
 "Two hypotheses explain the origin of chloroplasts. In the endosymbiosis hypothesis, a host cell engulfed a cyanobacterium. In the infolding hypothesis, part of the host's own plasma membrane folded inward and enclosed some of the host's cytoplasm, which later specialized for photosynthesis. Researchers sequence the chloroplast genome and compare it with other genomes. They find that chloroplast genes are circular, lack histones, and are more similar in sequence to genes of modern cyanobacteria than to genes in the plant's own nucleus.",
 "Which conclusion is best supported by the sequence comparison?",
 ("Chloroplast genes are more closely related to cyanobacterial genes than to the host's nuclear genes, which supports endosymbiosis over infolding of the host's membrane.",
  "Correct. If chloroplasts arose from the host's own membrane and cytoplasm, their genes would resemble the host's. Greater similarity to cyanobacterial genes points to a cyanobacterial origin."),
 [("Because chloroplasts have a double membrane, the sequence data show that they formed by infolding of the host's plasma membrane.",
   "Incorrect. The sequence comparison says nothing about membrane layers, and a double membrane could be produced by either hypothesis."),
  ("Because chloroplast DNA lacks histones, the sequence data show that chloroplasts are not part of the plant cell.",
   "Incorrect. Histone-free DNA is a bacterial feature, but chloroplasts are part of the plant cell and depend on proteins encoded by nuclear genes."),
  ("Because chloroplasts carry their own DNA, the sequence data show that the host nucleus contributes no genes to chloroplast function.",
   "Incorrect. Many chloroplast proteins are encoded in the nuclear genome and imported, so the nucleus does contribute to chloroplast function.")])

items = []; manifest = []
for key, seed, unit, topic, change, stim, q, corr, dis in V:
    rng = random.Random(key)
    opts = [(corr[0], corr[1], True)] + [(t, r, False) for t, r in dis]
    rng.shuffle(opts)
    choices = [dict(label=L[i], text=o[0]) for i, o in enumerate(opts)]
    keyed = next(L[i] for i, o in enumerate(opts) if o[2])
    items.append(dict(key=key, kind="mcq", unit=unit, topic=topic, seed=seed,
        stem=f"Stimulus: {stim}\n\nQuestion: {q}", choices=choices, keyed_label=keyed,
        rationales={L[i]: o[1] for i, o in enumerate(opts)}))
    manifest.append(dict(key=key, seed=seed, unit=unit, topic=topic, keyed_label=keyed, change=change))
json.dump(items, open(OUT, "w"), indent=1, ensure_ascii=False)
json.dump(manifest, open(OUT.replace("variants_items", "variants_manifest"), "w"), indent=1, ensure_ascii=False)
print(len(items), "variants; keyed letters:", [m["keyed_label"] for m in manifest])
