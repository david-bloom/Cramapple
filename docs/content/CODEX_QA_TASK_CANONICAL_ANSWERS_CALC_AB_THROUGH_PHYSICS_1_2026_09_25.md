# Codex QA Task — Canonical Answer QA, Calc AB Through Physics 1 (2026-09-25, update)

**Scope, precisely.** This task is criterion-4 (canonical answer) correctness QA plus a lightweight,
confirm-only pass on the other five servability criteria. It is renamed from an earlier working title
("Full Content Readiness") that overstated its scope — a reviewer flagged that the title implied a full
audit of the session's broader readiness work, when the task actually does NOT: validate whether the
not-yet-run work orders (Precalculus, Calculus BC, Chemistry labels/difficulty, the Physics C
Mechanics/Calc BC relabel order) still accurately reflect current Production state; call the live
serving selectors (`public.select_practice_frqs`, `app.select_unit_gated_practice_items`) to confirm
what actually gets served, as opposed to what the underlying data implies should be servable; or check
exam-pack-version singularity platform-wide (only for these seven subjects). That broader audit is a
separate, deliberately separate task — see
`docs/content/CODEX_QA_TASK_READINESS_AUDIT_WORK_ORDERS_AND_SELECTORS_2026_09_25.md`. Keeping this task
scoped to canonical-answer QA keeps an already-large 372-item review from becoming unwieldy; run both
tasks if you want full coverage, but they are independent and can run in either order.

**What changed since the last version.** The prior QA task
(`docs/content/CODEX_QA_TASK_SUBJECT_CONTENT_READINESS_CALC_AB_THROUGH_PHYSICS_2026_09_25.md`) covered
five subjects authored 2026-09-24/25 (Calc AB, Chemistry, Physics 2, Physics C: Mechanics, Physics C:
E&M). Overnight 2026-09-25, Claude directly authored and applied canonical-answer content for two more
subjects — **AP Statistics** (35 items) and **AP Physics 1** (39 items) — bringing the total FRQ with a
canonical answer across all seven subjects to **372**. This task supersedes the prior one: it keeps
everything from Parts A-D below but adds Statistics and Physics 1 to every part's scope, adds a new Part
E specific to a real defect found overnight that changes what "verified" should mean here, and adds Part
F (a precise, non-assertive method for the "no collateral damage" check that Part A's span-integrity
check implicitly relies on).

**Why Part E exists — read this before starting.** During Claude's own independent post-apply
re-verification of the Physics 1 batch, two items (`apphy1-frq-033` and `apphy1-frq-035`) were found to
have their `content_item_version_id`s swapped at the source-data stage: each item's canonical answer and
spans were internally self-consistent (span concatenation matched `canonical_answer_1` exactly, so the
authoring migration's own in-transaction check passed cleanly), but the spans' `criterion_keys` covered
the *other* item's `frq_criteria` rows entirely — i.e., apphy1-frq-035 (a spring/friction energy problem)
had apphy1-frq-033's SHM-graphs content applied to its current version, and vice versa. This was only
caught because a follow-up check compared each version's covered criteria against that version's actual
`frq_criteria` rows, not just against its own span concatenation. It was fixed directly in Production
(see the corrective section appended to
`supabase/migrations/20260925060000_apphysics1_canonical_answers_39_items.sql`) and re-verified clean.
**This means span-concatenation integrity alone, which Part A.5 below already asks for, is not
sufficient to catch a version-identity swap — you must also independently confirm each item's covered
criteria set matches that item's own stem/rubric content, not just that the spans are internally
consistent.** Treat this as a real, encountered failure mode, not a hypothetical — actively look for it
across all seven subjects, not just re-confirm the two known-fixed items.

**Context.** Over 2026-09-24/25, Claude directly authored and applied canonical-answer content for 195
published FRQ items across seven subjects (Calc AB, Chemistry, Physics 2, Physics C: Mechanics, Physics
C: E&M, AP Statistics, AP Physics 1), fixed a live grading bug in Calc AB (duplicated `frq_criteria`),
and fixed a version-identity swap in Physics 1 (this task's Part E). This task asks Codex to
independently verify the full current servability state of all seven subjects — not just the new
content, all of it — against the six criteria in `docs/product/SUBJECT_SERVABILITY_CRITERIA.md`.

**Subjects and current measured state** (re-confirm all of this as your first step; it should not need
rediscovering, but don't skip re-confirming it just because it's already measured):

| Subject | FRQ total | FRQ w/ canonical | MCQ total | Labels validated / non-validated | Difficulty rows | Exam pack versions published |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| AP Calculus AB | 62 | 62 | 62 | 9 / 82 | 0 / 124 | 1 |
| AP Chemistry | 53 | 53 | 70 | 45 / 78 | 0 / 123 | 1 |
| AP Physics 2 | 37 | 37 | 42 | 10 / 69 | 0 / 79 | 1 |
| AP Physics C: Mechanics | 42 | 42 | 42 | 4 / 80 | 0 / 84 | 1 |
| AP Physics C: E&M | 55 | 55 | 48 | 6 / 97 | 0 / 103 | 1 |
| AP Statistics | 69 | 69 | 101 | 44 / 126 | 0 / 170 | **2 (routing hazard — see below)** |
| AP Physics 1 | 54 | 54 | 63 | 7 / 110 | 0 / 117 | 1 |

**Total FRQ with a canonical answer across these seven subjects: 372.** That is the correct scope for
the correctness deep-dive below — not just the 195 Claude touched this week. The other ~177 have never
been independently re-verified by anyone and should not be assumed correct just because they predate
this week's work.

**AP Statistics has a known, separate, untouched P0**: two `exam_pack_versions` rows are simultaneously
published for Statistics (`548f06be-ccf4-426d-b82b-b424137a4438`, the old/general pack, 193 items, the
only one actually serving FRQ; and `7c5a2975-8f0e-45b9-8fcc-7ec9b8d81ada`, a newer MCQ-only pilot pack
serving 0 FRQ). All of this task's Statistics numbers (69/69 FRQ) are scoped to the functioning version
only. This routing hazard is NOT in scope to fix here — confirm it is still exactly as described (Part
C, criterion 6) and do not attempt to resolve it.

Proposal/report only — no Production writes. Read-only SQL against Production.

Paste the block below into Codex.

```text
QA task — canonical answer QA, Calc AB through Physics 1, 2026-09-25 (update).

Merge main first:

    git fetch origin
    git switch codex/qa-canonical-answers-calcab-through-physics1-2026-09-25
    # If that branch does not exist instead run:
    # git switch -c codex/qa-canonical-answers-calcab-through-physics1-2026-09-25 origin/main
    git merge origin/main

The checkout must be clean before starting. This is a QA pass against Production
(pcntajvbdfqhbeewmdry) -- read-only SQL and read-only edge function calls only, report findings as a
doc, no writes.

READ FIRST:
- docs/product/SUBJECT_SERVABILITY_CRITERIA.md (the six criteria and how to measure each one)
- docs/content/CODEX_QA_TASK_SUBJECT_CONTENT_READINESS_CALC_AB_THROUGH_PHYSICS_2026_09_25.md (the prior,
  five-subject version of this task -- if that task has already been run and a report exists at
  docs/content/CODEX_QA_REPORT_SUBJECT_CONTENT_READINESS_CALC_AB_THROUGH_PHYSICS_2026_09_25.md, read it
  too; you do not need to redo work it already did carefully, but DO re-run Part E's criteria-vs-item
  cross-check against all five of those subjects too, since that check did not exist when that report
  was written)
- docs/content/CLAUDE_QA_REPORT_AP_STATISTICS_AND_PHYSICS_1_2026_09_25.md (Claude's own read-only
  measurement QA pass on Statistics/Physics 1, done before this week's canonical-authoring work)
- docs/product/AP_CALCULUS_AB_LAUNCH_READINESS_2026_09_25.md
- docs/product/AP_CHEMISTRY_LAUNCH_READINESS_2026_09_25.md
- supabase/migrations/20260925000000_apcalcab_dedupe_frq_criteria.sql (the live grading-bug fix)
- The seven canonical-answer migrations: 20260925010000 (Calc AB), 20260925020000 (Physics 2),
  20260925030000 (Physics C: Mechanics), 20260925040000 (Physics C: E&M), 20260925050000 (AP
  Statistics), 20260925060000 (AP Physics 1 -- read this one in full, including the corrective section
  appended at the end that fixes the version-swap defect described in Part E) -- Chemistry's single item
  (apchem-frq-l-012) was applied directly, not via a dedicated migration file; find it via git log or
  by querying Production directly.
- prompts/CODEX_WORK_ORDER_AP_PHYSICS_1_LAUNCH_READINESS_2026_09_25.md and the sibling Precalculus/
  Calculus BC/Chemistry-labels-and-difficulty/Statistics work orders, just to confirm you are not
  duplicating scope that belongs to those separate, not-yet-run orders (labels and difficulty for these
  seven subjects are explicitly NOT this task's job -- see Part C below for what this task does check
  about them, which is narrower than closing them).
- Physics 2, Physics C: Mechanics, Physics C: E&M, AP Statistics, and AP Physics 1 do not yet have
  dedicated launch-readiness docs the way Calc AB and Chemistry do -- their current state lives in
  docs/product/SUBJECT_SERVABILITY_CRITERIA.md's tracking table and in the migration file headers.
  Note this gap in your deliverable; writing those docs would be a reasonable follow-up but is not
  required by this task.

PART A -- CANONICAL ANSWER CORRECTNESS, ALL 372 ITEMS (not just the 195 Claude authored this week)

For every FRQ with a non-null canonical_answer_1 across these seven subjects (372 total -- query
Production directly for the current exact list, don't rely on a static count that could have drifted):

1. Read the stem, stimulus, and frq_criteria directly from Production.
2. Independently work the problem from first principles yourself, before looking at
   canonical_answer_1. Only after deriving your own answer, compare it to what is stored.
3. Do NOT confirm correctness by checking that canonical_answer_1 matches the rubric's
   learner_facing_text -- that only proves self-consistency between two pieces of authored content,
   not that either is actually correct. This is exactly how a live Calc AB grading bug (duplicated
   frq_criteria doubling point totals on 4 items) and an earlier Biology rubric error were found: by
   independent re-derivation, not by cross-checking authored artifacts against each other.
4. For every item, explicitly record three separate judgments, not one flattened verdict:
   - Is the canonical answer correct (does it match your independent derivation)?
   - Is the rubric (frq_criteria) itself correct (does your independent derivation also confirm the
     rubric's stated correct values/reasoning)?
   - Do the canonical answer and the rubric agree with each other?
   These three can diverge independently -- a correct canonical answer can expose an incorrect rubric,
   which is a different, arguably more serious finding than a canonical-answer error alone.
5. Span integrity for each item: span concatenation equals canonical_answer_1 exactly (byte-for-byte);
   every frq_criteria criterion_key is covered by exactly one span's criterion_keys array (no
   criterion missing, none duplicated across spans, none extra); assembly_literal spans have an empty
   criterion_keys array. Re-verify this against current Production state -- do not trust that an
   applying migration's own in-transaction check is still true today.

Budget the most time on the Physics C subjects (E&M and Mechanics), which involve calculus-based
derivations (Gauss's law integrals, RC/RL circuit differential equations, rotational dynamics, orbital
mechanics) where a plausible-looking but wrong intermediate step is easy to miss on a skim. AP Statistics
and AP Physics 1 are new to this task's scope and have not been independently re-derived by anyone yet --
treat them with the same rigor as everything else, not as a lighter pass just because they were added
later.

PART B -- THE CALC AB GRADING-BUG FIX

Confirm apcalcab-frq-np2-008, apcalcab-frq-u13-002, apcalcab-frq-u13-006, and apcalcab-frq-u13-018 each
now have exactly one frq_criteria row per criterion_key (not two), and that no other FRQ item in any
of the seven subjects has the same exact-duplication pattern that might have been missed by the
original fix's scope.

PART C -- LIGHTWEIGHT VERIFICATION OF THE OTHER FIVE CRITERIA (confirm state, don't close gaps)

For each of the seven subjects, independently re-measure (don't just copy the table above) and confirm
or correct:
- Criterion 1 (reviewed/approved): item and version status counts.
- Criterion 2 (rubric/MCQ correctness): every FRQ has at least one frq_criteria row; every MCQ has
  exactly one is_correct choice. Report any subject where this is no longer true (it was measured
  clean earlier this week, but re-confirm, don't assume it's stayed that way).
- Criterion 3 (serving labels): confirm the validated/non-validated counts in the table above are
  still accurate as of today.
- Criterion 5 (difficulty): confirm the row counts in app.content_item_difficulty are still accurate.
- Criterion 6 (exam pack version): confirm exactly one published, non-retired exam_pack_version per
  subject, with the single known exception of AP Statistics -- for Statistics, confirm the dual-version
  finding is unchanged (still exactly two published versions, still exactly the same one serving FRQ)
  and do not attempt to resolve it. For every other subject, a second published version appearing would
  be a new routing hazard on par with Statistics' -- treat this check as high-priority even though it's
  quick.
This is a confirmation pass, not new authoring or gap-closing -- if you find labels or difficulty gaps,
report them, don't propose fixes (that's the separate, already-written work orders' job).

PART D -- GRADING-PATH REACHABILITY (not a per-subject spot check spree -- one call is sufficient)

For each of the seven subjects, make exactly ONE app.qa_grade_frq call against any one FRQ item with a
canonical answer, and confirm it returns the qa_path_ap_biology_only 409 (or report if it does NOT --
that would mean the gate has changed since this task was written, which would be a significant finding
requiring you to then actually run a fuller grading-verification pass). Do not repeat a call that returns
this same 409 multiple times per subject; one confirmed instance per subject is sufficient evidence that
the path is closed for that subject. If you want a working positive control to confirm your qa_grade_frq
usage itself is correct (not the source of the 409), you may run it once or twice against a Biology FRQ,
where the path is open -- but that is a sanity check on your own method, not part of this task's
seven-subject scope.

Report this finding prominently: as things stand, there is currently no way to verify via the grading
pipeline itself that any canonical answer in these seven subjects actually grades correctly when a
student submits it -- all grading-quality assurance for these seven subjects currently rests on the
independent-re-derivation and span-integrity checks in Part A, not on the grader itself. This is worth
escalating as its own follow-up (opening the QA path to non-Biology subjects, or building an equivalent
QA harness for them) separately from this task.

PART E -- VERSION-IDENTITY CROSS-CHECK (new this update)

This is the check that would have caught the apphy1-frq-033/035 swap before it reached Production. For
every one of the 372 FRQ with a canonical answer across all seven subjects:

1. For the item's current published version, list the distinct criterion_keys actually covered by its
   canonical_answer_spans (answer_field='canonical_answer_1').
2. Separately list the criterion_key set from that same version's frq_criteria rows.
3. Confirm these two sets are identical (same criteria, same count) -- this is a STRONGER check than Part
   A.5's span-concatenation check, because a version-identity swap between two items with the same
   *number* of spans but different *criteria* can pass concatenation integrity while still being
   completely wrong content, exactly as apphy1-frq-033/035 was until caught.
4. For any item where this check fails, additionally read the actual span text against the item's own
   stem and confirm whether the content is simply mismatched-but-fixable (a version swap, like
   apphy1-frq-033/035) or something else (e.g. a genuine content gap). Report the content_key, the
   version_id, and the specific criterion sets that disagree.
5. As a spot-check beyond the pure key-set comparison, for a sample of at least 10 items per subject (or
   all items, if a subject has fewer than 10), read the actual span text and confirm it topically matches
   the item's own stem/stimulus -- a criterion_key-set match does not guarantee the span text itself
   wasn't swapped between two items that happen to use an identical criterion-key naming convention
   (e.g. two items that both use generic part-a-criterion-01/02/03 keys). This is the failure mode the
   key-set check in steps 1-3 cannot catch by itself.

Confirm explicitly that apphy1-frq-033 and apphy1-frq-035 (the two items already found and fixed) now
pass this check cleanly, but do not stop there -- this check has not been run against the other 363
items, including the 177 that predate this week's authoring work entirely.

PART F -- NO-COLLATERAL-DAMAGE CHECK (precise method, not an assertion)

Earlier drafts of this task asserted "no collateral damage" without a method to actually establish
that -- git history proves what the migrations *intended* to change, but does not by itself prove
nothing *else* in Production changed during this work window. There is no pre-change table snapshot, so
this cannot be a byte-for-byte diff; instead, use timestamps as a bounded, precise substitute:

1. The work window for this session's canonical-answer authoring is 2026-09-25 01:00:00 UTC through the
   current time (i.e., from just before the first migration, 20260925000000, to now). Confirm this
   window against `git log --format='%ad' --date=iso -1 <first and last commit hashes>` yourself rather
   than trusting this task's stated boundary blindly.
2. Query `app.content_item_versions` PLATFORM-WIDE (not scoped to these seven subjects) for every row
   with `updated_at` inside that window. For each one, confirm its `content_item_id` maps to a
   `content_key` that is explicitly named in one of the seven migration files' header comments or this
   task's own item lists. Any row in that window NOT accounted for by a named migration is a collateral
   change and must be reported as a P0 finding regardless of whether the change itself looks benign.
3. Do the same for `app.canonical_answer_spans` using `created_at` in the same window (spans are
   insert-only in this workflow, so `created_at` is the right column, not `updated_at`).
4. Do the same for `app.frq_criteria` in the same window, specifically to confirm the Calc AB dedupe fix
   (Part B) is the only source of frq_criteria row changes in this window -- any other frq_criteria
   change in this window outside the four named Calc AB items is unexplained and must be reported.
5. This check is platform-wide by design, not limited to the seven subjects in scope -- the whole point
   is to catch a change that landed somewhere unexpected, which a subject-scoped query would definitionally
   miss.

DELIVERABLE

`docs/content/CODEX_QA_REPORT_CANONICAL_ANSWERS_CALC_AB_THROUGH_PHYSICS_1_2026_09_25.md`:

- One section per subject with a table of all its FRQ-with-canonical items (372 total across the
  seven), each row showing: content_key, canonical-answer verdict, rubric verdict, agreement verdict,
  span-integrity result, version-identity cross-check result (Part E), and a severity tag for any
  problem found (P0 = canonical answer or rubric is mathematically/scientifically wrong, OR a
  version-identity mismatch delivering the wrong content to students; P1 = span/coverage mismatch with
  no correctness impact on the stored text; P2 = documentation/tracking discrepancy, e.g. a stale count
  in a doc).
- A dedicated section for the Calc AB grading-bug re-verification (Part B).
- A section per subject for the Part C lightweight six-criteria confirmation, flagging any drift from
  the table above, and explicitly re-confirming the AP Statistics dual-exam-pack-version finding is
  unchanged.
- A single top-line section on the grading-path reachability finding (Part D), written so it's visible
  without reading the rest of the report.
- A single top-line section on the Part E version-identity cross-check, covering all 372 items --
  written so it's visible without reading the rest of the report, since a version-identity swap is a
  P0-class defect (wrong content reaching a real student) distinct from a plain correctness error.
- A single top-line section on the Part F no-collateral-damage check, listing the exact window used and
  every unaccounted-for row found platform-wide (or stating none were found, with the query used to
  establish that).
- A summary table across all seven subjects: items checked, canonical-correct, rubric-correct, both
  agree, span-clean, version-identity-clean, by severity tag.

WHAT WOULD MAKE THIS REJECTED

- Verifying only the 195 items Claude authored this week instead of all 372 with a canonical answer.
- Confirming correctness by comparing against the rubric's learner_facing_text instead of an
  independent derivation from the stem -- and specifically, collapsing "canonical answer correct,"
  "rubric correct," and "they agree" into one flattened verdict.
- Reporting span-integrity or version-identity as "already verified by the migration" without
  re-running the check yourself against current Production state.
- Treating Part E as satisfied by re-confirming only apphy1-frq-033/035 instead of running it against
  all 372 items.
- Treating Part E's key-set comparison (steps 1-3) as sufficient without doing the topical spot-check
  in step 5 on at least 10 items per subject.
- Repeating the qa_grade_frq 409 many times per subject and calling that thorough, instead of treating
  one confirmed 409 per subject as sufficient and reporting the blocker itself as the finding.
- Silently absorbing the grading-path-reachability or version-identity findings into a minor bullet
  point instead of surfacing each as a top-line, hard-to-miss result.
- Scope creep into actually closing labels or difficulty gaps for any subject (Part C is
  confirm-only), or attempting to resolve AP Statistics' dual-exam-pack-version hazard (explicitly out
  of scope, tracked separately as a P0).
- Asserting "no collateral damage" from git history alone without running Part F's timestamp-scoped
  platform-wide query.
- Treating this task as covering work-order accuracy or live selector validation -- that is
  `docs/content/CODEX_QA_TASK_READINESS_AUDIT_WORK_ORDERS_AND_SELECTORS_2026_09_25.md`'s job, not this
  task's.
- Any Production write.
```
