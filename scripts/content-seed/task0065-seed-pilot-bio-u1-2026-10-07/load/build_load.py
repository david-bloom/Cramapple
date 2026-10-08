"""Build the Production load for the Biology Unit 1 seed pilot (APPROVAL-0131).

82 accepted items (21 seeds, 61 variants) become published AP Biology practice MCQs:
  seeds    APBIO-MCQ-101 .. APBIO-MCQ-121             (topic order 1.1-1.7, slots A, B, C)
  variants APBIO-MCQ-SV-<seed n>-v<k>                  (k = the variant slot, 1-3; unfilled slots skipped)
The -SV-<n>-vK form resolves to its seed under DECISION-0096's key rules.

Labels:
  serving label   required_units {1}, primary_unit 1 (every topic is in Unit 1), validated
  topic cell      the plan's topic; primary, validated (four non-author checkers passed the on_topic rule; the
                  held-out judges placed every sampled item on its topic)
  skill cell      seed: four-family vote (validated at >=3, provisional_model at a unique 2, none = no cell);
                  variant: inherits the seed's skill and status (DECISION-0101)
  difficulty      seed: the four-family vote, basis calibrated_judgement, confidence low (provisional, DECISION-0101);
                  variant: inherits the seed's band, basis translated (DECISION-0096)
No human review (DECISION-0102); Product Owner Hard-Gate approval APPROVAL-0131.

Outputs: load_plan.json, manifest.json (content_key -> md5), chunk_NN.sql (guarded draft loads), publish.sql,
publish_rehearsal.sql, hash_check.sql.
"""
import json, glob, os, hashlib, collections

HERE = os.path.dirname(os.path.abspath(__file__))
PILOT = os.path.dirname(HERE)
PACK = '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7'
TSV = 'c676d1fc-3b58-4896-89e3-852d9bd1f81b'
OWNER = 'f5a26c6b-3566-4d58-9e97-979fbb947564'
SRC = 'task0065_seed_pilot_bio_u1_2026_10_07'
RUN = 'task0065-seed-pilot-bio-u1-2026-10-07 (APPROVAL-0131)'
FIRST_SEED = 101
CHUNK = 10


def q(s):
    return "'" + s.replace("'", "''") + "'"


def h(it):
    cs = sorted(it['choices'], key=lambda c: c['choice_key'])
    return hashlib.md5((it['stem'] + '|' + '|'.join(
        f"{c['choice_key']}:{c['choice_text']}:{str(bool(c['is_correct'])).lower()}:{c['rationale']}" for c in cs)).encode()).hexdigest()


topics = sorted((json.load(open(f)) for f in glob.glob(os.path.join(PILOT, 'batch/topics/*.json'))),
                key=lambda st: [int(x) for x in st['topic']['topic_code'].split('.')])
rows, n = [], FIRST_SEED
for st in topics:
    t = st['topic']
    for s in sorted(st['seeds'], key=lambda s: s['slot']['slot']):
        assert s.get('seed'), f"{t['topic_code']} {s['slot']['slot']}: no seed"
        L = s['seed']['label']
        seed_key = f'APBIO-MCQ-{n:03d}'
        assert L['difficulty'] in ('Easy', 'Medium', 'Hard')
        base = dict(topic=t['topic_code'], title=t['topic_title'], seed_key=seed_key,
                    skill=L['skill'] if L['skill_status'] in ('validated', 'provisional_model') else None,
                    skill_status=L['skill_status'], difficulty=L['difficulty'],
                    skill_tally=L['skill_tally'], difficulty_tally=L['difficulty_tally'])
        rows.append(dict(base, content_key=seed_key, kind='seed', pipeline_id=s['seed']['id'], item=s['seed']['item']))
        for v in s['variants']:
            if v.get('accepted'):
                rows.append(dict(base, content_key=f'APBIO-MCQ-SV-{n:03d}-v{v["v"]}', kind='variant',
                                 pipeline_id=v['accepted']['id'], item=v['accepted']['item']))
        n += 1

