-- Exported from Production migration history (supabase_migrations.schema_migrations)
-- version: 20260728221551
-- recorded name: resolve_single_assignment_blind_groups
-- statements: 1
-- This file is a faithful transcript of what Production actually ran.
-- Do not edit to "improve" it; corrections belong in a new forward migration.

-- A blind_group_id is also populated for some deliberately single-review
-- assignments. Resolve those as single reviews; wait only when a group
-- actually contains two assignments.

create or replace function app.tg_content_pipeline_on_decision()
returns trigger
language plpgsql
security definer
set search_path = app, pg_temp
as $function$
declare
  v_item_id uuid;
  v_outcome text;
  v_review_status text;
  v_blind_group_id uuid;
  v_assignment_count integer;
  v_submitted_count integer;
  v_group_score integer;
  v_is_latest boolean;
begin
  if new.content_item_version_id is null then
    return new;
  end if;

  if new.review_stage = 'tutor_question' then
    select blind_group_id
      into v_blind_group_id
      from app.content_review_assignments
     where content_review_assignment_id = new.content_review_assignment_id;

    if v_blind_group_id is not null then
      select count(*), count(*) filter (where status = 'submitted')
        into v_assignment_count, v_submitted_count
        from app.content_review_assignments
       where blind_group_id = v_blind_group_id
         and review_stage = 'tutor_question';
    else
      v_assignment_count := 1;
      v_submitted_count := 1;
    end if;

    if v_assignment_count = 1 then
      if new.tutor_score = 1 then
        v_outcome := 'reviewed_approved';
        v_review_status := 'question_review_approved';
      elsif new.tutor_score = 2 then
        v_outcome := 'changes_requested';
        v_review_status := 'modification_reserved';
      elsif new.tutor_score = 3 then
        v_outcome := 'reviewed_disapproved';
        v_review_status := 'excluded';
      else
        return new;
      end if;
    elsif v_assignment_count = 2 then
      if v_submitted_count <> 2 then
        return new;
      end if;

      select sum(d.tutor_score)
        into v_group_score
        from app.content_review_assignments a
        join app.content_review_decisions d
          on d.content_review_assignment_id = a.content_review_assignment_id
       where a.blind_group_id = v_blind_group_id
         and a.review_stage = 'tutor_question'
         and not exists (
           select 1
             from app.content_review_decisions newer
            where newer.supersedes_id = d.content_review_decision_id
         );

      if v_group_score = 2 then
        v_outcome := 'reviewed_approved';
        v_review_status := 'ap_reader_pending';
      elsif v_group_score = 3 then
        v_outcome := 'changes_requested';
        v_review_status := 'modification_reserved';
      elsif v_group_score between 4 and 6 then
        v_outcome := 'reviewed_disapproved';
        v_review_status := 'excluded';
      else
        return new;
      end if;
    else
      return new;
    end if;
  elsif new.review_stage = 'reader_question' then
    if new.reader_decision = 'agree' or new.tutor_score = 1 then
      v_outcome := 'reviewed_approved';
      v_review_status := 'question_review_approved';
    elsif new.tutor_score = 2 then
      v_outcome := 'changes_requested';
      v_review_status := 'modification_reserved';
    elsif new.reader_decision = 'disagree' or new.tutor_score = 3 then
      v_outcome := 'reviewed_disapproved';
      v_review_status := 'excluded';
    else
      return new;
    end if;
  else
    return new;
  end if;

  update app.content_item_versions
     set status = case
           when status in (
             'draft', 'assigned', 'changes_requested',
             'reviewed_approved', 'reviewed_disapproved'
           ) then v_outcome
           else status
         end,
         review_status = v_review_status
   where id = new.content_item_version_id;

  select civ.content_item_id,
         not exists (
           select 1
             from app.content_item_versions newer
            where newer.content_item_id = civ.content_item_id
              and (
                newer.version_num > civ.version_num
                or (
                  newer.version_num = civ.version_num
                  and newer.created_at > civ.created_at
                )
              )
         )
    into v_item_id, v_is_latest
    from app.content_item_versions civ
   where civ.id = new.content_item_version_id;

  if v_item_id is not null and v_is_latest then
    update app.content_items
       set status = case
             when status in (
               'draft', 'assigned', 'changes_requested',
               'reviewed_approved', 'reviewed_disapproved'
             ) then v_outcome
             else status
           end
     where id = v_item_id;
  end if;

  return new;
end;
$function$;

revoke all on function app.tg_content_pipeline_on_decision() from public;
revoke all on function app.tg_content_pipeline_on_decision() from anon;
revoke all on function app.tg_content_pipeline_on_decision() from authenticated;
