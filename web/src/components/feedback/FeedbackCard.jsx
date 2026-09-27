import React from 'react';
import { VerdictChip } from './VerdictChip.jsx';
import { ScoreChip } from '../pane/ScoreChip.jsx';

export function FeedbackCard({ verdict, earned, total, coaching, hintsUsed = [], marks, submitted, submittedLabel = 'Your answer' }) {
  return (
    <div style={{
      background: 'var(--surface-feedback)', border: '1px solid var(--purple-rule)',
      borderTop: 'var(--border-cap) solid var(--cap-work)', borderRadius: 'var(--radius-all)', boxShadow: 'var(--shadow-feedback)'
    }}>
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 'var(--space-4)', padding: '14px var(--pane-pad-x) 10px' }}>
        <span style={{ display: 'flex', alignItems: 'center', gap: 'var(--space-3)' }}>
          <span style={{
            fontSize: 'var(--type-eyebrow-size)', fontWeight: 'var(--type-eyebrow-weight)', letterSpacing: 'var(--type-eyebrow-tracking)',
            textTransform: 'uppercase', color: 'var(--text-eyebrow)'
          }}>Feedback</span>
          {verdict && <VerdictChip verdict={verdict} />}
        </span>
        {typeof total === 'number' && <ScoreChip earned={earned} total={total} size="lg" />}
      </div>
      {coaching && <p style={{
        margin: '0 var(--pane-pad-x) 14px', fontSize: 'var(--type-body-size)', lineHeight: 'var(--type-body-line)', color: 'var(--text-body)'
      }}>{coaching}</p>}
      {marks && <div style={{ margin: '0 var(--pane-pad-x) 14px', display: 'grid', gap: '8px' }}>{marks}</div>}
      {submitted && (
        <div style={{ background: 'var(--paper-000)', borderTop: '1px solid var(--purple-rule)', padding: '12px var(--pane-pad-x)' }}>
          <span style={{
            display: 'block', marginBottom: '4px', fontSize: 'var(--type-eyebrow-size)', fontWeight: 'var(--type-eyebrow-weight)',
            letterSpacing: 'var(--type-eyebrow-tracking)', textTransform: 'uppercase', color: 'var(--text-eyebrow)'
          }}>{submittedLabel}</span>
          <p style={{ margin: 0, fontSize: 'var(--type-body-size)', lineHeight: 'var(--type-body-line)', color: 'var(--text-secondary)' }}>{submitted}</p>
        </div>
      )}
      {hintsUsed.length > 0 && (
        <div style={{
          display: 'flex', alignItems: 'center', gap: 'var(--space-2)', flexWrap: 'wrap',
          borderTop: '1px solid var(--purple-rule)', padding: '9px var(--pane-pad-x)'
        }}>
          <span style={{
            fontSize: 'var(--type-eyebrow-size)', fontWeight: 'var(--type-eyebrow-weight)', letterSpacing: 'var(--type-eyebrow-tracking)',
            textTransform: 'uppercase', color: 'var(--text-eyebrow)'
          }}>Hints used</span>
          {hintsUsed.map((h, i) => (
            <span key={i} style={{
              fontSize: 'var(--type-count-size)', fontWeight: 'var(--type-count-weight)', color: 'var(--text-hint)',
              background: 'var(--yellow-050)', border: '1px solid var(--yellow-300)', borderRadius: 'var(--radius-all)',
              padding: 'var(--chip-pad-y) var(--chip-pad-x)'
            }}>{h}</span>
          ))}
        </div>
      )}
    </div>
  );
}
