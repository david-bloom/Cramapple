import json
M=json.load(open('math_items_prepatch.json')); C=json.load(open('ced_items_prepatch.json'))
STEM={ # variant id -> new stem
'apphycem-mcq-006-v3':"A smooth potential V(x) has a local maximum at x = 1.0 m and a local minimum at x = 3.0 m, with no other stationary points between them. Which statement about E_x is correct?",
'apphycem-mcq-025-v2':"A positive point charge sits just outside one face of an imaginary closed cube, not touching it. What is the total electric flux through the entire surface of the cube due to this outside charge?"}
RAT={ # variant id -> {choice text: new rationale}
'apphycem-mcq-006-v3':{'E_x is zero at both points and negative between them':"The sign between the points is wrong. With no other stationary points, V falls with increasing x from the maximum to the minimum, so dV/dx is negative and E_x = −dV/dx is positive there, not negative.",'E_x is most positive at x = 1.0 m and most negative at x = 3.0 m':"This guesses that E_x peaks where V peaks and bottoms where V bottoms. Because E_x = −dV/dx and the slope of V is zero at both extrema, E_x is zero there; between them V decreases, so E_x is positive."},
'apphycem-mcq-001-v3':{'It increases, because the field at the surface is stronger':"Net flux depends only on the enclosed charge, not on the field strength at the surface. Moving the charges makes the field stronger at some points of the surface and weaker at others, and the external charge's field lines enter and leave, so its net contribution stays zero."},
'apphycem-mcq-005-v3':{
 '+10 V/m for 0 < x < 0.20 m, then +22 V/m for 0.20 m < x < 0.50 m':"These are the ratios V/x at the segment ends (2/0.20 and 11/0.50). The field is the negative of the slope of V in each segment, −ΔV/Δx, not the ratio of V to position.",
 '+30 V/m for 0 < x < 0.20 m, then −40 V/m for 0.20 m < x < 0.50 m':"This pairs the magnitudes with the wrong segments. The steep 8 V drop over 0.20 m gives +40 V/m in the first segment; the 9 V rise over 0.30 m has slope +30 V/m, so the field is −30 V/m in the second."},
'apphycem-mcq-007-v3':{'1/12':"This inverts both factors, as if C were proportional to 1/(A·d) with the area also in the denominator. Capacitance is proportional to A/d, so C₂/C₁ = 4/3."},
'apphycem-mcq-025-v3':{'The net flux becomes negative because the new charge is negative':"Near the outside −Q the field points toward it, so the flux is outward through the part of the surface nearest that charge and inward elsewhere, and these cancel. The outside charge adds zero net flux, so the net remains +Q/ε₀."},
'apphycem-mcq-029-v1':{'Electric field lines always cross every surface at right angles':"Field lines cross an arbitrary surface at all angles. They are perpendicular only to an equipotential surface, such as a conductor's surface in electrostatic equilibrium."},
'apphycem-mcq-030-v1':{'unchanged':"The stored energy does change. Total energy is conserved, but the field does positive work pulling the dielectric in, so the energy stored in the capacitor drops (U = Q²/2C with C larger and Q fixed)."},
'apphycem-mcq-np1-003-v2':{
 '6.0 V/m in the +x direction':"This is the total potential drop 6.0 V with no division by the 3.0 m distance. The field magnitude is the slope's magnitude, 6.0 V/3.0 m = 2.0 V/m.",
 '0.50 V/m in the +x direction':"This inverts the slope, using Δx/ΔV = 3.0/6.0 instead of |ΔV|/Δx. The field magnitude is 6.0 V/3.0 m = 2.0 V/m."},
'apphycem-mcq-np1-006-v1':{'3E_s':"This treats the field as proportional to 1/r (as for a long line charge). Inside a uniformly charged sphere, E increases with r from zero at the center."},
}
n=0
for m in M:
    vid=m['key'][4:]
    if vid in STEM: m['stem']=STEM[vid]; n+=1
    for c in m['choices']:
        t=RAT.get(vid,{})
        if c['text'] in t: m['rationales'][c['label']]=t.pop(c['text']); n+=1
for c in C:
    vid=c['content_key'][4:]
    if vid in STEM: c['stem']=STEM[vid]
assert all(not v for v in RAT.values()),RAT
json.dump(M,open('math_items.json','w'),indent=1,ensure_ascii=False); json.dump(C,open('ced_items.json','w'),indent=1,ensure_ascii=False)
print('patched',n,'edits;',len(set(STEM)|set(RAT)),'variants')
