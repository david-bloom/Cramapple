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

## Branch note

This check was implemented on `claude/cramapple-grading-experiments-9lkjqc` as
a new `supabase/functions/_shared/mcq-quality.ts` module, because that branch's
`admin-content/index.ts` has no preflight-gate infrastructure at all yet.

Your environment has `supabase/functions/_shared/content-preflight.ts`
(from `codex/five-subject-harness-and-content`, commits `c5f5392`→`e7fd3b7` —
the file your own independent re-QA audited on 2026-07-20). Put the check
there instead, as a new finding alongside the existing completeness checks —
same conceptual check, correct location for your branch's actual
infrastructure. Don't try to reconcile the two branches' preflight
approaches; that's a separate, bigger piece of work than this task.

## Steps

**1. Write the check into `content-preflight.ts`.**

Add a new WARNING-severity (not BLOCKING — a genuinely longer correct answer
can be legitimate and needs human judgment) finding code
`MCQ_CORRECT_ANSWER_LENGTH_OUTLIER`, following whatever finding-emission
pattern `checkMcq` already uses in that file. Logic:

```
correct_length = length(the one is_correct choice's choice_text)
distractor_avg_length = average length of the other choices' choice_text
ratio = correct_length / distractor_avg_length
flag if ratio >= 1.4
```

1.4 is calibrated below both observed population ratios (1.60x, 1.73x), so it
catches the pattern earlier than the norm rather than only matching it exactly.
Skip (don't flag, don't crash) if there isn't exactly one correct choice or
there are no distractors — that's a different, already-covered completeness
defect. Add regression tests following the existing test conventions in that
file/directory (there's already a coverage gap noted for several blocking
codes in the prior re-audit — don't add to it; test this new code same as the
others).

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
