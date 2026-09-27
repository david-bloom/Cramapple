import React from 'react';

export function ActionRow({ primary, secondary, note, align = 'split' }) {
  return (
    <div style={{
      display: 'flex', alignItems: 'center', gap: 'var(--space-4)',
      justifyContent: align === 'split' ? 'space-between' : 'flex-start',
      borderTop: '1px solid var(--rule-divider)', paddingTop: 'var(--space-4)'
    }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 'var(--space-4)' }}>
        {primary}
        {secondary}
      </div>
      {note && <span style={{ fontSize: 'var(--type-count-size)', lineHeight: 'var(--type-count-line)', color: 'var(--text-quiet)' }}>{note}</span>}
    </div>
  );
}
