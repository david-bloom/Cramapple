import { assertEquals, assertRejects } from "https://deno.land/std@0.224.0/assert/mod.ts";
import { buildTrialQuote, startTrialSetup, type TrialDeps, TrialError } from "./trial-checkout.ts";

// deno-lint-ignore no-explicit-any
type Any = any;

// A small in-memory stand-in for the Supabase query builder calls the trial
// service makes.
function fakeService(opts: { consumed?: string[]; priorPaid?: boolean } = {}) {
  const orders: Any[] = [];
  const subjects = [
    { id: "sub-bio", subject_key: "biology" },
    { id: "sub-stats", subject_key: "statistics" },
  ];
  function query(table: string) {
    const filters: Array<(r: Any) => boolean> = [];
    let mode: "select" | "update" | "insert" = "select";
    let patch: Any = null;
    let inserted: Any = null;
    let head = false;
    const rows = () => (table === "trial_orders" ? orders : table === "subjects" ? subjects : []);
    const matching = () => rows().filter((r) => filters.every((f) => f(r)));
    const b: Any = {
      select(_cols?: string, o?: Any) { head = Boolean(o?.head); return b; },
      eq(col: string, val: unknown) { filters.push((r) => r[col] === val); return b; },
      in(col: string, vals: unknown[]) { filters.push((r) => vals.includes(r[col])); return b; },
      insert(row: Any) {
        mode = "insert";
        if (orders.some((o) => o.status === "pending_setup" && o.student_email_norm === row.student_email_norm)) {
          inserted = { error: { code: "23505" } };
        } else {
          inserted = { ...row, id: `order-${orders.length + 1}`, status: "pending_setup" };
          orders.push(inserted);
        }
        return b;
      },
      update(p: Any) { mode = "update"; patch = p; return b; },
      maybeSingle() { return Promise.resolve({ data: matching()[0] ?? null, error: null }); },
      single() {
        if (inserted?.error) return Promise.resolve({ data: null, error: inserted.error });
        return Promise.resolve({ data: inserted ?? matching()[0], error: null });
      },
      then(resolve: Any) {
        if (mode === "update") {
          for (const r of matching()) Object.assign(r, patch);
          return resolve({ error: null });
        }
        if (table === "stripe_checkout_sessions") {
          return resolve({ count: opts.priorPaid ? 1 : 0, error: null });
        }
        const m = matching();
        return resolve(head ? { count: m.length, error: null } : { data: m, error: null });
      },
    };
    return b;
  }
  return {
    orders,
    schema: () => ({
      from: query,
      rpc: (_fn: string, args: Any) =>
        Promise.resolve({ data: (opts.consumed ?? []).includes(args.p_email), error: null }),
    }),
  };
}

function fakeStripe(promos: Any[] = []) {
  const calls: Any[] = [];
  return {
    calls,
    prices: { retrieve: () => Promise.resolve({ unit_amount: 3999, currency: "usd", product: "prod_bio", type: "one_time" }) },
    promotionCodes: { list: () => Promise.resolve({ data: promos }) },
    customers: { create: (p: Any, o: Any) => { calls.push(["customer", p, o]); return Promise.resolve({ id: "cus_new" }); } },
    checkout: {
      sessions: {
        create: (p: Any, o: Any) => {
          calls.push(["session", p, o]);
          return Promise.resolve({ id: `cs_${calls.length}`, client_secret: "secret", url: p.ui_mode === "hosted_page" ? "https://checkout.stripe.com/x" : null });
        },
        expire: (id: string) => { calls.push(["expire", id]); return Promise.resolve({}); },
      },
    },
  };
}

const HALF = {
  id: "promo_half", code: "HALF", active: true, customer: null, expires_at: null,
  max_redemptions: null, times_redeemed: 0, restrictions: {},
  promotion: { type: "coupon", coupon: { id: "co_half", valid: true, percent_off: 50 } },
};

function deps(service: Any, stripe: Any, admissionEnabled = true): TrialDeps {
  return { service, stripe, now: () => new Date("2026-10-18T16:00:00Z"), admissionEnabled, termsVersion: "terms-1" };
}

const base = {
  purchaseType: "student_direct" as const,
  offer: "single" as const,
  subjectKeys: ["biology"],
  priceId: "price_bio",
  promoCode: null,
  studentEmail: "Kid@Example.com",
  customerId: null,
};

Deno.test("the server decides the billing mode", async () => {
  const q = await buildTrialQuote(deps(fakeService(), fakeStripe()), base);
  assertEquals([q.billing_mode, q.charge_amount, q.charge_date_floor_eastern], ["trial", 3999, "Sunday, October 25, 2026"]);
  assertEquals((await buildTrialQuote(deps(fakeService(), fakeStripe(), false), base)).pay_now_reason, "admission_off");
  assertEquals(
    (await buildTrialQuote(deps(fakeService({ consumed: ["kid@example.com"] }), fakeStripe()), base)).pay_now_reason,
    "trial_used",
  );
});

