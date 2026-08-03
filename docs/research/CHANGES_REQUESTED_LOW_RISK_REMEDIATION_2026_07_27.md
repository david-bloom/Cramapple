# Changes-Requested Low-Risk Remediation Audit

**Date:** 2026-07-27  
**Environment:** Production Supabase `pcntajvbdfqhbeewmdry`  
**Population:** all 234 latest non-published questions placed in
`changes_requested` by the `approve_with_edits` state repair

## Outcome

Every question and its active tutor note was reviewed.

| Classification | Questions | Action |
|---|---:|---|
| Exact, bounded low-risk correction | 64 | Forked an immutable corrected version and approved it |
| Requested correction already present / no defect found | 6 | Preserved the current version and approved it |
| Author/tutor calibration required | 164 | Left in `changes_requested` |
| **Total audited** | **234** | |

The Production result is 70 newly approved latest questions and 164 latest
questions still in `changes_requested`.

## Low-Risk Boundary

A question was changed only when the active tutor note supplied exact,
bounded replacement wording for a stem, stimulus, MCQ choice, or choice
rationale. The edit also had to preserve the keyed answer and leave exactly
one correct, non-duplicated MCQ choice.

A question remained `changes_requested` if completing the note would require
any of the following:

- changing FRQ point allocation or splitting/combining scored criteria;
- adding a scientific or mathematical assumption not already fixed by exact
  tutor wording;
- designing a new experiment, diagram, graph requirement, or data set;
- selecting among alternative rewrites;
- inventing missing rationale wording; or
- changing multiple defects when the tutor specified an exact fix for only
  one of them.

This boundary is intentionally subject-independent. It treats exact mechanical
repairs as low risk and routes scoring, pedagogy, and content judgment back to
qualified authors or tutors.

## Approved Low-Risk Questions

| Subject / type | Count | Content keys |
|---|---:|---|
| AP Chemistry MCQ | 1 | `apchem-mcq-014` |
| AP Physics 1 MCQ | 11 | `apphy1-mcq-012`, `apphy1-mcq-019`, `apphy1-mcq-027`, `apphy1-mcq-028`, `apphy1-mcq-033`, `apphy1-mcq-037`, `apphy1-mcq-039`, `apphy1-mcq-040`, `apphy1-mcq-041`, `apphy1-mcq-045`, `apphy1-mcq-047` |
| AP Physics 2 MCQ | 17 | `apphy2-mcq-006`, `apphy2-mcq-009`, `apphy2-mcq-014`, `apphy2-mcq-016`, `apphy2-mcq-019`, `apphy2-mcq-025`, `apphy2-mcq-028`, `apphy2-mcq-029`, `apphy2-mcq-031`, `apphy2-mcq-033`, `apphy2-mcq-034`, `apphy2-mcq-036`, `apphy2-mcq-037`, `apphy2-mcq-039`, `apphy2-mcq-040`, `apphy2-mcq-041`, `apphy2-mcq-042` |
| AP Physics C: E&M MCQ | 19 | `apphycem-mcq-002`, `apphycem-mcq-003`, `apphycem-mcq-004`, `apphycem-mcq-022`, `apphycem-mcq-023`, `apphycem-mcq-024`, `apphycem-mcq-025`, `apphycem-mcq-027`, `apphycem-mcq-028`, `apphycem-mcq-030`, `apphycem-mcq-031`, `apphycem-mcq-034`, `apphycem-mcq-035`, `apphycem-mcq-036`, `apphycem-mcq-038`, `apphycem-mcq-039`, `apphycem-mcq-040`, `apphycem-mcq-041`, `apphycem-mcq-042` |
| AP Physics C: Mechanics MCQ | 16 | `apphycm-mcq-022`, `apphycm-mcq-023`, `apphycm-mcq-025`, `apphycm-mcq-027`, `apphycm-mcq-028`, `apphycm-mcq-030`, `apphycm-mcq-031`, `apphycm-mcq-032`, `apphycm-mcq-033`, `apphycm-mcq-035`, `apphycm-mcq-036`, `apphycm-mcq-037`, `apphycm-mcq-038`, `apphycm-mcq-039`, `apphycm-mcq-041`, `apphycm-mcq-042` |
| AP Precalculus FRQ | 1 | `apprecalc-frq-015` |
| AP Statistics MCQ | 5 | `APSTATS-MCQ-062`, `APSTATS-MCQ-066`, `APSTATS-MCQ-069`, `APSTATS-MCQ-072`, `APSTATS-MCQ-099` |

