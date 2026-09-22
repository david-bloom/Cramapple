import * as React from 'react';

/** The FRQ written-answer field — purple-capped, because it is the student's own work. */
export interface AnswerFieldProps {
  value?: string;
  placeholder?: string;
  onChange?: (value: string) => void;
  rows?: number;
  /** Shows the hand-drawn 24px camera glyph to attach photographed work. */
  onAttach?: () => void;
  attachLabel?: string;
  readOnly?: boolean;
  /** 12px chrome count on the right, e.g. "2 of 3 sentences". */
  count?: React.ReactNode;
}
export declare function AnswerField(props: AnswerFieldProps): JSX.Element;
