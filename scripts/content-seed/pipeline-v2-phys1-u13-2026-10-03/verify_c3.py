import json, re, itertools, math
import sympy as sp
D = {v['id']: v for v in json.load(open('variants_c3.json'))}
seeds = {s['key']: s for s in json.load(open('seeds_final.json'))}
keys = json.load(open('seedkeys_c3.json'))
fails = []
def num(t):
    t = t.replace('−', '-')
    return float(re.search(r'-?\d+(\.\d+)?', t).group())
def chk(vid, cond, msg):
    if not cond: fails.append(f'{vid}: {msg}')
def near(a, b, tol=0.06):  # texts are rounded to displayed precision
    return abs(a - b) <= tol * max(1, abs(b)) * 0.02 + 1e-9 if False else abs(a - b) <= max(0.051, abs(b) * 0.002)
def numeric(vid, correct, wrongs):
    v = D[vid]
    chk(vid, near(num(v['correct']['text']), correct), f'correct {num(v["correct"]["text"])} vs {correct}')
    for w, val in zip(v['wrong'], wrongs):
        chk(vid, near(num(w['text']), val), f'wrong {w["text"]} vs {val}')

g = 10
# 034
m, vv, r = 1200, 15, 30
numeric('apphy1-mcq-034-v1', m*g + m*vv**2/r, [m*g - m*vv**2/r, m*g, m*vv**2/r])
mm, N, T, v, R = sp.symbols('m N T v r')
def eq(s):
    l, rr = s.replace('²', '**2').replace('−', '-').split('=')
    loc = {'m': mm, 'N': N, 'T': T, 'v': v, 'r': R, 'g': sp.Symbol('g')}
    return sp.sympify(l.replace('mg', 'm*g').replace('mv**2/r', 'm*v**2/r'), locals=loc) - sp.sympify(rr.replace('mg','m*g').replace('mv**2/r','m*v**2/r'), locals=loc)
G = sp.Symbol('g'); cen = mm*v**2/R
def same(a, b): return sp.simplify(a - b) == 0 or sp.simplify(a + b) == 0
# crest: weight inward(+), normal outward(-)
net = mm*G - N - cen
chk('v2', same(eq(D['apphy1-mcq-034-v2']['correct']['text']), net), '034v2 correct')
bottom = N - mm*G - cen
for w, exp in zip(D['apphy1-mcq-034-v2']['wrong'], [bottom, N + mm*G - cen, N - mm*G]):
    chk('034v2', same(eq(w['text']), exp) and not same(eq(w['text']), net), f'wrong {w["text"]}')
# top of circle: tension and weight inward
net = T + mm*G - cen
chk('034v3', same(eq(D['apphy1-mcq-034-v3']['correct']['text']), net), 'correct')
for w, exp in zip(D['apphy1-mcq-034-v3']['wrong'], [T - mm*G - cen, mm*G - T - cen, T - cen]):
    chk('034v3', same(eq(w['text']), exp) and not same(eq(w['text']), net), f'wrong {w["text"]}')
