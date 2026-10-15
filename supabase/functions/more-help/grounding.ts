// Only allowlisted fields from the caller-scoped question RPC enter the model.
// Incomplete authored parts fail closed rather than becoming a different question.
export type QuestionPart = { key: string; prompt: string };
const row = (value: unknown): Record<string, unknown> =>
  value && typeof value === "object" && !Array.isArray(value)
    ? value as Record<string, unknown>
    : {};

// This flag is emitted ONLY for an exact reviewed version/path/description
// triple. Metadata approval or a short alt alone is not a complete transcript.
export function questionVisual(value: unknown) {
  const visual = row(value);
  if (
    visual.completeReviewedDescription !== true ||
    typeof visual.description !== "string" || !visual.description.trim() ||
    visual.description.length > 10000 || typeof visual.alt !== "string"
  ) return null;
  return {
    alt: visual.alt,
    description: visual.description,
    provenance: "reviewed_question_visual_description",
  };
}

export function sourceFigures(value: unknown, sourceId: string) {
  if (!Array.isArray(value)) return [];
  return value.map(row).filter((figure) =>
    typeof figure.figureId === "string" &&
    typeof figure.family === "string" && typeof figure.alt === "string" &&
    Array.isArray(figure.usedBy) && figure.usedBy.some((use) => {
      const u = row(use);
      return u.kind === "reference_entry" && u.id === sourceId;
    })
  ).slice(0, 8).map((figure) => {
    const out: Record<string, unknown> = {};
    for (
      const key of [
        "figureId",
        "family",
        "title",
        "shortTitle",
        "subtitle",
        "caption",
        "alt",
        "xLabel",
        "yLabel",
        "note",
        "synthetic",
        "valuesNote",
        "labels",
        "params",
        "yTickFmt",
        "xTickFmt",
      ]
    ) {
      if (figure[key] !== undefined && figure[key] !== null) {
        out[key] = figure[key];
      }
    }
    out.usedBy = (figure.usedBy as unknown[]).map(row)
      .filter((u) => u.kind === "reference_entry" && u.id === sourceId)
      .map((u) => ({ kind: "reference_entry", id: sourceId, role: u.role }));
    return out;
  });
}
export function questionParts(value: unknown): QuestionPart[] | null {
  if (value === undefined || value === null) return [];
  if (!Array.isArray(value) || value.length > 26) return null;
  const seen = new Set<string>();
  const out: QuestionPart[] = [];
  for (const part of value) {
    if (!part || typeof part !== "object" || Array.isArray(part)) return null;
    const { key, prompt } = part as Record<string, unknown>;
    if (
      typeof key !== "string" || !key.trim() || key.length > 80 ||
      seen.has(key) || typeof prompt !== "string" || !prompt.trim()
    ) return null;
    seen.add(key);
    out.push({ key, prompt });
  }
  return out;
}
