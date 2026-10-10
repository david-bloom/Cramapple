#!/usr/bin/env python3
"""List every given item that a gate flagged, with the specific objections, for Claude's arbitration."""
import json, glob, os, sys
HERE = os.path.dirname(os.path.abspath(__file__))
only = sys.argv[1] if len(sys.argv) > 1 else None
for f in sorted(glob.glob(os.path.join(HERE, 'slots', '*.json'))):
    s = json.load(open(f))
    if s['status'] != 'given_flagged' or (only and only not in s['id']): continue
    c = s['candidates'][-1]
    print(f"\n### {s['id']}  stage={c['stage']}")
    if c.get('lint'): print('  lint:', c['lint'])
    if c.get('py') and not c['py']['ok']: print('  recompute:', c['py']['out'][-300:])
    if c.get('probe') and not c['probe']['pass']: print('  topic votes:', c['probe']['votes'], 'required units:', c['probe']['required_units'])
    for ch in c.get('checks') or []:
        if ch['pass']: continue
        fl = (ch.get('second') or ch.get('first') or {}).get('failed') or [ch.get('error', '')]
        for x in fl: print(f"  {ch['model'].split('/')[1]}: {x[:600]}")
