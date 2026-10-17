# Codex branch reconciliation — 2026-10-17

**Status:** Integration record; content custody and release gates remain open.
**Owner:** Codex / Main Conductor. **Authorization:** David Bloom: “Act on your recommendations.”

## Preserved work

| Original branch | Integration | Remaining action |
| --- | --- | --- |
| `codex/precalculus-u1-u3-mcq-gap-fill` | PR #489 preserves the reported 22 seeds/66 variants, approved CED annotations and source check. | Originating content conductor verifies durable private packet and manifest; David decides publication separately. |
| `codex/statistics-u1-u3-gap-fill` | PR #490 preserves 31-seed Stage A metadata and the topic 2.1 correction; Stage 0 is historical. | Originating conductor verifies durable private packet and manifest; Stage B and publication remain separately gated. |
| `codex/more-help-all-subjects-u1-u3` | This branch combines current main with its useful census/validator corrections and explicitly historical launch records. | Native PR checks/merge, then branch removal; no new Production deployment is included. |

The full question packets, keys, votes and attempt ledgers are not tracked in these branches and were not available in this checkout. Their durable private custody is **unverified**, not reported lost. Deleting a merged branch removes no packet from Git; no content task may be considered fully handed off for publication until the original packet location, access and manifest hashes are recorded. Do not regenerate or publish from metadata reports alone.

## More Help reconciliation

- Preserve current main's runtime answer-leak checker, reviewer-guided rewrites/fail-closed behavior, MCQ coaching boundary, FRQ stated-conclusion guards and all existing tests. Runtime diff is only the procedure-name pattern extension; add its three captured regression strings.
- Preserve the read-only census fix: teaching examples are excluded using `app.content_item_is_teaching`, as in the existing practice selector. Tables are historical 2026-10-16 counts, not a new live census.
- Preserve the Statistics launch record as [a full-path legacy record](../activity_log/LEGACY_APPROVAL_STATISTICS_MORE_HELP_LAUNCH_2026_10_16.md). Its original bare ID collided with canonical `APPROVAL-0183` (BC image mirror). The BC approval retains the bare identifier. This is an archival correction, not a new approval or grant of release authority.
- Mark the old session handoff and Statistics work order as historical; [the later More Help handoff](MORE_HELP_REMAINING_TASKS_2026_10_17.md) and [Statistics Stage A result](../qa/STATISTICS_U1_U3_GAP_FILL_STAGE_A_2026_10_16.md) govern their later recorded state. Live status was not reverified in this cleanup.

## Verification and boundaries

All 38 More Help contract tests pass, including runtime-check outage/refusal/rewrites and the added population-procedure cases; Deno also typechecks the suite. The standard-library import used the official `denoland/std` checkout pinned to release 0.224.0 via a scratch-only import map because this environment could not connect to deno.land. No dependency or import-map change is part of the PR. Diff against current main preserves the newer safeguards and changes only one runtime regex line plus its regression strings. Source annotations were checked against the two repository Fall 2026 CEDs. PR-relative whitespace and local documentation links are checked before publishing.

No Production/development write, function deployment, new migration, provider inference call, content publication or task closure. Completed branch removal is verified separately against remote refs after native merges.
