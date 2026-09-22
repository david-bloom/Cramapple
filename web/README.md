# Cramapple Web

The student practice frontend: the fixed 1440×900 three-pane question plate, in
both modes (Open Hand and Practice) and both item types (FRQ and MCQ), plus the
home / study map screen.

Built directly on the CramApple Design System — the tokens, the nineteen
components and the product rules all come from `docs/new_design/` and
`.claude/skills/cramapple-design/`. Nothing here restyles them.

## Run it

```bash
cd web
npm install
npm run dev          # http://localhost:5173
```

```bash
npm run build        # production bundle into dist/
npm run preview      # serve the built bundle on :4173
```

## The five screens

| Route | Screen |
| --- | --- |
| `/#/` | Home / study map — resume point, per-topic progress, the two modes explained |
| `/#/practice/<package_id>` | Practice FRQ or MCQ, chosen by the item's `item_type` |
| `/#/open-hand/<package_id>` | Open Hand FRQ or MCQ |

`HashRouter`, so a refresh works on any static host with no rewrite rules.

## Layout

```
src/
  components/      the design system, one directory per family, index.js is the barrel
  content/         the content layer -- sample/ holds hand-written AP Statistics items
  screens/         the five screens; parts/ holds what they share
  session/         attempts, hints and progress (localStorage), plus grading
  lib/             the inline scatterplot and small hooks
  styles/          styles.css (an @import list only), tokens/, fonts/
scripts/           browser checks that enforce the product's layout rules
```

## Product rules this code enforces

These are design rules, not preferences. Breaking one is a bug.

- **The plate is fixed at 1440×900 and never scrolls.** No region inside it
  scrolls or collapses. If content does not fit, cut copy or restructure — do
  not add a scrollbar. `npm run verify:panes` fails the build if any pane
  overflows, in any state of any screen.
- **The feedback card sits in its own `auto` row directly above the action row**,
  never inside the pane's `minmax(0,1fr)` content track. Inside the track, a
  grown answer field or option list pushes the card and the primary action past
  the frame, where `overflow: hidden` clips them and the student has no way
  forward.
- **A missed point is `↻` (revisit), never `✕`.** `✕` is the teacher's hand and
  exists only in Open Hand. `grade.js` can only ever return `earned` or
  `revisit`.
- **A hint is never free and never silent.** Idle → asking (the cost is named
  *before* disclosure, and backing out is as cheap as continuing) → open, which
  collapses to a receipt. The receipt never disappears — "Hide" folds the
  content away and leaves it standing — and every hint pulled is listed again on
  the feedback card.
- **In Practice, all disclosed help is costed help.** That includes the deep
  dive, which sits behind the same gate as the rubric rather than being a
  post-submit extra. How much help a student took, read against the score, is
  the mastery signal — so help that discloses silently would leave that signal
  incomplete. After submission the deep dive is free.
- **Reference materials are not help.** They are what a student may look up —
  topic, skills, vocabulary — so they stay visible and ungated throughout.
- **Body text never goes below 16px.** Chrome (breadcrumb 13, counts 12,
  eyebrows 12, caption 10) is the only exception, and never for content a
  student must read to answer.
- **Square corners, no motion.** Radius 0 everywhere; the only round thing is a
  radio dot. `--motion-duration` is `0ms` and `app.css` holds it there.
- **Colour is assignment, not decoration.** Orange is chrome and the single
  primary action, blue is rubric and points earned, green is reference material
  only, yellow is hints only, purple is the student's own work, maroon is points
  lost, clay is the `↻` mark.

## Checks

```bash
npm test                 # grading engine, incl. the voice rules (no "!", no praise)
npm run verify:panes     # no pane overflows, in 17 screen states
npm run verify:screens   # 73 interaction checks across all five screens
```

The two browser checks need a running preview and a Chromium:

```bash
npm run preview &
npx playwright install chromium      # once
npm run verify:panes
npm run verify:screens               # writes screenshots/ too
```

Set `PLAYWRIGHT_CHROMIUM` if Chromium is already on disk somewhere else, and
`BASE_URL` if the preview is not on `:4173`.

## Content

`src/content/` is a seam, not the content pipeline.

The six items under `src/content/sample/` are **hand-written for this Unit 2
walkthrough**. They did not come from the authoring pipeline in `prompts/`, they
carry no fact-pack refs and no provenance, and they have not been through
content review. They exist so the screens have something real to render.

The real items are the JSON packages under `content/item-packages/`. The sample
shape deliberately mirrors that schema (`package_id`, `item_type`, `taxonomy`,
`parts`/`criteria`, `mcq_choices`), so replacing these imports with a loader over
those packages is the intended next step.

Four fields are additions the screens need and the item-package schema does not
carry yet:

| Field | What it is for |
| --- | --- |
| `criteria[].match` / `.disqualify` | local grading — see below |
| `creditedResponse[]` | Open Hand's phrase-to-criterion mapping |
| `habits`, `reference`, `deepDive` | the panes around the question |
| `hints[]` | what each hint is called, what it costs, what it reveals |

## Grading is a stand-in

`src/session/grade.js` is deterministic regex matching against criterion
patterns. It is **not** the product's grader — that lives in
`supabase/functions/_shared/` (`grading-router`, `deterministic-verifier`,
`grading-partial-credit`) and should score real student work once this frontend
talks to a backend.

It is criterion-level and explainable on purpose, so the seam is obvious:
replace `gradeFrq()` with a call to the grading router and keep the return
shape. Everything downstream — the rubric marks, the coaching, the score chips,
the home plate's revisit line — reads that shape and nothing else.

## Fonts

Bungee, Passion One, Source Sans 3 and STIX Two Math are **self-hosted** from
`src/styles/fonts/` (latin and latin-ext subsets, ~790KB). The design system
loaded them from Google Fonts, which `HANDOFF.md` flags as a production gotcha:
if that request fails the wordmark silently falls back to system sans and every
plate reflows. It is not a cosmetic difference — measured against fallback
fonts, four panes overflowed the frame.

## Not built

- **No backend.** Session state is `localStorage` (`cramapple.session.v1`);
  `SessionProvider.jsx` has the two functions to replace.
- **No mastery signal.** Help taken and score are both recorded per attempt, but
  nothing derives mastery from them — that belongs with `student_cell_state` and
  is a pedagogy decision, not a frontend one.
- **No bring-your-own-question.** Practice serves a Cramapple question only.
  Camera and document upload are not built, and are not designed.
- **No auth, no enrollment, no payment.**
- **Desktop only.** The plate is a fixed 1440×900 frame by product rule; on a
  narrower viewport the desk scrolls around it rather than the plate reflowing.
  There is no responsive or mobile treatment, and inventing one would mean
  reopening the no-scroll rule.
- **Light only.** Dark mode was retired on 2026-09-21. Do not reconstruct one by
  inverting the tokens — the voice colours will not survive it.
- **AP Statistics Unit 2 only**, topics 2.2 and 2.3. The repo's primary subject
  is AP Biology, whose FRQs are longer and carry diagrammatic stimulus; the
  fixed no-scroll plate is exactly where that will bite. See the open question
  in `docs/new_design/README.md`.
