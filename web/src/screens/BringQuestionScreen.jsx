import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import {
  PaneShell, Masthead, Breadcrumb, ActionRow, ActionButton, AnswerField
} from '../components/index.js';
import { COURSE, TOPICS, referenceForTopic } from '../content/index.js';
import { createByoqItem } from '../content/byoq.js';
import { eyebrow, body, count } from './parts/text.js';

const DIFFICULTIES = ['Easy', 'Medium', 'Hard'];

const fieldLabel = { ...eyebrow, marginBottom: 6 };
const textInput = {
  width: '100%', background: 'var(--surface-work)', color: 'var(--text-body)',
  border: '1px solid var(--rule-300)', borderRadius: 'var(--radius-all)',
  padding: '10px 12px', fontFamily: 'var(--font-body)', fontSize: 'var(--type-body-size)', outline: 'none'
};

/**
 * BYOQ intake. A scrolling hub page like Home, not the fixed no-scroll Plate --
 * a form this dynamic (item type, a variable choice list) doesn't fit that
 * rule, and Home already establishes the alternative.
 *
 * This only collects what content/byoq.js can actually turn into a Practice
 * item: no photo/document upload is wired up (see the AnswerField note below),
 * and no answer is ever asked for, because CramApple never grades a BYOQ item --
 * see DECISION-0057.
 */
export function BringQuestionScreen() {
  const navigate = useNavigate();

  const [itemType, setItemType] = useState('mcq');
  const [title, setTitle] = useState('');
  const [topicCode, setTopicCode] = useState(TOPICS[0].code);
  const [difficulty, setDifficulty] = useState('Medium');
  const [stemText, setStemText] = useState('');
  const [choices, setChoices] = useState(['', '', '', '']);
  const [photoNotice, setPhotoNotice] = useState(false);

  const topic = TOPICS.find((t) => t.code === topicCode) || TOPICS[0];
  const filledChoices = choices.map((c) => c.trim()).filter(Boolean);

  const canSubmit = title.trim().length > 0
    && stemText.trim().length > 0
    && (itemType === 'frq' || filledChoices.length >= 2);

  const setChoiceAt = (i, value) => setChoices((cs) => cs.map((c, k) => (k === i ? value : c)));
  const removeChoiceAt = (i) => setChoices((cs) => cs.filter((_, k) => k !== i));
  const addChoice = () => setChoices((cs) => (cs.length < 4 ? [...cs, ''] : cs));

  const submit = () => {
    const item = createByoqItem({
      item_type: itemType,
      title: title.trim(),
      stemText: stemText.trim(),
      difficulty,
      topic: { code: topic.code, title: topic.title },
      choiceTexts: itemType === 'mcq' ? filledChoices : undefined,
      reference: referenceForTopic(topic.code)
    });
    navigate(`/practice/${item.package_id}`);
  };

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
        }}>Bring a Question</span>}
      />
      <Breadcrumb items={['Home', 'Bring a question']} />

      <div style={{
        flex: '1 1 auto', display: 'flex', flexDirection: 'column', gap: 'var(--space-6)',
        padding: 'var(--space-8) var(--gutter)', background: 'var(--surface-desk)'
      }}>
        <PaneShell voice="plain">
          <p style={body}>
            Type or paste a question from your own homework, an outside worksheet, or a
            practice exam. CramApple will hold it for you to practice against, but it
            doesn't have an answer key for it — nothing here gets scored, and it never
            appears in Open Hand, which only shows CramApple's own questions face-up.
          </p>
        </PaneShell>

        <PaneShell voice="question" eyebrow="Your question" title="Bring a question">
          <div style={{ display: 'grid', gap: 20 }}>
            <div>
              <span style={fieldLabel}>Question type</span>
              <div style={{ display: 'flex', gap: 10 }}>
                <ActionButton variant={itemType === 'mcq' ? 'primary' : 'quiet'} onClick={() => setItemType('mcq')}>
                  Multiple choice
                </ActionButton>
                <ActionButton variant={itemType === 'frq' ? 'primary' : 'quiet'} onClick={() => setItemType('frq')}>
                  Free response
                </ActionButton>
              </div>
            </div>

            <div style={{ display: 'grid', gridTemplateColumns: '2fr 1fr 1fr', gap: 16 }}>
              <div>
                <span style={fieldLabel}>Title</span>
                <input
                  type="text" value={title} onChange={(e) => setTitle(e.target.value)}
                  placeholder="A short name for this question" style={textInput}
                />
              </div>
              <div>
                <span style={fieldLabel}>Topic</span>
                <select value={topicCode} onChange={(e) => setTopicCode(e.target.value)} style={textInput}>
                  {TOPICS.map((t) => <option key={t.code} value={t.code}>{t.code} {t.title}</option>)}
                </select>
              </div>
              <div>
                <span style={fieldLabel}>Difficulty</span>
                <select value={difficulty} onChange={(e) => setDifficulty(e.target.value)} style={textInput}>
                  {DIFFICULTIES.map((d) => <option key={d} value={d}>{d}</option>)}
                </select>
              </div>
            </div>

            <div>
              <span style={fieldLabel}>Question</span>
              <AnswerField
                value={stemText}
                onChange={setStemText}
                rows={4}
                placeholder="Type or paste the question"
                attachLabel="Add a photo of the question"
                onAttach={() => setPhotoNotice(true)}
              />
              {photoNotice && (
                <p style={{ ...count, marginTop: 6 }}>
                  Photo capture isn't part of this preview yet — type or paste the question above.
                </p>
              )}
            </div>

            {itemType === 'mcq' && (
              <div>
                <span style={fieldLabel}>Answer choices</span>
                <div style={{ display: 'grid', gap: 8 }}>
                  {choices.map((c, i) => (
                    <div key={i} style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                      <span style={{ width: 18, fontWeight: 700, color: 'var(--text-secondary)' }}>
                        {String.fromCharCode(65 + i)}
                      </span>
                      <input
                        type="text" value={c} onChange={(e) => setChoiceAt(i, e.target.value)}
                        placeholder={`Choice ${String.fromCharCode(65 + i)}`} style={{ ...textInput, flex: '1 1 auto' }}
                      />
                      {choices.length > 2 && (
                        <ActionButton variant="link" onClick={() => removeChoiceAt(i)}>Remove</ActionButton>
                      )}
                    </div>
                  ))}
                </div>
                {choices.length < 4 && (
                  <div style={{ marginTop: 8 }}>
                    <ActionButton variant="link" onClick={addChoice}>Add another choice</ActionButton>
                  </div>
                )}
                <p style={{ ...count, marginTop: 8 }}>
                  You don't need to know which one is correct — CramApple doesn't grade your
                  own questions.
                </p>
              </div>
            )}

            <ActionRow
              note={canSubmit ? 'Ready to practice' : 'Title, topic and question are required'}
              primary={<ActionButton variant="primary" disabled={!canSubmit} onClick={submit}>Practice this question</ActionButton>}
              secondary={<ActionButton variant="link" onClick={() => navigate('/')}>Cancel</ActionButton>}
            />
          </div>
        </PaneShell>
      </div>

      <div style={{
        flex: '0 0 auto', height: 'var(--caption-height)', display: 'flex', alignItems: 'center', padding: '0 var(--gutter)',
        fontSize: 'var(--type-caption-size)', lineHeight: 'var(--type-caption-line)', fontWeight: 'var(--type-caption-weight)', color: 'var(--text-quiet)'
      }}>
        CramApple · {COURSE.title} · Bring a Question
      </div>
    </div>
  );
}
