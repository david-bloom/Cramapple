# TASK-0078 A1 — Two-step CI gate

Status: Ready for Review
Branch: `codex/task-0078-refactor-ci`
PR: [#520](https://github.com/david-bloom/Cramapple/pull/520)
Authority: David's A1 instruction and the narrower option recorded in TASK-0078; inventory `TEST_GATE_INVENTORY_2026_10_21.md` (61 suites).

The main Deno step runs 56 explicitly named suites with an explicit environment-name allowlist. It has no runtime network permission, filesystem permission or unrestricted environment permission. The second step contains only the five inventory exceptions: BYOQ, capture-pairing, email-template-data, payer-email and the add-on handler. Its network permission is bounded to `0.0.0.0:8000` (the import-time test listener) and its read permission to `docs/email/transactional/manifest.json`. Only that step grants unrestricted environment access for the Stripe SDK.

Both commands use `env -i`, retaining only the existing PATH and HOME. Ambient service credentials and CI environment variables are not passed into either test process. Fixtures supply test-only settings. Module dependency resolution is Deno's normal loading behavior; the permission split describes runtime capabilities.

Local verification on the inventory baseline: **689 tests / 56 suites** in the restricted run and **72 tests / five suites** in the exception run, **761 total / all 61 suites**. This includes the add-on test that Haiku's 60-suite proposal excluded. Both exact workflow commands pass in the clean environment; Python checker tests also pass. The existing import.meta.main guard for capture-pairing remains, with unchanged direct entry behavior.

A4 changes the existing evaluate-attempt suite, so its additional tests are picked up without another workflow path. A2's two new suites belong in the restricted main group; its SQL fixture remains a separate job. New tests from other pending PRs must be added to the appropriate group without restoring broad permissions to the main run.

No deployment, configuration change or live service call was made. Independent review remains pending. Next action: review/merge this gate before the dependent A2/A4 PRs, preserving the permission split during integration.
