# More help — AP Statistics units 1–3, Development output run (2026-10-15)

**Status: NOT release-ready.** Agent read finds answer disclosure on FRQ part (a) in 2 of 4 FRQ outputs. Human acceptance has not happened. Production unchanged.

Authority: owner approval 2026-10-15, "use 10 generations for Statistics", under the owner's rule of one subject at a time, units 1–3 only. Synthetic Development identity only (`…@example.invalid`), phase `before`, Development `more-help` v14, unit-gated reservation (`20261016000100`).

## Ledger (Statistics share of the 30-generation / $5 expansion cap)

| | Count |
| --- | --- |
| Provider requests reaching the model | 9 (8 delivered, 1 withheld by the output validator: `invalid_model_sources`, FRQ unit 3, then retried successfully) |
| Pre-provider refusals (no model call) | 2 (unit 5 MCQ: `reference_unavailable`; one `rate_limited` on the 24h delivered allowance) |
| Allowance remaining | 1 of 10 (conservatively 0 if the rate-limited call is counted) |
| Dollar cost | Not available in student-facing responses; not asserted |

## Coverage
Units 1, 2, 3 × MCQ and FRQ; some requests with learner focus/work (one with deliberately off-topic work, which the help correctly redirected). **Not covered:** `after`/graded phase, image-bearing questions (none in Statistics units 1–3), and end-to-end proof of the unit gate through the live function: the unit 5 probe was refused earlier for lack of Development reference content, so the gate itself is proven only by the rolled-back SQL test (`supabase/tests/more_help_unit_gate.sql`).

## Agent reading (not human acceptance)
- Clean: 6 of 8 (both unit 1 MCQ/FRQ outputs, unit 2 MCQs, unit 3 MCQ). They point at method and definitions without computing final values.
- **Disclosure finding:** G06 and G08 (unit 3 FRQ, part (a) = "identify the appropriate testing procedure and define the parameter") state the procedure (one-sample z-test for a proportion) and the parameter; G06 also hints the alternative's direction. The pre-submit disclosure checks did not catch this.
- The validator refusal (`invalid_model_sources`) shows the output gate works; a retry succeeded.

## Decision needed from the Product Owner
Accept as tolerable help (unanswered FRQ may reveal procedure selection), or require a pre-submit rule that FRQ parts asking to *identify/define/state* may not be answered. Until decided, do not deploy Statistics.

Private packet with full question text and outputs (not committed): `tmp/more_help_stats_review_packet_2026_10_15.md`. Dev fixtures created: 6 single-item sessions for the synthetic identity (Statistics units 1, 2, 3 and one unit 5).
