# AP Chemistry CED Reference Scope Inventory

Status: **Pre-production scope extraction**

Date: 2026-10-09

Coverage: Current AP Chemistry Course and Exam Description, all 9 units and 91 topics

## Purpose and status

This inventory executes the first two steps of the CED-first unit-reference plan:

1. extract the vocabulary/concepts, quantitative relationships, and representations that the current CED requires students to understand or use; and
2. organize that scope under the current 91-topic taxonomy.

It is a scope map, not final student-facing copy. The short phrases below identify candidate reference content; they are not approved definitions, equation cards, diagram specifications, or claims that every phrase must become a separate card. Before publication, each candidate entry still needs exact CED evidence, consolidation/ownership decisions, student-facing writing, and the production checking workflow.

Primary source: `docs/teaching/ap-chemistry-course-and-exam-description.pdf`

Indexed extraction aid: `docs/product/AP_CHEMISTRY_CED_FACT_PACK.md`

Production rules: `docs/product/MEMORY_HOOKS_AND_UNIT_REFERENCE_PRODUCTION_PROTOCOL.md`

### Column meanings

- **Vocabulary / concepts**: terms, distinctions, conventions, named models, and named processes the student must understand or apply.
- **Quantitative relationships**: equations plus non-equation proportional or algebraic relationships the student must construct or apply. Inclusion here does not mean the equation is absent from the AP equation sheet.
- **Representations / work**: graphs, particulate models, structural diagrams, symbolic representations, or experimental displays students must interpret or produce.
- **CED boundary**: explicit exclusions or unusually important scope limits. “—” means no explicit exclusion was recorded in the fact pack for that topic, not that the topic is unlimited.

## Reference Pack build protocol

This section defines how the scope inventory below becomes the AP Chemistry **Reference Pack** used
by Lesson Notes and the question-page reference pane. It is the AP Chemistry application of
`MEMORY_HOOKS_AND_UNIT_REFERENCE_PRODUCTION_PROTOCOL.md`; if the two documents conflict, that
production protocol and the cited Product Owner decisions govern.

### 1. Product and content boundary

A complete Reference Pack is the checked, student-facing collection for one unit. It contains:

1. **Vocabulary**: terms, distinctions, conventions, named models, and named processes that the CED
   requires a student to understand or apply.
2. **Equations and quantitative relationships**: named equations, proportional relationships, and
   algebraic relationships the CED requires a student to construct, select, interpret, or use.
3. **Memory hooks**: optional recall devices attached to one accepted vocabulary, equation,
   list/sequence, convention, or diagram entry. Most entries and many topics should have no hook.

The full accepted pack belongs in Lesson Notes. A question page shows only the subset directly useful
for that question: at most three vocabulary entries, only relevant equations/visuals, and at most one
directly relevant memory hook. Empty categories are omitted. The question-page limit is a presentation
rule, not a reason to omit CED-required content from the full pack.

Representations in the inventory remain inputs to the governed diagram/visual lane. A diagram may be
represented as a reference entry with checked labelled parts, but this protocol does not authorize a
new renderer or an unreviewed image. Until a governed asset exists, the entry is text-only.

The pack is not a glossary, textbook summary, formula dump, or substitute for instruction. Include an
entry only when a current AP Chemistry CED learning objective or essential-knowledge statement requires
the student to reproduce, select, interpret, or apply it. Respect every boundary in the rightmost column
below. Content from another unit, merely helpful enrichment, and familiar chemistry trivia are excluded.

### 2. Governing inputs

Use all four inputs before creating candidates:

1. the current AP Chemistry CED PDF, which is authoritative;
2. `AP_CHEMISTRY_CED_FACT_PACK.md`, as an indexed extraction aid rather than an authority;
3. this 91-topic inventory, as the completeness and boundary checklist; and
4. the current `app.taxonomy_topics` rows, as the valid subject/unit/topic keys.

Build one unit per batch. Unit 4 is not regenerated: its 22 checked Production entries are the starting
set, and later work may add or retire an entry only through the same evidence and checking process.

### 3. Consolidate the inventory into candidate entries

The phrases in a topic row are prompts for extraction, not card boundaries. Consolidate them before
student-facing writing:

- one entry should answer one lookup need;
- combine synonyms and inseparable ideas; split ideas with different definitions, conditions, or uses;
- assign the entry to the topic whose own learning objective or essential knowledge requires it as stated,
  which is not necessarily the earliest topic that mentions the idea (`owner_topic_code`; the rule, its test
  and five ruled examples are in `MEMORY_HOOKS_AND_UNIT_REFERENCE_PRODUCTION_PROTOCOL.md` §1.1);
- add a later topic to `topic_codes` only when that topic's own CED objective or essential knowledge
  uses the entry, and never add a topic that precedes the owner; and
- never duplicate an entry merely because later topics reuse it.

Every candidate manifest row must record:

| Field | Required content |
|---|---|
| Identity | stable candidate id, `subject_key`, unit, `owner_topic_code`, and `topic_codes` |
| Kind | `vocabulary`, `formula`, `list_sequence`, `convention`, or `diagram` |
| Student content | title, body, ordered items when applicable, and optional governed `visual_asset_ref` |
| Boundary | when to use it, when not to use it, assumptions/conditions, and a `caution` when needed |
| CED evidence | CED edition, printed/PDF page, topic, and the exact learning-objective or essential-knowledge identifier(s) supporting inclusion and wording |
| Provenance | extraction batch, source files, extractor/model version, and generation date |
| Equation metadata | common equation name, symbol meanings, units or unit constraints, and AP equation-sheet availability where applicable |
| Hook linkage | proposed hook or an explicit `no_hook`; a hook points to this entry and never owns separate academic content |

