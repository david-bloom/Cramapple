"""Authors the 9 Physics 2 repairs; writes repaired_items.json, fix_check_items.json (audit/solve), fix_check_blind.json (blind).
Run: python3 verify_fixes.py"""
import json
S={c['key']:c for c in json.load(open('seeds_all.json'))['candidate_seeds']}
# numeric sanity: entropy of heat transfer Q from hot Th to cold Tc: dS = Q/Tc - Q/Th > 0 for Tc<Th
for Q,Th,Tc in [(100,400,300),(5,600,300)]: assert Q/Tc-Q/Th>0
# electron: q=-e, moves to higher potential (dV>0): dU=q*dV<0, dK=-dU=e*dV>0 ; |W|=e|dV|
e=1.602e-19; dV=100.0; dU=-e*dV; dK=-dU; assert dK>0 and abs(dK-e*dV)<1e-30
# 009: t=0 uncharged capacitor: V_C=0 -> I=V/R (wire); long time I->0
V,R=9.0,1000.0; assert V/R==0.009
FIX={
'apphy2-mcq-002':dict(stem="During an isothermal expansion of an ideal gas, its internal-energy change is",
  rat={'A':"Assumes the gas gains internal energy because it takes in heat while expanding, ignoring that for an ideal gas at constant temperature the heat absorbed is converted entirely to work."}),
'apphy2-mcq-003':dict(stem="Which of the following best explains why energy is spontaneously transferred from a hot object to a cold object?",
  text={'A':"The transfer decreases the total entropy of the system",'B':"The transfer increases the total entropy of the system",'C':"The transfer violates conservation of energy",'D':"The transfer decreases the entropy of the cold object"},
  rat={'D':"Reverses the actual effect: heat flowing into the cold object increases its entropy, and because the cold object is at the lower temperature (ΔS ≈ Q/T_c for a small transfer) that increase is larger than the hot object's decrease (≈ Q/T_h), so the total entropy increases."}),
'apphy2-mcq-004':dict(stem="The electric field direction at a point is the direction of force on",
  rat={'C':"A neutral object has no sign of charge, so the force on it cannot define the field direction, whereas the field direction is defined by the force on a positive test charge.",
       'D':"Treats the definition as applying to one particular particle. The field direction is defined by the force on a positive test charge, whatever the sign of the charges that create the field; the force on an electron points opposite to the field."}),
'apphy2-mcq-005':dict(stem="Moving a positive charge opposite a uniform electric field causes electric potential energy to",
  text={'D':"become negative regardless of the starting value"},
  rat={'B':"Moving a positive charge opposite the field requires positive work by an external force, so the electric potential energy of the charge increases.",'C':"Potential energy would stay constant only for motion perpendicular to the field (along an equipotential). Moving opposite the field requires positive work by an external force, so the potential energy changes.",
       'D':"Assumes the change always produces a negative value. Moving against the field adds energy equal to the positive external work, so the potential energy rises from whatever it was; the sign of the final value depends on the starting value and the reference point."}),
'apphy2-mcq-006':dict(stem="Two identical positive point charges are placed on a horizontal line, one to the left of the other. At the midpoint between them, the electric field is"),
'apphy2-mcq-009':dict(stem="Immediately after an uncharged capacitor is connected through a resistor to a battery, the capacitor behaves approximately like",
  text={'D':"a resistor with the same resistance as the series resistor"},
  rat={'D':"Treats the capacitor as additional resistance that limits the current. At the first instant the uncharged capacitor has zero potential difference, so it adds no opposition and the current is set by the resistor alone, battery voltage divided by R."}),
'apphy2-mcq-025':dict(stem="At a point where electric potential is zero, the electric field",
  rat={'B':"Zero potential at one point says nothing about whether the field is uniform. The field is set by how quickly the potential changes with position, and that can differ from point to point near the zero-potential point."}),
'apphy2-mcq-026':dict(stem="An electron accelerated from rest through a potential difference of magnitude ΔV gains kinetic energy equal to",
  rat={'C':"This introduces an unnecessary factor of two. The magnitude of the electric potential-energy change is |q|ΔV = eΔV, and by conservation of energy that equals the kinetic energy gained.",
       'D':"This is the signed potential-energy change, not the kinetic-energy gain. The electron (q = −e) moves to higher potential, so ΔU = qΔV = −eΔV; conservation of energy gives ΔK = −ΔU = +eΔV, and kinetic energy gained from rest cannot be negative."}),
'apphy2-mcq-030':dict(stem="A capacitor in series with a resistor has been connected to a DC battery for a very long time. The circuit current is",
  rat={'C':"Infinite current is impossible here: the series resistor limits the current to at most V/R even if the capacitor were treated as a short, and at long times the fully charged capacitor blocks DC current rather than shorting it."}),
}
OUT={};AUD=[];BL=[]
for k,f in FIX.items():
    s=S[k]; chs=[]
    for c in s['choices']:
        L=c['choice_key']
        chs.append(dict(choice_key=L,choice_text=f.get('text',{}).get(L,c['choice_text']),is_correct=c['is_correct'],rationale=f.get('rat',{}).get(L,c['rationale'])))
    import re
    assert not re.search(r'\n\s*A[\.\)]\s',f['stem'])
    OUT[k]=dict(keyed=s['keyed_label'],stem=f['stem'],choices=chs)
    AUD.append(dict(key=k,kind='mcq',stem=f['stem'],choices=[dict(label=c['choice_key'],text=c['choice_text']) for c in chs],keyed_label=s['keyed_label'],rationales={c['choice_key']:c['rationale'] for c in chs}))
    body=f['stem']+"\n\nChoices:\n"+"\n".join(f"{c['choice_key']}. {c['choice_text']}" for c in chs)
    BL.append(dict(content_key=k,item_type='mcq',body=body))
json.dump(OUT,open('repaired_items.json','w'),indent=1,ensure_ascii=False)
json.dump(AUD,open('fix_check_items.json','w'),indent=1,ensure_ascii=False)
json.dump(BL,open('fix_check_blind.json','w'),indent=1,ensure_ascii=False)
print('ok',len(OUT))
