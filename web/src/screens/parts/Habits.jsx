import React from 'react';
import { eyebrow, list } from './text.js';

/**
 * Rules come in pairs. Every question carries "How points are earned" and
 * "How points are lost", three short lines each, written as habits rather
 * than facts -- deliberately shorter than prose so the pane fits without
 * scrolling.
 */
export function Habits({ habits }) {
  return (
    <>
      <div style={{ borderTop: '1px solid var(--rule-divider)', paddingTop: 14 }}>
        <span style={eyebrow}>How points are earned</span>
        <ul style={list}>{habits.earned.map((h) => <li key={h}>{h}</li>)}</ul>
      </div>
      <div>
        <span style={eyebrow}>How points are lost</span>
        <ul style={list}>{habits.lost.map((h) => <li key={h}>{h}</li>)}</ul>
      </div>
    </>
  );
}
