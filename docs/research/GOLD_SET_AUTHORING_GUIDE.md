# Gold-set verification — reader guide

**Version 2.1 — 2026-08-13** (v2.0 adopted 2026-08-03; supersedes v1.0, 2026-07-30)
**Operational protocol:** [`GOLD_SET_GENERATION_PROTOCOL.md`](GOLD_SET_GENERATION_PROTOCOL.md)
**Disagreement queue:** [`GOLD_DISAGREEMENT_ADJUDICATION_QUEUE.md`](GOLD_DISAGREEMENT_ADJUDICATION_QUEUE.md)
**Adopted by:** DECISION-0045; v2.1 disagreement addendum owner-directed 2026-08-13

---

## What changed from v1.0, and why

v1.0 asked readers to **write** 330 answers and verify them. That was roughly 94 hours of
reader time, on the roster that is already the bottleneck on content review. It was not
going to happen, and a gold set that never exists measures nothing.

**Answers are now written by AI and checked by two independent AI verifiers before you
see them.** Your job changed completely. You no longer write anything.

This is not a downgrade of your role. It is a concentration of it: reader attention now
goes entirely to the two places where reader judgement cannot be substituted, and where an
error would otherwise be invisible. Everything the AI produces is unverified until you
certify it — you are not checking its homework, you are the reason anyone can trust it.

**v2.1 clarification:** the two original cold readers still do not discuss or adjudicate
their own disagreements. After both reads are locked, a different qualified reviewer may
receive a small third-reader adjudication assignment. That process is defined in
`GOLD_DISAGREEMENT_ADJUDICATION_QUEUE.md`.

---

## 1. What you are building, and why it is not what you'd expect

You are **not** assembling model answers. You are building a **test for our grader.**

Cramapple's AI grader has never been checked against a human on a real student answer.
Not once. We cannot currently state how accurate it is, because we have nothing to
compare it against. You are building that comparison.

That changes what a "good" answer is. A polished, complete, textbook answer is almost
useless to us — the grader gets those right. What we need are answers where **we know in
advance exactly which rubric points should be awarded**, especially the awkward middle
cases. Deliberately imperfect answers are the product.

Every answer was written to a *script* saying which rubric elements it contains and which
it leaves out. Two AI verifiers have already read it cold and marked what's actually in
it. Where all three agree, it is a candidate. **Your marking is what decides whether that
agreement can be trusted at all.**

---

## 2. Your jobs

### Job 1 — Verify answers cold

You receive an answer with **no script, no AI verifier output, and no indication of how
it got to you.** For each criterion on the item, mark **which elements the answer
actually satisfies**, based only on what is written on the page.

- Be strict. A vague gesture, a hedge, or an adjacent statement does **not** count.
- Judge only what is present, not what the student probably meant.
- Do **not** award points or assign a score. Mark elements present or absent — nothing
  else. Scoring is the grader's job, and doing it here contaminates the comparison.
- Never look at what the AI grader produced. If you have seen it, hand the answer to
  someone else.

**Why the blindness matters.** If you know an answer was already auto-accepted, you are
no longer an independent check on auto-acceptance — you are agreeing with it. The whole
value of your pass is that it was made without knowing what anyone else concluded.

Your marks are then compared automatically against the script and the AI verifiers. As an
original cold reader, you will **not** be asked to negotiate or adjudicate a disagreement
with the other original reader. Your submitted mark remains independent evidence.

### Job 2 — Confirm element breakdowns *(Biology and Chemistry only)*

Most multi-point criteria do not say how their points divide. Of 617 criteria worth more
than one point, **455 (74%) give no breakdown.** A real 3-point criterion reads only:

> *Diversity and evenness increase from Plot A to Plot C as succession proceeds;
> explanation connects community assembly and changing habitat or species interactions to
> the trend.*

Three points, no statement of what each is for. The AI drafts a breakdown — one element
per point — and you confirm or correct it:

| criterion | pts | element 1 | element 2 | element 3 |
|---|---|---|---|---|
| c | 3 | states diversity increases A→C | states evenness increases A→C | explains via succession mechanism |

**This is the single highest-value task in the process.** One breakdown is reused across
all eight answers for that item. If it is wrong, all eight are wrong in exactly the same
way, and nothing downstream will catch it.

Where the rubric is genuinely ambiguous, **flag it** rather than picking. A criterion two
qualified readers read differently is a finding in its own right, and we would rather
capture it than have it silently averaged away.

> This is needed to *build the test*. It is not a request to rewrite the rubric — we
> measured that adding breakdowns to the rubric does not improve grading, so don't spend
> time polishing wording.

**Statistics, Physics and Precalculus have no multi-point criteria**, so Job 2 does not
arise there. Readers on those subjects do Job 1 only.

### Job 3 — Third-reader disagreement adjudication *(assigned only)*

A small number of qualified reviewers may receive a disagreement case **after two other
readers have completed their cold reads**. If you are assigned one:

1. You are not shown either original reader's mark, the writer script, machine-verifier
   output, or grader output.
