# Codex QA Task — Subject Content Readiness Work, Calc AB Through Physics (2026-09-25)

**Context.** Over 2026-09-24/25, Claude directly authored and applied canonical-answer content for
121 published FRQ items across five subjects, closing criterion 4 ("canonical answer exists," per
`docs/product/SUBJECT_SERVABILITY_CRITERIA.md`) for all of them. This is a QA pass on that body of
work — not new authoring, and not the still-open label/difficulty work (criteria 3 and 5), which have
their own separate Codex work orders per subject and are explicitly out of scope here.

**Scope: five subjects, 121 items, in this order:**

| Subject | Items closed | Migration(s) |
| --- | ---: | --- |
| AP Calculus AB | 33 | `supabase/migrations/20260925010000_apcalcab_canonical_answers_33_items.sql` |
| AP Chemistry | 1 | (single item, `apchem-frq-l-012`, applied directly — see `docs/product/AP_CHEMISTRY_LAUNCH_READINESS_2026_09_25.md`) |
| AP Physics 2 | 19 | `supabase/migrations/20260925020000_apphysics2_canonical_answers_19_items.sql` |
| AP Physics C: Mechanics | 29 | `supabase/migrations/20260925030000_apphysicscm_canonical_answers_29_items.sql` |
| AP Physics C: E&M | 39 | `supabase/migrations/20260925040000_apphysicscem_canonical_answers_39_items.sql` |

Also in scope: a live grading bug fixed en route in Calc AB (`supabase/migrations/20260925000000_apcalcab_dedupe_frq_criteria.sql`) — 4 items had every `frq_criteria` row duplicated, doubling live point totals. Verify this fix too.

A narrower QA prompt already exists for Calc AB alone
(`prompts/CODEX_QA_PROMPT_AP_CALCULUS_AB_2026_09_25.md`) — this task supersedes it in scope (covers
the same ground plus four more subjects) but the verification method described there is the template
for all five subjects below. Don't duplicate that file; this doc is the authoritative QA task going
forward.

Proposal/report only — no Production writes. Read-only SQL against Production.

Paste the block below into Codex.

```text
QA task — subject content readiness, Calc AB through Physics (Claude's direct-authoring work,
2026-09-24/25).

Merge main first:

    git fetch origin
    git switch codex/qa-content-readiness-calcab-through-physics-2026-09-25
    # If that branch does not exist instead run:
    # git switch -c codex/qa-content-readiness-calcab-through-physics-2026-09-25 origin/main
    git merge origin/main

The checkout must be clean before starting. This is a QA pass against Production
(pcntajvbdfqhbeewmdry) -- read-only SQL, report findings as a doc, no writes.

READ FIRST:
- docs/product/SUBJECT_SERVABILITY_CRITERIA.md (the six criteria; this task is criterion 4 only)
- docs/product/AP_CALCULUS_AB_LAUNCH_READINESS_2026_09_25.md
- docs/product/AP_CHEMISTRY_LAUNCH_READINESS_2026_09_25.md
- The five migration files listed in the table above, plus
  supabase/migrations/20260925000000_apcalcab_dedupe_frq_criteria.sql

WHAT TO VERIFY, FOR EACH OF THE FIVE SUBJECTS

1. Mathematical/scientific correctness, independently re-derived. For every one of the 121 items
   (33 + 1 + 19 + 29 + 39), read the stem/stimulus and frq_criteria directly from Production, then
   independently work the problem from first principles yourself -- do not just check that
   canonical_answer_1 is "plausible" or matches the rubric's learner_facing_text. Comparing against
   the rubric text only confirms self-consistency, not correctness -- the rubric itself could in
   principle be wrong (this is exactly how the Calc AB frq_criteria duplication bug and an earlier
   Biology rubric error were found). Flag any canonical answer whose final value or reasoning does not
   match your own independent derivation. This is the highest-value check in this task -- budget the
   most time here, especially for the Physics C subjects (E&M and Mechanics), which involve
   calculus-based derivations (Gauss's law integrals, RC/RL/LR circuit differential equations,
   rotational dynamics, orbital mechanics) where a plausible-looking but wrong intermediate step is
   easy to miss on a skim.

2. Span integrity, for all 121 items:
   - Span concatenation equals canonical_answer_1 exactly (byte-for-byte).
   - Every frq_criteria criterion_key for the item is covered by exactly one span's criterion_keys
     array -- no criterion missing, none appearing in two different spans, none extra.
   - assembly_literal spans (the separators between content spans) have an empty criterion_keys array.
   Re-verify this independently against current Production state -- don't trust that a migration's own
   in-transaction check is still true, since schema or data could have changed since it ran.

3. The Calc AB grading-bug fix specifically (apcalcab-frq-np2-008, apcalcab-frq-u13-002,
   apcalcab-frq-u13-006, apcalcab-frq-u13-018): confirm each now has exactly one frq_criteria row per
   criterion_key (not two), and that no other item in any of the five subjects has the same
   duplication pattern that might have been missed.

4. No collateral damage. Confirm no item's canonical_answer_1, canonical_answer_spans, or
   frq_criteria rows were modified beyond the intended 121 (canonicals) + 4 (Calc AB dedupe) items,
   in any of the five subjects.

5. Grader-gate spot check. For each of the five subjects, pick 3 newly-canonicaled items (spread
   across easy and hard/multi-part FRQ where possible) and run app.qa_grade_frq against each 3 times
   minimum (same discipline as Biology's M5 baseline -- a single run is not evidence). That's 15 items
   x 3 runs = 45 grader calls total. Report status/confidence/integrity per run, and flag any item
   where the 3 runs disagree.

6. Known, explicitly out-of-scope facts -- confirm these are NOT conflated with what this task
   verifies, but do note their current state in your report for completeness:
   - Chemistry, Physics 2, Physics C-Mechanics, Physics C-E&M: canonical_answer_spans coverage for
     items that already had canonicals BEFORE this week's work (i.e. not among the 121) was not
     measured or touched by this work -- if you happen to notice it's still incomplete for those,
     say so, but do not treat it as a defect in the 121 this task covers.
   - Criteria 3 (serving labels) and 5 (difficulty) for all five subjects remain open and have their
     own separate Codex work orders (prompts/CODEX_WORK_ORDER_*_LAUNCH_READINESS_2026_09_25.md and
     similar) -- do not start that work here.

DELIVERABLE

`docs/content/CODEX_QA_REPORT_SUBJECT_CONTENT_READINESS_CALC_AB_THROUGH_PHYSICS_2026_09_25.md`:
one section per subject, with a table of all items in that subject (content_key, your independent
re-derivation verdict -- confirmed or disputed with your own worked answer if disputed, span-integrity
result). Follow with a dedicated section for the Calc AB grading-bug re-verification, then a section
for the grader-gate spot-check results (all 15 items x 3 runs), then a summary table across all five
subjects (items checked, confirmed, disputed, span issues found).

WHAT WOULD MAKE THIS REJECTED

- Confirming correctness by comparing against the rubric's learner_facing_text instead of an
  independent derivation from the stem.
- Reporting span-integrity as "already verified by the migration" without re-running the check
  yourself against current Production state.
- Skipping any of the five subjects, or spot-checking only a sample of the 121 items for correctness
  instead of covering all of them.
- Scope creep into criteria 3 or 5 (labels, difficulty) for any subject.
- A single grader-gate run per item reported as sufficient evidence.
- Any Production write.
```
