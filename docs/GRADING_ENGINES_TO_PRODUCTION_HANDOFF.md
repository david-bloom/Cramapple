# Grading Engines → Production: Session Handoff

**Written:** 2026-07-28
**Purpose:** everything needed to resume Engine 1 / Engine 3 / Engine 4 build-test-deploy work in
a new session without re-deriving context.
**Goal:** get Engines 1, 3 and 4 into Production as soon as possible.

**Read these three first, in order:**
1. This document.
2. `docs/research/grading_cross_subject_takeaways.md` — Lessons 1–26. Lessons 1–8 are the
   pre-existing baseline; 9–26 were added 2026-07-27/28.
3. `docs/research/GRADING_PROGRAM_LEDGER_2026_07_27.md` — the running decision ledger.

---

## 0. One-paragraph state of the world

Engine 1 is deployed and, as of 2026-07-28, **works end-to-end for the first time** — it had never
successfully graded a single FRQ in Production before today. It has good quality discrimination
and is slow (~12 s p50) for architectural reasons that are understood and fixable. Engine 3 is
built, unit-tested, deployed, and **unreachable** — zero content routes to it. Engine 4 has 40
items parked in `human_shadow` and is the least-developed of the three. No real student has ever
been graded by any engine: Production has **0 student attempts and 0 attempt_responses**.

---

## 1. Verified Production facts

