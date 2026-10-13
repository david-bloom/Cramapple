# Cramapple Content & Pedagogy — canonical

The copy rules and the pedagogy rules. The second set are design rules, not suggestions: a screen that breaks them is wrong even if it looks right.

## Content fundamentals

**Second person, present tense, imperative.** "Read the stem before the options." "Pull a hint only if you need one." The product talks to the student as a coach mid-session, never about them.

**Name the error; don't judge the student.** Feedback says what the reading did, not that the student failed: "'will score' turns a prediction about averages into a guarantee about one student." Corrections open with `Fix:` or `Next time:`. The mark for a missed point is ↻ ("revisit", clay), never ✕ — the ✕ exists only in Open Hand, where the *teacher's* hand takes a point back.

**Verdicts are one word.** "Correct" / "Incorrect". Scores are `1 / 1`, `4 / 4`, and `— / 1` before an attempt. Never "Great job", never "Oops", no exclamation marks.

**Eyebrows label, headings name, sentences explain.** Eyebrow copy is one or two words ("QUESTION", "HINT", "FEEDBACK", "HINTS USED"). Pane titles are single nouns ("Rubric", "Answer Key", "Reference Materials", "Elimination"). Explanations are one to three sentences, in the language of the variables.

**Rules come in pairs.** Every question carries "How points are earned" and "How points are lost", three short lines each, written as habits rather than facts — one clause, no hedging. They are deliberately shorter than prose so the pane fits without scrolling.

**No emoji, ever.** Glyph vocabulary is ✓ ✕ ↻ ? ▸ ▼ ⌂ / · and the em dash. Typographic symbols only.

## Equation presentation

**A quotient of compound expressions is stacked, never written on one line with a slash.** Write the difference quotient as a stacked fraction, not as `(f(a+h)-f(a))/h`. A numerator or denominator is compound once it carries more than a single symbol — `(214 - 190)/(6 - 5)`, `(x²-4)/(x-2)` and `(3 - t)/(t² - 16)` are all wrong inline and right only stacked. This is the form the student meets on the exam, and a one-line quotient makes them resolve the precedence before they can read the mathematics.

**Four things keep the slash**, because they are conventional and stacking them reads as an error:

1. **Compound units** — `m/s`, `g/mol`, `mol/L`, `m/s²`. A unit is a name, not a division to perform.
2. **Leibniz derivative notation** — `dy/dx`, `d/dx`. Universally inline in AP mathematics.
3. **Single-symbol quotients and simple reciprocals** — `kq/r²`, `1/2`, `1/r²`.
4. **Fractions inside an argument, subscript or exponent** — `sin(7π/6)`, `t_{1/2}`, `b^{1/k}`.

The slash in a score (`1 / 1`, `— / 1`) is not division and this rule does not touch it.

**Mathematics is authored as LaTeX, and a surface that cannot render it may not show it.** Formula bodies are LaTeX source. Printing that source to a student is a defect, not a fallback: through 2026-10-12 the reference pane did exactly that, and 308 published formulas reached students as raw monospace backslashes. Equations render with KaTeX in its own bundled faces, in display style so a fraction's numerator and denominator are not shrunk to 0.7× — see `VISUAL_IDENTITY.md`, "Sizing what a student reads", which governs the size of every visual, not only mathematics.

## Pedagogy rules (these are design rules, not copy suggestions)

**The hint economy.** A hint is never free and never silent. Three states, always in this order:

1. **Idle** — a yellow block offering the hint by name ("Show me the rubric", "Rule out two choices") with a `?` chip.
2. **Asking** — "Sure you need a hint?" plus one line naming what it gives away, then "Yes, show me" (yellow) beside "No, keep solving" (a text link). The cost is surfaced *before* disclosure, and backing out is as easy as continuing.
3. **Open** — the content appears below, and the block collapses to a receipt: "Hint used · Rubric", with "Hide". The receipt never disappears, and every hint pulled is listed again in the feedback card's "Hints used" strip.

Never auto-open a hint, never open one on hover, and never let a hint close without leaving its receipt.

**Open Hand is a teaching method — it shows everything.** Open Hand shows a question, chosen to be relevant to the unit:topic being taught, together with its answer and all of the supporting educational information: the rubric, how points are earned and lost, the reference pane and the deep dive. Nothing is gated and nothing is scored. The rubric's points are face-up and manipulable, the answer key marks Correct and Distractor before the student picks, and selecting any option is free. The learning move is exploration — Open Hand MCQ invites the student to read all four explanations, and tracks how many they have read rather than scoring them.

**Practice mode scores the student's own work.** One answer, one submission, then a feedback card: score, coaching paragraph, hints-used receipt, and a per-criterion (FRQ) or per-choice (MCQ) mark list. The student's submitted work stays visible in a white band beneath the feedback so coaching can be read against it. Primary action is dimmed until there is something to submit.

**Every distractor is a named trap.** An MCQ distractor must carry (a) why it tempts and (b) the one-line fix. A distractor without a named error is not usable content.

**Reference materials are what the student may look up, not hints about this question.** Topic, skills, vocabulary — always the same three sections, in that order.