# CramApple Design System

CramApple is AP exam practice that teaches the scoring, not just the subject. A student works one question at a time inside a fixed three-pane plate: how it is scored on the left, the question and their work in the middle, what they are allowed to look up on the right. The product's whole argument is that points are won and lost in nameable ways, so every screen is built to name them.

There are two modes of every question type, and the difference between them is the product:

- **Open Hand** — nothing is hidden. The rubric (or the answer key) is face-up, the credited answer is marked, and the student manipulates it to watch the score move. It is a demonstration, not a test.
- **Practice** (the plain templates) — the same plate, but the scoring is withheld behind hints that cost something to open, and the student's own work is scored.

Question types: **FRQ** (free response, multi-point rubric, written answer) and **MCQ** (one question, four options, one correct and three distractors). Each exists in both modes — four templates in all, plus a Home / study map screen.

## Sources

Extracted from the working templates built in the Project-Crux design project:

- `CramApple - Open Hand FRQ.dc.html`
- `CramApple - FRQ.dc.html`
- `CramApple - Open Hand MCQ.dc.html`
- `CramApple - MCQ.dc.html`

Sample content throughout is AP Statistics Unit 2 (2.2 Scatterplots & Correlation, 2.3 Least-Squares Regression). No codebase, Figma file, or brand guideline document was provided; everything here is derived from those four templates and the written style guide handed over with them. **No logo or brand mark was provided** — the wordmark is set in type (Bungee, flat) wherever a mark would go. See "The mark" below. Do not draw one.

## Index

| File / folder | What it holds |
| --- | --- |
| `styles.css` | The only entry point consumers link. `@import` list, nothing else. |
| `tokens/fonts.css` | The four webfonts. The app self-hosts them — see `web/src/styles/tokens/fonts.css`. |
| `tokens/colors.css` | Brand, voice, ink, paper and rule colors. |
| `tokens/typography.css` | The four families and every type role. |
| `tokens/spacing.css` | Frame, three-pane grid, spacing scale, pane padding. |
| `tokens/elevation.css` | Borders, accent rules, shadows, the square-corner rule. |
| `tokens/semantic.css` | Aliases — use these in components, not the raw scales. |
| `guidelines/` | 24 specimen cards. Open one in a browser; each links `styles.css`. |
| `assets/icons/` | The two hand-drawn stroke SVGs (camera, copy). |
| `SKILL.md` | Agent-Skills front matter so this folder can be used in Claude Code. |

**The components and screens are running code, not prototypes.** They live in
the app, and that is where to read them and where to change them:

| Where | What |
| --- | --- |
| `web/src/components/` | The nine families, one directory each, `index.js` is the barrel. |
| `web/src/screens/` | The five screens, wired together and interactive. |
| `web/README.md` | How to run it, and the product rules the code enforces. |

Do not re-implement a primitive inside a screen, and do not restyle one with
literal hex — every component reads the semantic aliases in `tokens/semantic.css`.

### Components

Grouped by concern, under `web/src/components/`.

| Directory | Components |
| --- | --- |
| `pane/` | `Plate`, `PlateGrid`, `PaneShell`, `ScoreChip` |
| `hint/` | `HintGate` |
| `choice/` | `RadioOptionRow` |
| `rubric/` | `RubricCriterionRow` |
| `feedback/` | `FeedbackCard`, `VerdictChip` |
| `navigation/` | `Masthead`, `Wordmark`, `Breadcrumb`, `StudyMap` |
| `overlay/` | `DeepDiveOverlay` |
| `actions/` | `ActionRow`, `ActionButton` |
| `question/` | `QuestionHeader`, `GraphFrame`, `AnswerField` |

**Intentional additions.** Four names are not in the original nine-family list but were needed to build the plates without re-implementing chrome inside every kit: `Plate` / `PlateGrid` (the fixed 1440×900 frame and its three-column grid, previously inline in each template), `Masthead` (the 70px orange bar), `Wordmark` (the mark, so the on-light ink rule lives in one place), `ActionButton` (the four action treatments the action row composes), and `AnswerField` (the FRQ written-answer box). Nothing else was invented — there is no Toast, Avatar, Tabs or Tooltip here, because the product has none.

### Screens

Under `web/src/screens/`. `npm run dev` in `web/` opens them.

| Screen | What it does |
| --- | --- |
| `OpenHandFrqScreen` | Rubric face-up and manipulable; taking a point strikes the matching phrase in the credited response. |
| `PracticeFrqScreen` | Rubric behind a hint gate, answer field, feedback card with the submitted work kept visible. |
| `OpenHandMcqScreen` | Answer key face-up; counts explanations read instead of scoring. |
| `PracticeMcqScreen` | Elimination hint, one submission, then key + feedback. |
| `HomeScreen` | Home / study map. Progress is derived from recorded attempts, never stored twice. |

