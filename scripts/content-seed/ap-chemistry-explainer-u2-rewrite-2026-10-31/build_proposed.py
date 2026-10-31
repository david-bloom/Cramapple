import json, re, sys
d = json.load(open('current_dev.json'))
cur = {r['topic_code']: r for r in d}
NEW = {
'2.1': dict(
 core_idea="Electrons are shared unequally, with greater inequality generally accompanying a larger electronegativity difference, so bonding runs on one continuous scale from nonpolar to ionic. No cutoff separates the types: every polar bond has some ionic character, and C-H, with a small real difference, is treated as effectively nonpolar.",
 what_students_need_to_understand="Metal/nonmetal is only a shortcut: use observed properties when they are given. Electronegativity predicts bond polarity, but molecular polarity (2.7) also needs geometry. For ionic attractions (2.2, 2.3) use the ions' actual charges and separation. Metals differ because valence electrons are delocalized (2.4).",
 how_this_becomes_points="Name the bond type, support it with an explicit electronegativity comparison (which atom pulls harder, which carries delta-negative), then confirm with a property: conductivity when molten or dissolved, melting point, or brittleness versus malleability."),
'2.2': dict(
 core_idea="On a potential energy vs internuclear distance graph, the minimum marks the equilibrium bond length and the depth of the well below the separated-atom baseline (zero) is the bond energy. Higher bond order gives a shorter bond and a larger bond energy together; for ion pairs, Coulomb's law ties strength to charge size and distance.",
 what_students_need_to_understand="This turns a bonding label into numbers you can rank and defend. It returns in lattice-energy comparisons, bond-length and bond-energy rankings in 2.7, and bond-energy arguments in later thermodynamics, and it is one of the few Unit 2 ideas tested as graph reading.",
 how_this_becomes_points="Read bond length from the minimum's x-value and bond energy from the well depth. Rank length and energy together by bond order (shorter goes with larger energy). For ions, cite both charge magnitude and internuclear distance, never one alone."),
'2.3': dict(
 core_idea="Cations and anions form one extended, repeating three-dimensional array that maximizes attraction and minimizes repulsion across the whole lattice. Properties follow from that alternating array, not from named crystal types, which the exam does not assess.",
 what_students_need_to_understand="Hardness, brittleness, high melting point, and conduction only when molten or dissolved all trace back to this one picture. It links the Coulomb's-law reasoning of 2.2 to bulk properties in Unit 3, though its own exam weight is narrower than Lewis diagrams and VSEPR.",
 how_this_becomes_points="Two moves earn the point: state that the solid is one extended, repeating array of alternating charges, then link a named property to it. High melting point: many strong attractions throughout need a lot of energy to overcome. Brittleness: a shifted layer lines up like charges and repulsion cracks the crystal."),
'2.4': dict(
 core_idea="A metal is a lattice of positive ions in a delocalized sea of valence electrons. Alloys can hinder layer sliding while retaining mobile delocalized electrons: interstitial alloys (steel, small C atoms in iron's gaps) block sliding and are harder and less malleable yet still conduct; substitutional alloys swap in atoms of similar size.",
 what_students_need_to_understand="Delocalization from 2.1 now explains observable behavior: conductivity, malleability, luster. Atomic radius from Unit 1 tells the two alloy types apart, and the interstitial-versus-substitutional size argument is a clean, frequently testable call.",
 how_this_becomes_points="Cite mobile delocalized electrons for conductivity, and layers sliding while the electron sea holds them together for malleability. Classify an alloy by comparing the two atoms' radii: very different is interstitial, comparable is substitutional.",
 point_attaining_answer="Steel is interstitial: carbon's atomic radius is much smaller than iron's, so carbon sits in gaps between iron atoms. Brass is substitutional: zinc's radius is comparable to copper's, so zinc replaces copper at lattice positions. The types differ because classification rests on the radius comparison, not on both being metal mixtures. Steel still conducts, since interstitial atoms block layer sliding but mobile delocalized electrons remain, although alloying can change its electrical resistance."),
'2.5': dict(
 core_idea="A Lewis diagram is valence-electron bookkeeping done by a fixed procedure: total the valence electrons (add one per unit of negative charge, subtract one per unit of positive), place bonds and lone pairs to satisfy octets, and convert a lone pair into an extra bond when a central atom is short.",
 what_students_need_to_understand="The usual failure is the count, not the drawing: a missed ion charge or an undrawn lone pair changes the total, and every answer that starts from this diagram (resonance, formal charge, shape) inherits the error. Check the count against your picture before building on it.",
 how_this_becomes_points="The diagram is complete and correct: the electron total matches the formula (charge-adjusted for ions), every bonding pair and lone pair is drawn, octets are met where required, and an ion is bracketed with its charge outside.",
 point_attaining_answer="Carbon gives 4 and each of three oxygens gives 6, so 4 + 18 = 22, plus 2 for the 2- charge makes 24. With carbon central, one C=O and two C-O bonds use 8 electrons, leaving 16 as lone pairs: the double-bonded oxygen has 2 pairs and each single-bonded oxygen has 3. Every atom has an octet. Enclose the diagram in brackets with 2- outside."),
'2.6': dict(
 core_idea="Formal charge = valence electrons minus lone-pair electrons minus half the bonding electrons. Together with octet requirements, it selects among nonequivalent Lewis structures, while equivalent structures are averaged as resonance. The Lewis model has limits: it cannot cleanly represent odd-electron species.",
 what_students_need_to_understand="Resonance forms are alternative drawings, not successive states: never say a double bond moves back and forth. That is why both N-O bonds in nitrite are identical, and formal charge is the tool that picks which of several legal diagrams to reason from.",
 how_this_becomes_points="For equivalent structures, draw all forms, reject switching, and state the real structure is one average: nitrite's N-O bond order is (1 + 2)/2 = 1.5, so both bonds are equal. For nonequivalent ones, check octets, then compute formal charge: minimize it, negative on the more electronegative atom."),
'2.7': dict(
 core_idea="VSEPR counts regions of electron density (each lone pair or bond, however many lines, is one) to predict geometry, ideal electron-region angles (sp 180, sp2 120, sp3 109.5 degrees; actual bond angles can differ) and hybridization. Off the exam: deriving hybrid orbitals, d-orbital hybridization (over four regions: shape only), molecular orbital theory.",
 what_students_need_to_understand="Geometry is the payoff of the unit and the gateway to Unit 3: polarity, solubility and boiling point depend on shape plus bond dipoles. Hybridization identification scored a mean of only 0.56 of 1.0 on the 2025 free-response item, mainly from counting C=O as two regions.",
 how_this_becomes_points="Count regions (a lone pair is one, a double or triple bond is one), name the geometry from atom positions only, and give the matching angle. Assign sp, sp2 or sp3 from the same count only if asked. For polarity, combine bond dipoles with the geometry to test whether they cancel.",
 point_attaining_answer="Carbon has three regions: two C-H bonds and one C=O double bond, which counts as one. Three regions means trigonal planar geometry, about 120 degrees, and sp2 hybridization, not sp3. The costly error on the 2025 free-response item (mean 0.56 of 1.0) was counting C=O as two domains, giving four domains and sp3.",
 practice_bridge="In practice, count regions first, collapsing each double or triple bond to one, before assigning sp, sp2 or sp3; never use d-orbital or MO-theory language."),
}
CAPS = dict(core_idea=360, what_students_need_to_understand=360, how_this_becomes_points=320, point_attaining_answer=520, practice_bridge=220)
SW=set('the and for that this with from are is was were you your its not but can will have has how why what when which into than then they them their also each every more most only over such use used using one two all any may must should would could about between because before after while where there these those does did been being both either other some same so of to in on at by as or an a be it'.split())
def toks(s):
    s=re.sub(r'\$[^$]*\$',' ',s or ''); s=re.sub(r'[^a-zA-Z ]',' ',s.lower())
    return {t for t in s.split() if len(t)>2 and t not in SW}
