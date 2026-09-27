import * as React from 'react';

/**
 * The full-frame explainer that covers all three panes below the breadcrumb — it must be full-frame, because the centre pane cannot hold it without scrolling.
 * @startingPoint section="Overlays" subtitle="Full-frame deep dive with teal accent rules" viewport="700x320"
 */
export interface DeepDiveSection {
  title: string;
  body: React.ReactNode;
}
export interface DeepDiveOverlayProps {
  open?: boolean;
  /** Default "Deep dive". */
  eyebrow?: string;
  /** 32px Passion One title. */
  title?: string;
  /** Up to three columns; each gets a teal left rule — the only place teal appears. */
  sections?: DeepDiveSection[];
  onClose?: () => void;
  /** Shows the hand-drawn copy glyph. */
  onCopy?: () => void;
}
export declare function DeepDiveOverlay(props: DeepDiveOverlayProps): JSX.Element | null;
