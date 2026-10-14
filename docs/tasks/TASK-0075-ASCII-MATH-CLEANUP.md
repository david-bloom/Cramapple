# TASK-0075 — Clean up ASCII-notation maths in questions and lesson notes

**Status:** In progress — read-only inventory done 2026-10-14; waiting on the Product Owner's scope and notation rulings (below) before anything is drafted. No Production write.
**Tier:** Standard for the inventory and drafting; **Hard-Gate** for any Production write (same gate as `TASK-0073`).
**Owner:** unassigned. **Product Owner:** David Bloom.
**Branch / PR:** none yet.
**Depends on:** `TASK-0073` Phase 1 (done 2026-10-14); `TASK-0074` only if a drafted edit touches rubric text.
**Related:** `DECISION-0119`, `DECISION-0121`, `docs/new_design/CONTENT_AND_PEDAGOGY.md` "Equation presentation".

## Why this exists

`TASK-0073` fixed one class of problem: compound quotients written with a slash inside brackets. Screenshots from the
published app on 2026-10-14 show a second class that the pilot deliberately left alone: maths typed as plain ASCII.

- Question stems: "linear charge density lambda > 0", "uniform volume charge density rho". The choices on the same
  questions now render ρ and ε₀ as symbols; the stems still print the words.
- Lesson notes (worked examples, weak and point-attaining answers): `q_enc = sigma1*(2*pi*r*l)`, `E.dA`,
  `4.0x10^-9 C/m^2`, `E*(2*pi*R1*l)/epsilon0`.
- Bracket-free quotients the pilot's detector could not see, such as `4πR²/ρ` as an answer choice (`DECISION-0119`
  says it stacks).

## Scope

1. **Read-only inventory** in Production, per subject: find ASCII Greek names, `*` for multiplication, `^` exponents,
   `_` subscripts, `E.dA`-style dot products, and bracket-free quotients, across `stem`, `stimulus`, `choice_text`,
   `rationale`, `explanation`, rubric text and topic-guide lesson notes. Report counts by subject, surface and pattern.
   Expect physics and chemistry to dominate; do not assume.
2. **Decide notation per surface before drafting.** Question prose uses `\(…\)` / `\[…\]` (`ProseMath`). Lesson notes
   are rendered by `MathText`, which uses `$…$`; check that surface's renderer and delimiters rather than reusing
   the prose rule. Do not use `$…$` in question prose (`$` is currency there).
3. **Decide what stays plain.** Single Greek letters in running text may be better as Unicode (ρ) than as LaTeX;
   units and `10^-9` notation need a ruling. Put the rulings to the Product Owner with examples before drafting.
4. **Draft, validate, QA, apply** using the `TASK-0073` machinery: `scripts/latex_prose_pilot/validate.mjs`, an
   independent QA pass, and the guarded all-or-nothing transaction pattern (exact before-text guards, versions pinned,
   taxonomy labels captured and restored, post-write verification). Stems and choice text are inside
   `app.taxonomy_relevant_hash`; explanation is not.

## Inventory (2026-10-14, read-only Production queries)

**Scope of the read:** published items whose served version is published (2,915 versions), ten subject prefixes
(`apstat`, `apstats`, `STATS` merged). Rows that already contain `\(` or `\[` are excluded, so the 21 rows converted
in `TASK-0073` Phase 1 are not counted. Counts are **rows**, not items (a multiple-choice item has four choice rows).
The patterns are deliberately loose; a hit means "worth a look", not "wrong". Nothing below quotes exam text.

**Patterns** (Postgres regex): a Greek name next to a digit or operator (`6*pi`, `epsilon_0`, `lambda/(…)`); an underscore
subscript (`E_s`, `g_E`); a caret exponent (`x^2`, `e^(-bt)`); `*` between operands (`6*pi`); `sqrt(`; a dot-differential
(`E.dA`). Bracket-free quotients (`4πR²/ρ`) cannot be found reliably by regex and are found during drafting instead.

**Rows with at least one hit: 2,585.** By surface:

| Surface | Rows with a hit | In scope? |
|---|---:|---|
| MCQ answer rationale | 932 | yes |
| MCQ stem | 348 | yes (deterministic scoring, no model reads it) |
| MCQ answer choice | 383 | yes |
| MCQ stimulus | 1 | yes |
| FRQ stem + stimulus | 171 | **no for now:** the grader prompt includes the stem and stimulus, the same grader-read risk that ended the rubric edits (`DECISION-0122`) |
| Rubric text and rubric minimum fix | 704 | **no:** dropped by `DECISION-0122` |
| Version explanation | 46 | **no:** reaches no student surface |
| **In scope** | **1,664** | |

By subject (all surfaces): Calculus AB 731, Calculus BC 650, Precalculus 284, Physics 1 243, Physics C E&M 237,
Chemistry 182, Physics C Mechanics 104, Statistics 65, Physics 2 62, Biology 27.

By pattern (rows matching, overlapping; all surfaces): caret exponent 1,778; underscore subscript 432; Greek name 289;
`*` multiplication 245; `sqrt(` 235; dot-differential 2. Calculus is dominated by caret exponents; Physics by
subscripts and Greek names; Chemistry mostly by exponents.

**Where it hurts most for a student:** answer choices typed as `6*pi`, `sqrt(k/m)`, `e^2`, `9E_s`, where the stacked or
symbol form would read far better.

**Not located:** the Deep Dive lesson notes seen in the app (worked examples with `q_enc = sigma1*(2*pi*r*l)`) are not in
any `app` or `public` table found by name. `unit_reference_entries` (the reference packs) already renders stacked. A
pointer to where lesson notes are stored is needed before they can be inventoried.

## Rulings needed from the Product Owner before drafting

1. **Scope tier.** (A) answer choices only, 383 rows: smallest, biggest visual gain, same machinery as Phase 1.
   (B) A plus MCQ rationales and MCQ stems and stimuli: all 1,664 in-scope rows. (C) later, FRQ stems and stimuli, only
   if the grader-read risk is first solved (see `TASK-0074` follow-up review, section 5). Recommended: **A first**, then B in
   the order Physics C E&M, Physics C Mechanics, Physics 1, Physics 2, Precalculus, Chemistry, Statistics, Biology, with
   Calculus last because it is the largest set.
2. **Notation.** One rule, per `DECISION-0121`: any ASCII maths in an MCQ choice, rationale or stem becomes `\(…\)`
   LaTeX; ordinary words that happen to match (`gamma rays`, `delta` as a place name) are left alone. The alternative is
   Unicode for simple cases (`π`, `x²`) and LaTeX only for compound ones, which mixes two notations. Recommended: **LaTeX only**.
3. **Units and powers of ten.** Whether `m/s^2`, `C/m^2` and `4.0x10^-9` are converted when they sit in a unit
   string. Recommended: convert the exponent (`\mathrm{m/s^2}`), and keep the `DECISION-0119` rule that compound
   units keep their slash.
4. **Lesson notes.** Where are they stored, and are they in scope?

Whatever is chosen, each Production write uses the Phase 1 transaction pattern (exact before-text guards, versions pinned,
taxonomy labels captured and restored, post-write verification) and needs the Product Owner's explicit approval first.

## Risks to carry forward

- **Taxonomy labels.** Editing stems, stimuli, choices or rubric text flips validated labels to stale, which removes
  the item from student practice until restored. The Phase 1 transaction shows how to capture and restore them.
- **Grader.** Rubric text feeds the grading model; keep rubric edits behind `TASK-0074`. Check whether the grader
  also reads stems before editing them.
- **Staff surfaces.** Reviewer and admin pages render prose maths as of `ap-prep-blueprint` PR #23; confirm for any
  new field touched.
- **Published exam text.** Drafts and transactions hold published exam text and stay in a private branch, not here.

## Acceptance

- Inventory report with counts and examples, reviewed by the Product Owner.
- Written notation rulings recorded in `DECISIONS_LOG.md`.
- A drafted, validated, independently QA'd edit set, then an approved Production write with verification, or an
  explicit decision to stop at the inventory.
