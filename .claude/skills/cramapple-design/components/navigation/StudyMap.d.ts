import * as React from 'react';

/**
 * The overlay that drops under the breadcrumb across the full plate width, over a scrim.
 * @startingPoint section="Overlays" subtitle="Full-width topic map dropping under the breadcrumb" viewport="700x300"
 */
export interface StudyMapTopic {
  /** e.g. "2.3" */
  code: string;
  title: string;
  done: number;
  total: number;
  /** Marks the topic the student is in — red outline. */
  current?: boolean;
}
export interface StudyMapProps {
  open?: boolean;
  /** Unit name shown beside the eyebrow. */
  unit?: string;
  topics?: StudyMapTopic[];
  onClose?: () => void;
  onPick?: (topic: StudyMapTopic) => void;
}
export declare function StudyMap(props: StudyMapProps): JSX.Element | null;
