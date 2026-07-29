# TASK-0016 Phase C — Execution Log

**Window:** 2026-07-27 → 2026-07-28
**Production project:** `pcntajvbdfqhbeewmdry` — **read-only throughout.** No
attempts, users, responses, grades, or review decisions were written. All
Production access was via the Supabase MCP `execute_sql` tool (SELECT only) and
`list_tables`. No Production `evaluate-attempt` invocation was made.

## Stage 1 — Frozen item manifest ($0)

Eligibility SQL and full provenance are recorded in
`FROZEN_ITEM_MANIFEST.json` → `meta.eligibility_sql` and
`meta.owner_decisions_applied`. Aggregate counts returned during selection:

- 1,208 `content_item_versions`, 765 `content_review_decisions`
  (404 approve / 318 approve_with_edits / 38 disapprove / 5 null).
- `supersedes_id` populated on **0 of 765** rows → "latest, non-superseded
  decision" derived by `ROW_NUMBER() … ORDER BY COALESCE(submitted_at,
  created_at) DESC` instead. Deviation recorded in the manifest.
- Eligible after all filters: 146 FRQ / 287 MCQ → frozen at 100 / 100.
- Selector: `md5(content_item_version_id || '|phase_c_2026_07_27')` ascending,
  Hamilton largest-remainder apportionment by family. Seed and per-family
  quota log in `FROZEN_ITEM_MANIFEST.json` → `selection_log`.

Two owner decisions and one self-correction are documented in `README.md`
(inclusion of `tutor_review_pending` items with a real approve decision; the
rejected `canonical_answer_1` completeness check).

## Stage 2 — MCQ integrity ($0, 0 model calls)

100/100 frozen MCQs passed the production deterministic choice-match logic
(replicated from `supabase/functions/evaluate-attempt/index.ts` lines ~904–917)
against correct choice_key, an incorrect choice_key, and correct choice_text.
0 content defects. Artifacts: `stage2_mcq_integrity_{summary.json,records.jsonl}`.

## Stage 3 — Response corpus + adjudication (no Phase C budget spend)

Executed as Workflow `phase-c-stage3-response-corpus-v3` (run `wf_0ae89e42-823`),
20 agents, 0 errors, 10 batches × (blind generate → independent adjudicate).
Generation agents queried only `stem`/`stimulus` and were barred from
`frq_criteria`; adjudication agents queried the full rubric separately.

- 100 responses, 20 per archetype, 6× coverage of each of 6 required mechanisms.
- 437 criterion judgments: 219 earned / 204 not_earned / 14 unable_to_determine;
  20 flagged `unresolved_human_review_flag`.
- Independent invariant audit flagged 26/100 (25 = paraphrased rather than
  verbatim `evidence_quote`; 1 = genuine rubric defect in `APBIO-FRQ-L-025`).

**Harness bug found and fixed:** the Workflow tool delivers `args` as an
unparsed JSON string, not an object; two launch attempts failed on
`items.length` before the script was made to `JSON.parse` a string `args`.

## Stage 4 — Arm freeze ($0)

`frozen_arm_manifest.json`; prompt templates and shared criterion-contract text
SHA-256 hashed pre-scoring. Deterministic layer reuses the 5 existing seeded
AP Statistics `content_key`s (no re-derivation).

## Stage 5 — Low-number gate: two attempts, both FAILED

| Run | Items | Calls | Cost | Result |
|---|---|---:|---:|---|
| v1 | 20 (4/family) | 89 | $0.12123 | FAIL — Arm B p50 3,252 ms > 3,000 ms |
| v2 | 20 fresh, non-overlapping | 112 | $0.12826 | FAIL — Arm B p50 3,160 ms + schema 85% |
| diagnostic | 3 (the v2 failures) | 3 | $0.01281 | 3/3 recovered at 4,000-token cap |

Burned-run records: `stage5_v1_burned_run_record.md`,
`stage5_v2_burned_run_record.md` (the latter carries a **correction notice** —
its original root-cause attribution was wrong on two counts). Corrected
analysis: `ARM_B_ROOT_CAUSE_ANALYSIS.md`.

**Config-fidelity gap:** the manifest declares
`retries_on_transient_failure: 1`, but neither the Stage 5 nor Stage 6 runner
implemented retries. All reported schema-validity figures are therefore
no-retry figures. The Stage 5 v2 failures were deterministic truncation, so a
retry would likely have reproduced them; the 3 Stage 6 failures were not
diagnosed individually.

## Stage 6 — Full paired calibration

- Runner: `scripts/vercel-gateway-check/phase_c_stage6.mjs`. 100 items,
  sequential across items (parallel only *within* Arm A's criteria, which is
  its architectural definition — concurrent items would contend and corrupt
  latency measurement).
- **537 paid calls**: 437 Arm A + 100 Arm B. 0 budget stops.
- **Cost $0.6216 of the $5.00 cap.** Pre-call projection enforced before every
  request; cost computed from gateway-reported token usage, not estimated.
- Arm B ran with a **corrected 4,000-token cap** (prompt text unchanged from
  the hashed `arm_b_v2`); running the known-broken v2 cap would have reproduced
  a self-inflicted artifact rather than measured Arm B. Deviation recorded here
  and in the runner header.
- Schema failures: Arm A 3/437, Arm B 1/100. Not individually root-caused.
- Gate exposure tracked per item (40 of 100 appeared in a Stage 5 gate); clean
  held-out and gate-exposed subsets reported separately in `RESULTS.md` and
  agree to within 0.7 pp.

Raw records: `raw/stage6_arm_a.jsonl`, `raw/stage6_arm_b.jsonl`.
Metrics: `summary.json`. Analysis: `RESULTS.md`.

## Validation commands run

- Stage 2 deterministic self-check: 100/100 pass, 3 assertions per item.
- Stage 5 v2 selection asserted disjoint from v1 (`assert not (selected & burned)`).
- Stage 6 latency model cross-validated against measured token counts
  (predicted vs observed within ~10% at n=4 and n=10).
- McNemar paired test computed exactly (binomial, not chi-square approximation)
  given the small discordant count.

## Cumulative paid spend

| Stage | Cost |
|---|---:|
| 1–4 | $0.00000 |
| 5 v1 | $0.12123 |
| 5 v2 | $0.12826 |
| 5 diagnostic | $0.01281 |
| 6 | $0.62160 |
| **Total** | **$0.88390** |

## Not run

Feedback-quality judging for reason-match, minimum-fix sufficiency,
improved-answer correctness, and error-class accuracy (4 of the protocol's 5
dimensions). See `RESULTS.md` §6.
