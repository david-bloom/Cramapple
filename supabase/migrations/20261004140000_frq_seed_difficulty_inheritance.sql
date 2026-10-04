-- DECISION-0096 extended to FRQ variants (David Bloom, 2026-10-04: "yes, apply the same rule to FRQ variants").
-- The one published FRQ variant without a difficulty band, apcalcab-frq-u1v-001-v2, inherits its seed's band
-- (apcalcab-frq-u1n-001: Medium, calibrated_judgement, high; both sibling variants are also Medium).
-- Applied to Production 2026-10-04 under APPROVAL-0117. Afterwards every published item in all 10 subjects has a
-- band (FRQ 572/572, MCQ 1,718/1,718).
-- Rollback: delete from app.content_item_difficulty where proposal_run = 'frq-seed-difficulty-2026-10-04';
-- Trap 1: record this as version 20261004140000 on every environment (file name = ledger version).

begin;
do $$ begin
  if exists (select 1 from app.content_item_difficulty where content_item_version_id='eaf4260e-c12d-4cfd-9eb9-d9c918bd6f7b') then
    raise exception 'target already has a difficulty row'; end if;
end $$;
insert into app.content_item_difficulty (content_item_version_id, difficulty, basis, source_value, rationale, confidence, proposal_run)
select 'eaf4260e-c12d-4cfd-9eb9-d9c918bd6f7b', d.difficulty, 'translated', 'apcalcab-frq-u1n-001',
  'Inherited from seed apcalcab-frq-u1n-001 (DECISION-0096, extended to FRQ variants 2026-10-04).', d.confidence, 'frq-seed-difficulty-2026-10-04'
from app.content_items s join app.content_item_versions sv on sv.content_item_id=s.id and sv.status='published'
join app.content_item_difficulty d on d.content_item_version_id=sv.id
where s.content_key='apcalcab-frq-u1n-001' and s.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d';
do $$ declare n int; begin
  select count(*) into n from app.content_item_difficulty where proposal_run='frq-seed-difficulty-2026-10-04';
  if n<>1 then raise exception 'expected 1 row, got %', n; end if;
end $$;
commit;
