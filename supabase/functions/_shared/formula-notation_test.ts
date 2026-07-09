import {
  detectAmbiguousTypedFormulaText,
  normalizeFormulaActionHint,
  normalizeFormulaRepairHint,
  resolveFormulaRepairHint,
  resolveFormulaActionHint,
} from "./formula-notation.ts";

Deno.test("detects flat fraction typed formula hazards", () => {
  const result = detectAmbiguousTypedFormulaText("3t^2/2t");
  if (!result.ambiguous) throw new Error("expected ambiguous");
  if (!result.reason) throw new Error("expected reason");
  if (!result.repair_hint) throw new Error("expected repair hint");
});

Deno.test("allows clearly grouped typed formulas", () => {
  const result = detectAmbiguousTypedFormulaText("(3*t^2)/(2*t)");
  if (result.ambiguous) throw new Error("expected unambiguous");
});

Deno.test("allows ordinary prose responses", () => {
  const result = detectAmbiguousTypedFormulaText("Because the slope is positive.");
  if (result.ambiguous) throw new Error("expected unambiguous");
});

Deno.test("maps ambiguity to the scaffold hint vocabulary", () => {
  if (resolveFormulaActionHint(true) !== "show_scaffold") {
    throw new Error("expected show_scaffold");
  }
  if (resolveFormulaActionHint(false) !== "review_context") {
    throw new Error("expected review_context");
  }
});

Deno.test("normalizes only known action-hint values", () => {
  if (normalizeFormulaActionHint("show_scaffold") !== "show_scaffold") {
    throw new Error("expected show_scaffold");
  }
  if (normalizeFormulaActionHint("review_context") !== "review_context") {
    throw new Error("expected review_context");
  }
  if (normalizeFormulaActionHint("other") !== null) {
    throw new Error("expected null");
  }
});

Deno.test("normalizes repair hints conservatively", () => {
  if (normalizeFormulaRepairHint("  Rewrite the fraction.  ") !== "Rewrite the fraction.") {
    throw new Error("expected trimmed hint");
  }
  if (normalizeFormulaRepairHint("") !== null) {
    throw new Error("expected null");
  }
});

Deno.test("resolves repair hints from the highest-value gap", () => {
  const derived = resolveFormulaRepairHint(null, {
    repair_prompt: "  Rewrite with parentheses. ",
    minimum_fix: "Use parentheses.",
  });
  if (derived !== "Rewrite with parentheses.") {
    throw new Error("expected repair_prompt to win");
  }

  const fallback = resolveFormulaRepairHint(null, {
    minimum_fix: "Use parentheses.",
  });
  if (fallback !== "Use parentheses.") {
    throw new Error("expected minimum_fix fallback");
  }
});
