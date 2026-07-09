import {
  buildEcfResult,
  checkFormulaCase,
  coerceEcfQuestion,
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