The layout rules on this page are enforced by `npm run verify:panes` and
`npm run verify:screens` in `web/` — a pane that overflows the 1440×900 frame in
any state fails the check.

## Visual foundations

**The plate.** Every template is a fixed 1440×900 frame that never scrolls and never has a collapsed region. `overflow: hidden` at the frame, a 70px orange masthead, a 48px breadcrumb bar, then a three-column grid — 352px / fluid / 324px with 20px gaps inside 40px gutters — and a single 10px caption line at the bottom. **Content is sized to fit; it is never made reachable by scrolling or expanding.** If something does not fit, cut copy or restructure the layout. This is a hard rule and the most common way to break the system.

**Corners are square.** Radius 0 on every surface — panes, cards, buttons, chips, inputs. The only round thing in the product is a radio dot. Do not introduce rounded cards.

**Panes are capped, not tinted.** Each pane is white with a 1px `--rule-300` border and a 3px colored top rule that names its voice: blue for the rubric/answer key, green for reference materials, yellow for a hint pane, purple for the student's work, teal for the deep dive. The question pane is not capped — it is outlined in 2px brand orange, which is what makes it read as the primary surface. Pane shadow is `--shadow-pane`; the question pane carries the slightly heavier `--shadow-section`.

**Color is assignment, not decoration.** Five voices, each with one job:

| Voice | Owns |
| --- | --- |
| Orange `--orange-600` | Masthead, active breadcrumb, the one primary button per screen. Never used for error. |
| Blue `--blue-600` | Rubric, points earned, credited answers, ✓ marks. |
| Green `--green-500` | Reference materials only. |
| Yellow `--yellow-500` | Hints only. Every yellow surface costs the student something. |
| Purple `--purple-600` | The student's own work: answer field, options, feedback, deep dive. |

Maroon `--maroon-600` #8a2f3f carries points lost, incorrect verdicts and eliminated options — cool enough never to be read as the brand orange, because a lost point is a correction and not an alarm. Clay `--clay-600` #8c4530 is the ↻ revisit mark: come back to this, the point is still available. Amber is gone — the warm lane is now brand orange only. Teal appears only as one accent rule inside the deep dive.

**Type.** Bungee is the wordmark and nothing else. Passion One sets pane titles, scores and overlay titles at 22–32px; it is used at display sizes only, never for prose. Source Sans 3 does all reading and all controls. STIX Two Math is reserved for set mathematics. **Body copy never goes below 16px** — chrome (breadcrumb 13px, counts 12px, eyebrows 12px, the plate caption 10px) is the only exception, and never for content a student must read to answer. Eyebrows are 12px, 700 weight, uppercase, `.15em` tracking.

**Backgrounds and imagery.** Paper white plates on a `--paper-100` desk; chrome bars in `--paper-050`. Graphics are the question's own data — a scatterplot, a table — drawn as inline SVG on a `--purple-tint-05` field with a `--purple-rule` border, axis labels in `--purple-500`. Influence points and other called-out marks are yellow. There is no photography, no illustration, no gradient, and no texture anywhere in the product.

**Depth and transparency.** Shadows are wide, soft, and low-opacity (`0 12px 30px rgba(20,40,50,.07)`), read as paper lift rather than elevation levels. The feedback card is the one purple-cast shadow. Transparency appears only as flat color tints (`--purple-tint-06`) and the modal scrim (`--scrim`); there is no blur, no glass, no protection gradient.

**States.** Selection is a 2px purple border plus a filled radio dot plus a bolder label — never a background wash. Disabled is a desaturated fill (`--action-primary-disabled`) with `cursor: not-allowed`, not opacity. Eliminated/struck content is maroon ink with a line-through and ~55% opacity. Hover darkens a fill by one step (`--action-primary-bg-hover`) and does nothing else — no lift, no shadow change. Press has no separate treatment. Secondary actions are underlined text links (3px underline offset), never outlined buttons. Quiet actions are white with a `--rule-400` border and `--ink-500` label. There is no motion in the system: no transitions, no fades, no bounces, no easing. State changes are instant, because the product's rhythm is read-decide-see.

**Overlays.** Two, both square-cornered and both full-bleed within their region: the study map drops under the breadcrumb across the full width over a `--scrim`; the deep dive covers the entire frame below the breadcrumb (all three panes) — it must be full-frame, because at the center pane's ~664px it cannot fit its content without scrolling.

## Content fundamentals

**Second person, present tense, imperative.** "Read the stem before the options." "Pull a hint only if you need one." The product talks to the student as a coach mid-session, never about them.

