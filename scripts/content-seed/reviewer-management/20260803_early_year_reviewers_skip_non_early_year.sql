-- Free Sarah Sohail, Ghazanfar Ali, Muhammad Saood, Abdul Hanan, and Shazia
-- Fazal's PENDING assignments that are NOT part of the early-year
-- (Aug-Oct, Units 1-3 or subject-equivalent) packets created on 2026-08-03,
-- so each reviewer's active queue is left containing only their early-year
-- packet. Uses direct membership in the 'early-year-%-2026-08-03' labels
-- already created (rather than re-deriving unit tags) so this can't drift
-- from what was actually packeted. Only 'pending' rows are touched --
-- 'submitted' decisions and any other reviewers' assignments are untouched.

begin;

select pg_advisory_xact_lock(hashtext('cramapple-early-year-reviewers-skip-non-early-year-20260803'));

create temporary table other_pending_targets (
  content_review_assignment_id uuid primary key,
  reviewer_name text not null
) on commit drop;

insert into other_pending_targets (content_review_assignment_id, reviewer_name)
select cra.content_review_assignment_id, p.full_name
from app.content_review_assignments cra
join app.profiles p on p.user_id = cra.reviewer_id
where cra.status = 'pending'
  and cra.reviewer_id in (
    'c1d12a8d-1489-4f90-990f-2f1ae2d54199'::uuid, -- Sarah Sohail
    '8328a005-eea2-4f0a-a540-8fe739f88be8'::uuid, -- Ghazanfar Ali
    'cee0cee4-fc59-4084-9a83-b24ccca940b9'::uuid, -- Muhammad Saood
    '002e94ca-c634-4086-bea8-37390c0d3edf'::uuid, -- Abdul Hanan
    '1e6f9c8e-d6ad-4b39-b33b-b31a93020945'::uuid  -- Shazia Fazal
  )
  and not exists (
    select 1
    from app.content_review_assignment_labels al
    join app.content_labels l on l.id = al.content_label_id
    where al.content_review_assignment_id = cra.content_review_assignment_id
      and l.label_key like 'early-year-%-2026-08-03'
  );

do $$
declare
  v_sarah integer; v_ali integer; v_saood integer; v_abdul integer; v_shazia integer; v_total integer;
begin
  select
    count(*) filter (where reviewer_name = 'Sarah Sohail'),
    count(*) filter (where reviewer_name = 'Ghazanfar Ali'),
    count(*) filter (where reviewer_name = 'Muhammad Saood'),
    count(*) filter (where reviewer_name = 'Abdul Hanan'),
    count(*) filter (where reviewer_name = 'Shazia Fazal'),
    count(*)
  into v_sarah, v_ali, v_saood, v_abdul, v_shazia, v_total
  from other_pending_targets;

  if (v_sarah, v_ali, v_saood, v_abdul, v_shazia, v_total) <> (139, 27, 0, 0, 20, 186) then
    raise exception 'unexpected_other_pending_pool:sarah=%:ali=%:saood=%:abdul=%:shazia=%:total=%',
      v_sarah, v_ali, v_saood, v_abdul, v_shazia, v_total;
  end if;
end
$$;

update app.content_review_assignments cra
set status = 'skipped'
from other_pending_targets t
where cra.content_review_assignment_id = t.content_review_assignment_id;

do $$
declare
  v_still_pending integer;
begin
  select count(*) into v_still_pending
  from other_pending_targets t
  join app.content_review_assignments cra
    on cra.content_review_assignment_id = t.content_review_assignment_id
   and cra.status = 'pending';
  if v_still_pending <> 0 then
    raise exception 'other_pending_not_fully_skipped:%', v_still_pending;
  end if;
end
$$;

commit;
