# Decisions Log

This log records product, architecture, operating, security, design, and workflow decisions.

## Index

Most recent entries (full chronological list follows below):

- DECISION-0126 — Seven-Day Free Trial With a Saved Card for Every Checkout, Parent-Pay Included (Partly Revises `DECISION-0090`); Price Locked at Signup, Cancel Ends Access Now, One-Day Grace, One Trial Per Email (Student or Payer), Terms Acknowledgment, Cardless Trial Retired (`TASK-0077`)
- DECISION-0125 — ASCII-Notation Cleanup Is Approved in Two Tiers (Answer Choices First, Then All 1,664 In-Scope Multiple-Choice Rows), in LaTeX Everywhere, Converting Exponents in Units (`TASK-0075`)
- DECISION-0124 — Cross-Subject Duplicate Entries Are Allowed (Handoff §3.3): No Alias, No Normalisation; Figures May Be Shared Across Subjects
- DECISION-0123 — Figure Lane Rulings: `DECISION-0116` Ratified, `chem-mb-energy` Confirmed on Chemistry 3.5, the Unreviewed Lane A/B Figures Released, and the Chart-Shaped Entries Outside `kind='diagram'` Become the Next Lane
- DECISION-0122 — The Ten Rubric-Line LaTeX Edits Are Dropped: the Grader Reads Rubric Text, So Rubric Rows Keep Their Plain Text Unless a Verified Mitigation Exists (`TASK-0074`, `TASK-0073`)
- DECISION-0121 — Compound Quotients in Question and Teaching Prose: Display-Only Stacking, Inline Slashes Kept; Author Forward, Backfill Only Where It Hurts, Pilot on Precalculus and Physics C (`TASK-0073`)
- DECISION-0120 — Minimum Size for Anything a Student Reads Is Set by the Smallest Rendered Glyph, Not the Element: Mathematics Renders in Display Style; the Published Figures Are Measured Below the Floor and Left Open
- DECISION-0119 — Equation Presentation: a Quotient of Compound Expressions Is Stacked, Four Conventional Slashes Are Kept, and a Surface That Cannot Render LaTeX May Not Show It; Rendered Equations Use KaTeX's Own Faces, Amending the STIX Two Math Rule
- DECISION-0118 — Relevant Published Memory Hooks May Be Used in Hints, Post-Miss Feedback, and Student-Requested Targeted Help; Assistance Timing Rules Stay in Force
- DECISION-0117 — The Current MCQ Answer May Be Preloaded Into Client Memory for Instant Feedback; Direct Database Reads Stay Closed and Server Persistence Remains Authoritative
- DECISION-0116 — When a Published Entry Authors No `items[]`, the Figure's Own `labels` Are the Contract (Route b); Carried Per Use, Gated in `verify.py`
- DECISION-0115 — A Figure's Renderer Family Is Data, Not Schema: `app.figure_families` Lookup Plus Foreign Key Replaces the Hard-Coded CHECK
- DECISION-0111 — Student Photo Retention for Hand-Drawn Responses: Kept While the Account Exists, Bytes Redacted 24 Months After the Attempt or on Deletion/Erasure, Audit Row and Digest Kept (Plan D4)
- DECISION-0112 — AP Chemistry Unit 1 Reference Escalations: Both Accepted (1.8 Bond Likelihood, 1.7 Tools for Periodic Trends)
- DECISION-0113 — AP Chemistry Units 5–9 Escalations: Owner/Tag Fixes, Qualifier-Preserving Re-Extraction, One Drop, Unit 8 Duplicates Retired
- DECISION-0110 — A Photographed FRQ Answer Is Graded Only After the Student Confirms the Transcript; the Confirmation Screen Asks the Student to Add Anything Missing So Cramapple Can Help (Plan D2, Conditioned)
- DECISION-0109 — Same-Device Camera Capture for Hand-Drawn Responses When the Student Is Already on a Phone; QR Remains the Desktop Handoff (Narrow Amendment to DECISION-0051; Plan D1)
- DECISION-0108 — BYOQ Photo Extraction With Student Confirmation Replaces Typed Transcription and TASK-0039 Phase 3: Photos Only, Subject/Unit From Context, OpenAI Build-Measure-Switch, Student Answer Marks Stored, Phone-Side Review, No Policy Change, No Spend Cap; TASK-0068 Opened
- DECISION-0107 — Memory Hooks Pilot Rulings: a CED-Named Hook Overrides the Veto's Order Objection (SOCS Loaded); 1.13 Owns "Scope of Conclusions"; the Own-Family Veto Moves from Opus 5.5 to Haiku 5.5 on Cost
- DECISION-0105 — Unit Reference Content (Formulas, Vocabulary, Lists, Conventions, Diagrams) Is the Companion Content for Memory Hooks: TASK-0067 Opened, Hooks Require a Reference Entry (Amends DECISION-0104 D3), Fact-Pack Extraction First, Diagrams Text-Only Until TASK-0006 Renders
- DECISION-0104 — Memory Hooks Approved as Proposed (D1–D7): Topic-Owned Grain, CED Point-Bearing Inclusion Rule, Option B Table, Songs Out of v1, Three Surfaces, Stats Unit 1 + Chem Unit 4 Pilot; Amended to Include Diagram Parts
- DECISION-0103 — Student Hub Slice 1 Contracts: Save on Change, Unit-Wide Study Scope, "Asked and Scored" Door Line, Revisit Queue Removed, No Dismissible First-Use Panel
- DECISION-0102 — Items Made by Generate-and-Select (Protocol §0) Need No Human Review Before Load; the Production Hard-Gate Approval Remains
- DECISION-0101 — Seeds and Variants (§0): Difficulty Is Not an Author Target and Stays a Provisional Label; Skills Targeted at Practice Level; Variants Inherit the Seed's Labels Instead of Re-Voting
- DECISION-0100 — Learning Through a Worked (Scored) Example Is a Recommended, Exam-Directed Path on the Student Hub, Never a Required Step; Four Equal Entry Points (Worked Example, Practice, Deep-Dive Notes, Bring a Question)
- DECISION-0099 — Generate-and-Select Is the Default Method for New MCQs (Required for Open Hand Teaching Items): No Hand Edits, One Shared Rubric, Four Non-Author Checker Families Plus a Reject-Only Own-Family Veto, Planted-Defect Controls
- DECISION-0098 — Released-Exam-Derived Student Practice Sets May Seed Original Items Only Through the Clean-Room Spec Path
- DECISION-0097 — Owner Override: Open Hand and the Plate-Loop Practice Template Ship to Production Without the Fresh QA TASK-0051 Required; the Plate Loop Becomes the Default Practice Entry
- DECISION-0096 — MCQ and FRQ Variants Inherit Their Seed's Difficulty Band; an Unrated Seed Is Rated First and Applied to Its Variants
- DECISION-0095 — Items Stay Within the Subject's CED Vocabulary; a Mechanism Supplied in the Stem Does Not Bring a Term In Scope; Published Items That Break It Are Retired, Not Repaired
- DECISION-0094 — Launch Shape Revised: $1 Pilot Coupon (10 Friends) Before a 50%-Off Public Launch; Parent-Pay Live; Strangers May Pay Full Price; Supersedes DECISION-0091
- DECISION-0065 — Four Rules to Unblock J.0's Continuous `attainment_ratio` (FF-6): AI Cross-Model Verb Verification, Same-Tier Borrowing, Mean Aggregation, Non-Overlapping Cut Points
- DECISION-0064 — Split `APBIO-FRQ-S-101` Criterion `a-iv` Into Two Stem-Aligned Criteria; Authorize Rewriting `S-021`/`S-023`/`S-058`'s Canonical Answers to Match Their Rubrics
- Older entries (newest archive first): [`DECISIONS_LOG-0066_to_0093`](archive/DECISIONS_LOG-0066_to_0093.md), [`DECISIONS_LOG-0001_to_0065.md`](archive/DECISIONS_LOG-0001_to_0065.md)

*Rotated 2026-10-15: entries dated before 2026-10-01 moved to the archive above, with their index lines; nothing was discarded. This log now holds 2026-10-01 onward.*

**Rotation rule:** once this log exceeds ~600 lines, archive the older entries to `docs/activity_log/archive/DECISIONS_LOG-<range>.md` and update this index to point at the archive. Keep the index itself to the last ~10 entries. (This log is already well over that threshold — the first archive pass is overdue, not optional.)

