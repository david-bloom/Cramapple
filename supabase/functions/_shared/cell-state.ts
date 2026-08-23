// Course Mode F3 — deterministic evidence-weight classifier + tier/trigger rule
// engine (Phase 1). Pure functions, no model inference (INV-4): tier transitions
// and due-times are a deterministic function of (prior state, event, weight,
// timestamps), exhaustively unit-testable. Writes land in app.student_cell_state
// (F2); this module computes WHAT to write.
//
// Model refs: CM-D06 (tier ladder), CM-D07 (evidence weights), CM-D08 (decay),
// CM-D10/D11 (triggers -> one due-queue), CM-D12 (Phase-1 scope), CM-D13 (rule
// table; constants tunable, not correctness-critical), INV-5 (supported success is
// provisional), INV-6 (a miss reopens, never zeroes).
//
// Phase-1 events only: correct / incorrect (direct miss) / new_exposure. The
// decay clock is a READ-TIME condition (a cell is "due" when now >= next_due_at);
// this engine only stamps next_due_at. Phase-2 graph triggers (prerequisite,
// thread-sibling) are intentionally NOT implemented -- see nextCellState's default.

export type Tier =
  | "unseen"
  | "exposed_unverified"
  | "supported"
  | "independent"
  | "confirmed";

export type DueReason =
  | "decay"
  | "direct_miss"
  | "provisional_confirm"
  | "new_exposure";

// content_uncertain: grading/content could not be trusted (CM-D07 -> weight 0
// AND excluded from mastery evidence, "route to content_uncertain"). It is a
// distinct event, NOT a weight-0 'correct', so an uncertain grade never advances
// a tier (Fable QA finding 1: uncertain-0 must be distinguishable from assisted-0,
// which legitimately reaches `supported`).
export type CellEvent = "correct" | "incorrect" | "new_exposure" | "content_uncertain";

// Tunable constants (CM-D13): bounded, explainable defaults; calibrate on
// outcomes. NOT correctness-critical -- changing them changes cadence, not the
// invariants. Re-horizoned to the year-long course (weeks), compresses near exam.
export const TUNABLES = {
  decayDays: { supported: 3, independent: 10, confirmed: 30 },
  provisionalConfirmDays: 1,
  newExposureConsolidationDays: 2,
  directMissRecheckDays: 1,
  sameSessionWindowMinutes: 30,
  // independent -> confirmed requires the prior independent success to be at
  // least this old (a delay) AND a fully-informative (weight 1.0) fresh success.
  confirmMinDelayDays: 1,
  missEvidencePenalty: 0.5,
};

export const RULE_ENGINE_VERSION = "cell-state-1.0";

const TIER_ORDER: Tier[] = [
  "unseen",
  "exposed_unverified",
  "supported",
  "independent",
  "confirmed",
];
const tierRank = (t: Tier): number => TIER_ORDER.indexOf(t);
const atLeast = (t: Tier, floor: Tier): Tier =>
  tierRank(t) >= tierRank(floor) ? t : floor;

function addDays(now: Date, days: number): Date {
  return new Date(now.getTime() + days * 86_400_000);
}

// ---------------------------------------------------------------------------
// Evidence-weight classifier (CM-D07). Weight measures how informative an
// attempt is toward INDEPENDENT mastery. Independent of correctness.
//   1.00 independent + varied ("changed surface") + after a delay
//   0.65 independent + varied + same session
//   0.35 same / near-identical item (surface not changed)
//   0.00 heavily assisted / off-task, OR content/grading uncertain
// "changed surface" = same template, DIFFERENT params (same params = not changed).
// "same session" falls back to a time window when session identity is null
// (F2 supports sessionless/manual grades) -- see classifySameSession.
// ---------------------------------------------------------------------------
export type AttemptSignal = {
  assisted: boolean; // answer-bearing help used (assistance_state != 'independent')
  uncertain?: boolean; // content/grading uncertainty -> route content_uncertain
  changedSurface: boolean; // same template, different params vs the cell's last attempt
  sameSession: boolean; // same session as last attempt (or within the time window)
};

export function classifyWeight(s: AttemptSignal): number {
  if (s.uncertain || s.assisted) return 0;
  if (!s.changedSurface) return 0.35;
  return s.sameSession ? 0.65 : 1.0;
}

/** Same-session decision that tolerates a null session id (sessionless grades):
 *  equal non-null session ids => same session; otherwise fall back to a time
 *  window between this attempt and the cell's last attempt. */
export function classifySameSession(
  currentSessionId: string | null,
  priorSessionId: string | null,
  now: Date,
  priorAttemptAt: Date | null,
): boolean {
  if (currentSessionId && priorSessionId) {
    return currentSessionId === priorSessionId;
  }
  if (!priorAttemptAt) return false;
  const minutes = (now.getTime() - priorAttemptAt.getTime()) / 60_000;
  // Clock skew / out-of-order backfill (prior stamp in the "future"): treat as
  // same-session, the CONSERVATIVE choice -- never award the fully-informative
  // 1.0 weight off a negative interval (Fable QA finding 3).
  if (minutes < 0) return true;
  return minutes < TUNABLES.sameSessionWindowMinutes;
}

