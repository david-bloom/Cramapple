import React from 'react';

const BASE = {
  fontFamily: 'var(--font-body)', fontSize: 'var(--type-control-size)', lineHeight: 'var(--type-control-line)',
  fontWeight: 'var(--type-control-weight)', borderRadius: 'var(--radius-all)', padding: 'var(--control-pad-y) var(--control-pad-x)'
};

export function ActionButton({ variant = 'primary', disabled = false, onClick, children, type = 'button' }) {
  let s;
  if (variant === 'primary') {
    s = { ...BASE, background: disabled ? 'var(--action-primary-disabled)' : 'var(--action-primary-bg)', color: 'var(--action-primary-fg)', border: '1px solid transparent' };
  } else if (variant === 'hint') {
    s = { ...BASE, background: 'var(--action-hint-bg)', color: 'var(--action-hint-fg)', border: '1px solid var(--yellow-600)' };
  } else if (variant === 'quiet') {
    s = { ...BASE, background: 'var(--action-quiet-bg)', color: 'var(--action-quiet-fg)', border: 'var(--border-quiet)' };
  } else {
    s = { ...BASE, background: 'none', border: 0, padding: '11px 2px', color: 'var(--action-link-fg)', textDecoration: 'underline', textUnderlineOffset: 'var(--underline-offset)', textDecorationThickness: 'var(--underline-thickness)' };
  }
  return <button type={type} disabled={disabled} onClick={onClick} style={{ ...s, cursor: disabled ? 'not-allowed' : 'pointer' }}>{children}</button>;
}
