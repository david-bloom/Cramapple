-- Prevent subject-scope assignment leaks at the database boundary.
--
-- content_review_assignments is written by Edge Functions, bulk intake, and
-- occasional administrative SQL. Reviewer role checks alone are insufficient:
-- the assigned reviewer must hold a currently active qualification for the
-- content version's exam. Staging assignments with no promoted content version
-- are checked when content_item_version_id is later populated.

begin;

create or replace function app.tg_enforce_content_review_qualification()
returns trigger
language plpgsql
set search_path = app, pg_temp
as $$
declare
  target_exam_id uuid;
begin
  if new.content_item_version_id is null then
    return new;
  end if;

  select epv.exam_pack_id
    into target_exam_id
    from app.content_item_versions civ
    join app.content_items ci
      on ci.id = civ.content_item_id
    join app.exam_pack_versions epv
      on epv.id = ci.exam_pack_version_id
   where civ.id = new.content_item_version_id;

  if target_exam_id is null then
    raise exception using
      errcode = '23514',
      constraint = 'content_review_assignments_reviewer_qualification_check',
      message = format(
        'content review assignment %s has no resolvable exam scope',
        new.content_review_assignment_id
      );
  end if;

  if not exists (
    select 1
      from app.validator_qualifications vq
     where vq.reviewer_id = new.reviewer_id
       and vq.status = 'active'
       and target_exam_id = any(vq.exam_ids)
       and vq.effective_at <= now()
       and vq.expires_at > now()
  ) then
    raise exception using
      errcode = '23514',
      constraint = 'content_review_assignments_reviewer_qualification_check',
      message = format(
        'reviewer %s lacks an active qualification for exam %s',
        new.reviewer_id,
        target_exam_id
      );
  end if;

  return new;
end;
$$;

drop trigger if exists content_review_assignment_qualification_on_insert
  on app.content_review_assignments;
create trigger content_review_assignment_qualification_on_insert
before insert on app.content_review_assignments
for each row execute function app.tg_enforce_content_review_qualification();

drop trigger if exists content_review_assignment_qualification_on_scope_change
  on app.content_review_assignments;
create trigger content_review_assignment_qualification_on_scope_change
before update of reviewer_id, content_item_version_id
  on app.content_review_assignments
for each row execute function app.tg_enforce_content_review_qualification();

commit;
