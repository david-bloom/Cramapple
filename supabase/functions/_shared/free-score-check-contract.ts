const TOUCH_KEYS = new Set([
  "utm_source",
  "utm_medium",
  "utm_campaign",
  "utm_content",
  "utm_term",
  "landing_path",
  "referrer_host",
  "reddit_click_id",
]);

export function asString(value: unknown) {
  return typeof value === "string" && value.trim() ? value.trim() : null;
}

export function asUuid(value: unknown) {
  return typeof value === "string" &&
      /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i
        .test(value)
    ? value
    : null;
}

export function sanitizeTouch(value: unknown) {
  if (!value || typeof value !== "object" || Array.isArray(value)) return {};
  const result: Record<string, string> = {};
  for (const [key, raw] of Object.entries(value as Record<string, unknown>)) {
    if (TOUCH_KEYS.has(key) && typeof raw === "string" && raw.trim()) {
      result[key] = raw.trim().slice(0, 300);
    }
  }
  return result;
}

export function rpcErrorCode(message: string | undefined) {
  return message?.match(/(?:free_score_check|grading_access):([a-z_]+)/)?.[1] ??
    "free_score_check_failed";
}

export type FreeScoreCheckGradingRow = {
  id?: string;
  operation?: string;
  status?: string;
  points_earned?: number | null;
  points_available?: number | null;
  criterion_results?: unknown;
  highest_value_gap?: unknown;
  confidence?: string | null;
  uncertainty_reason?: string | null;
  feedback_preview?: string | null;
  action_hint?: string | null;
  repair_hint?: string | null;
  created_at?: string | null;
};

export function normalizeGradingResult(
  row: FreeScoreCheckGradingRow | null | undefined,
) {
  if (!row) return null;
  const criteria = Array.isArray(row.criterion_results)
    ? row.criterion_results
    : [];
  const pointsEarned = typeof row.points_earned === "number"
    ? row.points_earned
    : 0;
  const pointsAvailable = typeof row.points_available === "number"
    ? row.points_available
    : 0;

  return {
    id: row.id ?? null,
    operation: row.operation ?? null,
    status: row.status ?? "failed",
    points_earned: pointsEarned,
    points_available: pointsAvailable,
    criteria,
    highest_value_gap: row.highest_value_gap ?? null,
    confidence: row.confidence ?? null,
    uncertainty_reason: row.uncertainty_reason ?? null,
    student_facing_summary: row.feedback_preview ?? "",
    action_hint: row.action_hint ?? null,
    repair_hint: row.repair_hint ?? null,
    created_at: row.created_at ?? null,
  };
}

export function pointsGained(
  initial: ReturnType<typeof normalizeGradingResult>,
  repair: ReturnType<typeof normalizeGradingResult>,
) {
  if (!initial || !repair) return null;
  return repair.points_earned - initial.points_earned;
}
