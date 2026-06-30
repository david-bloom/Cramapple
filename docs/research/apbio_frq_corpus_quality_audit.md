# AP Biology FRQ Corpus Quality Audit

**Status:** Draft audit for tutor handoff readiness
**Scope:** 50 FRQs in the AP Biology export
**Corpus:** 20 short FRQs (`APBIO-FRQ-S-001` through `APBIO-FRQ-S-020`) and 30 long FRQs (`APBIO-FRQ-L-001` through `APBIO-FRQ-L-030`)
**Source:** `/Users/davidbloom/.codex/attachments/6595b704-fe28-415b-8f8f-01fb4c59a9c1/pasted-text.txt`

## Executive Summary

The FRQ corpus is broadly well formed and suitable for tutor review after a
small cleanup pass.

The strongest result is structural consistency: the prompts are self-contained,
AP Biology-aligned, and the short-FRQ set has clean criterion pairing overall.
The main issues are not content validity problems but metadata and rubric text
consistency problems that could confuse tutors or downstream scoring logic.

## Findings

### High Priority

1. `APBIO-FRQ-L-001`, `APBIO-FRQ-L-002`, and `APBIO-FRQ-L-003` have a points metadata mismatch.
   - `prompt_json.total_points = 8`
   - rubric points sum to `10`
   - Each of these long FRQs has five criteria at 2 points each, so the rubric
     is internally coherent, but the declared total points are wrong.
   - Recommended fix: either change `total_points` to `10` or merge/rebalance the
     criteria so the total returns to `8`.

2. `APBIO-FRQ-L-028` has the opposite points mismatch.
   - `prompt_json.total_points = 10`
   - rubric points sum to `8`
   - The rubric currently has four 2-point criteria, so the declared total points
     are overstated.
   - Recommended fix: change `total_points` to `8` unless a missing 2-point
     criterion is intentionally omitted.

3. `APBIO-FRQ-S-013` criterion `b` contains contradictory self-correction text.
   - The `evidence_requirements` text briefly says the cell will lose water, then
     corrects itself to gain water.
   - This is a tutor-facing ambiguity and should be cleaned before review.
   - Recommended fix: keep the correct version only:
     "The cell will GAIN water because the solution (-0.3 MPa) has a higher water
     potential than the cell (-0.5 MPa); water moves from higher to lower water
     potential, so water enters the cell."

4. `APBIO-FRQ-L-024` contains stray self-correction text in the rubric notes.
   - One of the criterion explanations includes a correction-style fragment
     (`Wait:` / `wrong` / similar self-repair language).
   - The underlying question is strong, but the rubric text should be cleaned so
     tutors see only one authoritative explanation.

### Lower Priority

1. Several long FRQs are ambitious and multi-part, but that is appropriate for
   the intended tutor-review use case.
2. The 20 short FRQs are otherwise cleanly matched and, based on the canonical
   pair review, were rated as useful for grading calibration.

## What Looks Ready

- The prompt set is pedagogically aligned with AP Biology topics.
- The short-FRQ set is structurally sound overall.
- The canonical answer pairs for the short set were reviewed cleanly, with no
  pair-level quality flags in the pair review report.
- The remaining issues are localized and fixable.

## Recommendation

The corpus is ready for tutor review **after** the following cleanup pass:

1. Fix the four metadata/rubric-text issues listed above.
2. Re-export the FRQ packet after those corrections.
3. Send the corrected packet to tutors.

## Cleaned Packet

The corrected tutor-ready packet has now been created at:

- [`apbio_frq_tutor_ready_packet.json`](/Users/davidbloom/Documents/Cramapple/docs/research/apbio_frq_tutor_ready_packet.json)
- [`apbio_frq_tutor_ready_packet.md`](/Users/davidbloom/Documents/Cramapple/docs/research/apbio_frq_tutor_ready_packet.md)

This version applies the four fixes identified in the audit and removes the
ambiguous self-correction text that could confuse a tutor review pass.

## Supporting Artifacts

- [Canonical pair review](/Users/davidbloom/Documents/Cramapple/docs/research/apbio_short_frq_canonical_pair_review_report.md)
- [Canonical answer takeaways](/Users/davidbloom/Documents/Cramapple/docs/research/apbio_short_frq_canonical_answer_takeaways.md)
