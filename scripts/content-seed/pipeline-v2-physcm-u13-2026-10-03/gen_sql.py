import json,hashlib
S={c['key']:c for c in json.load(open('seeds_all.json'))['candidate_seeds']}
R=json.load(open('repaired_items.json'))
def q(s): return "'"+s.replace("'","''")+"'"
PACK='ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9'; TSV='d77d7801-441d-49bb-a2cf-a02f6bff407d'
OWNER='f5a26c6b-3566-4d58-9e97-979fbb947564'
TAG='apphycm_u13_topic_2026_10_03'
ST=json.load(open('stripped_items.json'))
assert len(R)==8 and len(ST)==9
keys=sorted(list(R)+list(ST))
stems=[];chs=[];exp={}
for k in keys:
    s=S[k]; strip=k in ST
    r=R[k] if not strip else dict(stem=ST[k]['stem'],choices=s['choices'])
    stems.append(f"({q(k)},{q(s['version_id'])}::uuid,{q(hashlib.md5(s['stem'].encode()).hexdigest())},{q(r['stem'])},{'true' if strip else 'false'})")
    old={c['choice_key']:c for c in s['choices']}
    for c in r['choices']:
        o=old[c['choice_key']]
        if c['choice_text']!=o['choice_text'] or c['rationale']!=o['rationale']:
            chs.append(f"({q(k)},{q(c['choice_key'])},{q(c['choice_text'])},{q(c['rationale'])})")
    exp[k+'']=hashlib.md5((r['stem']+'|'+'|'.join(f"{c['choice_key']}:{c['choice_text']}:{str(c['is_correct']).lower()}:{c['rationale']}" for c in sorted(r['choices'],key=lambda c:c['choice_key']))).encode()).hexdigest()
