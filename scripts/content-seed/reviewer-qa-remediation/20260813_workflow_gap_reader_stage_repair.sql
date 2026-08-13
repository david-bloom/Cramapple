-- Workflow-gap remediation, 2026-08-13.
--
-- Root cause (fixed in code: supabase/functions/review-decision/index.ts):
-- tutor_question aggregate=2 (both tutors approved) used to look up an
-- AP-reader profile and create a reader_question assignment before setting
-- review_status='ap_reader_pending'. No reader role has ever been staffed in
-- Production, so the assignment was silently never created, and
-- 'ap_reader_pending' has no code path anywhere that ever advances it --
-- every item that reached this branch was permanently stuck below the P0-B
-- publish gate's allowlist. The difficulty-label-disagreement branch had the
-- identical dead-end shape ('difficulty_discussion'). Owner-directed
-- (2026-08-13): this operation does not use an AP-reader role, and difficulty
-- disagreements should not block publish ("when in doubt, use the harder
-- level of difficulty"). Fixed the code to go straight to the terminal
-- review_status in both cases; this script repairs the 17 items already
-- stuck under the old behavior.
--
-- Separately found and fixed: 13 of these items also had their
-- content_item_versions.status stuck at 'retired' (item-level status
-- correctly said reviewed_approved, but the version row itself did not --
-- same stale-version-status pattern found and fixed for other items earlier
-- this session), and 13 were missing practice_format, blocking publish via
-- unrelated triggers once the review_status blocker was cleared.
--
-- 16 items: aggregate=2 was already correctly computed by the (buggy) code;
-- advancing straight to the terminal review_status these already-valid
-- approvals earned, then publishing. No content changes.
--
-- 1 item (APBIO-FRQ-S-031): never advanced past the initial
-- 'tutor_review_pending' value at all (a stray 3rd tutor assignment in a
-- malformed blind group broke the exactly-2 assumption for its real pair).
-- Its real tutor outcome was Sarah (approve) + Adil (approve_with_edits) =
-- aggregate 3, mislabeled reviewed_approved by whatever ad hoc process set
-- that item-level status (no application code has ever set
-- content_items.status='reviewed_approved' -- confirmed by repo-wide grep).
-- Adil's stated concern ("only FRQ with no stimulus at all") does not
-- reproduce against current content: the item has a complete, well-formed
-- stimulus, and the membrane-fluidity biology was independently re-derived
-- and confirmed correct. Owner-adjudicated approval.
--
-- NOT touched: APSTATS-HDG-2026-GRAPH-005, the other tutor_review_pending
-- item -- genuinely has only one assigned tutor (Jill Schmidlkofer), never
-- paired with a second reviewer. Left for an owner decision (assign a second
-- reviewer, or accept single-reviewer approval) rather than forced through.

begin;
select pg_advisory_xact_lock(hashtext('cramapple-workflow-gap-remediation-20260813'));

-- Stale version-status corrections (13 items: 12 ap_reader_pending/
-- difficulty_discussion FRQs + APBIO-FRQ-S-031).
update app.content_item_versions v
set status='reviewed_approved', updated_at=now()
from app.content_items ci
where v.content_item_id=ci.id
  and ci.content_key in (
    'APBIO-FRQ-S-003','APBIO-FRQ-S-045','APBIO-FRQ-S-062','APBIO-FRQ-S-073',
    'APBIO-FRQ-S-074','APBIO-FRQ-S-085','APBIO-FRQ-S-006','APBIO-FRQ-S-007',
    'APBIO-FRQ-S-029','APBIO-FRQ-S-076','APBIO-FRQ-S-094','APBIO-FRQ-S-099',
    'APBIO-FRQ-S-031'
  )
  and ci.status='reviewed_approved'
  and v.status='retired'
  and v.id=(select id from app.content_item_versions v2 where v2.content_item_id=ci.id order by v2.version_num desc limit 1);

-- practice_format backfill (13 items: same set, all had frq_archetype IS NULL
-- too -- identical case to every prior practice_format fix this session).
update app.content_items
set practice_format='targeted_drill', updated_at=now()
where content_key in (
    'APBIO-FRQ-S-003','APBIO-FRQ-S-045','APBIO-FRQ-S-062','APBIO-FRQ-S-073',
    'APBIO-FRQ-S-074','APBIO-FRQ-S-085','APBIO-FRQ-S-006','APBIO-FRQ-S-007',
    'APBIO-FRQ-S-029','APBIO-FRQ-S-076','APBIO-FRQ-S-094','APBIO-FRQ-S-099',
    'APBIO-FRQ-S-031'
  )
  and practice_format is null and frq_archetype is null;

-- 16-item advance: aggregate=2 already validated, dead-ended at the reader
-- stage. Go straight to the terminal review_status and publish.
create temporary table advance_targets (
  content_key text primary key,
  item_type text not null
) on commit drop;

insert into advance_targets values
('APBIO-FRQ-S-003','frq'),('APBIO-FRQ-S-045','frq'),('APBIO-FRQ-S-062','frq'),
('APBIO-FRQ-S-073','frq'),('APBIO-FRQ-S-074','frq'),('APBIO-FRQ-S-085','frq'),
('apcalcab-mcq-010','mcq'),
('APBIO-FRQ-S-006','frq'),('APBIO-FRQ-S-007','frq'),('APBIO-FRQ-S-029','frq'),
('APBIO-FRQ-S-076','frq'),('APBIO-FRQ-S-094','frq'),('APBIO-FRQ-S-099','frq'),
('apcalcab-mcq-009','mcq'),('apcalcab-mcq-011','mcq'),('apcalcab-mcq-017','mcq');

create temporary table advanced (
  content_key text primary key,
  version_id uuid not null
) on commit drop;

insert into advanced
select ci.content_key, v.id
from advance_targets t
join app.content_items ci on ci.content_key=t.content_key and ci.item_type=t.item_type
join app.content_item_versions v on v.id=(select id from app.content_item_versions v2 where v2.content_item_id=ci.id order by v2.version_num desc limit 1)
where ci.status='reviewed_approved' and v.status='reviewed_approved' and v.review_status in ('ap_reader_pending','difficulty_discussion');

update app.content_item_versions civ
set review_status = case (select item_type from advance_targets t where t.content_key=(select content_key from advanced a where a.version_id=civ.id))
      when 'mcq' then 'mcq_answer_review_complete' else 'question_review_approved' end,
    status='published', published_at=coalesce(civ.published_at, now()), updated_at=now()
from advanced a where civ.id=a.version_id;

update app.content_items ci
set status='published', updated_at=now()
from advanced a where ci.content_key=a.content_key;

-- APBIO-FRQ-S-031: owner-adjudicated approval (see header note).
do $$
declare v_item app.content_items%rowtype; v_version_id uuid;
begin
  select * into strict v_item from app.content_items where content_key='APBIO-FRQ-S-031' and item_type='frq';
  select id into strict v_version_id from app.content_item_versions where content_item_id=v_item.id order by version_num desc limit 1;

  insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
  values (gen_random_uuid(), v_version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 'frq', 'pending', 'owner_remediation_approval', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid);

  insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, tutor_decision, decision_payload, decision_hash, created_by)
  select cra.content_review_assignment_id, v_version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 1, 'Medium', false, array[]::text[],
    'Owner adjudication, 2026-08-13: real tutor outcome (Sarah approve + Adil approve_with_edits, aggregate 3) never advanced past tutor_review_pending -- mislabeled reviewed_approved by an ad hoc process. Adil''s concern ("only FRQ with no stimulus at all") does not reproduce: item has a complete stimulus and independently-verified-correct membrane fluidity content. Approving.',
    'approve',
    jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','workflow_gap_adjudication','content_key','APBIO-FRQ-S-031','qa_date','2026-08-13'),
    encode(extensions.digest(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','workflow_gap_adjudication','content_key','APBIO-FRQ-S-031','qa_date','2026-08-13')::text,'sha256'),'hex'),
    'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
  from app.content_review_assignments cra
  where cra.content_item_version_id=v_version_id and cra.assignment_purpose='owner_remediation_approval' and cra.status='pending';

  update app.content_item_versions set review_status='question_review_approved', status='published', published_at=now(), updated_at=now() where id=v_version_id;
  update app.content_items set status='published', updated_at=now() where id=v_item.id;
end $$;

do $$
declare n integer;
begin
  select count(*) into n from advanced;
  if n<>16 then raise exception 'expected 16 advanced items, got %', n; end if;

  select count(*) into n from app.content_item_versions where status='published' and review_status in ('excluded','modification_reserved');
  if n<>0 then raise exception 'P0-B net check non-zero after workflow-gap repair: %', n; end if;

  select count(*) into n from (
    select content_item_id from app.content_item_versions where status='published' group by content_item_id having count(*)>1
  ) d;
  if n<>0 then raise exception 'duplicate published versions after workflow-gap repair: %', n; end if;
end $$;

select 'advanced_and_published' metric, count(*)::text value from advanced
union all select 'apbio_frq_s031_published', (select status from app.content_items where content_key='APBIO-FRQ-S-031')
union all select 'p0b_net_after', (select count(*) from app.content_item_versions where status='published' and review_status in ('excluded','modification_reserved'))::text
union all select 'remaining_single_reviewer_stall_not_touched', 'APSTATS-HDG-2026-GRAPH-005 (needs a second reviewer or owner decision)';

commit;
