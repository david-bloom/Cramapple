# Production approval packet: AP Chemistry Unit 2 explainers 2.1-2.7

Status: AWAITING DAVID'S APPROVAL, 2026-10-31. Proposed id APPROVAL-0204 (highest on main and on this branch is 0203; open PR #577 touches only 0143/0201). Re-check open PRs immediately before logging.

## What would change
7 rows in `app.topic_explainers` (ap_chemistry 2.1-2.7), fields core_idea, what_students_need_to_understand, how_this_becomes_points, point_attaining_answer, practice_bridge only (changed ones listed below). No schema, brief, figure, hook or frontend change. `published_at` unchanged. `source_note` gets one appended provenance sentence.

## Evidence
- Production rows re-read 2026-10-31: content hashes equal the rollback snapshot (`current_dev.json`) for all 7, so the apply starts from the state this was built on.
- Development: migration `supabase/migrations/20261031120000_chem_unit2_explainer_rewrite.sql` applied; read-back 7/7 identical to `proposed.json`; full `topic_guides_database_qa.sql` exit 0 (no hard failure).
- Caps: every changed field within its cap (core 360, understand 360, points 320, answer 520, bridge 220). Overlap with brief twin: max 0.70, below the 0.80 warning line.
- Proofread by Codex (separate model family); 13 findings ruled in `CODEX_RULINGS.md`: 6 factual defects fixed, 2 suggestions adopted, 5 declined. Unverified and left so: 2025 exam statistics, absolute electronegativity values, bond lengths/energies.
- Process note: Claude authored and arbitrated; one checker family (Codex) rather than the two-family DECISION-0093 standard. Approve knowing that.

## Rollback
Re-apply `current_dev.json` field values for the 7 rows (and strip the appended source_note sentence).

## Before / after (changed fields only)

### 2.1 Types of Chemical Bonds
**core_idea** (316 -> 330 chars)

- BEFORE: Electronegativity difference doesn't sort bonds into three separate boxes -- it places every bond on one continuous scale. Because the classification has no hard cutoff, even a bond called 'polar covalent' carries some ionic character, and a small real difference like C-H's is still treated as effectively nonpolar.
- AFTER: Electrons are shared unequally, with greater inequality generally accompanying a larger electronegativity difference, so bonding runs on one continuous scale from nonpolar to ionic. No cutoff separates the types: every polar bond has some ionic character, and C-H, with a small real difference, is treated as effectively nonpolar.

**what_students_need_to_understand** (337 -> 312 chars)

- BEFORE: Bond polarity set here reappears as molecular dipole moments in 2.7, as the charge magnitude driving Coulombic strength in 2.2 and 2.3, and as the delocalized-electron picture that explains metallic behavior in 2.4 -- so an unstated or wrong electronegativity comparison quietly loses points across three later topics, not just this one.
- AFTER: Metal/nonmetal is only a shortcut: use observed properties when they are given. Electronegativity predicts bond polarity, but molecular polarity (2.7) also needs geometry. For ionic attractions (2.2, 2.3) use the ions' actual charges and separation. Metals differ because valence electrons are delocalized (2.4).

**how_this_becomes_points** (409 -> 253 chars)

- BEFORE: Points require naming the bond type (nonpolar covalent, polar covalent, or ionic) and backing that call with an explicit electronegativity comparison -- which atom pulls harder and which carries the partial negative charge -- rather than a metal/nonmetal shortcut, and then confirming the call with a real property such as conductivity when molten/dissolved, melting point, or brittleness versus malleability.
- AFTER: Name the bond type, support it with an explicit electronegativity comparison (which atom pulls harder, which carries delta-negative), then confirm with a property: conductivity when molten or dissolved, melting point, or brittleness versus malleability.

### 2.2 Intramolecular Force and Potential Energy
**core_idea** (295 -> 332 chars)

- BEFORE: A potential-energy-vs-internuclear-distance curve is quantitative, not just a shape to recognize: as the atoms separate toward infinite distance, PE rises to zero, so the well's depth measured from that zero baseline down to the minimum is exactly the bond energy needed to pull the atoms apart.
- AFTER: On a potential energy vs internuclear distance graph, the minimum marks the equilibrium bond length and the depth of the well below the separated-atom baseline (zero) is the bond energy. Higher bond order gives a shorter bond and a larger bond energy together; for ion pairs, Coulomb's law ties strength to charge size and distance.

**what_students_need_to_understand** (325 -> 265 chars)

