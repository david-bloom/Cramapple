import * as React from 'react';

/** One word, never two: "Correct" or "Incorrect". No praise, no exclamation marks. */
export interface VerdictChipProps {
  verdict: 'correct' | 'incorrect' | 'Correct' | 'Incorrect';
}
export declare function VerdictChip(props: VerdictChipProps): JSX.Element;