The database schema remains the one in `TASK-0067`: equation details that do not yet have dedicated
columns stay in the checked candidate manifest and are encoded in `body`, `items`, and `caution` for
publication. Do not silently add client-only fields or duplicate the content in frontend code.

### 4. Student-writing rules by component

#### Vocabulary

- Use the CED's meaning and preferred chemistry language, not a generic dictionary definition.
- Define the term in one or two concise sentences, including the distinction that makes it useful.
- State conditions or limits that prevent the predictable misconception.
- Do not define a term with another undefined specialist term when a plain-language bridge is possible.
- If common classroom language differs from point-earning CED language, put the exam-safe wording in
  the definition and the warning in `caution`.

#### Equations and quantitative relationships

- Give the accepted name and a mathematically correct LaTeX expression.
- Define every symbol and distinguish quantities that students commonly confuse.
- State required units, temperature scale, standard-state assumptions, sign convention, or other
  conditions when they affect correct use.
- State what the relationship computes or supports and the evidence that tells a student to use it.
- Record important non-use boundaries, including CED-excluded calculations.
- Distinguish an equality from a proportional or qualitative relationship; do not turn a trend into a
  false exact formula.
- Equation-sheet availability is metadata, not an inclusion rule: an equation may still belong in the
  pack when the CED requires students to select or interpret it.

#### Memory hooks

- Propose a hook only after identifying the accepted reference entry it helps recall.
- One hook recalls one entry; `reference_entry_id` is required and its topic scope is inherited.
- The expansion must be complete, correctly ordered when order matters, and no broader than the entry.
- Prefer familiar public-domain classroom devices or short Cramapple-authored phrases. Do not use a
  publisher's novel wording, songs, lyrics, or audio.
- Record `public-domain-common` or `cramapple-authored` provenance.
- A hook is recall language, not the exam answer. Add a caution whenever the student must translate it
  into CED language to earn credit.
- “No hook” is the normal and acceptable outcome; never manufacture one to fill a UI slot.

### 5. Generate, check, and resolve

Follow the configured production pipeline rather than editing a weak candidate into shape:

1. **Extract from evidence.** Use the unit's CED pages plus its fact-pack section to produce the
   consolidated candidates and optional hooks. Extraction is evidence transformation, not free-form
   textbook authoring.
2. **Create controls first.** Plant six verified defects for the unit: a wrong formula or definition,
   a CED-excluded/non-CED item, a wrong owner topic, a wrong list member or order, a wrong hook
   expansion, and content from another unit. Verify every defect against the CED before the run.
3. **Run two independent checkers.** Each student-facing claim is judged for factual accuracy,
   CED-required scope, owner/reuse topics, conditions and cautions, and evidence support. A hook is also
   judged for correct expansion/order, linkage, admissibility, and rights-safe provenance.
4. **Run the reject-only own-family audit.** The veto can reject but cannot rewrite or approve a row
   that either independent checker rejected. Entry and hook verdicts are independent: rejecting a hook
   does not reject its reference entry.
5. **Re-sample flags once.** Only a repeated flag counts. Acceptance requires both independent
   checkers to accept and no repeated veto. All six controls must be rejected; otherwise validate the
   control, then either replace an invalid control and rerun controls only or void the batch.
6. **Round 2 is stateless.** Re-extract rejected entries from their title, owner topic, and original CED
   evidence without exposing checker reasons. Check them again. Do not hand-edit generated rows.
7. **Escalate evidence, not model preference.** A row still rejected after two rounds goes to the
   Product Owner with the candidate, CED citation, both checker reasons, and the veto reason. The Product
   Owner may accept/reject the row or decide ownership; the decision is recorded in provenance. Do not
   ask models to debate until they converge.

The current configured roles and smoke-test requirements live in
`MEMORY_HOOKS_AND_UNIT_REFERENCE_PRODUCTION_PROTOCOL.md`. As of 2026-10-09, extraction uses Claude
Sonnet 5.5; the independent checkers are Gemini 3.5 Flash and GPT-6 Sol; Claude Haiku 5.5 is the
reject-only own-family audit. A roster change requires the protocol's smoke test and batch-level Product
Owner ratification before its verdicts count.

### 6. Acceptance gates

An individual row is publishable only when all applicable checks pass:

| Component | Required acceptance evidence |
|---|---|
| Vocabulary | CED-supported inclusion and topic ownership; accurate definition; exam-safe terminology; misconception boundary/caution; two-checker acceptance and no veto |
| Equation/relationship | correct name and expression; symbols and units/conditions; appropriate use and non-use boundary; equation-sheet metadata recorded; CED-supported ownership; two-checker acceptance and no veto |
| Memory hook | accepted linked entry; exact expansion/order; accurate use statement; caution where hook wording differs from CED wording; rights-safe provenance; two-checker acceptance and no veto |
| Diagram entry | CED-required labelled parts; existing governed asset reference or explicit text-only fallback; separate visual QA when an asset is present |

A unit pack is complete only when:

- every vocabulary, quantitative-relationship, and representation phrase in that unit's inventory has
  a disposition: accepted entry, consolidated into a named entry, or excluded with a CED-backed reason;
