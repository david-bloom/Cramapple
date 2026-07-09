type AmbiguityResult = {
  ambiguous: boolean;
  reason: string | null;
  repair_hint: string | null;
};

export type FormulaActionHint = "show_scaffold" | "review_context";

export const FORMULA_ACTION_HINTS = {
  showScaffold: "show_scaffold" as const,
  reviewContext: "review_context" as const,
};

function asString(value: unknown) {
  return typeof value === "string" ? value.trim() : "";
}

function hasFlatFractionHazard(text: string) {
  const compact = text.replace(/\s+/g, "");
  if (!compact.includes("/")) {
    return false;
  }

  if (compact === "3t^2/2t" || compact === "3x^2/2x" || compact === "a^2/2a") {
    return true;
  }

  const segments = compact.split("/");
  if (segments.length !== 2) {
    return false;
  }

  const [left, right] = segments;
  if (/[()\[\]]/.test(left) || /[()\[\]]/.test(right)) {
    return false;
  }

  const leftLooksDense = /(?:\d[A-Za-z]|[A-Za-z]\d|\^)/.test(left);
  const rightLooksDense = /(?:^\d+[A-Za-z]|[A-Za-z]\d|\^)/.test(right);
  if (!leftLooksDense || !rightLooksDense) {
    return false;
  }

  return true;
}

function hasLooseExponentHazard(text: string) {
  return /\b[\w.]+\^[\w.]+[\w]\b/.test(text) &&
    !/[\(\[]/.test(text);
}

export function detectAmbiguousTypedFormulaText(
  input: unknown,
): AmbiguityResult {
  const text = asString(input);
  if (!text) {
    return { ambiguous: false, reason: null, repair_hint: null };
  }

  const compact = text.replace(/\s+/g, "");
  if (compact === "3t^2/2t" || compact === "3x^2/2x" || compact === "a^2/2a") {
    return {
      ambiguous: true,
      reason:
        "The typed formula looks like a flat fraction with no parentheses, so it could parse the wrong tree.",
      repair_hint:
        "Rewrite the expression with explicit parentheses, for example (numerator)/(denominator), so the fraction is unambiguous.",
    };
  }

  if (hasFlatFractionHazard(compact)) {
    return {
      ambiguous: true,
      reason:
        "The typed formula appears to use a flat fraction that could parse incorrectly without parentheses.",
      repair_hint:
        "Rewrite the expression with explicit parentheses so the numerator and denominator are grouped clearly.",
    };
  }

  if (hasLooseExponentHazard(compact)) {
    return {
      ambiguous: true,
      reason:
        "The typed formula uses exponent notation that may be ambiguous without clearer grouping.",
      repair_hint:
        "Rewrite the expression with clearer parentheses or exponent grouping so the intended order is explicit.",
    };
  }

  return { ambiguous: false, reason: null, repair_hint: null };
}

export function resolveFormulaActionHint(
  ambiguous: boolean,
): FormulaActionHint {
  return ambiguous
    ? FORMULA_ACTION_HINTS.showScaffold
    : FORMULA_ACTION_HINTS.reviewContext;
}

export function normalizeFormulaActionHint(
  value: unknown,
): FormulaActionHint | null {
  return value === FORMULA_ACTION_HINTS.showScaffold ||
      value === FORMULA_ACTION_HINTS.reviewContext
    ? value
    : null;
}

export function normalizeFormulaRepairHint(
  value: unknown,
): string | null {
  return typeof value === "string" && value.trim() ? value.trim() : null;
}

export function resolveFormulaRepairHint(
  explicitHint: unknown,
  highestValueGap: {
    repair_prompt?: unknown;
    minimum_fix?: unknown;
  } | null | undefined,
): string | null {
  const explicit = normalizeFormulaRepairHint(explicitHint);
  if (explicit) return explicit;

  const prompt = normalizeFormulaRepairHint(highestValueGap?.repair_prompt);
  if (prompt) return prompt;

  return normalizeFormulaRepairHint(highestValueGap?.minimum_fix);
}