assert len(rows) == 82 and sum(r['kind'] == 'seed' for r in rows) == 21
assert len({r['content_key'] for r in rows}) == 82
for r in rows:
    it = r['item']
    assert it['topic_code'] == r['topic'] and it['unit_number'] == 1
    assert len(it['choices']) == 4 and sum(bool(c['is_correct']) for c in it['choices']) == 1
    assert sorted(c['choice_key'] for c in it['choices']) == ['A', 'B', 'C', 'D']
    assert len({c['choice_text'].strip().lower() for c in it['choices']}) == 4
    assert all(c['rationale'].strip() for c in it['choices']) and it['stem'].strip()
    r['hash'] = h(it)
    r['keyed'] = next(c['choice_key'] for c in it['choices'] if c['is_correct'])

json.dump(rows, open(os.path.join(HERE, 'load_plan.json'), 'w'), indent=1, ensure_ascii=False)
json.dump({r['content_key']: r['hash'] for r in rows}, open(os.path.join(HERE, 'manifest.json'), 'w'), indent=1)

# ---- draft loads: one guarded transaction per chunk; the payload is a JSON literal ----
for f in glob.glob(os.path.join(HERE, 'chunk_*.sql')):
    os.remove(f)
for i in range(0, len(rows), CHUNK):
    part = rows[i:i + CHUNK]
    payload = [{'k': r['content_key'], 't': r['title'], 's': r['item']['stem'], 'a': r['keyed'],
                'c': [[c['choice_key'], c['choice_text'], bool(c['is_correct']), c['rationale']]
                      for c in sorted(r['item']['choices'], key=lambda c: c['choice_key'])]} for r in part]
    js = json.dumps(payload, ensure_ascii=False, separators=(',', ':'))
    assert '$pl$' not in js
    sql = f"""do $do$
declare p jsonb := $pl${js}$pl$::jsonb; r jsonb; c jsonb; v_ci uuid; v_civ uuid; n int;
begin
  if jsonb_array_length(p) <> {len(part)} then raise exception 'chunk size'; end if;
  if exists (select 1 from app.content_items ci where ci.exam_pack_version_id='{PACK}' and ci.content_key in (select x->>'k' from jsonb_array_elements(p) x))
    then raise exception 'chunk already loaded'; end if;
  for r in select * from jsonb_array_elements(p) loop
    insert into app.content_items (exam_pack_version_id, content_key, item_type, title, status)
    values ('{PACK}', r->>'k', 'mcq', r->>'t', 'draft') returning id into v_ci;
    insert into app.content_item_versions (content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
    values (v_ci, 1, r->>'s', null, md5(r->>'k'), 'draft', 'tutor_review_pending', r->>'a') returning id into v_civ;
    for c in select * from jsonb_array_elements(r->'c') loop
      insert into app.mcq_choices (content_item_version_id, choice_key, choice_text, is_correct, rationale)
      values (v_civ, c->>0, c->>1, (c->>2)::boolean, c->>3);
    end loop;
  end loop;
  select count(*) into n from app.content_items ci join app.content_item_versions v on v.content_item_id=ci.id join app.mcq_choices m on m.content_item_version_id=v.id
   where ci.exam_pack_version_id='{PACK}' and ci.status='draft' and ci.content_key in (select x->>'k' from jsonb_array_elements(p) x);
  if n <> {4 * len(part)} then raise exception 'chunk {i // CHUNK + 1}: expected {4 * len(part)} choice rows, got %', n; end if;
  raise notice 'chunk {i // CHUNK + 1}: loaded {len(part)} draft items';
end
$do$;
"""
    open(os.path.join(HERE, f'chunk_{i // CHUNK + 1:02d}.sql'), 'w').write(sql)

# ---- publish: approval record, labels, cells, difficulty, publish; all guarded ----
lab = ",\n".join(
    f"({q(r['content_key'])},{q(r['kind'])},{q(r['seed_key'])},{q(r['topic'])},{q(r['skill']) if r['skill'] else 'null'},"
    f"{q(r['skill_status'])},{q(r['difficulty'])},{q(r['hash'])},{q(json.dumps(r['difficulty_tally']))},{q(json.dumps(r['skill_tally']))})"
    for r in rows)
