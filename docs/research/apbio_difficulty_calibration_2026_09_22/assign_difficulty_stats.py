import json,re,csv
from collections import Counter
items=json.load(open('stats_full.json'))

HARD=[r'\bprobabilit',r'random variable',r'\bbinomial',r'\bgeometric distribution',r'\bconditional probab',
      r'\bbayes',r'\bsimulat',r'mutually exclusive',r'\bindependent events',r'expected value',
      r'\bconfound',r'\bbias(ed)?\b',r'design flaw',r'lurking variable',r'\bcausation\b',
      r'observational study',r'\bplacebo',r'\bblocking\b',r'\bblind(ed)?\b',
      r'\btype i\b|\btype ii\b',r'\bpower\b.*test|power of the test',r'bootstrap',r'nonparametric']
MED =[r'\bt-test|\bt test|two-sample|one-sample',r'chi-square|chi square',r'confidence interval',
      r'hypothesis test|significance test',r'\bp-value|\bp value',r'\bconditions?\b.*(met|verify|check)',
      r'large counts|10% condition|normality condition',r'sampling distribution',r'standard error',
      r'\bslope\b',r'\br\^?2\b|r-squared|coefficient of determination',r'least-squares|regression',
      r'\bmargin of error',r'\bproportion\b',r'\binference\b',r'\bresidual']
EASY=[r'\bmean\b',r'\bmedian\b',r'\bmode\b',r'standard deviation',r'\biqr\b|interquartile',
      r'\bz-score|\bz score',r'\bboxplot|box plot',r'\bhistogram',r'\bstem(-and-|\s)leaf',
      r'\bdotplot|dot plot',r'\bscatterplot|scatter plot',r'explanatory variable|response variable',
      r'\bquartile',r'\brange\b',r'\bskew',r'\boutlier',r'five-number',r'\bpercentile',r'\bfrequency table']
def hits(pats,t): return sum(1 for p in pats if re.search(p,t,re.I))

rows=[]
for it in items:
    blob=' '.join(filter(None,[it.get('stem'),it.get('stim'),it.get('criteria_text'),
                               it.get('topic'),' '.join(it.get('subtopics') or [])]))
    h,m,e=hits(HARD,blob),hits(MED,blob),hits(EASY,blob)
    # framework precedence: Hard cues dominate; then Medium procedures; else descriptive = Easy
    if h>=1 and h>=m: lvl,basis='Hard',f'hard cues={h}'
    elif m>=1:        lvl,basis='Medium',f'inference/procedure cues={m}'
    elif e>=1:        lvl,basis='Easy',f'descriptive cues={e}'
    elif h>=1:        lvl,basis='Hard',f'hard cues={h}'
    else:             lvl,basis='Medium','no cue matched - default to Medium (undiscriminated)'
    rows.append({'content_key':it['content_key'],'item_type':it['item_type'],'difficulty':lvl,
                 'basis':basis,'authored_difficulty':it.get('authored_difficulty') or ''})
rows.sort(key=lambda r:(r['item_type'],r['content_key']))
with open('APSTATS_DIFFICULTY_ASSIGNMENTS_2026_09_22.csv','w',newline='') as f:
    w=csv.DictWriter(f,fieldnames=['content_key','item_type','difficulty','basis','authored_difficulty'])
    w.writeheader(); w.writerows(rows)

print('AP STATISTICS — 384 published items')
for sub,lab in ((None,'ALL'),('frq','FRQ'),('mcq','MCQ')):
    rs=[r for r in rows if sub is None or r['item_type']==sub]; n=len(rs); c=Counter(r['difficulty'] for r in rs)
    print(f"  {lab:<4} n={n:<4} "+'  '.join(f"{k}: {c.get(k,0):>3} ({100*c.get(k,0)/n:4.1f}%)" for k in ('Easy','Medium','Hard')))
print('  no cue matched:',sum(1 for r in rows if 'no cue' in r['basis']))

# agreement vs the existing authored 4-level label, normalised to 3 levels
NORM={'easy':'Easy','Easy':'Easy','Easy-Medium':'Medium','medium':'Medium','Medium':'Medium',
      'hard':'Hard','Hard':'Hard','very_hard':'Hard','Very Hard':'Hard'}
both=[(r['difficulty'],NORM[r['authored_difficulty']]) for r in rows if r['authored_difficulty'] in NORM]
ag=sum(1 for a,b in both if a==b)
ca=Counter(a for a,_ in both); cb=Counter(b for _,b in both)
pe=sum((ca[t]/len(both))*(cb[t]/len(both)) for t in ('Easy','Medium','Hard'))
print(f"\nAGREEMENT with existing authored labels (n={len(both)}, 4-level collapsed to 3)")
print(f"  exact: {ag}/{len(both)} = {100*ag/len(both):.1f}%   kappa: {(ag/len(both)-pe)/(1-pe):.3f}")
print(f"  {'':<14}{'auth Easy':>11}{'auth Med':>10}{'auth Hard':>11}")
for a in ('Easy','Medium','Hard'):
    print(f"  new {a:<10}"+''.join(f"{sum(1 for x,y in both if x==a and y==b):>11}" for b in ('Easy','Medium','Hard')))
