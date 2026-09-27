# Codex QA Task — Full Content Readiness, Calc AB Through Physics (2026-09-25)

**Revision note (2026-09-25, same day):** This replaces the first version of this task. Two things
changed after the first version was posted:

1. **Scope was too narrow.** The first version only asked Codex to re-verify the 121 FRQ canonical
   answers Claude directly authored this week. It did not verify the *other* ~128 FRQ across these
   same five subjects that already had canonical answers before this week's work, and it did not
   verify any of the other five servability criteria. This version verifies **all 249** FRQ that
   currently have a canonical answer across these five subjects, plus a lighter-weight check of every
   other criterion in `docs/product/SUBJECT_SERVABILITY_CRITERIA.md`.
2. **The grader-gate section was unworkable as written.** It asked for 45 `app.qa_grade_frq` calls (3
   items x 5 subjects x 3 runs) as if that would produce grading evidence. It would not: the deployed
   `evaluate-attempt` function's QA no-persist path is hard-gated to Biology only —
   `if (examPack.exam_code !== "ap_biology") return respond({ error: "qa_path_ap_biology_only" },
   { status: 409 })` — verified directly against the Production function source
   (`get_edge_function` for `evaluate-attempt`, not just the repo copy, since this function has
   drifted from Production before). **None of the five subjects in this task is Biology**, so every
   one of those 45 calls would have failed identically with the same 409, and running them 45 times
   would not have added any evidence beyond running one. This version replaces that section with a
   single reachability check per subject and treats the 409 as the expected, correctly-gated result —
   not a defect to work around, but a real platform-level blocker on grading-verification confidence
   for every non-Biology subject, which this task surfaces as its own top-line finding rather than
   papering over.

**Context.** Over 2026-09-24/25, Claude directly authored and applied canonical-answer content for
121 published FRQ items across five subjects (Calc AB, Chemistry, Physics 2, Physics C: Mechanics,
Physics C: E&M), and separately fixed a live grading bug in Calc AB. This task asks Codex to
independently verify the full current servability state of these five subjects — not just the new
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

**Total FRQ with a canonical answer across these five subjects: 249.** That is the correct scope for
the correctness deep-dive below — not just the 121 Claude touched this week. The other ~128 have never
been independently re-verified by anyone and should not be assumed correct just because they predate
this week's work.

Proposal/report only — no Production writes. Read-only SQL against Production.

Paste the block below into Codex.

