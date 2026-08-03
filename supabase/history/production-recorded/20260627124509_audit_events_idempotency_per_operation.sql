-- Exported from Production migration history (supabase_migrations.schema_migrations)
-- version: 20260627124509
-- recorded name: audit_events_idempotency_per_operation
-- statements: 1
-- This file is a faithful transcript of what Production actually ran.
-- Do not edit to "improve" it; corrections belong in a new forward migration.

-- Scope audit-event idempotency to (request_id, reason_code) instead of request_id alone.

begin;

drop index if exists app.audit_events_request_id_unique;

create unique index if not exists audit_events_request_id_reason_code_unique
  on app.audit_events (request_id, reason_code)
  where request_id is not null and reason_code is not null;

commit;
