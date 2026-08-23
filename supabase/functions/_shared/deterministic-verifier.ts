// Generic data-driven deterministic verifier (Course Mode F4).
//
// Grades a student's numeric/interval response against an item's PERSISTED
// deterministic checks (app.content_item_checks.checks), with NO per-content_key
// TypeScript. This is the scalable replacement for the hardcoded per-content_key
// map in statistics-verifier.ts (CM-FACT-20): any generated instance whose
// generator emitted `deterministic_checks` can be graded by construction.
//
// Routed to via evaluator_strategy = "data_driven_deterministic"
// (see grading-router.ts, target "data_driven").
//
// Determinism (INV-4): grading is a pure function of (checks, response). No model
// inference. Unknown check kinds and unparseable responses ABSTAIN rather than
// guess (mirrors CM-D07's content-uncertain -> weight 0 posture), so an
// ambiguous case is never silently scored wrong.

export type NumericCheck = { kind: "numeric"; value: number; tol: number };
export type IntervalCheck = {
  kind: "interval";
  low: number;
  high: number;
  tol: number;
};
// Other kinds (e.g. slot-frame "mcq_key") are graded on their own path; here they
// abstain. Kept open so the array can carry mixed kinds without a parse error.
export type DeterministicCheck =
  | NumericCheck
  | IntervalCheck
  | { kind: string; [key: string]: unknown };

export type CheckStatus = "pass" | "fail" | "abstain";

export type CheckVerdict = {
  kind: string;
  status: CheckStatus;
  reason: string;
};

export type GradeStatus = "correct" | "incorrect" | "abstain";

export type GradeResult = {
  status: GradeStatus;
  verdicts: CheckVerdict[];
};

const NUMBER_RE = /-?\d+(?:\.\d+)?/g;

/** Extract the decimal numbers appearing in a response string, in order. */
export function extractNumbers(response: string): number[] {
  if (typeof response !== "string") return [];
  const matches = response.match(NUMBER_RE);
  if (!matches) return [];
  return matches.map(Number).filter((n) => Number.isFinite(n));
}

function isNumericCheck(c: DeterministicCheck): c is NumericCheck {
  return c.kind === "numeric" &&
    typeof (c as NumericCheck).value === "number" &&
    typeof (c as NumericCheck).tol === "number";
}

function isIntervalCheck(c: DeterministicCheck): c is IntervalCheck {
  return c.kind === "interval" &&
    typeof (c as IntervalCheck).low === "number" &&
    typeof (c as IntervalCheck).high === "number" &&
    typeof (c as IntervalCheck).tol === "number";
}

function gradeNumeric(check: NumericCheck, response: string): CheckVerdict {
  const nums = extractNumbers(response);
  if (nums.length !== 1) {
    return {
      kind: "numeric",
      status: "abstain",
      reason:
        `expected exactly one number in the response, found ${nums.length}`,
    };
  }
  const got = nums[0];
  const ok = Math.abs(got - check.value) <= check.tol;
  return {
    kind: "numeric",
    status: ok ? "pass" : "fail",
    reason: ok
      ? `${got} is within +/-${check.tol} of ${check.value}`
      : `${got} is not within +/-${check.tol} of ${check.value}`,
  };
}

function gradeInterval(check: IntervalCheck, response: string): CheckVerdict {
  const nums = extractNumbers(response);
  if (nums.length !== 2) {
    return {
      kind: "interval",
      status: "abstain",
      reason:
        `expected exactly two numbers (low, high) in the response, found ${nums.length}`,
    };
  }
  const [lo, hi] = nums;
  const ok = Math.abs(lo - check.low) <= check.tol &&
    Math.abs(hi - check.high) <= check.tol;
  return {
    kind: "interval",
    status: ok ? "pass" : "fail",
    reason: ok
      ? `(${lo}, ${hi}) matches (${check.low}, ${check.high}) within +/-${check.tol}`
      : `(${lo}, ${hi}) does not match (${check.low}, ${check.high}) within +/-${check.tol}`,
  };
}

function gradeOne(check: DeterministicCheck, response: string): CheckVerdict {
  if (isNumericCheck(check)) return gradeNumeric(check, response);
  if (isIntervalCheck(check)) return gradeInterval(check, response);
  return {
    kind: typeof check.kind === "string" ? check.kind : "unknown",
    status: "abstain",
    reason:
      `check kind ${JSON.stringify(check.kind)} is not handled by the data-driven verifier`,
  };
}

/**
 * Grade a response against a criterion's deterministic checks.
 *
 * Aggregation: any abstain -> "abstain" (route to human / weight 0); otherwise
 * any fail -> "incorrect"; otherwise "correct". An empty check list abstains
 * (nothing to verify), never silently passes.
 */
export function gradeAgainstChecks(
  checks: DeterministicCheck[],
  response: string,
): GradeResult {
  if (!Array.isArray(checks) || checks.length === 0) {
    return {
      status: "abstain",
      verdicts: [{
        kind: "none",
        status: "abstain",
        reason: "no deterministic checks to verify against",
      }],
    };
  }
  const verdicts = checks.map((c) => gradeOne(c, response));
  let status: GradeStatus;
  if (verdicts.some((v) => v.status === "abstain")) {
    status = "abstain";
  } else if (verdicts.some((v) => v.status === "fail")) {
    status = "incorrect";
  } else {
    status = "correct";
  }
  return { status, verdicts };
}
