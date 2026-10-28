import { assertEquals, assertRejects } from "https://deno.land/std@0.224.0/assert/mod.ts";
import { buildTrialQuote, readRedditClickId, startTrialSetup, type TrialDeps, TrialError } from "./trial-checkout.ts";

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
      is(col: string, val: unknown) { filters.push((r) => (r[col] ?? null) === val); return b; },
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
          const hit = matching();
          for (const r of hit) Object.assign(r, patch);
          return resolve({ data: hit.map((r) => ({ id: r.id })), error: null });
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

function fakeStripe(promos: Any[] = [], opts: { idempotent?: boolean } = {}) {
  const calls: Any[] = [];
  // Like Stripe API v1: a reused idempotency key replays the first response.
  const byKey = new Map<string, Any>();
  const expired = new Set<string>();
  return {
    calls,
    prices: { retrieve: () => Promise.resolve({ unit_amount: 3999, currency: "usd", product: "prod_bio", type: "one_time" }) },
    promotionCodes: { list: () => Promise.resolve({ data: promos }) },
    customers: { create: (p: Any, o: Any) => { calls.push(["customer", p, o]); return Promise.resolve({ id: "cus_new" }); } },
    checkout: {
      sessions: {
        create: (p: Any, o: Any) => {
          calls.push(["session", p, o]);
          if (opts.idempotent && byKey.has(o.idempotencyKey)) return Promise.resolve(byKey.get(o.idempotencyKey));
          const session = { id: `cs_${calls.length}`, client_secret: "secret", url: p.ui_mode === "hosted_page" ? "https://checkout.stripe.com/x" : null };
          byKey.set(o.idempotencyKey, session);
          return Promise.resolve(session);
        },
        expire: (id: string) => { calls.push(["expire", id]); expired.add(id); return Promise.resolve({}); },
        isExpired: (id: string) => expired.has(id),
        retrieve: (id: string) => Promise.resolve({ id, status: expired.has(id) ? "expired" : "open" }),
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
  assertEquals(session[1].wallet_options, { link: { display: "never" } });
  assertEquals(service.orders[0].student_email_norm, "kid@example.com");
  assertEquals(service.orders[0].ad_attribution, null);

  const second = await startTrialSetup(deps(service, stripe), start);
  assertEquals([second.order_id, service.orders.length], [first.order_id, 1]);
  assertEquals(stripe.calls.some((c: Any) => c[0] === "expire" && c[1] === first.session_id), true);
});

Deno.test("the order stores the sanitised ad attribution it was started with", async () => {
  const service = fakeService();
  const stripe = fakeStripe();
  const q = await buildTrialQuote(deps(service, stripe), base);
  const attribution = { ad_tracking_allowed: true, last_touch: { utm_source: "reddit", utm_content: "ad-07" } };
  await startTrialSetup(deps(service, stripe), {
    ...base,
    quoteVersion: q.quote_version,
    studentAck: { version: "terms-1", source: "checkout" },
    studentName: null,
    consentIp: "203.0.113.5",
    consentUserAgent: "test",
    adAttribution: attribution,
    urls: { returnUrl: "https://app/return" },
  });
  assertEquals(service.orders[0].ad_attribution, attribution);
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
  assertEquals(session.wallet_options, { link: { display: "never" } });
  assertEquals(session.custom_text.submit.message.includes("for Sam's AP Biology"), true);
  assertEquals([res.url !== null, service.orders[0].payer_is_learner], [true, false]);
  assertEquals(stripe.calls.some((c: Any) => c[0] === "customer"), false);
});

const startOf = (q: Any, over: Any = {}) => ({
  ...base,
  quoteVersion: q.quote_version,
  studentAck: { version: "terms-1", source: "checkout" },
  studentName: null,
  consentIp: null,
  consentUserAgent: null,
  urls: { returnUrl: "https://app/return" },
  ...over,
});

Deno.test("a retry with the same cart gets a live session, never the one it just expired", async () => {
  const service = fakeService();
  const stripe = fakeStripe([], { idempotent: true });
  const q = await buildTrialQuote(deps(service, stripe), base);
  const first = await startTrialSetup(deps(service, stripe), startOf(q));
  const second = await startTrialSetup(deps(service, stripe), startOf(q));
  assertEquals(stripe.checkout.sessions.isExpired(first.session_id), true);
  assertEquals(second.session_id !== first.session_id, true);
  assertEquals(stripe.checkout.sessions.isExpired(second.session_id), false);
  assertEquals(service.orders[0].checkout_session_id, second.session_id);
});

Deno.test("a start whose order was re-linked by a concurrent start stops instead of overwriting it", async () => {
  const service = fakeService();
  const stripe = fakeStripe();
  const q = await buildTrialQuote(deps(service, stripe), base);
  await startTrialSetup(deps(service, stripe), startOf(q));
  // Another start replaces the session between this start's read and write.
  const realExpire = stripe.checkout.sessions.expire;
  stripe.checkout.sessions.expire = (id: string) => {
    service.orders[0] = { ...service.orders[0], checkout_session_id: "cs_other" };
    return realExpire(id);
  };
  await assertRejects(() => startTrialSetup(deps(service, stripe), startOf(q)), TrialError, "trial_start_in_progress");
  assertEquals(service.orders[0].checkout_session_id, "cs_other");
});

Deno.test("resuming a purchase does not exhaust the promo code it reserved; another buyer is still refused", async () => {
  const lastSlot = { ...HALF, max_redemptions: 1, times_redeemed: 0 };
  const service = fakeService();
  const stripe = fakeStripe([lastSlot]);
  const withCode = { ...base, promoCode: "HALF" };
  const q = await buildTrialQuote(deps(service, stripe), withCode);
  await startTrialSetup(deps(service, stripe), startOf(q, { promoCode: "HALF" }));
  assertEquals(service.orders[0].promo_use_state, "reserved");

  const again = await buildTrialQuote(deps(service, stripe), withCode);
  assertEquals(again.charge_amount, 1999);
  await startTrialSetup(deps(service, stripe), startOf(again, { promoCode: "HALF" }));

  await assertRejects(
    () => buildTrialQuote(deps(service, stripe), { ...withCode, studentEmail: "other@example.com" }),
    TrialError,
    "promo_code_exhausted",
  );
});

Deno.test("a restart never replaces a session whose card is already saved (webhook not yet in)", async () => {
  const service = fakeService();
  const stripe = fakeStripe();
  const q = await buildTrialQuote(deps(service, stripe), base);
  const first = await startTrialSetup(deps(service, stripe), startOf(q));
  // The buyer completed setup; Stripe refuses to expire a complete session.
  stripe.checkout.sessions.expire = () => Promise.reject(new Error("Only open sessions can be expired"));
  stripe.checkout.sessions.retrieve = (id: string) => Promise.resolve({ id, status: "complete" });
  await assertRejects(() => startTrialSetup(deps(service, stripe), startOf(q)), TrialError, "trial_setup_completing");
  assertEquals(service.orders[0].checkout_session_id, first.session_id);
  assertEquals(stripe.calls.filter((c: Any) => c[0] === "session").length, 1);
});

Deno.test("a restart whose old session cannot be checked leaves the order alone", async () => {
  const service = fakeService();
  const stripe = fakeStripe();
  const q = await buildTrialQuote(deps(service, stripe), base);
  const first = await startTrialSetup(deps(service, stripe), startOf(q));
  stripe.checkout.sessions.expire = () => Promise.reject(new Error("timeout"));
  stripe.checkout.sessions.retrieve = () => Promise.reject(new Error("timeout"));
  await assertRejects(() => startTrialSetup(deps(service, stripe), startOf(q)), TrialError, "trial_start_unavailable");
  assertEquals(service.orders[0].checkout_session_id, first.session_id);
  // Already expired on Stripe (its event not yet here): the restart proceeds.
  stripe.checkout.sessions.retrieve = (id: string) => Promise.resolve({ id, status: "expired" });
  const second = await startTrialSetup(deps(service, stripe), startOf(q));
  assertEquals(service.orders[0].checkout_session_id, second.session_id);
});

Deno.test("setup sessions expire with the quote", async () => {
  const service = fakeService();
  const stripe = fakeStripe();
  const q = await buildTrialQuote(deps(service, stripe), base);
  await startTrialSetup(deps(service, stripe), startOf(q));
  const session = stripe.calls.find((c: Any) => c[0] === "session")[1];
  assertEquals(session.expires_at, Math.floor(new Date(service.orders[0].quote_expires_at).getTime() / 1000));
});

Deno.test("a Reddit click id is kept only when the visitor allowed ad tracking and it is well formed", () => {
  assertEquals(readRedditClickId({ reddit_click_id: "abc-123_X.y~z", ad_tracking_allowed: true }), "abc-123_X.y~z");
  assertEquals(readRedditClickId({ reddit_click_id: " abc ", ad_tracking_allowed: true }), "abc");
  assertEquals(readRedditClickId({ reddit_click_id: "abc", ad_tracking_allowed: false }), null);
  assertEquals(readRedditClickId({ reddit_click_id: "abc" }), null);
  assertEquals(readRedditClickId({ reddit_click_id: "a b", ad_tracking_allowed: true }), null);
  assertEquals(readRedditClickId({ reddit_click_id: "x".repeat(301), ad_tracking_allowed: true }), null);
  assertEquals(readRedditClickId({ reddit_click_id: "<script>", ad_tracking_allowed: true }), null);
  assertEquals(readRedditClickId(null), null);
  assertEquals(readRedditClickId("abc"), null);
});

Deno.test("trial start stores the Reddit click id on the order, and nothing when there is none", async () => {
  const service = fakeService();
  const stripe = fakeStripe();
  const q = await buildTrialQuote(deps(service, stripe), base);
  await startTrialSetup(deps(service, stripe), startOf(q, { redditClickId: "rdt-1" }));
  assertEquals(service.orders[0].reddit_click_id, "rdt-1");
  const other = fakeService();
  const q2 = await buildTrialQuote(deps(other, stripe), base);
  await startTrialSetup(deps(other, stripe), startOf(q2));
  assertEquals(other.orders[0].reddit_click_id, null);
});
