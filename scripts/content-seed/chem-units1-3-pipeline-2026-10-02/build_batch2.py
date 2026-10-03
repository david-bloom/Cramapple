import json
def R(x): return f"{x:.2f}"
V=[]
def add(id,seed,diff,title,stem,correct,wrong,note,check,facts=None):
    d={"id":id,"seed":seed,"difficulty":diff,"title":title,"stem":stem,
       "correct":{"text":correct[0],"rationale":correct[1]},
       "wrong":[{"text":t,"rationale":r,"error_pattern":e} for t,r,e in wrong],
       "change_note":note,"check":check}
    if facts: d["facts"]=facts
    V.append(d)

# ---------------- seed 003 ----------------
s="apchem-mcq-003"
add(s+"-v1",s,"easy","Planar carbonyl molecule",
"Four species are drawn as Lewis diagrams. Which one has a trigonal planar molecular geometry around its central atom?\n\nA. CH₂O\nB. PH₃\nC. SO₂\nD. SiH₄",
("CH₂O","Correct. Carbon forms two C–H single bonds and one C=O double bond. A double bond counts as one region of electron density, so carbon has three regions and no lone pair, giving trigonal planar geometry."),
[("PH₃","Phosphorus has three bonding pairs and one lone pair (four regions), so the molecular geometry is trigonal pyramidal, not trigonal planar. The lone pair is what pushes the three P–H bonds out of a plane.","Ignores the central-atom lone pair when counting regions, so three attached atoms is read as trigonal planar."),
 ("SO₂","Sulfur has three regions of electron density (two bonded O atoms and one lone pair), so its electron-domain geometry is trigonal planar, but the lone pair is not part of the molecular shape, which is bent.","Confuses electron-domain geometry with molecular geometry and reports the three-region arrangement as the shape."),
 ("SiH₄","Silicon has four bonding regions and no lone pairs, so the geometry is tetrahedral with 109.5° angles, not trigonal planar.","Counts every bond to the central atom without checking the number of regions; assumes four bonded atoms are coplanar.")],
"New species (CH₂O, PH₃, SO₂, SiH₄), new framing as Lewis diagrams; adds a double-bond-as-one-region test and an electron-domain-vs-molecular-geometry distractor.","conceptual",
["CH₂O: C has 3 regions (2 C–H, 1 C=O), 0 lone pairs -> trigonal planar","PH₃: P has 3 bonds + 1 lone pair -> trigonal pyramidal","SO₂: S has 2 bonded atoms + 1 lone pair -> bent (EDG trigonal planar)","SiH₄: 4 bonds, 0 lone pairs -> tetrahedral"])

add(s+"-v2",s,"medium","Nitrate ion shape",
"What is the molecular geometry of the nitrate ion, NO₃⁻?\n\nA. Trigonal planar\nB. Trigonal pyramidal\nC. Tetrahedral\nD. Bent",
("Trigonal planar","Correct. In the best Lewis structure (three equivalent resonance forms) nitrogen has one N=O double bond and two N–O single bonds, so three regions of electron density and no lone pair. Three regions with no lone pair give trigonal planar geometry."),
[("Trigonal pyramidal","Nitrogen in nitrate has no lone pair: all of its valence electrons are used in the bonds to the three oxygens. Trigonal pyramidal needs three bonds plus one lone pair, as in NH₃.","Assumes nitrogen always carries a lone pair, as in ammonia, and applies the NH₃ shape."),
 ("Tetrahedral","The double bond is one region, not two. Counting the N=O as two regions gives four regions, which is the source of this wrong answer; correctly there are three regions, so the geometry is trigonal planar.","Counts the double bond as two electron regions, giving four regions."),
 ("Bent","Bent geometry belongs to the nitrite ion, NO₂⁻, which has two bonded O atoms and one lone pair on N. Nitrate has three bonded O atoms and no lone pair on N.","Confuses nitrate with nitrite, whose nitrogen carries a lone pair.")],
"Different species (an ion), shape is named directly rather than chosen from a formula list; targets double-bond-as-one-region and nitrate/nitrite confusion.","conceptual",
["NO₃⁻: N has 3 regions, 0 lone pairs -> trigonal planar","NH₃-type shape needs 3 bonds + 1 lone pair; NO₃⁻ N has none","Double bond = one region -> not 4 regions","NO₂⁻: N has 2 bonded O + 1 lone pair -> bent"])

