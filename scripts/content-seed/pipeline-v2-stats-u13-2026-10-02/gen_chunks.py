import json,hashlib
M=json.load(open('math_items.json')); man={x['key']:x for x in json.load(open('variants_manifest.json'))}
EPV='548f06be-ccf4-426d-b82b-b424137a4438'
q=lambda s:"'"+s.replace("'","''")+"'"
def ck(k): return k[len('u13-'):].replace('APSTATS-MCQ-','APSTATS-MCQ-SV-',1)
items=[]
for m in M:
    key=ck(m['key']); ch=sorted(m['choices'],key=lambda c:c['label'])
    canon=m['stem']+'|'+'|'.join(f"{c['label']}:{c['text']}:{str(c['label']==m['keyed_label']).lower()}:{m['rationales'][c['label']]}" for c in ch)
    items.append((key,m,ch,hashlib.md5(canon.encode()).hexdigest()))
json.dump({k:h for k,_,_,h in items},open('load_manifest.json','w'),indent=0)
N=12;per=11
for ci in range(N):
    part=items[ci*per:(ci+1)*per]
    keys=','.join(q(k) for k,_,_,_ in part)
    s=f"begin;\ndo $$ begin\n  if exists (select 1 from app.content_items where exam_pack_version_id='{EPV}' and content_key = any (array[{keys}])) then raise exception 'chunk already loaded'; end if;\nend $$;\n"
    for k,m,ch,h in part:
        s+=f"-- {k}\nwith item_ins as (\n  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)\n  select gen_random_uuid(), '{EPV}', {q(k)}, 'mcq', {q(man[m['key']]['title'])}, 'draft' returning id\n), version_ins as (\n  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)\n  select gen_random_uuid(), id, 1, {q(m['stem'])}, null, md5({q(k)}), 'draft', 'tutor_review_pending', {q(m['keyed_label'])}\n  from item_ins returning id\n)\ninsert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)\n"
        s+="\nunion all ".join(f"select gen_random_uuid(), id, {q(c['label'])}, {q(c['text'])}, {str(c['label']==m['keyed_label']).lower()}, {q(m['rationales'][c['label']])} from version_ins" for c in ch).replace("select gen_random_uuid(), id, 'A'","select gen_random_uuid(), id, 'A'",1)+";\n"
    s+="commit;\n"
    open(f'load/chunk_{ci+1:02d}.sql','w').write(s)
v="select ci.content_key, md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key)) h from app.content_items ci join app.content_item_versions civ on civ.content_item_id=ci.id join app.mcq_choices c on c.content_item_version_id=civ.id where ci.exam_pack_version_id='%s' and ci.content_key like 'APSTATS-MCQ-SV-%%' group by ci.content_key, civ.stem order by 1;"%EPV
open('load/verify_hashes.sql','w').write(v)
print(len(items),[len(open(f'load/chunk_{i:02d}.sql').read()) for i in range(1,13)])
