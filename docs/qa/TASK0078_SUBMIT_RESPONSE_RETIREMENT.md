# TASK-0078 — Retire the unused submit-response Edge source

Status: Source removal ready for review; authorized Development retirement executed and inventory-verified.

Branch: `codex/task-0078-retire-submit-response`
PR: [#522](https://github.com/david-bloom/Cramapple/pull/522)
Next owner: independent reviewer/conductor, source removal and retirement evidence review; no Production action requested.

## Owner-authorized extension, 2026-10-21

David requested: “Remove the Development-only functions and the submit-response source directory, as the drift register and the earlier review both recommend.” This supersedes the earlier pending-approval note below for the exact retire row in `DRIFT_REGISTER_2026_10_21.md` §3: Development `submit-response`, `byoq-smoke-runner`, `byoq-ip-echo`. Repository work is Standard; remote retirement is Hard-Gate and is explicitly authorized by this request. No Production deletion/deployment or database change is authorized.

The fresh inventories confirm these three are Development-only. `send-auth-email` remains: the register says keep. `open-hand-item` remains: the register lists a separate owner decision. `grade-frq`, `seed-stimulus-images-2026-07-19`, `content-intake`, and all active endpoints are outside this retire row.

The two diagnostics currently serve only HTTP 410 `{error:"gone"}`; their downloaded source and exact deployment metadata are preserved in `retired-development-functions-2026-10-21/`. The legacy `submit-response` bundle cannot be downloaded by the connector or CLI (`expected multipart response, got application/octet-stream`); this is the already-recorded legacy-format limitation. Its source remains recoverable from Git `73206cde:supabase/functions/submit-response/index.ts`; that is a source recovery, not proof of the legacy deployment's exact bytes. No claim of an exact legacy bundle backup is made.

Runtime/configuration/workflow reference checks for all three retired names return no callers in this repository. Fable's pinned live-app caller review remains the live-app evidence; no live-app edit was made. The active submission path and its SQL RPC are unchanged.

Prepared commands (exact Development ref, one slug each):

```sh
supabase functions delete byoq-ip-echo --project-ref wmgjsdkphcyhngaffbqf --yes
supabase functions delete byoq-smoke-runner --project-ref wmgjsdkphcyhngaffbqf --yes
supabase functions delete submit-response --project-ref wmgjsdkphcyhngaffbqf --yes
```

Execution result at 2026-10-21 18:21:22 UTC: all three CLI commands returned `Deleted Function`. The fresh Development inventory has 29 functions (32 before), with exactly `submit-response`, `byoq-smoke-runner` and `byoq-ip-echo` removed. `send-auth-email` and `open-hand-item` remain. Production remains 29 functions with identical IDs, versions, hashes, JWT settings and update timestamps. See `retired-development-functions-2026-10-21/after-retirement.json`.

An unrelated Development `create-post-purchase-addon` update (v35→v36) was observed between the before/after snapshots. None of the retirement commands deployed or modified it; no actor attribution is inferred. It is recorded separately rather than claimed as an unchanged Development environment.

The legacy bundle backup limitation did not change: source can be restored from Git, but its exact deployed bytes were not recovered. No functional endpoint was deployed by this work. Source PR #522 remains reviewable independently of the earlier helper stack and is retargeted to current main. The historical source-only record follows.

## Original source-only record

Fable PR #519 at `60858969` found no live-app callers at `ap-prep-blueprint` `e73445d`. A fresh 2026-10-21 Production function inventory confirms `submit-response` is absent. The current repository has no function configuration or runtime frontend/Edge reference to the endpoint. Its source alone is removed here; historical docs are retained.

`attempt-response` remains the active submission path. `app.submit_response` and its submission guards, row locks, request-hash format and grants are unchanged. No shared submission command or hash transition is introduced.

At the original source-only checkpoint, remote deletion was pending. The extension above records the later owner authorization and exact scope. Restore the directory from `df39cd09` if an overlooked source consumer is found; restoration does not authorize a deployment.

Validation: targeted references under runtime code, function configuration and workflows; existing submission/entitlement handler tests run without importing the retired source.

## Reconciliation with the later TASK-0078 checklist

The latest request names A3 again. A fresh read-only Development inventory still has 29 functions: submit-response, byoq-smoke-runner and byoq-ip-echo are absent; send-auth-email and open-hand-item remain. No deletion was repeated. PR #522 retains the source-directory deletion and original receipts, and the canonical checklist now records that executed state instead of treating A3 as unstarted. Source review/merge remains pending.

Merge review follow-up (2026-10-21): the dormant `open_hand_e2e_dev.mjs` QA harness now submits through `attempt-response` (same operation/body), matching the active application path. Verified with syntax checking and the existing attempt-response submit tests; no live QA run was authorized by this source merge. The canonical task retains its latest owner rulings and other checklist rows.
