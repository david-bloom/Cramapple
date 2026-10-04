import json,hashlib,os
PACK='ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9'; OWNER='f5a26c6b-3566-4d58-9e97-979fbb947564'
def q(s): return "'"+s.replace("'","''")+"'"
DROP={
'apphycm-mcq-002-v1':'topic drift: both blind checkers placed it in 1.3 (seed topic 1.2)',
'apphycm-mcq-002-v2':'topic drift: both blind checkers placed it in 1.3 (seed topic 1.2)',
'apphycm-mcq-022-v1':'topic drift: both blind checkers placed it in 1.2 (seed topic 1.3)',
'apphycm-mcq-022-v2':'topic drift: checkers split 1.3/1.2, not both in seed topic 1.3',
'apphycm-mcq-022-v3':'topic drift: both blind checkers placed it in 1.2 (seed topic 1.3)',
'apphycm-mcq-029-v1':'unit drift: spring-oscillation context, checkers required units [3,7] and [2,3,7] (seed unit 3, topic 3.4)',
'apphycm-mcq-029-v2':'topic drift: checkers split 3.3/3.4, not both in seed topic 3.4; also a rationale defect',
'apphycm-mcq-029-v3':'topic drift: checkers split 3.3/3.4, not both in seed topic 3.4; also an unstated-direction rationale defect'}
M=json.load(open('math_items.json')); man={m['key']:m for m in json.load(open('variants_manifest.json'))}
keep=[m for m in M if m['key'][4:] not in DROP]
assert len(keep)==43
def lk(m):
    sid,vn=m['key'][4:].rsplit('-v',1); return sid.replace('apphycm-mcq-','apphycm-mcq-sv-')+'-v'+vn
def hsh(m):
    cs=sorted(m['choices'],key=lambda c:c['label'])
    return hashlib.md5((m['stem']+'|'+'|'.join(f"{c['label']}:{c['text']}:{str(c['label']==m['keyed_label']).lower()}:{m['rationales'][c['label']]}" for c in cs)).encode()).hexdigest()
rows=[]
for m in keep:
    rows.append(dict(lk=lk(m),seed=m['key'][4:].rsplit('-v',1)[0],m=m,title=man[m['key']]['title'],diff=man[m['key']]['difficulty'],h=hsh(m)))
# chunks by size
def block(r):
    m=r['m']; ch=sorted(m['choices'],key=lambda c:c['label'])
    sel=[]
    for i,c in enumerate(ch):
        pre="select gen_random_uuid(), id, " if i==0 else "union all select gen_random_uuid(), id, "
        sel.append(f"{pre}{q(c['label'])}, {q(c['text'])}, {'true' if c['label']==m['keyed_label'] else 'false'}, {q(m['rationales'][c['label']])} from version_ins")
    return f"""-- {r['lk']}
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '{PACK}', {q(r['lk'])}, 'mcq', {q(r['title'])}, 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, {q(m['stem'])}, null, md5({q(r['lk'])}), 'draft', 'tutor_review_pending', {q(m['keyed_label'])}
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
"""+"\n".join(sel)+";\n"
chunks=[];cur=[];sz=0
for r in rows:
    b=block(r)
    if cur and (len(cur)>=10 or sz+len(b.encode())>24000): chunks.append(cur);cur=[];sz=0
    cur.append((r,b));sz+=len(b.encode())
chunks.append(cur)
os.makedirs('load',exist_ok=True)
for f in os.listdir('load'): os.remove('load/'+f)
for i,c in enumerate(chunks,1):
    keys=",".join(q(r['lk']) for r,_ in c)
    s=f"""begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='{PACK}' and content_key = any (array[{keys}])) then raise exception 'chunk already loaded'; end if;
end $$;
"""+"".join(b for _,b in c)
    s+=f"""do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='{PACK}' and content_key = any (array[{keys}]) and status='draft')<>{len(c)} then raise exception 'chunk {i}: expected {len(c)} draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='{PACK}' and ci.content_key = any (array[{keys}]))<>{4*len(c)} then raise exception 'chunk {i}: choice rows'; end if;
end $$;
commit;
"""
    open(f'load/chunk_{i:02d}.sql','w').write(s)
