import json,csv,re
from collections import Counter
items=json.load(open('bio_full.json'))

EASY={'identify','identifies','state','states','name','names','list','lists','label','labels',
      'annotate','annotates','indicate','indicates','select','classify','classifies','recall'}
MED ={'describe','describes','determine','determines','compare','compares','contrast','contrasts',
      'distinguish','distinguishes','construct','constructs','represent','represents','write','writes',
      'analyze','analyzes','apply','applies','trace','traces','graph','plot','explain','explains'}
HARD={'predict','predicts','justify','justifies','design','designs','propose','proposes',
      'evaluate','evaluates','support','supports','synthesize','integrate','critique',
      'calculate','calculates'}
ORDER={'Easy':0,'Medium':1,'Hard':2}
# SP6 Argumentation context: an "explain" attached to a claim/argument is Hard, not Medium
ARG=re.compile(r'\bclaim\b|\bargument|\bsupports? the\b|\brefut|\bjustif|\bevidence that\b|\bevaluate\b',re.I)
VERB_RE=re.compile(r'\b('+'|'.join(sorted(EASY|MED|HARD,key=len,reverse=True))+r')\b',re.I)
def tier(v,ctx):
    v=v.lower()
    if v in ('explain','explains'): return 'Hard' if ARG.search(ctx or '') else 'Medium'
    return 'Easy' if v in EASY else 'Medium' if v in MED else 'Hard' if v in HARD else None

J=json.load(open('judgements.json')) if False else None
import importlib.util
spec=importlib.util.spec_from_file_location('j','judge.py')
src=open('judge.py').read(); ns={}
exec(src.split('J={')[1].split('}\nrows=')[0].join(['J={','}']),{'__builtins__':__builtins__},ns)
J=ns['J']

rows=[]
for it in items:
    units=[]
    if it['item_type']=='frq' and it.get('criteria_text'):
        for c in it['criteria_text'].split(' ~~ '):
            m=VERB_RE.search(c)
            if m:
                t=tier(m.group(1),c)
                if t: units.append((m.group(1).lower(),t))
    else:
        st=it['stem'] or ''
        m=VERB_RE.search(st)
        if m:
            t=tier(m.group(1),st)
            if t: units.append((m.group(1).lower(),t))
    if units:
        ts=[t for _,t in units]; cnt=Counter(ts); top=max(cnt.values())
        lvl=max([t for t,n in cnt.items() if n==top],key=lambda t:ORDER[t])
        basis='task verb'; why='verb(s): '+', '.join(sorted({v for v,_ in units}))
    else:
        lvl,why=J[it['content_key']]; basis='judgement'
    rows.append({'content_key':it['content_key'],'item_type':it['item_type'],'difficulty':lvl,
                 'basis':basis,'rationale':why})
rows.sort(key=lambda x:(x['item_type'],x['content_key']))
with open('APBIO_DIFFICULTY_ASSIGNMENTS_2026_09_22.csv','w',newline='') as f:
    w=csv.DictWriter(f,fieldnames=['content_key','item_type','difficulty','basis','rationale']); w.writeheader(); w.writerows(rows)
print('FINAL — 118 AP Biology items, 0 unclassified  (explain split: SP1=Medium, SP6/claim=Hard)')
for sub,lab in ((None,'ALL'),('frq','FRQ'),('mcq','MCQ')):
    rs=[r for r in rows if sub is None or r['item_type']==sub]; n=len(rs); c=Counter(r['difficulty'] for r in rs)
    print(f"  {lab:<4} n={n:<4} "+'  '.join(f"{k}: {c.get(k,0):>3} ({100*c.get(k,0)/n:4.1f}%)" for k in ('Easy','Medium','Hard')))
print('  basis:',dict(Counter(r['basis'] for r in rows)))
