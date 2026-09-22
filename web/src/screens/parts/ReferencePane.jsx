import React from 'react';
import { PaneShell } from '../../components/index.js';
import { eyebrow, body, list } from './text.js';

/**
 * Reference materials are what the student may look up, not hints about this
 * question. Always the same three sections, in this order: Topic, Skills,
 * Vocabulary -- then the exam note.
 */
export function ReferencePane({ reference }) {
  return (
    <PaneShell voice="reference" eyebrow="Allowed" title="Reference Materials" style={{ height: '100%' }}>
      <div style={{ display: 'grid', gap: 18 }}>
        <div>
          <span style={eyebrow}>Topic</span>
          <p style={body}>{reference.topic}</p>
        </div>
        <div>
          <span style={eyebrow}>Skills</span>
          <ul style={list}>
            {reference.skills.map((s) => <li key={s}>{s}</li>)}
          </ul>
        </div>
        <div>
          <span style={eyebrow}>Vocabulary</span>
          <ul style={list}>
            {reference.vocabulary.map((v) => (
              <li key={v.term}>
                <strong style={{ fontWeight: 'var(--type-body-strong-weight)' }}>{v.term}</strong> — {v.definition}
              </li>
            ))}
          </ul>
        </div>
        {reference.onTheExam && (
          <div style={{ borderTop: '1px solid var(--rule-divider)', paddingTop: 12 }}>
            <span style={eyebrow}>On the exam</span>
            <p style={body}>{reference.onTheExam}</p>
          </div>
        )}
      </div>
    </PaneShell>
  );
}
