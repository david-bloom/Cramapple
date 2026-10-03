-- AP Chemistry Units 1-3 pipeline step 4: new validated, hash-fresh serving-label versions for the 37 items whose blind 3-family consensus puts them in Units 1-3 (max required unit agreement >= 5 of 6). Old rows superseded, never edited. APPROVAL-0074.
begin;
select pg_advisory_xact_lock(hashtext('cramapple-apchem-u13-serving-labels-20261002'));
create temporary table tgt0 (content_key text primary key, primary_unit int, req int[], topic text, topic_support text, units_support text) on commit drop;
insert into tgt0 values
('apchem-frq-l-002',2,'{2}'::int[],'2.6','6/6','5/6'),
('apchem-frq-l-003',3,'{3}'::int[],'3.6','6/6','6/6'),
('apchem-frq-l-010',3,'{2,3}'::int[],'3.2','4/6','5/6'),
('apchem-frq-l-011',3,'{1,3}'::int[],'3.4','6/6','6/6'),
('apchem-frq-l-012',3,'{3}'::int[],'3.6','6/6','6/6'),
('apchem-frq-l-013',3,'{3}'::int[],'3.9','6/6','6/6'),
('apchem-mcq-001',1,'{1}'::int[],'1.1','6/6','6/6'),
('apchem-mcq-003',2,'{2}'::int[],'2.7','6/6','6/6'),
('apchem-mcq-005',3,'{1,3}'::int[],'3.5','6/6','6/6'),
('apchem-mcq-006',3,'{3}'::int[],'3.13','6/6','6/6'),
('apchem-mcq-007',3,'{3}'::int[],'3.10','6/6','6/6'),
('apchem-mcq-008',3,'{3}'::int[],'3.4','6/6','6/6'),
('apchem-mcq-021',1,'{1}'::int[],'1.1','6/6','6/6'),
('apchem-mcq-022',1,'{1}'::int[],'1.5','6/6','6/6'),
('apchem-mcq-023',1,'{1}'::int[],'1.6','6/6','6/6'),
('apchem-mcq-024',1,'{1}'::int[],'1.7','6/6','6/6'),
('apchem-mcq-025',2,'{2}'::int[],'2.1','6/6','6/6'),
('apchem-mcq-026',2,'{2}'::int[],'2.5','6/6','6/6'),
('apchem-mcq-027',2,'{2}'::int[],'2.6','6/6','6/6'),
('apchem-mcq-028',2,'{2}'::int[],'2.7','6/6','6/6'),
('apchem-mcq-029',3,'{2,3}'::int[],'3.1','6/6','6/6'),
('apchem-mcq-030',3,'{3}'::int[],'3.1','6/6','6/6'),
('apchem-mcq-031',3,'{3}'::int[],'3.2','6/6','6/6'),
('apchem-mcq-032',3,'{3}'::int[],'3.4','6/6','6/6'),
('apchem-mcq-033',3,'{3}'::int[],'3.5','6/6','6/6'),
('apchem-mcq-034',3,'{3}'::int[],'3.6','6/6','6/6'),
('apchem-mcq-035',3,'{3}'::int[],'3.10','6/6','6/6'),
('apchem-mcq-036',3,'{3}'::int[],'3.13','6/6','6/6'),
('apchem-mcq-037',3,'{3}'::int[],'3.12','6/6','6/6'),
('apchem-mcq-038',3,'{3}'::int[],'3.9','6/6','6/6'),
('apchem-mcq-039',3,'{3}'::int[],'3.7','6/6','6/6'),
('apchem-sfrq-004',3,'{3}'::int[],'3.13','6/6','6/6'),
('apchem-sfrq-014',2,'{2}'::int[],'2.7','6/6','6/6'),
('apchem-sfrq-015',3,'{3}'::int[],'3.4','6/6','6/6'),
('apchem-sfrq-016',3,'{2,3}'::int[],'3.1','6/6','6/6'),
('apchem-sfrq-018',3,'{2,3}'::int[],'3.1','5/6','6/6'),
('apchem-sfrq-019',3,'{1,3}'::int[],'3.7','6/6','6/6');
create temporary table tgt on commit drop as
select t.*, ci.id item_id, civ.id version_id, l.content_taxonomy_label_id old_label_id, coalesce(l.label_version,0) old_ver, l.label_status old_status, coalesce(l.taxonomy_source_version,'cbe3116f-6ef5-410c-b535-e9fb711c4c2c'::uuid) tsv,
       gen_random_uuid() new_label_id, gen_random_uuid() vd_id
from tgt0 t join app.content_items ci on ci.content_key=t.content_key and ci.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and ci.status='published'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.status='published'
left join app.content_taxonomy_labels l on l.content_item_id=ci.id and l.label_scope='serving' and l.superseded_by is null;
do $$ begin
  if (select count(*) from tgt)<>37 then raise exception 'expected 37 targets, got %', (select count(*) from tgt); end if;
end $$;
insert into app.content_taxonomy_labels (content_taxonomy_label_id, content_item_id, label_version, label_scope, required_units, max_required_unit, primary_unit, assessed_topics, taxonomy_source_version, taxonomy_confidence, label_status, source, source_payload, model_run_id, created_by)
select new_label_id, item_id, old_ver+1, 'serving', req, (select max(u) from unnest(req) u), primary_unit, array[]::text[], tsv, 'provisional', 'provisional_model', 'apchem_u13_pipeline_2026_10_02',
 jsonb_build_object('origin','three_family_blind_probe','models','google/gemini-3.8-flash, deepseek/deepseek-v4-pro, openai/gpt-6.1-sol','samples','2 each (6 per item)','max_unit_support',units_support,'consensus_topic',topic,'topic_support',topic_support,'supersedes_status',old_status),
 'apchem-u13-pipeline-2026-10-02','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
update app.content_taxonomy_labels l set superseded_by=t.new_label_id from tgt t where l.content_taxonomy_label_id=t.old_label_id;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, new_label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'automated_spot_check', primary_unit, req,
 'Product Owner chat instruction 2026-10-02 (APPROVAL-0074): run the full pipeline on Chemistry Units 1-3. Blind three-family consensus, max unit '||units_support||'; human review waived under the pattern of APPROVAL-0065, 0069 and 0073.' from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id,
 validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.new_label_id;
do $$ declare n int; begin
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id);
  if n<>37 then raise exception 'post-check: %', n; end if;
  select count(*) into n from (select l.content_item_id from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null group by 1 having count(*)>1) d;
  if n<>0 then raise exception 'multiple active serving labels'; end if;
end $$;
select count(*) validated_fresh from tgt;
