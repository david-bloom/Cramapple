# TASK-0024 - Free Score Check Cutover Evidence

**Task ID:** TASK-0024
**Evidence Date:** TODO
**Recorder:** TODO
**Production project:** `pcntajvbdfqhbeewmdry`
**Rule:** Do not paste secrets, service-role keys, student emails, names,
learner responses, production stems, stimuli, answers, or rubric text into this
record. Use IDs, statuses, counts, timestamps, and pass/fail outputs only.

> **Superseded 2026-08-15 by TASK-0026 (7-Day Full-Access Trial).** This
> cutover never happened; the offer was retired before launch. See
> TASK-0024-FREE-SCORE-CHECK-LAUNCH-READINESS.md and TASK-0026 for context.

This evidence record is intentionally separate from the implementation task so
an approved production cutover can capture exactly what changed, what was
verified, and what rollback path was ready.

## Pre-Cutover Local Evidence

- [ ] `node scripts/verify-free-score-check-local.mjs`
  - Timestamp:
  - Result:
  - Notes:
- [ ] `node scripts/verify-free-score-check-deploy-package.mjs`
  - Timestamp:
  - Result:
  - `package_sha256`:
  - File manifest count:
- [ ] `node scripts/verify-free-score-check-deploy-package.mjs --deploy-summary`
  - Timestamp:
  - Result:
  - Confirmed no source content is present:
  - Confirmed `package_sha256` matches verifier:
  - Confirmed `file_manifest` matches verifier:
- [ ] `node scripts/verify-free-score-check-sql-package.mjs`
  - Timestamp:
  - Result:
  - SQL `package_sha256`:
  - Artifact count:
  - Confirmed visual-gate migration and guarded templates are included:
- [ ] `node scripts/verify-free-score-check-launch-bundle.mjs`
  - Timestamp:
  - Result:
  - `bundle_sha256`:
  - Edge Function `package_sha256`:
  - SQL `package_sha256`:
  - Evidence manifest count:
- [ ] `node scripts/verify-free-score-check-deploy-package.mjs --deploy-payload`
  - Timestamp:
  - Confirmed `name = free-score-check`:
  - Confirmed `entrypoint_path = supabase/functions/free-score-check/index.ts`:
  - Confirmed `verify_jwt = true`:
  - Confirmed `package_sha256` matches verifier:
  - Confirmed `file_manifest` matches verifier:

## Production Read-Only Baseline

- [ ] Supabase Edge Function inventory checked before deploy
  - Timestamp:
  - `free-score-check` present:
  - If present, status/version/verify_jwt:
- [ ] `scripts/free-score-check-production-preflight.sql`
  - Timestamp:
  - `config_is_fail_closed_or_complete`:
  - `start_rpc_has_visual_gate`:
  - `configured_content_is_student_visible`:
  - `purchase_completed_source_is_stripe_only`:
  - `growth_outbox_has_no_private_launch_property_keys`:
- [ ] `scripts/free-score-check-production-readiness-snapshot.sql`
  - Timestamp:
  - `config_fail_closed_or_ready`:
  - `start_rpc_visual_gate`:
  - `edge_function_inventory`:
  - `eligible_candidate_count`:
  - `missing_visual_classification_count`:
  - `configured_content_student_visible`:
  - `purchase_completed_source`:
  - `growth_outbox_private_launch_keys`:
- [ ] `scripts/free-score-check-candidate-selection.sql`
  - Timestamp:
  - Eligible row count:
- [ ] If eligible row count is `0`,
  `scripts/free-score-check-candidate-triage-summary.sql`
  - Timestamp:
  - Highest-priority bucket:
  - Count:

## Production Change Evidence

- [ ] Apply `supabase/migrations/20260813174828_free_score_check_visual_gate.sql`
  - Timestamp:
  - Tool used:
  - Verified SQL `package_sha256`:
  - Result:
  - Immediate preflight `start_rpc_has_visual_gate`:
- [ ] Deploy `free-score-check` Edge Function
  - Timestamp:
  - Tool used:
  - Entrypoint:
  - Deployed `package_sha256`:
  - Version:
  - Status:
  - `verify_jwt`:
- [ ] Authorized human visual review completed in admin/content-review surface
  - Reviewer:
  - Reviewed `content_item_version_id`:
  - Review decision:
  - Confirmation that no prompt visual is required:
- [ ] Run `scripts/free-score-check-mark-no-visual-candidate.template.sql`
  - Timestamp:
  - Verified SQL `package_sha256`:
  - Reviewed `content_item_version_id`:
  - Result:
  - Candidate selector row count after classification:
- [ ] Run `scripts/free-score-check-enable-config.template.sql`
  - Timestamp:
  - Verified SQL `package_sha256`:
  - Selected `content_item_version_id`:
  - Selected `rubric_version_id`:
  - Result:

## Post-Enable Verification

- [ ] `scripts/free-score-check-production-preflight.sql`
  - Timestamp:
  - `config_is_fail_closed_or_complete`:
  - `start_rpc_has_visual_gate`:
  - `configured_content_is_student_visible`:
  - `purchase_completed_source_is_stripe_only`:
  - `growth_outbox_has_no_private_launch_property_keys`:
- [ ] `scripts/free-score-check-production-readiness-snapshot.sql`
  - Timestamp:
  - `config_fail_closed_or_ready`:
  - `start_rpc_visual_gate`:
  - `edge_function_inventory`:
  - `eligible_candidate_count`:
  - `configured_content_student_visible`:
  - `purchase_completed_source`:
  - `growth_outbox_private_launch_keys`:
- [ ] Mobile magic-link/OTP smoke
  - Timestamp:
  - Device/browser:
  - Landing route:
  - OTP/magic-link result:
  - Question route loaded:
  - Initial grade recorded:
  - Repair grade recorded:
  - Report route loaded:
  - Print/download report checked:
- [ ] `scripts/free-score-check-post-enable-smoke.sql`
  - Timestamp:
  - `recent_free_score_check_completed`:
  - `server_funnel_events_present`:
  - `growth_outbox_has_no_private_smoke_property_keys`:

## Rollback Readiness

- [ ] `scripts/free-score-check-disable-config.template.sql` reviewed and ready
  - Timestamp:
  - Operator:
  - Notes:
- [ ] If rollback executed
  - Timestamp:
  - Verified SQL `package_sha256`:
  - Result:
  - Config after rollback:
  - Follow-up owner:

## Final Launch Decision

- [ ] All required gates passed
- [ ] No private learning fields observed in growth events
- [ ] Offer remains disabled until paid traffic is explicitly approved
- [ ] Product Owner launch decision recorded
  - Decision:
  - Timestamp:
  - Notes:
