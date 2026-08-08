-- Assign the 20 new-protocol AP Physics 1 Units 1-3 items (10 FRQ + 10 MCQ,
-- content_key apphy1-frq-np1-* / apphy1-mcq-np1-*) to Muhammad Saood for
-- tutor_question review. Run after both batch scripts in this directory.
--
-- Owner-directed assignee, 2026-08-08. Saood handled the E&M np1 batch this
-- same session (117/117 of the E&M corpus-wide decisions to date). His
-- AP Physics 1 qualification/prior-volume was NOT re-verified this session
-- due to a Supabase MCP auth lapse — check app.validator_qualifications for
-- Physics 1 before running this script; if he is not qualified, re-target
-- this assignment to a qualified Physics 1 reviewer instead.

begin;
select pg_advisory_xact_lock(hashtext('cramapple-apphy1-newprotocol-assign-saood-20260808'));

do $$
declare
  v_saood_id uuid;
  v_count int;
begin
  select user_id into v_saood_id from app.profiles where full_name = 'Muhammad Saood';
  if v_saood_id is null then
    raise exception 'reviewer_not_found:Muhammad Saood';
  end if;

  select count(*) into v_count from app.content_items
  where content_key like 'apphy1-frq-np1-%' or content_key like 'apphy1-mcq-np1-%';
  if v_count <> 20 then
    raise exception 'expected_20_np1_items_found_%', v_count;
  end if;

  insert into app.content_review_assignments (
    content_review_assignment_id, content_item_version_id, reviewer_id,
    review_stage, review_kind, status, assignment_purpose, created_by
  )
  select gen_random_uuid(), civ.id, v_saood_id,
    'tutor_question', ci.item_type, 'pending', 'subject_review', v_saood_id
  from app.content_items ci
  join app.content_item_versions civ on civ.content_item_id = ci.id
  where ci.content_key like 'apphy1-frq-np1-%' or ci.content_key like 'apphy1-mcq-np1-%';
end $$;

commit;

select ci.content_key, cra.review_kind, cra.status, cra.assigned_at
from app.content_review_assignments cra
join app.content_item_versions civ on civ.id = cra.content_item_version_id
join app.content_items ci on ci.id = civ.content_item_id
where ci.content_key like 'apphy1-frq-np1-%' or ci.content_key like 'apphy1-mcq-np1-%'
order by ci.content_key;
