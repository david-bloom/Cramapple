# Grading Packet Backlog - 2026-07-07

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