(Note: the TASK-0012 branch independently logged its own DECISION-0027/0028 — CORS/ALLOWED_ORIGINS and budget-burn semantics — under different numbers on its own branch. Those land separately when that work merges to `main`; this charter-adoption decision claimed 0027/0028 here because `main` had not yet recorded entries past DECISION-0026 at merge time. If both branches' numbering collides on merge, renumber on whichever side merges second and update this index.)

(Note: the same collision recurred 2026-09-26. The `claude/launch-planning-cram-4oyh2g` branch independently claimed DECISION-0068 through 0072 for five launch-planning decisions, not knowing `main` had already recorded its own DECISION-0068 (BYOQ parallel tables, TASK-0039 Phase 1) by the time this branch merged. Per the rule above, this branch — the later-merging side — renumbered its five decisions to DECISION-0069 through 0073 at merge time; main's DECISION-0068 is untouched. If you are reading an older copy of any of the five renumbered decisions (in a plan doc, a chat log, or a stale local checkout) under its original 0068-0072 number, this is why the number no longer matches — the content is unchanged, only the ID moved.)

<!-- INDEX_END -->

## DECISION-0126 — Seven-Day Free Trial With a Saved Card for Every Checkout, Parent-Pay Included; Price Locked at Signup, Cancel Ends Access Now, One-Day Grace, One Trial Per Email (Student or Payer), Terms Acknowledgment, Cardless Trial Retired

- **Date:** 2026-10-18
- **Decided by:** David Bloom (Product Owner), in session, answering the eight questions in `docs/product/SEVEN_DAY_CARD_TRIAL_PLAN_2026_10_18.md` §7. His answers are quoted after each item.
- **Context:** David asked for a 7-day free trial built to Stripe's save-the-card-then-charge-off-session method, with promo codes still working. The plan is a draft for Codex review; nothing is built.
- **Decision:**
  1. **Every purchase gets a 7-day trial, starting at checkout.** "Trial covers any purchase from the time of the purchase." The trial covers what was bought (single subject or bundle), not every subject.
  2. **Parent-pay gets the trial too.** "Parent-pay is also 7 day free trial." This **partly revises `DECISION-0090`**: the parent's card is saved, but only to make this one trial charge. It is still never written to `app.stripe_customers` against the student and never reused (no add-on, no later purchase).
  3. **The price is locked at signup.** If a promo code expires or runs out mid-trial, the payer still pays the discounted price they agreed to. "Yes".
  4. **Cancelling ends access immediately**, not at day 7, and no charge is made. "No" (to keeping access until day 7).
  5. **One-day grace after a failed charge.** Access continues for 1 day while the charge is retried; after that, access ends until payment succeeds. "1 day grace".
  6. **One trial per email.** "1 trial per email". The plan reads this as the student's email, so a parent paying for two children gets two trials and a student cannot get a second trial through a parent (see Open). No card-fingerprint check.
  7. **The $1 pilot and 50%-off codes get the trial too.** "Yes". A code that brings the total to $0 needs no trial.
  8. **The payer accepts the terms.** "whomever is paying". Read as: the consent to the future charge is collected from, and the trial emails go to, the person paying (the student on direct checkout, the parent on parent-pay).
- **Follow-ups, answered by David the same day (2026-10-18):**
  9. **The payer's email counts too.** "yes". One trial per email covers both the student's email and the payer's email. A parent who
     has started one trial pays straight away for a second student, and a student whose email already appears as a payer or student
     on any trial pays straight away.
  10. **A student can cancel a trial their parent started.** "yes". Access ends immediately (item 4) and the parent is told.
  11. **Terms acknowledgment at checkout, and emails to both.** "we should have an acknowledgment of Ts and Cs on checkout and email
      to both parent and student". Every trial checkout (direct and parent) requires an explicit Terms and Conditions acknowledgment
      that is stored with the order. On parent-pay, the trial emails (start confirmation, pre-charge reminder, failure, cancellation,
      conversion) go to **both** the parent and the student.
  12. **Retire the cardless trial.** "retire the old trial that needs no card". `start-trial` / `app.start_trial` (`trial_v1`,
      `TASK-0026`) are switched off. Existing `trial_v1` rows lapse on their own and still count as a used trial under item 6.
  13. **The student is always told when a parent pays, and the student's email is required for that.** "we need a way to notify the
      student that their parent paid for their access. We need the student's email". Parent-pay keeps requiring the student's email
      before the link is created (as today), and every parent-pay outcome emails the student, including the edge case where the
      parent's email has already had a trial and the parent pays straight away instead.
- **Still open:** no one is named to review the Terms wording against state auto-renewal and free-trial rules. Item 11 sets the
  acknowledgment mechanism, not the legal review of the text.
- **Execution:** documentation only. Implementation is `TASK-0077`, Hard-Gate. Each Production migration, deploy, secret, Stripe dashboard change and Lovable publish needs its own approval.

## DECISION-0125 — ASCII-Notation Cleanup Is Approved in Two Tiers, in LaTeX Everywhere, Converting Exponents in Units

- **Date:** 2026-10-14
- **Decided by:** David Bloom (Product Owner), in session, answering the four rulings requested in `TASK-0075`: "Scope: start with 383 then do the 1,664. Notation: latex everywhere. Units: I approve your recommendation."
- **Context:** the read-only inventory found 2,585 published rows with ASCII maths (`6*pi`, `sqrt(k/m)`, `e^2`, `9E_s`, `epsilon_0`), of which 1,664 are in scope: multiple-choice choices, rationales, stems and stimuli. Rubric text (`DECISION-0122`), FRQ stems and stimuli (the grader's prompt includes them) and version explanations (no student surface) are out.
- **Decision:**
  1. **Tier A:** convert the 383 answer-choice rows first. **Tier B:** then the remaining in-scope rows (1,664 in total).
  2. **Notation:** LaTeX everywhere, `\(…\)` inline and `\[…\]` display on its own line, as `DECISION-0121` item 5. Ordinary words that match a pattern (`gamma rays`, `delta` as a name) are left alone.
  3. **Units and powers of ten:** exponents are converted, e.g. `\mathrm{m/s^2}`; compound units keep their slash (`DECISION-0119`).
  4. **Process:** each batch is drafted by stating the exact span and its LaTeX, validated deterministically, independently QA'd, visually QA'd by the Product Owner, and written with the Phase 1 transaction pattern (exact before-text guards, versions pinned, taxonomy labels captured and restored, post-write verification). **Each Production write needs the Product Owner's explicit approval.**
  5. **Order for Tier B:** Physics C E&M, Physics C Mechanics, Physics 1, Physics 2, Precalculus, Chemistry, Statistics, Biology, with Calculus last.
- **Open:** the storage location of the Deep Dive lesson notes (not found by table name); bracket-free quotient choices (such as `4πR²/ρ`) that the regex inventory cannot find; FRQ stems and stimuli, until the grader-read risk is solved.
- **Execution:** documentation only in this decision. Work is tracked in `TASK-0075`.
## DECISION-0124 — Cross-Subject Duplicate Entries Are Allowed (Handoff §3.3): No Alias, No Normalisation; Figures May Be Shared Across Subjects

- **Date:** 2026-10-15
- **Decided by:** David Bloom (Product Owner), in session: "Cross subject duplicates are allowed."
- **Decision:** the three cross-subject near-duplicate entries in `LANE_A_GAPS_AND_LANE_B_EXECUTION_2026_10_11.md` §3.3 (vector arrows, Physics 1 1.1 and Physics C Mechanics 1.1; free-body diagram, Physics 1 2.2 and Physics C Mechanics 2.2; electric field map, Physics 2 10.3 and Physics C E&M 8.3) stay as authored in each subject. No `app.subject_reference_aliases` rows, no title or label normalisation. Where a figure serves both entries it may be shared through a `figure_uses` row per entry; the existing rule stands that a shared figure's `covers` must list every wording it carries.
- **Not decided here:** whether any other pair of cross-subject entries should be aliased; each would still need its own call.
- **Execution:** documentation only. No data change.

## DECISION-0123 — Figure Lane Rulings: `DECISION-0116` Ratified, `chem-mb-energy` Confirmed on Chemistry 3.5, the Unreviewed Lane A/B Figures Released, and the Chart-Shaped Entries Outside `kind='diagram'` Become the Next Lane

- **Date:** 2026-10-15
- **Decided by:** David Bloom (Product Owner), in session, answering the open items in `SESSION_CLOSE_2026_10_12_FIGURES_COMPLETE.md` §8 and `LANE_A_GAPS_AND_LANE_B_EXECUTION_2026_10_11.md` §7.
- **Decisions:**
  1. **`DECISION-0116` is approved as written**: when a published entry authors no `items[]`, the figure's own `labels` are the contract (route b), declared per use and gated in `verify.py`.
  2. **Chemistry 3.5 owns the Maxwell-Boltzmann distribution figure** (handoff §2e). The record already matches: `chem-mb-energy` is published on Chemistry 3.5 "Maxwell-Boltzmann distribution" and on 5.5, and `chem-mb-catalysis` is published on 5.11 "How a catalyst increases rate". The ruling named `chem-mb-analysis`, which is not a figure id and appears nowhere in the figures table; it is read as the `chem-mb-*` family. No data change.
  3. **The `field_map`, `circuit_symbols` and three `xy_series` gap figures are released without an expert review.** They pass every gate and were already serving; this records the Product Owner's acceptance of the standing "no human subject expert has reviewed any batch's illustrative values" risk for them. The risk is not retired for any other batch.
  4. **The chart-shaped entries outside `kind='diagram'` become the next figure lane** (the "~81" of `LANE_A_GAP_CLASSIFICATION_2026_10_11.md`, which answers the 2026-10-12 close's question). Entries that classification marks "not a figure" (section 7: bare formulas, conditions lists, prose) are out of scope, so the buildable set is smaller than 81. Order follows classification section 8.
- **Execution:** documentation only. Any Production figure load remains a Hard Gate with its own approval.
- **Still open from the same handoff:** section 3.3, the three cross-subject duplicate entries.

## DECISION-0122 — The Ten Rubric-Line LaTeX Edits Are Dropped: the Grader Reads Rubric Text, So Rubric Rows Keep Their Plain Text Unless a Verified Mitigation Exists

- **Date:** 2026-10-14
- **Decided by:** David Bloom (Product Owner), in session: "Go with option A", after the `TASK-0074` Gateway pilot.
- **Context:** `TASK-0073` drafted ten edits to rubric lines (`app.frq_criteria.learner_facing_text`) as stacked LaTeX. The production grader loads that column into the model prompt and persists the model's explanation, so an edit that is only presentation could change grading or leak markup. `TASK-0074` ran 53 valid grading calls (synthetic criteria, Development, through the AI Gateway to `gpt-5.4-mini`). Plain and LaTeX rubrics gave the same decision in 8 of 9 cells; one borderline cell differed (permutation p = 0.40) and one string leaked `\,\mathrm{...}`. Stray control characters appeared in both rubric forms. The pilot neither proves LaTeX safe nor harmful.
- **Decision:**
  1. The ten rubric-line edits are **dropped**. Rubric rows keep their current plain text.
  2. Text that the grader reads is not edited for presentation unless a mitigation has been verified: the smallest is to keep the grader-facing text byte-for-byte and store any typeset form separately, proven by a prompt byte-equality test (follow-up review, section 5).
  3. No claim is made that a generic LaTeX stripper preserves grading semantics; none is to be built without per-row semantic checks and a separately approved bounded verification.
  4. Phase 1 (21 MCQ rows, already applied) is unaffected, as multiple-choice scoring is deterministic and reads no rubric text.
- **Amends:** `DECISION-0121` item 8 (the pilot scope) by removing the rubric rows from it. `DECISION-0121`'s notation and rendering rules are otherwise unchanged.
- **Open:** whether to strip control characters from model-written strings before storing them (a separate, semantics-neutral hygiene item, needs its own approval); whether typeset rubric display is worth M1.
- **Execution:** documentation only. No Production write, no grading deployment. Evidence: `scripts/grader_latex_test/RESULTS_2026_10_14.md` and `FOLLOWUP_REVIEW_2026_10_14.md`.

## DECISION-0121 — Prose Quotients: Stack Only When Displayed, Keep the Slash Inside a Sentence; Author Forward, Backfill Only Where It Hurts, Pilot on Precalculus and Physics C

- **Date:** 2026-10-14
- **Decided by:** David Bloom (Product Owner), in session: first "I approve option 2 for Units 1–3 in chemistry and calculus AB only. This will give us enough material to determine if it is a good approach."
- **Context:** `DECISION-0119` says a compound quotient is stacked. Applied literally to question and teaching prose it stacks mid-sentence (`Let f(x) = (x²−x−6)/(x²−4). Which statement…`), which is chunky in running text. The session close of 2026-10-13 left this undecided and said to decide it before editing any rows.
- **Decision:**
  1. In question and teaching prose, a compound quotient that **stands alone on its own line** (a displayed expression) is stacked.
  2. A compound quotient **inside a sentence** keeps the slash, written with explicit grouping.
  3. The four `DECISION-0119` exceptions and the score slash are unchanged.
  4. This applies to prose only. Reference-pack formulas remain stacked, as `DECISION-0119` already requires.
  5. Notation for prose maths is LaTeX in **`\(…\)` (inline) and `\[…\]` (display)**, not `$…$`. About 70 published prose rows already contain `$` as currency (mostly AP Statistics), so `$…$` would swallow the words between two prices; a backslash never occurs in prose. Absolute value is written `\lvert x\rvert`, never `|x|`, because a bare pipe on consecutive lines is read as a table. Content is **authored, not transformed**: no regex or render-time rewrite.
  6. **Author forward:** all new question and teaching prose is authored with the display-only rule in LaTeX. This costs nothing extra and stops the problem growing.
  7. **Backfill only where it hurts:** math-heavy courses where a fraction is central to the question (Precalculus, Physics C, Calculus). Chemistry, Biology and Statistics are not backfilled unless a specific item is raised.
  8. The first backfill is a **pilot on `ap_precalculus` and `ap_physics_c_em` / `ap_physics_c_mechanics`**, drafted from a read-only Production read, QA'd independently, and visually QA'd by the Product Owner before anything widens. Production writes remain a Hard Gate.
- **Revision same day:** a read-only Production count found the pilot slice thin (Calc AB units 7–8: about 9 loose hits; Chemistry 8–9: none; Chemistry units 1–3: 25 of 197 items have a hit). The overall problem is about 1% of prose and concentrated in math-heavy courses. David then approved author-forward plus a targeted backfill and chose Precalculus and Physics C first ("I approve 1 and 3. Do precalculus and physics c first.").
- **Rulings on the pilot drafts (2026-10-14):** a field that is a single worked equation counts as standing alone and is stacked; Precalculus answer choices written as "the square root of 3" keep their wording; `1/(…)` reciprocals with a compound denominator are stacked; inner simple quotients (`√3/2`, `1/2`) stay as slashes inside a stacked fraction.
- **Amends:** `DECISION-0119` for prose surfaces only; that decision's rule is otherwise unchanged. Annotate-don't-rewrite applies.
- **Open:** whether display-only stacking reads well in the app is what the pilot tests. The pilot's Production size is unmeasured (see `TASK-0073`).
- **Execution:** documentation only. No Production write, no migration, no app change in this decision. Work is tracked in `TASK-0073`.

## DECISION-0120 — The Size Floor Binds on the Smallest Rendered Glyph, Not the Element

- **Date:** 2026-10-13
- **Decided by:** David Bloom (Product Owner), in session: "Document this size standard for future equations, graphs and other visuals", after confirming the enlarged mathematics in Production ("it looks much better").
- **Context:** `DECISION-0119`'s renderer shipped and rendered correctly, but the Product Owner's first reaction in Production was that the mathematics was too small to read. The cause was not the font size set on the container: KaTeX's inline style renders a fraction's numerator and denominator at `size3` (0.7×), so a 17px container produced ~12px digits, and raising the container could not fix it because the shrink is relative to it. The same question — what size does the student actually see — had never been asked of the figures.
- **Decision:**
  1. `VISUAL_IDENTITY.md`'s 16px floor is a **reading** rule and binds on the **smallest character a student must read to answer, measured in rendered pixels on screen**, not on the nominal size of the element containing it.
  2. **Mathematics** renders in display style (`\displaystyle`) at a 1.3em base, putting a fraction's digits at ~21px against 16px prose. A one-symbol label renders *compact* (inline style), because display style there produces a full-height operator with its index beneath it.
  3. **Figure and graph text** is authored in SVG user units and then scaled to its container; **both the authored size and the rendered size must clear the floor.**
  4. **Exempt**, as not content read to answer: chrome (breadcrumb 13px, counts 12px, eyebrows 12px, plate caption 10px); the subordinate characters of ordinary maths typography — subscripts, superscripts and limits, which sit near 0.7× by convention; and a figure's **tick labels**, ruled 2026-10-13 (*"only meaningful labels - axis titles and annotations, not ticks"*). A figure's title, axis titles, annotations, data labels and legend are in scope. Note that this clarifies the work rather than shrinking it: annotations are authored within 0.5px of ticks, so the binding minimum barely moves — what it removes is the layout pressure from the densest labels on the chart.
  5. Compliance is established by **measurement, not inspection**: render it, measure every element that paints a glyph excluding spacers, take the minimum; for an SVG multiply the authored `font-size` by rendered-width ÷ viewBox-width.
- **Measured state at the time of deciding:** mathematics now complies (fraction digits ~20.8px, subscripts 14.6px, symbol labels 17.6px against 16px prose). **The published figures do not.** Across 47 rendered figures and 526 labels: **99.8% render below 16px, 87.1% below 12px**, median 9.8px, smallest 8px — smaller than the mathematics that was rejected as unreadable. The authored scale in the app's `lib/figures/render.ts` is itself under the floor (`tick: 10.5`, `mark: 11`, `axis: 12`), so this is not an artefact of one layout width.
- **Scope and what is NOT decided:** the figure remediation is **open**, tracked as `TASK-0072`. It is not authorised here, and it is not a one-line change — enlarging type inside a fixed viewBox costs layout room, so it needs its own task, a pass over the affected families, and the three-gate figure verification (`property tests, eyes, model readers`) rather than a global constant bump. The 73 published figures stay as they are until then.
- **Execution:** documentation only. No Production write, no migration, no app change.


## DECISION-0119 — Equation Presentation: Compound Quotients Stack, Four Conventional Slashes Are Kept, and LaTeX Is Rendered or Not Shown

- **Date:** 2026-10-12
- **Decided by:** David Bloom (Product Owner), in session: "start a cramapple session focused on equation presentation. Equations with division should be stacked, not separated with /", then "use katex default fonts, write the rule first".
- **Context:** David raised this from a prototype screenshot. Investigation found the premise was half right and the halves live in different places. In `app.unit_reference_entries`, authors already write division as `\frac{}{}`: of 327 formula entries (325 published), 144 use `\frac` and exactly four contain a slash, all four legitimate (`t_{1/2}`, `d/7`, `b^{1/k}`, the unit `m/s`). There were **no** content violations. The defect was that the app never rendered any of it — `ReferencePane.jsx` shows formula bodies as plain monospace text, so 308 published formulas reach students as raw backslashes. Separately, question and teaching prose (stems, choices, rationales, FRQ criteria, explainers, briefs) carries **zero** LaTeX and writes real compound quotients inline, e.g. `(x²−4)/(x−2)` and `(214 - 190)/(6 - 5)`.
- **Decision:**
  1. A quotient whose numerator or denominator is a compound expression is **stacked**, never written inline with a slash.
  2. Four cases **keep** the slash, because stacking them reads as an error: compound units (`m/s`, `g/mol`, `mol/L`); Leibniz derivative notation (`dy/dx`); single-symbol quotients and simple reciprocals (`kq/r²`, `1/2`); and fractions inside an argument, subscript or exponent (`sin(7π/6)`, `t_{1/2}`, `b^{1/k}`).
  3. The slash in a score (`1 / 1`, `— / 1`) is not division and is untouched.
  4. Mathematics is authored as LaTeX, and **a surface that cannot render it may not show it**. Printing LaTeX source to a student is a defect, not a fallback.
  5. Rendered equations use **KaTeX in its own bundled faces**. David chose this against a side-by-side rendering of real published formulas; forcing STIX Two Math over KaTeX degrades its metrics, which are tuned for its own faces.
- **Amends:** `docs/new_design/VISUAL_IDENTITY.md` ("STIX Two Math is reserved for set mathematics"), annotated in place per the `docs/INDEX.md` annotate-don't-rewrite rule. STIX Two Math still owns mathematical characters set in prose, which KaTeX does not touch.
- **Evidence:** macro survey over the 308 published LaTeX formulas found 74 distinct macros, including `\begin`/`\end` environments, `\oint`, `\binom` and `\mathcal` — a hand-rolled subset renderer would have silently broken a long tail, which is why KaTeX rather than a bespoke renderer. Side-by-side rendering: `docs/product/EQUATION_PRESENTATION_RENDERING_COMPARISON_2026_10_12.html` (KaTeX rendered all sampled bodies with zero errors).
- **Scope and what is NOT decided:** this records the rule and the renderer choice only. **UPDATE 2026-10-13: the renderer shipped** — `ap-prep-blueprint` PR #16, merged as `2bb35c6` and Lovable-published (project `56cae479` `latest_commit_sha` matches). It covers three surfaces, not one: `LookUp` (reference pane + compact reference), `Entries` in `QuestionExperience.jsx`, and deep-dive note sections — plus the symbol-definition labels, which are LaTeX in their own right. All 321 distinct published formula bodies render cleanly, and that corpus ships as a test fixture. **CONFIRMED IN PRODUCTION 2026-10-13** by the Product Owner, signed in: the Lesson Notes "Formulas and rules" section renders the difference quotient and both limit forms of the derivative as stacked fractions. This is the first evidence that a student sees typeset mathematics rather than LaTeX source. Evidence URL: `https://app.cramapple.com/learn/ap-calculus-ab/2/2.1` (AP Calculus AB, Unit 2, Topic 2.1). The prose retrofit is **not** authorised here. Its true size, measured 2026-10-12: 7,214 prose rows contain a slash, but 969 are unit-like and 553 are Leibniz notation; the unambiguous violations are the **415 rows matching `(compound)/(compound)`** (1,044 with a parenthesised numerator over anything; an earlier count of 402/1,013 omitted `topic_explainers.weak_answer`). The per-surface target table is in `docs/handoffs/LATEX_ROLLOUT_AND_VISUAL_SIZE_SESSION_CLOSE_2026_10_13.md` — sampled and confirmed to be real rational functions. Earlier drafts of this session quoted table sizes (4,400 stems, 11,456 choices) as the scope, which overstated it by two orders of magnitude. The retrofit and needs its own task record, a notation decision for surfaces that carry no LaTeX today, and a Production hard gate.
- **Execution:** documentation only. No Production write, no migration, no app change in this decision.

## DECISION-0118 — Relevant Published Memory Hooks May Be Used in Hints, Post-Miss Feedback, and Student-Requested Targeted Help

- **Date:** 2026-10-12
- **Decided by:** David Bloom (Product Owner), in session: "All reference packs should be in production. Update the rule about using hooks and hints."
- **Context:** After trying the Chemistry and Calculus targeted-help prototypes, David approved replacing the hook-placement exclusion in `DECISION-0104` D5.
- **Decision:** Checked, published memory hooks may appear in hints, post-miss feedback, and "I don't get it" / "I'm stuck" help when their linked reference entry directly addresses the current question or missing concept. Include the expansion, applicable conditions, and caution; connect the hook to the concept or answer move. Omit irrelevant or unavailable hooks rather than inventing unchecked content.
- **Assistance:** Opening help before a graded Practice submission remains recorded assistance (`APPROVAL-0130`) and does not qualify that attempt as unassisted under `DECISION-0074`. Help opened after submission does not retroactively alter independence. Existing Practice answer-disclosure, unscored Worked Example, and ungraded BYOQ boundaries remain.
- **Supersedes:** `DECISION-0104` D5's exclusion of hooks from hints and post-miss feedback only. Reference linkage, content checking, inclusion, rights, and no-songs rules remain.
- **Verification:** Live read-only queries confirm all 1,083 published reference entries and 13 hooks match between Development and Production; Calculus BC inherits AB via its Production alias. No promotion was needed. Evidence: `docs/qa/REFERENCE_PACK_PARITY_AND_HOOK_HELP_POLICY_2026_10_12.md`.
- **Execution:** `APPROVAL-0164` records the rule amendment. This session updates documentation only; the new help template, agent, and Production releases require separate implementation/release scope.

## DECISION-0117 — The Current MCQ Answer May Be Preloaded Into Client Memory for Instant Feedback; Direct Database Reads Stay Closed and Server Persistence Remains Authoritative

- **Date:** 2026-10-11
- **Decided by:** David Bloom (Product Owner), in session: "preload answers for the current question
  and retain in memory." David explicitly stated that exposing an answer through browser tools is an
  accepted product risk for this study system.
- **Context:** submitting an MCQ waits for the remote grade/persist/read-back chain before the student
  sees whether the answer is correct. That delay is unnecessary when the current question's answer can
  be present locally before the click.
- **Decisions:**
  1. A signed-in student may receive the answer metadata for **exactly one current published MCQ** in
     their active session's exam pack.
  2. The ordinary multi-question serving page stays answer-free. The client clears the prior answer
     when the current item changes and retains the new answer in React memory only.
  3. Local feedback is responsive presentation, not authoritative grading. The existing server chain
     still owns attempt persistence, scoring and mastery; navigation waits for that write, and a failed
     write is surfaced with retry.
  4. Direct grants on answer-bearing tables and views remain revoked. This narrowly amends
     `DECISION-0089`'s statement that answers are delivered only after submission; it does not reopen
     the direct-read exposure that `TASK-0056` closed.
  5. A preload failure falls back to the existing server-only behavior rather than blocking practice.
- **Implementation:** `TASK-0071-CURRENT-MCQ-ANSWER-PRELOAD.md`.
- **Deployment:** not approved by this decision. Production function deploy and app publish remain a
  separate Hard Gate.

## DECISION-0116 — When a Published Entry Authors No `items[]`, the Figure's Own `labels` Are the Contract (Route b); Carried Per Use, Gated in `verify.py`

- **Date:** 2026-10-11
- **Decided by:** David Bloom (Product Owner), in session, asked as the handoff's open decision 1 of 5.
  Options put were (a) author the entry's `items[]` first through the reference-pack pipeline and its
  checkers, or (b) let the figure's own `labels` carry the parts. Answer: **(b)**.
- **Context:** `LANE_A_GAPS_AND_LANE_B_EXECUTION_2026_10_11.md` §3.2. Of roughly 24 chart-shaped
  entries outside `kind='diagram'`, **19 author no labelled parts at all.** The coverage gate (protocol
  §4a) checks a figure's `covers` against the entry's `items[]`, so for those entries it asserted
  nothing: `verify.py` printed a note and moved on. The handoff states the risk of (b) plainly — the
  `figures` table is a side door into the corpus that the reference-pack checkers do not watch — and
  asked for one ruling because it governs ~19 entries rather than the single residual plot that had
  already been built this way.
- **Decisions:**
  1. **Route (b).** When a published entry authors no `items[]`, the figure's own `labels` are that
     entry's contract. The entry does not have to be re-authored first.
  2. **It is declared, not assumed.** A use that carries the contract says so
     (`labels_carry_contract` with a `contract_note` naming the entry and why its body supports the
     labels). Silence is not route (b); an entry with no `items[]` and no declaration **fails**.
  3. **It is a property of the USE, not of the figure.** One figure serves several entries —
     `physcmech-xva-graphs` serves an entry with four authored parts and two formula entries with
     none — so a figure-level flag could only ever be right for one of them.
  4. **The carried contract is gated.** Every carried label must also be declared covered, so a
     figure cannot promise the student a part it does not claim to draw; and the existing
     canvas-overflow and overprint checks then assert it is really rendered, at all three layouts.
  5. **The two-reader gate (§4c) still applies, with the entry's body in the prompt.** That is the
     only thing standing where the reference-pack checkers do not, so it is not optional for a
     figure taking route (b).
- **Found on the first run.** The gate failed immediately against the one figure that had already
  taken route (b): the **published** AP Precalculus residual plot declared three labelled parts and
  an empty `covers`, so the coverage gate asserted nothing for it. Fixed in the same change.
- **Records:** `scripts/lane-a-pilot/verify.py`, `FIGURE_PRODUCTION_PROTOCOL.md` v1.5.
- **Still open from the same handoff:** §3.3 (alias, normalise or accept the three cross-subject
  duplicate entries), §4.4 (commission, license or schematic for the four AP Biology structures),
  and the standing item that no human subject expert has reviewed any batch's illustrative values.

## DECISION-0115 — A Figure's Renderer Family Is Data, Not Schema: `app.figure_families` Lookup Plus Foreign Key Replaces the Hard-Coded CHECK

- **Date:** 2026-10-11
- **Decided by:** David Bloom (Product Owner), in session. Asked why the family list was hard-coded, then: "do (c) - lookup table with FK".
- **Context:** `app.figures.family` was constrained by `figures_family_check`, a CHECK over the six
  families the AP Chemistry pilot happened to need. **No reason was ever recorded** — the constraint
  carries no comment, and neither `LANE_A_PILOT_RESULTS_2026_10_10.md`,
  `LANE_A_FIGURE_DISPLAY_DESIGN_2026_10_10.md`, `FIGURE_PRODUCTION_PROTOCOL.md` nor
  `architecture/VISUAL_STIMULUS_AND_RENDERING_SYSTEM.md` mentions it. It was written alongside
  `status in (...)` and the two `jsonb_typeof` checks as house style for an enumerable text column,
  which closed a list that was always going to grow. The cost surfaced in planning the next Lane A
  batch: seven new families, so the constraint would have turned a content load into a Hard Gate
  schema deploy, repeatedly.
- **Decisions:**
  1. **Keep the enforcement, change its shape.** `family` is a dispatch key, not a value — the
     renderer looks it up directly, so a figure whose family nobody implements does not draw a
     slightly wrong chart, it draws nothing, and a published row that passes RLS and renders nothing
     is exactly this project's recurring silent-absence failure. The guarantee worth keeping is
     "an unknown family fails loudly at insert, not quietly in a student's pane."
  2. **`app.figure_families` (`family_key` primary key, `title`, `summary`, `renderer_note`) plus
     `figures_family_fkey`,** replacing the CHECK. Adding a family is now a one-row insert in the
     same load as its figures; no migration, no Hard Gate schema deploy.
  3. **`on delete restrict`, `on update cascade`.** A family in use cannot be deleted, so the lookup
     cannot be emptied from under published figures; renaming propagates to the figure rows, which is
     the only safe way to rename a key those rows already carry — the renderers still have to be
     renamed to match.
  4. **Locked down like `app.subject_reference_aliases`:** RLS enabled and forced, no policies, no
     `anon`/`authenticated` grants. Nothing student-facing reads it — the figure views already expose
     `family` as text — and foreign-key checks are run by the system rather than under RLS, so
     `service_role` still inserts figures without any select grant.
  5. **Record what neither form can promise.** Enforcement of the *name* lives in the database; the
     drawing lives in the app's TypeScript and in `scripts/lane-a-pilot/render.py`. Seeding a family
     whose renderer does not exist still fails at render time, so `renderer_note` records where each
     family is implemented, and a figure's mandatory `alt` (≥ 80 characters) remains the fallback when
     the drawing cannot arrive.
- **Consequences:** `FIGURE_PRODUCTION_PROTOCOL.md` §9's correction and
  `LANE_A_REMAINING_ENTRIES_CLASSIFICATION_2026_10_11.md` §6 are revised: the remaining Lane A batch
  is **a content load again**, not a schema change. Applied to Development and then to
  **Production the same day (`APPROVAL-0156`)**, verified in both; the two environments' column,
  constraint and seed signatures hash identically (`e549ee74…`).
- **Rollback:** re-add the CHECK over the families then in use and drop the foreign key; the lookup
  table can be left in place or dropped once nothing references it.

## DECISION-0113 — AP Chemistry Units 5–9 Escalations: Owner/Tag Fixes, Qualifier-Preserving Re-Extraction, One Drop, Unit 8 Duplicates Retired

- **Date:** 2026-10-10
- **Decided by:** David Bloom (Product Owner), in session, on Claude's recommendations: "do all of your recommendations … yes, do those too."
- **Decisions:**
  1. Owner/tag escalations go through a fresh extraction with the corrected owner and tags pinned:
     - Kp/Qp → 7.3 `[7.3, 7.4, 7.7]`
     - Kb → 8.3 `[8.3]`
     - Buffer solution → 8.4
     - Maxwell–Boltzmann → 5.5 `[5.5]`
     - Henderson–Hasselbalch → owner **8.4**, `[8.4, 8.9]`, by the first-requiring-topic rule (8.4.A.2). The models split between 8.9 and 8.4.
  2. Wording escalations go through a fresh extraction under a new general rule: preserve every CED qualifier and scope limit. Applies to collision requirements, catalysis types, titration curve, weak base + strong acid (CED arrows verified as ⇄ on the rendered page) and entropy/dispersal.
  3. When the only remaining objection is a topic tag that the checkers corrected from the CED, the same extracted content is re-checked with corrected tags. It is not re-extracted, so accepted content is not regenerated. This applied to collision → `[5.5]`, titration curve → `[8.5]` and H–H.
  4. Unit 6 "Direction of thermal energy flow" is dropped (covered by the 6.1 entries). Catalysis types stays out after failing round 3 on content.
  5. The Unit 8 duplicates are retired: standalone "pKa" and "pKw, pH and pOH at 25°C". Their content remains in the "Ka" and "Kw" entries.
- **Consequences:** 9 rows were added to Development and Production. Unit 8 went to Production complete (32 entries). Topic 5.5 now has entries. Batch: `scripts/content-seed/task0067-chem-escalations-r3-2026-10-10/`. Recorded under `APPROVAL-0148`.

## DECISION-0112 — AP Chemistry Unit 1 Reference Escalations: Both Accepted (1.8 Bond Likelihood, 1.7 Tools for Periodic Trends)

- **Date:** 2026-10-10
- **Decided by:** David Bloom (Product Owner), in session: "Accept the escalations."
- **Context:** batch `scripts/content-seed/task0067-chem-u1-2026-10-09/`. Both entries were rejected in two rounds, so under the Reference Pack protocol they went to the Product Owner.
  - `ap_chemistry-u1-r2-003` "Bond likelihood from valence electrons and nuclei" (1.8). GPT-6 Sol rejected it in both rounds: CED 1.8.A.1 says "The likelihood that two elements will form a chemical bond…", but the entry says "Whether two elements will form…" and has no caution. Claude had recommended rejecting it.
  - `ap_chemistry-u1-r2-004` "Tools for explaining periodic trends" (1.7). Both checkers accepted it. The Haiku veto rejected it twice because each tool is first introduced in 1.5. Claude had recommended accepting it with 1.7 as owner.
- **Decision:** both entries are accepted as extracted, with no hand edits, consistent with the no-edit rule. 1.7 stays the owner of the periodic-trends list.
- **Consequences:**
  - Both entries were loaded to Development and Production via `load.py --po-accept po_accept_ap_chemistry_u1.json`. Their `source_note` carries `po-override=DECISION-0112…`, and the SQL file is `out/load_ap_chemistry_u1_po_accept.sql`.
  - AP Chemistry Unit 1 now has 26 entries + 1 hook in both environments.
  - Known wording gap: the 1.8 entry states the CED's likelihood claim categorically. A later stateless re-extraction can replace it through the normal pipeline.

## DECISION-0111 — Student Photo Retention for Hand-Drawn Responses: Kept While the Account Exists, Bytes Redacted 24 Months After the Attempt or on Deletion/Erasure, Audit Row and Digest Kept (Plan D4)

- **Date:** 2026-10-09
- **Decided by:** David Bloom (Product Owner), in session: "I approve D1, D4."
- **Context:** `docs/product/HAND_DRAWN_RESPONSES_ALL_FRQS_PLAN_2026_10_09.md` §4 and D4. `app.response_attachments` is immutable by trigger (TASK-0025, for grading-dispute and audit integrity; blocks `service_role` too), while the privacy policy (§11, §13) promises retention "as long as needed" and deletion requests "subject to applicable law and operational constraints". No image has ever been deleted or redacted because none has ever been stored (0 rows in Production as of this date).
- **Decision:** Student response photos are kept while the account exists. Image bytes (original and any derived copy) are **redacted**, not deleted, 24 months after the attempt, or earlier on account deletion or an erasure request handled by support. The `response_attachments` row, SHA-256 digest, dimensions, and all grading records survive redaction. Redaction is the only write the immutability trigger will permit, through one service-role function; a pg_cron sweep applies the age rule. Unbound uploads keep the existing bucket sweep. Research/benchmark use of student photos stays outside this path (deidentified, reviewed, separately consented corpora only).
- **Still recommended, not blocking:** a counsel read of the policy's retention section against this rule before Phase 1 reaches Production.
- **Consequences:** schema additions `response_attachments.redacted_at` and the redaction function are in the Phase 1 build list; `APPROVAL-0142` records the approval.

## DECISION-0110 — A Photographed FRQ Answer Is Graded Only After the Student Confirms the Transcript; the Confirmation Screen Asks the Student to Add Anything Missing So Cramapple Can Help (Plan D2, Conditioned)

- **Date:** 2026-10-09
- **Decided by:** David Bloom (Product Owner), in session: "D2 should have a prompt for the student to confirm or add missing content so Cramapple can help. With that condition I approve D2."
- **Context:** Plan §2 step 4 and §5. The plan's safety argument is that the grader works only on text the student has confirmed, never on an unverified vision read (the Engine 4 finding of 2026-08-18: vision reads cannot be trusted as the decider). BYOQ (`TASK-0068`) proved the read-then-confirm loop for questions.
- **Decision:**
  1. A response that carries a photo is never submitted for grading until the student has confirmed the per-part transcript. There is no "grade the photo directly" path.
  2. **Condition:** the confirmation screen actively invites completion, not only agreement. Each `[unreadable]` span is an inline prompt to type what was written; a part with no transcribed answer says so and offers a field; the screen ends with an explicit "anything we missed? add it so we can score your whole answer and show you what to fix" prompt. The framing is help, not policing.
  3. Text added at review is stored distinctly (`student_added` spans in `response_parts`) so audits and the transcript-fidelity metric can separate what was photographed from what was typed afterwards.
- **Unchanged:** `DECISION-0057`/`DECISION-0068` (BYOQ stays a separate, never-graded path); the Engine 4 DR-1 gates for any automated judgement of image-only criteria.
- **Consequences:** `attempt-response` gains `propose_transcript`/`confirm_transcript`; `submit_response` refuses a response with a current attachment and no confirmed transcript; the Practice FRQ review screen is specified in the plan; `APPROVAL-0142`.

## DECISION-0109 — Same-Device Camera Capture for Hand-Drawn Responses When the Student Is Already on a Phone; QR Remains the Desktop Handoff (Narrow Amendment to DECISION-0051; Plan D1)

- **Date:** 2026-10-09
- **Decided by:** David Bloom (Product Owner), in session: "I approve D1, D4."
- **Context:** `DECISION-0051`/`APPROVAL-0046` (2026-08-19) made QR handoff Engine 4's sole capture path, rejecting a direct-upload fallback because laptop-camera capture is awkward. That reasoning addressed a student at a desktop. BYOQ (`TASK-0039`/`TASK-0068`) later shipped an "I'm on my phone — use this device" path for the case the earlier decision did not consider. Plan §2 step 2 proposes the same for responses.
- **Decision:** From a desktop or laptop, capture is QR handoff to a phone, unchanged. When the student's primary device is a phone or tablet, the capture control uses that device's camera directly. Both paths land in the same `capture-pairing` token and `submit_capture` flow (validate, strip metadata, quality-check, bind); the token's `access_path` records which path was used. No laptop-camera or desktop file-upload path is added.
- **Unchanged:** everything else in `DECISION-0051` (generic retake copy for image-quality failures, technical failures logged not blamed, image preserved and bound before submit).
- **Consequences:** `capture-pairing` same-device branch and the shared capture component are in the Phase 1 build list; `APPROVAL-0142`.

## DECISION-0108 — BYOQ Photo Extraction With Student Confirmation Replaces Typed Transcription and TASK-0039 Phase 3: Photos Only, Subject/Unit From Context, OpenAI Build-Measure-Switch, Student Answer Marks Stored, Phone-Side Review, No Policy Change, No Spend Cap; TASK-0068 Opened

- **Date:** 2026-10-08
- **Decided by:** David Bloom (Product Owner), in session, answering the eleven questions in `docs/product/BYOQ_ATTACHMENT_EXTRACTION_PLAN_CRITIQUE_2026_10_08.md` and then: "option 2 approved, go ahead with slice 0". On motivation: students "loved the idea but pretty obviously would not invest the time needed to accurately enter all the information. And in many cases, they cannot enter mathematic or scientific equations with a regular QWERTY keyboard."
- **Context:** `TASK-0039` shipped BYOQ Phases 1–2 on 2026-09-28 (`DECISION-0084`) with a deliberate no-OCR default: photograph, then type the transcription. Production holds three items, all internal tests, two with a photo and no typed stem. Codex drafted a Hard-Gate extraction plan (v1, PR #387) proposing a ten-subject vendor bake-off, subject/unit/topic inference from the image, staging tables, PDFs, and worksheet splitting. A source-checked critique found that OpenAI already processes student photos for the capture-quality check with `store: false`, that the live privacy policy already covers extracted content, that 2,170 published MCQs and 583 FRQs give a rights-clean benchmark with free ground truth, that the App has no formula renderer, and that the phone leg holds only a pairing capability. The plan was re-cut as v2 (`docs/product/BYOQ_PHOTO_EXTRACTION_PLAN_V2_2026_10_08.md`, PR #391).
- **Decision:**
  1. **Direction is firm.** A photographed question is read by a model and the student verifies; typing is the fallback and the editor, never the default after a photo. Production usage to date is disregarded as internal testing.
  2. **Vendor:** build-measure-switch on OpenAI, reusing the `capture-quality-check.ts` call pattern (`store: false`, strict JSON schema, timeout, cost reservation). No offline bake-off before the first build.
  3. **Privacy policy: no change.** The live policy is comprehensive and covers BYOQ. There is no deletion promise and none will be added; `store: false` is an engineering default, not a promise to students. The intake consent notice keeps its existing policy link.
  4. **Taxonomy:** subject and unit come from context (signed-in: active subject and saved unit position; anonymous: the intake selects, prefilled from `?subject=`). The model parses the question, detects MCQ vs FRQ, extracts stem and choices, and proposes a topic from the known unit's list (`unsure` allowed). The model never infers subject or unit.
  5. **Inputs:** photos only in v1 (multi-page photo capture already shipped). PDFs later only if usage warrants.
  6. **Review on the same device through the QR code:** capture and review on the phone; the QR remains the desktop handoff. This needs one new screen (`ByoqReview`, assembled from existing controls, shared with the desktop) and three capability-scoped ops bound to the pairing's item, with a one-time pairing-window extension (v2 §5.3). Approved with that cost known.
  7. **Student answer marks are stored.** Marks on the page that are not the question (own work, a circled option, a printed answer line) go to a new `captured_work` field, never into stem or choices; stored but not displayed in v1 (the practice screen already shows the photo). A printed answer key is dropped with a warning. The regex leak gate and the DB `ready` CHECK are unchanged. `DECISION-0057` is unchanged: nothing is graded, nothing is shown as correct.
  8. **Schema:** single photo, proposal stored on the draft `byoq_items` row (`extraction` jsonb + `captured_work` text). No staging tables, no new RLS.
  9. **Supersession:** this work supersedes all remaining `TASK-0039` work. Phases 1–2 close as Done; Phase 3 (worksheets) and `BYOQ_WORKSHEET_PARSING_DESIGN.md`'s open decisions are superseded, not carried forward.
  10. **Pilot testers:** Micah and Orly (plus David), named Production pilot behind a config flag.
  11. **Spend:** no product cap on extraction ("we will see how it goes"); a high technical daily breaker that pages David and falls back to typing is kept.
  12. **Per-field editability is critical, including a prompt to confirm the content is correct.** Every proposed field is editable; "Yes, this is my question" is the only path to `ready`; no per-field confidence bands in v1.
- **Unchanged:** `DECISION-0057` (never graded, never Open Hand, never a canonical answer); `DECISION-0077` (identity-agnostic); `DECISION-0084` launch defaults (quotas, 30-day anonymous purge, private-until-promoted); the Hard Gates on migration, deployment, secrets, and Production.
- **Consequences:** `APPROVAL-0139` records Gate A; `TASK-0068` opened; `TASK-0039` → Done; v1 plan and the worksheet design annotated superseded; one-pager D9 amended. Gate B (Development build) is a separate approval.

## DECISION-0107 — Memory Hooks Pilot Rulings: a CED-Named Hook Overrides the Veto's Order Objection (SOCS Loaded); 1.13 Owns "Scope of Conclusions"; the Own-Family Veto Moves from Opus 5.5 to Haiku 5.5 on Cost

- **Date:** 2026-10-09
- **Numbering note:** first drafted as DECISION-0106; renumbered to 0107 before merge because open PR #391 (BYOQ photo extraction plan v2, 2026-10-08) had reserved DECISION-0106 for its approval; that PR finally merged as DECISION-0108 / APPROVAL-0139, so 0106 is unused and 0107 is this record.
- **Decided by:** David Bloom (Product Owner): "1. SOCS is verified by the CED. CED wins. 2. 1.13. 3. We need to find a less expensive option. Opus is one of the most expensive models out there. What about Sol-6?"
- **Context:** `TASK-0067`/`TASK-0066` Phase B pilot (`scripts/content-seed/task0067-reference-pilot-2026-10-09/README.md`). Both checkers accepted SOCS because the Statistics CED names it; the Opus 5.5 veto rejected it twice because the extracted entry's items follow the CED sentence order rather than the SOCS order. GPT-6 Sol held in two rounds that 1.10 first requires the scope-of-conclusions distinction. The veto was 56% of the $20.29 batch.
- **Decision:**
  1. When the CED itself names a memory hook, the hook is admissible and the veto's entry-order objection does not block it. SOCS is loaded (Development) under a recorded Product Owner override; the rule applies to future batches.
  2. Statistics 1.13 is the owner of "Scope of conclusions from an experiment"; the entry is loaded (Development).
  3. The own-family veto uses `anthropic/claude-haiku-5.5`. GPT-6 Sol stays a checker: the veto must share the extractor's family (reject-only audit of its own family's output), so it cannot be an OpenAI model while Sonnet 5.5 extracts. Haiku 5.5 must pass the structured-output smoke test before its first batch.
- **Unchanged:** the no-hand-edit rule (overrides are acceptance decisions recorded in provenance, never content edits); two non-author checker families; every Production apply and publish remains a Hard Gate.
- **Consequences:** Development holds 102 entries and 3 hooks; Phase C builds against that payload; Unit 2+ batches run with the cheaper veto.

## DECISION-0105 — Unit Reference Content Is the Companion Content for Memory Hooks: TASK-0067 Opened, Hooks Require a Reference Entry (Amends DECISION-0104 D3), Fact-Pack Extraction First, Diagrams Text-Only Until TASK-0006 Renders

- **Date:** 2026-10-08
- **Decided by:** David Bloom (Product Owner): "Task 0066 only works if we have the formula, diagrams, lists, etc to accompany them", then "Approve R1-R4 as recommended and open TASK-0067".
- **Context:** Checked after `DECISION-0104`: no structured formulas, vocabulary, lists, or topic-level diagrams exist as student content (no such tables; the only `formula` column is on `app.provenance_claims`; diagrams are item-level prompt visuals; the protocol's unit reference surface is scoped but unbuilt; the parsed 1.7 pilot packet already extracts `factPack.formulas` and `factPack.concepts`). `docs/tasks/TASK-0067-UNIT-REFERENCE-CONTENT.md` §Why.
- **Decision:**
  1. **R1:** `TASK-0067` is opened and runs together with `TASK-0066` Phase A: one Development migration, two tables (`app.unit_reference_entries`, `app.topic_memory_hooks`), hooks keyed to entries.
  2. **R2:** `DECISION-0104` D3 is amended: a memory hook requires a `reference_entry_id` and inherits subject, owner topic, `topic_codes[]`, and unit from the entry; the hook's own `topic_codes[]` is dropped. A hook with nothing to point at cannot exist.
  3. **R3:** Reference entries are extracted first from the approved CED fact packs with provenance per row (protocol Phase 0 rules), then verified by two checker families under protocol v0.6 §0 against the CED PDF, the owner topic, and the CED-required inclusion rule.
  4. **R4:** Diagram entries ship as labelled parts in text until `TASK-0006`'s governed-diagram lane renders them; no new rendering path.
- **Unchanged:** D1, D2, D4–D7 of `DECISION-0104`; INV-3; the pilot units (AP Statistics Unit 1, AP Chemistry Unit 4); every Production apply, Production publish, and Lovable publish stays a Hard Gate.
- **Consequences:** `TASK-0066` is unblocked and sequenced with `TASK-0067`; `APPROVAL-0137` records the scope approval; the Open Hand reference pane's vocabulary section gains a structured source once the pilot lands.

## DECISION-0104 — Memory Hooks Approved as Proposed (D1–D7): Topic-Owned Grain, CED Point-Bearing Inclusion Rule, Option B Table, Songs Out of v1, Three Surfaces, Stats Unit 1 + Chem Unit 4 Pilot; Amended to Include Diagram Parts

> **D5 AMENDMENT, 2026-10-12:** `DECISION-0118` / `APPROVAL-0164` supersedes the hint/post-miss
> exclusion below. Relevant published hooks are now allowed in hints, post-miss feedback, and
> student-requested targeted help, with the existing assistance and answer-disclosure rules.
> The original decision remains below as its dated record.

- **Date:** 2026-10-08
- **Decided by:** David Bloom (Product Owner): "Approve D1-D7 as recommended and open the task", and, relaying Micah Bloom, "Micah was also interested in memory hooks for formulas and parts of diagrams. Why not include those?"
- **Context:** `docs/product/MEMORY_HOOKS_PROPOSAL_2026_10_08.md` (PR #385) scoped Micah's idea of connecting important formulas and lists to mnemonics, acronyms, phrases and songs. It resolved the "memory aid" grain left OPEN in `COURSE_HOMEWORK_CONSOLIDATION_PLAN.md` §3 and derived an inclusion rule from the finding that the KPCOFGS example is not in the AP Biology CED.
- **Decision:**
  1. **D1 Grain:** topic-owned with `topic_codes[]` and unit roll-up; no skill grain.
  2. **D2 Inclusion rule:** a hook is admissible only for an ordered sequence, list, formula structure, sign or direction convention, **or the labelled parts of a diagram** that a CED learning objective or scoring guideline requires. The hook is for recall; the answer is written in CED language, and a `caution` says so when they differ.
  3. **D3 Data model:** Option B, a new `app.topic_memory_hooks` table with a public view and `get_topic_point_guides` returning `memoryHooks[]`.
  4. **D4 Songs:** out of v1; no lyrics ever, no audio pipeline.
  5. **D5 Surfaces:** Deep Dive "Remember it" block, unit-reference list, Open Hand reference pane; not hints and not post-miss feedback. `diagram_parts` hooks render only through the existing visual-stimulus path.
  6. **D6 Pilot:** AP Statistics Unit 1 and AP Chemistry Unit 4, at most 8 hooks, before any wider survey.
  7. **D7 Priority:** not launch gating; the schema lands on the key `TASK-0054` settles.
- **Amendment (same day):** formulas were already in scope through the `acrostic` and `formula_sentence` kinds; diagram parts are added as kind `diagram_parts` with a nullable `visual_asset_ref` to an existing visual-stimulus asset (`TASK-0006`). Checkers gain a fifth check for it.
- **Unchanged:** INV-3; the generate-and-select authoring method (protocol v0.6 §0); every Production apply, publish, and Lovable publish stays a Hard Gate.
- **Consequences:** `TASK-0066` opened; `APPROVAL-0136` records the scope approval.

## DECISION-0103 — Student Hub Slice 1 Contracts: Save on Change, Unit-Wide Study Scope, "Asked and Scored" Door Line, Revisit Queue Removed, No Dismissible First-Use Panel

- **Date:** 2026-10-08
- **Decided by:** David Bloom (Product Owner), answering §5 of `docs/qa/QA_STUDENT_HUB_CONSOLIDATED_PLAN_2026_10_08.md` (PR #381): "go with your recommendation" on 1, 2, 4 and 5; "go with 'asked and scored'" on 3.
- **Context:** Sol's challenge QA (H1–H15) and Fable's independent assessment (N1–N8) were consolidated into one plan at Sol's request. Five questions where the two assessors differed, or where the plan departed from the unified recommendation, were put to the owner. Slice 1 (truthfulness and route reliability) depends on the first two.
- **Decision:**
  1. **Saved vs draft lesson: save on change.** Picking a unit or topic on the hub persists at once with an inline "Saved"; the Confirm / "Set my position" button goes; every door reads the saved lesson. The mutation is keyed to the latest pick. Unit-only saves send `topicCode: null`.
  2. **Unit-only position is a valid study scope.** The doors box reads "Studying: Unit N · pick a topic to narrow it"; Learn and Practice open unit-wide and say so on the plate; Notes lists the unit's topics. No door silently opens the unit's first topic under a unit heading.
  3. **Learn door line stays "See how a test-style question is asked and scored."** The unified recommendation §3.1 sub-line stands; the assessors' alternatives without "scored" are withdrawn.
  4. **"Worth revisiting" is removed from Stage B** until a real revisit list exists; no empty, unavailable or error states are built for it.
  5. **The first-use explanation is not dismissible.** It is shown on Stage A and absent on Stage B; no "How Cramapple works" reopen control.
- **Unchanged:** `DECISION-0100` and its amendment; the unified recommendation's design model; the deferred saved-notes store; the "Open Hand" plate masthead.
- **Consequences:** slice 1 of the consolidated plan can be scoped; the Fable record's §6.2 door line is annotated as superseded.

## DECISION-0102 — Items Made by Generate-and-Select (§0) Need No Human Review Before Load

- **Date:** 2026-10-07
- **Decided by:** David Bloom (Product Owner): "Remove the human-reviewed requirement for questions made with this protocol."
- **Context:** Protocol v0.6 §0.3 rule 6 (DECISION-0099) required a human spot-check per subject before the first load, and §0.5 asked a human to confirm judge-dispute adjudications.
  - Evidence: method test 1/23 defective vs legacy 4/24; lever re-judge 0/24; Biology Unit 1 seed pilot 0 defects in 42 blind-judged items, planted 4/4 caught.
- **Decision:**
  1. Items made by generate-and-select need no human review or spot-check before loading.
  2. Human confirmation of dispute adjudications is optional.
  3. The quality gate is the four non-author checker families, the planted-defect controls and the deterministic key recompute.
- **Unchanged:** a Production load is still a Hard-Gate approval recorded before `review_status` is set; FRQs and existing content still follow §4–§6.
- **Supersedes:** the human spot-check line in DECISION-0099 and §0.3 rule 6.

## DECISION-0101 — Seeds and Variants (§0): Difficulty Is Not an Author Target; Skills Targeted at Practice Level; Variants Inherit the Seed's Labels

- **Date:** 2026-10-07
- **Decided by:** David Bloom (Product Owner), in session. Approved recommendations 1 and 2 from the Biology Unit 1 seed pilot.
- **Evidence:** `scripts/content-seed/task0065-seed-pilot-bio-u1-2026-10-07/RESULTS.md` (PR #370).
  - Seeds written to a "Hard" brief were all voted Medium (0/7 Hard).
  - The target band was hit 10/21 times.
  - The seed's skill practice matched its target 17/21 times; the exact sub-skill matched 14/21.
  - Re-voted variants landed on a different sub-skill from their seed 22/61 times, although they kept the same reasoning.
- **Decision:**
  1. **Difficulty is not an author target** in §0 seed generation. The four-family difficulty vote on each seed is kept only as a `provisional_model` label until it is recalibrated from real attempt data.
  2. **Skills are targeted at the practice level.** A plan slot names a practice and may narrow it to the skills a multiple-choice item can exercise. The seed's sub-skill counts as validated at 3 or more matching votes.
  3. **Variants inherit the seed's skill and difficulty labels**; they are not re-voted. This extends DECISION-0096 (variants inherit difficulty) to skills. The variant prompt keeps the seed's validated sub-skill, or else its practice.
- **Implementation:** `scripts/vercel-gateway-check/teaching_pipeline/seed_pipeline.mjs`; protocol §0.8.
- **Not decided:**
  - a structural definition of Hard;
  - loading the pilot items, which is Hard-Gate (since done: APPROVAL-0131, 2026-10-07);
  - confirmation of the 15 provisional adjudications.

## DECISION-0100 — Learning Through a Worked (Scored) Example Is a Recommended, Exam-Directed Path on the Student Hub, Never a Required Step; Four Equal Entry Points (Worked Example, Practice, Deep-Dive Notes, Bring a Question)

**Date:** 2026-10-07
**Decided By:** David Bloom (verbal, in the `claude/ux-evaluation-session-flp1xj` session, recorded by Claude)
**Related:** `docs/product/NEW_STUDENT_FIRST_SESSION_UX_ASSESSMENT_2026_10_07.md` (§0b, R1, R3, K1, K7, K8, K23, K24), `TASK-0048`, `TASK-0052`, `DECISION-0097`, `DECISION-0075` D2/D17, open PR #365
**Area:** Product / student hub / first-session design

### Context

The 2026-10-07 first-session UX assessment found that the worked-example → practice loop exists only
in routing and that no screen states why a student would read an answered question. Its first draft
proposed a numbered four-step strip (position → worked example → practice → recommendation) that
would have presented the worked example as step 2 of a sequence. David's direction, verbatim in
substance:

> A student can learn through a worked example, and doing so is important because that is how they
> will be questioned on tests and the exam. It is highly directed learning toward tests and the exam,
> not toward general knowledge. But it is not required. Students might want to skip a worked example
> and practice on their own, or export the deep dives and use them as supplemental notes from class.
> They might upload their own homework question, which we will help them understand but not answer
> for them.

### Decision

1. **The worked example is a primary, recommended way to learn a topic, and its purpose is exam
   scoring.** The student-facing product must say so in one sentence (working copy: "Cramapple
   teaches each topic the way the exam asks and scores it"). It is directed at tests and the exam,
   not at general knowledge.
2. **It is never required.** No hub stage, plate, or recommendation may gate practice, notes, or
   bringing a question on having viewed a worked example. The numbered step-strip concept is
   withdrawn.
3. **Four equal entry points on the student hub, for the student's current topic:** the worked
   (scored) example, listed first and marked recommended with its reason; practice; deep dives as
   saveable, exportable notes; and bring-a-question. Each is one tap from the hub at every stage.
4. **Deep dives are exportable** as supplemental notes (save with confirmation, export, a place on the
   hub where saved notes live). Notes never count as evidence or score.
5. **Bring-a-question's promise is stated in the door:** Cramapple helps the student understand their
   own homework question and does not answer it for them. One name for this door everywhere.
6. **Vocabulary stays open.** "Worked example" is not confirmed; the assessment lists candidates and
   recommends "scored example" / "See one scored". The masthead term "Open Hand" is unaffected.

### Amendment 2026-10-07 (same day, David Bloom, answering the unified recommendation's §6)

1. The recommended door is named **"Learn from a question"**.
2. On the **first practice question of a session, aids (hint, lesson notes) are free and ungated**; the attempt is still recorded as guided when an aid is opened, so `DECISION-0074` is unaffected.
3. The **calendar hint** on the lesson question is dropped.
4. Both parallel assessments (Claude's in `docs/product/`, Sol's in `docs/qa/`, PR #365) merge as evidence records carrying a STATUS line that points to `docs/product/STUDENT_HUB_UNIFIED_RECOMMENDATION_2026_10_07.md`, which is the single recommendation.
5. The first-session pause card appears after **three** graded attempts and asks **"Want to keep going?"**, with continuing as the primary action and the hub as the alternative: three is enough for Cramapple to start recommending, every further answer sharpens it, and the student may want to keep going.

### Consequences

- The assessment's R1, R3, K1, K7 and K8 are revised in place; K23 (notes export) and K24
  (bring-a-question door) are added. No code, schema or Production change is made by this decision.
- `DECISION-0075` D2 (two plate templates, Open Hand unscored / Practice scored) and D17 (Open Hand as a
  sanctioned full-disclosure teaching method) are unchanged; this decision governs *how the hub offers*
  those templates, not what they are.
- `TASK-0052`'s "teaching-first is the default entry" wording (its line "Home's start practice always
  starts with Open Hand") now means *recommended first*, not *only path*: the hub must also expose
  practice, notes and bring-a-question directly.
- Open PR #365 (Codex, same-day parallel assessment) proposes an explicit "worked question → own
  attempt → focused feedback sequence"; where that reads as a required sequence it is superseded by
  this decision, and the two documents are to be reconciled by the Product Owner before merge.

## DECISION-0099 — Generate-and-Select Is the Default Method for New MCQs (Required for Open Hand Teaching Items)

**Date:** 2026-10-07  
**Decided By:** David Bloom  
**Related:** `docs/research/CONTENT_AUTHORING_AND_QA_PROTOCOL.md` v0.6 §0, `TASK-0065`, `APPROVAL-0127`, `APPROVAL-0129`, `DECISION-0093`, `DECISION-0095`

### Context

Repeatedly reviewed teaching questions kept failing newly applied checks. On 2026-10-06 David asked for "a way to
add questions without needing to edit them using at least 4 models and multiple sessions". The resulting pipeline
was piloted on Biology (20/21 accepted after two source fixes). It was then compared blind against the legacy
method on 24 topics, judged by three held-out model families against the CED PDF text, with planted defects
(4/4 caught):
- **Defective items:** legacy 4/24, generate-and-select 1/23, live legacy items 3/24.
- **Judge disputes:** legacy 6/24, generate-and-select 0/23.
- **Cost:** generate-and-select is about 4× legacy per defect-free item.

David (2026-10-07): "the new approach has fewer errors … and fewer disputes (eg higher confidence)"; "update the
content creation protocol with the improved new approach".

### Decision

1. **New MCQs are made by generate-and-select (protocol §0).** It is **required** for Open Hand teaching items
   and is the default for new scored MCQs. Scored MCQs still need serving labels and the Phase 6 gate. FRQs are
   not covered.
2. **Generated items are never hand-edited.** Failures are regenerated. Escalations are triaged against the CED
   PDF (brief or fact-pack errors are fixed at the source).
3. **Independence and controls.** Four checker families that did not write the item must clear it, and the
   author's family holds a reject-only veto. Planted-defect controls gate every batch.
4. **Cost.** The cost gap is accepted for now, with tuning levers listed in §0.7. Re-evaluate with the §0.5 test
   after any cut.

### Consequences

- The legacy patch loop (§5 adjudicate-and-repair) is retired for new MCQs.
- PR #348 (25 hand-patched items) stays on hold.
- Live teaching items found defective are replaced through §0.6, not edited in place.
- ~~Human spot-check per subject~~ (removed by DECISION-0102, 2026-10-07) and a Hard-Gate approval remain required before any Production load.

## DECISION-0098 — Released-Exam-Derived Student Practice Sets May Seed Original Items Only Through the Clean-Room Spec Path

**Date:** 2026-10-06  
**Decided By:** David Bloom  
**Related:** `docs/research/SEEDED_ITEM_GENERATION_PROTOCOL_2026_09_30.md` (§2 class D, §3 S1-S4, §4), `docs/research/ORLY_EXTERNAL_ASSIGNMENT_MINING_PROTOCOL_2026_08_24.md`, `DECISION-0093`, `DECISION-0095`

### Context

Orly and classmates pooled practice MCQs: 20 AP Chemistry questions in a Google Doc and 4 AP Calculus AB questions pasted in chat. Each item is a reworded version of a released AP exam item (most carry an "Original idea" line). The seeded protocol classes these as D ("do not use as seeds without a decision"). David asked to learn from them to make more diverse questions, "consider them seeds which we will version", for Units 1-3 only, aligned with the CED.

### Decision

1. Class-D student-pooled sets may be used as seeds **only through the class-B clean-room path** (seeded protocol §3 S1-S4, §4):
   - one context reads the source and writes scrubbed family specs (patterns and misconceptions only);
   - a separate context that never saw the source authors original items from those specs;
   - a divergence check against the source runs outside the repo and stores only numbers.
2. The source text is not stored in the repository. Specs, items, check outputs and numeric divergence reports are.
3. Run parameters chosen by David (AQP §2.1): checkers `openai/gpt-5.6-sol` + `deepseek/deepseek-v4-pro-0813` (live roster 2026-10-06), 3 members per family (easy/medium/hard), and **stop at checked drafts**. Nothing is loaded to Dev or Production without a separate approval.
4. The protocol's scrub sign-off (S2) is David's. The specs are in each batch's `family_specs.json`.

### Consequences

The batches are `scripts/content-seed/apchem-orly-cleanroom-2026-10-06/` (8 families, 24 drafts) and `scripts/content-seed/apcalcab-orly-cleanroom-2026-10-06/` (2 families, 6 drafts). A source-instance convergence (an author independently reproducing the source's specific compound or apparatus) is treated as a rewrite, not a tweak; 4 of 24 Chemistry drafts were rewritten for this reason. The family-membership gap (seeded protocol §7) still applies: family IDs live only in the batch files.

## DECISION-0097 — Owner Override: Open Hand and the Plate-Loop Practice Template Ship to Production Without the Fresh Independent QA TASK-0051 Required; the Plate Loop Becomes the Default Practice Entry

**Date:** 2026-10-05  
**Decided By:** David Bloom  
**Related:** `TASK-0051`, `TASK-0052`, `DECISION-0086`, `DECISION-0087`, `APPROVAL-0121`

### Context

David logged in on 2026-10-05 and got neither the redesigned student hub nor Open Hand. Read-only checks found: Production had never received `public.get_open_hand_item` (TASK-0051 Blocked pending fresh QA); the live Open Hand screen still called the superseded `open-hand-item` batch edge function, which does not exist in Production; and the plate loop was off by default behind a student-reachable `?loop=` URL switch.

### Decision

1. TASK-0051's gate is overridden by the owner. The RPC ships to Production now; the fresh independent QA becomes a follow-up, not a precondition.
2. TASK-0052 is executed now: the front end calls the RPC directly, one item at a time, and `open-hand-item` is deleted from the app (DECISION-0086 D2 as amended on TASK-0052).
3. The plate loop (Open Hand → Practice plate) is the default "Start practice" path for every student. The `?loop=` override is removed; `VITE_PLATE_LOOP=off` is the kill switch; `/session` stays in the codebase as the fallback.

### Amendment 2026-10-06

Point 3 is reversed for now: after seeing the live screen, David turned the plate loop OFF by default (`5b269ac1`, published). The plate loop returns as the default only after the fixes and checks listed on TASK-0052 pass his review.

### Consequences

The open TASK-0051 items (fresh QA, F3, excluded-item serving, staff live path, per-load exclusion count) remain open and owned. Rollback for the front end is the kill switch or a Lovable revert; rollback for the backend is dropping the function, which no other caller depends on.

## DECISION-0096 — MCQ Variants Inherit Their Seed's Difficulty Band

**Date:** 2026-10-04
**Decision Owner:** David Bloom
**Status:** Approved ("new MCQs should inherit the level of difficulty from the seed question. If seed does not have a level of difficulty, let's add it and apply to the variants.")
**Related:** 2026-10-04 six-criteria re-run (`docs/product/SUBJECT_SERVABILITY_CRITERIA.md`); APPROVAL-0117; migration `20261004130000`
**Area:** Content / difficulty

### Context

The 2026-10-04 re-run found criterion 5 (difficulty) failing for MCQ in every subject: about 1,040 MCQ variants
were published from 2026-09-30 without a `content_item_difficulty` row.

### Decided

1. An MCQ variant takes its seed's difficulty band. A Calc BC item that is a copy of an AB item takes the AB item's band.
2. If the seed has no band, the seed is rated first and the band is then applied to its variants.
3. Going forward, publishing an MCQ variant includes writing its inherited difficulty row.

### Notes

- Seed links are not stored in the database (seeded-item protocol §7). They are resolved from the content keys,
  which match every batch manifest: `-sv-<n>-vK` → `-<n>`; `-u<U>v-<n>-vK` → `-u<U>n-<n>`; `-u<U>n-<n>-vK` → `-u<U>n-<n>`;
  `apcalcbc-mcq-ab-<rest>` → `apcalcab-mcq-<rest>`.
- Variants that already had their own difficulty row were not changed.
- **Extended to FRQ variants** (David Bloom, 2026-10-04: "yes, apply the same rule to FRQ variants"). The one unrated FRQ variant, `apcalcab-frq-u1v-001-v2`, inherited Medium from `apcalcab-frq-u1n-001` (migration `20261004140000`).

## DECISION-0095 — Items Stay Within the Subject's CED Vocabulary; a Mechanism Supplied in the Stem Does Not Bring a Term In Scope; Published Items That Break It Are Retired, Not Repaired

**Date:** 2026-10-03 (first stated 2026-10-01)
**Decision Owner:** David Bloom
**Status:** Approved (Product Owner direction in the 2026-10-01 to 2026-10-03 Claude sessions; each point quoted below)
**Related Docs:** `docs/research/SEEDED_ITEM_GENERATION_PROTOCOL_2026_09_30.md` (section 10 and its pre-run checklist); `docs/handoffs/SEEDED_QUESTIONS_SESSION_RECORD_2026_10_01.md`; `docs/product/AP_BIOLOGY_CED_FACT_PACK.md`
**Related Decisions:** `DECISION-0093`, `DECISION-0085`, `DECISION-0082`
**Related Approvals:** `APPROVAL-0068`, `APPROVAL-0091`, `APPROVAL-0092`
**Area:** Content / QA / Scope

### Context

The AP Biology seeded-variant pilot found that published seeds and variants used terms the course and exam description (CED V.1, 2025, confirmed latest by the Product Owner) never names: signal sequence and SRP, 70S and 80S ribosomes, receptor-mediated endocytosis, clathrin, binary fission, integral and peripheral membrane proteins, high-salt extraction, and isomers. In most of them the stem supplied the mechanism, so the question was answerable from the text. The Product Owner had to choose between allowing that (as AP stimulus questions do) and keeping items to CED vocabulary.

### Decided

1. **Items stay within the CED vocabulary of their subject** ("stay within theced vocab", 2026-10-01; "Retire all 3 and create a decision for stay within the CED", 2026-10-03). A term or concept the CED does not name is out of scope even if the stem explains it.
2. **A published item that breaks the rule is retired, not repaired or replaced** ("We should retire them. We have enough questions. No need to do anything questionable", 2026-10-03). Retiring sets item and version status to `retired`; nothing is deleted. Five seeds were replaced with CED-vocabulary text (`APPROVAL-0068`) before this preference was stated; they stay as replaced. Retired so far: 7 variants (`APPROVAL-0091`) and 3 seeds (`APBIO-MCQ-014`, `063`, `025`; `APPROVAL-0092`).
3. **How a break is found.** A case-insensitive full-text match of stimulus, stem, every choice and every rationale against terms confirmed absent from the CED V.1 text. A generic label built from a CED term (for example "tripeptide" from "peptide") is not a break. Flags from a model checker are candidates only and are adjudicated against the CED text, never by vote.
4. **Where the checks come from.** The subject's CED fact pack must cite the CED and record the terms known to be absent; the scope check reads the pack, so it must be kept current.

### Consequences

- **Applied so far to AP Biology only.** Published banks in other subjects (Calc AB, Chemistry, Statistics, Physics, Precalculus) have **not** been scanned under this rule. **The Product Owner said on 2026-10-03 not to rescan them under this decision.** New items in any subject must still follow the rule.
- The term list is not exhaustive: it contains only terms confirmed absent. The CED text extracted from the PDF has spacing problems, so an absence should be confirmed by reading the CED page before an item is retired on it.
- FRQ and hand-drawn items were not scanned.
- 17 AP Biology variants and 62 seed-style AP Biology MCQs remain published; this session's 16 unloaded variant drafts stay unloaded.
- Retiring leaves labels in place, so label counts do not change when items are retired.

## DECISION-0094 — Launch Shape Revised: $1 Pilot Coupon (10 Friends) Before a 50%-Off Public Launch; Parent-Pay Live; Strangers May Pay Full Price; Supersedes DECISION-0091

**Date:** 2026-10-01
**Decision Owner:** David Bloom
**Status:** Approved (Product Owner direction in the 2026-09-30/10-01 Claude session; each point from David's own words)
**Related Task:** `docs/tasks/TASK-0041-LAUNCH-PAYMENT-FLOW.md`
**Related Docs:** `docs/product/STRIPE_PRODUCTION_CUTOVER_CHECKLIST_2026_09_30.md` (new); `docs/product/LAUNCH_RUNBOOK_2026_10_02.md` (amended)
**Related Decisions:** `DECISION-0091` (superseded for launch shape), `DECISION-0071`, `DECISION-0083`, `DECISION-0090`
**Area:** Product / Launch Scope / Payments

### Context

`DECISION-0071` chose a free launch because the payment flow was not built. `DECISION-0091` kept it free through a
100%-off `/checkout` coupon. The flow now exists in Dev. The $0 / `no_payment_required` checkout has never run, and no
real student has ever been graded. David asked why the product should be free at all.

### Decided

1. **Phase 1 — paid-flow pilot.** Orly emails a **$1** coupon to a small group of friends, who sign up promptly. Stripe
   coupon created by David in **Stripe live mode** (promotion code object `promo_1ULmINLwoRHzBJ1OIjwp6dwH`, not yet shared):
   **$38.99 off, 1 use, 10 redemptions maximum, first-time orders only**. It is a real card charge and so tests the live payment path.
2. **Phase 2 — public launch at 50% off through October**, after "some success with checkout". Success is **the Product
   Owner's judgment**; there is no automated gate.
3. **Parent-pay is live** (all six checkout functions go to Production).
4. **The code is entered by the student**, not auto-applied. **Orly emails it**, after the Production smoke test passes.
5. **Pilot users who pay $1 for one subject see the $30 "add another subject" offer** (it charges the saved card for real).
6. **Strangers may reach `/checkout` and pay full price** ($39.99 single) during the pilot. Accepted.

### Consequences

- `DECISION-0091`'s free Oct 2 shape is superseded; the runbook carries a banner.
- The $0 checkout path is off the critical path (optional Dev work). The real-card `paid` webhook path becomes the proof.
- The coupon is **"$38.99 off any purchase"**, not limited to single-subject products: a 2-subject bundle ($69.99) would
  cost $31.00 and a 3-subject bundle ($89.99) $51.00 with it. **Risk accepted by David**: at most 10 people get it, and
  mistakes will be handled manually. No `applies_to` restriction will be added.
- **Still Hard-Gated, not approved by this entry:** Stripe live-mode setup, Production secrets, the three Production
  migrations, the six Production function deploys, the Lovable publish, and the go/no-go. A refund and terms position
  (BIZ-001) is needed before live mode is enabled, because strangers can pay from that moment.
- The coupon code string must never be written into the repo.

