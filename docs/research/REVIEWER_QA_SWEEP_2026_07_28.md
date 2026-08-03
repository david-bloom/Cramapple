# Reviewer QA Sweep — 2026-07-28

**Production project:** `pcntajvbdfqhbeewmdry`  
**Window:** 2026-07-27 22:10:20 UTC through 2026-07-28 22:18:44 UTC  
**Eastern time:** 2026-07-27 18:10:20 through 2026-07-28 18:18:44  
**Prior documented sweep end:** 2026-07-27 13:19:11 UTC  
**Rule used:** the later of 24 hours before the sweep and the prior sweep end

## Scope and result

The window contained 82 human subject-review decisions from three active
reviewers:

| Reviewer | Decisions | Approve | Approve with edits | Disapprove |
| --- | ---: | ---: | ---: | ---: |
| Muhammad Saood | 40 | 2 | 38 | 0 |
| Muhammad Zeeshan | 23 | 8 | 14 | 1 |
| Sarah Sohail | 19 | 3 | 14 | 2 |
| **Total** | **82** | **13** | **66** | **3** |

The sweep checked:

- assignment and decision integrity for all 82 submissions;
- current-version alignment and lifecycle state for every reviewed version;
- MCQ choice count, keyed-answer uniqueness, and choice integrity;
- FRQ rubric presence, points, evidence requirements, and minimum-fix fields;
- all reviewer notes and concern codes;
- mathematical/scientific correctness of every approval and disapproval; and
- authored-versus-reviewer difficulty labels and topic-tag completion.

The 142 `owner_remediation_approval` decisions in the same wall-clock window
were reconciled separately and excluded from human reviewer performance.

## Defects found and corrected

### 1. Single-review blind groups did not resolve

Some single-review assignments carried a `blind_group_id`. The state trigger
treated every non-null blind group as a two-review group and returned without
updating lifecycle state when the group contained one assignment.

Correction:

- deployed migration
  `20260728223000_resolve_single_assignment_blind_groups.sql`;
- one-assignment groups now resolve as single reviews;
- true two-assignment groups still wait for both decisions;
- malformed groups larger than two remain conservatively unresolved; and
- all affected in-window single-review decisions were backfilled.

Post-repair verification found zero in-window one-assignment groups stranded
in `assigned`.

### 2. Pending Biology review pairs pointed at retired current versions

Eighteen Biology items had a submitted first review and a pending second
review, while both the parent item and assignment remained active but the
current content version was `retired`.

Correction:

- restored the 18 current versions to `assigned`;
- restored `review_status='tutor_review_pending'`; and
- preserved every assignment and immutable decision.

Post-repair verification found zero in-window assigned items pointing at a
retired reviewed version.

### 3. Two Chemistry approvals missed substantive defects

`apchem-sfrq-027`

- The rubric corrected the phrase “negative enthalpy” but failed to address the
  unsupported conclusion that lower enthalpy alone means “very stable.”
- The successor rubric now requires distinguishing lower product enthalpy from
  thermodynamic favorability, which requires considering `deltaG`.

`apchem-sfrq-030`

- The rubric scored increased temperature and decreased volume, but neither
  stress was actually stated in the prompt.
- The successor prompt now explicitly lists increased temperature, decreased
  volume, and catalyst addition.

Both original decisions remain immutable. Corrected version 2 successors were
created and independently approved.

### 4. One valid rejection was repaired

`apchem-sfrq-024`

- The rejection correctly identified that the item supplied background and
  rubric criteria but no actual question.
- A successor now explicitly asks for a collision-theory explanation covering
  temperature, concentration, activation-energy threshold, collision
  frequency, and orientation.

The original rejection remains immutable; corrected version 2 is approved.

### 5. One edit note contained an algebra transcription defect

`apchem-frq-l-022`

- The reviewer correctly requested explicit ICE-table algebra, but the note
  wrote the numerator inconsistently as `2x^2` in one place.
- The successor criterion now uses the correct equation
  `Kc=(2x)^2/(0.200-x)^2=54.3`, takes the positive square root, and obtains
  `x` approximately `0.157 M`.

The original edit request remains immutable; corrected version 2 is approved.

## Reviewer performance

### Muhammad Saood

- Completed 40 reviews: 38 precise `approve_with_edits` decisions and 2 sound
  approvals. His notes were unusually actionable, commonly supplying exact
  distractor replacements and the physical misconception each should test.
- No false approval was found. His strongest work was dimensional consistency,
  vector/scalar precision, experimental controls, and partial-credit rubric
  decomposition.
- All 40 topic selections were empty, and 21 of 40 difficulty labels differed
  from authored difficulty, almost always downward. Median submission spacing
  was 1.32 minutes, so future calibration should emphasize topic tagging and an
  explicit difficulty rubric.

### Muhammad Zeeshan

- Completed 23 Chemistry reviews: 14 edit requests, 8 approvals, and 1 valid
  rejection. He caught multiple missing-question defects and several concrete
  numerical or rubric omissions.
- Two approvals missed substantive prompt/rubric defects
  (`apchem-sfrq-027`, `apchem-sfrq-030`), and one otherwise valid edit note
  contained an algebra transcription error (`apchem-frq-l-022`). All three
  issues were corrected through immutable successors.
- All 23 topic selections were empty; 15 of 23 difficulty labels differed from
  authored difficulty, generally downward. Median submission spacing was 9.06
  minutes.

### Sarah Sohail

- Completed 19 Biology reviews: 14 edit requests, 3 sound approvals, and 2
  justified CED-scope rejections. No false approval was found.
- Topic tagging was complete on all 19 decisions. Her strongest judgments were
  AP-scope control and identifying compound rubric criteria that would produce
  inconsistent reader scoring.
- Several later edit notes correctly named a rubric-specificity problem but did
  not provide exact replacement language. More prescriptive minimum-fix text
  would make author remediation faster. Median submission spacing was 9.15
  minutes.

## Production verification

- 82 human decisions reconciled; no later human submission arrived during the
  sweep.
- 13 approvals, 66 edit requests, and 3 disapprovals accounted for.
- Every reviewed MCQ retained exactly four choices and one keyed answer.
- Every reviewed FRQ retained nonempty rubric, evidence, and minimum-fix
  fields.
- Four corrected successors are `reviewed_approved` with
  `question_review_approved`.
- Zero in-window single-review groups remain stranded in `assigned`.
- Eighteen pending Biology pair versions are active and await the second
  reviewer.
- No reviewed decision row was updated or deleted.
- Post-DDL security and performance advisors reported existing project-wide
  view, function, RLS, index, and Auth warnings; no finding named the repaired
  `app.tg_content_pipeline_on_decision()` function.

## Artifacts

- Schema repair:
  `supabase/migrations/20260728223000_resolve_single_assignment_blind_groups.sql`
- Immutable data/content repair:
  `scripts/content-seed/reviewer-qa-remediation/20260728_last_24h_reviewer_qa.sql`
