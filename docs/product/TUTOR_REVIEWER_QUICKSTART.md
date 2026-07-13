# Cramapple Reviewer Quickstart (for Tutors)

A short walkthrough for reviewing Cramapple content. Full rubric and dispositions are in `docs/research/TUTOR_CONTENT_ASSESSMENT_PILOT_2026_07_12.md` — this is the short version to get started.

## 1. Sign in

Go to **[cramapple.com/tutor-login](https://cramapple.com/tutor-login)**. Reviewer access is invite-only — use the email address Cramapple invited you with.

The page is headed "READER & TUTOR PORTAL — Sign in to review," with a single email field and an **Email me a sign-in link** button. Enter your email, click the button, then open the email and click the one-time link. You do not need a password.

> This step was verified live against production (2026-07-13) — the screen described above is real, current, and screenshotted. Later steps in this doc (queue, item review, submit) are described from the built review workflow's actual behavior but have not yet been screenshotted live, since no tutor account exists yet to sign in past this screen. Real screenshots of those steps will be added the first time a tutor completes sign-in.

## 2. Find your queue

After signing in you land on your reviewer queue. You'll only see content you're qualified and assigned to review — if you're scoped to AP Statistics, you won't see AP Biology items and vice versa.

## 3. Review each item

**For a multiple-choice question (MCQ):** read the stem, then every answer option, the designated correct choice, and each rationale. You're approving the question *and* the answer choices together in one submission — not in two separate passes.

**For a free-response question (FRQ):** read the stem/stimulus, then every rubric criterion — check that each criterion's evidence requirement and "minimum fix" (the smallest correction that would earn the point) are clear and correct.

Don't edit the content directly. If something needs to change, that's a "Maybe" or "No" with a note (see below) — a corrected version comes back to you as a fresh review later.

## 4. Make your decision

Choose one:

- **Yes** — suitable as-is, no changes needed.
- **Maybe** — plausible, but flag exactly what needs to change.
- **No** — not usable in its current form.

If you choose anything other than a clean **Yes**, a note is required — be specific enough that whoever revises the item knows exactly what to fix. Use the issue codes (`Accuracy`, `Ambiguity`, `Rubric gap`, `Other`) to categorize the problem.

## 5. Submit and lock

Once submitted, your decision locks — you won't see the other reviewer's decision on the same item, and you can't edit after submitting. If the item comes back as a revised version later, you'll review it fresh.

---

## Subject-specific standard: AP Statistics (2026-27 CED)

This section is the standard for evaluating **AP Statistics** content specifically. It's sourced directly from the College Board *AP Statistics Course and Exam Description, Effective Fall 2026* (the version covering the exam administered May 2027 — the exact exam your assigned students are studying for). This is a **major restructuring**, not a minor update — hold every AP Stats item you review to this version, not to whatever an older item or your own AP Stats background assumes.

**Why this matters right now:** the course just went from a 9-module structure to 5 units, the FRQ section changed shape entirely (6 small questions → 4 large ones), and at least two topics that used to be tested (inference for the regression slope; chi-square goodness-of-fit) do not appear in the new unit list. If you're reviewing an older item that still assumes the old shape, flag it — don't approve it as-is.

### Unit structure to tag against

| Unit | Topic | MC Weight |
|---|---|---|
| 1 | Exploring One-Variable Data and Collecting Data | 20–30% |
| 2 | Probability, Random Variables, and Probability Distributions | 15–25% |
| 3 | Inference for Categorical Data: Proportions | 15–25% |
| 4 | Inference for Quantitative Data: Means | 10–20% |
| 5 | Regression Analysis | 10–20% |

If an item you're reviewing is tagged with an old "Module 1–9" label instead of one of these five units, flag it as `Rubric gap` — it needs re-tagging before it's usable.

### The 4 Statistical Practices

Every MCQ and FRQ is built to test one or more of these — check that the item's stated practice tag actually matches what the question demands:

- **Practice 1 — Formulate Questions:** determine a valid investigative question for a statistical study.
- **Practice 2 — Collect Data:** identify/justify data-collection and inference methods, identify null/alternative hypotheses and error types.
- **Practice 3 — Analyze Data:** construct tabular/graphical representations, calculate summary statistics, probabilities, expected counts, means/SDs.
- **Practice 4 — Interpret Results:** describe/compare distributions, justify a claim from calculations or inference results.

### FRQ shape — this is the part most likely to be wrong in older content

The exam has exactly **4 FRQs, 10 points each** (not 6 questions at ~4 points each — that's the old shape):

- **Question 1** — multi-part, primarily Practices 1 & 2.
- **Question 2** — multi-part, primarily Practices 3 & 4.
- **Question 3** — dedicated inference question (hypothesis test or confidence interval), Practices 2, 3, & 4.
- **Question 4** — multi-part, spans multiple content areas, Practices 2, 3, & 4.

Each question is broken into lettered parts (A, B, C…) with numbered sub-parts (i, ii…), and **each point is scored independently** — a wrong answer on part A doesn't disqualify credit on part B. When you review an FRQ's criteria, check that:

- Each criterion corresponds to one independently-earnable point (binary: earned / not earned), not a bundled multi-idea point.
- The criterion states what response **does** and **does not** earn the point — plainly worded, not just "correct answer given."
- A couple of concrete example phrasings exist for both the earning and non-earning case (the real CED does this for every point — e.g. "cluster random sample" earns the point, "random sample" alone does not). If Cramapple's criterion has no example phrasing at all, that's a `Rubric gap`.
- The "minimum fix" is the smallest concrete change that would flip a non-earning response to an earning one — not a full re-explanation.

### Task verbs — check the criterion matches the verb's actual demand

If a question part says **Identify**, the response only needs to name the right thing — no justification required, and none should be demanded by the rubric. If it says **Explain** or **Justify**, a bare correct term is *not* enough — the rubric must require reasoning. Common verbs and what they actually demand: **Calculate** (do the math), **Identify/Classify** (name it, no elaboration needed), **Construct** (produce a graphical/tabular representation), **Describe** (state characteristics), **Compare** (numerically or descriptively contrast two or more things), **Explain** (give reasoning for why/how), **Justify** (give evidence defending a claim), **Determine** (apply a method or reach a conclusion from calculation), **Interpret** (connect a result back to the real-world context), **Complete** (identify conditions, justify them, and calculate the inference result together). A rubric that demands justification for an "Identify" part — or accepts a bare label for a "Justify" part — is a mismatch; flag it as `Rubric gap`.

### What's still uncertain — flag, don't reject

Two topics that used to be part of AP Statistics don't appear in the new unit list: **inference for the regression slope**, and **chi-square goodness-of-fit**. If you're reviewing an item that tests either of these, don't automatically fail it — flag it with a note ("tests a topic not found in the 2026-27 CED unit list — needs a product-team decision on whether this stays in scope") and let David/Orly make the call. This hasn't been fully confirmed against the prior CED edition yet.

### Hand-drawn graph responses are still in scope

Even though the real exam is going fully digital, Cramapple has no Desmos-equivalent graphing tool, and students still need practice constructing statistical graphs by hand. Continue reviewing hand-drawn graph-response items normally — this is a deliberate product decision, not an oversight.

---

Questions about scope, pacing, or anything ambiguous in an item: ask before guessing.
