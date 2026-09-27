import json,re,csv
from collections import Counter
items=[i for i in json.load(open('chem_full.json')) if i['item_type']=='mcq']
UNIT=r'(?:g|kg|mg|mol|L|mL|atm|torr|kPa|M|kJ|J|°C|K|nm|s|min|A|V|%)'
NUMQ=re.compile(r'\d[\d.,]*\s*(?:×\s*10[⁻\-–]?\s*\d+\s*)?'+UNIT)
# C3 Hard: synthesis, design/error evaluation, deviation from expected behaviour
SYNTH=re.compile(r'\bdoes not change\b.*\bbecause\b|\bdeviat\w+|\bnon-?ideal\b|\breal gas\b'
  r'|\bexperimental error\b|\bsource of error\b|\bdesign\b.*\b(flaw|error)\b|\banomal\w+'
  r'|\bunexpected\b|\binconsistent with\b|\bfails? to\b'
  r'|\beven though\b|\bdespite\b|\bgreater than that of\b.*\beven\b|\band why\b|, and why',re.I)
# C2 Medium: connects two distinct ideas / representations / a shift / multi-step chain
LINK=re.compile(r'\bimplies\b|\bshifts?\b|\bQ[c]?\s*[<>=]|\bK[c]?\s*[<>=]|\border in\b|\bzero order|\bfirst order'
  r'|\bsecond order|doubling.*(quadrupl|doubl|tripl)|\bE°?\s*cell\b|\bbuffer\b|\bLe Ch|\bequilibrium\b'
  r'|\bparticulate\b|\bdiagram\b|using (the )?(data|graph|table|average bond enthalp|standard enthalp)'
  r'|\bthermochemical equations\b|\bHess\b|\bbond enthalp|\benthalp\w* of formation|\bhalf-?equivalence'
  r'|\btitration\b|\bgalvanic\b|\belectroly\w+|\bmechanism\b|\brate law\b|\bhalf-reaction\b'
  r'|\bkinetic molecular\b|\bphotoelectron\b|\bsolubility\b.*\b(increase|decrease)|\bprecipitat',re.I)
RECALL=re.compile(r'\bwhich (of the following )?(species|substance|compound|ion|molecule|element|gas|solution|pair|type)\b'
  r'|\bgeometry\b|\bmolecular shape\b|\bboiling point\b|\bspectator\b|\bhybrid\w*|\bLewis structure\b'
  r'|\bresonance\b|\bvalence shell\b|\belectron configuration\b|\bcatalyst\b|\bis defined as\b'
  r'|\bfavorable when\b|\bthe system\b\s*A\.|\bconduct',re.I)
def c1(t): return len(NUMQ.findall(t))>=2 and re.search(r'\bA\.\s*[\d.]',t) is not None

rows=[];cov=Counter()
for it in items:
    t=it.get('stem') or ''
    if SYNTH.search(t):   lvl,why='Hard','C3 synthesis / deviation / design evaluation'
    elif LINK.search(t):  lvl,why='Medium','C2 connects two distinct ideas, a shift, or a multi-step chain'
    elif c1(t):           lvl,why='Easy','C1 single-step algorithmic calculation'
    elif RECALL.search(t):lvl,why='Easy','C1 direct recall of a fundamental concept or trend'
    else:                 lvl,why=None,'unclassified'
    cov[why]+=1
    rows.append({'content_key':it['content_key'],'item_type':'mcq','difficulty':lvl or '',
                 'basis':why,'authored_difficulty':it.get('authored_difficulty') or ''})
n=len(items); cls=sum(1 for r in rows if r['difficulty'])
print(f'AP CHEMISTRY MCQ — characteristics, structural v2 (n={n})')
print(f'  classified {cls}/{n} = {100*cls/n:.1f}%   [verb method: 10/68 = 14.7%; structural v1: 61.8%]')
c=Counter(r['difficulty'] for r in rows if r['difficulty'])
print('  '+'  '.join(f'{k}: {c.get(k,0)} ({100*c.get(k,0)/cls:.1f}%)' for k in ('Easy','Medium','Hard')))
for k,v in cov.most_common(): print(f'    {v:>3}  {k}')
with open('apchem_mcq_characteristics.csv','w',newline='') as f:
    w=csv.DictWriter(f,fieldnames=['content_key','item_type','difficulty','basis','authored_difficulty'])
    w.writeheader(); w.writerows(rows)
# spot check against obviously-miscalibrated authored labels
print('\n  spot check vs authored:')
items_by={i['content_key']:i for i in items}
for r in rows:
    s=(items_by[r['content_key']].get('stem') or '')
    for probe in ('pH of 1.0','favorable when','inert gas','ionization energy of magnesium'):
        if probe in s:
            print(f"    authored={r['authored_difficulty'] or '-':<10} new={r['difficulty']:<7} {s[:88]}")
