import {
  extractNumbers,
  gradeAgainstChecks,
} from "./deterministic-verifier.ts";

function assert(cond: boolean, msg: string) {
  if (!cond) throw new Error(msg);
}

// --- extractNumbers ---------------------------------------------------------
Deno.test("extractNumbers pulls decimals in order, ignoring surrounding text", () => {
  assert(
    JSON.stringify(extractNumbers("z = 1.23")) === JSON.stringify([1.23]),
    "single number",
  );
  assert(
    JSON.stringify(extractNumbers("(0.4535, 0.6132)")) ===
      JSON.stringify([0.4535, 0.6132]),
    "interval pair",
  );
  assert(
    JSON.stringify(extractNumbers("P = -0.5")) === JSON.stringify([-0.5]),
    "negative",
  );
  assert(JSON.stringify(extractNumbers("no numbers")) === "[]", "none");
  // leading-decimal forms must parse as < 1, not as an integer (Fable QA #4)
  assert(JSON.stringify(extractNumbers(".8413")) === JSON.stringify([0.8413]), "leading dot");
  assert(JSON.stringify(extractNumbers("-.85")) === JSON.stringify([-0.85]), "neg leading dot");
});

Deno.test("leading-decimal probability grades correctly, not mis-scored (Fable QA #4)", () => {
  const checks = [{ kind: "numeric", value: 0.8413, tol: 0.005 }];
  assert(gradeAgainstChecks(checks, ".8413").status === "correct", "leading-dot correct");
  assert(gradeAgainstChecks(checks, ".20").status === "incorrect", "leading-dot wrong value");
  const negChecks = [{ kind: "numeric", value: -0.85, tol: 0.01 }];
  assert(gradeAgainstChecks(negChecks, "-.85").status === "correct", "neg leading-dot");
});

// --- numeric checks ---------------------------------------------------------
Deno.test("numeric check passes within tolerance and fails outside", () => {
  const checks = [{ kind: "numeric", value: 1.23, tol: 0.01 }];
  assert(gradeAgainstChecks(checks, "z = 1.23").status === "correct", "exact");
  assert(gradeAgainstChecks(checks, "z = 1.235").status === "correct", "within tol");
  assert(gradeAgainstChecks(checks, "z = 1.30").status === "incorrect", "outside tol");
});

Deno.test("numeric check abstains when the response has no single number", () => {
  const checks = [{ kind: "numeric", value: 1.23, tol: 0.01 }];
  assert(gradeAgainstChecks(checks, "I am not sure").status === "abstain", "zero numbers");
  assert(gradeAgainstChecks(checks, "1.2 or 3.4").status === "abstain", "two numbers");
});

Deno.test("numeric tolerance boundary is inclusive", () => {
  const checks = [{ kind: "numeric", value: 10, tol: 0.5 }];
  assert(gradeAgainstChecks(checks, "10.5").status === "correct", "at +tol");
  assert(gradeAgainstChecks(checks, "9.5").status === "correct", "at -tol");
  assert(gradeAgainstChecks(checks, "10.51").status === "incorrect", "just past tol");
});

// --- interval checks (as the one_prop_ci generator emits) -------------------
Deno.test("interval check matches both bounds within tolerance", () => {
  const checks = [{ kind: "interval", low: 0.4535, high: 0.6132, tol: 0.001 }];
  assert(
    gradeAgainstChecks(checks, "(0.4535, 0.6132)").status === "correct",
    "exact interval",
  );
  assert(
    gradeAgainstChecks(checks, "(0.453, 0.613)").status === "correct",
    "rounded within tol",
  );
  assert(
    gradeAgainstChecks(checks, "(0.40, 0.61)").status === "incorrect",
    "low bound off",
  );
});

Deno.test("interval check abstains without exactly two numbers", () => {
  const checks = [{ kind: "interval", low: 0.45, high: 0.61, tol: 0.001 }];
  assert(gradeAgainstChecks(checks, "0.45").status === "abstain", "one number");
});

// --- aggregation + edge cases ----------------------------------------------
Deno.test("abstain dominates fail dominates correct across multiple checks", () => {
  const passC = { kind: "numeric", value: 1, tol: 0.01 };
  const failC = { kind: "numeric", value: 2, tol: 0.01 };
  const unknownC = { kind: "mcq_key", correct_type: "x" };
  // response "1" -> pass for passC, fail for failC (2 vs 1), so incorrect
  assert(gradeAgainstChecks([passC, failC], "1").status === "incorrect", "one fails");
  // adding an unknown-kind check -> abstain dominates
  assert(
    gradeAgainstChecks([passC, unknownC], "1").status === "abstain",
    "unknown kind abstains",
  );
});

Deno.test("empty or non-array checks abstain rather than pass", () => {
  assert(gradeAgainstChecks([], "1.23").status === "abstain", "empty");
  // deno-lint-ignore no-explicit-any
  assert(gradeAgainstChecks(null as any, "1.23").status === "abstain", "non-array");
});

Deno.test("malformed numeric check (missing tol) abstains, never passes", () => {
  // A check object claiming kind numeric but missing tol must not be trusted.
  // deno-lint-ignore no-explicit-any
  const checks = [{ kind: "numeric", value: 1.23 } as any];
  assert(gradeAgainstChecks(checks, "1.23").status === "abstain", "missing tol");
});
