// Shared post-grade side effect: persisting the student's mastery /
// spaced-repetition memory_state after a grade lands.
//
// Extracted from evaluate-attempt/index.ts (TASK-0025 QA review 2026-08-17)
// so attempt-response's record_manual_grade operation (the hand-drawn-image
// human-grading pilot) can call the exact same path instead of silently
// skipping it -- before this extraction, any attempt graded manually never
// updated memory_state, diverging mastery tracking / item-delivery signals
// from reality for that student with no error surfaced anywhere.

import { createServiceClient } from "./supabase.ts";
import { loadLearningRuntimeContext } from "./learning-context.ts";
import {
  asRecord,
  buildGradingMemoryState,
  recordStudentMemoryEvent,
} from "./student-memory.ts";

export async function persistGradingMemory(input: {
  service: ReturnType<typeof createServiceClient>;
  sessionId: string | null;
  attemptId: string;
  attemptMode: string;
  assistanceState: string;
  finalStatus: string;
  pointsEarned: number;
  pointsAvailable: number;
  confidence: string | null;
  highestValueGap: {
    criterion_key: string;
    minimum_fix: string;
    repair_prompt: string;
  } | null;
  criteria: Array<{
    criterion_key: string;
    status: string;
    points_awarded: number;
  }>;
  summary: string;
  examPackVersionId: string;
  gradingRoute?: Record<string, unknown> | null;
  verificationProfile?: Record<string, unknown> | null;
  verificationProfileSummary?: Record<string, unknown> | null;
  feedbackPreview?: string | null;
  actionHint?: string | null;
  repairHint?: string | null;
  deterministicCheck?: Record<string, unknown> | null;
}) {
  if (!input.sessionId) {
    return null;
  }

  const context = await loadLearningRuntimeContext(
    input.service,
    input.sessionId,
  );
  if (!context) {
    return null;
  }

  const subjectDefaults = asRecord(context.subject_defaults);
  const subject = asRecord(subjectDefaults.subject);
  const examPack = asRecord(subjectDefaults.exam_pack);
  const memory = asRecord(context.student_memory);
  const sessionState = asRecord(context.session_state);

  if (!subject.id || !sessionState.user_id) {
    return context;
  }

  const memoryState = buildGradingMemoryState({
    currentMemoryState: asRecord(memory.memory_state),
    subjectId: String(subject.id),
    subjectKey: String(subject.subject_key ?? ""),
    subjectName: String(subject.display_name ?? ""),
    examPackVersionId: input.examPackVersionId,
    sessionId: input.sessionId,
    attemptId: input.attemptId,
    attemptMode: input.attemptMode,
    assistanceState: input.assistanceState,
    finalStatus: input.finalStatus,
    pointsEarned: input.pointsEarned,
    pointsAvailable: input.pointsAvailable,
    confidence: input.confidence,
    highestValueGap: input.highestValueGap,
    criteria: input.criteria,
    summary: input.summary,
  });

  try {
    await recordStudentMemoryEvent(input.service, {
      userId: String(sessionState.user_id),
      subjectId: String(subject.id),
      eventKind: "grading_result",
      sourceSessionId: input.sessionId,
      sourceAttemptId: input.attemptId,
      memoryState,
      eventPayload: {
        exam_pack: examPack,
        session_state: context.session_state,
        grading_route: input.gradingRoute ?? null,
        verification_profile: input.verificationProfile ?? null,
        verification_profile_summary: input.verificationProfileSummary ??
          null,
        feedback_preview: input.feedbackPreview ?? null,
        action_hint: input.actionHint ?? null,
        repair_hint: input.repairHint ?? null,
        deterministic_check: input.deterministicCheck ?? null,
        grading_result: {
          attempt_id: input.attemptId,
          final_status: input.finalStatus,
          points_earned: input.pointsEarned,
          points_available: input.pointsAvailable,
          confidence: input.confidence,
          highest_value_gap: input.highestValueGap,
          summary: input.summary,
        },
      },
    });
  } catch (error) {
    console.error("grading_memory_persist_failed", error);
  }

  return (await loadLearningRuntimeContext(input.service, input.sessionId)) ??
    context;
}
