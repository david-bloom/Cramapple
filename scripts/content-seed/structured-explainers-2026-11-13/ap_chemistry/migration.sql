-- Structured explainer pieces (recommendation #3), batch 2026-11-13. Guarded on each row still holding the text it was built on.
begin;
update app.topic_explainers set
  core_idea = $q$- You cannot count atoms directly, so n = m/M bridges a measurable mass to moles.
- Avogadro's number (6.022x10^23/mol) bridges moles to particle count.
- A substance's molar mass in grams numerically equals one particle's average mass in amu.$q$,
  what_students_need_to_understand = $q$- Stoichiometry, solution concentration and gas laws all start by converting between mass and moles.
- A wrong molar mass or a mole/particle mix-up propagates into every later calculation, not just this topic's.$q$,
  how_this_becomes_points = $q$1. Apply n = m/M (or a rearrangement) with the molar mass of the substance actually asked about.
2. Decide whether Avogadro's number is needed to reach a particle count.
3. Do not stop at moles when particles were requested.$q$,
  point_attaining_answer = $q$n = m/M = 3.42 g / 180.16 g/mol ~ 0.01898 mol.

Multiplying by Avogadro's number gives the particle count: 0.01898 mol x 6.022x10^23/mol ~ 1.14x10^22 glucose molecules.

Molar mass, not Avogadro's number, converts mass to moles; Avogadro's number only converts moles to particle count.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 1-5 except 1.5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_chemistry/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=1 and topic_code='1.1' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='10af973e0150995b9832e4ef581ac35a';
update app.topic_explainers set
  core_idea = $q$- A single-element mass spectrum has one peak per isotope: position is the isotope's mass, size is its natural relative abundance.
- Average atomic mass is the isotope-weighted average of those peaks.
- Excluded from the AP Exam: spectra of multiple elements, or peaks from anything other than singly charged monatomic ions.$q$,
  what_students_need_to_understand = $q$- This is how average atomic mass is actually measured, not memorized.
- Isotopes of one element share a proton count and differ only in neutron count.
- The 2025 FRQ isotope-mass-difference point scored a mean of just 0.55/1.0, mostly from attributing the difference to electrons or protons instead of neutrons.$q$,
  how_this_becomes_points = $q$1. Read each peak's mass and relative abundance.
2. Multiply mass by fractional abundance and sum across every peak.
3. To explain a mass difference, name neutron count: proton count (and electron count in a neutral atom) is fixed.$q$,
  point_attaining_answer = $q$| Isotope | Mass (amu) | Abundance | Product |
| Mg-24 | 23.985 | 0.7899 | 18.945 |
| Mg-25 | 24.986 | 0.1000 | 2.499 |
| Mg-26 | 25.983 | 0.1101 | 2.861 |

Sum ~ 24.31 amu, matching magnesium's periodic-table mass of 24.305.

Mg-24 and Mg-25 both have 12 protons (defining the element) and 12 electrons (neutral atom); the one-amu difference comes from Mg-25's one additional neutron.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 1-5 except 1.5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_chemistry/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=1 and topic_code='1.2' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='8ea99613069521912fa51100bf22ef6d';
update app.topic_explainers set
  core_idea = $q$- Law of definite proportions: the mass ratio of elements in any pure sample of a compound is fixed.
- The empirical formula is the lowest whole-number atom ratio matching that mass ratio.
- A molecular formula is an integer multiple of it: actual molar mass divided by the empirical formula's mass.$q$,
  what_students_need_to_understand = $q$- Experimental mass data, like combustion analysis (masses of CO2 and H2O from burning a sample), leads to a compound's formula.
- It works only because every sample of a pure compound gives the same element ratio, however much you burn.$q$,
  how_this_becomes_points = $q$1. Convert given masses or mass percentages to moles of each element.
2. Divide every mole value by the smallest to get a whole-number ratio (the empirical formula).
3. Divide the molecular molar mass by the empirical formula's mass to find the scaling factor.$q$,
  point_attaining_answer = $q$The mole ratio C:H:O = 3.33:6.66:3.33 reduces to 1:2:1, giving empirical formula CH2O with empirical mass 12.01+2(1.008)+16.00 ~ 30.03 g/mol.

The actual molar mass (180 g/mol) is about 180.16/30.03 ~ 6 times the empirical mass, so the molecular formula is (CH2O)x6 = C6H12O6, not CH2O.

The empirical formula alone under-answers a molecular-formula question.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 1-5 except 1.5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_chemistry/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=1 and topic_code='1.3' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='b31e9a15e2f8ed47ade5a4715f43bf8f';
update app.topic_explainers set
  core_idea = $q$- A pure substance has one particle type in a fixed proportion; a mixture has two or more whose proportions can vary sample to sample.
- A homogeneous mixture can look as uniform as a compound, so appearance never substitutes for checking whether the composition ratio stays constant across independent samples.$q$,
  what_students_need_to_understand = $q$- Fixed versus variable ratio is what makes empirical-formula reasoning (Topic 1.3) valid at all.
- The same evidence, a constant or inconstant elemental composition ratio, is what Unit 3's mixture-separation topics build on.$q$,
  how_this_becomes_points = $q$1. Use elemental analysis data from two or more samples to test whether a component's mass ratio holds constant.
2. State a purity conclusion that follows from that comparison.
3. Do not rely on appearance, texture, or one sample's data.$q$,
  point_attaining_answer = $q$| Sample | % H | % O |
| Water (H2O), fixed ratio | 11.19 | 88.81 |
| Sample A | 11.2 | 88.8 |
| Sample B | 9.5 | 90.5 |

Sample A matches that ratio, but Sample B does not: a pure substance's composition ratio cannot vary between samples.

Because the ratio changed between bottles, at least one sample is not the pure substance claimed; appearance (both being clear liquids) provides no evidence either way.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 1-5 except 1.5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_chemistry/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=1 and topic_code='1.4' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='744224e40915ea9ac394c3b8db9a2a59';
update app.topic_explainers set
  core_idea = $q$- Each PES peak's position is the energy needed to remove an electron from a specific subshell; its height is roughly proportional to that subshell's electron count.
- Photon energy follows E = hv and equals the electron's binding energy plus its ejected kinetic energy.$q$,
  what_students_need_to_understand = $q$- PES reads the Topic 1.5 configuration rules directly off real data.
- Core electrons, closer to the nucleus and less shielded, always need more energy to remove than valence electrons, whichever subshell Aufbau filled last.$q$,
  how_this_becomes_points = $q$1. Match peak positions and relative heights to an element's electron configuration.
2. Explain binding-energy differences by distance from the nucleus and shielding.
3. Do not explain them by the order subshells were filled.$q$,
  point_attaining_answer = $q$| Peak height | Subshell |
| 2 | 1s |
| 2 | 2s |
| 6 | 2p |
| 2 | 3s |

Heights 2:2:6:2 are electron counts: 2+2+6+2 = 12 total electrons, 1s2 2s2 2p6 3s2, so magnesium (Z=12).

The highest-binding-energy peak (height 2) is 1s because 1s electrons sit closest to the nucleus and are least shielded, not because 1s was filled first or last. Binding-energy order and Aufbau filling order are different orderings.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 1-5 except 1.5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_chemistry/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=1 and topic_code='1.6' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='4924f581bd01d4bd1e0890b6c2436d81';
update app.topic_explainers set
  core_idea = $q$- Periodic position reflects recurring electron-configuration patterns; ionization energy, radius, electron affinity and electronegativity trends follow from Coulomb's law, shielding and effective nuclear charge.
- Excluded from the AP Exam: aufbau-exception configurations (chromium, copper); the standard filling order applies wherever trends are tested.$q$,
  what_students_need_to_understand = $q$- Trends let you predict or estimate a property for an unfamiliar element from its position alone.
- This reasoning is tested throughout the exam: the same Coulomb's-law logic reappears whenever a later unit compares or estimates a property.$q$,
  how_this_becomes_points = $q$1. Explain the trend with effective nuclear charge and distance from the nucleus or shielding.
2. Never just name the trend's direction.
3. Use that reasoning to make a specific comparison or estimate when exact data isn't given.$q$,
  point_attaining_answer = $q$Cl and S are in the same period, so their valence electrons sit at a similar distance from the nucleus with similar shielding from the same core configuration.

Chlorine has one more proton (Z=17 vs. 16), so greater effective nuclear charge. By Coulomb's law, a larger nuclear charge over a similar radius gives a stronger attraction on the valence electrons, so removing one from chlorine requires more energy.

The direction of the trend follows from this charge difference, not from the trend's name.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 1-5 except 1.5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_chemistry/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=1 and topic_code='1.7' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='1314e51df01b8d09d072fe0c142e6546';
update app.topic_explainers set
  core_idea = $q$- Bonding depends on how valence electrons interact with the nucleus; same-column elements form analogous compounds.
- Typical ionic charge follows from valence electron count and position, and total charge must balance to zero.
- NaCl predicts KCl (same column as Na), but not CaCl: Ca loses two electrons for 2+, so CaCl2 balances and CaCl does not.$q$,
  what_students_need_to_understand = $q$- This sets up bonding and compound formation for Unit 2.
- From periodic position and the zero-total-charge requirement alone, you can predict a formula or analogous compound for an element you haven't seen.$q$,
  how_this_becomes_points = $q$1. Derive an ion's typical charge from its group number or valence-electron count.
2. Build a formula whose total positive and negative charge sums to zero.
3. Use same-column analogies, but never assume elements from different groups share a charge.$q$,
  point_attaining_answer = $q$| Element | Group | Reaches noble-gas configuration by | Typical charge |
| Ca | 2 | losing 2 valence electrons | 2+ |
| Cl | 17 | gaining 1 electron | 1- |

Balancing total charge to zero requires two Cl- ions for every Ca2+ ion, giving CaCl2.

The same-column analogy to NaCl breaks down because calcium's group, and therefore its charge, is different from sodium's.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 1-5 except 1.5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_chemistry/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=1 and topic_code='1.8' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='7ac9f929a05793f1daf4f92b55d2c736';
update app.topic_explainers set
  core_idea = $q$- Electrons are shared unequally, with greater inequality generally accompanying a larger electronegativity difference: bonding is one continuous scale from nonpolar to ionic.
- No cutoff separates the types; every polar bond has some ionic character.
- C-H, with a small real difference, is treated as effectively nonpolar.$q$,
  what_students_need_to_understand = $q$- Metal/nonmetal is only a shortcut: use observed properties when they are given.
- Electronegativity predicts bond polarity, but molecular polarity (2.7) also needs geometry.
- For ionic attractions (2.2, 2.3) use the ions' actual charges and separation; metals differ because valence electrons are delocalized (2.4).$q$,
  how_this_becomes_points = $q$1. Name the bond type.
2. Support it with an explicit electronegativity comparison: which atom pulls harder, which carries delta-negative.
3. Confirm with a property: conductivity when molten or dissolved, melting point, or brittleness versus malleability.$q$,
  point_attaining_answer = $q$| Bond | Electronegativities | Difference | Type |
| C-H | 2.55, 2.20 | about 0.35 | effectively nonpolar covalent |
| O-H | 3.44, 2.20 | about 1.24 | polar covalent, delta-negative on O |
| Na-Cl | 0.93, 3.16 | about 2.23 | ionic |

Na-Cl has the largest gap of the three, so it is classified ionic. Because ionic and covalent form a continuum rather than two boxes, even this bond retains some covalent character.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 1-5 except 1.5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_chemistry/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=2 and topic_code='2.1' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='7af49a1d976fa9fa32aaea48aeced776';
update app.topic_explainers set
  core_idea = $q$- On a potential energy vs internuclear distance graph, the minimum marks the equilibrium bond length; the well depth below the separated-atom baseline (zero) is the bond energy.
- Higher bond order gives a shorter bond and a larger bond energy together.
- For ion pairs, Coulomb's law ties strength to charge size and distance.$q$,
  what_students_need_to_understand = $q$- This turns a bonding label into numbers you can rank and defend.
- It returns in lattice-energy comparisons, bond-length and bond-energy rankings in 2.7, and later bond-energy arguments in thermodynamics.
- It is one of the few Unit 2 ideas tested as graph reading.$q$,
  how_this_becomes_points = $q$1. Read bond length from the minimum's x-value and bond energy from the well depth.
2. Rank length and energy together by bond order (shorter goes with larger energy).
3. For ions, cite both charge magnitude and internuclear distance, never one alone.$q$,
  point_attaining_answer = $q$| Bond | Length (pm) | Energy (kJ/mol) |
| C-C single | 154 | 347 |
| C=C double | 134 | 614 |
| C-C triple | 120 | 839 |

Each additional bond adds more shared electron density directly between the two nuclei, pulling them closer and deepening the well.

On the PE curve, higher bond order shifts the minimum to a shorter distance and makes it lower (more negative relative to the separated-atom baseline). Shorter length and larger energy rise together as one consequence of bond order, not two independent facts.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 1-5 except 1.5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_chemistry/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=2 and topic_code='2.2' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='91610ba9bfb0e82948c071e327f0b21d';
update app.topic_explainers set
  core_idea = $q$- Cations and anions form one extended, repeating three-dimensional array that maximizes attraction and minimizes repulsion across the whole lattice.
- Properties follow from that alternating array, not from named crystal types, which the exam does not assess.$q$,
  what_students_need_to_understand = $q$- Hardness, brittleness, high melting point, and conduction only when molten or dissolved all trace back to this one picture.
- It links the Coulomb's-law reasoning of 2.2 to bulk properties in Unit 3, though its own exam weight is narrower than Lewis diagrams and VSEPR.$q$,
  how_this_becomes_points = $q$1. State that the solid is one extended, repeating array of alternating charges.
2. Link a named property to it. High melting point: many strong attractions throughout need a lot of energy to overcome. Brittleness: a shifted layer lines up like charges and repulsion cracks the crystal.$q$,
  point_attaining_answer = $q$Student B's explanation earns the point.

The AP Exam explicitly excludes knowledge of specific crystal structures: naming 'rock-salt' or 'face-centered cubic' is neither required nor sufficient.

Student B's reasoning is what the exam rewards: displacing one layer brings like-charged ions into alignment, the resulting Coulombic repulsion overcomes the lattice's attractive forces along that plane, and the crystal fractures rather than deforming the way a metal would.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 1-5 except 1.5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_chemistry/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=2 and topic_code='2.3' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='fa90a3b9334b635c959560b77247fe01';
update app.topic_explainers set
  core_idea = $q$- A metal is a lattice of positive ions in a delocalized sea of valence electrons.
- Interstitial alloys (steel, small C atoms in iron's gaps) block sliding: harder and less malleable, yet still conducting.
- Substitutional alloys swap in atoms of similar size.$q$,
  what_students_need_to_understand = $q$- Delocalization from 2.1 now explains observable behavior: conductivity, malleability, luster.
- Atomic radius from Unit 1 tells the two alloy types apart; the size argument is a clean, frequently testable call.$q$,
  how_this_becomes_points = $q$1. Cite mobile delocalized electrons for conductivity.
2. Explain malleability: layers slide while the electron sea holds them together.
3. Classify an alloy by comparing the two atoms' radii: very different is interstitial, comparable is substitutional.$q$,
  point_attaining_answer = $q$| Alloy | Radius comparison | Type | Second atom |
| Steel | carbon much smaller than iron | interstitial | in gaps between iron atoms |
| Brass | zinc comparable to copper | substitutional | replaces copper at lattice positions |

The types differ because classification rests on the radius comparison, not on both being metal mixtures.

Steel still conducts, since interstitial atoms block layer sliding but mobile delocalized electrons remain, although alloying can change its electrical resistance.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 1-5 except 1.5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_chemistry/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=2 and topic_code='2.4' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='a12b88b46de0ed574776d9e0e0acb43a';
update app.topic_explainers set
  core_idea = $q$- A Lewis diagram is valence-electron bookkeeping done by a fixed procedure.
- Total the valence electrons: add one per unit of negative charge, subtract one per unit of positive.
- Place bonds and lone pairs to satisfy octets, converting a lone pair into an extra bond when a central atom is short.$q$,
  what_students_need_to_understand = $q$- The usual failure is the count, not the drawing: a missed ion charge or an undrawn lone pair changes the total.
- Every answer built on the diagram (resonance, formal charge, shape) inherits the error, so check the count against your picture first.$q$,
  how_this_becomes_points = $q$1. The electron total matches the formula (charge-adjusted for ions).
2. Every bonding pair and lone pair is drawn, and octets are met where required.
3. An ion is bracketed with its charge outside.$q$,
  point_attaining_answer = $q$| Source | Electrons |
| Carbon | 4 |
| Three oxygens, 6 each | 18 |
| 2- charge | 2 |
| Total | 24 |

With carbon central, one C=O and two C-O bonds use 8 electrons, leaving 16 as lone pairs: the double-bonded oxygen has 2 pairs and each single-bonded oxygen has 3. Every atom has an octet.

Enclose the diagram in brackets with 2- outside.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 1-5 except 1.5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_chemistry/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=2 and topic_code='2.5' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='4288a2dbbc99171cb1a1e04a4922bc32';
update app.topic_explainers set
  core_idea = $q$- Formal charge = valence electrons minus lone-pair electrons minus half the bonding electrons.
- With octet requirements, it selects among nonequivalent Lewis structures; equivalent structures are averaged as resonance.
- The Lewis model cannot cleanly represent odd-electron species.$q$,
  what_students_need_to_understand = $q$- Resonance forms are alternative drawings, not successive states: never say a double bond moves back and forth.
- That is why both N-O bonds in nitrite are identical.
- Formal charge picks which of several legal diagrams to reason from.$q$,
  how_this_becomes_points = $q$1. Equivalent: draw all forms, reject switching, and state the real structure is one average (nitrite's N-O bond order is (1 + 2)/2 = 1.5, so both bonds are equal).
2. Nonequivalent: check octets, then compute formal charge.
3. Minimize formal charge, with negative on the more electronegative atom.$q$,
  point_attaining_answer = $q$The two resonance structures are equivalent, so the real ion is a single averaged structure, not one that switches between two forms. Each N-O bond has an intermediate bond order of 1.5 (halfway between a single and a double bond).

| N-O bond | Length (pm) |
| Typical N=O double | ~115 |
| Nitrite, both bonds | about 124 |
| Typical N-O single | ~140 |

Both nitrite bonds measure the same length, confirming the averaged picture rather than two different bond lengths.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 1-5 except 1.5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_chemistry/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=2 and topic_code='2.6' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='eca8dfd9f9b64e1c0f04f05a18f75eea';
update app.topic_explainers set
  core_idea = $q$- VSEPR counts regions of electron density (each lone pair or bond, however many lines, is one) to predict geometry, ideal angles and hybridization.
- Ideal angles: sp 180, sp2 120, sp3 109.5 degrees; actual bond angles can differ.
- Off the exam: deriving hybrid orbitals, d-orbital hybridization (over four regions: shape only), molecular orbital theory.$q$,
  what_students_need_to_understand = $q$- Geometry is the payoff of the unit and the gateway to Unit 3: polarity, solubility and boiling point depend on shape plus bond dipoles.
- Hybridization identification scored a mean of only 0.56 of 1.0 on the 2025 free-response item, mainly from counting C=O as two regions.$q$,
  how_this_becomes_points = $q$1. Count regions (a lone pair is one, a double or triple bond is one), name the geometry from atom positions only, and give the matching angle.
2. Assign sp, sp2 or sp3 from the same count only if asked.
3. For polarity, combine bond dipoles with the geometry to test whether they cancel.$q$,
  point_attaining_answer = $q$Carbon has three regions: two C-H bonds and one C=O double bond, which counts as one.

Three regions means trigonal planar geometry, about 120 degrees, and sp2 hybridization, not sp3.

The costly error on the 2025 free-response item (mean 0.56 of 1.0) was counting C=O as two domains, giving four domains and sp3.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 1-5 except 1.5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_chemistry/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=2 and topic_code='2.7' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='5e9faa959f9bd66e781dff3addf38ef1';
update app.topic_explainers set
  core_idea = $q$- Roughly weakest to strongest: London dispersion (every particle, fluctuating dipoles), dipole-dipole (polar), ion-dipole (ions with polar molecules), hydrogen bonding (H on N/O/F with a nearby N/O/F).
- London forces are often the strongest net IMF for very large molecules.
- CED: "London dispersion forces" is not synonymous with "van der Waals forces".$q$,
  what_students_need_to_understand = $q$- This ranking is the mechanism behind solid classification (3.2) and solubility/miscibility prediction (3.10).
- It is where the lowest-scoring point on the 2025 exam (mean 0.11/1.0) arose: students read "r" in Coulomb's law as an ion's own radius, not the separation between the ion and a nearby dipole.$q$,
  how_this_becomes_points = $q$1. Name the strongest relevant force present.
2. Justify it from structural evidence: polarity from electronegativity or geometry, size/polarizability, ionic charge, or an actual N-O-F-to-H arrangement.
3. Avoid a generic "intermolecular forces" label.$q$,
  point_attaining_answer = $q$| Molecule (molar mass) | Structural evidence | Strongest IMF |
| CH4 (16) | symmetric tetrahedral, effectively nonpolar C-H bonds | London dispersion only |
| CH3Cl (50) | polar C-Cl bond, asymmetric shape | dipole-dipole, plus London |
| CH3OH (32) | O-H bond | hydrogen bonding, plus dipole-dipole and London |

Boiling points rise in that order, even though methanol's molar mass (32) is lower than chloromethane's (50). Molar mass alone does not predict the order; the strongest IMF type present does.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 1-5 except 1.5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_chemistry/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=3 and topic_code='3.1' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='939576aef99484c5da767d866efdcb7d';
update app.topic_explainers set
  core_idea = $q$- Vapor pressure and boiling point track IMF strength directly (vaporization fully overcomes IMFs); melting point only loosely (melting just rearranges particles).
- Covalent network solids are usually rigid and high-melting; graphite is the exception: covalent within layers, but soft because weak London dispersion forces between layers let them slide.$q$,
  what_students_need_to_understand = $q$- This connects the IMF ranking from 3.1 to bulk solid behavior.
- The graphite exception tests whether structure-level reasoning is applied rather than a blanket "covalent network equals hard" rule.$q$,
  how_this_becomes_points = $q$1. Classify the solid type.
2. Explain a specific property (melting point, conductivity, brittleness, or malleability) from particle-level structure.
3. Do not rely on the class name alone.$q$,
  point_attaining_answer = $q$| Property | Diamond | Graphite |
| Structure | 3-D network, four covalent neighbors per carbon | layers, three covalent neighbors per carbon in a flat sheet |
| Between layers | none: rigid lattice | weak London dispersion forces |
| Hardness | extremely hard | soft |

No layer in diamond can move without breaking strong covalent bonds, while graphite's sheets slide despite strong bonds within a layer.

Calling both "covalent network" is correct but incomplete: the property depends on which bonds must break.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 1-5 except 1.5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_chemistry/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=3 and topic_code='3.2' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='9e40a29e55e93f6ffe445c5dc7f7a69e';
update app.topic_explainers set
  core_idea = $q$- Solids can be crystalline (regular, repeating 3-D arrangement) or amorphous (irregular, no long-range order); both count as solids by spacing and motion.
- Solid and liquid molar volumes are typically similar (close contact); the gas phase (far apart, independent particles) differs sharply.
- Not assessed: reading or interpreting phase diagrams.$q$,
  what_students_need_to_understand = $q$- This sets up the spacing/motion vocabulary reused in 3.2 and in 3.5's gas-particle-motion reasoning.
- Because of the phase-diagram exclusion, only structural description is testable here, not reading phase-diagram features.$q$,
  how_this_becomes_points = $q$1. Compare particle spacing, motion, and order with specific descriptive language for each phase.
2. Do not invoke phase-diagram features like triple points or critical points.$q$,
  point_attaining_answer = $q$| Phase | Molar volume (mL/mol) | Particles |
| Ice | about 19.6 | ordered lattice, close contact |
| Liquid water | about 18 | disordered, still close-packed |
| Water vapor | about 22,400 | far apart, independent, no fixed spacing or order |

Solid and liquid stay in the same narrow range (about 18-20 mL/mol) because hydrogen bonding and other IMFs keep molecules in close contact. The gas volume is roughly a thousand times larger because of spacing and motion, not a phase-diagram feature like a triple point.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 1-5 except 1.5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_chemistry/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=3 and topic_code='3.3' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='ab7c8d8b6137d66bee461ea612a4357d';
update app.topic_explainers set
  core_idea = $q$- PV = nRT is the core relationship; mixtures add partial pressure proportional to mole fraction (P_A = P_total x X_A, X_A = mol_A / mol_total) and Dalton's law (P_total = P_A + P_B + P_C + ...).
- R's units (0.08206 L*atm/(mol*K)) fix P in atm, V in L, T in Kelvin; Celsius or torr silently break the calculation.$q$,
  what_students_need_to_understand = $q$- This is the algebra and unit-consistency workhorse of Unit 3.
- It connects to 3.7's molarity (same solution-total-volume discipline) and 3.5's KMT (which explains why T must be absolute).$q$,
  how_this_becomes_points = $q$1. Choose the correct equation (PV=nRT versus Dalton's/mole-fraction).
2. Convert every unit into the set matching R.
3. Connect partial pressure to mole fraction explicitly rather than guessing a fraction.$q$,
  point_attaining_answer = $q$Total moles = 0.50 + 0.20 = 0.70 mol. T is already in Kelvin (300 K), R = 0.08206 L*atm/(mol*K): P_total = nRT/V = (0.70)(0.08206)(300)/10.0 = 1.72 atm.

| Gas | Moles | Mole fraction | Partial pressure |
| N2 | 0.50 | 0.714 | 0.714 x 1.72 = 1.23 atm |
| O2 | 0.20 | 0.286 | 0.286 x 1.72 = 0.49 atm |

Check: 1.23 + 0.49 = 1.72 atm, matching P_total by Dalton's law.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 1-5 except 1.5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_chemistry/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=3 and topic_code='3.4' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='6fd5b36dcc9fe16c3110191b194e9b3d';
update app.topic_explainers set
  core_idea = $q$- KE = 1/2 m v^2; Kelvin temperature is directly proportional to average kinetic energy of all particles, not average speed.
- At the same temperature, gases of different molar mass share average KE, so the lighter gas moves faster.
- The Maxwell-Boltzmann speed-vs-fraction-of-particles curve broadens and shifts to higher speeds as temperature rises.$q$,
  what_students_need_to_understand = $q$- Same average KE with different average speed is the single most commonly missed idea in this topic.
- It directly explains effusion/diffusion rate differences tested elsewhere.$q$,
  how_this_becomes_points = $q$1. Connect Kelvin temperature specifically to average kinetic energy, never average speed.
2. Use the mass-speed tradeoff to compare distributions of different gases at the same temperature.$q$,
  point_attaining_answer = $q$| | Helium | Xenon |
| Molar mass (g/mol) | 4.00 | 131.3 |
| Average KE at 300 K | same | same |
| Average speed | much faster | much slower |

Average KE depends only on temperature, not on identity or mass. Because KE = 1/2 m v^2, helium's much smaller mass means its particles must move much faster on average to reach that same KE.

On a Maxwell-Boltzmann distribution, helium's curve is shifted to substantially higher speeds and is broader than xenon's, though both are at 300 K.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 1-5 except 1.5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_chemistry/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=3 and topic_code='3.5' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='63a8125feeb70533c0799f338ab17764';
update app.topic_explainers set
  core_idea = $q$- Real gases deviate from ideal for two distinct reasons under different conditions.
- Low temperature (near condensation): attractions pull slow particles together, so pressure measures lower than the ideal law predicts.
- Very high pressure: particle volume becomes a significant fraction of the container, leaving less free space than the ideal law assumes.$q$,
  what_students_need_to_understand = $q$- This follows from 3.1's IMF strength and 3.5's particle motion/KMT.
- Name which mechanism (attraction or particle volume) applies under which condition, not one vague "high pressure, low temperature" trigger.
- Both effects mean deviation is largest, not smallest, at low temperature and high pressure.$q$,
  how_this_becomes_points = $q$1. Identify which mechanism (attraction versus particle volume) applies to the given condition.
2. State that these conditions cause the largest deviation from ideal, not the smallest.$q$,
  point_attaining_answer = $q$These are the conditions where real gases deviate most from ideal, not least.

| Condition | Mechanism | Effect |
| Low temperature, near condensation | attractions between slow particles reduce wall-collision force | measured pressure lower than PV=nRT predicts |
| Very high pressure | particles' own finite volume (assumed negligible) is a real fraction of the total | less free space than the ideal model assumes |

One mechanism comes from attraction, one from particle volume; both make a gas behave less ideally.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 1-5 except 1.5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_chemistry/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=3 and topic_code='3.6' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='079fcd7b68e460e19bdbfaf11ec3de0c';
update app.topic_explainers set
  core_idea = $q$- A solution is homogeneous: concentration, color and density are uniform wherever you sample; a heterogeneous mixture varies by location.
- Solutions need not be liquids: solid solutions (some alloys) and gas solutions (air) qualify if homogeneous.
- Molarity is moles of solute per liter of final solution (M = n_solute / L_solution), not of solvent added.$q$,
  what_students_need_to_understand = $q$- Molarity's solution-volume (not solvent-volume) discipline parallels the unit-consistency care of 3.4's gas law.
- Homogeneous/heterogeneous classification underlies 3.9's separation-method reasoning.$q$,
  how_this_becomes_points = $q$1. Classify a mixture as homogeneous or heterogeneous, with justification.
2. Compute molarity using the total solution volume.
3. Do not use the volume of solvent added.$q$,
  point_attaining_answer = $q$Correctly made solution: M = n_solute / L_solution = 0.250 mol / 0.500 L = 0.500 M.

If the colleague measured 500. mL of water and then dissolved NaCl in it, the final volume would be slightly more than 500 mL (the dissolving solid adds volume), so the true molarity is slightly lower than 0.500 M.

Always use the volume of the final solution after mixing, not the solvent volume measured beforehand; treating them as interchangeable introduces a real, if small, error.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 1-5 except 1.5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_chemistry/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=3 and topic_code='3.7' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='28555a322e1974b205d4d4c597287b03';
update app.topic_explainers set
  core_idea = $q$- Particulate diagrams show relative numbers and spacing of solute and solvent particles; compare relative concentration or interaction type between two solutions only if the boxes represent equal volumes.
- Off the AP Exam: colligative properties (freezing-point depression, boiling-point elevation, etc.) and molality or percent-by-mass/volume calculations.$q$,
  what_students_need_to_understand = $q$- This topic tests visual/quantitative reasoning without the calculation tools (molality, colligative properties) that would normally support it.
- That is why the equal-volume check matters so much: more particles in a larger box can mean the same or lower concentration.$q$,
  how_this_becomes_points = $q$1. Compare particle counts only after confirming box areas/volumes are equal, or explicitly normalizing for unequal ones.
2. Never reach for a molality or colligative-property calculation; neither is assessable here.$q$,
  point_attaining_answer = $q$| Diagram | Particles | Area | Particles per area |
| A | 8 | A | 8/A |
| B | 12 | 2A | 12/(2A) = 6/A |

Concentration depends on particles per unit volume (or area, in a 2-D representation), not raw particle count. Since 8/A is greater than 6/A, Diagram A is the more concentrated solution despite fewer total particles; the raw count is misleading until divided by the box's size.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 1-5 except 1.5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_chemistry/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=3 and topic_code='3.8' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='8095d60203e378b5e9c416ec5744cdd1';
update app.topic_explainers set
  core_idea = $q$- Ordinary filtration only separates a solid from a liquid it is suspended in (a heterogeneous mixture); dissolved solute shares the solvent's phase and passes through.
- Chromatography separates by differential interaction strength with a stationary and a mobile phase: components favoring the mobile phase travel farther/faster, revealing relative polarity.$q$,
  what_students_need_to_understand = $q$- Chromatography separation is entirely an IMF-strength argument, connecting back to 3.1.
- The homogeneous/heterogeneous distinction from 3.7 determines whether filtration is even a candidate method.$q$,
  how_this_becomes_points = $q$1. Choose the method from the physical/chemical property that actually differs between components.
2. Explain chromatography through differential interaction strength with the two phases.
3. Do not explain it through size or mass.$q$,
  point_attaining_answer = $q$| Dye | Travel | Interacts more strongly with | Relative polarity |
| A | farther | nonpolar mobile phase | less polar |
| B | less far | polar stationary paper | more polar |

Distance traveled reflects differential interaction strength with the stationary versus mobile phase, not molar mass. The solvent is nonpolar and the paper polar, so Dye A partitions more into the nonpolar solvent and moves with it.

Filtration could not have separated these dyes, since both are fully dissolved in the same liquid phase.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 1-5 except 1.5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_chemistry/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=3 and topic_code='3.9' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='3b7b8d396c942fa11197957f25bc511e';
update app.topic_explainers set
  core_idea = $q$- "Like dissolves like" is shorthand for a mechanism: a solute dissolves well when solute and solvent have similar dominant IMFs.
- Similar IMFs let solvent particles surround and stabilize solute particles as effectively as the solute's own particles did; mismatched IMFs do not.
- This is 3.1's IMF vocabulary applied to miscibility instead of boiling point.$q$,
  what_students_need_to_understand = $q$- This topic is graded on naming the actual force match or mismatch.
- Restating the mnemonic without the underlying forces earns nothing.$q$,
  how_this_becomes_points = $q$1. Name the dominant IMF type in both solute and solvent.
2. State whether they match, and predict solubility/miscibility from that.
3. Do not cite "like dissolves like" alone.$q$,
  point_attaining_answer = $q$Iodine is a nonpolar diatomic molecule, so its only intermolecular force is London dispersion.

| Solvent | Dominant IMF | Match with I2 | Result |
| Water | hydrogen bonding, much stronger than London forces | mismatch: water would rather hydrogen-bond with itself | only slightly soluble |
| Hexane (nonpolar) | London dispersion | match: replaces iodine's own interactions | dissolves readily |

The deciding factor is the matched or mismatched force type, not simply invoking "like dissolves like."$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 1-5 except 1.5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_chemistry/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=3 and topic_code='3.10' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='913619f367b15bf94a3ff21b5c7c0415';
update app.topic_explainers set
  core_idea = $q$- Different spectrum regions carry different energy, so they probe different transitions.
- Microwave (lowest of the three): molecular rotational. Infrared: molecular vibrational (bond stretching and bending). UV/visible (highest): electronic, an electron moving between energy levels.
- Absorption in one region tells you about that transition type only.$q$,
  what_students_need_to_understand = $q$- This maps onto the common point loss of treating every spectrum as electronic-transition evidence.
- It connects to 3.13's Beer-Lambert law, typically applied in the UV/visible region for concentration measurements.$q$,
  how_this_becomes_points = $q$1. Match the spectral region given in the prompt to its transition type.
2. Do not over-interpret a non-UV/visible spectrum as electronic-structure evidence.$q$,
  point_attaining_answer = $q$The classmate's claim is incorrect.

Infrared radiation carries enough energy to excite molecular vibrational transitions, here the stretching of the C=O bond, but not enough to promote an electron between electronic energy levels; that requires the higher-energy UV/visible region.

The IR band is evidence of bond vibration (a carbonyl group), not of the compound's electronic structure. An electronic-transition claim would need a UV/visible absorption spectrum.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 1-5 except 1.5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_chemistry/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=3 and topic_code='3.11' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='0f290164e64f64563ab82c5889599020';
update app.topic_explainers set
  core_idea = $q$- A photon is a packet of electromagnetic energy; its wavelength and frequency determine the exact energy transferred when light is absorbed or emitted.
- c = lambda nu: shorter wavelength means higher frequency.
- E = h nu: higher frequency means greater photon energy.$q$,
  what_students_need_to_understand = $q$- Keep the chain straight: wavelength and frequency are inversely related, but energy and frequency are directly related.
- Absorption raises the species to a higher-energy state by the photon energy; emission lowers it by the emitted photon energy.$q$,
  how_this_becomes_points = $q$1. Convert wavelength to meters if needed.
2. Solve for frequency with c = lambda nu, then use E = h nu.
3. Connect the number to an energy change in the species, not just a calculator result.$q$,
  point_attaining_answer = $q$The 400 nm photon carries more energy.

| Photon | Wavelength vs. 500 nm | Frequency | Energy |
| 400 nm | shorter | higher | more |
| 700 nm | longer | lower | less |

Frequency is c divided by wavelength, and photon energy is E = h nu. The answer should compare frequency and energy, not just the size of the wavelength number.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 1-5 except 1.5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_chemistry/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=3 and topic_code='3.12' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='d7e0ea3b245100f4b0fed5606381d2e2';
update app.topic_explainers set
  core_idea = $q$- Beer-Lambert turns spectrophotometry into a concentration measurement.
- Absorbance equals molar absorptivity times path length times concentration: A = epsilon b c.
- With wavelength and path length fixed, epsilon and b are fixed, so absorbance changes linearly with concentration.$q$,
  what_students_need_to_understand = $q$- Wavelength is normally chosen near maximum absorbance, so small concentration differences give clearer absorbance differences.
- Cuvette path length must stay the same if absorbances are compared by proportional reasoning.$q$,
  how_this_becomes_points = $q$1. Name the variables in A = epsilon b c.
2. Use direct proportionality only when epsilon and b are constant.
3. Interpret larger absorbance as more absorbing species along the light path, not a different photon energy claim.$q$,
  point_attaining_answer = $q$Same compound, same wavelength, and same 1.00 cm path length, so epsilon and b are constant. Beer-Lambert reduces to A proportional to concentration.

Doubling absorbance from 0.40 to 0.80 means the concentration doubled.

The photon energy did not double because the wavelength did not change; the amount of absorbing species in the path changed.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 1-5 except 1.5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_chemistry/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=3 and topic_code='3.13' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='72460f4d60be3ef1190a6b187929eaac';
update app.topic_explainers set
  core_idea = $q$- A reaction claim is really a composition claim.
- Chemical changes form new substances.
- Physical changes alter state, form, or mixture without changing identity.$q$,
  what_students_need_to_understand = $q$- Gas, precipitate, heat, light, or color change can support a reaction claim.
- The strongest answer connects the observation to particles being rearranged into different substances.$q$,
  how_this_becomes_points = $q$1. Identify whether composition changes.
2. Name evidence for a reaction.
3. Describe what happened to the substances, not just the visible cue.$q$,
  point_attaining_answer = $q$The formation of a solid precipitate suggests that ions in solution rearranged to form a new insoluble substance.

The observation matters because it points to a composition change, not merely because the mixture looks different.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 1-5 except 1.5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_chemistry/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=4 and topic_code='4.1' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='148ae8bb59d5c34ba56e7a7b77a2613b';
update app.topic_explainers set
  core_idea = $q$- Net ionic equations show only the species that actually change during an aqueous process.
- They still conserve atoms and total charge.$q$,
  what_students_need_to_understand = $q$- Move through the equation forms deliberately.
- The molecular equation shows formulas as written; the complete ionic equation splits strong aqueous electrolytes into ions.
- The net ionic equation removes spectator ions that are identical on both sides.$q$,
  how_this_becomes_points = $q$1. Dissociate correctly and give correct phases.
2. Cancel true spectators only.
3. Check both atom balance and charge balance in the final net ionic equation.$q$,
  point_attaining_answer = $q$Cancel Na+ if it has the same charge and aqueous phase on both sides.

It is a spectator ion, so the net ionic equation should focus on the species that react or change phase.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 1-5 except 1.5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_chemistry/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=4 and topic_code='4.2' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='342020e1aaac2e5fd2b8971a42227e49';
update app.topic_explainers set
  core_idea = $q$- A balanced equation and a particulate diagram must tell the same conservation story.
- The same kinds and numbers of atoms are rearranged into products.$q$,
  what_students_need_to_understand = $q$- Translate coefficients into counts or ratios of particles.
- Spectator ions may be shown in a complete particulate representation but omitted from a net ionic one.
- The products drawn must match formulas and charges from the balanced equation.$q$,
  how_this_becomes_points = $q$1. Match coefficients and conserve atoms and charge.
2. Choose the correct representation type.
3. Show particles in the proper combined or separated form.$q$,
  point_attaining_answer = $q$The diagram must preserve the particle ratio represented by the coefficients.

If two formula units or sets of ions are needed for every one product unit, the particulate model should show that ratio or a consistent multiple of it.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 1-5 except 1.5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_chemistry/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=4 and topic_code='4.3' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='3f2172e644a89b8c7f4b73f8e4d944c2';
update app.topic_explainers set
  core_idea = $q$- Physical versus chemical change depends on what changes at the particle level.
- Intermolecular attractions usually shift in physical changes; chemical bonds usually change in chemical changes.$q$,
  what_students_need_to_understand = $q$- Avoid one-word rules.
- Melting separates particles by weakening intermolecular attractions, so composition stays the same; a reaction that forms new covalent or ionic substances changes composition.
- Dissolving an ionic solid can need a more careful argument because ionic attractions and ion-dipole interactions are involved.$q$,
  how_this_becomes_points = $q$1. Name the interaction being broken or formed.
2. Tie that interaction to composition change or no composition change.$q$,
  point_attaining_answer = $q$It is a physical change.

The water molecules remain H2O; the main change is in intermolecular attractions and particle arrangement, not in the composition of the molecules.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 1-5 except 1.5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_chemistry/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=4 and topic_code='4.4' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='64ad1b1bc085d9cc66e014077a939471';
update app.topic_explainers set
  core_idea = $q$- Stoichiometry is conservation of atoms turned into calculation.
- Balanced coefficients are mole ratios that connect measured amounts of reactants and products.$q$,
  what_students_need_to_understand = $q$- Mass, volume of gas, or solution concentration data must first become moles.
- The balanced equation changes one substance amount into another.
- The final answer must return to the requested unit, often mass or concentration.$q$,
  how_this_becomes_points = $q$1. Convert to moles.
2. Use the correct coefficient ratio, identifying limiting information when needed.
3. Convert from moles to the requested unit instead of stopping early.$q$,
  point_attaining_answer = $q$No. A mass comparison must include molar mass.

The mole ratio says 3 mol Zn per 2 mol Al, but the masses require multiplying each mole amount by its molar mass before comparing.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 1-5 except 1.5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_chemistry/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=4 and topic_code='4.5' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='301cba38407ad0d4ab6b733a40f4d2f2';
update app.topic_explainers set
  core_idea = $q$- A titration uses a measured volume of known titrant.
- It finds analyte amount through a specific balanced reaction.$q$,
  what_students_need_to_understand = $q$- Distinguish chemical completion from the observed signal.
- At the equivalence point, the analyte has reacted according to the stoichiometric ratio.
- The endpoint is the indicator or instrument change used to detect that point, and it may only approximate equivalence.$q$,
  how_this_becomes_points = $q$1. Calculate titrant moles.
2. Apply the balanced mole ratio to get analyte moles, then divide by analyte volume for concentration.
3. Use endpoint/equivalence language precisely.$q$,
  point_attaining_answer = $q$| Term | Meaning |
| Equivalence point | the stoichiometric point where the analyte has been consumed by the titrant |
| Endpoint | the observed color change used to signal that point, chosen to be close to equivalence |$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 1-5 except 1.5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_chemistry/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=4 and topic_code='4.6' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='5e8d29eb4d2e13daa1d989bacb6d1a6f';
update app.topic_explainers set
  core_idea = $q$- Reaction types are recognized by particle-level changes.
- Acid-base: proton transfer. Redox: electron transfer.
- Precipitation: insoluble product formation. Complete hydrocarbon combustion: CO2/H2O formation.$q$,
  what_students_need_to_understand = $q$- Support the classification with evidence.
- Redox requires oxidation-number change; acid-base requires proton transfer.
- Precipitation requires an insoluble or sparingly soluble ionic product, with AP Chemistry limiting solubility-rule memorization to the stated soluble ions.$q$,
  how_this_becomes_points = $q$1. Identify the reaction signature.
2. Use allowed solubility information.
3. Do not rely on labels without evidence from formulas or oxidation numbers.$q$,
  point_attaining_answer = $q$A solid product from mixing aqueous ions supports a precipitation reaction.

To call it redox, you would need evidence of oxidation-number changes; solid formation alone is not electron transfer.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 1-5 except 1.5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_chemistry/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=4 and topic_code='4.7' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='9f2145a6d929b1bfeeb07ed103bb7a9d';
update app.topic_explainers set
  core_idea = $q$- Bronsted-Lowry acid-base reactions are proton-transfer reactions.
- Acids donate H+ and bases accept H+.$q$,
  what_students_need_to_understand = $q$- Track one proton through the equation.
- After an acid donates H+, it becomes its conjugate base; after a base accepts H+, it becomes its conjugate acid.
- Water can act as either donor or acceptor in aqueous reactions; Lewis acid-base ideas are outside this AP topic.$q$,
  how_this_becomes_points = $q$1. Identify donor and acceptor.
2. Pair conjugates correctly.
3. Explain relative strength from ionization behavior when asked.$q$,
  point_attaining_answer = $q$NH3 is the base because it accepts H+ from water to become NH4+.

Water donates H+ and therefore acts as the acid in this direction.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 1-5 except 1.5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_chemistry/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=4 and topic_code='4.8' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='4c61a872185efeaa351fcefd67ecbb8b';
update app.topic_explainers set
  core_idea = $q$- Redox reactions are electron-transfer reactions.
- Half-reactions make the electron accounting explicit.$q$,
  what_students_need_to_understand = $q$- Connect oxidation numbers to half-reaction direction.
- Oxidation is loss of electrons, so electrons appear as products in the oxidation half-reaction; reduction is gain, so electrons appear as reactants in the reduction half-reaction.
- Balanced redox equations conserve atoms and charge.$q$,
  how_this_becomes_points = $q$1. Assign oxidation states and identify what is oxidized or reduced.
2. Place electrons on the correct side.
3. Scale half-reactions so electrons cancel.$q$,
  point_attaining_answer = $q$Electrons are products: Al(s) -> Al3+(aq) + 3e-.

Aluminum loses electrons, so this is oxidation and electron loss must appear on the product side.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 1-5 except 1.5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_chemistry/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=4 and topic_code='4.9' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='65a3dc71ea8c978fa9c405158a75346f';
update app.topic_explainers set
  core_idea = $q$- Reaction rate is how quickly concentrations change as reactants become products.
- The balanced equation controls how species rates compare.$q$,
  what_students_need_to_understand = $q$- Connect measured slopes to stoichiometry: if coefficients differ, one species may disappear twice as fast as another appears.
- Rate can also change when concentration, temperature, surface area, catalyst, or environment changes the number of successful collisions.$q$,
  how_this_becomes_points = $q$1. Read concentration-time data.
2. Use coefficient ratios to compare species rates.
3. Explain factor changes through particle behavior.$q$,
  point_attaining_answer = $q$B increases at 0.10 M/s.

The balanced equation says 2 mol A are consumed for every 1 mol B formed, so the disappearance rate of A is twice the appearance rate of B.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 1-5 except 1.5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_chemistry/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=5 and topic_code='5.1' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='7e07b7ee683cd36da8353b197eb5e6c7';
update app.topic_explainers set
  core_idea = $q$- A rate law is an experimental relationship between rate and reactant concentrations.
- Orders are found from data.$q$,
  what_students_need_to_understand = $q$- Use initial-rate comparisons: with one concentration doubled and others constant, a doubled rate means order one and a quadrupled rate means order two.
- Overall order is the sum of individual orders, and rate constant units depend on that overall order.$q$,
  how_this_becomes_points = $q$1. Isolate one variable between trials.
2. Solve for reactant orders and write the rate law.
3. Determine k with correct units when asked.$q$,
  point_attaining_answer = $q$Second order.

Doubling [A] causes the rate to increase by a factor of four, so rate is proportional to [A]^2 for that reactant.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 1-5 except 1.5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_chemistry/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=5 and topic_code='5.2' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='98d7ecff10990e57da018e8687aa8d68';
update app.topic_explainers set
  core_idea = $q$- Integrated rate laws identify reaction order.
- The order is the one whose concentration transformation produces a straight line over time.$q$,
  what_students_need_to_understand = $q$- Match graph, equation, and slope. Zero order: linear [A] vs t, slope -k.
- First order: linear ln[A] vs t, slope -k, constant half-life.
- Second order: linear 1/[A] vs t, slope +k.$q$,
  how_this_becomes_points = $q$1. Choose the linear plot.
2. Extract k from the correct slope and use the matching integrated rate law.
3. Apply first-order half-life only when appropriate.$q$,
  point_attaining_answer = $q$It is first order.

A linear ln[A] versus time plot matches ln[A]_t - ln[A]_0 = -kt, and the slope is -k.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 1-5 except 1.5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_chemistry/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=5 and topic_code='5.3' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='c7feebbe7e6607bdc8e10fbfb75721a8';
update app.topic_explainers set
  core_idea = $q$- An elementary reaction is one molecular event.
- Its reactants directly determine the rate law for that step.$q$,
  what_students_need_to_understand = $q$- Recognize the boundary of the shortcut.
- For an elementary step A + B -> products, rate = k[A][B]; for an overall reaction made of multiple steps, the overall coefficients do not automatically give orders.
- Collisions involving three or more particles at once are rare.$q$,
  how_this_becomes_points = $q$1. Identify molecularity.
2. Write the rate law for a named elementary step.
3. Avoid the elementary shortcut for overall equations.$q$,
  point_attaining_answer = $q$The reactants NO2 and CO appear: rate = k[NO2][CO].

For an elementary step, the rate law follows the colliding reactant particles in that single step.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 1-5 except 1.5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_chemistry/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=5 and topic_code='5.4' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='21ea08783511ca3fe013529255b0168f';
update app.topic_explainers set
  core_idea = $q$- A successful collision requires enough energy to overcome activation energy.
- It also requires a productive particle orientation.$q$,
  what_students_need_to_understand = $q$- Explain rate changes through successful collisions.
- Raising temperature increases particle energy and the fraction above activation energy; increasing concentration or surface area can increase collision frequency.
- Orientation matters because not every collision forms products.$q$,
  how_this_becomes_points = $q$1. Name the factor changed.
2. Connect it to collision frequency, energy distribution, or orientation.
3. Explain why successful collision count changes.$q$,
  point_attaining_answer = $q$Higher temperature shifts the energy distribution so a larger fraction of particles have energy at or above activation energy.

Collision frequency may also rise, but the key AP explanation is more energetically successful collisions.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 1-5 except 1.5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_chemistry/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=5 and topic_code='5.5' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='29d1abd46e72adfc863e3931650c6598';
update app.topic_explainers set
  core_idea = $q$- A reaction energy profile shows the energy barrier between reactants and the transition state.
- It also shows the energy difference between reactants and products.$q$,
  what_students_need_to_understand = $q$- Separate kinetics from thermodynamics: activation energy affects rate.
- Overall energy change indicates endothermic or exothermic character.
- The Arrhenius equation supports qualitative temperature and activation-energy reasoning, but AP Chemistry does not assess Arrhenius calculations.$q$,
  how_this_becomes_points = $q$1. Label reactants, products, and transition state.
2. Label forward and reverse activation energy.
3. Label overall energy change correctly.$q$,
  point_attaining_answer = $q$The overall energy change is negative, so the reaction is exothermic.

Activation energy is measured from reactants up to the transition-state peak and remains a barrier.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 1-5 except 1.5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_chemistry/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=5 and topic_code='5.6' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='5725065e02d4647e7a8303b7438f8b98';
update app.topic_explainers set
  core_idea = $q$- A mechanism is a set of elementary steps that add to the overall reaction.
- Intermediates and catalysts cancel from the net equation for different reasons.$q$,
  what_students_need_to_understand = $q$- Inspect individual steps.
- An intermediate is produced in one step and consumed in a later step; a catalyst is consumed first and regenerated later.
- The summed mechanism must match the overall balanced equation.$q$,
  how_this_becomes_points = $q$1. Add the steps and cancel correctly.
2. Classify species from the order in which they appear.
3. Check the overall reaction.$q$,
  point_attaining_answer = $q$It is an intermediate.

| Species type | Pattern across steps |
| Intermediate | made during the mechanism, used up later |
| Catalyst | consumed in an earlier step, regenerated later |$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 1-5 except 1.5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_chemistry/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=5 and topic_code='5.7' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='a54979b208c6aa7296452337ee814cf9';
update app.topic_explainers set
  core_idea = $q$- The rate-determining elementary step controls the rate law.
- This holds when it is the slow step that limits the mechanism.$q$,
  what_students_need_to_understand = $q$- Write the slow-step rate law from the reactants in that elementary step.
- If the slow step contains only species from the overall reaction, the rate law is direct.
- If it contains an intermediate, another mechanism relationship is needed before the final rate law is acceptable.$q$,
  how_this_becomes_points = $q$1. Identify the slow step.
2. Use molecularity for that step.
3. Avoid overall-equation coefficients as rate-law powers.$q$,
  point_attaining_answer = $q$Because the slow step is elementary, its reactants determine the rate law: rate = k[A][B].

The overall equation is not the source of the powers.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 1-5 except 1.5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_chemistry/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=5 and topic_code='5.8' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='3cbfa8afaf89978a886bf83f5c657d16';
update app.topic_explainers set
  core_idea = $q$- Pre-equilibrium lets a fast reversible step relate an intermediate concentration to reactant concentrations.
- This happens before the slow step occurs.$q$,
  what_students_need_to_understand = $q$- See why substitution is needed: the slow-step rate law may contain an intermediate.
- Since intermediates should not usually appear in the experimentally observed rate law, the earlier fast equilibrium expression is used to rewrite that intermediate.$q$,
  how_this_becomes_points = $q$1. Write the slow-step rate law.
2. Write the pre-equilibrium expression and solve for the intermediate.
3. Substitute without changing the mechanism logic.$q$,
  point_attaining_answer = $q$A final rate law should be expressed in terms of reactants that can be controlled or measured.

The fast pre-equilibrium step can express [I] in terms of earlier reactants, allowing substitution into the slow-step rate law.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 1-5 except 1.5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_chemistry/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=5 and topic_code='5.9' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='666b71fbf8bcb84d7a3b0a3c1f4251fd';
update app.topic_explainers set
  core_idea = $q$- A multistep energy profile represents a mechanism as multiple barriers and wells.
- Peaks are transition states; wells between peaks are intermediates.$q$,
  what_students_need_to_understand = $q$- Connect graph features to mechanism steps.
- Each peak corresponds to an elementary-step transition state; each valley between reactants and products corresponds to an intermediate.
- The largest activation barrier usually marks the slowest step.$q$,
  how_this_becomes_points = $q$1. Count steps.
2. Identify intermediates and compare activation energies.
3. Connect the rate-determining step to the highest barrier, not total energy change.$q$,
  point_attaining_answer = $q$The middle valley represents an intermediate.

It is a species formed after the first elementary step and consumed before the final products are reached.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 1-5 except 1.5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_chemistry/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=5 and topic_code='5.10' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='07f59d2e923d94e1189a6baf2c51bac5';
update app.topic_explainers set
  core_idea = $q$- A catalyst changes the reaction pathway and is regenerated overall.
- So mechanism-step evidence is required to identify it.$q$,
  what_students_need_to_understand = $q$- Prove catalyst status from the mechanism, not just from a definition.
- A catalyst is consumed in one step and regenerated in a later step, with no net consumption in the overall equation; an intermediate is produced first and consumed later.
- Catalysts can lower activation energy or improve effective collision pathways.$q$,
  how_this_becomes_points = $q$1. Cite the exact steps where the catalyst is consumed and regenerated.
2. Distinguish it from intermediates.
3. Connect the alternate pathway to increased rate.$q$,
  point_attaining_answer = $q$X is a catalyst because the mechanism shows it being consumed in step 1 and regenerated in step 2, so it is not consumed overall.

The step evidence is the required justification.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 1-5 except 1.5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-2026-11-13/ap_chemistry/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=5 and topic_code='5.11' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='e012604c18259f75b39d14e307d8798e';
do $$ begin if (select count(*) from app.topic_explainers where subject_key='ap_chemistry' and topic_code in ('1.1','1.2','1.3','1.4','1.6','1.7','1.8','2.1','2.2','2.3','2.4','2.5','2.6','2.7','3.1','3.2','3.3','3.4','3.5','3.6','3.7','3.8','3.9','3.10','3.11','3.12','3.13','4.1','4.2','4.3','4.4','4.5','4.6','4.7','4.8','4.9','5.1','5.2','5.3','5.4','5.5','5.6','5.7','5.8','5.9','5.10','5.11') and source_note like '%Structured 2026-11-13 (recommendation #3%')<>47 then raise exception 'expected 47 rows updated'; end if; end $$;
commit;
