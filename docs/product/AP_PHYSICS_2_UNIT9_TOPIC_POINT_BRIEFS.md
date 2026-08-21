# AP Physics 2 Unit 9 Topic Point Briefs

Status: Draft content system seed for new-user home and unit selector planning.

Purpose: preserve Cramapple-original topic point brief content for AP
Physics 2 Unit 9 (Thermodynamics). Unit 9 is AP Physics 2's first unit in
the local taxonomy — the College Board's restructured 2024-25 course numbers
AP Physics 2's units 9 through 15, continuing the sequence from AP Physics
1's units 1 through 8. These briefs help a new student understand how each
topic turns into point-attainment behavior without replacing a full lesson.

Source basis: AP Physics 2: Algebra-Based Course and Exam Description, plus
the local CED fact pack in `docs/product/AP_PHYSICS_2_CED_FACT_PACK.md`
(Unit 9 deep-tier detail, including verbatim CED boundary statements and
documented 2025 misconception patterns).

Content rules: same as the AP Chemistry / Calculus / Biology Unit 1 briefs —
no external links, no copied third-party language, subject- and
topic-specific, concept tied to point-earning behavior.

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

## Unit 9 Seed Content

```ts
const apPhysics2Unit9TopicPointBriefs: TopicPointBrief[] = [
  {
    unitId: "unit-9",
    topicId: "9.1",
    title: "Kinetic Theory: Temperature and Pressure",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "Gas pressure comes from atoms colliding with a surface — it's the perpendicular force per area those collisions produce, and it exists at every point inside the gas, not just at the container wall. Temperature is a measure of the atoms' average kinetic energy, and the Maxwell-Boltzmann distribution shows how that energy is spread across all the atoms at a given temperature.",
    whyItMatters:
      "This unit opens the course by replacing 'temperature' and 'pressure' as vague sensations with atomic-motion definitions you'll build every other Unit 9 idea on — internal energy, the first law, and entropy all trace back to this atomic picture.",
    howPointsAreEarned:
      "Points come from correctly relating P = F_perp/A to atomic collisions, computing or reasoning with average KE = (3/2)k_B*T = (1/2)m*v_rms^2, and reading qualitative features of a Maxwell-Boltzmann curve (peak location, spread, high-speed tail) to compare two temperatures or two gas samples.",
    answerMove:
      "When asked to compare two Maxwell-Boltzmann curves or describe how one changes with temperature, describe the shift and spread in words (peak moves to higher speed, curve flattens and widens) — do not attempt to state or use a mathematical formula for the distribution itself, since this course only requires qualitative reading of its shape.",
    commonPointLoss:
      "Describing pressure as something that only exists 'at the walls' instead of throughout the gas, or treating a higher Maxwell-Boltzmann peak speed as the only thing that changes with temperature while ignoring the spread.",
    learnMorePath: "/learn/ap-physics-2/unit-9/kinetic-theory-temperature-pressure",
    practiceParams: { subject: "ap_physics_2", unit: "9", topic: "9.1" },
  },
  {
    unitId: "unit-9",
    topicId: "9.2",
    title: "The Ideal Gas Law",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "The ideal gas law, PV = nRT = Nk_B*T, connects a gas's pressure, volume, temperature, and quantity of particles under the idealizations that atoms have negligible volume, move randomly, and collide elastically.",
    whyItMatters:
      "It's the single equation you'll use to predict how a gas responds when one variable is held fixed and another changes, and it's the algebraic backbone for the energy and work calculations later in this unit.",
    howPointsAreEarned:
      "Points require correctly solving PV = nRT (or Nk_B*T) for an unknown variable with consistent units (T in kelvin), reading values off P-V, P-T, or V-T graphs, and extrapolating a linear P-vs-T graph back to P = 0 to estimate absolute zero.",
    answerMove:
      "When a P-vs-T graph is given and the question asks for the temperature at which pressure would reach zero, extend the straight-line trend down to the T-axis (P = 0) rather than assuming the answer must be 0°C or reading only the plotted data range.",
    commonPointLoss:
      "Plugging a Celsius temperature directly into PV = nRT instead of converting to kelvin first.",
    learnMorePath: "/learn/ap-physics-2/unit-9/ideal-gas-law",
    practiceParams: { subject: "ap_physics_2", unit: "9", topic: "9.2" },
  },
  {
    unitId: "unit-9",
    topicId: "9.3",
    title: "Thermal Energy Transfer and Equilibrium",
    classImportance: "somewhat-important",
    examImportance: "somewhat-important",
    whatItIs:
      "Two objects in thermal contact can exchange energy by conduction, convection, or radiation; energy spontaneously flows from the higher-temperature system to the lower-temperature one until both reach the same temperature, a state called thermal equilibrium where net energy transfer stops.",
    whyItMatters:
      "This is the conceptual foundation for heating/cooling problems and for why systems drift toward equilibrium — an idea that resurfaces qualitatively when entropy and the second law are introduced later in the unit.",
    howPointsAreEarned:
      "Points come from correctly identifying the direction of spontaneous energy transfer (hot to cold, never the reverse), naming or distinguishing the transfer mechanism (conduction/convection/radiation) appropriate to a scenario, and stating that thermal equilibrium means zero net energy transfer, not zero atomic motion.",
    answerMove:
      "When asked to explain why two objects at different temperatures reach a common final temperature, frame it as the statistically most probable outcome of many random atomic collisions redistributing energy — not as 'heat rising' or objects 'wanting' to equalize.",
    commonPointLoss:
      "Describing thermal equilibrium as a state where atoms stop moving, rather than a state where net energy transfer between the two systems has stopped.",
    learnMorePath: "/learn/ap-physics-2/unit-9/thermal-equilibrium",
    practiceParams: { subject: "ap_physics_2", unit: "9", topic: "9.3" },
  },
  {
    unitId: "unit-9",
    topicId: "9.4",
    title: "The First Law of Thermodynamics",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "The first law, ΔU = Q + W, is energy conservation applied to a gas's internal energy: internal energy changes because thermal energy is transferred in/out (Q) or work is done on/by the gas as its volume changes (W = −PΔV). PV diagrams let you visualize a process, and the area under the curve gives the magnitude of work done.",
    whyItMatters:
      "Nearly every quantitative Unit 9 free-response question is built around this law — reading a PV diagram, identifying the process type, and tracking energy through Q, W, and ΔU is the core quantitative skill of the unit.",
    howPointsAreEarned:
      "Points require correctly applying sign conventions in ΔU = Q + W, computing W = −PΔV (or the area under a P-V curve) for a given process, identifying which quantity is zero or constant for isovolumetric/isothermal/isobaric/adiabatic processes, and computing ΔU = (3/2)nRΔT for a monatomic ideal gas.",
    answerMove:
      "When a process is labeled adiabatic, immediately set Q = 0 and get ΔU entirely from W — don't try to estimate any thermal energy transfer for that step, since by definition none occurs.",
    commonPointLoss:
      "Forgetting the negative sign in W = −PΔV, so an expanding gas (doing positive work on its surroundings) is incorrectly recorded as gaining energy from work instead of losing it.",
    learnMorePath: "/learn/ap-physics-2/unit-9/first-law-thermodynamics",
    practiceParams: { subject: "ap_physics_2", unit: "9", topic: "9.4" },
  },
  {
    unitId: "unit-9",
    topicId: "9.5",
    title: "Specific Heat and Thermal Conductivity",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "Specific heat (Q = mcΔT) tells you how much thermal energy changes a material's temperature; thermal conductivity (Q/Δt = kAΔT/L) tells you how fast thermal energy passes through a material of a given thickness and area. Both are fixed properties of the material.",
    whyItMatters:
      "These equations let you move from the qualitative hot-to-cold picture in 9.3 to actual numbers — how much energy transferred, or how quickly — which is tested constantly in calorimetry and conduction-rate problems.",
    howPointsAreEarned:
      "Points come from correctly using Q = mcΔT to find heat, mass, specific heat, or ΔT (including setting Q_lost = Q_gained in two-object mixing problems), and using Q/Δt = kAΔT/L to find conduction rate, and treating c as constant across the whole temperature change in a problem.",
    answerMove:
      "In any calorimetry problem, set the heat lost by the warmer object equal to the heat gained by the cooler object (Q_lost = Q_gained) and solve — do not average the two starting temperatures as a shortcut, since masses and specific heats can differ.",
    commonPointLoss:
      "Assuming specific heat changes as an object's temperature changes, instead of treating it as constant throughout the process as this course requires.",
    learnMorePath: "/learn/ap-physics-2/unit-9/specific-heat-conductivity",
    practiceParams: { subject: "ap_physics_2", unit: "9", topic: "9.5" },
  },
  {
    unitId: "unit-9",
    topicId: "9.6",
    title: "Entropy and the Second Law of Thermodynamics",
    classImportance: "somewhat-important",
    examImportance: "somewhat-important",
    whatItIs:
      "Entropy is a measure of how spread out or unavailable-to-do-work energy has become; it depends only on a system's current configuration, not its history. The second law says an isolated system's total entropy never decreases and stays constant only if every process in it is reversible.",
    whyItMatters:
      "It's the conceptual explanation for why processes in this unit — like heat flowing hot to cold — only ever run one direction, tying together the whole unit's picture of energy spreading toward equilibrium.",
    howPointsAreEarned:
      "Points come from qualitatively explaining why total entropy of an isolated system increases or stays the same for a given process, correctly identifying that a non-isolated (closed) system's entropy can decrease because energy crosses its boundary, and connecting maximum entropy to thermodynamic equilibrium — all in words, with no ΔS = Q/T calculation expected.",
    answerMove:
      "When asked to justify an entropy claim, explain it in terms of energy dispersal and probability (energy spreading among more possible configurations is far more likely than it spontaneously concentrating) — never attempt a numeric ΔS = Q/T calculation, since this course tests entropy only qualitatively.",
    commonPointLoss:
      "Claiming a single closed (non-isolated) part of a larger system can never lose entropy, when only the total entropy of a fully isolated system is guaranteed not to decrease.",
    learnMorePath: "/learn/ap-physics-2/unit-9/entropy-second-law",
    practiceParams: { subject: "ap_physics_2", unit: "9", topic: "9.6" },
  },
];
```
