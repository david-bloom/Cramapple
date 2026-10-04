import json
A=json.load(open('seed_analysis.json'))
R=json.load(open('repaired_items.json')); ST=json.load(open('stripped_items.json'))
HELD={'apphycem-mcq-003':'HELD, sound (probed 8.6, unit 8); not in SQL','apphycem-mcq-016':'HELD, sound but probed Unit 13 (13.2), outside Units 8-10; not in SQL','apphycem-mcq-019':'HELD, NOT sound: differential-form Gauss (div E, Dirac delta) is outside the CED fact pack and the stem gives away the answer (all 4 checkers); recommend retire; not in SQL','apphycem-mcq-np1-005':'HELD, key correct and verified (probed 10.3, unit 10) but rationale B is inaccurate (the coaxial radial gap b-a is uniform); would need a rationale repair before any release; not in SQL'}
CH={'apphycem-mcq-005':'Stem and choices recast from 3-D gradient/curl notation (outside the CED) to the CED 1-D relation E_x=-dV/dx; choice C (curl of a scalar) replaced; inline A-D list removed',
'apphycem-mcq-006':'Stem recast to 1-D stationary point (dV/dx=0 -> E_x=0); gradient/curl choices replaced; inline list removed',
'apphycem-mcq-007':'Rationale C was wrong (said "inverting" the ratio); fixed; inline list removed',
'apphycem-mcq-027':'Rationale B misdescribed kq/r^2 as the signed field; fixed; inline list removed',
'apphycem-mcq-030':'Rationale D implied charge does not change; clarified; inline list removed',
'apphycem-mcq-np1-001':'Rationales B, C, D reworded (inaccurate error stories)',
'apphycem-mcq-np1-006':'Rationales C, D replaced (contrived/incorrect distractor stories); found by author, not flagged by checkers',
'apphycem-mcq-np1-010':'Rationale C wrongly said Q/(4 pi eps0) is not a flux; now identified as flux per steradian'}
for k,v in A.items():
    if k in HELD: v['classification']=HELD[k]; v['change']=''
    elif k in R: v['classification']='REPAIR'; v['change']=CH[k]
    elif k in ST: v['classification']='OK (strip-only new version)'; v['change']='inline A-D list removed from stem; nothing else'
    else: v['classification']='OK'; v['change']=''
    v['math_verification']='see verify_math.py'
json.dump(A,open('seed_analysis.json','w'),indent=1,ensure_ascii=False)
import collections; print(collections.Counter(v['classification'].split(',')[0] for v in A.values()))
