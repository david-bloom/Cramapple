-- Assign Gulgeldi Darrynow AP Chemistry questions with exactly one human
-- approve/approve_with_edits label on the latest active version, excluding
-- Units 1, 2, and 3.

begin;
select pg_advisory_xact_lock(hashtext('cramapple-gulgeldi-apchem-non-unit123-one-label-20260805'));

create temporary table packet_versions on commit drop as
with apchem as (
  select
    ci.id content_item_id,
    ci.content_key,
    ci.item_type,
    civ.id content_item_version_id,
    civ.version_num,
    civ.status version_status,
    civ.prompt_json->>'topic' topic,
    coalesce(civ.prompt_json->'modules','[]'::jsonb) modules
  from app.content_items ci
  join app.content_item_versions civ on civ.content_item_id=ci.id
  join app.exam_pack_versions epv on epv.id=ci.exam_pack_version_id
  join app.exam_packs ep on ep.id=epv.exam_pack_id
  join app.subjects s on s.id=ep.subject_id
  where s.display_name='AP Chemistry'
    and civ.status <> 'retired'
    and civ.version_num=(
      select max(n.version_num)
      from app.content_item_versions n
      where n.content_item_id=ci.id
    )
), counted as (
  select
    a.*,
    count(*) filter (
      where cra.content_review_assignment_id is not null
        and p.role in ('tutor','reader','validator')
        and coalesce(
          d.tutor_decision,
          case d.tutor_score
            when 1 then 'approve'
            when 2 then 'approve_with_edits'
            when 3 then 'disapprove'
          end
        ) in ('approve','approve_with_edits')
    ) approve_or_awe_count,
    count(*) filter (
      where cra.content_review_assignment_id is not null
        and p.role in ('tutor','reader','validator')
        and coalesce(
          d.tutor_decision,
          case d.tutor_score
            when 1 then 'approve'
            when 2 then 'approve_with_edits'
            when 3 then 'disapprove'
          end
        ) not in ('approve','approve_with_edits')
    ) other_decision_count
  from apchem a
  left join app.content_review_decisions d
    on d.content_item_version_id=a.content_item_version_id
   and d.review_stage='tutor_question'
  left join app.content_review_assignments cra
    on cra.content_review_assignment_id=d.content_review_assignment_id
   and cra.assignment_purpose='subject_review'
  left join app.profiles p on p.user_id=d.reviewer_id
  group by a.content_item_id,a.content_key,a.item_type,a.content_item_version_id,
           a.version_num,a.version_status,a.topic,a.modules
), eligible as (
  select *,
    (
      coalesce(topic ~ '^[123]\.', false)
      or exists (
        select 1
        from jsonb_array_elements_text(modules) m(module)
        where m.module ~* '(^|[^0-9])unit[-_ ]?[123]([^0-9]|$)'
      )
    ) is_unit_123
  from counted
  where approve_or_awe_count=1
    and other_decision_count=0
)
select content_item_id, content_item_version_id, content_key, item_type,
       version_num, version_status
from eligible
where not is_unit_123
  and not exists (
    select 1
    from app.content_review_assignments existing
    where existing.content_item_version_id=eligible.content_item_version_id
      and existing.reviewer_id='119817d1-96c9-4cbc-8fdc-4962e03b1b12'::uuid
      and existing.status in ('pending','in_progress')
  )
  and not exists (
    select 1
    from app.content_review_decisions prior
    where prior.content_item_version_id=eligible.content_item_version_id
      and prior.reviewer_id='119817d1-96c9-4cbc-8fdc-4962e03b1b12'::uuid
  );

do $$
declare
  v_total integer;
  v_qualified boolean;
  v_keys text;
