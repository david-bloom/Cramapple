import {
  buildEcfResult,
  checkFormulaCase,
  coerceEcfQuestion,
  type EcfPartSpec,
  findStatisticsItem,
} from "./math-verifier.ts";
import formulaCases from "../../../docs/research/math_formula_grading_experiment_2026_07_08/cases.json" with { type: "json" };

type FormulaCaseFixture = {
  id: string;
  subject: string;
  kind: "expression" | "antiderivative" | "numeric" | "conceptual";
  variables?: string[];
  var?: string;
  canonical: string | null;
  response: string;
  expected: "PASS" | "FLAG" | "ABSTAIN";
  domain?: [number, number];
  tol?: number;
};

const formulaCasesData = formulaCases as {
  cases: FormulaCaseFixture[];
  hazards: Array<Pick<FormulaCaseFixture, "id" | "kind" | "variables" | "var" | "canonical" | "response"> & { note: string }>;
};

Deno.test("symbolic formula battery matches the reference cases", () => {
  for (const item of formulaCasesData.cases) {
    const result = checkFormulaCase({
      kind: item.kind,
      canonical: item.canonical,
      response: item.response,
      variables: item.variables,
      var: item.var,
      domain: item.domain,
      tol: item.tol,
    });

    if (result.verdict !== item.expected) {
      throw new Error(
        `expected ${item.expected} for ${item.id}, got ${result.verdict} (${result.reason ?? "no reason"})`,
      );
    }
  }

  const flatFractionHazard = formulaCasesData.hazards.find((item) =>
    item.id === "HZ-2-flatfrac"
  );
  if (!flatFractionHazard) {
    throw new Error("expected the flat-fraction hazard case");
  }

  const hazardResult = checkFormulaCase({
    kind: flatFractionHazard.kind,
    canonical: flatFractionHazard.canonical,
    response: flatFractionHazard.response,
    variables: flatFractionHazard.variables,
    var: flatFractionHazard.var,
  });
  if (hazardResult.verdict !== "ABSTAIN") {
    throw new Error("expected the flat-fraction hazard to abstain");
  }

  for (const item of formulaCasesData.hazards) {
    if (item.id === "HZ-2-flatfrac") {
      continue;
    }
    const result = checkFormulaCase({
      kind: item.kind,
      canonical: item.canonical,
      response: item.response,
      variables: item.variables,
      var: item.var,
    });
    if (result.verdict === "FLAG") {
      throw new Error(`did not expect hazard ${item.id} to false-flag`);
    }
  }
});

Deno.test("ambiguous flat fractions abstain instead of false-flagging", () => {
  const result = checkFormulaCase({
    kind: "expression",
    canonical: "3*t/2",
    response: "3t^2/2t",
    variables: ["t"],
  });

  if (result.verdict !== "ABSTAIN") {
    throw new Error("expected abstain for flat-fraction hazard");
  }
});

Deno.test("coerces ECF responses from wrapped student-part JSON", () => {
  const item = findStatisticsItem("APSTAT-MOD6-H001");
  if (!item) throw new Error("expected statistics item");

  const question = coerceEcfQuestion(item, {
    student: {
      SE_diff: {
        stated_formula: "sqrt(s1**2/n1 + s2**2/n2)",
        shown_subs: { s1: 8, n1: 30, s2: 7, n2: 30 },
        student_answer: 1.94079,
      },
      t_stat: {
        stated_formula: "(m1 - m2)/SEd",
        shown_subs: { m1: 72, m2: 76, SEd: 1.94079 },
        student_answer: -2.06104,
      },
    },
  });

  if (!question) throw new Error("expected coercible question");
  const result = buildEcfResult(question);

  if (result.parts.length !== 2) {
    throw new Error("expected two ECF parts");
  }
  if (result.parts[0].verdict !== "CORRECT") {
    throw new Error("expected first part to be correct");
  }
  if (result.parts[1].verdict !== "CORRECT") {
    throw new Error("expected second part to be correct");
  }
});

