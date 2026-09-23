import re, os, json, glob
from collections import defaultdict, Counter
SP='/private/tmp/claude-503/-Users-davidbloom-Documents-Cramapple-nosync/0b1a02b1-5c37-4ee3-95c6-7078986cf0f9/scratchpad/crr'

VERBS=['justify','explain','describe','identify','state','calculate','determine','predict',
       'represent','construct','design','propose','evaluate','compare','analyze','derive',
       'estimate','sketch','draw','label','annotate','indicate','interpret','select','find','write','show','use']
VERB_RE=re.compile(r'\b(' + '|'.join(VERBS) + r')(?:s|es|d|ed|ing)?\b', re.I)
PT_RE=re.compile(r'^\s*((?:Point\s+)?(?:[A-Z]{2}\d\s+P\d+|[A-Z]\d{1,2}|\d{2}))\s+([\d.]+)\s+([\d.]+)\s*$')
Q_RE=re.compile(r'^\s*Question\s+([A-Za-z0-9/]+)\s*$')
OVER_RE=re.compile(r'Overall Mean Score:\s*([\d.]+)')

FILES={  # canonical subject -> file
 'AP Biology':'Biology__ap25-cr-report-biology.txt',
 'AP Calculus':'Calculus_AB__ap25-cr-report-calculus-ab-bc.txt',
 'AP Chemistry':'Chemistry__ap25-cr-report-chemistry.txt',
 'AP Physics 1':'Physics_1__ap24-cr-report-physics-1.txt',
 'AP Physics 2':'Physics_2__ap25-cr-report-physics-2.txt',
 'AP Physics C: E&M':'Physics_C__EM___ap25-cr-report-physics-c-em.txt',
 'AP Physics C: Mech':'Physics_C__M___ap25-cr-report-physics-c-mech.txt',
 'AP Precalculus':'Pre-calculus__ap25-cr-report-precalculus.txt',
 'AP Statistics':'Statistics__ap25-cr-report-statistics.txt',
}

def parse(path):
    lines=open(path,encoding='utf-8',errors='replace').read().split('\n')
    qs=[];cur=None
    for i,ln in enumerate(lines):
        m=Q_RE.match(ln)
        if m: cur={'q':m.group(1),'points':[],'start':i,'task':None,'topic':None,'overall':None,'body':i}; qs.append(cur); continue
        if cur is None: continue
        if ln.startswith('Task:') and not cur['task']: cur['task']=ln[5:].strip()
        if ln.startswith('Topic:') and not cur['topic']: cur['topic']=ln[6:].strip()
        pm=PT_RE.match(ln)
        if pm and 'Overall' not in ln:
            try: cur['points'].append({'label':re.sub(r'^Point\s+','',pm.group(1)).strip(),'max':float(pm.group(2)),'mean':float(pm.group(3))})
            except ValueError: pass
        om=OVER_RE.search(ln)
        if om and cur['overall'] is None: cur['overall']=float(om.group(1))
        if 'What were the responses' in ln and cur['body']==cur['start']: cur['body']=i
    for j,q in enumerate(qs):
        e=qs[j+1]['start'] if j+1<len(qs) else len(lines)
        q['narr']=' '.join(lines[q['body']:e])
        mx=re.search(r'Max Score:\s*([\d.]+)',q['narr'] if False else '\n'.join(lines[q['start']:e]))
        mn=re.search(r'Mean Score:\s*([\d.]+)','\n'.join(lines[q['start']:e]))
        if not q['points'] and mx and mn: q['qmax']=float(mx.group(1)); q['qmean']=float(mn.group(1))
    return qs

def verb_for(label, narr, letter_map, seq_parts, idx):
    # 1) direct mention of the point label in narrative
    core=label.split()[-1]                      # "AB1 P3" -> "P3" ; "A1" -> "A1"
    for sent in re.split(r'(?<=[.;])\s+', narr):
        if re.search(r'\b'+re.escape(core)+r'\b', sent):
            v=VERB_RE.search(sent)
            if v: return v.group(1).lower(),'direct'
    # 2) part-letter mapping
    lm=re.match(r'^([A-Z])\d', label)
    if lm and lm.group(1) in letter_map: return letter_map[lm.group(1)],'letter'
    # 3) sequential part order
    if seq_parts and idx < len(seq_parts): return seq_parts[idx],'sequential'
    return None,None

rows=[]
for subj,fn in FILES.items():
    path=os.path.join(SP,fn)
    for q in parse(path):
        narr=q['narr']
        # letter map: first verb after "part X"
        letter_map={}
        for sent in re.split(r'(?<=[.;])\s+', narr):
            pm=re.search(r'\bparts?\s+\(?([A-Z])\)?', sent, re.I)
            if pm:
                v=VERB_RE.search(sent[pm.end():])
                if v: letter_map.setdefault(pm.group(1).upper(), v.group(1).lower())
        # sequential: verbs in order of "Part X" mentions
        seq=[]
        for pm in re.finditer(r'\bparts?\s+\(?[A-Za-z]\)?\s*\(?[ivx]*\)?', narr, re.I):
            v=VERB_RE.search(narr[pm.end():pm.end()+220])
            if v: seq.append(v.group(1).lower())
        pts=q['points']
        # Calculus file mixes AB and BC -> tag by label prefix
        for i,p in enumerate(pts):
            s=subj
            if subj=='AP Calculus':
                s='AP Calculus AB' if p['label'].startswith('AB') else ('AP Calculus BC' if p['label'].startswith('BC') else subj)
            v,how=verb_for(p['label'],narr,letter_map,seq,i)
            rows.append({'subject':s,'question':q['q'],'label':p['label'],'max':p['max'],'mean':p['mean'],
                         'ratio':round(p['mean']/p['max'],3) if p['max'] else None,'verb':v,'attr':how,
                         'task':q['task'],'topic':q['topic']})
        if not pts and 'qmean' in q:
            rows.append({'subject':subj,'question':q['q'],'label':'(whole item)','max':q['qmax'],'mean':q['qmean'],
                         'ratio':round(q['qmean']/q['qmax'],3),'verb':None,'attr':None,'task':q['task'],'topic':q['topic']})

json.dump(rows,open(SP+'/../crr_rows.json','w'),indent=1)
print('total rows:',len(rows))
for s,c in sorted(Counter(r['subject'] for r in rows).items()): 
    wv=sum(1 for r in rows if r['subject']==s and r['verb'])
    print(f'  {s:22s} rows={c:3d}  verb-attributed={wv:3d}')
print('attribution method:',dict(Counter(r['attr'] for r in rows if r['attr'])))
