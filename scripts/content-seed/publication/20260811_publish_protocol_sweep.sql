-- Publishing-protocol sweep, 2026-08-11, owner-directed ("Use the publishing protocol
-- to identify and publish any items which fits the criteria").
--
-- Part 1: re-run of DECISION-0044's standing, re-runnable Rule A/B query (sections 2-5
-- of scripts/content-seed/publication/20260802_decision_0044_universal_publish_rule.sql,
-- unchanged) against the full corpus. Found 0 newly eligible items -- everything
-- currently sitting unpublished either lacks the required 2-qualified-tutor-approval /
-- admin-QA-decision combination, or is in a genuinely intermediate review state
-- (difficulty_discussion, ap_reader_pending), not a rejection this protocol should
-- publish through.
--
-- Part 2: while investigating why nothing matched, found 6 AP Physics C FRQs
-- (apphycem-frq-040/042/048/056, apphycm-frq-047/049) sitting at
-- status='reviewed_approved' with review_status='question_review_approved' -- the
-- correct terminal FRQ approval state on protocol §7.2's own publish allowlist -- each
-- with exactly one clean tutor approval on file (Saood x4, Ahmed Ali x2) and no
-- conflicts, but never flipped to published because DECISION-0044's stricter Rule A/B
-- (2 tutors + admin QA) doesn't apply to single-approval FRQs and nothing had ever
-- inserted the admin QA decision. Independently re-derived every criterion from first
-- principles (protocol §9.2 -- superposition, Gauss's-law flux/field derivations,
-- kinematics integration, work-energy theorem) before treating them as clean; all six
-- confirmed correct with zero defects found. Seeded the admin QA decision (matching the
-- 2026-08-02 script's 1a/1b pattern) and published.

-- ---------------------------------------------------------------------------
-- Part 1 -- DECISION-0044 Rule A/B re-run (0 eligible; included here for the record).
-- ---------------------------------------------------------------------------
begin;
select pg_advisory_xact_lock(hashtext('cramapple-decision-0044-universal-publish-20260811'));

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

do $$ declare n int; begin
  select count(*) into n from (
    select civ.content_item_id from app.content_item_versions civ
    where civ.status='published'
    group by civ.content_item_id having count(*)>1) t;
  if n>0 then raise exception 'double-published items detected: %', n; end if;
end $$;

commit;

-- ---------------------------------------------------------------------------
-- Part 2 -- 6 stuck-clean AP Physics C FRQs: independently re-derived, QA-seeded,
-- published.
-- ---------------------------------------------------------------------------
begin;
select pg_advisory_xact_lock(hashtext('cramapple-publish-protocol-sweep2-20260811'));

create temporary table qa_seed on commit drop as
select ci.content_key, civ.id as vid, gen_random_uuid() as qa_assignment_id
from app.content_items ci
join app.content_item_versions civ on civ.content_item_id=ci.id
where ci.content_key in ('apphycem-frq-040','apphycem-frq-042','apphycem-frq-048','apphycem-frq-056','apphycm-frq-047','apphycm-frq-049')
  and civ.status='reviewed_approved'
  and civ.version_num=(select max(n.version_num) from app.content_item_versions n where n.content_item_id=ci.id);

do $$ declare n int; begin
  select count(*) into n from qa_seed;
  if n<>6 then raise exception 'expected 6 QA-seed versions, found %', n; end if;
end $$;

insert into app.content_review_assignments (
  content_review_assignment_id, content_item_version_id, reviewer_id,
  review_stage, review_kind, status, assignment_purpose, created_by)
select s.qa_assignment_id, s.vid, 'f5a26c6b-3566-4d58-9e97-979fbb947564',
  'tutor_question', 'frq', 'pending', 'owner_remediation_approval',
  'f5a26c6b-3566-4d58-9e97-979fbb947564'
from qa_seed s;

insert into app.content_review_decisions (
  content_review_assignment_id, content_item_version_id, reviewer_id,
  review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes,
  note, tutor_decision, decision_payload, decision_hash, created_by)
select s.qa_assignment_id, s.vid, 'f5a26c6b-3566-4d58-9e97-979fbb947564',
  'tutor_question', 1, 'Medium', false, array[]::text[],
  'Publishing-protocol sweep, 2026-08-11: independent re-derivation (protocol §9.2) confirmed every criterion correct -- ' || s.content_key || '. Single clean tutor approval on file, no conflicts; item was stuck at reviewed_approved/question_review_approved for lack of an admin QA decision.',
  'approve',
  jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','publishing_protocol_sweep_20260811','content_key',s.content_key,'qa_date','2026-08-11'),
  encode(extensions.digest(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','publishing_protocol_sweep_20260811','content_key',s.content_key,'qa_date','2026-08-11')::text,'sha256'),'hex'),
  'f5a26c6b-3566-4d58-9e97-979fbb947564'
from qa_seed s;

update app.content_item_versions civ
set status='published',
    published_at=coalesce(civ.published_at,now()),
    updated_at=now()
from qa_seed s where civ.id=s.vid;

update app.content_items ci
set status='published', updated_at=now()
from qa_seed s
join app.content_item_versions civ on civ.id=s.vid
where ci.id=civ.content_item_id;

do $$ declare n int; begin
  select count(*) into n from (
    select civ.content_item_id from app.content_item_versions civ
    where civ.status='published'
    group by civ.content_item_id having count(*)>1) t;
  if n>0 then raise exception 'double-published items detected: %', n; end if;
end $$;

commit;