- every accepted row has an owner and all reuse topics validate against the current taxonomy;
- duplicates have been resolved across the unit;
- all controls passed and all checker/escalation decisions are recorded;
- “no hook” outcomes are retained rather than silently treated as missing work; and
- the pack has been compared back to every topic row and CED boundary in this inventory.

### 7. Package, load, and present

The batch directory must preserve the candidate manifest, controls, checker verdicts, accepted/rejected
counts, no-hook outcomes, escalations/overrides, generated load SQL, QA results, model slate, and cost.
Raw model-call JSONL logs are not committed.

Load the generated SQL into Development; do not retype accepted copy. Run the zero-orphan, owner-unit,
published-hook linkage, view, and `get_topic_point_guides` checks from
`scripts/qa/unit_reference_and_memory_hooks_qa.sql`. Probe at least one topic with entries, one topic
with a hook, the unit roll-up, and an empty result.

For student surfaces:

- **Lesson Notes:** show the complete accepted unit/topic pack, grouped by kind and owner topic.
- **Worked examples and Practice:** choose the question-relevant projection; vocabulary is capped at
  three and no answer truth may leak before a graded Practice submission.
- **BYOQ:** populate the projection only after the student confirms both unit and topic; never infer a
  topic, grade the student's question, or fabricate missing reference content.
- **All surfaces:** omit empty sections and display cautions with their entry or hook.

Production remains a Hard Gate: it requires the named batch and rollback in the approvals log, loading
the same generated SQL, rerunning data/RPC QA, and separately approving any frontend publish. Retire
hooks before retiring their linked entries.

## Unit 1 — Atomic Structure and Properties

| Topic | Vocabulary / concepts | Quantitative relationships | Representations / work | CED boundary |
|---|---|---|---|---|
| **1.1 Moles and Molar Mass** | mole; Avogadro's number; molar mass; particle; formula unit | \(n=m/M\); \(N=nN_A\); one-particle mass in amu corresponds numerically to molar mass in g/mol | convert among mass, moles, and particle count; connect particulate and macroscopic amounts | — |
| **1.2 Mass Spectra of Elements** | isotope; relative abundance; average atomic mass; mass spectrum | weighted-average atomic mass | read peak position and relative height; infer isotope identity/abundance; construct or annotate a single-element spectrum | No multielement spectra or peaks from species other than singly charged monatomic ions |
| **1.3 Elemental Composition of Pure Substances** | law of definite proportions; empirical formula; molecular formula; percent composition | mass ratio; lowest whole-number mole ratio | derive an empirical formula from elemental-composition data | — |
| **1.4 Composition of Mixtures** | pure substance; mixture; particle type; purity; elemental analysis | component fraction and relative atom counts as supported by data | distinguish pure-substance and mixture particle models; infer composition/purity | — |
| **1.5 Atomic Structure and Electron Configuration** | proton; neutron; electron; nucleus; shell; subshell; orbital; Aufbau principle; shielding; effective nuclear charge | \(F_{coulombic}\propto q_1q_2/r^2\) | write/interpret ground-state electron configurations and orbital diagrams; connect structure to ionization energy | Assigning quantum numbers is not assessed |
| **1.6 Photoelectron Spectroscopy** | photoelectron spectroscopy (PES); binding energy; subshell | peak position ↔ removal energy; peak intensity/area ↔ electron count | interpret PES peak positions and relative sizes; match spectra to electron configurations | — |
| **1.7 Periodic Trends** | periodicity; atomic radius; ionic radius; ionization energy; electron affinity; electronegativity; shielding; effective nuclear charge | qualitative Coulombic relationships among charge, distance, and attraction | use periodic-table position/electron configuration to predict and justify trends; estimate missing values from data | Electron configurations of Aufbau exceptions are not assessed |
| **1.8 Valence Electrons and Ionic Compounds** | valence electron; core electron; ion; cation; anion; ionic charge; isoelectronic species | charge follows electron loss/gain needed for stable valence arrangements | predict common monatomic-ion charges and analogous compounds from periodic position | — |

## Unit 2 — Compound Structure and Properties

| Topic | Vocabulary / concepts | Quantitative relationships | Representations / work | CED boundary |
|---|---|---|---|---|
| **2.1 Types of Chemical Bonds** | nonpolar covalent; polar covalent; ionic; metallic bonding; electronegativity; bond dipole; ionic character; delocalized electron | electronegativity difference ↔ bond polarity/ionic character, used as a continuum | classify bonding from composition, electronegativity, structure, and properties; show bond-dipole direction | — |
| **2.2 Intramolecular Force and Potential Energy** | intramolecular force; equilibrium bond length; bond energy; bond order; internuclear distance | larger bond order → shorter/stronger bond; Coulombic attraction increases with charge and decreases with distance | interpret/draw potential-energy vs. internuclear-distance curves; compare well depth and minimum position | — |
| **2.3 Structure of Ionic Solids** | crystal lattice; coordination; Coulombic attraction/repulsion; lattice structure | relative interaction strength from ion charge and separation | interpret/produce particulate lattice models that maximize unlike-charge attraction and minimize like-charge repulsion | Specific crystal structures are not assessed |
| **2.4 Structure of Metals and Alloys** | metallic bonding; sea of electrons; interstitial alloy; substitutional alloy; malleability; ductility; conductivity | atomic-radius similarity determines likely alloy type qualitatively | interpret/produce particle models of pure metals, interstitial alloys, and substitutional alloys | — |
| **2.5 Lewis Diagrams** | Lewis diagram; bonding pair; lone pair; octet rule; expanded octet | valence-electron counting | construct and interpret Lewis structures from formulas/charges | — |
| **2.6 Resonance and Formal Charge** | resonance; resonance form; formal charge; equivalent structure; odd-electron species; Lewis-model limitation | formal charge = valence electrons − nonbonding electrons − 1/2 bonding electrons | construct equivalent resonance forms; select better nonequivalent structures using octets/formal charges | — |
| **2.7 VSEPR and Hybridization** | electron domain; VSEPR; molecular geometry; bond angle; molecular polarity; hybridization; sigma bond; pi bond; geometric isomer | ideal angles: sp 180°, sp² 120°, sp³ 109.5°; bond order ↔ length/energy | derive geometry, approximate angles, polarity, and sp/sp²/sp³ from Lewis structures; distinguish σ/π bonding | No derivation/depiction of hybrid orbitals; no d-orbital hybridization; no assessed MO diagrams/filling |

