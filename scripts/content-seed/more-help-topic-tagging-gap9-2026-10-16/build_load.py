"""Build the metadata-only, source-guarded four-cell topic load from the 64-cell templates.
Private inputs stay in /private/tmp; this script reads the frozen snapshot and writes SQL there."""
import hashlib, json, re, uuid
from pathlib import Path

HERE = Path(__file__).resolve().parent
TEMPLATE = HERE.parent / 'more-help-topic-tagging-65-2026-10-15'
OUT = Path('/private/tmp/more-help-tagging-gap9-votes-2026-10-16/load')
OUT.mkdir(parents=True, exist_ok=True)
snap = {r['content_key']: r for r in json.loads(Path('/private/tmp/more-help-tagging-gap9-snapshot-2026-10-16.json').read_text())}
APPROVAL = 'APPROVAL-0180'
decision_id = str(uuid.uuid5(uuid.NAMESPACE_URL, 'cramapple:%s:topic-gap4:2026-10-16' % APPROVAL))
run_id = 'more-help-topic-gap9-2026-10-16:three-families-two-samples+CED-read'
# Live serving label read from Production immediately before building (id, version, status).
labels = {
 'apphy1-frq-np1-004': ('ea818cea-6471-4eab-9663-b0a6ef2f683f', 1, 'validated'),
 'apprecalc-frq-016': ('7162c9cf-5e6f-444e-9fe6-e9d7f1165b4f', 2, 'validated'),
 'apprecalc-frq-u12-002': ('7e2d89a9-d0f5-4e28-a48b-05c26c8f532f', 3, 'provisional_model'),
 'apprecalc-mcq-sv-037-v3': ('478a6221-bac0-43d2-b711-4f97a52764cf', 1, 'validated'),
}
decisions = {  # content_key -> (topic, basis)
 'apphy1-frq-np1-004': ('2.5', '5of6'),
 'apprecalc-frq-016': ('3.13', '5of6'),
 'apprecalc-frq-u12-002': ('2.12', '6of6'),
 'apprecalc-mcq-sv-037-v3': ('1.13', '4of6_ced_confirmed'),
}
plan = []
for key, (topic, basis) in decisions.items():
    q = snap[key]
    lid, lver, lstat = labels[key]
    row = {'cell_id': str(uuid.uuid5(uuid.NAMESPACE_URL, 'cramapple:topic-gap4:%s:%s' % (q['content_item_version_id'], topic))),
           'version_id': q['content_item_version_id'], 'item_id': q['content_item_id'],
           'exam_pack_version_id': q['exam_pack_version_id'], 'subject_key': q['subject_key'],
           'taxonomy_source_version': q['taxonomy_source_version'], 'topic_code': topic,
           'source': 'more_help_topic_gap9_2026_10_16:' + basis, 'model_run_id': run_id, 'decision_id': decision_id,
           'version_md5': q['version_row_md5'], 'taxo_hash': q['taxonomy_relevant_hash'],
           'label_id': lid, 'label_version': lver, 'label_status': lstat}
    row['expected_md5'] = hashlib.md5('|'.join(str(row[k]) for k in ['cell_id', 'version_id', 'item_id', 'taxonomy_source_version',
        'topic_code', 'source', 'model_run_id', 'decision_id']).encode()).hexdigest()
    plan.append(row)
assert len(plan) == 4
plan_json = json.dumps(plan, separators=(',', ':'))

def adapt(text):
    text = re.sub(r'\$plan\$\[.*?\]\$plan\$', lambda m: '$plan$' + plan_json + '$plan$', text, flags=re.S)
    text = text.replace('topic65_plan', 'gap4_plan')
    text = text.replace('label_id uuid,label_version integer,expected_md5 text)', 'label_id uuid,label_version integer,expected_md5 text,label_status text)')
    # Counts and messages: 64 -> 4.
    text = text.replace('<>64', '<>4').replace("'Exact 64-version accepted plan required'", "'Exact 4-version accepted plan required'")
    text = text.replace("'64 primary topic cells verified'", "'4 primary topic cells verified'")
    text = text.replace("'64 new mappings removed; original absence restored'", "'4 new mappings removed; original absence restored'")
    old_label = "and l.label_scope='serving' and l.label_status='validated' and l.superseded_by is null\n     and l.validated_against_taxo_hash=p.taxo_hash"
    new_label = "and l.label_scope='serving' and l.label_status=p.label_status and l.superseded_by is null\n     and (p.label_status<>'validated' or l.validated_against_taxo_hash=p.taxo_hash)"
    if old_label in text: text = text.replace(old_label, new_label)
    text = text.replace('APPROVAL-0178', APPROVAL)
    return text

apply_sql = adapt((TEMPLATE / 'apply.sql').read_text())
rehearse_sql = adapt((TEMPLATE / 'rehearse.sql').read_text())
recovery_sql = adapt((TEMPLATE / 'recovery.sql').read_text())
for name, t in [('apply', apply_sql), ('rehearse', rehearse_sql), ('recovery', recovery_sql)]:
    assert '64' not in re.sub(r'\$plan\$.*?\$plan\$', '', t, flags=re.S), (name, [m.group(0) for m in re.finditer(r'.{20}64.{20}', re.sub(r'\$plan\$.*?\$plan\$', '', t, flags=re.S))])
assert "l.label_status=p.label_status" in apply_sql and "label_status text)" in apply_sql
(OUT / 'apply.sql').write_text(apply_sql)
(OUT / 'rehearse.sql').write_text(rehearse_sql)
(OUT / 'recovery.sql').write_text(recovery_sql)
# Combined rehearsal: apply body, then recovery body, in ONE transaction that ends in rollback.
body_apply = apply_sql.split('begin;', 1)[1].rsplit('commit;', 1)[0]
body_rec = recovery_sql.split('begin;', 1)[1].rsplit('commit;', 1)[0]
# Recovery body re-creates the temp table; drop the first copy so the names don't clash.
combined = 'begin;\n' + body_apply.replace('on commit drop', '') + '\ndrop table gap4_plan;\n' + body_rec.replace('on commit drop', '') + '\nrollback;\n'
(OUT / 'rehearse_recovery.sql').write_text(combined)
manifest = {'approval': APPROVAL, 'decision_id': decision_id, 'model_run_id': run_id,
            'cells': [{k: r[k] for k in ['cell_id', 'version_id', 'subject_key', 'topic_code', 'source', 'version_md5', 'taxo_hash', 'label_id', 'label_version', 'label_status', 'expected_md5']} | {'content_key': k} for r, k in zip(plan, decisions)]}
(HERE / 'manifest.json').write_text(json.dumps(manifest, indent=1))
print('built', [p['topic_code'] for p in plan], decision_id)
