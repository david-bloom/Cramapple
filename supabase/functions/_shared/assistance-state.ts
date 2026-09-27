// STUDENT_INTERACTION_DATA_SCHEMA_PLAN_2026_09_27.md Phase 1 item 1 / DECISION-0080.
//
// attempts.assistance_state was, until now, entirely client-supplied at attempt
// creation -- and the client always sends "independent" (the plan's own live
// audit found 1 distinct value across 108 Production rows). This derives the
// truth server-side from attempts.pre_submit_hint_count, which is itself
// maintained by a trigger on app.attempt_assistance_events and can't be
// spoofed by the client the way the original column could.
//
// This only ever strengthens the client's claim, never weakens it: a real
// pre-submission hint open always forces "coached", but the absence of a
// logged event does NOT downgrade an "exam_practice" declaration to
// "independent" -- that's a distinct, intentionally-declared attempt
// condition unrelated to hint usage, and the events log has no way to prove
// its absence, only an event's presence. (It also means this is a no-op for
// every attempt until a real UI writes to attempt_assistance_events --
// SessionFrame does not yet, pending the separately-approved Workstream B1
// rebuild.)
export function deriveAssistanceState(
  clientAssistanceState: string | null,
  preSubmitHintCount: number | null,
): string | null {
  if ((preSubmitHintCount ?? 0) > 0) {
    return "coached";
  }
  return clientAssistanceState;
}
