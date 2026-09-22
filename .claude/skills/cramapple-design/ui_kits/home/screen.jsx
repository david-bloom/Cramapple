const { Plate, PlateGrid, PaneShell, ScoreChip, Masthead, Breadcrumb, StudyMap, ActionRow, ActionButton } = window.CramAppleDesignSystem_c1541a;
const hEyebrow = { display: 'block', marginBottom: 5, fontSize: 'var(--type-eyebrow-size)', fontWeight: 'var(--type-eyebrow-weight)', letterSpacing: 'var(--type-eyebrow-tracking)', textTransform: 'uppercase', color: 'var(--text-eyebrow)' };
const hBody = { margin: 0, fontSize: 'var(--type-body-size)', lineHeight: 'var(--type-body-line)', color: 'var(--text-secondary)' };

const UNITS = [
  { code: '2.1', title: 'Two Categorical Variables', done: 6, total: 6, mode: 'Practice' },
  { code: '2.2', title: 'Scatterplots & Correlation', done: 4, total: 7, mode: 'Practice' },
  { code: '2.3', title: 'Least-Squares Regression', done: 3, total: 8, mode: 'Open Hand', current: true },
  { code: '2.4', title: 'Residuals & Departures', done: 0, total: 5, mode: 'Open Hand' },
  { code: '2.5', title: 'Correlation vs. Causation', done: 0, total: 4, mode: 'Open Hand' },
  { code: '2.6', title: 'Unit 2 Mixed Review', done: 0, total: 12, mode: 'Practice' }
];

