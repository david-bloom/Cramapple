# Codex QA Task — Verify the 34-Item P0 Remediation (2026-09-25)

**Context.** Codex's own QA pass (`docs/content/CODEX_QA_REPORT_CANONICAL_ANSWERS_CALC_AB_THROUGH_PHYSICS_1_2026_09_25.md`,
PR #188, merged) found 34 P0 correctness/completeness defects across the seven-subject canonical-answer
corpus. Claude then fixed all 34 directly in Production across seven migrations
(`supabase/migrations/20260925070000_*.sql` through `20260925130000_*.sql`, all merged to `main`), and
wrote a self-report of what changed and why in each migration file's header comment. **None of those
fixes have been independently re-verified by anyone else.** This task closes that gap: it asks Codex to
do to Claude's remediation exactly what Codex already did to the original canonicals -- independently
re-derive each corrected item from its own stem/stimulus/rubric, not confirm it by checking that the fix
matches what the migration file or this task claims it should say.

**Scope, precisely.** This task covers only the 34 items Claude touched in this remediation pass. It does
NOT re-run Part A of the original canonical-answer QA task against the other ~338 items in the seven-subject
corpus (that would just be re-doing PR #188's already-merged work) and does NOT touch PR #189's separate,
still-open readiness-audit findings (the AP Statistics dual-pack P0, the five stale work orders, the
Physics C: Mechanics relabel scope, the two orphaned measurement branches) -- none of those were in scope
for this remediation and none were touched by it; they remain exactly as PR #189 found them.

Proposal/report only -- no Production writes. Read-only SQL against Production.

Paste the block below into Codex.

```text
QA task -- verify the 34-item P0 remediation, 2026-09-25.

Merge main first:

    git fetch origin
    git switch codex/qa-p0-remediation-verification-2026-09-25
    # If that branch does not exist instead run:
    # git switch -c codex/qa-p0-remediation-verification-2026-09-25 origin/main
    git merge origin/main

The checkout must be clean before starting. This is a QA pass against Production
(pcntajvbdfqhbeewmdry) -- read-only SQL only, report findings as a doc, no writes.

READ FIRST:
- docs/content/CODEX_QA_REPORT_CANONICAL_ANSWERS_CALC_AB_THROUGH_PHYSICS_1_2026_09_25.md (your own
  original QA report -- this is the finding list every fix below is supposed to address)
- The seven remediation migrations, in order, for their header comments explaining what changed and why:
  supabase/migrations/20260925070000_p0_content_fixes_stats_numerical_and_two_new_writes.sql
  supabase/migrations/20260925080000_p0_fixes_calcab_005_and_chem_l002_l006.sql
  supabase/migrations/20260925090000_p0_fixes_chem_sfrq_and_apphy1_019_022_029.sql
  supabase/migrations/20260925100000_p0_fixes_apphy2_019_023_028_032.sql
  supabase/migrations/20260925110000_p0_fixes_apphycem_017_np1002_apphycm_019_026.sql
  supabase/migrations/20260925120000_p0_fixes_apphy1_014_026_apphy2_002_003_017.sql
  supabase/migrations/20260925130000_p0_fixes_final_six_completes_34_of_34.sql
- docs/product/SUBJECT_SERVABILITY_CRITERIA.md's "Codex QA sweep and remediation, 2026-09-25" note for
  the top-line summary of what this remediation pass covered and what it explicitly did not touch.

THE 34 ITEMS, grouped by what kind of fix was made (verify every one regardless of group):

Group 1 -- rubric text itself was wrong, not just the canonical (verify the rubric fix too, not just the
canonical):
  apcalcab-frq-005 (frq_criteria's stated stimulus constant corrected from 14 to 16)
  apphy1-frq-026 (frq_criteria criterion b-time AND the canonical both asserted "Track A necessarily
    arrives first" -- Claude's fix claims this is false in general, verified with a worked counter-example
    involving a near-vertical steep section. Re-derive this claim yourself from first principles; this is
    the single highest-value item in this task to get right, since it reverses a rubric assertion rather
    than just filling a gap)

Group 2 -- spurious rubric criteria deleted (verify the deletion was correct, i.e. that the deleted
criteria really did not correspond to anything the stem asks):
  apchem-frq-l-005 (criteria b2 and d1 deleted -- confirm neither stem part (b) nor part (d) asks about a
    rate-law-vs-mechanism distinction, and confirm the remaining criteria still fully cover what the stem
    does ask)

Group 3 -- stem itself was wrong (verify the stem fix, and that canonical/rubric already correctly used
the corrected fact):
  apphycem-frq-np1-002 ("cylindrical symmetry" -> "spherical symmetry", for a system of concentric
    spherical shells)

Group 4 -- numerical/source-data defects (independently recompute, don't just check that the new number
looks plausible):
  APSTAT-MOD4-H001-INV (stem and canonical both corrected from p≈0.014 to p≈0.007 for a one-sided test;
    recompute the one-sided p-value yourself from t≈-2.56, Welch df≈46.5)
  apstats-frq-u12-020 (stimulus South-facility SD corrected from 3.1 to 5.8 to resolve the original
    mathematical impossibility with n=40/mean=12.4/max=40; independently confirm 5.8 is internally
    consistent, and separately assess whether the canonical's rewritten SD-comparison paragraph (part
    c, criterion part-c-criterion-03) is itself correct given the new number, not just non-impossible)

Group 5 -- completeness fixes to this week's own new canonical-answer writes (these are the highest-
priority items to get exactly right, since they are entirely Claude-authored, both the original write and
the fix):
  apphy1-frq-054 (added v0x)
  apphycem-frq-038 (added the actual current direction, "counterclockwise viewed from above along B" --
    independently re-derive this direction yourself via F=qv×B; do not just check that a direction is
    now stated)

Group 6 -- completeness fixes to pre-existing legacy canonicals (omitted subparts, diagrams, derivations,
or explanations the stem explicitly requested):
  apchem-frq-l-002, apchem-frq-l-003, apchem-frq-l-004, apchem-frq-l-006
  apchem-sfrq-008, apchem-sfrq-009
  apphy1-frq-014, apphy1-frq-019, apphy1-frq-022, apphy1-frq-029
  apphy2-frq-002, apphy2-frq-003, apphy2-frq-017, apphy2-frq-019, apphy2-frq-023, apphy2-frq-028,
    apphy2-frq-032
  apphycm-frq-003, apphycm-frq-008, apphycm-frq-019, apphycm-frq-026
  apphycem-frq-008, apphycem-frq-009, apphycem-frq-011, apphycem-frq-017
  APSTATS-HDG-2026-GRAPH-005 (trend-line description corrected to fall within the data's actual x/y
    range -- independently recompute an approximate least-squares fit from the nine given points and
    confirm the new description is a reasonable line, not just "less obviously wrong" than the old one)

PART A -- INDEPENDENT RE-DERIVATION OF ALL 34 FIXES

For each of the 34 items above:
1. Read the item's current stem, stimulus, and frq_criteria directly from Production (not from the
   migration file -- confirm the migration actually applied and current state matches what you expect).
2. Independently work the problem (or, for diagram/procedure items, independently determine what a
   complete correct answer should contain) from first principles, before reading Claude's corrected
   canonical_answer_1. Only after deriving your own answer, compare it to what is now stored.
3. Record three separate judgments, same discipline as your original QA pass: is the corrected canonical
   answer itself correct; is the rubric (frq_criteria) itself correct; do they agree. For Group 1 and
   Group 2 items, this is especially important -- confirm the rubric change itself was the right call,
   not just that it's now self-consistent with the canonical.
4. For every item, confirm the fix actually closes the SPECIFIC finding from your original report (re-read
   that finding's exact wording) -- not just that the item looks more complete in some general sense.
5. Span integrity where applicable: for any of the 34 items that have canonical_answer_spans rows,
   confirm span concatenation still equals canonical_answer_1 exactly and criterion-key coverage still
   exactly matches frq_criteria. Most of these 34 items are pre-existing legacy items with NO spans (this
   is expected, pre-existing segmentation debt per Part B of your original report -- do not flag "no
   spans" as a new defect for an item that already had none before this remediation).

PART B -- NO-COLLATERAL-DAMAGE CHECK, SCOPED TO THIS REMEDIATION

Using the same timestamp-scoped method as your original report's Part F (or equivalent), confirm that
every `content_item_versions.updated_at` change and every `canonical_answer_spans.created_at`/
`frq_criteria` change across the FULL PLATFORM (not just these seven subjects) since 2026-09-25 07:00 UTC
maps to exactly these 34 content_keys (plus the two rubric-only changes and one deletion noted in Groups
1-2, which touch frq_criteria rather than canonical_answer_1). Report any change outside that set as a P0.

PART C -- CONFIRM NOTHING ELSE WAS SILENTLY TOUCHED

Spot-check at least 15 of the other ~338 items in the seven-subject corpus that were NOT in your original
34 P0 findings (a mix of items your original report marked PASS and a few you may not have reviewed in
depth). Confirm their canonical_answer_1 text is unchanged from what your original report recorded. This
guards against a fix to one item accidentally bleeding into another via a bad WHERE clause or a copy-paste
error in the remediation migrations.

DELIVERABLE

`docs/content/CODEX_QA_REPORT_P0_REMEDIATION_VERIFICATION_2026_09_25.md`:

- One row per item (34 total) with: content_key, group (1-6 above), your independently-derived verdict
  (does the fix actually resolve the original finding: yes/no/partially), a new severity tag if the fix
  itself introduced a defect (P0/P1/P2, same scale as your original report), and a one-line note.
- A dedicated top-line section for Group 1 (the two rubric-level fixes) and Group 4 (the two numerical
  fixes) -- these carry the highest consequence if wrong, so surface them prominently even if every other
  group is clean.
- A section for Part B's no-collateral-damage check.
- A section for Part C's spot-check of untouched items.
- A summary table: items verified-correct, items still defective, items where the fix introduced a new
  issue, by severity tag.
- An explicit top-line statement of whether all 34 original P0 findings can now be considered genuinely
  closed, or how many remain open/newly-defective.

WHAT WOULD MAKE THIS REJECTED

- Confirming a fix is correct by checking that it matches the migration file's own claim about what it
  changed, instead of independently re-deriving the answer from the stem/stimulus.
- Treating Group 1's rubric-level fixes (especially apphy1-frq-026's reversed claim) as a normal
  completeness fix instead of independently verifying the underlying physics/reasoning yourself.
- Flagging "no canonical_answer_spans" as a new defect on items that already had none before this
  remediation (that is known, separate, pre-existing debt, not something this remediation was asked to
  fix).
- Skipping Part C (the spot-check of untouched items) -- that is the check that would catch collateral
  damage to items outside the 34.
- Re-litigating or re-running PR #189's readiness-audit scope (work-order accuracy, live selectors, the
  Statistics dual-pack hazard) -- none of that is this task's job, and none of it was touched by this
  remediation.
- Any Production write.
```
