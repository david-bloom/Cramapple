# Course Mode — Release Path Decision Brief

STATUS: decision brief (SURFACE, not execute) | DATE: 2026-08-23 | AUDIENCE: David (decision-maker), LLM-first for the next session.
This brief lays out the path from "the write hook is merged" to "a student sees a graded course-mode cell update," names every gate on that path, marks who owns each, and gives a recommendation where one is mine to give. It **executes nothing**: no governance object is created, no release bar is set, the loader is not run, and CM-D19 stamping is not built. Those are David's calls; this is the map to them.

Companion docs: `COURSE_MODE_STATUS_AND_HANDOFF.md` (living map), `COURSE_MODE_LEARNING_MODEL.md` (decisions/invariants), `COURSE_MODE_PILOT_BUILD_PLAN.md` (D-numbers).

> **EXECUTION UPDATE — 2026-08-23 (later): decision taken — launch on DEV first; serving form = numeric-entry (David). The Dev backend pipeline is now fully in place.** Done in Dev (all reversible; Prod untouched): (1) `last_attempt_id` migration applied; (4) the `ap_statistics 2026-27` exam-pack version created — exam date **2027-05-11 (Tue)**, `status='draft'`, id `4e54bb4f-695f-41be-ac06-745fe9ad8bcc`; (5) the loader ran (David, via the SQL Editor) → **19 items / 19 check rows / 19 cell tags across 6 distinct cells, all `review_status NULL` (unreleased)**, split 15 `data_driven_deterministic` + 4 `rule_based_mcq`; (2) `evaluate-attempt` **deployed with the hook — now v15** (`ezbr_sha256 2d1f53df…`, up from v14; the deploy was run by David with `supabase functions deploy … --use-api --workdir "$PWD"` after a stray `~/supabase` folder kept hijacking the CLI workdir). **Remaining in Dev:** (3) the live "graded attempt → `student_cell_state` write" proof — one authenticated attempt fired through the deployed function (the hook runs inside the request path; SQL alone can't trigger it). **This session cannot fire it:** the egress policy blocks `wmgjsdkphcyhngaffbqf.supabase.co` (403 CONNECT) — the MCP tools use a different channel, but raw HTTP to the function/auth endpoints is denied, and per policy that must be reported, not routed around. A realistic *student-path* firing is release-gated anyway. **Verified instead (2026-08-23):** the data side of the hook is fully wired for the real seeded content — for `apstat-lsrl_predict-005000` (version `06a1b2fe…`), a graded numeric attempt resolves item→cell (`5.3×3.B`, cell present in the registry), grades via `content_item_checks` (kind `numeric`), and resolves subject (`19e1a256…`) via the `2026-27` exam-pack → `student_cell_state` would be written. Every join the live hook depends on resolves against real data. To actually fire it: (A) release one item (D8 + CM-D19) and answer it in the Dev app — the genuine proof; or (B) a synthetic curl against the deployed function from a host that can reach it (needs a user JWT + a prepared attempt/response row). RELEASE to students still gated on D8 + CM-D19 regardless.

---

## 0. TL;DR — what I need from you, and what is safe to do now

**Two things are safe to do NOW, are independent of the release decision, and have ZERO learner-visible effect** (they only wire up plumbing that stays dormant until content is released):
- **G1 → G2 → G3: apply the `last_attempt_id` migration to Dev, THEN deploy `evaluate-attempt`, then smoke-test one write.** The code is already merged to `main` (PR #101) but is **not deployed to Dev**, and the migration is **not applied**. Order is load-bearing (see §4). This can proceed without any release decision.

**Three decisions are yours and gate the actual content release** (nothing serves until all three land):
- **Decision A — D8 release bars** (validation sample sizes / property-test coverage / gold-regression thresholds). **RESOLVED 2026-08-25 (David): ratified as proposed** — see `COURSE_MODE_D8_RELEASE_BARS_PROPOSED_DEFAULTS_2026_08_25.md` and §5 below. CM-D19 stamping is now buildable against these bars. §5.
- **Decision B — the `ap_statistics 2026-27` exam-pack version in Dev** (a governance object needing an official exam date). The loader **cannot run without it** — it fail-closed aborts. David/Orly. §6.
- **Decision C — serving form** of the generated computational items: numeric-entry (data-driven verifier) vs MCQ (rule-based). Affects how the graded response is scored. §7.

**One security gate must close before ANY release** (not before deploy): the `app.grading_results` exposure — a student can currently read their own row's `shadow_result` (the answer key) *if* PostgREST exposes the `app` schema. Verify + close. §8.

**One thing must be built, and it is blocked on Decision A**: CM-D19 template-release stamping. §9.

---

## 1. Live state snapshot — verified against Dev `wmgjsdkphcyhngaffbqf`, 2026-08-23

All rows below were read directly from Dev this session (not inferred from the migration ledger, which is untrustworthy — CM-FACT / §6 of the handoff).

| Fact | Verified value | Implication |
|---|---|---|
| PR #101 (live write hook) | **MERGED to `main`** (merge commit `571f6a0`, 2026-08-23 17:13) | The handoff doc still calls it "draft/open" — **stale**; corrected here and in the handoff. |
| `evaluate-attempt` edge fn in Dev | **v14, last updated ~mid-July 2026** (before the hook existed) | The merged hook code is **NOT deployed**. Deploy is pending. |
| `app.student_cell_state.last_attempt_id` column in Dev | **ABSENT** | Migration `20260823150000` is **NOT applied**. Deploy-before-migration would silently no-op the whole hook (§4). |
| `ap_statistics` exam-pack versions in Dev | **`2025-26` only** (id `58280cf8…`); no `2026-27` | Loader `select … into strict` aborts → **cannot seed** (Decision B). |
| `app.taxonomy_cells` | **131** (F1 seed intact) | Cell registry ready. |
| `app.content_item_cells` / `app.content_item_checks` | **0 / 0** | No generated content loaded yet. |
| `app.student_cell_state` | **0 rows** | Hook has never written (consistent with "not deployed"). |
| `public.grading_results` view | **exists**, excludes `shadow_result` + `raw_model_response` | Correct curated surface. |
| `app.grading_results` grant to `authenticated` | **`SELECT` granted**, `shadow_result` column present, RLS enabled (owner-select) | **Leak surface** if `app` is REST-exposed (§8). |
| PostgREST exposed schemas | not set at role level → **project API config** (default excludes `app`) | Must be **verified in the dashboard**, not SQL. |
| Loader artifact | `out/f4_load_DRAFT.sql` present (184 KB); 19 sample packages emitted | Loader is **ready**; blocked only on Decision B. |

---

## 2. The one-line goal, and what "released" means

Goal: a graded AP Stats attempt on a **generated, released** item updates exactly one `student_cell_state` cell, with no per-instance human step. Everything below is the gap between the merged code and that goal.

"Released" = a `content_item_versions` row reaches `review_status='question_review_approved'` **and** carries a `validated` serving label, via the CM-D19 machine-stamp (§9). Until then every loaded item stays `review_status NULL` / `draft` and is never served — which is exactly why the hook and the loader are safe to have merged/prepared ahead of the release decision.

---

## 3. Critical path (ordered; owner in brackets)

```
  ┌─ NOW, release-independent, zero learner-visible effect ─────────────┐
  │  G1  apply last_attempt_id migration to Dev            [deploy]      │
  │  G2  deploy evaluate-attempt to Dev (AFTER G1)         [deploy]      │
  │  G3  smoke-test: one graded attempt lands one write    [deploy]      │
  └─────────────────────────────────────────────────────────────────────┘
        (the hook is now live but dormant — no released content to grade)

  ── gated on your decisions ────────────────────────────────────────────
   A   set D8 release bars                                 [DAVID]
   C   pick serving form (numeric-entry vs MCQ)            [DAVID]
   B   create ap_statistics 2026-27 exam-pack version      [DAVID/ORLY]
   S   close app.grading_results exposure (before release) [deploy/David]
   ↓
   D19 build CM-D19 template-release stamping (needs A)    [buildable once A set]
   ↓
   L   run loader → seed unreleased drafts (needs B)       [buildable once B set]
   ↓
   R   CM-D19-stamp the validated template's instances → served
   ↓
   ✅  released content + live hook → cell updates visible
```

G1–G3 do not depend on A/B/C/S; they can (and should) go first to de-risk the deploy in isolation. Everything from D19 down waits on the decisions.

---

## 4. Deploy-gate G1–G3 (PR #101, now merged) — DO-able now, SURFACED not executed

I did **not** apply the migration or deploy. These are the exact steps, in the one correct order, for whoever deploys.

**G1 — Apply the `last_attempt_id` migration to Dev FIRST.**
- File: `supabase/migrations/20260823150000_course_mode_live_write_hook_cell_state_last_attempt.sql` (additive, nullable `alter table app.student_cell_state add column if not exists last_attempt_id uuid`).
- **Why order matters (confirmed live):** the deployed hook reads/writes `last_attempt_id`. If `evaluate-attempt` is deployed *before* the column exists, every `student_cell_state` read/write errors → the hook's F1 guard SKIPs the write → **the entire hook silently no-ops** (grades are unaffected, so the failure is invisible). Deploy-before-migration is the trap the migration's own header warns about.

**G2 — Deploy `evaluate-attempt` to Dev (only after G1 verifies).**
- Deployed version is v14 (pre-hook). The merged `main` version splits `data_driven` into a real grading branch + calls `persistCellState`.

**G3 — Smoke-test one write lands.**
- Because there is no released generated content yet, the clean smoke test is a **manually cell-tagged throwaway** draft item (as the F4 core proof did on 2026-08-23, deleted after): grade one attempt, confirm exactly one `student_cell_state` row appears with a sane tier and a `last_attempt_id`, then delete the proof rows. This proves the deploy without waiting on release.

Recommendation: **do G1–G3 now.** It isolates "did the deploy work" from "is the content right," and it is fully reversible (drop the proof rows). Zero risk to students (nothing served).

---

## 5. Decision A — D8 release bars (RESOLVED 2026-08-25 — David ratified as proposed)

**Status:** D8 is no longer ON HOLD. David ratified the proposed slate on 2026-08-25. The ratified values (full rationale in `COURSE_MODE_D8_RELEASE_BARS_PROPOSED_DEFAULTS_2026_08_25.md`):

| Bar | Ratified value |
|---|---|
| Validation sample size *n* per template (human spot-audit) | **20 instances** |
| Property-test coverage | **≥100 instances/computational procedure, ≥120/MCQ frame, 0 rejects; every scenario context and every expected misconception tag exercised ≥1×; answer position varies; catalog self-checks pass** |
| Gold-set regression threshold | **0 grader-behavior changes** vs the old-namespace Stats gold corpus (behavior-drift bar only, not coverage; gates engine changes, not content adds) |
| Ongoing spot-audit rate | **5 served instances / template / 30 days** (or per 500 served, whichever first); confirmed defect → quarantine template |
| Gate-2 independent re-derivation (added bar) | key + every distractor hand-recomputed on the validation sample; **0 defects** |

CM-D19 stamping can now be built against these bars — it remains a separate, David-gated build.

**What it is:** the quantitative bars a *template* must clear before its instances may be machine-stamped as released (CM-D17 / CM-D19): validation sample size per template, property-test coverage bar, and gold-set grader-behavior regression thresholds.

**Why it blocks everything downstream:** CM-D19 stamping (§9) is the machine that says "this template passed D8 → stamp its instances approved." With no bar, there is no pass/fail predicate to encode, so CM-D19 cannot be built, so nothing can be released. This is the single highest-leverage decision on the path.

**What I am NOT doing:** setting defaults. The handoff is explicit that you are still thinking and that no defaults should be invented. I leave the numbers blank.

**To make the decision tractable, here is the decision *shape* (not the values):**

| Bar | What it governs | The trade-off you're setting |
|---|---|---|
| Validation sample size *n* per template | How many instances a human spot-audits before the template is trusted | Higher *n* = more confidence, more review labor per template. |
| Property-test coverage | What fraction of the parameter/slot space the automated harness must exercise | The generator already runs 400 instances / 5,040 invariant checks per default pass; the bar formalizes "enough." |
| Gold-set regression threshold | Max tolerated grader-behavior drift vs the Stats gold corpus | **Caveat (CM-D17):** the gold corpus is old-namespace — valid for grader *behavior* regression, NOT coverage claims. The bar can only be a behavior-drift bar. |
| Ongoing spot-audit rate | *n* served instances re-audited per template per period (the CM-D19 mitigation you already approved) | This is the post-release safety net that made template-level release acceptable; it needs a rate. |

Once you set these four, CM-D19 becomes a well-defined build.

---

## 6. Decision B — the `ap_statistics 2026-27` exam-pack version (governance; David/Orly)

**What it is:** a row in `app.exam_pack_versions` for `exam_code='ap_statistics'`, `school_year='2026-27'`, carrying the **official exam date**. It is a governance object — an exam-pack version is the release-cycle anchor, and its exam date drives the horizon math (CM-D04/CM-D08 interval compression as the exam nears). Dev has only `2025-26` today.

**Why it blocks the loader:** `build_load_sql.py` resolves the target with `select … into strict` on `(exam_code='ap_statistics', school_year='2026-27')`. Missing → the whole transaction aborts by design (fail-closed, no guessing). The loader will not seed a single item until this row exists.

**What I am NOT doing:** creating it or inventing an exam date. The 2026-27 AP Statistics exam date is a real-world fact that must be entered correctly, and creating the cycle object is a David/Orly governance act, not something to fabricate.

**What you need to provide:** the official 2026-27 AP Statistics exam date (and confirmation that a new exam-pack + version is the right home vs. reusing an existing pack). Once provided, this is a one-row insert that unblocks the loader.

---

## 7. Decision C — serving form of the generated computational items (yours; technical)

**The tension (from the model doc §4 / handoff §4):** the generated computational items are **both** MCQ (they carry 4 choices) **and** numeric (they carry deterministic checks). The loader currently sets `evaluator_strategy='data_driven_deterministic'` with `rubric_type NULL` (numeric-entry grading via the F4 verifier) *and* loads `mcq_choices` so the same item *could* serve as MCQ.

**Why it must be decided before serving:** the deployed hook's `data_driven` branch grades `responseText` **as a numeric-entry value**. If the pilot serves these as **MCQ**, the student's response is a choice key (e.g. "B"), which won't parse as a number → the verifier **abstains → the item holds for shadow review** and never scores or updates a cell. Either:
- **(C1) Serve as numeric-entry** — the response field is the numeric answer; the F4 verifier grades it; cleanest match to the merged code. Recommended for the pilot's computational items.
- **(C2) Serve as MCQ** — then the loader/route must map the chosen option to its numeric value (or route to `rule_based_mcq`), or nothing scores.

**Recommendation: C1 (numeric-entry) for the computational templates**, because it exercises the F4 verifier that the whole pilot was built to prove, and it matches the merged branch with no extra mapping. The conceptual 4.B slot-frame stays MCQ (`rule_based_mcq`) as the loader already sets. This is reversible per-template.

---

## 8. Security gate S — `app.grading_results` exposure (close before ANY release; verified live)

**The finding (confirmed this session):** `public.grading_results` correctly excludes `shadow_result`/`raw_model_response`. **But** `app.grading_results` has a direct `authenticated: SELECT` grant, still has the `shadow_result` column, and RLS is an **owner-select** policy (`a.user_id = auth.uid()`). So *if* PostgREST exposes the `app` schema to the `authenticated` role, a student can REST-read **their own** row's `shadow_result` — which, for a `data_driven` graded item, embeds the answer key (this is the re-QA round-2 finding-1 concern, now confirmed as a real config surface, not hypothetical).

**Why it's a release gate, not a deploy gate:** `shadow_result` is only populated by graded `data_driven` attempts, which only happen once content is released. So it does not block G1–G3, but it **must** be closed before the first release.

**Options (any one closes it; ordered by preference):**
- **(S1) Verify `app` is not in the PostgREST exposed-schemas list** (Supabase Dashboard → Project Settings → API → Exposed schemas). Default Supabase exposes `public, storage, graphql_public` only. If `app` is absent, the grant is inert over REST and the surface is already closed — **verify and record it**. Likely already true.
- **(S2) Revoke the direct grant:** `revoke select on app.grading_results from authenticated;` and force all client reads through `public.grading_results`. Belt-and-suspenders even if S1 holds.
- **(S3) Column-level grant** excluding `shadow_result`/`raw_model_response` if any client path genuinely needs direct table access.

**Recommendation: S1 (verify) + S2 (revoke).** Both are cheap; together they make the leak impossible regardless of future exposed-schema changes. I did not execute either (a `revoke` is a mutation on Dev config).

---

> **BUILT 2026-08-23:** D8 bars **approved by David** (SME sample 20/0-defects; ≥100 property instances/0 rejects; 0 verifier disagreements; 5/template/month spot-audit) and CM-D19 stamping **built + applied to Dev** (migration `20260823160000`): `app.template_release_bars` (the approved bars, versioned) + `app.template_releases` (release ledger) + `app.cm_d19_release_template(...)` / `app.cm_d19_revoke_template_release(...)`. The release function is **fail-closed** on the bars (verified: a sub-bar attestation is rejected, 0 items stamped) and reversible. It stamps a template's instances to `review_status='question_review_approved'` + `status='published'` (both `content_items` and `content_item_versions`), matching instances by `item_package_payload->'provenance'->>'template_id'`. **Still required to serve to a student:** a real SME attestation (David's 20-instance review), plus the cycle-level switches — publish the `2026-27` exam_pack_version + an active `subject_entitlement`.

## 9. Build item — CM-D19 template-release stamping (BUILT — see banner above)

**What it is:** the machine that, for an approved template that has cleared its D8 bars, stamps each conforming instance's `review_status='question_review_approved'` + a `validated` serving label, recording `template_id + params` as provenance — replacing per-instance human approval (CM-D19, which you approved 2026-08-23 with the sampled spot-audit).

**Why it's blocked:** it encodes the D8 pass/fail predicate (Decision A). No bars → no predicate → nothing to build against.

**Design sketch (for when A lands), so the build is scoped, not open-ended:**
- Input: a template id + its validation-sample result + the D8 bars.
- Gate: assert the template's sample cleared every D8 bar; refuse otherwise (fail-closed, mirroring the loader's posture).
- Action: for each `content_item_versions` row whose provenance names that template, set `review_status` approved + write the `validated` serving label, stamping template id + params + the bar snapshot as provenance.
- Audit: register the template in the ongoing spot-audit sampler at the rate Decision A sets.
- Invariant: stamping is idempotent and reversible per template (a template can be un-released).

