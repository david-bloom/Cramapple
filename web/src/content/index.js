import frq22 from './sample/apstats-2-2-frq-001.js';
import mcq22 from './sample/apstats-2-2-mcq-001.js';
import frq23a from './sample/apstats-2-3-frq-001.js';
import mcq23a from './sample/apstats-2-3-mcq-001.js';
import mcq23b from './sample/apstats-2-3-mcq-002.js';
import frq23b from './sample/apstats-2-3-frq-002.js';
import { REAL_ITEMS } from './real.js';
import { getByoqItem } from './byoq.js';

/**
 * The content layer.
 *
 * Every question here is a hand-written sample for the design system's Unit 2
 * walkthrough. The real items live in content/item-packages/ as JSON, produced
 * by the authoring pipeline in prompts/ and carrying provenance and fact-pack
 * refs. This module is the seam: swap these imports for a loader over those
 * packages and nothing downstream changes.
 *
 * Fields the screens rely on, beyond the repo's item-package schema:
 *   criteria[].match / .disqualify  -- local grading (see session/grade.js)
 *   creditedResponse[]              -- Open Hand phrase-to-criterion mapping
 *   habits, hints, reference,
 *   deepDive, coaching              -- the panes around the question
 */

export const COURSE = {
  code: 'ap-statistics',
  title: 'AP Statistics',
  exam: 'AP Statistics · May 2027',
  unitsInCourse: 9
};

export const UNIT = {
  key: 'unit-2',
  label: 'Unit 2',
  title: 'Exploring Two-Variable Data',
  get heading() { return `${this.label} · ${this.title}`; }
};

// Ordered. Question order inside a topic is the order a student meets them.
const QUESTIONS = [
  mcq22,
  frq22,
  frq23a,
  mcq23a,
  mcq23b,
  frq23b
];

export const TOPICS = [
  { code: '2.2', title: 'Scatterplots & Correlation' },
  { code: '2.3', title: 'Least-Squares Regression' }
].map((t) => ({
  ...t,
  questions: QUESTIONS.filter((q) => q.taxonomy.topic === t.code)
}));

export const ALL_QUESTIONS = TOPICS.flatMap((t) => t.questions);

/**
 * Real item packages, resolvable by the same routes as the samples. They sit
 * outside the sample unit deliberately: they belong to eight different courses
 * and do not form a study map, so Home and progress stay on the walkthrough
 * while these are reachable directly for review.
 */
export { REAL_ITEMS };

export const TOTAL_QUESTIONS = ALL_QUESTIONS.length;

export function getQuestion(packageId) {
  return ALL_QUESTIONS.find((q) => q.package_id === packageId)
    || REAL_ITEMS.find((q) => q.package_id === packageId)
    || getByoqItem(packageId);
}

export function getTopic(code) {
  return TOPICS.find((t) => t.code === code) || null;
}

/**
 * A library question's reference block for a given topic, for a BYOQ item to
 * borrow. CramApple-authored and topic-general, so it carries no answer to the
 * student's own submitted problem -- see content/byoq.js.
 */
export function referenceForTopic(code) {
  const topic = getTopic(code);
  const withReference = topic?.questions.find((q) => q.reference);
  return withReference?.reference || null;
}

/**
 * Position of a question within its topic, 1-indexed, plus the topic total.
 * Real packages are not in the walkthrough and have no position, so this
 * answers 1 of 1 rather than throwing.
 */
export function positionInTopic(question) {
  const topic = getTopic(question?.taxonomy?.topic);
  if (!topic) return { number: 1, total: 1 };
  const index = topic.questions.indexOf(question);
  return index === -1 ? { number: 1, total: 1 } : { number: index + 1, total: topic.questions.length };
}

/** The next question in the unit, crossing topic boundaries. Null at the end. */
export function nextQuestion(question) {
  const list = question.source === 'package' ? REAL_ITEMS : ALL_QUESTIONS;
  const i = list.indexOf(question);
  return i >= 0 && i < list.length - 1 ? list[i + 1] : null;
}

/** Plain text of a stem, for aria labels and the copied deep dive. */
export function stemText(question) {
  return question.stem.map((n) => n.value).join('');
}