add(s+"-v3",s,"hard","Flat 120 degree ion",
"Which species has a trigonal planar molecular geometry, with three identical atoms bonded to the central atom in one plane at bond angles of 120°?\n\nA. CO₃²⁻\nB. SO₃²⁻\nC. ClF₃\nD. NO₂⁻",
("CO₃²⁻","Correct. Carbonate has three equivalent resonance forms with one C=O and two C–O⁻; carbon has three regions and no lone pair, so the three O atoms lie in a plane at 120°."),
[("SO₃²⁻","Sulfite has the same formula pattern as carbonate, but sulfur has three bonded O atoms and one lone pair (four regions), so the shape is trigonal pyramidal.","Matches the XO₃ formula pattern of carbonate and ignores the lone pair on sulfur."),
 ("ClF₃","Chlorine has three bonded F atoms and two lone pairs (five regions). The three F atoms lie in one plane but the shape is T-shaped with angles near 90°, not trigonal planar.","Assumes three bonded atoms means trigonal planar and ignores the two lone pairs on chlorine."),
 ("NO₂⁻","Nitrite has two bonded O atoms and one lone pair on N: trigonal planar electron-domain geometry but a bent molecular shape with only two atoms bonded to the central atom.","Reports the electron-domain geometry of three regions as the molecular shape.")],
"Ion with resonance, three-atom-bonded distractors from different families (pyramidal, T-shaped, bent), stem specifies 120° and three identical atoms.","conceptual",
["CO₃²⁻: C has 3 regions, 0 lone pairs -> trigonal planar, 120°","SO₃²⁻: S has 3 bonds + 1 lone pair -> trigonal pyramidal","ClF₃: Cl has 3 bonds + 2 lone pairs -> T-shaped (~90°)","NO₂⁻: N has 2 bonds + 1 lone pair -> bent"])