| Fact | Value | How to re-verify |
|---|---|---|
| Production project | `pcntajvbdfqhbeewmdry` | Supabase MCP `list_projects` |
| Dev project | `wmgjsdkphcyhngaffbqf` | repo CLI is linked to **Dev**, not Prod |
| Grading function | `evaluate-attempt`, ACTIVE, **v26** | `list_edge_functions` |
| Grading model in Prod | **`gpt-4.1-mini`** via `requireEnv("OPENAI_MODEL")` | `evaluate-attempt/index.ts:81` |
| Model used by ALL Phase C research | `google/gemini-2.5-flash` via Vercel AI Gateway | see §6 trap 1 |
| `app.grading_results` rows | 38 (10 from 2026-07-17, 28 from today's pilot) | SQL |
| `app.attempt_responses` | **0** | SQL |
| `public.student_attempts` | **0** | SQL |
| Real users | 0 (17 auth users = staff/reviewers + pilot) | SQL |

**Routing distribution across 1,316 content item versions:**

| `evaluator_strategy` | n | engine |
|---|---:|---|
| `llm_discrete_text` | 561 | Engine 1 |
| `rule_based_mcq` | 494 | deterministic MCQ |
| `null` | 221 | unrouted |
| `human_shadow` | 40 | Engine 4 |
| **`symbolic_ecf`** | **0** | **Engine 3 — unreachable** |

---

## 2. Engine 1 — deployed, working, slow

### Status: **in Production and functional as of 2026-07-28**

Two transport defects were fixed and deployed today. Before them, **0 of 5** FRQ gradings ever
attempted in Production had succeeded.

| defect | file | nature |
|---|---|---|
| `required` omitted `action_hint`, `repair_hint` | `_shared/grading-contract.ts` | OpenAI `strict:true` requires every key in `properties` to be in `required`. The API names only the FIRST offender — fixing what the error said would have shipped a second identical outage. |
| `reasoning.effort` sent unconditionally | `_shared/grading-contract.ts` | `gpt-4.1-mini` rejects the parameter. Now gated by `supportsReasoningEffort()`. |
| evidence grounding too strict | `_shared/grading-feedback.ts` | raw `response.includes(quote)` flagged **10.19%** of criteria, ~64% false alarms from collapsed newlines. Now normalisation + elision-aware → **2.66%**. Verified in Production at 4.3% (n=70). |

### Pilot re-run results (2026-07-28, 30 calls, 6 items, 5 quality tiers)

| | 2026-07-17 | 2026-07-27 | **2026-07-28** |
|---|---:|---:|---:|
| completed | 0/5 | 30/30 | 28/28 |
| `graded` | 0 | 20 (67%) | **24 (86%)** |
| `uncertain` | 5 | 10 (33%) | **4 (14%)** |
| wall p50 / p90 | — | 17.5 s / 91.1 s | **12.2 s / 20.3 s** |
| cost/call | — | $0.00997 | $0.00894 |

**Quality discrimination is excellent and monotonic** — tier 5 → 1 scored 85.7% / 37.9% / 13.3% /
3.3% / 0.0% with no inversion. This is the strongest evidence Engine 1's judgement is sound on
real Production content.

Full write-up: `docs/research/grading_repair_pilot_2026_07_27/RESULTS_2026_07_28_RERUN.md`
Raw data: `docs/research/grading_repair_pilot_2026_07_27/raw_20260728.jsonl`

### UPDATE 2026-07-29 — items 2, 3 and 4 are built (not deployed)

See `docs/research/ENGINE1_PARTIAL_CREDIT_AND_ARM_A_2026_07_29.md`.

- **Partial credit (item 4) is RESOLVED as a product question and built.** Owner: partial credit
  IS intended, including error carry forward. Required three changes together — schema
  (`partially_earned`), prompt (nothing told the grader it could award partial), and sanitizer.
  Verified live on `gpt-4.1-mini`: an item whose correct award is 4/7 now scores 4/7 `graded`,
  where the old code gave **1/7 `uncertain`**. Re-counted: **601 of 2,969 criteria multi-point,
  124 published.**
- **`uncertainty_reason` (item 3) fixed.** The "failed 0 integrity check(s)" string is now
  impossible; abstention and integrity failure are worded separately.
- **PRIORITY ORDER CORRECTED (owner, 2026-07-29): Quality > Speed > Cost.** Not Speed first, as
  the old grader-priority memo said. Cost is immaterial — real runs land near **$0.002/FRQ**.
  Treat any doc asserting Speed first as stale.
- **Arm A (item 1) is built but ships DEFAULT OFF** behind `GRADING_ARM`, and on current evidence
  **it does not ship at all.** It is **2.5–3.3× faster** on the production model, but scored
  **0 of 6 correct** across two variants where Arm B scored **5 of 6**. The obvious fix — giving
  each call the full rubric as context, which cost had been the only reason to omit — was tried
  and **did not work**. Under Quality-first that is a reject pending a real corpus.
- **Bigger lever than the arm question: try a stronger model.** Cost is immaterial and quality is
  first, and `gpt-4.1-mini` is both the slow component and the source of the over-crediting. It is
  the only lever that can improve quality *and* speed at once.
- **Repo HEAD was BEHIND Production** — the v26/v25 fixes had never been committed. Fixed first
  (`26859a8`), so trap 2 now has a reference point.
- **Before deploying any of this: bump `EVALUATE_ATTEMPT_PROMPT_VERSION`.** The grading prompt
  changed materially, so before/after results are not comparable. It is a Supabase secret, not code.

### Engine 1 open work, in priority order

1. **Arm B → Arm A conversion. Biggest single speed win.**
   Production issues ONE model call grading all criteria of an item. Measured today:
   **latency ≈ 0.58 s + 3.89 s × n_criteria** (1-criterion items 4.5 s, 4-criterion items 16.1 s).
   That is the Arm B shape Phase C closed as a dead end (`ARM_B_ROOT_CAUSE_ANALYSIS.md`).
   Arm A — parallel per-criterion — is **flat in criterion count**, ~1.9 s p50 in Phase C.
   Expected: **~16 s → ~4 s** on a 4-criterion Biology FRQ. Already designed and validated at n=100.
2. **Strip decision-irrelevant output fields** (~355 ms p50). A 4-field schema measured
   **1,073 ms p50** vs 1,428 ms for the 9-field one, same model/provider/architecture.
   Candidates to drop: `improved_answer` (composes prose no decision depends on), `minimum_fix`,
   `error_classification`, `gate_schema_status`. **Check product need before dropping** —
   `minimum_fix` is part of the stated product promise ("the minimum fix for the next point").
3. **Fix the misleading `uncertainty_reason`.** `sanitizeModelResult` sets `uncertain` when
   `issues.length > 0` **OR** any criterion is `unable_to_determine`, but always words it as an
   integrity failure. Confirmed live: a grading returned *"Grading output failed 0 integrity
   check(s)"* when the cause was abstention. Message bug, not scoring bug — fix before that string
   reaches a tutor.
4. **Partial credit — UNRESOLVED and possibly serious.** `earned_points_mismatch` converts any
   `earned` criterion whose award ≠ `points_possible` into `unable_to_determine` with **0 points**.
   **598 of 2,472 Production criteria (24%) are multi-point** (381 at 2 pts, 217 at 3).
   The pilot could not test this — all 6 pilot items are single-point. **Needs a pilot corpus with
   multi-point criteria.** If partial credit is intended, this is systematic under-credit on a
   quarter of the bank; if criteria are meant to be all-or-nothing, the code is right and the
   rubric point values are misleading. **This is a product decision.**
5. **Escalation — there is none.** See §5.

---

## 3. Engine 3 — built, tested, deployed, unreachable

### Status: correct at the checker level; **0 items route to it**

- Harness: **211/211** part-level expectations, all six ECF verdicts at 100%.
- Unit tests: **13/13** (4 regression tests added).
- Three production bugs found and fixed 2026-07-28, all now deployed:
  1. reserved-name collision (`e`/`pi` bound as constants over supplied inputs) — silently
     mis-graded a **published, tutor-approved** AP Statistics item against the student.
  2. `CORRECT_VIA_ECF` awarded with no dependency — full marks for wrong answers.
  3. parser lacked `erf`/`factorial` used by shipped profiles.
- `MATH_VERIFIER_VERSION` bumped to `math-verifier-ts-2026-07-28`.

Harness: `scripts/engine3-harness/` — regenerate fixtures with `build_fixtures.py` (SymPy,
deliberately independent of the TS parser), run with
`deno run --allow-read --allow-write scripts/engine3-harness/run_harness.ts`.

### Blocking preconditions

| # | Precondition | Type | Note |
|---|---|---|---|
| P1 | ≥1 item has `evaluator_strategy = 'symbolic_ecf'` | **data write** | Currently 0 of 1,316. A routing path cannot be tested without routing something to it. |
| P2 | Profile reachable for that item | **code** | `grading-router.ts:35` already reads `prompt_json.verification_profile`. The loader still uses a hardcoded map in `math-verifier.ts:873-951` (5 entries). |
| P3 | Caller can POST structured `response_parts` | **already satisfied** | `attempt-response/index.ts:361` accepts arbitrary `response_parts` jsonb. |

### THREE OWNER DECISIONS REQUIRED — Engine 3 cannot proceed without these

1. **Environment.** Dev-only, or Dev + a Production smoke subset? Recommend full matrix on Dev,
   then a minimal Production smoke on `APSTAT-MOD6-M001` (the only published item that mixes a
   deterministic and a conceptual criterion). Production needs approval for content mutation +
   test rows + verified cleanup.
2. **Tier B draft items.** Include them? **Every rich ECF chain is on draft content.** Without
   Tier B the test cannot exercise ECF chaining at all — Engine 3's distinctive capability.
   Including them is fine for an engineering proof but must not be reported as launch progress.
3. **Profile loading.** Wire the loader to `prompt_json.verification_profile` (durable, makes
   profiles governed content) or extend the hardcoded map (faster, but the map is the defect under
   investigation — testing through it validates the wrong path). **Recommend wiring the loader.**

### Hard ceiling on Engine 3

Even after the integration test passes, **Engine 3 cannot issue an authoritative grade** — the
path hard-codes `finalStatus = "uncertain"` (`evaluate-attempt/index.ts:~1121`). And there is no
producer of structured `response_parts` from students (no typed-math editor exists). **Engine 3
is shadow-only until both are built.** Do not promise learner-facing Engine 3 output.

Scope doc: `docs/research/ENGINE3_HARNESS_TEST_SCOPE_2026_07_28.md`
Results: `docs/research/ENGINE3_HARNESS_RUN1_RESULTS_2026_07_28.md`
Also unexercised: `detectAmbiguousTypedFormulaText` (`_shared/formula-notation.ts`, called at
`evaluate-attempt/index.ts:1039`) — the ABSTAIN-on-ambiguous-notation guardrail. Add fixtures in
the integration test.

---

## 4. Engine 4 — least developed, needs scoping first

**I did not work on Engine 4 this session.** What is known:

- 40 content item versions are tagged `human_shadow`.
- Phase B real-handwriting validation exists:
  `prompts/CLAUDE_TASK0016_PHASE_B_REAL_HANDWRITING_VALIDATION_2026_07_27.md`.
- Hand-drawn sample images: `docs/hand drawn samples/`, and
  `docs/research/DRAWN_RESPONSE_FRQs_v1.1_images/`.
- Design/review docs: `DRAWN_RESPONSE_ARCHITECTURE_REVIEW.md`,
  `DRAWN_RESPONSE_PILOT_V0_REVIEW.md`, `ORLY_DRAWN_RESPONSE_PILOT_PROTOCOL.md`,
  `hand_drawn_sample_grading_experiment_2026-06-29.md`.
- The ledger's standing instruction: continue Engine 4 only through its planned
  **QR → observation → gold → abstention → shadow** sequence.
- Relevant contamination finding: 5 `HDG-2026-GRAPH` items are correctly tagged
  `spatial`/`human_shadow` but were scored as text in Stage 3, inflating the apparent Engine 1
  ambiguity rate from 0.73% to 3.2%. **Do not score spatial content through Engine 1.**

**First action for Engine 4: read those docs and write a scope note before any build work.**
Treat the "ASAP to Production" goal with care here — Engine 4 is furthest from ready and involves
learner-visible spatial judgement.

---

## 5. The escalation gap — applies to all engines

**Engine 1 never abstains.** Measured directly (β2-A, n=740 paired):

- 56 criterion labels judged genuinely undecidable by blind adjudication → the grader returned a
  confident verdict on **54**.
- 30 hand-authored `abstention_policy` fields changed **one label out of 740** (p = 1.00).
- The base prompt already instructs abstention. **Prompt text cannot buy it.**
- `confidence` reads `high` on **100%** of ambiguous input and **100%** of the grader's own
  errors. It is effectively a constant and must not be used for triage or gating.

**What works:** inter-run disagreement is **20.8× enriched** on undecidable content
(18.5% vs 0.9%). As a trigger: **62.5% precision, 18.5% recall**, firing on ~2% of labels.

**Critical sizing rule (Lesson 19):** score escalation triggers at the **production base rate
(~0.73%)**, not the corpus base rate. At 0.73%, disagreement escalates ~669 per 65k judgments to
catch 88; a higher-recall text rule escalates **10,326** to catch 186 and is unusable.

**Consequence: there is currently no path for a hard case to reach a human.** Ship
disagreement-routing anyway (partial mitigation beats none, ~$0.0117/FRQ, no wall-clock cost if
parallel) but **always report the 18.5% recall alongside it.**

Also: Engine 1's run-to-run reliability is **99.4% on decidable content**, 97.8% overall — a
legitimately good number, usable in a reliability claim with the ambiguous-content caveat.

---

## 6. Traps that cost time today — read before touching anything

**1. Production runs a different model than all the research.**
Every Phase C number (Stage 5/6, β1, β2, β3) was measured on `google/gemini-2.5-flash` via the
Vercel AI Gateway. Production runs **`gpt-4.1-mini`** via `OPENAI_MODEL`. **None of the Phase C
accuracy/latency/cost numbers describe the deployed system.** Verify the deployed configuration
before spending on calibration.

**2. Never deploy repo HEAD without diffing it against the deployed version.**
Today's deploy shipped an entitlement gate calling `authorize_grading_access`, an RPC from
migration `20260720122542_free_score_check_growth_funnel.sql` that is **not applied to
Production**. Result: every non-admin grading request 403'd for ~25 minutes. No user impact (zero
real students) but strictly worse than the bugs being fixed. Now behind
`GRADING_ENTITLEMENTS_ENABLED`, **default off**.
→ **Owner decision:** whether to apply that migration. It changes monetization behaviour (free
users get one initial grade + one repair). Apply it and flip the flag in the same change.