begin
  select count(*), string_agg(content_key, ', ' order by content_key)
  into v_total, v_keys
  from packet_versions;

  if v_total <> 4 then
    raise exception 'expected 4 non-Unit-1/2/3 exactly-one-label AP Chemistry targets, found %: %',
      v_total, coalesce(v_keys, '(none)');
  end if;

  if exists (
    select 1
    from packet_versions
    where content_key not in (
      'apchem-mcq-014',
      'apchem-mcq-050',
      'apchem-sfrq-005',
      'apchem-sfrq-024'
    )
  ) then
    raise exception 'unexpected packet key set: %', v_keys;
  end if;

  select exists (
    select 1
    from app.validator_qualifications vq
    where vq.reviewer_id='119817d1-96c9-4cbc-8fdc-4962e03b1b12'::uuid
      and vq.status='active'
      and 'bfb1b3d3-21b4-49c5-b2f6-6b5b6ed16afe'::uuid = any(vq.exam_ids)
      and vq.effective_at <= now()
      and (vq.expires_at is null or vq.expires_at > now())
  ) into v_qualified;

  if not v_qualified then
    raise exception 'Gulgeldi Darrynow does not have an active AP Chemistry qualification';
  end if;
end $$;

insert into app.content_review_assignments (
  content_item_version_id,
  reviewer_id,
  review_stage,
  review_kind,
  status,
  assignment_purpose,
  created_by
)
select
  content_item_version_id,
  '119817d1-96c9-4cbc-8fdc-4962e03b1b12'::uuid,
  'tutor_question',
  item_type,
  'pending',
  'subject_review',
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from packet_versions;

insert into app.content_labels (
  exam_pack_id,
  label_key,
  label_name,
  label_type,
  status,
  created_by
)
values (
  'bfb1b3d3-21b4-49c5-b2f6-6b5b6ed16afe'::uuid,
  'gulgeldi-apchem-non-unit123-one-label-2026-08-05',
  'Gulgeldi AP Chemistry non-Unit-1-3 one-label follow-up',
  'workflow',
  'published',
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
)
on conflict (exam_pack_id, label_key) do update
set label_name=excluded.label_name,
    label_type=excluded.label_type,
    status=excluded.status;

insert into app.content_review_assignment_labels (
  content_review_assignment_id,
  content_label_id,
  created_by
)
select
  a.content_review_assignment_id,
  l.id,
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from packet_versions pv
join app.content_review_assignments a
  on a.content_item_version_id=pv.content_item_version_id
 and a.reviewer_id='119817d1-96c9-4cbc-8fdc-4962e03b1b12'::uuid
 and a.review_stage='tutor_question'
 and a.assignment_purpose='subject_review'
join app.content_labels l
  on l.exam_pack_id='bfb1b3d3-21b4-49c5-b2f6-6b5b6ed16afe'::uuid
 and l.label_key='gulgeldi-apchem-non-unit123-one-label-2026-08-05'
on conflict do nothing;

do $$
declare
  v_assignments integer;
  v_labeled integer;
begin
  select count(*)
  into v_assignments
  from packet_versions pv
  join app.content_review_assignments a
    on a.content_item_version_id=pv.content_item_version_id
   and a.reviewer_id='119817d1-96c9-4cbc-8fdc-4962e03b1b12'::uuid
   and a.status='pending'
   and a.assignment_purpose='subject_review';

  select count(*)
  into v_labeled
  from packet_versions pv
  join app.content_review_assignments a
    on a.content_item_version_id=pv.content_item_version_id
   and a.reviewer_id='119817d1-96c9-4cbc-8fdc-4962e03b1b12'::uuid
   and a.status='pending'
   and a.assignment_purpose='subject_review'
  join app.content_review_assignment_labels al
    on al.content_review_assignment_id=a.content_review_assignment_id
  join app.content_labels l
    on l.id=al.content_label_id
   and l.label_key='gulgeldi-apchem-non-unit123-one-label-2026-08-05';

  if v_assignments <> 4 or v_labeled <> 4 then
    raise exception 'assignment verification failed: pending %, labeled %', v_assignments, v_labeled;
  end if;
end $$;

select count(*)::integer as assigned_count,
       string_agg(content_key, ', ' order by content_key) as assigned_keys
from packet_versions;

commit;
