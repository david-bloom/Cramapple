# CramApple Design System

CramApple is AP exam practice that teaches the scoring, not just the subject. A student works one question at a time inside a fixed three-pane plate: how it is scored on the left, the question and their work in the middle, what they are allowed to look up on the right. The product's whole argument is that points are won and lost in nameable ways, so every screen is built to name them.

There are two modes of every question type, and the difference between them is the product:

- **Open Hand** — nothing is hidden. The rubric (or the answer key) is face-up, the credited answer is marked, and the student manipulates it to watch the score move. It is a demonstration, not a test.
- **Practice** (the plain templates) — the same plate, but the scoring is withheld behind hints that cost something to open, and the student's own work is scored.

Question types: **FRQ** (free response, multi-point rubric, written answer) and **MCQ** (one question, four options, one correct and three distractors). Each exists in both modes — four templates in all.

## Sources

Extracted from the working templates built in the Project-Crux design project:

- `CramApple - Open Hand FRQ.dc.html`
- `CramApple - FRQ.dc.html`
- `CramApple - Open Hand MCQ.dc.html`
- `CramApple - MCQ.dc.html`

Sample content throughout is AP Statistics Unit 2 (2.2 Scatterplots & Correlation, 2.3 Least-Squares Regression). No codebase, Figma file, or brand guideline document was provided; everything here is derived from those four templates. **No logo or brand mark was provided** — the wordmark is set in type (Bungee, white on red, with a hard offset shadow) wherever a mark would go. Do not draw one.

## Index

| File | What it holds |
| --- | --- |
| `styles.css` | The only entry point consumers link. `@import` list, nothing else. |
| `tokens/colors.css` | Brand, voice, ink, paper and rule colors. |
| `tokens/typography.css` | The four families and every type role. |
| `tokens/spacing.css` | Frame, three-pane grid, spacing scale, pane padding. |
| `tokens/elevation.css` | Borders, accent rules, shadows, the square-corner rule. |
| `tokens/semantic.css` | Aliases — use these in components, not the raw scales. |
| `guidelines/` | Specimen cards for the Design System tab. |
| `components/` | Reusable primitives (pending — see Status). |
| `ui_kits/` | Full-screen recreations of the four templates (pending). |

## Visual foundations

**The plate.** Every template is a fixed 1440×900 frame that never scrolls and never has a collapsed region. `overflow: hidden` at the frame, a 70px red masthead, a 48px breadcrumb bar, then a three-column grid — 352px / fluid / 324px with 20px gaps inside 40px gutters — and a single 10px caption line at the bottom. **Content is sized to fit; it is never made reachable by scrolling or expanding.** If something does not fit, cut copy or restructure the layout. This is a hard rule and the most common way to break the system.

**Corners are square.** Radius 0 on every surface — panes, cards, buttons, chips, inputs. The only round thing in the product is a radio dot. Do not introduce rounded cards.

**Panes are capped, not tinted.** Each pane is white with a 1px `--rule-300` border and a 3px colored top rule that names its voice: blue for the rubric/answer key, green for reference materials. The question pane is not capped — it is outlined in 2px brand red, which is what makes it read as the primary surface. Pane shadow is `--shadow-pane`; the question pane carries the slightly heavier `--shadow-section`.

**Color is assignment, not decoration.** Five voices, each with one job:

| Voice | Owns |
| --- | --- |
| Red `--red-500` | Masthead, active breadcrumb, the one primary button per screen. Never used for error. |
| Blue `--blue-600` | Rubric, points earned, credited answers, ✓ marks. |
| Green `--green-500` | Reference materials only. |
| Yellow `--yellow-500` | Hints only. Every yellow surface costs the student something. |
| Purple `--purple-600` | The student's own work: answer field, options, feedback, deep dive. |

Clay `--clay-600` carries points lost and eliminated options — a warm brown-red, deliberately not the brand red, because a lost point is a correction and not an alarm. Amber `--amber-600` is the "revisit" mark. Teal appears only as one accent rule inside the deep dive.

**Type.** Bungee is the wordmark and nothing else. Passion One sets pane titles, scores and overlay titles at 22–32px; it is used at display sizes only, never for prose. Source Sans 3 does all reading and all controls. STIX Two Math is reserved for set mathematics. **Body copy never goes below 16px** — chrome (breadcrumb 13px, counts 12px, eyebrows 12px) is the only exception, and never for content a student must read to answer. Eyebrows are 12px, 700 weight, uppercase, `.15em` tracking.

**Backgrounds and imagery.** Paper white plates on a `--paper-100` desk; chrome bars in `--paper-050`. Graphics are the question's own data — a scatterplot, a table — drawn as inline SVG on a `--purple-tint-05` field with a `--purple-rule` border, axis labels in `--purple-500`. Influence points and other called-out marks are yellow. There is no photography, no illustration, no gradient, and no texture anywhere in the product.

**Depth and transparency.** Shadows are wide, soft, and low-opacity (`0 12px 30px rgba(20,40,50,.07)`), read as paper lift rather than elevation levels. The feedback card is the one purple-cast shadow. Transparency appears only as flat color tints (`--purple-tint-06`) and the modal scrim (`--scrim`); there is no blur, no glass, no protection gradient.

