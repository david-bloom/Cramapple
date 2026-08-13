// Tests for getStatisticsScopedCriteria / NUMERIC_ELEMENT_CRITERIA (replan
// O2, 2026-08-13): the per-criterion flag-scoping lookup. A wrong or stale
// entry here has the exact same silent-blast-radius shape as the SFRQ-008
// key defect this replaces -- scoping the wrong criterion is not "safer
// than item-wide," it is a different way to zero the wrong thing.

import {
  getStatisticsScopedCriteria,
  NUMERIC_ELEMENT_CRITERIA,
  STATISTICS_TARGETS,
} from "./statistics-verifier.ts";

Deno.test("getStatisticsScopedCriteria returns the mapped criteria for a known item", () => {
  const result = getStatisticsScopedCriteria("APSTATS-SFRQ-008");
  if (!result || result.join(",") !== "a-1,a-2") {
    throw new Error(`expected ["a-1","a-2"] for SFRQ-008, got ${JSON.stringify(result)}`);
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

Deno.test("every NUMERIC_ELEMENT_CRITERIA entry points at a keyed (non-null, non-abstain) STATISTICS_TARGETS entry", () => {
  // Catches drift: if a target is ever changed to null (abstain) or removed
  // while its criterion mapping is left behind, the mapping becomes
  // meaningless -- there is no numeric evidence left to scope by.
  for (const contentKey of Object.keys(NUMERIC_ELEMENT_CRITERIA)) {
    const target = STATISTICS_TARGETS[contentKey];
    if (target === undefined) {
      throw new Error(`${contentKey} has a criterion mapping but no STATISTICS_TARGETS entry at all`);
    }
    if (target === null) {
      throw new Error(`${contentKey} has a criterion mapping but its target is null (abstain) -- nothing to scope`);
    }
  }
});

Deno.test("every NUMERIC_ELEMENT_CRITERIA entry lists at least one criterion key", () => {
  for (const [contentKey, keys] of Object.entries(NUMERIC_ELEMENT_CRITERIA)) {
    if (!Array.isArray(keys) || keys.length === 0) {
      throw new Error(`${contentKey} maps to an empty criterion list`);
    }
  }
});
