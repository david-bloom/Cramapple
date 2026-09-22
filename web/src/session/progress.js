import { TOPICS, ALL_QUESTIONS } from '../content/index.js';

/**
 * Progress is derived from recorded attempts, never stored separately -- one
 * source of truth means the study map and the home plate can never disagree.
 * Only Practice attempts count as done: Open Hand is a demonstration and
 * nothing in it is scored.
 */

/** Only the sample walkthrough forms a study map; real packages are reviewed directly. */
export function topicProgress(attempts) {
  return TOPICS.map((t) => {
    const done = t.questions.filter((q) => attempts[q.package_id]?.mode === 'practice').length;
    const earned = t.questions.reduce((s, q) => s + (attempts[q.package_id]?.earned || 0), 0);
    const available = t.questions.reduce((s, q) => s + (q.points || 0), 0);
    return { ...t, done, total: t.questions.length, earned, available };
  });
}

export function unitProgress(attempts) {
  const done = ALL_QUESTIONS.filter((q) => attempts[q.package_id]?.mode === 'practice').length;
  return { done, total: ALL_QUESTIONS.length };
}

/**
 * Where to send the student when they resume.
 *
 * Only the walkthrough resumes. A real package reached directly for review is
 * not part of it and must not become the home plate's resume target -- it has
 * no topic, no position and no place on the study map.
 */
export function resumePoint(session) {
  const lastIsInWalkthrough = session.last
    && ALL_QUESTIONS.some((q) => q.package_id === session.last.packageId);
  if (lastIsInWalkthrough) return session.last;
  const firstUnattempted = ALL_QUESTIONS.find((q) => !session.attempts[q.package_id]);
  const target = firstUnattempted || ALL_QUESTIONS[0];
  return { packageId: target.package_id, mode: 'practice' };
}

/**
 * The most recent Practice attempt that left a point on the table, phrased for
 * the home plate. Returns null when there is nothing to revisit.
 */
export function lastRevisit(attempts) {
  const scored = ALL_QUESTIONS
    .map((q) => ({ question: q, attempt: attempts[q.package_id] }))
    .filter((r) => r.attempt && r.attempt.mode === 'practice')
    .sort((a, b) => (b.attempt.submittedAt || 0) - (a.attempt.submittedAt || 0));

  const miss = scored.find((r) => r.attempt.earned < r.attempt.total);
  if (!miss) return null;

  const mark = (miss.attempt.marks || []).find((m) => m.state === 'revisit');
  return {
    question: miss.question,
    earned: miss.attempt.earned,
    total: miss.attempt.total,
    label: mark ? (mark.label || `option ${mark.choice_key}`) : null
  };
}