## Unit 3 — Properties of Substances and Mixtures

| Topic | Vocabulary / concepts | Quantitative relationships | Representations / work | CED boundary |
|---|---|---|---|---|
| **3.1 Intermolecular and Interparticle Forces** | London dispersion; polarizability; dipole-dipole; ion-dipole; hydrogen bonding; intermolecular vs. intramolecular | IMF strength trends with charge, separation, polarity, and electron-cloud size/polarizability | identify and draw relevant attractions; connect particle-level interactions to macroscopic properties | “London dispersion” is not synonymous with all van der Waals forces |
| **3.2 Properties of Solids** | ionic solid; covalent-network solid; molecular solid; metallic solid; vapor pressure; boiling point; melting point; brittleness; conductivity; malleability; ductility | stronger attractions generally → lower vapor pressure/higher boiling point; melting-point relation is less direct | classify solids from structure/properties; connect lattice/particle models to observed properties | — |
| **3.3 Solids, Liquids, and Gases** | crystalline; amorphous; solid; liquid; gas; molar volume; phase | particle spacing/motion explains relative volume and compressibility | interpret/produce particle models for phases and crystalline vs. amorphous solids | Phase diagrams are not assessed |
| **3.4 Ideal Gas Law** | ideal gas; pressure; volume; absolute temperature; mole fraction; partial pressure | \(PV=nRT\); \(P_A=X_AP_{total}\); \(X_A=n_A/n_{total}\); \(P_{total}=\sum P_i\) | solve multivariable gas problems; interpret macroscopic/particulate gas changes | — |
| **3.5 Kinetic Molecular Theory** | kinetic molecular theory; elastic collision; average kinetic energy; Maxwell-Boltzmann distribution | \(KE=\tfrac12mv^2\); average KE ∝ kelvin temperature | interpret/compare Maxwell-Boltzmann curves; connect speed, mass, and temperature | — |
| **3.6 Deviation from Ideal Gas Law** | real gas; interparticle attraction; finite particle volume; condensation | attraction lowers measured pressure; particle volume matters at high pressure | interpret \(PV/nRT\) or pressure/volume deviations and explain them with particle models | — |
| **3.7 Solutions and Mixtures** | solution; solute; solvent; homogeneous mixture; heterogeneous mixture; molarity | \(M=n_{solute}/V_{solution}\) | calculate concentration/dilution by conservation of solute; distinguish uniform and nonuniform samples | — |
| **3.8 Representations of Solutions** | concentration; solvation; dissociation; electrolyte; relative concentration | particle count/volume represents relative concentration and stoichiometric dissociation | interpret/produce particulate solution models with correct species ratios and water orientation | No colligative properties; no molality, mass-percent, or volume-percent calculations |
| **3.9 Separation of Solutions and Mixtures** | filtration; distillation; chromatography; stationary phase; mobile phase; retention; polarity | separation depends on relative attractions/volatility rather than a single universal formula | choose/explain separation methods; interpret chromatograms and infer relative interactions/polarity | — |
| **3.10 Solubility** | soluble; insoluble; miscible; immiscible; solute-solvent interaction | solubility is favored when new solute-solvent attractions appropriately offset disrupted interactions | predict/explain solubility from particle structure and IMF similarity | — |
| **3.11 Spectroscopy and the Electromagnetic Spectrum** | absorption; emission; electromagnetic spectrum; microwave; infrared; ultraviolet; visible; rotational/vibrational/electronic transition | frequency/energy region maps to transition type | interpret spectra qualitatively and connect wavelength region to molecular/electronic change | — |
| **3.12 Properties of Photons** | photon; wavelength; frequency; Planck's constant; speed of light; quantized energy | \(c=\lambda\nu\); \(E=h\nu\) | relate wavelength, frequency, photon energy, and absorption/emission transitions | — |
| **3.13 Beer-Lambert Law** | absorbance; transmittance; molar absorptivity; path length; calibration curve; \(\lambda_{max}\) | \(A=\varepsilon bc\); at fixed \(\lambda\) and \(b\), \(A\propto c\) | interpret/construct absorbance-vs.-concentration calibration graphs; determine unknown concentration | — |

## Unit 4 — Chemical Reactions

