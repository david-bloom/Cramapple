import React, { useState } from 'react';
import {
  PaneShell, ScoreChip, RubricCriterionRow, QuestionHeader, GraphFrame,
  ActionRow, ActionButton
} from '../components/index.js';
import { Scatterplot } from '../lib/Scatterplot.jsx';
import { QuestionPlate } from './parts/QuestionPlate.jsx';
import { ReferencePane } from './parts/ReferencePane.jsx';
import { Stem } from './parts/Stem.jsx';
import { eyebrow, body } from './parts/text.js';

/**
 * Open Hand FRQ. Nothing is hidden and nothing is scored: the rubric is
 * face-up and the student takes points back to watch the credited response
 * lose the phrase that was carrying each one.
 *
 * ✕ is the teacher's hand and appears only here. In Practice a missed point
 * is ↻ -- still available.
 */
export function OpenHandFrqScreen({ question, onNext }) {
  const [awarded, setAwarded] = useState(() => question.criteria.map(() => true));

  const earned = question.criteria.reduce(
    (sum, c, i) => sum + (awarded[i] ? c.points : 0), 0
  );
  const toggle = (i) => setAwarded((a) => a.map((v, k) => (k === i ? !v : v)));

  // A credited-response segment is live while the criterion carrying it is awarded.
  const isLive = (segment) => {
    if (!segment.criterion) return true;
    const i = question.criteria.findIndex((c) => c.criterion_key === segment.criterion);
    return i === -1 ? true : awarded[i];
  };

  return (
    <QuestionPlate question={question} mode="open-hand">
      {({ openDeepDive }) => (
        <>
          <PaneShell
            voice="rubric"
            eyebrow="Face-up"
            title="Rubric"
            right={<ScoreChip earned={earned} total={question.points} />}
            style={{ height: '100%' }}
          >
            <p style={{ ...body, marginBottom: 14 }}>
              Every point is face-up. Take one back to see what the answer loses.
            </p>
            <div style={{ display: 'grid', gap: 10 }}>
              {question.criteria.map((c, i) => (
                <RubricCriterionRow
                  key={c.criterion_key}
                  code={c.code}
                  label={c.label}
                  detail={c.detail}
                  points={c.points}
                  state={awarded[i] ? 'earned' : 'taken'}
                  interactive
                  onToggle={() => toggle(i)}
                />
              ))}
            </div>
            <p style={{ ...body, marginTop: 14, color: 'var(--text-quiet)', fontSize: 'var(--type-count-size)' }}>
              Click a criterion to take the point back. ✕ is the teacher's hand — in Practice a missed point is ↻.
            </p>
          </PaneShell>

          <PaneShell
            voice="question"
            eyebrow="Question"
            title={question.title}
            right={<ScoreChip earned={earned} total={question.points} label="Score" />}
            style={{ height: '100%' }}
          >
            <div style={{
              display: 'grid', gap: 14, height: '100%', minHeight: 0,
              // Header, graph, credited response, actions. The slack goes to the
              // credited response, not the graph -- the graph has a natural
              // aspect and letterboxes if it is stretched.
              gridTemplateRows: 'auto auto minmax(0,1fr) auto'
            }}>
              <QuestionHeader
                topic={`${question.taxonomy.topic} ${question.taxonomy.topic_title}`}
                mode="Open Hand"
                points={question.points}
                stem={<Stem nodes={question.stem} />}
              />

              <div>
                {question.stimulus?.kind === 'scatterplot' && (
                  <GraphFrame caption={question.stimulus.caption} source={question.stimulus.source}>
                    <Scatterplot {...question.stimulus} height={188} />
                  </GraphFrame>
                )}
              </div>

              <div style={{
                background: 'var(--surface-work)', border: '1px solid var(--purple-rule)',
                borderTop: 'var(--border-cap) solid var(--cap-work)', padding: '14px 16px'
              }}>
                <span style={eyebrow}>Credited response</span>
                <p style={{ margin: 0, fontSize: 'var(--type-option-size)', lineHeight: 'var(--type-option-line)' }}>
                  {question.creditedResponse.map((segment, i) => {
                    const live = isLive(segment);
                    // A literal segment is punctuation -- it joins the previous
                    // segment with no space in front of it.
                    const next = question.creditedResponse[i + 1];
                    const space = next && !next.literal;
                    return (
                      <React.Fragment key={i}>
                        <span style={{
                          background: live && segment.criterion ? 'var(--blue-050)' : 'transparent',
                          textDecoration: live ? 'none' : 'line-through',
                          color: live ? 'var(--text-body)' : 'var(--status-eliminated)'
                        }}>{segment.text}</span>
                        {space ? ' ' : ''}
                      </React.Fragment>
                    );
                  })}
                </p>
                <p style={{ ...body, marginTop: 8, fontSize: 'var(--type-count-size)' }}>
                  Highlight shows which rubric point each phrase is carrying.
                </p>
              </div>

              <ActionRow
                note="Nothing is scored in Open Hand"
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
