# `approve_with_edits` State Repair

**Date:** 2026-07-27 EDT / migration applied 2026-07-28 UTC  
**Production project:** `pcntajvbdfqhbeewmdry`  
**Status:** Applied and verified

## Product rule

`approve_with_edits` is not final approval.

1. The edit request remains immutable audit evidence.
2. Before correction, the current question state is `changes_requested`.
3. Once the requested defect is corrected and that correction is confirmed,
   the corrected version receives a new immutable `approve` decision.
4. The current question then displays as approved.

## Root cause

Migration `20260720213000_content_pipeline_state_machine.sql` mapped both tutor
score 1 (`approve`) and tutor score 2 (`approve_with_edits`) to
`reviewed_approved`:

```sql
elsif new.tutor_score in (1, 2) then
  v_outcome := 'reviewed_approved';
```

It also allowed the last individual decision in a blind tutor pair to control
the state instead of resolving the pair as a pair.

## Repair

Migration:

`supabase/migrations/20260728005749_correct_approve_with_edits_state.sql`

The migration:

- adds `changes_requested` to item and version lifecycle states;
- maps a single score-2 decision to `changes_requested`;
- resolves blind pairs as:
  - `approve + approve` → `reviewed_approved`;
  - `approve + approve_with_edits` → `changes_requested`;
  - aggregate 4–6 → `reviewed_disapproved`;
- prevents a decision on an older content version from changing the parent
  question's current state;
- retains `modification_reserved` as the review-status signal for unresolved
  edits;
- adds a narrowly scoped `owner_remediation_approval` assignment purpose for
  a non-blind admin self-assignment;
- preserves ordinary subject-qualification enforcement for every normal
  reviewer assignment;
- writes new immutable `approve` decisions for correction-backed questions;
  and
- links each approval to the historical edit request through `supersedes_id`
  and structured decision provenance.

## Corrected questions flipped to approved

The repair set was intentionally conservative.

- 27 questions had a later immutable version carrying an explicit
  `qa_remediation` marker after an earlier `approve_with_edits`.
- `apphy1-frq-025` was added after the current six rubric criteria were checked
  directly against the tutor's note. Every requested numeric result and
  criterion split is present.
- Fresh edit requests on already-remediated versions were not flipped.
- Publication status alone was not treated as correction evidence.

### Counts

| Subject | FRQ | MCQ | Total |
| --- | ---: | ---: | ---: |
| AP Biology | 13 | 0 | 13 |
| AP Chemistry | 2 | 0 | 2 |
| AP Physics 1 | 1 | 0 | 1 |
| AP Precalculus | 9 | 1 | 10 |
| AP Statistics | 2 | 0 | 2 |
| **Total** | **27** | **1** | **28** |

### Keys

```text
APBIO-FRQ-L-001
APBIO-FRQ-L-003
APBIO-FRQ-L-005
APBIO-FRQ-L-007
APBIO-FRQ-L-009
APBIO-FRQ-L-025
APBIO-FRQ-L-031
APBIO-FRQ-L-038
APBIO-FRQ-L-041
APBIO-HDG-2026-GRAPH-004
APBIO-HDG-2026-GRAPH-008
APBIO-HDG-2026-GRAPH-011
APBIO-HDG-2026-GRAPH-012
apchem-frq-l-003
apchem-frq-l-005
apphy1-frq-025
apprecalc-frq-001
apprecalc-frq-005
apprecalc-frq-007
apprecalc-frq-008
apprecalc-frq-009
apprecalc-frq-010
apprecalc-frq-013
apprecalc-frq-014
apprecalc-frq-016
apprecalc-mcq-010
APSTAT-MOD4-M004
APSTATS-SFRQ-008
```

## Production verification

Post-migration read-only verification found:

- 28 remediation approval decisions;
- 28 distinct corrected latest versions;
- 28 submitted audit assignments;
- 28 assignments explicitly tagged `owner_remediation_approval`;
- all 28 corrected latest versions have the active label set
  `["approve"]`, with no active `approve_with_edits`;
- both lifecycle constraints include `changes_requested`;
- the deployed trigger contains the score-2, blind-pair, and latest-version
  protections;
- `anon`, `authenticated`, and `PUBLIC` cannot execute the trigger function
  directly; and
- the trigger has a fixed `search_path`.

The first two migration attempts failed inside their transactions and rolled
back completely:

1. the reviewer-qualification guard correctly rejected an unqualified admin
   assignment, leading to the explicit, constrained
   `owner_remediation_approval` purpose; and
2. a broad item-status synchronization touched an unrelated retired item,
   leading to a repair scoped only to unresolved edit-labeled latest versions.

The third migration application succeeded.

## Remaining edit-required state

The migration moved **234** latest, non-published questions that had only an
active `approve_with_edits` decision from false `reviewed_approved` to
`changes_requested`.

There remain:

- 23 published latest questions with `approve_with_edits` and no active
  `approve`;
- 4 published questions with both labels;
- 4 retired questions with only `approve_with_edits`; and
- 2 retired questions with both labels.

Published questions were not silently removed because earlier in-place edits
were not reliably tracked. They are now marked `modification_reserved` and
need a note-to-current-content audit. Only confirmed corrections should receive
the same immutable remediation approval.

## Advisor result

Supabase security and performance advisors were run after the DDL change. They
reported existing project-wide issues, including public security-definer views,
mutable search paths on older functions, RLS initialization-plan warnings,
unindexed foreign keys, and duplicate indexes. No new advisor finding named the
new assignment-purpose column or the repaired trigger.

Relevant Supabase remediation references:

- https://supabase.com/docs/guides/database/database-linter?lint=0010_security_definer_view
- https://supabase.com/docs/guides/database/database-linter?lint=0011_function_search_path_mutable
- https://supabase.com/docs/guides/database/database-linter?lint=0003_auth_rls_initplan
