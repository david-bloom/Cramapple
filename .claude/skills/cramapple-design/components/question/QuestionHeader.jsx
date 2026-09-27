import React from 'react';

export function QuestionHeader({ eyebrow = 'Question', topic, number, total, stem, points, mode }) {
  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: '10px' }}>
      <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', gap: 'var(--space-4)' }}>
        <span style={{ display: 'flex', alignItems: 'baseline', gap: 'var(--space-3)' }}>
          <span style={{
            fontSize: 'var(--type-eyebrow-size)', fontWeight: 'var(--type-eyebrow-weight)', letterSpacing: 'var(--type-eyebrow-tracking)',
            textTransform: 'uppercase', color: 'var(--text-eyebrow)'
          }}>{eyebrow}</span>
          {topic && <span style={{ fontSize: 'var(--type-count-size)', fontWeight: 600, color: 'var(--text-quiet)' }}>{topic}</span>}
        </span>
        <span style={{ display: 'flex', alignItems: 'baseline', gap: 'var(--space-3)' }}>
          {mode && <span style={{
            fontSize: 'var(--type-count-size)', fontWeight: 700, letterSpacing: '.08em', textTransform: 'uppercase',
            color: 'var(--text-work)', background: 'var(--purple-tint-06)', border: '1px solid var(--purple-rule)', padding: 'var(--chip-pad-y) var(--chip-pad-x)'
          }}>{mode}</span>}
          {typeof points === 'number' && <span style={{ fontSize: 'var(--type-count-size)', fontWeight: 600, color: 'var(--text-secondary)' }}>{points} {points === 1 ? 'point' : 'points'}</span>}
          {number && <span style={{ fontSize: 'var(--type-count-size)', fontWeight: 600, color: 'var(--text-quiet)' }}>{number} of {total}</span>}
        </span>
      </div>
      <p style={{ margin: 0, fontSize: 'var(--type-question-size)', lineHeight: 'var(--type-question-line)', color: 'var(--text-body)', textWrap: 'pretty' }}>{stem}</p>
    </div>
  );
}
