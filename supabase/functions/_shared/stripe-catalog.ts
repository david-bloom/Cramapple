// Subject-key-to-Price-ID mapping for the Stripe catalog (TASK-0023). Kept
// out of the database and out of committed code because the mapping is
// environment-specific (test-mode Price IDs for beta/preview, live-mode
// Price IDs for production) and must never be cross-wired between them —
// see docs/architecture/PRODUCTION_PLUMBING_AND_CUTOVER_PLAN.md §5. Each
// environment sets STRIPE_PRICE_CATALOG_JSON as an Edge Function secret.
//
// Expected shape:
// {
//   "subjects": { "biology": "price_...", "ap-chemistry": "price_...", ... },
//   "bundle_2": "price_...",
//   "bundle_3": "price_...",
//   "unlimited": "price_..."
// }

export type PriceCatalog = {
  subjects: Record<string, string>;
  bundle_2: string;
  bundle_3: string;
  unlimited: string;
};

const BUNDLE_KEYS = ["bundle_2", "bundle_3", "unlimited"] as const;

export function parsePriceCatalog(raw: string): PriceCatalog {
  let parsed: unknown;
  try {
    parsed = JSON.parse(raw);
  } catch {
    throw new Error("STRIPE_PRICE_CATALOG_JSON is not valid JSON");
  }
  if (!parsed || typeof parsed !== "object" || Array.isArray(parsed)) {
    throw new Error("STRIPE_PRICE_CATALOG_JSON must be a JSON object");
  }
  const value = parsed as Record<string, unknown>;

  const rawSubjects = value.subjects;
  if (
    !rawSubjects || typeof rawSubjects !== "object" || Array.isArray(rawSubjects)
  ) {
    throw new Error("STRIPE_PRICE_CATALOG_JSON.subjects must be an object");
  }
  const subjects: Record<string, string> = {};
  for (
    const [subjectKey, priceId] of Object.entries(
      rawSubjects as Record<string, unknown>,
    )
  ) {
    if (typeof priceId !== "string" || !priceId.startsWith("price_")) {
      throw new Error(
        `STRIPE_PRICE_CATALOG_JSON.subjects.${subjectKey} must be a Stripe price id`,
      );
    }
    subjects[subjectKey] = priceId;
  }

  for (const bundleKey of BUNDLE_KEYS) {
    const priceId = value[bundleKey];
    if (typeof priceId !== "string" || !priceId.startsWith("price_")) {
      throw new Error(
        `STRIPE_PRICE_CATALOG_JSON.${bundleKey} must be a Stripe price id`,
      );
    }
  }

  return {
    subjects,
    bundle_2: value.bundle_2 as string,
    bundle_3: value.bundle_3 as string,
    unlimited: value.unlimited as string,
  };
}

export function loadPriceCatalog(): PriceCatalog {
  const raw = Deno.env.get("STRIPE_PRICE_CATALOG_JSON");
  if (!raw) {
    throw new Error(
      "Missing required environment variable: STRIPE_PRICE_CATALOG_JSON",
    );
  }
  return parsePriceCatalog(raw);
}
