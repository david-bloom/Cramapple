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

## UPDATE 2026-08-11 — corrections from the exemplar-pilot second-opinion review

Appended per replan item 1.5
(`docs/research/GRADING_ENGINE_REPLAN_EXECUTION_PLAN_2026_08_10.md`). The
2026-07-28 text below is retained unchanged as the comparison baseline;
where this section contradicts it, this section wins. Only already-decided
items are listed — no new data was required for any of them.

1. **The deterministic text layer is live and decisive, not "effectively
   absent (0.7%)."** Phase C measured 0.7% deterministic firing on its
   cross-subject corpus; on the 2026-08-10 exemplar-pilot capture the
   Statistics keyed gate short-circuited **130 of 300 calls (43% of cases)**
   before any model call. It is a decision-making production layer and is
   now under Engine 3-grade governance: a standing invariant harness audits
   every `STATISTICS_TARGETS` key against gold answers + re-derived
   canonical values (`scripts/grading-model-assessment/
   verify_deterministic_keys.ts`, in `deno test`;
   `docs/research/DETERMINISTIC_KEY_AUDIT_2026_08_11.md`). The audit found
   `APSTATS-SFRQ-008` keyed with the retired v1 canonical's values —
   every correct response deterministically zeroed. Corrected values are
   in-repo pending O1.
2. **"Engine 1 never abstains" is now half-obsolete.** The grader-call
   finding stands (prompt text cannot buy abstention — ledger §5.3), but at
   the SYSTEM level abstention is common: deterministic flags plus
   sanitizer integrity checks put 13.5% of the pilot's LLM-path trials and
   43% of its cases into `uncertain`. The escalation problem is now
   "convert system abstentions," not "create abstention."
3. **Non-model end-to-end overhead is measured: ~691 ms p50 / 953 ms p95**
   (deterministic-gate calls in the pilot capture — full HTTP/auth/DB/render
   path, no model). §11's "unmeasured non-model latency" is closed as a
   question; against the 1,000 ms bar, the non-model floor alone consumes
   ~69% of budget. Stage-timing telemetry to attack it is pre-staged in the
   Step 2 deploy bundle.
4. **Engine 3 owner-decision #3 is resolved toward wiring the profile
   loader.** The hardcoded-map pattern (bare constants keyed by
   content_key) is the exact class that just failed in production via
   SFRQ-008; the governed-loader build is scheduled in the replan's rebuild
   register.
5. **Prompt-content experiment direction is closed.** The exemplar few-shot
   pilot, corrected for its replay-parsing defect, reads +1.4pp with CIs
   straddling zero at both cluster granularities
   (`exemplar_grading_pilot_2026_08/REPORT.md` §"Correction — 2026-08-11").
   Remaining prompt-adjacent work is `accepted_variants` authoring only
   (ledger §5.1).

---

## UPDATE 2026-08-13 — Steps 1–3 of the replan executed; the real accuracy lever identified

Steps 1–3 of `GRADING_ENGINE_REPLAN_EXECUTION_PLAN_2026_08_10.md` are now
all complete (the 2026-08-11 update above covers Step 1's analysis only).
Full detail across `docs/activity_log/ACTIVITY_LOG.md`'s 2026-08-13 entries
and `exemplar_grading_pilot_2026_08/EXECUTION_LOG.md`. **The single most
important thing for a new session to know: the deterministic layer and the
grader's own judgment are both now confirmed working correctly — the
accuracy work that still matters is a different, smaller problem (item 6
below), not more of what Steps 1–2 fixed.**

1. **`APSTATS-SFRQ-008`'s deterministic keys were wrong and are now fixed
   and deployed.** Keyed to the item's retired v1 canonical, not the
   published v3 — every correct response was zeroed. Fixed, deployed
   (`evaluate-attempt` v37+), and a standing invariant harness now audits
   every keyed entry against real gold answers in `deno test` permanently.
   Ledger §3B has the full record; do not re-derive this.
2. **Per-criterion deterministic flag scoping ("O2") is deployed for 8
   items.** A flag used to zero every criterion on the item regardless of
   which one the numeric evidence concerned; now only the implicated
   criteria are held, confirmed working end-to-end against a real
   authenticated call. **Shipped with a same-session, self-caught defect**
   worth reading even if you don't touch this code: reusing an existing
   "similar" data structure across two different key namespaces (gold-fixture
   ids vs real `frq_criteria.criterion_key`) silently no-op'd on 7 of 8
   items before being caught. Ledger §3B, "Engineering pitfall" row — the
   lesson generalizes to any future criterion-key mapping (Engine 3/4
   included).
3. **Run A confirms the fix works on the exact previously-broken traffic.**
   13 responses that used to hit the deterministic gate now all reach real
   grading; selective accuracy 100%. $0.40 real spend.
4. **Run B (prompt caching) closed without spending.** The prompt's
   cacheable prefix is byte-stable but only ~540 tokens — half of OpenAI's
   1024-token minimum. Don't measure this again until the prompt is
   deliberately restructured to cross that floor.
5. **Run C found Arm A does not deliver its speed claim on `gpt-4.1-mini`.**
   Phase C's "~16s → ~4s" figure (§0 below, and Lesson 26 in the takeaways
   doc) was measured on `gemini-2.5-flash`. Re-measured on the real
   production model: 22–31 seconds across every criterion count, not flat,
   mostly slower than Arm B. Quality wasn't clearly bad this round. **Do
   not cite the old Arm A latency figures for `gpt-4.1-mini`** — see
   takeaways Lesson 27 and ledger's Phase C correction block.
