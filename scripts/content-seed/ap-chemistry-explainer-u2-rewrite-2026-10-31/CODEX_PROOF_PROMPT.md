# Codex proofing task: AP Chemistry Unit 2 student explainers (2.1-2.7)

You are an independent reviewer. Do NOT use any API, network, database or repository tools; work only from the text in this message. Do NOT rewrite the content wholesale. Your job is to find real errors and report them. Be concrete and brief.

## Context
Cramapple is an AP exam prep product. Each AP Chemistry topic page shows a short "Cheat Sheet" built from an explainer row. Seven explainers (topics 2.1 to 2.7) were rewritten to be shorter and to give each field one job. For every topic below you get: the CHANGED fields (BEFORE and AFTER), the UNCHANGED fields (context only, already published), and the paired BRIEF text (a separate field the explainer must not merely restate).

## Field roles (each field does one job)
- core_idea: the mechanism or "why it works", not a restatement of the definition. Max 360 characters.
- what_students_need_to_understand: the specific trap or dependency to hold in mind. Max 360 characters.
- how_this_becomes_points: the rubric path, step by step, using the topic's own evidence. Max 320 characters.
- point_attaining_answer: the model answer to the mini example question. Max 520 characters.
- practice_bridge: one line sending the student back to practice. Max 220 characters.
Unchanged fields (answer_move, mini_example_question, weak_answer, common_point_loss) are not being edited in this pass.

## What to check, in priority order
1. FACTUAL ACCURACY of every AFTER statement, using your own chemistry knowledge AND the "Course facts" section below. Independently re-derive every number and electron count yourself before judging it (electronegativity differences, bond lengths and energies, electron totals, formal charges, bond angles, region counts). Show the re-derivation in one line for any item you check.
2. AP SCOPE: nothing asserted as required that the course says is out of scope, and nothing required by the course left out of a rubric path. Note the explicit exclusion statements in Course facts (2.3 crystal structures; 2.7 hybrid-orbital derivation, d-orbital hybridization, molecular orbital theory).
3. INTERNAL CONSISTENCY: each AFTER field must agree with that topic's unchanged fields (the mini example question, weak answer, answer_move, common_point_loss) and with the other AFTER fields. In particular, the point_attaining_answer must actually answer the mini example question, and how_this_becomes_points must describe what that answer does.
4. LOSS OF CONTENT: did shortening drop anything a student needs to earn the point that the BEFORE text had? Name it.
5. ROLE FIT AND NON-RESTATEMENT: does each AFTER field do its own job, and does it add something its BRIEF twin does not? Flag any AFTER field that mostly restates its brief twin. (Wording overlap was measured separately; judge meaning, including paraphrase.)
6. Wording clarity for a high-school student (ambiguous pronouns, jargon not defined, sentence that could be read two ways).
Length caps were already verified mechanically; do not recount.

## Known item to confirm
The BEFORE text of topic 2.5 point_attaining_answer said 6 electrons in sigma bonds + 2 in the pi bond + 18 as lone pairs for carbonate (CO3 2-), which sums to 26, not 24. The AFTER text claims 8 bonding electrons and 16 lone-pair electrons. Confirm or correct this.
Also confirm the claim in 2.7 that this reasoning chain "scored only 0.56 of 1.0 on the 2025 free-response hybridization item": the repository fact pack records hybridization identification (2025 Q4 Part A) as 0.56/1.0, with the dominant error being counting a C=O double bond as two domains. If you cannot verify a statistic from memory, say "unverified" and do not guess.

## Output format (exactly this)
A. One table, one row per finding: ID | topic | field | severity (DEFECT = wrong or misleading, MISSING = needed content lost, SUGGESTION = optional polish) | quote the exact words | why it is a problem (include your re-derivation if numeric) | minimal replacement text (a few words or one sentence, same character budget).
B. Then one line per topic: "2.x: PASS" or "2.x: FIX (finding IDs)".
C. Then a list of anything you could not verify.
If a topic has no findings, say so; do not invent findings. Do not comment on style where the text is correct and clear.

## Course facts (Unit 2 excerpt from the course framework fact pack)

### Unit 2 — Compound Structure and Properties (7-9%)

