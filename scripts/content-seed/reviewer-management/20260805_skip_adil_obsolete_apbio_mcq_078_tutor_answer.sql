-- Remove the obsolete answer-review row that collides with Adil's active
-- question-quality review for APBIO-MCQ-078. Preserve all content and any
-- immutable decisions; this obsolete assignment has no decisions.

begin;

select pg_advisory_xact_lock(
  hashtext('skip-adil-obsolete-apbio-mcq-078-tutor-answer')
);

do $$
declare
  v_obsolete app.content_review_assignments%rowtype;
  v_current app.content_review_assignments%rowtype;
  v_key text;
begin
  select * into strict v_obsolete
  from app.content_review_assignments
  where content_review_assignment_id=
    'fdeaf261-1bb4-48e6-9814-7979e8a138cf'
  for update;

  select * into strict v_current
  from app.content_review_assignments
  where content_review_assignment_id=
    '20196f88-387c-4e00-a68b-aa850e537c5c'
  for update;

  select ci.content_key into strict v_key
  from app.content_item_versions civ
  join app.content_items ci on ci.id=civ.content_item_id
  where civ.id=v_obsolete.content_item_version_id;

  if lower(v_key)<>lower('APBIO-MCQ-078')
     or v_obsolete.content_item_version_id<>v_current.content_item_version_id
     or v_obsolete.reviewer_id<>'af36ebd6-ba8f-48bd-ad58-b3e0fd4914a8'
     or v_current.reviewer_id<>v_obsolete.reviewer_id
     or v_obsolete.review_stage<>'tutor_answer'
     or v_current.review_stage<>'tutor_question'
     or v_obsolete.review_kind<>'mcq'
     or v_current.review_kind<>'mcq'
     or v_current.status not in ('pending','in_progress') then
    raise exception 'APBIO-MCQ-078 assignment identities or states changed';
  end if;

  if exists (
    select 1 from app.content_review_decisions d
    where d.content_review_assignment_id=
      v_obsolete.content_review_assignment_id
  ) then
    raise exception 'obsolete tutor_answer assignment unexpectedly has a decision';
  end if;

  if v_obsolete.status in ('pending','in_progress') then
    update app.content_review_assignments
    set status='skipped'
    where content_review_assignment_id=
      v_obsolete.content_review_assignment_id;
  elsif v_obsolete.status<>'skipped' then
    raise exception 'obsolete tutor_answer assignment is unexpectedly %',
      v_obsolete.status;
  end if;
end
$$;

do $$
begin
  if not exists (
    select 1
    from app.content_review_assignments
    where content_review_assignment_id=
      'fdeaf261-1bb4-48e6-9814-7979e8a138cf'
      and status='skipped'
  ) or not exists (
    select 1
    from app.content_review_assignments
    where content_review_assignment_id=
      '20196f88-387c-4e00-a68b-aa850e537c5c'
      and status in ('pending','in_progress')
  ) then
    raise exception 'APBIO-MCQ-078 post-update verification failed';
  end if;
end
$$;

commit;