manifest={r['lk']:r['h'] for r in rows}
json.dump(manifest,open('load_manifest.json','w'),indent=1); json.dump({r['lk']:r['seed'] for r in rows},open('load_seedmap.json','w'),indent=1)
kl=",".join(f"({q(k)},{q(h)})" for k,h in manifest.items())
open('hash_sql.txt','w').write(f"with exp(k,h) as (values {kl}), got as (select ci.content_key k, md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key)) h from app.content_items ci join app.content_item_versions civ on civ.content_item_id=ci.id join app.mcq_choices c on c.content_item_version_id=civ.id where ci.exam_pack_version_id='{PACK}' and ci.content_key in (select k from exp) group by ci.content_key, civ.stem) select (select count(*) from exp) expected, (select count(*) from got) loaded, (select count(*) from exp join got using(k) where exp.h=got.h) matching, (select string_agg(coalesce(exp.k,got.k),',') from exp full join got using(k) where exp.h is distinct from got.h) mismatched;")
# publish
lab=",\n".join(f"({q(r['lk'])},{q(r['seed'])},{q(r['h'])})" for r in rows)
N=len(rows)
body=f"""begin;
select pg_advisory_xact_lock(hashtext('cramapple-apphycm-variants-publish-20261003'));
create temporary table lab (content_key text primary key, seed text, exp_hash text) on commit drop;
insert into lab values
{lab};
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id,
 sl.required_units req, sl.primary_unit pu, sl.taxonomy_source_version tsv, sc.topic_code topic
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id='{PACK}'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
join app.content_items si on si.content_key=l.seed and si.exam_pack_version_id='{PACK}' and si.status='published'
join app.content_item_versions sv on sv.content_item_id=si.id and sv.status='published'
join app.content_taxonomy_labels sl on sl.content_item_id=si.id and sl.label_scope='serving' and sl.superseded_by is null and sl.label_status='validated'
join app.content_item_cells sc on sc.content_item_version_id=sv.id and sc.is_primary and sc.superseded_by is null and sc.assignment_status='validated'
where ci.status='draft' and civ.status='draft';
do $$ begin
 if (select count(*) from tgt)<>{N} then raise exception 'expected {N} draft targets with a validated seed label and topic cell, got %', (select count(*) from tgt); end if;
 if exists (select 1 from tgt where split_part(topic,'.',1)::int<>pu or pu<>(select max(u) from unnest(req) u)) then raise exception 'seed unit/topic/required-unit mismatch'; end if;
 if exists (select 1 from tgt t join app.content_item_cells c on c.content_item_version_id=t.version_id) or exists (select 1 from tgt t join app.content_taxonomy_labels l on l.content_item_id=t.item_id) then raise exception 'a target already has cells or labels'; end if;
 if (select count(*) from (select t.content_key from tgt t join app.content_item_versions civ on civ.id=t.version_id join app.mcq_choices c on c.content_item_version_id=civ.id group by t.content_key, civ.stem, t.exp_hash having md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key))=t.exp_hash) z)<>{N} then raise exception 'loaded text does not match the build manifest'; end if;
end $$;
insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select assignment_id, version_id, '{OWNER}'::uuid, 'tutor_question', 'mcq', 'pending', 'owner_remediation_approval', '{OWNER}'::uuid from tgt;
insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, tutor_decision, decision_payload, decision_hash, created_by)
select assignment_id, version_id, '{OWNER}'::uuid, 'tutor_question', 1, null, false, array[]::text[],
 'AP Physics C: Mechanics Units 1-3 variants: publication on Product Owner chat instruction 2026-10-03 (continue: Units 1-3 pipeline). Seed audit and repair; python-verified authoring; two-model blind solve and rationale audit (Gemini 3.8 Flash + DeepSeek V4 Pro) with patch rounds and re-audit; CED scope and topic check against the seed.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apphycm_variants_po_approval','qa_date','2026-10-03','content_key',content_key,'seed',seed),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apphycm_variants_po_approval','qa_date','2026-10-03','content_key',content_key,'seed',seed)::text),
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
select label_id, item_id, 1, 'serving', req, (select max(u) from unnest(req) u), pu, array[]::text[], tsv, 'provisional', 'provisional_model',
 'apphycm_variants_2026_10_03',
 jsonb_build_object('origin','inherited_from_seed','seed',seed,'units_source','seed current validated serving label; two blind checkers (Gemini 3.8 Flash, DeepSeek V4 Pro) placed the variant in the seed unit and none above it','topic',topic,'report','scripts/content-seed/pipeline-v2-physcm-u13-2026-10-03'),
 'apphycm-variants-labeling-2026-10-03', '{OWNER}'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, '{OWNER}'::uuid, 'confirmed', 'automated_spot_check', pu, req,
 'Product Owner chat instruction 2026-10-03 (continue: Units 1-3 pipeline, AP Physics C: Mechanics). Variant inherits its seed unit, required units and topic after a two-checker blind check (unit and topic agreement with the seed).' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', 'apphycm_variants_topic_2026_10_03',
 'apphycm-variants-labeling-2026-10-03 (two blind checkers; topic inherited from the validated seed cell)', null, now(), gen_random_uuid() from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='{OWNER}'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>{N} then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>{N} then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells where source='apphycm_variants_topic_2026_10_03' and is_primary and superseded_by is null; if n<>{N} then raise exception 'topic cell count %', n; end if;
end $$;
"""
open('publish_rehearsal.sql','w').write(body+"""do $$ begin raise exception 'REHEARSAL OK (rolled back): published=%, validated_labels=%, topic_cells=%', (select count(*) from tgt), (select count(*) from app.content_taxonomy_labels where source='apphycm_variants_2026_10_03' and label_status='validated'), (select count(*) from app.content_item_cells where source='apphycm_variants_topic_2026_10_03'); end $$;
rollback;
""")
open('publish.sql','w').write(body+"""select (select count(*) from tgt) published, (select count(*) from app.content_taxonomy_labels where source='apphycm_variants_2026_10_03' and label_status='validated') validated_labels, (select count(*) from app.content_item_cells where source='apphycm_variants_topic_2026_10_03') topic_cells;
commit;
""")
# flags / patch records
json.dump({'dropped':DROP,'kept':N,'flagged_first_pass':{
'apphycm-mcq-001-v1':'RAT B units wording (patched)','apphycm-mcq-021-v2':'RAT C (patched)','apphycm-mcq-018-v2':'RAT C force zero at endpoint (patched)','apphycm-mcq-018-v3':'RAT A antiderivative sign (patched)','apphycm-mcq-025-v3':'RAT A dimensional (patched)','apphycm-mcq-026-v3':'stem asked magnitude but choices carry direction (stem patched) + RAT D (patched)','apphycm-mcq-027-v1':'RAT D too strong (patched)','apphycm-mcq-028-v3':'RAT A sign (patched)','apphycm-mcq-030-v1':'RAT B dimensional (patched)',
'apphycm-mcq-029-v2':'RAT (dropped)','apphycm-mcq-029-v3':'RAT (dropped)'},
'patched_reaudit':'9 patched items re-solved and re-audited by both checkers: 0 flags'},open('vflags.json','w'),indent=1)
print(len(chunks),[len(c) for c in chunks])
