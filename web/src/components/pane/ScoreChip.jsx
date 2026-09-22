import React from 'react';

const TONES = {
  earned: { fg: 'var(--text-earned)', bg: 'var(--blue-050)', bd: 'var(--blue-100)' },
  lost: { fg: 'var(--text-lost)', bg: 'var(--maroon-050)', bd: 'var(--maroon-300)' },
  neutral: { fg: 'var(--text-secondary)', bg: 'var(--paper-050)', bd: 'var(--rule-300)' }
};

export function ScoreChip({ earned = null, total, tone, label, size = 'md' }) {
  const t = TONES[tone || (earned === null ? 'neutral' : earned === total ? 'earned' : 'lost')];
  const big = size === 'lg';
  return (
    <span style={{ display: 'inline-flex', alignItems: 'baseline', gap: 'var(--space-2)' }}>
      {label && <span style={{
        fontSize: 'var(--type-eyebrow-size)', fontWeight: 'var(--type-eyebrow-weight)', letterSpacing: 'var(--type-eyebrow-tracking)',
        textTransform: 'uppercase', color: 'var(--text-eyebrow)'
      }}>{label}</span>}
      <span style={{
        fontFamily: 'var(--font-display)', fontWeight: 'var(--type-score-weight)',
        fontSize: big ? 'var(--type-score-size)' : '22px', lineHeight: big ? 'var(--type-score-line)' : '24px',
        color: t.fg, background: t.bg, border: `1px solid ${t.bd}`, borderRadius: 'var(--radius-all)',
        padding: big ? '2px 12px' : '1px 9px', whiteSpace: 'nowrap'
      }}>{earned === null ? '—' : earned} / {total}</span>
    </span>
  );
}
