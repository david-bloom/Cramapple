# Lovable Prompt — Gold-set verification screen: render the actual question parts

**Target:** Lovable workspace for `exam-buddy-wireframe` (production build source for
cramapple.com). **Not** the `david-bloom/Cramapple` docs repo.
**Date:** 2026-08-07
**Related:** `prompts/LOVABLE_GOLD_SET_VERIFICATION_SCREEN_2026_08_03.md` (the original
build brief for this screen — this prompt is a follow-up fix to it, not a new feature);
`supabase/migrations/20260805130000_gold_set_question_parts.sql`

---

## What's broken

Jill Schmidlkofer (gold-set reader) reported she cannot see the actual question being
asked while marking — only a placeholder stem like "Answer all parts of the following
question." She's inferring what the four sub-questions must have been by reading the
element labels (i.e. reverse-engineering the question from the grading criteria), which
is backwards and error-prone.

**This was already fixed on the backend, two days before this prompt.** The
`gold_set_verification_next()` RPC was updated on 2026-08-05 to add a `parts` array
containing the real per-part question text. It has been live in Production since, and is
verified still working today. But no corresponding frontend change ever shipped — the
verification screen still only renders `stem`, which is why Jill is seeing the same
problem again. This prompt is that missing frontend change.

## The RPC contract has one new field: `parts`

`supabase.rpc('gold_set_verification_next')` now returns (unchanged fields omitted):

```
{
  assignment_id: string,
  seq: number,
  stem: string,
  stimulus: string | null,
  stimulus_image_path: string | null,
  parts: Array<{               // <-- NEW as of 2026-08-05, not yet rendered anywhere
    part_key: string,          // e.g. "a", "b", "c", "d"
    prompt_text: string        // the actual sub-question text for that part
  }>,
  answer_text: string,
  elements: Array<{ ... }>     // unchanged
}
```

`parts` is always an array — empty (`[]`) for items that don't use the multi-part
structure, populated in `part_key` order otherwise. `stem` is left in the payload
unchanged and should still be shown; it is not being replaced, just supplemented.

## The fix

In the question column of the marking screen (left column on desktop, question section
on mobile — see the original brief's "The marking screen" section), after the stimulus
and stimulus image and before the answer card:

- If `parts` is non-empty, render each part as its own labelled block, in array order:
  a short label from `part_key` (e.g. "Part A", capitalizing/uppercasing the key) followed
  by that part's `prompt_text`. Use the same typographic treatment as the stem/stimulus —
  this is still "the question," just the part of it that was missing.
- If `parts` is empty, render nothing extra — the stem alone is the complete question for
  that item, exactly as today.
- Do not change anything about how `stem` or `stimulus` are rendered. This is additive.
- Do not add `points_possible` anywhere on this screen — it is deliberately excluded from
  the RPC response (see the migration comment) so readers mark content, not points. If you
  notice `parts` doesn't carry point values, that's intentional, not a bug to work around.

No other route, screen, or RPC changes. Do not touch the existing reviewer review queue —
this fix is scoped to `/reviewer/gold-set/verify` only, same as the original brief.

## Why this matters enough to say twice

The scientific validity of the gold-set certification depends on the reader judging the
answer against what was actually asked. A reader inferring the question from the grading
criteria is doing the certification process backwards — she's using the answer key to
guess the question, which defeats the independent-verification purpose of having a human
reader in the loop at all.
