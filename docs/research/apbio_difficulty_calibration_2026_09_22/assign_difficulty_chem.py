import json,re,csv
from collections import Counter
p='/Users/davidbloom/.claude/projects/-Users-davidbloom-Documents-Cramapple-nosync/0b1a02b1-5c37-4ee3-95c6-7078986cf0f9/tool-results/mcp-585b59f7-61af-4fac-bd1d-0f78516e1f14-execute_sql-1790122460765.txt'
inner=json.loads(open(p,encoding='utf-8',errors='replace').read())['result']
items=json.loads(re.search(r'<untrusted-data-[0-9a-f-]+>\s*(\[.*\])\s*</untrusted-data',inner,re.S).group(1))
json.dump(items,open('chem_full.json','w'))

# Framework (validated 9/10 on 2025 CRR Q1):
#  Easy   = single-step algorithmic calculation OR direct recall/identification
#  Medium = connects two representations / predicts a shift / multi-step calculation / single-link explain
#  Hard   = predict AND justify a directional change; explain a deviation from ideal behaviour;
#           evaluate experimental design or error; conceptual synthesis
PRED=re.compile(r'\bpredict|\bwill the\b|\bdirectional|\bshift\b|\bincrease or decrease|\bhigher or lower',re.I)
JUST=re.compile(r'\bjustify|\bexplain|\baccount for|\bsupport (your|the) (claim|answer)|\breasoning',re.I)
HARDX=re.compile(r'deviat\w* from ideal|non-?ideal|ideal gas law fails|experimental error|source[s]? of error'
                 r'|design (flaw|error)|flaw in the (design|procedure)|why the student|invalid|improve the experiment'
                 r'|inconsisten\w+ with|anomal', re.I)
MEDX=re.compile(r'particulate|particle diagram|draw.*particle|equilibrium shift|le ch.telier|\bshift\b'
                r'|multi-?step|then calculate|using your answer', re.I)
EASYV=re.compile(r'\bidentif\w+|\bstate\b|\bname\b|\blist\b|\bannotate\w*|\bwrite the\b|\bselect\b|\bcircle\b',re.I)
CALC=re.compile(r'\bcalculat\w+|\bdetermine the (value|mass|concentration|ph|number)|\bcompute',re.I)

rows=[]
for it in items:
    blob=' '.join(filter(None,[it.get('stem'),it.get('stim'),it.get('criteria_text'),it.get('topic')]))
    if HARDX.search(blob):                      lvl,why='Hard','deviation/experimental-error/design evaluation'
    elif PRED.search(blob) and JUST.search(blob):lvl,why='Hard','predict AND justify a directional change'
    elif JUST.search(blob) and MEDX.search(blob):lvl,why='Medium','explain/justify linked to a shift or representation'
    elif JUST.search(blob):                      lvl,why='Medium','explain/justify, single link'
    elif PRED.search(blob):                      lvl,why='Medium','predicts a shift without required justification'
    elif MEDX.search(blob):                      lvl,why='Medium','connects two representations / multi-step'
    elif CALC.search(blob):                      lvl,why='Easy','single-step algorithmic calculation'
    elif EASYV.search(blob):                     lvl,why='Easy','direct recall / identification'
    else:                                        lvl,why='Medium','no cue matched - default Medium (undiscriminated)'
    rows.append({'content_key':it['content_key'],'item_type':it['item_type'],'difficulty':lvl,
                 'basis':why,'authored_difficulty':it.get('authored_difficulty') or ''})
rows.sort(key=lambda r:(r['item_type'],r['content_key']))
with open('APCHEM_DIFFICULTY_ASSIGNMENTS_2026_09_22.csv','w',newline='') as f:
    w=csv.DictWriter(f,fieldnames=['content_key','item_type','difficulty','basis','authored_difficulty'])
    w.writeheader(); w.writerows(rows)
print('AP CHEMISTRY — %d published items'%len(rows))
for sub,lab in ((None,'ALL'),('frq','FRQ'),('mcq','MCQ')):
    rs=[r for r in rows if sub is None or r['item_type']==sub]; n=len(rs); c=Counter(r['difficulty'] for r in rs)
    print(f"  {lab:<4} n={n:<4} "+'  '.join(f"{k}: {c.get(k,0):>3} ({100*c.get(k,0)/n:4.1f}%)" for k in ('Easy','Medium','Hard')))
print('  no cue matched:',sum(1 for r in rows if 'no cue' in r['basis']))
NORM={'easy':'Easy','Easy':'Easy','Easy-Medium':'Medium','medium':'Medium','Medium':'Medium',
      'hard':'Hard','Hard':'Hard','very_hard':'Hard','Very Hard':'Hard'}
both=[(r['difficulty'],NORM[r['authored_difficulty']]) for r in rows if r['authored_difficulty'] in NORM]
if both:
    ag=sum(1 for a,b in both if a==b)
    ca=Counter(a for a,_ in both); cb=Counter(b for _,b in both)
    pe=sum((ca[t]/len(both))*(cb[t]/len(both)) for t in ('Easy','Medium','Hard'))
    print(f"\n  vs authored labels (n={len(both)}): exact {100*ag/len(both):.1f}%, kappa {(ag/len(both)-pe)/(1-pe):.3f}")
