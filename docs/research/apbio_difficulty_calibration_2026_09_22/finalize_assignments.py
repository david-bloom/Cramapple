import json,csv,re
from collections import Counter

# ---------- CHEMISTRY ----------
chem={i['content_key']:i for i in json.load(open('chem_full.json'))}
cf={r['content_key']:r for r in csv.DictReader(open('APCHEM_DIFFICULTY_ASSIGNMENTS_2026_09_22.csv'))}
cm={r['content_key']:r for r in csv.DictReader(open('apchem_mcq_characteristics.csv'))}
CJ={ # judgement, framework-grounded
 'absorbance 0.60':('Easy','C1 single-step Beer-Lambert proportional reasoning'),
 'solubility of a nonreactive gas':('Easy','C1 direct recall of a solubility trend'),
 'how many moles of water form':('Easy','C1 single-step stoichiometry'),
 'Which ions are spectators':('Easy','C1 direct identification'),
 'pH of 1.0':('Easy','C1 single-step log calculation'),
 'photon of ultraviolet':('Easy','C1 direct recall of a photon energy trend'),
 'ammonium nitrate in water inside a coffee-cup':('Medium','C2 links a calorimetry observation to thermodynamics'),
 'pOH of a 0.0025 M HCl':('Medium','C2 two-step: pH then pOH'),
 'deltaH = -92 kJ/mol and deltaS':('Medium','C2 connects enthalpy, entropy and temperature dependence'),
 'constant current of 2.00 A':('Medium','C2 multi-step Faraday electrolysis'),
 'enthalpy change, deltaH(rxn), for the formation of carbon disulfide':('Medium','C2 multi-step Hess-law manipulation'),
}
def chem_final(k):
    it=chem[k]; stem=it.get('stem') or ''
    if it['item_type']=='mcq':
        r=cm.get(k)
        if r and r['difficulty']: return r['difficulty'],r['basis']
    else:
        r=cf.get(k)
        if r and 'no cue' not in r['basis']: return r['difficulty'],r['basis']
    for probe,(lvl,why) in CJ.items():
        if probe in stem: return lvl,why
    return None,'UNASSIGNED'
chem_rows=[]
for k,it in sorted(chem.items(),key=lambda kv:(kv[1]['item_type'],kv[0])):
    lvl,why=chem_final(k)
    chem_rows.append({'content_key':k,'item_type':it['item_type'],'difficulty':lvl or '',
                      'basis':why,'authored_difficulty':it.get('authored_difficulty') or ''})

# ---------- STATISTICS ----------
st={i['content_key']:i for i in json.load(open('stats_full.json'))}
sv={r['content_key']:r for r in csv.DictReader(open('apstats_difficulty_assignments_v3.csv'))}
DISPLAY=re.compile(r'which representation correctly displays',re.I)
CONFOUND=re.compile(r'\bchoose to\b|\bwho choose\b|then compares\b|\bmorning class\b.{0,60}\bafternoon class\b'
                    r'|\brecords\b.{0,80}\bthen compares\b',re.I)
RANDASSIGN=re.compile(r'assigns?\b.{0,40}\bat random\b|\brandomly assigns\b',re.I)
def stats_final(k):
    r=sv[k]
    if r['difficulty']: return r['difficulty'],r['basis']
    it=st[k]; blob=' '.join(filter(None,[it.get('stem'),it.get('stim')]))
    if DISPLAY.search(blob):   return 'Easy','C1 build/read a basic display from raw data'
    if re.search(r'Sampling plan:',blob):
        return 'Easy','C1 identify the sampling method from a described plan'
    if RANDASSIGN.search(blob):return 'Medium','C2 well-designed randomised experiment'
    if CONFOUND.search(blob):  return 'Hard','C3 observational comparison with a confounding risk'
    return None,'UNASSIGNED'
stats_rows=[]
for k,it in sorted(st.items(),key=lambda kv:(kv[1]['item_type'],kv[0])):
    lvl,why=stats_final(k)
    stats_rows.append({'content_key':k,'item_type':it['item_type'],'difficulty':lvl or '',
                       'basis':why,'authored_difficulty':it.get('authored_difficulty') or ''})

for name,rows in (('apchem_difficulty_assignments_FINAL.csv',chem_rows),
                  ('apstats_difficulty_assignments_FINAL.csv',stats_rows)):
    with open(name,'w',newline='') as f:
        w=csv.DictWriter(f,fieldnames=['content_key','item_type','difficulty','basis','authored_difficulty'])
        w.writeheader(); w.writerows(rows)
    n=len(rows); un=sum(1 for r in rows if not r['difficulty']); c=Counter(r['difficulty'] for r in rows if r['difficulty'])
    lab=name.split('_')[0].upper()
    print(f"{lab:<9} n={n:<4} unassigned={un}   "+'  '.join(f'{k}: {c.get(k,0):>3} ({100*c.get(k,0)/n:4.1f}%)' for k in ('Easy','Medium','Hard')))
    for sub in ('frq','mcq'):
        rs=[r for r in rows if r['item_type']==sub]; cc=Counter(r['difficulty'] for r in rs)
        print(f"   {sub.upper():<5} n={len(rs):<4}          "+'  '.join(f'{k}: {cc.get(k,0):>3} ({100*cc.get(k,0)/len(rs):4.1f}%)' for k in ('Easy','Medium','Hard')))