Deno.test("ECF accepts a correct answer when substitutions are not itemized", () => {
  const item = findStatisticsItem("APSTAT-MOD3-H001-INV");
  if (!item) throw new Error("expected statistics item");

  const question = coerceEcfQuestion(item, {
    student: {
      SE: {
        stated_formula: "s/sqrt(n)",
        shown_subs: null,
        student_answer: 21.9089,
      },
      CI_low: {
        stated_formula: "xbar - z*SE",
        shown_subs: { xbar: 850, z: 1.96, SE: 21.9089 },
        student_answer: 807.05863,
      },
      CI_high: {
        stated_formula: "xbar + z*SE",
        shown_subs: { xbar: 850, z: 1.96, SE: 21.9089 },
        student_answer: 892.94137,
      },
      t_stat: {
        stated_formula: "(xbar - mu0)/SE",
        shown_subs: { xbar: 850, mu0: 800, SE: 21.9089 },
        student_answer: 2.28217,
      },
    },
  });

  if (!question) throw new Error("expected coercible question");
  const result = buildEcfResult(question);
  if (result.parts[0].verdict !== "CORRECT") {
    throw new Error(`expected correct SE verdict, got ${result.parts[0].verdict}`);
  }
});

Deno.test("formula checker uses exponent precedence before unary minus", () => {
  const negativePower = checkFormulaCase({
    kind: "numeric",
    canonical: "-2^2",
    response: "-4",
  });
  if (negativePower.verdict !== "PASS") {
    throw new Error("expected -2^2 to evaluate as -4");
  }

  const wrongSign = checkFormulaCase({
    kind: "numeric",
    canonical: "-2^2",
    response: "4",
  });
  if (wrongSign.verdict !== "FLAG") {
    throw new Error("expected 4 to be flagged against -2^2");
  }
});

Deno.test("formula checker accepts negative exponents", () => {
  const numeric = checkFormulaCase({
    kind: "numeric",
    canonical: "0.5",
    response: "2^-1",
  });
  if (numeric.verdict !== "PASS") {
    throw new Error("expected 2^-1 to evaluate to 0.5");
  }

  const expression = checkFormulaCase({
    kind: "expression",
    canonical: "1/x",
    response: "x^-1",
    variables: ["x"],
  });
  if (expression.verdict !== "PASS") {
    throw new Error("expected x^-1 to match 1/x");
  }
});

Deno.test("formula checker samples multivariable expressions independently", () => {
  const result = checkFormulaCase({
    kind: "expression",
    canonical: "x - y",
    response: "-0.03125",
    variables: ["x", "y"],
  });

  if (result.verdict !== "FLAG") {
    throw new Error("expected multivariable non-equivalence to be flagged");
  }
});

Deno.test("formula checker preserves signed-square behavior", () => {
  const negativeCanonical = checkFormulaCase({
    kind: "numeric",
    canonical: "-4",
    response: "-2^2",
  });
  if (negativeCanonical.verdict !== "PASS") {
    throw new Error("expected -2^2 to evaluate to -4");
  }

  const parenthesized = checkFormulaCase({
    kind: "numeric",
    canonical: "4",
    response: "(-2)^2",
  });
  if (parenthesized.verdict !== "PASS") {
    throw new Error("expected (-2)^2 to evaluate to 4");
  }
});

Deno.test("ap statistics item metadata remains available for the router boundary", () => {
  const item = findStatisticsItem("APSTAT-MOD3-H001-INV");
  if (!item) throw new Error("expected item");
  if (item.ecf_parts.length !== 4) {
    throw new Error("expected four ecf parts");
  }
});

// --- Regression tests for the three defects found by the Engine 3 harness,
// --- 2026-07-28. See docs/research/ENGINE3_HARNESS_RUN1_RESULTS_2026_07_28.md

Deno.test("BUG1: a supplied input named `e` or `pi` wins over the built-in constant", () => {
  const parts = [{
    id: "mean",
    points: 1,
    canonical_formula: "(a+b+c+d+e)/5",
    givens: { a: 12, b: 15, c: 18, d: 21, e: 24 },
    canonical_answer: 18,
  }];
  const result = buildEcfResult({
    parts,
    student: {
      mean: {
        stated_formula: "(a+b+c+d+e)/5",
        shown_subs: { a: 12, b: 15, c: 18, d: 21, e: 24 },
        student_answer: 18,
      },
    },
  });
  // Before the fix this evaluated to (66 + Math.E)/5 = 13.7437 and returned INCORRECT,
  // silently mis-grading the published item STATS-MOD1-E004.
  if (result.parts[0].verdict !== "CORRECT") throw new Error(`expected "CORRECT", got ${result.parts[0].verdict}`);
  if (result.earned !== 1) throw new Error(`expected 1, got ${result.earned}`);

  const piParts = [{
    id: "t",
    points: 1,
    canonical_formula: "pi*2",
    givens: { pi: 10 },
    canonical_answer: 20,
  }];
  const piResult = buildEcfResult({
    parts: piParts,
    student: { t: { stated_formula: "pi*2", shown_subs: { pi: 10 }, student_answer: 20 } },
  });
  if (piResult.parts[0].verdict !== "CORRECT") throw new Error(`expected "CORRECT", got ${piResult.parts[0].verdict}`);
});

