# Course Mode — Unit 1 pilot loop proof

Two complementary proofs that the AP Stats Unit-1 Course Mode loop
(**serve → grade → cell promotion**, and **miss → fragile / tier-unchanged**)
works for all 10 released pilot cells on Dev.

Released cells (exam-pack version `4e54bb4f-695f-41be-ac06-745fe9ad8bcc`,
20 published instances each, 200 total):

| template_id | cell (topic×skill) |
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

## 1. `run_local_engine_proof.ts` — offline engine proof (runs anywhere)

Drives the **real** deployed rule engine
(`supabase/functions/_shared/cell-state.ts` + `cell-state-signals.ts`, version
`cell-state-1.0`) using each cell's **real Dev provenance** (`fixtures.json`),
reproducing exactly the compute chain in `cell-state-persist.ts::applyToCell`.
For every cell it asserts:

- cold serve → **correct** (independent, changed-surface) → promotes `unseen → independent`, weight `1.0`;
- later serve → **wrong** → `fragile = true`, **tier unchanged** (INV-6, a miss reopens but never lowers).

No network, no DB writes.

```bash
bun run scripts/course_mode_loop_proof/run_local_engine_proof.ts
```

This proves the promotion engine, which is identical regardless of grading path.
It does **not** exercise the deployed grader or the DB write — that is script 2.

## 2. `run_e2e_harness.ts` — end-to-end proof against deployed Dev

Drives the actual deployed edge functions — `attempt-response`
(create → save → submit), `evaluate-attempt` (deterministic MCQ
choice-match grade → `persistCellState`), and `student-session-items`
(`confirm_transfer` → `app.select_confirm_transfer_item`) — as a throwaway
entitled test student, then reads back `app.student_cell_state` to confirm the
transition, for all 10 cells × both outcomes, **including the §7.1(b)
confirm-transfer beat** (a same-cell parallel item served + graded; numeric
cells 1.7×3.B / 1.9×3.B must fail closed). Requires the `student-session-items`
confirm-transfer branch to be deployed — see
`docs/teaching/COURSE_MODE_PILOT_PHASE1_2_RUNBOOK_2026_08_26.md`.

**Must run where egress allows `https://<project-ref>.supabase.co`.** The
authoring session could reach Dev only over SQL (Supabase MCP); the org egress
policy blocked the Supabase host, so the HTTP path (GoTrue + edge functions)
could not run there. Script 1 covers the engine offline; this covers the
deployed grader + DB write that script 1 cannot reach.

```bash
bun add @supabase/supabase-js
export SB_URL="https://wmgjsdkphcyhngaffbqf.supabase.co"      # Dev
export SB_ANON_KEY="<anon/publishable key>"
export SB_SERVICE_ROLE_KEY="<service_role key>"               # setup + verify only; never sent to edge fns
bun run scripts/course_mode_loop_proof/run_e2e_harness.ts
```

Safety: writes only to Dev, only under a throwaway `cm-loop-proof+<ts>@example.com`
student it provisions and deletes at the end (`KEEP_STUDENT=1` to retain).
Prod (`pcntajvbdfqhbeewmdry`) is never referenced. Point `STUDENT_EMAIL` at an
existing user only if you deliberately want the cell-state written to that profile.

## Status at authoring (2026-08-26, verified live on Dev)

- Load ([A]) and CM-D19 release ([B]) were **already complete** — 200 published
  pilot items, 10 `app.template_releases` rows (`revoked_at IS NULL`,
  `instances_stamped = 20` each), flat attestation
  `{sme_sample_n:20, sme_defects:0, property_instances:120, property_rejects:0, verifier_disagreements:0}`,
  bars `cm-d19-phase1-2026-08-23`. `evaluate-attempt` is ACTIVE v16.
- Script 1 executed here: **all 10 cells PASS**.
- Script 2 is ready to run from an egress-allowed environment.
