# AP Chemistry Unit 1 Topic Point Briefs

Status: Draft content system seed for new-user home and unit selector planning.

Purpose: preserve Cramapple-original topic point brief content for AP
Chemistry Unit 1 (Atomic Structure and Properties). These briefs are meant to
help a new student understand how each topic turns into point-attainment
behavior without replacing a full lesson.

Source basis: AP Chemistry Course and Exam Description, Effective Fall 2024,
plus the local CED fact pack in
`docs/product/AP_CHEMISTRY_CED_FACT_PACK.md` (Unit 1 deep-tier detail,
including verbatim exclusion statements and the 2025 FRQ/CRR misconception
data cited for Topic 1.2).

Content rules:

- Do not include external links.
- Do not copy third-party study-guide language.
- Keep each topic subject-specific, unit-specific, and point-focused.
- Each brief should connect concept -> importance -> point behavior -> practice.
- The `Learn more` route can later open Cramapple-authored instruction.
- The `Start practicing` route should filter practice by subject, unit, and topic.

This file follows the same `Learn More Behavior`, `Type`, and content-standard
conventions established in
`docs/product/AP_CALCULUS_UNIT1_TOPIC_POINT_BRIEFS.md` and
`docs/product/AP_BIOLOGY_UNIT1_TOPIC_POINT_BRIEFS.md`. See those files for the
full page-structure and navigation spec; this file adds only the AP Chemistry
Unit 1 content and the type reference for convenience.

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

## Unit 1 Seed Content

