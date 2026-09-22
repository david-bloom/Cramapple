One-line: the white, square-cornered, 3px-capped pane that every region of a 1440×900 CramApple plate is built from.

```jsx
<PaneShell voice="rubric" eyebrow="Scoring" title="Rubric" right={<ScoreChip earned={3} total={4} />}>
  {criteria}
</PaneShell>
```

Variants: `voice` picks the cap colour — blue `rubric`, green `reference`, purple `work`, yellow `hint`, teal `deepdive`. `voice="question"` is the primary surface: no cap, 2px red border, heavier shadow. Panes never scroll — size content to fit or cut copy.