**Name the error; don't judge the student.** Feedback says what the reading did, not that the student failed: "'will score' turns a prediction about averages into a guarantee about one student." Corrections open with `Fix:` or `Next time:`. The mark for a missed point is ↻ ("revisit", clay), never ✕ — the ✕ exists only in Open Hand, where the *teacher's* hand takes a point back.

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

## The mark

**The name, set in Bungee, IS the mark.** Use the `Wordmark` component; never retype it by hand, because the ink changes with the ground and that is the part people get wrong:

| Ground | Ink | Token |
| --- | --- | --- |
| Brand orange `--orange-600` (the masthead) | White | `--wordmark-on-brand` |
| White or paper | `--orange-700` #ca3500 | `--wordmark-on-light` |
| `--ink-900`, or a solid plate over imagery | White | `--wordmark-on-dark` |
| Print, mono, low-fidelity output | `--ink-900` | `--wordmark-mono` |

**#ca3500 is the only orange dark enough to be ink.** `--orange-500` #ff6900 reads about 2.3:1 on white and `--orange-600` #f54900 about 3.5:1 — both fail as type on a light ground, even at display size. On photography or any busy ground, set the white wordmark on a solid `--orange-600` or `--ink-900` plate rather than directly on the image; there is no outline, scrim or shadow treatment for the mark.

Never: shadow it, outline it, stack it over two lines, letter-space it beyond `--type-wordmark-tracking`, set it in two colours, put it in a box or a circle, or set it below 16px.

### About an actual logo

There isn't one, and I won't invent it — a drawn apple, a monogram or anything else I produced would be a guess that consumers of this system would then treat as the brand. A type-set wordmark is a legitimate permanent answer (it is what ships today and it works at every size), so the decision is genuinely open:

- **Keep the wordmark as the mark.** No further work; it is already tokenised for every ground.
- **Commission or supply a mark.** Drop the files into `assets/logo.svg` (plus a mono variant) and tell me the clear-space and minimum-size rules; I will wire it into `Wordmark` as a lockup, replace the masthead's type, and rebuild the project tile. An SVG with the type as outlines is ideal — it removes the Bungee webfont dependency from the mark.

Until a file exists, every `Wordmark` call renders type, and that is the correct behaviour rather than a placeholder.

## Iconography

There is no icon library in the product and none should be added. The system uses three things:

1. **Typographic glyphs** for status and navigation: ✓ (credit), ✕ (take the point — Open Hand only), ↻ (revisit), ? (hint), ▸ ▼ (disclosure), ⌂ (home), · (separator), — (no score yet).
2. **Two 24×24 stroke SVGs**, inline, `stroke-width` 1.9, round caps, `currentColor`: a camera (attach hand-drawn work, used in `AnswerField`) and a copy/duplicate mark (copy the deep dive, used in `DeepDiveOverlay`). They also live as files in `assets/icons/`. **These two are reconstructions from the written style guide, not the original files** — the source SVGs were not supplied. Replace them if the originals exist.
3. **Data SVG** — the question's chart, drawn per question from coordinates. No chart library.

If a genuine icon need appears, match that inline stroke style (1.9–2px, round caps, `currentColor`, 24px box) rather than importing a set. No emoji. No PNG icons exist.

## Fonts

Bungee, Passion One, Source Sans 3 and STIX Two Math.

`tokens/fonts.css` here still `@import`s them from Google Fonts. **The app does
not** — `web/src/styles/tokens/fonts.css` carries real `@font-face` rules against
binaries in `web/src/styles/fonts/` (latin and latin-ext, ~790KB).

That is not a cosmetic difference. Measured with the families falling back to
system sans, four panes overflowed the 1440×900 frame. A network-loaded font is
a layout dependency, so anything that ships to students self-hosts.

## Status

Built: tokens, this guide, 24 foundation cards, the nine component families (19
components), and the five screens — all running as an app in `web/`.

**This supersedes `docs/product/CRAMAPPLE_VISUAL_IDENTITY_BRIEF_v2.md`**, which
describes a different system (warm emerald green, Plus Jakarta Sans + JetBrains
Mono, dark-first, gold for full marks). Per David, this design system wins. The
replacement brief is `docs/new_design/`. Dark mode was retired on 2026-09-21 —
do not reconstruct one by inverting these tokens; the voice colours will not
survive it.

Known gaps to resolve with the team: the type stack is treated as the brand
stack but has not been confirmed; there is no logo file; the two stroke icons
are reconstructions; the sample content in `web/src/content/sample/` is
hand-written and has not been through the authoring pipeline; everything is
validated against AP Statistics Unit 2 only, not AP Biology; and the upcoming
surfaces — blog templates, the Stripe enrollment funnel, hand-drawn image
capture, and the marketing home page — have no tokens or components here yet,
because none of those screens were available to extract from.
