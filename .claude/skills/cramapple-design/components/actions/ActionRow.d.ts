import * as React from 'react';

/**
 * The bottom band of the question pane: one primary action, one text-link secondary, and an optional quiet note.
 * @startingPoint section="Plate" subtitle="Primary action, text-link secondary, quiet note" viewport="700x140"
 */
export interface ActionRowProps {
  /** The single red ActionButton. Dimmed until there is something to submit. */
  primary?: React.ReactNode;
  /** An underlined text link — "Skip for now", "No, keep solving". */
  secondary?: React.ReactNode;
  /** Right-hand 12px chrome note, e.g. "Question 4 of 12". */
  note?: React.ReactNode;
  align?: 'split' | 'start';
}
export declare function ActionRow(props: ActionRowProps): JSX.Element;
