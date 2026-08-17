-- APSTATS-HDG-2026-GRAPH-005: owner-directed single-reviewer publish, 2026-08-13.
-- See docs/research/REVIEWER_WORKFLOW_GAP_2026_08_13.md §3a for full context.
--
-- Only ever had one assigned tutor (Jill Schmidlkofer, approve/score 1,
-- 2026-07-21), never paired with a second reviewer. Owner explicitly directed
-- accepting single-reviewer approval rather than requiring a second tutor.
--
-- Before publishing, verified this was safe: Jill's note (carried over near-
-- verbatim between her two submissions) describes an unrealistically perfect
-- correlation (r=.997) with "hours studied" values 2 through 10, one student
-- each. The CURRENTLY STORED stimulus does not match that complaint -- data
-- on file is hours 0-5 with repeated values, scores 58-94 with real scatter
-- (independently recomputed r~=0.77), essentially the exact fix her own note
-- suggested. The data was evidently revised after her review; her note is
-- stale commentary on a superseded version, not a live concern.

begin;
select pg_advisory_xact_lock(hashtext('cramapple-workflow-gap-remediation-20260813'));

-- Same stale version-status pattern found repeatedly this session.
update app.content_item_versions v
set status='reviewed_approved', updated_at=now()
from app.content_items ci
where v.content_item_id=ci.id and ci.content_key='APSTATS-HDG-2026-GRAPH-005'
  and ci.status='reviewed_approved' and v.status='retired'
  and v.id=(select id from app.content_item_versions v2 where v2.content_item_id=ci.id order by v2.version_num desc limit 1);

do $$
declare v_item app.content_items%rowtype; v_version_id uuid;
begin
  select * into strict v_item from app.content_items where content_key='APSTATS-HDG-2026-GRAPH-005' and item_type='frq';
  select id into strict v_version_id from app.content_item_versions where content_item_id=v_item.id order by version_num desc limit 1;

  insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
  values (gen_random_uuid(), v_version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 'frq', 'pending', 'owner_remediation_approval', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid);

  insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, tutor_decision, decision_payload, decision_hash, created_by)
  select cra.content_review_assignment_id, v_version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 1, 'Easy', false, array[]::text[],
    'Owner adjudication, 2026-08-13: only ever had one assigned tutor (Jill Schmidlkofer, approve/score 1, 2026-07-21), never paired with a second reviewer -- accepting single-reviewer approval per explicit owner direction rather than blocking on the unstaffed two-reviewer requirement. Verified the stored stimulus data does not match the unrealistic-data complaint in Jill''s carried-over note (r=.997, hours 2-10 one each): current data (hours 0-5 with repeats, scores 58-94, r~=0.77) is realistic and was evidently already revised; her note describes a superseded version. Approving.',
    'approve',
    jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','single_reviewer_owner_accepted','content_key','APSTATS-HDG-2026-GRAPH-005','qa_date','2026-08-13'),
    encode(extensions.digest(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','single_reviewer_owner_accepted','content_key','APSTATS-HDG-2026-GRAPH-005','qa_date','2026-08-13')::text,'sha256'),'hex'),
    'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
  from app.content_review_assignments cra
  where cra.content_item_version_id=v_version_id and cra.assignment_purpose='owner_remediation_approval' and cra.status='pending';

  update app.content_item_versions set review_status='question_review_approved', status='published', published_at=now(), updated_at=now() where id=v_version_id;
  update app.content_items set status='published', updated_at=now() where id=v_item.id;
end $$;

do $$
declare n integer;
begin
  select count(*) into n from app.content_item_versions where status='published' and review_status in ('excluded','modification_reserved');
  if n<>0 then raise exception 'P0-B net check non-zero after single-reviewer publish: %', n; end if;

  select count(*) into n from app.content_items ci
    join app.content_item_versions v on v.id=(select id from app.content_item_versions v2 where v2.content_item_id=ci.id order by v2.version_num desc limit 1)
    where ci.status='reviewed_approved' and v.review_status not in ('question_review_approved','mcq_answer_review_complete');
  if n<>0 then raise exception 'items remain stuck below terminal review_status after single-reviewer publish: %', n; end if;
end $$;

select ci.content_key, ci.status, v.status as version_status, v.review_status
from app.content_items ci
join app.content_item_versions v on v.id=(select id from app.content_item_versions v2 where v2.content_item_id=ci.id order by v2.version_num desc limit 1)
where ci.content_key='APSTATS-HDG-2026-GRAPH-005';

commit;
