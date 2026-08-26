# Course Mode — Unit 1 Pilot: PROD Load/Release Record (Phase 4)

STATUS: promotion record | DATE: 2026-08-26 (evening) | AUDIENCE: David + next session.
Prod project `pcntajvbdfqhbeewmdry`. Companion to `COURSE_MODE_PILOT_LAUNCH_PLAN_2026_08_26.md`
(Phase 4) and `COURSE_MODE_STATS_UNIT1_LOOP_PROOF_2026_08_26.md` (the Dev proof this promotes).

## 0. TL;DR

Phase 4 (Prod promotion) is **complete except ONE step**: the `evaluate-attempt`
**hook deploy** (CLI-only — see §3). David ran the Prod load + CM-D19 release and the
`student-session-items` deploy himself this evening; this session verified all of it live,
applied the three remaining serving switches (lsrl `rubric_type` backfill, manifest row,
profile flip), and passed the readiness + security audits. **Until §3 is run, an answered
MCQ on Prod grades correctly but writes NO `student_cell_state` row** — the mastery loop
is broken at its last step, exactly the pre-hook state Dev was in before 2026-08-24.

## 1. What David executed (verified live, not re-run)

- **[A] F4 load + [B] CM-D19 release — DONE on Prod, 2026-08-26 18:43 UTC.**
  10 `app.template_releases` rows for epv `7c5a2975-8f0e-45b9-8fcc-7ec9b8d81ada`,
  `instances_stamped = 20` each, `revoked_at IS NULL`, released_by David's Prod user
  (`f5a26c6b-…`), bars `cm-d19-phase1-2026-08-23` (plus the 2026-08-24 `lsrl_predict`
  release of 3). Exam-pack version status `published`.
- **`student-session-items` deployed to Prod — v17 ACTIVE, 2026-08-26 20:42 UTC.**
  Deployed source read back and confirmed to carry the confirm-transfer branch
  (`confirm_transfer` request shape → `app.select_confirm_transfer_item`). The
  ezbr sha differs from Dev v3 only by bundle path prefix, not code.
- **Migration objects present on Prod:** `app.select_confirm_transfer_item(uuid,uuid)` ✓;
  the two delivery tables the Dev drift lesson said to pre-flight —
  `app.content_asset_metadata` + `app.content_visual_requirements` — **exist as objects** ✓.
- Front-end: Lovable project `d334fed9` repointed at Prod via `.env` (18:47 UTC) and the
  confirm-transfer beat built (17:05–17:28 UTC). **Caveat:** Vite inlines `VITE_SUPABASE_URL`
  at build time — the published site keeps calling Dev until David **republishes**, and the
  browser needs a fresh Prod login (the Lovable agent confirmed no Dev URL remains in source).

## 2. What this session applied (2026-08-26, via Supabase MCP)

1. **Prod Fix 1 — `rubric_type='mcq'` on the 3 `lsrl_predict` items** in `7c5a2975`
   (`1856226a…`, `a84f7601…`, `d73ec98d…`). They were still NULL → would have routed to the
   numeric verifier and graded `content_uncertain` (the session-2 Dev bug).
2. **`home_release_manifest` row for `7c5a2975`** — `quick_start_enabled=true`,
   `minimum_published_items=3`, `allowed_unit_numbers={1,5}`, `criterion_starter_enabled=false`,
   updated_by David. (Mirrors the proven Dev manifest.)
3. **David's Prod profile** `active_exam_pack_version_id`: `548f06be…` (2026 pack) →
   **`7c5a2975`**. His ap-statistics entitlement is `active` (beta tier, no end date) — access
   stays entitlement-gated; no pilot-cohort entitlements were granted (that is Phase 5).

### Audits (all green, run after the writes)

- **Readiness:** 200/200 pilot items `published` + `question_review_approved` +
  `rubric_type='mcq'` + `item_type='mcq'`; 10 templates; 200/200 well-formed 4-choice MCQs with
  exactly one correct; 200 cell tags across exactly the 10 pilot cells.
