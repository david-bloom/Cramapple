import * as React from 'react';

/**
 * The capped white pane every region of a CramApple plate sits in.
 * @startingPoint section="Plate" subtitle="Capped three-pane surface with eyebrow, title and score slot" viewport="700x300"
 */
export interface PaneShellProps {
  /** Which voice owns this pane. Sets the 3px top cap; 'question' swaps it for the 2px red outline. */
  voice?: 'rubric' | 'reference' | 'work' | 'hint' | 'deepdive' | 'question' | 'plain';
  /** Single-noun pane title, set in Passion One. e.g. "Rubric", "Reference Materials". */
  title?: string;
  /** 12px uppercase label above the title. One or two words. */
  eyebrow?: string;
  /** Right-hand slot in the header — usually a ScoreChip or a count. */
  right?: React.ReactNode;
  /** Sticky bottom band inside the pane, divided by a hairline rule. */
  footer?: React.ReactNode;
  /** Set false when children own their own edge-to-edge padding. */
  padded?: boolean;
  children?: React.ReactNode;
  style?: React.CSSProperties;
}
export declare function PaneShell(props: PaneShellProps): JSX.Element;
