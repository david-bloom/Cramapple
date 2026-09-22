import React, { useState } from 'react';
import {
  PaneShell, ScoreChip, RadioOptionRow, QuestionHeader,
  ActionRow, ActionButton, HintGate, FeedbackCard
} from '../components/index.js';
import { QuestionPlate } from './parts/QuestionPlate.jsx';
import { ReferencePane } from './parts/ReferencePane.jsx';
import { Habits } from './parts/Habits.jsx';
import { DeepDiveGate, DEEP_DIVE_HINT } from './parts/DeepDiveGate.jsx';
import { Stem } from './parts/Stem.jsx';
import { body } from './parts/text.js';
import { useSession, useHints } from '../session/SessionProvider.jsx';
import { gradeMcq } from '../session/grade.js';

/**
 * Practice MCQ. One point, one submission, the key closed until the student
 * commits. The elimination hint strikes two distractors and is listed on the
 * feedback card.
 *
 * On submit the option list shrinks to the credited row plus the row the
 * student picked, with a pointer to the Answer Key for the rest -- four
 * expanded options would push the feedback card past the frame.
 */
export function PracticeMcqScreen({ question, onNext }) {
  const { attempts, recordAttempt } = useSession();
  // The deep dive is costed help in Practice, so it joins the hint list and
  // its receipt lands on the feedback card with the rest.
  const hints = useHints(question.package_id, [...question.hints, DEEP_DIVE_HINT]);
  const attempt = attempts[question.package_id];
  const submitted = Boolean(attempt && attempt.mode === 'practice');

  const [picked, setPicked] = useState(attempt?.picked || null);
  const elimHint = question.hints.find((h) => h.kind === 'eliminate');
  const eliminated = !submitted && elimHint && hints.wasUsed(elimHint.hint_key)
    ? elimHint.eliminates
    : [];

  const submit = () => {
    const result = gradeMcq(question, picked);
    recordAttempt(question.package_id, {
      mode: 'practice',
      picked,
      earned: result.earned,
      total: result.total,
      verdict: result.verdict,
      marks: result.marks,
      coaching: result.coaching,
      hintsUsed: hints.used
    });
  };

  const shown = submitted
    ? question.choices.filter((c) => c.is_correct || c.choice_key === attempt.picked)
    : question.choices;

  return (
    <QuestionPlate question={question} mode="practice">
      {({ openDeepDive }) => (
        <>
          <PaneShell
            voice={submitted ? 'rubric' : 'hint'}
            eyebrow="Scoring"
            title={submitted ? 'Answer Key' : 'Elimination'}
            right={<ScoreChip earned={submitted ? attempt.earned : null} total={1} />}
            style={{ height: '100%' }}
          >
            {submitted ? (
              <div style={{ display: 'grid', gap: 10 }}>
                {attempt.marks.map((m) => (
                  <div key={m.choice_key} style={{
                    background: 'var(--surface-pane)', border: '1px solid var(--rule-300)',
                    borderLeft: `var(--border-cap) solid ${
                      m.is_correct ? 'var(--blue-600)' : m.picked ? 'var(--clay-600)' : 'var(--rule-400)'
                    }`,
                    padding: '10px 12px'
                  }}>
                    <span style={{ display: 'flex', alignItems: 'baseline', gap: 8 }}>
                      <span aria-hidden="true" style={{
                        fontSize: 16, fontWeight: 700,
                        color: m.is_correct ? 'var(--text-earned)' : m.picked ? 'var(--text-revisit)' : 'var(--text-quiet)'
                      }}>{m.is_correct ? '✓' : m.picked ? '↻' : '·'}</span>
                      <span style={{ fontSize: 'var(--type-body-size)', fontWeight: 700 }}>{m.choice_key}</span>
                      <span style={{ fontSize: 'var(--type-body-size)', lineHeight: 'var(--type-body-line)', color: 'var(--text-secondary)' }}>
                        {m.note}
                      </span>
                    </span>
                  </div>
                ))}
              </div>
            ) : (
              <div style={{ display: 'grid', gap: 16 }}>
                <p style={body}>{question.scoringNote}</p>
                {elimHint && (
                  <HintGate
                    name={elimHint.name}
                    cost={elimHint.cost}
                    state={hints.stateOf(elimHint.hint_key)}
                    contentHidden={!hints.contentVisible(elimHint.hint_key)}
                    onAsk={() => hints.ask(elimHint.hint_key)}
                    onConfirm={() => hints.confirm(elimHint.hint_key)}
                    onCancel={() => hints.cancel(elimHint.hint_key)}
                    onHide={() => hints.toggleContent(elimHint.hint_key)}
                  >
                    <p style={body}>{elimHint.body}</p>
                  </HintGate>
                )}
                {question.deepDive && (
                  <DeepDiveGate hints={hints} onOpen={openDeepDive} />
                )}
                <Habits habits={question.habits} />
              </div>
            )}
          </PaneShell>

          <PaneShell
            voice="question"
            eyebrow="Question"
            title={question.title}
            right={<ScoreChip earned={submitted ? attempt.earned : null} total={1} label="Score" />}
            style={{ height: '100%' }}
          >
            <div style={{
              display: 'grid', gap: 16, height: '100%', minHeight: 0,
              gridTemplateRows: 'auto minmax(0,1fr) auto auto'
            }}>
              <QuestionHeader
                topic={`${question.taxonomy.topic} ${question.taxonomy.topic_title}`}
                mode="Practice"
                points={1}
                stem={<Stem nodes={question.stem} />}
              />

              <div role="radiogroup" aria-label="Answer choices" style={{ display: 'grid', gap: 10, alignContent: 'start', minHeight: 0 }}>
                {shown.map((c) => (
                  <RadioOptionRow
                    key={c.choice_key}
                    letter={c.choice_key}
                    selected={submitted ? attempt.picked === c.choice_key : picked === c.choice_key}
                    verdict={c.is_correct ? 'correct' : 'distractor'}
                    showVerdict={submitted}
                    eliminated={eliminated.includes(c.choice_key)}
                    onSelect={submitted ? undefined : () => setPicked(c.choice_key)}
                  >
                    {c.text}
                  </RadioOptionRow>
                ))}
                {submitted && shown.length < question.choices.length && (
                  <p style={{ margin: 0, fontSize: 'var(--type-count-size)', color: 'var(--text-quiet)' }}>
                    The {question.choices.length - shown.length} options you did not pick are explained in the Answer Key.
                  </p>
                )}
              </div>

              {submitted ? (
                <FeedbackCard
                  verdict={attempt.verdict}
                  earned={attempt.earned}
                  total={attempt.total}
                  coaching={attempt.coaching}
                  hintsUsed={attempt.hintsUsed}
                />
              ) : <span />}

              <ActionRow
                note={submitted ? 'One point · scored' : picked ? 'Ready to submit' : 'Pick one answer'}
                primary={submitted
                  ? <ActionButton variant="primary" onClick={onNext}>Next question</ActionButton>
                  : <ActionButton variant="primary" disabled={!picked} onClick={submit}>Submit answer</ActionButton>}
                secondary={submitted
                  ? <ActionButton variant="link" onClick={openDeepDive}>Open the deep dive</ActionButton>
                  : <ActionButton variant="link" onClick={onNext}>Skip for now</ActionButton>}
              />
            </div>
          </PaneShell>

          <ReferencePane reference={question.reference} />
        </>
      )}
    </QuestionPlate>
  );
}
