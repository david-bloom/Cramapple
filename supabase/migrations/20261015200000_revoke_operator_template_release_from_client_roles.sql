-- Security hardening (no behaviour change).
--
-- app.cm_d19_release_template and app.cm_d19_revoke_template_release are
-- operator-run (postgres / service_role) SECURITY INVOKER functions. They were
-- created with the default PUBLIC execute grant, so anon and authenticated can
-- call them. They are inert for those roles (the tables they write are not
-- grantable to them), but a function nobody in the browser should reach should
-- not be executable by the browser roles. See TASK-0056 notes in
-- docs/tasks/TASK-0056-ANSWER-KEY-DIRECT-READ-EXPOSURE.md.
--
-- The app never calls these (no edge function, RPC wrapper or client code
-- references them). postgres (owner) and service_role keep EXECUTE.
-- Rollback: grant execute on both functions back to authenticated.

revoke execute on function app.cm_d19_release_template(text, uuid, jsonb, uuid, text)
  from public, anon, authenticated;
revoke execute on function app.cm_d19_revoke_template_release(text, uuid, uuid)
  from public, anon, authenticated;

grant execute on function app.cm_d19_release_template(text, uuid, jsonb, uuid, text)
  to service_role;
grant execute on function app.cm_d19_revoke_template_release(text, uuid, uuid)
  to service_role;
