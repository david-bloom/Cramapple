import { createServiceClient } from "./supabase.ts";
import {
  asRecord,
  loadStudentMemorySnapshot,
  mergeStringArrays,
} from "./student-memory.ts";

function orderByLabelType(labelType: string) {
  switch (labelType) {
    case "unit":
      return 0;
    case "topic":
      return 1;
    case "skill":
      return 2;
    default:
      return 3;
  }
}

function groupLabels(labels: Record<string, unknown>[]) {
  const grouped: Record<string, Record<string, unknown>[]> = {};
  for (const label of labels) {
    const labelType = typeof label.label_type === "string"
      ? label.label_type
      : "other";
    grouped[labelType] ??= [];
    grouped[labelType].push(label);
  }

  return grouped;
}

export async function loadLearningRuntimeContext(
  service: ReturnType<typeof createServiceClient>,
  sessionId: string,
) {
  const { data: session, error: sessionError } = await service.schema("app")
    .from("learning_sessions")
    .select(
      "id, user_id, exam_pack_version_id, entry_path, session_mode, available_minutes, status, started_at, ended_at, created_at, updated_at",
    )
    .eq("id", sessionId)
    .maybeSingle();

  if (sessionError || !session) {
    return null;
  }

  const { data: examPackVersion, error: examPackVersionError } = await service
    .schema("app")
    .from("exam_pack_versions")
    .select(
      "id, exam_pack_id, school_year, official_exam_date, status, source_uri, source_published_at, released_at, created_at, updated_at",
    )
    .eq("id", session.exam_pack_version_id)
    .maybeSingle();

  if (examPackVersionError || !examPackVersion) {
    return null;
  }

  const { data: examPack, error: examPackError } = await service.schema("app")
    .from("exam_packs")
    .select("id, exam_code, exam_name, subject_id, created_at, updated_at")
    .eq("id", examPackVersion.exam_pack_id)
    .maybeSingle();

  if (examPackError || !examPack) {
    return null;
  }

  const { data: subject, error: subjectError } = await service.schema("app")
    .from("subjects")
    .select("id, subject_key, display_name, status, created_at, updated_at")
    .eq("id", examPack.subject_id)
    .maybeSingle();

  if (subjectError || !subject) {
    return null;
  }

  const { data: guidanceProfile, error: guidanceError } = await service
    .schema("app")
    .from("subject_guidance_profiles")
    .select("profile_version, guidance_defaults, status, created_at, updated_at")
    .eq("subject_id", subject.id)
    .maybeSingle();

  if (guidanceError) {
    return null;
  }

  const { data: labels, error: labelsError } = await service.schema("app")
    .from("content_labels")
    .select("label_key, label_name, label_type, status, created_at, updated_at")
    .eq("exam_pack_id", examPack.id)
    .neq("status", "retired")
    .order("label_type", { ascending: true })
    .order("label_key", { ascending: true });

  if (labelsError) {
    return null;
  }

  const memorySnapshot = await loadStudentMemorySnapshot(
    service,
    session.user_id,
    subject.id,
  );

  const recentAttemptsQuery = await service.schema("app")
    .from("attempts")
    .select(
      "id, content_item_version_id, attempt_mode, status, assistance_state, started_at, submitted_at, graded_at, score_points, score_possible, confidence_level, result_state, result_summary",
    )
    .eq("learning_session_id", session.id)
    .order("started_at", { ascending: false })
    .limit(5);

  if (recentAttemptsQuery.error) {
    return null;
  }

  const labelRows = (labels ?? []) as Record<string, unknown>[];

  const groupedLabels = groupLabels(labelRows);
  const guidanceDefaults = asRecord(guidanceProfile?.guidance_defaults);
  const memoryState = asRecord(memorySnapshot?.memory_state);
  const recentGapCriteria = mergeStringArrays(
    memoryState.recent_gap_criteria,
    [],
  );

  return {
    context_version: "2026-07-07",
    subject_defaults: {
      subject: {
        id: subject.id,
        subject_key: subject.subject_key,
        display_name: subject.display_name,
        status: subject.status,
      },
      exam_pack: {
        id: examPack.id,
        exam_code: examPack.exam_code,
        exam_name: examPack.exam_name,
      },
      exam_pack_version: {
        id: examPackVersion.id,
        school_year: examPackVersion.school_year,
        official_exam_date: examPackVersion.official_exam_date,
        status: examPackVersion.status,
      },
      guidance_profile: guidanceProfile
        ? {
          profile_version: guidanceProfile.profile_version,
          status: guidanceProfile.status,
          guidance_defaults: guidanceDefaults,
        }
        : null,
      taxonomy_labels: {
        grouped: groupedLabels,
        flat: labelRows.map((row) => ({
          label_key: row.label_key,
          label_name: row.label_name,
          label_type: row.label_type,
          status: row.status,
        })).sort((a, b) =>
          orderByLabelType(String(a.label_type)) -
          orderByLabelType(String(b.label_type))
        ),
      },
    },
    student_memory: {
      memory_state: memoryState,
      state_version: memorySnapshot?.state_version ?? "2026-07-07",
      evidence_count: memorySnapshot?.evidence_count ?? 0,
      last_event_id: memorySnapshot?.last_event_id ?? null,
      last_event_kind: memorySnapshot?.last_event_kind ?? null,
      last_event_at: memorySnapshot?.last_event_at ?? null,
      recent_gap_criteria: recentGapCriteria,
    },
    session_state: {
      id: session.id,
      user_id: session.user_id,
      exam_pack_version_id: session.exam_pack_version_id,
      entry_path: session.entry_path,
      session_mode: session.session_mode,
      available_minutes: session.available_minutes,
      status: session.status,
      started_at: session.started_at,
      ended_at: session.ended_at,
      recent_attempts: recentAttemptsQuery.data ?? [],
    },
    effective_guidance: {
      ...guidanceDefaults,
      ...memoryState,
      current_session_mode: session.session_mode,
      current_entry_path: session.entry_path,
      available_minutes: session.available_minutes,
      session_status: session.status,
    },
  };
}
