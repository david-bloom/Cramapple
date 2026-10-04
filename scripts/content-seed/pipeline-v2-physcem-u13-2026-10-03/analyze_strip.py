import json,sys,collections
d=sys.argv[1] if len(sys.argv)>1 else ''
K={a['key']:a['keyed_label'] for a in json.load(open('strip_check_items.json'))}
res=collections.defaultdict(list)
for l in open(f'out_sblind_strip{d}/results.jsonl'):
    r=json.loads(l)
    if not r['ok']: print('BLINDERR',r['key'],r['error']);continue
    L=r['label']; m=r['model'].split('/')[1][:5]
    res[r['key']].append(f"blind {m}:{L['chosen_label'].strip()} multi={L['more_than_one_defensible_choice']} scope={L['scope_verdict']} {L['out_of_scope_concepts']} topic={L['primary_topic_code'].split()[0]}")
for l in open(f'out_saudit_strip{d}/results.jsonl'):
    r=json.loads(l)
    if not r['ok']: print('AUDERR',r['key'],r['error']);continue
    m=r['model'].split('/')[1][:5]; o=r['object']
    if r['pass']=='solve': res[r['key']].append(f"solve {m}:{o['chosen_label'].strip()} defect={o['defect'][:150]!r}")
    else:
        res[r['key']].append(f"audit {m}: keyOK={o['keyed_choice_correct']} badrat={[ (c['label'],c['issue'][:200]) for c in o['per_choice'] if not c['rationale_accurate']]} other={[str(x)[:200] for x in o['other_defects']]}")
for k in sorted(res):
    print(k,K[k]); [print('   ',x) for x in sorted(res[k])]
