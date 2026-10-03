import json,glob,collections
v=collections.defaultdict(dict)
for f in glob.glob('out_skill_*/labels.jsonl'):
    for l in open(f):
        r=json.loads(l)
        if r['ok']: v[r['key']][r['model']]=r['label']['skill_code']
P={p['content_key']:p for p in json.load(open('packets_skill.json'))}
out=[];c=collections.Counter()
for k,m in sorted(v.items()):
    cnt=collections.Counter(m.values()).most_common()
    top,n=cnt[0]
    tie=len(cnt)>1 and cnt[1][1]==n
    st='validated' if n>=3 else ('held' if tie else 'provisional_model') if n==2 else 'held'
    if n==2 and tie: st='held'
    c[st]+=1
    out.append(dict(key=k,skill=top if st!='held' else None,votes=n,status=st,topic=P[k].get('primary_topic'),all=m))
json.dump(out,open('skill_tally.json','w'),indent=1)
print(c,len(out))