2. Read the question, answer and relevant rubric element cold and record `present` or
   `absent` with evidence.
3. Lock that mark first. Only then may the disagreement history be revealed for final
   classification.
4. Classify the case as `FINAL_PRESENT`, `FINAL_ABSENT`, `RUBRIC_AMBIGUOUS`,
   `GOLD_ANSWER_DEFECT`, or `RUBRIC_OR_CONTENT_DEFECT`.
5. If the answer/rubric is genuinely ambiguous or defective, do not force a binary label;
   escalate it instead.

The operational queue, current cases, and closure rules are in
`GOLD_DISAGREEMENT_ADJUDICATION_QUEUE.md`.

---

## 3. What the answers you'll see are meant to be

You don't write these, but knowing the recipe makes you a better verifier — particularly
at spotting an answer that has failed to be what it claims.

| # | type | what it must be |
|---|---|---|
| **A1** | Full credit, canonical | Everything, phrased the way the rubric expects. Taken from the item's canonical answer, not generated. |
| **A2** | **Full credit, unconventional** | Everything, but in **different words, a valid alternative method, or unusual notation**. Must genuinely deserve full marks. |
| **A3** | Partial — omit | Complete except **one element is simply absent**. Not wrong — missing. |
| **A4** | Partial — omit differently | A different subset absent, ideally across a different criterion. |
| **A5** | Partial — attempted and wrong | An element **addressed but incorrect** (not merely missing). Grades differently from A3. |
| **A6** | Near-miss | Adjacent, hedged, or vague wording that sounds right but **should not earn the point**. |
| **A7** | Error carried forward | An early value is wrong; later work applies **correct method to that wrong value**. Should still earn the method points. |
| **A8** | Contradiction or near-zero | States something then contradicts it, or addresses almost nothing. |

**A2 is the most important one, and the easiest to get wrong.** In testing, the grader
gave full marks to only **7 of 10 genuinely complete answers** — it under-credits correct
work that isn't phrased canonically. If you see an A2 that is really just A1 with
synonyms swapped, say so. That's a defect in the corpus worth reporting.

---

## 4. Five ways verification goes wrong

1. **Crediting an element that was only gestured at.** The most common. If the answer
   says *"it ends up level at the top"* and the element is *"the curve flattens"* — that
   is present. If it says *"the numbers change a lot at first"* — that is not. The line is
   whether the specific claim is made, not whether the student seems to be near it.
2. **Reading in what the student meant.** You are an unusually good subject expert
   marking an answer written to look like a rushed teenager's. The temptation to complete
   their thought for them is strong and must be resisted.
3. **Marking points instead of elements.** If you find yourself computing a total, stop.
4. **Drifting stricter or looser across a batch.** Verification is repetitive. Take
   breaks between items rather than pushing through a long block.
5. **Looking at something you shouldn't have.** If you see the script, the AI output, or
   the grader's score for an answer, that answer is contaminated — say so and pass it on.
   This costs one answer. Not saying so costs the certification.

---

## 5. Volume

Readers are certifying a pipeline, not producing a corpus, so the load no longer scales
with the size of the set.

**Pilot — Statistics and Physics, this round:**

| reader | subject | items | answers to verify | est. time |
|---|---|---:|---:|---:|
| Jill | AP Statistics | 6 | 40 | ~3.5 h |
| Saood | AP Statistics | 6 | 40 | ~3.5 h |

You are both marking **the same 40 answers**, independently. That is deliberate — two cold
markings of one answer measure the machine better than one marking each of two answers.
Do not compare notes, and do not discuss an item with the other reader until both queues
are drained. Physics and the maths wait for reviewers currently being hired.

In the pilot you verify **every** answer that reached you. That is the point: we are
measuring how often the machine is wrong, and you cannot measure that from a sample of
itself.

**After the pilot,** if the machine's error rate clears the certification bar, readers
verify a random sample only — roughly 100 answers per set regardless of how large the set
is. If it does not clear the bar, we go back to reader verification of everything, and
the plan gets re-scoped.

Third-reader adjudication is expected to be much smaller than the ordinary verification
queue: it is created only from actual two-reader element disagreements.

Roughly **5 minutes per answer** to verify; element breakdowns (Biology/Chemistry) around
**3 minutes per criterion**, done once and reused eight times.

---

## 6. What happens to your work

Every certified answer is graded by the AI, and its result is compared to the agreed
labels, criterion by criterion. The output is a table of where the grader
**over-credits** and where it **under-credits**, per criterion and per subject — the
first real measurement of grading quality we will have.

Where two original readers disagree, the disagreement remains part of the certification
record even after third-reader adjudication. Adjudication establishes the authoritative
label for the frozen regression set; it does not erase the fact that the original readers
disagreed.

The set is then **frozen** and becomes a permanent regression suite: every future change
to the grader is re-run against it. Nothing that fails it ships.

**We will never tune the grader on this set.** Anything tuned on its own test data looks
excellent and means nothing — we have measured that mistake here twice.

---

## Questions

Flag anything ambiguous rather than guessing. Two qualified readers disagreeing is
information; a guess is not.
