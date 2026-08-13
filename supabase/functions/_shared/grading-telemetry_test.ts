import {
  createStageTimer,
  normalizeResponseText,
} from "./grading-telemetry.ts";

Deno.test("response normalization is case/whitespace/NFKC-insensitive and nothing more", () => {
  const a = normalizeResponseText("The mean is  -1.40\ndollars.");
  const b = normalizeResponseText("the MEAN is -1.40 dollars.");
  if (a !== b) throw new Error("case and whitespace shape must not distinguish responses");
  // NFKC: full-width digits fold to ASCII.
  if (normalizeResponseText("ｍｅａｎ １.４０") !== "mean 1.40") {
    throw new Error("NFKC compatibility folding must apply");
  }
  // Conservative by design: punctuation and numeric formatting DO
  // distinguish -- the replay threshold must not be reached by an
  // aggressive normalizer.
  if (normalizeResponseText("mean 1.40") === normalizeResponseText("mean 1.4")) {
    throw new Error("normalization must not rewrite numbers");
  }
  if (normalizeResponseText(null) !== "" || normalizeResponseText(undefined) !== "") {
    throw new Error("null/undefined normalize to the empty string");
  }
});

Deno.test("stage timer records per-stage deltas that sum to total, skipping unmarked stages", () => {
  let clock = 0;
  const timer = createStageTimer(() => clock);
  clock = 120;
  timer.mark("auth");
  clock = 320;
  timer.mark("db");
  clock = 321;
  timer.mark("deterministic");
  // no "model" mark -- the deterministic-gate path never calls one
  clock = 350;
  timer.mark("sanitize");
  const timings = timer.finish();
  if (timings.auth !== 120 || timings.db !== 200 || timings.deterministic !== 1 || timings.sanitize !== 29) {
    throw new Error(`per-stage deltas wrong: ${JSON.stringify(timings)}`);
  }
  if ("model" in timings) throw new Error("unmarked stages must be absent, not zero");
  if (timings.total !== 350) throw new Error("total is wall time from construction");
});

Deno.test("marking the same stage twice accumulates rather than overwrites", () => {
  let clock = 0;
  const timer = createStageTimer(() => clock);
  clock = 10;
  timer.mark("db");
  clock = 15;
  timer.mark("deterministic");
  clock = 25;
  timer.mark("db");
  const timings = timer.finish();
  if (timings.db !== 20) throw new Error("repeated marks must accumulate");
});
