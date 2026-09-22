import * as React from 'react';

/**
 * The 48px chrome bar under the masthead: home glyph, unit · topic · question, and the study-map disclosure.
 * @startingPoint section="Plate" subtitle="Unit · topic · question, with the study-map disclosure" viewport="700x90"
 */
export interface BreadcrumbProps {
  /** Path segments. The last is the active one and is set in brand red. */
  items?: React.ReactNode[];
  /** Adds the ⌂ home glyph and ▸/▼ disclosure that opens the study map. */
  onOpenMap?: () => void;
  mapOpen?: boolean;
  /** Right-hand chrome, e.g. "Question 4 of 12". */
  right?: React.ReactNode;
}
export declare function Breadcrumb(props: BreadcrumbProps): JSX.Element;
