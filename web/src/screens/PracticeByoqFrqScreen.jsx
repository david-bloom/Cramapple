import React, { useState } from 'react';
import {
  PaneShell, ScoreChip, QuestionHeader, AnswerField, ActionRow, ActionButton, FeedbackCard
} from '../components/index.js';
import { QuestionPlate } from './parts/QuestionPlate.jsx';
import { ReferencePane } from './parts/ReferencePane.jsx';
import { Missing } from './parts/Missing.jsx';
import { Stem } from './parts/Stem.jsx';
import { eyebrow, body } from './parts/text.js';
import { useSession } from '../session/SessionProvider.jsx';

const NOT_GRADABLE = "This is your own question, so there's no CramApple-authored"
  + ' rubric to score it against. Read back through your reasoning against the'
  + ' reference material, or ask your teacher to check this one.';

/**
 * Practice for a BYOQ (bring-your-own-question) FRQ item. Deliberately not the
 * library PracticeFrqScreen: there is no `criteria` array on this item (see
 * content/byoq.js), because no rubric can be authored for a problem CramApple
 * did not write. No rubric hint, no deep dive, no per-criterion marks -- just
 * the student's own answer, held for their own review.
 */
export function PracticeByoqFrqScreen({ question, onNext }) {
  const { attempts, recordAttempt } = useSession();
  const attempt = attempts[question.package_id];
  const submitted = Boolean(attempt && attempt.mode === 'practice');

  const [text, setText] = useState(attempt?.response || '');

  const submit = () => {
    recordAttempt(question.package_id, {
      mode: 'practice',
      response: text,
      earned: null,
      total: null,
      verdict: null,
      marks: [],
      coaching: NOT_GRADABLE,
      hintsUsed: []
    });
  };

  return (
    <QuestionPlate question={question} mode="practice">
      {() => (
        <>
          <PaneShell
            voice="hint"
            eyebrow="Scoring"
            title="Your own question"
            style={{ height: '100%' }}
          >
            <div style={{ display: 'grid', gap: 16 }}>
              <p style={body}>{question.scoringNote}</p>
              <Missing heading="Not available for your own questions">
                No rubric, hint, or deep dive exists for a question CramApple
                didn't author.
              </Missing>
            </div>
          </PaneShell>

          <PaneShell
            voice="question"
            eyebrow="Question"
            title={question.title}
            right={<ScoreChip earned={null} total={question.points} label="Score" />}
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

              <div style={{ display: 'grid', gap: 8, alignContent: 'start', minHeight: 0 }}>
                {!submitted && (
                  <div>
                    <span style={eyebrow}>Your work</span>
                    <AnswerField
                      value={text}
                      onChange={setText}
                      rows={5}
                      onAttach={() => {}}
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
                note={submitted ? 'Not scored' : 'One submission per question'}
                primary={submitted
                  ? <ActionButton variant="primary" onClick={onNext}>Done — back to Home</ActionButton>
                  : <ActionButton variant="primary" disabled={text.trim().length === 0} onClick={submit}>Submit answer</ActionButton>}
                secondary={submitted
                  ? undefined
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
