import React from 'react';

export function RadioOptionRow({ letter, children, selected = false, verdict, showVerdict = false, eliminated = false, explanation, note, onSelect, readCount }) {
  const isCorrect = verdict === 'correct';
  const tag = showVerdict && verdict
    ? (isCorrect
      ? { text: 'Correct', fg: 'var(--status-correct)', bg: 'var(--blue-050)', bd: 'var(--blue-100)' }
      : { text: 'Distractor', fg: 'var(--status-incorrect)', bg: 'var(--maroon-050)', bd: 'var(--maroon-300)' })
    : null;
  return (
    <div
      role="radio"
      aria-checked={selected}
      aria-disabled={eliminated || undefined}
      tabIndex={eliminated ? -1 : 0}
      onClick={eliminated ? undefined : onSelect}
      onKeyDown={eliminated ? undefined : (e) => {
        if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); onSelect && onSelect(); }
      }}
      style={{
        display: 'block', width: '100%', textAlign: 'left', background: 'var(--surface-pane)',
        border: selected ? 'var(--border-selected)' : '1px solid var(--rule-300)',
        borderRadius: 'var(--radius-all)', padding: '12px var(--row-pad-x)',
        cursor: eliminated ? 'not-allowed' : 'pointer', opacity: eliminated ? 'var(--strike-opacity)' : 1
      }}
    >
      <div style={{ display: 'flex', alignItems: 'flex-start', gap: 'var(--space-3)' }}>
        <span aria-hidden="true" style={{
          flex: '0 0 auto', width: '18px', height: '18px', marginTop: '3px', borderRadius: 'var(--radius-dot)',
          border: selected ? '2px solid var(--status-selected-border)' : '2px solid var(--rule-400)',
          display: 'inline-flex', alignItems: 'center', justifyContent: 'center'
        }}>
          {selected && <span style={{ width: '8px', height: '8px', borderRadius: 'var(--radius-dot)', background: 'var(--status-selected-dot)' }} />}
        </span>
        <span style={{
          flex: '0 0 auto', fontFamily: 'var(--font-body)', fontWeight: 700, fontSize: 'var(--type-option-size)',
          lineHeight: 'var(--type-option-line)', color: eliminated ? 'var(--status-eliminated)' : 'var(--text-secondary)', width: '16px'
        }}>{letter}</span>
        <span style={{
          flex: '1 1 auto', fontSize: 'var(--type-option-size)', lineHeight: 'var(--type-option-line)',
          fontWeight: selected ? 'var(--type-body-strong-weight)' : 400,
          color: eliminated ? 'var(--status-eliminated)' : 'var(--text-body)',
          textDecoration: eliminated ? 'line-through' : 'none'
        }}>{children}</span>
        {tag && <span style={{
          flex: '0 0 auto', fontSize: 'var(--type-count-size)', fontWeight: 'var(--type-count-weight)', letterSpacing: '.06em',
          textTransform: 'uppercase', color: tag.fg, background: tag.bg, border: `1px solid ${tag.bd}`,
          padding: 'var(--chip-pad-y) var(--chip-pad-x)', borderRadius: 'var(--radius-all)'
        }}>{tag.text}</span>}
      </div>
      {explanation && (
        <div style={{ marginTop: '10px', marginLeft: '46px', borderLeft: `var(--border-cap) solid ${isCorrect ? 'var(--blue-600)' : 'var(--maroon-500)'}`, paddingLeft: '12px' }}>
          <p style={{ margin: 0, fontSize: 'var(--type-body-size)', lineHeight: 'var(--type-body-line)', color: 'var(--text-secondary)' }}>{explanation}</p>
          {note && <p style={{ margin: '6px 0 0', fontSize: 'var(--type-body-size)', lineHeight: 'var(--type-body-line)', color: 'var(--text-body)' }}>
            <strong style={{ fontWeight: 'var(--type-body-strong-weight)' }}>Fix:</strong> {note}</p>}
          {typeof readCount === 'number' && <p style={{ margin: '6px 0 0', fontSize: 'var(--type-count-size)', color: 'var(--text-quiet)' }}>Read {readCount} of 4</p>}
        </div>
      )}
    </div>
  );
}
