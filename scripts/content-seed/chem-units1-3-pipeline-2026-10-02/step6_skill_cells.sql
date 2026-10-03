begin;
select pg_advisory_xact_lock(hashtext('cramapple-apchem-u13-skill-cells-20261002'));
create temporary table tgt (content_key text primary key, topic text, skill text, status text, tier text) on commit drop;
insert into tgt values
('apchem-frq-l-002','2.6','6.C','provisional_model','2of4'),
('apchem-frq-l-003','3.6','6.E','validated','4of4'),
('apchem-frq-l-011','3.4','5.F','validated','4of4'),
('apchem-frq-l-012','3.6','6.E','validated','4of4'),
('apchem-frq-l-013','3.9','2.C','validated','4of4'),
('apchem-mcq-001','1.1','5.F','validated','4of4'),
('apchem-mcq-003','2.7','6.A','provisional_model','2of4'),
('apchem-mcq-005','3.5','4.A','validated','4of4'),
('apchem-mcq-006','3.13','2.B','validated','3of4'),
('apchem-mcq-007','3.10','4.A','validated','4of4'),
('apchem-mcq-008','3.4','5.F','validated','4of4'),
('apchem-mcq-021','1.1','5.F','validated','4of4'),
('apchem-mcq-022','1.5','1.A','validated','4of4'),
('apchem-mcq-023','1.6','4.A','validated','4of4'),
('apchem-mcq-024','1.7','4.A','validated','4of4'),
('apchem-mcq-025','2.1','6.A','provisional_model','2of4'),
('apchem-mcq-026','2.5','3.B','validated','4of4'),
('apchem-mcq-027','2.6','6.D','validated','3of4'),
('apchem-mcq-030','3.1','4.C','validated','4of4'),
('apchem-mcq-031','3.2','4.C','validated','3of4'),
('apchem-mcq-032','3.4','5.F','validated','4of4'),
('apchem-mcq-033','3.5','4.A','validated','4of4'),
('apchem-mcq-034','3.6','6.E','validated','4of4'),
('apchem-mcq-035','3.10','4.C','validated','4of4'),
('apchem-mcq-036','3.13','2.D','validated','4of4'),
('apchem-mcq-037','3.12','5.C','validated','4of4'),
('apchem-mcq-038','3.9','2.C','validated','4of4'),
('apchem-mcq-039','3.7','5.F','validated','4of4'),
('apchem-sfrq-004','3.13','2.F','validated','3of4'),
('apchem-sfrq-014','2.7','6.C','provisional_model','2of4'),
('apchem-sfrq-015','3.4','5.F','validated','4of4'),
('apchem-sfrq-016','3.1','4.C','validated','3of4'),
('apchem-sfrq-018','3.1','4.C','validated','4of4'),
('apchem-sfrq-019','3.7','5.F','validated','4of4');
create temporary table tg on commit drop as select t.*, civ.id version_id, ci.id item_id from tgt t join app.content_items ci on ci.content_key=t.content_key and ci.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and ci.status='published' join app.content_item_versions civ on civ.content_item_id=ci.id and civ.status='published';
do $$ begin
  if (select count(*) from tg)<>34 then raise exception 'target count'; end if;
  if exists (select 1 from tg g where not exists (select 1 from app.content_item_cells c where c.content_item_version_id=g.version_id and c.is_primary and c.topic_code=g.topic and c.superseded_by is null)) then raise exception 'a target has no matching primary topic cell'; end if;
  if exists (select 1 from tg g join app.content_item_cells c on c.content_item_version_id=g.version_id and c.skill_code is not null and c.superseded_by is null) then raise exception 'a target already has a skill cell'; end if;
end $$;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, 'cbe3116f-6ef5-410c-b535-e9fb711c4c2c', topic, skill, false, status, 'apchem_skill_phase_b_2026_10_02:'||tier,
 case when status='validated' then 'apchem-skill-phase-b-2026-10-02 (4 voters: claude-opus-5, gpt-5.5, gemini-2.5-pro, gemini-3.8-flash; validated at >=3 of 4)' else 'apchem-skill-phase-b-2026-10-02 (4 voters; unique 2-of-4 plurality, below the 3-of-4 validation bar)' end,
 null, case when status='validated' then now() else null end, case when status='validated' then gen_random_uuid() else null end from tg;
do $$ declare n int; begin
  select count(*) into n from app.content_item_cells c join tg g on g.version_id=c.content_item_version_id where c.skill_code=g.skill and c.topic_code=g.topic and not c.is_primary and c.assignment_status=g.status and c.superseded_by is null;
  if n<>34 then raise exception 'post-check %', n; end if;
end $$;
select (select count(*) from tg where status='validated') validated, (select count(*) from tg where status<>'validated') provisional;
commit;
