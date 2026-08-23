type GradingTarget =
  | "mcq_rule"
  | "llm_text"
  | "symbolic_ecf"
  | "shadow_review"
  | "data_driven";

export type RubricType =
  | "mcq"
  | "discrete_text"
  | "structured_formula"
  | "spatial"
  | "holistic";

export type GradingRoute = {
  rubricType: RubricType;
  evaluatorStrategy: string;
  target: GradingTarget;
  source: "explicit" | "legacy_item_type" | "prompt_json" | "default";
  reason: string;
};

function asString(value: unknown) {
  return typeof value === "string" && value.trim() ? value.trim() : null;
}

function asRecord(value: unknown) {
  return value && typeof value === "object" && !Array.isArray(value)
    ? value as Record<string, unknown>
    : null;
}

function readDeclaredRouteValue(promptJson: unknown, key: string) {
  const record = asRecord(promptJson);
  if (!record) return null;

  const direct = asString(record[key]);
  if (direct) return direct;

  const verificationProfile = asRecord(record.verification_profile);
  if (verificationProfile) {
    const nested = asString(verificationProfile[key]);
    if (nested) return nested;
  }

  return null;
}

function normalizeRubricType(value: unknown): RubricType | null {
  const rubricType = asString(value);
  return rubricType === "mcq" ||
      rubricType === "discrete_text" ||
      rubricType === "structured_formula" ||
      rubricType === "spatial" ||
      rubricType === "holistic"
    ? rubricType
    : null;
}

function normalizeEvaluatorStrategy(value: unknown) {
  const strategy = asString(value);
  return strategy === "rule_based_mcq" ||
      strategy === "llm_discrete_text" ||
      strategy === "python_symbolic_ecf" ||
      strategy === "human_shadow" ||
      strategy === "data_driven_deterministic"
    ? strategy
    : null;
}

function routeFromRubricType(rubricType: RubricType): GradingRoute {
  switch (rubricType) {
    case "mcq":
      return {
        rubricType,
        evaluatorStrategy: "rule_based_mcq",
        target: "mcq_rule",
        source: "explicit",
        reason: "MCQ answers are handled by the deterministic exact-match path.",
      };
    case "discrete_text":
      return {
        rubricType,
        evaluatorStrategy: "llm_discrete_text",
        target: "llm_text",
        source: "explicit",
        reason: "Discrete analytic text is routed to the existing FRQ grader.",
      };
    case "structured_formula":
      return {
        rubricType,
        evaluatorStrategy: "python_symbolic_ecf",
        target: "symbolic_ecf",
        source: "explicit",
        reason:
          "Structured formula grading is routed to the symbolic plus ECF verifier boundary.",
      };
    case "spatial":
      return {
        rubricType,
        evaluatorStrategy: "human_shadow",
        target: "shadow_review",
        source: "explicit",
        reason:
          "Spatial grading is out of scope for Phase A and routes to shadow review.",
      };
    case "holistic":
      return {
        rubricType,
        evaluatorStrategy: "human_shadow",
        target: "shadow_review",
        source: "explicit",
        reason:
          "Holistic grading is deferred and routes to shadow review.",
      };
  }
}

function fallbackFromItemType(itemType: string | null): GradingRoute {
  if (itemType === "mcq") {
    return routeFromRubricType("mcq");
  }

  if (itemType === "quantitative") {
    return {
      rubricType: "structured_formula",
      evaluatorStrategy: "python_symbolic_ecf",
      target: "symbolic_ecf",
      source: "legacy_item_type",
      reason:
        "Legacy quantitative items are treated as structured-formula candidates and routed to the symbolic plus ECF verifier boundary.",
    };
  }

  if (itemType === "frq") {
    return {
      rubricType: "discrete_text",
      evaluatorStrategy: "llm_discrete_text",
      target: "llm_text",
      source: "legacy_item_type",
      reason:
        "Legacy FRQ items continue on the existing discrete-text grading path.",
    };
  }

  return {
    rubricType: "discrete_text",
    evaluatorStrategy: "human_shadow",
    target: "shadow_review",
    source: "default",
    reason:
      "Unsupported or missing rubric metadata routes to shadow review instead of guessing.",
  };
}

export function resolveGradingRoute(input: {
  rubricType?: unknown;
  evaluatorStrategy?: unknown;
  itemType?: string | null;
  promptJson?: unknown;
}): GradingRoute {
  const explicitRubricType = normalizeRubricType(input.rubricType);
  if (explicitRubricType) {
    return routeFromRubricType(explicitRubricType);
  }

  const explicitStrategy = normalizeEvaluatorStrategy(input.evaluatorStrategy);
  if (explicitStrategy) {
    switch (explicitStrategy) {
      case "rule_based_mcq":
        return routeFromRubricType("mcq");
      case "llm_discrete_text":
        return routeFromRubricType("discrete_text");
      case "python_symbolic_ecf":
        return routeFromRubricType("structured_formula");
      case "data_driven_deterministic":
        return {
          rubricType: "structured_formula",
          evaluatorStrategy: "data_driven_deterministic",
          target: "data_driven",
          source: "explicit",
          reason:
            "Generated instance graded by the data-driven deterministic verifier, which reads the item's persisted content_item_checks (no per-content_key code).",
        };
      case "human_shadow":
        return {
          ...fallbackFromItemType(input.itemType ?? null),
          evaluatorStrategy: "human_shadow",
          target: "shadow_review",
          reason:
            "The rubric explicitly requests human shadow review, so the item is held instead of routed to an automated grader.",
        };
    }
  }

  const promptRubricType = normalizeRubricType(
    readDeclaredRouteValue(input.promptJson, "rubric_type"),
  );
  if (promptRubricType) {
    return routeFromRubricType(promptRubricType);
  }

  const promptStrategy = normalizeEvaluatorStrategy(
    readDeclaredRouteValue(input.promptJson, "evaluator_strategy"),
  );
  if (promptStrategy) {
    return resolveGradingRoute({
      rubricType: null,
      evaluatorStrategy: promptStrategy,
      itemType: input.itemType ?? null,
      promptJson: null,
    });
  }

  return fallbackFromItemType(input.itemType ?? null);
}
