import React from 'react';

export function AnswerField({ value = '', placeholder = 'Write your answer', onChange, rows = 5, onAttach, attachLabel = 'Attach hand-drawn work', readOnly = false, count }) {
  return (
    <div>
      <textarea
        value={value} placeholder={placeholder} rows={rows} readOnly={readOnly}
        onChange={(e) => onChange && onChange(e.target.value)}
        style={{
          width: '100%', resize: 'none', background: 'var(--surface-work)', color: 'var(--text-body)',
          border: '1px solid var(--purple-rule)', borderTop: 'var(--border-cap) solid var(--cap-work)', borderRadius: 'var(--radius-all)',
          padding: '12px 14px', fontFamily: 'var(--font-body)', fontSize: 'var(--type-body-size)', lineHeight: 'var(--type-body-line)', outline: 'none'
        }}
      />
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginTop: '6px' }}>
        {onAttach ? (
          <button type="button" onClick={onAttach} style={{
            display: 'inline-flex', alignItems: 'center', gap: '8px', background: 'none', border: 0, padding: 0, cursor: 'pointer',
            color: 'var(--action-link-fg)', fontSize: 'var(--type-count-size)', fontWeight: 600
          }}>
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.9" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
              <path d="M3.4 8.2h3.3l1.5-2.4h7.6l1.5 2.4h3.3v10.1H3.4z" /><path d="M12 16.1a3.3 3.3 0 1 0 0-6.6 3.3 3.3 0 0 0 0 6.6z" />
            </svg>
            {attachLabel}
          </button>
        ) : <span />}
        {count && <span style={{ fontSize: 'var(--type-count-size)', color: 'var(--text-quiet)' }}>{count}</span>}
      </div>
    </div>
  );
}
