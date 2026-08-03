-- DECISION-0044 — Universal publication rule (owner-directed, 2026-08-02).
--
-- An item's latest active version is published when EITHER:
--   Rule A: it holds approvals from >=2 distinct, real, actively qualified
--     tutors, no conflicting tutor decision, AND an AI QA approval recorded
--     as an admin-profile decision on that same version; OR
--   Rule B: a tutor filed approve_with_edits on a predecessor (or the item's
--     review history), the fix was authored by AI (admin-created successor
--     version), the fix version carries no tutor non-approval, and an AI QA
--     approval is recorded on the fix version.
-- Both rules also require the structural gates from the 2026-07-30 release
-- (4 distinct MCQ choices / exactly one key matching canonical_answer_1 when
-- populated; FRQ criteria present with positive points; stimulus asset
-- present; no competing published version). Failing items are skipped and
-- reported, not silently dropped.
--
-- Sections 1a/1b seed the AI QA decisions from the 2026-08-02 QA session
-- (each listed version was independently re-derived by hand in that session —
-- see docs/research/REVIEWER_QA_GULGELDI_2026_08_02.md and the activity log).
-- Sections 2-3 are the standing, re-runnable implementation of the rule.

begin;
select pg_advisory_xact_lock(hashtext('cramapple-decision-0044-universal-publish-20260802'));

-- ---------------------------------------------------------------------------
-- 1a. Seed AI QA approvals: Rule A candidates verified 2026-08-02.
-- ---------------------------------------------------------------------------
create temporary table ai_qa_seed on commit drop as
select ci.content_key, civ.id as vid, ci.item_type,
       gen_random_uuid() as qa_assignment_id,
       'two_qualified_tutor_approvals_plus_ai_qa'::text as basis
from app.content_items ci
join app.content_item_versions civ on civ.content_item_id=ci.id
where ci.content_key in (
  'apchem-mcq-004','apchem-mcq-009','apchem-mcq-010','apchem-mcq-013',
  'apchem-mcq-015','apchem-mcq-016','apchem-mcq-045','apchem-mcq-047',
  'apchem-mcq-048','apchem-mcq-054','apchem-mcq-064',
  'apchem-sfrq-028','apchem-sfrq-029',
  'APSTATS-MCQ-006-CAL','APSTATS-MCQ-009-CAL','APSTATS-MCQ-019',
  'APSTATS-MCQ-022','APSTATS-MCQ-026','APSTATS-MCQ-032')
  and civ.status not in ('retired','published')
  and civ.version_num=(select max(n.version_num) from app.content_item_versions n
                       where n.content_item_id=ci.id)
  and not exists (select 1 from app.content_review_decisions d
      join app.profiles p on p.user_id=d.reviewer_id and p.role='admin'
      where d.content_item_version_id=civ.id);

-- 1b. Seed AI QA approvals on clean AI-fix versions (Rule B) lacking one:
--     the eight 2026-07-31 Precalculus distractor-rationale repairs (verified
--     in that sweep) and the two 2026-08-02 Chemistry edit-application fixes.
insert into ai_qa_seed (content_key, vid, item_type, qa_assignment_id, basis)
select ci.content_key, civ.id, ci.item_type, gen_random_uuid(),
       'approve_with_edits_fixed_by_ai_plus_ai_qa'
from app.content_items ci
join app.content_item_versions civ on civ.content_item_id=ci.id
where ci.content_key in (
  'apprecalc-mcq-001','apprecalc-mcq-006','apprecalc-mcq-009',
  'apprecalc-mcq-011','apprecalc-mcq-012','apprecalc-mcq-015',
  'apprecalc-mcq-016','apprecalc-mcq-019',
  'apchem-sfrq-008','apchem-sfrq-018')
  and civ.status not in ('retired','published')
  and civ.created_by='f5a26c6b-3566-4d58-9e97-979fbb947564'
  and civ.version_num=(select max(n.version_num) from app.content_item_versions n
                       where n.content_item_id=ci.id)
  and not exists (select 1 from app.content_review_decisions d
      join app.profiles p on p.user_id=d.reviewer_id and p.role='admin'
      where d.content_item_version_id=civ.id);

do $$ declare n int; begin
  select count(*) into n from ai_qa_seed;
  if n <> 29 then raise exception 'AI QA seed expected 29 versions, found %', n; end if;
end $$;

insert into app.content_review_assignments (
  content_review_assignment_id, content_item_version_id, reviewer_id,
  review_stage, review_kind, status, assignment_purpose, created_by)
select s.qa_assignment_id, s.vid, 'f5a26c6b-3566-4d58-9e97-979fbb947564',
  'tutor_question', s.item_type, 'pending', 'owner_remediation_approval',
  'f5a26c6b-3566-4d58-9e97-979fbb947564'
from ai_qa_seed s;

