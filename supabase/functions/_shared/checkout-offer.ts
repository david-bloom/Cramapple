import type { PriceCatalog } from "./stripe-catalog.ts";

export type OfferMode = "single" | "bundle_2" | "bundle_3" | "unlimited";
const REQUIRED_SUBJECT_COUNT = { single: 1, bundle_2: 2, bundle_3: 3 };

/** Resolve only trusted catalog prices; callers retain their purchase-policy gates. */
export function resolveCheckoutOffer(
  catalog: PriceCatalog,
  mode: OfferMode,
  rawSubjectKeys: unknown,
) {
  if (mode === "unlimited") {
    return { priceId: catalog.unlimited, subjectKeys: [] as string[] };
  }
  const keys = Array.isArray(rawSubjectKeys)
    ? rawSubjectKeys.filter((entry): entry is string =>
      typeof entry === "string" && entry.trim().length > 0
    ).map((entry) => entry.trim())
    : null;
  if (
    !keys || keys.length !== (rawSubjectKeys as unknown[]).length ||
    keys.length !== REQUIRED_SUBJECT_COUNT[mode] ||
    new Set(keys).size !== keys.length
  ) {
    throw new Error("invalid_subject_keys");
  }
  const unknownKeys = keys.filter((key) => !catalog.subjects[key]);
  if (unknownKeys.length > 0) {
    const error = new Error("unknown_subject_keys") as Error & {
      subjectKeys?: string[];
    };
    error.subjectKeys = unknownKeys;
    throw error;
  }
  return {
    subjectKeys: keys,
    priceId: mode === "single"
      ? catalog.subjects[keys[0]]
      : mode === "bundle_2"
      ? catalog.bundle_2
      : catalog.bundle_3,
  };
}

type PromotionClient = {
  promotionCodes: {
    list(params: { code: string; active: true; limit: number }): PromiseLike<{
      data: Array<{ id: string }>;
    }>;
  };
};

/** The callers normalize empty input to null before reaching the lookup. */
export async function promotionDiscount(
  client: PromotionClient,
  code: string | null,
) {
  if (!code) return null;
  const normalized = code.trim().toUpperCase();
  if (!normalized) return null;
  const list = await client.promotionCodes.list({
    code: normalized,
    active: true,
    limit: 1,
  });
  const promotion = list.data[0];
  if (!promotion) throw new Error("promo_code_invalid");
  return promotion.id;
}
