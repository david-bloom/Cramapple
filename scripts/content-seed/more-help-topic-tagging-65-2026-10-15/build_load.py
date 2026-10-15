"""Build metadata-only, source-guarded topic loads from private review evidence."""
import hashlib
import json
import uuid
from collections import Counter
from pathlib import Path

HERE = Path(__file__).resolve().parent
PRIVATE = Path('/private/tmp')
snapshot = json.loads((PRIVATE / 'more-help-tagging-65-snapshot-2026-10-15.json').read_text())
reconciled = json.loads((PRIVATE / 'more-help-tagging-65-reconciliation-2026-10-15.json').read_text())
bc = json.loads((PRIVATE / 'more-help-tagging-65-bc-adjudication-2026-10-15.json').read_text())['adjudications']
chem = json.loads((PRIVATE / 'more-help-tagging-chemistry-adjudication-2026-10-15.json').read_text())['decisions']
adj = {r['content_item_version_id']: r for r in bc + chem}
questions = {r['content_item_version_id']: r for r in snapshot}
assert len(questions) == 65
decision_id = str(uuid.uuid5(uuid.NAMESPACE_URL, 'cramapple:APPROVAL-0178:topic65:2026-10-15'))
run_id = 'more-help-topic65-2026-10-15:three-families-two-samples+CED-review'
plan, exceptions, decisions = [], [], []
for result in reconciled:
    key = result['id']
    question = questions[key]
    review = result['review']
    adjudication = adj.get(key)
    if adjudication:
        primary = adjudication.get('final_proposed_primary', adjudication.get('primary_topic'))
        basis = 'ced_text_tiebreak'
        citation = adjudication['ced_lo_ek']
        rationale = adjudication.get('rationale', '')
    else:
        primary = review['proposed_primary_topic']
        assert primary and result['votes'].get(primary, 0) >= 5, result['key']
        basis = 'six_vote_consensus_and_blind_CED_read'
        citation = review['ced_lo_ek']
        rationale = review.get('reason', review.get('rationale', ''))
    if not primary:
        exceptions.append({'content_key': result['key'], 'content_item_version_id': key,
                           'reason': 'Owner CED scope ruling pending; no forced topic assignment',
                           'votes': result['votes'], 'citation': citation})
        continue
    assert citation, result['key']
    source = 'more_help_topic65_2026_10_15:' + ('ced_text_tiebreak' if adjudication else str(result['votes'][primary])+'of6')
    row = {
        'cell_id': str(uuid.uuid5(uuid.NAMESPACE_URL, 'cramapple:topic65:'+key+':'+primary)),
        'version_id': key, 'item_id': question['content_item_id'],
        'exam_pack_version_id': question['exam_pack_version_id'], 'subject_key': question['subject_key'],
        'taxonomy_source_version': question['taxonomy_source_version'],
        'topic_code': primary, 'source': source, 'model_run_id': run_id,
        'decision_id': decision_id, 'version_md5': question['version_row_md5'],
        'taxo_hash': question['taxonomy_relevant_hash'],
        'label_id': question['serving_label']['content_taxonomy_label_id'],
        'label_version': question['serving_label']['label_version'],
    }
    row['expected_md5'] = hashlib.md5('|'.join(str(row[k]) for k in [
        'cell_id','version_id','item_id','taxonomy_source_version','topic_code',
        'source','model_run_id','decision_id']).encode()).hexdigest()
    plan.append(row)
    decisions.append({
        'content_key': result['key'], 'subject': question['subject_key'], **row,
        'classification_source_md5': question['classification_source_md5'],
        'vote_counts': result['votes'], 'completed_votes': result['complete_votes'],
        'expected_votes': 6, 'decision_basis': basis, 'ced_lo_ek': citation,
        'rationale': rationale, 'scope_flags': review.get('scope_flags', []),
        'secondary_topics_reviewed_not_written': (adjudication or review).get('secondary_topics', []),
    })
assert len(plan) == 64 and len(exceptions) == 1
assert Counter(d['subject'] for d in decisions) == {'ap-calculus-bc':20,'ap-chemistry':44}
manifest = {'approval':'APPROVAL-0178','status':'prepared_not_applied','decision_id':decision_id,
            'planned_primary_cells':len(plan),'exceptions':exceptions,'decisions':decisions}
