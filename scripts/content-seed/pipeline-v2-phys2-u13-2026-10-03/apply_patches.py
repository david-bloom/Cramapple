import json
M=json.load(open('math_items_prepatch.json'))
P={ # variant id -> {choice text (exact): new rationale}
'apphy2-mcq-002-v1':{
 'Zero':"The internal energy of an ideal gas depends only on its temperature (for a monatomic gas U = 3/2 nRT). The temperature is constant, so ΔU = 0 even though work is done on the gas and energy leaves it as heat.",
 'Positive, because the piston does work on the gas':"Work done on the gas does add energy, but here the water bath removes exactly as much energy as heat as the piston adds as work (Q = −W), so the net change is ΔU = Q + W = 0, not a positive value."},
'apphy2-mcq-021-v2':{
 '3.0 atm':"At constant V and N, P is proportional to the kelvin temperature. Converting with T = T_C + 273, T rises from 27 + 273 = 300 K to 177 + 273 = 450 K, so P = 2.0 atm × 450/300 = 3.0 atm."},
'apphy2-mcq-025-v1':{
 'V ≈ 7.2×10² V; E = 0':"Gets both quantities wrong. It adds the magnitudes of the two potentials (359.6 + 359.6 V) and ignores the negative charge's sign, then cancels the fields as if they were scalars. Potentials add with sign (giving 0 here) and the fields add as vectors (giving a nonzero total)."},
'apphy2-mcq-026-v2':{
 '4.7×10⁶ m/s':"Makes an algebra slip when solving ½mv² = eΔV: it writes v² = eΔV/(2m), leaving the ½ on the wrong side of the equation. The correct step is v² = 2eΔV/m."},
'apphy2-mcq-027-v3':{
 'The 4.0 Ω resistor, three times as much as the 12 Ω resistor':"Uses P = V²/R as if both resistors had the same voltage across them, which is true only in parallel. In series the same current passes through both while the voltage divides, and P = I²R gives more power to the larger resistance."},
'apphy2-mcq-029-v2':{
 '0.7 A':"Treats the 1.2 A as leaving the node. Then 3.0 A in against 1.2 + 2.5 = 3.7 A out leaves a 0.7 A shortfall, which would mean charge enters through the last lead instead of leaving. The 1.2 A is delivered to the node and belongs on the incoming side, giving 4.2 − 2.5 = 1.7 A."},
}
n=0
for m in M:
    vid=m['key'][4:]
    if vid in P:
        for c in m['choices']:
            if c['text'] in P[vid]:
                m['rationales'][c['label']]=P[vid].pop(c['text']); n+=1
assert all(not v for v in P.values()),P
json.dump(M,open('math_items.json','w'),indent=1,ensure_ascii=False)
json.dump({k:v for k,v in {}.items()},open('/dev/null','w'))
print('patched',n)
