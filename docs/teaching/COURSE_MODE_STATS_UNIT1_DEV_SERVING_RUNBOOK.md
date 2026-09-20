# Course Mode — AP Stats Unit 1 Dev Serving-Wiring Runbook

STATUS: **PREP — verified Dev state + staged steps. Executes nothing; every Dev write is held for David's go; releases are gated on SME sign-off.** | DATE: 2026-08-25 | AUDIENCE: David + the executing session.

**What this is.** The exact, ordered steps to wire the AP Statistics Unit-1 pilot to **serve on Dev**
(Phase 2 of `COURSE_MODE_STATS_UNIT1_PILOT_PLAN_2026_08_24.md` §7), grounded in the **live Dev
state read directly** on 2026-08-25 (the migration ledger is not trusted — objects verified in the
DB). Serving uses the **direct-RLS read path** (`usePublishedMcqs`-style), so a cell serves once its
items are **published + cell-tagged + correctly rubric-typed** in the active pack and the unit is in
the home manifest — no `validated` serving label needed (PILOT_PLAN §6, RESOLVED).

**Nothing here has been executed.** All SQL is staged for review. Prod is untouched and out of scope.

---

## 1. Verified Dev state (`wmgjsdkphcyhngaffbqf`, read-only, 2026-08-25)

| Thing | Value |
|---|---|
| Course-mode exam-pack version (2026-27) | `4e54bb4f-695f-41be-ac06-745fe9ad8bcc` — **status `published`**, exam date 2027-05-11 |
| ap_statistics taxonomy_source_version | `dae3c72e-82ca-4960-9552-1b034bd347e5` |
| Unit-1 taxonomy cells registered | **28** (registry present) |
| Home manifest for the course-mode pack | `quick_start_enabled=true`, `minimum_published_items=3`, **`allowed_unit_numbers={5}`** |
| David's Dev profile `active_exam_pack_version_id` | `4e54bb4f…` (already pointed at the course-mode pack) |
| David's Dev user_id | `cda34c9d-80f3-43bb-b359-8413bad3ee2e` |
| `student_cell_state` rows | 1 (the proven lsrl cell 5.3×3.B) |

**Pilot-cell readiness (via `content_item_cells` → `content_item_versions`):**

| Cell | Loaded? | status | review_status | rubric_type | Serving-ready? |
|---|---|---|---|---|---|
| 5.3×3.B (Unit 5, lsrl — reference) | yes (3) | **published** | **question_review_approved** | mcq | ✅ serving |
| 1.7×3.B *(numeric)* | yes (3) | draft | null | null (data_driven) | ❌ not released |
| 1.9×4.B *(MCQ)* | yes (4) | draft | null | mcq | ❌ not released |
| 1.9×3.B, 1.2×2.A, 1.5×3.A, 1.6×4.A, 1.8×3.A, 1.11×2.A, 1.12×2.A, 1.13×2.A | **NOT loaded** | — | — | — | ❌ not loaded |

**Bottom line:** of the 10 pilot cells, **2 are loaded-but-unreleased** and **8 are not loaded at
all**. Serving is currently gated to Unit 5 only (manifest `{5}`). The dominant blocker is content
release, not switch-flipping.

---

## 2. Dependency order (what unblocks what)

```
David SME sign-off on the D8 pack (D2)        ─┐
   (COURSE_MODE_STATS_UNIT1_D8_REVIEW_PACK)    │ gates
                                               ▼
[A] generate + load the 8 missing cells → all 10 present as drafts
                                               ▼
[B] CM-D19 release each pilot template → items published + approved
                                               ▼
[C] confirm rubric_type per serving form (mcq vs numeric)
                                               ▼
[D] manifest: add unit 1  +  [E] confirm hook deployed  ── David's go
                                               ▼
[F] prove the loop on Dev (answer each cell → cell promotes)
```

---

## 3. The steps (staged SQL — do not run without David's go)

### [A] Load the 8 missing pilot cells — *gated on generation; Dev write held*
Generate + build the load SQL from the generator, then apply as an unreleased draft load:
```bash
# in scripts/course_mode_stats_generator/
python3 build_load_sql.py            # regenerates out/f4_load_DRAFT.sql (fail-closed, drafts)
python3 build_load_sql.py --check    # must print: validated N packages, 0 problems
```
Then apply `out/f4_load_DRAFT.sql` to Dev (MCP `apply_migration` or psql). Lands each item as
`status=draft`, cell-tagged, with `rubric_type` stamped by the loader. **Result:** all 10 pilot
cells present as unreleased drafts. (1.7×3.B and 1.9×4.B are already loaded — the load is
idempotent per content_hash; verify no duplicates.)

