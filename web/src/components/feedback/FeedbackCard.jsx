import React from 'react';
import { VerdictChip } from './VerdictChip.jsx';
import { ScoreChip } from '../pane/ScoreChip.jsx';
import { FeedbackRating } from './FeedbackRating.jsx';

/**
 * `coaching` is the grader's composed feedback and is always the baseline: it
 * appears with the grade, instantly. `coach` is optional model-written
 * coaching that arrives after the grade ({ status: 'pending' | 'ready' | 'none',
 * text }). When it is ready it takes the place of the composed text in the same
 * slot; when it is pending or absent the composed text stays and the card never
 * shows an error or an apology. `onRate` is passed only where the feedback is
 * real, so an ungradable result shows no rating.
 */
export function FeedbackCard({ verdict, earned, total, coaching, coach, rating = null, onRate, hintsUsed = [], marks, submitted, submittedLabel = 'Your answer' }) {
  const coachReady = coach && coach.status === 'ready' && coach.text;
  const slotText = coachReady ? coach.text : coaching;
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
      {slotText && <p data-feedback-source={coachReady ? 'coaching' : 'composed'} style={{
        margin: '0 var(--pane-pad-x) 14px', fontSize: 'var(--type-body-size)', lineHeight: 'var(--type-body-line)', color: 'var(--text-body)'
      }}>{slotText}</p>}
      {coach && coach.status === 'pending' && (
        <p style={{ margin: '0 var(--pane-pad-x) 12px', fontSize: 'var(--type-count-size)', color: 'var(--text-quiet)' }}>Coaching on its way</p>
      )}
      {marks && <div style={{ margin: '0 var(--pane-pad-x) 14px', display: 'grid', gap: '8px' }}>{marks}</div>}
      {onRate && slotText && (
        <div style={{ margin: '0 var(--pane-pad-x) 12px' }}>
          <FeedbackRating value={rating} onRate={onRate} />
        </div>
      )}
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
