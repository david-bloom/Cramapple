# Approve-with-edits remediation — 2026-08-05

## Scope

- Production project: `pcntajvbdfqhbeewmdry`
- Source sweep: `docs/Q&A/REVIEWER_QA_SWEEP_2026_08_05.md`
- SQL applied: `scripts/content-seed/reviewer-qa-remediation/20260805_approve_with_edits_remediation.sql`
- Explicit `approve_with_edits` decisions remediated: 37
- Gulgeldi Darrynow plain approvals treated as edit requests per owner direction: 7
- Total repaired successor versions: 44

## Result

The remediation created successor versions for all 44 repair targets, preserved the immutable source reviewer decisions, and added owner QA approval decisions pointing back to the triggering reviewer note.

After the repair, the publication sweep published:

- 44 repaired approve-with-edits / misrouted approve-with-edits successors; and
- 2 clean double-approve items: `apcalcbc-frq-u13-002` and `apcalcbc-frq-u13-006`.

No QA gate blocks were reported.

## Verification

Independent post-apply verification found:

| Check | Result |
| --- | ---: |
| Repaired versions with remediation marker | 44 |
| Repaired versions published | 44 |
| Owner QA approvals on repaired versions | 44 |
| MCQ structural failures | 0 |
| FRQ structural failures | 0 |
| Duplicate published versions per item | 0 |

## Repaired Keys

`APBIO-FRQ-L-008`, `APBIO-MCQ-005`, `apcalcab-frq-008`, `apcalcab-frq-011`, `apcalcab-frq-012`, `apcalcab-frq-016`, `apcalcab-frq-u13-002`, `apcalcab-frq-u13-006`, `apcalcab-frq-u13-018`, `apcalcab-mcq-012`, `apcalcab-mcq-014`, `apcalcab-mcq-015`, `apcalcab-mcq-016`, `apcalcab-mcq-019`, `apcalcab-mcq-020`, `apcalcbc-frq-015`, `apcalcbc-frq-u13-010`, `apcalcbc-frq-u13-014`, `apcalcbc-frq-u13-018`, `apcalcbc-mcq-026`, `apchem-frq-l-024`, `apchem-frq-l-027`, `apchem-mcq-030`, `apchem-mcq-068`, `apchem-sfrq-015`, `apchem-sfrq-022`, `apchem-sfrq-026`, `apchem-sfrq-027`, `apchem-sfrq-031`, `apchem-sfrq-033`, `apchem-sfrq-035`, `apchem-sfrq-037`, `apprecalc-frq-029`, `apprecalc-frq-u12-005`, `apprecalc-frq-u12-007`, `apprecalc-frq-u12-009`, `apprecalc-frq-u12-011`, `apprecalc-frq-u12-013`, `apprecalc-frq-u12-015`, `apprecalc-frq-u12-017`, `apprecalc-frq-u12-019`, `apprecalc-mcq-031`, `apprecalc-mcq-045`, `apstats-frq-u12-005`.