json.dump(exp,open('expected_hashes.json','w'),indent=1)
V={'001': '1.2', '002': '1.2', '003': '3.2', '006': '3.3', '007': '3.5', '008': '3.3', '017': '1.2', '018': '3.2', '021': '1.2', '022': '1.3', '024': '3.3', '025': '2.9', '026': '2.10', '027': '3.2', '028': '3.3', '029': '3.4', '030': '3.5'}
tcv=",".join(f"('apphycm-mcq-{n}','{t}')" for n,t in V.items())
NT=len(V)
RXT=r"E'\\n\\s*A[\\.\\)]\\s[\\s\\S]*$'"
RX=r"E'\\n\\s*A[\\.\\)]\\s'"
STEMS=",\n".join(stems); CHS=",\n".join(chs)
body=f"""begin;
select pg_advisory_xact_lock(hashtext('cramapple-apphycm-u13-seedfix-20261003'));
create temporary table fx_stem (content_key text primary key, old_vid uuid, old_stem_md5 text, new_stem text, strip boolean) on commit drop;
insert into fx_stem values
{STEMS};
create temporary table fx_ch (content_key text, choice_key text, new_text text, new_rat text) on commit drop;
insert into fx_ch values
{CHS};
create temporary table tcv (content_key text primary key, topic text) on commit drop;
insert into tcv values {tcv};
create temporary table mod on commit drop as
select ci.content_key, ci.id item_id, civ.id old_vid, f.strip, f.new_stem, civ.stem old_stem from app.content_items ci join app.content_item_versions civ on civ.content_item_id=ci.id and civ.status='published'
join fx_stem f on f.content_key=ci.content_key and f.old_vid=civ.id and f.old_stem_md5=md5(civ.stem)
where ci.exam_pack_version_id='{PACK}' and ci.item_type='mcq' and ci.status='published';
create temporary table lab0 on commit drop as
select m.content_key, l.content_taxonomy_label_id old_label, l.label_version old_ver, l.label_status old_status, l.taxonomy_source_version tsv, l.required_units req, l.primary_unit pu, l.assessed_topics
from mod m join app.content_taxonomy_labels l on l.content_item_id=m.item_id and l.label_scope='serving' and l.superseded_by is null;
do $$ begin
 if (select count(*) from mod)<>17 then raise exception 'expected 17 items to change (version id/stem md5 guard), got %',(select count(*) from mod); end if;
 if (select count(*) from mod where strip)<>9 then raise exception 'expected 9 strip-only items'; end if;
 if exists (select 1 from mod where strip and rtrim(regexp_replace(old_stem, {RXT}, ''))<>new_stem) then raise exception 'a strip-only stem differs from the old stem minus its A-D list'; end if;
 if (select count(*) from lab0)<>17 or exists (select 1 from lab0 where old_status<>'validated') then raise exception 'a target lacks exactly one current validated serving label'; end if;
 if exists (select 1 from app.content_item_cells c join mod m on m.old_vid=c.content_item_version_id where c.superseded_by is null) then raise exception 'target already has cells'; end if; end $$;
create temporary table changed (content_key text primary key, old_version_id uuid not null, new_version_id uuid not null) on commit drop;
do $$
declare t record; v_old app.content_item_versions%rowtype; v_new uuid; v_stem text; e record; v_hits int;
begin
  for t in select * from mod order by content_key loop
    select * into strict v_old from app.content_item_versions where id=t.old_vid for update;
    select new_stem into strict v_stem from fx_stem where content_key=t.content_key;
    perform 1 from app.content_items where id=t.item_id for update;
    v_new := gen_random_uuid();
    update app.content_review_assignments set status='skipped' where content_item_version_id=v_old.id and assignment_purpose='subject_review' and status in ('pending','in_progress');
    update app.content_item_versions set status='retired', updated_at=now() where id=v_old.id;
    update app.content_items set status='draft', updated_at=now() where id=t.item_id;
    insert into app.content_item_versions (id,content_item_id,version_num,stem,stimulus,prompt_json,explanation,help_text,content_hash,status,created_by,canonical_answer_1,canonical_answer_2,review_status,rubric_type,evaluator_strategy,stimulus_image_path)
    values (v_new,t.item_id,v_old.version_num+1,v_stem,v_old.stimulus,
      coalesce(v_old.prompt_json,'{{}}'::jsonb) || jsonb_build_object('content_version',v_old.version_num+1,'qa_remediation','2026-10-03 AP Physics C: Mechanics Units 1-3 audit: rationale/distractor/stem defects repaired and duplicated A-D list removed from the stem; keys unchanged','qa_source_version_id',v_old.id),
      v_old.explanation,v_old.help_text,md5(v_stem),'draft','{OWNER}'::uuid,v_old.canonical_answer_1,v_old.canonical_answer_2,null,v_old.rubric_type,v_old.evaluator_strategy,v_old.stimulus_image_path);
    insert into app.mcq_choices (content_item_version_id,choice_key,choice_text,is_correct,rationale) select v_new,choice_key,choice_text,is_correct,rationale from app.mcq_choices where content_item_version_id=v_old.id;
    for e in select * from fx_ch where content_key=t.content_key loop
      update app.mcq_choices set choice_text=e.new_text, rationale=e.new_rat where content_item_version_id=v_new and choice_key=e.choice_key;
      get diagnostics v_hits = row_count;
      if v_hits<>1 then raise exception 'fix for % choice % matched % rows', t.content_key, e.choice_key, v_hits; end if;
    end loop;
    insert into app.content_item_cells (content_item_version_id,content_item_id,taxonomy_source_version,topic_code,skill_code,is_primary,assignment_status,source,model_run_id,validated_by,validated_at,validation_decision_id)
      select v_new,content_item_id,taxonomy_source_version,topic_code,skill_code,is_primary,assignment_status,source,model_run_id,validated_by,validated_at,validation_decision_id from app.content_item_cells where content_item_version_id=v_old.id and superseded_by is null;
    insert into app.content_item_difficulty (content_item_version_id,difficulty,basis,attainment_ratio,ratio_source,subject_cut_points,source_value,rationale,confidence,proposal_run,created_by)
      select v_new,difficulty,basis,attainment_ratio,ratio_source,subject_cut_points,source_value,rationale,confidence,proposal_run,created_by from app.content_item_difficulty where content_item_version_id=v_old.id;
    insert into changed values (t.content_key,v_old.id,v_new);
  end loop;
end $$;
update app.content_item_versions civ set content_hash = md5(coalesce(civ.stem,'')||E'\\n'||coalesce(civ.stimulus,'')||E'\\n'||coalesce((select string_agg(m.choice_key||':'||m.choice_text||':'||m.is_correct::text||':'||coalesce(m.rationale,''), E'\\n' order by m.choice_key) from app.mcq_choices m where m.content_item_version_id=civ.id),'')) from changed r where civ.id=r.new_version_id;
insert into app.content_review_assignments (content_review_assignment_id,content_item_version_id,reviewer_id,review_stage,review_kind,status,assignment_purpose,created_by)
select gen_random_uuid(),new_version_id,'{OWNER}'::uuid,'tutor_question','mcq','pending','owner_remediation_approval','{OWNER}'::uuid from changed;
insert into app.content_review_decisions (content_review_assignment_id,content_item_version_id,reviewer_id,review_stage,tutor_score,difficulty_label,diagnostic_flag,concern_codes,note,tutor_decision,decision_payload,decision_hash,created_by)
select cra.content_review_assignment_id,r.new_version_id,'{OWNER}'::uuid,'tutor_question',1,'Medium',false,array[]::text[],
  'Owner-approved repair 2026-10-03 (AP Physics C: Mechanics Units 1-3 audit): rationale, distractor and stem defects corrected (two-checker re-audit clean) and the duplicated A-D list removed from the stem; keys unchanged. ' || r.content_key,'approve',
  jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','seed_audit_rationale_and_stem_repair','content_key',r.content_key,'qa_date','2026-10-03'),
  md5(r.new_version_id::text||'{OWNER}'||'apphycm-u13-seedfix-20261003'),'{OWNER}'::uuid
from changed r join app.content_review_assignments cra on cra.content_item_version_id=r.new_version_id and cra.assignment_purpose='owner_remediation_approval' and cra.status='pending';
update app.content_item_versions civ set status='reviewed_approved', review_status='question_review_approved', approved_by='{OWNER}'::uuid, approved_at=coalesce(civ.approved_at,now()), updated_at=now() from changed r where civ.id=r.new_version_id;
update app.content_items ci set status='reviewed_approved', updated_at=now() from changed r join app.content_item_versions civ on civ.id=r.new_version_id where ci.id=civ.content_item_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from changed r where civ.id=r.new_version_id;
update app.content_items ci set status='published', updated_at=now() from changed r join app.content_item_versions civ on civ.id=r.new_version_id where ci.id=civ.content_item_id;
-- carry the validated serving label forward to the new versions
create temporary table tgt on commit drop as
select r.content_key, civ.content_item_id item_id, r.new_version_id version_id, o.old_label, o.old_ver, o.old_status, o.tsv, o.req, o.pu, o.assessed_topics, gen_random_uuid() new_label_id, gen_random_uuid() vd_id
from changed r join app.content_item_versions civ on civ.id=r.new_version_id join lab0 o on o.content_key=r.content_key;
do $$ begin if (select count(*) from tgt)<>17 then raise exception 'label target mismatch: %', (select count(*) from tgt); end if; end $$;
insert into app.content_taxonomy_labels (content_taxonomy_label_id,content_item_id,label_version,label_scope,required_units,max_required_unit,primary_unit,assessed_topics,taxonomy_source_version,taxonomy_confidence,label_status,source,source_payload,model_run_id,created_by)
select new_label_id,item_id,old_ver+1,'serving',req,(select max(u) from unnest(req) u),pu,coalesce(assessed_topics,array[]::text[]),tsv,'provisional','provisional_model','apphycm_u13_pipeline_2026_10_03',
 jsonb_build_object('origin','carry_forward','note','unit and required units carried forward from the current validated label after a rationale/stem repair','supersedes_status',old_status),'apphycm-u13-pipeline-2026-10-03','{OWNER}'::uuid from tgt;
update app.content_taxonomy_labels l set superseded_by=t.new_label_id from tgt t where l.content_taxonomy_label_id=t.old_label;
insert into app.content_taxonomy_validation_decisions (validation_decision_id,content_taxonomy_label_id,decided_by,decision,decision_source,reviewed_primary_unit,reviewed_required_units,notes)
select vd_id,new_label_id,'{OWNER}'::uuid,'confirmed','automated_spot_check',pu,req,'Product Owner chat instruction 2026-10-03 (continue: Units 1-3 pipeline, AP Physics C: Mechanics). Carry-forward of the validated serving label after repair; both blind checkers placed the repaired item in the same unit.' from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='{OWNER}'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.new_label_id;
-- primary topic cells ({NT} items, stage-1 topic votes >= 5 of 6) on the published versions
create temporary table tc on commit drop as
select v.*, ci.id item_id, civ.id version_id from tcv v join app.content_items ci on ci.content_key=v.content_key and ci.exam_pack_version_id='{PACK}' and ci.status='published'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.status='published';
do $$ begin
 if (select count(*) from tc)<>{NT} then raise exception 'expected {NT} topic targets, got %', (select count(*) from tc);end if;
 if exists (select 1 from tc join app.content_item_cells c on c.content_item_version_id=tc.version_id and c.is_primary and c.superseded_by is null) then raise exception 'a topic target already has a primary cell'; end if;
end $$;
insert into app.content_item_cells (content_item_version_id,content_item_id,taxonomy_source_version,topic_code,skill_code,is_primary,assignment_status,source,model_run_id,validated_by,validated_at,validation_decision_id)
select version_id,item_id,'{TSV}'::uuid,topic,null,true,'validated','{TAG}','apphycm-topic-probe-2026-10-03 (gemini-3.8-flash + deepseek-v4-pro + gpt-6.1-sol, 2 samples each; topic agreement >= 5 of 6)',null,now(),gen_random_uuid() from tc;
do $$ declare n int; begin
  select count(*) into n from changed; if n<>17 then raise exception 'expected 17 changed, got %', n; end if;
  select count(*) into n from changed r join app.mcq_choices o on o.content_item_version_id=r.old_version_id join app.mcq_choices w on w.content_item_version_id=r.new_version_id and w.choice_key=o.choice_key where w.is_correct<>o.is_correct; if n<>0 then raise exception 'a key changed'; end if;
  select count(*) into n from app.mcq_choices c join changed r on r.new_version_id=c.content_item_version_id; if n<>68 then raise exception 'choice rows %', n; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>(select count(*) from tgt) then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_versions v join changed r on r.new_version_id=v.id where v.stem ~ {RX} or v.status<>'published'; if n<>0 then raise exception 'a new stem has a list or is not published'; end if;
  select count(*) into n from (select v.content_item_id from app.content_item_versions v where v.status='published' and v.content_item_id in (select item_id from tgt) group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions'; end if;
  select count(*) into n from app.content_item_cells where source='{TAG}' and is_primary and superseded_by is null; if n<>{NT} then raise exception 'topic cell count %', n; end if;
end $$;
"""
rehearse=body+"""do $$ begin raise exception 'REHEARSAL OK (rolled back): versions_changed=%, labels_written=%, topic_cells=%', (select count(*) from changed), (select count(*) from tgt), (select count(*) from tc); end $$;
rollback;
"""
commit=body+"""select (select count(*) from changed) versions_changed, (select count(*) from tgt) labels_written, (select count(*) from tc) topic_cells;
commit;
"""
open('seedfix_rehearsal.sql','w').write(rehearse); open('seedfix_commit.sql','w').write(commit)
kl=",".join(f"({q(k)},{q(h)})" for k,h in exp.items())
open('hash_sql.txt','w').write(f"with exp(k,h) as (values {kl}), got as (select ci.content_key k, md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key)) h from app.content_items ci join app.content_item_versions civ on civ.content_item_id=ci.id and civ.status='published' join app.mcq_choices c on c.content_item_version_id=civ.id where ci.exam_pack_version_id='{PACK}' and ci.content_key in (select k from exp) group by ci.content_key, civ.stem) select (select count(*) from exp) expected, (select count(*) from got) loaded, (select count(*) from exp join got using(k) where exp.h=got.h) matching, (select string_agg(coalesce(exp.k,got.k),',') from exp full join got using(k) where exp.h is distinct from got.h) mismatched;")
E=None