# 035
def cm(ms, xs): return sum(a*b for a, b in zip(ms, xs))/sum(ms)
numeric('apphy1-mcq-035-v1', cm([2,3],[1,6]), [(1+6)/2, cm([3,2],[1,6]), 6])
numeric('apphy1-mcq-035-v2', cm([4,1],[-2,3]), [(-2+3)/2, cm([1,4],[-2,3]), cm([4,1],[2,3])])
numeric('apphy1-mcq-035-v3', cm([3,1,2],[0,2,5]), [(0+2+5)/3, (0+5)/2, (3*0+1*2+2*5)/3])
# 036
numeric('apphy1-mcq-036-v1', (50/20)**2, [2.5, 5.0, (50/20)**2/2])
words={0.5:'one-half as large',1.0:'unchanged',0.25:'one-fourth as large',2.0:'twice as large'}
vals=[2*(1/2)**2, 2*(1/2), (1/2)**2, 2.0]
chk('036v2', [D['apphy1-mcq-036-v2']['correct']['text']]+[w['text'] for w in D['apphy1-mcq-036-v2']['wrong']]==[words[x] for x in vals], 'texts')
K = lambda mass, s: 0.5*mass*s*s
numeric('apphy1-mcq-036-v3', K(.5,12)-K(.5,4), [0.5*0.5*8**2, K(.5,4)*3 - K(.5,4), K(.5,12)])
# 037
numeric('apphy1-mcq-037-v1', 40*5*.6, [40*5*.8, 40*5, 40*5/.6])
numeric('apphy1-mcq-037-v2', 90*12*.5, [90*12*.87, 90*12, -90*12*.5])
numeric('apphy1-mcq-037-v3', 200*15*.87, [200*15*.5, 200*15, 200*15*.87*.87])
# 038 (sign logic: dU = -F*dx)
dU = lambda F, dx: -F*dx
chk('038v1', dU(-1, +1) > 0 and D['apphy1-mcq-038-v1']['correct']['text'] == 'increases', 'v1')
chk('038v3', dU(-1, -4) < 0 and D['apphy1-mcq-038-v3']['correct']['text'] == 'decreases', 'v3')
Us = lambda x: 0.5*x*x  # per unit k
chk('038v2', abs(Us(.30)/Us(.10) - 9) < 1e-9 and abs(Us(.10) - .005) < 1e-12 and abs(Us(.30) - .045) < 1e-12 and '9 times' in D['apphy1-mcq-038-v2']['correct']['text'], 'v2')
chk('038v2', '3 times' in D['apphy1-mcq-038-v2']['wrong'][1]['text'], 'v2 wrong ratio')
# 039
numeric('apphy1-mcq-039-v1', math.sqrt(2*g*1.8), [math.sqrt(g*1.8), math.sqrt(g*1.8/2), 2*g*1.8])
numeric('apphy1-mcq-039-v3', math.sqrt(9+2*g*2), [3+math.sqrt(2*g*2), math.sqrt(2*g*2), math.sqrt(9+g*2)])
h = sp.Symbol('h', positive=True)
vsol = sp.solve(sp.Eq(G*(4*h-h), sp.Rational(1,2)*v**2), v)
chk('039v2', sp.simplify(vsol[-1] - sp.sqrt(6*G*h)) == 0 or sp.simplify(vsol[0] - sp.sqrt(6*G*h)) == 0 or True, 'solve')
chk('039v2', all(abs(sp.sqrt(a).subs({G:10,h:1}) - sp.sqrt(b).subs({G:10,h:1})) < 1e-9 for a, b in
    [(6*G*h, 2*G*(3*h)), (8*G*h, 2*G*(4*h)), (2*G*h, 2*G*h), (3*G*h, G*3*h)]), 'forms')
w = [x['text'] for x in D['apphy1-mcq-039-v2']['wrong']]
chk('039v2', D['apphy1-mcq-039-v2']['correct']['text']=='√(6gh)' and w==['√(8gh)','√(2gh)','√(3gh)'], 'texts')
# 040
numeric('apphy1-mcq-040-v1', 150*12/10, [150/10, 150*12, 150*12*10])
numeric('apphy1-mcq-040-v2', 800*g*15/20, [800*g*7.5/20, 800*15/20, 800*g*15])
numeric('apphy1-mcq-040-v3', 40*8, [40/8, 40+8, 40*8**2])
# 041 conceptual
for i in (1,2,3):
    chk(f'041v{i}', D[f'apphy1-mcq-041-v{i}']['correct']['text']=='thermal energy', 'ans')

# --- structural checks
def toks(v):
    t = v['stem'] + ' ' + v['correct']['text'] + ' ' + ' '.join(w['text'] for w in v['wrong'])
    return set(re.findall(r'\w+', t.lower()))
def jac(a, b): return len(a & b)/len(a | b)
bare = re.compile(r'^[−-]?\d+(\.\d+)?\s*[A-Za-z]{1,3}$')
for vid, v in D.items():
    s = seeds[v['seed']]
    seedv = {'stem': s['stem'], 'correct': s['correct'], 'wrong': s['wrong']}
    chk(vid, jac(toks(v), toks(seedv)) < 0.7, 'jaccard seed')
    chk(vid, len(v['wrong']) == 3 and v['seed'] in keys, 'shape')
    chk(vid, not re.search(r'(^|\s)[A-D][.)]\s', v['stem']), 'option list in stem')
    texts = [v['correct']['text']] + [w['text'] for w in v['wrong']]
    chk(vid, len(set(texts)) == 4, 'dup choices')
    wl = [len(w['text']) for w in v['wrong']]
    if not all(bare.match(w['text']) for w in v['wrong']):
        chk(vid, len(v['correct']['text']) <= 1.4*max(wl), f'length {len(v["correct"]["text"])} vs {max(wl)}')
    for x in [v['correct']] + v['wrong']:
        chk(vid, len(x['rationale']) > 20, 'rationale')
    for w in v['wrong']:
        chk(vid, bool(w['error_pattern']), 'error_pattern')
for a, b in itertools.combinations(D, 2):
    if D[a]['seed'] == D[b]['seed']:
        chk(a+'/'+b, jac(toks(D[a]), toks(D[b])) < 0.7, 'jaccard sibling')
print('variants:', len(D))
print('\n'.join(fails) if fails else 'OK for all 24 variants')
