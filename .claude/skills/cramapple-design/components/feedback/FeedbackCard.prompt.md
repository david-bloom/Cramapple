One-line: the purple-cast card that closes a Practice attempt — the only purple shadow in the system.

```jsx
<FeedbackCard verdict="incorrect" earned={2} total={4}
  coaching="'will score' turns a prediction about averages into a guarantee about one student. Fix: say 'predicted mean score'."
  hintsUsed={['Rubric', 'Rule out two choices']}
  submitted="The slope means every extra hour of study will raise a score by 4.1 points."
  marks={criterionRows} />
```

Never shown in Open Hand — Open Hand has nothing to submit. Keep the coaching to three sentences so the plate does not need to scroll.

**Where it goes.** The card is a sibling of the content it comments on, in its own `auto` row directly above the action row — never stacked *inside* the pane's `minmax(0,1fr)` content track. Put it there and a plate whose option rows or answer field have grown will push the card and the primary action past the frame, where `overflow: hidden` clips them and the student has no way forward. On MCQ, do not also expand every option's explanation on submit: the left pane's Answer Key already states each one.
