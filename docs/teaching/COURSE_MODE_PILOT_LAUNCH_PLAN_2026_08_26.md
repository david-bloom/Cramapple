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
> - **Phase 3 (front-end build, Lovable `exam-buddy` / cramapple.com) — BUILT; live QA moved to Prod.**
>   Dispatched the frontend-only brief (no Lovable Cloud). The confirm-transfer beat is now wired into
>   the **real** `/session` (`session.index.tsx → SessionFrame → use-session.ts`): a `use-session`
>   state machine (`beginConfirmTransfer`/`finishConfirmTransfer`) calls `student-session-items`
>   `confirm_transfer` and grades via `grade_transfer_attempt`, replacing the old queue-advance
>   workaround (cursor pinned, advance exactly once, miss→repair, no-match→honest close); MCQ choices
>   are fetched client-side (`is_correct` never projected). A second fix corrected pilot **skill
>   resolution** — it now parses the real content-key format so all 10 cells resolve (keyed by
>   topic+skill; 1.9×4.B non-numeric, so the beat fires; 1.7/1.9-3.B excluded). 313 + 328 tests green.
>   Also fixed: the confirm-transfer brief's `grade_attempt` → `grade_transfer_attempt` bug (PR #134).
> - **Phase 4 (promote to Prod) — IN PROGRESS (2026-08-26).** Doing live QA on **Prod** (cramapple.com)
>   rather than Dev, since cramapple.com already points at Prod and there are no students (rollback
>   intact). Done on Prod (`pcntajvbdfqhbeewmdry`): confirm-transfer RPC applied; `student-session-items`
>   reconciled (Prod's `unit_gated` + mcq-choices **plus** the confirm-transfer branch — repo had
>   diverged; PR #135) and deployed; `evaluate-attempt` + `grade_transfer_attempt` prompt-version + the
>   two delivery tables already present; **200 pilot items loaded** (psql) into the **draft** 2026-27
>   pack `7c5a2975` (isolated from the live "2026" pack `548f06be`); **10 templates CM-D19 released**
>   (20 each) under David's Prod user; pack `7c5a2975` **published**; front-end `.env` repointed to Prod
>   (legacy anon JWT). **Remaining:** entitle a throwaway Prod test student, confirm Prod
>   `ALLOWED_ORIGINS` lists cramapple.com, then run the live confirm-transfer QA.
> - **Deferred (Phase 4 completeness, not blocking QA):** the pilot pack's home/unit manifest
>   (`allowed_units {1,5}`) — the confirm-transfer MCQ path serves published items directly and does
>   not read it; and the Prod security re-audit.

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

### Phase 3 — Front-end build (Lovable `exam-buddy` / cramapple.com) · ◑ BUILT — live QA moved to Prod · no Lovable Cloud
- ✓ Confirm-transfer flow wired into the **real** `/session` (`session.index.tsx → SessionFrame →
  use-session.ts`): `beginConfirmTransfer`/`finishConfirmTransfer` call `student-session-items`
  `confirm_transfer` and grade via `grade_transfer_attempt` — **replacing the queue-advance
  workaround** that had shipped (which just relabeled the next queued item). Cursor pinned during the
  beat, advances exactly once, miss→repair, no-match→honest close. MCQ choices fetched client-side
  (`is_correct` never projected).
- ✓ **Skill resolution fixed** — parses the real content-key format (`apstat-u1-<t>-<s><letter>` + the
  named keys) keyed by (topic, skill), so all 10 pilot cells resolve; 1.9×4.B is non-numeric (beat
  fires), 1.7/1.9-3.B excluded. Without this the beat never fired on a normal session.
- ✓ Brief bug fixed: call 5 `grade_attempt` → `grade_transfer_attempt` (PR #134).
- Vitest suites green (313, then 328). Not yet built out: the broader `StudentHomeSnapshot` /
  confidence-on-submit polish and some session-setup routing nits (tracked, non-blocking for the beat).
- **Exit gate:** a test student completes a real Course Mode session **on Prod (cramapple.com)** end
  to end — moved from Dev because the Dev Supabase host CORS-blocks the Lovable origins and cramapple.com
  already points at Prod (no students, rollback intact).

### Phase 4 — Promote to Prod · ◑ IN PROGRESS (2026-08-26) · Owner: Eng (CLI + Supabase)
- ✓ **Pre-flight:** the two delivery tables (`content_asset_metadata`, `content_visual_requirements`)
  already exist on Prod (no drift here); `evaluate-attempt` already accepts `grade_transfer_attempt`
  and the prompt-version is published.
- ✓ Confirm-transfer RPC `select_confirm_transfer_item` applied to Prod.
- ✓ `student-session-items` **reconciled** — Prod's deployed v16 had `unit_gated` + mcq-choices that
  the repo lacked, so a straight deploy would have regressed it; merged both lineages (superset; PR
  #135) and deployed to Prod.
- ✓ **200 pilot items loaded** (psql) into the **draft 2026-27 pack `7c5a2975`** — isolated from the
  live "2026" pack `548f06be`. Fail-closed loader; distinct content-keys.
- ✓ **CM-D19 released** all 10 templates (20 instances each) under David's Prod user, flat attestation,
  bars `cm-d19-phase1-2026-08-23`.
- ✓ Pack `7c5a2975` **published**; front-end `.env` repointed to Prod (legacy anon JWT — Prod's auth,
  like Dev's, is safest with the legacy JWT).
- ◻ **Remaining:** entitle a throwaway Prod student (active-epv `7c5a2975` + beta Statistics); confirm
  Prod `ALLOWED_ORIGINS` lists `https://cramapple.com`; run the live confirm-transfer QA on cramapple.com.
- ◻ **Deferred (not blocking QA):** home/unit manifest `allowed_units {1,5}` (the MCQ path serves
  published items directly, ignoring it) and the Prod security re-audit (no `grading_results`
  answer-key leak; students never see `is_correct`).
- **Exit gate:** a real Prod session runs the beat end-to-end · access still gated (only pilot testers
  entitled) · rollback rehearsed (`cm_d19_revoke_template_release` per template · unpublish `7c5a2975`).

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