N = len(rows)
N_SKILL = sum(1 for r in rows if r['skill'])
body = f"""begin;
select pg_advisory_xact_lock(hashtext('cramapple-task0065-seed-pilot-bio-u1-publish-20261007'));
create temporary table lab (content_key text primary key, kind text, seed_key text, topic text, skill text, skill_status text,
  difficulty text, exp_hash text, diff_tally text, skill_tally text) on commit drop;
insert into lab values
{lab};
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id='{PACK}'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
where ci.status='draft' and civ.status='draft';
do $$ begin
 if (select count(*) from tgt)<>{N} then raise exception 'expected {N} draft targets, got %', (select count(*) from tgt); end if;
 if exists (select 1 from tgt t join app.content_item_cells c on c.content_item_version_id=t.version_id)
    or exists (select 1 from tgt t join app.content_taxonomy_labels l on l.content_item_id=t.item_id)
    or exists (select 1 from tgt t join app.content_item_difficulty d on d.content_item_version_id=t.version_id)
    or exists (select 1 from tgt t join app.content_review_assignments a on a.content_item_version_id=t.version_id)
   then raise exception 'a target already has cells, labels, difficulty or review rows'; end if;
 if exists (select 1 from tgt t where not exists (select 1 from app.taxonomy_topics tt where tt.taxonomy_source_version='{TSV}' and tt.topic_code=t.topic and tt.unit_number=1))
   then raise exception 'topic not in Unit 1 of taxonomy {TSV}'; end if;
 if exists (select 1 from tgt t where t.skill is not null and not exists (select 1 from app.taxonomy_cells tc where tc.taxonomy_source_version='{TSV}' and tc.topic_code=t.topic and tc.skill_code=t.skill))
   then raise exception 'skill not in the topic grid'; end if;
 if (select count(*) from (select t.content_key from tgt t join app.content_item_versions civ on civ.id=t.version_id join app.mcq_choices c on c.content_item_version_id=civ.id
     group by t.content_key, civ.stem, t.exp_hash having md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key))=t.exp_hash) z)<>{N}
   then raise exception 'loaded text does not match the build manifest'; end if;
end $$;
insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select assignment_id, version_id, '{OWNER}'::uuid, 'tutor_question', 'mcq', 'pending', 'owner_remediation_approval', '{OWNER}'::uuid from tgt;
insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, tutor_decision, decision_payload, decision_hash, created_by)
select assignment_id, version_id, '{OWNER}'::uuid, 'tutor_question', 1, null, false, array[]::text[],
 'AP Biology Unit 1 seed pilot (TASK-0065): publication on Product Owner chat instruction 2026-10-07 ("load the pilot''s 82 questions"), APPROVAL-0131; no human review per DECISION-0102. Generate-and-select (protocol v0.6 section 0, DECISION-0099): no hand edits; four non-author checker families (blind solve + rubric audit) plus own-family veto; 6/6 planted-defect controls; held-out judges found 0 defects in all 21 seeds and a 21-variant sample; every computable key recomputed.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','task0065_seed_pilot_po_approval','approval','APPROVAL-0131','qa_date','2026-10-07','content_key',content_key,'kind',kind,'seed',seed_key),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','task0065_seed_pilot_po_approval','approval','APPROVAL-0131','qa_date','2026-10-07','content_key',content_key,'kind',kind,'seed',seed_key)::text),
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
select label_id, item_id, 1, 'serving', array[1], 1, 1, array[]::text[], '{TSV}'::uuid, 'provisional', 'provisional_model', '{SRC}',
 jsonb_build_object('origin', kind, 'seed', seed_key, 'topic', topic, 'units_source', 'designated Unit 1 topic; four non-author checkers passed the on_topic rule', 'report', 'scripts/content-seed/task0065-seed-pilot-bio-u1-2026-10-07'),
 '{RUN}', '{OWNER}'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, '{OWNER}'::uuid, 'confirmed', 'automated_spot_check', 1, array[1],
 'Product Owner chat instruction 2026-10-07 (APPROVAL-0131). Item was generated for its designated Unit 1 topic and passed the on_topic rule with four non-author checker families; held-out judges placed every sampled item on its topic.' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, '{TSV}'::uuid, topic, null, true, 'validated', '{SRC}:topic', '{RUN}: designated topic, four-family on_topic check', null, now(), gen_random_uuid() from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, '{TSV}'::uuid, topic, skill, false, skill_status,
 '{SRC}:skill:'||case when kind='seed' then 'vote' else 'inherit' end,
 '{RUN}: '||case when kind='seed' then 'four non-author families voted (validated at >=3 of 4); tally '||skill_tally else 'inherits seed '||seed_key||' (DECISION-0101)' end,
 null, case when skill_status='validated' then now() end, case when skill_status='validated' then gen_random_uuid() end
from tgt where skill is not null;
insert into app.content_item_difficulty (content_item_version_id, difficulty, basis, source_value, rationale, confidence, proposal_run)
select version_id, difficulty,
 case when kind='seed' then 'calibrated_judgement' else 'translated' end,
 case when kind='seed' then null else seed_key end,
 case when kind='seed' then 'Four non-author model families voted (Easy = single-fact recall; Medium = apply one concept or interpret given information; Hard = combine concepts or multi-step reasoning). Tally '||diff_tally||'. Provisional until recalibrated from student attempts (DECISION-0101).'
      else 'Inherited from seed '||seed_key||' (DECISION-0096).' end,
 'low', '{SRC}'
from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='{OWNER}'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>{N} then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>{N} then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells c join tgt t on t.version_id=c.content_item_version_id where c.is_primary and c.superseded_by is null and c.assignment_status='validated'; if n<>{N} then raise exception 'topic cell count %', n; end if;
  select count(*) into n from app.content_item_cells c join tgt t on t.version_id=c.content_item_version_id where not c.is_primary and c.skill_code is not null and c.superseded_by is null; if n<>{N_SKILL} then raise exception 'skill cell count %', n; end if;
  select count(*) into n from app.content_item_difficulty d join tgt t on t.version_id=d.content_item_version_id; if n<>{N} then raise exception 'difficulty count %', n; end if;
end $$;
"""
counts = "(select count(*) from tgt), (select count(*) from app.content_item_cells c join tgt t on t.version_id=c.content_item_version_id where not c.is_primary), (select count(*) from app.content_item_cells c join tgt t on t.version_id=c.content_item_version_id where not c.is_primary and c.assignment_status='validated')"
open(os.path.join(HERE, 'publish_rehearsal.sql'), 'w').write(
    body + f"do $$ begin raise exception 'REHEARSAL OK (rolled back): published=%, skill_cells=%, validated_skill_cells=%', {counts}; end $$;\nrollback;\n")
