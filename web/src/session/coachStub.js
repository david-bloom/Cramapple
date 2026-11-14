import { useEffect, useState } from 'react';

/**
 * DEMO ONLY. There is no coaching backend yet, so this stands in for one when
 * the URL carries ?coachdemo=1: coaching is 'pending' for 1.2 s after submit,
 * then 'ready' with sample text that is fixed and not generated. Without the
 * flag it returns null and the card behaves exactly as before. Delete when the
 * real post-grade coaching call exists.
 */
const DEMO_TEXT = 'Demo coaching text. This slot fills with the model-written coaching when it arrives: about 80 words that name what the question required, say where your answer fell short of it, and end with one question for you to try again. It replaces the plain feedback above in the same space, so nothing on the page moves.';

export function useCoachStub(enabled, submitted) {
  const [status, setStatus] = useState('pending');
  useEffect(() => {
    if (!enabled || !submitted) return undefined;
    setStatus('pending');
    const t = setTimeout(() => setStatus('ready'), 1200);
    return () => clearTimeout(t);
  }, [enabled, submitted]);
  if (!enabled || !submitted) return null;
  return { status, text: status === 'ready' ? DEMO_TEXT : null };
}
