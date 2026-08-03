# Writing gold-set answers — tutor and verifier guide

**Version 1.0 — 2026-07-30**
**Workbook:** `GOLD_SET_ANSWER_WORKBOOK.xlsx` (one copy per tutor)

---

## 1. What you are building, and why it is not what you'd expect

You are **not** writing model answers. You are writing a **test for our grader.**

Cramapple's AI grader has never been checked against a human on a real student answer. Not once.
We cannot currently state how accurate it is, because we have nothing to compare it against. You
are building that comparison.

That changes what a "good" answer is. A polished, complete, textbook answer is almost useless to
us — the grader gets those right. What we need are answers where **we know in advance exactly
which rubric points should be awarded**, especially the awkward middle cases. If your answer set
is too clean, the whole exercise tells us nothing. Deliberately imperfect answers are the product.

**The one thing that makes this work:** every answer is written to a *script* that says which
rubric elements it contains and which it leaves out. We then check whether the grader's scoring
matches the script. Where it doesn't, we've found a real grader defect.

---

## 2. Two roles, and the rule that cannot bend

| role | does | never does |
|---|---|---|
| **Writer** | decomposes the criteria, scripts answers, writes them | verifies or grades their own answers |
| **Verifier** | reads a finished answer cold and marks what's actually in it | sees the script before marking |

**A writer must never verify their own answers, and the verifier must not see the script.**

This is not bureaucracy. When we ran this with an AI writing to a script, **5 of 10 answers did
not match their own script** — they included ideas they were explicitly told to leave out. If the
writer also verifies, that error is invisible, and we end up measuring tutor compliance while
believing we're measuring grader accuracy. The verifier is the only thing standing between us and
a gold set that is quietly wrong.

Expect roughly **1 in 5 answers to be discarded** at verification. That is the process working.
Do not argue discarded answers back in — it is cheaper to write a new one.

---

## 3. Before writing anything: decompose the criterion

Most of our multi-point criteria do not say how their points divide. Of 617 criteria worth more
than one point, **455 (74%) give no breakdown.** For example, a real 3-point criterion reads only:

> *Diversity and evenness increase from Plot A to Plot C as succession proceeds; explanation
> connects community assembly and changing habitat or species interactions to the trend.*

Three points, no statement of what each is for. **Your first job on every multi-point criterion is
to write down that breakdown** in the `Elements` sheet — one element per point:

| criterion | pts | element 1 | element 2 | element 3 |
|---|---|---|---|---|
| c | 3 | states diversity increases A→C | states evenness increases A→C | explains via succession mechanism |

You cannot script a 2-of-3 answer until you know what the three things are. Use your subject
judgement; where the rubric is genuinely ambiguous, **flag it** in the `Notes` column — an
ambiguous criterion is itself a finding worth having.

> This decomposition is needed to *build the test*. It is not a request to rewrite the rubric —
> we measured that adding breakdowns to the rubric does not improve grading, so don't spend time
> polishing the wording.

---

## 4. The eight answers per question

Write **8 answers per question**, following this recipe. Each answer is graded against *every*
criterion on the item, so one answer exercises the whole rubric at once.

| # | type | what it must be |
|---|---|---|
| **A1** | Full credit, canonical | Everything, phrased the way the rubric expects. The easy case. |
| **A2** | **Full credit, unconventional** | Everything, but in **different words, a valid alternative method, or unusual notation**. Must genuinely deserve full marks. |
| **A3** | Partial — omit | Complete except **one element is simply absent**. Not wrong — missing. |
| **A4** | Partial — omit differently | A different subset absent, ideally across a different criterion. |
| **A5** | Partial — attempted and wrong | An element is **addressed but incorrect** (not merely missing). This grades differently from A3 and we need both. |
| **A6** | Near-miss | Uses adjacent, hedged, or vague wording that sounds right but **should not earn the point**. |
| **A7** | Error carried forward | An early value is wrong; later work applies **correct method to that wrong value**. Should still earn the method points. *Skip if the item has no dependent parts — write another A3-style answer instead.* |
| **A8** | Contradiction or near-zero | Either states something then contradicts it later, or addresses almost nothing. |

