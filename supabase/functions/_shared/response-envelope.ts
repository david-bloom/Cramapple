// Envelope parsing only; schemas, prompts, budgets and transport remain feature-owned.
export function responseOutputText(raw: unknown, stopOnRefusal = true): string | null {
  if (!raw || typeof raw !== "object") return null;
  const rec = raw as Record<string, unknown>;
  if (typeof rec.output_text === "string" && rec.output_text.length) return rec.output_text;
  if (!Array.isArray(rec.output)) return null;
  for (const item of rec.output) {
    if (!item || typeof item !== "object") continue;
    const content = (item as Record<string, unknown>).content;
    if (!Array.isArray(content)) continue;
    for (const piece of content) {
      if (!piece || typeof piece !== "object") continue;
      const value = piece as Record<string, unknown>;
      if (stopOnRefusal && value.type === "refusal") return null;
      if (typeof value.text === "string" && value.text.length) return value.text;
    }
  }
  return null;
}

// Existing grading parser historically skipped refusal nodes. Preserve that
// policy explicitly; changing it belongs in its own behavior review.
export function gradingOutputText(raw: Record<string, unknown>): string | null {
  return responseOutputText(raw, false);
}

export function responseUsage(raw: unknown): { input_tokens: number | null; output_tokens: number | null } {
  const usage = (raw as Record<string, unknown> | null)?.usage as Record<string, unknown> | undefined;
  const finite = (v: unknown) => typeof v === "number" && Number.isFinite(v) ? v : null;
  return { input_tokens: finite(usage?.input_tokens), output_tokens: finite(usage?.output_tokens) };
}
