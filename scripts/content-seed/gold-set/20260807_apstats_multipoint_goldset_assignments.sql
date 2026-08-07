-- Assign the 4 newly-generated multi-point AP Statistics gold-set items
-- (set_key='A', 30 provisional_accept/reader_queue answers across
-- APSTATS-SFRQ-007/008/009/010, TASK-0022) to Muhammad Saood and Jill
-- Schmidlkofer, mirroring the existing set-B pilot's two-reader-per-answer
-- design (both readers mark the same answers, per §5 of
-- GOLD_SET_GENERATION_PROTOCOL.md -- reader consensus needs both readers on
-- the same items to compute agreement). Jill's cold-verification pass on
-- this set is also her first opportunity to confirm the element
-- decomposition drafted in 20260807_apstats_multipoint_redecomposition.sql.
--
-- Removes 4 single-point set-B assignments from Jill's existing pending
-- queue (her earliest 4 by seq) to make room without growing her total load.
--
-- Owner instruction, 2026-08-07: "Add those questions to the gold set and
-- assign them to Saood and Jill. ... remove 4 single-point questions from
-- her queue."

begin;
select pg_advisory_xact_lock(hashtext('cramapple-apstats-multipoint-goldset-assignments-20260807'));

-- gold_set_verification_assignments has no 'skipped' status (only pending/
-- submitted/flagged_contaminated); removing means deleting the still-pending
-- (never-submitted, no marks) row, same as the Tutor Beta cleanup earlier
-- this session.
create temporary table jill_removed as
select gold_set_verification_assignment_id
from app.gold_set_verification_assignments
where reviewer_id='0a5909f7-f50b-486a-a31f-4fc3cc47e039'::uuid and status='pending'
order by seq
limit 4;

delete from app.gold_set_verification_assignments
where gold_set_verification_assignment_id in (select gold_set_verification_assignment_id from jill_removed);

insert into app.gold_set_verification_assignments (gold_set_answer_id, reviewer_id, seq, status, assigned_at)
select ga.gold_set_answer_id, r.reviewer_id,
  m.max_seq + row_number() over (partition by r.reviewer_id order by ga.gold_set_answer_id),
  'pending', now()
from app.gold_set_answers ga
cross join (values ('cee0cee4-fc59-4084-9a83-b24ccca940b9'::uuid), ('0a5909f7-f50b-486a-a31f-4fc3cc47e039'::uuid)) as r(reviewer_id)
join (
  select reviewer_id, coalesce(max(seq),0) max_seq
  from app.gold_set_verification_assignments
  where reviewer_id in ('cee0cee4-fc59-4084-9a83-b24ccca940b9'::uuid,'0a5909f7-f50b-486a-a31f-4fc3cc47e039'::uuid)
  group by reviewer_id
) m on m.reviewer_id=r.reviewer_id
where ga.set_key='A'
  and ga.content_item_version_id in (
    '07ef9bbb-739d-4807-9928-ef02b7d7583f','efc05957-06a3-4b0e-8097-9926841fdaff',
    '22c1824d-b601-4050-83ae-edb18b8e98bb','7abbb85e-a697-4db6-bea8-b363bea8f36e'
  );

do $$
declare v_saood integer; v_jill integer; v_jill_removed integer;
begin
  select count(*) into v_saood from app.gold_set_verification_assignments where reviewer_id='cee0cee4-fc59-4084-9a83-b24ccca940b9'::uuid and status='pending' and gold_set_answer_id in (select gold_set_answer_id from app.gold_set_answers where set_key='A');
  select count(*) into v_jill from app.gold_set_verification_assignments where reviewer_id='0a5909f7-f50b-486a-a31f-4fc3cc47e039'::uuid and status='pending' and gold_set_answer_id in (select gold_set_answer_id from app.gold_set_answers where set_key='A');
  if v_saood<>30 or v_jill<>30 then
    raise exception 'assignment count mismatch: saood=%, jill=%, expected 30 each', v_saood, v_jill;
  end if;

  select count(*) into v_jill_removed from jill_removed;
  if v_jill_removed<>4 then
    raise exception 'expected 4 removed single-point assignments for Jill, found %', v_jill_removed;
  end if;
end $$;

select 'Saood' as reviewer, count(*) as new_pending from app.gold_set_verification_assignments where reviewer_id='cee0cee4-fc59-4084-9a83-b24ccca940b9'::uuid and status='pending' and gold_set_answer_id in (select gold_set_answer_id from app.gold_set_answers where set_key='A')
union all
select 'Jill', count(*) from app.gold_set_verification_assignments where reviewer_id='0a5909f7-f50b-486a-a31f-4fc3cc47e039'::uuid and status='pending' and gold_set_answer_id in (select gold_set_answer_id from app.gold_set_answers where set_key='A');

commit;
