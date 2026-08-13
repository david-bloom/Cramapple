// Tests for the raw_calls.jsonl -> ResultCase[] mapping's criteria
// extraction (to_result_cases.mjs). Fixture shapes are taken from the real
// 2026-08-10 capture: the normal response carries result.criteria; the
// idempotency-replay response returns the grading_results DB row, whose
// column is criterion_results. The first version of the script read only
// result.criteria, silently scoring the 5 replay records (all criteria
// earned) as empty -- the defect behind the pilot's inflated +4.7pp
// headline (see REPORT.md, "Correction -- 2026-08-11").
import { extractTrialCriteria } from "./to_result_cases.mjs";

const NORMAL_RECORD = {
  content_key: "APSTATS-SFRQ-005",
  response_index: 2,
  arm: "with_exemplar",
  trial: 1,
  http_status: 200,
  api_response: {
    result: {
      status: "graded",
      criteria: [
        { criterion_key: "a1", status: "earned", points_awarded: 1 },
        { criterion_key: "b1", status: "not_yet_earned", points_awarded: 0 },
      ],
    },
  },
};

// Idempotency replay: `result` is the grading_results row; verdicts live
// under criterion_results and there is no `criteria` key.
const REPLAY_RECORD = {
  content_key: "APSTATS-SFRQ-001",
  response_index: 0,
  arm: "off",
  trial: 3,
  http_status: 200,
  idempotency_key: "0d9f1c7e-0000-4000-a000-000000000000",
  api_response: {
    result: {
      status: "graded",
      criterion_results: [
        { criterion_key: "a1", status: "earned", points_awarded: 1 },
        { criterion_key: "b1", status: "earned", points_awarded: 1 },
        { criterion_key: "c1", status: "earned", points_awarded: 1 },
        { criterion_key: "d1", status: "earned", points_awarded: 1 },
      ],
    },
  },
};

Deno.test("normal records read result.criteria", () => {
  const criteria = extractTrialCriteria(NORMAL_RECORD);
  if (criteria.length !== 2 || criteria[0].criterion_key !== "a1") {
    throw new Error("expected the sanitized criteria array");
  }
});

Deno.test("idempotency-replay records fall back to result.criterion_results", () => {
  const criteria = extractTrialCriteria(REPLAY_RECORD);
  if (
    criteria.length !== 4 ||
    !criteria.every((criterion: { status: string }) => criterion.status === "earned")
  ) {
    throw new Error("replay verdicts must be read, not scored as empty");
  }
});

Deno.test("criteria wins over criterion_results when both are present", () => {
  const criteria = extractTrialCriteria({
    ...NORMAL_RECORD,
    api_response: {
      result: {
        criteria: NORMAL_RECORD.api_response.result.criteria,
        criterion_results: REPLAY_RECORD.api_response.result.criterion_results,
      },
    },
  });
  if (criteria.length !== 2) throw new Error("sanitized criteria must take precedence");
});

Deno.test("a record with neither shape fails loudly and names the record", () => {
  let thrown: Error | null = null;
  try {
    extractTrialCriteria({
      content_key: "APSTATS-SFRQ-009",
      response_index: 4,
      arm: "off",
      trial: 0,
      http_status: 200,
      idempotency_key: "cafebabe-0000-4000-a000-000000000000",
      api_response: { result: { status: "graded" } },
    });
  } catch (error) {
    thrown = error as Error;
  }
  if (!thrown) throw new Error("unrecognized result shape must throw, not emit empty criteria");
  if (
    !thrown.message.includes("APSTATS-SFRQ-009#4") ||
    !thrown.message.includes("cafebabe")
  ) {
    throw new Error(`error must identify the offending record, got: ${thrown.message}`);
  }
});

Deno.test("empty criteria arrays are treated as missing, not as a valid empty verdict", () => {
  let thrown = false;
  try {
    extractTrialCriteria({
      ...NORMAL_RECORD,
      api_response: { result: { criteria: [], criterion_results: [] } },
    });
  } catch {
    thrown = true;
  }
  if (!thrown) throw new Error("empty arrays must fail loudly too");
});