- BEFORE: This turns bonding from a label into a number you can rank and defend -- it drives lattice-energy comparisons, the bond-length/bond-energy rankings tested again in 2.7, and every bond-energy argument in later thermodynamics units, and it is one of the few Unit 2 ideas tested as a graph-reading task rather than a definition.
- AFTER: This turns a bonding label into numbers you can rank and defend. It returns in lattice-energy comparisons, bond-length and bond-energy rankings in 2.7, and bond-energy arguments in later thermodynamics, and it is one of the few Unit 2 ideas tested as graph reading.

**how_this_becomes_points** (380 -> 242 chars)

- BEFORE: Points require reading equilibrium bond length off the curve's minimum x-value and bond energy off the well's depth, ranking bond length and bond energy together by bond order (shorter bond goes with the larger bond energy, never the reverse), and for ion pairs, citing both Coulomb's-law factors together -- charge magnitude and internuclear distance -- rather than either alone.
- AFTER: Read bond length from the minimum's x-value and bond energy from the well depth. Rank length and energy together by bond order (shorter goes with larger energy). For ions, cite both charge magnitude and internuclear distance, never one alone.

### 2.3 Structure of Ionic Solids
**core_idea** (353 -> 256 chars)

- BEFORE: Ionic solids pack cations and anions into one extended, repeating array that maximizes attraction and minimizes repulsion across the whole lattice -- and the AP Exam explicitly does not require naming which specific lattice geometry (such as rock-salt or cesium-chloride packing) a compound adopts, only the general alternating-array Coulombic argument.
- AFTER: Cations and anions form one extended, repeating three-dimensional array that maximizes attraction and minimizes repulsion across the whole lattice. Properties follow from that alternating array, not from named crystal types, which the exam does not assess.

**what_students_need_to_understand** (351 -> 267 chars)

- BEFORE: This supplies the structural picture behind every ionic-solid property you're asked to explain -- why they're hard, brittle, high-melting, and conduct only when molten or dissolved -- and it's the bridge between the Coulomb's-law reasoning in 2.2 and bulk-property questions in Unit 3, even though its own exam weight is narrower than Lewis and VSEPR.
- AFTER: Hardness, brittleness, high melting point, and conduction only when molten or dissolved all trace back to this one picture. It links the Coulomb's-law reasoning of 2.2 to bulk properties in Unit 3, though its own exam weight is narrower than Lewis diagrams and VSEPR.

**how_this_becomes_points** (454 -> 311 chars)

- BEFORE: Points require describing the lattice as an extended, periodic array of alternating cations and anions and connecting that arrangement to a specific property -- many strong Coulombic attractions throughout the lattice requiring large energy to disrupt (high melting point), or a shifted layer aligning like charges and fracturing the crystal (brittleness) -- without naming a specific crystal-structure type, since that is outside what the exam assesses.
- AFTER: Two moves earn the point: state that the solid is one extended, repeating array of alternating charges, then link a named property to it. High melting point: many strong attractions throughout need a lot of energy to overcome. Brittleness: a shifted layer lines up like charges and repulsion cracks the crystal.

### 2.4 Structure of Metals and Alloys
**core_idea** (448 -> 336 chars)

