const { Plate, PlateGrid, PaneShell, ScoreChip, Masthead, Breadcrumb, StudyMap, RadioOptionRow, QuestionHeader, ActionRow, ActionButton, HintGate, FeedbackCard, VerdictChip, DeepDiveOverlay } = window.CramAppleDesignSystem_c1541a;
const pmEyebrow = { display: 'block', marginBottom: 5, fontSize: 'var(--type-eyebrow-size)', fontWeight: 'var(--type-eyebrow-weight)', letterSpacing: 'var(--type-eyebrow-tracking)', textTransform: 'uppercase', color: 'var(--text-eyebrow)' };
const pmBody = { margin: 0, fontSize: 'var(--type-body-size)', lineHeight: 'var(--type-body-line)', color: 'var(--text-secondary)' };
const pmList = { margin: 0, padding: '0 0 0 18px', fontSize: 'var(--type-body-size)', lineHeight: 'var(--type-body-line)', color: 'var(--text-secondary)', display: 'grid', gap: 4 };
const eyebrow = pmEyebrow, body = pmBody, list = pmList;
const PM_OPTIONS = [
  { letter: 'A', text: 'Students who study one more hour per week score 4.1 points higher on the final.', verdict: 'distractor',
    why: 'Drops “predicted” and “mean”, so it promises every individual student the same 4.1 points.', fix: 'Say the predicted mean score, not what students score.' },
  { letter: 'B', text: 'For each additional hour studied per week, the predicted mean final exam score increases by 4.1 points.', verdict: 'correct',
    why: 'Names both variables, reads the slope as a rate, keeps the response a predicted mean, and carries the units.' },
  { letter: 'C', text: 'Studying one more hour per week causes final exam scores to rise by 4.1 points.', verdict: 'distractor',
    why: 'Observational data cannot support a causal claim; the line only describes association.', fix: 'Reserve “causes” for randomised experiments.' },
  { letter: 'D', text: 'The mean final exam score for these students is 4.1 points.', verdict: 'distractor',
    why: 'Reads the slope as if it were a centre. 4.1 is a rate of change, not a mean score.', fix: 'Slope answers “per one more x”, never “on average, y is”.' }
];

