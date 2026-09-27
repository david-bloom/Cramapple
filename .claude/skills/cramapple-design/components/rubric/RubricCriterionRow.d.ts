import * as React from 'react';

/**
 * One scoring criterion in the rubric pane. In Open Hand it is manipulable — click to take the point back and watch the score move.
 * @startingPoint section="Plate" subtitle="Rubric criteria: earned, revisit, taken back, pending" viewport="700x240"
 */
export interface RubricCriterionRowProps {
  /** Short rubric code, e.g. "E1", "C2". */
  code?: string;
  /** The criterion, as a habit rather than a fact. One clause, no hedging. */
  label: React.ReactNode;
  /** One supporting line in the language of the variables. */
  detail?: React.ReactNode;
  /** earned ✓ (blue) · revisit ↻ (amber, the Practice miss mark) · taken ✕ (clay, Open Hand only) · pending · */
  state?: 'earned' | 'revisit' | 'taken' | 'pending';
  /** Points this criterion is worth. Default 1. */
  points?: number;
  /** Open Hand only: clicking the row toggles the point. */
  interactive?: boolean;
  onToggle?: () => void;
}
export declare function RubricCriterionRow(props: RubricCriterionRowProps): JSX.Element;
