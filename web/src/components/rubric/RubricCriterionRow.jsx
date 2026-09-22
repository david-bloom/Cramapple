import React from 'react';

const MARKS = {
  earned: { glyph: '✓', fg: 'var(--text-earned)', bg: 'var(--blue-050)', bd: 'var(--blue-100)' },
  revisit: { glyph: '↻', fg: 'var(--text-revisit)', bg: 'var(--clay-050)', bd: 'var(--clay-300)' },
  taken: { glyph: '✕', fg: 'var(--text-lost)', bg: 'var(--maroon-050)', bd: 'var(--maroon-300)' },
  pending: { glyph: '·', fg: 'var(--text-quiet)', bg: 'var(--paper-050)', bd: 'var(--rule-300)' }
};

export function RubricCriterionRow({ code, label, detail, state = 'pending', points = 1, interactive = false, onToggle }) {
  const m = MARKS[state] || MARKS.pending;
  return (
    <div
      role={interactive ? 'switch' : undefined}
      aria-checked={interactive ? state === 'earned' : undefined}
      aria-label={interactive ? `${label} — ${state === 'earned' ? 'point awarded' : 'point taken back'}` : undefined}
      tabIndex={interactive ? 0 : undefined}
      onClick={interactive ? onToggle : undefined}
      onKeyDown={interactive ? (e) => {
        if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); onToggle && onToggle(); }
      } : undefined}
      style={{
        display: 'flex', gap: 'var(--space-3)', alignItems: 'flex-start', width: '100%', textAlign: 'left',
        padding: 'var(--row-pad-y) var(--row-pad-x)', background: state === 'earned' ? 'var(--blue-050)' : 'var(--surface-pane)',
        border: '1px solid var(--rule-300)', borderLeft: `var(--border-cap) solid ${state === 'earned' ? 'var(--blue-600)' : state === 'taken' ? 'var(--maroon-600)' : state === 'revisit' ? 'var(--clay-600)' : 'var(--rule-400)'}`,
        borderRadius: 'var(--radius-all)', cursor: interactive ? 'pointer' : 'default'
      }}
    >
      <span aria-hidden="true" style={{
        flex: '0 0 auto', width: '24px', height: '24px', display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
        color: m.fg, background: m.bg, border: `1px solid ${m.bd}`, borderRadius: 'var(--radius-all)', fontSize: '15px', fontWeight: 700
      }}>{m.glyph}</span>
      <span style={{ flex: '1 1 auto', minWidth: 0 }}>
        <span style={{ display: 'flex', gap: 'var(--space-2)', alignItems: 'baseline' }}>
          {code && <span style={{ fontSize: 'var(--type-count-size)', fontWeight: 700, letterSpacing: '.06em', textTransform: 'uppercase', color: 'var(--text-eyebrow)' }}>{code}</span>}
          <span style={{ fontSize: 'var(--type-body-size)', lineHeight: 'var(--type-body-line)', fontWeight: 'var(--type-body-strong-weight)', color: 'var(--text-body)' }}>{label}</span>
        </span>
        {detail && <span style={{ display: 'block', marginTop: '2px', fontSize: 'var(--type-body-size)', lineHeight: 'var(--type-body-line)', color: 'var(--text-secondary)' }}>{detail}</span>}
      </span>
      <span style={{
        flex: '0 0 auto', fontFamily: 'var(--font-display)', fontWeight: 700, fontSize: '20px', lineHeight: '24px',
        color: state === 'earned' ? 'var(--text-earned)' : 'var(--text-quiet)'
      }}>{state === 'earned' ? points : '—'}/{points}</span>
    </div>
  );
}
