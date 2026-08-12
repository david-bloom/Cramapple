-- Gold-set Set B assignment, 2026-08-11, owner-directed ("Use Set B instead, ensure
-- everyone has a queue"). Set A is complete (60/60 submitted, fixed 2-reader pilot) and
-- has no unfinished content; this assigns from Set B's 58 zero-reader answers instead.
--
-- Ahmed Ali currently holds zero gold-set assignments of any status (removed in the
-- 08-11 pause's 15-row cleanup) -- the literal violation of "all gold set reviewers have
-- a corpus to complete." Assigned all 50 unassigned Set B answers in his qualified
-- subjects (Physics 1/2, C:Mechanics, C:E&M).
--
-- Jill Schmidlkofer is also at 0 pending (40 submitted, finished) and is qualified only
-- for AP Statistics. Assigned the 8 unassigned Set B Statistics answers.
--
-- Abdul Hanan is at 0 pending (46 submitted, finished) but is qualified only for Calc
-- AB/BC/Precalculus -- zero unassigned Set B answers exist in those subjects, so no
-- assignment was possible for him; noted, not silently skipped. Chisom Anuba (45
-- pending), Ghazanfar Ali (54 pending), and Muhammad Saood (34 pending) already have
-- substantial active queues and were not given more.

begin;
select pg_advisory_xact_lock(hashtext('cramapple-goldset-setb-assign-20260811'));

create temporary table targets on commit drop as
select gsa.gold_set_answer_id,
  case when subj.display_name = 'AP Statistics' then (select user_id from app.profiles where full_name='Jill Schmidlkofer')
       else (select user_id from app.profiles where full_name='Ahmed Ali') end as reviewer_id,
  row_number() over (partition by (subj.display_name='AP Statistics') order by gsa.gold_set_answer_id) as rn
from app.gold_set_answers gsa
join app.content_item_versions civ on civ.id=gsa.content_item_version_id
join app.content_items ci on ci.id=civ.content_item_id
join app.exam_pack_versions epv on epv.id=ci.exam_pack_version_id
join app.exam_packs ep on ep.id=epv.exam_pack_id
join app.subjects subj on subj.id=ep.subject_id
where gsa.set_key='B'
  and not exists (select 1 from app.gold_set_verification_assignments gva where gva.gold_set_answer_id=gsa.gold_set_answer_id)
  and subj.display_name in ('AP Physics 1','AP Physics 2','AP Physics C: Mechanics','AP Physics C: Electricity and Magnetism','AP Statistics');

do $$ declare n int; begin
  select count(*) into n from targets;
  if n<>58 then raise exception 'expected 58 targets, got %', n; end if;
end $$;

insert into app.gold_set_verification_assignments (gold_set_verification_assignment_id, gold_set_answer_id, reviewer_id, seq, status, assigned_at)
select gen_random_uuid(), t.gold_set_answer_id, t.reviewer_id,
  t.rn + coalesce((select max(g.seq) from app.gold_set_verification_assignments g where g.reviewer_id=t.reviewer_id),0),
  'pending', now()
from targets t;

commit;
