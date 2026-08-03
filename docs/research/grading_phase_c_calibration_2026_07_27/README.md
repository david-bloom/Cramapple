# TASK-0016 Phase C — Cross-Subject Calibration (2026-07-27)

**Status:** Stages 1-3 complete (frozen manifest, MCQ integrity, response
corpus + adjudication). Stages 4-6 not yet run. No paid model spend has
occurred yet (Stage 3 generation/adjudication used this session's own model
via the Agent/Workflow harness, not a billed API call against the Phase C
budget; Stages 5-6 are where the $1.00/$5.00 paid caps apply).

## What this folder is

Execution artifacts for `prompts/CLAUDE_TASK0016_PHASE_C_CROSS_SUBJECT_CALIBRATION_2026_07_27.md`,
run against Production `pcntajvbdfqhbeewmdry` (read-only).

## Stage 1 — Frozen item manifest

- `FROZEN_ITEM_MANIFEST.json` — 100 FRQ + 100 MCQ items, stratified across
  Biology, Chemistry, Statistics, Physics (4 SKUs), and Calculus/Precalculus
  (3 SKUs), selected deterministically (seed `phase_c_2026_07_27`, MD5-hash
  ordering, Hamilton/largest-remainder proportional apportionment). 36 of the
  100 FRQs are long-form (target was >=10).
- `EXCLUSIONS.json` — every excluded content_item_version group with counts
  and reasons.

### Eligibility rule (final)

```
tutor_decision IN ('approve','approve_with_edits')
  AND status IN ('reviewed_approved','published')
  AND review_status IN (NULL, 'question_review_approved', 'tutor_review_pending')
  AND (FRQ: >=1 frq_criteria row with non-empty learner_facing_text)
  AND (MCQ: >=2 choices, exactly 1 marked is_correct)
```

"Latest decision" is derived by `ROW_NUMBER() OVER (PARTITION BY
content_item_version_id ORDER BY COALESCE(submitted_at, created_at) DESC)`,
**not** `supersedes_id` — that column is populated on 0 of 765
`content_review_decisions` rows in Production today and cannot be used as the
prompt's literal "non-superseded decision" signal. This is a schema fact, not
a Phase C finding to act on, but it is worth someone confirming whether
`supersedes_id` is meant to be wired up elsewhere.

### Decisions made during this run (owner-confirmed, 2026-07-27)

1. **Exclude genuinely reopened/pending items.** `review_status` values
   `ap_reader_pending`, `difficulty_discussion`, `modification_reserved`,
   `excluded`, `answer_tutor_review_pending` are treated as real pending
   states and excluded, as are `status` values `draft`, `assigned`,
   `retired`, `changes_requested`, `reviewed_disapproved`, regardless of
   `review_status`.
2. **Include `status IN (reviewed_approved, published)` items whose
   `review_status` still reads `tutor_review_pending` despite a recorded
   `approve`/`approve_with_edits` decision.** Verified against a concrete
   case: AP Chemistry's 29 `reviewed_approved` MCQs matched the Product
   Owner's independently-known count exactly, while 12 `reviewed_approved`
   AP Chemistry FRQs left `review_status` stale at `tutor_review_pending`
   after decisioning. Treated as stale/unset pipeline metadata rather than a
   genuine reopen, and applied **consistently across every subject** (not
   only Chemistry) once confirmed.

Two earlier candidate completeness checks were tried and rejected as
incorrect during this run:
- Requiring `content_item_versions.canonical_answer_1` to be non-null for
  FRQs was **wrong** — only ~70% of FRQs populate that column; the rest
  (e.g. `APSTAT-MOD3-E004`, "range of data: 5, 8, 3, 12, 7") carry their
  canonical answer inside `frq_criteria.learner_facing_text`
  ("Correctly calculates range as 9 (12 − 3)") instead. The real
  completeness check is `frq_criteria` presence with non-empty
  `learner_facing_text`, which is what the frozen manifest uses.

### Known content-pipeline gap this manifest does not fix

**AP Calculus BC has zero eligible FRQs or MCQs** under every rule applied in
this run — all versions are `status=assigned` with no tutor decision at all
(never routed to review), plus one `published`+`tutor_review_pending` row
with no decision. AP Calculus AB only reached 12 eligible FRQs via decision
#2 above (relaxing the stale `tutor_review_pending` flag) and would have had
zero otherwise. This is a real, unresolved AP Calculus review-pipeline gap,
separate from Phase C — the "Calculus/Precalculus" family in this manifest is
carried almost entirely by AP Precalculus (31 of 43 eligible FRQs) plus a
thin AP Calculus AB slice; **no AP Calculus BC content is represented.**