Deno.test("BUG2: a wrong answer on a no-dependency part is INCORRECT, not CORRECT_VIA_ECF", () => {
  const parts = [{
    id: "pct_within_1sd",
    points: 1,
    canonical_formula: "68",
    givens: {},
    canonical_answer: 68,
  }];
  const result = buildEcfResult({
    parts,
    student: {
      pct_within_1sd: {
        stated_formula: "68",
        shown_subs: {},
        student_answer: 92.5,
      },
    },
  });
  // Before the fix this awarded FULL MARKS via CORRECT_VIA_ECF, with feedback
  // citing an "earlier part" that does not exist.
  if (result.parts[0].verdict !== "INCORRECT") throw new Error(`expected "INCORRECT", got ${result.parts[0].verdict}`);
  if (result.earned !== 0) throw new Error(`expected 0, got ${result.earned}`);
});

Deno.test("BUG2: genuine carried-forward error still earns CORRECT_VIA_ECF", () => {
  const parts: EcfPartSpec[] = [
    { id: "SE", points: 1, canonical_formula: "s/sqrt(n)", givens: { s: 120, n: 30 }, canonical_answer: 21.9089 },
    {
      id: "CI_low",
      points: 1,
      canonical_formula: "xbar - z*SE",
      givens: { xbar: 850, z: 1.96 },
      deps: { SE: "SE" },
      canonical_answer: 807.05863,
    },
  ];
  const wrongSE = 25;
  const result = buildEcfResult({
    parts,
    student: {
      SE: { stated_formula: "s/sqrt(n)", shown_subs: { s: 120, n: 30 }, student_answer: wrongSE },
      CI_low: {
        stated_formula: "xbar - z*SE",
        shown_subs: { xbar: 850, z: 1.96, SE: wrongSE },
        student_answer: 850 - 1.96 * wrongSE,
      },
    },
  });
  if (result.parts[0].verdict !== "INCORRECT") throw new Error(`expected "INCORRECT", got ${result.parts[0].verdict}`);
  if (result.parts[1].verdict !== "CORRECT_VIA_ECF") throw new Error(`expected "CORRECT_VIA_ECF", got ${result.parts[1].verdict}`);
  if (result.earned !== 1) throw new Error(`expected 1, got ${result.earned}`);
});

Deno.test("BUG3: erf and factorial parse and evaluate", () => {
  const erfParts = [{
    id: "confidence_level",
    points: 1,
    canonical_formula: "erf((1.645 / 2) / sqrt(2))",
    givens: {},
    canonical_answer: 0.58921,
  }];
  const erfResult = buildEcfResult({
    parts: erfParts,
    student: {
      confidence_level: {
        stated_formula: "erf((1.645 / 2) / sqrt(2))",
        shown_subs: { dummy: 1 },
        student_answer: 0.58921,
      },
    },
  });
  // Before the fix the canonical formula failed to parse and this returned
  // NAKED_ANSWER — telling a fully correct student "no work shown".
  if (erfResult.parts[0].verdict !== "CORRECT") throw new Error(`expected "CORRECT", got ${erfResult.parts[0].verdict}`);

  const factParts = [{
    id: "probability_exactly_8",
    points: 1,
    canonical_formula: "factorial(20) / (factorial(8) * factorial(12)) * (0.4**8) * (0.6**12)",
    givens: {},
    canonical_answer: 0.179705787754689,
  }];
  const factResult = buildEcfResult({
    parts: factParts,
    student: {
      probability_exactly_8: {
        stated_formula: "factorial(20) / (factorial(8) * factorial(12)) * (0.4**8) * (0.6**12)",
        shown_subs: { dummy: 1 },
        student_answer: 0.179705787754689,
      },
    },
  });
  if (factResult.parts[0].verdict !== "CORRECT") throw new Error(`expected "CORRECT", got ${factResult.parts[0].verdict}`);
});
