"""APPROVAL-0126: load + publish the 27 approved clean-room items (21 AP Chemistry, 6 AP Calculus AB) to Production.
Pattern copied from pipeline-v2-phys2-u13-2026-10-03/gen_load.py (draft -> owner review decision -> reviewed_approved
-> labels/cells/difficulty -> published), in ONE transaction per subject. Writes <subject>_rehearsal.sql (ends in a
REHEARSAL OK exception) and <subject>_commit.sql, plus hash_check_<subject>.sql. Run from scripts/content-seed/.
F4 (density) is excluded entirely (Product Owner, 2026-10-06: hold, do not publish)."""
import json, hashlib, os

OWNER = 'f5a26c6b-3566-4d58-9e97-979fbb947564'
SUBJ = {
    'apchem': dict(pack='c9ca46b2-b529-4ed3-9741-dddea455ab9b', tsv='cbe3116f-6ef5-410c-b535-e9fb711c4c2c', n=21),
    'apcalcab': dict(pack='826c8cf1-bc1b-4f2a-bd33-61a758e1487d', tsv='33b4408b-0ecc-4c7a-b0b1-612db81164a1', n=6),
}
TITLES = {
    'f1-v1': 'Empirical formula of a ceramic', 'f1-v2': 'Empirical formula from element masses',
    'f1-v3': 'Empirical formula from lab data', 'f2-v1': 'Formula from one element percent',
    'f2-v2': 'Empirical formula, not a multiple', 'f2-v3': 'Molecular formula of a boron hydride',
    'f3-v1': 'Oxygen atoms in a nitrate salt', 'f3-v2': 'Atoms in a fertilizer salt',
    'f3-v3': 'Atom counts in calcium phosphate', 'f5-v1': 'Mixture percent from sodium analysis',
    'f5-v2': 'Mixture percent from calcium mass', 'f5-v3': 'Purity of a copper ore',
    'f6-v1': 'Nitrate ion from two salts', 'f6-v2': 'Potassium ion from two phosphates',
    'f6-v3': 'Ammonium ion from two salts', 'f7-v1': 'Measurement needed for molar mass',
    'f7-v2': 'Quantity not needed for molar mass', 'f7-v3': 'Using total pressure over water',
    'f8-v1': 'Drying a sample to constant mass', 'f8-v2': 'Percent water from drying data',
    'f8-v3': 'Stopping before constant mass', 'c1-v1': 'Average rate of a sine function',
    'c1-v2': 'Zero average rate of a cosine', 'c1-v3': 'Average rate of a spring model',
    'c2-v1': 'Greatest average rate from a table', 'c2-v2': 'Greatest average rate of a cubic',
    'c2-v3': 'Least average rate of a reservoir',
}
REQ_OVERRIDE = {  # 2-2 required-unit ties broken by the family's pooled plurality ([1,3] in both families)
    'apchem-mcq-orly-f6-v1': [1, 3], 'apchem-mcq-orly-f7-v1': [1, 3]}
PO_TOPIC = {'apchem-mcq-orly-f6-v2'}  # topic 3.7 set by the Product Owner in chat (checkers split 3.7 / 4.5)

def q(s): return "'" + s.replace("'", "''") + "'"
def arr(xs): return 'array[' + ','.join(str(x) for x in xs) + ']::int[]'
HERE = os.path.dirname(os.path.abspath(__file__))
plan = json.load(open(os.path.join(HERE, 'load_plan.json')))

