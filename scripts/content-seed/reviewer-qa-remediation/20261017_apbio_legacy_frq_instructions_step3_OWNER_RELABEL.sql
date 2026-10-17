-- Legacy Biology FRQ question-instruction repair (units 1-3): STEP 3, RESTORE SERVING. OWNER-RUN, NOT BY AN AGENT. APPROVAL-0189.
-- Drafted 2026-10-17; NOT YET EXECUTED.
--
-- PROBLEM (found after step 2): publishing the 14 repaired versions left each live version WITHOUT its topic/skill cells
-- (the cells stayed on the retired predecessor) and each item's serving label 'stale' (validated against the retired
-- version). The practice selector (public.select_student_practice_items) only serves items with a 'validated' serving
-- label, so the 14 repaired FRQs are NOT being served to students until this step runs. A read-only selector probe on
-- Production confirmed 0 of the 14 are served in units 1-3 (18 other Biology FRQs are).
--
-- FIX, per the existing republish pattern (publish_mcq_batch.py `republish`): copy each retired predecessor's live cells
-- onto the new live version unchanged, then re-validate the item's existing serving label against the new version
-- (new validation decision recorded in the owner's name, taxonomy hash recomputed). No question, scoring, taxonomy
-- assignment or label content changes.
--
-- Safety: every guard stops with a message and changes nothing. The script ends by asserting that all 14 items are
-- returned by the practice selector for units 1-3; if not, it raises and ROLLS BACK everything.
-- Rehearse first: replace the final `commit;` with `rollback;` (the assertions still fire).

begin;
set local lock_timeout='3s';
set local statement_timeout='60s';
select pg_advisory_xact_lock(hashtext('cramapple-bio-frq-instructions-relabel-20261017'));

create temporary table rl (
  content_key text primary key, item_id uuid, new_version_id uuid, old_version_id uuid, label_id uuid, decision_id uuid default gen_random_uuid()
) on commit drop;

insert into rl (content_key, item_id, new_version_id, old_version_id, label_id)
select i.content_key, i.id, nv.id, (nv.prompt_json->>'qa_source_version_id')::uuid, l.content_taxonomy_label_id
from app.content_items i
join app.content_item_versions nv on nv.content_item_id=i.id and nv.status='published' and nv.prompt_json->>'qa_remediation' like '%APPROVAL-0189%'
join app.content_taxonomy_labels l on l.content_item_id=i.id and l.label_scope='serving' and l.superseded_by is null
where i.content_key in ('APBIO-FRQ-S-003','APBIO-FRQ-S-019','APBIO-FRQ-S-021','APBIO-FRQ-S-023','APBIO-FRQ-S-025','APBIO-FRQ-S-026','APBIO-FRQ-S-028',
  'APBIO-FRQ-S-029','APBIO-FRQ-S-032','APBIO-FRQ-S-033','APBIO-FRQ-S-036','APBIO-FRQ-S-038','APBIO-FRQ-S-071','APBIO-FRQ-S-080');

do $guard$
declare n int;
begin
  if not exists(select 1 from app.profiles where user_id='f5a26c6b-3566-4d58-9e97-979fbb947564' and role='admin') then raise exception 'owner approver unavailable'; end if;
  select count(*) into n from rl; if n<>14 then raise exception 'expected 14 targets with exactly one serving label, got %', n; end if;
  if exists(select 1 from rl where not exists (select 1 from app.content_item_versions o where o.id=rl.old_version_id and o.status='retired' and o.content_item_id=rl.item_id))
    then raise exception 'a predecessor version is not the retired version of the same item'; end if;
  if exists(select 1 from rl join app.content_taxonomy_labels l on l.content_taxonomy_label_id=rl.label_id where l.label_status<>'stale')
    then raise exception 'expected every label to be stale; refusing to touch a label in another state'; end if;
  if exists(select 1 from rl where exists (select 1 from app.content_item_cells c where c.content_item_version_id=rl.new_version_id and c.superseded_by is null))
    then raise exception 'a new version already has cells; refusing to duplicate'; end if;
  if exists(select 1 from rl where not exists (select 1 from app.content_item_cells c where c.content_item_version_id=rl.old_version_id and c.superseded_by is null and c.is_primary))
    then raise exception 'a predecessor has no live primary topic cell to copy'; end if;
end $guard$;

-- 1. copy the predecessor's live cells onto the new live version, unchanged
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary,
  assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select rl.new_version_id, c.content_item_id, c.taxonomy_source_version, c.topic_code, c.skill_code, c.is_primary,
  c.assignment_status, c.source, c.model_run_id, c.validated_by, c.validated_at, c.validation_decision_id
from rl join app.content_item_cells c on c.content_item_version_id=rl.old_version_id and c.superseded_by is null;

-- 2. owner validation decision for each existing serving label, then re-validate it against the new live version
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source,
  reviewed_primary_unit, reviewed_required_units, notes)
select rl.decision_id, rl.label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'automated_spot_check', l.primary_unit, l.required_units,
  'APPROVAL-0189 step 3: content-preserving republish (question instructions added, scoring and topic cells unchanged); serving label re-validated against the new live version.'
from rl join app.content_taxonomy_labels l on l.content_taxonomy_label_id=rl.label_id;

update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(),
  validation_decision_id=rl.decision_id, validated_against_version_id=rl.new_version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(rl.new_version_id)
from rl where l.content_taxonomy_label_id=rl.label_id;

do $verify$
declare n int; unit_n int; served int;
begin
  select count(*) into n from rl join app.content_taxonomy_labels l on l.content_taxonomy_label_id=rl.label_id
    where l.label_status='validated' and l.validated_against_version_id=rl.new_version_id and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(rl.new_version_id);
  if n<>14 then raise exception 'expected 14 re-validated labels, got %', n; end if;
  select count(*) into n from rl where (select count(*) from app.content_item_cells c where c.content_item_version_id=rl.new_version_id and c.superseded_by is null)
     = (select count(*) from app.content_item_cells c where c.content_item_version_id=rl.old_version_id and c.superseded_by is null);
  if n<>14 then raise exception 'cell copy incomplete: % of 14', n; end if;
  -- the real test: does the student practice selector now return all 14 in units 1-3 (same call the audit probe uses)?
  select count(distinct q.content_key) into served
  from (values (1),(2),(3)) un(u) cross join generate_series(0,255,51) off
  cross join lateral public.select_student_practice_items('2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', un.u, '00000000-0000-4000-8000-000000000000', null, null, null, 51, off) q
  where q.content_key in (select content_key from rl);
  if served<>14 then raise exception 'practice selector returns % of 14 repaired FRQs; rolling back', served; end if;
end $verify$;

select 'relabelled' metric, count(*)::text value from rl
union all select 'served_by_selector', '14 of 14 (asserted)';

commit;
