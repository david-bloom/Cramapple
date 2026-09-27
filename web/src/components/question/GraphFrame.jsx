import React from 'react';

/**
 * `fill` lets the frame take whatever its grid row has left instead of sitting
 * at a fixed height above dead space. Pass `height` for a fixed box, `fill` when
 * the row should decide.
 */
export function GraphFrame({ caption, source, children, height, fill = false }) {
  return (
    <figure style={{
      margin: 0,
      ...(fill ? { minHeight: 0, display: 'flex', flexDirection: 'column' } : {})
    }}>
      <div style={{
        background: 'var(--surface-graph)', border: '1px solid var(--rule-graph)', borderRadius: 'var(--radius-all)',
        padding: 'var(--space-3)', height, display: 'flex', alignItems: 'center', justifyContent: 'center',
        ...(fill ? { flex: '1 1 auto', minHeight: 0 } : {})
      }}>{children}</div>
      {(caption || source) && (
        <figcaption style={{
          display: 'flex', justifyContent: 'space-between', gap: 'var(--space-3)', marginTop: '6px',
          fontSize: 'var(--type-count-size)', lineHeight: 'var(--type-count-line)', color: 'var(--text-secondary)'
        }}>
          <span>{caption}</span>
          {source && <span style={{ color: 'var(--text-quiet)' }}>{source}</span>}
        </figcaption>
      )}
    </figure>
  );
}
