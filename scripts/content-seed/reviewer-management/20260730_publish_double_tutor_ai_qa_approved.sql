-- Publish current content versions that have:
--   1. approvals from at least two distinct, real, actively qualified tutors;
--   2. no conflicting decision from a real, actively qualified tutor; and
--   3. an independent AI QA pass for completeness, correctness, answer/rubric
--      alignment, AP relevance, and required-asset availability.
--
-- The release set was independently inspected before this transaction. The
-- explicit IDs make the release reproducible; the assertions below prevent a
-- stale or newly-conflicted version from being published.

begin;

select pg_advisory_xact_lock(hashtext('20260730_publish_double_tutor_ai_qa_approved'));

create temp table qa_release (
  content_item_version_id uuid primary key,
  qa_assignment_id uuid not null default gen_random_uuid()
) on commit drop;

insert into qa_release (content_item_version_id) values
  ('de59d53c-1f80-4b1a-9694-10d9e50dcad0'),
  ('d83f1bbd-6875-4de6-bbe1-c3287551f030'),
  ('0d1f0407-90fa-448d-9ef0-617ca7a857f4'),
  ('24e1b672-8130-4e68-9ecf-0fa9875bfffb'),
  ('926d74a3-728c-4d70-988c-2badf0b4884f'),
  ('c7e38946-d45b-42e6-8c58-919e9bfce4a5'),
  ('220a3baa-2b1d-481a-9670-db5038c7c291'),
  ('f6925ed6-4935-4a38-aaef-c100c8c22240'),
  ('0c9fdac3-6787-4bd4-b302-abed1a982ab1'),
  ('099337a6-966a-4ef1-b931-a0a5a8df67bf'),
  ('0d08ffbf-c83b-45a4-98a8-f97f3246660c'),
  ('190d1f49-0544-42fa-ba0d-0b9da1def765'),
  ('6d969ff3-9cc5-499d-bb33-c6a5d01d76a3'),
  ('84e2a207-ae56-4351-9186-1549aff27762');

do $$
declare
  v_bad text;
begin
  select string_agg(civ.content_key, ', ' order by civ.content_key)
  into v_bad
  from qa_release r
  join public.content_item_versions civ on civ.id = r.content_item_version_id
  where civ.status in ('published', 'retired')
     or civ.version_num <> (
       select max(newer.version_num)
       from app.content_item_versions newer
       where newer.content_item_id = civ.content_item_id
     )
     or exists (
       select 1
       from app.content_item_versions other
       where other.content_item_id = civ.content_item_id
         and other.id <> civ.id
         and other.status = 'published'
     )
     or nullif(trim(civ.stem), '') is null
     or (
       civ.item_type = 'mcq'
       and (
         (select count(*) from app.mcq_choices c
          where c.content_item_version_id = civ.id) <> 4
         or
         (select count(distinct lower(trim(c.choice_text)))
          from app.mcq_choices c
          where c.content_item_version_id = civ.id) <> 4
         or
         (select count(*) from app.mcq_choices c
          where c.content_item_version_id = civ.id and c.is_correct) <> 1
         or not coalesce((
           select bool_or(
             lower(trim(c.choice_key)) = lower(trim(civ.canonical_answer_1))
           )
           from app.mcq_choices c
           where c.content_item_version_id = civ.id and c.is_correct
         ), false)
       )
     )
     or (
       civ.item_type = 'frq'
       and (
         (select count(*) from app.frq_criteria f
          where f.content_item_version_id = civ.id) = 0
         or
         coalesce((
           select sum(f.points_possible)
           from app.frq_criteria f
           where f.content_item_version_id = civ.id
         ), 0) <= 0
       )
     )
     or (
       civ.stimulus_image_path is not null
       and not exists (
         select 1
         from storage.objects o
         where o.name = civ.stimulus_image_path
       )
     );

  if v_bad is not null then
    raise exception 'release structural/version gate failed for: %', v_bad;
  end if;
end
$$;

do $$
declare
  v_bad text;
begin
  with leaf_decisions as (
    select d.*
    from app.content_review_decisions d
    where d.review_stage = 'tutor_question'
      and not exists (
        select 1
        from app.content_review_decisions newer
        where newer.supersedes_id = d.content_review_decision_id
      )
  ),
  qualified_real_decisions as (
    select
      r.content_item_version_id,
      d.reviewer_id,
      coalesce(d.tutor_score = 1 or d.tutor_decision = 'approve', false)
        as is_approval
    from qa_release r
    join public.content_item_versions civ
      on civ.id = r.content_item_version_id
    join leaf_decisions d
      on d.content_item_version_id = r.content_item_version_id
    join app.content_review_assignments a
      on a.content_review_assignment_id = d.content_review_assignment_id
     and a.assignment_purpose = 'subject_review'
    join app.profiles p
      on p.user_id = d.reviewer_id
     and p.role = 'tutor'
    join auth.users u
      on u.id = d.reviewer_id
     and lower(u.email) not like '%@cramapple-test.internal'
    where exists (
      select 1
      from app.validator_qualifications q
      where q.reviewer_id = d.reviewer_id
        and q.status = 'active'
        and q.effective_at <= now()
        and (q.expires_at is null or q.expires_at > now())
        and civ.exam_pack_id = any(q.exam_ids)
    )
  ),
  decision_gate as (
    select
      r.content_item_version_id,
      count(distinct q.reviewer_id) filter (where q.is_approval) as approvals,
      count(distinct q.reviewer_id) filter (where not q.is_approval) as conflicts
    from qa_release r
    left join qualified_real_decisions q
      on q.content_item_version_id = r.content_item_version_id
    group by r.content_item_version_id
  )
  select string_agg(civ.content_key, ', ' order by civ.content_key)
  into v_bad
  from decision_gate g
  join public.content_item_versions civ on civ.id = g.content_item_version_id
  where g.approvals < 2 or g.conflicts > 0;

  if v_bad is not null then
    raise exception 'two-qualified-tutor agreement gate failed for: %', v_bad;
  end if;
