import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import {
  PaneShell, ScoreChip, Masthead, Breadcrumb, ActionRow, ActionButton
} from '../components/index.js';
import { COURSE, UNIT, getQuestion, positionInTopic } from '../content/index.js';
import { useSession } from '../session/SessionProvider.jsx';
import { topicProgress, unitProgress, resumePoint, lastRevisit } from '../session/progress.js';
import { eyebrow, body, count } from './parts/text.js';

/**
 * Home is a hub, not a question: it scrolls, unlike the fixed 1440x900 plate
 * every question screen renders (see app.css). This is the new-student shape
 * -- one authored unit, no confirmed class position, no mastery history yet.
 * A returning-student layout (curriculum-wide progress, streaks, milestones)
 * is a distinct, larger design not built here.
 */
export function HomeScreen() {
  const navigate = useNavigate();
  const session = useSession();

  const topics = topicProgress(session.attempts);
  const unit = unitProgress(session.attempts);
  const resume = resumePoint(session);
  const resumeQuestion = getQuestion(resume.packageId);
  const revisit = lastRevisit(session.attempts);
  const isNew = unit.done === 0;

  const [selected, setSelected] = useState(resumeQuestion?.taxonomy.topic || topics[0].code);
  const selectedTopic = topics.find((t) => t.code === selected) || topics[0];

  const open = (topic, mode) => {
    const next = topic.questions.find((q) => !session.attempts[q.package_id]) || topic.questions[0];
    if (next) navigate(`/${mode}/${next.package_id}`);
  };

  const resumePosition = resumeQuestion ? positionInTopic(resumeQuestion) : null;

  return (
    <div style={{
      width: 'var(--plate-width)', minHeight: '100vh', margin: '0 auto',
      background: 'var(--surface-plate)', display: 'flex', flexDirection: 'column',
      fontFamily: 'var(--font-body)', color: 'var(--text-body)'
    }}>
      <Masthead
        course={COURSE.title}
        right={<span style={{
          fontSize: 13, fontWeight: 700, letterSpacing: '.12em',
          textTransform: 'uppercase', color: 'var(--paper-000)'
        }}>Home</span>}
      />
      <Breadcrumb items={['Home', UNIT.heading]} right={`${unit.done} of ${unit.total} questions done`} />

      <div style={{
        flex: '1 1 auto', display: 'flex', flexDirection: 'column', gap: 'var(--space-6)',
        padding: 'var(--space-8) var(--gutter)', background: 'var(--surface-desk)'
      }}>

        {/* WELCOME -- honest to what the app actually knows right now. */}
        <PaneShell voice="plain">
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 'var(--space-6)' }}>
            <div>
              <span style={eyebrow}>{isNew ? 'Welcome' : 'Studying'}</span>
              <p style={{ ...body, marginTop: 4, fontSize: 'var(--type-question-size)', lineHeight: 'var(--type-question-line)', color: 'var(--text-body)' }}>
                <strong>{COURSE.title}</strong> — your only subject so far.
              </p>
            </div>
            <p style={{ ...body, textAlign: 'right' }}>
              {COURSE.exam}. You have covered 1 of {COURSE.unitsInCourse} units.
            </p>
          </div>
        </PaneShell>

        {/* HERO -- the one primary action on the screen. */}
        <PaneShell
          voice="question"
          eyebrow={isNew ? 'Start here' : 'Where you left off'}
          title={resumeQuestion ? `${resumeQuestion.taxonomy.topic} ${resumeQuestion.taxonomy.topic_title}` : UNIT.title}
          right={<ScoreChip earned={unit.done} total={unit.total} tone="neutral" label="Unit" />}
        >
          <div style={{ display: 'grid', gap: 16 }}>
            <p style={{ margin: 0, fontSize: 'var(--type-question-size)', lineHeight: 'var(--type-question-line)' }}>
              {resumeQuestion
                ? `Question ${resumePosition.number} — ${resumeQuestion.title.toLowerCase()}.`
                : 'Pick a topic from the curriculum below to begin.'}
            </p>

            <div style={{
              background: isNew ? 'var(--surface-chrome)' : 'var(--surface-work)',
              border: isNew ? '1px solid var(--rule-300)' : '1px solid var(--purple-rule)',
              borderTop: isNew ? 'none' : 'var(--border-cap) solid var(--cap-work)',
              padding: '12px 14px'
            }}>
              <span style={eyebrow}>{isNew ? 'Why this' : 'Last attempt'}</span>
              {isNew ? (
                <p style={body}>There's no work from you in this unit yet, so there is nothing to recommend honestly. Question 1 is the one thing that makes the next recommendation real.</p>
              ) : revisit ? (
                <p style={body}>
                  {revisit.earned} of {revisit.total} points. The missed point was{' '}
                  <strong style={{ color: 'var(--text-revisit)' }}>↻ {revisit.label}</strong> — it is still available.
                </p>
              ) : (
                <p style={body}>Every point earned so far. Keep the habits that got them.</p>
              )}
            </div>

            <div>
              <span style={eyebrow}>This unit's habits</span>
              <ul style={{
                margin: 0, padding: '0 0 0 18px', display: 'grid', gap: 4,
                fontSize: 'var(--type-body-size)', lineHeight: 'var(--type-body-line)', color: 'var(--text-secondary)'
              }}>
                <li>Name both variables before you name a number.</li>
                <li>Keep the response a predicted mean.</li>
                <li>Say association until the design earns cause.</li>
              </ul>
            </div>

            <ActionRow
              primary={
                <ActionButton
                  variant="primary"
                  disabled={!resumeQuestion}
                  onClick={() => navigate(`/${resume.mode}/${resume.packageId}`)}
                >
                  {isNew ? 'Start question 1' : `Resume question ${resumePosition.number}`}
                </ActionButton>
              }
              secondary={<ActionButton variant="link" onClick={session.reset}>Start over</ActionButton>}
              note="Practice mode"
            />
          </div>
        </PaneShell>

        {/* CURRICULUM -- progress derived from attempts, never stored twice. */}
        <PaneShell
          voice="rubric"
          eyebrow="Curriculum"
          title={UNIT.heading}
          right={<span style={count}>{unit.done} of {unit.total} done</span>}
        >
          <div style={{ display: 'flex', alignItems: 'center', gap: 20, paddingBottom: 12, borderBottom: '1px solid var(--rule-divider)' }}>
            <span style={{ display: 'flex', alignItems: 'center', gap: 7 }}>
              <span style={{ width: 12, height: 12, background: 'var(--blue-600)' }} />
              <span style={count}>Done</span>
            </span>
            <span style={{ display: 'flex', alignItems: 'center', gap: 7 }}>
              <span style={{ width: 12, height: 12, background: 'var(--rule-300)' }} />
              <span style={count}>Not yet reached</span>
            </span>
          </div>

          <div style={{ display: 'flex', flexWrap: 'wrap', gap: 16, marginTop: 16 }}>
            {topics.map((t) => {
              const active = selected === t.code;
              return (
                <div
                  key={t.code}
                  role="button"
                  tabIndex={0}
                  onClick={() => setSelected(t.code)}
                  onKeyDown={(e) => {
                    if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); setSelected(t.code); }
                  }}
                  style={{
                    width: 264, cursor: 'pointer',
                    background: active ? 'var(--orange-050)' : 'var(--surface-pane)',
                    border: active ? '2px solid var(--orange-500)' : '1px solid var(--rule-300)',
                    borderTop: active ? '2px solid var(--orange-700)' : 'var(--border-cap) solid var(--rule-400)',
                    padding: '12px 14px'
                  }}
                >
                  <span style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between' }}>
                    <span style={{ fontSize: 'var(--type-count-size)', fontWeight: 700, letterSpacing: '.06em', color: 'var(--text-eyebrow)' }}>{t.code}</span>
                    <span style={{ fontSize: 'var(--type-count-size)', fontWeight: 600, color: 'var(--text-secondary)' }}>
                      {t.earned} of {t.available} pts
                    </span>
                  </span>
                  <span style={{
                    display: 'block', margin: '3px 0 10px', fontSize: 'var(--type-option-size)',
                    lineHeight: 'var(--type-option-line)', fontWeight: 600
                  }}>{t.title}</span>
                  <span style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 8 }}>
                    <span style={{ fontSize: 'var(--type-count-size)', color: 'var(--text-secondary)' }}>{t.done} of {t.total}</span>
                    <span style={{ display: 'inline-flex', gap: 3 }}>
                      {Array.from({ length: t.total }).map((_, k) => (
                        <span key={k} style={{ width: 9, height: 9, background: k < t.done ? 'var(--blue-600)' : 'var(--rule-300)' }} />
                      ))}
                    </span>
                  </span>
                </div>
              );
            })}
          </div>

          {/* The unit has nine topics; only the ones with authored content are
              shown. Say so rather than rendering empty cards for the rest. */}
          <p style={{ ...body, marginTop: 14, fontSize: 'var(--type-count-size)', color: 'var(--text-quiet)' }}>
            Showing the {topics.length} topics with practice written so far. The rest of {UNIT.label} lands as content is authored.
          </p>

          <div style={{ marginTop: 16, borderTop: '1px solid var(--rule-divider)', paddingTop: 14, display: 'flex', alignItems: 'center', gap: 16 }}>
            <ActionButton variant="quiet" onClick={() => open(selectedTopic, 'practice')}>
              Practise {selectedTopic.code}
            </ActionButton>
            <ActionButton variant="link" onClick={() => open(selectedTopic, 'open-hand')}>
              Open {selectedTopic.code} face-up
            </ActionButton>
            <span style={{ marginLeft: 'auto', ...count }}>
              Open Hand is free to explore · Practice is scored
            </span>
          </div>
        </PaneShell>

        {/* HOW IT WORKS -- general explainer, needs no history. */}
        <PaneShell voice="reference" eyebrow="How it works" title="Two modes">
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 24 }}>
            <div>
              <span style={eyebrow}>Open Hand</span>
              <p style={body}>Nothing is hidden. The rubric or answer key is face-up and you move it yourself to watch the score change. Nothing is scored.</p>
            </div>
            <div>
              <span style={eyebrow}>Practice</span>
              <p style={body}>The same question with the scoring withheld. Pull a hint only if you need one — every hint is listed on your feedback.</p>
            </div>
            <div>
              <span style={eyebrow}>Marks</span>
              <ul style={{
                margin: 0, padding: 0, listStyle: 'none', display: 'grid', gap: 7,
                fontSize: 'var(--type-body-size)', lineHeight: 'var(--type-body-line)', color: 'var(--text-secondary)'
              }}>
                <li><span style={{ color: 'var(--text-earned)', fontWeight: 700 }}>✓</span>&nbsp;&nbsp;point earned</li>
                <li><span style={{ color: 'var(--text-revisit)', fontWeight: 700 }}>↻</span>&nbsp;&nbsp;revisit — still available</li>
                <li><span style={{ color: 'var(--text-lost)', fontWeight: 700 }}>✕</span>&nbsp;&nbsp;Open Hand only: point taken back</li>
                <li><span style={{ color: 'var(--text-hint)', fontWeight: 700 }}>?</span>&nbsp;&nbsp;a hint, and what it costs</li>
              </ul>
            </div>
          </div>
        </PaneShell>

      </div>

      <div style={{
        flex: '0 0 auto', height: 'var(--caption-height)', display: 'flex', alignItems: 'center', padding: '0 var(--gutter)',
        fontSize: 'var(--type-caption-size)', lineHeight: 'var(--type-caption-line)', fontWeight: 'var(--type-caption-weight)', color: 'var(--text-quiet)'
      }}>
        CramApple · {COURSE.title} · {UNIT.heading}
      </div>
    </div>
  );
}