**3. Unit tests cannot catch provider-contract violations.** Both Engine 1 transport bugs were
only visible by replaying the **unmodified production request body against the live API**. Do that
before believing any transport fix.

**4. Any paid run must checkpoint before it writes anything else.** A foreground run hit a
10-minute cap and lost every completed call (~$0.50–0.70, zero data). All drivers now append per
response-group and resume from the file.

**5. Check baseline error count before spending on any boundary experiment.** β3 spent $1.18 on a
test with 6 discordant pairs, which cannot reach significance at any effect size. Target ≥15%
baseline error in the held-out set.

**6. Check for known label defects before interpreting grader/gold disagreement.** The FRQ02
boundary diagnostic first read as a perfect null (3 fixed / 3 broken) because 3 "broken" cases
were in a label-noise cluster `grader_speed_sp1_report.md` had already documented. Corrected:
**+3.2 pp, 3 fixed / 0 broken.** Five bad labels turned a real effect into exactly zero.

---

## 7. Operational runbook

### Deploy `evaluate-attempt` to Production

```bash
supabase functions deploy evaluate-attempt \
  --project-ref pcntajvbdfqhbeewmdry \
  --use-api \
  --workdir /Users/davidbloom/Documents/Cramapple
```

`--workdir` is required: there is no `supabase/config.toml`, so the CLI otherwise resolves its
workdir to `$HOME` and fails. The CLI is authenticated (`~/.supabase/access-token`) but **linked
to Dev**, hence the explicit `--project-ref`.

