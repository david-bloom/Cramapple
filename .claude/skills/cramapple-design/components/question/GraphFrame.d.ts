import * as React from 'react';

/**
 * The purple-tinted field the question's own data sits on — a scatterplot, a table, a residual plot, drawn as inline SVG.
 * @startingPoint section="Plate" subtitle="Purple-tinted data field with a 12px caption" viewport="700x280"
 */
export interface GraphFrameProps {
  /** One-line description of what the graphic shows. */
  caption?: React.ReactNode;
  /** Right-aligned provenance, e.g. "n = 24". */
  source?: React.ReactNode;
  /** Fixed height when the plate needs the pane to hold its shape. */
  height?: number | string;
  /** Inline SVG drawn from the question's coordinates. Axis labels in --purple-500; called-out points in yellow. */
  children?: React.ReactNode;
}
export declare function GraphFrame(props: GraphFrameProps): JSX.Element;
