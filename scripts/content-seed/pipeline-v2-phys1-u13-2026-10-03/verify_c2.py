import json, re, math
V = json.load(open('variants_c2.json'))
seeds = {s['key']: s for s in json.load(open('seeds_final.json'))}
g = 10.0
# spec: id -> list of (value, direction-or-None) for correct, wrong1..3, each recomputed from the stated error
S = {}
S['apphy1-mcq-027-v1'] = [(0.5*5.0*18, None), (18*5.0, None), ((0+18)/2, None), (18/5.0, None)]
S['apphy1-mcq-027-v2'] = [((9+3)/2*6.0, None), (9*6.0, None), (3*6.0, None), (0.5*9*6.0, None)]
_t = (8.0-2.0)/1.5
S['apphy1-mcq-027-v3'] = [((2+8)/2*_t, None), (8*_t, None), (2*_t, None), (0.5*8*_t, None)]
def proj(v, h):
    t = math.sqrt(2*h/g)
    return [(v*t, None), (v*math.sqrt(h/g), None), (h, None), (v*h/g, None)]
S['apphy1-mcq-028-v1'] = proj(12, 45)
S['apphy1-mcq-028-v2'] = proj(15, 80)
S['apphy1-mcq-028-v3'] = proj(2.0, 1.25)
# 029: north/east positive
vp, vq = 25, -15
S['apphy1-mcq-029-v1'] = [(abs(vq-vp), 'south'), (abs(vp-vq), 'north'), (abs(25-15), 'south'), (abs(25-15), 'north')]
S['apphy1-mcq-029-v2'] = [(32-2.0, 'east'), (32+2.0, 'east'), (32, 'east'), (2.0, 'west')]
S['apphy1-mcq-029-v3'] = [(abs(9-14), 'south'), (abs(14-9), 'north'), (9+14, 'south'), (9+14, 'north')]
S['apphy1-mcq-031-v1'] = [(8.0/9, None), (8.0/3, None), (8.0*3, None), (8.0*9, None)]
S['apphy1-mcq-031-v2'] = [(800/4, None), (800/2, None), (800*1, None), (800*4, None)]
S['apphy1-mcq-031-v3'] = [(2/2**2, None), (1.0, None), (2.0, None), (1/2**2, None)]  # in units of g_E
N = 50*10.0
S['apphy1-mcq-032-v1'] = [(50*2.0, 'forward'), (0.40*N, 'forward'), (50*2.0, 'backward'), (0, None)]
N3 = 10*10.0
S['apphy1-mcq-032-v3'] = [(35, None), (0.50*N3, None), (0.30*N3, None), (20, None)]
S['apphy1-mcq-033-v1'] = [(150*0.040, 'right'), (150*0.040, 'left'), (150*4.0, 'right'), (0.5*150*0.040**2, 'right')]
mg = 0.50*g
S['apphy1-mcq-033-v2'] = [(mg/0.10, None), (0.50/0.10, None), (2*mg/0.10, None), (mg/0.10**2, None)]
S['apphy1-mcq-033-v3'] = [(120*(0.62-0.50), 'toward'), (120*0.12, 'away'), (120*0.62, 'toward'), (120*0.50, 'toward')]
# sanity on physics preconditions
assert 35 < 0.50*N3 and 20 < 0.50*N3 and 50*2.0 < 0.40*N

def toks(s): return set(re.findall(r"[a-z0-9.]+", s.lower()))
def jac(a, b): return len(a & b)/len(a | b)
def full(v): return v['stem'] + ' ' + v['correct']['text'] + ' ' + ' '.join(w['text'] for w in v['wrong'])

ok_all = True
ids = [v['id'] for v in V]
assert len(V) == 24 and len(set(ids)) == 24
for v in V:
    errs = []
    choices = [v['correct']['text']] + [w['text'] for w in v['wrong']]
    if len(v['wrong']) != 3 or len(set(choices)) != 4: errs.append('choice count/dup')
    if re.search(r'(^|\s)[A-D][.)]\s', v['stem']): errs.append('option list in stem')
    for c in [v['correct']] + v['wrong']:
        if len(c['rationale']) < 30: errs.append('short rationale')
    for w in v['wrong']:
        if not w.get('error_pattern'): errs.append('no error_pattern')
    # length rule
    bare = all(re.fullmatch(r'[\d.]+\s*[A-Za-z/^0-9 ]*', w['text']) and len(w['text']) < 14 for w in v['wrong'])
    if not bare and len(v['correct']['text']) > 1.4*max(len(w['text']) for w in v['wrong']): errs.append('correct too long %d vs %d' % (len(v['correct']['text']), max(len(w['text']) for w in v['wrong'])))
    # jaccard
    jv = [jac(toks(full(v)), toks(full(o))) for o in V if o['id'] != v['id'] and o['seed'] == v['seed']]
    sd = seeds[v['seed']]
    seedtxt = sd['stem'] + ' ' + sd['correct']['text'] + ' ' + ' '.join(w['text'] for w in sd['wrong'])
    js = jac(toks(full(v)), toks(seedtxt))
    if max(jv + [js]) >= 0.7: errs.append('jaccard %.2f' % max(jv + [js]))
    # numeric
    if v['check'] == 'numeric':
        spec = S[v['id']]
        for (val, d), txt in zip(spec, choices):
            if txt.startswith('g_E'):
                num, tol = {'g_E': 1.0, 'g_E / 2': 0.5, '2 g_E': 2.0, 'g_E / 4': 0.25}[txt], 1e-9
                if txt == '2 g_E': num = 2.0
            else:
                m = re.search(r'[\d.]+', txt)
                num = float(m.group())
                dec = len(m.group().split('.')[1]) if '.' in m.group() else 0
                tol = 0.5*10**(-dec) + 1e-9
            if abs(num - val) > tol:
                errs.append('value mismatch %s vs %.4g' % (txt, val))
            if d and d not in txt: errs.append('direction mismatch ' + txt)
    print('OK' if not errs else 'FAIL', v['id'], errs if errs else '', ' maxJ=%.2f' % max(jv + [js]))
    ok_all &= not errs
print('ALL OK' if ok_all else 'SOME FAIL')
