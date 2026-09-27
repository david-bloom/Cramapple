const { Plate, PlateGrid, PaneShell, ScoreChip, Masthead, Breadcrumb, StudyMap, RubricCriterionRow, QuestionHeader, GraphFrame, ActionRow, ActionButton, DeepDiveOverlay } = window.CramAppleDesignSystem_c1541a;
const ohfEyebrow = { display: 'block', marginBottom: 5, fontSize: 'var(--type-eyebrow-size)', fontWeight: 'var(--type-eyebrow-weight)', letterSpacing: 'var(--type-eyebrow-tracking)', textTransform: 'uppercase', color: 'var(--text-eyebrow)' };
const ohfBody = { margin: 0, fontSize: 'var(--type-body-size)', lineHeight: 'var(--type-body-line)', color: 'var(--text-secondary)' };
const ohfList = { margin: 0, padding: '0 0 0 18px', fontSize: 'var(--type-body-size)', lineHeight: 'var(--type-body-line)', color: 'var(--text-secondary)', display: 'grid', gap: 4 };
const eyebrow = ohfEyebrow, body = ohfBody, list = ohfList;
const OHF_CRITERIA = [
  { code: 'E1', label: 'Names both variables', detail: 'Hours studied predicts final exam score.' },
  { code: 'E2', label: 'Reads the slope as a rate', detail: 'Per one additional hour studied.' },
  { code: 'E3', label: 'Says predicted mean, not actual', detail: 'The line predicts an average, not one student.' },
  { code: 'E4', label: 'States the units', detail: '4.1 points on the final exam.' }
];