# ---------------- seed 025 ----------------
s="apchem-mcq-025"
EN=dict(Na=0.93,H=2.20,S=2.58,N=3.04,Cl=3.16,O=3.44,K=0.82,Si=1.90,P=2.19,Br=2.96,Li=0.98,Be=1.57,C=2.55,I=2.66,F=3.98)
def d(a,b): return abs(EN[a]-EN[b])
def sm(a,b): return EN[a]+EN[b]
add(s+"-v1",s,"easy","Greatest ionic character",
"A student compares four bonds using Pauling electronegativities (Na = 0.93, H = 2.20, S = 2.58, N = 3.04, Cl = 3.16, O = 3.44). Which bond is predicted to have the greatest ionic character?\n\nA. Na–Cl\nB. O–S\nC. N–Cl\nD. H–Cl",
("Na–Cl",f"Correct. Ionic character increases with the electronegativity difference. ΔEN: Na–Cl = 3.16 − 0.93 = {R(d('Na','Cl'))}; O–S = {R(d('O','S'))}; N–Cl = {R(d('N','Cl'))}; H–Cl = {R(d('H','Cl'))}. Na–Cl is the largest by a wide margin."),
[("O–S",f"ΔEN for O–S is 3.44 − 2.58 = {R(d('O','S'))}, far smaller than 2.23 for Na–Cl. This answer comes from choosing the bond that contains the single most electronegative atom (O, 3.44) instead of comparing differences.","Picks the bond containing the most electronegative atom rather than the largest electronegativity difference."),
 ("N–Cl",f"ΔEN for N–Cl is 3.16 − 3.04 = {R(d('N','Cl'))}, the smallest here. This answer comes from adding the electronegativities (3.04 + 3.16 = {R(sm('N','Cl'))}, the largest sum) instead of subtracting.","Adds the two electronegativities instead of subtracting them."),
 ("H–Cl",f"ΔEN for H–Cl is 3.16 − 2.20 = {R(d('H','Cl'))}, which is the largest difference among the nonmetal–nonmetal bonds but less than 2.23 for Na–Cl. This answer comes from treating the metal–nonmetal bond as covalent and leaving it out of the comparison.","Excludes the metal–nonmetal bond from the comparison, assuming only nonmetal pairs are candidates.")],
"New elements (Na, H, S, N, Cl, O), no fluorine; same task but distractors target add-instead-of-subtract, highest-EN-atom, and metal-excluded errors.","numeric")
add(s+"-v2",s,"hard","Rank ionic character",
"Using Pauling electronegativities (K = 0.82, Si = 1.90, P = 2.19, H = 2.20, S = 2.58, Br = 2.96, Cl = 3.16), which ranking lists the bonds in order of INCREASING ionic character?\n\nA. P–H < S–Cl < Si–Cl < K–Br\nB. K–Br < Si–Cl < S–Cl < P–H\nC. K–Br < P–H < Si–Cl < S–Cl\nD. S–Cl < Si–Cl < K–Br < P–H",
("P–H < S–Cl < Si–Cl < K–Br",f"Correct. ΔEN values: P–H = {R(d('P','H'))}; S–Cl = {R(d('S','Cl'))}; Si–Cl = {R(d('Si','Cl'))}; K–Br = {R(d('K','Br'))}. Ionic character rises with ΔEN, so the increasing order is P–H, S–Cl, Si–Cl, K–Br."),
[("K–Br < Si–Cl < S–Cl < P–H","This is the order of DEcreasing ionic character (ΔEN 2.14, 1.26, 0.58, 0.01). It results from reading 'increasing' backwards and listing the most ionic bond first.","Reverses the direction of the ranking, giving decreasing instead of increasing ionic character."),
 (f"K–Br < P–H < Si–Cl < S–Cl",f"This ranks by the SUM of the electronegativities (K–Br {R(sm('K','Br'))}, P–H {R(sm('P','H'))}, Si–Cl {R(sm('Si','Cl'))}, S–Cl {R(sm('S','Cl'))}) instead of the difference, which makes the most ionic bond look the least ionic.","Adds the electronegativities instead of subtracting them before ranking."),
 ("S–Cl < Si–Cl < K–Br < P–H","This puts P–H last by treating hydrogen as a metal because it sits in Group 1. The ΔEN for P–H is only 0.01, essentially nonpolar, so it belongs first; the other three are ranked correctly by ΔEN.","Treats hydrogen as a metal because of its group position and so ranks any H-containing bond as most ionic.")],
"Task shape changed to ranking four bonds in increasing order; different atoms (K, Si, P, H, S, Br, Cl); errors are reversed direction, sum, and H-as-metal.","numeric")
add(s+"-v3",s,"medium","Bond with most ionic character",
"A student is asked to predict which bond in a set will behave most like an ionic interaction. Pauling electronegativities: Li = 0.98, Be = 1.57, C = 2.55, Cl = 3.16, I = 2.66, O = 3.44, F = 3.98. Which bond has the greatest ionic character?\n\nA. Be–O\nB. Li–I\nC. C–F\nD. O–Cl",
("Be–O",f"Correct. ΔEN: Be–O = 3.44 − 1.57 = {R(d('Be','O'))}; Li–I = {R(d('Li','I'))}; C–F = {R(d('C','F'))}; O–Cl = {R(d('O','Cl'))}. Be–O has the largest difference, so the greatest ionic character."),
[("Li–I",f"ΔEN for Li–I is 2.66 − 0.98 = {R(d('Li','I'))}, smaller than 1.87. This answer comes from choosing the bond with the lowest-electronegativity (most metallic) atom, Li, rather than computing and comparing differences.","Picks the bond containing the most metallic (lowest electronegativity) atom instead of the largest difference."),
 ("C–F",f"ΔEN for C–F is 3.98 − 2.55 = {R(d('C','F'))}, smaller than 1.87. This answer comes from picking the bond that contains the most electronegative atom (F, 3.98) rather than the largest difference.","Picks the bond containing the most electronegative atom (fluorine) instead of comparing differences."),
 ("O–Cl",f"ΔEN for O–Cl is 3.44 − 3.16 = {R(d('O','Cl'))}, nearly nonpolar. This answer comes from adding the electronegativities (3.44 + 3.16 = {R(sm('O','Cl'))}, the largest sum) instead of subtracting.","Adds the electronegativities instead of subtracting them.")],
"Different atoms; correct bond is not the one with an extreme atom (not the metal with lowest EN and not the F-containing bond), so three attractive heuristics all fail.","numeric")

