import React from 'react';

export function DeepDiveOverlay({ open = false, eyebrow = 'Deep dive', title, sections = [], onClose, onCopy }) {
  if (!open) return null;
  return (
    <div style={{ position: 'absolute', inset: 'calc(var(--masthead-height) + var(--breadcrumb-height)) 0 0 0', background: 'var(--surface-scrim)', zIndex: 30, display: 'flex' }}>
      <div style={{
        flex: 1, margin: 'var(--space-5) var(--gutter) var(--space-6)', background: 'var(--surface-overlay)',
        border: '1px solid var(--rule-400)', borderTop: 'var(--border-cap) solid var(--cap-deepdive)',
        borderRadius: 'var(--radius-all)', boxShadow: 'var(--shadow-overlay)', display: 'flex', flexDirection: 'column', minHeight: 0
      }}>
        <div style={{ display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between', gap: 'var(--space-5)', padding: '18px var(--space-7) 14px', borderBottom: '1px solid var(--rule-divider)' }}>
          <div>
            <span style={{ fontSize: 'var(--type-eyebrow-size)', fontWeight: 'var(--type-eyebrow-weight)', letterSpacing: 'var(--type-eyebrow-tracking)', textTransform: 'uppercase', color: 'var(--text-eyebrow)' }}>{eyebrow}</span>
            <h2 style={{ margin: '4px 0 0', fontFamily: 'var(--font-display)', fontWeight: 'var(--type-overlay-title-weight)', fontSize: 'var(--type-overlay-title-size)', lineHeight: 'var(--type-overlay-title-line)' }}>{title}</h2>
          </div>
          <div style={{ display: 'flex', alignItems: 'center', gap: 'var(--space-5)' }}>
            {onCopy && (
              <button type="button" onClick={onCopy} style={{
                display: 'inline-flex', alignItems: 'center', gap: '8px', background: 'var(--action-quiet-bg)', border: 'var(--border-quiet)',
                borderRadius: 'var(--radius-all)', padding: '9px 14px', cursor: 'pointer', color: 'var(--action-quiet-fg)',
                fontSize: 'var(--type-control-size)', fontWeight: 'var(--type-control-weight)', fontFamily: 'var(--font-body)'
              }}>
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.9" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
                  <path d="M8.6 3.6h11.8v11.8H8.6z" /><path d="M15.4 20.4H3.6V8.6" />
                </svg>
                Copy deep dive
              </button>
            )}
            <button type="button" onClick={onClose} style={{
              background: 'none', border: 0, cursor: 'pointer', color: 'var(--action-link-fg)', fontSize: 'var(--type-control-size)',
              fontWeight: 'var(--type-control-weight)', textDecoration: 'underline', textUnderlineOffset: 'var(--underline-offset)', textDecorationThickness: 'var(--underline-thickness)'
            }}>Back to the question</button>
          </div>
        </div>
        <div style={{ flex: '1 1 auto', minHeight: 0, padding: '20px var(--space-7)', display: 'grid', gridTemplateColumns: `repeat(${Math.min(sections.length, 3) || 1}, minmax(0,1fr))`, gap: 'var(--space-7)' }}>
          {sections.map((s, i) => (
            <div key={i} style={{ borderLeft: 'var(--border-cap) solid var(--teal-500)', paddingLeft: 'var(--space-4)' }}>
              <h3 style={{ margin: '0 0 8px', fontSize: 'var(--type-body-size)', lineHeight: 'var(--type-body-line)', fontWeight: 700, color: 'var(--text-body)' }}>{s.title}</h3>
              <div style={{ fontSize: 'var(--type-body-size)', lineHeight: 'var(--type-body-line)', color: 'var(--text-secondary)' }}>{s.body}</div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
