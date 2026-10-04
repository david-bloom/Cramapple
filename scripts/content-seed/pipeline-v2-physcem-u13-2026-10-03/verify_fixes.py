"""Authors the 8 repairs; writes repaired_items.json, fix_check_items.json (audit/solve), fix_check_blind.json (blind). Run: python3 verify_fixes.py  (after verify_math.py passes)"""
import json,re
S={c['key']:c for c in json.load(open('seeds_all.json'))['candidate_seeds']}
FIX={
'apphycem-mcq-005':dict(stem="For electrostatics in one dimension, the x-component of the electric field is related to the electric potential V(x) by",
  text={'A':"E_x = dV/dx",'B':"E_x = -dV/dx",'C':"E_x = -V/x",'D':"E_x = ∫V dt"},
  rat={'A':"This drops the negative sign: the field points toward decreasing potential, so E_x = -dV/dx.",
       'B':"The field component is the negative derivative of the potential with respect to position.",
       'C':"This treats the field as the ratio of V to position, which would equal -dV/dx only if V were linear in x and zero at x = 0; in general the field is the derivative of V, not a ratio."}),
'apphycem-mcq-006':dict(stem="At a point on the x-axis where the electric potential V(x) has a stationary point (dV/dx = 0), which statement must be true?",
  text={'A':"The field component E_x is zero there.",'B':"The potential V must equal zero there.",'C':"An infinite charge must be located there.",'D':"The field component E_x must be nonzero there."},
  rat={'A':"Since E_x = -dV/dx, a stationary point of V, where dV/dx = 0, has E_x = 0.",
       'B':"This confuses a vanishing slope of V with the value of V itself being zero; V can have any value at a maximum or minimum.",
       'C':"A stationary point requires only that the slope of V vanish, not an infinite charge source.",
       'D':"This reverses the relation E_x = -dV/dx: a zero slope of V gives a zero field component, not a nonzero one."}),
'apphycem-mcq-007':dict(stem="Capacitance of parallel plates neglecting edges is",
  rat={'C':"This puts ε in the denominator and both A and d in the numerator; capacitance increases with plate area and decreases with plate separation, so A and d cannot both appear in the numerator."}),
'apphycem-mcq-027':dict(stem="With V(∞)=0, point-charge potential is",
  rat={'B':"This has the 1/r² dependence of the point-charge field magnitude k|q|/r², not the 1/r dependence of the potential."}),
'apphycem-mcq-030':dict(stem="A dielectric with κ>1 fully fills a capacitor that remains connected to an ideal battery. Stored energy",
  rat={'D':"With the voltage held fixed by the battery, U = (1/2)CV² changes only through C, which increases by κ, so the stored energy increases by κ; the charge on the plates also increases by κ, but that is already reflected in the factor κ and does not produce an additional κ²."}),
'apphycem-mcq-np1-001':dict(stem=S['apphycem-mcq-np1-001']['stem'],
  rat={'B':"This uses the 1/r² dependence of a spherically symmetric (point-charge) field, which does not apply to a long cylindrical charge distribution, whose field falls off as 1/r.",
       'C':"This leaves the length L in the answer; the enclosed charge λL and the lateral area 2πrL both contain L, so it cancels and the field cannot depend on the arbitrary length of the Gaussian cylinder.",
       'D':"This has the wrong r-dependence (1/r² instead of 1/r) and the wrong numerical factor; the lateral area of the cylinder is 2πrL, giving E = λ/(2πε₀r)."}),
'apphycem-mcq-np1-006':dict(stem=S['apphycem-mcq-np1-006']['stem'],
  rat={'C':"This is half the correct value, as if the factor of 1/2 from r = R/2 were applied a second time to ρr/(3ε₀).",
       'D':"This omits the factor of 1/3: Gauss's law gives E(4πr²) = ρ(4/3)πr³/ε₀, so E = ρr/(3ε₀), not ρr/ε₀; the incorrect form ρr/ε₀ evaluates to ρR/(2ε₀) at r = R/2."}),
'apphycem-mcq-np1-010':dict(stem=S['apphycem-mcq-np1-010']['stem'],
  rat={'C':"This is the flux through a portion of the surface that subtends one steradian (the total flux divided by 4π), not the flux through one face of the cube; a cube face subtends 4π/6 steradians as seen from the center."}),
}
OUT={};AUD=[];BL=[]
for k,f in FIX.items():
    s=S[k]; chs=[]
    for c in s['choices']:
        L=c['choice_key']
        chs.append(dict(choice_key=L,choice_text=f.get('text',{}).get(L,c['choice_text']),is_correct=c['is_correct'],rationale=f.get('rat',{}).get(L,c['rationale'])))
    assert not re.search(r'\n\s*A[\.\)]\s',f['stem'])
    # key letter unchanged
    assert [c['choice_key'] for c in chs if c['is_correct']]==[c['choice_key'] for c in s['choices'] if c['is_correct']]
    if k in ('apphycem-mcq-007','apphycem-mcq-027','apphycem-mcq-030'):
        old=re.sub(r'\n\s*A[\.\)]\s[\s\S]*$','',s['stem']).rstrip(); assert old==f['stem'],(old,f['stem'])
    OUT[k]=dict(keyed=s['keyed_label'],stem=f['stem'],choices=chs)
    AUD.append(dict(key=k,kind='mcq',stem=f['stem'],choices=[dict(label=c['choice_key'],text=c['choice_text']) for c in chs],keyed_label=s['keyed_label'],rationales={c['choice_key']:c['rationale'] for c in chs}))
    BL.append(dict(content_key=k,item_type='mcq',body=f['stem']+"\n\nChoices:\n"+"\n".join(f"{c['choice_key']}. {c['choice_text']}" for c in chs)))
json.dump(OUT,open('repaired_items.json','w'),indent=1,ensure_ascii=False)
json.dump(AUD,open('fix_check_items.json','w'),indent=1,ensure_ascii=False)
json.dump(BL,open('fix_check_blind.json','w'),indent=1,ensure_ascii=False)
print('ok',len(OUT))
