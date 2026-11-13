#!/usr/bin/env python3
"""Stage 1 analysis of raw/*.json (read-only). Writes gap_items.json (every in-scope item with its gap flags) and prints the table.
Definition of 'missing' (from live Production selector `select_student_practice_items`, view `content_item_topic_resolution`, trigger hash `taxonomy_relevant_hash`):
 in scope  = item.status published AND latest version status published AND not teaching AND unit in the subject's first five registry units.
 topic     = a primary cell (skill_code null) on the LATEST version with assignment_status validated  (selector also accepts 'authored'; reported separately)
 skill     = >=1 non-primary cell with a skill_code on the latest version, status validated (provisional_model reported separately)
 serving   = latest non-superseded label_scope=serving with label_status validated AND validated_against_taxo_hash == current hash AND max_required_unit set
 difficulty= >=1 content_item_difficulty row on the latest version
"""
import json, os, re, collections, sys
HERE = os.path.dirname(os.path.abspath(__file__)); RAW = os.path.join(HERE, 'raw')
tax = json.load(open(os.path.join(RAW, '_taxonomy_topics.json')))
units = collections.defaultdict(set)
topics = collections.defaultdict(dict)
for t in tax: units[t['subject_key']].add(t['unit_number']); topics[t['subject_key']][t['topic_code']] = t['unit_number']
SCOPE = {k: sorted(v)[:5] for k, v in units.items()}
SCOPE_NOTE = {k: sorted(v) for k, v in units.items()}
out, summ = [], collections.OrderedDict()
for code in sorted(SCOPE):
    rows = json.load(open(os.path.join(RAW, code + '.json')))
    S = collections.Counter()
    for r in rows:
        r['subject'] = code
        pcells = [c for c in r['cells'] if c['p']]
        scells = [c for c in r['cells'] if c['s']]
        val_topic = [c for c in pcells if c['st'] == 'validated' and not c['s']]
        auth_topic = [c for c in pcells if c['st'] == 'authored']
        prov_topic = [c for c in pcells if c['st'] == 'provisional_model']
        act = [l for l in r['labels'] if not l['sup']]
        act_v = [l for l in act if l['st'] == 'validated']
        lab = act_v[-1] if act_v else None
        lab_state = ('none' if not act else None)
        if lab:
            lab_state = 'ok' if (lab['hm'] and lab['mx'] is not None) else 'stale_hash'
        elif act:
            lab_state = 'only_' + act[-1]['st']
        # unit
        u_topic = val_topic[0]['unit'] if val_topic else (auth_topic[0]['unit'] if auth_topic else (prov_topic[0]['unit'] if prov_topic else None))
        u_label = (lab or (act[-1] if act else {})).get('pu') if act else None
        u_label2 = (lab or (act[-1] if act else {})).get('mx') if act else None
        u_pj = int(r['pj_unit']) if (r['pj_unit'] or '').isdigit() else None
        if u_pj is None and r['pj_topic']:
            m = re.match(r'\s*(\d+)\.\d+', r['pj_topic']); u_pj = int(m.group(1)) if m else None
        u = u_topic if u_topic is not None else (u_label if u_label is not None else (u_label2 if u_label2 is not None else u_pj))
        usrc = 'cell' if u_topic is not None else ('label' if (u_label is not None or u_label2 is not None) else ('prompt_json' if u_pj is not None else 'none'))
        kind = 'variant' if (re.search(r'-v\d+$', r['content_key'], re.I) or r['pkind'] == 'variant') else 'seed'
        flags = dict(unit=u, unit_src=usrc, kind=kind, topic_validated=bool(val_topic), topic_authored_only=(not val_topic and bool(auth_topic)),
                     topic_provisional_only=(not val_topic and not auth_topic and bool(prov_topic)),
                     skill_validated=any(c['st'] == 'validated' for c in scells), skill_provisional_only=(not any(c['st'] == 'validated' for c in scells) and bool(scells)),
                     serving=lab_state, difficulty=bool(r['diffs']),
                     conflicts=[x for x in [('unit_cell_vs_label' if (u_topic and u_label and u_topic != u_label) else None), ('unit_cell_vs_prompt' if (u_topic and u_pj and u_topic != u_pj) else None)] if x],
                     cells_other_versions=r['cells_other_versions'], n_pub_versions=r['n_pub_versions'], vstatus=r['vstatus'])
        r['f'] = flags
        r['in_scope'] = (r['vstatus'] == 'published' and not r['teaching'] and u in SCOPE[code]) if u is not None else None
        out.append({k: r[k] for k in ('subject', 'item_id', 'content_key', 'item_type', 'frq_form', 'vid', 'version_num', 'f', 'in_scope', 'pj_topic', 'pseed')})
json.dump({'scope_units': SCOPE, 'taxonomy_units': SCOPE_NOTE, 'items': out}, open(os.path.join(HERE, 'gap_items.json'), 'w'))
print('SCOPE', json.dumps(SCOPE))
