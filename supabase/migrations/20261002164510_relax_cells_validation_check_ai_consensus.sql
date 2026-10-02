-- DECISION-0085 route 1 (David, 2026-10-02: "change the validator rule in production from the human requirement to the AI requirement").
-- A 'validated' content_item_cells row now needs a validated_at, a validation_decision_id and EITHER a human validated_by OR a model_run_id (the consensus trail).
-- Rows that are not 'validated' still may not carry a complete validation record. Existing rows are unaffected (the new rule is a superset of the old one).
-- Applied to Production (pcntajvbdfqhbeewmdry) 2026-10-02 as version 20261002164510 after a rolled-back rehearsal (AI-validated accepted; missing decision id,
-- missing human+model run, and a non-validated row with a full record all rejected).
alter table app.content_item_cells drop constraint content_item_cells_validation_check;
alter table app.content_item_cells add constraint content_item_cells_validation_check check (
  (assignment_status = 'validated') = (validated_at is not null and validation_decision_id is not null and (validated_by is not null or model_run_id is not null)));