6. **The actual binding accuracy constraint, found independently twice the
   same session: evidence-grounding false alarms, not model judgment or
   deterministic coverage.** Both the O2 smoke test and Run A found
   selective accuracy at or near 100% (every committed verdict correct)
   with the entire accuracy gap sitting in abstention — the sanitizer
   rejecting a correct verdict because its evidence quote isn't an exact
   substring match. Ledger §4 Lesson 11, takeaways Lesson 28. **This is
   the next real lever, ranked above more gold-set volume, more
   deterministic-key coverage, or another model/arm evaluation** — none of
   those move a number whose gap is abstention.

**Not done:** Step 4 as originally scoped (a full handoff rewrite) — this
update section is the practical equivalent, written same-day rather than
as a separate rebuild. The rebuild register in the replan doc has Arm A's
row updated with Run C's verdict; nothing else in that register changed.

---

## UPDATE 2026-08-18 — Engine 4 real-photo grading accuracy measured for the first time; escalation confirmed to work; concrete pilot-to-production gap identified

**§11 below said "Engine 4 essentially everything" is unmeasured. That's no
longer true.** A full session was spent building genuine per-photo gold
labels for the 200 real `HDG-2026-P1` photos (`docs/hand drawn samples/`)
and measuring the production-candidate grading method against them for the
first time — previously only a clean, computer-rendered synthetic proxy had
ever been tested (97-100% exact match, `hand_drawn_graph_benchmark_2026_06_30/`),
which turned out to hide the entire real failure mode. **Primary reference
for everything below: `docs/research/HAND_DRAWN_REAL_PHOTO_GRADING_ACCURACY_2026_08_18.md`**
— the full narrative, every number, and every reverted/failed experiment
documented honestly (read that document fully before starting new Engine 4
work; this section is a synthesized roadmap, not a replacement for it).

### What's now known

1. **The `gpt-4o-mini`-based production candidate (`VISION_FAST_ESC`) fails
   all four DR-1 thresholds on real photos, by a wide margin** (23.0% exact
   match / 84.5% F1 / 30.6% FAR / 20.5% FRR against ≥95%/≥90%/≤2%/≤5%). This
   is the first real measurement of false-accept rate for this method ever
   — the synthetic benchmark had no known-incorrect items, so it was
   literally unmeasurable before now.
2. **Model backbone is the single biggest lever found.** Swapping only the
   model to `openai/gpt-5.2` (same images, same prompt) raises F1 to 93.3%
   — clearing DR-1 for the first time in this investigation — and improves
   every other metric substantially without clearing them (38.5% exact /
   18.4% FAR / 7.9% FRR).
3. **Escalation is now causally confirmed to work, not just correlated with
   difficulty.** A controlled test (same 21-photo medium-confidence subset,
   `gpt-5.2` alone vs. escalated to `gpt-5.2-pro`) found FAR more than
   halved (50.0% → 18.8%) and exact match went from 0% to 33.3% on
   previously-unsolved responses. **This has NOT been run on the full
   corpus** — only 21 of `gpt-5.2`'s 105 medium-confidence responses have
   been escalated. Running the remaining 84 and recomputing across all 200
   is the single highest-value next step to get a real, complete number.