```text
QA task — full content readiness, Calc AB through Physics, 2026-09-25.

Merge main first:

    git fetch origin
    git switch codex/qa-content-readiness-calcab-through-physics-2026-09-25
    # If that branch does not exist instead run:
    # git switch -c codex/qa-content-readiness-calcab-through-physics-2026-09-25 origin/main
    git merge origin/main

The checkout must be clean before starting. This is a QA pass against Production
(pcntajvbdfqhbeewmdry) -- read-only SQL and read-only edge function calls only, report findings as a
doc, no writes.

READ FIRST:
- docs/product/SUBJECT_SERVABILITY_CRITERIA.md (the six criteria and how to measure each one)
- docs/product/AP_CALCULUS_AB_LAUNCH_READINESS_2026_09_25.md
- docs/product/AP_CHEMISTRY_LAUNCH_READINESS_2026_09_25.md
- supabase/migrations/20260925000000_apcalcab_dedupe_frq_criteria.sql (the live grading-bug fix)
- The five canonical-answer migrations: 20260925010000 (Calc AB), 20260925020000 (Physics 2),
  20260925030000 (Physics C: Mechanics), 20260925040000 (Physics C: E&M) -- Chemistry's single item
  (apchem-frq-l-012) was applied directly, not via a dedicated migration file; find it via git log or
  by querying Production directly.
- prompts/CODEX_WORK_ORDER_AP_PHYSICS_1_LAUNCH_READINESS_2026_09_25.md and the sibling Precalculus/
  Calculus BC/Chemistry-labels-and-difficulty work orders, just to confirm you are not duplicating
  scope that belongs to those separate, not-yet-run orders (labels and difficulty for these five
  subjects are explicitly NOT this task's job -- see Part C below for what this task does check about
  them, which is narrower than closing them).
- Physics 2, Physics C: Mechanics, and Physics C: E&M do not yet have dedicated launch-readiness docs
  the way Calc AB and Chemistry do -- their current state lives in
  docs/product/SUBJECT_SERVABILITY_CRITERIA.md's tracking table and in the migration file headers.
  Note this gap in your deliverable; writing those three docs would be a reasonable follow-up but is
  not required by this task.

PART A -- CANONICAL ANSWER CORRECTNESS, ALL 249 ITEMS (not just the 121 Claude authored this week)

For every FRQ with a non-null canonical_answer_1 across these five subjects (249 total -- query
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
mechanics) where a plausible-looking but wrong intermediate step is easy to miss on a skim.

PART B -- THE CALC AB GRADING-BUG FIX

Confirm apcalcab-frq-np2-008, apcalcab-frq-u13-002, apcalcab-frq-u13-006, and apcalcab-frq-u13-018 each
now have exactly one frq_criteria row per criterion_key (not two), and that no other FRQ item in any
of the five subjects has the same exact-duplication pattern that might have been missed by the
original fix's scope.

PART C -- LIGHTWEIGHT VERIFICATION OF THE OTHER FIVE CRITERIA (confirm state, don't close gaps)

For each of the five subjects, independently re-measure (don't just copy the table above) and confirm
or correct:
- Criterion 1 (reviewed/approved): item and version status counts.
- Criterion 2 (rubric/MCQ correctness): every FRQ has at least one frq_criteria row; every MCQ has
  exactly one is_correct choice. Report any subject where this is no longer true (it was measured
  clean earlier this week, but re-confirm, don't assume it's stayed that way).
- Criterion 3 (serving labels): confirm the validated/non-validated counts in the table above are
  still accurate as of today.
- Criterion 5 (difficulty): confirm the row counts in app.content_item_difficulty are still accurate.
- Criterion 6 (exam pack version): confirm exactly one published, non-retired exam_pack_version per
  subject -- this is the one criterion where a silent regression (a second version going live) would
  be a routing hazard on par with Statistics' dual-version finding from 2026-09-24, so treat this check
  as high-priority even though it's quick.
This is a confirmation pass, not new authoring or gap-closing -- if you find labels or difficulty gaps,
report them, don't propose fixes (that's the separate, already-written work orders' job).

PART D -- GRADING-PATH REACHABILITY (not a 45-call spot check -- see the revision note above)

For each of the five subjects, make exactly ONE app.qa_grade_frq call against any one FRQ item with a
canonical answer, and confirm it returns the qa_path_ap_biology_only 409 (or report if it does NOT --
that would mean the gate has changed since this task was written, which would be a significant finding
requiring you to then actually run the fuller grading-verification pass this task originally
attempted). Do not repeat a call that returns this same 409 multiple times per subject; one confirmed
instance per subject is sufficient evidence that the path is closed for that subject. If you want a
working positive control to confirm your qa_grade_frq usage itself is correct (not the source of the
409), you may run it once or twice against a Biology FRQ, where the path is open -- but that is a
sanity check on your own method, not part of this task's five-subject scope.

Report this finding prominently: as things stand, there is currently no way to verify via the grading
pipeline itself that any canonical answer in Calc AB, Chemistry, Physics 2, Physics C: Mechanics, or
Physics C: E&M actually grades correctly when a student submits it -- all grading-quality assurance for
these five subjects currently rests on the independent-re-derivation and span-integrity checks in Part
A, not on the grader itself. This is worth escalating as its own follow-up (opening the QA path to
non-Biology subjects, or building an equivalent QA harness for them) separately from this task.

DELIVERABLE

`docs/content/CODEX_QA_REPORT_SUBJECT_CONTENT_READINESS_CALC_AB_THROUGH_PHYSICS_2026_09_25.md`:

- One section per subject with a table of all its FRQ-with-canonical items (249 total across the
  five), each row showing: content_key, canonical-answer verdict, rubric verdict, agreement verdict,
  span-integrity result, and a severity tag for any problem found (P0 = canonical answer or rubric is
  mathematically/scientifically wrong; P1 = span/coverage mismatch with no correctness impact on the
  stored text; P2 = documentation/tracking discrepancy, e.g. a stale count in a doc).
- A dedicated section for the Calc AB grading-bug re-verification (Part B).
- A section per subject for the Part C lightweight six-criteria confirmation, flagging any drift from
  the table above.
- A single top-line section on the grading-path reachability finding (Part D), written so it's visible
  without reading the rest of the report.
- A summary table across all five subjects: items checked, canonical-correct, rubric-correct, both
  agree, span-clean, by severity tag.

WHAT WOULD MAKE THIS REJECTED

- Verifying only the 121 items Claude authored this week instead of all 249 with a canonical answer.
- Confirming correctness by comparing against the rubric's learner_facing_text instead of an
  independent derivation from the stem -- and specifically, collapsing "canonical answer correct,"
  "rubric correct," and "they agree" into one flattened verdict.
- Reporting span-integrity as "already verified by the migration" without re-running the check
  yourself against current Production state.
- Repeating the qa_grade_frq 409 many times per subject and calling that thorough, instead of treating
  one confirmed 409 per subject as sufficient and reporting the blocker itself as the finding.
- Silently absorbing the grading-path-reachability finding into a minor bullet point instead of
  surfacing it as a top-line, hard-to-miss result.
- Scope creep into actually closing labels or difficulty gaps for any subject (Part C is
  confirm-only).
- Any Production write.
```
