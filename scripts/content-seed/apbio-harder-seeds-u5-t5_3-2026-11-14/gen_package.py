import json,hashlib,os
HERE=os.path.dirname(os.path.abspath(__file__)); os.chdir(HERE)
PACK='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7'; OWNER='f5a26c6b-3566-4d58-9e97-979fbb947564'
TSV='c676d1fc-3b58-4896-89e3-852d9bd1f81b'
SRC_TAG='apbio_u5_t5_3_2026_11_14'; CELL_TAG='apbio_u5_t5_3_2026_11_14_topic'
rows=json.load(open('items.json'))
def q(s): return "'"+s.replace("'","''")+"'"
def h(r):
    cs=sorted(r['choices'],key=lambda c:c['label'])
    return hashlib.md5((r['stem']+'|'+'|'.join(f"{c['label']}:{c['text']}:{str(c['is_correct']).lower()}:{c['rationale']}" for c in cs)).encode()).hexdigest()
for r in rows: r['h']=h(r)
N=len(rows); assert N==12
def block(r):
    ch=sorted(r['choices'],key=lambda c:c['label']); key=[c['label'] for c in ch if c['is_correct']][0]
    sel=[]
    for i,c in enumerate(ch):
        pre="select gen_random_uuid(), id, " if i==0 else "union all select gen_random_uuid(), id, "
        sel.append(f"{pre}{q(c['label'])}, {q(c['text'])}, {'true' if c['is_correct'] else 'false'}, {q(c['rationale'])} from version_ins")
    return f"""-- {r['content_key']}
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '{PACK}', {q(r['content_key'])}, 'mcq', {q(r['title'])}, 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, {q(r['stem'])}, null, md5({q(r['content_key'])}), 'draft', 'tutor_review_pending', {q(key)}
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
"""+"\n".join(sel)+";\n"
os.makedirs('load',exist_ok=True)
for f in os.listdir('load'): os.remove('load/'+f)
chunks=[];cur=[];sz=0
for r in rows:
    b=block(r)
    if cur and (len(cur)>=9 or sz+len(b.encode())>24000): chunks.append(cur);cur=[];sz=0
    cur.append((r,b));sz+=len(b.encode())
chunks.append(cur)
for i,c in enumerate(chunks,1):
    keys=",".join(q(r['content_key']) for r,_ in c)
    s=f"""begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='{PACK}' and content_key = any (array[{keys}])) then raise exception 'chunk {i} already loaded'; end if;
end $$;
"""+"".join(b for _,b in c)+f"""do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='{PACK}' and content_key = any (array[{keys}]) and status='draft')<>{len(c)} then raise exception 'chunk {i}: expected {len(c)} draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='{PACK}' and ci.content_key = any (array[{keys}]))<>{4*len(c)} then raise exception 'chunk {i}: expected {4*len(c)} choices'; end if;
end $$;
commit;
"""
    open(f'load/chunk_{i:02d}.sql','w').write(s)