**A2 is the one people skip, and it's the most important.** In testing, the grader gave full marks
to only **7 of 10 genuinely complete answers** — it under-credits correct work that isn't phrased
canonically. A1 alone will never expose that. If you write A2 as a lightly reworded A1, we lose
the single most valuable probe in the set.

---

## 5. How to write the answer text

**Sound like a real student under time pressure.** Informal, uneven, sometimes vague. Real answers
have run-on sentences, hedges, and abbreviations. A tidy paragraph is not what 2,500 teenagers
will submit, and a grader tuned on tidy paragraphs will fail on real ones.

**Length:** 2–5 sentences for short FRQs; a short paragraph per part for long FRQs. Match what a
student would actually produce in the time available.

**Express ideas, don't announce them.** Write *"eventually it stops going up no matter how much
you add"* — not *"Element 2: the rate plateaus."* Signposting makes the answer trivially easy to
grade and destroys its value as a test.

**Omission means absent, not denied.** To leave an element out, just don't write it. Do **not**
write *"I don't know about the active sites."* An explicit disclaimer is a different test.

**Do not reference the rubric, the criteria, or the point values inside the answer.**

---

## 6. Five ways this goes wrong — all observed

1. **Leaking an omitted element.** By far the most common. Elements that are closely related in
   meaning slip in through a side remark. If you're told to omit "the curve flattens" but you
   write "it ends up level at the top", you have included it. **Reread every answer once, hunting
   only for elements you were supposed to leave out.**
2. **Writing all eight answers in one voice.** They start to read like one student. Vary register,
   length and structure deliberately.
3. **Making partial answers bad answers.** A 2-of-3 answer should be *good work missing a piece*,
   not a weak answer. If your partial answers are all poor, you're only testing the easy end.
4. **A2 that isn't really unconventional.** Change the *approach*, not just the synonyms.
5. **Making near-misses too obviously wrong.** A6 should be genuinely tempting — the kind of thing
   that starts an argument between two reviewers. If it's clearly wrong, it tests nothing.

---

## 7. The verifier's job

You receive an answer with **no script**. For each criterion on the item, mark **which elements
the answer actually satisfies** — based only on what is written on the page.

- Be strict. A vague gesture, a hedge, or an adjacent statement does **not** count.
- Judge only what is present, not what the student probably meant.
- Do **not** award points or assign a score. Mark elements present or absent — nothing else.
- Never look at what the AI grader produced. If you have seen it, hand the answer to someone else.

Your marks and the writer's script are then compared automatically. Agreement → the answer enters
the gold set. Disagreement → discarded, and no one needs to adjudicate it.

---

## 8. Volume and priority

| batch | subject | questions | answers |
|---|---|---:|---:|
| **1** | **AP Biology** (published FRQs) | **30** | **240** |
| 2 | AP Chemistry | 5 | 30 |
| 2 | AP Calculus AB | 5 | 30 |
| 2 | AP Calculus BC | 5 | 30 |

**Batch 1 is the priority and should be finished first.** AP Biology holds 64% of all multi-point
criteria and 83% of the published ones, and it is the August 2026 beta subject. Batch 2 subjects
are canaries — enough to catch subject-specific breakage, not enough to certify them.

Physics, Precalculus and Statistics are **out of scope**: they have no multi-point criteria at all,
so the behaviour under test does not apply to them.

Roughly **12 minutes per answer** to write, **5 minutes** to verify.

---

## 9. What happens to your work

Every accepted answer is graded by the AI, and its score is compared to your script, criterion by
criterion. The output is a table of where the grader **over-credits** and where it **under-credits**,
per criterion and per subject — the first real measurement of grading quality we will have.

The set is then **frozen** and becomes a permanent regression suite: every future change to the
grader is re-run against it. Nothing that fails it ships.

**We will never tune the grader on this set.** Anything tuned on its own test data looks excellent
and means nothing — we have measured that mistake here twice.

---

## Questions

Flag anything ambiguous in the `Notes` column rather than guessing. A criterion two qualified
tutors read differently is a finding in its own right, and we would rather capture it than have it
silently averaged away.