Deploying pulls the transitive closure of `_shared` imports (16 files). **Diff against the
deployed version first** (trap 2).

### Run the tests

```bash
deno test --allow-read --allow-env supabase/functions/_shared/
```

56 tests as of 2026-07-28. Engine 3 harness:
`deno run --allow-read --allow-write scripts/engine3-harness/run_harness.ts`

### Run the Production narrow pilot

The synthetic student is created and deleted per run, so the user id cannot be hardcoded.

```bash
# 1. OWNER runs this — it creates an account and handles a password
node /Users/davidbloom/Documents/Cramapple/docs/research/grading_repair_pilot_2026_07_27/create_pilot_session.mjs

# 2. Assistant confirms the email via SQL (Production requires confirmation),
#    then captures the session:
node /Users/davidbloom/Documents/Cramapple/docs/research/grading_repair_pilot_2026_07_27/create_pilot_session.mjs --signin

# 3. Run
export SUPABASE_PUBLISHABLE_KEY='sb_publishable_TlRLW6EOot2pzI4QYtuP7A_XcktZHFT'
export PILOT_OUTPUT_FILE=/tmp/cramapple_grading_pilot_raw_YYYYMMDD.jsonl
export PILOT_RUN_LABEL=YYYYMMDD
node docs/research/grading_repair_pilot_2026_07_27/run_pilot.mjs
```

