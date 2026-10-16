-- PRODUCTION: enable ONE subject for specific units. Owner approval required PER SUBJECT, with the
-- unit list stated in the approval. Substitute __SUBJECT__ (registry key, e.g. ap-statistics) and
-- __UNITS__ (e.g. {1,2,3}). Preconditions (do not run before all are true):
--   1. 01_apply_gate.sql applied on Production.   2. Production more-help is v16 or later (JWT-verified).
--   3. The app change for this subject is merged but NOT yet published (publish the app AFTER this step,
--      so the button never appears before the backend accepts the subject).
--   4. The owner accepted the Development output packet.
-- Reversible at once with 03_rollback_subject.sql; no student data is touched.
begin;
do $g$ begin
  if to_regclass('app.more_help_subject_policy') is null then raise exception 'Run 01_apply_gate.sql first'; end if;
  if not exists(select 1 from app.subjects where subject_key = '__SUBJECT__') then raise exception 'Unknown registry subject key'; end if;
  if '__UNITS__'::int[] is null or cardinality('__UNITS__'::int[]) = 0 then raise exception 'A unit list is required for a new subject'; end if;
end $g$;
insert into app.more_help_subject_policy(subject_key, allowed_units, note)
values ('__SUBJECT__', '__UNITS__'::int[], 'owner-approved rollout; see APPROVALS_LOG');
select * from app.more_help_subject_policy order by subject_key;
commit;
