One-line: the yellow hint block — the only place yellow is allowed, because every yellow surface costs the student something.

```jsx
<HintGate name="Show me the rubric" cost="This reveals all four scoring criteria before you answer."
  state={s} onAsk={()=>set('asking')} onConfirm={()=>set('open')} onCancel={()=>set('idle')} onHide={hide}>
  <RubricList />
</HintGate>
```

Rules: cost is surfaced before disclosure; backing out is as easy as continuing; the open state collapses to a "Hint used · …" receipt that never disappears and is repeated in the feedback card's hints-used strip.