Similarly, **AP Chemistry FRQ availability is thin at the source**: 55 of 66
Chemistry FRQ content_item_versions are still `assigned` (never sent to
tutor review) and 7 more are `changes_requested`. Decision #2 above raised
Chemistry's usable FRQ pool from 2 to 14, which is enough to meet its
proportional quota (10) in this run, but the underlying review backlog is
unresolved.

### Selected manifest shape

| Family | FRQ selected | MCQ selected |
|---|---:|---:|
| Biology | 14 | 12 |
| Chemistry | 10 | 11 |
| Statistics | 25 | 15 |
| Physics (4 SKUs) | 21 | 49 |
| Calculus/Precalculus (3 SKUs) | 30 | 13 |
| **Total** | **100** | **100** |

See `FROZEN_ITEM_MANIFEST.json` → `selection_log` for the full per-subject
pool/quota/selected breakdown.

## Stage 2 — MCQ integrity calibration

`stage2_mcq_integrity_summary.json` / `stage2_mcq_integrity_records.jsonl` —
100/100 frozen MCQs pass the production deterministic choice-match logic
(replicated from `evaluate-attempt/index.ts`) against both the correct and an
incorrect choice_key, and against choice_text. 0 content defects. $0 spend, 0
model calls, as required.

## Stage 3 — Response corpus and adjudication

`candidate_responses.jsonl` (100 synthetic FRQ responses, balanced 20/archetype
across fully_correct/partially_correct/boundary_adjacent/confidently_wrong_complete/
blank_off_topic, with 6x coverage of each of 6 required multi-part mechanisms),
`adjudicated_labels.jsonl` (437 independently-adjudicated criterion judgments),
`label_audit_report.md` (methodology, invariant audit, one genuine content
defect found in `APBIO-FRQ-L-025`'s rubric text), `stage3_summary.json`.

Executed as a Workflow: generation and adjudication subagents self-fetched
their assigned items' content directly from Production via the Supabase MCP
`execute_sql` tool (read-only), rather than the orchestrating session relaying
full item text through its own context — the first two launch attempts hit a
harness bug where the `args` value arrives as an unparsed JSON string rather
than a parsed object; the script now defensively `JSON.parse`s `args` when it
is a string.

Independent invariant audit found 26/100 responses with an `evidence_quote`
that isn't an exact substring of the response (paraphrase, not a scoring
error — see `label_audit_report.md`) and one genuine rubric-content defect
(inconsistent Human-Gorilla divergence figures across `frq_criteria` fields on
`APBIO-FRQ-L-025`) flagged for a separate content-ops fix.

This corpus is `calibration` tier per `GRADING_RESEARCH_CANONICAL_PROCESS.md`
— it supports Stage 4-6 architecture comparison, not a launch/gold claim.

## Stage 4 — Freeze the two FRQ grading arms

`frozen_arm_manifest.json` — both arms locked before any scoring:

- **Model/provider:** `google/gemini-2.5-flash` via the Vercel AI Gateway,
  thinking disabled, temperature 0, identical timeouts/retries in both arms.
  The *only* intended difference between arms is request architecture.
- **Arm A (parallel criterion baseline):** one model call per criterion, run
  in parallel (concurrency cap `min(criteria_count, 16)`); latency = max
  completion time across criterion calls.
- **Arm B (single structured multi-criterion challenger):** one model call
  per response, one schema returning every criterion's verdict; latency =
  single call completion time.
- Both arms share one frozen prompt template family built on the reusable
  9-field criterion-contract discipline from
  `frq02_label_audit_2026_07_27/RESULTS_REPEAT2_FINAL_GOLD_2026_07_27.md`
  (target proposition, sufficient evidence, near-misses, scope, polarity,
  contradiction policy, ECF policy, deterministic checks, minimal repair),
  plus the required per-criterion output fields (status, confidence-for-
  logging-only, evidence_quote, withheld_point_reason, minimum_fix,
  improved_answer, error_classification, gate_schema_status). Prompt
  templates and instruction text are SHA-256 hashed in the manifest so any
  post-freeze edit is detectable.
