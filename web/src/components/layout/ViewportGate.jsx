import React from 'react';
import { Wordmark } from '../navigation/Wordmark.jsx';

// Must track --plate-width / --plate-height in tokens/spacing.css -- the
// plate is a fixed frame that never reflows, so below this the three panes
// cannot all be shown at once.
const MIN_WIDTH = 1440;
const MIN_HEIGHT = 900;

function readViewport() {
  return { width: window.innerWidth, height: window.innerHeight };
}

export function ViewportGate({ children }) {
  const [viewport, setViewport] = React.useState(readViewport);

  React.useEffect(() => {
    const onResize = () => setViewport(readViewport());
    window.addEventListener('resize', onResize);
    return () => window.removeEventListener('resize', onResize);
  }, []);

  const tooSmall = viewport.width < MIN_WIDTH || viewport.height < MIN_HEIGHT;
  if (!tooSmall) return children;

  return (
    <div style={{
      minHeight: '100vh', display: 'flex', alignItems: 'center', justifyContent: 'center',
      background: 'var(--surface-desk)', padding: 'var(--space-6)'
    }}>
      <div style={{
        maxWidth: 420, width: '100%', background: 'var(--surface-pane)',
        border: 'var(--border-question)', boxShadow: 'var(--shadow-section)',
        padding: 'var(--space-7) var(--space-6)'
      }}>
        <Wordmark tone="on-light" style={{ display: 'block', marginBottom: 'var(--space-5)' }} />
        <span style={{
          display: 'block', marginBottom: 6, fontSize: 'var(--type-eyebrow-size)', fontWeight: 'var(--type-eyebrow-weight)',
          letterSpacing: 'var(--type-eyebrow-tracking)', textTransform: 'uppercase', color: 'var(--text-eyebrow)'
        }}>Screen too small</span>
        <h1 style={{
          margin: '0 0 12px', fontFamily: 'var(--font-display)', fontWeight: 'var(--type-pane-title-weight)',
          fontSize: 'var(--type-pane-title-size)', lineHeight: 'var(--type-pane-title-line)', color: 'var(--text-body)'
        }}>Widen your window</h1>
        <p style={{ margin: '0 0 16px', fontSize: 'var(--type-body-size)', lineHeight: 'var(--type-body-line)', color: 'var(--text-secondary)' }}>
          CramApple shows scoring, the question, and reference material at once, so it needs at least {MIN_WIDTH} by {MIN_HEIGHT} pixels. Make the browser window bigger, or switch to a larger screen.
        </p>
        <p style={{ margin: 0, fontSize: 'var(--type-count-size)', lineHeight: 'var(--type-count-line)', color: 'var(--text-quiet)' }}>
          Current window: {viewport.width} × {viewport.height}
        </p>
      </div>
    </div>
  );
}
