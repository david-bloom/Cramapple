-- Exported from Production migration history (supabase_migrations.schema_migrations)
-- version: 20260712144716
-- recorded name: fix_prevent_profile_role_change_service_role_check
-- statements: 1
-- This file is a faithful transcript of what Production actually ran.
-- Do not edit to "improve" it; corrections belong in a new forward migration.

create or replace function app.prevent_profile_role_change()
returns trigger
language plpgsql
as $function$
begin
  if current_user <> 'service_role'
     and coalesce(current_setting('request.jwt.claim.role', true), '') <> 'service_role'
     and new.role <> old.role then
    raise exception 'role changes are server-side only';
  end if;
  return new;
end;
$function$;
