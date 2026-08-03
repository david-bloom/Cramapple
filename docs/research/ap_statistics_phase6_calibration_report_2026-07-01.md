# AP Statistics Phase 6 Calibration Report - 2026-07-01

**Status:** Blocked - required blind tutor-scored data is absent/incomplete.
**Related task:** `TASK-0013`, Phase 6.
**Protocol:** `docs/research/AP_STATISTICS_PHASE6_CALIBRATION_PROTOCOL.md`.
**Scope constraint:** No grading logic changed. No synthetic test cases used as a substitute for real tutor-scored data.

## Executive Summary

Phase 6 could not produce criterion-level agreement numbers because the required gold set does not exist for the live published AP Statistics pilot content.

The only AP Statistics content currently documented as live and gradeable is the 2026-07-01 smoke batch: 18 MCQs and 18 short FRQs. That batch was promoted directly to the production serving/grading tables at the Product Owner's direction after computational QA, explicitly bypassing the normal `content_review_assignments` / `content_review_decisions` tutor-review pipeline. The task protocol requires real independent blind tutor scores in those tables; there are no such scores documented for this batch.

Because the calibration sample is absent, this report stops at blocker status. It does not fabricate agreement rates, verifier lift, disagreement clusters, or launch confidence.

## Evidence Reviewed

- `docs/research/AP_STATISTICS_PHASE6_CALIBRATION_PROTOCOL.md`: requires published AP Statistics content with independent blind tutor scores recorded through `content_review_assignments` and `content_review_decisions`; forbids synthetic-only substitution.
- `docs/research/ap_statistics_phase4_mcq_smoke_batch_2026_07_01/README.md`: records the live AP Statistics smoke batch as 36 published items, states no `content_review_assignments` were created during staging, and states the later publish step promoted all 36 rows past the normal tutor-review pipeline.
- `docs/activity_log/ACTIVITY_LOG.md`: records the same production state: live and gradeable, not reviewed by a tutor, rights/originality gate not evaluated.
- `supabase/migrations/202606260002_content_review_workflow.sql`: confirms the relevant review tables and stages. These tables review content/canonical answers; they do not, by themselves, provide scored student-response gold labels unless populated with the required blind scoring payloads.
- `supabase/functions/evaluate-attempt/index.ts`: confirms MCQ grading is rule-based lookup (`model_id = "rule-based-mcq"`, zero model cost/tokens) and FRQ grading is LLM-based through the existing criterion result path.
- `scripts/ap_statistics_calculation_check/checker.py`: confirms the deterministic verifier exists as a standalone Phase 3 checker and remains unwired from `evaluate-attempt`.

## Live Data Access Note

I attempted to query `Cramapple - Production` (`pcntajvbdfqhbeewmdry`) through the Supabase connector for AP Statistics content, review-assignment counts, review-decision counts, attempts, and grading results. The connector failed before executing SQL:

```text
MCP startup failed: timed out awaiting tools/list after 29.999999841s
```

No live SQL result is therefore cited here. The blocker conclusion rests on the repository's current production execution record, which explicitly says no tutor/reader review happened for the live batch. A follow-up run should re-query production once the connector is available, but it must still stop unless real blind tutor-scored response data is present.

## Required Sample Size vs. Available Sample

Protocol target:

- Meaningful signal starts around `n = 40`.
- Full confidence starts around `n = 100`.
- For AP Statistics, the protocol expected the full pilot FRQ batch if available.

Available real tutor-scored calibration sample:

- Usable blind tutor-scored AP Statistics student responses: **0 confirmed**.
- Usable criterion-level tutor labels for published AP Statistics FRQs: **0 confirmed**.
- Published AP Statistics smoke content: **36 items documented** (`18` MCQ, `18` short FRQ), but content publication is not the same as blind scoring.

Because `n = 0` for confirmed real tutor-scored response labels, agreement calculations are not statistically limited; they are impossible.

## Criterion-Level Agreement

Not computed.

Reason: no real blind tutor-scored AP Statistics response set is available to compare against `evaluate-attempt` criterion results.

The report therefore cannot provide:

- overall criterion-level agreement;
- earned/not-earned confusion counts;
- per-criterion or per-item agreement;
- confidence by criterion type;
- boundary-case disagreement examples.

## LLM-Alone vs. LLM + Verifier

Not computed.

Reason: Phase 3's deterministic calculation checker is present, but the protocol requires comparison on the same real tutor-scored response set. Without tutor labels and corresponding `evaluate-attempt` outputs, any LLM-alone vs. LLM+verifier comparison would be synthetic or speculative.

The verifier should remain **standalone and unwired** until this comparison is run on real scored AP Statistics responses.

## Disagreement Clusters Requiring Adjudication

None identified from real data.

Reason: disagreement clusters require at least one three-way comparison among student response, `evaluate-attempt` criterion result, and blind tutor score. That dataset is absent.

Expected cluster categories to inspect once data exists:

- numeric answer correct but interpretation missing context;
- test statistic correct but p-value/conclusion inconsistent;
- confidence interval bounds correct but confidence-level or population-parameter wording wrong;
- condition-check responses that are statistically plausible but incomplete;
- ambiguous revised work with multiple numeric claims.

These are anticipated review lenses, not observed clusters from this run.

## MCQ Lookup Confirmation

MCQ grading does not require AP-Statistics-specific calibration beyond answer-key integrity checks.

`evaluate-attempt` handles MCQs through a deterministic branch: it finds the published correct choice in `app.mcq_choices`, compares the submitted choice to the correct `choice_key` or `choice_text`, writes one criterion result (`mcq_correct_choice`), records `model_id = "rule-based-mcq"`, and records zero input/output tokens and zero estimated cost.

For the published AP Statistics smoke batch, the Phase 4 record says every MCQ has exactly four choices and exactly one `is_correct` choice. That confirms lookup mechanics for the documented batch. It does not substitute for FRQ calibration.

## Recommendation

Do **not** wire the deterministic AP Statistics calculation verifier into live grading yet.

Plain-language reason: the checker may be promising, but we have not seen it improve agreement with real tutor scores on real AP Statistics student responses. The right next step is not more synthetic testing; it is to create or collect a blind-scored AP Statistics FRQ sample, run `evaluate-attempt`, run the verifier as a sidecar, and compare all three signals.

## Blocker to Clear

To unblock Phase 6, create a real calibration packet with:

1. Published AP Statistics FRQ content version IDs.
2. Real student responses or response-like tutor-scored attempts tied to those versions.
3. Independent blind tutor criterion scores, stored in the existing review/audit workflow or an equivalent immutable table with reviewer identity, blind group, rubric criterion, awarded/not-awarded status, and submitted timestamp.
4. `evaluate-attempt` grading results for the same responses.
5. A sidecar run of `scripts/ap_statistics_calculation_check/checker.py` only for criteria with explicit expected calculation specs.

Until those inputs exist, Phase 6 remains blocked and `TASK-0013` should not claim documented AP Statistics grader agreement/confidence numbers.
