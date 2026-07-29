# Cross-Subject Content Remediation — Packet 2 Production Report

**Applied:** 2026-07-27  
**Production project:** `pcntajvbdfqhbeewmdry`  
**Release migration:** `20260728024242_publish_ai_qa_pilot_and_run_second_packet.sql`  
**QA-correction migration:** `20260728024450_correct_packet_2_textual_qa_misses.sql`

## Release Policy

One qualified human review plus documented AI QA is sufficient for testing and
Production. A second qualified human review is an urgent follow-up, not a
blocking release gate. Every release decision records:

- `approval_basis=single_qualified_review_plus_ai_qa`;
- `second_human_review_status=follow_up_pending`;
- the source human review decision; and
- the packet identifier.

## Frozen Packet

### Rubric-point restructuring (7)

- `apphy1-frq-002`
- `apphy1-frq-003`
- `apphy1-frq-004`
- `apphy2-frq-017`
- `apphy2-frq-033`
- `apphycem-frq-019`
- `apphycm-frq-023`

### Assumption or convention repair (7)

- `apphy1-frq-028`
- `apphy2-frq-026`
- `apphy2-frq-027`
- `apphycem-frq-003`
- `apphycem-frq-007`
- `apphycm-frq-002`
- `apphycm-frq-006`

### Substantive rewrite (6)

- `APBIO-MCQ-074`
- `apchem-sfrq-005`
- `apphy1-frq-014`
- `apphy2-frq-030`
- `apphycem-frq-030`
- `apphycm-frq-014`

The packet spans Biology, Chemistry, Physics 1, Physics 2, Physics C:
Electricity and Magnetism, and Physics C: Mechanics.

## Production Outcome

- 20/20 source versions retired.
- 20/20 immutable successors approved and published.
- 20/20 parent items published.
- All FRQ stored totals equal the sum of rubric points.
- The MCQ has four unique choices and exactly one correct answer.
- All 20 retain the source qualified-human review in their decision provenance.
- All 20 are queued for second qualified human review.

The same release operation also approved and published all 21 successors from
packet 1, producing 41 total releases under the new policy.

## Post-Publish QA Finding and Correction

Independent live assertions found three phrase-selector misses in the initial
packet-2 migration:

- `apphy2-frq-026` did not receive the intended magnitude wording;
- `apphy2-frq-027` did not receive the intended opposite-sign wording; and
- `apphy2-frq-033` retained the unrounded final-energy rubric wording.

No published row was edited. Version 2 of each item was retired, a corrected
version 3 was created, re-approved through the same gate, and published. Live
verification confirms the required wording and significant-figures rule.

## Final Reconciliation

Production reports:

- 41 policy-based release decisions across the two packets;
- 41 current published successors;
- 41 second-review follow-ups;
- packet 2 split exactly 7/7/6 across the three repair classes; and
- 123 latest versions still in `changes_requested`, down from 143 before this
  packet.

This packet demonstrates a reusable cross-subject repair pattern, but it does
not substitute for the pending independent second-human reviews.