### [B] CM-D19 release each pilot template — *gated on David's D8 SME sign-off (D2)*
For each of the 10 templates, after 0-defect SME sign-off on its 20-sample section:
```sql
select app.cm_d19_release_template(
  '<template_or_frame_id>',                     -- e.g. 'summary_stats', 'FB-U1-2-2A-VARIABLES-01'
  '4e54bb4f-695f-41be-ac06-745fe9ad8bcc',       -- course-mode epv
  '{"sme": {"n": 20, "defects": 0}, "property": {"n": 120, "rejects": 0}, "verifier": 0}'::jsonb,
  'cda34c9d-80f3-43bb-b359-8413bad3ee2e'         -- released_by = David's Dev user_id
);
```
Flips its instances to `status=published` / `review_status=question_review_approved` and records
`app.template_releases`. Reversible via `app.cm_d19_revoke_template_release(...)`.

### [C] Confirm rubric_type matches the serving form — *verify after [B]*
- **MCQ cells** (1.9×4.B + the 7 conceptual) must be `rubric_type='mcq'` (choice-match). 1.9×4.B
  already is; the loader's "Fix 1" stamps the rest.
- **Numeric-entry cells** (1.7×3.B, 1.9×3.B) serve via the deterministic verifier — keep
  `rubric_type=null` + `evaluator_strategy='data_driven_deterministic'` (this is the current 1.7×3.B
  state, which is correct for numeric serving).
```sql
-- readiness audit (run after release):
select cic.topic_code, cic.skill_code, civ.status, civ.review_status, civ.rubric_type, civ.evaluator_strategy
from app.content_item_cells cic
join app.content_item_versions civ on civ.id = cic.content_item_version_id
where cic.topic_code like '1.%' order by 1,2;
```

### [D] Add Unit 1 to the home manifest — *SAFE Dev config, reversible; held for David's go*
Currently `allowed_unit_numbers={5}`. Add Unit 1 (keep 5 so the lsrl proof still serves):
```sql
update app.home_release_manifest
set allowed_unit_numbers = '{1,5}', updated_by = 'cda34c9d-80f3-43bb-b359-8413bad3ee2e'
where exam_pack_version_id = '4e54bb4f-695f-41be-ac06-745fe9ad8bcc';
-- revert: set allowed_unit_numbers = '{5}'
```
`minimum_published_items=3` already satisfied once ≥3 Unit-1 items publish; `quick_start_enabled` is
already true. **No effect until items are published (step B)** — safe to set earlier or later.

### [E] Confirm the `evaluate-attempt` hook is deployed on Dev — *verify; redeploy is CLI-only*
The hooked function (`persistCellState` + `data_driven` real grading) must be the deployed Dev
version (docs: Dev **v15**). It can't be checked via SQL; verify in the Supabase dashboard/Edge
Functions, or smoke-test one graded write. If not current:
```bash
supabase functions deploy evaluate-attempt --project-ref wmgjsdkphcyhngaffbqf --use-api --workdir "$PWD"
```

### [F] Profiles / test students — *mostly done*
David's Dev profile already points at `4e54bb4f`. For any additional pilot tester:
```sql
update app.profiles set active_exam_pack_version_id = '4e54bb4f-695f-41be-ac06-745fe9ad8bcc'
where user_id = '<tester_user_id>';   -- ensure their entitlement is active
```

---

