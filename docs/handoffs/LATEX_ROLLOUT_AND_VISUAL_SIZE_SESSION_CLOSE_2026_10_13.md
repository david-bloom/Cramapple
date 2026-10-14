# Session close — LaTeX rendering shipped, visual size standard set, LaTeX rollout still open

**Date:** 2026-10-13. **Owner:** Claude session. **Product Owner:** David Bloom.
**Status:** everything below is **merged and published to Production** unless marked otherwise.
**Governing records:** `DECISION-0119` (equation presentation), `DECISION-0120` (visual size floor),
`TASK-0072` (figure legibility).
**Read with:** `docs/new_design/CONTENT_AND_PEDAGOGY.md` → Equation presentation,
`docs/new_design/VISUAL_IDENTITY.md` → "Sizing what a student reads".

---

## 1. Why this document exists

David: *"Document this thoroughly so we can revisit the LaTeX rollout soon."*

The rendering half of the work is finished and live. **The rollout half is not started**, and it is the
part a future session will have to think about rather than execute. This document is written so that
session does not re-derive any of the measurement below.

---

## 2. What shipped

| What | Where | State |
|---|---|---|
| Equation presentation rule | `Cramapple` #427 | merged |
| KaTeX renderer, three surfaces | `ap-prep-blueprint` #16 (`2bb35c6`) | merged, **published** |
| Record corrections (renderer shipped; Production confirmed) | `Cramapple` #429, #432 | merged |
| Legibility fix: display style, compact labels | `ap-prep-blueprint` #19 | merged, **published** |
| Visual size standard + `TASK-0072` | `Cramapple` #433, #434 | merged |
| Notes figures one per row | `ap-prep-blueprint` #20 (`f0fbcdf`) | merged, **published** |

**Confirmed in Production** by the Product Owner, signed in, at
`https://app.cramapple.com/learn/ap-calculus-ab/2/2.1`.

### The renderer covers three surfaces, not one

Reading the code found one. Loading the real page found three. Any future work in this area must touch
all of them or it is incomplete:

1. `LookUp` in `src/screens/parts/ReferencePane.jsx` — reference pane and compact reference.
2. `Entries` in `src/screens/question-experience/QuestionExperience.jsx` — the `.qx-formula` list.
3. Deep-dive note sections, via `ruleLine` / `formulaLine` / `symbolClause` in
   `src/lib/open-hand/presentation.ts`.

Plus **symbol-definition labels on all three** — a label like `\bar{m}` is LaTeX in its own right.

### How maths travels through flat text

Deep-dive bodies are flat strings, so there is nothing downstream to detect. The maths is delimited with
`$` where the section is built (`mathSpan`) and rendered where it is displayed (`MathText`). No reference
entry in the corpus contains a `$`, and a stray one is stripped so it cannot unbalance the split.
`stripMath` removes the markers for the clipboard, so **copied notes are byte-identical to before** —
there is a test on this, and it must stay true.

---

## 3. The LaTeX rollout — the open work

### What it is

The reference-pack formulas were already authored in LaTeX; the app simply never rendered them. **Question
and teaching prose is the opposite: it renders fine and contains no LaTeX at all.** Zero backslashes, in
every prose column, product-wide. Division there is written inline as text, and the compound quotients
among those violate `DECISION-0119`.

### Exact targets, measured 2026-10-13 against Production

| Surface | Rows | `(compound)/(compound)` | parenthesised numerator |
|---|---|---|---|
| `mcq_choices.rationale` | 11,456 | 139 | 445 |
| `content_item_versions.stem` | 4,368 | 135 | 198 |
| `mcq_choices.choice_text` | 11,456 | 58 | 129 |
| `frq_criteria.learner_facing_text` | 6,594 | 42 | 150 |
| `content_item_versions.explanation` | 636 | 16 | 44 |
| `topic_explainers.point_attaining_answer` | 603 | 9 | 32 |
| `topic_explainers.mini_example_question` | 603 | 9 | 13 |
| `topic_explainers.weak_answer` | 603 | 4 | 19 |
| `topic_explainers.core_idea` | 603 | 2 | 11 |
| `topic_point_briefs.what_it_is` | 603 | 1 | 3 |
| **Total** | | **415** | **1,044** |

**Size it from this table, not from row counts.** 7,214 prose rows contain a slash, but 969 are unit-like
(`m/s`, `g/mol`) and 553 are Leibniz notation (`dy/dx`) — both of which the rule explicitly keeps inline.
Quoting table sizes as the scope overstates the job by roughly twenty times, and an earlier draft of this
session did exactly that.

*(An earlier figure of 402 appears in `DECISION-0119`; it omitted `topic_explainers.weak_answer`. 415 is
the correct count for the same pattern.)*

Sampled and confirmed to be genuine rational functions, e.g. `(x²−4)/(x−2)`, `(214 - 190)/(6 - 5)`,
`(3 - t)/(t^2 - 16)`, `Let f(x) = (x²−x−6)/(x²−4)`.

