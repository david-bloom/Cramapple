import json,re,csv
from collections import Counter
items=json.load(open('stats_full.json'))

def unit(it):
    for s in (it.get('subtopics') or []):
        m=re.match(r'\s*Unit\s+(\d+)\s*:',str(s),re.I)
        if m: return int(m.group(1))
    m=re.match(r'\s*(\d+)\.',it.get('topic') or '')
    if m: return int(m.group(1))
    for s in (it.get('modules') or []):
        m=re.match(r'^\s*(\d+)\s*$',str(s))
        if m: return int(m.group(1))
    return None

# C3 HARD - probability/simulation (lowest-scoring), design flaws, synthesis
C3=re.compile(r'\bprobabilit|\bP\(|\bconditional\b|\bbayes|\bindependen\w*\b|\bmutually exclusive'
  r'|\bbinomial|\bgeometric distribution|\bexpected value|\brandom variable|\bsimulat\w+|\bcombination'
  r'|\bpermutation|\bcounting method|\bconfound|\blurking|\bbias(ed)?\b|\bcausation\b|\bcause and effect'
  r'|\bdesign flaw|\bnonresponse|\bundercoverage|\bvoluntary response|\bplacebo\b|\bblind'
  r'|\btype i\b|\btype ii\b|\bpower of the test|\bbootstrap|\bnonparametric',re.I)
# C2 MEDIUM - 4-step inference, conditions, routine interpretation, design procedures, representation
C2=re.compile(r'\bt-?test|\bz-?test|\bchi-?square|\bconfidence interval|\bsignificance test|\bhypothesis test'
  r'|\bp-?value|\bmargin of error|\bstandard error|\bsampling distribution|\bcentral limit'
  r'|\blarge counts|\b10%\s*condition|\bnormality condition|\bconditions?\b.{0,24}\b(met|verify|check|satisf)'
  r'|\bleast-?squares|\bregression|\bslope\b|\br-?squared|\bcoefficient of determination|\bresidual'
  r'|\bpredicted\b|\bcorrelation coefficient|\bstratified|\bcluster sampl|\bmatched-?pairs'
  r'|\bdesign (an?|a matched|the) experiment|\bhow you would design|\brandom assignment'
  r'|\bconstructed graph|\bconstruct a (graph|boxplot|histogram|scatterplot)|\bpaired procedure'
  r'|\bobservational (study|vs)|\bexperiment\b.{0,18}\bsurvey\b|\bcensus\b',re.I)
# C1 EASY - single-step mechanics, summary statistics, reading a display, vocabulary/classification
C1=re.compile(r'\bmean\b|\bmedian\b|\bmode\b|\bstandard deviation|\biqr\b|\binterquartile|\bquartile'
  r'|\bz-?score|\bfive-?number|\bpercentile|\brange\b|\bskew|\boutlier|\bfrequency table'
  r'|\bboxplot|\bbox plot|\bhistogram|\bdotplot|\bdot plot|\bstem(-and-|\s)?leaf|\bscatterplot|\bscatter plot'
  r'|\bexplanatory variable|\bresponse variable|\bcategorical or quantitative|\bparameter or (a )?statistic'
  r'|\bclassify each|\bidentify whether|\bwhat is the difference between|\bdefine\b|\bwhat is the population'
  r'|\bdescriptive and inferential'
  r'|\bbest describes the sampling method|\bsampling plan\b.{0,200}\bbest describes'
  r'|\bthe variable recorded\b|\bbest describes the variable\b',re.I)
# C2b MEDIUM - an experimental-design scenario (assignment to treatments)
C2B=re.compile(r'\brandomly assigns\b|\bassigns? (volunteers|subjects|participants|students)\b'
  r'|\btreatment group|\bcontrol group',re.I)

UNIT_BASE={1:'Easy',2:'Easy',3:'Medium',4:'Hard',5:'Medium',6:'Medium',7:'Medium',8:'Medium',9:'Medium'}

rows=[];cov=Counter()
for it in items:
    blob=' '.join(filter(None,[it.get('stem'),it.get('stim'),it.get('criteria_text'),
                               it.get('topic'),' '.join(it.get('subtopics') or [])]))
    u=unit(it)
    if C3.search(blob):        lvl,why='Hard','C3 probability/simulation, design flaw, or synthesis'
    elif u==4:                 lvl,why='Hard','C3 Unit 4 (probability and random variables)'
    elif C2.search(blob):      lvl,why='Medium','C2 inference procedure, design, or routine interpretation'
    elif C2B.search(blob):     lvl,why='Medium','C2 experimental-design scenario (random assignment)'
    elif C1.search(blob):      lvl,why='Easy','C1 summary statistic, display reading, or vocabulary'
    elif u in (1,2):           lvl,why='Easy','C1 Unit 1-2 (exploring data)'
    elif u is not None:        lvl,why=UNIT_BASE[u],f'unit {u} base tier'
    else:                      lvl,why=None,'unclassified'
    cov[why]+=1
    rows.append({'content_key':it['content_key'],'item_type':it['item_type'],'difficulty':lvl or '',
                 'basis':why,'authored_difficulty':it.get('authored_difficulty') or ''})
rows.sort(key=lambda r:(r['item_type'],r['content_key']))
with open('apstats_difficulty_assignments_v3.csv','w',newline='') as f:
    w=csv.DictWriter(f,fieldnames=['content_key','item_type','difficulty','basis','authored_difficulty'])
    w.writeheader(); w.writerows(rows)

n=len(rows); cls=sum(1 for r in rows if r['difficulty'])
print(f'AP STATISTICS — structural characteristics (n={n})')
print(f'  classified {cls}/{n} = {100*cls/n:.1f}%   [keyword v1: 280/384 = 72.9%; structural v2: 79.2%]')
for sub,lab in ((None,'ALL'),('frq','FRQ'),('mcq','MCQ')):
    rs=[r for r in rows if (sub is None or r['item_type']==sub) and r['difficulty']]
    tot=len([r for r in rows if sub is None or r['item_type']==sub]); c=Counter(r['difficulty'] for r in rs)
    print(f"  {lab:<4} {len(rs):>3}/{tot:<3} "+'  '.join(f'{k}: {c.get(k,0):>3} ({100*c.get(k,0)/max(len(rs),1):4.1f}%)' for k in ('Easy','Medium','Hard')))
print('\n  cue breakdown:')
for k,v in cov.most_common(): print(f'    {v:>3}  {k}')