- **Serving gates:** `exam_pack_version_is_selectable('7c5a2975')` = true;
  `home_exam_pack_is_eligible('7c5a2975')` = true; 203 published MCQs.
- **Confirm-transfer selector (live RPC):** 1.2×2.A and 1.9×4.B return a same-cell candidate;
  numeric cells 1.7×3.B and 1.9×3.B **fail closed** (0 rows) — identical to the Dev proof.
- **Security:** `authenticated` holds NO table grant on `app.mcq_choices` or
  `app.grading_results`; column grants exclude `is_correct`/`rationale` and
  `shadow_result`/`raw_model_response`; `public.grading_results` view carries neither secret
  column. No answer-key exposure.

## 3. THE ONE REMAINING STEP — deploy the `evaluate-attempt` hook (David, CLI)

Prod `evaluate-attempt` is still **v54 (pre-hook, 19 files)** — read back and probed: no
`persistCellState`, no `cell-state*`, no `data_driven` branch, no deterministic verifier.
The MCP cannot carry the 23-file/287KB bundle (established 2026-08-24), so this is the same
CLI form used for `student-session-items` tonight, from a Cramapple clone on current `main`:

```bash
cd <Cramapple clone> && git checkout main && git pull
supabase functions deploy evaluate-attempt --project-ref pcntajvbdfqhbeewmdry --use-api --workdir "$PWD"
```

The repo `main` sources were verified **byte-identical** to the Dev v16 bundle (the exact
code the 10/10 Dev e2e loop proof ran against), so this deploy converges Prod to proven code.
Function secrets (`ALLOWED_ORIGINS` etc.) are env-level and survive the redeploy.
**Until this runs, don't treat any Prod answers as counting toward mastery** — they will
grade but write no cell state (and there is no backfill for attempts made pre-hook: mastery
is at-most-once per attempt, keyed to the grade event).

Verify after: `supabase functions list --project-ref pcntajvbdfqhbeewmdry` → version 55+, ACTIVE;
then answer one item and confirm a row:
`select * from app.student_cell_state where user_id='f5a26c6b-3566-4d58-9e97-979fbb947564';`

**Rollback:** this session saved the exact v54 bundle (19 files) before any change
(session scratchpad `prod_ea_v54_rollback/`); a redeploy of those files restores the
pre-hook grader byte-for-byte. Content/serving rollback stays as documented:
`app.cm_d19_revoke_template_release(template, epv, revoked_by)` per template, delete the
`home_release_manifest` row, repoint the profile at `548f06be…`.

## 4. State table (verified live, 2026-08-26 ~20:30 UTC)

| Thing | Prod value |
|---|---|
| epv `7c5a2975` | published; 203 published item versions (200 pilot + 3 lsrl) |
| `template_releases` | 11 active (10 pilot @20 + lsrl @3), none revoked |
| `rubric_type` | **all 203 = 'mcq'** (3 lsrl backfilled this session) |
| Manifest `7c5a2975` | quick_start, min 3, **units {1,5}** (added this session) |
| David's profile | active_epv = **`7c5a2975`** (flipped this session) |
| `student-session-items` | **v17 ACTIVE — confirm-transfer branch confirmed** |
| `evaluate-attempt` | **v54 — PRE-HOOK. §3 pending** |
| `select_confirm_transfer_item` | live; numeric cells fail closed ✓ |
| Delivery tables (`content_asset_metadata`, `content_visual_requirements`) | both exist ✓ |
| `app.student_cell_state` | exists, `last_attempt_id` present, 0 rows |
| Answer-key exposure | none (mcq_choices + grading_results audits green) |

## 5. After §3 lands

Exit gate for Phase 4 is then met (readiness green, 200/200 loop-ready, access
entitlement-gated). Next: David republishes the Lovable app (Prod URL bake) + signs in
against Prod, runs a real Course Mode session end-to-end, then Phase 5 (pilot cohort
entitlements + observation) per the launch plan.
