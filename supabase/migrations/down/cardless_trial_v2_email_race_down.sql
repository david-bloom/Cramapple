-- Down script for cardless_trial_v2_email_race (Development ledger 20261110013137;
-- Production ledger 20261110022059). Production rollback needs separate approval.
-- Run BEFORE cardless_trial_v2_qa_fixes_down.sql.
begin;
do $down$
declare snap jsonb := (select config_value from app.config where config_key = 'cardless_trial_email_race_prior_definitions');
begin
  if snap is null then raise exception 'cardless_trial_v2_email_race down: snapshot missing'; end if;
  execute snap->>'start_subject_trial';
end $down$;
delete from app.config where config_key = 'cardless_trial_email_race_prior_definitions';
delete from supabase_migrations.schema_migrations where name = 'cardless_trial_v2_email_race';
commit;
