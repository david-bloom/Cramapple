import { convertCalibrationLabels } from "./ap-statistics-gold.ts";
import { evaluateLaunchBar } from "./launch-bar.ts";
import { scoreRun } from "./harness.ts";

const provisionalDoc = {
  schema: "provisional_calibration_labels_v1",
  label_authority: "AI provisional (Claude Fable); NOT human-adjudicated gold",
  corpus_defects: [{ content_key: "APSTAT-DEFECT-001" }],
  items: [
    {
      content_key: "APSTAT-MOD3-H001-INV",
      rubric: [{ criterion_key: "bias" }, { criterion_key: "ci_calc" }],
      responses: [
        {
          response_index: 0,
          response_text: "correct answer",
          criteria: {
            // deliberately out of rubric order to prove ordering is stable
            ci_calc: { provisional_label: "earned" },
            bias: { provisional_label: "earned" },
          },
        },
        {
          response_index: 1,
          response_text: "partial answer",
          criteria: {
            bias: { provisional_label: "not_earned" },
            ci_calc: { provisional_label: "partially_earned" },
          },
          expected_repair_criterion_key: "bias",
          forbidden_repair_phrases: ["the answer is 20"],
        },
      ],
    },
    {
      content_key: "APSTAT-DEFECT-001",
      rubric: [{ criterion_key: "x" }],
      responses: [
        { response_index: 0, response_text: "n/a", criteria: { x: { provisional_label: "earned" } } },
      ],
    },
  ],
};

Deno.test("convertCalibrationLabels flattens responses and excludes corpus defects", () => {
  const result = convertCalibrationLabels(provisionalDoc);
  if (result.case_count !== 2) throw new Error("defect item must be dropped -> 2 cases");
  if (result.criterion_count !== 4) throw new Error("expected 4 labelled criteria");
  if (!result.is_provisional) throw new Error("provisional authority must be flagged");
  if (JSON.stringify(result.excluded_defects) !== JSON.stringify(["APSTAT-DEFECT-001"])) {
    throw new Error("corpus defect must be recorded as excluded");
  }
  // rubric order preserved regardless of key order in the response
  if (JSON.stringify(result.cases[0].criteria.map((c) => c.criterion_key)) !== JSON.stringify(["bias", "ci_calc"])) {
    throw new Error("gold criterion order must follow the rubric");
  }
  if (result.cases[1].expected_repair_criterion_key !== "bias") throw new Error("repair target must carry through");
  if (JSON.stringify(result.cases[1].forbidden_repair_phrases) !== JSON.stringify(["the answer is 20"])) {
    throw new Error("forbidden repair phrases must carry through");
  }
});

Deno.test("convertCalibrationLabels accepts adjudicated gold_label and E/P/N/U codes", () => {
  const result = convertCalibrationLabels({
    label_authority: "human dual-blind adjudicated gold",
    items: [
      {
        content_key: "X",
        rubric: [{ criterion_key: "a" }, { criterion_key: "b" }],
        responses: [
          {
            response_index: 0,
            response_text: "r",
            criteria: { a: { gold_label: "earned" }, b: { gold_label: "N" } },
          },
        ],
      },
    ],
  });
  if (result.is_provisional) throw new Error("adjudicated authority must not be flagged provisional");
  if (result.cases[0].criteria[1].gold_label !== "not_earned") throw new Error("E/P/N/U codes must normalize");
});

Deno.test("convertCalibrationLabels rejects unknown labels", () => {
  let threw = false;
  try {
    convertCalibrationLabels({
      items: [{
        content_key: "X",
        rubric: [{ criterion_key: "a" }],
        responses: [{ response_index: 0, response_text: "r", criteria: { a: { provisional_label: "mostly" } } }],
      }],
    });
  } catch {
    threw = true;
  }
  if (!threw) throw new Error("unknown label must fail closed");
});

Deno.test("launch bar gates on accuracy floor and p50 ceiling, reports p90/p99 and cost", () => {
  const verdict = evaluateLaunchBar({
    overall_accuracy: 0.96,
    results: [
      { content_key: "A", response_index: 0, criteria: [], latency_ms: 400, cost_usd: 0.004 },
      { content_key: "A", response_index: 1, criteria: [], latency_ms: 900, cost_usd: 0.006 },
      { content_key: "B", response_index: 0, criteria: [], latency_ms: 1500, cost_usd: 0.02 },
    ],
  });
  if (!verdict.gates.accuracy.pass) throw new Error("0.96 must clear the 0.95 floor");
  if (verdict.gates.latency_p50_ms.value !== 900) throw new Error("p50 must be 900");
  if (!verdict.gates.latency_p50_ms.pass) throw new Error("p50=900 clears the 1000ms ceiling even with a high tail");
  if (verdict.reported.latency_p99_ms !== 1500) throw new Error("p99 must report the tail");
  if (!verdict.pass) throw new Error("both gates pass -> overall pass");
});

Deno.test("launch bar fails when accuracy below floor", () => {
  const verdict = evaluateLaunchBar({
    overall_accuracy: 0.9,
    results: [{ content_key: "A", response_index: 0, criteria: [], latency_ms: 100, cost_usd: 0.001 }],
  });
  if (verdict.gates.accuracy.pass) throw new Error("0.90 must fail the 0.95 floor");
  if (verdict.pass) throw new Error("failing a gate must fail overall");
});

Deno.test("launch bar cannot pass latency gate with no timings captured", () => {
  const verdict = evaluateLaunchBar({
    overall_accuracy: 0.99,
    results: [{ content_key: "A", response_index: 0, criteria: [] }],
  });
  if (verdict.gates.latency_p50_ms.value !== null) throw new Error("no latency -> null p50");
  if (verdict.gates.latency_p50_ms.pass) throw new Error("missing timing cannot pass the latency gate");
  if (verdict.pass) throw new Error("missing timing must fail overall");
});

// End-to-end: converted provisional gold + a self-consistent candidate scores
// and evaluates the bar. Proves the pipeline is push-button; accuracy here is a
// plumbing artifact (candidate mirrors gold), not a quality measurement.
Deno.test("end-to-end: convert -> score -> launch bar", () => {
  const converted = convertCalibrationLabels(provisionalDoc);
  const candidate = converted.cases.map((c) => ({
    content_key: c.content_key,
    response_index: c.response_index,
    criteria: c.criteria.map((cr) => ({
      criterion_key: cr.criterion_key,
      status: cr.gold_label === "earned" ? "earned" : "not_yet_earned",
      points_awarded: cr.gold_label === "earned" ? 1 : 0,
      points_possible: 1,
    })),
    latency_ms: 500,
    cost_usd: 0.005,
  }));
  const scored = scoreRun(converted.cases, candidate);
  const verdict = evaluateLaunchBar(
    { overall_accuracy: scored.overall_accuracy, results: candidate },
  );
  if (scored.case_count !== 2) throw new Error("expected 2 scored cases");
  if (!verdict.gates.latency_p50_ms.pass) throw new Error("500ms p50 must clear the ceiling");
});
