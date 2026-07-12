-- Persist the deterministic verifier and boundary-contract versions on grading
-- results so symbolic/ECF outcomes can be audited and replayed.

begin;

alter table app.grading_results
  add column if not exists deterministic_verifier_version text;

alter table app.grading_results
  add column if not exists boundary_contract_version text;

commit;
