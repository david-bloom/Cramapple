import * as React from 'react';

/**
 * The top of the question pane: eyebrow, topic, mode and point count, then the stem at 19px.
 * @startingPoint section="Plate" subtitle="Eyebrow, mode chip, point count and the question stem" viewport="700x160"
 */
export interface QuestionHeaderProps {
  /** One or two words. Default "Question". */
  eyebrow?: string;
  /** e.g. "2.3 Least-Squares Regression". */
  topic?: string;
  number?: number;
  total?: number;
  /** The question text. Second person, present tense. */
  stem: React.ReactNode;
  /** Points available — drives the rubric total. */
  points?: number;
  /** "Open Hand" or "Practice". */
  mode?: string;
}
export declare function QuestionHeader(props: QuestionHeaderProps): JSX.Element;