open(os.path.join(HERE, 'publish.sql'), 'w').write(body + "commit;\n")
kl = ",".join(f"({q(r['content_key'])},{q(r['hash'])})" for r in rows)
open(os.path.join(HERE, 'hash_check.sql'), 'w').write(
    f"with exp(k,h) as (values {kl}), got as (select ci.content_key k, ci.status, md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key)) h "
    f"from app.content_items ci join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1 join app.mcq_choices c on c.content_item_version_id=civ.id "
    f"where ci.exam_pack_version_id='{PACK}' and ci.content_key in (select k from exp) group by ci.content_key, ci.status, civ.stem) "
    f"select (select count(*) from exp) expected, (select count(*) from got) loaded, (select count(*) from exp join got using(k) where exp.h=got.h) matching, "
    f"(select string_agg(distinct status, ',') from got) statuses, (select string_agg(coalesce(exp.k,got.k),',') from exp full join got using(k) where exp.h is distinct from got.h) mismatched;\n")
print(json.dumps({'items': N, 'seeds': 21, 'variants': N - 21, 'skill_cells': N_SKILL,
                  'skill_status': dict(collections.Counter(r['skill_status'] for r in rows)),
                  'difficulty': dict(collections.Counter(r['difficulty'] for r in rows)),
                  'chunk_bytes': [os.path.getsize(f) for f in sorted(glob.glob(os.path.join(HERE, 'chunk_*.sql')))],
                  'publish_bytes': os.path.getsize(os.path.join(HERE, 'publish.sql'))}))