## 4. Pre-serve security gate (verify before a student answers)
Confirm students can't reach the answer key: students read grading only via the curated
`public.grading_results` view (excludes `shadow_result`), and the `app` schema is not REST-exposed to
`authenticated`. Audit grants:
```sql
select grantee, privilege_type
from information_schema.role_table_grants
where table_schema='app' and table_name='grading_results' and grantee='authenticated';
-- expect: no direct SELECT on app.grading_results for authenticated (or column-limited only)
```
(Release-gate finding from the write-hook QA; `mcq_choices` leak already fixed, PR #106.)

---

## 5. Prove-the-loop checklist (Phase 3, after wiring)
Run the app against Dev (local `:5173`, per NEXT_SESSION_PROMPT §4), log in as a test student, and
for **each pilot cell**: serve → answer correct → confirm a `student_cell_state` row writes/promotes;
answer wrong → confirm `fragile` + tier-unchanged; confirm numeric cells (1.7×3.B, 1.9×3.B) grade via
the deterministic verifier and MCQ cells via choice-match. Both grading paths, all 10 cells — the
lsrl proof widened to a real unit.

---

## 6. What is safe-now vs held
- **Safe/reversible on Dev (still held for David's go):** [A] load, [B] release (gated on SME), [C]
  audit, [D] manifest, [F] profiles. All Dev-only, learner-invisible until published, each reversible.
- **Needs a human/CLI:** [E] hook deploy (if not current); SME sign-off (D2).
- **Not in scope here:** any Prod switch (held); the front-end build (Lovable).

Re-verify §1 live before running any step — Dev state drifts.

---

## 7. Execution log

**2026-08-25 (David approved the safe/reversible Dev steps).**
- **[A] load — BUILT, not applied.** `emit_pilot.py` + `out/f4_load_DRAFT.sql` regenerated = 200
  pilot packages (10 cells × 20, seeds matched to the D8 pack so served==reviewed; fresh seeds so no
  content_key collision). Loader `--check`: 200 packages, 0 problems. **Not applied to Dev** — the
  1.8 MB load SQL exceeds the Supabase MCP inline limit; apply via CLI/psql (or a small MCP smoke
  subset). Correction to §3[C]: the loader stamps `rubric_type='mcq'` on **all** items (incl. the two
  computational cells) — the proven-live choice-match config; the numeric checks are the inert
  substrate.
- **[C] security audit — PASS.** `authenticated` has **no** direct SELECT on `app.grading_results`;
  `public.grading_results` view exists and does **not** expose `shadow_result`. No answer-key
  serve-blocker.
- **[D] manifest — APPLIED.** `home_release_manifest` for epv `4e54bb4f`:
  `allowed_unit_numbers` **{5} → {1,5}** (quick_start=true, min_items=3). Reversible: `set
  allowed_unit_numbers='{5}'`. Inert until Unit-1 items publish (step B).
- **[F] profile — no change needed.** David's Dev `active_exam_pack_version_id` already `4e54bb4f`.
- **[B] CM-D19 release — HELD.** Not run; gated on David's explicit D8 SME sign-off (the call records
  a 20/0 attestation under his name). Distractor-plausibility flag on the 2 computational cells still
  open for the SME pass.
- **Prod:** untouched.

- **Load-path smoke — PASS (rolled back, zero residue).** Ran a 2-item subset (1 computational +
  1 slot-frame) through the real loader body inside a `begin … rollback` on Dev: fail-closed epv +
  taxonomy resolution succeeded, and the transaction-local proof showed **2 unreleased versions, 2
  `rubric_type='mcq'`, 2 cell-tags (composite FK to `taxonomy_cells` held), 2 check rows, 8
  mcq_choices**, then rolled back — confirmed 0 `-SMOKE` rows persisted. Proves the F4 load path for
  the new pilot content end-to-end (DB plumbing); the full serve→grade→cell-promotion loop still
  needs [B] release + the front-end.

Nothing beyond [C]/[D] was written to Dev ([A] smoke was rolled back). [A] full apply and [B] release remain pending.

**2026-08-26 (verified live; corrects the line above).**
- **[A] load — DONE.** 200 published pilot items across the 10 templates in epv
  `4e54bb4f`, `item_type='mcq'`, all 4-choice (1 correct + 3 distractors, 0 malformed).
- **[B] CM-D19 release — DONE.** 10 `app.template_releases`, `revoked_at IS NULL`,
  `instances_stamped=20` each, released by David's Dev user on 2026-08-25. Attestation
  is **flat**: `{sme_sample_n:20, sme_defects:0, property_instances:120, property_rejects:0,
  verifier_disagreements:0}`, bars `cm-d19-phase1-2026-08-23`. (Re-running was avoided:
  the load is fail-closed on existing keys, and the release RPC stamps only `draft` items.)
- **[E] hook — DONE.** `evaluate-attempt` edge function ACTIVE v16 (≥ the doc's v15).
- **Prove-the-loop (§5) — engine PASS locally; deployed harness delivered.** The
  `cell-state-1.0` promotion engine passes for all 10 cells offline
  (`scripts/course_mode_loop_proof/run_local_engine_proof.ts`): correct→independent,
  miss→fragile/tier-unchanged. The deployed end-to-end path (real `attempt-response`
  + `evaluate-attempt`) is packaged as `run_e2e_harness.ts` — run from an
  egress-allowed environment; the authoring session's egress policy blocked the Dev
  Supabase host. See `COURSE_MODE_STATS_UNIT1_LOOP_PROOF_2026_08_26.md`.
- **Prod:** untouched.