```ts
const apChemistryUnit1TopicPointBriefs: TopicPointBrief[] = [
  {
    unitId: "unit-1",
    topicId: "1.1",
    title: "Moles and Molar Mass",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "You cannot count individual atoms or molecules directly in the lab. The mole and Avogadro's number (6.022 x 10^23 per mol) give a bridge from a measurable mass to a particle count, using n = m/M.",
    whyItMatters:
      "Almost every quantitative calculation in this course, including stoichiometry, solution concentration, and gas laws, starts by converting between mass and moles. This is the entry-level skill the rest of AP Chemistry depends on.",
    howPointsAreEarned:
      "You earn points by correctly using n = m/M (and its rearrangements) to convert between mass, moles, and particle count, and by using the right molar mass for the substance in question.",
    answerMove:
      "Before calculating, write down what you are given (mass, moles, or particle count) and what you need, then choose n = m/M or n times Avogadro's number to connect them.",
    commonPointLoss:
      "Using the wrong molar mass, such as an element's molar mass in a compound problem, or miscounting atoms when summing a compound's molar mass from its formula.",
    learnMorePath: "/learn/ap-chemistry/unit-1/moles-and-molar-mass",
    practiceParams: {
      subject: "ap_chemistry",
      unit: "1",
      topic: "1.1",
    },
  },
  {
    unitId: "unit-1",
    topicId: "1.2",
    title: "Mass Spectra of Elements",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "A mass spectrum of a single element shows a peak for each isotope, positioned at that isotope's mass and sized by its relative abundance in a natural sample. Average atomic mass is the isotope-weighted average of those peaks.",
    whyItMatters:
      "This is how average atomic mass is actually determined from data instead of memorized, and it reinforces that isotopes of an element share proton count but differ in neutron count.",
    howPointsAreEarned:
      "You earn points by reading isotope mass and relative abundance off the spectrum, multiplying each isotope's mass by its fractional abundance, and summing to calculate the weighted average atomic mass.",
    answerMove:
      "For each peak, multiply the isotope mass by its fractional abundance, then add the products across every peak to get the weighted average atomic mass.",
    commonPointLoss:
      "Attributing isotope mass differences to electrons or protons instead of neutrons.",
    learnMorePath: "/learn/ap-chemistry/unit-1/mass-spectra-of-elements",
    practiceParams: {
      subject: "ap_chemistry",
      unit: "1",
      topic: "1.2",
    },
  },
  {
    unitId: "unit-1",
    topicId: "1.3",
    title: "Elemental Composition of Pure Substances",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "The law of definite proportions says the mass ratio of elements in any pure sample of a compound is always the same. The empirical formula is the lowest whole-number ratio of atoms that matches that mass ratio.",
    whyItMatters:
      "This connects experimental mass data, such as combustion analysis, to a compound's formula. It is a lab-grounded skill that reappears whenever a question gives percent composition or masses instead of a formula.",
    howPointsAreEarned:
      "You earn points by converting given masses or mass percentages to moles of each element, dividing every mole value by the smallest one, and rounding to a whole-number ratio to get the empirical formula, then scaling to the molecular formula if molar mass is given.",
    answerMove:
      "Assume a 100 g sample so mass percent becomes grams, convert each element's grams to moles, divide every mole value by the smallest mole value, then scale to whole numbers.",
    commonPointLoss:
      "Stopping at the empirical formula when the molecular formula was asked for, by not scaling the empirical formula using the ratio of given molar mass to empirical formula mass.",
    learnMorePath:
      "/learn/ap-chemistry/unit-1/elemental-composition-of-pure-substances",
    practiceParams: {
      subject: "ap_chemistry",
      unit: "1",
      topic: "1.3",
    },
  },
  {
    unitId: "unit-1",
    topicId: "1.4",
    title: "Composition of Mixtures",
    classImportance: "somewhat-important",
    examImportance: "somewhat-important",
    whatItIs:
      "A pure substance contains one type of particle in a fixed proportion. A mixture contains two or more particle types whose proportions can vary from sample to sample. Elemental analysis can be used to check a sample's purity.",
    whyItMatters:
      "This distinction between fixed-ratio compounds and variable-ratio mixtures is what makes empirical formula reasoning valid in the first place, and it reappears when Unit 3 asks about separating mixtures and solutions.",
    howPointsAreEarned:
      "You earn points by using elemental analysis data across multiple samples to test whether a component ratio stays constant, and by using that evidence to argue whether a sample is a pure substance or a mixture.",
    answerMove:
      "Compare the calculated mass ratio of components across two or more samples of the same material. A constant ratio supports a pure substance; a changing ratio supports a mixture.",
    commonPointLoss:
      "Assuming a sample is a pure substance just because it looks uniform or homogeneous, instead of checking whether its elemental composition ratio stays constant across independent samples.",
    learnMorePath: "/learn/ap-chemistry/unit-1/composition-of-mixtures",
    practiceParams: {
      subject: "ap_chemistry",
      unit: "1",
      topic: "1.4",
    },
  },
  {
    unitId: "unit-1",
    topicId: "1.5",
    title: "Atomic Structure and Electron Configuration",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "An atom is a positively charged nucleus (protons and neutrons) surrounded by negatively charged electrons. Coulomb's law describes the force between charged particles as proportional to q1 times q2 divided by r squared. Electron configuration follows the Aufbau principle, filling shells and subshells in order of increasing energy.",
    whyItMatters:
      "Electron configuration explains reactivity, typical bonding behavior, and every periodic trend covered for the rest of the course, and it is the structural fact behind the photoelectron spectroscopy evidence in the next topic.",
    howPointsAreEarned:
      "You earn points by writing correct ground-state electron configurations using the Aufbau filling order, and by using Coulomb's law reasoning, meaning charge and distance from the nucleus, to explain why a configuration produces a given property instead of only stating the property.",
    answerMove:
      "Fill subshells in order of increasing energy (1s, 2s, 2p, 3s, 3p, 4s, 3d, and so on), then explain any related property, such as ionization energy, using nuclear charge and electron distance or shielding rather than stopping at the configuration itself.",
    commonPointLoss:
      "Writing a correct electron configuration but then explaining a related property, such as ionization energy, with a vague label like 'periodic trend' instead of grounding the explanation in nuclear charge and electron distance or shielding, which is what the Coulomb's law reasoning actually requires.",
    learnMorePath:
      "/learn/ap-chemistry/unit-1/atomic-structure-and-electron-configuration",
    practiceParams: {
      subject: "ap_chemistry",
      unit: "1",
      topic: "1.5",
    },
  },
  {
    unitId: "unit-1",
    topicId: "1.6",
    title: "Photoelectron Spectroscopy",
    classImportance: "somewhat-important",
    examImportance: "somewhat-important",
    whatItIs:
      "In a photoelectron spectrum (PES), each peak's position shows the energy needed to remove an electron from a specific subshell, and each peak's height is approximately proportional to the number of electrons in that subshell.",
    whyItMatters:
      "PES gives direct experimental evidence for electron configuration and shell structure, turning the electron configuration rules from Topic 1.5 into something read off real data instead of only memorized.",
    howPointsAreEarned:
      "You earn points by matching a spectrum's peak positions and relative heights to a specific element's electron configuration, and by explaining that core electrons need more energy to remove because they are closer to the nucleus and less shielded than valence electrons.",
    answerMove:
      "Count the number of peaks and compare their relative heights first to identify subshell electron counts, then match that pattern to a specific element's electron configuration before discussing binding energy.",
    commonPointLoss:
      "Confusing binding energy order with orbital filling order; a subshell with higher binding energy is held more tightly and closer to the nucleus, which is not necessarily the last subshell filled by the Aufbau principle.",
    learnMorePath: "/learn/ap-chemistry/unit-1/photoelectron-spectroscopy",
    practiceParams: {
      subject: "ap_chemistry",
      unit: "1",
      topic: "1.6",
    },
  },
  {
    unitId: "unit-1",
    topicId: "1.7",
    title: "Periodic Trends",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "Periodic table position reflects recurring electron configuration patterns. Trends in ionization energy, atomic and ionic radius, electron affinity, and electronegativity are explained qualitatively using Coulomb's law, shielding, and effective nuclear charge.",
    whyItMatters:
      "Periodic trends let you predict or estimate a property for an unfamiliar element from its position alone, and this qualitative reasoning skill is tested throughout the exam, not only in Unit 1.",
    howPointsAreEarned:
      "You earn points by explaining a trend using effective nuclear charge and distance from the nucleus or shielding, not just by naming the trend's direction, and by using the trend to make a specific comparison or estimate when exact data is missing.",
    answerMove:
      "For a trend question, choose whichever Coulombic factor actually differs between the two atoms or ions being compared, effective nuclear charge, distance from the nucleus, or shielding, and use only that factor to justify the direction of the trend.",
    commonPointLoss:
      "Correctly stating the direction of a trend, such as 'ionization energy increases across a period,' without explaining why through effective nuclear charge and shielding; an unsupported direction claim does not earn the explanation point.",
    learnMorePath: "/learn/ap-chemistry/unit-1/periodic-trends",
    practiceParams: {
      subject: "ap_chemistry",
      unit: "1",
      topic: "1.7",
    },
  },
  {
    unitId: "unit-1",
    topicId: "1.8",
    title: "Valence Electrons and Ionic Compounds",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "Bond formation is governed by how valence electrons interact with the nucleus. Elements in the same column tend to form analogous compounds, and an element's typical ionic charge can be predicted from its valence electron count and periodic table position.",
    whyItMatters:
      "This sets up bonding and compound formation for Unit 2, and it lets you predict a formula or an analogous compound for an element you have not seen before, based on periodic position alone.",
    howPointsAreEarned:
      "You earn points by predicting an ion's typical charge from its group number or valence electron count, and by using that charge to predict a compound's formula or to identify an analogous compound for a same-column element.",
    answerMove:
      "For common main-group ions, count valence electrons from the group number, determine how many electrons must be gained or lost to reach a noble-gas configuration, and use that number as the ion's typical charge.",
    commonPointLoss:
      "Guessing or misremembering an ionic charge instead of deriving it from valence electron count and group position, or proposing a compound formula whose total positive and negative charge does not balance to zero.",
    learnMorePath:
      "/learn/ap-chemistry/unit-1/valence-electrons-and-ionic-compounds",
    practiceParams: {
      subject: "ap_chemistry",
      unit: "1",
      topic: "1.8",
    },
  },
];
```