function Screen() {
  const [picked, setPicked] = React.useState(null);
  const [hint, setHint] = React.useState('idle');
  const [submitted, setSubmitted] = React.useState(false);
  const [map, setMap] = React.useState(false);
  const [deep, setDeep] = React.useState(false);
  const eliminated = hint === 'open' ? ['A', 'D'] : [];
  const correct = picked === 'B';
  const hintsUsed = hint === 'open' ? ['Rule out two choices'] : [];

  return (
    <Plate caption="CramApple · AP Statistics · Unit 2 · 2.3 Least-Squares Regression · Practice">
      <Masthead course="AP Statistics" right={<span style={{ fontSize: 13, fontWeight: 700, letterSpacing: '.12em', textTransform: 'uppercase', color: 'var(--paper-000)' }}>Practice</span>} />
      <Breadcrumb items={['Unit 2', '2.3 Least-Squares Regression', 'Question 7']} mapOpen={map} onOpenMap={() => setMap(m => !m)} right="Question 7 of 12" />
      <PlateGrid>
        <PaneShell voice={submitted ? 'rubric' : 'hint'} eyebrow="Scoring" title={submitted ? 'Answer Key' : 'Elimination'}
          right={<ScoreChip earned={submitted ? (correct ? 1 : 0) : null} total={1} />} style={{ height: '100%' }}>
          {submitted ? (
            <div style={{ display: 'grid', gap: 10 }}>
              {PM_OPTIONS.map(o => {
                const isRight = o.verdict === 'correct';
                return (
                  <div key={o.letter} style={{ background: 'var(--surface-pane)', border: '1px solid var(--rule-300)', borderLeft: `var(--border-cap) solid ${isRight ? 'var(--blue-600)' : picked === o.letter ? 'var(--clay-600)' : 'var(--rule-400)'}`, padding: '10px 12px' }}>
                    <span style={{ display: 'flex', alignItems: 'baseline', gap: 8 }}>
                      <span style={{ fontSize: 16, fontWeight: 700, color: isRight ? 'var(--text-earned)' : picked === o.letter ? 'var(--text-revisit)' : 'var(--text-quiet)' }}>{isRight ? '✓' : picked === o.letter ? '↻' : '·'}</span>
                      <span style={{ fontSize: 'var(--type-body-size)', fontWeight: 700 }}>{o.letter}</span>
                      <span style={{ fontSize: 'var(--type-body-size)', lineHeight: 'var(--type-body-line)', color: 'var(--text-secondary)' }}>{isRight ? 'Credited' : o.fix}</span>
                    </span>
                  </div>
                );
              })}
            </div>
          ) : (
            <div style={{ display: 'grid', gap: 16 }}>
              <p style={body}>One point. One submission. The key stays closed until you commit.</p>
              <HintGate name="Rule out two choices" cost="This strikes out two distractors and is listed on your feedback."
                state={hint} onAsk={() => setHint('asking')} onConfirm={() => setHint('open')} onCancel={() => setHint('idle')} onHide={() => setHint('idle')}>
                <p style={body}>A and D are struck out in the question pane. Two remain — one of them names a cause the data cannot support.</p>
              </HintGate>
              <div style={{ borderTop: '1px solid var(--rule-divider)', paddingTop: 14 }}>
                <span style={eyebrow}>How points are earned</span>
                <ul style={list}><li>Read the stem before the options.</li><li>Name the rate, then the response.</li><li>Check the response is a mean.</li></ul>
              </div>
              <div>
                <span style={eyebrow}>How points are lost</span>
                <ul style={list}><li>Picking the first plausible wording.</li><li>Accepting a causal verb.</li><li>Reading slope as a centre.</li></ul>
              </div>
            </div>
          )}
        </PaneShell>

        <PaneShell voice="question" eyebrow="Question" title="Reading a slope" right={<ScoreChip earned={submitted ? (correct ? 1 : 0) : null} total={1} label="Score" />} style={{ height: '100%' }}>
          <div style={{ display: 'grid', gap: 16, height: '100%', minHeight: 0, gridTemplateRows: 'auto minmax(0,1fr) auto auto' }}>
            <QuestionHeader topic="2.3 Least-Squares Regression" mode="Practice" points={1}
              stem={<>A least-squares line predicting final exam score from hours studied per week has slope 4.1. Which statement interprets the slope correctly?</>} />
            <div style={{ display: 'grid', gap: 10, alignContent: 'start', minHeight: 0 }}>
              {(submitted ? PM_OPTIONS.filter(o => o.verdict === 'correct' || o.letter === picked) : PM_OPTIONS).map(o => (
                <RadioOptionRow key={o.letter} letter={o.letter} selected={picked === o.letter} verdict={o.verdict} showVerdict={submitted}
                  eliminated={!submitted && eliminated.includes(o.letter)} onSelect={() => setPicked(o.letter)}>
                  {o.text}
                </RadioOptionRow>
              ))}
              {submitted && !correct && <p style={{ margin: 0, fontSize: 'var(--type-count-size)', color: 'var(--text-quiet)' }}>The two options you did not pick are explained in the Answer Key.</p>}
            </div>
            {submitted ? (
              <FeedbackCard verdict={correct ? 'correct' : 'incorrect'} earned={correct ? 1 : 0} total={1} hintsUsed={hintsUsed}
                coaching={correct
                  ? 'Right, and for the right reason: predicted mean, per one extra hour, in points. Keep all four moves when you write it out on an FRQ.'
                  : `You picked ${picked}. ${PM_OPTIONS.find(o => o.letter === picked).why} Next time: check that the response is a predicted mean before you check the number.`} />
            ) : <span />}
            <ActionRow note={submitted ? 'One point · scored' : picked ? 'Ready to submit' : 'Pick one answer'}
              primary={submitted
                ? <ActionButton variant="primary">Next question</ActionButton>
                : <ActionButton variant="primary" disabled={!picked} onClick={() => setSubmitted(true)}>Submit answer</ActionButton>}
              secondary={submitted
                ? <ActionButton variant="link" onClick={() => setDeep(true)}>Open the deep dive</ActionButton>
                : <ActionButton variant="link">Skip for now</ActionButton>} />
          </div>
        </PaneShell>

        <PaneShell voice="reference" eyebrow="Allowed" title="Reference Materials" style={{ height: '100%' }}>
        <div style={{ display: 'grid', gap: 18 }}>
          <div>
            <span style={eyebrow}>Topic</span>
            <p style={body}>2.3 Least-Squares Regression — using a fitted line to predict a quantitative response.</p>
          </div>
          <div>
            <span style={eyebrow}>Skills</span>
            <ul style={list}>
              <li>2.D — Interpret slope and intercept in context.</li>
              <li>2.B — Describe form, direction and strength from a scatterplot.</li>
              <li>4.B — Distinguish association from causation.</li>
            </ul>
          </div>
          <div>
            <span style={eyebrow}>Vocabulary</span>
            <ul style={list}>
              <li><strong>Slope</strong> — change in the predicted mean response per one-unit change in x.</li>
              <li><strong>Predicted value</strong> — ŷ, the line's estimate, never an individual's actual score.</li>
              <li><strong>Explanatory variable</strong> — x, here hours studied.</li>
            </ul>
          </div>
          <div style={{ borderTop: '1px solid var(--rule-divider)', paddingTop: 12 }}>
            <span style={eyebrow}>On the exam</span>
            <p style={body}>Formula sheet gives ŷ = a + bx. Context is not on the sheet — you supply it.</p>
          </div>
        </div>
      </PaneShell>
      </PlateGrid>
      <StudyMap open={map} unit="Unit 2 · Exploring Two-Variable Data" onClose={() => setMap(false)} topics={[
  { code: '2.1', title: 'Two Categorical Variables', done: 6, total: 6 },
  { code: '2.2', title: 'Scatterplots & Correlation', done: 4, total: 7 },
  { code: '2.3', title: 'Least-Squares Regression', done: 3, total: 8, current: true },
  { code: '2.4', title: 'Residuals & Departures', done: 0, total: 5 }
]} />
      <DeepDiveOverlay open={deep} title="Three ways a slope sentence fails" onClose={() => setDeep(false)} onCopy={() => {}} sections={[
        { title: 'Promising an individual', body: 'The line predicts a mean. Any sentence that tells one student what they will score has left the model behind.' },
        { title: 'Claiming a cause', body: 'These data are observational. The slope describes association only.' },
        { title: 'Confusing rate with centre', body: 'Slope answers “per one more hour”, never “on average, what do students score?”.' }
      ]} />
    </Plate>
  );
}
