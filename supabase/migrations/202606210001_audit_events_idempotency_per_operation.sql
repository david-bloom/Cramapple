-- Scope audit-event idempotency to (request_id, reason_code) instead of request_id alone.
--
-- The prior unique index on app.audit_events(request_id) treated request_ids as a
-- global namespace across every Edge Function. Each function (session-event,
-- admin-content, storage-sign-url) dedups by (request_id, reason_code), so a
-- client that reused the same UUID for two different operations would pass each
-- function's dedup check and then collide on the unique index at insert time —
-- surfacing a 500 instead of a clean idempotency result.
--
-- The composite unique matches the dedup intent: same request_id is allowed
-- across operations, repeated request_id for the same operation is rejected.

begin;

drop index if exists app.audit_events_request_id_unique;

create unique index if not exists audit_events_request_id_reason_code_unique
  on app.audit_events (request_id, reason_code)
  where request_id is not null and reason_code is not null;

commit;
