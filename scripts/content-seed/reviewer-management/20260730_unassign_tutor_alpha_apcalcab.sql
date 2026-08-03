-- Return Tutor Alpha's single AP Calculus AB assignment to the unassigned pool.
-- Preserve the historical pipeline-test decision and all other reviewers'
-- assignments on the content version.

begin;

select pg_advisory_xact_lock(
  hashtext('cramapple-unassign-tutor-alpha-apcalcab-20260730')
);

do $$
declare
  v_target_count integer;
  v_assignment_id uuid;
  v_decision_count integer;
begin
  select
    count(*),
    min(a.content_review_assignment_id::text)::uuid
  into v_target_count,v_assignment_id
  from app.content_review_assignments a
  join app.content_item_versions civ
    on civ.id=a.content_item_version_id
  join app.content_items ci
    on ci.id=civ.content_item_id
  join app.exam_pack_versions epv
    on epv.id=ci.exam_pack_version_id
  join app.exam_packs ep
    on ep.id=epv.exam_pack_id
  where a.reviewer_id='aaaaaaaa-0001-0000-0000-000000000001'::uuid
    and ep.exam_code='ap_calculus_ab'
    and a.status in ('pending','in_progress');

  if v_target_count<>1 then
    raise exception
      'Expected exactly one active Tutor Alpha AP Calculus AB assignment, found %',
      v_target_count;
  end if;

  if v_assignment_id<>
     '7b44dfe6-3a77-436f-b94e-a2e3015a3551'::uuid then
    raise exception
      'Resolved an unexpected Tutor Alpha assignment: %',
      v_assignment_id;
  end if;

  select count(*)
  into v_decision_count
  from app.content_review_decisions d
  where d.content_review_assignment_id=v_assignment_id;

  if v_decision_count<>1 then
    raise exception
      'Expected the preserved pipeline-test decision, found % decisions',
      v_decision_count;
  end if;

  update app.content_review_assignments
  set status='skipped'
  where content_review_assignment_id=v_assignment_id
    and status in ('pending','in_progress');

  if not found then
    raise exception 'Tutor Alpha assignment was not updated';
  end if;
end
$$;

do $$
declare
  v_active integer;
  v_skipped integer;
  v_decisions integer;
begin
  select
    count(*) filter(where a.status in ('pending','in_progress')),
    count(*) filter(where a.status='skipped'),
    count(d.content_review_decision_id)
  into v_active,v_skipped,v_decisions
  from app.content_review_assignments a
  join app.content_item_versions civ
    on civ.id=a.content_item_version_id
  join app.content_items ci
    on ci.id=civ.content_item_id
  join app.exam_pack_versions epv
    on epv.id=ci.exam_pack_version_id
  join app.exam_packs ep
    on ep.id=epv.exam_pack_id
  left join app.content_review_decisions d
    on d.content_review_assignment_id=a.content_review_assignment_id
  where a.reviewer_id='aaaaaaaa-0001-0000-0000-000000000001'::uuid
    and ep.exam_code='ap_calculus_ab';

  if (v_active,v_skipped,v_decisions)<>(0,1,1) then
    raise exception
      'Tutor Alpha unassignment verification failed: active %, skipped %, decisions %',
      v_active,v_skipped,v_decisions;
  end if;
end
$$;

commit;
