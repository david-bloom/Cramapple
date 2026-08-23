import { resolveGradingRoute } from "./grading-router.ts";

Deno.test("routes explicit mcq rubric to rule-based exact match", () => {
  const route = resolveGradingRoute({
    rubricType: "mcq",
    itemType: "frq",
  });

  if (route.target !== "mcq_rule") throw new Error("expected mcq_rule");
  if (route.evaluatorStrategy !== "rule_based_mcq") {
    throw new Error("expected rule_based_mcq");
  }
  if (route.source !== "explicit") throw new Error("expected explicit source");
});

Deno.test("routes legacy FRQ items to discrete-text grading", () => {
  const route = resolveGradingRoute({
    itemType: "frq",
  });

  if (route.target !== "llm_text") throw new Error("expected llm_text");
  if (route.rubricType !== "discrete_text") {
    throw new Error("expected discrete_text");
  }
  if (route.evaluatorStrategy !== "llm_discrete_text") {
    throw new Error("expected llm_discrete_text");
  }
  if (route.source !== "legacy_item_type") {
    throw new Error("expected legacy_item_type");
  }
});

Deno.test("routes legacy quantitative items to the symbolic ECF verifier", () => {
  const route = resolveGradingRoute({
    itemType: "quantitative",
  });

  if (route.target !== "symbolic_ecf") {
    throw new Error("expected symbolic_ecf");
  }
  if (route.evaluatorStrategy !== "python_symbolic_ecf") {
    throw new Error("expected python_symbolic_ecf");
  }
  if (route.source !== "legacy_item_type") {
    throw new Error("expected legacy_item_type");
  }
});

Deno.test("routes structured formulas to the symbolic ECF verifier", () => {
  const route = resolveGradingRoute({
    rubricType: "structured_formula",
    itemType: "frq",
  });

  if (route.target !== "symbolic_ecf") {
    throw new Error("expected symbolic_ecf");
  }
  if (route.evaluatorStrategy !== "python_symbolic_ecf") {
    throw new Error("expected python_symbolic_ecf");
  }
  if (route.source !== "explicit") throw new Error("expected explicit source");
});

Deno.test("routes explicit human shadow requests to shadow review even for FRQ items", () => {
  const route = resolveGradingRoute({
    evaluatorStrategy: "human_shadow",
    itemType: "frq",
  });

  if (route.target !== "shadow_review") {
    throw new Error("expected shadow_review");
  }
  if (route.evaluatorStrategy !== "human_shadow") {
    throw new Error("expected human_shadow");
  }
});

Deno.test("routes unsupported rubric metadata to shadow review", () => {
  const route = resolveGradingRoute({
    itemType: "essay",
    promptJson: {
      rubric_type: "unsupported_type",
      evaluator_strategy: "unknown_strategy",
    },
  });

  if (route.target !== "shadow_review") {
    throw new Error("expected shadow_review");
  }
  if (route.source !== "default") {
    throw new Error("expected default source");
  }
  if (route.evaluatorStrategy !== "human_shadow") {
    throw new Error("expected human_shadow");
  }
});

Deno.test("reads rubric metadata from prompt_json verification_profile", () => {
  const route = resolveGradingRoute({
    itemType: "frq",
    promptJson: {
      verification_profile: {
        rubric_type: "spatial",
      },
    },
  });

  if (route.target !== "shadow_review") {
    throw new Error("expected shadow_review");
  }
  if (route.rubricType !== "spatial") throw new Error("expected spatial");
  if (route.evaluatorStrategy !== "human_shadow") {
    throw new Error("expected human_shadow");
  }
});

Deno.test("honors prompt_json evaluator strategy when rubric_type is absent", () => {
  const route = resolveGradingRoute({
    itemType: "frq",
    promptJson: {
      evaluator_strategy: "human_shadow",
    },
  });

  if (route.target !== "shadow_review") {
    throw new Error("expected shadow_review");
  }
  if (route.evaluatorStrategy !== "human_shadow") {
    throw new Error("expected human_shadow");
  }
  if (route.source !== "legacy_item_type") {
    throw new Error("expected legacy_item_type");
  }
});

Deno.test("routes explicit data_driven_deterministic strategy to the data-driven verifier", () => {
  const route = resolveGradingRoute({
    evaluatorStrategy: "data_driven_deterministic",
    itemType: "quantitative",
  });

  if (route.target !== "data_driven") throw new Error("expected data_driven");
  if (route.evaluatorStrategy !== "data_driven_deterministic") {
    throw new Error("expected data_driven_deterministic");
  }
  if (route.source !== "explicit") throw new Error("expected explicit source");
});

Deno.test("honors prompt_json data_driven_deterministic strategy when rubric_type is absent", () => {
  const route = resolveGradingRoute({
    itemType: "mcq",
    promptJson: {
      evaluator_strategy: "data_driven_deterministic",
    },
  });

  if (route.target !== "data_driven") throw new Error("expected data_driven");
  if (route.evaluatorStrategy !== "data_driven_deterministic") {
    throw new Error("expected data_driven_deterministic");
  }
});

Deno.test("prefers prompt_json rubric_type over evaluator strategy when both are present", () => {
  const route = resolveGradingRoute({
    itemType: "frq",
    promptJson: {
      rubric_type: "structured_formula",
      evaluator_strategy: "llm_discrete_text",
    },
  });

  if (route.target !== "symbolic_ecf") {
    throw new Error("expected symbolic_ecf");
  }
  if (route.rubricType !== "structured_formula") {
    throw new Error("expected structured_formula");
  }
  if (route.evaluatorStrategy !== "python_symbolic_ecf") {
    throw new Error("expected python_symbolic_ecf");
  }
  if (route.source !== "explicit") {
    throw new Error("expected explicit source");
  }
});
