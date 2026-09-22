import React from 'react';
import { HintGate, ActionButton } from '../../components/index.js';

/**
 * In Practice the deep dive is costed help, not a post-submit extra.
 *
 * The product rule: a student can answer cold, or expose the helpful content —
 * the rubric, the deep dive — before submitting. How much help they took, read
 * against the score, is the mastery signal. So the deep dive has to sit behind
 * the same three-state gate the rubric does and leave the same receipt, or the
 * signal is incomplete and the help is silently free.
 *
 * After submission the deep dive is free, and the action row opens it directly.
 */
export const DEEP_DIVE_HINT = {
  hint_key: 'deepdive',
  kind: 'deepdive',
  name: 'Show me the deep dive',
  receipt: 'Deep dive',
  cost: 'This walks through the reasoning before you write, and is listed on your feedback.'
};

export function DeepDiveGate({ hints, onOpen }) {
  const key = DEEP_DIVE_HINT.hint_key;
  return (
    <HintGate
      name={DEEP_DIVE_HINT.name}
      cost={DEEP_DIVE_HINT.cost}
      state={hints.stateOf(key)}
      contentHidden={!hints.contentVisible(key)}
      onAsk={() => hints.ask(key)}
      onConfirm={() => { hints.confirm(key); onOpen(); }}
      onCancel={() => hints.cancel(key)}
      onHide={() => hints.toggleContent(key)}
    >
      <ActionButton variant="quiet" onClick={onOpen}>Open the deep dive</ActionButton>
    </HintGate>
  );
}
