import React from 'react';
import { useEscapeToClose } from '../../lib/useEscapeToClose.js';

export function StudyMap({ open = false, unit, topics = [], onClose, onPick }) {
  useEscapeToClose(open, onClose);
  if (!open) return null;
  return (
    <div style={{ position: 'absolute', inset: 'calc(var(--masthead-height) + var(--breadcrumb-height)) 0 0 0', background: 'var(--surface-scrim)', zIndex: 20 }} onClick={onClose}>
      <div onClick={(e) => e.stopPropagation()} style={{
        background: 'var(--surface-overlay)', borderBottom: '1px solid var(--rule-400)', boxShadow: 'var(--shadow-overlay)',
        padding: '20px var(--gutter) 24px'
      }}>
        <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', marginBottom: 'var(--space-4)' }}>
          <span style={{ display: 'flex', alignItems: 'baseline', gap: 'var(--space-3)' }}>
            <span style={{ fontSize: 'var(--type-eyebrow-size)', fontWeight: 'var(--type-eyebrow-weight)', letterSpacing: 'var(--type-eyebrow-tracking)', textTransform: 'uppercase', color: 'var(--text-eyebrow)' }}>Study map</span>
            <h2 style={{ margin: 0, fontFamily: 'var(--font-display)', fontSize: 'var(--type-pane-title-size)', lineHeight: 'var(--type-pane-title-line)', fontWeight: 700 }}>{unit}</h2>
          </span>
          <button type="button" onClick={onClose} style={{
            background: 'none', border: 0, cursor: 'pointer', fontSize: 'var(--type-control-size)', fontWeight: 600,
            color: 'var(--action-link-fg)', textDecoration: 'underline', textUnderlineOffset: 'var(--underline-offset)', textDecorationThickness: 'var(--underline-thickness)'
          }}>Close map</button>
        </div>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, minmax(0,1fr))', gap: 'var(--pane-gap)' }}>
          {topics.map((t, i) => (
            <div key={i} onClick={() => onPick && onPick(t)} style={{
              background: t.current ? 'var(--orange-050)' : 'var(--surface-pane)',
              border: t.current ? '2px solid var(--orange-700)' : '1px solid var(--rule-300)',
              borderTop: t.current ? '2px solid var(--orange-700)' : 'var(--border-cap) solid var(--rule-400)',
              borderRadius: 'var(--radius-all)', padding: '12px 14px', cursor: 'pointer'
            }}>
              <span style={{ display: 'block', fontSize: 'var(--type-count-size)', fontWeight: 700, letterSpacing: '.06em', color: 'var(--text-eyebrow)' }}>{t.code}</span>
              <span style={{ display: 'block', margin: '2px 0 8px', fontSize: 'var(--type-body-size)', lineHeight: 'var(--type-body-line)', fontWeight: 'var(--type-body-strong-weight)', color: 'var(--text-body)' }}>{t.title}</span>
              <span style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 'var(--space-2)' }}>
                <span style={{ fontSize: 'var(--type-count-size)', color: 'var(--text-secondary)' }}>{t.done} of {t.total} done</span>
                <span style={{ display: 'inline-flex', gap: '3px' }}>
                  {Array.from({ length: t.total }).map((_, k) => (
                    <span key={k} style={{ width: '8px', height: '8px', background: k < t.done ? 'var(--blue-600)' : 'var(--rule-300)' }} />
                  ))}
                </span>
              </span>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