function OpenHandFRQ() {
  const [awarded, setAwarded] = React.useState([true, true, true, true]);
  const [map, setMap] = React.useState(false);
  const [deep, setDeep] = React.useState(false);
  const earned = awarded.filter(Boolean).length;
  const toggle = (i) => setAwarded(a => a.map((v, k) => k === i ? !v : v));

  return (
    <Plate caption="CramApple · AP Statistics · Unit 2 · 2.3 Least-Squares Regression · Open Hand">
      <Masthead course="AP Statistics" right={<span style={{ fontSize: 13, fontWeight: 700, letterSpacing: '.12em', textTransform: 'uppercase', color: 'var(--paper-000)' }}>Open Hand</span>} />
      <Breadcrumb items={['Unit 2', '2.3 Least-Squares Regression', 'Question 4']} mapOpen={map} onOpenMap={() => setMap(m => !m)} right="Question 4 of 12" />
      <PlateGrid>
        <PaneShell voice="rubric" eyebrow="Face-up" title="Rubric" right={<ScoreChip earned={earned} total={4} />} style={{ height: '100%' }}>
          <p style={{ ...body, marginBottom: 14 }}>Every point is face-up. Take one back to see what the answer loses.</p>
          <div style={{ display: 'grid', gap: 10 }}>
            {OHF_CRITERIA.map((c, i) => (
              <RubricCriterionRow key={c.code} code={c.code} label={c.label} detail={c.detail}
                state={awarded[i] ? 'earned' : 'taken'} interactive onToggle={() => toggle(i)} />
            ))}
          </div>
          <p style={{ ...body, marginTop: 14, color: 'var(--text-quiet)', fontSize: 'var(--type-count-size)' }}>Click a criterion to take the point back. ✕ is the teacher's hand — in Practice a missed point is ↻.</p>
        </PaneShell>

        <PaneShell voice="question" eyebrow="Question" title="Interpreting slope" right={<ScoreChip earned={earned} total={4} label="Score" />} style={{ height: '100%' }}>
          <div style={{ display: 'grid', gap: 14, height: '100%', minHeight: 0, gridTemplateRows: 'auto auto minmax(0,1fr) auto' }}>
            <QuestionHeader topic="2.3 Least-Squares Regression" mode="Open Hand" points={4}
              stem={<>The least-squares line for predicting final exam score from hours studied per week is <span style={{ fontFamily: 'var(--font-math)' }}>ŷ = 42.6 + 4.1x</span>. Interpret the slope in the context of this study.</>} />
            <GraphFrame caption="Hours studied per week vs. final exam score" source="n = 15">
              <svg viewBox="0 0 640 200" width="100%" height="188" role="img" aria-label="Scatterplot of hours studied against final exam score">
        <line x1="54" y1="168" x2="616" y2="168" stroke="var(--purple-500)" strokeWidth="1.5" />
        <line x1="54" y1="168" x2="54" y2="14" stroke="var(--purple-500)" strokeWidth="1.5" />
        <line x1="70" y1="156" x2="600" y2="34" stroke="var(--purple-600)" strokeWidth="2" />
        {[[86,150],[122,146],[158,132],[194,134],[230,118],[266,112],[302,108],[338,96],[374,88],[410,84],[446,70],[482,66],[518,54],[554,48],[590,40]].map(([x, y], i) => (<circle key={i} cx={x} cy={y} r="4.5" fill="var(--purple-500)" />))}
        <circle cx="566" cy="140" r="6" fill="var(--yellow-500)" stroke="var(--yellow-700)" strokeWidth="1.5" />
        <text x="574" y="136" fontSize="11" fill="var(--yellow-700)" fontFamily="var(--font-body)" fontWeight="700">influence</text>
        <text x="335" y="190" textAnchor="middle" fontSize="12" fill="var(--purple-500)" fontFamily="var(--font-body)">Hours studied per week</text>
        <text x="16" y="92" textAnchor="middle" fontSize="12" fill="var(--purple-500)" fontFamily="var(--font-body)" transform="rotate(-90 16 92)">Final exam score</text>
      </svg>
            </GraphFrame>
            <div style={{ background: 'var(--surface-work)', border: '1px solid var(--purple-rule)', borderTop: 'var(--border-cap) solid var(--cap-work)', padding: '14px 16px' }}>
              <span style={eyebrow}>Credited response</span>
              <p style={{ margin: 0, fontSize: 'var(--type-option-size)', lineHeight: 'var(--type-option-line)' }}>
                <span style={{ background: awarded[1] ? 'var(--blue-050)' : 'transparent', textDecoration: awarded[1] ? 'none' : 'line-through', color: awarded[1] ? 'var(--text-body)' : 'var(--status-eliminated)' }}>For each additional hour studied per week,</span>{' '}
                <span style={{ background: awarded[2] ? 'var(--blue-050)' : 'transparent', textDecoration: awarded[2] ? 'none' : 'line-through', color: awarded[2] ? 'var(--text-body)' : 'var(--status-eliminated)' }}>the predicted mean</span>{' '}
                <span style={{ background: awarded[0] ? 'var(--blue-050)' : 'transparent', textDecoration: awarded[0] ? 'none' : 'line-through', color: awarded[0] ? 'var(--text-body)' : 'var(--status-eliminated)' }}>final exam score</span>{' '}increases by 4.1{' '}
                <span style={{ background: awarded[3] ? 'var(--blue-050)' : 'transparent', textDecoration: awarded[3] ? 'none' : 'line-through', color: awarded[3] ? 'var(--text-body)' : 'var(--status-eliminated)' }}>points</span>.
              </p>
              <p style={{ ...body, marginTop: 8, fontSize: 'var(--type-count-size)' }}>Highlight shows which rubric point each phrase is carrying.</p>
            </div>
            <ActionRow note="Nothing is scored in Open Hand"
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
            <p style={body}>Formula sheet gives ŷ = a + bx and b = r(s<sub>y</sub>/s<sub>x</sub>). Context is not on the sheet — you supply it.</p>
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
      <DeepDiveOverlay open={deep} title="Why slope is a mean, not a promise" onClose={() => setDeep(false)} onCopy={() => {}} sections={[
  { title: 'The claim', body: 'A slope of 4.1 says that among students like these, the predicted mean final exam score is 4.1 points higher for each additional hour studied per week. It is a statement about the line, not about any one student.' },
  { title: 'The trap', body: '“Will score 4.1 points higher” promises an individual an outcome. The regression line has no individuals in it — the residuals hold everything it missed, and for a single student that gap is often larger than the slope.' },
  { title: 'The habit', body: 'Write it in four moves: per one extra hour (rate), the predicted mean final exam score (response, as a mean), increases by 4.1 (magnitude), points (units). Four moves, four rubric points.' }
]} />
    </Plate>
  );
}