// ---------------------------------------------------------------------------
// Tier / trigger rule table (CM-D13). Pure: (prev, event, weight, now) -> next.
// ---------------------------------------------------------------------------
export type CellState = {
  tier: Tier;
  fragile: boolean;
  weighted_evidence: number;
  last_independent_success_at: string | null; // ISO
  last_attempt_at: string | null; // ISO -- set only by a real attempt (not exposure)
  last_exposure_at: string | null; // ISO -- set by new_exposure; kept distinct so a
  // consolidation trigger never masquerades as an attempt in the classifier
  next_due_at: string | null; // ISO
  due_reason: DueReason | null;
};

export type RuleInput = {
  event: CellEvent;
  weight: number; // from classifyWeight (used for 'correct')
  now: Date;
};

export function initialCellState(): CellState {
  return {
    tier: "unseen",
    fragile: false,
    weighted_evidence: 0,
    last_independent_success_at: null,
    last_attempt_at: null,
    last_exposure_at: null,
    next_due_at: null,
    due_reason: null,
  };
}

export function nextCellState(prev: CellState, input: RuleInput): CellState {
  const { event, weight, now } = input;
  const iso = now.toISOString();

  if (event === "new_exposure") {
    // Class advanced into this cell's material (CM-D10 consolidation). This is NOT
    // an attempt -> stamp last_exposure_at, not last_attempt_at (finding 4). Only
    // meaningful from unseen; never downgrades an already-verified cell.
    const next: CellState = { ...prev, last_exposure_at: iso };
    if (prev.tier === "unseen") {
      next.tier = "exposed_unverified";
      next.next_due_at = addDays(now, TUNABLES.newExposureConsolidationDays).toISOString();
      next.due_reason = "new_exposure";
    }
    return next;
  }

  // correct / incorrect / content_uncertain are real attempts.
  const next: CellState = { ...prev, last_attempt_at: iso };

  if (event === "content_uncertain") {
    // Grading/content untrusted (CM-D07): record the attempt for recency, but add
    // NO evidence and change NO tier/due -- the item is routed out for review,
    // never writing false proficiency (finding 1).
    return next;
  }

  if (event === "incorrect") {
    // Direct miss: reopen the estimate (fragile) but DO NOT lower the tier
    // (INV-6 -- a miss reopens, never zeroes). Re-enter the active queue soon.
    next.fragile = true;
    next.weighted_evidence = Math.max(0, prev.weighted_evidence - TUNABLES.missEvidencePenalty);
    next.next_due_at = addDays(now, TUNABLES.directMissRecheckDays).toISOString();
    next.due_reason = "direct_miss";
    return next;
  }

  // event === "correct"
  next.weighted_evidence = prev.weighted_evidence + weight;

  if (weight >= 0.65) {
    // Independent + varied success. Advances the ladder; clears fragile.
    next.fragile = false;
    if (tierRank(prev.tier) >= tierRank("independent")) {
      // Already independent (or confirmed): confirm only on a delayed, fully
      // informative (weight 1.0) success (INV-5 -- provisional until re-tested
      // cold after a delay with a changed surface).
      const priorTs = prev.last_independent_success_at
        ? new Date(prev.last_independent_success_at)
        : null;
      const delayedEnough = priorTs
        ? (now.getTime() - priorTs.getTime()) / 86_400_000 >= TUNABLES.confirmMinDelayDays
        : false;
      if (prev.tier === "independent" && weight >= 1.0 && delayedEnough) {
        next.tier = "confirmed";
      } // else stays at its tier, just refreshed
    } else {
      // From unseen/exposed/supported -> independent (provisional progress).
      next.tier = "independent";
    }
    next.last_independent_success_at = iso;
    const decay = next.tier === "confirmed"
      ? TUNABLES.decayDays.confirmed
      : TUNABLES.decayDays.independent;
    next.next_due_at = addDays(now, decay).toISOString();
    next.due_reason = "decay";
    return next;
  }

  // weight 0.35 (same/near-identical item) OR weight 0 (assisted): a SUPPORTED
  // success -- provisional (INV-5). Advances up to `supported` only; never reaches
  // independent (which needs an unassisted, changed-surface retry). Schedules a
  // short cold re-test. NOTE: uncertain grades never reach here -- applyAttempt
  // routes them to the content_uncertain event (no evidence); only a caller using
  // nextCellState directly with a raw weight-0 'correct' would land here.
  next.tier = atLeast(prev.tier, "supported");
  // an assisted/near-identical success does not advance a cell already past
  // `supported`; keep the higher tier, but still schedule the confirm re-test.
  if (tierRank(prev.tier) > tierRank("supported")) next.tier = prev.tier;
  next.next_due_at = addDays(now, TUNABLES.provisionalConfirmDays).toISOString();
  next.due_reason = "provisional_confirm";
  return next;
}

/** Convenience: classify + transition in one call, stamping engine version. */
export function applyAttempt(
  prev: CellState,
  event: CellEvent,
  signal: AttemptSignal,
  now: Date,
): { state: CellState; weight: number; version: string } {
  // An uncertain grade on a real attempt is routed to content_uncertain (no
  // evidence, no tier change) rather than a weight-0 'correct' (finding 1).
  const effectiveEvent: CellEvent =
    (event === "correct" || event === "incorrect") && signal.uncertain
      ? "content_uncertain"
      : event;
  const weight = effectiveEvent === "correct" ? classifyWeight(signal) : 0;
  const state = nextCellState(prev, { event: effectiveEvent, weight, now });
  return { state, weight, version: RULE_ENGINE_VERSION };
}
