import React, { useEffect, useState } from 'react';
import { useEscapeToClose } from '../../lib/useEscapeToClose.js';

export function DeepDiveOverlay({ open = false, eyebrow = 'Deep dive', title, sections = [], onClose, onCopy }) {
  const [active, setActive] = useState(0);
  useEscapeToClose(open, onClose);
  useEffect(() => {
    if (open) setActive(0);
  }, [open, title]);
  if (!open) return null;

  const notes = sections.length ? sections : [{ title: 'No notes yet', body: 'This question does not have deep-dive notes yet.' }];
  const activeNote = notes[Math.min(active, notes.length - 1)];

  return (
    <div className="deep-dive-overlay">
      <section className="deep-dive-panel" aria-labelledby="deep-dive-title">
        <header className="deep-dive-header">
          <div>
            <span className="deep-dive-eyebrow">{eyebrow}</span>
            <h2 id="deep-dive-title" className="deep-dive-title">{title}</h2>
            <p className="deep-dive-count">
              Note {Math.min(active + 1, notes.length)} of {notes.length}
            </p>
          </div>
          <div className="deep-dive-actions">
            {onCopy && (
              <button type="button" onClick={onCopy} className="deep-dive-copy">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.9" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
                  <path d="M8.6 3.6h11.8v11.8H8.6z" /><path d="M15.4 20.4H3.6V8.6" />
                </svg>
                Copy deep dive
              </button>
            )}
            <button type="button" onClick={onClose} className="deep-dive-back">Back to the question</button>
          </div>
        </header>

        <div className="deep-dive-notes">
          <nav className="deep-dive-note-list" aria-label="Deep dive notes">
            {notes.map((s, i) => (
              <button
                key={`${s.title}-${i}`}
                type="button"
                className={`deep-dive-note-tab${i === active ? ' is-active' : ''}`}
                aria-current={i === active ? 'true' : undefined}
                onClick={() => setActive(i)}
              >
                <span className="deep-dive-note-number">{String(i + 1).padStart(2, '0')}</span>
                <span className="deep-dive-note-label">{s.title}</span>
              </button>
            ))}
          </nav>

          <article className="deep-dive-note-card">
            <div className="deep-dive-note-kicker">Deep dive note</div>
            <h3>{activeNote.title}</h3>
            <p>{activeNote.body}</p>
          </article>
        </div>
      </section>
    </div>
  );
}
