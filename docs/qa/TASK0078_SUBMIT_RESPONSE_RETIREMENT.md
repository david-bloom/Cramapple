# TASK-0078 — Retire the unused submit-response Edge source

Status: Ready for review; remote Development deletion pending separate approval.

Fable PR #519 at `60858969` found no live-app callers at `ap-prep-blueprint` `e73445d`. A fresh 2026-10-21 Production function inventory confirms `submit-response` is absent. The current repository has no function configuration or runtime frontend/Edge reference to the endpoint. Its source alone is removed here; historical docs are retained.

`attempt-response` remains the active submission path. `app.submit_response` and its submission guards, row locks, request-hash format and grants are unchanged. No shared submission command or hash transition is introduced.

Before deleting the legacy Development function: recheck its current callers/inventory and obtain approval for that exact remote deletion. No remote function was deleted by this source change. Restore the directory from `df39cd09` if an overlooked source consumer is found; restoration does not authorize a deployment.

Validation: targeted references under runtime code, function configuration and workflows; existing submission/entitlement handler tests run without importing the retired source.
