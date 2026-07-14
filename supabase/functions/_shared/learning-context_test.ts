import { loadLearningRuntimeContext } from "./learning-context.ts";

Deno.test("loadLearningRuntimeContext preserves the feedback trail in effective guidance", async () => {
  const memoryState = {
    last_feedback_summary: "Score paused until the grader can score it safely.",
    last_feedback_preview: "Score paused until the grader can score it safely.",
    last_action_hint: "show_scaffold",
    last_repair_hint: "Rewrite the fraction with parentheses.",
    last_deterministic_check: {
      content_key: "APSTAT-MOD3-H001-INV",
      status: "flag",
    },
  };

  const service = {
    schema(_schema: string) {
      return {
        from(table: string) {
          if (table === "student_memory_snapshots") {
            return {
              select() {
                return {
                  eq() {
                    return {
                      eq() {
                        return {
                          async maybeSingle() {
                            return {
                              data: {
                                memory_state: memoryState,
                                state_version: "2026-07-08",
                                evidence_count: 3,
                                last_event_id: "evt_1",
                                last_event_kind: "grading_result",
                                last_event_at: "2026-07-08T12:00:00.000Z",
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
          }

          const baseResponse = {
            data: null,
            error: null,
          };

          if (table === "learning_sessions") {
            return {
              select() {
                return {
                  eq() {
                    return {
                      async maybeSingle() {
                        return {
                          data: {
                            id: "session_1",
                            user_id: "user_1",
                            exam_pack_version_id: "exam_pack_version_1",
                            entry_path: "recommendation",
                            session_mode: "focused",
                            available_minutes: 12,
                            status: "active",
                            started_at: "2026-07-08T12:00:00.000Z",
                            ended_at: null,
                          },
                          error: null,
                        };
                      },
                    };
                  },
                };
              },
            };
          }

          if (table === "exam_pack_versions") {
            return {
              select() {
                return {
                  eq() {
                    return {
                      async maybeSingle() {
                        return {
                          data: {
                            id: "exam_pack_version_1",
                            exam_pack_id: "exam_pack_1",
                            school_year: "2025-26",
                            official_exam_date: "May 4, 2026",
                            status: "released",
                          },
                          error: null,
                        };
                      },
                    };
                  },
                };
              },
            };
          }

          if (table === "exam_packs") {
            return {
              select() {
                return {
                  eq() {
                    return {
                      async maybeSingle() {
                        return {
                          data: {
                            id: "exam_pack_1",
                            exam_code: "APBIO",
                            exam_name: "AP Biology",
                            subject_id: "subject_1",
                          },
                          error: null,
                        };
                      },
                    };
                  },
                };
              },
            };
          }

          if (table === "subjects") {
            return {
              select() {
                return {
                  eq() {
                    return {
                      async maybeSingle() {
                        return {
                          data: {
                            id: "subject_1",
                            subject_key: "ap-biology",
                            display_name: "AP Biology",
                            status: "active",
                          },
                          error: null,
                        };
                      },
                    };
                  },
                };
              },
            };
          }

          if (table === "subject_guidance_profiles") {
            return {
              select() {
                return {
                  eq() {
                    return {
                      async maybeSingle() {
                        return {
                          data: {
                            profile_version: "2026-07-08",
                            guidance_defaults: {
                              next_action_title: "Interpreting controls",
                            },
                            status: "active",
                          },
                          error: null,
                        };
                      },
                    };
                  },
                };
              },
            };
          }

          if (table === "content_labels") {
            return {
              select() {
                return {
                  eq() {
                    return {
                      neq() {
                        return {
                          order() {
                            return {
                              order() {
                                return Promise.resolve(baseResponse);
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
          }

          if (table === "attempts") {
            return {
              select() {
                return {
                  eq() {
                    return {
                      order() {
                        return {
                          limit() {
                            return Promise.resolve(baseResponse);
                          },
                        };
                      },
                    };
                  },
                };
              },
            };
          }

          throw new Error(`unexpected table: ${table}`);
        },
      };
    },
  };

  const context = await loadLearningRuntimeContext(service as never, "session_1");

  if (!context) {
    throw new Error("expected runtime context");
  }

  const loadedMemoryState = context.student_memory.memory_state as Record<string, unknown>;
  if (loadedMemoryState.last_feedback_summary !== memoryState.last_feedback_summary) {
    throw new Error("expected feedback summary in memory snapshot");
  }

  const effectiveGuidance = context.effective_guidance as Record<string, unknown>;

  if (effectiveGuidance.last_feedback_summary !== memoryState.last_feedback_summary) {
    throw new Error("expected feedback summary in effective guidance");
  }

  if (effectiveGuidance.last_feedback_preview !== memoryState.last_feedback_preview) {
    throw new Error("expected feedback preview in effective guidance");
  }

  if (effectiveGuidance.last_action_hint !== memoryState.last_action_hint) {
    throw new Error("expected action hint in effective guidance");
  }

  if (effectiveGuidance.last_repair_hint !== memoryState.last_repair_hint) {
    throw new Error("expected repair hint in effective guidance");
  }

  const deterministicCheck = effectiveGuidance.last_deterministic_check as
    | Record<string, unknown>
    | null
    | undefined;
  if (deterministicCheck?.status !== "flag") {
    throw new Error("expected deterministic check in effective guidance");
  }
});
