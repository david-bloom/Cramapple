import React from 'react';

const TONES = {
  'on-brand': 'var(--wordmark-on-brand)',
  'on-light': 'var(--wordmark-on-light)',
  'on-dark': 'var(--wordmark-on-dark)',
  mono: 'var(--wordmark-mono)'
};

export function Wordmark({ tone = 'on-brand', size, style }) {
  return (
    <span style={{
      fontFamily: 'var(--font-wordmark)',
      fontSize: size || 'var(--type-wordmark-size)',
      lineHeight: size ? 1 : 'var(--type-wordmark-line)',
      letterSpacing: 'var(--type-wordmark-tracking)',
      color: TONES[tone] || TONES['on-brand'],
      whiteSpace: 'nowrap',
      ...style
    }}>CramApple</span>
  );
}
