# AP Chemistry Unit 2 Topic Point Briefs

Status: Draft content system seed, pending QA. **Open style decision — see
"Style A / Style B" below; Orly to weigh in.**

Deployment state is deliberately NOT asserted here — it drifts. The canonical
record of where these rows exist is the migration
(`supabase/migrations/20260821030000_chemistry_statistics_unit2_topic_point_briefs_seed.sql`)
and the `app.topic_point_briefs` table in each environment.

Purpose: preserve Cramapple-original topic point brief content for AP
Chemistry Unit 2 (Compound Structure and Properties, 7-9% of the MC exam).
These briefs help a student understand how each topic turns into
point-attainment behavior without replacing a full lesson.

Source basis: AP Chemistry Course and Exam Description, Effective Fall 2024,
plus the local CED fact pack in `docs/product/AP_CHEMISTRY_CED_FACT_PACK.md`
(Unit 2 deep-tier detail, including the four verbatim exclusion statements
and the documented 2025 FRQ misconception patterns for Topic 2.7).

Topic titles verified verbatim against the primary-source PDF
(`subject packs/Chemistry/ap-chemistry-course-and-exam-description.pdf`,
"Course at a Glance") on 2026-08-21 — all 7 match.

## Style A / Style B — open decision

The corpus currently contains two registers, and this unit is the test case
for settling which one Cramapple standardizes on.

