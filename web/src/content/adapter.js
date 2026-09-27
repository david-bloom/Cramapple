/**
 * Real item packages → what the screens need.
 *
 * This is the seam the README describes, now carrying real content. The source
 * is `content/item-packages/` at the repo root, imported unmodified through the
 * `@packages` alias — nothing is copied, so nothing can drift.
 *
 * The rule here is that **nothing is invented**. Where the design system wants
 * content an item package does not carry, this returns `null` and the screen
 * renders a marked absence. Authoring that content is the pipeline's job
 * (`prompts/`, INV-3, the double-approve rule) and fabricating it here would put
 * unvetted pedagogy in front of a student under the product's own styling.
 *
 * What a package carries, and what it does not, is listed in MISSING below.
 */

/** Fields the plates want that no MCQ package supplies. Rendered as absences. */
export const MISSING = {
  title: 'Pane title — packages carry no human title, only a taxonomy node.',
  habits: 'How points are earned / lost — not in the package schema.',
  reference: 'Topic, skills, vocabulary, on-the-exam — not in the package schema.',
  hints: 'No hint is defined, so nothing says which distractors an elimination hint would strike.',
  deepDive: 'Only a one-line expected_reasoning exists, not the three-section deep dive.',
  choiceFix: 'Per-distractor "Fix:" line — rationales say why a choice tempts, not how to correct it.',
  coaching: 'Per-verdict coaching copy — not in the package schema.'
};

const TITLE_CASE = (s) => s.replace(/(^|[\s-])(\w)/g, (m) => m.toUpperCase());

/** `unit-3-trigonometric-and-polar-functions` → `Unit 3 · Trigonometric and Polar Functions` */
function readUnit(nodeKey) {
  const m = /^unit-(\d+)-(.*)$/.exec(nodeKey || '');
  if (!m) return null;
  return { label: `Unit ${m[1]}`, title: TITLE_CASE(m[2].replace(/-/g, ' ')) };
}

/** `topic-3.9` → `3.9` */
function readTopic(nodeKey) {
  const m = /^topic-([\d.]+)$/.exec(nodeKey || '');
  return m ? m[1] : null;
}

/** `ap_calculus_ab` → `AP Calculus AB` */
function readCourse(examCode) {
  return (examCode || '')
    .split('_')
    .map((w) => (w === 'ap' ? 'AP' : w.length <= 2 ? w.toUpperCase() : TITLE_CASE(w)))
    .join(' ');
}

/**
 * Every prompt in the library inlines its own "A. … B. … C. … D. …" list, and
 * the plate renders the choices as their own rows. Left in, the student reads
 * every option twice. Strip the block and keep the question.
 */
export function splitPrompt(prompt) {
  const at = (prompt || '').search(/\n\s*A[.)]\s/);
  return at === -1
    ? { stem: (prompt || '').trim(), inlinedChoices: false }
    : { stem: prompt.slice(0, at).trim(), inlinedChoices: true };
}

/**
 * A stimulus whose only payload is a calculator rule is a directions line, not
 * question data — the plate has nowhere to put it, so it is surfaced separately
 * rather than dropped silently.
 */
function readStimuli(stimuli = []) {
  let directions = null;
  const rest = [];
  for (const s of stimuli) {
    const text = s?.payload?.text || '';
    const mode = s?.payload?.calculator_mode;
    if (s.stimulus_key === 'directions' || (mode && text.length < 80)) {
      directions = { text, calculatorMode: mode || null };
    } else if (text) {
      rest.push({ kind: 'text', key: s.stimulus_key, text });
    }
  }
  return { directions, stimuli: rest };
}

/** Map one MCQ item package onto the shape the MCQ screens read. */
export function adaptMcq(pkg) {
  const part = (pkg.parts || [])[0] || {};
  const { stem, inlinedChoices } = splitPrompt(part.prompt);
  const { directions, stimuli } = readStimuli(pkg.stimuli);

  const nodes = (pkg.taxonomy_refs || []).map((t) => t.node_key);
  const unit = nodes.map(readUnit).find(Boolean);
  const topic = nodes.map(readTopic).find(Boolean);
  const course = readCourse(pkg.exam_pack_ref?.exam_code);
  const reasoning = pkg.review_notes?.expected_reasoning || null;

  return {
    source: 'package',
    schema_version: pkg.schema_version,
    package_id: pkg.package_id,
    item_type: 'mcq',
    difficulty: pkg.difficulty,

    taxonomy: {
      course,
      unit: unit?.label || null,
      unit_title: unit?.title || null,
      // Half the library tags only a unit, so topic is legitimately null.
      topic: topic,
      topic_title: unit?.title || course
    },

    // No package carries a title; the screens mark the absence.
    title: null,
    stem: [{ type: 'text', value: stem }],
    inlinedChoices,
    directions,
    stimuli,

    points: part.points ?? 1,
    scoringNote: null,

    choices: (pkg.mcq_choices || []).map((c) => ({
      choice_key: c.choice_key,
      text: c.choice_text,
      is_correct: c.is_correct,
      rationale: c.rationale || null,
      // Rationales name why a choice tempts. They do not name the fix.
      minimum_fix: null
    })),

    habits: null,
    hints: [],
    reference: null,
    deepDive: null,
    openHandNote: null,
    coaching: null,

    // Kept so a screen can show what the package does say, rather than nothing.
    expectedReasoning: reasoning,
    teachingExplanation: pkg.review_notes?.teaching_explanation || null
  };
}

/** "3.9 Least-Squares Regression", or just the unit title when no topic node exists. */
export function topicLabel(q) {
  return q.taxonomy.topic ? `${q.taxonomy.topic} ${q.taxonomy.topic_title}` : q.taxonomy.topic_title;
}

export function adaptItem(pkg) {
  if (pkg.item_type === 'mcq') return adaptMcq(pkg);
  throw new Error(`No adapter for item_type "${pkg.item_type}" yet (${pkg.package_id})`);
}
