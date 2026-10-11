# Session close 2026-10-11: app accessibility, consistency and colour pass

**Scope.** These changes cover app.cramapple.com only. The App repo is `david-bloom/ap-prep-blueprint`, which syncs to Lovable project `56cae479`. The marketing site cramapple.com (`61dd6602`) was explicitly out of scope, per David.

**State at close.**
- Everything below is merged to the App repo's `main` at `d7e85cb`, and CI passes there.
- **Not published in Lovable.** Publishing waits on David's signed-in check (see Open items).
- No Production database, migration or Lovable publish happened in this session.

## Trigger

On 2026-10-11 an accessibilitychecker.org audit of `app.cramapple.com/question` scored 60 and rated the page "high lawsuit risk". David supplied the PDF report. He then asked for three things:
1. fix the findings on `/question`;
2. review every other app page for similar issues and for consistency;
3. add colour to reduce the "beige wall", without compromising accessibility.

## Method

- Ran axe-core 4.10.2 (WCAG 2.0, 2.1 and 2.2 A/AA, plus best practice) in two ways:
  - live and signed out, on every app route;
  - locally, on every page and dev-harness state at 1440px and 375px.
- Signed-in pages were rendered in the dev harness from fixtures:
  - `/dev-qx-harness?state=hub-new`
  - `/dev-qx-harness?state=hub-building`
  - `/dev-qx-harness?state=notes`
  - the five `/question` states: practice, review, worked, FRQ practice and FRQ review.
- The hub harness fills the taxonomy and guide query caches, so every section renders without signing in.
- **Final result:** 13 pages and states, each at both widths, with 0 violations and no horizontal scroll.

## What changed, by PR

### PR #7: `/question` audit fixes (merged at `7bae82f`)

- **Landmarks:**
  - One `<main>` below the top bar, in both the question view and the notice view. This fixes `landmark-one-main` and `region`.
- **Answer choices:**
  - They are no longer `<li>` elements inside `role="radiogroup"`. This fixes `listitem`.
- **Subject picker label:**
  - It used `opacity: .6` (4.4:1). It now uses `--ink-500`.
- **Brand surface:**
  - David chose the darker top bar.
  - New token `--surface-brand` = `--orange-700`: white text on it is 4.9:1, where `--orange-600` gave 3.59:1.
  - Every white-on-orange surface now uses it.
- **Design reference:**
  - The board copies in `docs/design-reference/` were refreshed to canvas v18.
  - `colour_pass_2026_10_11.py` holds the board transform.

**PR #7 merged before its last three commits were pushed.** Those commits (`907eb9a`, `f63ae34`, `eb1fdbe`) went in with PR #8. Lesson: after pushing to an open PR, check `gh pr view --json mergedAt,headRefOid` before reporting the work as merged.

### PR #8: app-wide consistency and contrast, plus hub fixes (merged at `0a4e749`)

**One top bar across the app**
- `TopContextBar` (hub, progress, setup and session pages) now renders the same orange brand bar as `/question` and BYOQ, with the subject picker inside it.
- The picker that floated over page content in `_ux.tsx` is gone.
- Lesson Notes uses `StudyNav brand` (hub | change topic | subject).
  - Its view moved to `src/components/learn/LessonNotesView.tsx`.
  - The duplicate back link in the sheet is gone.
  - Its status and error states are inside `<main>`.

**Contrast tokens**

| Token | Was | Now | Failure it fixes |
|---|---|---|---|
| `--ca-accent-text` | orange-700 | orange-800 | 4.47:1 on the beige background |
| `--cv-text-subtle` | ink-400 | ink-500 | 3.19:1 |
| `--notes-core` | teal-500 | teal-600 | 4.07:1 |
| `--notes-brand` | orange-500 | orange-700 | 2.88:1 |

**Structure**
- Lesson Notes and Deep Dive headings now step down one level from the title: h1 → h2 on the page, h2 → h3 in the pop-up.
- `/tutor-login` now has an h1 and a labelled email field.
- Signed-out `/learn/...` used to go to the tutor login. It now goes to the student sign-in (`studentLoginHref`) and returns to the topic afterwards.
- The sign-in shell (`MarketingShell`) wraps on phones. `/join` and `/tutor-login` had scrolled 135px sideways.

