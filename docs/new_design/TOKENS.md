# Token contract

`styles.css` is the only entry point. It is an `@import` list and nothing else; everything it reaches ships to consumers.

```
styles.css
├── tokens/fonts.css       Google Fonts import for the four families
├── tokens/colors.css      Raw scales — brand, voices, ink, paper, rules
├── tokens/typography.css  Families and every type role
├── tokens/spacing.css     Plate frame, three-pane grid, spacing scale, pane padding
├── tokens/elevation.css   Borders, accent rules, shadows, the square-corner rule
└── tokens/semantic.css    Aliases — THIS is the contract
```

## Rules

**Consume the aliases, not the scales.** Write `var(--text-earned)`, not `var(--blue-600)`. The scales can be re-tuned; the aliases are the promise.

**Never hardcode a hex.** If a value is missing, add a token rather than inlining.

**`--radius-all` is `0px` and `--radius-dot` is `50%`.** These are the only two radii. The dot is for the MCQ radio and nothing else.

**`--motion-duration` is `0ms` and `--motion-easing` is `step-end`.** They exist so nobody invents a transition. Do not change them to add "polish".

**16px floor.** `--type-body-size` is the smallest size any content a student must read may use. The sub-16px roles (`--type-breadcrumb-size` 13px, `--type-count-size` 12px, `--type-eyebrow-size` 12px, `--type-caption-size` 10px) are chrome only.

## The colour assignment

| Token | Hex | Owns — and nothing else |
| --- | --- | --- |
| `--orange-600` | #f54900 | Masthead ground, question-pane outline |
| `--orange-700` | #ca3500 | The one primary action, active breadcrumb, the mark on light grounds |
| `--blue-600` | #1f56a8 | Rubric, points earned, credited answers, ✓ |
| `--green-500` | #2f9c67 | Reference materials |
| `--yellow-500` | #edb90d | Hints — and every yellow surface costs the student something |
| `--purple-600` | #5f43ba | The student's own work: answer field, options, feedback, deep dive |
| `--maroon-600` | #8a2f3f | Points lost, incorrect verdicts, eliminated options |
| `--clay-600` | #8c4530 | The ↻ revisit mark |
| `--teal-500` | #2a8a92 | One accent rule inside the deep dive |

Orange is never an error colour. Yellow is never decoration. Nothing else may be introduced into the warm lane.

## Wordmark inks

| Ground | Token | Value |
| --- | --- | --- |
| Brand orange | `--wordmark-on-brand` | white |
| White or paper | `--wordmark-on-light` | #ca3500 — the only orange dark enough to be ink (~5.2:1) |
| Ink-900 or a plate over imagery | `--wordmark-on-dark` | white |
| Print / mono | `--wordmark-mono` | #16202a |
