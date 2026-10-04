import json
M=json.load(open('math_items_prepatch.json'))
P={ # variant id -> {choice text (exact): new rationale}
'apphycm-mcq-001-v1':{'16 m/s²':"This is the numerical value of the velocity, v(2.0) = 2(2.0)³ = 16 m/s, so it would have units of m/s rather than m/s². Acceleration requires differentiating v(t) before substituting the time."},
'apphycm-mcq-021-v2':{'5Dt³':"Differentiating 5Dt⁴ without bringing down the exponent 4 gives 5Dt³. The second differentiation must multiply by 4 to give 20Dt³."},
'apphycm-mcq-018-v2':{'Zero':"The force is zero at x = L, but work depends on the force at every point along the path. The force is positive for 0 ≤ x < L, so the work is positive."},
'apphycm-mcq-018-v3':{'F₀L/8':"This takes the magnitude of the antiderivative at x = L, F₀L³/(2(2L)²) = F₀L/8, as the lower-limit term. The path starts at x = 0, where that term is F₀L³/(2L²) = F₀L/2."},
'apphycm-mcq-025-v3':{'3.2 m':"This is v₀b/m = (8.0)(2.0)/5.0 = 3.2, which has units of acceleration (m/s²), not length, because the ratio of the parameters is inverted. The total distance is v₀m/b = 20 m."},
'apphycm-mcq-026-v3':{'2100 N, directed toward the center':"This multiplies mv² by the radius instead of dividing by it (mv²r ≈ 2132 would not even have units of force). The centripetal force is mv²/r ≈ 950 N."},
'apphycm-mcq-027-v1':{'30 J':"This averages the force at the two endpoints, (3 + 27)/2, and multiplies by 2.0 m. That shortcut is not valid in general for a nonlinear force such as F = 3x², where it gives 30 J while the integral gives 26 J."},
'apphycm-mcq-028-v3':{'32 N in the +x direction':"This forgets the power-rule factor of 2 from x⁻², giving a magnitude 4.0/x³ = 32. Differentiating 4.0x⁻² gives −8.0x⁻³, so F = −dU/dx = +8.0x⁻³ = 64 N."},
'apphycm-mcq-030-v1':{'6.3 W':"This divides the parallel force component by the speed (25 N ÷ 4.0 m/s ≈ 6.3, which is not a power) instead of multiplying. Power is P = F·v = 25 N × 4.0 m/s = 100 W."},
}
STEM={'apphycm-mcq-026-v3':('What is the magnitude of the net force on the ball?','What is the net force on the ball?')}
n=0
for m in M:
    vid=m['key'][4:]
    if vid in STEM:
        assert m['stem'].endswith(STEM[vid][0]); m['stem']=m['stem'][:-len(STEM[vid][0])]+STEM[vid][1]; n+=1
    if vid in P:
        for c in m['choices']:
            if c['text'] in P[vid]: m['rationales'][c['label']]=P[vid].pop(c['text']); n+=1
assert all(not v for v in P.values()),P
json.dump(M,open('math_items.json','w'),indent=1,ensure_ascii=False)
print('patched',n)