for subj, cfg in SUBJ.items():
    B = os.path.join(HERE, '..', f'{subj}-orly-cleanroom-2026-10-06')
    items = [i for i in json.load(open(os.path.join(B, 'items_assembled.json'))) if not i['key'].split('orly-')[1].startswith('f4')]
    assert len(items) == cfg['n'], (subj, len(items))
    PACK, TSV, N = cfg['pack'], cfg['tsv'], cfg['n']
    blocks, rows, exp = [], [], {}
    for it in items:
        k = it['key']; p = plan[k]; short = k.split('orly-')[1]
        ch = sorted(it['choices'], key=lambda c: c['label'])
        assert sum(c['label'] == it['keyed_label'] for c in ch) == 1 and len(ch) == 4
        sel = []
        for i, c in enumerate(ch):
            pre = 'select ' if i == 0 else 'union all select '
            sel.append(f"{pre}gen_random_uuid(), id, {q(c['label'])}, {q(c['text'])}, {'true' if c['label'] == it['keyed_label'] else 'false'}, {q(it['rationales'][c['label']])} from version_ins")
        blocks.append(f"""-- {k}
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '{PACK}', {q(k)}, 'mcq', {q(TITLES[short])}, 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, {q(it['stem'])}, null, '{{}}'::jsonb, md5({q(k)}), 'draft', 'tutor_review_pending', {q(it['keyed_label'])}
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
""" + '\n'.join(sel) + ';\n')
        req = REQ_OVERRIDE.get(k, p['req'])
        assert max(req) == p['pu'] and int(p['topic'].split('.')[0]) == p['pu']
        rows.append(f"({q(k)},{q(p['topic'])},{arr(req)},{p['pu']},{q(p['difficulty'])},{q(p['skill']) if p['skill'] else 'null'},{q(p['skill_status']) if p['skill_status'] else 'null'},{q(p['tier'])},{'true' if k in PO_TOPIC else 'false'},{q(it['family_id'])})")
        exp[k] = hashlib.md5((it['stem'] + '|' + '|'.join(f"{c['label']}:{c['text']}:{str(c['label'] == it['keyed_label']).lower()}:{it['rationales'][c['label']]}" for c in ch)).encode()).hexdigest()
    keys = ','.join(q(k) for k in exp)
    tag = f'{subj}_orly_cleanroom_2026_10_06'
    body = f"""begin;
select pg_advisory_xact_lock(hashtext('cramapple-{subj}-orly-cleanroom-publish-20261006'));
do $$ begin
  if exists (select 1 from app.content_items where content_key = any (array[{keys}])) then raise exception 'already loaded'; end if;
end $$;
""" + ''.join(blocks) + f"""
create temporary table lab (content_key text primary key, topic text, req int[], pu int, difficulty text, skill text, skill_status text, tier text, po_topic boolean, family text) on commit drop;
insert into lab values
{','.join(chr(10) + r for r in rows)};
create temporary table expd (content_key text primary key, h text) on commit drop;
insert into expd values {','.join(f'({q(k)},{q(h)})' for k, h in exp.items())};
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id, gen_random_uuid() skill_vd
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id='{PACK}' and ci.status='draft'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1 and civ.status='draft';
do $$ begin
 if (select count(*) from tgt)<>{N} then raise exception 'expected {N} draft targets, got %', (select count(*) from tgt); end if;
 if exists (select 1 from tgt where not exists (select 1 from app.taxonomy_topics tt where tt.taxonomy_source_version='{TSV}' and tt.topic_code=tgt.topic)) then raise exception 'unknown topic'; end if;
 if exists (select 1 from tgt where skill is not null and not exists (select 1 from app.taxonomy_cells c where c.taxonomy_source_version='{TSV}' and c.topic_code=tgt.topic and c.skill_code=tgt.skill)) then raise exception 'skill not in grid'; end if;
 if (select count(*) from (select t.content_key from tgt t join app.content_item_versions civ on civ.id=t.version_id join app.mcq_choices c on c.content_item_version_id=civ.id join expd e on e.content_key=t.content_key
     group by t.content_key, civ.stem, e.h having md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key))=e.h) z)<>{N} then raise exception 'loaded text does not match the build manifest'; end if;
end $$;
update app.content_item_versions civ set content_hash = md5(coalesce(civ.stem,'')||E'\\n'||coalesce(civ.stimulus,'')||E'\\n'||coalesce((select string_agg(m.choice_key||':'||m.choice_text||':'||m.is_correct::text||':'||coalesce(m.rationale,''), E'\\n' order by m.choice_key) from app.mcq_choices m where m.content_item_version_id=civ.id),'')) from tgt where civ.id=tgt.version_id;
insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select assignment_id, version_id, '{OWNER}'::uuid, 'tutor_question', 'mcq', 'pending', 'owner_remediation_approval', '{OWNER}'::uuid from tgt;
insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, tutor_decision, decision_payload, decision_hash, created_by)
select assignment_id, version_id, '{OWNER}'::uuid, 'tutor_question', 1, null, false, array[]::text[],
 'Orly pooled-practice clean-room items (DECISION-0098), published on Product Owner chat approval 2026-10-06 (APPROVAL-0126). Clean-room authoring from scrubbed family specs; author verify scripts; independent re-derivation of every key; two-model blind solve + rationale audit (gpt-5.6-sol, deepseek-v4-pro-0813) with patch rounds re-checked in full; CED scope check; topic probe. Batch: scripts/content-seed/apchem-orly-cleanroom-2026-10-06/README.md',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','approval_0126_po_chat','qa_date','2026-10-06','content_key',content_key,'family',family),
 md5(jsonb_build_object('approval','APPROVAL-0126','content_key',content_key,'version',version_id)::text), '{OWNER}'::uuid from tgt;
create temporary table qa_blocked on commit drop as
select g.content_key, case
 when nullif(trim(civ.stem),'') is null then 'blank stem'
 when (select count(*) from app.mcq_choices m where m.content_item_version_id=civ.id)<>4 then 'choice count'
 when (select count(distinct lower(trim(m.choice_text))) from app.mcq_choices m where m.content_item_version_id=civ.id)<>4 then 'duplicate choice text'
 when (select count(*) from app.mcq_choices m where m.content_item_version_id=civ.id and m.is_correct)<>1 then 'correct key count'
 when exists (select 1 from app.mcq_choices m where m.content_item_version_id=civ.id and nullif(trim(coalesce(m.rationale,'')),'') is null) then 'blank rationale'
 when civ.canonical_answer_1 is distinct from (select m.choice_key from app.mcq_choices m where m.content_item_version_id=civ.id and m.is_correct) then 'canonical letter mismatch'
 when civ.stem ~ E'\\n\\\\s*A[\\\\.\\\\)]\\\\s' then 'embedded choice list'
 end reason
from tgt g join app.content_item_versions civ on civ.id=g.version_id;
delete from qa_blocked where reason is null;
do $$ begin if exists (select 1 from qa_blocked) then raise exception 'structural QA blocked: %', (select string_agg(content_key||':'||reason, ', ') from qa_blocked); end if; end $$;
update app.content_item_versions civ set status='reviewed_approved', review_status='question_review_approved', approved_by='{OWNER}'::uuid, approved_at=coalesce(civ.approved_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='reviewed_approved', updated_at=now() from tgt where ci.id=tgt.item_id;
insert into app.content_item_difficulty (content_item_version_id, difficulty, basis, rationale, confidence, proposal_run)
select version_id, difficulty, 'calibrated_judgement', 'Authored band from the clean-room family spec (v1 easy, v2 medium, v3 hard); DECISION-0096 requires a band on every published MCQ.', 'medium', 'orly-cleanroom-2026-10-06' from tgt;
insert into app.content_taxonomy_labels (content_taxonomy_label_id, content_item_id, label_version, label_scope, required_units, max_required_unit, primary_unit, assessed_topics, taxonomy_source_version, taxonomy_confidence, label_status, source, source_payload, model_run_id, created_by)
select label_id, item_id, 1, 'serving', req, (select max(u) from unnest(req) u), pu, array[]::text[], '{TSV}'::uuid, 'provisional', 'provisional_model', '{tag}',
 jsonb_build_object('origin','clean_room_original','topic',topic,'family',family,'units_source', case when po_topic then 'Product Owner chat 2026-10-06 set topic 3.7 (checkers split 3.7/4.5)' else 'blind topic probe gpt-5.6-sol + deepseek-v4-pro-0813, 2 samples each; unit agreement' end,'report','scripts/content-seed/apchem-orly-cleanroom-2026-10-06'),
 'orly-cleanroom-labeling-2026-10-06', '{OWNER}'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, '{OWNER}'::uuid, 'confirmed', case when po_topic then 'chat_review' else 'automated_spot_check' end, pu, req,
 case when po_topic then 'Product Owner chat 2026-10-06 (APPROVAL-0126): "Approve 3.7".' else 'Product Owner chat approval 2026-10-06 (APPROVAL-0126). Two blind checkers (gpt-5.6-sol, deepseek-v4-pro-0813) placed the item in this unit (DECISION-0066).' end from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='{OWNER}'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, '{TSV}'::uuid, topic, null, true, 'validated', '{tag}_topic',
 case when po_topic then 'Product Owner chat 2026-10-06 (topic 3.7)' else 'orly-cleanroom topic probe 2026-10-06 (gpt-5.6-sol + deepseek-v4-pro-0813, 2 samples each)' end, case when po_topic then '{OWNER}'::uuid end, now(), gen_random_uuid() from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, '{TSV}'::uuid, topic, skill, false, skill_status, 'skill_orly_cleanroom_4voter_2026_10_06:'||tier,
 'orly-cleanroom skills 2026-10-06 (4 voters: claude-opus-5, gpt-5.5, gemini-2.5-pro, gemini-3.8-flash; validated at >=3 of 4)', null,
 case when skill_status='validated' then now() end, case when skill_status='validated' then skill_vd end from tgt where skill is not null;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' and content_item_id in (select item_id from tgt) group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions'; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>{N} then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>{N} then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells c join tgt t on t.version_id=c.content_item_version_id where c.is_primary and c.superseded_by is null and c.assignment_status='validated'; if n<>{N} then raise exception 'topic cell count %', n; end if;
  select count(*) into n from app.content_item_difficulty d join tgt t on t.version_id=d.content_item_version_id; if n<>{N} then raise exception 'difficulty count %', n; end if;
end $$;
"""
    summary = f"(select count(*) from tgt), (select count(*) from app.content_taxonomy_labels where source='{tag}' and label_status='validated'), (select count(*) from app.content_item_cells c join tgt t on t.version_id=c.content_item_version_id where c.is_primary), (select count(*) from app.content_item_cells c join tgt t on t.version_id=c.content_item_version_id where not c.is_primary), (select count(*) from app.content_item_difficulty d join tgt t on t.version_id=d.content_item_version_id)"
    open(os.path.join(B, f'{subj}_rehearsal.sql'), 'w').write(body + f"do $$ begin raise exception 'REHEARSAL OK (rolled back): published=%, validated_labels=%, topic_cells=%, skill_cells=%, difficulty=%', {summary}; end $$;\nrollback;\n")
    open(os.path.join(B, f'{subj}_commit.sql'), 'w').write(body + f"select {summary};\ncommit;\n")
    kl = ','.join(f'({q(k)},{q(h)})' for k, h in exp.items())
    open(os.path.join(B, f'hash_check_{subj}.sql'), 'w').write(f"with exp(k,h) as (values {kl}), got as (select ci.content_key k, md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key)) h from app.content_items ci join app.content_item_versions civ on civ.content_item_id=ci.id and civ.status='published' join app.mcq_choices c on c.content_item_version_id=civ.id where ci.exam_pack_version_id='{PACK}' and ci.content_key in (select k from exp) group by ci.content_key, civ.stem) select (select count(*) from exp) expected, (select count(*) from got) loaded, (select count(*) from exp join got using(k) where exp.h=got.h) matching;")
    print(subj, N, 'items;', len(body.encode()), 'bytes')
