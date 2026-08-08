-- Transfer 20 pending Physics tutor-question assignments from Ghazanfar Ali to
-- Ahmed Ali / stemmentora@gmail.com.
--
-- Owner instruction, 2026-08-07:
-- "Assign 3 MCQs and 2 FRQs from each of the 4 physics subjects (20 total) to
-- reviewer stemmentora@gmail.com. Take these 20 from Ghazanfar Ali's queue so
-- Ali's queue is reduced by 20. Prioritize any questions which have already
-- have an approve or approve with edits label."
--
-- Selection is deterministic by subject/type/content_key and ranks items with
-- prior tutor-question approve_with_edits/score=2 ahead of approve/score=1.

begin;

select pg_advisory_xact_lock(
  hashtext('cramapple-transfer-ali-physics-twenty-to-stemmentora-20260807')
);

create temporary table transfer_constants (
  ghazanfar_id uuid not null,
  stemmentor_id uuid not null,
  assigned_by uuid not null
) on commit drop;

insert into transfer_constants
select
  '8328a005-eea2-4f0a-a540-8fe739f88be8'::uuid,
  '2b29b40a-6c00-49f8-9bfa-7e3d9e81f9ae'::uuid,
  (select user_id from app.profiles where role = 'admin' and full_name = 'David' limit 1);

do $$
declare
  v_ghazanfar_ok boolean;
  v_stemmentor_ok boolean;
begin
  select exists (
    select 1 from app.profiles
    where user_id = (select ghazanfar_id from transfer_constants)
      and full_name = 'Ghazanfar Ali'
  ) into v_ghazanfar_ok;

  select exists (
    select 1
    from app.profiles p
    join auth.users u on u.id = p.user_id
    where p.user_id = (select stemmentor_id from transfer_constants)
      and u.email = 'stemmentora@gmail.com'
  ) into v_stemmentor_ok;

  if not v_ghazanfar_ok then
    raise exception 'ghazanfar_profile_not_found';
  end if;

  if not v_stemmentor_ok then
    raise exception 'stemmentora_profile_not_found';
  end if;
end $$;

do $$
declare
  v_missing integer;
begin
  with physics_packs as (
    select id, exam_code
    from app.exam_packs
    where exam_code in (
      'ap_physics_1',
      'ap_physics_2',
      'ap_physics_c_mechanics',
      'ap_physics_c_em'
    )
  ), expected as (
    select count(*) expected_count from physics_packs
  ), qualified as (
    select distinct ep.exam_code
    from app.validator_qualifications vq
    join physics_packs ep on ep.id = any(vq.exam_ids)
    where vq.reviewer_id = (select stemmentor_id from transfer_constants)
      and vq.status = 'active'
      and vq.effective_at <= now()
      and vq.expires_at > now()
  )
  select (select expected_count from expected) - count(*)
  into v_missing
  from qualified;

  if v_missing <> 0 then
    raise exception 'stemmentora_missing_physics_qualification_count=%', v_missing;
  end if;
end $$;

create temporary table selected_assignments on commit drop as
with ali_pending as (
  select
    a.content_review_assignment_id,
    a.content_item_version_id,
    ci.id as content_item_id,
    ci.content_key,
    ci.item_type,
    ep.id as exam_pack_id,
    ep.exam_code,
    a.created_at
  from app.content_review_assignments a
  join app.content_item_versions civ on civ.id = a.content_item_version_id
  join app.content_items ci on ci.id = civ.content_item_id
  join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  cross join transfer_constants c
  where a.reviewer_id = c.ghazanfar_id
    and a.review_stage = 'tutor_question'
    and a.status = 'pending'
    and ep.exam_code in (
      'ap_physics_1',
      'ap_physics_2',
      'ap_physics_c_mechanics',
      'ap_physics_c_em'
    )
    and ci.item_type in ('mcq', 'frq')
    and not exists (
      select 1
      from app.content_review_assignments existing
      where existing.content_item_version_id = a.content_item_version_id
        and existing.reviewer_id = c.stemmentor_id
        and existing.review_stage = 'tutor_question'
    )
    and not exists (
      select 1
      from app.content_item_versions any_version
      join app.content_review_decisions decision
        on decision.content_item_version_id = any_version.id
       and decision.review_stage = 'tutor_question'
      where any_version.content_item_id = ci.id
        and decision.reviewer_id = c.stemmentor_id
    )
), scored as (
  select
    ap.*,
    coalesce((
      select min(case
        when d.tutor_decision = 'approve_with_edits' or d.tutor_score = 2 then 0
        when d.tutor_decision = 'approve' or d.tutor_score = 1 then 1
        else 2
      end)
      from app.content_review_decisions d
      cross join transfer_constants c
      where d.content_item_version_id = ap.content_item_version_id
        and d.review_stage = 'tutor_question'
        and d.reviewer_id <> c.ghazanfar_id
        and (
          d.tutor_decision in ('approve', 'approve_with_edits')
          or d.tutor_score in (1, 2)
        )
    ), 2) as prior_rank
  from ali_pending ap
), ranked as (
  select
    *,
    row_number() over (
      partition by exam_code, item_type
      order by prior_rank, content_key, content_review_assignment_id
    ) as rn
  from scored
)
select *
from ranked
where (item_type = 'mcq' and rn <= 3)
   or (item_type = 'frq' and rn <= 2);

