# The skill dimension subdivides mastery, it never adds to it — 2026-09-29

**Status:** CURRENT | **Type:** Analysis, measured against Production, read-only
**Bears on:** `TASK-0050`, `DECISION-0074`, `DECISION-0085`
**Prompted by:** David, 2026-09-29 — should Statistics and Calculus AB go to the next phase first,
in case later phases teach us something that changes Phase 0 for the remaining subjects?

They should, and doing the arithmetic answered it before any Phase B run was needed.

## The structural fact

A cell is masterable under `DECISION-0074` when it holds 2 MCQ and 1 FRQ. Every topic × skill cell
sits inside exactly one topic. So if a cell clears the bar, its topic necessarily clears it too:

> **masterable(topic × skill) ≤ masterable(topic), always.**

The skill dimension can only ever **subdivide** a topic's items into finer cells. It cannot create
items, so it cannot raise the count. It buys diagnostic resolution — knowing *which* skill a student
is failing — and pays for it in mastery coverage. That is a trade, not a gain, and the plan did not
say so.

## Measured, both launch subjects, live packs

| | AP Statistics | AP Calculus AB |
| --- | --- | --- |
| Items with a topic | 181 | 117 |
| Topics carrying items | 48 | 50 |
| **Items per topic** | **3.77** | **2.34** |
| Candidate skills per topic | **2.33** (curated grid) | **~4.9** (all assessed sub-skills of the aligned practice) |
| Masterable at **topic** grain | 14 | **15** |
| Masterable at **skill** grain | **12** (measured) | not yet run |

Statistics paid **2 cells** (14 → 12) for its skill dimension. It could afford that because its grid
is *curated narrow* — 131 cells over 55 topics, 2.33 candidates per topic — and its items are dense
at 3.77 per topic. Its ratio of items-per-topic to candidates-per-topic is **1.6**.

Calculus AB's proposed grid inverts both terms. Items are sparser (2.34 per topic) and the candidate
set is wider, because "all assessed sub-skills of the topic's aligned practice" gives roughly 4.9
rather than a curated 2.33. Its ratio is **0.5** — about a third of Statistics'.

Spreading 2.34 items per topic across ~4.9 cells cannot often put 3 items (2 MCQ + 1 FRQ) in the same
cell. The exact figure needs the run; the direction does not. **It can only fall from 15, and on
these ratios it would fall a long way.**

## What this changes

**The candidate-set rule is wrong, and it is a Phase 0/A decision, not a Phase B one.** "All assessed
sub-skills under the CED-aligned practice" is *finer* than the grid that actually worked for
Statistics. Applied to Calculus AB it would trade away most of 15 masterable cells for resolution
nobody has asked for yet. Chemistry is on track to be worse: mean 5.31 candidates per topic against
119 items.

Three ways to set the grain, and the choice should be made once, for all subjects, before more
Phase 0 capture:

1. **Practice-level grid** — cells ≡ topics, 4 skills for Calculus, 6 for Chemistry. Keeps all 15
   masterable cells. Delivers the schema parity David asked for. Adds no diagnostic resolution,
   because the mapping is 1:1 with topic.
2. **Curated narrow grid**, the way Statistics was built — only the sub-skills genuinely assessed
   against each topic, ~2-3 per topic rather than all 5-6. Keeps most mastery *and* adds resolution.
   The CED's **Learning Objective / Essential Knowledge tables** are what would make this
   transcription rather than judgment; the Course at a Glance alone does not carry it.
3. **Full sub-skill grid** — maximum resolution, near-zero mastery on current inventory. Only
   defensible after substantially more items exist.

**Recommended: 2, and it changes what Phase 0 must capture.** The LO/EK tables are a different part
of the CED from the Course at a Glance pages captured so far. If the curated grid is the target, the
remaining subjects' Phase 0 should collect them, and Calculus and Chemistry should have theirs
collected before Phase A runs.

That is precisely the thing David's question was trying to surface: a later-phase lesson that
invalidates work already done in Phase 0 if the phases are run subject-by-subject in lockstep.

## One consequence for the launch subjects

Calculus AB's 117 topic assignments already yield **15 masterable cells at topic grain** — more than
Statistics' 12 at skill grain — with no Phase B run and no further spend. If mastery coverage is
what matters near term, Calculus AB is *already* in a better position than the subject we have
finished, and running Phase B on it with the current grid design would make that worse rather than
better.
