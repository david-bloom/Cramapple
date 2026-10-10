-- TASK-0069: app.merge_response_parts must run with INVOKER rights. As a
-- definer function it executed as its owner, and
-- app.response_versions_guard_reserved_parts() (which recognises the service
-- role by current_user) refused the write with reserved_keys_are_server_only.
-- No-op on a database whose 20261009233521 already declares security invoker.
alter function app.merge_response_parts(uuid, jsonb, text, text[]) security invoker;
