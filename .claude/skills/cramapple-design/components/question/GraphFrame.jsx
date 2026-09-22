import React from 'react';

export function GraphFrame({ caption, source, children, height }) {
  return (
    <figure style={{ margin: 0 }}>
      <div style={{
        background: 'var(--surface-graph)', border: '1px solid var(--rule-graph)', borderRadius: 'var(--radius-all)',
        padding: 'var(--space-3)', height, display: 'flex', alignItems: 'center', justifyContent: 'center'
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
