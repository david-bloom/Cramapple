# Grading Packet Backlog - 2026-07-07

> **Superseding priority (2026-07-08, DECISION-0034).** The breadth-first
> ordering below is retained for history but is no longer the active direction.
> The active priority is **depth: one fully-adjudicated AP Biology gold set**
> (dual-blind human scoring + lead adjudication, meeting the §12.2 held-out
> minimums for the launch questions) *before* more synthetic breadth packets.
> Rationale: every decision-grade result so far is a single question against a
> provisional corpus, and only adjudicated gold evidence can test the governance
> release thresholds. See
> [grading_cross_subject_takeaways.md](./grading_cross_subject_takeaways.md)
> Lesson 7. The breadth families below remain valuable for pipeline exercise and
> resume *after* the gold set exists; when generated, each must carry a
> `development` corpus tier (canonical process, Corpus Tier Labeling) and, for
> FRQs, must not rely on truncation-only wrong answers, which do not test the
> confidently-wrong-but-complete failure mode.
>
> **Progress (2026-07-08).** Three `calibration`-tier gold-set-candidate packages
> now exist (`ap_biology_gold_set_candidate_2026_07_08/`,
> `ap_statistics_gold_set_candidate_2026_07_08/`,
> `ap_chemistry_gold_set_candidate_2026_07_08/`), each with AI provisional labels,
> a blind dual-scoring harness, and an adjudication queue — see
> [grading_gold_set_candidates_2026_07_08_report.md](./grading_gold_set_candidates_2026_07_08_report.md).
> The remaining work is **human adjudication** (AP Biology first) to upgrade them
> to `adjudicated_gold`, a Statistics calculation checker, and hand-authored
> wrong-reasoning Chemistry responses (the sampled Chemistry variants proved
> truncation-degenerate).

This backlog turns the current grading-research direction into the next packet families to prepare.
It follows `docs/research/grading_test_packet_requirements.md` and the fixed 4-criterion contract pattern already used in the AP Statistics HDR and AP Biology spike packages.

## Why more packets are needed

The current corpus is strong enough for calibration and ablation on a small set of items, but it is not yet broad enough to support general claims across:

- subject,
- question type,
- module,
- difficulty,
- and hand-drawn response style.

To keep learning general rather than overfitting to one prompt family, the next packets should widen the coverage before the next benchmark round.

## Recommended next packet families

| Priority | Packet family | Purpose | Minimum shape |
| --- | --- | --- | --- |
| 1 | AP Statistics FRQ packet | Establish non-HDR Stats baseline | one FRQ corpus with a fixed 4-criterion contract per item |
| 2 | AP Statistics hand-drawn FRQ packet | Generalize Stats grading to handwritten work | one HDR corpus matched to the same Stats contract style |
| 3 | AP Biology FRQ packet | Establish Biology baseline | one FRQ corpus with the same 4-criterion contract shape |
| 4 | AP Biology hand-drawn FRQ packet | Generalize Biology grading to handwritten work | one HDR corpus matched to the Biology contract style |
| 5 | Hard-case calibration packet | Target the known failure modes | a smaller set focused on borderline geometry, completeness, and rubric ambiguity |

## Packet setup fields still required

For each packet family, the packet-preparer should ask only for:

1. subject,
2. question-type distribution,
3. difficulty distribution,
4. module distribution,
5. special instructions.

## Suggested generation order

1. AP Statistics FRQ.
2. AP Statistics hand-drawn FRQ.
3. AP Biology FRQ.
4. AP Biology hand-drawn FRQ.
5. Hard-case calibration packet.

## User role boundary

For content generation, the user only needs to:

- procure hand-drawn responses when a packet needs them, and
- answer the five setup questions above.

Everything else should be standardized by the packet template and the experiment package.

## Notes

- Use the same contract shape unless a packet intentionally tests a rubric revision.
- Keep per-subject packet reports separate until each packet has its own evaluation result.
- Only pool results after the per-packet reports exist.
