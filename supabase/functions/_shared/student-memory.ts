import { createServiceClient } from "./supabase.ts";

export type StudentMemoryState = Record<string, unknown>;

export function asRecord(value: unknown): Record<string, unknown> {
  return value && typeof value === "object" && !Array.isArray(value)
    ? value as Record<string, unknown>
    : {};
}

export function asString(value: unknown) {
  return typeof value === "string" && value.trim() ? value.trim() : null;
}

export function asStringArray(value: unknown) {
  if (Array.isArray(value)) {
    return value.filter((entry) => typeof entry === "string")
      .map((entry) => entry.trim())
      .filter(Boolean);
  }

  if (typeof value === "string") {
    return value
      .split(/[|,;]/)
      .map((entry) => entry.trim())
      .filter(Boolean);
  }

  return [];
}

export function mergeStringArrays(
  current: unknown,
  additions: string[],
  limit = 6,
) {
  const merged = [
    ...asStringArray(current),
    ...additions.filter((item) => typeof item === "string" && item.trim()),
  ];

  const unique: string[] = [];
  for (const entry of merged) {
    if (!unique.includes(entry)) {
      unique.push(entry);
    }
    if (unique.length >= limit) {
      break;
    }
  }

  return unique;
}

export function mergeStudentMemoryState(
  current: StudentMemoryState,
  patch: StudentMemoryState,
) {
  return {
    ...current,
    ...patch,
  };
}

export function buildSessionMemoryState(input: {
  currentMemoryState?: StudentMemoryState;
  subjectId: string;
  subjectKey: string;
  subjectName: string;
  examPackVersionId: string;
  sessionId: string;
  entryPath: string;
  sessionMode: string;
  availableMinutes: number;
  sessionStatus: string;
  startedAt?: string | null;
  endedAt?: string | null;
  guidanceDefaults?: StudentMemoryState;
}) {
  const base = input.currentMemoryState ?? {};
  return mergeStudentMemoryState(base, {
    subject_id: input.subjectId,
    subject_key: input.subjectKey,
    subject_name: input.subjectName,
    last_exam_pack_version_id: input.examPackVersionId,
    last_session_id: input.sessionId,
    last_entry_path: input.entryPath,
    last_session_mode: input.sessionMode,
    last_available_minutes: input.availableMinutes,
    last_session_status: input.sessionStatus,
    last_session_started_at: input.startedAt ?? null,
    last_session_ended_at: input.endedAt ?? null,
    preferred_help_style:
      asString(base.preferred_help_style) ??
      asString(input.guidanceDefaults?.help_style) ??
      "balanced",
    preferred_feedback_density:
      asString(base.preferred_feedback_density) ??
      asString(input.guidanceDefaults?.feedback_density) ??
      "balanced",
    preferred_repair_style:
      asString(base.preferred_repair_style) ??
      asString(input.guidanceDefaults?.preferred_repair_style) ??
      "minimum_fix",
    preferred_representation_order:
      base.preferred_representation_order ??
      input.guidanceDefaults?.preferred_representation_order ??
      [],
    subject_specific_checks:
      base.subject_specific_checks ??
      input.guidanceDefaults?.subject_specific_checks ??
      [],
    latest_session_modes: mergeStringArrays(
      base.latest_session_modes,
      [input.sessionMode],
    ),
    latest_entry_paths: mergeStringArrays(
      base.latest_entry_paths,
      [input.entryPath],
    ),
    evidence_count: Number.isFinite(Number(base.evidence_count))
      ? Number(base.evidence_count)
      : 0,
  });
}

export function buildGradingMemoryState(input: {
  currentMemoryState?: StudentMemoryState;
  subjectId: string;
  subjectKey: string;
  subjectName: string;
  examPackVersionId: string;
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
}) {
  const base = input.currentMemoryState ?? {};
  const missingCriteria = input.criteria
    .filter((criterion) => criterion.status !== "earned")
    .map((criterion) => criterion.criterion_key);

  return mergeStudentMemoryState(base, {
    subject_id: input.subjectId,
    subject_key: input.subjectKey,
    subject_name: input.subjectName,
    last_exam_pack_version_id: input.examPackVersionId,
    last_session_id: input.sessionId,
    last_attempt_id: input.attemptId,
    last_attempt_mode: input.attemptMode,
    last_assistance_state: input.assistanceState,
    last_result_state: input.finalStatus,
    last_points_earned: input.pointsEarned,
    last_points_available: input.pointsAvailable,
    last_confidence: input.confidence ?? "medium",
    last_feedback_summary: input.summary,
    latest_gap_criteria: mergeStringArrays(
      base.latest_gap_criteria,
      input.highestValueGap
        ? [input.highestValueGap.criterion_key, ...missingCriteria]
        : missingCriteria,
      8,
    ),
    latest_repair_prompts: mergeStringArrays(
      base.latest_repair_prompts,
      input.highestValueGap ? [input.highestValueGap.repair_prompt] : [],
      6,
    ),
    preferred_help_style: input.finalStatus === "graded"
      ? (input.pointsEarned < input.pointsAvailable
        ? "stepwise"
        : "independent")
      : asString(base.preferred_help_style) ?? "balanced",
    preferred_feedback_density: input.finalStatus === "graded"
      ? (input.confidence === "low" ? "expanded" : "balanced")
      : asString(base.preferred_feedback_density) ?? "balanced",
    preferred_repair_style: input.highestValueGap
      ? "minimum_fix"
      : asString(base.preferred_repair_style) ?? "minimum_fix",
    evidence_count: Number.isFinite(Number(base.evidence_count))
      ? Number(base.evidence_count) + 1
      : 1,
  });
}

export async function loadStudentMemorySnapshot(
  service: ReturnType<typeof createServiceClient>,
  userId: string,
  subjectId: string,
) {
  const { data, error } = await service.schema("app")
    .from("student_memory_snapshots")
    .select(
      "memory_state, state_version, evidence_count, last_event_id, last_event_kind, last_event_at, created_at, updated_at",
    )
    .eq("user_id", userId)
    .eq("subject_id", subjectId)
    .maybeSingle();

  if (error) {
    throw error;
  }

  return data && typeof data === "object" && !Array.isArray(data)
    ? data as Record<string, unknown>
    : null;
}

export async function recordStudentMemoryEvent(
  service: ReturnType<typeof createServiceClient>,
  input: {
    userId: string;
    subjectId: string;
    eventKind:
      | "session_summary"
      | "grading_result"
      | "manual_preference"
      | "stuck_choice"
      | "review_outcome";
    sourceSessionId?: string | null;
    sourceAttemptId?: string | null;
    memoryState: StudentMemoryState;
    eventPayload?: StudentMemoryState;
  },
) {
  const { data, error } = await service.schema("app")
    .from("student_memory_events")
    .insert({
      user_id: input.userId,
      subject_id: input.subjectId,
      event_kind: input.eventKind,
      source_session_id: input.sourceSessionId ?? null,
      source_attempt_id: input.sourceAttemptId ?? null,
      event_payload: {
        event_kind: input.eventKind,
        memory_state: input.memoryState,
        ...(input.eventPayload ?? {}),
      },
    })
    .select("id, created_at")
    .maybeSingle();

  if (error) {
    throw error;
  }

  return data as Record<string, unknown> | null;
}
