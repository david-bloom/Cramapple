# Orly Source Log

One row per document received under
`docs/research/ORLY_EXTERNAL_ASSIGNMENT_MINING_PROTOCOL_2026_08_24.md`.

| Date received | School / teacher | Subject | Document type | CED units/topics covered | Category | Mined for | Items authored from it | Rights notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 2026-08-24 | Solebury School / Michelle Gavin | AP Calculus AB | Summer assignment, Unit 1 Part I (Flipped Math LT1.1-1.8) | 1.1-1.8 | CED-aligned unit content | Topic scope, pacing, self-assessment rubric | apcalcab-mcq-060, -070, -080, -090 (published to Prod 2026-08-24, David's direct approval) | References `calculus.flippedmath.com` video curriculum - licensed to the school, not embedded or linked by us |
| 2026-08-24 | Solebury School / Michelle Gavin | AP Chemistry | Summer assignment (no unit label) | None directly - prerequisite skills only | Prerequisite / readiness content | Confirms readiness-content is a real, distinct category (see protocol §4/§6) | None yet | Problems resemble standard textbook-style density/mole exercises; treated as restricted per protocol §2 |
| 2026-08-24 | Solebury School / Hannah Pritchett | AP Calculus BC | Summer assignment: DeltaMath problem set (Units 1 & 2) + 3 DeltaMath "Corrective Assignment" printouts (Mid-Unit 1, End-of-Unit 1, Unit 2 CA) | 1.1-1.16 (full unit), 2.1-2.10 (through quotient rule) | CED-aligned unit content, but source platform is DeltaMath (licensed third-party item bank), not teacher-authored - see protocol §2 revision below | Topic scope (both units), pacing, per-unit test cadence, corrective/remediation structure | apcalcbc-mcq-060, -070, -080, -090 (published to Prod 2026-08-24, David's direct approval) | DeltaMath is commercial curriculum software; "Corrective Assignment" packets are its own auto-generated item bank, not the school's original work - treat as *more* restricted than a teacher-authored worksheet, per the new §2 platform-content note |

**Publish note (2026-08-24):** all 8 items above went straight to Prod
`status='published'` on David's explicit approval ("simple versions of
questions assigned to Orly"), via
`supabase/migrations/20260824120000_orly_protocol_calc_unit1_unit2_items.sql`.
Each still walked `draft -> reviewed_approved -> published` so the DB's own
publish-gate and pipeline-guard triggers applied normally; `review_status`
is `answer_approved`, recording a Product Owner approval rather than a
standard second-reviewer pass. Not inserted into Dev. No
`content_taxonomy_labels` rows created yet, so these won't surface through
taxonomy-gated serving paths until the normal labeling pipeline runs.
