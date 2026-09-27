import * as React from 'react';

/**
 * The post-submission card: verdict, score, coaching, per-criterion marks, the student's own work, and the hints-used receipt strip.
 * @startingPoint section="Plate" subtitle="Verdict, score, coaching, hints-used strip" viewport="700x340"
 */
export interface FeedbackCardProps {
  verdict?: 'correct' | 'incorrect';
  /** Points earned. */
  earned?: number | null;
  /** Points available. Omit to hide the score. */
  total?: number;
  /** One to three sentences naming what the reading did — never judging the student. Corrections open "Fix:" or "Next time:". */
  coaching?: React.ReactNode;
  /** Every hint pulled, listed again here. The receipt never disappears. */
  hintsUsed?: string[];
  /** Per-criterion (FRQ) or per-choice (MCQ) mark list — usually RubricCriterionRow children. */
  marks?: React.ReactNode;
  /** The student's submitted work, kept visible in a white band so coaching reads against it. */
  submitted?: React.ReactNode;
  submittedLabel?: string;
}
export declare function FeedbackCard(props: FeedbackCardProps): JSX.Element;