# ---------------- seed 026 ----------------
s="apchem-mcq-026"
add(s+"-v1",s,"medium","Beyond the octet",
"In its best Lewis structure, which species has a central atom surrounded by more than eight electrons?\n\nA. XeF₂\nB. PCl₃\nC. BF₃\nD. HCN",
("XeF₂","Correct. Xenon (8 valence electrons) forms two Xe–F bonds and keeps three lone pairs: five electron domains and 2(2) + 3(2) = 10 electrons around Xe, an expanded valence shell."),
[("PCl₃","Phosphorus forms three single bonds and keeps one lone pair, giving exactly 8 electrons. Being in period 3 makes expansion possible, not required.","Assumes a period-3 central atom must expand its valence shell."),
 ("BF₃","Boron forms three bonds and has only 6 electrons, an incomplete octet. That is an exception to the octet rule in the opposite direction, not an expanded octet.","Treats any exception to the octet rule as an expanded valence shell."),
 ("HCN","Carbon has a single bond to H (2 electrons) and a triple bond to N (6 electrons): exactly 8. Counting the triple bond's electrons more than once would give a false total above 8.","Over-counts the electrons of a multiple bond around carbon, giving more than eight.")],
"New species (XeF₂, PCl₃, BF₃, HCN); includes electron-deficient and multiple-bond distractors in place of CO₂ and SiCl₄.","conceptual",
["XeF₂: 2 bonds + 3 lone pairs on Xe = 10 electrons","PCl₃: 3 bonds + 1 lone pair on P = 8 electrons","BF₃: 3 bonds on B = 6 electrons","HCN: C has 1 single + 1 triple bond = 8 electrons"])
add(s+"-v2",s,"hard","Electrons around iodine",
"In the best Lewis structure of IF₅, how many electrons surround the central iodine atom?\n\nA. 12 electrons\nB. 10 electrons\nC. 8 electrons\nD. 6 electrons",
("12 electrons","Correct. Iodine has 7 valence electrons; five I–F single bonds use 5 of them, leaving 2 (one lone pair). Around iodine: 5 bonding pairs (10 electrons) + 1 lone pair (2) = 12 electrons, an expanded valence shell."),
[("10 electrons","This counts only the five bonding pairs (5 × 2 = 10) and leaves out iodine's lone pair, which also belongs to the electrons surrounding the central atom.","Omits the lone pair when counting electrons around the central atom."),
 ("8 electrons","This applies the octet rule to iodine. Iodine is in period 5, and five bonds plus a lone pair cannot fit in 8 electrons, so the octet is exceeded.","Forces the octet rule on a central atom that must expand."),
 ("6 electrons","This is the number of electron domains (5 bonds + 1 lone pair = 6), not the number of electrons; each domain holds 2 electrons.","Reports the number of electron domains as the number of electrons.")],
"Task shape changed from choosing a species to counting electrons around a named central atom (IF₅, period 5).","numeric")
add(s+"-v3",s,"hard","Ion with expanded shell",
"Which ion requires its central atom to hold more than eight electrons in its best Lewis structure?\n\nA. ICl₂⁻\nB. NO₃⁻\nC. PH₄⁺\nD. BF₄⁻",
("ICl₂⁻","Correct. Total valence electrons: 7 + 2(7) + 1 = 22. Two I–Cl bonds use 4, leaving three lone pairs on iodine (the rest fill chlorine). Iodine then has 2(2) + 3(2) = 10 electrons."),
[("NO₃⁻","Nitrogen has one N=O and two N–O single bonds: 4 + 2 + 2 = 8 electrons in each resonance form. Counting electrons from several resonance forms together would overstate the total.","Adds electrons from different resonance forms together, exceeding eight."),
 ("PH₄⁺","Phosphorus forms four P–H bonds and has no lone pair: 8 electrons. Being in period 3 does not force expansion.","Assumes a period-3 central atom must expand its valence shell."),
 ("BF₄⁻","Boron forms four B–F bonds and has no lone pair: 8 electrons (the extra electron of the −1 charge is already shared in the fourth bond). Adding that electron on top of eight gives a false 10.","Adds the electron from the negative charge on top of the four bonds.")],
"Ion-based task with a halogen central atom; distractors are resonance, period-3 and ion-charge errors.","conceptual",
["ICl₂⁻: I has 2 bonds + 3 lone pairs = 10 electrons","NO₃⁻: N has 8 electrons","PH₄⁺: P has 4 bonds = 8 electrons","BF₄⁻: B has 4 bonds = 8 electrons"])

