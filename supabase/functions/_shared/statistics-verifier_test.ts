// Tests for getStatisticsScopedCriteria / PRODUCTION_NUMERIC_ELEMENT_CRITERIA
// (replan O2, 2026-08-13): the per-criterion flag-scoping lookup used at
// grading time. A wrong or stale entry here has the exact same
// silent-blast-radius shape as the SFRQ-008 key defect this replaces --
// scoping the wrong criterion is not "safer than item-wide," it is a
// different way to zero the wrong thing.
//
// NUMERIC_ELEMENT_CRITERIA (a separate map, also in statistics-verifier.ts)
// is audit-only and indexes into gold-answer SCRIPT element ids, not real
// criterion keys -- see that map's own comment. Do not confuse the two;
// this file deliberately tests PRODUCTION_NUMERIC_ELEMENT_CRITERIA, the one
// getStatisticsScopedCriteria actually reads.

import {
  getStatisticsScopedCriteria,
  NUMERIC_ELEMENT_CRITERIA,
  PRODUCTION_NUMERIC_ELEMENT_CRITERIA,
  STATISTICS_TARGETS,
} from "./statistics-verifier.ts";

Deno.test("getStatisticsScopedCriteria returns the mapped criteria for a known item", () => {
  const result = getStatisticsScopedCriteria("APSTATS-SFRQ-008");
  if (!result || result.join(",") !== "a") {
    throw new Error(`expected ["a"] for SFRQ-008, got ${JSON.stringify(result)}`);
  }
});

// Snapshot of the exact mapping, verified against production
// app.frq_criteria.criterion_key on 2026-08-13 (see the query in
// PRODUCTION_NUMERIC_ELEMENT_CRITERIA's comment). This exists specifically
// to catch the bug this map shipped with same-day: an earlier version
// reused NUMERIC_ELEMENT_CRITERIA's gold-fixture element ids (a1, b-1,
// a-2 ...) directly for runtime scoping, which matched zero real criteria
// on 7 of 8 items (only SFRQ-001's fixture ids happened to coincide with
// its real ones). If this test ever needs to change, it must be because a
// NEW live query confirmed the new values -- not because the numbers were
// convenient.
Deno.test("PRODUCTION_NUMERIC_ELEMENT_CRITERIA matches production app.frq_criteria.criterion_key exactly", () => {
  const expected: Record<string, string[]> = {
    "APSTATS-SFRQ-001": ["a1", "c1"],
    "APSTATS-SFRQ-002": ["a"],
    "APSTATS-SFRQ-003": ["c"],
    "APSTATS-SFRQ-004": ["b"],
    "APSTATS-SFRQ-007": ["b", "c"],
    "APSTATS-SFRQ-008": ["a"],
    "APSTATS-SFRQ-009": ["a"],
    "APSTATS-SFRQ-010": ["a"],
  };
  const actualKeys = Object.keys(PRODUCTION_NUMERIC_ELEMENT_CRITERIA).sort();
  const expectedKeys = Object.keys(expected).sort();
  if (actualKeys.join(",") !== expectedKeys.join(",")) {
    throw new Error(
      `mapped content_key set changed -- got [${actualKeys}], expected [${expectedKeys}]. ` +
        `If intentional (a new item's mapping was added/removed), update this test's ` +
        `"expected" against a fresh production query, not from memory.`,
    );
  }
  for (const [contentKey, keys] of Object.entries(expected)) {
    const actual = PRODUCTION_NUMERIC_ELEMENT_CRITERIA[contentKey];
    if (!actual || actual.join(",") !== keys.join(",")) {
      throw new Error(
        `${contentKey}: expected [${keys}], got [${actual}] -- re-verify against ` +
          `production app.frq_criteria.criterion_key before changing this test`,
      );
    }
  }
});

Deno.test("PRODUCTION_NUMERIC_ELEMENT_CRITERIA does not reuse NUMERIC_ELEMENT_CRITERIA's fixture-id values", () => {
  // Regression guard for the exact bug found 2026-08-13: the two maps must
  // never be assigned from the same object/values again, since they index
  // different namespaces (gold-fixture script element ids vs real
  // frq_criteria.criterion_key). A future refactor that "simplifies" this
  // back into one map would silently reintroduce the no-op-scoping bug.
  for (const contentKey of Object.keys(PRODUCTION_NUMERIC_ELEMENT_CRITERIA)) {
    if (contentKey === "APSTATS-SFRQ-001") continue; // legitimately identical by coincidence
    const prod = PRODUCTION_NUMERIC_ELEMENT_CRITERIA[contentKey];
    const audit = NUMERIC_ELEMENT_CRITERIA[contentKey];
    if (audit && prod.join(",") === audit.join(",")) {
      throw new Error(
        `${contentKey}: PRODUCTION_NUMERIC_ELEMENT_CRITERIA matches NUMERIC_ELEMENT_CRITERIA's ` +
          `fixture ids exactly -- verify this isn't the 2026-08-13 bug recurring (real ` +
          `criterion keys are plain letters, fixture ids have numeric/hyphen suffixes)`,
      );
    }
  }
});

Deno.test("getStatisticsScopedCriteria returns null for an item with no known mapping", () => {
  // SFRQ-011 is keyed in STATISTICS_TARGETS but has no gold answers, so no
  // element-decomposition mapping exists -- callers must fall back to the
  // item-wide behavior, not guess.
  const result = getStatisticsScopedCriteria("APSTATS-SFRQ-011");
  if (result !== null) {
    throw new Error("an unmapped keyed item must return null, not scope on a guess");
  }
});

Deno.test("getStatisticsScopedCriteria returns null for a content_key that doesn't exist at all", () => {
  if (getStatisticsScopedCriteria("NOT-A-REAL-CONTENT-KEY") !== null) {
    throw new Error("an unknown content_key must return null");
  }
});

Deno.test("getStatisticsScopedCriteria returns null for null/undefined content_key", () => {
  if (getStatisticsScopedCriteria(null) !== null) {
    throw new Error("null content_key must return null");
  }
  if (getStatisticsScopedCriteria(undefined) !== null) {
    throw new Error("undefined content_key must return null");
  }
});

Deno.test("every PRODUCTION_NUMERIC_ELEMENT_CRITERIA entry points at a keyed (non-null, non-abstain) STATISTICS_TARGETS entry", () => {
  // Catches drift: if a target is ever changed to null (abstain) or removed
  // while its criterion mapping is left behind, the mapping becomes
  // meaningless -- there is no numeric evidence left to scope by.
  for (const contentKey of Object.keys(PRODUCTION_NUMERIC_ELEMENT_CRITERIA)) {
    const target = STATISTICS_TARGETS[contentKey];
    if (target === undefined) {
      throw new Error(`${contentKey} has a criterion mapping but no STATISTICS_TARGETS entry at all`);
    }
    if (target === null) {
      throw new Error(`${contentKey} has a criterion mapping but its target is null (abstain) -- nothing to scope`);
    }
  }
});

Deno.test("every PRODUCTION_NUMERIC_ELEMENT_CRITERIA entry lists at least one criterion key", () => {
  for (const [contentKey, keys] of Object.entries(PRODUCTION_NUMERIC_ELEMENT_CRITERIA)) {
    if (!Array.isArray(keys) || keys.length === 0) {
      throw new Error(`${contentKey} maps to an empty criterion list`);
    }
  }
});