4. **Confidence-gated selective prediction is a real lever, but read it at
   the response level, not per-criterion.** A criterion-level policy showed
   70% "coverage," but that's a per-criterion-judgment statistic; at the
   response level (what a student's actual grade depends on) only 40.5% of
   responses land fully in the safe bucket, and only 26.5% of all 200 are
   both hands-off and actually correct. Don't cite the 70% number as
   "70% of students get a hands-off accurate grade" — it isn't that.
5. **Two rubric-clarity bugs investigated with the same method (read false-
   rejects/accepts, visually inspect real photos, check the literal rubric
   text) — one fixed cleanly, one reverted.** `ZERO_INTERCEPT_ANNOTATION`
   was a real, narrow bug (the model was importing a different criterion's
   requirement into its judgment) — fixed, verified via full 67-photo
   retest, zero collateral damage, error rate cut >60%. `PLOT_VALUES` (the
   largest remaining error source, 28.5% wrong across all archetypes) got
   a similarly-diagnosed fix, but it taught a general tolerance-calibration
   principle rather than correcting a narrow bug, and the retest showed
   small regressions in adjacent criteria plus a net FAR increase — reverted,
   not adopted. **`PLOT_VALUES` remains open and is the best next accuracy
   target**, with the lesson learned: a second controlled run (or a more
   surgically-scoped fix) is needed before trying again, not another
   general leniency instruction.
6. **A dedicated (non-LLM) OCR probe found real, if not-yet-fully-automated,
   evidence for a different kind of fix.** macOS's built-in Vision framework
   (local, free, no API) reads printed/handwritten axis numbers with
   near-perfect accuracy on hand-verified spot checks — dramatically
   cleaner than any VLM tested. The automated scoring script's 25.0% number
   is misleading (it measures a bug in this session's own left/bottom
   axis-role heuristic, confirmed by hand-checking a "failing" case where
   the OCR text was actually perfect) — a real engineering task (robust,
   orientation-invariant axis-role assignment), not yet done. Separately,
   the same tool tested against real handwritten Calc/Chem equations
   (`docs/hand drawn samples/Calc AB HDR/`, `Chem HDR/` — out of scope all
   session, no rubric linkage) showed strong core-content transcription
   with one specific, recurring weakness (exponent/superscript notation
   inconsistently preserved) — this may be a better-fitting problem for OCR
   than graphs are (pure symbolic recognition, no point-detection needed),
   and gives real signal toward Engine 3's own outstanding "real human-
   handwriting transcription gating run" requirement (§3 below / TASK-0016).
   This is a separate, unscoped opportunity, not a continuation of the
   Engine 4 graph work.
7. **Real, pre-existing corpus defects found and documented, independent of
   grading accuracy:** systematic axis-tick-value corruption on 11+ `EST`
   items (a shared template/printing defect, not a drawer error — confirmed
   via duplicate photos sharing identical corruption), near-universal
   missing axis units, and several misfiled photos (wrong item's content
   under a given item's filename). Should be triaged before this corpus is
   trusted as an official launch-gate benchmark.
8. **One open governance question, deliberately not resolved unilaterally:**
   whether `ZERO_INTERCEPT_ANNOTATION` should credit a corrupted-axis item
   when the student's demonstrated work is otherwise correct. Real
   arguments both ways (documented in the research doc); flagged for
   owner/adjudicator decision, gold left unchanged pending that call.

### Concrete gap to production — ordered

1. **Finish the escalation validation at full scale.** Run `gpt-5.2-pro`
   (fix already known: `maxOutputTokens: 1200`, not 600 — a real token-
   budget bug found and fixed mid-session, isolated to `SER`/`EST`'s longer
   criterion lists) on the remaining 84 medium-confidence photos, recompute
   exact match/F1/FAR/FRR across the full 200. This is the single most
   valuable next number — everything cited above from the escalation test
   is real but partial (21/105).
2. **Formal gold-set adjudication.** Current gold (200 photos) is single-
   pass `ai_provisional`-tier (20 independent AI graders, one pass each),
   not the dual-human-adjudicated standard §11 already requires for any
   production question (`CONTENT_GOVERNANCE_AND_VALIDATION.md` §12.2). This
   gap, already flagged generically in §11, is now concretely true for
   Engine 4's real-photo gold specifically. Needed before any of these
   numbers can support an actual launch decision, not just R&D direction.
3. **Resolve the open `ZERO_INTERCEPT_ANNOTATION` policy question** (item 8
   above) via real adjudication, not further unilateral AI judgment calls.
4. **Corpus cleanup.** Fix or exclude the 11+ corrupted-axis `EST` items
   (item 7 above) before treating this corpus as an official benchmark
   reference for a go/no-go decision.
5. **Decide the deployment/authority model — this is a product/policy
   decision, not yet made.** Options quantified in the research doc, each
   with real coverage/accuracy/cost/latency tradeoffs: (a) unconditional
   single-model grading (simplest, worst accuracy), (b) confidence-gated
   selective automation + human review for the rest (protects quality,
   costs coverage), (c) escalation-augmented (recovers coverage instead of
   just protecting quality on a shrinking safe subset, per item 3 above,
   but only tested on a partial subsample so far), (d) some hybrid. None of
   these currently clears all four DR-1 thresholds outright at full
   coverage — the real question is whether a *partial*-coverage authoritative
   slice (whichever policy) is an acceptable interim launch shape, which is
   an owner call, not something to assume.
6. **Latency/cost engineering for any escalation-based design.**
   `gpt-5.2-pro` ran 23-36s per call in testing — 4-5x slower than `gpt-5.2`.
   Cannot block the student-facing request path the way this session's
   diagnostic scripts ran serially; needs async/background grading and a
   "still checking" UX pattern, or the latency budget this doc already
   cares about (§0/§11) gets blown badly. Not designed yet.
7. **`PLOT_VALUES` fix, take two** (item 5 above) — the largest remaining
   error source, one attempt already tried and reverted. Needs either a
   second controlled run to separate real signal from run-to-run noise in
   the adjacent-criteria regressions, or a more narrowly-scoped fix than
   "teach a general tolerance principle."
8. **Optional, separate track: formalize the OCR-for-equations finding into
   a real Engine 3 pilot** (item 6 above) — needs its own gold data and
   benchmark; not a continuation of Engine 4's graph work, don't conflate
   the two scopes.

### Artifacts

- **Committed and pushed to `origin/main`:** commit `8b8b8e5` — real gold
  labels, the original benchmark harness, the extraction-only/resolution-
  crop/model-backbone spikes, and the first full `gpt-5.2` run. Covers
  everything through item 2 above's baseline.
- **NOT yet committed** (all in the working tree as of 2026-08-18, session
  end): the `PLOT_VALUES` fix attempt and its revert documentation, the
  escalation controlled test (`hand_drawn_graph_escalation_gemini_run.mjs` —
  name predates a mid-session pivot from `gemini-3.1-pro-preview` to
  `gpt-5.2-pro`, see the research doc for why), `select_escalation_test_subsample.mjs`,
  and the OCR probe (`ocr_axis_probe.mjs`, `vision_ocr.swift` + compiled
  binary). Commit these (or ask for review first) before a new session
  builds further on top, so `git status` in the next session isn't a
  surprise.
- **Gold data:** `docs/research/hand_drawn_graph_real_photo_benchmark_2026_08_18/gold/`
  (`real_photo_gold_labels_2026_08_18.json` — the 200-photo gold set;
  `extraction_probe_subsample_2026_08_18.json`,
  `escalation_test_subsample_2026_08_18.json` — deterministic, reproducible
  stratified selections, see the select_*.mjs scripts for exact logic).
- **All run outputs:** `docs/research/hand_drawn_graph_real_photo_benchmark_2026_08_18/runs/`
  — every experiment's raw JSONL, kept even for reverted/failed attempts as
  a historical record (never deleted, per this session's own practice).
- **Scripts:** `scripts/vercel-gateway-check/hand_drawn_graph_*.mjs` (one
  per spike/experiment, each with a header comment explaining what it tests
  and why), `select_*.mjs` (subsample selection, deterministic), `ocr_axis_probe.mjs`
  + `vision_ocr.swift` (the local OCR probe).

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
- **Engine 4 real-photo grading accuracy is now measured (2026-08-18 UPDATE
  above) — update this line, don't cite "essentially everything" anymore.**
  Still genuinely unmeasured for Engine 4: the full-200-photo escalation
  number (only 21/105 medium-confidence photos escalated so far), any
  dual-human-adjudicated gold (same gap as the line above, now concretely
  true here too), end-to-end request latency with an escalation call in the
  path, and anything about Engine 4 in an actual integration/deployment
  context (this was all offline benchmarking against a static photo corpus,
  never a real request path).
