# Course Mode — Unit 1 Pilot: Load/Release verified + Loop Proof

STATUS: verification + proof | DATE: 2026-08-26 | AUDIENCE: David + next session.

Supersedes the "[A]/[B] pending" state in `COURSE_MODE_PILOT_FINISH_NEXT_STEPS_2026_08_25.md`
and the runbook's 2026-08-25 log. **Verified live against Dev
(`wmgjsdkphcyhngaffbqf`); Prod (`pcntajvbdfqhbeewmdry`) untouched.**

## 1. [A] load + [B] CM-D19 release — ALREADY COMPLETE (verified, not re-run)

The DB is the source of truth; the 2026-08-25 docs were written before the
release ran and never updated. Live state:

- **200 published pilot items** across the 10 templates (10 × 20), `item_type='mcq'`,
  in exam-pack version `4e54bb4f-695f-41be-ac06-745fe9ad8bcc`.
- **10 `app.template_releases` rows**, `revoked_at IS NULL`, `instances_stamped = 20`
  each, released by David's Dev user (`cda34c9d-…`) on 2026-08-25.
- Attestation is **flat** (the function's real contract; the doc's nested
  `{"sme":{…}}` example was stale):
  `{sme_sample_n:20, sme_defects:0, property_instances:120, property_rejects:0, verifier_disagreements:0}`,
  bars `cm-d19-phase1-2026-08-23`.
- Manifest `allowed_unit_numbers = {1,5}`. `evaluate-attempt` edge function
  **ACTIVE v16** (doc referenced v15 → hook is current; step **[E]** satisfied).
- All 200 items are well-formed 4-choice MCQs (exactly one correct + 3 distractors;
  0 malformed) → deterministic choice-match grading.

The 10 real template ids (the doc's `FB-U1-*` labels are aliases):

| template_id | cell |
|---|---|
| `summary_stats` | 1.7×3.B |
| `compare_stats` | 1.9×3.B |
| `slotframe_u1_2_variables` | 1.2×2.A |
| `slotframe_u1_5_graphs` | 1.5×3.A |
| `slotframe_u1_6_distribution` | 1.6×4.A |
| `slotframe_u1_8_boxplots` | 1.8×3.A |
| `slotframe_u1_11_sampling` | 1.11×2.A |
| `slotframe_u1_12_bias` | 1.12×2.A |
| `slotframe_u1_13_design` | 1.13×2.A |
| `slotframe_4b_compare` | 1.9×4.B |

Re-running was deliberately avoided: the loader is fail-closed on existing
content-keys (would abort), and the release RPC only stamps `draft` items — a
re-run on already-`published` items stamps **0**, not 20, and would churn the
release record via its `ON CONFLICT DO UPDATE`.

## 2. Prove-the-loop — engine proven locally; deployed harness delivered

Grading + cell-state promotion live only in the `evaluate-attempt` edge
function's TypeScript (no SQL RPC). The authoring session could reach Dev only
over SQL (Supabase MCP); **org egress policy blocks the Dev Supabase host**, so
the deployed HTTP grader could not be driven from there. Split into two proofs
under `scripts/course_mode_loop_proof/`:

- **`run_local_engine_proof.ts` — RAN HERE, all 10 cells PASS.** Drives the real
  `cell-state-1.0` engine with each cell's real Dev provenance, reproducing
  `cell-state-persist.ts::applyToCell` exactly. Every cell: cold serve→**correct**
  promotes `unseen → independent` (weight 1.0); later serve→**wrong** sets
  `fragile=true` with **tier unchanged** (INV-6). Matches the existing lsrl
  proof row shape.
- **`run_e2e_harness.ts` — RAN 2026-08-26 (local CLI), all 10 cells PASS.**
  Provisions a throwaway entitled test student, drives the deployed
  `attempt-response` → `evaluate-attempt` → `student-session-items` path for all
  10 cells, reads back `app.student_cell_state`, and deletes the student. Wrapped
  by `run.sh` (one command; prompts for the legacy service_role JWT).

### Live result — 10/10 PASS (Dev, deployed functions)

```
cell      | correct→     | confirm-transfer   | miss→        | fragile  | verdict
1.7×3.B   | independent  | excluded✓          | independent  | true     | PASS
1.9×3.B   | independent  | excluded✓          | independent  | true     | PASS
1.2×2.A   | independent  | confirmed✓         | independent  | true     | PASS
1.5×3.A   | independent  | confirmed✓         | independent  | true     | PASS
1.6×4.A   | independent  | confirmed✓         | independent  | true     | PASS
1.8×3.A   | independent  | confirmed✓         | independent  | true     | PASS
1.11×2.A  | independent  | confirmed✓         | independent  | true     | PASS
1.12×2.A  | independent  | confirmed✓         | independent  | true     | PASS
1.13×2.A  | independent  | confirmed✓         | independent  | true     | PASS
1.9×4.B   | independent  | confirmed✓         | independent  | true     | PASS
```

Each cell: cold serve→**correct** promotes to `independent`; the **§7.1(b)
confirm-transfer beat** serves a *different* same-cell MCQ that grades correct
(cell stays `independent`) for the 8 non-numeric cells, and **fails closed**
(no item) for the 2 numeric cells (1.7×3.B, 1.9×3.B); a later serve→**wrong**
sets `fragile=true` with **tier unchanged** (INV-6).

### One Dev fix was required to get here

The confirm-transfer serve initially 500'd with `item_details_failed`. Root
cause was **Dev schema drift, not the code**: `app.content_asset_metadata` and
`app.content_visual_requirements` (migrations `20260805100000` /
`20260805120000`) were recorded in Dev's migration ledger but did not exist as
objects, and the delivery layer (`deliverRows`) reads both. Recreated both from
their in-repo migrations (idempotent; RLS forced; service-role-only). No code
change, no function redeploy. **A ledger row is not proof the object exists —
pre-flight both tables on Prod before Phase 4.**

## 3. What still remains for the pilot

- ~~Prove the deployed loop live.~~ **Done 2026-08-26 (above).**
- Front-end build (Lovable) — the `/session` skill-rail, `StudentHomeSnapshot`,
  confidence-on-submit, and the confirm-transfer flow per
  `COURSE_MODE_CONFIRM_TRANSFER_FRONTEND_BRIEF.md` (the long pole).
- Prod promotion (Phase 4) — held for David's explicit go; pre-flight the two
  delivery tables on Prod.
