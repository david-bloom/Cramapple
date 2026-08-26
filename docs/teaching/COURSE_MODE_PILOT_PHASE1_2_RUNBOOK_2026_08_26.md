# Course Mode pilot — Phase 1 finish + Phase 2 loop proof runbook

DATE: 2026-08-26 · AUDIENCE: whoever has CLI + egress to the Dev Supabase host.
Companion to `COURSE_MODE_PILOT_LAUNCH_PLAN_2026_08_26.md`. Dev project ref
`wmgjsdkphcyhngaffbqf`. **Prod untouched.**

## Where this picks up

Already done on Dev (verified live):
- Load + CM-D19 release (200 items, 10 templates × 20), manifest `allowed_units {1,5}`,
  `evaluate-attempt` v16.
- **Migration `20260826120000`** — `app.select_confirm_transfer_item` applied + verified
  (service-role-only; 1.2×2.A returns a same-cell MCQ; 1.7×3.B & 1.9×3.B fail closed; 1.9×4.B not
  excluded).

Two steps remain, both need an environment this cloud session can't reach (CLI + egress to
`https://wmgjsdkphcyhngaffbqf.supabase.co`):

---

## Part A — Deploy `student-session-items` to Dev (CLI)

The confirm-transfer branch of the function is merged to `main` but not yet deployed. The RPC it
calls is already live (Part 0 above), so this is the last piece of the serving change.

**Prereqs**
- Supabase CLI installed and authenticated (`supabase login`).
- Run from the repo root (the CLI bundles the function's `../_shared/*` imports).
- No new secrets needed — the function reads `SUPABASE_URL` / `SUPABASE_ANON_KEY` /
  `SUPABASE_SERVICE_ROLE_KEY` / `ALLOWED_ORIGINS`, already set on Dev from the current deploy;
  a redeploy preserves them.

**Deploy**
```bash
supabase functions deploy student-session-items --project-ref wmgjsdkphcyhngaffbqf
```

**Verify**
```bash
supabase functions list --project-ref wmgjsdkphcyhngaffbqf   # version bumped, status ACTIVE
```
The change is behavior-preserving for the ordinary FRQ path (delivery was refactored into a shared
`deliverRows()`; the confirm-transfer branch only runs when a request carries `confirm_transfer`).
The end-to-end proof in Part B exercises both the ordinary grade path and the new branch.

**Rollback (if needed)**
```bash
git checkout <previous-sha> -- supabase/functions/student-session-items supabase/functions/_shared
supabase functions deploy student-session-items --project-ref wmgjsdkphcyhngaffbqf
git checkout main -- supabase/functions   # restore the working tree
```

---

## Part B — Prove the loop on Dev (Phase 2)

`scripts/course_mode_loop_proof/run_e2e_harness.ts` drives the **real deployed** functions for all
10 pilot cells and now also exercises the **§7.1(b) confirm-transfer beat**.

**Prereqs**
- An environment whose egress allows the Dev Supabase host.
- Bun (or Node ≥18 + `tsx`) and the client lib: `bun add @supabase/supabase-js`.
- Part A deployed (the confirm-transfer beat calls the updated `student-session-items`).

**Env** (never commit these)
```bash
export SB_URL="https://wmgjsdkphcyhngaffbqf.supabase.co"
export SB_ANON_KEY="<Dev anon/publishable key>"
export SB_SERVICE_ROLE_KEY="<Dev service_role key>"   # setup + verification only; never sent to edge fns
```

**Run**
```bash
bun run scripts/course_mode_loop_proof/run_e2e_harness.ts
# Node: npx tsx scripts/course_mode_loop_proof/run_e2e_harness.ts
```

**What it does, per cell** (as a throwaway `cm-loop-proof+<ts>@example.com` student it provisions
and deletes; pass `KEEP_STUDENT=1` to retain):
1. **correct** on instance A → `student_cell_state` promotes to `independent`.
2. **confirm-transfer** — calls `student-session-items` with `confirm_transfer:{source…}`; the
   deployed selector returns a **different same-cell** published MCQ; the harness grades it correct
   → the cell stays `independent`. For the **numeric** cells (1.7×3.B, 1.9×3.B) it asserts the
   selector **fails closed** (no item) — the correct behavior.
3. **wrong** on instance B → `fragile = true`, tier unchanged (INV-6).

**Expected**: a table with every cell `PASS`, ending
`OK — all 10 cells: correct→independent; confirm-transfer serves a same-cell item (numeric cells
fail closed) and grades correct; miss→fragile (tier unchanged).` Non-zero exit on any failure.

**What this proves vs. what it doesn't.** This proves the **backend** end-to-end: serving,
deterministic MCQ grading, cell-state promotion, and the confirm-transfer serving+grading path.
§7.1(b) itself — *withholding "counted independent" until confirm-transfer passes* — is a
**session-flow gate enforced in the front-end** (the cell-state engine still promotes on one correct
attempt). The front-end build (Phase 3, per `COURSE_MODE_CONFIRM_TRANSFER_FRONTEND_BRIEF.md`) is
what enforces that gate for a real student; this harness proves the serving/grading the front-end
depends on.

**Troubleshooting**
- `no-item!` on a non-numeric cell → Part A not deployed (the confirm-transfer branch isn't live), or
  the selector migration isn't applied. Re-check `supabase functions list` and
  `select to_regprocedure('app.select_confirm_transfer_item(uuid,uuid)')`.
- `LEAK!` on a numeric cell → the numeric exclusion isn't taking effect; re-check the deployed RPC.
- `budget_capped` / OpenAI errors → not expected (pilot items grade deterministically by
  choice-match); if seen, an item is mis-tagged as non-MCQ.

---

## After Part B passes

Phase 2 exit gate met. Next is Phase 3 (front-end build) then Phase 4 (Prod promotion, held for
David's go) — see the launch plan. Prod stays untouched until then.