with payloads as (
  select s.*, jsonb_build_object(
    'review_stage','tutor_question',
    'tutor_score',1,
    'tutor_decision','approve',
    'approval_basis',s.basis,
    'qa_date','2026-08-02',
    'decision_ref','DECISION-0044',
    'qa_checks',jsonb_build_array(
      'complete_content_and_assets',
      'mathematical_or_scientific_correctness',
      'answer_or_rubric_alignment',
      'ap_exam_relevance')) as payload
  from ai_qa_seed s)
insert into app.content_review_decisions (
  content_review_assignment_id, content_item_version_id, reviewer_id,
  review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes,
  note, tutor_decision, decision_payload, decision_hash, created_by)
select p.qa_assignment_id, p.vid, 'f5a26c6b-3566-4d58-9e97-979fbb947564',
  'tutor_question', 1,
  coalesce((select d.difficulty_label from app.content_review_decisions d
            where d.content_item_version_id=p.vid and d.difficulty_label is not null
            order by d.submitted_at desc limit 1),'Medium'),
  false, array[]::text[],
  case p.basis
    when 'two_qualified_tutor_approvals_plus_ai_qa'
      then 'Independent AI QA passed (2026-08-02 session, hand re-derived) after two qualified tutors agreed on approval. DECISION-0044.'
    else 'AI-applied fix for tutor approve_with_edits requests; fix independently verified. DECISION-0044.'
  end,
  'approve', p.payload,
  encode(extensions.digest(p.payload::text,'sha256'),'hex'),
  'f5a26c6b-3566-4d58-9e97-979fbb947564'
from payloads p;

-- ---------------------------------------------------------------------------
-- 2. Rule A: two qualified tutor approvals + AI QA, no conflicts.
-- ---------------------------------------------------------------------------
create temporary table publish_set (
  vid uuid primary key, content_key text, rule text);

insert into publish_set (vid, content_key, rule)
select civ.id, ci.content_key, 'A'
from app.content_item_versions civ
join app.content_items ci on ci.id=civ.content_item_id
join app.exam_pack_versions epv on epv.id=ci.exam_pack_version_id
where civ.status not in ('retired','published')
  and civ.version_num=(select max(n.version_num) from app.content_item_versions n
                       where n.content_item_id=civ.content_item_id)
  and not exists (select 1 from app.content_item_versions o
      where o.content_item_id=civ.content_item_id and o.id<>civ.id and o.status='published')
  and (select count(distinct d.reviewer_id)
       from app.content_review_decisions d
       join app.content_review_assignments a
         on a.content_review_assignment_id=d.content_review_assignment_id
        and a.assignment_purpose='subject_review'
       join app.profiles p on p.user_id=d.reviewer_id and p.role='tutor'
       join auth.users u on u.id=d.reviewer_id
        and lower(u.email) not like '%@cramapple-test.internal'
       where d.content_item_version_id=civ.id
         and d.review_stage='tutor_question'
         and coalesce(d.tutor_score=1 or d.tutor_decision='approve',false)
         and not exists (select 1 from app.content_review_decisions nn
                         where nn.supersedes_id=d.content_review_decision_id)
         and exists (select 1 from app.validator_qualifications q
             where q.reviewer_id=d.reviewer_id and q.status='active'
               and q.effective_at<=now()
               and (q.expires_at is null or q.expires_at>now())
               and epv.exam_pack_id=any(q.exam_ids))) >= 2
  and not exists (select 1
       from app.content_review_decisions d
       join app.profiles p on p.user_id=d.reviewer_id and p.role='tutor'
       join auth.users u on u.id=d.reviewer_id
        and lower(u.email) not like '%@cramapple-test.internal'
       where d.content_item_version_id=civ.id
         and d.review_stage='tutor_question'
         and not coalesce(d.tutor_score=1 or d.tutor_decision='approve',false)
         and not exists (select 1 from app.content_review_decisions nn
                         where nn.supersedes_id=d.content_review_decision_id)
         and exists (select 1 from app.validator_qualifications q
             where q.reviewer_id=d.reviewer_id and q.status='active'
               and q.effective_at<=now()
               and (q.expires_at is null or q.expires_at>now())
               and epv.exam_pack_id=any(q.exam_ids)))
  and exists (select 1 from app.content_review_decisions d
       join app.profiles p on p.user_id=d.reviewer_id and p.role='admin'
       where d.content_item_version_id=civ.id and d.tutor_decision='approve')
  and not exists (select 1 from app.content_review_decisions d
       join app.profiles p on p.user_id=d.reviewer_id and p.role='admin'
       where d.content_item_version_id=civ.id and d.tutor_decision='disapprove');

