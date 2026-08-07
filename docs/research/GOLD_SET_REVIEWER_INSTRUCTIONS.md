# Gold-set reviewer instructions — one page

**Version 1.0 — 2026-08-04**
Background and reasoning: [`GOLD_SET_AUTHORING_GUIDE.md`](GOLD_SET_AUTHORING_GUIDE.md) v2.0.
Full protocol: [`GOLD_SET_GENERATION_PROTOCOL.md`](GOLD_SET_GENERATION_PROTOCOL.md) v1.0.
You do not need to read either to do the work. Read this.

---

## Why we're asking you to do this

Our AI grades student answers, but nobody has ever checked how well it does it. To check
it, we need a pile of answers where we already know the right marking — then we let the AI
grade them and see where it disagrees with us.

That's why the answers look odd. We're not collecting good answers; we're collecting
answers that are wrong in very specific, deliberate ways — one point missing, one point
attempted but incorrect, one point almost-but-not-quite made. Those are the cases where a
grader goes wrong, so those are the cases we need marked exactly.

Your marking is the answer key. Everything the AI decides gets measured against it, so a
loose or generous mark doesn't just miss one answer — it makes the measurement wrong.

---

## The job in one sentence

For each answer you are given, mark **which rubric elements the answer actually
satisfies** — nothing more.

You are not writing answers, not fixing them, not scoring them.

---

## The five rules

1. **Mark present or absent. Never points, never a total.** If you catch yourself adding
   up a score, stop.
2. **Judge only what is written.** Not what the student meant, not what they were clearly
   about to say.
3. **Be strict.** A vague gesture, a hedge, or an adjacent statement is *absent*. The test
   is whether the specific claim is made.
4. **Give a short evidence quote** for every element you mark present — the words on the
   page that satisfy it.
5. **Stay blind.** You should never see the answer's script, the AI verifiers' marks, or
   the grader's score. If you do see one, say so and pass that answer to someone else. It
   costs one answer; not saying so costs the whole exercise.

---

## Working through a batch

- Take the answers in the order given. Don't skip ahead or look for patterns between them.
- Roughly **5 minutes per answer**. If one is taking much longer, it is probably a genuine
  ambiguity — mark your best reading and flag it.
- **Take breaks between items.** Drifting stricter or looser partway through a batch is
  the failure mode we can't detect afterward.
- Expect answers to be deliberately imperfect. Missing, wrong, and hedged elements are the
  product — that's not a defect to report.

---

## Flag it, don't resolve it

Flag rather than guess when:

- **The criterion is genuinely ambiguous** — two qualified readers would read it
  differently. That's a finding we want, not a problem for you to settle.
- **The answer looks fake** — reads like tidy model prose rather than something a rushed
  student would write.
- **An "unconventional full credit" answer is just the canonical answer reworded.** These
  are labelled A2 in the corpus. A2 with synonyms swapped is a corpus defect worth
  reporting.

You will never be asked to adjudicate a disagreement or defend your marking. Your marks
are compared automatically.

---

## Element breakdowns — Biology and Chemistry only

**Statistics, Physics and Precalculus reviewers: skip this section.**

Some multi-point criteria don't say how their points divide. The AI drafts a breakdown —
one element per point — and you confirm or correct it:

| criterion | pts | element 1 | element 2 | element 3 |
|---|---|---|---|---|
| c | 3 | states diversity increases A→C | states evenness increases A→C | explains via succession mechanism |

About **3 minutes per criterion**. Do this carefully: one breakdown is reused across all
eight answers for that item, so an error here is wrong in all eight the same way and
nothing downstream catches it.

Confirm the split; don't rewrite the rubric wording. If the criterion can't be split
without picking between two fair readings, flag it instead of picking.

---

## Questions

Flag anything ambiguous rather than guessing. Two qualified reviewers disagreeing is
information; a guess is not.
