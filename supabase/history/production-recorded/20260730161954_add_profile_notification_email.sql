-- Exported from Production migration history (supabase_migrations.schema_migrations)
-- version: 20260730161954
-- recorded name: add_profile_notification_email
-- statements: 1
-- This file is a faithful transcript of what Production actually ran.
-- Do not edit to "improve" it; corrections belong in a new forward migration.

alter table app.profiles
  add column if not exists notification_email text;

alter table app.profiles
  add constraint profiles_notification_email_format_check
  check (
    notification_email is null
    or notification_email ~* '^[^[:space:]@]+@[^[:space:]@]+\.[^[:space:]@]+$'
  );

comment on column app.profiles.notification_email is
  'Optional address for operational notifications only. It is not an authentication identifier and does not change the user login.';