`PILOT_RUN_LABEL` keeps the deterministic attempt/response/idempotency UUIDs distinct per run —
without it a re-run silently *resumes* the previous one instead of re-running it.

### Gateway credentials for research runs

`scripts/vercel-gateway-check/.env` holds a live `AI_GATEWAY_API_KEY`. The `VERCEL_OIDC_TOKEN` in
`.env.local` **expired 2026-06-18** and shadows the working key — always run with
`env -u VERCEL_OIDC_TOKEN`.

---

## 8. Test-data footprint currently in Production

Owner said **keep for now** (2026-07-28). Clean up when the workstream closes.

| table | rows |
|---|---:|
| `app.attempts` | 30 |
| `app.response_versions` | 30 |
| `app.grading_results` | 28 (+10 pre-existing from 2026-07-17) |
| `app.profiles` | 2 |
| `auth.users` | 2 |

Pilot user: `76705295-a203-4ce3-a2d4-218183024f05`
**Orphaned, unusable** (password unrecoverable — see the credential bug in the pilot section):
`938cb3d3-8071-467f-add2-6f2aecf1d291`. Delete with the cleanup pass.

---

## 9. Ordered plan to get all three engines to Production

### Engine 1 — closest to ready
1. Decide the **partial-credit** question (§2.4). Blocks any multi-point content.
2. **Arm A conversion** — the speed fix. ~16 s → ~4 s.
3. **Lean the output schema** — check product need for `minimum_fix` first.
4. Fix the `uncertainty_reason` message.
5. Re-run the narrow pilot **with multi-point criteria** to validate 1–4 together.
6. Ship **disagreement-routing** for escalation, reporting its 18.5% recall honestly.
7. Decide the **entitlement migration** + flag.

