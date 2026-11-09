-- Down script for 20261109215704_cardless_trial_v2.sql (spec §11). Development only
-- unless separately approved. Run cardless_trial_v2_qa_fixes_down.sql and
-- get_my_learning_sessions_down.sql FIRST (they depend on these objects).
--
-- The up-migration patched app.authorize_grading_access by anchor without a
-- snapshot, so this reverses the same anchor deterministically, and restores
-- app.has_study_readback_access to the sample release's two-clause body
-- (20261108201632). trial_v2 entitlement rows and consumed-email hashes are
-- history and are kept; the source check is narrowed only when none exist.
begin;

do $down$
declare
  definition text := pg_get_functiondef('app.authorize_grading_access(uuid,uuid,text,text)'::regprocedure);
  patched text := E'    return app.trial_grading_gate(p_user_id, v_subject_id, p_operation, p_request_id);';
  original text := E'    return ''entitled'';';
begin
  if strpos(definition, 'trial_grading_gate') > 0 then
    if (length(definition) - length(replace(definition, patched, ''))) / length(patched) <> 1 then
      raise exception 'cardless_trial_v2 down: expected exactly one trial_grading_gate call to reverse';
    end if;
    execute replace(definition, patched, original);
  end if;
end $down$;

create or replace function app.has_study_readback_access(_user_id uuid, _version_id uuid)
returns boolean language sql stable security definer set search_path = pg_catalog as $$
  select app.has_study_pack_access(_user_id, _version_id)
    or exists (
      select 1 from app.sample_grants g
      join app.exam_pack_versions v on v.id = _version_id
      join app.exam_packs p on p.id = v.exam_pack_id
      where g.user_id = _user_id and g.subject_id = p.subject_id
    );
$$;
revoke all on function app.has_study_readback_access(uuid, uuid) from public, anon, authenticated;
grant execute on function app.has_study_readback_access(uuid, uuid) to service_role;

drop function if exists app.trial_grading_gate(uuid, uuid, text, text);
drop function if exists public.start_subject_trial(text, text, jsonb, jsonb);
drop function if exists app.start_subject_trial(uuid, text, text, jsonb, jsonb);
drop function if exists public.get_trial_state();
drop function if exists app.trial_v2_state(uuid);
drop table if exists app.trial_grading_log;
delete from app.config where config_key in ('cardless_trial_enabled', 'trial_daily_grading_cap');

do $down$
begin
  if not exists (select 1 from app.trial_consumed_emails where source = 'trial_v2') then
    alter table app.trial_consumed_emails drop constraint trial_consumed_emails_source_check;
    alter table app.trial_consumed_emails add constraint trial_consumed_emails_source_check
      check (source in ('trial_v1', 'stripe_trial_v1'));
  end if;
end $down$;

delete from supabase_migrations.schema_migrations where name = 'cardless_trial_v2';
commit;
