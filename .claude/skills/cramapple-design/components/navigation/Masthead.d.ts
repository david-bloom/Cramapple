import * as React from 'react';

/**
 * The 70px red bar at the top of every plate. The wordmark is set in Bungee with a hard offset shadow — there is no logo file.
 * @startingPoint section="Plate" subtitle="70px red masthead with the type-set wordmark" viewport="700x90"
 */
export interface MastheadProps {
  /** Course label on the right, e.g. "AP Statistics". */
  course?: string;
  /** Extra right-hand chrome — a streak count, a mode label. */
  right?: React.ReactNode;
}
export declare function Masthead(props: MastheadProps): JSX.Element;