Unit 4 already has a completed production pilot. This scope row set remains broader than its 22 accepted reference entries; the accepted pilot is the evidence for what consolidation can look like after checking.

| Topic | Vocabulary / concepts | Quantitative relationships | Representations / work | CED boundary |
|---|---|---|---|---|
| **4.1 Introduction for Reactions** | physical change; chemical change; evidence of change; precipitate | composition distinguishes chemical from physical change; observations are evidence, not proof | classify changes from observations and particulate/symbolic evidence | — |
| **4.2 Net Ionic Equations** | molecular equation; complete ionic equation; net ionic equation; spectator ion; aqueous dissociation | balanced equations conserve atoms and charge | write and translate among molecular, complete-ionic, and net-ionic forms | — |
| **4.3 Representations of Reactions** | reactant; product; coefficient; particulate representation | coefficients specify reacting-particle and mole ratios | translate balanced equations to/from particle models while conserving each atom type | — |
| **4.4 Physical and Chemical Changes** | bond formation/breaking; intermolecular-interaction change; dissolution | chemical changes typically change bonding; physical changes typically change intermolecular organization | defend classification with molecular-level evidence; allow evidence-supported ambiguity for processes such as salt dissolution | — |
| **4.5 Stoichiometry** | stoichiometric coefficient; mole ratio; limiting reactant; excess reactant; theoretical yield | balanced-equation mole ratios; combine with molarity and \(PV=nRT\) | solve mass/mole/gas/solution stoichiometry; interpret before/after particle models | — |
| **4.6 Introduction to Titration** | titrant; analyte; equivalence point; endpoint; indicator | at equivalence, reacting amounts satisfy balanced-equation stoichiometry | interpret titration setup/data; distinguish endpoint observation from equivalence condition | — |
| **4.7 Types of Chemical Reactions** | acid-base; redox; combustion; precipitation; oxidation number; soluble/sparingly soluble | complete hydrocarbon combustion → \(CO_2+H_2O\); precipitation follows ion stoichiometry | classify reactions; predict precipitates/products using the limited required solubility knowledge | Reducing/oxidizing-agent terminology not assessed; no rote solubility rules beyond Na⁺, K⁺, NH₄⁺, NO₃⁻ salts |
| **4.8 Introduction to Acid-Base Reactions** | Brønsted-Lowry acid/base; proton donor/acceptor; conjugate acid-base pair; amphoteric water | relative conjugate strengths follow proton-transfer equilibrium | identify conjugate pairs and write proton-transfer equations | Lewis acid-base concepts are not assessed; emphasis is aqueous reactions |
| **4.9 Oxidation-Reduction Reactions** | oxidation; reduction; half-reaction; electron transfer; oxidation number | electrons lost = electrons gained; mass and charge conserved | assign oxidation numbers; construct/balance redox equations from half-reactions | — |

## Unit 5 — Kinetics

| Topic | Vocabulary / concepts | Quantitative relationships | Representations / work | CED boundary |
|---|---|---|---|---|
| **5.1 Reaction Rates** | reaction rate; concentration change; time interval; surface area; catalyst | stoichiometric coefficients fix relative disappearance/appearance rates | determine average/instantaneous rate from tables or concentration-time graphs | — |
| **5.2 Introduction to Rate Law** | rate law; rate constant; reaction order; overall order; method of initial rates | \(rate=k[A]^m[B]^n\); orders from initial-rate ratios; units of \(k\) depend on overall order | infer rate law/order from experimental tables; predict effects of concentration/temperature | — |
| **5.3 Concentration Changes over Time** | integrated rate law; half-life; zero/first/second order; radioactive decay | \([A]_t-[A]_0=-kt\); \(\ln[A]_t-\ln[A]_0=-kt\); \(1/[A]_t-1/[A]_0=kt\); first-order \(t_{1/2}=0.693/k\) | identify order from which plot is linear; use slope/intercept and concentration-time curves | — |
| **5.4 Elementary Reactions** | elementary reaction; molecularity; unimolecular; bimolecular | elementary-step exponents follow reactant stoichiometry; three-body collisions are rare | write a rate law for an elementary step and judge mechanistic plausibility | — |
| **5.5 Collision Model** | collision model; activation energy; effective collision; orientation; Maxwell-Boltzmann distribution | rate depends on collision frequency and fraction with sufficient energy/correct orientation | compare energy distributions and shaded fractions above \(E_a\); explain temperature effects | — |
| **5.6 Reaction Energy Profile** | reaction coordinate; transition state; activation energy; exothermic/endothermic | \(E_a\) is transition-state minus reactant energy; Arrhenius relation used qualitatively | interpret/draw single-step energy profiles and label reactants, products, transition state, \(E_a\), \(\Delta H\) | Arrhenius-equation calculations are not assessed |
| **5.7 Introduction to Reaction Mechanisms** | mechanism; elementary step; intermediate; catalyst; overall reaction | elementary steps sum algebraically to the overall equation | sum/cancel species in mechanisms; identify intermediates and catalysts from steps | Collecting data to detect an intermediate is not assessed |
| **5.8 Reaction Mechanism and Rate Law** | rate-determining step; slow step; mechanism consistency | for applicable irreversible/slow-first-step mechanisms, observed law follows the slow elementary step | test a proposed mechanism against overall equation and experimental rate law | Same intermediate-detection exclusion as 5.7 |
| **5.9 Pre-Equilibrium Approximation** | pre-equilibrium; fast equilibrium; slow step; intermediate substitution | derive an overall rate law by replacing an intermediate using the preceding equilibrium relation | follow symbolic mechanism-to-rate-law derivations | — |
| **5.10 Multistep Reaction Energy Profile** | multistep reaction; intermediate; transition state; rate-determining step | number of peaks = steps; valleys = intermediates; largest relevant barrier identifies slow step | interpret/draw multistep energy profiles and connect features to mechanism steps | — |
| **5.11 Catalysis** | catalyst; homogeneous/heterogeneous catalysis; enzyme catalysis; acid-base catalysis; alternate pathway | catalyst changes pathway/\(E_a\), not net thermodynamics; net catalyst amount is regenerated | compare catalyzed/uncatalyzed energy profiles; identify catalyst mechanistically from its consumption/regeneration | — |

