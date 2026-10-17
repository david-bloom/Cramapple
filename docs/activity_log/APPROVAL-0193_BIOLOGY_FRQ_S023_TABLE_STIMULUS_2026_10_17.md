# APPROVAL-0193 — Biology FRQ S-023: show the pH data as a table

**Date:** 2026-10-17 · **Status:** step 1 executed (draft v4 exists, not serving); step 2 drafted, owner-run, NOT executed.

**Problem:** live S-023 v3 stores its data as plain lines, so students see one run-on paragraph (owner phone smoke test, Q16). The app already renders caption + pipe-delimited rows as a real table (`src/lib/stimulus-blocks.ts`, `StimulusText`).

**Change:** new v4 with stimulus `caption / pH | Pepsin | Trypsin / 2 | 100 | 2 / 7 | 8 | 100 / 11 | 0 | 35`. Same numbers, stem, parts and scoring criteria (asserted). Parser output checked: one table block, header `pH, Pepsin, Trypsin`, three rows.

**Step 1 (agent, executed on Production):** `scripts/content-seed/reviewer-qa-remediation/20261017_apbio_frq_s023_table_step1_draft.sql` inserts the v4 draft and copies criteria. Rehearsed with rollback first. Live v3 keeps serving.

**Step 2 (owner-run):** `…_s023_table_step2_OWNER_PUBLISH.sql` retires v3, records the owner approval, publishes v4, copies the topic cells and re-validates the serving label in the same transaction (the gap APPROVAL-0189 step 3 had to repair), then asserts the student selector returns S-023 or rolls back.

**Rollback:** retire v4, republish v3 (`prompt_json->>'qa_source_version_id'`), re-validate the label.