do $$
declare
  v_total integer;
  v_prior_positive integer;
begin
  select count(*) into v_total from selected_assignments;

  if v_total <> 20 then
    raise exception 'transfer_selection_count_changed=%', v_total;
  end if;

  if exists (
    select 1
    from selected_assignments
    group by exam_code
    having count(*) filter (where item_type = 'mcq') <> 3
        or count(*) filter (where item_type = 'frq') <> 2
  ) then
    raise exception 'transfer_selection_distribution_changed';
  end if;

  select count(*) into v_prior_positive
  from selected_assignments
  where prior_rank in (0, 1);

  if v_prior_positive <> 20 then
    raise exception 'transfer_selection_not_all_prior_positive=%', v_prior_positive;
  end if;
end $$;

insert into app.content_labels (
  exam_pack_id,
  label_key,
  label_name,
  label_type,
  status,
  created_by
)
select distinct
  exam_pack_id,
  'stemmentora-physics-transfer-from-ghazanfar-2026-08-07',
  'Stemmentora Physics transfer from Ghazanfar Ali, 2026-08-07',
  'workflow',
  'published',
  (select assigned_by from transfer_constants)
from selected_assignments
on conflict (exam_pack_id, label_key) do update
set label_name = excluded.label_name,
    label_type = excluded.label_type,
    status = excluded.status;

update app.content_review_assignments a
set reviewer_id = (select stemmentor_id from transfer_constants),
    assigned_at = now()
from selected_assignments s
where a.content_review_assignment_id = s.content_review_assignment_id
  and a.reviewer_id = (select ghazanfar_id from transfer_constants)
  and a.status = 'pending'
  and a.review_stage = 'tutor_question';

insert into app.content_review_assignment_labels (
  content_review_assignment_id,
  content_label_id,
  created_by
)
select
  s.content_review_assignment_id,
  l.id,
  (select assigned_by from transfer_constants)
from selected_assignments s
join app.content_labels l
  on l.exam_pack_id = s.exam_pack_id
 and l.label_key = 'stemmentora-physics-transfer-from-ghazanfar-2026-08-07'
on conflict do nothing;

do $$
declare
  v_transferred integer;
  v_labeled integer;
begin
  select count(*)
  into v_transferred
  from selected_assignments s
  join app.content_review_assignments a
    on a.content_review_assignment_id = s.content_review_assignment_id
   and a.reviewer_id = (select stemmentor_id from transfer_constants)
   and a.status = 'pending'
   and a.review_stage = 'tutor_question';

  select count(*)
  into v_labeled
  from selected_assignments s
  join app.content_review_assignment_labels al
    on al.content_review_assignment_id = s.content_review_assignment_id
  join app.content_labels l
    on l.id = al.content_label_id
   and l.label_key = 'stemmentora-physics-transfer-from-ghazanfar-2026-08-07';

  if (v_transferred, v_labeled) <> (20, 20) then
    raise exception 'transfer_reconciliation_failed: transferred=%, labeled=%',
      v_transferred, v_labeled;
  end if;
end $$;

select exam_code, item_type, count(*)::integer assigned_count
from selected_assignments
group by exam_code, item_type
order by exam_code, item_type;

select exam_code, item_type, content_key, prior_rank
from selected_assignments
order by exam_code, item_type, content_key;

commit;
