import json,hashlib,os
OWNER='f5a26c6b-3566-4d58-9e97-979fbb947564'
PACKS={'em':'841a88cc-773c-44e5-97fa-6504f8667689','cm':'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9','p2':'f584ab0d-114a-4520-9649-42e3e9a2fd22'}
SEEDPACK={'apphycem-mcq-003':'em','apphycm-mcq-023':'cm','apphycm-mcq-031':'cm','apphy2-mcq-001':'p2'}
def q(s): return "'"+s.replace("'","''")+"'"
fl=json.load(open('vflags.json')); DROP=fl['dropped']
M=json.load(open('math_items.json')); man={m['key']:m for m in json.load(open('variants_manifest.json'))}
keep=[m for m in M if m['key'][4:] not in DROP]
N=len(keep); assert N==fl['kept'],(N,fl['kept'])
def lk(m):
    sid,vn=m['key'][4:].rsplit('-v',1); return sid.replace('-mcq-','-mcq-sv-')+'-v'+vn
def hsh(m):
    cs=sorted(m['choices'],key=lambda c:c['label'])
    return hashlib.md5((m['stem']+'|'+'|'.join(f"{c['label']}:{c['text']}:{str(c['label']==m['keyed_label']).lower()}:{m['rationales'][c['label']]}" for c in cs)).encode()).hexdigest()
rows=[]
for m in keep:
    seed=m['key'][4:].rsplit('-v',1)[0]
    rows.append(dict(lk=lk(m),seed=seed,pack=PACKS[SEEDPACK[seed]],m=m,title=man[m['key']]['title'],h=hsh(m)))