## Unit 6 — Thermochemistry

| Topic | Vocabulary / concepts | Quantitative relationships | Representations / work | CED boundary |
|---|---|---|---|---|
| **6.1 Endothermic and Exothermic Processes** | system; surroundings; endothermic; exothermic; heat; work | \(q_{system}=-q_{surroundings}\) for isolated heat exchange; sign follows energy direction | infer energy flow from temperature/process evidence and particle interactions | — |
| **6.2 Energy Diagrams** | potential energy; enthalpy change; reactants; products | \(\Delta H=H_{products}-H_{reactants}\) | interpret/draw endothermic and exothermic energy diagrams | — |
| **6.3 Heat Transfer and Thermal Equilibrium** | thermal energy; temperature; heat transfer; thermal equilibrium; average kinetic energy | energy flows from higher to lower temperature until equal average KE | interpret particulate collision models and temperature-time behavior | — |
| **6.4 Heat Capacity and Calorimetry** | heat capacity; specific heat capacity; calorimeter; first law | \(q=mc\Delta T\); \(q_{lost}+q_{gained}=0\) | analyze calorimetry data/setups; select correct mass and sign; connect measured \(\Delta T\) to reaction energy | — |
| **6.5 Energy of Phase Changes** | enthalpy of fusion/vaporization/condensation/freezing; heating curve | \(q=n\Delta H_{phase}\) when data are supplied; reverse process changes sign; temperature is constant during a pure-substance phase change | interpret/construct heating curves and particle-energy changes across plateaus | — |
| **6.6 Introduction to Enthalpy of Reaction** | enthalpy; reaction enthalpy; constant pressure; bond breaking/forming | \(\Delta H_{rxn}=q_p\); sign indicates heat released/absorbed | connect reaction-coordinate/particle energy changes to calorimetric temperature change | Technical distinctions between enthalpy and internal energy are not assessed |
| **6.7 Bond Enthalpies** | bond enthalpy; average bond energy | \(\Delta H_{rxn}\approx\sum E_{bonds\ broken}-\sum E_{bonds\ formed}\) | inventory bonds broken/formed from structures and estimate \(\Delta H\) | — |
| **6.8 Enthalpy of Formation** | standard enthalpy of formation; standard state | \(\Delta H^\circ_{rxn}=\sum n\Delta H_f^\circ(products)-\sum n\Delta H_f^\circ(reactants)\) | use tabulated formation data with balanced-equation coefficients | — |
| **6.9 Hess's Law** | Hess's law; reaction reversal; reaction scaling | reverse → negate \(\Delta H\); scale → scale \(\Delta H\); add equations → add \(\Delta H\) | manipulate and sum thermochemical equations to reach a target equation | State-function terminology is not assessed |

## Unit 7 — Equilibrium

