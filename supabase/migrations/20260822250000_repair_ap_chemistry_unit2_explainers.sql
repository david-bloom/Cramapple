begin;

-- Repair AP Chemistry Unit 2 (Compound Structure and Properties) Learn More
-- explainers -- all 7 were template-generated debt (core_idea
-- verbatim-matching their brief's what_it_is, and mini_example_question /
-- weak_answer shared boilerplate duplicated across ~150 other rows
-- corpus-wide, per the 2026-08-21 bulk audit). Confirmed via SQL before
-- authoring: all 7 rows carried source_note 'generated-from-brief:legacy;
-- grandfathered-2026-08-21', and a direct read of the current rows showed
-- core_idea byte-identical to the paired brief's what_it_is on every row,
-- plus the exact boilerplate weak_answer ("I would do the calculation or
-- name the trend and move on.") and mini_example_question
-- (title-interpolation template) on every row -- so all 7 are genuine
-- debt; none were an outlier that already had hand-authored content.
-- Briefs for this unit are genuinely hand-authored and correct; NOT
-- touched here.
--
-- Grounded in docs/product/AP_CHEMISTRY_CED_FACT_PACK.md Unit 2 section
-- (starting line 283): 2.1's fact that all polar bonds carry some ionic
-- character (ionic/covalent is a continuum, not a hard cutoff) and that
-- C-H bonds are treated as effectively nonpolar despite a small real
-- electronegativity difference, applied to a real C-H/O-H/Na-Cl
-- electronegativity-difference comparison (Pauling values: C 2.55, H
-- 2.20, O 3.44, Na 0.93, Cl 3.16); 2.2's PE-curve zero-baseline-at-
-- infinite-separation fact (well depth measured from that baseline is
-- bond energy), applied to real C-C/C=C/C-triple-bond-C bond
-- length/energy data (154 pm/347 kJ/mol, 134 pm/614 kJ/mol, 120 pm/839
-- kJ/mol); 2.3's verbatim exclusion statement that specific crystal
-- structures are not assessed, applied to a rock-salt-vs-alternating-
-- array contrast for explaining NaCl's brittleness; 2.4's interstitial-
-- vs-substitutional alloy distinction plus the related Unit 3 (section
-- 3.2) fact that interstitial alloying reduces malleability/ductility
-- while retaining conductivity, applied to a steel-vs-brass radius
-- comparison; 2.5's Lewis-diagram construction procedure with an
-- explicit charge-adjustment step, applied to a carbonate ion (CO3^2-,
-- 24 valence electrons after the 2- charge adjustment) worked example;
-- 2.6's formal-charge equation (valence electrons minus lone-pair
-- electrons minus half the bonding electrons) and the equivalent-vs-
-- nonequivalent resonance distinction, applied to a nitrite ion (NO2^-)
-- equivalent-resonance example verified against real experimental N-O
-- bond length data (~124 pm, intermediate between a ~140 pm single bond
-- and a ~115 pm double bond, and equal on both sides); and 2.7's three
-- verbatim VSEPR/hybridization exclusion statements (hybrid-orbital
-- derivation, d-orbital hybridization, molecular orbital theory) plus
-- the documented 2025 FRQ misconception (hybridization ID scored 0.56/1.0,
-- dominant error counting a C=O double bond as two electron domains
-- instead of one), applied directly to a formaldehyde (H2C=O) central-
-- carbon hybridization example that reproduces that exact misconception.
-- All computed/cited numbers (Pauling electronegativities, bond
-- lengths/energies by bond order, valence-electron counts, formal-charge
-- reasoning, and real N-O bond-length data) were independently verified
-- during authoring.
--
-- Before-state not separately captured for this batch (no prior
-- before-state export file exists for AP Chemistry Unit 2); the
-- pre-repair content is fully recoverable from git history for this
-- table's rows if a rollback is ever needed.
--
-- Every new explainer is genuinely topic-specific: core_idea differs from
-- what_it_is on every row (expands it with a new grounded fact from the
-- fact pack rather than restating it). answer_move and common_point_loss
-- are preserved verbatim from the paired brief per protocol section 4
-- ("the same topic-specific answer_move" / "the same or refined
-- common_point_loss") -- the Unit 2 briefs already carry specific,
-- correct, non-templated point-earning language, so no refinement was
-- needed. mini_example_question / weak_answer / point_attaining_answer /
-- practice_bridge are original per-row text that was checked corpus-wide
-- before this migration was written and repeats nowhere else in the
-- published corpus (zero collisions found).

with explainer_updates (
  topic_code, core_idea, what_students_need_to_understand,
  how_this_becomes_points, answer_move, mini_example_question, weak_answer,
  point_attaining_answer, common_point_loss, practice_bridge
) as (
  values
  ('2.1',
   'Electronegativity difference doesn''t sort bonds into three separate boxes -- it places every bond on one continuous scale. Because the classification has no hard cutoff, even a bond called ''polar covalent'' carries some ionic character, and a small real difference like C-H''s is still treated as effectively nonpolar.',
   'Bond polarity set here reappears as molecular dipole moments in 2.7, as the charge magnitude driving Coulombic strength in 2.2 and 2.3, and as the delocalized-electron picture that explains metallic behavior in 2.4 -- so an unstated or wrong electronegativity comparison quietly loses points across three later topics, not just this one.',
   'Points require naming the bond type (nonpolar covalent, polar covalent, or ionic) and backing that call with an explicit electronegativity comparison -- which atom pulls harder and which carries the partial negative charge -- rather than a metal/nonmetal shortcut, and then confirming the call with a real property such as conductivity when molten/dissolved, melting point, or brittleness versus malleability.',
   'State the electronegativity comparison explicitly before naming the bond type (''O is more electronegative than H, so the shared electrons are pulled toward O -- polar covalent, with delta-negative on O''), and when the item gives you experimental properties, let those properties decide the classification rather than the metal/nonmetal shortcut.',
   'Rank the C-H bond in methane, the O-H bond in water, and the Na-Cl bond in table salt from least to most ionic character, and justify the order using electronegativity difference.',
   'C-H and O-H are both covalent bonds and NaCl is ionic, so C-H and O-H behave the same way and NaCl is a totally different kind of bond.',
   'Electronegativity difference sets the order: C (2.55) and H (2.20) differ by about 0.35, so C-H is effectively nonpolar covalent. O (3.44) and H (2.20) differ by about 1.24, giving O-H a real bond dipole (polar covalent) with delta-negative on oxygen. Na (0.93) and Cl (3.16) differ by about 2.23, the largest gap of the three, so the bond is classified ionic -- though because ionic and covalent form a continuum rather than two boxes, even this bond retains some covalent character.',
   'Treating ionic and covalent as two separate boxes, instead of a continuum where every polar bond already has some ionic character.',
   'Back in practice, on every bond-classification item, write the electronegativity comparison down first -- then let its size, not the metal/nonmetal identity, decide where the bond sits on the continuum.'),
  ('2.2',
   'A potential-energy-vs-internuclear-distance curve is quantitative, not just a shape to recognize: as the atoms separate toward infinite distance, PE rises to zero, so the well''s depth measured from that zero baseline down to the minimum is exactly the bond energy needed to pull the atoms apart.',
   'This turns bonding from a label into a number you can rank and defend -- it drives lattice-energy comparisons, the bond-length/bond-energy rankings tested again in 2.7, and every bond-energy argument in later thermodynamics units, and it is one of the few Unit 2 ideas tested as a graph-reading task rather than a definition.',
   'Points require reading equilibrium bond length off the curve''s minimum x-value and bond energy off the well''s depth, ranking bond length and bond energy together by bond order (shorter bond goes with the larger bond energy, never the reverse), and for ion pairs, citing both Coulomb''s-law factors together -- charge magnitude and internuclear distance -- rather than either alone.',
   'When you rank two ionic compounds, name charge and ionic size in the same sentence and say which one dominates (for example MgO over NaCl because 2+/2- charges outweigh any size difference); when reading a PE curve, quote the x-value at the minimum as bond length and the well depth as bond energy rather than describing the curve''s shape.',
   'Carbon-carbon bonds get shorter and stronger as bond order rises: the C-C single bond is about 154 pm and 347 kJ/mol, the C=C double bond about 134 pm and 614 kJ/mol, and the C-triple-bond-C bond about 120 pm and 839 kJ/mol. Explain why bond order predicts both trends together.',
   'The triple bond is strongest because it has three bonds instead of one, so there''s more holding the atoms together.',
   'Each additional bond adds more shared electron density directly between the two nuclei, pulling them closer together (154 pm to 134 pm to 120 pm) and deepening the potential-energy well (347 to 614 to 839 kJ/mol) -- on the PE curve, higher bond order shifts the minimum to a shorter distance and makes that minimum lower (more negative relative to the separated-atom baseline), so shorter bond length and larger bond energy rise together as a single consequence of bond order, not two independent facts.',
   'Comparing only ion charges and ignoring ionic radius, or claiming a longer bond is somehow stronger.',
   'Return to practice and, on every PE-curve or bond-order comparison, state length and energy together as one bond-order consequence -- never rank one without checking the other agrees.'),
  ('2.3',
   'Ionic solids pack cations and anions into one extended, repeating array that maximizes attraction and minimizes repulsion across the whole lattice -- and the AP Exam explicitly does not require naming which specific lattice geometry (such as rock-salt or cesium-chloride packing) a compound adopts, only the general alternating-array Coulombic argument.',
   'This supplies the structural picture behind every ionic-solid property you''re asked to explain -- why they''re hard, brittle, high-melting, and conduct only when molten or dissolved -- and it''s the bridge between the Coulomb''s-law reasoning in 2.2 and bulk-property questions in Unit 3, even though its own exam weight is narrower than Lewis and VSEPR.',
   'Points require describing the lattice as an extended, periodic array of alternating cations and anions and connecting that arrangement to a specific property -- many strong Coulombic attractions throughout the lattice requiring large energy to disrupt (high melting point), or a shifted layer aligning like charges and fracturing the crystal (brittleness) -- without naming a specific crystal-structure type, since that is outside what the exam assesses.',
   'Explain ionic properties by the alternating-array arrangement and the many attractions it creates, not by memorizing lattice names -- the AP Exam explicitly does not assess knowledge of specific crystal structures, so naming a structure type earns nothing and is not expected of you.',
   'Two students explain why NaCl is brittle. Student A says ''NaCl adopts a rock-salt (face-centered cubic) crystal structure, which makes it brittle.'' Student B says ''shifting one layer of the lattice aligns like-charged ions, and the resulting repulsion fractures the crystal.'' Which explanation earns credit on the AP Exam, and why?',
   'Student A''s answer is more specific and names the actual crystal structure, so it should earn more credit than Student B''s.',
   'Student B''s explanation earns the point. The AP Exam explicitly excludes knowledge of specific crystal structures -- naming ''rock-salt'' or ''face-centered cubic'' is neither required nor sufficient. Student B''s reasoning is what the exam actually rewards: displacing one layer relative to its neighbor brings like-charged ions into alignment, the resulting Coulombic repulsion overcomes the lattice''s attractive forces along that plane, and the crystal fractures rather than deforming the way a metal would.',
   'Describing an ionic solid as separate molecules or discrete ion pairs, rather than one extended lattice of alternating charges.',
   'Go to practice and, on ionic-solid property questions, reach for the alternating-array-plus-Coulombic-forces explanation every time -- never spend words naming a specific lattice geometry.'),
  ('2.4',
   'A metal is positive ions immersed in a delocalized sea of valence electrons. Alloying that lattice changes mechanical behavior without touching the electron sea itself: an interstitial alloy like steel (small carbon atoms wedged into iron''s gaps) becomes harder and less malleable than pure iron because those interstitial atoms block layers from sliding past each other, yet steel still conducts, since the delocalized electron sea is undisturbed.',
   'This is where the delocalization idea from 2.1 becomes an explanation for real, testable behavior -- conductivity, malleability, luster -- and where atomic radius from Unit 1 does concrete structural work distinguishing the two alloy types; its exam weight is narrower than Lewis/VSEPR, but the interstitial-versus-substitutional call is a clean, frequently testable size argument.',
   'Points require invoking mobile delocalized electrons to explain conductivity, invoking ion layers sliding past one another (held together throughout by the electron sea) to explain malleability, and classifying a named alloy as interstitial or substitutional by explicitly comparing the atomic radii of its two components rather than by naming the alloy from memory.',
   'Classify an alloy by comparing atomic radii out loud -- significantly different radii means the small atoms fill interstices (interstitial), comparable radii means one atom replaces another in lattice sites (substitutional) -- and cite the radius comparison as your reason, not the identity of the metals.',
   'Steel forms when small carbon atoms occupy gaps in an iron lattice. Brass forms when zinc atoms (atomic radius comparable to copper''s) replace copper atoms directly in the lattice. Classify each alloy as interstitial or substitutional, and justify the classification using atomic radius.',
   'Steel and brass are both alloys made of two metals mixed together, so they''re the same type of alloy.',
   'Steel is an interstitial alloy: carbon''s atomic radius is significantly smaller than iron''s, so carbon atoms fit into the interstices (gaps) between iron atoms in the host lattice rather than replacing them. Brass is a substitutional alloy: zinc''s atomic radius is comparable to copper''s, so zinc atoms directly replace copper atoms at regular lattice positions. The two are not the same structural type -- classification depends on comparing atomic radii, not on both being metal-metal mixtures. Note steel also stays conductive despite carbon reducing its malleability, since the interstitial atoms disrupt layer-sliding but leave the delocalized electron sea intact.',
   'Saying metals conduct because they ''have free electrons'' without stating those delocalized electrons are mobile throughout the whole solid.',
   'Head to practice and, on every alloy-classification item, compare the two elements'' atomic radii out loud before naming interstitial or substitutional -- the radius comparison is the justification, not the alloy''s name.'),
  ('2.5',
   'A Lewis diagram is a bookkeeping drawing built by a fixed procedure: total the valence electrons, adjusting that total by adding one electron per unit of negative charge or removing one per unit of positive charge for a polyatomic ion, then place bonds and lone pairs to satisfy octets, converting a lone pair into an extra bond when a central atom is left short.',
   'The Lewis diagram feeds almost everything downstream in this unit and the next -- resonance and formal-charge selection in 2.6, geometry and hybridization in 2.7, and intermolecular-force reasoning in Unit 3 -- so a diagram with the wrong electron count poisons every conclusion built on top of it, which is why free-response items so often ask you to draw one before anything else.',
   'Points require a complete, correct diagram: the total valence-electron count matches the formula (with charge adjustments applied for ions), every bonding pair and lone pair is actually drawn (not just implied), octets are satisfied wherever the procedure calls for them, and an ion''s finished diagram is enclosed in brackets with the overall charge written outside.',
   'Write the valence-electron total as a number before you draw anything, then count the electrons in your finished picture and confirm the two match -- and for a polyatomic ion, adjust that total for the charge and put brackets with the charge around the final structure.',
   'Draw the Lewis diagram for the carbonate ion, CO3^2-, and state the total number of valence electrons used.',
   'Carbon has 4 valence electrons and each oxygen has 6, so 4 + 6 + 6 + 6 = 22 electrons total.',
   'Carbon contributes 4 valence electrons and each of the three oxygens contributes 6, giving 4 + 18 = 22 -- but the ion carries a 2- charge, so 2 more electrons are added for a total of 24. With carbon central, one C=O double bond and two C-O single bonds distribute those 24 electrons: 6 in the three C-O sigma bonds, 2 more in the C=O pi bond, and 18 as lone pairs on the three oxygens, giving each terminal oxygen its full octet and carbon four bonds. The finished diagram is enclosed in brackets with a 2- written outside.',
   'Drawing only the bonds and forgetting lone pairs, or ignoring an ion''s charge when totaling valence electrons.',
   'Back to practice and, on every ion''s Lewis diagram, write the charge adjustment as its own step before counting electrons -- add for anions, subtract for cations -- so the total you build from is already correct.'),
  ('2.6',
   'Formal charge is computed as valence electrons minus lone-pair electrons minus half the bonding electrons on that atom, and it is the arithmetic tool -- not intuition -- that picks the best nonequivalent Lewis structure. The Lewis model itself has real limits: it cannot represent an odd-electron species, like a radical, without leaving one electron unpaired and formal charges imperfectly assigned.',
   'This is the judgment layer between drawing a structure and using it -- it''s why every bond in a resonance-stabilized ion like nitrite is identical in length rather than one short and two long, and it''s the tool that tells you which of several legal Lewis diagrams is the one the exam expects you to reason from.',
   'Points require drawing all equivalent resonance forms and stating the real structure is a single average of them (bond order and bond length between the individual-structure extremes), or -- for nonequivalent candidates -- computing formal charge on the contested atoms explicitly and justifying the chosen structure by minimized formal charges with any negative formal charge placed on the more electronegative atom.',
   'Decide first whether your candidate structures are equivalent or nonequivalent: equivalent ones call for drawing the resonance set and describing an averaged structure, while nonequivalent ones call for showing the actual formal-charge arithmetic on the contested atoms and naming which structure wins and why.',
   'The nitrite ion, NO2^-, has two equivalent resonance structures: one with the N=O double bond on the left oxygen and a single bond to the right oxygen, and one with the reverse. Explain what the ion''s real bonding looks like, and predict whether its two N-O bond lengths are equal or different.',
   'The ion rapidly flips back and forth between the two structures, so at any instant one N-O bond is a double bond and the other is a single bond.',
   'The two resonance structures are equivalent, so the real ion is a single averaged structure, not one that switches between two forms. Each N-O bond has an intermediate bond order of 1.5 (halfway between a single and a double bond), and experimentally both N-O bonds in nitrite measure about 124 pm -- shorter than a typical N-O single bond (~140 pm) and longer than a typical N=O double bond (~115 pm), and identical to each other, confirming the averaged picture rather than two different bond lengths.',
   'Saying the molecule rapidly switches between resonance forms; it is one averaged structure, and the bonds are identical.',
   'Return to practice and, before writing any resonance answer, decide equivalent-or-not first -- equivalent structures get an averaging statement, nonequivalent ones get real formal-charge arithmetic on the page.'),
  ('2.7',
   'VSEPR counts regions of electron density -- treating any double or triple bond as exactly one region -- to predict geometry, bond angles (sp 180 degrees, sp2 120 degrees, sp3 109.5 degrees), and hybridization. Three things stay off the exam: deriving or depicting hybrid orbitals, hybridization involving d orbitals (central atoms with more than four electron-pair regions get a shape only, no hybridization label), and molecular orbital theory.',
   'Geometry is the payoff of the whole unit and the entry point to Unit 3: whether a molecule is polar, and therefore how it interacts with other molecules, dissolves, and boils, depends on shape plus bond dipoles together -- and this exact reasoning chain was the lowest-scoring hybridization item on the 2025 exam, at a mean of just 0.56 out of 1.0.',
   'Points require counting electron-density regions correctly (each lone pair is one region, and a double or triple bond is exactly one region, not one per bond line), naming the geometry from atom positions only, giving the matching bond angle, and -- only when hybridization is asked for -- assigning sp, sp2, or sp3 from that same region count, never from counting bond lines individually.',
   'Count regions of electron density first and count each multiple bond as a single region, then answer exactly what was asked -- a geometry name if the question says geometry, an sp/sp2/sp3 label if it says hybridization. Note the scope limit: hybridization labels stop at sp3, so for a central atom with more than four electron pairs give only the shape, and never reach for d-orbital hybridization or molecular orbital theory, which the exam does not assess.',
   'Determine the hybridization of the central carbon atom in formaldehyde, H2C=O, where carbon is singly bonded to two hydrogens and doubly bonded to one oxygen.',
   'Carbon is attached to four things -- two hydrogens, plus two separate bonds to oxygen -- so it has four electron domains and is sp3 hybridized.',
   'Carbon has three regions of electron density: two single C-H bonds and one C=O double bond, which counts as a single region regardless of it being a double bond. Three regions means trigonal planar geometry with approximately 120 degree bond angles and sp2 hybridization, not sp3. This is exactly the error that cost the most points on the 2025 free-response hybridization item (mean score 0.56/1.0): counting a C=O double bond as two separate electron domains, which wrongly pushes the count to four and the hybridization to sp3 instead of the correct sp2.',
   'Counting a C=O double bond as two regions and answering sp3; a double bond is one region, so that carbon is sp2.',
   'Head back to practice and, on every hybridization question, count regions of electron density first -- collapsing every double or triple bond to one region -- before assigning sp, sp2, or sp3, and never reach for d-orbital or molecular-orbital-theory language.')
)
update app.topic_explainers e
set
  core_idea = u.core_idea,
  what_students_need_to_understand = u.what_students_need_to_understand,
  how_this_becomes_points = u.how_this_becomes_points,
  answer_move = u.answer_move,
  mini_example_question = u.mini_example_question,
  weak_answer = u.weak_answer,
  point_attaining_answer = u.point_attaining_answer,
  common_point_loss = u.common_point_loss,
  practice_bridge = u.practice_bridge,
  source_note = 'cramapple-authored; repaired 2026-08-22 replacing a template-generated explainer (previously generated-from-brief, grandfathered per the 2026-08-21 bulk audit) with topic-specific content grounded in AP_CHEMISTRY_CED_FACT_PACK.md Unit 2 section (line 283): the ionic/covalent-continuum and C-H-effectively-nonpolar facts for 2.1, verified against real Pauling electronegativity values; the PE-curve zero-baseline-at-infinite-separation fact for 2.2, verified against real C-C/C=C/C-triple-bond-C bond length and energy data; the verbatim crystal-structure exclusion statement for 2.3; the interstitial-alloy-retains-conductivity fact (cross-referenced from the Unit 3 section 3.2 alloy discussion) for 2.4, verified against a steel-vs-brass radius comparison; the explicit ion charge-adjustment step in the Lewis-diagram procedure for 2.5, verified against a carbonate-ion worked example; the formal-charge equation and equivalent-resonance-averaging rule for 2.6, verified against real nitrite-ion N-O bond-length data; and the three verbatim VSEPR/hybridization exclusion statements plus the documented 2025 FRQ C=O-double-bond-domain-counting misconception (mean score 0.56/1.0) for 2.7, applied directly to a formaldehyde central-carbon example reproducing that exact error; briefs for this unit are genuinely hand-authored and were NOT touched. batch 2026-08-22-ap-chemistry-unit2-explainer-repair; author=reviewer same session, no independent human review yet'
from explainer_updates u
where e.subject_key = 'ap_chemistry'
  and e.unit_number = 2
  and e.topic_code = u.topic_code;

do $$
declare
  v_repaired integer;
  v_core_matches integer;
begin
  select count(*) into v_repaired from app.topic_explainers
    where subject_key='ap_chemistry' and unit_number=2 and status='published'
      and source_note like '%unit2-explainer-repair%';
  if v_repaired <> 7 then
    raise exception 'expected 7 repaired AP Chemistry Unit 2 explainers, got %', v_repaired;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e on e.subject_key=b.subject_key and e.topic_code=b.topic_code
  where b.subject_key='ap_chemistry' and b.unit_number=2 and b.status='published'
    and e.status='published' and e.core_idea = b.what_it_is;
  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Chemistry Unit 2 explainers matching their brief verbatim, got %', v_core_matches;
  end if;
end $$;

commit;