def ovl(a,b):
    A,B=toks(a),toks(b)
    if len(A)<8 or len(B)<8: return None
    return len(A&B)/min(len(A),len(B))
FIELDS=['core_idea','what_students_need_to_understand','how_this_becomes_points','answer_move','mini_example_question','weak_answer','point_attaining_answer','common_point_loss','practice_bridge']
out=[]; bad=0
for tc in sorted(cur):
    c=cur[tc]; n={f:NEW.get(tc,{}).get(f,c[f]) for f in FIELDS}
    row=dict(topic_code=tc,title=c['title'],**n)
    out.append(row)
    for f,cap in CAPS.items():
        L=len(n[f]); flag='' if L<=cap else '  <-- OVER'
        if L>cap: bad+=1
        print(f'{tc} {f:34s} {len(c[f]):4d} -> {L:4d} (cap {cap}){flag}')
    pairs=[('core_idea','b_what_it_is'),('what_students_need_to_understand','b_why_it_matters'),('how_this_becomes_points','b_how_points_are_earned')]
    print('   overlap vs brief twin:', {f:(None if ovl(n[f],c[b]) is None else round(ovl(n[f],c[b]),2)) for f,b in pairs}, ' old:', {f:(None if ovl(c[f],c[b]) is None else round(ovl(c[f],c[b]),2)) for f,b in pairs})
json.dump(out,open('proposed.json','w'),indent=1,ensure_ascii=False)
print('OVER-CAP COUNT',bad)
