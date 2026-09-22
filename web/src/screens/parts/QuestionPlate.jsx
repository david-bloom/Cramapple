import React, { useCallback, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Plate, PlateGrid, Masthead, Breadcrumb, StudyMap, DeepDiveOverlay } from '../../components/index.js';
import { COURSE, UNIT, positionInTopic } from '../../content/index.js';
import { topicLabel } from '../../content/adapter.js';
import { useSession } from '../../session/SessionProvider.jsx';
import { topicProgress } from '../../session/progress.js';

/**
 * The chrome every question screen shares: the fixed plate, the masthead, the
 * breadcrumb, the three-column grid, and the two overlays.
 *
 * Both overlays are rendered here rather than inside a pane, because the study
 * map drops under the breadcrumb across the full width and the deep dive covers
 * the whole frame below the breadcrumb -- neither fits inside the centre pane.
 */
export function QuestionPlate({ question, mode, children }) {
  const navigate = useNavigate();
  const session = useSession();
  const [mapOpen, setMapOpen] = useState(false);
  const [deepOpen, setDeepOpen] = useState(false);

  const real = question.source === 'package';
  const { number, total } = real ? { number: 1, total: 1 } : positionInTopic(question);
  const modeLabel = mode === 'open-hand' ? 'Open Hand' : 'Practice';
  const { topic, topic_title: topicTitle } = question.taxonomy;

  const topics = real ? [] : topicProgress(session.attempts).map((t) => ({
    ...t,
    current: t.code === topic
  }));

  const closeMap = useCallback(() => setMapOpen(false), []);
  const closeDeep = useCallback(() => setDeepOpen(false), []);

  const copyDeepDive = question.deepDive
    ? () => {
      const text = [
        question.deepDive.title,
        ...question.deepDive.sections.map((s) => `${s.title}\n${s.body}`)
      ].join('\n\n');
      if (navigator.clipboard) navigator.clipboard.writeText(text).catch(() => {});
    }
    : undefined;

  return (
    <Plate caption={real
      ? `CramApple · ${question.taxonomy.course} · ${topicLabel(question)} · ${modeLabel} · real package`
      : `CramApple · ${COURSE.title} · ${UNIT.label} · ${topic} ${topicTitle} · ${modeLabel}`}>
      <Masthead
        course={real ? question.taxonomy.course : COURSE.title}
        right={<span style={{
          fontSize: 13, fontWeight: 700, letterSpacing: '.12em',
          textTransform: 'uppercase', color: 'var(--paper-000)'
        }}>{modeLabel}</span>}
      />
      <Breadcrumb
        items={real
          ? [question.taxonomy.course, topicLabel(question)]
          : [UNIT.label, `${topic} ${topicTitle}`, `Question ${number}`]}
        mapOpen={mapOpen}
        onOpenMap={real ? undefined : () => setMapOpen((m) => !m)}
        right={real ? question.package_id : `Question ${number} of ${total}`}
      />

      <PlateGrid>{typeof children === 'function' ? children({ openDeepDive: () => setDeepOpen(true) }) : children}</PlateGrid>

      <StudyMap
        open={mapOpen}
        unit={UNIT.heading}
        topics={topics}
        onClose={closeMap}
        onPick={(t) => {
          const first = t.questions[0];
          closeMap();
          if (first) navigate(`/${mode}/${first.package_id}`);
        }}
      />

      {question.deepDive && (
        <DeepDiveOverlay
          open={deepOpen}
          title={question.deepDive.title}
          sections={question.deepDive.sections}
          onClose={closeDeep}
          onCopy={copyDeepDive}
        />
      )}
    </Plate>
  );
}
