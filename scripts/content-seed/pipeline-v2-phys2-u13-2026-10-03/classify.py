import json
A=json.load(open('seed_analysis.json'))
R={ # key: (class, change)
'002':('REPAIR','Rationale A: replace with "Assumes the gas gains internal energy because it takes in heat while expanding, ignoring that for an ideal gas at constant T the heat absorbed is converted entirely to work." Key/choices unchanged.'),
'003':('REPAIR','Stem/choice grammar: choices are bare verb phrases with no subject. Reword choices to full clauses ("The transfer increases the total entropy of the system", "...decreases the total entropy...", "...violates conservation of energy", "...decreases the entropy of the cold object"). Keep key B. Rationale D: say the cold object entropy rises by Q/Tc, exceeding the hot object loss Q/Th.'),
'004':('REPAIR','Rationale C is false ("neutral object experiences no net electric force at all"; polarisation forces exist). Replace with "A neutral object has no sign of charge, so a force on it cannot define the field direction (any attraction arises only via induced polarisation)." Rationale D: say only that the field is defined by a positive test charge for any charge sign, not "overgeneralizes".'),
'005':('REPAIR','Rationale C is wrong ("stays constant unless charge moves along field lines"): PE changes for motion along/opposite the field and is constant only perpendicular to it. Rewrite: "Would hold only for motion perpendicular to the field (along an equipotential); moving opposite the field requires positive external work." Consider replacing silly distractor D "become mass" with "become negative regardless of the starting value" or similar.'),
'006':('REPAIR','Stem lacks geometry but choices say left/right: add "placed on a horizontal line, one to the left of the other" (or relabel B/C "toward the first/second charge"). Key A unchanged.'),
'007':('OK',''),'008':('OK',''),
'009':('REPAIR','Distractor D "an inductor" (and its rationale) is outside the CED fact pack (inductors not assessed in AP Physics 2); neither checker flagged it. Replace with an in-scope option such as "a resistor of very large resistance" or "an ideal switch left open"; rewrite rationale D accordingly (must not describe inductors). Key B unchanged.'),
'001':('OK',''),'019':('N/A',''),
'021':('OK',''),'022':('OK',''),'023':('OK',''),'024':('OK',''),
'025':('REPAIR','Rationale B talks about potential being constant nearby, but choice B says the FIELD must be constant nearby. Rewrite: "Zero potential at one point says nothing about whether the field is uniform; the field is set by the spatial gradient of V and can vary from point to point." Key C unchanged.'),
'026':('REPAIR','Rationale C and D invoke "W=qΔV" with signed q; for an electron q<0 so the statement is wrong as written. Use |W| = e|ΔV| (or W = qΔV with ΔV signed and negative for the electron moving to higher potential). Key A unchanged.'),
'027':('OK',''),'028':('OK',''),'029':('OK',''),
'030':('REPAIR','Rationale C incorrect: a capacitor acting as a short would give current V/R (series resistor), not infinite. Rewrite: "Infinite current is impossible because the series resistor limits current to at most V/R; the capacitor at long time blocks DC rather than shorting." Key B unchanged.'),
}
math={'001':'P ∝ T at fixed V,n: x2 -> verified (sympy)','002':'conceptual (ΔU=0 isothermal ideal gas)','007':'1/(1/3+1/6)=2 Ω verified','008':'12/3=4 Ω verified','021':'P=NkT/V ∝ N: x2 verified','022':'rate ∝ k: x2 verified','024':'6Q/2=3Q each verified','026':'KE=eΔV (|qΔV|) verified; 1/2 mv² = eΔV consistent','027':'P=V²/R: x4 verified','029':'2.0+3.5=5.5 A verified'}
for k,v in A.items():
    n=k[-3:]; c=R[n]; v['classification']=c[0]; v['repair']=c[1]; v['math_verification']=math.get(n,'no computation required (conceptual)')
    if n in('001','019'): v['classification']='HELD '+('(sound; unit 9, topic %s)'%v['topic'] if n=='001' else '(sound but Unit 15 / topic %s: out of Units 9-11 scope)'%v['topic'])
json.dump(A,open('seed_analysis.json','w'),indent=1,ensure_ascii=False)
