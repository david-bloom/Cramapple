# Course Mode — Finish the AP Stats Unit 1 Pilot: Next-Session Guide

STATUS: resume guide | DATE: 2026-08-25 | AUDIENCE: the next session (LLM) + David.

> **UPDATE 2026-08-26 — read `COURSE_MODE_STATS_UNIT1_LOOP_PROOF_2026_08_26.md` first.**
> Verified live on Dev: **[A] load and [B] CM-D19 release are already COMPLETE** (200
> published items, 10 releases at 20 stamped each; attestation is **flat**, not the
> nested shape in §2.4 below), and **[E]** hook is ACTIVE v16. The loop's promotion
> engine is proven locally for all 10 cells; the deployed end-to-end harness is
> delivered under `scripts/course_mode_loop_proof/` (run where egress allows). The
> §2 items below marked done there are historical.

Read this first, then — for detail — `COURSE_MODE_STATS_UNIT1_DEV_SERVING_RUNBOOK.md` (the wiring
steps + verified live Dev state), `COURSE_MODE_SESSION_ASSEMBLY_AND_ENTRY_FLOW_SPEC.md` (the session
UX), and `COURSE_MODE_STATS_UNIT1_PILOT_PLAN_2026_08_24.md` (the phased plan). All of this session's
work is **merged to `main`** (PR #123, merge commit `9b19fba`).

---

## 0. TL;DR — where the pilot stands

The whole **content + design substrate is done and green**; what remains to make a student do a real
Course Mode session is **David's SME sign-off → release → the front-end build → prove the loop**.
Nothing is served yet; Prod is untouched.

## 1. Done this session (all merged, PR #123)

- **Session experience designed** — `COURSE_MODE_SESSION_ASSEMBLY_AND_ENTRY_FLOW_SPEC.md`: entry
  points, top-N due-queue assembly, beat-by-beat run, wrap-up, and the two-column `/session`
  skill-rail (rail gated by coldness; the point-earning move ambient only in learn-first, otherwise
  surfaced in repair; no `/session/setup`). 3-state visual canvas built; sent to the Lovable
  front-end (`exam-buddy-wireframe` project `d334fed9`, plan mode) + its 5 build questions answered.
- **Pilot content (DRAFT, pending SME)** — `COURSE_MODE_STATS_UNIT1_SKILL_ORIENTATIONS.md` (10
  four-beat orientations) + `COURSE_MODE_STATS_UNIT1_WORKED_EXAMPLES.md` (10 open-hand parallel
  examples).
- **D8 evidence** — `COURSE_MODE_STATS_UNIT1_D8_REVIEW_PACK_2026_08_25.md`: harness GREEN (generator
  1100/16300/0 fail/0 reject; slot-frames 960/9600; loader `--check` 200/0) + a 20-instance sample
  per template for the SME pass.
- **Pilot load built** — `emit_pilot.py` + `out/f4_load_DRAFT.sql` = 200 packages (10 cells × 20,
  seeds matched to the D8 pack so **served == reviewed**; fresh seeds so no fail-closed collision).
- **Dev serving-wiring** (`COURSE_MODE_STATS_UNIT1_DEV_SERVING_RUNBOOK.md`): **[C]** security audit
  PASS, **[D]** manifest `allowed_unit_numbers` {5}→{1,5} applied (reversible), **[F]** David's Dev
  profile already points at the pack; **load-path smoke PASS** (rolled back, zero residue).

## 2. The remaining gates to finish the pilot (in order)

1. **David SME sign-off on the D8 pack (D2) — the key gate.** Review the 20/template samples; clear
   **0 defects** each. Explicitly resolve the flagged concern: some **computational distractors are
   wrong-statistic values** (e.g. an SD offered against a *mean* question on 1.7×3.B / 1.9×3.B) —
   decide if they're on-scale/plausible or need a generator tweak. Sign-off is what unblocks release.
2. **§7.1 guess-floor decision** (spec §7.1) — does a "Guessing" + correct MCQ earn full
   `independent`? Recommended: (b) require confirm-transfer before MCQ `independent`. Decides whether
   the confirm-transfer beat is mandatory and whether confidence affects tiering.
3. **[A] apply the full load to Dev** — `out/f4_load_DRAFT.sql` (1.8 MB) via **CLI/psql** (too large
   for the Supabase MCP): `psql "$DEV_DB_URL" -f scripts/course_mode_stats_generator/out/f4_load_DRAFT.sql`.
   Lands 200 unreleased drafts, cell-tagged, `rubric_type='mcq'`.
4. **[B] CM-D19 release per template** — after sign-off, `app.cm_d19_release_template(<id>, '4e54bb4f…',
   '{"sme":{"n":20,"defects":0},"property":{"n":120,"rejects":0},"verifier":0}'::jsonb, '<David Dev
   user_id>')` for each of the 10 (ids: `summary_stats`, `compare_stats`, `FB-U1-2-2A-VARIABLES-01`,
   `FB-U1-5-3A-GRAPH-01`, `FB-U1-6-4A-DISTRIBUTION-01`, `FB-U1-8-3A-BOXPLOT-01`,
   `FB-U1-11-2A-SAMPLING-01`, `FB-U1-12-2A-BIAS-01`, `FB-U1-13-2A-DESIGN-01`, `FB-4B-COMPARE-01`).
   Verify with the runbook §3[C] readiness audit.
5. **[E] confirm the `evaluate-attempt` hook is deployed on Dev** (docs: v15) — redeploy is CLI-only.
6. **Front-end build (Lovable, the long pole)** — review the plan the agent returned; build the
   `/session` skill-rail + the new `StudentHomeSnapshot` learning-state layer + confidence-on-submit.
   Reuse app tokens/components (don't copy the mock's hardcoded palette).
7. **Prove the loop on Dev (Phase 3)** — answer each of the 10 cells: serve → grade → cell promotion;
   miss → fragile/tier-unchanged; both grading paths. The lsrl proof widened to a real unit.
8. **Prod promotion (Phase 4 — held for David's explicit go)** — pack publish + manifest + active-epv
   + entitlements + the `evaluate-attempt` hook deploy (CLI).

## 3. Key IDs / facts (verified live Dev, 2026-08-25)

| Thing | Value |
|---|---|
| Dev project ref | `wmgjsdkphcyhngaffbqf` · Prod `pcntajvbdfqhbeewmdry` (untouched) |
| Course-mode exam-pack version (2026-27) | `4e54bb4f-695f-41be-ac06-745fe9ad8bcc` (published) |
| ap_statistics taxonomy_source_version | `dae3c72e-82ca-4960-9552-1b034bd347e5` |
| David's Dev user_id | `cda34c9d-80f3-43bb-b359-8413bad3ee2e` |
| Home manifest (course-mode pack) | quick_start=true, min_items=3, **allowed_units={1,5}** |
| Loaded pilot cells on Dev (pre-[A]) | only 1.7×3.B + 1.9×4.B (draft); the other 8 load via [A] |
| Front-end (Lovable) | `exam-buddy-wireframe` project `d334fed9-5a97-4e76-906e-7c0ad7082212` |

## 4. Housekeeping carried over

- **Branch deletions (David — agent is org-policy 403-blocked):** cramapple
  `codex/image-workflows-design-sketch`; exam-buddy-wireframe `codex/task0018-recognized-home`,
  `codex/task0019-session-targets`, `fix/gold-set-question-parts`. Keep `archive/*` in both.
- **Runbook step [C] correction:** the loader stamps `rubric_type='mcq'` on **all** items (incl. the
  two computational cells) — the proven-live choice-match config; numeric checks are the inert
  substrate.

## 5. Resume prompt (copy-paste)

> Continue the Cramapple Course Mode pilot. Read
> `docs/teaching/COURSE_MODE_PILOT_FINISH_NEXT_STEPS_2026_08_25.md` first. Everything is merged to
> `main`; Dev has [C]/[D] applied and the load built but NOT applied; nothing is released or served;
> Prod is untouched. Pick up with: [choose] (a) I've SME-signed the D8 pack — apply the load (CLI)
> and run CM-D19 release for the 10 templates on Dev, then prove the loop; or (b) settle the §7.1
> guess-floor decision; or (c) review the Lovable front-end plan and proceed with the build; or (d)
> something I'll specify.
