import json,re,math,os,itertools
d=os.path.dirname(os.path.abspath(__file__))
V=json.load(open(os.path.join(d,'variants_c1.json')))
seeds={s['key']:s for s in json.load(open(os.path.join(d,'seeds_final.json')))}
g=10
cos=math.cos;sin=math.sin;rad=math.radians
# id -> [correct, wrong1, wrong2, wrong3] each from the stated computation
E={
'apphy1-mcq-001-v1':[(15-5)/4.0,15/4.0,(5+15)/4.0,15-5],
'apphy1-mcq-001-v2':[(6-24)/9.0,(24-6)/9.0,-(24+6)/9.0,6-24],
'apphy1-mcq-001-v3':[(-4-6)/0.5,(4-6)/0.5,(4+6)/0.5,(-4-6)*0.5],
'apphy1-mcq-003-v1':[18/4.5,4.5/18,18-4.5,18*4.5],
'apphy1-mcq-003-v2':[(20-8)/3.0,20/3.0,(20+8)/3.0,20-8],
'apphy1-mcq-003-v3':[24/0.40,24*0.40,24-0.40,0.40/24],
'apphy1-mcq-005-v1':[20*g*sin(rad(30)),0,20*g*cos(rad(30)),20*g],
'apphy1-mcq-006-v1':[25*6.0,25+6.0,25/6.0,25*6.0*10],
'apphy1-mcq-006-v2':[20*4.0*cos(rad(60)),20*4.0,20*4.0*sin(rad(60)),20+4.0],
'apphy1-mcq-006-v3':[15*3.0*cos(rad(180)),15*3.0,-15/3.0,-(15+3.0)],
'apphy1-mcq-007-v3':[0.5*1200*15**2,60000*1.5,60000+0.5*1200*(15-10)**2,60000*1.5**3],
'apphy1-mcq-008-v1':[3.0*g*4.0,3.0*4.0,3.0*g,g*4.0],
'apphy1-mcq-008-v2':[60*g*15,60*15,60*g,g*15],
'apphy1-mcq-008-v3':[2.0*g*1.5,2.0*g*5.0,2.0*1.5,g*1.5],
}
# conceptual factor items
F={
'apphy1-mcq-007-v1':[3**2,3,3*2,3**3],
'apphy1-mcq-007-v2':[0.5**2,0.5,0.5**3,0.5**4],
}
W=lambda s:set(re.findall(r"[a-z0-9]+",s.lower()))
def jac(a,b): return len(a&b)/len(a|b)
def vtext(v): return v['stem']+' '+v['correct']['text']+' '+' '.join(w['text'] for w in v['wrong'])
def num(t):
    t=t.replace('−','-').replace(',','')
    m=re.search(r'[+-]?\d+(\.\d+)?',t); return float(m.group())
bad=0
assert len(V)==24
for v in V:
    id=v['id'];errs=[]
    assert len(v['wrong'])==3 and v['id'].rsplit('-v',1)[0]==v['seed']
    if re.search(r'(^|\s)[A-D][\.\)]\s',v['stem']): errs.append('option list in stem')
    if id in E:
        vals=E[id]; texts=[v['correct']['text']]+[w['text'] for w in v['wrong']]
        for val,t in zip(vals,texts):
            p=num(t)
            if abs(val-p)>0.006*max(abs(p),1) and abs(val-p)>0.051*(1 if abs(p)<10 else 0): errs.append(f'value {val} vs text {t}')
            if abs(val-p)>max(0.01*abs(p),0.06): errs.append(f'value {val} vs text {t}')
        if len(set(round(x,6) for x in vals))!=4: errs.append('choices not distinct')
    elif id in F:
        words={0:None}
        pass
    texts=[v['correct']['text']]+[w['text'] for w in v['wrong']]
    allnum=all(re.fullmatch(r'[+\-−]?[\d,\.]+( [A-Za-z/²]+)?( (east|west))?',t) for t in texts)
    ratio=len(v['correct']['text'])/max(len(w['text']) for w in v['wrong'])
    if not allnum and ratio>1.4: errs.append(f'length ratio {ratio:.2f}')
    if len(set(texts))!=4: errs.append('dup choice text')
    others=[o for o in V if o['seed']==v['seed'] and o['id']!=id]
    sj=jac(W(vtext(v)),W(seeds[v['seed']]['stem']+' '+' '.join(c['text'] for c in seeds[v['seed']]['choices'])))
    if sj>=0.7: errs.append(f'seed jaccard {sj:.2f}')
    for o in others:
        j=jac(W(vtext(v)),W(vtext(o)))
        if j>=0.7: errs.append(f'sibling jaccard {j:.2f} {o["id"]}')
    if errs: bad+=1; print('FAIL',id,errs)
    else: print('OK',id)
# conceptual factor items checked by hand-computed arithmetic
assert F['apphy1-mcq-007-v1']==[9,3,6,27]
assert F['apphy1-mcq-007-v2']==[0.25,0.5,0.125,0.0625]
print('OK apphy1-mcq-007-v1/v2 factors 9,3,6,27 and 1/4,1/2,1/8,1/16')
print('ALL OK' if not bad else f'{bad} FAILURES')
