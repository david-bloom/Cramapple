#!/usr/bin/env python3
"""Round-1 patch of the 75 drafts (2026-10-02), applied in place to variants_batch*.json, math_items.json and ced_items.json; letters unchanged.
(a) strip the embedded A-D list from the 15 batch-2 stems (stale after letter randomization); (b) nine hand-verified content/rationale defects found by the two-model audit."""
import json,glob,re
RAT=[ # (variant id, old substring, new substring) applied to whichever rationale contains old
('apchem-mcq-005-v2','so average speed varies inversely with particle mass','so average speed varies inversely with the square root of particle mass'),
('apchem-mcq-005-v2','Lists the gases in order of increasing molar mass.','Lists the gases in order of decreasing molar mass (Cl₂ 71, N₂ 28, Ne 20 g/mol).'),
('apchem-mcq-025-v1','This answer comes from treating the metal–nonmetal bond as covalent and leaving it out of the comparison.','This answer comes from ignoring the metal and comparing only the nonmetal–nonmetal bonds.'),
('apchem-mcq-026-v3','Adding that electron on top of eight gives a false 10.','Treating the −1 charge as an extra lone pair on boron would give a false 10.'),
('apchem-mcq-035-v1','Raising the temperature gives molecules more kinetic energy and weakens, not strengthens, intermolecular attractions such as hydrogen bonds.','Raising the temperature gives molecules more kinetic energy, so attractions such as hydrogen bonds are overcome more easily; it does not make them stronger.'),
('apchem-mcq-037-v2',"The beam's intensity depends on the number of photons per second, not on the energy of each photon.","A beam's intensity depends on both the number of photons per second and the energy of each photon, so a more intense beam does not mean more energy per photon."),
('apchem-mcq-003-v2','all of its valence electrons are used in the bonds to the three oxygens','every electron pair around it is a bonding pair to one of the three oxygens'),
('apchem-mcq-031-v1','in a covalent network solid every atom is held','in a covalent network solid such as silicon carbide every atom is held'),
('apchem-mcq-031-v2','network solids are also brittle, high-melting and nonconducting as solids','network solids such as quartz are also brittle, high-melting and nonconducting as solids'),
('apchem-mcq-031-v3','network solids are nonconducting,','network solids such as diamond are nonconducting,'),
]
STEM=[('apchem-mcq-003-v1','Four species are drawn as Lewis diagrams.','Four species are listed below.')]
def strip_embedded(stem):
    m=re.search(r"\n\s*\n\s*A[\.\)]\s",stem) or re.search(r"\n\s*A[\.\)]\s",stem)
    return stem[:m.start()].rstrip() if m else stem
changed=set()
# batch files (source order)
for f in sorted(glob.glob('variants_batch*.json')):
    V=json.load(open(f)); dirty=False
    for v in V:
        s=strip_embedded(v['stem'])
        if s!=v['stem']: v['stem']=s; dirty=True; changed.add(v['id'])
        for vid,o,n in STEM:
            if v['id']==vid and o in v['stem']: v['stem']=v['stem'].replace(o,n); dirty=True; changed.add(vid)
        for vid,o,n in RAT:
            if v['id']==vid:
                for c in [v['correct']]+v['wrong']:
                    if o in c['rationale']: c['rationale']=c['rationale'].replace(o,n); dirty=True; changed.add(vid)
    if dirty: json.dump(V,open(f,'w'),indent=1,ensure_ascii=False)
# exported items
M=json.load(open('math_items.json'))
for m in M:
    vid=m['key'].replace('u13-','')
    s=strip_embedded(m['stem'])
    if s!=m['stem']: m['stem']=s
    for v,o,n in STEM:
        if vid==v: m['stem']=m['stem'].replace(o,n)
    for v,o,n in RAT:
        if vid==v:
            for l,r in m['rationales'].items():
                if o in r: m['rationales'][l]=r.replace(o,n)
json.dump(M,open('math_items.json','w'),indent=1,ensure_ascii=False)
C=json.load(open('ced_items.json'))
for c in C:
    s=strip_embedded(c['stem'])
    if s!=c['stem']: c['stem']=s
    for v,o,n in STEM:
        if c['content_key'].replace('u13-','')==v: c['stem']=c['stem'].replace(o,n)
json.dump(C,open('ced_items.json','w'),indent=1,ensure_ascii=False)
json.dump(sorted(changed),open('patched_ids.json','w'))
print(len(changed),"variants changed in the batch files")
left=[m['key'] for m in M if re.search(r"\n\s*A[\.\)]\s",m['stem'])]
print("embedded lists remaining in exported stems:",left)
