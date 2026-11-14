import React from 'react';

/**
 * A quiet five-point "was this helpful?" control for the feedback card.
 *
 * Added to the system on purpose (2026-11-14): the product had no rating
 * control. It uses only existing tokens and the square-corner rule, no icons,
 * no emoji, no motion. Digits 1-5 with plain end labels, never stars or faces.
 * It sits at chrome scale (12px) because it is not content a student needs to
 * read to answer. Once a value is chosen it is replaced by a static line;
 * the choice is final for the attempt so the signal stays clean.
 */
export function FeedbackRating({ value = null, onRate }) {
  const eyebrow = {
    fontSize: 'var(--type-eyebrow-size)', fontWeight: 'var(--type-eyebrow-weight)', letterSpacing: 'var(--type-eyebrow-tracking)',
    textTransform: 'uppercase', color: 'var(--text-eyebrow)'
  };
  const quiet = { fontSize: 'var(--type-count-size)', color: 'var(--text-quiet)' };

  if (value) {
    return (
      <div style={{ display: 'flex', alignItems: 'center', gap: 'var(--space-3)' }}>
        <span style={eyebrow}>Helpful?</span>
        <span style={quiet}>Thanks · {value} of 5</span>
      </div>
    );
  }

  return (
    <div role="group" aria-label="How helpful was this feedback, 1 to 5" style={{ display: 'flex', alignItems: 'center', gap: 'var(--space-3)', flexWrap: 'wrap' }}>
      <span style={eyebrow}>Helpful?</span>
      <span style={{ display: 'flex', alignItems: 'center', gap: 'var(--space-3)', flexWrap: 'nowrap' }}>
        <span style={quiet}>Not at all</span>
        <span style={{ display: 'flex', gap: 'var(--space-1)' }}>
          {[1, 2, 3, 4, 5].map((n) => (
            <button
              key={n}
              type="button"
              aria-label={`${n} of 5`}
              onClick={() => onRate && onRate(n)}
              style={{
                width: '30px', height: '26px', padding: 0, cursor: 'pointer',
                fontFamily: 'var(--font-body)', fontSize: 'var(--type-count-size)', fontWeight: 'var(--type-count-weight)',
                color: 'var(--text-quiet)', background: 'var(--paper-000)', border: '1px solid var(--rule-400)', borderRadius: 'var(--radius-all)'
              }}
            >{n}</button>
          ))}
        </span>
        <span style={quiet}>Very</span>
      </span>
    </div>
  );
}
