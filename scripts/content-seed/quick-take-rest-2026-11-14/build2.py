import json,sys
files={'ap_biology':['ap_biology'],'ap_chemistry':['ap_chemistry'],'ap_calculus_ab':['ap_calculus_ab'],'ap_calculus_bc':['ap_calculus_bc_a','ap_calculus_bc_b'],'ap_physics_1':['ap_physics_1'],'ap_precalculus':['ap_precalculus']}
snap=json.load(open('snap_fixed.json'))
out={};bad=[]
for subj,fs in files.items():
    d={}
    for f in fs:
        for l in open(f'qt_{f}.txt').read().split('\n'):
            if not l.strip(): continue
            p=l.split('|'); code=p[0]
            if code.endswith('R'): d[code[:-1]]+="\nRemember it: "+'|'.join(p[1:]); continue
            if len(p)>3: print('PIPE',subj,code)
            d[code]=f"The answer move: {p[1]}\nHow points are lost: {'|'.join(p[2:])}" if len(p)==3 else f"The answer move: {'|'.join(p[1:-1])}\nHow points are lost: {p[-1]}"
    want={r['topic_code'] for r in snap if r['subject_key']==subj}
    if set(d)!=want: print(subj,'coverage',sorted(set(d)^want)); bad.append((subj,'coverage'))
    for c,t in d.items():
        for ln in t.split('\n'):
            n=len(ln.split(': ',1)[1].split())
            if n>25: bad.append((subj,c,ln.split(':')[0],n))
        if len(t)>400: bad.append((subj,c,'chars',len(t)))
    out[subj]=d
json.dump(out,open('proposed.json','w'),indent=1,ensure_ascii=False)
print({s:len(d) for s,d in out.items()},'problems',len(bad))
for b in bad: print(b)
