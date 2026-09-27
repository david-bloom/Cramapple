const { Plate, PlateGrid, PaneShell, ScoreChip, Masthead, Breadcrumb, StudyMap, RadioOptionRow, QuestionHeader, ActionRow, ActionButton, DeepDiveOverlay } = window.CramAppleDesignSystem_c1541a;
const ohmEyebrow = { display: 'block', marginBottom: 5, fontSize: 'var(--type-eyebrow-size)', fontWeight: 'var(--type-eyebrow-weight)', letterSpacing: 'var(--type-eyebrow-tracking)', textTransform: 'uppercase', color: 'var(--text-eyebrow)' };
const ohmBody = { margin: 0, fontSize: 'var(--type-body-size)', lineHeight: 'var(--type-body-line)', color: 'var(--text-secondary)' };
const ohmList = { margin: 0, padding: '0 0 0 18px', fontSize: 'var(--type-body-size)', lineHeight: 'var(--type-body-line)', color: 'var(--text-secondary)', display: 'grid', gap: 4 };
const eyebrow = ohmEyebrow, body = ohmBody, list = ohmList;
const OHM_OPTIONS = [
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
  const [picked, setPicked] = React.useState('B');
  const [read, setRead] = React.useState(['B']);
  const [map, setMap] = React.useState(false);
  const [deep, setDeep] = React.useState(false);
  const pick = (l) => { setPicked(l); setRead(r => r.includes(l) ? r : [...r, l]); };

  return (
    <Plate caption="CramApple · AP Statistics · Unit 2 · 2.3 Least-Squares Regression · Open Hand">
      <Masthead course="AP Statistics" right={<span style={{ fontSize: 13, fontWeight: 700, letterSpacing: '.12em', textTransform: 'uppercase', color: 'var(--paper-000)' }}>Open Hand</span>} />
      <Breadcrumb items={['Unit 2', '2.3 Least-Squares Regression', 'Question 7']} mapOpen={map} onOpenMap={() => setMap(m => !m)} right="Question 7 of 12" />
      <PlateGrid>
        <PaneShell voice="rubric" eyebrow="Face-up" title="Answer Key" right={<span style={{ fontSize: 'var(--type-count-size)', fontWeight: 600, color: 'var(--text-secondary)' }}>{read.length} of 4 read</span>} style={{ height: '100%' }}>
          <p style={{ ...body, marginBottom: 14 }}>Nothing is scored here. Read every explanation — three of these four are traps you will meet again.</p>
          <div style={{ display: 'grid', gap: 10 }}>
            {OHM_OPTIONS.map(o => {
              const isRead = read.includes(o.letter);
              const correct = o.verdict === 'correct';
              return (
                <div key={o.letter} onClick={() => pick(o.letter)} style={{
                  cursor: 'pointer', background: 'var(--surface-pane)', border: '1px solid var(--rule-300)',
                  borderLeft: `var(--border-cap) solid ${correct ? 'var(--blue-600)' : 'var(--maroon-600)'}`, padding: '10px 12px'
                }}>
                  <span style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', gap: 8 }}>
                    <span style={{ fontSize: 'var(--type-body-size)', fontWeight: 700, color: correct ? 'var(--text-earned)' : 'var(--text-lost)' }}>
                      {o.letter} · {correct ? 'Credited' : 'Distractor'}
                    </span>
                    <span style={{ fontSize: 'var(--type-count-size)', fontWeight: 600, color: isRead ? 'var(--text-earned)' : 'var(--text-quiet)' }}>{isRead ? '✓ read' : '· unread'}</span>
                  </span>
                  <span style={{ display: 'block', marginTop: 4, fontSize: 'var(--type-body-size)', lineHeight: 'var(--type-body-line)', color: 'var(--text-secondary)' }}>{correct ? 'Four moves, four ways to lose the point.' : o.fix}</span>
                </div>
              );
            })}
          </div>
          <p style={{ ...body, marginTop: 14, fontSize: 'var(--type-count-size)', color: 'var(--text-quiet)' }}>Selecting an option is free in Open Hand. It counts as reading, not as answering.</p>
        </PaneShell>

        <PaneShell voice="question" eyebrow="Question" title="Reading a slope" right={<span style={{ fontSize: 'var(--type-count-size)', fontWeight: 600, color: 'var(--text-secondary)' }}>Not scored</span>} style={{ height: '100%' }}>
          <div style={{ display: 'grid', gap: 16, height: '100%', minHeight: 0, gridTemplateRows: 'auto minmax(0,1fr) auto' }}>
            <QuestionHeader topic="2.3 Least-Squares Regression" mode="Open Hand" points={1}
              stem={<>A least-squares line predicting final exam score from hours studied per week has slope 4.1. Which statement interprets the slope correctly?</>} />
            <div style={{ display: 'grid', gap: 10, alignContent: 'start', minHeight: 0 }}>
              {OHM_OPTIONS.map(o => (
                <RadioOptionRow key={o.letter} letter={o.letter} selected={picked === o.letter} verdict={o.verdict} showVerdict
                  onSelect={() => pick(o.letter)} explanation={picked === o.letter ? o.why : undefined} note={picked === o.letter ? o.fix : undefined}>
                  {o.text}
                </RadioOptionRow>
              ))}
            </div>
            <ActionRow note={`${read.length} of 4 explanations read`}
              primary={<ActionButton variant="primary">Next question</ActionButton>}
              secondary={<ActionButton variant="link" onClick={() => setDeep(true)}>Open the deep dive</ActionButton>} />
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
        { title: 'Promising an individual', body: 'The line predicts a mean. Any sentence that tells one student what they will score has left the model behind — the residual for that student is usually bigger than the slope.' },
        { title: 'Claiming a cause', body: 'These data are observational. Hours studied is entangled with prior grades, sleep and course load; the slope describes association only.' },
        { title: 'Confusing rate with centre', body: 'Slope answers “per one more hour”. Intercept answers “at zero hours”. Neither answers “on average, what do students score?”.' }
      ]} />
    </Plate>
  );
}