# ---------------- seed 027 ----------------
s="apchem-mcq-027"
def fc(v,nb,bond_e): return v-nb-bond_e//2
add(s+"-v1",s,"medium","Central oxygen in ozone",
"In one resonance contributor of ozone, O₃, the central oxygen atom forms one O=O double bond and one O–O single bond and carries one lone pair. What is the formal charge on the central oxygen atom?\n\nA. +1\nB. −2\nC. +3\nD. −1",
("+1","Correct. Central O: 6 valence electrons; 2 nonbonding electrons (one lone pair); 6 bonding electrons (double + single bond), of which half = 3 count. Formal charge = 6 − 2 − 3 = +1."),
[("−2","This is 6 − 2 − 6: subtracting all 6 bonding electrons instead of half of them gives −2.","Subtracts the full number of bonding electrons instead of half."),
 ("+3","This is 6 − 3: leaving the lone-pair electrons out of the count (only the 3 bond electrons are subtracted) gives +3.","Omits nonbonding (lone-pair) electrons from the formal-charge calculation."),
 ("−1","−1 is the formal charge of the singly bonded terminal oxygen (6 − 6 − 1 = −1), not the central oxygen. This answer comes from assigning the terminal atom's value to the central atom.","Reports the formal charge of a different atom in the structure.")],
"Different species (ozone), central rather than terminal atom, and the three wrong values come from different formal-charge counting errors.","numeric")
add(s+"-v2",s,"easy","Nitrogen in nitrate",
"In the Lewis structure of the nitrate ion, NO₃⁻, nitrogen forms one N=O double bond and two N–O single bonds and has no lone pairs. What is the formal charge on nitrogen?\n\nA. +1\nB. −3\nC. +5\nD. −1",
("+1","Correct. Nitrogen has 5 valence electrons, 0 nonbonding electrons, and 8 bonding electrons (double + two single bonds), of which half = 4 count. Formal charge = 5 − 0 − 4 = +1."),
[("−3","This is 5 − 0 − 8: subtracting all 8 bonding electrons instead of half gives −3.","Subtracts the full number of bonding electrons instead of half."),
 ("+5","This is 5 − 0: counting only the valence electrons and ignoring the bonds gives +5.","Forgets to subtract the bonding contribution."),
 ("−1","−1 is the overall charge of the ion, not the formal charge on nitrogen; the −1 is distributed over the oxygen atoms.","Treats the charge on the whole ion as the formal charge on the central atom.")],
"Different species and atom (central N in an ion with no lone pairs); distractors include ion-charge-as-formal-charge.","numeric")
add(s+"-v3",s,"hard","Carbon in carbon monoxide",
"In the Lewis structure of carbon monoxide, CO, the atoms are joined by a triple bond and each atom has one lone pair. What is the formal charge on the carbon atom?\n\nA. −1\nB. +1\nC. 0\nD. −4",
("−1","Correct. Carbon has 4 valence electrons, 2 nonbonding electrons (one lone pair), and 6 bonding electrons (triple bond), of which half = 3 count. Formal charge = 4 − 2 − 3 = −1 (oxygen is +1, so the molecule is neutral)."),
[("+1","+1 is the formal charge of oxygen (6 − 2 − 3 = +1), not carbon. This comes from computing the other atom's value.","Reports the formal charge of the other atom."),
 ("0","This assumes that because CO is neutral each atom must have formal charge zero. The formal charges are −1 and +1 and sum to zero.","Assumes a neutral molecule means every atom has formal charge zero."),
 ("−4","This is 4 − 2 − 6: subtracting all 6 bonding electrons instead of half gives −4.","Subtracts the full number of bonding electrons instead of half.")],
"Diatomic with a triple bond, formal charge on carbon; sign and neutral-molecule traps.","numeric")