manifest={r['content_key']:r['h'] for r in rows}
json.dump(manifest,open('load_manifest.json','w'),indent=1)
kl=",".join(f"({q(k)},{q(v)})" for k,v in manifest.items())
open('verify_hashes.sql','w').write(f"""-- Read-only. Expect 24 rows with ok = true after load (and after publish).
with exp(k,h) as (values {kl}),
got as (select ci.content_key k, ci.status item_status, civ.status version_status,
  md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key)) h
  from app.content_items ci join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
  join app.mcq_choices c on c.content_item_version_id=civ.id
  where ci.exam_pack_version_id='{PACK}' and (ci.content_key like 'apbio-mcq-b3-h-5.%' or ci.content_key like 'apbio-mcq-b3-sv-h-5.%')
  group by ci.content_key, ci.status, civ.status, civ.stem)
select e.k, g.item_status, g.version_status, (g.h=e.h) ok from exp e left join got g on g.k=e.k order by e.k;
""")
lab=",\n".join(f"({q(r['content_key'])},{q(r['topic'])},{q(r['h'])})" for r in rows)
NOTE="AP Biology Unit 5 harder seeds and variants (batch apbio_u5_t5_3_2026_11_14); owner-authorized production content release after the batch checks recorded in the status document. No subject-expert review is claimed."
body=f"""begin;
select pg_advisory_xact_lock(hashtext('cramapple-apbio-u5-t5-3-2026-11-14-publish-20261114'));
create temporary table lab (content_key text primary key, topic text, exp_hash text) on commit drop;
insert into lab values
{lab};
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id,
 '{TSV}'::uuid tsv, (case topic when '5.1' then array[4, 5] when '5.2' then array[5] when '5.3' then array[5] when '5.4' then array[5] when '5.5' then array[5] end)::int[] req, 5 pu
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id='{PACK}'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
where ci.status='draft' and civ.status='draft';
do $$ begin
 if (select count(*) from tgt)<>{N} then raise exception 'expected {N} draft targets, got %', (select count(*) from tgt); end if;
 if exists (select 1 from tgt where split_part(topic,'.',1)::int<>pu) then raise exception 'topic/unit mismatch'; end if;
 if exists (select 1 from tgt t join app.content_item_cells c on c.content_item_version_id=t.version_id) or exists (select 1 from tgt t join app.content_taxonomy_labels l on l.content_item_id=t.item_id) then raise exception 'a target already has cells or labels'; end if;
 if (select count(*) from (select t.content_key from tgt t join app.content_item_versions civ on civ.id=t.version_id join app.mcq_choices c on c.content_item_version_id=civ.id group by t.content_key, civ.stem, t.exp_hash having md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key))=t.exp_hash) z)<>{N} then raise exception 'loaded text does not match the build manifest'; end if;
 if exists (select 1 from tgt t where not exists (select 1 from app.taxonomy_topics tt where tt.taxonomy_source_version=t.tsv and tt.topic_code=t.topic)) then raise exception 'a topic code is not present in the taxonomy source version'; end if;
end $$;
insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select assignment_id, version_id, '{OWNER}'::uuid, 'tutor_question', 'mcq', 'pending', 'owner_remediation_approval', '{OWNER}'::uuid from tgt;
insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, tutor_decision, decision_payload, decision_hash, created_by)
select assignment_id, version_id, '{OWNER}'::uuid, 'tutor_question', 1, null, false, array[]::text[],
 {q(NOTE)},
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apbio_u5_t5_3_2026_11_14_po_approval','qa_date','2026-11-14','content_key',content_key),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apbio_u5_t5_3_2026_11_14_po_approval','qa_date','2026-11-14','content_key',content_key)::text),
 '{OWNER}'::uuid from tgt;
create temporary table qa_blocked on commit drop as
select g.content_key, case
 when nullif(trim(civ.stem),'') is null then 'blank stem'
 when (select count(*) from app.mcq_choices m where m.content_item_version_id=civ.id)<>4 then 'choice count'
 when (select count(distinct lower(trim(m.choice_text))) from app.mcq_choices m where m.content_item_version_id=civ.id)<>4 then 'duplicate choice text'
 when (select count(*) from app.mcq_choices m where m.content_item_version_id=civ.id and m.is_correct)<>1 then 'correct key count'
 when exists (select 1 from app.mcq_choices m where m.content_item_version_id=civ.id and nullif(trim(coalesce(m.rationale,'')),'') is null) then 'blank rationale'
 when civ.canonical_answer_1 is distinct from (select m.choice_key from app.mcq_choices m where m.content_item_version_id=civ.id and m.is_correct) then 'canonical letter mismatch'
 end reason
from tgt g join app.content_item_versions civ on civ.id=g.version_id;
delete from qa_blocked where reason is null;
do $$ begin if exists (select 1 from qa_blocked) then raise exception 'structural QA blocked: %', (select string_agg(content_key||':'||reason, ', ') from qa_blocked); end if; end $$;
update app.content_item_versions civ set status='reviewed_approved', review_status='question_review_approved', approved_by='{OWNER}'::uuid, approved_at=coalesce(civ.approved_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='reviewed_approved', updated_at=now() from tgt where ci.id=tgt.item_id;
insert into app.content_taxonomy_labels (content_taxonomy_label_id, content_item_id, label_version, label_scope, required_units, max_required_unit, primary_unit, assessed_topics, taxonomy_source_version, taxonomy_confidence, label_status, source, source_payload, model_run_id, created_by)
select label_id, item_id, 1, 'serving', req, 5, pu, array[]::text[], tsv, 'provisional', 'provisional_model',
 '{SRC_TAG}',
 jsonb_build_object('origin','owner_authored','units_source','AP Biology Unit 5 (topics 5.x belong to unit 5; required_units set per topic from verified serving labels and taxonomy mapping)','topic',topic,'report','scripts/content-seed/apbio-harder-seeds-u5-t5_3-2026-11-14'),
 'apbio-u5-t5-3-2026-11-14-labeling', '{OWNER}'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, '{OWNER}'::uuid, 'confirmed', 'chat_review', pu, req,
 'Product Owner chat instruction 2026-11-14 (AP Biology harder seeds and variants). Topic assigned by the author from the question design (topic recorded on the cell); topic-only tagging, skill left null.' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', '{CELL_TAG}',
 'apbio-u5-t5-3-2026-11-14-labeling (topic set by the author from the question design)', null, now(), gen_random_uuid() from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='{OWNER}'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>{N} then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>{N} then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells where source='{CELL_TAG}' and is_primary and superseded_by is null; if n<>{N} then raise exception 'topic cell count %', n; end if;
end $$;
"""
open('publish_rehearsal.sql','w').write(body+f"""do $$ begin raise exception 'REHEARSAL OK (rolled back): published=%, validated_labels=%, topic_cells=%', (select count(*) from tgt), (select count(*) from app.content_taxonomy_labels where source='{SRC_TAG}' and label_status='validated'), (select count(*) from app.content_item_cells where source='{CELL_TAG}'); end $$;
rollback;
""")
open('publish.sql','w').write(body+f"""select (select count(*) from tgt) published, (select count(*) from app.content_taxonomy_labels where source='{SRC_TAG}' and label_status='validated') validated_labels, (select count(*) from app.content_item_cells where source='{CELL_TAG}') topic_cells;
commit;
""")
# retirement of the superseded items
OLD=json.load(open('superseded_keys.json'))
NOLD=len(OLD)
assert NOLD==len(set(OLD))
ol=",".join(q(k) for k in OLD)
rbody=f"""begin;
select pg_advisory_xact_lock(hashtext('cramapple-apbio-u5-t5-3-2026-11-14-retire-20261114'));
create temporary table old on commit drop as
select ci.id item_id, civ.id version_id, ci.content_key
from app.content_items ci join app.content_item_versions civ on civ.content_item_id=ci.id and civ.status='published'
where ci.exam_pack_version_id='{PACK}' and ci.item_type='mcq' and ci.status='published' and ci.content_key in ({ol});
do $$ begin
 if (select count(*) from old)<>{NOLD} then raise exception 'expected {NOLD} published superseded items, got %', (select count(*) from old); end if;
 if (select count(*) from app.content_items where exam_pack_version_id='{PACK}' and status='published' and (content_key like 'apbio-mcq-b3-h-5.%' or content_key like 'apbio-mcq-b3-sv-h-5.%'))<>{N} then raise exception 'the {N} new items are not all published; publish first'; end if;
end $$;
update app.content_review_assignments set status='skipped' where content_item_version_id in (select version_id from old) and assignment_purpose='subject_review' and status in ('pending','in_progress');
update app.content_item_versions set status='retired', updated_at=now() where id in (select version_id from old);
update app.content_items set status='retired', updated_at=now() where id in (select item_id from old);
do $$ declare n int; begin
 select count(*) into n from app.content_items where id in (select item_id from old) and status='retired'; if n<>{NOLD} then raise exception 'retire count %', n; end if;
 select count(*) into n from app.content_items ci where ci.exam_pack_version_id='{PACK}' and ci.status='published' and not exists (select 1 from app.content_item_versions v where v.content_item_id=ci.id and v.status='published') and ci.item_type='mcq';
 raise notice 'published MCQ items without a published version (pre-existing defects count too): %', n;
end $$;
"""
open('retire_old_rehearsal.sql','w').write(rbody+"""do $$ begin raise exception 'REHEARSAL OK (rolled back): retired=%', (select count(*) from old); end $$;
rollback;
""")
open('retire_old.sql','w').write(rbody+"""select count(*) retired from old;
commit;
""")
open('superseded_keys.json','w').write(json.dumps(OLD,indent=1))
print("chunks",len(chunks),"items",N,"old",len(OLD))
for f in sorted(os.listdir('.')): print(f, os.path.getsize(f) if os.path.isfile(f) else 'dir')
