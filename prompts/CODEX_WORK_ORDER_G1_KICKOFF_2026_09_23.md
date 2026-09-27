# Codex Work Order G.1 Kickoff — 2026-09-23

Paste the block below into Codex. The amended charter on `main` is the specification; this prompt
points at it rather than restating it.

```text
Work order G.1 — re-cut ap-physics-1 before authoring any further G subject.

FIRST, bring main into your branch. You merged main at 10:53 and ran F at 11:13, but the
span-exclusivity invariant and work order G.1 landed on main at 10:56 — three minutes after your
merge. Your working copy does not have either.

    git fetch origin
    git merge origin/main          # from your worktree on codex/project2-2026-09-23

Confirm before continuing: `grep -c "G.1 — first, re-cut" \
prompts/CODEX_PROJECT_2_CONTENT_COMPLETION_2026_09_23.md` must return 1.

What happened, and what did not:

Work order B's segmentation was REJECTED by QA because 195 of its 240 criteria had no span tagged to
them alone — deselecting one rubric point struck text earning another, which defeats the only reason
spans exist. G said "identical in shape to work order B", and B's invariant table had no exclusivity
row, so the spec permitted it. Your committed ap-physics-1 batch has the same defect and worse:

    176 of 176 criteria have no span of their own; mean over-strike 1.00
    88 spans carrying 176 criteria — every span double-tagged

Your work order F output is the counter-example, and it is yours: 576 spans across 261 criteria,
zero spans carrying more than one criterion, mean over-strike 0.00. You segmented F at criterion
granularity without being told to. Apply F's own granularity to ap-physics-1.

G.1, in order:

1. Re-cut the 39 ap-physics-1 items so each of the 176 criteria has at least one span tagged to it
   alone. full_text should not need to change for most items — split existing spans at sentence
   boundaries.
2. Where one sentence genuinely earns two criteria, re-author it into two sentences. You authored
   this text, so you may. Say which items' full_text changed and why.
3. Re-verify exact concatenation and full coverage after re-cutting; the earlier invariants must
   still hold.
4. Report before/after in ap-physics-1/: criteria with no exclusive span, and mean over-strike, both
   before and after, plus the count of items whose full_text changed.
5. Only then continue to subject 2 (ap-physics-c-em), applying the invariant from the start.

ap-physics-1 has not been QA'd. Re-cut it first so QA reviews the corrected batch rather than
dispositioning one you already know is defective.

Also new on main and applying to every remaining G subject: G's derivations schema is tightened per
QA finding B-QA-002. expression is the formula for that one value, not the whole answer sentence
repeated; inputs names the operands as label/value pairs, not a boilerplate source quote; and a value
read from a table — a t*, a z, a chi-square critical value — is kind:"looked_up" with the
distribution and parameters named, not kind:"computed". B's derivations were complete in count but
QA had to parse arithmetic out of prose to check them.

scripts/qa/overnight_qa_harness.py now has check_span_exclusivity. Run against your current
ap-physics-1 it reports 176/176 and 1.00 and fails, so you can verify the re-cut yourself before
handing off.

Do not start work orders H or E.1 in this session. G.1 first, then continue G's subject sequence.

Unchanged: read-only against Production; propose in files; one directory per work order; never
create or edit qa_findings.csv or qa_report.md; commit and push to codex/project2-2026-09-23, no PR
and no merge to main. G's STOP-for-QA gate between subjects still applies.
```

## Why this exists, and what it is not

**It is not a criticism of F.** F was run three minutes after the exclusivity invariant landed and
without it, and F is nevertheless clean — 576 spans, 261 criteria, zero double-tagged, mean
over-strike 0.00. F also emitted `removals.csv` and `similarity_report.csv` as the amended work order
required. F awaits QA on its content, but its segmentation is exactly right, and it is the worked
example G.1 should copy.

**The defect is real and confined to `ap-physics-1`**, which was authored at 09:42 under the original
G text. Measured: 176 of 176 criteria with no exclusive span, mean over-strike 1.00.

**Sequencing.** G.1 is small, it is the only thing blocking G's remaining 182 FRQ across six
subjects, and every additional subject authored under the old pattern multiplies the rework. H is
larger but nothing gates on it, and E.1 is six rows. G.1 first.

**Branch-hygiene note:** the three-minute gap between Codex's merge and the G.1 push is exactly the
failure this kickoff exists to catch. Codex works in `/private/tmp/cramapple-project2` on
`codex/project2-2026-09-23`; amendments land on `main`. Always re-merge and verify with the grep
before acting on a work order that has been amended.
