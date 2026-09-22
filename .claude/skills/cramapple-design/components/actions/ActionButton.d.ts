import * as React from 'react';

/** The four action treatments. There is exactly one primary (red) action per screen. */
export interface ActionButtonProps {
  /** primary = the one red action · hint = yellow, costs something · quiet = white with a rule-400 border · link = underlined text, the only secondary treatment */
  variant?: 'primary' | 'hint' | 'quiet' | 'link';
  /** Desaturated fill plus cursor not-allowed — never opacity. */
  disabled?: boolean;
  onClick?: () => void;
  type?: 'button' | 'submit';
  children?: React.ReactNode;
}
export declare function ActionButton(props: ActionButtonProps): JSX.Element;
