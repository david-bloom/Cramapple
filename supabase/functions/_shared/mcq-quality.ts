// MCQ answer-choice quality checks that are independent of structural
// completeness (content-preflight's job elsewhere) — these catch authoring
// patterns that make an item easier to guess than to solve.
//
// Length-parity: 2026-07-21 QA review (tutor feedback from Jill, AP
// Statistics) found the correct choice is systematically longer than its
// distractors — 75% of published AP Statistics MCQs and 87% of published AP
// Biology MCQs, with the correct choice averaging 1.6x-1.7x a distractor's
// length. That's a detectable "pick the longest answer" tell independent of
// subject knowledge. This is a WARNING, not a blocking defect: a genuinely
// longer correct answer can be legitimate (e.g. a correct choice naming two
// mechanisms where every distractor only needs one), so it requires human
// judgment, not an automatic rejection.

export type MinimalChoice = {
  choice_text: string;
  is_correct: boolean;
};

export type LengthParityFinding = {
  code: "MCQ_CORRECT_ANSWER_LENGTH_OUTLIER";
  severity: "warning";
  correct_length: number;
  distractor_avg_length: number;
  ratio: number;
};

// Ratio above which the correct answer is a detectable length-based tell.
// Calibrated against the 2026-07-21 review: population averages measured
// 1.60x (AP Statistics, n=118) and 1.73x (AP Biology, n=54); 1.4x sits below
// both, so it flags earlier than the observed norm rather than only at it.
const LENGTH_PARITY_RATIO_THRESHOLD = 1.4;

export function checkAnswerLengthParity(
  choices: MinimalChoice[],
): LengthParityFinding | null {
  const correct = choices.filter((c) => c.is_correct);
  const distractors = choices.filter((c) => !c.is_correct);
  if (correct.length !== 1 || distractors.length === 0) return null;

  const correctLength = correct[0].choice_text.length;
  const distractorAvgLength =
    distractors.reduce((sum, c) => sum + c.choice_text.length, 0) /
    distractors.length;

  if (distractorAvgLength === 0) return null;

  const ratio = correctLength / distractorAvgLength;
  if (ratio < LENGTH_PARITY_RATIO_THRESHOLD) return null;

  return {
    code: "MCQ_CORRECT_ANSWER_LENGTH_OUTLIER",
    severity: "warning",
    correct_length: correctLength,
    distractor_avg_length: Math.round(distractorAvgLength * 10) / 10,
    ratio: Math.round(ratio * 100) / 100,
  };
}
