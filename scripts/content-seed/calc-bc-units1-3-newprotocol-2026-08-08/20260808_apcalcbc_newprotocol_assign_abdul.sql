-- Assign the 20 new-protocol AP Calculus BC Units 1-3 items (10 FRQ + 10 MCQ,
-- content_key apcalcbc-frq-np1-* / apcalcbc-mcq-np1-*) to Abdul Hanan for
-- tutor_question review. Run after both batch scripts in this directory.
--
-- Abdul Hanan: 88 prior AP Calculus BC adjudications (52 approve, 35
-- approve_with_edits, 1 disapprove) as of the 2026-08-08 reviewer QA sweep —
-- chosen as a proven, active BC reviewer for this comparison batch.

begin;
select pg_advisory_xact_lock(hashtext('cramapple-apcalcbc-newprotocol-assign-abdul-20260808'));

do $$
declare
  v_abdul_id uuid;
  v_count int;
begin
  select user_id into v_abdul_id from app.profiles where full_name = 'Abdul Hanan';
  if v_abdul_id is null then
    raise exception 'reviewer_not_found:Abdul Hanan';
  end if;

  select count(*) into v_count from app.content_items
  where content_key like 'apcalcbc-frq-np1-%' or content_key like 'apcalcbc-mcq-np1-%';
  if v_count <> 20 then
    raise exception 'expected_20_np1_items_found_%', v_count;
  end if;

  insert into app.content_review_assignments (
    content_review_assignment_id, content_item_version_id, reviewer_id,
    review_stage, review_kind, status, assignment_purpose, created_by
  )
  select gen_random_uuid(), civ.id, v_abdul_id,
    'tutor_question', ci.item_type, 'pending', 'subject_review', v_abdul_id
  from app.content_items ci
  join app.content_item_versions civ on civ.content_item_id = ci.id
  where ci.content_key like 'apcalcbc-frq-np1-%' or ci.content_key like 'apcalcbc-mcq-np1-%';
end $$;

commit;

select ci.content_key, cra.review_kind, cra.status, cra.assigned_at
from app.content_review_assignments cra
join app.content_item_versions civ on civ.id = cra.content_item_version_id
join app.content_items ci on ci.id = civ.content_item_id
where ci.content_key like 'apcalcbc-frq-np1-%' or ci.content_key like 'apcalcbc-mcq-np1-%'
order by ci.content_key;
