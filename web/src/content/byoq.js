/**
 * Student-submitted (BYOQ) items.
 *
 * Persisted to localStorage, same seam as session/SessionProvider.jsx -- when
 * this frontend gets a backend, replace load()/save() with API calls and
 * nothing downstream changes.
 *
 * A BYOQ item is tagged `source: 'student'` and, by construction, never carries
 * an answer: no MCQ choice has `is_correct: true`, no FRQ has `criteria`, and no
 * hint of kind `eliminate`/`rubric` exists, because none of those can be
 * authored for a problem CramApple did not write and the submitting student has
 * not solved. See docs/activity_log/DECISIONS_LOG.md DECISION-0057.
 */

const STORAGE_KEY = 'cramapple.byoq.v1';

function load() {
  try {
    const raw = window.localStorage.getItem(STORAGE_KEY);
    return raw ? JSON.parse(raw) : {};
  } catch {
    return {};
  }
}

function save(all) {
  try {
    window.localStorage.setItem(STORAGE_KEY, JSON.stringify(all));
  } catch {
    // A student in private browsing still gets a working session, just not a
    // durable one -- never let storage failure block submission.
  }
}

function makePackageId() {
  return `byoq-${Date.now().toString(36)}-${Math.random().toString(36).slice(2, 7)}`;
}

/**
 * @param {object} input
 * @param {'mcq'|'frq'} input.item_type
 * @param {string} input.title
 * @param {string} input.stemText
 * @param {'Easy'|'Medium'|'Hard'} input.difficulty
 * @param {{code: string, title: string}} input.topic
 * @param {string[]} [input.choiceTexts] required for item_type: 'mcq', 2-4 entries
 * @param {object|null} [input.reference] borrowed from a library item in the same topic
 * @returns the created item, already persisted
 */
export function createByoqItem(input) {
  const package_id = makePackageId();

  const base = {
    source: 'student',
    schema_version: '1.0.0',
    package_id,
    item_type: input.item_type,
    difficulty: input.difficulty,

    taxonomy: {
      course: 'AP Statistics',
      unit: 'Unit 2',
      unit_title: 'Exploring Two-Variable Data',
      topic: input.topic.code,
      topic_title: input.topic.title
    },

    title: input.title,
    stem: [{ type: 'text', value: input.stemText }],

    points: input.item_type === 'mcq' ? 1 : 4,
    scoringNote: "This is your own question. CramApple didn't write it, so it can't be scored.",

    // Never authored, never populated -- see the module comment.
    habits: null,
    hints: [],
    deepDive: null,
    coaching: null,
    reference: input.reference || null,

    ...(input.item_type === 'mcq'
      ? {
        choices: input.choiceTexts.map((text, i) => ({
          choice_key: String.fromCharCode(65 + i),
          text,
          is_correct: false,
          rationale: null,
          minimum_fix: null
        }))
      }
      : { criteria: [] })
  };

  const all = load();
  all[package_id] = base;
  save(all);
  return base;
}

export function getByoqItem(packageId) {
  if (!packageId || !packageId.startsWith('byoq-')) return null;
  const all = load();
  return all[packageId] || null;
}
