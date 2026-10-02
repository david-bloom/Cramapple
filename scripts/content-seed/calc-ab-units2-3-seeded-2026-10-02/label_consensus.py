import json,glob,collections
man={m['key']:m for m in json.load(open('variants_manifest.json'))}
by=collections.defaultdict(list)
for f in glob.glob('out_labels_*/labels.jsonl'):
    for l in open(f):
        r=json.loads(l)
        if r['ok']: by[r['key']].append(r['label'])
U=lambda l:tuple(sorted(l['required_units'])); T=lambda l:l['primary_topic_code']; S=lambda l:l['skill_code']; D=lambda l:l['difficulty']; M=lambda l:max(l['required_units'])
def pl(L,fn):
    c=collections.Counter(fn(l) for l in L); v,n=c.most_common(1)[0]; return v,n,len(L)
out={}
for k,m in man.items():
    sl,vl=by[m['seed']],by[k]; res={}
    for name,fn in (('units',U),('max_unit',M),('topic',T),('skill',S),('difficulty',D)):
        sv,sn,st=pl(sl,fn); vv,vn,vt=pl(vl,fn)
        res[name]=dict(seed=sv,seed_support=f"{sn}/{st}",variant=vv,variant_support=f"{vn}/{vt}",inherit=(sv==vv and vn>=4 and sn>=4))
    out[k]=res
json.dump(out,open('label_inheritance.json','w'),indent=1,default=list)
tot=collections.Counter()
for k,r in out.items():
    for d,x in r.items(): tot[d]+=x['inherit']
print("inherit counts of",len(out),dict(tot))
print("\nSEEDS (probe plurality):")
for sk in sorted({m['seed'] for m in man.values()}):
    L=by[sk]; print(' ',sk.replace('apcalcab-mcq-',''),'units',pl(L,U),'topic',pl(L,T),'skill',pl(L,S),'diff',pl(L,D))
print("\nVARIANTS (HELD dims):")
for k,r in sorted(out.items()):
    held=[d for d,x in r.items() if not x['inherit']]
    print(' ',k.replace('u23-',''),'units',list(r['units']['variant']),r['units']['variant_support'],'topic',r['topic']['variant'],r['topic']['variant_support'],'| HELD:',held)