**Hub (David's requests)**
- **Lesson Notes cards**, revisit reasons and study-action notes: 16px in ink-700 (were 14px in ink-500).
- **Curriculum categories**, each with a colour on both the legend and the cards:

| Category | Colour |
|---|---|
| Your class is here | Orange outline |
| Not scored yet (fewer than `POINT_CAPTURE_MIN_ITEMS` = 3 distinct items) | Purple |
| Scored | Blue |

  Before this, the legend promised a blue "evidence" state that no card ever showed.

### PR #9: colour pass (merged at `f22111e`)

**David's decisions:** desk, topic bar, pane headers, rubric rows and hub, yes. Subject accents, no.

**Desk**
- `--surface-desk` changes from beige `paper-100` to `--slate-050` (`#f4f6f9`).
- It applies to `/question` and both hub stages.

**`/question` topic bar**
- Tinted by mode: learn uses teal-050, practice uses purple-050.
- The mode chip is solid: white on teal-600 or purple-600.

**Pane headers**

| Pane | Tint | Eyebrow |
|---|---|---|
| Rubric | blue-050 | blue-700 |
| Question | orange-050 | orange-800 |
| Reference | green-050 | green-700 |

**Rubric rows**
- Earned: blue-050 with a blue-600 edge.
- Lost: maroon-050 with a maroon-600 edge.
- The correct MCQ key row is blue.
- The ✓ / ↻ marks remain, so meaning never depends on colour alone.

**Hub header strips**
- Each section has a tinted header strip and a 4px cap.
- Colours: week blue, how you worked purple, worth revisiting orange, curriculum green, Lesson Notes teal.
- The independent-share bar is now purple, to match practice.

## Colour rules

Each rule below was checked against measured contrast, and the last two are enforced by tests.
- **Tints carry colour; text stays dark.** Text on a 050 tint is ink-700/900 (9.7–15.5:1) or the hue's own 700/800 shade (6.8–8.9:1).
- **Never on a tint:** ink-500 on a 100 tint (3.9:1), yellow text (yellow-700 on yellow-050 is only 4.5:1), or any 500/600-shade text.
- **Edges and bars** use 600 shades: 4.7–7.1:1 on white or the desk, which passes the 3:1 non-text rule.
- **Orange-600** is for edges and fills only, never for text (3.6:1).
- **Colour never carries meaning alone.** Every coloured state also has a label or mark.

## Guardrails added

In `src/lib/__tests__/question-design-rules.test.ts`, three new blocks:
- `/question accessibility rules`
- `app-wide top bar and contrast`
- `student hub` and `colour pass`

Together they check:
- one `<main>`;
- no list items in the radiogroup;
- `--surface-brand` on every white-on-orange surface;
- that the app's pages use the brand bar, with no floating picker;
- the contrast-token values;
- no ink-400 reading text on the hub;
- hub text at 16px or larger, in ink-700 or darker;
- the curriculum colours on both the legend and the cards;
- the desk, topic bar, pane header and rubric row tints;
- **no CSS rule with a colour-tint background that sets ink-300..500 or a 500/600 hue as its text colour.**

`learn-topic-notes.test.tsx` requires h2 sections on the page and h3 in the pop-up. The App suite has 929 tests at close.

## Open items

1. **David's signed-in check, then a Lovable publish** (Hard Gate, David's approval):
   - **Hub:**
     - the brand bar and picker, including switching subjects;
     - the curriculum colours on real units;
     - the Lesson Notes cards;
     - the header strips.
   - **`/question`:**
     - the practice (purple) and learn (teal) topic bars;
     - the graded FRQ rubric rows.
   - **The Lesson Notes page.**
2. After the publish, re-run axe on the live site.
3. The hub page label ("AP Statistics | Home") is now the bar's accessible name rather than visible text, because only the wordmark is white on the orange. David has not ruled on whether it should be visible somewhere.
4. Subject accents were declined. If they are revisited, the proposed palette (Stats blue, Bio green, Chem teal, Calc purple, Physics clay, all 600 shades) passes as edges and swatches.
5. The marketing site was not reviewed; it is out of scope.