function Screen() {
  const [map, setMap] = React.useState(false);
  const [topic, setTopic] = React.useState('2.3');
  const done = UNITS.reduce((s, u) => s + u.done, 0);
  const total = UNITS.reduce((s, u) => s + u.total, 0);

  return (
    <Plate caption="CramApple · AP Statistics · Unit 2 · Exploring Two-Variable Data">
      <Masthead course="AP Statistics" right={<span style={{ fontSize: 13, fontWeight: 700, letterSpacing: '.12em', textTransform: 'uppercase', color: 'var(--paper-000)' }}>Home</span>} />
      <Breadcrumb items={['Home', 'Unit 2 · Exploring Two-Variable Data']} mapOpen={map} onOpenMap={() => setMap(m => !m)} right={`${done} of ${total} questions done`} />
      <PlateGrid>
        <PaneShell voice="question" eyebrow="Where you left off" title="2.3 Least-Squares Regression" right={<ScoreChip earned={done} total={total} tone="neutral" label="Unit" />} style={{ height: '100%' }}>
          <div style={{ display: 'grid', gap: 16, height: '100%', minHeight: 0, gridTemplateRows: 'auto auto minmax(0,1fr) auto' }}>
            <p style={{ margin: 0, fontSize: 'var(--type-question-size)', lineHeight: 'var(--type-question-line)' }}>
              Question 4 — interpret the slope of a least-squares line in context.
            </p>
            <div style={{ background: 'var(--surface-work)', border: '1px solid var(--purple-rule)', borderTop: 'var(--border-cap) solid var(--cap-work)', padding: '12px 14px' }}>
              <span style={hEyebrow}>Last attempt</span>
              <p style={hBody}>3 of 4 points. The missed point was <strong style={{ color: 'var(--text-revisit)' }}>↻ says predicted mean, not actual</strong> — it is still available.</p>
            </div>
            <div>
              <span style={hEyebrow}>This unit's habits</span>
              <ul style={{ margin: 0, padding: '0 0 0 18px', display: 'grid', gap: 4, fontSize: 'var(--type-body-size)', lineHeight: 'var(--type-body-line)', color: 'var(--text-secondary)' }}>
                <li>Name both variables before you name a number.</li>
                <li>Keep the response a predicted mean.</li>
                <li>Say association until the design earns cause.</li>
              </ul>
            </div>
            <ActionRow note="Practice mode"
              primary={<ActionButton variant="primary">Resume question 4</ActionButton>}
              secondary={<ActionButton variant="link">Start the unit over</ActionButton>} />
          </div>
        </PaneShell>

        <PaneShell voice="rubric" eyebrow="Study map" title="Unit 2 · Exploring Two-Variable Data" right={<span style={{ fontSize: 'var(--type-count-size)', fontWeight: 600, color: 'var(--text-secondary)' }}>{done} of {total} done</span>} style={{ height: '100%' }}>
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12 }}>
            {UNITS.map(u => {
              const active = topic === u.code;
              return (
                <div key={u.code} onClick={() => setTopic(u.code)} style={{
                  cursor: 'pointer', background: active ? 'var(--orange-050)' : 'var(--surface-pane)',
                  border: active ? '2px solid var(--orange-500)' : '1px solid var(--rule-300)',
                  borderTop: active ? '2px solid var(--orange-700)' : 'var(--border-cap) solid var(--rule-400)', padding: '12px 14px'
                }}>
                  <span style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between' }}>
                    <span style={{ fontSize: 'var(--type-count-size)', fontWeight: 700, letterSpacing: '.06em', color: 'var(--text-eyebrow)' }}>{u.code}</span>
                    <span style={{ fontSize: 'var(--type-count-size)', fontWeight: 600, color: u.mode === 'Open Hand' ? 'var(--text-work)' : 'var(--text-secondary)' }}>{u.mode}</span>
                  </span>
                  <span style={{ display: 'block', margin: '3px 0 10px', fontSize: 'var(--type-option-size)', lineHeight: 'var(--type-option-line)', fontWeight: 600 }}>{u.title}</span>
                  <span style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 8 }}>
                    <span style={{ fontSize: 'var(--type-count-size)', color: 'var(--text-secondary)' }}>{u.done} of {u.total}</span>
                    <span style={{ display: 'inline-flex', gap: 3 }}>
                      {Array.from({ length: u.total }).map((_, k) => (<span key={k} style={{ width: 9, height: 9, background: k < u.done ? 'var(--blue-600)' : 'var(--rule-300)' }} />))}
                    </span>
                  </span>
                </div>
              );
            })}
          </div>
          <div style={{ marginTop: 16, borderTop: '1px solid var(--rule-divider)', paddingTop: 14, display: 'flex', alignItems: 'center', gap: 16 }}>
            <ActionButton variant="primary">Open {topic}</ActionButton>
            <ActionButton variant="link">See every unit</ActionButton>
            <span style={{ marginLeft: 'auto', fontSize: 'var(--type-count-size)', color: 'var(--text-quiet)' }}>Open Hand is free to explore · Practice is scored</span>
          </div>
        </PaneShell>

        <PaneShell voice="reference" eyebrow="How it works" title="Two modes" style={{ height: '100%' }}>
          <div style={{ display: 'grid', gap: 18 }}>
            <div>
              <span style={hEyebrow}>Open Hand</span>
              <p style={hBody}>Nothing is hidden. The rubric or answer key is face-up and you move it yourself to watch the score change. Nothing is scored.</p>
            </div>
            <div>
              <span style={hEyebrow}>Practice</span>
              <p style={hBody}>The same question with the scoring withheld. Pull a hint only if you need one — every hint is listed on your feedback.</p>
            </div>
            <div style={{ borderTop: '1px solid var(--rule-divider)', paddingTop: 14 }}>
              <span style={hEyebrow}>Marks</span>
              <ul style={{ margin: 0, padding: 0, listStyle: 'none', display: 'grid', gap: 7, fontSize: 'var(--type-body-size)', lineHeight: 'var(--type-body-line)', color: 'var(--text-secondary)' }}>
                <li><span style={{ color: 'var(--text-earned)', fontWeight: 700 }}>✓</span>&nbsp;&nbsp;point earned</li>
                <li><span style={{ color: 'var(--text-revisit)', fontWeight: 700 }}>↻</span>&nbsp;&nbsp;revisit — still available</li>
                <li><span style={{ color: 'var(--text-lost)', fontWeight: 700 }}>✕</span>&nbsp;&nbsp;Open Hand only: point taken back</li>
                <li><span style={{ color: 'var(--text-hint)', fontWeight: 700 }}>?</span>&nbsp;&nbsp;a hint, and what it costs</li>
              </ul>
            </div>
            <div style={{ borderTop: '1px solid var(--rule-divider)', paddingTop: 14 }}>
              <span style={hEyebrow}>Exam</span>
              <p style={hBody}>AP Statistics · May 2027. You have covered 2 of 9 units.</p>
            </div>
          </div>
        </PaneShell>
      </PlateGrid>
      <StudyMap open={map} unit="Unit 2 · Exploring Two-Variable Data" onClose={() => setMap(false)} topics={UNITS.slice(0, 4)} />
    </Plate>
  );
}
