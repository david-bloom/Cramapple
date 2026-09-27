/**
 * Local grading.
 *
 * This is a deterministic stand-in, not the product's grader. The real one is
 * in supabase/functions/_shared/ (grading-router, deterministic-verifier,
 * grading-partial-credit) and is what should score a student's work once this
 * frontend talks to a backend. Everything here is criterion-level and
 * explainable on purpose, so the seam is obvious: replace gradeFrq() with a
 * call to the grading router and keep the same return shape.
 *
 * Product rules encoded here:
 *  - A missed point is `revisit` (the ↻ mark), never `taken` (✕). ✕ is the
 *    teacher's hand in Open Hand and belongs nowhere in Practice.
 *  - Coaching names the error and opens with Fix: or Next time:. It never
 *    judges the student.
 */

function normalize(text) {
  return String(text || '')
    .toLowerCase()
    .replace(/[‘’]/g, "'")
    .replace(/[“”]/g, '"')
    .replace(/\s+/g, ' ')
    .trim();
}

function anyMatch(patterns, text) {
  return (patterns || []).some((p) => new RegExp(p, 'i').test(text));
}

function allMatch(patterns, text) {
  return (patterns || []).every((p) => new RegExp(p, 'i').test(text));
}

/** True when the response satisfies this criterion. */
export function criterionEarned(criterion, response) {
  const text = normalize(response);
  if (!text) return false;
  if (criterion.disqualify && anyMatch(criterion.disqualify, text)) return false;
  const matched = criterion.matchMode === 'all'
    ? allMatch(criterion.match, text)
    : anyMatch(criterion.match, text);
  return matched;
}

/**
 * Score a written response against the item's rubric.
 * @returns {{marks: Array, earned: number, total: number, verdict: string, coaching: string}}
 */
export function gradeFrq(question, response) {
  const marks = question.criteria.map((c) => ({
    criterion_key: c.criterion_key,
    code: c.code,
    label: c.label,
    detail: c.detail,
    points: c.points,
    state: criterionEarned(c, response) ? 'earned' : 'revisit',
    minimum_fix: c.minimum_fix
  }));

  const earned = marks.filter((m) => m.state === 'earned').reduce((s, m) => s + m.points, 0);
  const total = question.criteria.reduce((s, c) => s + c.points, 0);
  const missed = marks.filter((m) => m.state !== 'earned');

  return {
    marks,
    earned,
    total,
    verdict: earned === total ? 'correct' : 'incorrect',
    coaching: frqCoaching(question, earned, total, missed)
  };
}

function frqCoaching(question, earned, total, missed) {
  if (missed.length === 0) {
    return question.coaching?.allEarned
      || 'Every criterion is there. Write it the same way next time.';
  }

  const lead = earned === 0
    ? 'None of the rubric moves landed yet.'
    : `${earned} of ${total} moves are there. ${question.coaching?.lead || ''}`.trim();

  // Name one error, not all of them -- a list of four fixes teaches nothing.
  const first = missed[0];
  const rest = missed.length > 1
    ? ` The other ${missed.length - 1} ${missed.length === 2 ? 'criterion is' : 'criteria are'} marked ↻ in the rubric — still available next attempt.`
    : '';

  return `${lead} Fix: ${first.minimum_fix}${rest}`;
}

/**
 * Score a multiple-choice submission.
 * @returns {{earned: number, total: number, verdict: string, coaching: string, marks: Array}}
 */
export function gradeMcq(question, pickedKey) {
  const picked = question.choices.find((c) => c.choice_key === pickedKey);
  const correct = Boolean(picked && picked.is_correct);

  const marks = question.choices.map((c) => ({
    choice_key: c.choice_key,
    is_correct: c.is_correct,
    picked: c.choice_key === pickedKey,
    state: c.is_correct ? 'earned' : c.choice_key === pickedKey ? 'revisit' : 'pending',
    note: c.is_correct ? 'Credited' : c.minimum_fix,
    rationale: c.rationale
  }));

  return {
    marks,
    earned: correct ? 1 : 0,
    total: 1,
    verdict: correct ? 'correct' : 'incorrect',
    coaching: correct
      ? (question.coaching?.correct || 'Correct, and for the right reason.')
      : `You picked ${pickedKey}. ${picked ? picked.rationale : ''} ${question.coaching?.incorrectTail || ''}`.replace(/\s+/g, ' ').trim()
  };
}

/** Dispatch on item type. */
export function grade(question, submission) {
  return question.item_type === 'mcq'
    ? gradeMcq(question, submission)
    : gradeFrq(question, submission);
}