**States.** Selection is a 2px purple border plus a filled radio dot plus a bolder label — never a background wash. Disabled is a desaturated fill (`--action-primary-disabled`) with `cursor: not-allowed`, not opacity. Eliminated/struck content is clay ink with a line-through and ~55% opacity. Secondary actions are underlined text links (3px underline offset), never outlined buttons. Quiet actions are white with a `--rule-400` border and `--ink-500` label. There is no motion in the system: no transitions, no fades, no bounces. State changes are instant, because the product's rhythm is read-decide-see.

**Overlays.** Two, both square-cornered and both full-bleed within their region: the study map drops under the breadcrumb across the full width over a `--scrim`; the deep dive covers the entire frame below the breadcrumb (all three panes) — it must be full-frame, because at the center pane's ~664px it cannot fit its content without scrolling.

## Content fundamentals

**Second person, present tense, imperative.** "Read the stem before the options." "Pull a hint only if you need one." The product talks to the student as a coach mid-session, never about them.

**Name the error; don't judge the student.** Feedback says what the reading did, not that the student failed: "'will score' turns a prediction about averages into a guarantee about one student." Corrections open with `Fix:` or `Next time:`. The mark for a missed point is ↻ ("revisit"), never ✕ — the ✕ exists only in Open Hand, where the *teacher's* hand takes a point back.

**Verdicts are one word.** "Correct" / "Incorrect". Scores are `1 / 1`, `4 / 4`, and `— / 1` before an attempt. Never "Great job", never "Oops", no exclamation marks.

**Eyebrows label, headings name, sentences explain.** Eyebrow copy is one or two words ("QUESTION", "HINT", "FEEDBACK", "HINTS USED"). Pane titles are single nouns ("Rubric", "Answer Key", "Reference Materials", "Elimination"). Explanations are one to three sentences, in the language of the variables.

**Rules come in pairs.** Every question carries "How points are earned" and "How points are lost", three short lines each, written as habits rather than facts — one clause, no hedging. They are deliberately shorter than prose so the pane fits without scrolling.

**No emoji, ever.** Glyph vocabulary is ✓ ✕ ↻ ? ▸ ▼ ⌂ / · and the em dash. Typographic symbols only.

## Pedagogy rules (these are design rules, not copy suggestions)

**The hint economy.** A hint is never free and never silent. Three states, always in this order:

1. **Idle** — a yellow block offering the hint by name ("Show me the rubric", "Rule out two choices") with a `?` chip.
2. **Asking** — "Sure you need a hint?" plus one line naming what it gives away, then "Yes, show me" (yellow) beside "No, keep solving" (a text link). The cost is surfaced *before* disclosure, and backing out is as easy as continuing.
3. **Open** — the content appears below, and the block collapses to a receipt: "Hint used · Rubric", with "Hide". The receipt never disappears, and every hint pulled is listed again in the feedback card's "Hints used" strip.

Never auto-open a hint, never open one on hover, and never let a hint close without leaving its receipt.

**Open Hand shows everything.** In Open Hand mode nothing is gated: the rubric's points are face-up and manipulable, the answer key marks Correct and Distractor before the student picks, and selecting any option is free. The learning move is exploration — Open Hand MCQ invites the student to read all four explanations, and tracks how many they have read rather than scoring them.

**Practice mode scores the student's own work.** One answer, one submission, then a feedback card: score, coaching paragraph, hints-used receipt, and a per-criterion (FRQ) or per-choice (MCQ) mark list. The student's submitted work stays visible in a white band beneath the feedback so coaching can be read against it. Primary action is dimmed until there is something to submit.

**Every distractor is a named trap.** An MCQ distractor must carry (a) why it tempts and (b) the one-line fix. A distractor without a named error is not usable content.

**Reference materials are what the student may look up, not hints about this question.** Topic, skills, vocabulary — always the same three sections, in that order.

## Iconography

There is no icon library in the product and none should be added. The system uses three things:

1. **Typographic glyphs** for status and navigation: ✓ (credit), ✕ (take the point — Open Hand only), ↻ (revisit), ? (hint), ▸ ▼ (disclosure), ⌂ (home), · (separator).
2. **Two hand-drawn 24×24 stroke SVGs**, inline, `stroke-width` 1.9–2, round caps, `currentColor`: a camera (attach a hand-drawn image) and a copy/duplicate mark (copy the deep dive).
3. **Data SVG** — the question's chart, drawn per question from coordinates.

If a genuine icon need appears, match that inline stroke style (2px, round caps, `currentColor`, 24px box) rather than importing a set. No emoji.

## Status

Built: tokens, this guide, foundation specimen cards.

Pending (needs the dedicated design-system project so the component compiler runs): the nine component families — pane shell + score chip, hint gate, radio option row, rubric criterion row, feedback card + verdict chip, breadcrumb + study map, deep dive overlay, action row, question header + graph frame — and five UI kits (Open Hand FRQ, FRQ, Open Hand MCQ, MCQ, and a new Home / study map screen).

Known gaps to resolve with the team: the type stack (Bungee / Passion One / Source Sans 3, all Google Fonts) is treated as the brand stack but has not been confirmed; there is no logo file; and the upcoming surfaces — blog templates, the Stripe enrollment funnel, hand-drawn image capture, and the marketing home page — have no tokens or components here yet, because none of those screens were available to extract from.
