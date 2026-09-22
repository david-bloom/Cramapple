import * as React from 'react';

/**
 * The three-state hint economy: idle offer → cost confirmation → open content with a permanent receipt.
 * @startingPoint section="Plate" subtitle="Yellow hint block with its cost-before-disclosure confirm step" viewport="700x200"
 */
export interface HintGateProps {
  /** What the hint gives, named: "Show me the rubric", "Rule out two choices". */
  name: string;
  /** One line stating what opening it gives away. Shown in the asking state, before disclosure. */
  cost?: string;
  /** idle → asking → open. Never auto-advance, never open on hover. */
  state?: 'idle' | 'asking' | 'open';
  onAsk?: () => void;
  onConfirm?: () => void;
  onCancel?: () => void;
  /** Collapses the disclosed content; the receipt stays. */
  onHide?: () => void;
  /** The disclosed content, rendered under the receipt in the open state. */
  children?: React.ReactNode;
}
export declare function HintGate(props: HintGateProps): JSX.Element;
