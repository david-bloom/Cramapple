import {
  assertEquals,
  assertThrows,
} from "https://deno.land/std@0.224.0/assert/mod.ts";
import { parsePriceCatalog } from "./stripe-catalog.ts";

const VALID_CATALOG = JSON.stringify({
  subjects: {
    biology: "price_biology",
    "ap-chemistry": "price_chemistry",
  },
  bundle_2: "price_bundle2",
  bundle_3: "price_bundle3",
  unlimited: "price_unlimited",
});

Deno.test("parses a valid catalog", () => {
  assertEquals(parsePriceCatalog(VALID_CATALOG), {
    subjects: {
      biology: "price_biology",
      "ap-chemistry": "price_chemistry",
    },
    bundle_2: "price_bundle2",
    bundle_3: "price_bundle3",
    unlimited: "price_unlimited",
  });
});

Deno.test("rejects invalid JSON", () => {
  assertThrows(() => parsePriceCatalog("{not json"));
});

Deno.test("rejects a non-object top level value", () => {
  assertThrows(() => parsePriceCatalog("[]"));
});

Deno.test("rejects a missing subjects map", () => {
  assertThrows(() =>
    parsePriceCatalog(JSON.stringify({
      bundle_2: "price_bundle2",
      bundle_3: "price_bundle3",
      unlimited: "price_unlimited",
    }))
  );
});

Deno.test("rejects a subject price id that isn't a Stripe price id", () => {
  assertThrows(() =>
    parsePriceCatalog(JSON.stringify({
      subjects: { biology: "not-a-price-id" },
      bundle_2: "price_bundle2",
      bundle_3: "price_bundle3",
      unlimited: "price_unlimited",
    }))
  );
});

Deno.test("rejects a missing bundle price id", () => {
  assertThrows(() =>
    parsePriceCatalog(JSON.stringify({
      subjects: { biology: "price_biology" },
      bundle_2: "price_bundle2",
      unlimited: "price_unlimited",
    }))
  );
});
