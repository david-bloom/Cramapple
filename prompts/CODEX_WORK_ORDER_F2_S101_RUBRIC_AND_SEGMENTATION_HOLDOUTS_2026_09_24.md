# Codex Work Order F.2 — `S-101`'s Rubric Split and the Three Segmentation Holdouts

**Authorization: DECISION-0064** (`docs/activity_log/DECISIONS_LOG.md`). Read it in full before
starting either half of this order — it is broader than the standing "fill gaps; do not replace"
rule and than DECISION-0056's narrower redundancy exception, and the conditions attached to it are
requirements here, not background.

Two unrelated fixes, same directory family, same gates. Do them in order; each has its own report.

Paste the block below into Codex.

```text
Work order F.2 — two authorized content fixes: S-101's rubric, and S-021/S-023/S-058's canonicals.

Merge main first:

    git fetch origin
    git switch codex/work-order-f2-s101-and-segmentation-holdouts
    # If that branch does not exist instead run:
    # git switch -c codex/work-order-f2-s101-and-segmentation-holdouts origin/main
    git merge origin/main

The checkout must be clean before starting. Commit and push to
codex/work-order-f2-s101-and-segmentation-holdouts as you go. Do not open a PR and do not merge to
main. Read-only against Production throughout -- propose in files, never write to the database.

READ FIRST, in this order:
  1. docs/activity_log/DECISIONS_LOG.md -- DECISION-0064 (index entry at the top), and DECISION-0056
     for the logging pattern it extends.
  2. docs/research/biology_m1_regrade_and_blocker_2026_09_24/README.md -- Part 1, the full S-101
     diagnosis, including the exact stem-to-criterion mapping table.
  3. docs/research/apbio_canonical_recovery_2026_09_22/qa_findings.csv -- rows QA2-015, QA2-016,
     QA2-017, QA2-040, QA2-041.
  4. docs/research/apbio_canonical_recovery_2026_09_22/recovery_ledger.csv -- the existing drafted
     rows for S-021, S-023, S-058 (filter on those three content_key values).
  5. prompts/CODEX_PROJECT_2_CONTENT_COMPLETION_2026_09_23.md -- "Shared rules" and "Shared
     QA-preparation contract" sections. The span schema, the every-criterion-needs-an-exclusive-span
     rule, and the SUMMARY.md/packet.jsonl contract all apply here unchanged.

Work in docs/research/apbio_f2_s101_and_holdouts_2026_09_24/ -- a new directory, do not write into
any other work order's directory.

=== PART 1 — S-101: split criterion a-iv, then hand off for regrading ===

DECISION-0064 authorizes exactly this: split the rubric's criterion a-iv into two 1-point criteria
matching the stem's (a)(iii) and (a)(iv). The item moves from 4 points to 5.

  - a-iv (revised): covers ONLY the stem's (a)(iii) -- what "most parsimonious" means. Its
    evidence_requirements should name only that fact.
  - a-v (new): covers ONLY the stem's (a)(iv) -- why parsimony is preferred (fewest unsupported
    assumptions). Its evidence_requirements should name only that fact.
  - learner_facing_text for both must be written so a student reading them can tell they are two
    separate, single asks -- that is the entire point of the split.

This is a RUBRIC edit, not an answer edit. F.1's already-relabelled answer text (docs/research/
apbio_drafted_criteria_2026_09_23/, or wherever your merge of main puts it) already separates
(iii) and (iv) into two paragraphs -- do not rewrite that text. Re-tag which span(s) satisfy which
of the two new criteria, and re-verify: spans still concatenate exactly to full_text, both new
criteria have their own exclusive span, and no other criterion's coverage changed.

Produce, in your F.2 directory:
  - a criteria_change.json documenting the before/after for a-iv (old criterion_key, old
    evidence_requirements, old points) and the two new criteria (keys, evidence_requirements,
    points, which span(s) tag each)
  - re-verified invariant numbers (concatenation, exclusive-span coverage) for this one item

STOP after this. Do not re-grade it yourself -- the grader path is service_role-gated, and more
importantly the model that authors a rubric fix must not be the one that verifies it clears the
gate. Report the rubric change and hand back. Claude re-runs DECISION-0052's grader gate against
your corrected rubric (existing F.1 answer text, new criteria) and only writes canonical_answer_1
if it clears 100%. If it does not clear 100% on your first proposal, that is a finding, not a
failure -- report what the gate said and stop; do not iterate on the rubric yourself to force a
pass.

=== PART 2 — S-021, S-023, S-058: canonical answers that actually answer their rubrics ===

QA2-015 and QA2-040 (both high severity, from 2026-09-22, never actioned) found that for S-021 and
S-058, NEITHER stored canonical_answer_1 NOR canonical_answer_2 answers the item's own rubric --
"the stored answers appear to belong to a different question/rubric." The recovery_ledger.csv row
for each shows every criterion (a1/a2/b1/b2) already had to be drafted from scratch in the
2026-09-22 pass because nothing was recoverable. S-023 is less severe: 3 of 4 criteria needed
drafting, 1 (b2) was recoverable from the existing canonical_answer_2.

DO NOT simply re-emit the 2026-09-22 recovery_ledger.csv rows as final. Re-verify each of the
three items against CURRENT Production first -- confirm the stem, rubric criteria, and both stored
canonical fields have not changed since 2026-09-22, and confirm the drafted content in the ledger
still correctly answers the current rubric. If anything has moved, say so and redraft against the
current state rather than proceeding on stale text.

For each of the three items, produce:
  - full_text: a complete canonical_answer_1 that answers every criterion in the item's current
    rubric, following the same span schema as work order F (spans[] with text, criterion_keys,
    provenance, source_field, source_offset where recoverable) and the same exclusive-span-per-
    criterion rule (every criterion earned by exactly one span tagged to it and no other; where one
    sentence would earn two criteria, split it into two sentences instead of double-tagging).
  - For content recoverable from the existing canonical_answer_1 or canonical_answer_2 (S-023's b2,
    and check whether S-021/S-058 have ANY genuinely on-rubric fragment despite QA's finding --
    confirm zero yourself rather than assuming QA's finding transfers unchanged), mark that
    provenance as recovered_ca1 / recovered_ca2 per the existing schema. Everything else is
    drafted.
  - The canonical_answer_2 question QA left open (QA2-016, QA2-041): decide explicitly, per item,
    whether the existing off-rubric canonical_answer_2 is legitimate supplementary context worth
    keeping alongside the new canonical_answer_1, or should be proposed for removal. State your
    reasoning either way -- this is exactly the ambiguity DECISION-0064 requires you to resolve, not
    leave open a second time.
  - removal_log.csv (DECISION-0056/0064's discipline, extended to this broader authorization):
    for every piece of currently-published canonical_answer_1 or canonical_answer_2 text your
    proposal does NOT retain, log the verbatim text, character count, which stored field it came
    from, and why (off-rubric / contradicts current rubric / superseded by a drafted span that
    covers the same ground). This must account for the full character delta between what's stored
    today and what you're proposing -- nothing silently disappears from the log.

Produce a packet.jsonl (model-neutral inputs, re-derivable from Production, matching work order F's
existing packet shape) and a SUMMARY.md with the same invariant table, confidence-ranked open
questions, and self-flagged weak points that every other content work order in this project
produces. Confidence must track genuine ambiguity (per the shared QA-preparation contract) --
"drafted from scratch because nothing else fits" is lower confidence than "recovered verbatim,"
and your SUMMARY.md should say so plainly rather than reporting uniform high confidence.

=== WHAT WOULD MAKE THIS REJECTED AT QA ===

  - Part 1: any change to the already-relabelled answer text, or a-iv/a-v criteria whose combined
    scope differs from the original a-iv's (i.e. anything lost or added beyond the split itself).
  - Part 1: grading it yourself, or reporting a grader result Claude didn't independently produce.
  - Part 2: re-emitting the 2026-09-22 draft unchanged without re-verifying it against current
    Production.
  - Part 2: any criterion left uncovered, any span not exclusive to its criterion, or a
    removal_log.csv that doesn't account for the full text delta.
  - Either part: scope creep to any item other than S-101, S-021, S-023, S-058.
  - Working in, or writing into, any other work order's directory.

Report when both parts are complete: the rubric change and its re-verified invariants (Part 1),
and for Part 2 the three items' coverage numbers, the ca2 decision per item, and the removal log's
totals. Flag anything you could not resolve rather than guessing past it.
```

## Why this is one work order and not two

Both halves trace to the same decision (DECISION-0064) and the same directory-scoped authoring
conventions from the Project 2 charter; splitting them into separate work orders would just
duplicate the read-first list. The gates are genuinely independent, though — Part 1 blocks on
Claude's regrade, Part 2 blocks on Claude's content QA, and they can land in either order.

## What stays with Claude

- **Part 1**: re-run DECISION-0052's grader gate against the corrected rubric (existing F.1 text +
  the new a-iv/a-v split). Only write `canonical_answer_1` for `S-101` if it clears 100%. If it
  doesn't, that's a finding to report back, not something to fix silently.
- **Part 2**: independent QA of the three rewritten canonicals against their current rubrics and
  against the `removal_log.csv`'s accounting of what changed, then apply.
- Closing FF-4 and FF-5 in `docs/product/AP_BIOLOGY_FAST_FOLLOW.md` once both are verified.
