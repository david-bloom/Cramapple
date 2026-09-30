import json,glob,collections
man={i['key']:i for i in json.load(open('batch_manifest.json'))}
rows=[]
for f in glob.glob('out_labels_*/labels.jsonl'):
    rows+= [json.loads(l) for l in open(f)]
print("label rows",len(rows),"ok",sum(r['ok'] for r in rows))
by=collections.defaultdict(list)
for r in rows:
    if r['ok']: by[r['key']].append((r['model'],r['label']))
def plur(labs,fn):
    c=collections.Counter(fn(l) for _,l in labs); v,n=c.most_common(1)[0]; return v,n,len(labs)
U=lambda l:tuple(sorted(l['required_units'])); T=lambda l:l['primary_topic_code']; S=lambda l:l['skill_code']; D=lambda l:l['difficulty']
seedkey={} # variant key -> seed's label-probe key
kmap={'apcalcab-mcq-001':'pilotseed-apcalcab-mcq-001','apcalcab-mcq-026':'pilotseed-apcalcab-mcq-026','apcalcab-mcq-029':'pilotseed-apcalcab-mcq-029','apcalcab-mcq-031':'pilotseed-apcalcab-mcq-031','apcalcab-mcq-038':'pilotseed-apcalcab-mcq-038','apcalcab-mcq-017':'pilotseed-apcalcab-mcq-017','apcalcab-mcq-np2-006':'pilotseed-apcalcab-mcq-np2-006','apcalcab-mcq-016':'pilotseed-apcalcab-mcq-016'}
# probe key of each variant (pilot-<id> or u3-<id>)
out={}
for k,it in man.items():
    pk=('pilot-' if it['src']=='pilot' else 'u3-')+k.replace('apcalcab-mcq-sv-','')
    sk=kmap.get(it['seed'],it['seed'])
    sl,vl=by[sk],by[pk]
    res={}
    for name,fn in (('units',U),('topic',T),('skill',S),('difficulty',D)):
        sv,sn,st=plur(sl,fn); vv,vn,vt=plur(vl,fn)
        ok = (sv==vv) and vn>=4 and sn>=4
        res[name]=dict(seed=sv,seed_support=f"{sn}/{st}",variant=vv,variant_support=f"{vn}/{vt}",inherit=ok)
    out[k]=res
json.dump(out,open('label_inheritance.json','w'),indent=1)
tot=collections.Counter(); 
for k,r in out.items():
    for d,x in r.items(): tot[d]+=x['inherit']
print("inherit counts of 24:",dict(tot))
for k,r in sorted(out.items()):
    held=[d for d,x in r.items() if not x['inherit']]
    print(k.replace('apcalcab-mcq-sv-',''),'units',list(r['units']['variant']),'topic',r['topic']['variant'],'skill',r['skill']['variant'],'diff',r['difficulty']['variant'],'| HELD:',held)