The five Statistics corrections were already present in their current versions.
The Precalculus tutor note explicitly said the prompt and rubric were accurate,
complete, and aligned. Those six versions were approved without a no-op fork.

## Questions Still Requiring Author/Tutor Work

| Subject / type | Count |
|---|---:|
| AP Biology FRQ / MCQ | 1 / 2 |
| AP Chemistry FRQ / MCQ | 7 / 6 |
| AP Physics 1 FRQ / MCQ | 23 / 7 |
| AP Physics 2 FRQ / MCQ | 31 / 7 |
| AP Physics C: E&M FRQ / MCQ | 32 / 10 |
| AP Physics C: Mechanics FRQ / MCQ | 29 / 8 |
| AP Statistics FRQ | 1 |
| **Total** | **164** |

The remaining MCQs are:

- AP Biology: `APBIO-MCQ-069`, `APBIO-MCQ-074`
- AP Chemistry: `apchem-mcq-003`, `apchem-mcq-005`,
  `apchem-mcq-011`, `apchem-mcq-020`, `apchem-mcq-050`,
  `apchem-mcq-053`
- AP Physics 1: `apphy1-mcq-002`, `apphy1-mcq-013`,
  `apphy1-mcq-014`, `apphy1-mcq-020`, `apphy1-mcq-022`,
  `apphy1-mcq-042`, `apphy1-mcq-050`
- AP Physics 2: `apphy2-mcq-002`, `apphy2-mcq-004`,
  `apphy2-mcq-005`, `apphy2-mcq-017`, `apphy2-mcq-020`,
  `apphy2-mcq-024`, `apphy2-mcq-026`
- AP Physics C: E&M: `apphycem-mcq-007`, `apphycem-mcq-009`,
  `apphycem-mcq-010`, `apphycem-mcq-011`, `apphycem-mcq-013`,
  `apphycem-mcq-014`, `apphycem-mcq-015`, `apphycem-mcq-017`,
  `apphycem-mcq-019`, `apphycem-mcq-020`
- AP Physics C: Mechanics: `apphycm-mcq-002`, `apphycm-mcq-004`,
  `apphycm-mcq-005`, `apphycm-mcq-009`, `apphycm-mcq-013`,
  `apphycm-mcq-017`, `apphycm-mcq-018`, `apphycm-mcq-019`

All 124 remaining FRQs require rubric, task-design, assumption, or
partial-credit decisions rather than a mechanical text substitution. Their
authoritative queue is the set of latest FRQ versions whose Production status
remains `changes_requested`.

## Production Method and Verification

Migration:
`supabase/migrations/20260728011701_remediate_low_risk_changes_requested.sql`

The migration:

1. locked and re-resolved every target against the latest version;
2. required an active `approve_with_edits` source decision;
3. refused to replace a keyed answer except for one explicitly verified
   ambiguity-only rephrase that preserved the answer;
4. retired the old version and cloned all version, choice, and rubric fields;
5. applied only the frozen exact replacements;
6. recomputed the content hash;
7. required exactly one correct MCQ choice and no duplicate choice text;
8. inserted a scoped `owner_remediation_approval` assignment and immutable
   score-1 decision, linked to the historical edit request with
   `supersedes_id`; and
9. verified both latest-version and parent-item state as
   `reviewed_approved`.

Post-migration Production reconciliation:

- 70 remediation approval decisions;
- 70/70 latest versions and parent items are `reviewed_approved`;
- 64 immutable corrected forks;
- 6 verified current-version approvals;
- 164 latest versions remain `changes_requested`.

No question was published by this remediation.
