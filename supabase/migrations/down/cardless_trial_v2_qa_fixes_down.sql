-- Down script for 20261110011605_cardless_trial_v2_qa_fixes.sql. Development only
-- unless separately approved. Restores the three 20261109215704 bodies from the
-- snapshot the up-migration stored in app.config, drops the sanitizer.
begin;
do $down$
declare snap jsonb := (select config_value from app.config where config_key = 'cardless_trial_prior_definitions');
begin
  if snap is null then raise exception 'cardless_trial_v2_qa_fixes down: snapshot missing'; end if;
  execute snap->>'trial_v2_state';
  execute snap->>'start_subject_trial';
  execute snap->>'trial_grading_gate';
end $down$;
drop function if exists app.sanitize_trial_touch(jsonb);
delete from app.config where config_key = 'cardless_trial_prior_definitions';
delete from supabase_migrations.schema_migrations where name = 'cardless_trial_v2_qa_fixes';
commit;
