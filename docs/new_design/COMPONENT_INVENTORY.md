# Component inventory

Nine families, 19 exported components, five screens. Every family has a counterpart in the four working question templates — nothing here is a primitive a design system "usually" has.

### Components

Grouped by concern. Each directory holds `<Name>.jsx`, `<Name>.d.ts`, `<Name>.prompt.md` and one card HTML.

| Directory | Components |
| --- | --- |
| `components/pane/` | `Plate`, `PlateGrid`, `PaneShell`, `ScoreChip` |
| `components/hint/` | `HintGate` |
| `components/choice/` | `RadioOptionRow` |
| `components/rubric/` | `RubricCriterionRow` |
| `components/feedback/` | `FeedbackCard`, `VerdictChip` |
| `components/navigation/` | `Masthead`, `Wordmark`, `Breadcrumb`, `StudyMap` |
| `components/overlay/` | `DeepDiveOverlay` |
| `components/actions/` | `ActionRow`, `ActionButton` |
| `components/question/` | `QuestionHeader`, `GraphFrame`, `AnswerField` |

**Intentional additions.** Four names are not in the original nine-family list but were needed to build the plates without re-implementing chrome inside every kit: `Plate` / `PlateGrid` (the fixed 1440×900 frame and its three-column grid, previously inline in each template), `Masthead` (the 70px orange bar), `Wordmark` (the mark, so the on-light ink rule lives in one place), `ActionButton` (the four action treatments the action row composes), and `AnswerField` (the FRQ written-answer box). Nothing else was invented — there is no Toast, Avatar, Tabs or Tooltip here, because the product has none.

### UI kits

| Kit | Screen |
| --- | --- |
| `ui_kits/open-hand-frq/` | Rubric face-up and manipulable; taking a point strikes the matching phrase in the credited response. |
| `ui_kits/frq/` | Practice FRQ: rubric behind a hint gate, answer field, feedback card with the submitted work kept visible. |
| `ui_kits/open-hand-mcq/` | Answer key face-up; counts explanations read instead of scoring. |
| `ui_kits/mcq/` | Practice MCQ: elimination hint, one submission, then key + feedback. |
| `ui_kits/home/` | Home / study map — assembled from the same parts; not extracted from a source template. |

Each kit is `{README.md, index.html, screen.jsx}`. `index.html` loads `_ds_bundle.js` and mounts the screen; the screens compose the components above rather than re-implementing them.

## Where they live

The implementation lives in the design-system project (downloadable as a zip), organised as `components/<group>/<Name>.jsx` with a sibling `.d.ts` props contract and `.prompt.md` usage note, plus one specimen card HTML per directory.