| Topic | Vocabulary / concepts | Quantitative relationships | Representations / work | CED boundary |
|---|---|---|---|---|
| **7.1 Introduction to Equilibrium** | reversible process; dynamic equilibrium; forward/reverse reaction | at equilibrium, forward rate = reverse rate; concentrations remain constant, not necessarily equal | interpret concentration-time or rate-time graphs and particulate models at equilibrium | — |
| **7.2 Direction of Reversible Reactions** | net forward; net reverse; equilibrium | direction follows comparison of forward and reverse rates | infer net change from rate information and evolving particle/concentration displays | — |
| **7.3 Reaction Quotient and Equilibrium Constant** | equilibrium constant; reaction quotient; \(K_c\); \(K_p\); homogeneous/heterogeneous equilibrium | \(K_c=[C]^c[D]^d/[A]^a[B]^b\); \(K_p=(P_C)^c(P_D)^d/(P_A)^a(P_B)^b\); \(Q\) has same form | construct \(K\)/\(Q\) expressions; omit pure solids/liquids; compare \(Q\) with \(K\) | No \(K_c\)-to-\(K_p\) conversion; no dissolved-species/gas-phase equilibrium calculations |
| **7.4 Calculating the Equilibrium Constant** | equilibrium concentration; equilibrium partial pressure | substitute equilibrium data into \(K_c\) or \(K_p\) with stoichiometric exponents | calculate \(K\) from tables, graphs, or particulate counts/pressures | — |
| **7.5 Magnitude of the Equilibrium Constant** | product-favored; reactant-favored; essentially complete | large \(K\) → products predominate; small \(K\) → reactants predominate | infer mixture composition from \(K\) magnitude and vice versa | — |
| **7.6 Properties of the Equilibrium Constant** | reverse reaction; reaction scaling; coupled reactions | reverse → \(1/K\); scale coefficients by \(c\) → \(K^c\); add reactions → multiply \(K\) values | manipulate reactions and corresponding \(K\)/\(Q\) expressions | — |
| **7.7 Calculating Equilibrium Concentrations** | initial/change/equilibrium (ICE); equilibrium shift | \(Q<K\) forward; \(Q>K\) reverse; \(Q=K\) equilibrium; solve mass-action relations | build/solve ICE tables or equivalent algebra; validate physically meaningful roots | — |
| **7.8 Representations of Equilibrium** | equilibrium composition; relative particle count | particle-count ratios map to the appropriate \(K\) expression | interpret/produce before/at-equilibrium particulate diagrams consistent with \(K\) | — |
| **7.9 Introduction to Le Châtelier's Principle** | stress; shift; concentration/pressure/volume/temperature disturbance; dilution | qualitative response counteracts imposed change; only temperature changes \(K\) | predict shifts and observable changes in pH, color, pressure, or concentration | — |
| **7.10 Reaction Quotient and Le Châtelier's Principle** | disturbed equilibrium; re-equilibration | concentration/pressure changes alter \(Q\); temperature alters \(K\); response drives \(Q\to K\) | use explicit \(Q\)-vs.-\(K\) reasoning to justify direction after a disturbance | — |
| **7.11 Introduction to Solubility Equilibria** | saturated solution; molar solubility; solubility-product constant \(K_{sp}\) | write \(K_{sp}\); relate molar solubility to ion concentrations by stoichiometry | construct dissolution equations/expressions and solve \(K_{sp}\)–solubility problems | — |
| **7.12 Common-Ion Effect** | common ion; selective precipitation; reduced solubility | common-ion concentration enters \(K_{sp}\), lowering additional dissolution; compare \(Q_{sp}\) and \(K_{sp}\) | use ICE/particle reasoning to predict or calculate solubility changes | — |

## Unit 8 — Acids and Bases

| Topic | Vocabulary / concepts | Quantitative relationships | Representations / work | CED boundary |
|---|---|---|---|---|
| **8.1 Introduction to Acids and Bases** | acid; base; hydronium; hydroxide; autoionization; neutral solution | \(pH=-\log[H_3O^+]\); \(pOH=-\log[OH^-]\); \(K_w=[H_3O^+][OH^-]\); at 25°C, \(pH+pOH=14\) | use molecular/ionic and logarithmic representations; distinguish neutrality from pH 7 at non-25°C | \(H_3O^+\) preferred, but \(H^+\) accepted; \(K_w\) is temperature-dependent |
| **8.2 pH and pOH of Strong Acids and Bases** | strong acid; strong base; complete ionization/dissociation | strong-acid \([H_3O^+]\) and hydroxide stoichiometry; Group II hydroxides yield two \(OH^-\) per formula unit | calculate pH/pOH from formula and concentration; represent complete dissociation | — |
| **8.3 Weak Acid and Base Equilibria** | weak acid/base; conjugate pair; acid/base ionization constant; percent ionization | \(K_a=[H_3O^+][A^-]/[HA]\); \(K_b=[OH^-][HB^+]/[B]\); \(pK=-\log K\); \(K_aK_b=K_w\); \(pK_a+pK_b=pK_w\) | write equilibrium expressions; use ICE tables; connect strength, ionization, and equilibrium composition | — |
| **8.4 Acid-Base Reactions and Buffers** | neutralization; buffer; excess reagent; hydrolysis | strong/strong stoichiometry; weak/strong mixture case split: buffer, excess strong species, or equivalence hydrolysis | identify major species after reaction and select the correct pH model | — |
| **8.5 Acid-Base Titrations** | titration curve; equivalence point; half-equivalence point; monoprotic/polyprotic acid | at monoprotic equivalence, moles titrant = moles analyte; at weak-system half-equivalence, \(pH=pK_a\) | interpret/construct pH-vs.-volume curves; identify regions, equivalence, half-equivalence, and major species | No full species-concentration calculations across polyprotic curves; qualitative species reasoning remains in scope |
| **8.6 Molecular Structure of Acids and Bases** | conjugate-base stability; inductive effect; resonance stabilization; carboxylic acid; nitrogenous base | greater conjugate-base stabilization → stronger acid/larger \(K_a\) | compare structures and justify relative acid/base strength using electronegativity, induction, and resonance | — |
| **8.7 pH and pKa** | protonated/deprotonated form; acid-base indicator; transition range | \(pH<pK_a\): acid form dominates; \(pH>pK_a\): base form dominates | interpret indicator/color or speciation displays; choose an indicator with suitable \(pK_a\) | — |
| **8.8 Properties of Buffers** | buffer; conjugate acid; conjugate base; pH resistance | added base consumes conjugate acid; added acid consumes conjugate base | use equations/particle models to explain how a buffer responds to additions | — |
| **8.9 Henderson-Hasselbalch Equation** | buffer ratio; Henderson-Hasselbalch equation | \(pH=pK_a+\log([A^-]/[HA])\) | solve for pH, \(pK_a\), or component ratio and interpret changes qualitatively | No derivation; no calculation of the pH change caused by adding acid/base to a buffer |
| **8.10 Buffer Capacity** | buffer capacity; optimal buffer range | fixed ratio sets pH; larger component concentrations increase capacity; unequal components give asymmetric capacity | compare buffers and predict which resists a specified acid/base addition better | — |
| **8.11 pH and Solubility** | acid-dependent solubility; basic anion; hydroxide salt | consuming a constituent ion shifts dissolution; use Le Châtelier qualitatively | predict solubility changes with pH using coupled acid-base/solubility reasoning | Solubility-as-a-function-of-pH calculations are not assessed |

