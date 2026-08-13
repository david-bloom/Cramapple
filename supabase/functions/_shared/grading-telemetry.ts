// Passive grading telemetry helpers (replan 2026-08-10 item 2.2).
//
// Everything here is observational: nothing in this module changes a
// grading decision, and the caller writes the results with a best-effort
// update that tolerates the telemetry columns not existing yet (the paired
// migration is drafted as
// supabase/migrations/20260811TBD_grading_telemetry.sql and is NOT applied
// until the Step 2 deploy bundle ships).

// Canonical normalization for replay-rate telemetry. Two responses that
// differ only in case, whitespace shape, or Unicode compatibility form
// (e.g. full-width digits, ligatures) count as the same answer for
// duplicate-rate purposes. Deliberately NOT stronger than that (no
// punctuation stripping, no number rounding): the pre-registered replay
// threshold (~10% per-item duplicate rate) should be measured on a
// conservative definition, so a build decision is never triggered by an
// aggressive normalizer manufacturing duplicates.
export function normalizeResponseText(text: string | null | undefined) {
  return (text ?? "")
    .normalize("NFKC")
    .toLowerCase()
    .replace(/\s+/g, " ")
    .trim();
}

export type StageTimings = Record<string, number>;

// Wall-clock stage timer. Usage:
//   const timer = createStageTimer();
//   ...auth...
//   timer.mark("auth");
//   ...db loads...
//   timer.mark("db");
//   const timings = timer.finish(); // adds "total"
// Each mark records the ms elapsed since the PREVIOUS mark (so the stages
// sum to "total" up to rounding); stages never marked simply do not appear,
// which is how paths that skip the model (deterministic gate, MCQ) come out
// naturally.
export function createStageTimer(now: () => number = () => performance.now()) {
  const startedAt = now();
  let lastAt = startedAt;
  const timings: StageTimings = {};
  return {
    mark(stage: string) {
      const at = now();
      timings[stage] = (timings[stage] ?? 0) + Math.round(at - lastAt);
      lastAt = at;
    },
    finish(): StageTimings {
      return { ...timings, total: Math.round(now() - startedAt) };
    },
  };
}
