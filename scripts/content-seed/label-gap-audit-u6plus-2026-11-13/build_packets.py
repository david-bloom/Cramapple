#!/usr/bin/env python3
"""Stage 3 step 1 (read-only): build blind probe packets (student-visible text only; never a key, rationale or rubric) for the gap items
that need a model vote, plus per-subject taxonomy.json for the probe. Excludes the 30 apstats-frq-u45r2-% items (deterministic / inherit)."""
import importlib.util, json, os, collections
HERE = os.path.dirname(os.path.abspath(__file__))
spec = importlib.util.spec_from_file_location('pmb', os.path.join(HERE, '..', 'publish_mcq_batch.py'))
pmb = importlib.util.module_from_spec(spec); spec.loader.exec_module(pmb)
REF = pmb.ENVS['prod']
d = json.load(open(os.path.join(HERE, '../../../docs/qa/LABEL_GAP_AUDIT_UNITS_6PLUS_2026_11_13_ITEMS.json')))
G = [i for i in d['items'] if i['f']['vstatus'] == 'published' and i['in_scope'] and (not i['f']['topic_validated'] or i['f']['serving'] != 'ok')
     and i['f']['kind']=='seed']
print(len(G), 'items to vote')
by = collections.defaultdict(list)
for i in G: by[i['subject']].append(i)
ts = json.load(open(os.path.join(HERE, 'raw', '_taxonomy_topics.json')))
# units titles
units = pmb.query(REF, "select tsv.subject_key, u.unit_number, u.unit_title from app.taxonomy_source_versions tsv join app.taxonomy_units u using (taxonomy_source_version) order by 1,2")
os.makedirs(os.path.join(HERE, 'stage3'), exist_ok=True)
for sub, items in by.items():
    tax = {'units': [{'n': u['unit_number'], 'title': u['unit_title']} for u in units if u['subject_key'] == sub],
           'topics': [{'code': t['topic_code'], 'title': t['topic_title']} for t in ts if t['subject_key'] == sub], 'skills': []}
    json.dump(tax, open(os.path.join(HERE, 'stage3', f'taxonomy_{sub}.json'), 'w'), indent=0)
    vids = ','.join("'%s'" % i['vid'] for i in items)
    rows = pmb.query(REF, f"""select ci.content_key, ci.item_type, civ.id::text vid, civ.stem, civ.stimulus, civ.prompt_json->'parts' parts,
       coalesce((select string_agg(mc.choice_key||'. '||mc.choice_text, E'\\n' order by mc.choice_key) from app.mcq_choices mc where mc.content_item_version_id=civ.id),'') choices
       from app.content_item_versions civ join app.content_items ci on ci.id=civ.content_item_id where civ.id in ({vids})""")
    pk = []
    for r in rows:
        parts = r.get('parts') or []
        ptxt = '\n'.join(f"{p.get('label','')} {p.get('prompt','')}".strip() for p in parts if isinstance(p, dict) and p.get('prompt'))
        r['stem'] = r['stem'] + ('\n\nParts:\n' + ptxt if ptxt and ptxt[:40] not in (r['stem'] + (r['stimulus'] or '')) else '')
        body = 'Question stem:\n' + r['stem'] + ('\n\nStimulus:\n' + r['stimulus'] if r['stimulus'] else '') + ('\n\nChoices:\n' + r['choices'] if r['choices'] else '')
        pk.append({'content_key': r['content_key'], 'vid': r['vid'], 'item_type': r['item_type'], 'body': body})
    assert len(pk) == len(items), (sub, len(pk), len(items))
    json.dump(pk, open(os.path.join(HERE, 'stage3', f'packets_{sub}.json'), 'w'))
    print(sub, len(pk))