(HERE/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')

data = json.dumps(plan, separators=(',',':'))
projection = "md5(concat_ws('|',c.content_item_cell_id::text,c.content_item_version_id::text,c.content_item_id::text,c.taxonomy_source_version::text,c.topic_code,c.source,c.model_run_id,c.validation_decision_id::text))"
setup = """begin;
set local lock_timeout='5s';
set local statement_timeout='30s';
-- Readable content remains available; block content edits only during this short batch.
lock table app.content_items,app.content_item_versions,app.mcq_choices,app.frq_criteria,
 app.content_taxonomy_labels,app.taxonomy_source_versions,app.taxonomy_topics,
 app.exam_pack_versions,app.exam_packs,app.subjects in share mode;
lock table app.content_item_cells in share row exclusive mode;
create temporary table topic65_plan on commit drop as
select * from jsonb_to_recordset($plan$""" + data + """$plan$::jsonb) as x(
 cell_id uuid,version_id uuid,item_id uuid,exam_pack_version_id uuid,subject_key text,
 taxonomy_source_version uuid,topic_code text,
 source text,model_run_id text,decision_id uuid,version_md5 text,taxo_hash text,
 label_id uuid,label_version integer,expected_md5 text);
"""
guard = """do $guard$
begin
 if (select count(*) from topic65_plan)<>64 or
    (select count(distinct version_id) from topic65_plan)<>64 then
   raise exception 'Exact 64-version accepted plan required';
 end if;
 if exists(select 1 from topic65_plan p
   left join app.content_item_versions v on v.id=p.version_id
   left join app.content_items ci on ci.id=p.item_id
   where v.id is null or v.content_item_id<>p.item_id or v.status<>'published'
     or ci.id is null or ci.status<>'published'
     or ci.exam_pack_version_id<>p.exam_pack_version_id
     or not exists(select 1 from app.exam_pack_versions epv
       join app.exam_packs ep on ep.id=epv.exam_pack_id
       join app.subjects s on s.id=ep.subject_id
       where epv.id=ci.exam_pack_version_id and s.subject_key=p.subject_key)
     or md5(to_jsonb(v)::text)<>p.version_md5
     or app.taxonomy_relevant_hash(v.id)<>p.taxo_hash
     or exists(select 1 from app.content_item_versions newer
       where newer.content_item_id=v.content_item_id and newer.version_num>v.version_num)
 ) then raise exception 'Stale or changed question source'; end if;
 if exists(select 1 from topic65_plan p where not exists(
   select 1 from app.content_taxonomy_labels l where l.content_taxonomy_label_id=p.label_id
     and l.content_item_id=p.item_id and l.label_version=p.label_version
     and l.label_scope='serving' and l.label_status='validated' and l.superseded_by is null
     and l.validated_against_taxo_hash=p.taxo_hash
 )) then raise exception 'Serving-label provenance drift'; end if;
 if exists(select 1 from topic65_plan p where not exists(
   select 1 from app.taxonomy_topics t
     join app.taxonomy_source_versions tsv using(taxonomy_source_version)
     where t.taxonomy_source_version=p.taxonomy_source_version
     and t.topic_code=p.topic_code
     and tsv.subject_key=replace(p.subject_key,'-','_')
 )) then raise exception 'Topic not in exact subject registry'; end if;
 if exists(select 1 from app.content_item_cells c join topic65_plan p
   on p.version_id=c.content_item_version_id)
 then raise exception 'Question gained a cell since snapshot'; end if;
end $guard$;
"""
insert = """insert into app.content_item_cells(content_item_cell_id,content_item_version_id,
 content_item_id,taxonomy_source_version,topic_code,skill_code,is_primary,
 assignment_status,source,model_run_id,validated_by,validated_at,validation_decision_id)
select cell_id,version_id,item_id,taxonomy_source_version,topic_code,null,true,
 'validated',source,model_run_id,null,now(),decision_id from topic65_plan;
"""
verify = """do $verify$
begin
 if (select count(*) from app.content_item_cells c join topic65_plan p
     on p.cell_id=c.content_item_cell_id where """+projection+"""=p.expected_md5
     and c.is_primary and c.skill_code is null and c.assignment_status='validated'
     and c.validated_by is null and c.validated_at is not null and c.superseded_by is null)<>64
 then raise exception 'Inserted mapping hash or validation mismatch'; end if;
 -- After-only metadata insertion must not alter question/key/rubric fingerprints.
 if exists(select 1 from topic65_plan p join app.content_item_versions v on v.id=p.version_id
   where md5(to_jsonb(v)::text)<>p.version_md5 or app.taxonomy_relevant_hash(v.id)<>p.taxo_hash)
 then raise exception 'Unexpected source change'; end if;
end $verify$;
select '64 primary topic cells verified' as result,count(*) as verified_rows
from topic65_plan;
"""
body = setup+guard+insert+verify
(HERE/'rehearse.sql').write_text('-- APPROVAL-0178; metadata only. Entire batch rolls back.\n'+body+'rollback;\n')
(HERE/'apply.sql').write_text('-- APPROVAL-0178; identical to rehearsed transaction except COMMIT.\n'+body+'commit;\n')
post = """with p as(select * from jsonb_to_recordset($plan$"""+data+"""$plan$::jsonb) as x(
cell_id uuid,version_id uuid,item_id uuid,exam_pack_version_id uuid,subject_key text,
taxonomy_source_version uuid,topic_code text,
source text,model_run_id text,decision_id uuid,version_md5 text,taxo_hash text,
label_id uuid,label_version integer,expected_md5 text))
select count(*) as planned,count(*) filter(where """+projection+"""=p.expected_md5
 and c.is_primary and c.skill_code is null and c.assignment_status='validated'
 and c.validated_at is not null and c.superseded_by is null) as exact_cells,
count(*) filter(where md5(to_jsonb(v)::text)=p.version_md5
 and app.taxonomy_relevant_hash(v.id)=p.taxo_hash) as unchanged_sources
from p left join app.content_item_cells c on c.content_item_cell_id=p.cell_id
left join app.content_item_versions v on v.id=p.version_id;
"""
(HERE/'verify.sql').write_text('-- SELECT only.\n'+post)
recovery_guard = """do $recover_guard$
begin
 if (select count(*) from app.content_item_cells c join topic65_plan p
   on c.content_item_cell_id=p.cell_id where """+projection+"""=p.expected_md5
   and c.is_primary and c.skill_code is null and c.assignment_status='validated'
   and c.validated_by is null
   and c.superseded_by is null)<>64
 then raise exception 'Recovery mapping drift; review before touching live rows'; end if;
 if exists(select 1 from topic65_plan p join app.content_item_versions v on v.id=p.version_id
   where md5(to_jsonb(v)::text)<>p.version_md5 or app.taxonomy_relevant_hash(v.id)<>p.taxo_hash)
 then raise exception 'Recovery source drift'; end if;
 if exists(select 1 from app.content_item_cells c join topic65_plan p
   on c.content_item_version_id=p.version_id where c.content_item_cell_id<>p.cell_id)
 then raise exception 'Recovery found additional cells'; end if;
end $recover_guard$;
delete from app.content_item_cells c using topic65_plan p
where c.content_item_cell_id=p.cell_id;
do $recovered$
begin
 if exists(select 1 from app.content_item_cells c join topic65_plan p
   on c.content_item_version_id=p.version_id)
 then raise exception 'Recovery failed to restore original cell absence'; end if;
end $recovered$;
select '64 new mappings removed; original absence restored' as result;
"""
(HERE/'recovery.sql').write_text('-- UNEXECUTED recovery only: original state had zero cells.\n'
 '-- Requires current owner/conductor recovery decision; never changes question or learner rows.\n'
 +setup+recovery_guard+'commit;\n')
(HERE/'rehearse_recovery.sql').write_text('-- Insert then inverse only this batch, in one rolled-back rehearsal.\n'
 +body+recovery_guard+'rollback;\n')
print(json.dumps({'primary_cells':len(plan),'exceptions':len(exceptions),'subjects':dict(Counter(d['subject'] for d in decisions)),'decision_id':decision_id}))
