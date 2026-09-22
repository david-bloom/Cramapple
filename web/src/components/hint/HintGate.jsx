import React from 'react';

export function HintGate({ name, cost, state = 'idle', contentHidden = false, onAsk, onConfirm, onCancel, onHide, children }) {
  const label = { fontSize: 'var(--type-control-size)', lineHeight: 'var(--type-control-line)', fontWeight: 'var(--type-control-weight)', fontFamily: 'var(--font-body)' };
  const yellowBtn = {
    ...label, background: 'var(--action-hint-bg)', color: 'var(--action-hint-fg)', border: '1px solid var(--yellow-600)',
    borderRadius: 'var(--radius-all)', padding: '9px 16px', cursor: 'pointer'
  };
  const linkBtn = {
    ...label, background: 'none', border: 0, padding: '9px 2px', color: 'var(--action-link-fg)', cursor: 'pointer',
    textDecoration: 'underline', textUnderlineOffset: 'var(--underline-offset)', textDecorationThickness: 'var(--underline-thickness)'
  };
  const block = {
    background: 'var(--surface-hint)', border: '1px solid var(--yellow-300)', borderTop: 'var(--border-cap) solid var(--cap-hint)',
    borderRadius: 'var(--radius-all)', padding: '12px 14px'
  };

  if (state === 'open') {
    return (
      <div>
        <div style={{
          display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 'var(--space-3)',
          background: 'var(--surface-hint-receipt)', border: '1px solid var(--rule-300)', borderLeft: 'var(--border-cap) solid var(--cap-hint)',
          borderRadius: 'var(--radius-all)', padding: '8px 12px'
        }}>
          <span style={{ fontSize: 'var(--type-count-size)', fontWeight: 'var(--type-count-weight)', letterSpacing: '.04em', textTransform: 'uppercase', color: 'var(--text-secondary)' }}>
            Hint used · {name}
          </span>
          {onHide && <button type="button" onClick={onHide} style={{ ...linkBtn, padding: 0, fontSize: 'var(--type-count-size)' }}>{contentHidden ? 'Show' : 'Hide'}</button>}
        </div>
        {!contentHidden && children && <div style={{ marginTop: 'var(--space-3)' }}>{children}</div>}
      </div>
    );
  }

  if (state === 'asking') {
    return (
      <div style={block}>
        <p style={{ margin: '0 0 4px', fontSize: 'var(--type-body-size)', lineHeight: 'var(--type-body-line)', fontWeight: 'var(--type-body-strong-weight)', color: 'var(--text-body)' }}>Sure you need a hint?</p>
        <p style={{ margin: '0 0 12px', fontSize: 'var(--type-body-size)', lineHeight: 'var(--type-body-line)', color: 'var(--text-secondary)' }}>{cost}</p>
        <div style={{ display: 'flex', alignItems: 'center', gap: 'var(--space-4)' }}>
          <button type="button" onClick={onConfirm} style={yellowBtn}>Yes, show me</button>
          <button type="button" onClick={onCancel} style={linkBtn}>No, keep solving</button>
        </div>
      </div>
    );
  }

  return (
    <div style={{ ...block, display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 'var(--space-3)' }}>
      <span style={{ display: 'flex', alignItems: 'center', gap: 'var(--space-3)' }}>
        <span aria-hidden="true" style={{
          display: 'inline-flex', alignItems: 'center', justifyContent: 'center', width: '22px', height: '22px',
          background: 'var(--yellow-500)', color: 'var(--ink-900)', border: '1px solid var(--yellow-600)',
          fontSize: '14px', fontWeight: 700, borderRadius: 'var(--radius-all)'
        }}>?</span>
        <span style={{ fontSize: 'var(--type-body-size)', lineHeight: 'var(--type-body-line)', fontWeight: 'var(--type-body-strong-weight)', color: 'var(--text-body)' }}>{name}</span>
      </span>
      <button type="button" onClick={onAsk} style={{ ...yellowBtn, padding: '7px 14px' }}>Show me</button>
    </div>
  );
}
