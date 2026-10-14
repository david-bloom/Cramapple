# TASK-0075 — Clean up ASCII-notation maths in questions and lesson notes

**Status:** Open — queued 2026-10-14 at the Product Owner's request; nothing run yet.
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
