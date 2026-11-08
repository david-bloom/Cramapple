-- Down script for 20261108201632_paywall_sample_access.sql (spec §9, rollback level 3).
-- Development only unless separately approved. Restores the pre-change
-- function bodies from the snapshot the up-migration stored in app.config
-- ('sample_access_prior_definitions'), drops the sample objects, and restores
-- the learning_sessions.entry_path check. Imported first-MCQ attempts remain
-- as ordinary rows; without a grant the subject-access gate then denies their
-- readback until the student holds an entitlement (documented loss).
--
-- Run inside a transaction; fails loudly if the snapshot is missing.

begin;

do $down$
declare
  snap jsonb := (select config_value from app.config where config_key = 'sample_access_prior_definitions');
  v_sessions_with_sample integer;
begin
  if snap is null then
    raise exception 'sample access down: snapshot app.config.sample_access_prior_definitions missing';
  end if;

  drop trigger if exists sample_gate_attempt_insert on app.attempts;
  drop trigger if exists sample_supersede_on_entitlement on app.subject_entitlements;

  -- Restore patched/replaced bodies exactly as captured.
  execute snap->>'has_study_subject_access';
  execute snap->>'authorize_grading_access';
  execute snap->>'get_study_topic_point_guides';
  execute snap->>'get_question_experience';

  -- The sample entry_path must not be in use when the old check returns.
  select count(*) into v_sessions_with_sample from app.learning_sessions where entry_path = 'sample';
  if v_sessions_with_sample > 0 then
    update app.learning_sessions set entry_path = 'recommend' where entry_path = 'sample';
  end if;
  alter table app.learning_sessions drop constraint learning_sessions_entry_path_check;
  execute 'alter table app.learning_sessions add constraint learning_sessions_entry_path_check '
    || (snap->>'learning_sessions_entry_path_check');
end;
$down$;

drop function if exists public.claim_sample_frq_source(uuid);
drop function if exists public.claim_sample_try(text);
drop function if exists app.claim_sample_try(uuid, text);
drop function if exists public.get_sample_access_state();
drop function if exists app.sample_access_state(uuid);
drop function if exists app.sample_try_status(text);
drop function if exists app.sample_try_answer(text, text);
drop function if exists app.sample_try_start(text, integer, text, text, text, jsonb);
drop function if exists app.sample_try_view(app.sample_tries, boolean);
drop function if exists app.sample_try_feedback(app.sample_tries);
drop function if exists app.sample_try_question(app.sample_tries);
drop function if exists app.select_sample_mcq(uuid, integer, uuid[], text);
drop function if exists app.sample_unit_availability(text);
drop function if exists app.sample_supersede_on_entitlement();
drop function if exists app.sample_serving_scope(uuid, uuid);
drop function if exists app.sample_take_photo_run(uuid, uuid);
drop function if exists app.sample_gate_attempt_insert();
drop function if exists app.has_study_readback_access(uuid, uuid);
drop function if exists app.sample_study_access(uuid, text);
drop function if exists app.sample_item_unit(uuid);
drop function if exists app.sample_pack_for_subject(uuid);
drop function if exists app.sample_subject_id(text);
drop function if exists app.sample_has_regular_access(uuid, uuid);
drop function if exists app.sample_grant_for(uuid);
drop function if exists app.sample_grant_phase(app.sample_grants);

drop table if exists app.sample_consumptions;
drop table if exists app.sample_consumed_emails;
alter table app.sample_tries drop constraint if exists sample_tries_grant_fk;
drop table if exists app.sample_grants;
drop table if exists app.sample_tries;

drop function if exists app.sample_access_enabled();
drop function if exists app.sample_honor_existing();
delete from app.config where config_key in ('sample_access_enabled', 'sample_access_honor_existing', 'sample_access_prior_definitions');

commit;