Deno.test("promo codes are evaluated and locked into the quote", async () => {
  const q = await buildTrialQuote(deps(fakeService(), fakeStripe([HALF])), { ...base, promoCode: "half" });
  assertEquals([q.discount_amount, q.charge_amount, q.promo_code], [2000, 1999, "HALF"]);
  const free = { ...HALF, promotion: { type: "coupon", coupon: { id: "co_free", valid: true, percent_off: 100 } } };
  assertEquals((await buildTrialQuote(deps(fakeService(), fakeStripe([free])), { ...base, promoCode: "FREE" })).billing_mode, "pay_now_zero");
  await assertRejects(() => buildTrialQuote(deps(fakeService(), fakeStripe([])), { ...base, promoCode: "NOPE" }), TrialError, "promo_code_invalid");
  const firstOnly = { ...HALF, restrictions: { first_time_transaction: true } };
  await assertRejects(
    () => buildTrialQuote(deps(fakeService({ priorPaid: true }), fakeStripe([firstOnly])), { ...base, promoCode: "HALF" }),
    TrialError,
    "promo_code_first_time_only",
  );
});

Deno.test("starting needs the quoted version and the current Terms version", async () => {
  const service = fakeService();
  const stripe = fakeStripe();
  const q = await buildTrialQuote(deps(service, stripe), base);
  const start = {
    ...base,
    quoteVersion: "q_stale",
    studentAck: { version: "terms-1", source: "checkout" },
    studentName: null,
    consentIp: null,
    consentUserAgent: null,
    urls: { returnUrl: "https://app/return" },
  };
  await assertRejects(() => startTrialSetup(deps(service, stripe), start), TrialError, "quote_changed");
  await assertRejects(
    () => startTrialSetup(deps(service, stripe), { ...start, quoteVersion: q.quote_version, studentAck: { version: "terms-0", source: "checkout" } }),
    TrialError,
    "terms_version_mismatch",
  );
  assertEquals(service.orders.length, 0);
});

Deno.test("direct start: one pending order per email, refreshed in place", async () => {
  const service = fakeService();
  const stripe = fakeStripe();
  const q = await buildTrialQuote(deps(service, stripe), base);
  const start = {
    ...base,
    quoteVersion: q.quote_version,
    studentAck: { version: "terms-1", source: "checkout" },
    studentName: null,
    consentIp: "203.0.113.5",
    consentUserAgent: "test",
    urls: { returnUrl: "https://app/return" },
  };
  const first = await startTrialSetup(deps(service, stripe), start);
  assertEquals([first.client_secret, service.orders.length, service.orders[0].subject_ids[0]], ["secret", 1, "sub-bio"]);
  const session = stripe.calls.find((c: Any) => c[0] === "session");
  assertEquals([session[1].mode, session[1].ui_mode, session[1].customer, session[1].metadata.kind], ["setup", "elements", "cus_new", "trial_setup"]);
  assertEquals(service.orders[0].student_email_norm, "kid@example.com");

  const second = await startTrialSetup(deps(service, stripe), start);
  assertEquals([second.order_id, service.orders.length], [first.order_id, 1]);
  assertEquals(stripe.calls.some((c: Any) => c[0] === "expire" && c[1] === first.session_id), true);
});

Deno.test("parent start uses Stripe's hosted page with required Terms consent", async () => {
  const service = fakeService();
  const stripe = fakeStripe();
  const parent = { ...base, purchaseType: "parent_share" as const };
  const q = await buildTrialQuote(deps(service, stripe), parent);
  const res = await startTrialSetup(deps(service, stripe), {
    ...parent,
    quoteVersion: q.quote_version,
    studentAck: { version: "terms-1", source: "parent_share_drawer" },
    studentName: "Sam Lee",
    consentIp: null,
    consentUserAgent: null,
    urls: { successUrl: "https://app/ok", cancelUrl: "https://app/cancel" },
  });
  const session = stripe.calls.find((c: Any) => c[0] === "session")[1];
  assertEquals([session.ui_mode, session.consent_collection.terms_of_service, session.customer_creation], ["hosted_page", "required", "always"]);
  assertEquals(session.custom_text.submit.message.includes("for Sam's biology"), true);
  assertEquals([res.url !== null, service.orders[0].payer_is_learner], [true, false]);
  assertEquals(stripe.calls.some((c: Any) => c[0] === "customer"), false);
});