- **Deterministic layer:** reuses the 5 already-keyed AP Statistics
  `content_key`s from `statistics_phase_b_2026_07_08/statistics_item_keys.json`
  (the same 5 wired into Production's `math-verifier.ts` since 2026-07-12,
  PR #37) — `STATS-MOD3-M006`, `STATS-MOD1-E004`, `APSTAT-MOD3-E004`,
  `APSTAT-MOD6-M001`, `STATS-MOD1-M004` — all 5 happen to already be in this
  100-item frozen corpus. This gives the Ledger's open question #2 ("do the
  seeded content_keys correspond to live/published items?") independent
  confirmation via this run's own manifest. The other 95 items have no
  existing verification_profile and grade 100% on the model in both arms.
- **Pricing table:** `google/gemini-2.5-flash` at $0.30/1M input,
  $2.50/1M output tokens (Vercel AI Gateway published rate as of 2026-07-27;
  confirm against the live dashboard before Stage 5/6 spend) — for
  pre-run budget projection only; actual per-call cost is logged from the
  gateway usage response at run time.

No model calls were made for Stage 4 itself — this is configuration-freeze
only, $0 spend.

## Stage 5 — Low-number paid gate (n=20) — FAILED TWICE, Stage 6 not run

Two independent, non-overlapping 20-item gate attempts, both real paid runs
against `google/gemini-2.5-flash` via the Vercel AI Gateway:

| Run | Arm A schema-valid | Arm A agreement | Arm A p50 | Arm B schema-valid | Arm B agreement | Arm B p50 | Gate | Cost |
|---|---:|---:|---:|---:|---:|---:|---|---:|
| v1 (`stage5_v1_burned_run_record.md`) | 100% | 91.3% | 1,685ms | 100% | 95.7% | **3,252ms** | FAIL (Arm B latency) | $0.121 |
| v2 (`stage5_v2_burned_run_record.md`) | 98.9% | 90.1% | 1,712ms | **85.0%** | 91.2% | **3,160ms** | FAIL (Arm B latency + schema) | $0.128 |

**Arm A passed every gate bar on both independent slices without any repair.**
Arm B failed the p50 latency ceiling (≤3,000ms) both times, and also dropped
below the 95% schema-validity bar on run 2.

**A follow-up root-cause investigation (`ARM_B_ROOT_CAUSE_ANALYSIS.md`,
diagnostic cost $0.013) corrected the v2 write-up on one point and settled the
reparable-vs-dead-end question:**

- The **v2 schema failure was self-inflicted** by the repair's own too-tight
  token cap, not an Arm B property. A diagnostic rerun of all 3 failed items at
  a 4,000-token cap recovered **3/3 with every criterion returned**. Fully
  reparable in one line. (`stage5_v2_burned_run_record.md` originally
  misattributed this to "three 10-criterion items"; in fact one failure was a
  4-criterion item and one 10-criterion item succeeded — that record now carries
  a correction notice.)
- The **latency failure is structural and not reparable.** Measured across 36
  successful calls: `Arm B ≈ 610 + 637 × n_criteria ms` (267 tok/s generation,
  610 ms TTFB), versus **Arm A flat at ~1,700 ms regardless of n**. Arm B only
  wins at n_criteria=1; **88 of 100 corpus items have ≥2 criteria** (median 4,
  up to 10), so Arm B is dominated on 88% of the corpus and by ~4× at the tail.
  Closing the gap would require cutting per-criterion output 3–6× — deleting the
  evidence-quote / minimum-fix / improved-answer fields that are the product
  promise. The brevity repair already cut output 29% (239→170 tok/criterion) and
  wasn't close.
- Arm B's **original motivation is refuted**: it was proposed to tame max-of-N
  tail latency, but Arm A's per-call tail is benign here (p50 1,437ms, max
  3,179ms), so max-of-N costs little while Arm B pays the full serial sum.
- **Retained as live hypotheses, not findings:** Arm B is ~2.4× cheaper (Arm A
  re-sends shared context per criterion, 3.64× the input tokens) and scored
  equal-or-better criterion agreement on both slices (pooled 93.4% vs 90.6%,
  +2.8pp, not significant at these n). Worth revisiting only if cost or
  criterion-boundary quality — not speed — ever becomes the binding constraint.

**Verdict: close Arm B as a dead end for latency; retain Arm A.**

### ⚠ Bigger finding: neither arm meets the real launch bar

The 3,000 ms gate is only a stop-loss. The actual TASK-0016 bar is **end-to-end
p50 ≤ 1,000 ms**. Measured decomposition: **provider TTFB alone is ~588 ms —
59% of the entire budget**, leaving ~412 ms ≈ **110 output tokens**, against
Arm A's current **234 tokens per criterion (2.1× over)** — and that excludes
network, auth, DB writes, and render. **The launch bar cannot be met by
choosing between these two arms.** It needs a faster provider path, streaming
partial feedback (so perceived latency is TTFB-bound ~600 ms), far wider
deterministic-layer coverage than today's 5 seeded `content_key`s, or an
explicit revision of the 1,000 ms figure. This is a Phase F / launch-gate
decision and is the most consequential thing this run measured.

Total Stage 5 spend across both attempts: **$0.24949** (each gate run had its
own independent $1.00 cap; neither was close to being exceeded).

Cumulative Phase C spend across all stages so far: **$0.24949** (Stages 1-4
were $0; Stage 5 is the first paid work).

## Not yet run / open decision

Stage 6 (n=100 paid run, $5.00 cap) has **not** been run and should not
proceed on Arm B as currently specified, given the recommendation above. A
Product Owner decision is needed on how to close out Phase C: accept the
recommendation and stop, run Stage 6 on Arm A alone (single-arm, no paired
comparison), or fund new Arm B engineering work before any further spend.
