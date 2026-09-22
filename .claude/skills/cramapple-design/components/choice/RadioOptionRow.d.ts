import * as React from 'react';

/**
 * One MCQ choice: radio, letter, label, and — in Open Hand or after feedback — its verdict and named trap.
 * @startingPoint section="Plate" subtitle="MCQ choice rows: selected, credited, distractor, eliminated" viewport="700x260"
 */
export interface RadioOptionRowProps {
  /** A, B, C or D. */
  letter: string;
  /** The option text. */
  children: React.ReactNode;
  /** 2px purple border + filled dot + bolder label. Never a background wash. */
  selected?: boolean;
  /** What this option is. Every distractor must carry a named error. */
  verdict?: 'correct' | 'distractor';
  /** Show the Correct / Distractor tag. True in Open Hand from the start; in Practice only after submission. */
  showVerdict?: boolean;
  /** Ruled out by a hint or by the student. Clay ink, line-through, 55% opacity, not clickable. */
  eliminated?: boolean;
  /** Why it is credited, or why it tempts. One to three sentences in the language of the variables. */
  explanation?: React.ReactNode;
  /** The one-line correction, prefixed "Fix:". Required alongside a distractor explanation. */
  note?: React.ReactNode;
  /** Open Hand MCQ tracks explanations read rather than scoring. */
  readCount?: number;
  onSelect?: () => void;
}
export declare function RadioOptionRow(props: RadioOptionRowProps): JSX.Element;
