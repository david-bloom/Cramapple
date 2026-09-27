import React, { useState } from 'react';
import {
  PaneShell, ScoreChip, RadioOptionRow, QuestionHeader,
  ActionRow, ActionButton, FeedbackCard
} from '../components/index.js';
import { QuestionPlate } from './parts/QuestionPlate.jsx';
import { ReferencePane } from './parts/ReferencePane.jsx';
import { Missing } from './parts/Missing.jsx';
import { Stem } from './parts/Stem.jsx';
import { body } from './parts/text.js';
import { useSession } from '../session/SessionProvider.jsx';

const NOT_GRADABLE = "This is your own question, so there's no CramApple-authored"
  + " answer key to score it against. Read back through your reasoning against the"
  + ' reference material, or ask your teacher to check this one.';

/**
 * Practice for a BYOQ (bring-your-own-question) MCQ item. Deliberately not the
 * library PracticeMcqScreen: there is no is_correct anywhere on this item's
 * choices (see content/byoq.js), so there is no answer key to reveal and no
 * elimination hint to offer. Every choice stays visible before and after
 * submission -- nothing is filtered down to "picked + correct" because there is
 * no correct one to point to.
 */
export function PracticeByoqMcqScreen({ question, onNext }) {
  const { attempts, recordAttempt } = useSession();
  const attempt = attempts[question.package_id];
  const submitted = Boolean(attempt && attempt.mode === 'practice');

  const [picked, setPicked] = useState(attempt?.picked || null);

  const submit = () => {
    recordAttempt(question.package_id, {
      mode: 'practice',
      picked,
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
                No answer key, elimination hint, or deep dive exists for a question
                CramApple didn't author.
              </Missing>
            </div>
          </PaneShell>

          <PaneShell
            voice="question"
            eyebrow="Question"
            title={question.title}
            right={<ScoreChip earned={null} total={1} label="Score" />}
            style={{ height: '100%' }}
          >
            <div style={{
              display: 'grid', gap: 16, height: '100%', minHeight: 0,
              gridTemplateRows: 'auto minmax(0,1fr) auto auto'
            }}>
              <QuestionHeader
                topic={`${question.taxonomy.topic} ${question.taxonomy.topic_title}`}
                mode="Practice"
                points={question.points ?? 1}
                stem={<Stem nodes={question.stem} />}
              />

              <div role="radiogroup" aria-label="Answer choices" style={{ display: 'grid', gap: 10, alignContent: 'start', minHeight: 0 }}>
                {question.choices.map((c) => (
                  <RadioOptionRow
                    key={c.choice_key}
                    letter={c.choice_key}
                    selected={submitted ? attempt.picked === c.choice_key : picked === c.choice_key}
                    onSelect={submitted ? undefined : () => setPicked(c.choice_key)}
                  >
                    {c.text}
                  </RadioOptionRow>
                ))}
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
                note={submitted ? 'Not scored' : picked ? 'Ready to submit' : 'Pick one answer'}
                primary={submitted
                  ? <ActionButton variant="primary" onClick={onNext}>Done — back to Home</ActionButton>
                  : <ActionButton variant="primary" disabled={!picked} onClick={submit}>Submit answer</ActionButton>}
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
