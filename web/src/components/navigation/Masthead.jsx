import React from 'react';
import { Wordmark } from './Wordmark.jsx';

export function Masthead({ course = 'AP Statistics', right }) {
  return (
    <header style={{
      height: 'var(--masthead-height)', flex: '0 0 auto', background: 'var(--orange-600)', color: 'var(--text-on-brand)',
      display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '0 var(--gutter)'
    }}>
      <Wordmark tone="on-brand" />
      <span style={{ display: 'flex', alignItems: 'center', gap: 'var(--space-5)' }}>
        <span style={{ fontSize: 'var(--type-body-size)', fontWeight: 'var(--type-body-strong-weight)', color: 'var(--paper-000)' }}>{course}</span>
        {right}
      </span>
    </header>
  );
}