- **2.1 Types of Chemical Bonds.** EK: electronegativity increases
  left-to-right across a period, decreases down a group (explained via
  shell model + Coulomb's law). Nonpolar covalent = shared valence electrons
  between similar-electronegativity atoms (C–H bonds are "effectively
  nonpolar" despite a small real difference); polar covalent = shared
  electrons between unequal-electronegativity atoms, with greater
  electronegativity difference producing greater bond dipole in single
  bonds; all polar bonds have some ionic character (ionic/covalent is a
  continuum, not a hard distinction). Metal-nonmetal bonds are generally
  ionic, nonmetal-nonmetal generally covalent, but compound *properties* are
  the best characterization tool. In metallic solids, valence electrons are
  delocalized, not tied to individual atoms. Zero explicit exclusion
  statements.
- **2.2 Intramolecular Force and Potential Energy.** EK: a potential-energy-
  vs-internuclear-distance graph shows equilibrium bond length (lowest PE
  point) and bond energy (energy to separate atoms). Higher bond order
  (single→double→triple) = shorter bond, larger bond energy. Coulomb's law
  governs cation-anion interaction strength: larger charges and smaller ions
  (shorter internuclear distance) both increase strength. Zero explicit
  exclusion statements.
- **2.3 Structure of Ionic Solids.** EK: cations/anions arrange in a
  systematic, periodic 3-D array maximizing attractive and minimizing
  repulsive Coulombic forces. **Exclusion Statement (verbatim):**
  "Knowledge of specific crystal structures is not essential to an
  understanding of the learning objective and will not be assessed on the
  AP Exam." (Source of existing flat-list item 3.)
- **2.4 Structure of Metals and Alloys.** EK: metallic bonding = positive
  metal-ion array + delocalized "sea of electrons." Interstitial alloys
  (e.g. steel: C in Fe interstices) form between atoms of significantly
  different radii; substitutional alloys (e.g. some brass) form between
  atoms of comparable radius. Zero explicit exclusion statements.
- **2.5 Lewis Diagrams.** EK: Lewis diagrams follow an established
  construction procedure. Zero explicit exclusion statements.
- **2.6 Resonance and Formal Charge.** EK: when more than one equivalent
  Lewis structure is possible, resonance is a required refinement for
  qualitatively accurate structure/property prediction. Octet rule + formal
  charge select among nonequivalent candidate structures. The Lewis model
  has real limitations, particularly for odd-electron-count species. Zero
  explicit exclusion statements.
- **2.7 VSEPR and Hybridization.** EK: VSEPR uses Coulombic repulsion
  between electron pairs to predict arrangement around a central atom;
  applies with Lewis diagrams to predict geometry (linear, trigonal planar,
  tetrahedral, trigonal pyramidal, bent, trigonal bipyramidal, seesaw,
  T-shaped, octahedral, square pyramidal, square planar), bond angles,
  relative bond energies/lengths, dipole presence, and valence-orbital
  hybridization. Ideal bond angles: sp = 180°, sp² = 120°, sp³ = 109.5°.
  Sigma bonds (stronger, from head-on orbital overlap) vs. pi bonds (from
  multiple-bond overlap; prevent bond rotation, cause geometric isomers;
  weaker, lower bond energy than sigma). **Exclusion Statements (verbatim,
  three — the prior flat list merged all three into one sentence):** (1)
  "An understanding of the derivation and depiction of hybrid orbitals will
  not be assessed on the AP Exam. The course includes the distinction
  between sigma and pi bonding, the use of VSEPR to explain the shapes of
  molecules, and the sp, sp2, and sp3 nomenclature." (2) "Hybridization
  involving d orbitals will not be assessed on the AP Exam. When an atom has
  more than four pairs of electrons surrounding the central atom, students
  are only responsible for the shape of the resulting molecule." (3)
  "Molecular orbital theory is recommended as a way to provide deeper
  insight into bonding. However, the AP Exam will neither explicitly assess
  molecular orbital diagrams, filling of molecular orbitals, nor the
  distinction between bonding, nonbonding, and antibonding orbitals."

**Documented misconception (2025 FRQ Q4/Q5, Topic 2.7):** hybridization
identification (Q4 Part A) scored only 0.56/1.0 — the dominant error was
counting four electron domains on a carbon with a C=O double bond (yielding
incorrect sp³) instead of the correct three bonding regions (sp²); other
wrong-format responses gave sigma/pi counts, electron configurations, or
molecular geometry instead of a hybridization label. VSEPR geometry
identification for a more complex, multi-central-atom molecule (Q5 Part A,
trimethylsilanol) was comparatively accessible (0.65/1.0), but common wrong


## Topics


### 2.1 Types of Chemical Bonds

BRIEF (separate field the explainer must not restate):
- what_it_is: Bonding is a continuum set by how unequally two atoms pull on shared electrons. Electronegativity rises left-to-right across a period and falls down a group (shell model plus Coulomb's law). Similar electronegativities give nonpolar covalent bonds, unequal ones give polar covalent bonds with a bond dipole, and large differences give bonds we call ionic. Metals instead delocalize their valence electrons across the whole solid rather than assigning them to individual atoms.
- why_it_matters: Every later structure-and-property argument in the course starts here: bond polarity feeds molecular dipoles in 2.7, charge magnitude feeds Coulombic reasoning in 2.2 and 2.3, and delocalized electrons explain metallic behavior in 2.4. AP questions constantly ask you to explain a physical property by naming the bonding type and justifying it, so a shaky grip on electronegativity trends silently costs points across three units.
- how_points_are_earned: Points come from classifying a bond as nonpolar covalent, polar covalent, or ionic AND justifying the classification with a stated electronegativity comparison, then using observed properties (conductivity when molten or dissolved, melting point, solubility, brittleness versus malleability) as the confirming evidence. Comparison items award credit for ranking bond polarity by relative electronegativity difference and for identifying which atom carries the partial negative charge.

CHANGED FIELDS:

**core_idea** (cap 360; 316 -> 294 chars)
BEFORE: Electronegativity difference doesn't sort bonds into three separate boxes -- it places every bond on one continuous scale. Because the classification has no hard cutoff, even a bond called 'polar covalent' carries some ionic character, and a small real difference like C-H's is still treated as effectively nonpolar.
AFTER: Electrons are shared unequally in proportion to the electronegativity difference, so bonding runs on one continuous scale from nonpolar to ionic. No cutoff separates the types: every polar bond has some ionic character, and C-H, with a small real difference, is treated as effectively nonpolar.

**what_students_need_to_understand** (cap 360; 337 -> 291 chars)
BEFORE: Bond polarity set here reappears as molecular dipole moments in 2.7, as the charge magnitude driving Coulombic strength in 2.2 and 2.3, and as the delocalized-electron picture that explains metallic behavior in 2.4 -- so an unstated or wrong electronegativity comparison quietly loses points across three later topics, not just this one.
AFTER: Metal/nonmetal is only a shortcut. The same electronegativity comparison later sets molecular dipoles (2.7) and charge strength in Coulomb's law (2.2, 2.3), and metals differ because their valence electrons are delocalized (2.4). A missing or wrong comparison here costs points in all three.

**how_this_becomes_points** (cap 320; 409 -> 253 chars)
BEFORE: Points require naming the bond type (nonpolar covalent, polar covalent, or ionic) and backing that call with an explicit electronegativity comparison -- which atom pulls harder and which carries the partial negative charge -- rather than a metal/nonmetal shortcut, and then confirming the call with a real property such as conductivity when molten/dissolved, melting point, or brittleness versus malleability.
AFTER: Name the bond type, support it with an explicit electronegativity comparison (which atom pulls harder, which carries delta-negative), then confirm with a property: conductivity when molten or dissolved, melting point, or brittleness versus malleability.

UNCHANGED FIELDS (context):
- point_attaining_answer: Electronegativity difference sets the order: C (2.55) and H (2.20) differ by about 0.35, so C-H is effectively nonpolar covalent. O (3.44) and H (2.20) differ by about 1.24, giving O-H a real bond dipole (polar covalent) with delta-negative on oxygen. Na (0.93) and Cl (3.16) differ by about 2.23, the largest gap of the three, so the bond is classified ionic -- though because ionic and covalent form a continuum rather than two boxes, even this bond retains some covalent character.
- practice_bridge: Back in practice, on every bond-classification item, write the electronegativity comparison down first -- then let its size, not the metal/nonmetal identity, decide where the bond sits on the continuum.
- answer_move: State the electronegativity comparison explicitly before naming the bond type ('O is more electronegative than H, so the shared electrons are pulled toward O -- polar covalent, with delta-negative on O'), and when the item gives you experimental properties, let those properties decide the classification rather than the metal/nonmetal shortcut.
- mini_example_question: Rank the C-H bond in methane, the O-H bond in water, and the Na-Cl bond in table salt from least to most ionic character, and justify the order using electronegativity difference.
- weak_answer: C-H and O-H are both covalent bonds and NaCl is ionic, so C-H and O-H behave the same way and NaCl is a totally different kind of bond.
- common_point_loss: Treating ionic and covalent as two separate boxes, instead of a continuum where every polar bond already has some ionic character.

### 2.2 Intramolecular Force and Potential Energy

BRIEF (separate field the explainer must not restate):
- what_it_is: A graph of potential energy versus internuclear distance describes a bond quantitatively: the lowest point on the curve is the equilibrium bond length, and the depth of that well is the bond energy needed to pull the atoms apart. Higher bond order (single to double to triple) pulls the minimum to a shorter distance and deepens the well. For ions, Coulomb's law says larger charges and smaller ionic radii both strengthen the attraction.
- why_it_matters: This topic converts bonding from a label into a number you can compare and defend. It is the engine behind lattice-energy rankings, bond-length and bond-strength comparisons in 2.7, and every energy argument in later thermodynamics units, and it is one of the few Unit 2 skills that appears as a graph-reading task on the exam.
- how_points_are_earned: Points come from correctly reading equilibrium bond length and bond energy off a PE curve, from ranking bond length and bond energy by bond order in the same breath (shorter goes with stronger), and from applying Coulomb's law to ion pairs by citing BOTH factors -- the magnitude of the charges and the internuclear distance set by ionic radii -- to justify which interaction is stronger.

CHANGED FIELDS:

**core_idea** (cap 360; 295 -> 332 chars)
BEFORE: A potential-energy-vs-internuclear-distance curve is quantitative, not just a shape to recognize: as the atoms separate toward infinite distance, PE rises to zero, so the well's depth measured from that zero baseline down to the minimum is exactly the bond energy needed to pull the atoms apart.
AFTER: On a potential energy vs internuclear distance graph, the minimum marks the equilibrium bond length and the depth of the well below the separated-atom baseline (zero) is the bond energy. Higher bond order gives a shorter bond and a larger bond energy together; for ion pairs, Coulomb's law ties strength to charge size and distance.

**what_students_need_to_understand** (cap 360; 325 -> 265 chars)
BEFORE: This turns bonding from a label into a number you can rank and defend -- it drives lattice-energy comparisons, the bond-length/bond-energy rankings tested again in 2.7, and every bond-energy argument in later thermodynamics units, and it is one of the few Unit 2 ideas tested as a graph-reading task rather than a definition.
AFTER: This turns a bonding label into numbers you can rank and defend. It returns in lattice-energy comparisons, bond-length and bond-energy rankings in 2.7, and bond-energy arguments in later thermodynamics, and it is one of the few Unit 2 ideas tested as graph reading.

**how_this_becomes_points** (cap 320; 380 -> 242 chars)
BEFORE: Points require reading equilibrium bond length off the curve's minimum x-value and bond energy off the well's depth, ranking bond length and bond energy together by bond order (shorter bond goes with the larger bond energy, never the reverse), and for ion pairs, citing both Coulomb's-law factors together -- charge magnitude and internuclear distance -- rather than either alone.
AFTER: Read bond length from the minimum's x-value and bond energy from the well depth. Rank length and energy together by bond order (shorter goes with larger energy). For ions, cite both charge magnitude and internuclear distance, never one alone.

UNCHANGED FIELDS (context):
- point_attaining_answer: Each additional bond adds more shared electron density directly between the two nuclei, pulling them closer together (154 pm to 134 pm to 120 pm) and deepening the potential-energy well (347 to 614 to 839 kJ/mol) -- on the PE curve, higher bond order shifts the minimum to a shorter distance and makes that minimum lower (more negative relative to the separated-atom baseline), so shorter bond length and larger bond energy rise together as a single consequence of bond order, not two independent facts.
- practice_bridge: Return to practice and, on every PE-curve or bond-order comparison, state length and energy together as one bond-order consequence -- never rank one without checking the other agrees.
- answer_move: When you rank two ionic compounds, name charge and ionic size in the same sentence and say which one dominates (for example MgO over NaCl because 2+/2- charges outweigh any size difference); when reading a PE curve, quote the x-value at the minimum as bond length and the well depth as bond energy rather than describing the curve's shape.
- mini_example_question: Carbon-carbon bonds get shorter and stronger as bond order rises: the C-C single bond is about 154 pm and 347 kJ/mol, the C=C double bond about 134 pm and 614 kJ/mol, and the C-triple-bond-C bond about 120 pm and 839 kJ/mol. Explain why bond order predicts both trends together.
- weak_answer: The triple bond is strongest because it has three bonds instead of one, so there's more holding the atoms together.
- common_point_loss: Comparing only ion charges and ignoring ionic radius, or claiming a longer bond is somehow stronger.

### 2.3 Structure of Ionic Solids

BRIEF (separate field the explainer must not restate):
- what_it_is: In an ionic solid, cations and anions occupy a systematic, repeating three-dimensional array. That arrangement is not arbitrary: it is the packing that puts oppositely charged ions as close as possible while keeping like-charged ions apart, maximizing attraction and minimizing repulsion across the whole lattice.
- why_it_matters: It supplies the structural picture behind the properties you are asked to explain elsewhere -- why ionic solids are hard, brittle, high-melting, and conduct only when molten or dissolved. It carries narrower exam weight than the Lewis and VSEPR topics, but it is the bridge between Coulomb's law in 2.2 and bulk-property questions later.
- how_points_are_earned: Points come from describing the lattice as an extended periodic array of alternating cations and anions and explaining a macroscopic property by that arrangement -- for instance, that many strong Coulombic attractions throughout the lattice require large energy to disrupt (high melting point), or that shifting a layer aligns like charges and causes the crystal to fracture (brittleness).

CHANGED FIELDS:

**core_idea** (cap 360; 353 -> 256 chars)
BEFORE: Ionic solids pack cations and anions into one extended, repeating array that maximizes attraction and minimizes repulsion across the whole lattice -- and the AP Exam explicitly does not require naming which specific lattice geometry (such as rock-salt or cesium-chloride packing) a compound adopts, only the general alternating-array Coulombic argument.
AFTER: Cations and anions form one extended, repeating three-dimensional array that maximizes attraction and minimizes repulsion across the whole lattice. Properties follow from that alternating array, not from named crystal types, which the exam does not assess.

**what_students_need_to_understand** (cap 360; 351 -> 267 chars)
BEFORE: This supplies the structural picture behind every ionic-solid property you're asked to explain -- why they're hard, brittle, high-melting, and conduct only when molten or dissolved -- and it's the bridge between the Coulomb's-law reasoning in 2.2 and bulk-property questions in Unit 3, even though its own exam weight is narrower than Lewis and VSEPR.
AFTER: Hardness, brittleness, high melting point, and conduction only when molten or dissolved all trace back to this one picture. It links the Coulomb's-law reasoning of 2.2 to bulk properties in Unit 3, though its own exam weight is narrower than Lewis diagrams and VSEPR.

**how_this_becomes_points** (cap 320; 454 -> 311 chars)
BEFORE: Points require describing the lattice as an extended, periodic array of alternating cations and anions and connecting that arrangement to a specific property -- many strong Coulombic attractions throughout the lattice requiring large energy to disrupt (high melting point), or a shifted layer aligning like charges and fracturing the crystal (brittleness) -- without naming a specific crystal-structure type, since that is outside what the exam assesses.
AFTER: Two moves earn the point: state that the solid is one extended, repeating array of alternating charges, then link a named property to it. High melting point: many strong attractions throughout need a lot of energy to overcome. Brittleness: a shifted layer lines up like charges and repulsion cracks the crystal.

UNCHANGED FIELDS (context):
- point_attaining_answer: Student B's explanation earns the point. The AP Exam explicitly excludes knowledge of specific crystal structures -- naming 'rock-salt' or 'face-centered cubic' is neither required nor sufficient. Student B's reasoning is what the exam actually rewards: displacing one layer relative to its neighbor brings like-charged ions into alignment, the resulting Coulombic repulsion overcomes the lattice's attractive forces along that plane, and the crystal fractures rather than deforming the way a metal would.
- practice_bridge: Go to practice and, on ionic-solid property questions, reach for the alternating-array-plus-Coulombic-forces explanation every time -- never spend words naming a specific lattice geometry.
- answer_move: Explain ionic properties by the alternating-array arrangement and the many attractions it creates, not by memorizing lattice names -- the AP Exam explicitly does not assess knowledge of specific crystal structures, so naming a structure type earns nothing and is not expected of you.
- mini_example_question: Two students explain why NaCl is brittle. Student A says 'NaCl adopts a rock-salt (face-centered cubic) crystal structure, which makes it brittle.' Student B says 'shifting one layer of the lattice aligns like-charged ions, and the resulting repulsion fractures the crystal.' Which explanation earns credit on the AP Exam, and why?
- weak_answer: Student A's answer is more specific and names the actual crystal structure, so it should earn more credit than Student B's.
- common_point_loss: Describing an ionic solid as separate molecules or discrete ion pairs, rather than one extended lattice of alternating charges.

### 2.4 Structure of Metals and Alloys

BRIEF (separate field the explainer must not restate):
- what_it_is: A metal is an array of positive metal ions immersed in a sea of delocalized valence electrons that belong to the solid as a whole. Alloys come in two structural flavors: interstitial alloys, where much smaller atoms (carbon in iron, giving steel) sit in the gaps of the host lattice, and substitutional alloys, where atoms of comparable radius (as in some brass) replace host atoms in lattice positions.
- why_it_matters: This is where delocalization from 2.1 becomes an explanation for real behavior -- conductivity, malleability, luster -- and where atomic radius from Unit 1 does concrete structural work. Its exam weight is narrower than the Lewis/VSEPR core, but the interstitial-versus-substitutional distinction is a clean, frequently testable size argument.
- how_points_are_earned: Points come from invoking mobile delocalized electrons to explain conductivity and from invoking layers of ions sliding past one another (with the electron sea still holding them together) to explain malleability, and from classifying an alloy as interstitial or substitutional by explicitly comparing the atomic radii of the two elements involved.

CHANGED FIELDS:

**core_idea** (cap 360; 448 -> 303 chars)
BEFORE: A metal is positive ions immersed in a delocalized sea of valence electrons. Alloying that lattice changes mechanical behavior without touching the electron sea itself: an interstitial alloy like steel (small carbon atoms wedged into iron's gaps) becomes harder and less malleable than pure iron because those interstitial atoms block layers from sliding past each other, yet steel still conducts, since the delocalized electron sea is undisturbed.
AFTER: A metal is a lattice of positive ions in a delocalized sea of valence electrons. Alloys change how layers slide, not the sea: interstitial alloys (steel, small C atoms in iron's gaps) block sliding and are harder and less malleable yet still conduct; substitutional alloys swap in atoms of similar size.

**what_students_need_to_understand** (cap 360; 381 -> 247 chars)
BEFORE: This is where the delocalization idea from 2.1 becomes an explanation for real, testable behavior -- conductivity, malleability, luster -- and where atomic radius from Unit 1 does concrete structural work distinguishing the two alloy types; its exam weight is narrower than Lewis/VSEPR, but the interstitial-versus-substitutional call is a clean, frequently testable size argument.
AFTER: Delocalization from 2.1 now explains observable behavior: conductivity, malleability, luster. Atomic radius from Unit 1 tells the two alloy types apart, and the interstitial-versus-substitutional size argument is a clean, frequently testable call.

**how_this_becomes_points** (cap 320; 366 -> 246 chars)
BEFORE: Points require invoking mobile delocalized electrons to explain conductivity, invoking ion layers sliding past one another (held together throughout by the electron sea) to explain malleability, and classifying a named alloy as interstitial or substitutional by explicitly comparing the atomic radii of its two components rather than by naming the alloy from memory.
AFTER: Cite mobile delocalized electrons for conductivity, and layers sliding while the electron sea holds them together for malleability. Classify an alloy by comparing the two atoms' radii: very different is interstitial, comparable is substitutional.

**point_attaining_answer** (cap 520; 669 -> 437 chars)
BEFORE: Steel is an interstitial alloy: carbon's atomic radius is significantly smaller than iron's, so carbon atoms fit into the interstices (gaps) between iron atoms in the host lattice rather than replacing them. Brass is a substitutional alloy: zinc's atomic radius is comparable to copper's, so zinc atoms directly replace copper atoms at regular lattice positions. The two are not the same structural type -- classification depends on comparing atomic radii, not on both being metal-metal mixtures. Note steel also stays conductive despite carbon reducing its malleability, since the interstitial atoms disrupt layer-sliding but leave the delocalized electron sea intact.
AFTER: Steel is interstitial: carbon's atomic radius is much smaller than iron's, so carbon sits in gaps between iron atoms. Brass is substitutional: zinc's radius is comparable to copper's, so zinc replaces copper at lattice positions. The types differ because classification rests on the radius comparison, not on both being metal mixtures. Steel still conducts, since interstitial atoms block layer sliding but leave the electron sea intact.

UNCHANGED FIELDS (context):
- practice_bridge: Head to practice and, on every alloy-classification item, compare the two elements' atomic radii out loud before naming interstitial or substitutional -- the radius comparison is the justification, not the alloy's name.
- answer_move: Classify an alloy by comparing atomic radii out loud -- significantly different radii means the small atoms fill interstices (interstitial), comparable radii means one atom replaces another in lattice sites (substitutional) -- and cite the radius comparison as your reason, not the identity of the metals.
- mini_example_question: Steel forms when small carbon atoms occupy gaps in an iron lattice. Brass forms when zinc atoms (atomic radius comparable to copper's) replace copper atoms directly in the lattice. Classify each alloy as interstitial or substitutional, and justify the classification using atomic radius.
- weak_answer: Steel and brass are both alloys made of two metals mixed together, so they're the same type of alloy.
- common_point_loss: Saying metals conduct because they 'have free electrons' without stating those delocalized electrons are mobile throughout the whole solid.

### 2.5 Lewis Diagrams

BRIEF (separate field the explainer must not restate):
- what_it_is: A Lewis diagram is a bookkeeping drawing of where every valence electron in a molecule or ion sits. You build it by a fixed procedure: total the valence electrons (adjusting for overall charge), choose a central atom and arrange the others around it, connect them with single bonds, then distribute the remaining electrons as lone pairs to satisfy octets, converting lone pairs into multiple bonds when a central atom comes up short.
- why_it_matters: The Lewis diagram is the input to almost everything downstream -- resonance and formal-charge selection in 2.6, geometry, bond angles, hybridization, and molecular dipole in 2.7, and intermolecular-force reasoning in Unit 3. A drawing with the wrong electron count poisons every conclusion built on it, which is why free-response items so often ask you to draw one first.
- how_points_are_earned: Points come from producing a complete, correct diagram: the total valence-electron count matches the formula (including added electrons for anions and removed electrons for cations), every bonding pair and lone pair is shown, octets are satisfied where the procedure requires, and an ion's diagram is enclosed in brackets with the overall charge written outside.

CHANGED FIELDS:

**core_idea** (cap 360; 363 -> 295 chars)
BEFORE: A Lewis diagram is a bookkeeping drawing built by a fixed procedure: total the valence electrons, adjusting that total by adding one electron per unit of negative charge or removing one per unit of positive charge for a polyatomic ion, then place bonds and lone pairs to satisfy octets, converting a lone pair into an extra bond when a central atom is left short.
AFTER: A Lewis diagram is valence-electron bookkeeping done by a fixed procedure: total the valence electrons (add one per unit of negative charge, subtract one per unit of positive), place bonds and lone pairs to satisfy octets, and convert a lone pair into an extra bond when a central atom is short.

**what_students_need_to_understand** (cap 360; 382 -> 272 chars)
BEFORE: The Lewis diagram feeds almost everything downstream in this unit and the next -- resonance and formal-charge selection in 2.6, geometry and hybridization in 2.7, and intermolecular-force reasoning in Unit 3 -- so a diagram with the wrong electron count poisons every conclusion built on top of it, which is why free-response items so often ask you to draw one before anything else.
AFTER: The usual failure is the count, not the drawing: a missed ion charge or an undrawn lone pair changes the total, and every answer that starts from this diagram (resonance, formal charge, shape) inherits the error. Check the count against your picture before building on it.

**how_this_becomes_points** (cap 320; 366 -> 226 chars)
BEFORE: Points require a complete, correct diagram: the total valence-electron count matches the formula (with charge adjustments applied for ions), every bonding pair and lone pair is actually drawn (not just implied), octets are satisfied wherever the procedure calls for them, and an ion's finished diagram is enclosed in brackets with the overall charge written outside.
AFTER: The diagram is complete and correct: the electron total matches the formula (charge-adjusted for ions), every bonding pair and lone pair is drawn, octets are met where required, and an ion is bracketed with its charge outside.

**point_attaining_answer** (cap 520; 524 -> 338 chars)
BEFORE: Carbon contributes 4 valence electrons and each of the three oxygens contributes 6, giving 4 + 18 = 22 -- but the ion carries a 2- charge, so 2 more electrons are added for a total of 24. With carbon central, one C=O double bond and two C-O single bonds distribute those 24 electrons: 6 in the three C-O sigma bonds, 2 more in the C=O pi bond, and 18 as lone pairs on the three oxygens, giving each terminal oxygen its full octet and carbon four bonds. The finished diagram is enclosed in brackets with a 2- written outside.
AFTER: Carbon gives 4 and each of three oxygens gives 6, so 4 + 18 = 22, plus 2 for the 2- charge makes 24. With carbon central, one C=O and two C-O bonds use 8 electrons, leaving 16 as lone pairs: the double-bonded oxygen has 2 pairs and each single-bonded oxygen has 3. Every atom has an octet. Enclose the diagram in brackets with 2- outside.

UNCHANGED FIELDS (context):
- practice_bridge: Back to practice and, on every ion's Lewis diagram, write the charge adjustment as its own step before counting electrons -- add for anions, subtract for cations -- so the total you build from is already correct.
- answer_move: Write the valence-electron total as a number before you draw anything, then count the electrons in your finished picture and confirm the two match -- and for a polyatomic ion, adjust that total for the charge and put brackets with the charge around the final structure.
- mini_example_question: Draw the Lewis diagram for the carbonate ion, CO3^2-, and state the total number of valence electrons used.
- weak_answer: Carbon has 4 valence electrons and each oxygen has 6, so 4 + 6 + 6 + 6 = 22 electrons total.
- common_point_loss: Drawing only the bonds and forgetting lone pairs, or ignoring an ion's charge when totaling valence electrons.

### 2.6 Resonance and Formal Charge

BRIEF (separate field the explainer must not restate):
- what_it_is: Two refinements sit on top of a finished Lewis diagram. When several EQUIVALENT diagrams are possible, resonance says the real molecule is a single averaged structure -- bonds intermediate in length and strength -- not a molecule flipping between forms. When candidate diagrams are NONEQUIVALENT, the octet rule plus formal charge picks the best one: minimize formal charges overall and place any negative formal charge on the more electronegative atom. The Lewis model has real limits, especially for odd-electron species.
- why_it_matters: This is the judgment layer between drawing a structure and using it. It explains why all the bonds in a nitrate or carbonate ion are identical rather than one short and two long, and it is the tool that tells you which of several legal drawings is the one the exam expects you to reason from.
- how_points_are_earned: Points come from drawing all equivalent resonance forms and stating that the actual structure is an average of them (with bond order and bond length between the extremes), and separately from computing formal charge -- valence electrons minus lone-pair electrons minus half the bonding electrons -- for the competing atoms and justifying your chosen structure by minimized formal charges and by negative formal charge sitting on the more electronegative atom.

CHANGED FIELDS:

**core_idea** (cap 360; 400 -> 299 chars)
BEFORE: Formal charge is computed as valence electrons minus lone-pair electrons minus half the bonding electrons on that atom, and it is the arithmetic tool -- not intuition -- that picks the best nonequivalent Lewis structure. The Lewis model itself has real limits: it cannot represent an odd-electron species, like a radical, without leaving one electron unpaired and formal charges imperfectly assigned.
AFTER: Formal charge = valence electrons minus lone-pair electrons minus half the bonding electrons. It is the calculation that selects among nonequivalent Lewis structures, while equivalent structures are averaged as resonance. The Lewis model has limits: it cannot cleanly represent odd-electron species.

**what_students_need_to_understand** (cap 360; 311 -> 213 chars)
BEFORE: This is the judgment layer between drawing a structure and using it -- it's why every bond in a resonance-stabilized ion like nitrite is identical in length rather than one short and two long, and it's the tool that tells you which of several legal Lewis diagrams is the one the exam expects you to reason from.
AFTER: This is the judgment step between drawing a structure and using it. It explains why both N-O bonds in nitrite are identical, not one short and one long, and it picks which of several legal diagrams to reason from.

**how_this_becomes_points** (cap 320; 417 -> 300 chars)
BEFORE: Points require drawing all equivalent resonance forms and stating the real structure is a single average of them (bond order and bond length between the individual-structure extremes), or -- for nonequivalent candidates -- computing formal charge on the contested atoms explicitly and justifying the chosen structure by minimized formal charges with any negative formal charge placed on the more electronegative atom.
AFTER: For equivalent structures, draw all forms and state that the real structure is one average (intermediate bond order and length). For nonequivalent ones, compute formal charge on the contested atoms and choose the structure with minimized formal charges, any negative on the more electronegative atom.

UNCHANGED FIELDS (context):
- point_attaining_answer: The two resonance structures are equivalent, so the real ion is a single averaged structure, not one that switches between two forms. Each N-O bond has an intermediate bond order of 1.5 (halfway between a single and a double bond), and experimentally both N-O bonds in nitrite measure about 124 pm -- shorter than a typical N-O single bond (~140 pm) and longer than a typical N=O double bond (~115 pm), and identical to each other, confirming the averaged picture rather than two different bond lengths.
- practice_bridge: Return to practice and, before writing any resonance answer, decide equivalent-or-not first -- equivalent structures get an averaging statement, nonequivalent ones get real formal-charge arithmetic on the page.
- answer_move: Decide first whether your candidate structures are equivalent or nonequivalent: equivalent ones call for drawing the resonance set and describing an averaged structure, while nonequivalent ones call for showing the actual formal-charge arithmetic on the contested atoms and naming which structure wins and why.
- mini_example_question: The nitrite ion, NO2^-, has two equivalent resonance structures: one with the N=O double bond on the left oxygen and a single bond to the right oxygen, and one with the reverse. Explain what the ion's real bonding looks like, and predict whether its two N-O bond lengths are equal or different.
- weak_answer: The ion rapidly flips back and forth between the two structures, so at any instant one N-O bond is a double bond and the other is a single bond.
- common_point_loss: Saying the molecule rapidly switches between resonance forms; it is one averaged structure, and the bonds are identical.

### 2.7 VSEPR and Hybridization

BRIEF (separate field the explainer must not restate):
- what_it_is: VSEPR takes a finished Lewis diagram and predicts three-dimensional shape by assuming regions of electron density around a central atom repel one another and spread as far apart as possible. From that arrangement you get the molecular geometry (linear, trigonal planar, tetrahedral, trigonal pyramidal, bent, trigonal bipyramidal, seesaw, T-shaped, octahedral, square pyramidal, square planar), approximate bond angles, relative bond lengths and energies, whether the molecule has a net dipole, and the hybridization label sp (180 degrees), sp2 (120 degrees), or sp3 (109.5 degrees). Sigma bonds form by head-on overlap and are stronger; pi bonds, present in multiple bonds, are weaker and block rotation, producing geometric isomers.
- why_it_matters: Geometry is the payoff of the whole unit and the entry point to Unit 3: whether a molecule is polar -- and therefore how it interacts with other molecules, dissolves, and boils -- depends on shape plus bond dipoles. This topic is among the most heavily assessed in the unit and shows up in both multiple-choice and free-response settings.
- how_points_are_earned: Points come from counting regions of electron density around the central atom (each lone pair counts as one, and a double or triple bond counts as ONE region), then naming the molecular geometry based on atom positions only, giving the associated bond angle, and -- when asked -- assigning the hybridization label. Polarity points require combining bond dipoles with the geometry to argue whether they cancel.

CHANGED FIELDS:

**core_idea** (cap 360; 445 -> 322 chars)
BEFORE: VSEPR counts regions of electron density -- treating any double or triple bond as exactly one region -- to predict geometry, bond angles (sp 180 degrees, sp2 120 degrees, sp3 109.5 degrees), and hybridization. Three things stay off the exam: deriving or depicting hybrid orbitals, hybridization involving d orbitals (central atoms with more than four electron-pair regions get a shape only, no hybridization label), and molecular orbital theory.
AFTER: VSEPR counts regions of electron density (each lone pair, single, double or triple bond is one region) to predict geometry, bond angle (sp 180, sp2 120, sp3 109.5 degrees) and hybridization. Off the exam: deriving hybrid orbitals, d-orbital hybridization (more than four regions: shape only), and molecular orbital theory.

**what_students_need_to_understand** (cap 360; 348 -> 226 chars)
BEFORE: Geometry is the payoff of the whole unit and the entry point to Unit 3: whether a molecule is polar, and therefore how it interacts with other molecules, dissolves, and boils, depends on shape plus bond dipoles together -- and this exact reasoning chain was the lowest-scoring hybridization item on the 2025 exam, at a mean of just 0.56 out of 1.0.
AFTER: Geometry is the payoff of the unit and the gateway to Unit 3: polarity, solubility and boiling point depend on shape plus bond dipoles. This reasoning chain scored only 0.56 of 1.0 on the 2025 free-response hybridization item.

**how_this_becomes_points** (cap 320; 389 -> 251 chars)
BEFORE: Points require counting electron-density regions correctly (each lone pair is one region, and a double or triple bond is exactly one region, not one per bond line), naming the geometry from atom positions only, giving the matching bond angle, and -- only when hybridization is asked for -- assigning sp, sp2, or sp3 from that same region count, never from counting bond lines individually.
AFTER: Count regions correctly (a lone pair is one, a double or triple bond is one, not one per line), name the geometry from atom positions only, give the matching angle, and, only if hybridization is asked, assign sp, sp2 or sp3 from the same region count.

**point_attaining_answer** (cap 520; 557 -> 311 chars)
BEFORE: Carbon has three regions of electron density: two single C-H bonds and one C=O double bond, which counts as a single region regardless of it being a double bond. Three regions means trigonal planar geometry with approximately 120 degree bond angles and sp2 hybridization, not sp3. This is exactly the error that cost the most points on the 2025 free-response hybridization item (mean score 0.56/1.0): counting a C=O double bond as two separate electron domains, which wrongly pushes the count to four and the hybridization to sp3 instead of the correct sp2.
AFTER: Carbon has three regions: two C-H bonds and one C=O double bond, which counts as one. Three regions means trigonal planar geometry, about 120 degrees, and sp2 hybridization, not sp3. The costly error on the 2025 free-response item (mean 0.56 of 1.0) was counting C=O as two domains, giving four domains and sp3.

**practice_bridge** (cap 220; 260 -> 155 chars)
BEFORE: Head back to practice and, on every hybridization question, count regions of electron density first -- collapsing every double or triple bond to one region -- before assigning sp, sp2, or sp3, and never reach for d-orbital or molecular-orbital-theory language.
AFTER: In practice, count regions first, collapsing each double or triple bond to one, before assigning sp, sp2 or sp3; never use d-orbital or MO-theory language.

UNCHANGED FIELDS (context):
- answer_move: Count regions of electron density first and count each multiple bond as a single region, then answer exactly what was asked -- a geometry name if the question says geometry, an sp/sp2/sp3 label if it says hybridization. Note the scope limit: hybridization labels stop at sp3, so for a central atom with more than four electron pairs give only the shape, and never reach for d-orbital hybridization or molecular orbital theory, which the exam does not assess.
- mini_example_question: Determine the hybridization of the central carbon atom in formaldehyde, H2C=O, where carbon is singly bonded to two hydrogens and doubly bonded to one oxygen.
- weak_answer: Carbon is attached to four things -- two hydrogens, plus two separate bonds to oxygen -- so it has four electron domains and is sp3 hybridized.
- common_point_loss: Counting a C=O double bond as two regions and answering sp3; a double bond is one region, so that carbon is sp2.