| | avg `whatItIs` | avg `answerMove` | avg `commonPointLoss` |
|---|---|---|---|
| **Style A — concise** (AP Biology, Calculus AB/BC, Precalculus; and this unit's first pass) | ~110-270 | ~96-200 | ~82-196 |
| **Style B — fuller** (this unit as seeded below) | ~490 | ~300 | ~130 |

Arguments on each side, stated fairly:

- **For Style A.** The existing written spec says "Keep this concise. Do not
  teach the whole classroom lesson." It matches the larger share of the
  corpus by row count (Biology + Calculus AB alone are 145 of ~237 briefs),
  and short cards are easier to scan on a phone before a diagnostic.
- **For Style B.** It carries more of the causal chain — *why* the misconception
  happens, not just that it does — and it survives editing better. A concrete
  data point from this session: while trimming AP Statistics 2.12 from Style B
  to Style A, a CED-grounded distinction (randomization distribution vs.
  sampling distribution) was silently dropped and had to be restored on review.
  Length trimming is lossy in a way that is hard to catch.

**Seeded below and currently live in Dev: Style B (fuller).** The Style A
variant of the same 7 topics is preserved verbatim in the appendix so the two
can be compared directly on identical content.

Content rules (both styles): no external links, no copied third-party
language, subject- and topic-specific, concept tied to point-earning
behavior, `commonPointLoss` short and student-facing with no exam-year or
scoring-statistic citations.

## Type

```ts
type Importance = "not-important" | "somewhat-important" | "very-important";

type TopicPointBrief = {
  unitId: string;
  topicId: string;
  title: string;
  classImportance: Importance;
  examImportance: Importance;
  whatItIs: string;
  whyItMatters: string;
  howPointsAreEarned: string;
  answerMove: string;
  commonPointLoss: string;
  learnMorePath: string;
  practiceParams: {
    subject: string;
    unit: string;
    topic: string;
  };
};
```

## Unit 2 Seed Content — Style B (fuller), currently live in Dev

```ts
const apChemistryUnit2TopicPointBriefs: TopicPointBrief[] = [
  {
    unitId: "unit-2",
    topicId: "2.1",
    title: "Types of Chemical Bonds",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "Bonding is a continuum set by how unequally two atoms pull on shared electrons. Electronegativity rises left-to-right across a period and falls down a group (shell model plus Coulomb's law). Similar electronegativities give nonpolar covalent bonds, unequal ones give polar covalent bonds with a bond dipole, and large differences give bonds we call ionic. Metals instead delocalize their valence electrons across the whole solid rather than assigning them to individual atoms.",
    whyItMatters:
      "Every later structure-and-property argument in the course starts here: bond polarity feeds molecular dipoles in 2.7, charge magnitude feeds Coulombic reasoning in 2.2 and 2.3, and delocalized electrons explain metallic behavior in 2.4. AP questions constantly ask you to explain a physical property by naming the bonding type and justifying it, so a shaky grip on electronegativity trends silently costs points across three units.",
    howPointsAreEarned:
      "Points come from classifying a bond as nonpolar covalent, polar covalent, or ionic AND justifying the classification with a stated electronegativity comparison, then using observed properties (conductivity when molten or dissolved, melting point, solubility, brittleness versus malleability) as the confirming evidence. Comparison items award credit for ranking bond polarity by relative electronegativity difference and for identifying which atom carries the partial negative charge.",
    answerMove:
      "State the electronegativity comparison explicitly before naming the bond type ('O is more electronegative than H, so the shared electrons are pulled toward O — polar covalent, with delta-negative on O'), and when the item gives you experimental properties, let those properties decide the classification rather than the metal/nonmetal shortcut.",
    commonPointLoss:
      "Treating ionic and covalent as two separate boxes, instead of a continuum where every polar bond already has some ionic character.",
    learnMorePath: "/learn/ap-chemistry/unit-2/types-of-chemical-bonds",
    practiceParams: { subject: "ap_chemistry", unit: "2", topic: "2.1" },
  },
  {
    unitId: "unit-2",
    topicId: "2.2",
    title: "Intramolecular Force and Potential Energy",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "A graph of potential energy versus internuclear distance describes a bond quantitatively: the lowest point on the curve is the equilibrium bond length, and the depth of that well is the bond energy needed to pull the atoms apart. Higher bond order (single to double to triple) pulls the minimum to a shorter distance and deepens the well. For ions, Coulomb's law says larger charges and smaller ionic radii both strengthen the attraction.",
    whyItMatters:
      "This topic converts bonding from a label into a number you can compare and defend. It is the engine behind lattice-energy rankings, bond-length and bond-strength comparisons in 2.7, and every energy argument in later thermodynamics units, and it is one of the few Unit 2 skills that appears as a graph-reading task on the exam.",
    howPointsAreEarned:
      "Points come from correctly reading equilibrium bond length and bond energy off a PE curve, from ranking bond length and bond energy by bond order in the same breath (shorter goes with stronger), and from applying Coulomb's law to ion pairs by citing BOTH factors — the magnitude of the charges and the internuclear distance set by ionic radii — to justify which interaction is stronger.",
    answerMove:
      "When you rank two ionic compounds, name charge and ionic size in the same sentence and say which one dominates (for example MgO over NaCl because 2+/2- charges outweigh any size difference); when reading a PE curve, quote the x-value at the minimum as bond length and the well depth as bond energy rather than describing the curve's shape.",
    commonPointLoss:
      "Comparing only ion charges and ignoring ionic radius, or claiming a longer bond is somehow stronger.",
    learnMorePath: "/learn/ap-chemistry/unit-2/bond-energy-and-length",
    practiceParams: { subject: "ap_chemistry", unit: "2", topic: "2.2" },
  },
  {
    unitId: "unit-2",
    topicId: "2.3",
    title: "Structure of Ionic Solids",
    classImportance: "somewhat-important",
    examImportance: "somewhat-important",
    whatItIs:
      "In an ionic solid, cations and anions occupy a systematic, repeating three-dimensional array. That arrangement is not arbitrary: it is the packing that puts oppositely charged ions as close as possible while keeping like-charged ions apart, maximizing attraction and minimizing repulsion across the whole lattice.",
    whyItMatters:
      "It supplies the structural picture behind the properties you are asked to explain elsewhere — why ionic solids are hard, brittle, high-melting, and conduct only when molten or dissolved. It carries narrower exam weight than the Lewis and VSEPR topics, but it is the bridge between Coulomb's law in 2.2 and bulk-property questions later.",
    howPointsAreEarned:
      "Points come from describing the lattice as an extended periodic array of alternating cations and anions and explaining a macroscopic property by that arrangement — for instance, that many strong Coulombic attractions throughout the lattice require large energy to disrupt (high melting point), or that shifting a layer aligns like charges and causes the crystal to fracture (brittleness).",
    answerMove:
      "Explain ionic properties by the alternating-array arrangement and the many attractions it creates, not by memorizing lattice names — the AP Exam explicitly does not assess knowledge of specific crystal structures, so naming a structure type earns nothing and is not expected of you.",
    commonPointLoss:
      "Describing an ionic solid as separate molecules or discrete ion pairs, rather than one extended lattice of alternating charges.",
    learnMorePath: "/learn/ap-chemistry/unit-2/ionic-solids",
    practiceParams: { subject: "ap_chemistry", unit: "2", topic: "2.3" },
  },
  {
    unitId: "unit-2",
    topicId: "2.4",
    title: "Structure of Metals and Alloys",
    classImportance: "somewhat-important",
    examImportance: "somewhat-important",
    whatItIs:
      "A metal is an array of positive metal ions immersed in a sea of delocalized valence electrons that belong to the solid as a whole. Alloys come in two structural flavors: interstitial alloys, where much smaller atoms (carbon in iron, giving steel) sit in the gaps of the host lattice, and substitutional alloys, where atoms of comparable radius (as in some brass) replace host atoms in lattice positions.",
    whyItMatters:
      "This is where delocalization from 2.1 becomes an explanation for real behavior — conductivity, malleability, luster — and where atomic radius from Unit 1 does concrete structural work. Its exam weight is narrower than the Lewis/VSEPR core, but the interstitial-versus-substitutional distinction is a clean, frequently testable size argument.",
    howPointsAreEarned:
      "Points come from invoking mobile delocalized electrons to explain conductivity and from invoking layers of ions sliding past one another (with the electron sea still holding them together) to explain malleability, and from classifying an alloy as interstitial or substitutional by explicitly comparing the atomic radii of the two elements involved.",
    answerMove:
      "Classify an alloy by comparing atomic radii out loud — significantly different radii means the small atoms fill interstices (interstitial), comparable radii means one atom replaces another in lattice sites (substitutional) — and cite the radius comparison as your reason, not the identity of the metals.",
    commonPointLoss:
      "Saying metals conduct because they 'have free electrons' without stating those delocalized electrons are mobile throughout the whole solid.",
    learnMorePath: "/learn/ap-chemistry/unit-2/metals-and-alloys",
    practiceParams: { subject: "ap_chemistry", unit: "2", topic: "2.4" },
  },
  {
    unitId: "unit-2",
    topicId: "2.5",
    title: "Lewis Diagrams",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "A Lewis diagram is a bookkeeping drawing of where every valence electron in a molecule or ion sits. You build it by a fixed procedure: total the valence electrons (adjusting for overall charge), choose a central atom and arrange the others around it, connect them with single bonds, then distribute the remaining electrons as lone pairs to satisfy octets, converting lone pairs into multiple bonds when a central atom comes up short.",
    whyItMatters:
      "The Lewis diagram is the input to almost everything downstream — resonance and formal-charge selection in 2.6, geometry, bond angles, hybridization, and molecular dipole in 2.7, and intermolecular-force reasoning in Unit 3. A drawing with the wrong electron count poisons every conclusion built on it, which is why free-response items so often ask you to draw one first.",
    howPointsAreEarned:
      "Points come from producing a complete, correct diagram: the total valence-electron count matches the formula (including added electrons for anions and removed electrons for cations), every bonding pair and lone pair is shown, octets are satisfied where the procedure requires, and an ion's diagram is enclosed in brackets with the overall charge written outside.",
    answerMove:
      "Write the valence-electron total as a number before you draw anything, then count the electrons in your finished picture and confirm the two match — and for a polyatomic ion, adjust that total for the charge and put brackets with the charge around the final structure.",
    commonPointLoss:
      "Drawing only the bonds and forgetting lone pairs, or ignoring an ion's charge when totaling valence electrons.",
    learnMorePath: "/learn/ap-chemistry/unit-2/lewis-diagrams",
    practiceParams: { subject: "ap_chemistry", unit: "2", topic: "2.5" },
  },
  {
    unitId: "unit-2",
    topicId: "2.6",
    title: "Resonance and Formal Charge",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "Two refinements sit on top of a finished Lewis diagram. When several EQUIVALENT diagrams are possible, resonance says the real molecule is a single averaged structure — bonds intermediate in length and strength — not a molecule flipping between forms. When candidate diagrams are NONEQUIVALENT, the octet rule plus formal charge picks the best one: minimize formal charges overall and place any negative formal charge on the more electronegative atom. The Lewis model has real limits, especially for odd-electron species.",
    whyItMatters:
      "This is the judgment layer between drawing a structure and using it. It explains why all the bonds in a nitrate or carbonate ion are identical rather than one short and two long, and it is the tool that tells you which of several legal drawings is the one the exam expects you to reason from.",
    howPointsAreEarned:
      "Points come from drawing all equivalent resonance forms and stating that the actual structure is an average of them (with bond order and bond length between the extremes), and separately from computing formal charge — valence electrons minus lone-pair electrons minus half the bonding electrons — for the competing atoms and justifying your chosen structure by minimized formal charges and by negative formal charge sitting on the more electronegative atom.",
    answerMove:
      "Decide first whether your candidate structures are equivalent or nonequivalent: equivalent ones call for drawing the resonance set and describing an averaged structure, while nonequivalent ones call for showing the actual formal-charge arithmetic on the contested atoms and naming which structure wins and why.",
    commonPointLoss:
      "Saying the molecule rapidly switches between resonance forms; it is one averaged structure, and the bonds are identical.",
    learnMorePath: "/learn/ap-chemistry/unit-2/resonance-and-formal-charge",
    practiceParams: { subject: "ap_chemistry", unit: "2", topic: "2.6" },
  },
  {
    unitId: "unit-2",
    topicId: "2.7",
    title: "VSEPR and Hybridization",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "VSEPR takes a finished Lewis diagram and predicts three-dimensional shape by assuming regions of electron density around a central atom repel one another and spread as far apart as possible. From that arrangement you get the molecular geometry (linear, trigonal planar, tetrahedral, trigonal pyramidal, bent, trigonal bipyramidal, seesaw, T-shaped, octahedral, square pyramidal, square planar), approximate bond angles, relative bond lengths and energies, whether the molecule has a net dipole, and the hybridization label sp (180 degrees), sp2 (120 degrees), or sp3 (109.5 degrees). Sigma bonds form by head-on overlap and are stronger; pi bonds, present in multiple bonds, are weaker and block rotation, producing geometric isomers.",
    whyItMatters:
      "Geometry is the payoff of the whole unit and the entry point to Unit 3: whether a molecule is polar — and therefore how it interacts with other molecules, dissolves, and boils — depends on shape plus bond dipoles. This topic is among the most heavily assessed in the unit and shows up in both multiple-choice and free-response settings.",
    howPointsAreEarned:
      "Points come from counting regions of electron density around the central atom (each lone pair counts as one, and a double or triple bond counts as ONE region), then naming the molecular geometry based on atom positions only, giving the associated bond angle, and — when asked — assigning the hybridization label. Polarity points require combining bond dipoles with the geometry to argue whether they cancel.",
    answerMove:
      "Count regions of electron density first and count each multiple bond as a single region, then answer exactly what was asked — a geometry name if the question says geometry, an sp/sp2/sp3 label if it says hybridization. Note the scope limit: hybridization labels stop at sp3, so for a central atom with more than four electron pairs give only the shape, and never reach for d-orbital hybridization or molecular orbital theory, which the exam does not assess.",
    commonPointLoss:
      "Counting a C=O double bond as two regions and answering sp3; a double bond is one region, so that carbon is sp2.",
    learnMorePath: "/learn/ap-chemistry/unit-2/vsepr-and-hybridization",
    practiceParams: { subject: "ap_chemistry", unit: "2", topic: "2.7" },
  },
];
```

## Appendix — Style A (concise) variant of the same 7 topics

Preserved for the style comparison only; NOT currently seeded. Identical
titles, importance ratings, `learnMorePath`, and `practiceParams` — only the
prose fields differ.

```ts
const apChemistryUnit2TopicPointBriefsStyleA: TopicPointBrief[] = [
  {
    topicId: "2.1",
    whatItIs:
      "Bonding sits on a continuum set by how unequally two atoms pull on shared electrons. Electronegativity rises across a period and falls down a group. Similar electronegativities give nonpolar covalent bonds, unequal ones polar covalent bonds, and large differences ionic bonds.",
    whyItMatters:
      "Bond polarity feeds molecular dipoles in 2.7, and charge magnitude feeds the Coulombic reasoning in 2.2 and 2.3. AP questions constantly ask you to explain a physical property by naming the bonding type and justifying it.",
    howPointsAreEarned:
      "You earn points by classifying a bond as nonpolar covalent, polar covalent, or ionic and justifying it with a stated electronegativity comparison, then using observed properties such as conductivity, melting point, or brittleness as confirming evidence.",
    answerMove:
      "State the electronegativity comparison before naming the bond type, and when the item gives you experimental properties, let those properties decide the classification rather than the metal/nonmetal shortcut.",
    commonPointLoss:
      "Treating ionic and covalent as two separate boxes, instead of a continuum where every polar bond already has some ionic character.",
  },
  {
    topicId: "2.2",
    whatItIs:
      "A potential-energy-versus-internuclear-distance graph describes a bond: the lowest point is the equilibrium bond length, and the depth of that well is the bond energy. Higher bond order means a shorter, stronger bond. For ions, Coulomb's law says larger charges and smaller radii both strengthen attraction.",
    whyItMatters:
      "This turns bonding from a label into a number you can compare and defend, behind lattice-energy rankings, bond-length comparisons in 2.7, and later thermodynamics. It is also one of the few Unit 2 skills tested as a graph-reading task.",
    howPointsAreEarned:
      "You earn points by reading equilibrium bond length and bond energy off a PE curve, by ranking bond length and bond energy together by bond order, and by applying Coulomb's law to ion pairs citing both charge magnitude and internuclear distance.",
    answerMove:
      "When ranking two ionic compounds, name charge and ionic size in the same sentence and say which dominates; when reading a PE curve, quote the x-value at the minimum as bond length and the well depth as bond energy.",
    commonPointLoss:
      "Comparing only ion charges and ignoring ionic radius, or claiming a longer bond is stronger.",
  },
  {
    topicId: "2.3",
    whatItIs:
      "In an ionic solid, cations and anions occupy a systematic, repeating three-dimensional array — the packing that puts opposite charges as close as possible while keeping like charges apart, maximizing attraction and minimizing repulsion.",
    whyItMatters:
      "It supplies the structural picture behind properties you are asked to explain elsewhere: why ionic solids are hard, brittle, high-melting, and conduct only when molten or dissolved. It carries narrower exam weight than the Lewis and VSEPR topics.",
    howPointsAreEarned:
      "You earn points by describing the lattice as an extended periodic array of alternating ions and explaining a macroscopic property from it — many strong attractions requiring large energy to disrupt, or a shifted layer aligning like charges and fracturing the crystal.",
    answerMove:
      "Explain ionic properties from the alternating-array arrangement and the many attractions it creates, not from memorized lattice names — specific crystal structures are explicitly not assessed on the AP Exam.",
    commonPointLoss:
      "Describing an ionic solid as separate molecules or discrete ion pairs, rather than one extended lattice of alternating charges.",
  },
  {
    topicId: "2.4",
    whatItIs:
      "A metal is an array of positive metal ions in a sea of delocalized valence electrons belonging to the solid as a whole. Interstitial alloys form when much smaller atoms sit in lattice gaps (carbon in iron, giving steel); substitutional alloys form when atoms of comparable radius replace host atoms.",
    whyItMatters:
      "This is where delocalization from 2.1 becomes an explanation for conductivity, malleability, and luster, and where atomic radius from Unit 1 does concrete structural work. The interstitial-versus-substitutional split is a clean, testable size argument.",
    howPointsAreEarned:
      "You earn points by invoking mobile delocalized electrons to explain conductivity, by invoking layers of ions sliding while the electron sea holds them together to explain malleability, and by classifying an alloy from an explicit atomic-radius comparison.",
    answerMove:
      "Classify an alloy by comparing atomic radii out loud — significantly different radii means interstitial, comparable radii means substitutional — and cite the radius comparison as your reason, not the identity of the metals.",
    commonPointLoss:
      "Saying metals conduct because they have free electrons, without stating those delocalized electrons are mobile throughout the whole solid.",
  },
  {
    topicId: "2.5",
    whatItIs:
      "A Lewis diagram is a bookkeeping drawing of where every valence electron sits. You total the valence electrons (adjusting for charge), arrange the atoms, connect them with single bonds, then distribute the rest as lone pairs to satisfy octets, converting lone pairs to multiple bonds where a central atom falls short.",
    whyItMatters:
      "The Lewis diagram is the input to nearly everything downstream — resonance and formal charge in 2.6, geometry and hybridization in 2.7, intermolecular forces in Unit 3. A wrong electron count poisons every conclusion built on it.",
    howPointsAreEarned:
      "You earn points for a complete, correct diagram: the valence-electron total matches the formula including the ion's charge, every bonding pair and lone pair is shown, octets are satisfied where required, and an ion is bracketed with its charge outside.",
    answerMove:
      "Write the valence-electron total as a number before drawing anything, then count the electrons in your finished picture and confirm the two match — and for a polyatomic ion, adjust that total for the charge and bracket the structure.",
    commonPointLoss:
      "Drawing only the bonds and forgetting lone pairs, or ignoring an ion's charge when totaling valence electrons.",
  },
  {
    topicId: "2.6",
    whatItIs:
      "Two refinements on a finished Lewis diagram. When several equivalent diagrams are possible, resonance says the real molecule is one averaged structure, not one flipping between forms. When candidates are nonequivalent, formal charge picks the best: minimize formal charges and put negative formal charge on the more electronegative atom.",
    whyItMatters:
      "This is the judgment layer between drawing a structure and using it. It explains why all bonds in nitrate or carbonate are identical rather than one short and two long, and tells you which of several legal drawings the exam expects you to reason from.",
    howPointsAreEarned:
      "You earn points by drawing all equivalent resonance forms and stating the actual structure is their average with intermediate bond length, and separately by computing formal charge — valence minus lone-pair electrons minus half the bonding electrons — to justify a chosen structure.",
    answerMove:
      "Decide first whether your candidate structures are equivalent or nonequivalent: equivalent ones call for drawing the resonance set and describing an averaged structure, nonequivalent ones call for showing the formal-charge arithmetic and naming which structure wins.",
    commonPointLoss:
      "Saying the molecule rapidly switches between resonance forms; it is one averaged structure, and those bonds are identical.",
  },
  {
    topicId: "2.7",
    whatItIs:
      "VSEPR predicts three-dimensional shape by assuming regions of electron density around a central atom repel and spread as far apart as possible, giving molecular geometry, bond angles, net dipole, and the hybridization label sp (180 degrees), sp2 (120 degrees), or sp3 (109.5 degrees). Sigma bonds form by head-on overlap; pi bonds are weaker and block rotation.",
    whyItMatters:
      "Geometry is the payoff of the unit and the entry to Unit 3: whether a molecule is polar — and so how it dissolves and boils — depends on shape plus bond dipoles. This is among the most heavily assessed topics in the unit.",
    howPointsAreEarned:
      "You earn points by counting regions of electron density around the central atom, where a lone pair counts as one and a double or triple bond counts as one region, then naming the geometry from atom positions, giving the bond angle, and assigning hybridization when asked.",
    answerMove:
      "Count regions of electron density first, counting each multiple bond as a single region, then answer exactly what was asked — a geometry name or an sp/sp2/sp3 label. Hybridization labels stop at sp3: for more than four electron pairs give only the shape, never d-orbital hybridization or molecular orbital theory.",
    commonPointLoss:
      "Counting a C=O double bond as two regions and answering sp3; a double bond is one region, so that carbon is sp2.",
  },
];
```
