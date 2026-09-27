import React from 'react';

const CAPS = { rubric: 'var(--cap-rubric)', reference: 'var(--cap-reference)', hint: 'var(--cap-hint)', work: 'var(--cap-work)', deepdive: 'var(--cap-deepdive)' };

export function PaneShell({ voice = 'plain', title, eyebrow, right, footer, padded = true, children, style }) {
  const isQuestion = voice === 'question';
  const cap = CAPS[voice];
  return (
    <section style={{
      display: 'flex', flexDirection: 'column', minHeight: 0, background: 'var(--surface-pane)',
      border: isQuestion ? 'var(--border-question)' : 'var(--border-pane)',
      ...(cap ? { borderTop: `var(--border-cap) solid ${cap}` } : {}),
      boxShadow: isQuestion ? 'var(--shadow-section)' : 'var(--shadow-pane)',
      borderRadius: 'var(--radius-all)', ...style
    }}>
      {(title || eyebrow || right) && (
        <header style={{
          display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', gap: 'var(--space-3)',
          padding: `14px var(--pane-pad-x) 10px`, borderBottom: '1px solid var(--rule-divider)'
        }}>
          <div style={{ display: 'flex', flexDirection: 'column', gap: '3px' }}>
            {eyebrow && <span style={{
              fontSize: 'var(--type-eyebrow-size)', lineHeight: 'var(--type-eyebrow-line)', fontWeight: 'var(--type-eyebrow-weight)',
              letterSpacing: 'var(--type-eyebrow-tracking)', textTransform: 'uppercase', color: 'var(--text-eyebrow)'
            }}>{eyebrow}</span>}
            {title && <h2 style={{
              margin: 0, fontFamily: 'var(--font-display)', fontWeight: 'var(--type-pane-title-weight)',
              fontSize: 'var(--type-pane-title-size)', lineHeight: 'var(--type-pane-title-line)', color: 'var(--text-body)'
            }}>{title}</h2>}
          </div>
          {right && <div style={{ flex: '0 0 auto' }}>{right}</div>}
        </header>
      )}
      <div style={{ flex: '1 1 auto', minHeight: 0, padding: padded ? 'var(--pane-pad-y) var(--pane-pad-x)' : 0 }}>{children}</div>
      {footer && <div style={{ borderTop: '1px solid var(--rule-divider)', padding: '12px var(--pane-pad-x)' }}>{footer}</div>}
    </section>
  );
}
