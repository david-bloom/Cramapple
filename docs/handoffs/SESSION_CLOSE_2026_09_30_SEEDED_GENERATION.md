# Session Close: Seeded Generation, AP Calc AB Content Publication — 2026-09-30

Format follows `prompts/CLOSE_SESSION_PROMPT.md`. Records: `DECISION-0093`, `APPROVAL-0065`, Activity Log entry of the same date.

## 1. Current task
No numbered task. Work item: author, check, label and publish AP Calculus AB variants, and turn what was learned into a protocol for generating questions from existing ones ("seeds"). The next session will test that protocol on a **different subject**.

## 2. What changed this session
- **Production content (Prod `pcntajvbdfqhbeewmdry`):** 136 AP Calc AB Unit 1 items published (34 originals + 102 variants; 8 relabelled topic 2.1 / Unit 2, keys keep the `u1` prefix) and 24 seeded variants (`apcalcab-mcq-sv-<seed>-vK`). Calc AB: published 119 to 279, unit-gated 36 to 196, validated serving labels 38 to 198.
- **Protocols:** `CONTENT_AUTHORING_AND_QA_PROTOCOL.md` v0.5 (checker model menu, pre-run prompts, Phase 5b variants); new `SEEDED_ITEM_GENERATION_PROTOCOL_2026_09_30.md` (draft v0.1); pointers added in the Orly mining protocol; `docs/INDEX.md` rows.
- **Scripts (separate PR, not merged by me):** token-usage logging in the three checker scripts in `scripts/vercel-gateway-check/` (`apcalcab_unit1_math_check.mjs`, `_ced_conformance.mjs`, `_label_probe.mjs`); batch folders under `scripts/content-seed/calc-ab-*-2026-09-30/`.
- **Logs:** DECISION-0093, APPROVAL-0065, Activity Log entry, this handoff.

## 3. What was verified
- Keys: 0 of about 250 blind solves by two or three models disagreed with a stored key (only `apcalcab-mcq-037`, whose stored letter disagrees with its flagged-correct choice, was found separately).
- Loads: 136 of 136 and 24 of 24 md5-exact against the source; 0 letter/key inconsistencies; 0 stale label hashes; no `anon`/`authenticated` column grant on `is_correct` or `rationale`; no duplicate published versions; selftest shows no mismatches (capped skips only).
- Findings: distractor rationales are where defects live (about 15% of first-draft items in Unit 1; 17% across the 24 later variants; 10 of 20 audited published seeds). A second checker caught what the first missed; a blind Fable 5.1 pass found 0 real defects in the 24 final variants and confirmed all 14 known-defective controls.

## 4. What remains open
1. **`apcalcab-mcq-037` key desync (live in Production).** `canonical_answer_1 = 'A'`, but choice B (0.796) is flagged `is_correct` and is the correct local maximum. Determine which field grading uses, check attempts, fix `canonical_answer_1` to `B` via a migration, refresh the item's label hash. Only letter-vs-letter mismatch among 173 published Calc AB MCQs.
2. **Distractor-rationale repairs on 10 published Calc AB MCQs** (keys are correct): `026` D, `031` A and B, `np2-006` B, `016` B, `038` B and C, `030` A, `008` A, `007` B, `005` A, `080` D. Evidence in `scripts/content-seed/calc-ab-pilot-2026-09-30/PILOT_REPORT.md` and `.../calc-ab-seed-audit-2026-09-30/AUDIT_REPORT.md`. Repair with the owner-remediation pattern (new version, never in-place); label hashes will go stale and need refresh. Overlaps `TASK-0053`. Not audited: about 150 other published MCQs (Units 4-8 have one audited item each); the policy is to audit a seed when it is varied, not to sweep.
3. **Held labels.** Unit 1: 17 difficulty and 10 topic held, skill labels provisional only, 3 originals with no skill consensus (`LABELING_REPORT.md`). Seeded variants: topic held on `005-v1/v2`, skill on `017-v1/v2` and `038-v1/v2`, difficulty on `029-v1/v2` and `038-v1/v2`.
4. **Unit 1 open notes:** DeepSeek V4 Pro recall is uncalibrated; FRQ `002` rubric question on limit-based justification for asymptotes; the 8 relabelled items still carry `u1` in their keys.
5. **Schema gap:** no `family_id` / `derived_from_content_item_id` (AQP §7.1); batch manifests are the only record of which items are siblings.
6. **Untested ideas:** trimming or caching the CED fact pack (about half of checking cost); per-batch Fable sampling.
7. **PRs:** the docs close-out PR is merged under the docs-only authority once CI is green; the scripts/content-seed PR is left for David.
8. **Security note:** an early command in this session echoed one line of `scripts/vercel-gateway-check/.env.local`, including the AI Gateway key, into the session transcript. Rotate the key if that transcript is shared.

## 5. Open blockers or risks
- Published seeds with flawed rationales (item 2) keep showing students misleading feedback until repaired. Item 1 could mark a correct answer wrong if grading reads `canonical_answer_1`.
- The seeded protocol is draft and has been exercised only on AP Calc AB MCQs (class A seeds). It has **not** been used with a class B or C (third-party) seed and no clean-room run has happened.

## 6. Files changed or checked
Docs: `docs/research/SEEDED_ITEM_GENERATION_PROTOCOL_2026_09_30.md`, `docs/research/CONTENT_AUTHORING_AND_QA_PROTOCOL.md`, `docs/research/ORLY_EXTERNAL_ASSIGNMENT_MINING_PROTOCOL_2026_08_24.md`, `docs/INDEX.md`, the three activity logs. Batch reports (in `scripts/content-seed/`): `calc-ab-unit1-original-2026-09-29/` (PR #292), `calc-ab-pilot-2026-09-30/`, `calc-ab-seed-audit-2026-09-30/`, `calc-ab-unit3-variants-2026-09-30/`, `calc-ab-fable-calibration-2026-09-30/`, `calc-ab-seeded-batch-2026-09-30/` (`PUBLICATION_RECORD.md`).

## 7. Commands, queries, tests
Supabase MCP `execute_sql` on Production: chunked loads, hash verification (`verify_hashes.sql`), approval/label/publish transactions, `app.servable_items_census()` and `_selftest()`, key/desync scans. Vercel AI Gateway: math check (solve + audit), CED check, label probe, Fable calibration. sympy for every key and distractor value. All results in the batch folders' `out*/` directories.

## 8. Approval state
Approved and recorded: `DECISION-0093`, `APPROVAL-0065`. **Not approved:** any other subject; repairs to published items (they need the owner-remediation approval when run); anything touching a class B/C seed.

## 9. Exact next step
The Product Owner opens a new session on a different subject to test `SEEDED_ITEM_GENERATION_PROTOCOL_2026_09_30.md`. Recommended prompt: "Read docs/INDEX.md, then the seeded item generation protocol and the authoring protocol §2.1. Start with the pre-run questions (which two checker models from the live roster, variants and how many), audit the seeds first (S0a), then run the pilot on <subject>." First actions: check the live gateway roster, pick seeds from published items with validated labels, run the S0a audit before writing any variant.

## 10. Do not touch next session
- `scripts/content-seed/calc-ab-unit1-original-2026-09-29/` and `calc-ab-seeded-batch-2026-09-30/`: do **not** re-run `build_batch.py`, `verify_and_build.py` or `build_variants.py` (they redraw correct-answer letters and would desync from what is loaded).
- Do not edit `apcalcab-mcq-037` or the 10 flagged seeds in place; use the repair tasks.
- Do not treat a Fable/other-model flag as a defect until verified by hand or sympy.