## Unit 9 — Thermodynamics and Electrochemistry

| Topic | Vocabulary / concepts | Quantitative relationships | Representations / work | CED boundary |
|---|---|---|---|---|
| **9.1 Introduction to Entropy** | entropy; dispersal of matter/energy; microstate | entropy generally increases with phase dispersal, gas volume, gas-particle count, and temperature | justify entropy changes with specific particle-level matter/energy distributions | Avoid unsupported “disorder” slogans; use particle-level reasoning |
| **9.2 Absolute Entropy and Entropy Change** | standard molar entropy; standard entropy change | \(\Delta S^\circ_{rxn}=\sum nS^\circ(products)-\sum nS^\circ(reactants)\) | use tabulated entropy data and balanced coefficients | — |
| **9.3 Gibbs Free Energy and Thermodynamic Favorability** | Gibbs free energy; standard state; thermodynamically favored/unfavored | \(\Delta G^\circ_{rxn}=\sum n\Delta G_f^\circ(products)-\sum n\Delta G_f^\circ(reactants)\); \(\Delta G^\circ=\Delta H^\circ-T\Delta S^\circ\) | interpret \(\Delta H/\Delta S\) sign cases and temperature dependence; use data tables | CED prefers “thermodynamically favored” over “spontaneous” |
| **9.4 Thermodynamic and Kinetic Control** | thermodynamic control; kinetic control; activation barrier; equilibrium | favorability does not determine rate; high \(E_a\) can make a favored process immeasurably slow | compare free-energy/favorability evidence with reaction-energy/rate evidence | — |
| **9.5 Free Energy and Equilibrium** | equilibrium favorability; standard free energy; equilibrium constant | \(\Delta G^\circ=-RT\ln K\); \(K=e^{-\Delta G^\circ/RT}\); sign/magnitude of \(\Delta G^\circ\) maps to \(K\) vs. 1 | move among \(\Delta G^\circ\), \(K\), and equilibrium-composition representations | — |
| **9.6 Free Energy of Dissolution** | lattice disruption; solvent reorganization; solvation; enthalpy-entropy compensation | \(\Delta G^\circ=\Delta H^\circ-T\Delta S^\circ\) applied to the component processes | represent/explain the three dissolution contributions and why net sign can be difficult to predict | — |
| **9.7 Coupled Reactions** | coupled reaction; shared intermediate; external energy source; ATP/ADP example | \(\Delta G^\circ_{net}=\sum\Delta G_i^\circ\); coupling is favorable when the sum is negative | add reactions, cancel shared intermediates, and evaluate net favorability | — |
| **9.8 Galvanic and Electrolytic Cells** | galvanic/voltaic cell; electrolytic cell; anode; cathode; oxidation; reduction; half-cell; salt bridge; external circuit | electron flow accompanies oxidation at anode and reduction at cathode in both cell types | label/interpret/produce cell diagrams at macroscopic and particulate levels; track electron and ion motion | Positive/negative electrode labels are not assessed |
| **9.9 Cell Potential and Free Energy** | standard reduction potential; standard cell potential; Faraday constant | \(E^\circ_{cell}=E^\circ_{cathode}-E^\circ_{anode}\); \(\Delta G^\circ=-nFE^\circ\) | combine half-reactions/potentials; connect voltage sign to favorability and electron flow | — |
| **9.10 Cell Potential under Nonstandard Conditions** | nonstandard potential; reaction quotient; equilibrium potential | qualitatively, \(E=E^\circ-(RT/nF)\ln Q\); \(E=0\) when \(Q=K\) | predict how concentration changes affect cell potential using reaction direction and qualitative Nernst reasoning | Bare algorithmic Nernst calculations are insufficient; Le Châtelier is not the stated model for operating cells |
| **9.11 Electrolysis and Faraday's Law** | electrolysis; electroplating; current; charge; Faraday's law | \(I=q/t\); charge ↔ moles electrons ↔ stoichiometric amount/mass deposited or consumed | interpret electrolytic-cell setups and solve current–time–mass/electron-transfer problems | — |

## Completeness and next transformation

- **Taxonomy coverage:** 91 of 91 current topics are present: 8 + 7 + 13 + 9 + 11 + 9 + 12 + 11 + 11.
- **Scope coverage:** each topic has an explicit vocabulary/concept pass and a representation/work pass; quantitative relationships are listed where the CED supplies or requires one.
- **Known exclusions:** the topic-specific exclusions captured in the fact pack are attached to the relevant rows rather than placed in one undifferentiated list.
- **Not yet done:** exact card boundaries, polished definitions, equation-sheet availability metadata, interpret-vs.-produce metadata, exact EK citations per final entry, diagram specifications, cross-topic ownership/reuse, checker verdicts, and publication.
- **Existing checked subset:** the Unit 4 production pilot contains 22 accepted student-facing reference entries. It should be reused as the starting point for Unit 4 rather than regenerated from this shorthand.

The next safe transformation is **one unit at a time**: consolidate the row-level scope into candidate entries, attach exact CED evidence and ownership, then send every student-facing academic claim through the configured checker workflow before loading it.
