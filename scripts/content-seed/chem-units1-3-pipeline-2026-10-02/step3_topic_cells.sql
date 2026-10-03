-- AP Chemistry Units 1-3 pipeline step 3: primary topic cells (topic only) from a blind 3-family x 2-sample probe, topic agreement >= 5 of 6. Chemistry had no primary topic cells.
-- Relies on migration 20261002164510 (model_run_id instead of a human validated_by). APPROVAL-0074.
begin;
select pg_advisory_xact_lock(hashtext('cramapple-apchem-u13-topic-cells-20261002'));
create temporary table tc (content_key text primary key, topic text, support text) on commit drop;
insert into tc values
('apchem-frq-l-002','2.6','6/6'),
('apchem-frq-l-003','3.6','6/6'),
('apchem-frq-l-011','3.4','6/6'),
('apchem-frq-l-012','3.6','6/6'),
('apchem-frq-l-013','3.9','6/6'),
('apchem-mcq-001','1.1','6/6'),
('apchem-mcq-003','2.7','6/6'),
('apchem-mcq-005','3.5','6/6'),
('apchem-mcq-006','3.13','6/6'),
('apchem-mcq-007','3.10','6/6'),
('apchem-mcq-008','3.4','6/6'),
('apchem-mcq-021','1.1','6/6'),
('apchem-mcq-022','1.5','6/6'),
('apchem-mcq-023','1.6','6/6'),
('apchem-mcq-024','1.7','6/6'),
('apchem-mcq-025','2.1','6/6'),
('apchem-mcq-026','2.5','6/6'),
('apchem-mcq-027','2.6','6/6'),
('apchem-mcq-028','2.7','6/6'),
('apchem-mcq-029','3.1','6/6'),
('apchem-mcq-030','3.1','6/6'),
('apchem-mcq-031','3.2','6/6'),
('apchem-mcq-032','3.4','6/6'),
('apchem-mcq-033','3.5','6/6'),
('apchem-mcq-034','3.6','6/6'),
('apchem-mcq-035','3.10','6/6'),
('apchem-mcq-036','3.13','6/6'),
('apchem-mcq-037','3.12','6/6'),
('apchem-mcq-038','3.9','6/6'),
('apchem-mcq-039','3.7','6/6'),
('apchem-sfrq-004','3.13','6/6'),
('apchem-sfrq-014','2.7','6/6'),
('apchem-sfrq-015','3.4','6/6'),
('apchem-sfrq-016','3.1','6/6'),
('apchem-sfrq-018','3.1','5/6'),
('apchem-sfrq-019','3.7','6/6');
create temporary table tg on commit drop as select t.*, civ.id version_id, ci.id item_id from tc t join app.content_items ci on ci.content_key=t.content_key and ci.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and ci.status='published' join app.content_item_versions civ on civ.content_item_id=ci.id and civ.status='published';
do $$ begin
  if (select count(*) from tg)<>36 then raise exception 'expected 36 targets, got %', (select count(*) from tg); end if;
  if exists (select 1 from tg g join app.content_item_cells c on c.content_item_version_id=g.version_id and c.is_primary and c.superseded_by is null) then raise exception 'a target already has a primary cell'; end if;
end $$;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, 'cbe3116f-6ef5-410c-b535-e9fb711c4c2c', topic, null, true, 'validated', 'apchem_topic_probe_2026_10_02:'||support,
 'apchem-topic-probe-2026-10-02 (google/gemini-3.8-flash + deepseek/deepseek-v4-pro + openai/gpt-6.1-sol, 2 samples each; topic agreement >=5 of 6)', null, now(), gen_random_uuid() from tg;
do $$ declare n int; begin
  select count(*) into n from app.content_item_cells c join tg g on g.version_id=c.content_item_version_id where c.is_primary and c.topic_code=g.topic and c.assignment_status='validated' and c.superseded_by is null;
  if n<>36 then raise exception 'post-check %', n; end if;
end $$;
select count(*) written from tg;