# ---------------- seed 028 ----------------
s="apchem-mcq-028"
add(s+"-v1",s,"medium","Shape of XeF₄",
"For XeF₄, which pair correctly gives the arrangement of all electron pairs on xenon, followed by the shape of the molecule itself?\n\nA. Octahedral, then square planar\nB. Octahedral, then square pyramidal\nC. Trigonal bipyramidal, then seesaw\nD. Octahedral, then tetrahedral",
("Octahedral, then square planar","Correct. Xenon has 8 valence electrons; four Xe–F bonds use 4, leaving 4 (two lone pairs). Six domains give an octahedral arrangement; the two lone pairs sit opposite each other, leaving four F atoms in a square plane."),
[("Octahedral, then square pyramidal","Square pyramidal needs five bonds and one lone pair (as in IF₅). XeF₄ has four bonds and two lone pairs, so the lone pairs occupy opposite positions and the shape is square planar.","Counts only one lone pair on xenon and applies the five-bond, one-lone-pair shape."),
 ("Trigonal bipyramidal, then seesaw","This treats xenon as having five domains (4 bonds + 1 lone pair), as in SF₄. Xenon has two lone pairs, so six domains and an octahedral arrangement.","Counts only one lone pair, giving five domains and the SF₄ pattern."),
 ("Octahedral, then tetrahedral","The six-domain electron-domain geometry is right, but the lone pairs are not removed to form a tetrahedron; opposite lone pairs leave the four F atoms in a flat square, not a tetrahedron.","Assumes four bonded atoms always form a tetrahedral shape regardless of the lone-pair positions.")],
"New species (XeF₄, 6 domains, two lone pairs); distractors target counting one lone pair instead of two and a tetrahedral-by-default shape.","conceptual",
["XeF₄: 4 bonds + 2 lone pairs = 6 domains -> octahedral EDG, square planar shape","IF₅-type: 5 bonds + 1 lone pair -> square pyramidal","SF₄-type: 4 bonds + 1 lone pair -> TBP EDG, seesaw","Square planar, not tetrahedral, for 4 bonds + 2 lone pairs"])
add(s+"-v2",s,"medium","Shape of BrF₃",
"A central bromine atom is bonded to three fluorine atoms in BrF₃. Which pair names the arrangement of all electron pairs on bromine, followed by the shape of the molecule?\n\nA. Trigonal bipyramidal, then T-shaped\nB. Trigonal bipyramidal, then trigonal planar\nC. Tetrahedral, then trigonal pyramidal\nD. Trigonal bipyramidal, then seesaw",
("Trigonal bipyramidal, then T-shaped","Correct. Bromine has 7 valence electrons; three Br–F bonds use 3, leaving 4 (two lone pairs). Five domains give a trigonal bipyramid; both lone pairs sit in equatorial positions, leaving three F atoms in a T-shape."),
[("Trigonal bipyramidal, then trigonal planar","The five-domain geometry is right, but a trigonal planar shape ignores the two lone pairs. With the lone pairs in equatorial positions the F atoms form a T, with angles near 90°, not 120°.","Ignores the effect of lone pairs on the molecular shape and reports the shape of the bonded atoms alone as planar."),
 ("Tetrahedral, then trigonal pyramidal","This counts only one lone pair on bromine (four domains), as in NF₃. Bromine has two lone pairs, so five domains and a T-shaped molecule.","Counts one lone pair, treating the central atom like nitrogen in NF₃."),
 ("Trigonal bipyramidal, then seesaw","Seesaw requires four bonds and one lone pair (as in SF₄). BrF₃ has three bonds and two lone pairs, so the shape is T-shaped.","Uses six valence electrons for bromine, leaving one lone pair and the SF₄ shape.")],
"New species (BrF₃, five domains with two lone pairs, T-shaped); wrong answers mix different lone-pair counts.","conceptual",
["BrF₃: 3 bonds + 2 lone pairs = 5 domains -> TBP EDG, T-shaped","NF₃-type: 3 bonds + 1 lone pair -> tetrahedral EDG, trigonal pyramidal","SF₄-type: 4 bonds + 1 lone pair -> seesaw","Trigonal planar needs 3 domains, no lone pairs"])
add(s+"-v3",s,"hard","Identify molecule from shape",
"A molecule has a central atom with six electron domains and a square pyramidal molecular shape. Which formula could represent the molecule?\n\nA. IF₅\nB. XeF₄\nC. SF₆\nD. PCl₅",
("IF₅","Correct. Iodine has 7 valence electrons; five I–F bonds use 5, leaving 2 (one lone pair). Six domains give an octahedral arrangement and the single lone pair leaves a square pyramid."),
[("XeF₄","XeF₄ has six domains (4 bonds + 2 lone pairs) but a square planar shape, since the two lone pairs sit opposite each other.","Counts only one lone pair on xenon, expecting the five-bond shape."),
 ("SF₆","SF₆ has six bonds and no lone pairs, so its molecular shape is octahedral, not square pyramidal.","Ignores lone pairs: assumes six domains always give a square pyramidal arrangement of bonded atoms."),
 ("PCl₅","PCl₅ has five domains (five bonds, no lone pairs) and is trigonal bipyramidal. It has five bonded atoms, but the question requires six domains.","Equates five bonded atoms with a square pyramid and does not check the number of domains.")],
"Reverse task shape: given EDG domain count and shape, identify the formula; new species set (IF₅, XeF₄, SF₆, PCl₅).","conceptual",
["IF₅: 5 bonds + 1 lone pair = 6 domains -> square pyramidal","XeF₄: 4 bonds + 2 lone pairs -> square planar","SF₆: 6 bonds -> octahedral","PCl₅: 5 domains -> trigonal bipyramidal"])
json.dump(V,open("variants_batch2.json","w"),ensure_ascii=False,indent=1)
print(len(V))