-- ---------------------------------------------------------------------------
-- 3. Rule B: approve_with_edits + AI fix, clean fix version, AI QA on fix.
-- ---------------------------------------------------------------------------
insert into publish_set (vid, content_key, rule)
select civ.id, ci.content_key, 'B'
from app.content_item_versions civ
join app.content_items ci on ci.id=civ.content_item_id
where civ.status not in ('retired','published')
  and civ.created_by='f5a26c6b-3566-4d58-9e97-979fbb947564'
  and civ.version_num>=2
  and civ.version_num=(select max(n.version_num) from app.content_item_versions n
                       where n.content_item_id=civ.content_item_id)
  and not exists (select 1 from app.content_item_versions o
      where o.content_item_id=civ.content_item_id and o.id<>civ.id and o.status='published')
  and exists (select 1 from app.content_review_decisions d
      join app.content_item_versions dv on dv.id=d.content_item_version_id
      join app.profiles p on p.user_id=d.reviewer_id and p.role='tutor'
      join auth.users u on u.id=d.reviewer_id
       and lower(u.email) not like '%@cramapple-test.internal'
      where dv.content_item_id=civ.content_item_id and dv.id<>civ.id
        and d.tutor_decision='approve_with_edits')
  and not exists (select 1 from app.content_review_decisions d
      join app.profiles p on p.user_id=d.reviewer_id and p.role='tutor'
      where d.content_item_version_id=civ.id
        and not coalesce(d.tutor_score=1 or d.tutor_decision='approve',false))
  and exists (select 1 from app.content_review_decisions d
      join app.profiles p on p.user_id=d.reviewer_id and p.role='admin'
      where d.content_item_version_id=civ.id and d.tutor_decision='approve')
  and not exists (select 1 from app.content_review_decisions d
      join app.profiles p on p.user_id=d.reviewer_id and p.role='admin'
      where d.content_item_version_id=civ.id and d.tutor_decision='disapprove')
on conflict (vid) do nothing;

-- ---------------------------------------------------------------------------
-- 4. Structural gates: filter failures out with a report.
-- ---------------------------------------------------------------------------
create temporary table blocked as
select ps.content_key, ps.rule,
  case
    when nullif(trim(civ.stem),'') is null then 'blank stem'
    when ci.item_type='mcq' and (
      (select count(*) from app.mcq_choices c where c.content_item_version_id=civ.id)<>4
      or (select count(distinct lower(trim(c.choice_text))) from app.mcq_choices c
          where c.content_item_version_id=civ.id)<>4
      or (select count(*) from app.mcq_choices c
          where c.content_item_version_id=civ.id and c.is_correct)<>1
      -- canonical_answer_1 is optional metadata (null on 80 of 118 already-published
      -- MCQs; mcq_choices.is_correct is the serving source of truth). Enforce the
      -- match only when it is populated.
      or (civ.canonical_answer_1 is not null
          and not coalesce((select bool_or(lower(trim(c.choice_key))=lower(trim(civ.canonical_answer_1)))
              from app.mcq_choices c where c.content_item_version_id=civ.id and c.is_correct),false)))
      then 'mcq structure/key gate'
    when ci.item_type='frq' and (
      (select count(*) from app.frq_criteria f where f.content_item_version_id=civ.id)=0
      or coalesce((select sum(f.points_possible) from app.frq_criteria f
          where f.content_item_version_id=civ.id),0)<=0)
      then 'frq rubric gate'
    when civ.stimulus_image_path is not null and not exists
      (select 1 from storage.objects o where o.name=civ.stimulus_image_path)
      then 'missing stimulus asset'
  end as reason
from publish_set ps
join app.content_item_versions civ on civ.id=ps.vid
join app.content_items ci on ci.id=civ.content_item_id;

delete from blocked where reason is null;
delete from publish_set where content_key in (select content_key from blocked);

-- ---------------------------------------------------------------------------
-- 5. Publish. `status` must pass through 'reviewed_approved' before
--    'published' (enforced by trigger tg_content_pipeline_guard_publish) —
--    two separate updates, not a bypass of that gate.
-- ---------------------------------------------------------------------------
update app.content_item_versions civ
set status='reviewed_approved', updated_at=now()
from publish_set ps
where civ.id=ps.vid and civ.status<>'reviewed_approved';

update app.content_item_versions civ
set status='published',
    review_status='question_review_approved',
    approved_at=coalesce(civ.approved_at,now()),
    approved_by=coalesce(civ.approved_by,'f5a26c6b-3566-4d58-9e97-979fbb947564'),
    published_at=coalesce(civ.published_at,now()),
    updated_at=now()
from publish_set ps where civ.id=ps.vid;

update app.content_items ci
set status='published', updated_at=now()
from publish_set ps
join app.content_item_versions civ on civ.id=ps.vid
where ci.id=civ.content_item_id;

-- No item may end up with two published versions.
do $$ declare n int; begin
  select count(*) into n from (
    select civ.content_item_id from app.content_item_versions civ
    where civ.status='published'
    group by civ.content_item_id having count(*)>1) t;
  if n>0 then raise exception 'double-published items detected: %', n; end if;
end $$;

commit;

select rule, count(*) as published, string_agg(content_key,', ' order by content_key) as keys
from publish_set group by rule
union all
select 'BLOCKED('||coalesce(reason,'?')||')', count(*), string_agg(content_key,', ' order by content_key)
from blocked group by reason;
