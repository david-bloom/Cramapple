import React from 'react';

export function VerdictChip({ verdict }) {
  const correct = verdict === 'Correct' || verdict === 'correct';
  return (
    <span style={{
      display: 'inline-block', fontFamily: 'var(--font-body)', fontSize: 'var(--type-control-size)', lineHeight: 'var(--type-control-line)',
      fontWeight: 700, letterSpacing: '.04em', textTransform: 'uppercase', borderRadius: 'var(--radius-all)',
      padding: '5px 12px',
      color: correct ? 'var(--paper-000)' : 'var(--paper-000)',
      background: correct ? 'var(--status-correct)' : 'var(--status-incorrect)',
      border: `1px solid ${correct ? 'var(--blue-700)' : 'var(--maroon-700)'}`
    }}>{correct ? 'Correct' : 'Incorrect'}</span>
  );
}
