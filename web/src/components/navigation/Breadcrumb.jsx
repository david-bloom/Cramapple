import React from 'react';

export function Breadcrumb({ items = [], onOpenMap, mapOpen = false, right }) {
  return (
    <nav style={{
      height: 'var(--breadcrumb-height)', flex: '0 0 auto', background: 'var(--surface-chrome)',
      borderBottom: '1px solid var(--rule-300)', display: 'flex', alignItems: 'center',
      justifyContent: 'space-between', padding: '0 var(--gutter)'
    }}>
      <span style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
        {onOpenMap && (
          <button type="button" onClick={onOpenMap} style={{
            background: 'none', border: 0, padding: '2px 6px 2px 0', cursor: 'pointer',
            fontSize: '15px', color: 'var(--text-secondary)'
          }} aria-label="Study map">⌂ <span style={{ fontSize: 'var(--type-breadcrumb-size)', fontWeight: 'var(--type-breadcrumb-weight)' }}>{mapOpen ? '▼' : '▸'}</span></button>
        )}
        {items.map((it, i) => (
          <span key={i} style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
            {i > 0 && <span aria-hidden="true" style={{ color: 'var(--rule-500)', fontSize: 'var(--type-breadcrumb-size)' }}>·</span>}
            <span style={{
              fontSize: 'var(--type-breadcrumb-size)', lineHeight: 'var(--type-breadcrumb-line)', fontWeight: 'var(--type-breadcrumb-weight)',
              color: i === items.length - 1 ? 'var(--orange-700)' : 'var(--text-secondary)'
            }}>{it}</span>
          </span>
        ))}
      </span>
      {right && <span style={{ fontSize: 'var(--type-breadcrumb-size)', fontWeight: 'var(--type-breadcrumb-weight)', color: 'var(--text-secondary)' }}>{right}</span>}
    </nav>
  );
}
