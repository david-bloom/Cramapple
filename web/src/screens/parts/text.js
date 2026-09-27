/**
 * The three text roles the panes reuse. They are plain style objects rather
 * than CSS classes so a screen can spread and adjust one inline, the same way
 * the design templates do.
 */

export const eyebrow = {
  display: 'block',
  marginBottom: 5,
  fontSize: 'var(--type-eyebrow-size)',
  fontWeight: 'var(--type-eyebrow-weight)',
  letterSpacing: 'var(--type-eyebrow-tracking)',
  textTransform: 'uppercase',
  color: 'var(--text-eyebrow)'
};

export const body = {
  margin: 0,
  fontSize: 'var(--type-body-size)',
  lineHeight: 'var(--type-body-line)',
  color: 'var(--text-secondary)'
};

export const list = {
  margin: 0,
  padding: '0 0 0 18px',
  fontSize: 'var(--type-body-size)',
  lineHeight: 'var(--type-body-line)',
  color: 'var(--text-secondary)',
  display: 'grid',
  gap: 4
};

export const count = {
  fontSize: 'var(--type-count-size)',
  lineHeight: 'var(--type-count-line)',
  color: 'var(--text-quiet)'
};
