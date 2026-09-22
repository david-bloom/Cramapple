import React, { useState } from 'react';
import {
  PaneShell, RadioOptionRow, QuestionHeader, ActionRow, ActionButton
} from '../components/index.js';
import { QuestionPlate } from './parts/QuestionPlate.jsx';
import { ReferencePane } from './parts/ReferencePane.jsx';
import { Stem } from './parts/Stem.jsx';
import { body } from './parts/text.js';
import { useSession } from '../session/SessionProvider.jsx';

/**
 * Open Hand MCQ. The answer key is face-up, every option is marked Correct or
 * Distractor before the student picks, and selecting is free. The learning move
 * is exploration, so the screen counts explanations read rather than scoring.
 */
export function OpenHandMcqScreen({ question, onNext }) {
  const { read, markRead } = useSession();
  const seen = read[question.package_id] || [];
  const [picked, setPicked] = useState(seen[seen.length - 1] || null);

  const pick = (key) => { setPicked(key); markRead(question.package_id, key); };
  const total = question.choices.length;

  return (
    <QuestionPlate question={question} mode="open-hand">
      {({ openDeepDive }) => (
        <>
          <PaneShell
            voice="rubric"
            eyebrow="Face-up"
            title="Answer Key"
            right={<span style={{ fontSize: 'var(--type-count-size)', fontWeight: 600, color: 'var(--text-secondary)' }}>
              {seen.length} of {total} read
            </span>}
            style={{ height: '100%' }}
          >
            <p style={{ ...body, marginBottom: 14 }}>{question.openHandNote}</p>
            <div style={{ display: 'grid', gap: 10 }}>
              {question.choices.map((c) => {
                const isRead = seen.includes(c.choice_key);
                return (
                  <div
                    key={c.choice_key}
                    role="button"
                    tabIndex={0}
                    onClick={() => pick(c.choice_key)}
                    onKeyDown={(e) => {
                      if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); pick(c.choice_key); }
                    }}
                    style={{
                      cursor: 'pointer', background: 'var(--surface-pane)', border: '1px solid var(--rule-300)',
                      borderLeft: `var(--border-cap) solid ${c.is_correct ? 'var(--blue-600)' : 'var(--maroon-600)'}`,
                      padding: '10px 12px'
                    }}
                  >
                    <span style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', gap: 8 }}>
                      <span style={{
                        fontSize: 'var(--type-body-size)', fontWeight: 700,
                        color: c.is_correct ? 'var(--text-earned)' : 'var(--text-lost)'
                      }}>
                        {c.choice_key} · {c.is_correct ? 'Credited' : 'Distractor'}
                      </span>
                      <span style={{
                        fontSize: 'var(--type-count-size)', fontWeight: 600,
                        color: isRead ? 'var(--text-earned)' : 'var(--text-quiet)'
                      }}>{isRead ? '✓ read' : '· unread'}</span>
                    </span>
                    <span style={{
                      display: 'block', marginTop: 4, fontSize: 'var(--type-body-size)',
                      lineHeight: 'var(--type-body-line)', color: 'var(--text-secondary)'
                    }}>
                      {c.is_correct ? 'Every move in place — and four ways to lose the point.' : c.minimum_fix}
                    </span>
                  </div>
                );
              })}
            </div>
            <p style={{ ...body, marginTop: 14, fontSize: 'var(--type-count-size)', color: 'var(--text-quiet)' }}>
              Selecting an option is free in Open Hand. It counts as reading, not as answering.
            </p>
          </PaneShell>

          <PaneShell
            voice="question"
            eyebrow="Question"
            title={question.title}
            right={<span style={{ fontSize: 'var(--type-count-size)', fontWeight: 600, color: 'var(--text-secondary)' }}>Not scored</span>}
            style={{ height: '100%' }}
          >
            <div style={{
              display: 'grid', gap: 16, height: '100%', minHeight: 0,
              gridTemplateRows: 'auto minmax(0,1fr) auto'
            }}>
              <QuestionHeader
                topic={`${question.taxonomy.topic} ${question.taxonomy.topic_title}`}
                mode="Open Hand"
                points={1}
                stem={<Stem nodes={question.stem} />}
              />

              <div role="radiogroup" aria-label="Answer choices" style={{ display: 'grid', gap: 10, alignContent: 'start', minHeight: 0 }}>
                {question.choices.map((c) => (
                  <RadioOptionRow
                    key={c.choice_key}
                    letter={c.choice_key}
                    selected={picked === c.choice_key}
                    verdict={c.is_correct ? 'correct' : 'distractor'}
                    showVerdict
                    onSelect={() => pick(c.choice_key)}
                    explanation={picked === c.choice_key ? c.rationale : undefined}
                    note={picked === c.choice_key ? c.minimum_fix : undefined}
                  >
                    {c.text}
                  </RadioOptionRow>
                ))}
              </div>

              <ActionRow
                note={`${seen.length} of ${total} explanations read`}
                primary={<ActionButton variant="primary" onClick={onNext}>Next question</ActionButton>}
                secondary={<ActionButton variant="link" onClick={openDeepDive}>Open the deep dive</ActionButton>}
              />
            </div>
          </PaneShell>

          <ReferencePane reference={question.reference} />
        </>
      )}
    </QuestionPlate>
  );
}