- BEFORE: A metal is positive ions immersed in a delocalized sea of valence electrons. Alloying that lattice changes mechanical behavior without touching the electron sea itself: an interstitial alloy like steel (small carbon atoms wedged into iron's gaps) becomes harder and less malleable than pure iron because those interstitial atoms block layers from sliding past each other, yet steel still conducts, since the delocalized electron sea is undisturbed.
- AFTER: A metal is a lattice of positive ions in a delocalized sea of valence electrons. Alloys can hinder layer sliding while retaining mobile delocalized electrons: interstitial alloys (steel, small C atoms in iron's gaps) block sliding and are harder and less malleable yet still conduct; substitutional alloys swap in atoms of similar size.

**what_students_need_to_understand** (381 -> 247 chars)

- BEFORE: This is where the delocalization idea from 2.1 becomes an explanation for real, testable behavior -- conductivity, malleability, luster -- and where atomic radius from Unit 1 does concrete structural work distinguishing the two alloy types; its exam weight is narrower than Lewis/VSEPR, but the interstitial-versus-substitutional call is a clean, frequently testable size argument.
- AFTER: Delocalization from 2.1 now explains observable behavior: conductivity, malleability, luster. Atomic radius from Unit 1 tells the two alloy types apart, and the interstitial-versus-substitutional size argument is a clean, frequently testable call.

**how_this_becomes_points** (366 -> 246 chars)

- BEFORE: Points require invoking mobile delocalized electrons to explain conductivity, invoking ion layers sliding past one another (held together throughout by the electron sea) to explain malleability, and classifying a named alloy as interstitial or substitutional by explicitly comparing the atomic radii of its two components rather than by naming the alloy from memory.
- AFTER: Cite mobile delocalized electrons for conductivity, and layers sliding while the electron sea holds them together for malleability. Classify an alloy by comparing the two atoms' radii: very different is interstitial, comparable is substitutional.

**point_attaining_answer** (669 -> 499 chars)

- BEFORE: Steel is an interstitial alloy: carbon's atomic radius is significantly smaller than iron's, so carbon atoms fit into the interstices (gaps) between iron atoms in the host lattice rather than replacing them. Brass is a substitutional alloy: zinc's atomic radius is comparable to copper's, so zinc atoms directly replace copper atoms at regular lattice positions. The two are not the same structural type -- classification depends on comparing atomic radii, not on both being metal-metal mixtures. Note steel also stays conductive despite carbon reducing its malleability, since the interstitial atoms disrupt layer-sliding but leave the delocalized electron sea intact.
- AFTER: Steel is interstitial: carbon's atomic radius is much smaller than iron's, so carbon sits in gaps between iron atoms. Brass is substitutional: zinc's radius is comparable to copper's, so zinc replaces copper at lattice positions. The types differ because classification rests on the radius comparison, not on both being metal mixtures. Steel still conducts, since interstitial atoms block layer sliding but mobile delocalized electrons remain, although alloying can change its electrical resistance.

### 2.5 Lewis Diagrams
**core_idea** (363 -> 295 chars)

- BEFORE: A Lewis diagram is a bookkeeping drawing built by a fixed procedure: total the valence electrons, adjusting that total by adding one electron per unit of negative charge or removing one per unit of positive charge for a polyatomic ion, then place bonds and lone pairs to satisfy octets, converting a lone pair into an extra bond when a central atom is left short.
- AFTER: A Lewis diagram is valence-electron bookkeeping done by a fixed procedure: total the valence electrons (add one per unit of negative charge, subtract one per unit of positive), place bonds and lone pairs to satisfy octets, and convert a lone pair into an extra bond when a central atom is short.

**what_students_need_to_understand** (382 -> 272 chars)

- BEFORE: The Lewis diagram feeds almost everything downstream in this unit and the next -- resonance and formal-charge selection in 2.6, geometry and hybridization in 2.7, and intermolecular-force reasoning in Unit 3 -- so a diagram with the wrong electron count poisons every conclusion built on top of it, which is why free-response items so often ask you to draw one before anything else.
- AFTER: The usual failure is the count, not the drawing: a missed ion charge or an undrawn lone pair changes the total, and every answer that starts from this diagram (resonance, formal charge, shape) inherits the error. Check the count against your picture before building on it.

**how_this_becomes_points** (366 -> 226 chars)

- BEFORE: Points require a complete, correct diagram: the total valence-electron count matches the formula (with charge adjustments applied for ions), every bonding pair and lone pair is actually drawn (not just implied), octets are satisfied wherever the procedure calls for them, and an ion's finished diagram is enclosed in brackets with the overall charge written outside.
- AFTER: The diagram is complete and correct: the electron total matches the formula (charge-adjusted for ions), every bonding pair and lone pair is drawn, octets are met where required, and an ion is bracketed with its charge outside.

**point_attaining_answer** (524 -> 338 chars)

- BEFORE: Carbon contributes 4 valence electrons and each of the three oxygens contributes 6, giving 4 + 18 = 22 -- but the ion carries a 2- charge, so 2 more electrons are added for a total of 24. With carbon central, one C=O double bond and two C-O single bonds distribute those 24 electrons: 6 in the three C-O sigma bonds, 2 more in the C=O pi bond, and 18 as lone pairs on the three oxygens, giving each terminal oxygen its full octet and carbon four bonds. The finished diagram is enclosed in brackets with a 2- written outside.
- AFTER: Carbon gives 4 and each of three oxygens gives 6, so 4 + 18 = 22, plus 2 for the 2- charge makes 24. With carbon central, one C=O and two C-O bonds use 8 electrons, leaving 16 as lone pairs: the double-bonded oxygen has 2 pairs and each single-bonded oxygen has 3. Every atom has an octet. Enclose the diagram in brackets with 2- outside.

### 2.6 Resonance and Formal Charge
**core_idea** (400 -> 309 chars)

- BEFORE: Formal charge is computed as valence electrons minus lone-pair electrons minus half the bonding electrons on that atom, and it is the arithmetic tool -- not intuition -- that picks the best nonequivalent Lewis structure. The Lewis model itself has real limits: it cannot represent an odd-electron species, like a radical, without leaving one electron unpaired and formal charges imperfectly assigned.
- AFTER: Formal charge = valence electrons minus lone-pair electrons minus half the bonding electrons. Together with octet requirements, it selects among nonequivalent Lewis structures, while equivalent structures are averaged as resonance. The Lewis model has limits: it cannot cleanly represent odd-electron species.

**what_students_need_to_understand** (311 -> 252 chars)

- BEFORE: This is the judgment layer between drawing a structure and using it -- it's why every bond in a resonance-stabilized ion like nitrite is identical in length rather than one short and two long, and it's the tool that tells you which of several legal Lewis diagrams is the one the exam expects you to reason from.
- AFTER: Resonance forms are alternative drawings, not successive states: never say a double bond moves back and forth. That is why both N-O bonds in nitrite are identical, and formal charge is the tool that picks which of several legal diagrams to reason from.

**how_this_becomes_points** (417 -> 297 chars)

- BEFORE: Points require drawing all equivalent resonance forms and stating the real structure is a single average of them (bond order and bond length between the individual-structure extremes), or -- for nonequivalent candidates -- computing formal charge on the contested atoms explicitly and justifying the chosen structure by minimized formal charges with any negative formal charge placed on the more electronegative atom.
- AFTER: For equivalent structures, draw all forms, reject switching, and state the real structure is one average: nitrite's N-O bond order is (1 + 2)/2 = 1.5, so both bonds are equal. For nonequivalent ones, check octets, then compute formal charge: minimize it, negative on the more electronegative atom.

### 2.7 VSEPR and Hybridization
**core_idea** (445 -> 353 chars)

- BEFORE: VSEPR counts regions of electron density -- treating any double or triple bond as exactly one region -- to predict geometry, bond angles (sp 180 degrees, sp2 120 degrees, sp3 109.5 degrees), and hybridization. Three things stay off the exam: deriving or depicting hybrid orbitals, hybridization involving d orbitals (central atoms with more than four electron-pair regions get a shape only, no hybridization label), and molecular orbital theory.
- AFTER: VSEPR counts regions of electron density (each lone pair or bond, however many lines, is one) to predict geometry, ideal electron-region angles (sp 180, sp2 120, sp3 109.5 degrees; actual bond angles can differ) and hybridization. Off the exam: deriving hybrid orbitals, d-orbital hybridization (over four regions: shape only), molecular orbital theory.

**what_students_need_to_understand** (348 -> 271 chars)

- BEFORE: Geometry is the payoff of the whole unit and the entry point to Unit 3: whether a molecule is polar, and therefore how it interacts with other molecules, dissolves, and boils, depends on shape plus bond dipoles together -- and this exact reasoning chain was the lowest-scoring hybridization item on the 2025 exam, at a mean of just 0.56 out of 1.0.
- AFTER: Geometry is the payoff of the unit and the gateway to Unit 3: polarity, solubility and boiling point depend on shape plus bond dipoles. Hybridization identification scored a mean of only 0.56 of 1.0 on the 2025 free-response item, mainly from counting C=O as two regions.

**how_this_becomes_points** (389 -> 279 chars)

- BEFORE: Points require counting electron-density regions correctly (each lone pair is one region, and a double or triple bond is exactly one region, not one per bond line), naming the geometry from atom positions only, giving the matching bond angle, and -- only when hybridization is asked for -- assigning sp, sp2, or sp3 from that same region count, never from counting bond lines individually.
- AFTER: Count regions (a lone pair is one, a double or triple bond is one), name the geometry from atom positions only, and give the matching angle. Assign sp, sp2 or sp3 from the same count only if asked. For polarity, combine bond dipoles with the geometry to test whether they cancel.

**point_attaining_answer** (557 -> 311 chars)

- BEFORE: Carbon has three regions of electron density: two single C-H bonds and one C=O double bond, which counts as a single region regardless of it being a double bond. Three regions means trigonal planar geometry with approximately 120 degree bond angles and sp2 hybridization, not sp3. This is exactly the error that cost the most points on the 2025 free-response hybridization item (mean score 0.56/1.0): counting a C=O double bond as two separate electron domains, which wrongly pushes the count to four and the hybridization to sp3 instead of the correct sp2.
- AFTER: Carbon has three regions: two C-H bonds and one C=O double bond, which counts as one. Three regions means trigonal planar geometry, about 120 degrees, and sp2 hybridization, not sp3. The costly error on the 2025 free-response item (mean 0.56 of 1.0) was counting C=O as two domains, giving four domains and sp3.

**practice_bridge** (260 -> 155 chars)

- BEFORE: Head back to practice and, on every hybridization question, count regions of electron density first -- collapsing every double or triple bond to one region -- before assigning sp, sp2, or sp3, and never reach for d-orbital or molecular-orbital-theory language.
- AFTER: In practice, count regions first, collapsing each double or triple bond to one, before assigning sp, sp2 or sp3; never use d-orbital or MO-theory language.
