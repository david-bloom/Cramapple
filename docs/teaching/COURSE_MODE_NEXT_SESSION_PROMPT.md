# Course Mode — Next-Session Resume Guide

STATUS: resume guide | DATE: 2026-08-24 | AUDIENCE: the next session (LLM), and David.

Read this first, then `COURSE_MODE_STATUS_AND_HANDOFF.md` (the living map) and
`COURSE_MODE_LEARNING_MODEL.md` (decisions/invariants). This file is the "where
we left off + how to pick up" summary for the 2026-08-24 session.

---

## 1. What was accomplished (2026-08-24)

The pilot template `lsrl_predict` (LSRL prediction, cell 5.3×3.B) went from
draft to **released on BOTH Dev and Prod**, and the whole course-mode backend
reached **Dev↔Prod parity**. Specifically:

1. **First live CM-D19 release.** David SME-reviewed the 20-instance sample
   (two credibility passes) and approved 3 rebuilt credible items
   (`apstat-lsrl_predict-005000/1/2`: seedling-height cm, used-car $7.68k @ age 8,
   ad-spend→revenue — all inside their credibility envelopes). They were loaded
   and CM-D19-stamped to `published` + `review_status='question_review_approved'`.
2. **CM-D19 two-phase publish bugfix** (`migration 20260824010000`). The first real
   stamp exposed that the function jumped `draft→published` in one UPDATE, which
   the standing `app.tg_content_pipeline_guard_publish` blocks (must go through
   `reviewed_approved`). The original fail-closed test only exercised the
   *rejection* path. Fixed with a two-phase `draft→reviewed_approved→published`
   stamp; idempotent; D8 gate/ledger/scoping unchanged.
3. **Security gate closed on Dev + Prod** (`migration 20260824020000`).
   `app.grading_results.shadow_result` (embeds the answer) and `raw_model_response`
   were client-readable via an `authenticated` table grant + owner-RLS. Because
   `public.grading_results` is `security_invoker=true` the grant is load-bearing,
   so the fix is surgical: revoke the table grant, re-grant SELECT on every column
   **except** those two. View still works; `service_role` untouched.
4. **Full Prod sync.** All 6 new-to-Prod course-mode migrations applied to Prod
   (F1 taxonomy, F4 checks/cells, F2/F3 `student_cell_state`, `last_attempt_id`,
   CM-D19, two-phase fix). The 3 `converge_*` migrations were already satisfied on
   Prod. David chose an **isolated** content home: a new Prod ap_statistics
   `2026-27` `exam_pack_version` (separate from the live 296-item `2026` pack),
   into which the 3 items were loaded + released.

**Nothing serves a student yet.** All released content sits behind the held
serving switches (below).

## 2. Key IDs / facts (verified this session)

| Thing | Dev (`wmgjsdkphcyhngaffbqf`) | Prod (`pcntajvbdfqhbeewmdry`) |
|---|---|---|
| ap_statistics taxonomy_source_version | `dae3c72e-82ca-4960-9552-1b034bd347e5` | **same** `dae3c72e-…` |
| course-mode exam_pack_version (2026-27) | `4e54bb4f-695f-41be-ac06-745fe9ad8bcc` | `7c5a2975-8f0e-45b9-8fcc-7ec9b8d81ada` |
| David's user_id (for `released_by`/profile) | `cda34c9d-80f3-43bb-b359-8413bad3ee2e` | `f5a26c6b-3566-4d58-9e97-979fbb947564` |
| `evaluate-attempt` edge fn | **v15, hook DEPLOYED** | **v54, hook NOT deployed** |
| lsrl_predict release | done (release `edde7473`) | done (release `9728aad1`) |
| ap-statistics subject_entitlement (David) | active | (check before serving) |
| D8 bars version | `cm-d19-phase1-2026-08-23` (SME 20/0, ≥100 prop/0, 0 verifier, 5/mo audit) | same |

Attestation used (truthful): `{sme_sample_n:20, sme_defects:0,
property_instances:200, property_rejects:0, verifier_disagreements:0}`. The 200
is lsrl-specific from the harness (`property_report(per_proc=200)` → 0/200); the
default per-proc 80 is below the ≥100 bar, so re-run at ≥100 for any new template.

