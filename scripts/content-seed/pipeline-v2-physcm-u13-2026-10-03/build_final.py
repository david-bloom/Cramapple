"""Authors the 4 PCM repairs + strip-only versions for the other 13 in-scope seeds.
Writes repaired_items.json, stripped_items.json, strip_diff.txt, final_check_items.json (audit/solve), final_check_blind.json (blind).
Run: python3 build_final.py"""
import json,re,hashlib,difflib
S={c['key']:c for c in json.load(open('seeds_all.json'))['candidate_seeds']}
RX=r'\n\s*A[\.\)]\s[\s\S]*$'
# numeric/calculus sanity (full checks in sympy_keys.py)
import sympy as sp
t=sp.symbols('t'); assert sp.diff(3*t**2,t).subs(t,2)==12; assert sp.diff(sp.symbols('C')*t**4,t,3)==24*sp.symbols('C')*t
REPAIR_KEYS=['001','002','003','006','017','021','027','030']
FIX={
'001':dict(stem="If v(t)=3t² in SI units, the acceleration at t=2 s is",
  rat={'A':"Reads the coefficient 3 in v(t)=3t² as the acceleration itself, as if v were proportional to t, instead of differentiating v(t) with respect to time."}),
'002':dict(rat={'D':"Divides the constant k by T, a quantity with units of acceleration per unit time, instead of integrating the velocity over the interval; it is not a displacement.",'A':"Gives the final velocity v(T)=kT, which has units of speed rather than displacement; displacement requires integrating the linearly increasing velocity over the interval."}),
'003':dict(rat={'D':"Divides the force gradient a by L instead of integrating the force over the displacement; integrating ax always produces a term proportional to L², never a/L."}),
'027':dict(rat={'C':"Averaging the endpoint forces is not valid for every F(x); it equals the integral only in special cases such as a force that is linear in position, so the word 'always' makes this false."}),
'030':dict(rat={'D':"Power is the rate of work, F·v; the product of force and acceleration F·a does not have units of power and is not the rate of energy transfer."}),
'006':dict(rat={'C':"Divides U by x instead of differentiating; -U/x equals -dU/dx only when U is directly proportional to x, so it is wrong for a general potential energy function.",'D':"This differentiates U twice. The second derivative is the curvature (stiffness) of the potential well and equals minus the rate of change of the force with position; it is not the force itself, which is −dU/dx."}),
'017':dict(rat={'D':"Gives only the cubic term At³ and drops the −Bt term; no derivative has been taken, so this is not a velocity expression at all."}),
'021':dict(rat={'C':"This differentiates a third time, one differentiation too many: d³x/dt³ = 24Ct."}),
}
INSCOPE=['001','002','003','006','007','008','017','018','021','022','024','025','026','027','028','029','030']
R={};ST={};AUD=[];BL=[];D=[]
for n in INSCOPE:
    k='apphycm-mcq-'+n; s=S[k]
    assert re.search(r'\n\s*A[\.\)]\s',s['stem'])
    base=re.sub(RX,'',s['stem']).rstrip()
    tail=s['stem'][len(base):].strip()
    assert tail=="\n".join(f"{c['choice_key']}. {c['choice_text']}" for c in s['choices']),(k,tail)
    f=FIX.get(n,{})
    stem=f.get('stem',base)
    chs=[dict(choice_key=c['choice_key'],choice_text=f.get('text',{}).get(c['choice_key'],c['choice_text']),is_correct=c['is_correct'],rationale=f.get('rat',{}).get(c['choice_key'],c['rationale'])) for c in s['choices']]
    assert [c['choice_key'] for c in chs if c['is_correct']]==[s['keyed_label']]
    assert not re.search(r'\n\s*A[\.\)]\s',stem) and len(stem)>=12
    rec=dict(keyed=s['keyed_label'],old_md5=hashlib.md5(s['stem'].encode()).hexdigest(),stem=stem,choices=chs)
    if n in REPAIR_KEYS: R[k]=rec
    else: ST[k]=dict(keyed=rec['keyed'],old_md5=rec['old_md5'],stem=stem)
    D.append(f"== {k} ({'REPAIR' if n in REPAIR_KEYS else 'strip-only'})\n"+"\n".join(difflib.unified_diff(s['stem'].split('\n'),stem.split('\n'),'old','new',lineterm='',n=0)))
    for c,o in zip(chs,s['choices']):
        if c['choice_text']!=o['choice_text'] or c['rationale']!=o['rationale']: D.append(f"  choice {c['choice_key']} changed:\n   - {o['choice_text']} | {o['rationale']}\n   + {c['choice_text']} | {c['rationale']}")
    AUD.append(dict(key=k,kind='mcq',stem=stem,choices=[dict(label=c['choice_key'],text=c['choice_text']) for c in chs],keyed_label=s['keyed_label'],rationales={c['choice_key']:c['rationale'] for c in chs}))
    BL.append(dict(content_key=k,item_type='mcq',body=stem+"\n\nChoices:\n"+"\n".join(f"{c['choice_key']}. {c['choice_text']}" for c in chs)))
json.dump(R,open('repaired_items.json','w'),indent=1,ensure_ascii=False)
json.dump(ST,open('stripped_items.json','w'),indent=1,ensure_ascii=False)
json.dump(AUD,open('final_check_items.json','w'),indent=1,ensure_ascii=False)
json.dump(BL,open('final_check_blind.json','w'),indent=1,ensure_ascii=False)
open('strip_diff.txt','w').write("\n".join(D)+"\n")
print(len(R),len(ST)); print(open('strip_diff.txt').read())
