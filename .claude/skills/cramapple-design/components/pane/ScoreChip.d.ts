import * as React from 'react';

/** The earned / total score, set in Passion One. Reads "— / 1" before an attempt. */
export interface ScoreChipProps {
  /** Points earned. `null` renders the em dash — use it before the student has submitted. */
  earned?: number | null;
  /** Points available. */
  total: number;
  /** Override the derived tone. Defaults: full = earned (blue), partial = lost (clay), null = neutral. */
  tone?: 'earned' | 'lost' | 'neutral';
  /** Optional uppercase eyebrow set to the left, e.g. "SCORE". */
  label?: string;
  /** 'lg' is the 28px feedback-card size; 'md' is the pane-header size. */
  size?: 'md' | 'lg';
}
export declare function ScoreChip(props: ScoreChipProps): JSX.Element;
