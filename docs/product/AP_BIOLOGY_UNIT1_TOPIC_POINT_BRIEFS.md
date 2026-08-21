# AP Biology Unit 1 Topic Point Briefs

Status: Draft content system seed for new-user home and unit selector planning.

Purpose: preserve Cramapple-original topic point brief content for AP Biology
Unit 1. These briefs are meant to help a new student understand how each
Chemistry of Life topic turns into AP Biology point-attainment behavior without
replacing a full lesson.

Source basis: AP Biology Course and Exam Description, plus the local CED fact
pack in `docs/product/AP_BIOLOGY_CED_FACT_PACK.md`.

Content rules:

- Do not include external links.
- Do not copy third-party study-guide language.
- Keep each topic subject-specific, unit-specific, and point-focused.
- Each brief should connect concept -> importance -> point behavior -> practice.
- The `Learn more` route can later open Cramapple-authored instruction.
- The `Start practicing` route should filter practice by subject, unit, and topic.

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
const apBiologyUnit1TopicPointBriefs: TopicPointBrief[] = [
  {
    unitId: "unit-1",
    topicId: "1.1",
    title: "Structure of Water and Hydrogen Bonding",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "Water is a polar molecule. Its uneven charge distribution allows water molecules to form hydrogen bonds with each other and with other polar or charged substances.",
    whyItMatters:
      "Water properties explain many biological patterns: cohesion, adhesion, surface tension, temperature stability, solvent behavior, and why cells can maintain chemistry in aqueous environments.",
    howPointsAreEarned:
      "You earn points by connecting a property of water to the molecular reason behind it and then to the biological consequence. The answer should move from polarity or hydrogen bonding to the observed system behavior.",
    answerMove:
      "Use a three-step chain: water is polar -> hydrogen bonds form -> this causes the biological property or effect.",
    commonPointLoss:
      "Naming a water property without explaining how polarity or hydrogen bonding produces it.",
    learnMorePath: "/learn/ap-biology/unit-1/water-and-hydrogen-bonding",
    practiceParams: {
      subject: "ap_biology",
      unit: "1",
      topic: "1.1",
    },
  },
  {
    unitId: "unit-1",
    topicId: "1.2",
    title: "Elements of Life",
    classImportance: "very-important",
    examImportance: "somewhat-important",
    whatItIs:
      "Living systems are built mostly from a small set of elements, especially carbon, hydrogen, oxygen, nitrogen, phosphorus, and sulfur. These elements form the atoms in biological macromolecules.",
    whyItMatters:
      "Element composition helps students explain why particular molecules can store energy, carry information, form membranes, or build cellular structures.",
    howPointsAreEarned:
      "You earn points by linking an element to the molecule or structure it supports, such as phosphorus in nucleic acids and phospholipids or nitrogen in amino acids and nucleotides.",
    answerMove:
      "Do not just list elements. Connect the element to a biological molecule and the molecule to its function.",
    commonPointLoss:
      "Reciting CHNOPS without explaining what those elements let cells build or do.",
    learnMorePath: "/learn/ap-biology/unit-1/elements-of-life",
    practiceParams: {
      subject: "ap_biology",
      unit: "1",
      topic: "1.2",
    },
  },
  {
    unitId: "unit-1",
    topicId: "1.3",
    title: "Introduction to Macromolecules",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "Biological macromolecules are large molecules built from smaller subunits. Dehydration synthesis builds polymers by removing water, and hydrolysis breaks polymers by adding water.",
    whyItMatters:
      "This topic gives students a reusable way to think about carbohydrates, proteins, nucleic acids, and many digestion or biosynthesis contexts.",
    howPointsAreEarned:
      "You earn points by identifying whether a system is building or breaking a polymer and by connecting the reaction to water use or release and bond formation or cleavage.",
    answerMove:
      "Ask: is the cell building a larger molecule or breaking one apart? Then name dehydration synthesis or hydrolysis and state what happens to water.",
    commonPointLoss:
      "Mixing up dehydration synthesis and hydrolysis, especially the direction of water movement.",
    learnMorePath: "/learn/ap-biology/unit-1/macromolecules",
    practiceParams: {
      subject: "ap_biology",
      unit: "1",
      topic: "1.3",
    },
  },
  {
    unitId: "unit-1",
    topicId: "1.4",
    title: "Carbohydrates",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "Carbohydrates include monosaccharides and polysaccharides. They can provide readily usable energy, store energy, or contribute to structural support depending on their bonds and organization.",
    whyItMatters:
      "AP Biology often rewards structure-function reasoning. The same basic sugar subunits can lead to different biological roles depending on how they are linked and arranged.",
    howPointsAreEarned:
      "You earn points by connecting carbohydrate structure to function, such as glucose availability for energy, starch or glycogen for storage, or cellulose for plant cell wall support.",
    answerMove:
      "Name the carbohydrate type, identify the structural feature, and connect it to energy storage, energy use, or support.",
    commonPointLoss:
      "Saying carbohydrates are only for energy and missing structural roles such as cellulose.",
    learnMorePath: "/learn/ap-biology/unit-1/carbohydrates",
    practiceParams: {
      subject: "ap_biology",
      unit: "1",
      topic: "1.4",
    },
  },
  {
    unitId: "unit-1",
    topicId: "1.5",
    title: "Lipids",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "Lipids are generally nonpolar or hydrophobic molecules. Important examples include fats, phospholipids, and steroids, each with structures that support different cell functions.",
    whyItMatters:
      "Lipids connect Unit 1 chemistry to membranes, energy storage, insulation, signaling, and cell compartment boundaries later in the course.",
    howPointsAreEarned:
      "You earn points by connecting nonpolar or amphipathic structure to function. For example, phospholipid structure explains membrane formation, while fats support long-term energy storage.",
    answerMove:
      "Start with polarity: hydrophobic or amphipathic? Then connect that property to membrane behavior, storage, insulation, or signaling.",
    commonPointLoss:
      "Treating all lipids as the same instead of distinguishing fats, phospholipids, and steroids by structure and function.",
    learnMorePath: "/learn/ap-biology/unit-1/lipids",
    practiceParams: {
      subject: "ap_biology",
      unit: "1",
      topic: "1.5",
    },
  },
  {
    unitId: "unit-1",
    topicId: "1.6",
    title: "Nucleic Acids",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "Nucleic acids such as DNA and RNA are polymers of nucleotides. Their nucleotide sequences store and transmit biological information.",
    whyItMatters:
      "This topic starts the information theme that returns in DNA replication, gene expression, biotechnology, inheritance, and evolution.",
    howPointsAreEarned:
      "You earn points by connecting nucleotide structure and sequence to information storage, directionality, complementary base pairing, or differences between DNA and RNA.",
    answerMove:
      "When asked about DNA or RNA, connect structure to information: sequence stores instructions, base pairing supports copying, and strand direction affects synthesis.",
    commonPointLoss:
      "Describing nucleic acids only as genetic material without explaining how sequence, base pairing, or strand structure supports the function.",
    learnMorePath: "/learn/ap-biology/unit-1/nucleic-acids",
    practiceParams: {
      subject: "ap_biology",
      unit: "1",
      topic: "1.6",
    },
  },
  {
    unitId: "unit-1",
    topicId: "1.7",
    title: "Proteins",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "Proteins are polymers of amino acids joined by peptide bonds. A protein's amino acid sequence influences its folding, shape, and function.",
    whyItMatters:
      "Proteins are central to enzymes, transport, signaling, structure, movement, and regulation. AP Biology questions often ask students to connect a change in structure to a change in function.",
    howPointsAreEarned:
      "You earn points by tracing the structure-function chain: amino acid sequence affects interactions, interactions affect folding and shape, and shape affects protein function.",
    answerMove:
      "Use the chain: sequence -> folding/shape -> function. If a mutation or environmental change appears, explain how it could alter that chain.",
    commonPointLoss:
      "Saying a protein is denatured or changed without connecting the structural change to a functional consequence.",
    learnMorePath: "/learn/ap-biology/unit-1/proteins",
    practiceParams: {
      subject: "ap_biology",
      unit: "1",
      topic: "1.7",
    },
  },
];
```
