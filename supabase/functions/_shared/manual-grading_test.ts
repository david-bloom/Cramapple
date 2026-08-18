import { assertEquals } from "https://deno.land/std@0.224.0/assert/mod.ts";
import {
  type CriterionCatalogEntry,
  scoreManualGrade,
  type SubmittedCriterion,
} from "./manual-grading.ts";

const CATALOG: CriterionCatalogEntry[] = [
  { criterion_key: "BOXPLOT_SCALE", points_possible: 1 },
  { criterion_key: "FIVE_NUMBER_VALUES", points_possible: 1 },
  { criterion_key: "CENTER_COMPARISON", points_possible: 1 },
  { criterion_key: "VARIABILITY_COMPARISON", points_possible: 1 },
];

function criterion(
  key: string,
  status: SubmittedCriterion["status"],
  points: number,
): SubmittedCriterion {
  return {
    criterion_key: key,
    status,
    points_awarded: points,
    evidence_quote: null,
    decision_explanation: "test",
    minimum_fix: null,
  };
}

Deno.test("scoreManualGrade sums points across all-earned criteria", () => {
  const submitted = CATALOG.map((c) => criterion(c.criterion_key, "earned", 1));
  const result = scoreManualGrade(submitted, CATALOG);
  assertEquals(result, {
    ok: true,
    criteria: submitted,
    points_earned: 4,
    points_available: 4,
  });
});

Deno.test("scoreManualGrade computes a mixed score correctly", () => {
  const submitted = [
    criterion("BOXPLOT_SCALE", "earned", 1),
    criterion("FIVE_NUMBER_VALUES", "not_yet_earned", 0),
    criterion("CENTER_COMPARISON", "earned", 1),
    criterion("VARIABILITY_COMPARISON", "unable_to_determine", 0),
  ];
  const result = scoreManualGrade(submitted, CATALOG);
  assertEquals(result.ok, true);
  if (result.ok) {
    assertEquals(result.points_earned, 2);
    assertEquals(result.points_available, 4);
  }
});

Deno.test("scoreManualGrade rejects a missing criterion (fails closed)", () => {
  const submitted = CATALOG.slice(0, 3).map((c) =>
    criterion(c.criterion_key, "earned", 1)
  );
  const result = scoreManualGrade(submitted, CATALOG);
  assertEquals(result, {
    ok: false,
    reason: "manual_grade_missing_criteria",
  });
});

Deno.test("scoreManualGrade rejects an unknown criterion key", () => {
  const submitted = [
    ...CATALOG.map((c) => criterion(c.criterion_key, "earned", 1)),
    criterion("NOT_A_REAL_KEY", "earned", 1),
  ];
  const result = scoreManualGrade(submitted, CATALOG);
  assertEquals(result, {
    ok: false,
    reason: "manual_grade_unknown_criterion_key",
  });
});

Deno.test("scoreManualGrade rejects a duplicate criterion key", () => {
  const submitted = [
    criterion("BOXPLOT_SCALE", "earned", 1),
    criterion("BOXPLOT_SCALE", "earned", 1),
    criterion("CENTER_COMPARISON", "earned", 1),
    criterion("VARIABILITY_COMPARISON", "earned", 1),
  ];
  const result = scoreManualGrade(submitted, CATALOG);
  assertEquals(result, {
    ok: false,
    reason: "manual_grade_duplicate_criterion_key",
  });
});

Deno.test("scoreManualGrade rejects points_awarded above points_possible", () => {
  const submitted = CATALOG.map((c) => criterion(c.criterion_key, "earned", 1));
  submitted[0] = criterion("BOXPLOT_SCALE", "earned", 5);
  const result = scoreManualGrade(submitted, CATALOG);
  assertEquals(result, {
    ok: false,
    reason: "manual_grade_points_exceed_possible",
  });
});

Deno.test("scoreManualGrade rejects earned status with zero points (status/points contradiction)", () => {
  const submitted = CATALOG.map((c) => criterion(c.criterion_key, "earned", 1));
  submitted[0] = criterion("BOXPLOT_SCALE", "earned", 0);
  const result = scoreManualGrade(submitted, CATALOG);
  assertEquals(result, {
    ok: false,
    reason: "manual_grade_status_points_mismatch",
  });
});

Deno.test("scoreManualGrade rejects not_yet_earned status with nonzero points", () => {
  const submitted = CATALOG.map((c) => criterion(c.criterion_key, "earned", 1));
  submitted[0] = criterion("BOXPLOT_SCALE", "not_yet_earned", 1);
  const result = scoreManualGrade(submitted, CATALOG);
  assertEquals(result, {
    ok: false,
    reason: "manual_grade_status_points_mismatch",
  });
});

Deno.test("scoreManualGrade rejects a negative points_awarded", () => {
  const submitted = CATALOG.map((c) => criterion(c.criterion_key, "earned", 1));
  submitted[0] = { ...submitted[0], points_awarded: -1 };
  const result = scoreManualGrade(submitted, CATALOG);
  assertEquals(result, {
    ok: false,
    reason: "manual_grade_invalid_points_awarded",
  });
});

Deno.test("scoreManualGrade rejects a non-integer points_awarded", () => {
  const submitted = CATALOG.map((c) => criterion(c.criterion_key, "earned", 1));
  submitted[0] = { ...submitted[0], points_awarded: 0.5 };
  const result = scoreManualGrade(submitted, CATALOG);
  assertEquals(result, {
    ok: false,
    reason: "manual_grade_invalid_points_awarded",
  });
});

Deno.test("scoreManualGrade rejects an invalid status string", () => {
  const submitted = CATALOG.map((c) => criterion(c.criterion_key, "earned", 1));
  submitted[0] = {
    ...submitted[0],
    status: "definitely_correct" as unknown as SubmittedCriterion["status"],
  };
  const result = scoreManualGrade(submitted, CATALOG);
  assertEquals(result, { ok: false, reason: "manual_grade_invalid_status" });
});

Deno.test("scoreManualGrade accepts a valid partially_earned criterion", () => {
  const multiPointCatalog: CriterionCatalogEntry[] = [
    { criterion_key: "MULTI", points_possible: 3 },
  ];
  const submitted = [criterion("MULTI", "partially_earned", 2)];
  const result = scoreManualGrade(submitted, multiPointCatalog);
  assertEquals(result.ok, true);
  if (result.ok) {
    assertEquals(result.points_earned, 2);
    assertEquals(result.points_available, 3);
  }
});

Deno.test("scoreManualGrade rejects partially_earned at the full or zero boundary", () => {
  const multiPointCatalog: CriterionCatalogEntry[] = [
    { criterion_key: "MULTI", points_possible: 3 },
  ];
  assertEquals(
    scoreManualGrade(
      [criterion("MULTI", "partially_earned", 3)],
      multiPointCatalog,
    ),
    { ok: false, reason: "manual_grade_status_points_mismatch" },
  );
  assertEquals(
    scoreManualGrade(
      [criterion("MULTI", "partially_earned", 0)],
      multiPointCatalog,
    ),
    { ok: false, reason: "manual_grade_status_points_mismatch" },
  );
});

Deno.test("scoreManualGrade fails closed on an empty criteria catalog", () => {
  const result = scoreManualGrade([], []);
  assertEquals(result, {
    ok: false,
    reason: "manual_grade_no_criteria_catalog",
  });
});
