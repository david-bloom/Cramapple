import Stripe from "https://esm.sh/stripe@17?target=deno";

function requireEnv(name: string) {
  const value = Deno.env.get(name);
  if (!value) {
    throw new Error(`Missing required environment variable: ${name}`);
  }
  return value;
}

// STRIPE_SECRET_KEY is required by both the Checkout-session-creation and
// webhook-receiver functions, so it fails fast at module load like the
// Supabase client helpers. STRIPE_WEBHOOK_SECRET is only needed by the
// webhook receiver, so it is required lazily inside
// verifyStripeWebhookEvent instead of forcing every importer to define it.
const STRIPE_SECRET_KEY = requireEnv("STRIPE_SECRET_KEY");

export const stripe = new Stripe(STRIPE_SECRET_KEY, {
  httpClient: Stripe.createFetchHttpClient(),
});

// Deno has no synchronous Node crypto, so signature verification must use
// the async variant (constructEventAsync uses SubtleCrypto under the hood).
export async function verifyStripeWebhookEvent(
  rawBody: string,
  signatureHeader: string | null,
) {
  if (!signatureHeader) {
    throw new Error("missing_stripe_signature_header");
  }
  const webhookSecret = requireEnv("STRIPE_WEBHOOK_SECRET");
  return await stripe.webhooks.constructEventAsync(
    rawBody,
    signatureHeader,
    webhookSecret,
  );
}
