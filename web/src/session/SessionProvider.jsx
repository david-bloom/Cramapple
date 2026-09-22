import React, { createContext, useContext, useCallback, useEffect, useMemo, useState } from 'react';

/**
 * Session state: what the student has attempted, which hints they pulled, and
 * where they left off. Persisted to localStorage so a reload does not erase a
 * unit's progress. When this frontend gets a backend, replace the two storage
 * functions below with API calls -- nothing else in the app reads storage.
 *
 * Shape:
 *   attempts: { [packageId]: { mode, response|picked, earned, total, verdict,
 *                              marks, hintsUsed: [receipt], submittedAt } }
 *   hints:    { [packageId]: { [hintKey]: 'idle' | 'asking' | 'open' } }
 *   read:     { [packageId]: [choiceKey]  }   // Open Hand MCQ, explanations read
 *   last:     { packageId, mode } | null
 */

const STORAGE_KEY = 'cramapple.session.v1';
const EMPTY = { attempts: {}, hints: {}, read: {}, last: null };

function load() {
  try {
    const raw = window.localStorage.getItem(STORAGE_KEY);
    return raw ? { ...EMPTY, ...JSON.parse(raw) } : EMPTY;
  } catch {
    return EMPTY;
  }
}

function save(state) {
  try {
    window.localStorage.setItem(STORAGE_KEY, JSON.stringify(state));
  } catch {
    // A student in private browsing still gets a working session, just not a
    // durable one. Never let storage failure break the plate.
  }
}

const SessionContext = createContext(null);

export function SessionProvider({ children }) {
  const [state, setState] = useState(load);

  useEffect(() => { save(state); }, [state]);

  const recordAttempt = useCallback((packageId, attempt) => {
    setState((s) => ({
      ...s,
      attempts: { ...s.attempts, [packageId]: { ...attempt, submittedAt: Date.now() } }
    }));
  }, []);

  const setHintState = useCallback((packageId, hintKey, value) => {
    setState((s) => ({
      ...s,
      hints: { ...s.hints, [packageId]: { ...(s.hints[packageId] || {}), [hintKey]: value } }
    }));
  }, []);

  const markRead = useCallback((packageId, choiceKey) => {
    setState((s) => {
      const seen = s.read[packageId] || [];
      if (seen.includes(choiceKey)) return s;
      return { ...s, read: { ...s.read, [packageId]: [...seen, choiceKey] } };
    });
  }, []);

  const setLast = useCallback((packageId, mode) => {
    setState((s) => (s.last && s.last.packageId === packageId && s.last.mode === mode
      ? s
      : { ...s, last: { packageId, mode } }));
  }, []);

  const reset = useCallback(() => setState(EMPTY), []);

  const value = useMemo(() => ({
    ...state,
    recordAttempt,
    setHintState,
    markRead,
    setLast,
    reset
  }), [state, recordAttempt, setHintState, markRead, setLast, reset]);

  return <SessionContext.Provider value={value}>{children}</SessionContext.Provider>;
}

export function useSession() {
  const ctx = useContext(SessionContext);
  if (!ctx) throw new Error('useSession must be used inside a SessionProvider');
  return ctx;
}

/**
 * Hint state for one question, plus the receipts the feedback card lists.
 *
 * Four stored states -- idle, asking, open, hidden. `hidden` still counts as
 * pulled: the product rule is that a receipt never disappears and every hint
 * taken is listed again on the feedback card, so "Hide" folds the revealed
 * content away and leaves the receipt standing. Backing out of `asking`
 * (No, keep solving) costs nothing and returns to idle.
 */
export function useHints(packageId, hints = []) {
  const { hints: all, setHintState } = useSession();
  const forQuestion = all[packageId] || {};

  const raw = (hintKey) => forQuestion[hintKey] || 'idle';
  const wasUsed = (hintKey) => raw(hintKey) === 'open' || raw(hintKey) === 'hidden';

  return {
    // HintGate only knows idle/asking/open; `hidden` renders as an open receipt.
    stateOf: (key) => (raw(key) === 'hidden' ? 'open' : raw(key)),
    contentVisible: (key) => raw(key) === 'open',
    wasUsed,
    ask: (key) => setHintState(packageId, key, 'asking'),
    confirm: (key) => setHintState(packageId, key, 'open'),
    cancel: (key) => setHintState(packageId, key, 'idle'),
    toggleContent: (key) => setHintState(packageId, key, raw(key) === 'open' ? 'hidden' : 'open'),
    used: hints.filter((h) => wasUsed(h.hint_key)).map((h) => h.receipt || h.name)
  };
}
