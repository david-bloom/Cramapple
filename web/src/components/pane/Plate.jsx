import React from 'react';

export function Plate({ caption, children, style }) {
  return (
    <div style={{
      position: 'relative', flex: '0 0 auto',
      width: 'var(--plate-width)', height: 'var(--plate-height)', overflow: 'hidden',
      background: 'var(--surface-plate)', display: 'flex', flexDirection: 'column',
      fontFamily: 'var(--font-body)', color: 'var(--text-body)', ...style
    }}>
      {children}
      {caption && <div style={{
        flex: '0 0 auto', height: 'var(--caption-height)', display: 'flex', alignItems: 'center', padding: '0 var(--gutter)',
        fontSize: 'var(--type-caption-size)', lineHeight: 'var(--type-caption-line)', fontWeight: 'var(--type-caption-weight)', color: 'var(--text-quiet)'
      }}>{caption}</div>}
    </div>
  );
}

export function PlateGrid({ children, style }) {
  return (
    <div style={{
      flex: '1 1 auto', minHeight: 0, display: 'grid', gridTemplateColumns: 'var(--grid-columns)',
      gap: 'var(--pane-gap)', padding: 'var(--space-5) var(--gutter)', background: 'var(--surface-desk)', ...style
    }}>{children}</div>
  );
}
