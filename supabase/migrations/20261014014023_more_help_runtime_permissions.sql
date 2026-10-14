-- Claude P0-1: runtime calls use SECURITY INVOKER + service_role, not postgres.
-- Grant only the missing operations; keep client grants/RLS and RPC gates intact.
grant update on app.question_help_receipts to service_role;
grant select, insert on app.attempt_assistance_events to service_role;
