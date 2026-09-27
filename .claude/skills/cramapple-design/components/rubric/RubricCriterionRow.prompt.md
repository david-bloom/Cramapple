One-line: a single rubric criterion with its mark and its point value — the row that makes scoring nameable.

```jsx
<RubricCriterionRow code="E2" state="revisit" label="Interprets slope in context"
  detail="Per extra hour studied, predicted score rises 4.1 points." />
```

Marks: ✓ earned, ↻ revisit (never ✕ in Practice — a missed point is a revisit), ✕ only in Open Hand where the teacher's hand takes a point back, · pending. Pass `interactive` in Open Hand so the student can move the score.
