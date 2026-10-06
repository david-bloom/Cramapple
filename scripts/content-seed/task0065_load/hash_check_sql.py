#!/usr/bin/env python3
"""Emit a read-only SQL query that compares loaded TASK-0065 text with the
source JSON (md5 of stem + choices). Usage: hash_check_sql.py [subject ...]"""
import hashlib, json, os, sys
sys.path.insert(0, os.path.dirname(__file__))
from build_load_sql import SRC, EXCLUDE, PREFIX
subs = set(sys.argv[1:]) or set(PREFIX)
rows = []
for it in json.load(open(SRC)):
    s = it['subject_key']
    if s not in subs or it['topic_code'] in EXCLUDE.get(s, set()):
        continue
    ch = sorted(it['choices'], key=lambda c: c['choice_key'])
    txt = it['stem'] + '|' + '|'.join(f"{c['choice_key']}:{c['choice_text']}:{str(c['is_correct']).lower()}:{c['rationale']}" for c in ch)
    rows.append((PREFIX[s] + it['topic_code'], hashlib.md5(txt.encode()).hexdigest()))
vals = ','.join(f"('{k}','{h}')" for k, h in rows)
print(f"""with exp(k,h) as (values {vals}),
got as (select ci.content_key k, md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key)) h
  from app.content_items ci join app.content_item_versions civ on civ.content_item_id=ci.id
  join app.mcq_choices c on c.content_item_version_id=civ.id
  where ci.content_key in (select k from exp) group by ci.content_key, civ.stem)
select (select count(*) from exp) expected, (select count(*) from got) loaded,
  (select count(*) from exp join got using (k) where exp.h=got.h) matching,
  (select string_agg(coalesce(exp.k,got.k),',') from exp full join got using (k) where exp.h is distinct from got.h) mismatched;""")
