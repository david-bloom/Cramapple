# Codex Work Order F.1 Kickoff — 2026-09-24

A one-item correction. Paste the block below into Codex. It is small enough to slot in whenever F's
directory is next open, and it blocks the AP Biology canonical migration.

```text
Work order F.1 — re-label APBIO-FRQ-S-101 to match its four-part stem. One item, one paragraph.

Merge main first; F.1 is new and so are two corrections to G's requirements.

    git fetch origin
    git merge origin/main          # from your worktree on codex/project2-2026-09-23

Confirm: `grep -c "Work order F.1" prompts/CODEX_PROJECT_2_CONTENT_COMPLETION_2026_09_23.md`
must return at least 1.

Why this exists. The AP Biology completion plan captured a grader baseline on 2026-09-24, before any
canonical answer is written to Production. Of the three Biology items the grader gate can reach, two
score 100%. APBIO-FRQ-S-101 scores 3 of 4, on two separate runs, and the grader's reason is correct:
there is no part (a)(iv) in the answer.

The cause is a split artefact, not an authoring error:

  - The stem asks (a)(i) through (a)(iv) and the rubric has four criteria, a-i through a-iv.
  - The answer text is labelled (i), (ii), (iii) only, because it was recovered verbatim from
    retired parent APBIO-FRQ-L-025, which asked a THREE-part question.
  - The content earning a-iv is present but sits inside the (iii) paragraph. QA of work order A
    confirmed it verbatim at its exact offset, so the mapping was right.

The content is correct. The presentation is not: a student reading this canonical sees no part (iv).

What to do:

  1. Split the (iii) paragraph into labelled (iii) and (iv), matching the stem. The definition of
     "most parsimonious" stays under (iii); why parsimony is preferred becomes (iv).
  2. This is a RE-LABEL, not a re-authoring. Preserve the recovered wording. Add the (iv) label and
     the minimal connective needed for the sentence to stand alone — nothing more.
  3. Re-verify: exact concatenation, full criterion coverage, and every criterion still having a span
     tagged to it alone. F scored 0 of 261 criteria without an exclusive span; do not regress it.
  4. Update provenance honestly. The (iv) span is no longer byte-identical to the parent source, so
     it is not recovered_parent any more. Mark it drafted, or propose something more precise and say
     why, and do not leave a source_offset that no longer resolves.
  5. Record it in F1_CHANGES.md: before and after, which spans changed, the provenance change, and
     your re-verified invariant numbers.

Do NOT re-grade it. The grader path is service_role-gated, and the model that makes a fix must not be
the one that verifies it. Claude re-runs the gate against your corrected text and records the result
against the baseline.

Do NOT touch APBIO-FRQ-S-102 or -103. Both score 100% on the current deployment.

One generalising check while you are in there. S-101/102/103 are the only Biology items split from a
retired parent, so that cause is contained — but the underlying defect is more general: an answer
whose sub-part labels do not match the sub-parts its stem asks for. Scan F's 71 items for it and
report the count either way. Finding only S-101 is a result worth having, not a wasted pass.
```

## Why it is worth doing before M1

M1 writes Biology's canonical answers to Production. The grader gate refuses any item that already
has a canonical, so **once M1 runs, `S-101` can never be re-measured through that path.** Fixing the
label first means the applied canonical is the one that scores 100%, rather than shipping a known
3-of-4 and losing the ability to confirm the fix.

## Two things this correction demonstrates

**The baseline earned its place.** It was captured only because the gate's own guard would have made
the measurement impossible afterwards. It then found a content defect that four QA passes over the
same text had not — because none of them read the answer the way a student does, against the stem's
part structure.

**It also corrected a QA finding of mine.** F-QA-001 characterised both grader failures as grader
defects. That was right for `S-103`, which now scores 5/5 clean after a redeploy with no content
change — and wrong for `S-101`, which is a real content problem. Recorded in
`docs/research/biology_m5_grader_baseline_2026_09_24.md`.
