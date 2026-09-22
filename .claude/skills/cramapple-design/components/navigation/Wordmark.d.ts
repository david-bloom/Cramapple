import * as React from 'react';

/**
 * The name set in Bungee. There is no logo file — this component IS the mark, so never draw or substitute one.
 * @startingPoint section="Brand" subtitle="The type-set wordmark, on brand orange / light / dark grounds" viewport="700x120"
 */
export interface WordmarkProps {
  /**
   * The ground it sits on. 'on-brand' = white on --orange-600 (the masthead).
   * 'on-light' = --orange-700 on paper — the only orange dark enough to pass on white; never use --orange-500/600 as ink.
   * 'on-dark' = white, for an ink-900 or photographic ground.
   * 'mono' = --ink-900, for print, fax-grade output and anywhere colour cannot be trusted.
   */
  tone?: 'on-brand' | 'on-light' | 'on-dark' | 'mono';
  /** Any CSS length. Omit for the 22px masthead size. Bungee is a display face — do not set it below 16px. */
  size?: number | string;
  style?: React.CSSProperties;
}
export declare function Wordmark(props: WordmarkProps): JSX.Element;
