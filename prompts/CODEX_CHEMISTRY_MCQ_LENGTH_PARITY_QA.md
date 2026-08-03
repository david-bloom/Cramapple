# Codex: AP Chemistry MCQ answer-length parity QA

## Context

AP Statistics tutor Jill flagged that our MCQs "often have short distractor
answers and long correct answers" — a classic test-taking tell (pick the
longest, most detailed option) that lets students guess correct without
knowing the content.

We validated this quantitatively against Production
(`pcntajvbdfqhbeewmdry`), joining `app.content_items` → `content_item_versions`
→ `mcq_choices` for the latest version of every published MCQ per subject:

| Subject | n (published MCQs) | Correct-longer | Avg correct len | Avg distractor len | Ratio |
|---|---|---|---|---|---|
| AP Statistics | 118 | 88 (75%) | 78.5 | 49.0 | 1.60x |
| AP Biology | 54 | 47 (87%) | 217.1 | 125.6 | 1.73x |

Both subjects: real pattern, not noise. Qualitative read of the first 10 items
in each subject showed the mechanism is usually "the correct answer carries a
justification/mechanism clause the distractors don't get" — sometimes that's
legitimate (correct answer states two mechanisms where each distractor only
needs one), sometimes it's an authoring shortcut (rubric language copied into
the correct choice, distractors left as bare claims).

Your job: run the same audit on **AP Chemistry**.

## Branch note — UPDATED, step 1 is already done, don't redo it

This check now exists in **two** places, neither reconciled with the other
yet (see `prompts/CODEX_BRANCH_RECONCILIATION_INDEPENDENT_REVIEW.md` for the
full branch-reconciliation picture):

- `claude/cramapple-grading-experiments-9lkjqc`:
  `supabase/functions/_shared/mcq-quality.ts` (that branch has no
  content-preflight.ts at all).
- **`codex/five-subject-harness-and-content`, your own worktree at
  `/private/tmp/cramapple-content-qa`: added directly to
  `supabase/functions/_shared/content-preflight.ts` as a new WARNING finding
  `MCQ_CORRECT_ANSWER_LENGTH_OUTLIER` inside `checkMcq`, ratio >= 1.4x,
  committed locally as commit `b1e803d` on top of your existing unpushed
  `e7fd3b7`. Not pushed — it's sitting in your worktree right now. Pull it in
  (or just look at the commit) before you do anything else; do not
  re-implement this from scratch.**

Skip straight to step 2 below — step 1 (write the check) is done.

## Steps

~~1. Write the check into `content-preflight.ts`~~ — **done, see above.**
Just confirm the committed version behaves as expected against a couple of
real Chemistry MCQs before relying on it for step 2.

**2. Run it to produce the definitive impacted-item list for AP Chemistry.**

Run against all published Chemistry MCQs — repo packages under
`content/item-packages/ap-chemistry/` if that's where this branch's Chemistry
content lives, and/or a direct query against Production
(`pcntajvbdfqhbeewmdry`) for whatever's actually published there, however you
have it wired up. Report: total published MCQs, count/percent correct-longer,
avg correct/distractor length, ratio — same shape as the table above — plus
the full list of affected `content_key`s.

**3. Draft candidate distractor rewrites — flagged as drafts, not final.**

For each flagged item, don't trim the correct answer (may destroy real
rubric-relevant content — same reasoning as the Biology finding: naming
multiple mechanisms genuinely takes more words). Instead draft a rewritten
distractor that:
- States a real, plausible Chemistry misconception (not a random padding
  phrase)
- Matches the correct answer's level of mechanistic specificity and roughly
  its length
- Is unambiguously wrong once evaluated on content, not on length

These are drafts for subject-matter review (Chemistry content ownership,
not yours or mine to unilaterally finalize) — do not treat "the length ratio
now passes" as sign-off on chemical accuracy.

**4. Do not touch published rows directly.**

Whatever content pipeline governs this branch's Chemistry content, a rewrite
has to go through the real versioning/review flow (new version → review →
re-approval → publish), not a raw UPDATE to an already-published row. If this
branch's pipeline doesn't already enforce that, say so explicitly rather than
improvising a publish path.

**5. Re-run the length-parity check against the redrafted version before
calling anything fixed**, to confirm the ratio actually moved, not just that
a rewrite happened.

## Report back

- The quantitative table (same shape as above) for Chemistry.
- Full affected `content_key` list.
- Draft rewrites per flagged item, explicitly labeled unreviewed/draft.
- Anything you had to guess at or couldn't verify (branch state, pipeline
  enforcement, content location) — flag it rather than assuming.
