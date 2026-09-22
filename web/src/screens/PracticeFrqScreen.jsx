import React, { useState } from 'react';
import {
  PaneShell, ScoreChip, RubricCriterionRow, QuestionHeader, GraphFrame,
  AnswerField, ActionRow, ActionButton, HintGate, FeedbackCard
} from '../components/index.js';
import { Scatterplot } from '../lib/Scatterplot.jsx';
import { QuestionPlate } from './parts/QuestionPlate.jsx';
import { ReferencePane } from './parts/ReferencePane.jsx';
import { Habits } from './parts/Habits.jsx';
import { Stem } from './parts/Stem.jsx';
import { eyebrow, body } from './parts/text.js';
import { useSession, useHints } from '../session/SessionProvider.jsx';
import { gradeFrq } from '../session/grade.js';

/**
 * Practice FRQ. The scoring is withheld behind a hint that costs something, the
 * student's own work is scored, and one submission closes the attempt.
 */
export function PracticeFrqScreen({ question, onNext }) {
  const { attempts, recordAttempt } = useSession();
  const hints = useHints(question.package_id, question.hints);
  const attempt = attempts[question.package_id];
  const submitted = Boolean(attempt && attempt.mode === 'practice');

  const [text, setText] = useState(attempt?.response || '');
  const rubricHint = question.hints.find((h) => h.kind === 'rubric');
  const rubricOpen = Boolean(rubricHint && hints.contentVisible(rubricHint.hint_key));

  const submit = () => {
    const result = gradeFrq(question, text);
    recordAttempt(question.package_id, {
      mode: 'practice',
      response: text,
      earned: result.earned,
      total: result.total,
      verdict: result.verdict,
      marks: result.marks,
      coaching: result.coaching,
      hintsUsed: hints.used
    });
  };

  return (
    <QuestionPlate question={question} mode="practice">
      {({ openDeepDive }) => (
        <>
          {/* Scoring pane. Yellow while the rubric is gated; blue once it is the rubric. */}
          <PaneShell
            voice={submitted ? 'rubric' : 'hint'}
            eyebrow="Scoring"
            title={submitted ? 'Rubric' : 'How this is scored'}
            right={<ScoreChip earned={submitted ? attempt.earned : null} total={question.points} />}
            style={{ height: '100%' }}
          >
            {submitted ? (
              <div style={{ display: 'grid', gap: 10 }}>
                {attempt.marks.map((m) => (
                  <RubricCriterionRow
                    key={m.criterion_key}
                    code={m.code}
                    label={m.label}
                    detail={m.state === 'earned' ? m.detail : m.minimum_fix}
                    state={m.state}
                    points={m.points}
                  />
                ))}
                <p style={{ ...body, fontSize: 'var(--type-count-size)', marginTop: 4 }}>
                  ↻ means revisit, not wrong forever — the point is still available next attempt.
                </p>
              </div>
            ) : (
              <div style={{ display: 'grid', gap: 16 }}>
                <p style={body}>{question.scoringNote}</p>
                {rubricHint && (
                  <HintGate
                    name={rubricHint.name}
                    cost={rubricHint.cost}
                    state={hints.stateOf(rubricHint.hint_key)}
                    contentHidden={!hints.contentVisible(rubricHint.hint_key)}
                    onAsk={() => hints.ask(rubricHint.hint_key)}
                    onConfirm={() => hints.confirm(rubricHint.hint_key)}
                    onCancel={() => hints.cancel(rubricHint.hint_key)}
                    onHide={() => hints.toggleContent(rubricHint.hint_key)}
                  >
                    <div style={{ display: 'grid', gap: 10 }}>
                      {question.criteria.map((c) => (
                        <RubricCriterionRow
                          key={c.criterion_key}
                          code={c.code}
                          label={c.label}
                          detail={c.detail}
                          state="pending"
                          points={c.points}
                        />
                      ))}
                    </div>
                  </HintGate>
                )}
                {/* The habits pair is what stands in for a rubric the student
                    cannot see, and for an FRQ it says the same thing the criteria
                    say ("Name both variables" / "Names both variables"). Once the
                    hint is paid for and the rubric is open, keeping both overruns
                    the pane by ~170px -- so the rubric replaces them rather than
                    stacking on top of them. */}
                {!rubricOpen && <Habits habits={question.habits} />}
              </div>
            )}
          </PaneShell>

          {/* Question pane. Four rows: header, content track, feedback, actions.
              The feedback card sits in its own auto row above the action row --
              inside the 1fr track a grown answer field pushes both past the frame. */}
          <PaneShell
            voice="question"
            eyebrow="Question"
            title={question.title}
            right={<ScoreChip earned={submitted ? attempt.earned : null} total={question.points} label="Score" />}
            style={{ height: '100%' }}
          >
            <div style={{
              display: 'grid', gap: 14, height: '100%', minHeight: 0,
              gridTemplateRows: 'auto minmax(0,1fr) auto auto'
            }}>
              <QuestionHeader
                topic={`${question.taxonomy.topic} ${question.taxonomy.topic_title}`}
                mode="Practice"
                points={question.points}
                stem={<Stem nodes={question.stem} />}
              />

              <div style={{ display: 'grid', gap: 14, alignContent: 'start', minHeight: 0 }}>
                {question.stimulus?.kind === 'scatterplot' && (
                  <GraphFrame
                    caption={question.stimulus.caption}
                    source={question.stimulus.source}
                    height={submitted ? 118 : 206}
                  >
                    <Scatterplot {...question.stimulus} />
                  </GraphFrame>
                )}
                {!submitted && (
                  <div>
                    <span style={eyebrow}>Your work</span>
                    <AnswerField
                      value={text}
                      onChange={setText}
                      rows={4}
                      onAttach={() => {}}
                      count={question.answerHint}
                    />
                  </div>
                )}
              </div>

              {submitted ? (
                <FeedbackCard
                  verdict={attempt.verdict}
                  earned={attempt.earned}
                  total={attempt.total}
                  coaching={attempt.coaching}
                  hintsUsed={attempt.hintsUsed}
                  submitted={attempt.response}
                  submittedLabel="Your answer"
                />
              ) : <span />}

              <ActionRow
                note={submitted
                  ? `Scored against ${question.criteria.length} criteria`
                  : 'One submission per question'}
                primary={submitted
                  ? <ActionButton variant="primary" onClick={onNext}>Next question</ActionButton>
                  : <ActionButton variant="primary" disabled={text.trim().length === 0} onClick={submit}>Submit answer</ActionButton>}
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