end
$$;

insert into app.content_review_assignments (
  content_review_assignment_id,
  content_item_version_id,
  reviewer_id,
  review_stage,
  review_kind,
  status,
  assignment_purpose,
  created_by
)
select
  r.qa_assignment_id,
  r.content_item_version_id,
  'f5a26c6b-3566-4d58-9e97-979fbb947564',
  'tutor_question',
  civ.item_type,
  'pending',
  'owner_remediation_approval',
  'f5a26c6b-3566-4d58-9e97-979fbb947564'
from qa_release r
join public.content_item_versions civ on civ.id = r.content_item_version_id;

with qa_payloads as (
  select
    r.qa_assignment_id,
    r.content_item_version_id,
    jsonb_build_object(
      'review_stage', 'tutor_question',
      'tutor_score', 1,
      'tutor_decision', 'approve',
      'approval_basis', 'two_qualified_tutor_approvals_plus_ai_qa',
      'qa_date', '2026-07-30',
      'qa_checks', jsonb_build_array(
        'complete_content_and_assets',
        'mathematical_or_scientific_correctness',
        'answer_or_rubric_alignment',
        'ap_exam_relevance',
        'two_distinct_qualified_tutor_approvals',
        'no_qualified_tutor_conflict'
      ),
      'source_review_decision_ids', (
        select jsonb_agg(d.content_review_decision_id order by d.submitted_at)
        from app.content_review_decisions d
        join app.content_review_assignments a
          on a.content_review_assignment_id = d.content_review_assignment_id
         and a.assignment_purpose = 'subject_review'
        join app.profiles p
          on p.user_id = d.reviewer_id
         and p.role = 'tutor'
        join auth.users u
          on u.id = d.reviewer_id
         and lower(u.email) not like '%@cramapple-test.internal'
        where d.content_item_version_id = r.content_item_version_id
          and d.review_stage = 'tutor_question'
          and coalesce(d.tutor_score = 1 or d.tutor_decision = 'approve', false)
          and not exists (
            select 1
            from app.content_review_decisions newer
            where newer.supersedes_id = d.content_review_decision_id
          )
      )
    ) as payload
  from qa_release r
)
insert into app.content_review_decisions (
  content_review_assignment_id,
  content_item_version_id,
  reviewer_id,
  review_stage,
  tutor_score,
  difficulty_label,
  diagnostic_flag,
  concern_codes,
  note,
  tutor_decision,
  decision_payload,
  decision_hash,
  created_by
)
select
  p.qa_assignment_id,
  p.content_item_version_id,
  'f5a26c6b-3566-4d58-9e97-979fbb947564',
  'tutor_question',
  1,
  coalesce((
    select d.difficulty_label
    from app.content_review_decisions d
    where d.content_item_version_id = p.content_item_version_id
      and d.difficulty_label is not null
    order by d.submitted_at desc
    limit 1
  ), 'Medium'),
  false,
  array[]::text[],
  'Independent AI QA passed after two qualified tutors agreed on approval.',
  'approve',
  p.payload,
  encode(extensions.digest(p.payload::text, 'sha256'), 'hex'),
  'f5a26c6b-3566-4d58-9e97-979fbb947564'
from qa_payloads p;

update app.content_item_versions civ
set
  status = 'published',
  review_status = 'question_review_approved',
  approved_at = coalesce(civ.approved_at, now()),
  approved_by = coalesce(
    civ.approved_by,
    'f5a26c6b-3566-4d58-9e97-979fbb947564'
  ),
  published_at = coalesce(civ.published_at, now()),
  updated_at = now()
from qa_release r
where civ.id = r.content_item_version_id;

update app.content_items ci
set status = 'published', updated_at = now()
from qa_release r
join app.content_item_versions civ
  on civ.id = r.content_item_version_id
where ci.id = civ.content_item_id;

do $$
declare
  v_count integer;
begin
  select count(*)
  into v_count
  from qa_release r
  join app.content_item_versions civ on civ.id = r.content_item_version_id
  join app.content_items ci on ci.id = civ.content_item_id
  where civ.status = 'published'
    and civ.review_status = 'question_review_approved'
    and civ.published_at is not null
    and ci.status = 'published'
    and exists (
      select 1
      from app.content_review_decisions d
      where d.content_review_assignment_id = r.qa_assignment_id
        and d.decision_payload ->> 'approval_basis'
          = 'two_qualified_tutor_approvals_plus_ai_qa'
    );

  if v_count <> 14 then
    raise exception 'publication verification failed: %/14', v_count;
  end if;
end
$$;

commit;
