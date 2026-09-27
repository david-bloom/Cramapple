import React from 'react';

/**
 * A marked absence.
 *
 * The design system's rule for content it does not have: "omit, or leave
 * purposely blank with a disclaimer." Real item packages carry the question and
 * the choices and nothing else the plate wants — no habits pair, no reference
 * materials, no hints, no deep dive, no per-distractor fix.
 *
 * Inventing that content here would put unvetted pedagogy in front of a student
 * wearing the product's own styling, which is exactly what INV-3 and the
 * double-approve rule exist to prevent. So the plate shows the hole instead.
 *
 * Deliberately not styled like product UI: a dashed rule and mono type, so it
 * can never be mistaken for content at a glance or in a screenshot.
 */
export function Missing({ children, inline = false, heading = 'Not in this package' }) {
  return (
    <div
      role="note"
      style={{
        border: '1px dashed var(--rule-400)',
        background: 'var(--paper-050)',
        padding: inline ? '6px 9px' : '10px 12px',
        display: 'grid',
        gap: 3
      }}
    >
      <span style={{
        fontFamily: 'var(--font-body)',
        fontSize: 'var(--type-count-size)',
        fontWeight: 700,
        letterSpacing: '.1em',
        textTransform: 'uppercase',
        color: 'var(--text-quiet)'
      }}>{heading}</span>
      <span style={{
        fontSize: inline ? 'var(--type-count-size)' : 'var(--type-body-size)',
        lineHeight: inline ? 'var(--type-count-line)' : 'var(--type-body-line)',
        color: 'var(--text-secondary)'
      }}>{children}</span>
    </div>
  );
}
