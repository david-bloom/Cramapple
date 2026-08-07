-- Remove Tutor Beta (aaaaaaaa-0002-0000-0000-000000000002, a QA fixture
-- profile) from any active Review Task or Gold Set assignment.
--
-- Owner instruction, 2026-08-06: "Search for any Review Tasks or Gold Set
-- assignments to Tutor Beta. If found, remove them. Tutor Beta is a QA
-- profile."
--
-- Findings:
--   * 2 app.content_review_assignments (APBIO-MCQ-078, tutor_question and
--     tutor_answer stages, status='submitted') carry a decision each. Both
--     are 2026-06-28 fixture/seed data alongside other seed reviewers
--     ("Tutor Alpha", "Reader Gamma") on an item stuck at status='assigned'
--     (never published, no production impact). They could NOT be removed:
--     app.content_review_decisions is protected by the
--     prevent_review_decision_mutation trigger, which blocks delete as well
--     as update, and content_review_decisions_assignment_id_fkey cascades
--     the assignment delete into that blocked delete. Decision immutability
--     is intentional (audit-trail integrity) and this script does not
--     attempt to bypass it. These two rows are left in place; flagged to the
--     Product Owner for an explicit call if hard removal is ever wanted.
--   * 8 app.gold_set_verification_assignments (status='pending', assigned
--     2026-08-03, no marks recorded) had no dependent rows and were removed
--     below.

begin;
select pg_advisory_xact_lock(hashtext('cramapple-remove-tutor-beta-goldset-20260806'));

delete from app.gold_set_verification_assignments
where reviewer_id='aaaaaaaa-0002-0000-0000-000000000002'::uuid;

do $$
declare
  v_remaining integer;
begin
  select count(*) into v_remaining
  from app.gold_set_verification_assignments
  where reviewer_id='aaaaaaaa-0002-0000-0000-000000000002'::uuid;

  if v_remaining <> 0 then
    raise exception 'tutor_beta_goldset_removal_incomplete:%', v_remaining;
  end if;
end $$;

commit;