**Gotcha:** `released_by`/`approved_by` must be a user_id present in *that env's*
`app.profiles` (Prod rejected David's Dev id via the `approved_by` FK). Look it
up per env by email `dbloom01@gmail.com`.

## 3. Two things still owned by David (both held on purpose)

### A. Deploy the `evaluate-attempt` hook to Prod (CLI-only)
Prod's function is v54 without the live-write hook; MCP can't deploy it
(23 files/287 KB). From inside the repo on `main`:
```
supabase functions deploy evaluate-attempt --project-ref pcntajvbdfqhbeewmdry --use-api --workdir "$PWD"
```
(Dev already has the hook at v15.) Until this, a graded Prod attempt won't write
`student_cell_state`.

### B. Flip the serving switches (front-end enablement)
Held because David said he is "not ready for the front-end experience." The
serving gate (verified from `public.issue_session_target` +
`app.start_home_learning_session_for_user` + `enforce_session_target_home_eligibility`)
requires ALL of:
1. the course-mode `exam_pack_version.status = 'published'` (currently `draft`);
2. a row in `app.home_release_manifest` for that epv with `quick_start_enabled=true`
   and `minimum_published_items` ≤ the published count (only 3 lsrl items are
   published, so set the minimum ≤ 3) — **no manifest row exists yet**;
3. `app.profiles.active_exam_pack_version_id` = that epv for the user (currently null);
4. an active `app.subject_entitlement` for ap-statistics (Dev: David's is active).

**Fastest live demo = Dev** (hook already deployed): flip 1–4 for the Dev epv
`4e54bb4f` + David's Dev profile, answer one lsrl item in the app, and watch a
`student_cell_state` row get written (the end-to-end proof). Do NOT flip any of
these without David's explicit go.

**UPDATE 2026-08-24 (Dev switches FLIPPED, with David's explicit go):** conditions
1–3 are now done on Dev (epv `4e54bb4f` `published`; `home_release_manifest` row
`quick_start_enabled=true, minimum_published_items=3, allowed_unit_numbers={5}`;
David's Dev `profiles.active_exam_pack_version_id=4e54bb4f`); condition 4 was
already active. Gate proven OPEN at the DB level by simulating David's `auth.uid()`:
`exam_pack_version_is_selectable=true`, `home_exam_pack_is_eligible=true`,
compatible published MCQ count `=3`. **Prod untouched.** Rollback = un-flip the 3.

**But three serving-path gaps were found (surfaced, not patched):** (a) there is
**no server-side MCQ item-selector RPC on Dev** — the serving edge fn
`student-session-items` calls `select_practice_frqs`, which is **FRQ-only** and is
**absent from Dev**; `select_unit_gated_practice_items` (migration 20260804190000)
is also not deployed on Dev; (b) the 3 lsrl items have **no `serving`-scope
`content_taxonomy_labels` row** (only the `content_item_cells` cell tag, which
drives the hook, not serving selection); (c) so **how the app actually fetches an
MCQ item to display is a front-end-repo concern** (`exam-buddy-wireframe`), not
confirmable from the backend. The live `student_cell_state` write itself still
requires David authenticated in the app (evaluate-attempt = `requireProfile`, no
JWT minting). **Next: confirm the front-end's Dev MCQ fetch path (or add a server
selector + serving labels) before the answer-an-item step can succeed.**

## 4. Deferred / backlog (not blocking)

- **Release more templates.** The generator has 8 procedures; only `lsrl_predict`
  is released. The rest (one-prop CI, two-prop z, normal prob, summary stats,
  one-sample t-test, one-sample t-interval, chi-square) need their own SME
  20-sample review + a ≥100 property attestation + CM-D19 release (same flow).
  Two-sample t (4.7/4.10×3.E) and more Practice-4 slot-frames are the next
  generator adds.
- **F2/F3 tunables** in `cell-state.ts` are Phase-1 defaults, not calibrated —
  review once real attempts flow.
- **Home manifest / quick-start UX** and the per-cell micro-experience live in the
  **separate Lovable frontend repo** (`david-bloom/exam-buddy-wireframe`), not here.

## 5. Open PRs / branch state

- **PR #102** — merged to `main` (David). All 9 course-mode migrations now on main.
- **PR #103** (draft, open) — the `grading_results` security migration
  (`20260824020000`) + these docs, based on current `main`. CI green. Watched.
- Branch `claude/cramapple-course-mode-next-d420oh` currently carries the #103 work.

## 6. How to resume (copy-paste prompt)

> Continue the Cramapple Course Mode work. Read
> `docs/teaching/COURSE_MODE_NEXT_SESSION_PROMPT.md` first for the 2026-08-24
> state. `lsrl_predict` is released on Dev + Prod and the backend is at Dev↔Prod
> parity; nothing serves a student yet. Do NOT flip serving switches or deploy the
> Prod hook without my explicit go. Pick up with: [choose one] (a) enable the
> front-end serving demo on Dev end-to-end (publish epv `4e54bb4f`, add a
> `home_release_manifest` row, set my Dev `profiles.active_exam_pack_version_id`,
> confirm entitlement, then prove a live `student_cell_state` write); or
> (b) release the next generator template through the same D8/CM-D19 flow; or
> (c) something else I'll specify. PR #103 is the open follow-up.
