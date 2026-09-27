-- Correct approval provenance after reconciling with main, where APPROVAL-0051
-- was already assigned to TASK-0044. TASK-0042 is APPROVAL-0056.
begin;

create temporary table tmp_task0042_approval_note_corrections on commit drop as
select d.validation_decision_id
from app.content_taxonomy_validation_decisions d
join app.content_taxonomy_labels l
  on l.content_taxonomy_label_id = d.content_taxonomy_label_id
where l.model_run_id in (
  'serving-units-mcp-2026-09-25-20260927113404',
  'serving-units-mcp-2026-09-25-20260927113406',
  'serving-units-mcp-2026-09-25-20260927113517'
)
  and d.notes like 'APPROVAL-0051 / DECISION-0066:%';

do $$
declare v_count integer;
begin
  select count(*) into v_count
  from tmp_task0042_approval_note_corrections;
  if v_count <> 152 then
    raise exception 'TASK-0042 approval-note correction drift: expected 152, found %', v_count;
  end if;
end $$;

update app.content_taxonomy_validation_decisions d
set notes = 'APPROVAL-0056 /' || substring(d.notes from length('APPROVAL-0051 /') + 1)
from tmp_task0042_approval_note_corrections c
where c.validation_decision_id = d.validation_decision_id;

do $$
declare
  v_new integer;
  v_old integer;
begin
  select count(*) into v_new
  from app.content_taxonomy_validation_decisions d
  join tmp_task0042_approval_note_corrections c
    on c.validation_decision_id = d.validation_decision_id
  where d.notes like 'APPROVAL-0056 / DECISION-0066:%';

  select count(*) into v_old
  from app.content_taxonomy_validation_decisions d
  join tmp_task0042_approval_note_corrections c
    on c.validation_decision_id = d.validation_decision_id
  where d.notes like 'APPROVAL-0051 / DECISION-0066:%';

  if v_new <> 152 or v_old <> 0 then
    raise exception 'TASK-0042 approval-note verification failed: new %, old %', v_new, v_old;
  end if;
end $$;

commit;
