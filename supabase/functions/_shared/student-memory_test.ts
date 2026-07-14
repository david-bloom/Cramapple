import {
  buildGradingMemoryState,
  recordStudentMemoryEvent,
} from "./student-memory.ts";

Deno.test("recordStudentMemoryEvent preserves deterministic check payload", async () => {
  let insertedPayload: any = null;

  const service = {
    schema() {
      return {
        from(table: string) {
          if (table !== "student_memory_events") {
            throw new Error(`unexpected table: ${table}`);
          }

          return {
            insert(payload: Record<string, unknown>) {
              insertedPayload = payload;
              return {
                select() {
                  return {
                    async maybeSingle() {
                      return {
                        data: {
                          id: "evt_1",
                          created_at: "2026-07-08T12:00:00.000Z",
                        },
                        error: null,
                      };
                    },
                  };
                },
              };
            },
          };
        },
      };
    },
  };

  const result = await recordStudentMemoryEvent(service as never, {
    userId: "user_1",
    subjectId: "subject_1",
    eventKind: "grading_result",
    sourceSessionId: "session_1",
    sourceAttemptId: "attempt_1",
    memoryState: {
      last_result_state: "graded",
      last_feedback_summary: "Saved for follow-up.",
    },
    eventPayload: {
      feedback_preview: "Saved for follow-up.",
    },
    deterministicCheck: {
      content_key: "APSTAT-MOD3-H001-INV",
      status: "flag",
      reason: "The response misses the required confidence interval bounds.",
      repair_hint: "Recompute the interval with the keyed standard error.",
    },
  });

  if (!insertedPayload) {
    throw new Error("expected insert payload");
  }

  const eventPayload = insertedPayload.event_payload;
  if (!eventPayload) {
    throw new Error("expected event payload");
  }

  const deterministicCheck = eventPayload.deterministic_check as Record<string, unknown> | null;
  if (deterministicCheck?.content_key !== "APSTAT-MOD3-H001-INV") {
    throw new Error("expected deterministic check content key");
  }
  if (eventPayload.action_hint !== undefined) {
    throw new Error("expected action hint to be absent in this narrow event test");
  }
  if (eventPayload.feedback_preview !== "Saved for follow-up.") {
    throw new Error("expected feedback preview to be preserved");
  }
  if (!result || result.id !== "evt_1") {
    throw new Error("expected inserted row result");
  }
});

Deno.test("buildGradingMemoryState preserves the learner-facing feedback trail", () => {
  const state = buildGradingMemoryState({
    currentMemoryState: {
      last_feedback_preview: "Old preview",
    },
    subjectId: "subject_1",
    subjectKey: "ap-statistics",
    subjectName: "AP Statistics",
    examPackVersionId: "exam_pack_1",
    sessionId: "session_1",
    attemptId: "attempt_1",
    attemptMode: "practice",
    assistanceState: "light",
    finalStatus: "graded",
    pointsEarned: 1,
    pointsAvailable: 2,
    confidence: "medium",
    highestValueGap: {
      criterion_key: "c1",
      minimum_fix: "Use the labeled interval.",
      repair_prompt: "Use the labeled interval.",
    },
    criteria: [
      {
        criterion_key: "c1",
        status: "earned",
        points_awarded: 1,
      },
      {
        criterion_key: "c2",
        status: "not_yet_earned",
        points_awarded: 0,
      },
    ],
    summary: "Saved for follow-up.",
    feedbackPreview: "Score paused until the grader can score it safely.",
    actionHint: "show_scaffold",
    repairHint: "Use the labeled interval.",
    deterministicCheck: {
      content_key: "APSTAT-MOD3-H001-INV",
      status: "flag",
    },
  });

  if (state.last_feedback_preview !== "Score paused until the grader can score it safely.") {
    throw new Error("expected feedback preview to be preserved");
  }
  if (state.last_action_hint !== "show_scaffold") {
    throw new Error("expected action hint to be preserved");
  }
  if (state.last_repair_hint !== "Use the labeled interval.") {
    throw new Error("expected repair hint to be preserved");
  }
  const lastDeterministicCheck = state.last_deterministic_check as
    | Record<string, unknown>
    | null
    | undefined;
  if (lastDeterministicCheck?.status !== "flag") {
    throw new Error("expected deterministic check to be preserved");
  }
  if (state.last_feedback_summary !== "Saved for follow-up.") {
    throw new Error("expected summary to be preserved");
  }
});

Deno.test("recordStudentMemoryEvent stores the feedback trail payload fields", async () => {
  let insertedPayload: any = null;

  const service = {
    schema() {
      return {
        from(table: string) {
          if (table !== "student_memory_events") {
            throw new Error(`unexpected table: ${table}`);
          }

          return {
            insert(payload: Record<string, unknown>) {
              insertedPayload = payload;
              return {
                select() {
                  return {
                    async maybeSingle() {
                      return { data: { id: "evt_2" }, error: null };
                    },
                  };
                },
              };
            },
          };
        },
      };
    },
  };

  await recordStudentMemoryEvent(service as never, {
    userId: "user_2",
    subjectId: "subject_2",
    eventKind: "grading_result",
    memoryState: { last_result_state: "graded" },
    eventPayload: {
      feedback_preview: "Saved for follow-up.",
      action_hint: "show_scaffold",
      repair_hint: "Use the labeled interval.",
    },
    deterministicCheck: {
      content_key: "APSTAT-MOD3-H001-INV",
      status: "flag",
    },
  });

  const eventPayload = insertedPayload?.event_payload as Record<string, unknown> | undefined;
  if (!eventPayload) {
    throw new Error("expected event payload");
  }
  if (eventPayload.feedback_preview !== "Saved for follow-up.") {
    throw new Error("expected feedback preview to be stored");
  }
  if (eventPayload.action_hint !== "show_scaffold") {
    throw new Error("expected action hint to be stored");
  }
  if (eventPayload.repair_hint !== "Use the labeled interval.") {
    throw new Error("expected repair hint to be stored");
  }
  if ((eventPayload.deterministic_check as Record<string, unknown> | null)?.status !== "flag") {
    throw new Error("expected deterministic check to be stored");
  }
});