def block(r):
    m=r['m']; ch=sorted(m['choices'],key=lambda c:c['label']); sel=[]
    for i,c in enumerate(ch):
        pre="select gen_random_uuid(), id, " if i==0 else "union all select gen_random_uuid(), id, "
        sel.append(f"{pre}{q(c['label'])}, {q(c['text'])}, {'true' if c['label']==m['keyed_label'] else 'false'}, {q(m['rationales'][c['label']])} from version_ins")
    return f"""-- {r['lk']}
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '{r['pack']}', {q(r['lk'])}, 'mcq', {q(r['title'])}, 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, {q(m['stem'])}, null, md5({q(r['lk'])}), 'draft', 'tutor_review_pending', {q(m['keyed_label'])}
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
"""+"\n".join(sel)+";\n"
pairs=",".join(f"({q(r['pack'])}::uuid,{q(r['lk'])})" for r in rows)
s=f"""begin;
select pg_advisory_xact_lock(hashtext('cramapple-heldfour-variants-load-20261004'));
do $$ begin
  if exists (select 1 from app.content_items ci join (values {pairs}) p(pack,k) on ci.exam_pack_version_id=p.pack and ci.content_key=p.k) then raise exception 'chunk already loaded'; end if;
end $$;
"""+"".join(block(r) for r in rows)+f"""do $$ begin
  if (select count(*) from app.content_items ci join (values {pairs}) p(pack,k) on ci.exam_pack_version_id=p.pack and ci.content_key=p.k where ci.status='draft')<>{N} then raise exception 'expected {N} draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id join (values {pairs}) p(pack,k) on ci.exam_pack_version_id=p.pack and ci.content_key=p.k)<>{4*N} then raise exception 'choice rows'; end if;
end $$;
commit;
"""
os.makedirs('load',exist_ok=True)
for f in os.listdir('load'): os.remove('load/'+f)
open('load/chunk_01.sql','w').write(s)
manifest={r['lk']:r['h'] for r in rows}
json.dump(manifest,open('load_manifest.json','w'),indent=1); json.dump({r['lk']:dict(seed=r['seed'],pack=r['pack']) for r in rows},open('load_seedmap.json','w'),indent=1)
kl=",".join(f"({q(r['pack'])}::uuid,{q(r['lk'])},{q(r['h'])})" for r in rows)
open('hash_sql.txt','w').write(f"with exp(p,k,h) as (values {kl}), got as (select exp.p, ci.content_key k, md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key)) h from exp join app.content_items ci on ci.exam_pack_version_id=exp.p and ci.content_key=exp.k join app.content_item_versions civ on civ.content_item_id=ci.id join app.mcq_choices c on c.content_item_version_id=civ.id group by exp.p, ci.content_key, civ.stem) select (select count(*) from exp) expected, (select count(*) from got) loaded, (select count(*) from exp join got using(p,k) where exp.h=got.h) matching, (select string_agg(coalesce(exp.k,got.k),',') from exp full join got using(p,k) where exp.h is distinct from got.h) mismatched;")
lab=",\n".join(f"({q(r['lk'])},{q(r['pack'])}::uuid,{q(r['seed'])},{q(r['h'])})" for r in rows)
LS='heldfour_variants_2026_10_04'; CS='heldfour_variants_topic_2026_10_04'
body=f"""begin;
select pg_advisory_xact_lock(hashtext('cramapple-heldfour-variants-publish-20261004'));
create temporary table lab (content_key text primary key, pack uuid, seed text, exp_hash text) on commit drop;
insert into lab values
{lab};
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id,
 sl.required_units req, sl.primary_unit pu, sl.taxonomy_source_version tsv, sc.topic_code topic
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id=l.pack
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
join app.content_items si on si.content_key=l.seed and si.exam_pack_version_id=l.pack and si.status='published'
join app.content_item_versions sv on sv.content_item_id=si.id and sv.status='published'
join app.content_taxonomy_labels sl on sl.content_item_id=si.id and sl.label_scope='serving' and sl.superseded_by is null and sl.label_status='validated'
join app.content_item_cells sc on sc.content_item_version_id=sv.id and sc.is_primary and sc.superseded_by is null and sc.assignment_status='validated'
where ci.status='draft' and civ.status='draft';
do $$ begin
 if (select count(*) from tgt)<>{N} then raise exception 'expected {N} draft targets with a validated seed label and topic cell, got %', (select count(*) from tgt); end if;
 if exists (select 1 from tgt where split_part(topic,'.',1)::int<>pu or pu<>(select max(u) from unnest(req) u)) then raise exception 'seed unit/topic/required-unit mismatch'; end if;
 if exists (select 1 from tgt t join app.content_item_cells c on c.content_item_version_id=t.version_id) or exists (select 1 from tgt t join app.content_taxonomy_labels l on l.content_item_id=t.item_id) then raise exception 'a target already has cells or labels'; end if;
 if exists (select 1 from app.content_taxonomy_labels where source='{LS}') or exists (select 1 from app.content_item_cells where source='{CS}') then raise exception 'already published (label or cell source exists)'; end if;
 if (select count(*) from (select t.content_key from tgt t join app.content_item_versions civ on civ.id=t.version_id join app.mcq_choices c on c.content_item_version_id=civ.id group by t.content_key, civ.stem, t.exp_hash having md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key))=t.exp_hash) z)<>{N} then raise exception 'loaded text does not match the build manifest'; end if;
end $$;
insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select assignment_id, version_id, '{OWNER}'::uuid, 'tutor_question', 'mcq', 'pending', 'owner_remediation_approval', '{OWNER}'::uuid from tgt;
insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, tutor_decision, decision_payload, decision_hash, created_by)
select assignment_id, version_id, '{OWNER}'::uuid, 'tutor_question', 1, null, false, array[]::text[],
 'Held-four seed variants (AP Physics C E&M, AP Physics C Mechanics, AP Physics 2): publication on Product Owner chat instruction 2026-10-04. Python/sympy-verified authoring; two-model blind solve and rationale audit (Gemini 3.8 Flash + DeepSeek V4 Pro); CED scope and topic check against the seed.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','heldfour_variants_po_approval','qa_date','2026-10-04','content_key',content_key,'seed',seed),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','heldfour_variants_po_approval','qa_date','2026-10-04','content_key',content_key,'seed',seed)::text),
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
 '{LS}',
 jsonb_build_object('origin','inherited_from_seed','seed',seed,'units_source','seed current validated serving label; two blind checkers (Gemini 3.8 Flash, DeepSeek V4 Pro) placed the variant in the seed unit and none above it','topic',topic,'report','scripts/content-seed/release-held-four-2026-10-04'),
 'heldfour-variants-labeling-2026-10-04', '{OWNER}'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, '{OWNER}'::uuid, 'confirmed', 'automated_spot_check', pu, req,
 'Product Owner chat instruction 2026-10-04 (held-four seed variants). Variant inherits its seed unit, required units and topic after a two-checker blind check (unit and topic agreement with the seed).' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', '{CS}',
 'heldfour-variants-labeling-2026-10-04 (two blind checkers; topic inherited from the validated seed cell)', null, now(), gen_random_uuid() from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='{OWNER}'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>{N} then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>{N} then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells where source='{CS}' and is_primary and superseded_by is null; if n<>{N} then raise exception 'topic cell count %', n; end if;
end $$;
"""
open('publish_rehearsal.sql','w').write(body+f"""do $$ begin raise exception 'REHEARSAL OK (rolled back): published=%, validated_labels=%, topic_cells=%', (select count(*) from tgt), (select count(*) from app.content_taxonomy_labels where source='{LS}' and label_status='validated'), (select count(*) from app.content_item_cells where source='{CS}'); end $$;
rollback;
""")
open('publish.sql','w').write(body+f"""select (select count(*) from tgt) published, (select count(*) from app.content_taxonomy_labels where source='{LS}' and label_status='validated') validated_labels, (select count(*) from app.content_item_cells where source='{CS}') topic_cells;
commit;
""")
print(N,len(rows))
