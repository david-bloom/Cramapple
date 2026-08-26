# Course Mode — AP Statistics Unit 1 Pilot Launch Plan

STATUS: launch plan | DATE: 2026-08-26 | AUDIENCE: David + Eng.
Verified live against Dev (`wmgjsdkphcyhngaffbqf`, 2026-08-26). Prod (`pcntajvbdfqhbeewmdry`) untouched.

Rendered view: a formatted version of this plan is published as a private Artifact
("Course Mode Pilot Launch"). This markdown file is the canonical, self-contained copy.

> **STATUS UPDATE — 2026-08-26**
> - **Phase 0 (merge & reconcile) — DONE.** Integration PR #128 merged to `main`; the 1.9×4.B
>   `template_id` reconciled to `slotframe_4b_compare` (matches live Dev); #125/#126/#127 closed as
>   superseded. No Dev re-load needed (load SQL byte-identical to Dev's source).
> - **Phase 1 (deploy serving to Dev) — DONE.** Migration `20260826120000`
>   (`app.select_confirm_transfer_item`) applied + verified on Dev; the `student-session-items`
>   edge function (confirm-transfer branch) deployed to Dev (v3 ACTIVE). `evaluate-attempt` v16.
> - **Dev schema drift repaired (2026-08-26).** `app.content_asset_metadata` and
>   `app.content_visual_requirements` (migrations `20260805100000` / `20260805120000`) were **stamped
>   in Dev's migration ledger but absent as objects** — the `student-session-items` delivery layer
>   (`deliverRows`) reads both, so the confirm-transfer serve 500'd with `item_details_failed`.
>   Both tables recreated on Dev from their in-repo migrations (idempotent `create table if not
>   exists`; RLS forced; service-role-only). No code change; no function redeploy. **Prod untouched
>   — verify these two tables exist on Prod before Phase 4.**
> - **Phase 2 (prove the loop on Dev) — DONE.** `run_e2e_harness.ts` drove the real deployed
>   functions for all 10 pilot cells: **10/10 PASS** — correct→independent, miss→fragile
>   (tier unchanged, INV-6), and the §7.1(b) confirm-transfer beat: the 8 non-numeric cells serve a
>   different same-cell MCQ that grades correct (cell stays independent); the 2 numeric cells
>   (1.7×3.B, 1.9×3.B) fail closed. See `COURSE_MODE_STATS_UNIT1_LOOP_PROOF_2026_08_26.md`.
> - **Next executable step:** Phase 3 — the Lovable front-end build (per
>   `COURSE_MODE_CONFIRM_TRANSFER_FRONTEND_BRIEF.md`). Prod stays untouched until Phase 4.
>
> **STATUS UPDATE #2 — 2026-08-26 (evening)**
> - **Phase 3 (front-end) — BUILT by David via Lovable** (project `d334fed9`): the real
>   confirm-transfer beat replaced the queue-advance workaround (17:05–17:28 UTC) and the app's
>   `.env` was repointed at **Prod** (18:47 UTC). Outstanding: **republish** (Vite bakes the
>   Supabase URL at build time — the published site calls Dev until rebuilt) + fresh Prod login.
> - **Phase 4 (Prod promotion) — David gave the go by executing it: COMPLETE except the
>   `evaluate-attempt` hook deploy.** David ran the F4 load + CM-D19 release (10 templates × 20,
>   18:43 UTC, his Prod user) and deployed `student-session-items` v17 (confirm-transfer branch
>   confirmed in the read-back source). This session then verified everything live, backfilled
>   `rubric_type='mcq'` on the 3 Prod lsrl items, added the `7c5a2975` manifest row
>   (units {1,5}, min 3), flipped David's profile to `7c5a2975`, and passed the readiness +
>   security + selector audits (numeric cells fail closed). ~~Remaining: the CLI-only
>   `evaluate-attempt` deploy.~~ **DONE ~20:37 UTC — v55 ACTIVE, bundle sha byte-identical to
>   the proven Dev v16 hook. Phase 4 exit gate MET.** Before a real session: Lovable republish
>   + fresh Prod login. Next: Phase 5 (pilot cohort entitlements + observation).
>   Full record: `COURSE_MODE_PROD_LOAD_RELEASE_RECORD_2026_08_26.md`.

---

## 0. Where the pilot stands (verified live on Dev)

- **[A] load + [B] CM-D19 release — DONE.** 200 published pilot items (10 cells × 20);
  10 active `template_releases` (`revoked_at IS NULL`), 20 stamped each; **flat** attestation
  `{sme_sample_n:20, sme_defects:0, property_instances:120, property_rejects:0, verifier_disagreements:0}`,
  bars `cm-d19-phase1-2026-08-23`. Manifest `allowed_units {1,5}`. `evaluate-attempt` hook **v16**.
- **§7.1 guess-floor — resolved, option (b)** (PR #125): an MCQ cell may **not** reach
  `independent` on a single cold-correct answer; a same-cell **confirm-transfer** question must
  also grade correct first. This is a **session-flow gate, not an engine change** — the
  `cell-state-1.0` engine still promotes on one correct attempt (proven), so the *flow* must
  withhold "counted independent" until confirm-transfer passes.
- **D8 SME sign-off — cleared, 0 defects** (PR #125). Flagged wrong-statistic distractors accepted
  as faithful-to-misconception.
- **Confirm-transfer serving — deployed + proven on Dev (2026-08-26).**
  `app.select_confirm_transfer_item` is live and verified; the `student-session-items`
  confirm-transfer branch is deployed to Dev (v3 ACTIVE). Tests + a frontend-only Lovable brief
  shipped in #127 (via #128).
- **Loop — engine-proven AND deployed-loop-proven (2026-08-26).** `cell-state-1.0` passes for all 10
  cells offline (`scripts/course_mode_loop_proof/run_local_engine_proof.ts`), and the **deployed**
  serve→grade→promote path (`run_e2e_harness.ts`) now passes **10/10 live on Dev**, including the
  §7.1(b) confirm-transfer beat (numeric cells fail closed). Getting there required recreating two
  Dev tables its ledger claimed but was missing (see the status update above).
- **Prod is untouched. Nothing is served to any student yet.**

---

## 1. RESOLVED — 1.9×4.B template-id conflict (integrated in #128)

**Done 2026-08-26:** reconciled to `slotframe_4b_compare` and merged via #128; verified no
`slotframe_u1_9_compare_justify` remains in `scripts/`/`supabase/`. The original problem, for the
record:

PR #125 tags the 4B frame `template_id = slotframe_u1_9_compare_justify`; PR #126 tags it
`slotframe_4b_compare`. Both edit `slot_frames.py` (same line) and regenerate the load, so the
second to merge **conflicts**. **Dev is already released under `slotframe_4b_compare`** — that is
the value in the live `template_releases` row and in every 4B item's provenance. If
`slotframe_u1_9_compare_justify` reaches `main`, the generator diverges from the live release and
the 4B cell breaks (no serve/release match; confirm-transfer + loop fail for that cell).

**Resolution (applied): kept `slotframe_4b_compare` everywhere.** Full rationale in
`COURSE_MODE_PILOT_MERGE_RESOLUTION_2026_08_26.md`.

---

## 2. The three PRs, reconciled

| PR | Branch | Carries | Merge note |
|---|---|---|---|
| **#126** | `…load-release-ucvs4a` | Load-scoped loader invariant (`_f4_loaded_civ`); 4B id `slotframe_4b_compare`. Matches live Dev. | **Merge first** — its generator/load values are the source of truth. Touches only `slot_frames.py`, `build_load_sql.py`, `out/`. |
| **#125** | `…review-xwpizb` | §7.1(b) decision + D8 sign-off (docs); 4B id `slotframe_u1_9_compare_justify` (wrong). | Resolve `slot_frames.py` + `out/` to keep #126's 4B id; keep #125's **docs/decision**. |
| **#127** | `…load-release-o65xog` | Load/release verification + loop proof; confirm-transfer serving (migration + `student-session-items` + tests); frontend brief; this plan. | Merge last. Only `COURSE_MODE_PILOT_FINISH_NEXT_STEPS_2026_08_25.md` overlaps #125 — keep both. |

After all three land: regenerate is **not** required (take #126's `out/`), but run the generator
harness to confirm green, and grep the load SQL for the 4B id (see the resolution doc).

---

## 3. Launch sequence

### Phase 0 — Merge & reconcile · ✓ DONE (2026-08-26 · #128) · Owner: Eng (repo)
- Merge **#126 → #125 → #127**, resolving 4B to `slotframe_4b_compare` and keeping #126's
  load-scoped invariant (per the resolution playbook).
- Keep both sides' additive edits in `COURSE_MODE_PILOT_FINISH_NEXT_STEPS_2026_08_25.md`.
- Run the generator harness green; grep the load SQL for the correct 4B id.
- **Exit gate:** `main` green · `out/f4_load_DRAFT.sql` consistent with live Dev · no
  `slotframe_u1_9_compare_justify` anywhere.

### Phase 1 — Deploy the serving change to Dev · ✓ DONE (2026-08-26) · Owner: Eng (CLI · Supabase)
- ✓ Migration `20260826120000_course_mode_confirm_transfer_item_selector.sql` applied to Dev (ledger
  version aligned); `app.select_confirm_transfer_item` verified live (service-role-only ACL; 1.2×2.A
  returns a same-cell MCQ; 1.7×3.B & 1.9×3.B fail closed; 1.9×4.B not excluded).
- ✓ `student-session-items` edge function (confirm-transfer branch) deployed to Dev via
  `supabase functions deploy … --use-api --workdir "$PWD"` (v3 ACTIVE). `evaluate-attempt` already
  v16 — no redeploy.
- ✓ **Dev schema drift repaired** — `app.content_asset_metadata` + `app.content_visual_requirements`
  (`20260805100000` / `20260805120000`) were ledger-stamped but missing as objects; recreated from
  their in-repo migrations so the delivery layer (`deliverRows`) stops 500ing. Prod untouched.
- The Deno handler tests + `supabase/tests/confirm_transfer_item_selector.integration.sql` run in CI;
  the selector's assertions were also executed directly against live Dev (passed).
- Do **not** re-run the load/release — already applied and verified on Dev.
- **Exit gate:** ✓ migration applied + verified · ✓ `student-session-items` deployed · ✓ delivery
  tables present on Dev.

### Phase 2 — Prove the loop on Dev · ✓ DONE (2026-08-26) · Owner: Eng (egress-allowed environment)
- ✓ Ran `scripts/course_mode_loop_proof/run_e2e_harness.ts` (via `run.sh`) against Dev from a
  local CLI: **10/10 cells PASS** through the real deployed `attempt-response` + `evaluate-attempt`
  + `student-session-items`.
- ✓ serve → grade → cell promotion for all 10 cells; miss → fragile / tier-unchanged (INV-6).
- ✓ **§7.1(b) confirm-transfer beat verified e2e:** the 8 non-numeric cells serve a *different*
  same-cell MCQ (via `select_confirm_transfer_item`) that grades correct and the cell stays
  independent; the 2 numeric cells (1.7×3.B, 1.9×3.B) fail closed (no item). Full table in
  `COURSE_MODE_STATS_UNIT1_LOOP_PROOF_2026_08_26.md`.
- **Exit gate:** ✓ all 10 cells pass both grading paths live · ✓ confirm-transfer beat verified e2e.

### Phase 3 — Front-end build (Lovable) — the long pole · Owner: Lovable + David · no Lovable Cloud
- Build the `/session` skill-rail, the `StudentHomeSnapshot` learning-state layer, and
  confidence-on-submit. Reuse app tokens/components — not the mock's palette.
- Implement the confirm-transfer flow per `COURSE_MODE_CONFIRM_TRANSFER_FRONTEND_BRIEF.md`
  (`beginConfirmTransfer`/`finishConfirmTransfer`, don't reuse `moveOn()`, progress stays
  `Question k of N` and advances once).
- Enforce §7.1(b): confirm-transfer is **mandatory** before a cell counts as independent; a
  fail-closed no-match closes the item honestly, never a false "same skill" claim.
- **Exit gate:** a test student completes a real Course Mode session on Dev end to end.

### Phase 4 — Promote to Prod · *held for David's explicit go* · Owner: Eng (CLI)
- Deploy migrations + `evaluate-attempt` + `student-session-items` to Prod.
- **Pre-flight the delivery tables on Prod:** confirm `app.content_asset_metadata` and
  `app.content_visual_requirements` actually exist as objects (the Dev drift showed a ledger row is
  not proof) — `select to_regclass('app.content_asset_metadata'), to_regclass('app.content_visual_requirements');`
  must return both, else `student-session-items` will 500 on serve.
- Apply the F4 load to Prod via `psql`, then CM-D19 release the 10 templates with the flat
  attestation under David's Prod user.
- Flip Prod governance: publish the exam-pack version, manifest `allowed_units {1,5}`, pilot
  users' active-epv + entitlements.
- Re-run the security audit on Prod (no `grading_results` answer-key leak; students never see
  `is_correct`).
- **Exit gate:** Prod readiness audit green · 200/200 loop-ready · access still gated.

### Phase 5 — Run the pilot & observe · Owner: David + Eng
- Grant entitlements to the pilot cohort; open access.
- Watch: grading spot-audit (bars set a monthly rate), `evaluate-attempt` logs, the OpenAI daily
  cap (FRQ path; MCQ grades deterministically), and that cell promotions look sane.
- Success signal: pilot students complete sessions, the loop tiers correctly, no answer-key
  exposure, grading within tolerance.
- **Rollback:** `cm_d19_revoke_template_release` per template · manifest back to `allowed_units {5}`.
  Both reversible, learner-invisible once revoked.

---

## 4. Go / no-go gates

| Before you… | Confirm |
|---|---|
| Merge the PRs | 4B id resolves to `slotframe_4b_compare`; regenerated load harness green. |
| Prove the loop on Dev | Migration applied, function deployed, selector integration test passing. |
| Start the front-end build | Live loop proven on Dev, including the confirm-transfer beat (§7.1 b). |
| Promote to Prod | A real Dev session works end to end; David gives an explicit go. |
| Open access to students | Prod readiness audit green; rollback path (revoke + manifest) rehearsed. |