This is a contained build once A is decided; I did not start it (it would bake in guessed bars).

---

## 10. What I did NOT do (surface, not execute) — explicit

- Did **not** apply the `last_attempt_id` migration or deploy `evaluate-attempt` (G1–G3 surfaced for the deployer).
- Did **not** set any D8 bar or invent defaults (Decision A).
- Did **not** create the `ap_statistics 2026-27` exam-pack version or invent an exam date (Decision B).
- Did **not** run the loader or apply `f4_load_DRAFT.sql` to any DB (blocked on B anyway).
- Did **not** build CM-D19 stamping (blocked on A).
- Did **not** revoke the `app.grading_results` grant or change PostgREST config (S surfaced).
- Read-only Dev queries only (all mutations avoided); Prod untouched.

## 11. What I *can* build the moment you decide (so the next session moves fast)

- **A set** → build CM-D19 stamping (§9) against the concrete bars, with tests.
- **B provided** (exam date) → the one-row exam-pack version insert + run the loader → seed unreleased drafts + verify counts.
- **C chosen** → confirm/adjust the loader's `evaluator_strategy`/`rubric_type` per template and (if C2) the option→numeric mapping.
- **Green-light on G1–G3** → I can prepare the exact migration-then-deploy runbook (or, if you want it executed here rather than by a human deployer, do it against Dev with the smoke test).