### Why it is not just a find-and-replace

1. **There is no notation in these surfaces at all.** The reference pane renders LaTeX because the content
   is LaTeX. Prose is plain text, so the rollout needs a *notation decision first*: author LaTeX into the
   prose and render it, or mark maths some other way. Nothing has been decided.
2. **Every prose surface would need a renderer.** Stems, choices, rationales and criteria are rendered by
   components that currently emit plain text. `MathText` exists and is reusable, but each surface has to
   opt in, and each is on the hot path of the question experience.
3. **The content is reviewed.** These are published, reviewed items. A regex that reformats 415 of them
   silently is exactly the kind of change this repo's content discipline exists to prevent. A render-time
   transform was considered and rejected for that reason — the recommendation is to author the change,
   because 415 rows is a reviewable pass.
4. **An unresolved design question.** The rule says stack a compound quotient. Applied literally to
   `Let f(x) = (x²−x−6)/(x²−4). Which statement…` it stacks **inline, mid-sentence**, which is chunky in
   running prose. Display-only stacking for prose, with inline slashes left in sentences, is a legitimate
   alternative that has not been ruled on. **Decide this before anyone edits 415 rows**, or it will be
   done twice.

### Suggested sequence for the next session

1. Rule on the inline-versus-display question above. It changes what the content pass produces.
2. Decide the notation (almost certainly LaTeX, for consistency with the reference packs).
3. Open a task; Production content writes are a Hard Gate.
4. Pilot one surface and one subject — `content_item_versions.stem` for a single subject is the smallest
   slice with real signal.
5. Only then widen. Author, do not transform.

---

## 4. The visual size standard

**The 16px floor binds on the smallest character a student must read to answer, measured in rendered
pixels on screen — not on the nominal size of the element containing it.** Chrome is exempt; so are the
subordinate characters of maths typography (subscripts, superscripts, limits) and, in a figure, the tick
labels. In scope for a figure: title, subtitle, axis titles, annotations, data labels, legend.

**Compliance is established by measurement, never by inspection.** Render it, measure every element that
paints a glyph excluding spacers, take the minimum. For an SVG, multiply the authored `font-size` by
rendered width ÷ viewBox width.

### Current measured state

| Surface | State |
|---|---|
| Mathematics | **Compliant.** Fraction digits ~20.8px, symbol labels 17.6px, subscripts 14.6px, against 16px prose. |
| Notes-sheet figures, ≥~1130px viewport | **Compliant.** Smallest in-scope label 21px at 1440px, 18.4px at 1280px. |
| Notes-sheet figures, <~1130px | **Below the floor**, and scale cannot fix it: the sheet is narrower than the 989px a `full`-preset figure needs and is already single-column. 15.5px at 1100px, 10.9px at 768px. |
| Reference-pane figures | **Below the floor**, out of scope: ~324px slot against the 495px a `compact` figure needs. |
| Phones | **Below the floor**, out of scope by ruling. |

Closing the sub-1130px gap needs a type bump on the in-scope roles in `src/lib/figures/render.ts` — the
second-choice lever, deliberately not taken. It is cheap now that ticks are exempt, but it is a renderer
change with layout consequences and must go through the three-gate figure verification.

---

## 5. Traps this session hit, so the next one does not

- **Production cannot be verified anonymously.** `app.cramapple.com` 302s to `cramapple.com` when logged
  out, so `curl -L` silently returns the *marketing* site's HTML and assets, and a 404 body reads as
  "feature absent". I concluded the renderer was missing from the published CSS twice on this basis. It
  was not. Check signed in, or not at all.
- **A 200 is not a body.** The Lovable npm mirror returns HTTP 200 on HEAD and an empty body without
  credentials. Hashing that gave the sha512 of the empty string, which briefly looked like a verified
  integrity match. Check `size_download`, not just the status.
- **Read the preset off the calling component.** The first measurement of the notes page called it
  compliant, using viewBox 340 (`compact`) when the sheet renders `layout="full"` (680). Wrong by a factor
  of two.
- **Reading the code found one surface printing LaTeX; loading the page found three.**
- **The decision-log index is stale.** Its "most recent entries" block listed `DECISION-0108` as the top
  entry while the log actually ran to `0118`. Grep for the maximum; do not trust the index head.
- **Three defects here were invisible to the whole test suite and to reading the markup, and visible in
  one measurement.** The test suite cannot see type size. Measure.

---

## 6. State of the repositories at close

- `Cramapple` `main`: all documentation merged. No uncommitted work from this session.
- `ap-prep-blueprint` `main`: `f0fbcdf`, published to Lovable project `56cae479`.
- `bun.lock` carries a **hand-constructed** KaTeX entry — bun cannot run on this machine. Its integrity
  hashes were verified byte-for-byte against the npm tarballs, and three Lovable builds have since
  succeeded on it, which is the real proof.
- The shared worktree `.worktrees/cramapple-app` is left on `claude/task-0072-notes-figure-scale`.
