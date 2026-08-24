# Course Mode — Next-Session Resume Guide

STATUS: resume guide | DATE: 2026-08-24 (session 3) | AUDIENCE: the next session (LLM), and David.

Read this first, then `COURSE_MODE_STATUS_AND_HANDOFF.md` (the living map) and
`COURSE_MODE_LEARNING_MODEL.md` (decisions/invariants). This file is the "where
we left off + how to pick up" summary.

**SESSION-3 UPDATE (2026-08-24):** generator **Fix 1 landed** — the loader
(`scripts/course_mode_stats_generator/build_load_sql.py`) now stamps **every**
generated item `rubric_type='mcq'` (was NULL for computational items), so future
MCQ-served items route to `mcq_rule` and grade on choice-match without the manual
DB touch session 2 needed. `evaluator_strategy` stays split as an inert data marker
(computational items keep `data_driven_deterministic`; the persisted
`content_item_checks` are untouched, preserving a future numeric-entry option). This
matches the proven-live Dev config exactly. Regenerated `out/f4_load_DRAFT.sql` +
patched `out/lsrl_reload_DRAFT.sql` so a re-run can't reintroduce the bug. Code-only;
**no DB, no Dev/Prod touch** — the 3 released Dev lsrl items already carry the manual
`rubric_type='mcq'` from session 2, so nothing needs re-running there. §6.1 below is
now DONE; §6.3 (Prod `rubric_type='mcq'` on `7c5a2975`) is the remaining place the old
NULL still lives, gated behind the held Prod work.

---

## 0. TL;DR — where we are

The **full course-mode loop is proven live on Dev**: a real MCQ answered in the
app grades deterministically and promotes a mastery cell. Getting there this
session unblocked serving (an RLS recursion fix), figured out how to actually run
the app against Dev (local, port 5173), and fixed an MCQ-vs-numeric grading
mismatch. **Prod is untouched** — all Prod serving/hook work remains held for
David. A couple of security fixes are **staged but not applied**.

## 1. What was accomplished — session 2 (2026-08-24)

Prereq from session 1 (same day): `lsrl_predict` (cell 5.3×3.B, items
`apstat-lsrl_predict-005000/1/2`) was CM-D19-released on Dev **and** Prod, and the
backend reached Dev↔Prod parity. Nothing served a student yet. Session 2:

1. **Dev serving switches flipped** (David's explicit go, Dev-only, reversible):
   epv `4e54bb4f` `draft→published`; `home_release_manifest` row added
   (`quick_start_enabled=true, minimum_published_items=3, allowed_unit_numbers={5}`);
   David's Dev `profiles.active_exam_pack_version_id=4e54bb4f`; entitlement already
   active. Gate proven open (`exam_pack_version_is_selectable` /
   `home_exam_pack_is_eligible` both true, compatible MCQ count = 3).
2. **RLS recursion fix — the real serving blocker** (`migration 20260824030000`,
   applied to Dev). Dev's `content_item_versions_select_published` policy used an
   INLINE subquery into `content_items`, whose `ci_select_assigned_reviewer` policy
   subqueries back → `42P17 infinite recursion` on EVERY authenticated read of
   published content (broke the student read path Dev-wide). Prod was fine because
   its version delegates to the SECURITY DEFINER helper `app.content_item_is_published()`.
   Fix converges Dev's policy to that Prod form (helper already existed on Dev).
   Verified: the front-end's exact `usePublishedMcqs` query now returns the 3 items.
3. **Figured out how to actually run the app against Dev** (see §4). The published
   app + ALL Vercel deploys point at **Prod** via the committed `.env`, so there is
   **no Dev-hosted app** — you must run `exam-buddy-wireframe` locally. Also: Dev
   edge functions enforce a CORS `ALLOWED_ORIGINS` allowlist that includes
   `localhost:5173`/`:3000` but NOT Vite's default `:8080` — run the dev server on
   **:5173** or every `functions.invoke` is browser-blocked.
4. **Proved the live write.** David logged in locally, answered `005000` → the loop
   fired: serve → `evaluate-attempt` (Dev v15) → `persistCellState` → a
   `student_cell_state` row on cell **5.3×3.B**.
5. **Fixed the MCQ grading mismatch (Fix 1).** The first graded answer came back
   `content_uncertain` (no evidence). Root cause (traced in `grading-router.ts`):
   `resolveGradingRoute` prioritizes explicit `evaluator_strategy` above `item_type`,
   and these items are `item_type='mcq'` but `evaluator_strategy='data_driven_deterministic'`
   (numeric), so a choice answer routed to the numeric verifier, which abstains
   ("no parseable number"). Fix: set **`rubric_type='mcq'`** on the 3 Dev items
   (rubric_type wins router priority 1 → `mcq_rule` → choice vs `mcq_choices.is_correct`).
   Confirmed: re-answered `005000` correctly → grade `status=graded` 1/1, cell
   promoted **`unseen → independent`** (weighted_evidence 0→1, event `correct`,
   last_attempt_id populated, next-due `decay`). **End-to-end loop fully proven.**
6. **Found a live answer-key exposure** (checked, staged fix, NOT applied):
   `app.mcq_choices` grants column SELECT on `is_correct`/`rationale` to
   `authenticated` on **Dev AND Prod** (`public.mcq_choices` is security_invoker), so
   any logged-in student can read the answer key for every published MCQ (proven live
   on Prod). A plain revoke would blind the reviewer UI (it reads those columns via
   the same grant), so the fix is coordinated — see §5.

## 2. Key IDs / facts

| Thing | Dev (`wmgjsdkphcyhngaffbqf`) | Prod (`pcntajvbdfqhbeewmdry`) |
|---|---|---|
| ap_statistics taxonomy_source_version | `dae3c72e-82ca-4960-9552-1b034bd347e5` | **same** |
| course-mode exam_pack_version (2026-27) | `4e54bb4f-695f-41be-ac06-745fe9ad8bcc` | `7c5a2975-8f0e-45b9-8fcc-7ec9b8d81ada` |
| David's user_id | `cda34c9d-80f3-43bb-b359-8413bad3ee2e` | `f5a26c6b-3566-4d58-9e97-979fbb947564` |
| `evaluate-attempt` edge fn | **v15, hook DEPLOYED** | **v54, hook NOT deployed** |
| Serving switches (epv/manifest/profile) | **FLIPPED — serving live on Dev** | held (untouched) |
| lsrl items `rubric_type` | **`mcq` (Fix 1 applied)** | still `NULL` (numeric route) |
| Dev publishable key (client-side, safe) | `sb_publishable_75zU2AprWByjZi83_Mzmqw_VdtqaAZt` | — |
| David's cell state | 5.3×3.B `tier=independent` (proven) | none |

## 3. What is DONE / proven vs still held

**Done + proven on Dev:** serving gate open, RLS read path fixed, local run recipe,
end-to-end graded MCQ + cell promotion. `main` is at the session's last commit
(RLS fix `51f7a4c`, staged security fix `0bb6ed9`, milestone logs `2cb39f0`/`f57956d`).

**Held / owned by David (do NOT do without explicit go):**
- **Prod serving switches** (epv `7c5a2975` publish + manifest + profile).
- **Prod `evaluate-attempt` hook deploy** (CLI-only; MCP can't — 23 files/287KB):
  `supabase functions deploy evaluate-attempt --project-ref pcntajvbdfqhbeewmdry --use-api --workdir "$PWD"`
- **Prod Fix 1** (`rubric_type='mcq'` on Prod's 3 items in `7c5a2975`) — Prod items
  still route to the numeric verifier and would grade `uncertain`.

## 4. How to run the Dev app locally (re-demo recipe)

There is no hosted Dev app. In a clone of `david-bloom/exam-buddy-wireframe`, create
`.env`:
```
VITE_SUPABASE_URL=https://wmgjsdkphcyhngaffbqf.supabase.co
VITE_SUPABASE_PUBLISHABLE_KEY=sb_publishable_75zU2AprWByjZi83_Mzmqw_VdtqaAZt
SUPABASE_URL=https://wmgjsdkphcyhngaffbqf.supabase.co
SUPABASE_PUBLISHABLE_KEY=sb_publishable_75zU2AprWByjZi83_Mzmqw_VdtqaAZt
SUPABASE_SERVICE_ROLE_KEY=<Dev service-role, from Supabase dashboard — the MCQ demo does NOT need it>
```
Then `npm install && npm run dev -- --port 5173 --strictPort` (MUST be an
allowlisted port — 5173 or 3000, NOT 8080). Log in as David's Dev account, then go
to **`/session/mcq`** (NOT the generic `/session`, which is FRQ-only via the absent
`select_practice_frqs`). The MCQ route uses `usePublishedMcqs` (direct RLS read) +
`useGradePractice` (→ `evaluate-attempt`). Answer an lsrl item → verify a
`student_cell_state` write for user `cda34c9d…`.

## 5. Staged security fix — mcq_choices answer-key (NOT applied)

Full plan in `docs/security/MCQ_ANSWER_KEY_COORDINATED_FIX.md`. Three parts,
sequenced (do NOT reorder):
- **PART 1** — `migration 20260824040000_reviewer_mcq_answer_key_rpc.sql` (additive,
  written, NOT applied): SECURITY DEFINER RPC `public.get_review_mcq_choices(uuid)`
  returns is_correct/rationale only to an assigned reviewer/admin.
- **PART 2** — repoint the `exam-buddy-wireframe` reviewer read (`review.functions.ts`)
  at the RPC (Lovable prompt in the doc), publish.
- **PART 3** — `REVOKE SELECT (is_correct, rationale) ON app.mcq_choices FROM
  authenticated, anon` (SQL staged in the doc, deliberately NOT in `migrations/` so it
  can't be db-pushed to Prod before PART 2 lands). Apply Dev + Prod LAST.

## 6. Next steps / open decisions (David's call)

1. **Generator fix — ✅ DONE (session 3).** The loader now stamps every generated item
   `rubric_type='mcq'`, so future MCQ-served items route to `mcq_rule` without a manual
   DB touch. `evaluator_strategy` kept split as an inert data marker (computational →
   `data_driven_deterministic`); `content_item_checks` unchanged. No re-release needed
   for the 3 Dev lsrl items — they already carry the manual `rubric_type='mcq'`.
2. **Design question** — these items now grade purely on choice-match; their numeric
   `content_item_checks` verification is unused. Fine if course-mode practice stays
   **MCQ**; revisit if you want **numeric-entry** serving (your earlier stated intent —
   would need a front-end change + conflicts with the MCQ serving gate).
3. **Prod propagation** — when ready: Prod hook deploy + Prod serving switches + Prod
   `rubric_type='mcq'` on `7c5a2975`'s 3 items.
4. **Sequence the mcq_choices coordinated fix** (§5).
5. **Release more templates** — generator has 8 procedures; only `lsrl_predict` is
   released. Each needs SME 20-sample review + ≥100 property attestation + CM-D19
   release. (Re-run property harness at ≥100; default per-proc 80 is below the bar.)
6. **F2/F3 tunables** in `cell-state.ts` are Phase-1 defaults — calibrate once real
   attempts flow.

## 7. Gotchas

- Published app / all Vercel deploys = **Prod**; no Dev-hosted app (run locally, §4).
- Dev edge-fn CORS allowlist = `localhost:5173`/`:3000` only (not `:8080`).
- `/session/mcq` is the course-mode MCQ path; `/session` (use-session.ts) is FRQ-only.
- Dev migration ledger can't be trusted — verify objects directly (e.g. the
  unit-gated selector & `select_practice_frqs` are absent on Dev; serving uses the
  front-end's direct RLS read instead).
- `released_by`/`approved_by` must be a user_id in *that env's* `app.profiles`.

## 8. How to resume (copy-paste prompt)

> Continue the Cramapple Course Mode work. Read
> `docs/teaching/COURSE_MODE_NEXT_SESSION_PROMPT.md` first for the 2026-08-24
> (session 2) state. The full loop is proven live on Dev (serving works, an MCQ
> grades and promotes cell 5.3×3.B); Prod is untouched and all Prod serving/hook
> work is held for me. Do NOT touch Prod or apply the staged mcq_choices fix without
> my explicit go. Pick up with: [choose one] (a) apply Fix 1 in the generator
> (`rubric_type='mcq'` for MCQ-served items) so new items grade without a manual
> touch; or (b) release the next generator template through the D8/CM-D19 flow; or
> (c) sequence the mcq_choices answer-key coordinated fix
> (`docs/security/MCQ_ANSWER_KEY_COORDINATED_FIX.md`); or (d) something I'll specify.