### Engine 3 — blocked on three decisions
1. Owner answers the three questions in §3.
2. Wire the profile loader to `prompt_json.verification_profile`.
3. Route Tier A + Tier B items on Dev; run the integration matrix (~50 requests, ~$0 model cost).
4. Add `detectAmbiguousTypedFormulaText` fixtures.
5. Production smoke on `APSTAT-MOD6-M001` with approval + verified cleanup.
6. **Stop.** Authoritative output and structured student input are unbuilt — Engine 3 stays
   shadow-only until both are separately built and approved.

### Engine 4 — scope before building
1. Read the drawn-response docs (§4) and write a scope note.
2. Follow the planned QR → observation → gold → abstention → shadow sequence.
3. Do not route spatial content through Engine 1 in the meantime.

---

## 10. Research corpus — what has and has not been read

`docs/research/` holds **88 markdown files** and 24 subdirectories. As of 2026-07-28 I had read:

**Read:** `grading_cross_subject_takeaways.md` (Lessons 1–26), `grader_speed_sp1_report.md`
(partially — through the misattribution-audit section), `bio_reference_layer_next_planning_memo.md`,
`GRADING_PROGRAM_LEDGER_2026_07_27.md`, `grading_engine_rollout_plan_2026_07_08.md`,
`ENGINE3_*`, the Phase C calibration directory, `frq02_generated_answer_labels_codex_provisional.jsonl`.

**NOT yet read — do this before the next experiment:**
`bio_reference_layer_exemplar_test_report.md`, `..._flywheel_volume_test_report.md`,
`..._gated_prompt_test_report.md`, `..._oracle_boundary_test_report.md`,
`..._next_experiment_plan.md`, `..._baseline.md`, `..._measurement_harness.md`,
`GRADER_SPEED_SUBTASK_PROTOCOL.md`, `grading_launch_gate_audit_2026_07_08.md`,
`canonical_answer_test_series.md`, `grading_generalization_and_feedback_protocol_2026_07_08.md`,
`apbio_kimi_grading_experiment_2026-07-17.md`, `frq_grading_status_2026-06-18.md`,
`GRADING_RESEARCH_CANONICAL_PROCESS.md`.

**Standing rule learned the hard way:** the prior research contains findings that invert new
results. Read the relevant prior report before interpreting a new one.

---

## 11. Known-unmeasured — do not claim these

- **4 of 5 feedback-quality dimensions** (reason match, minimum-fix sufficiency, improved-answer
  correctness, error-class accuracy). Only grounding has been measured.
- **No dual-human adjudicated gold set exists** for any production question. Governance requires
  300+ dual-blind adjudicated held-out responses (`CONTENT_GOVERNANCE_AND_VALIDATION.md` §12.2).
  All current gold is single-pass or model-adjudicated.
- **Engine 1 end-to-end request latency** outside the model call (app shell, auth, DB I/O).
- **Partial credit behaviour** on multi-point criteria.
- **Engine 3 in any integration context.**
- **Engine 4 essentially everything.**
