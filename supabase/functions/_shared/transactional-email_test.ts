import {
  assertEquals,
  assertRejects,
  assertThrows,
} from "https://deno.land/std@0.224.0/assert/mod.ts";
import { Webhook } from "https://esm.sh/standardwebhooks@1.0.0";
import { buildAuthEmail, handleAuthEmail } from "./auth-email.ts";
import {
  buildPaymentEmail,
  deliverPaymentEmails,
  enqueuePaymentEmail,
} from "./payment-email.ts";
import { sendLoopsTransactional } from "./loops-transactional.ts";
import type { SupabaseClient } from "https://esm.sh/@supabase/supabase-js@2.49.1";

const secret = btoa("a-test-webhook-signing-secret-32bytes");
const env = {
  LOOPS_SECRET_KEY: "test-key",
  SEND_EMAIL_HOOK_SECRET: `v1,whsec_${secret}`,
  AUTH_EMAIL_WELCOME_URL: "https://dev.example.com/welcome",
  LOOPS_SIGNUP_TRANSACTIONAL_ID: "signup-id",
  LOOPS_INVITE_TRANSACTIONAL_ID: "invite-id",
  LOOPS_MAGICLINK_TRANSACTIONAL_ID: "login-id",
  TRANSACTIONAL_MAILING_ADDRESS: "Test business address",
};

async function withEmailTest(run: () => Promise<void>) {
  const old = Object.fromEntries(
    Object.keys(env).map((key) => [key, Deno.env.get(key)]),
  );
  const originalFetch = globalThis.fetch;
  for (const [key, value] of Object.entries(env)) Deno.env.set(key, value);
  try {
    await run();
  } finally {
    globalThis.fetch = originalFetch;
    for (const [key, value] of Object.entries(old)) {
      if (value === undefined) Deno.env.delete(key);
      else Deno.env.set(key, value);
    }
  }
}

function signedRequest(action = "invite", tamper = false) {
  const body = JSON.stringify({
    user: { email: "student@example.com" },
    email_data: { email_action_type: action, token: "123456" },
  });
  const id = "hook-test-id";
  const date = new Date();
  return new Request("https://example.com/hook", {
    method: "POST",
    body: tamper ? body.replace("123456", "654321") : body,
    headers: {
      "webhook-id": id,
      "webhook-timestamp": String(Math.floor(date.getTime() / 1000)),
      "webhook-signature": new Webhook(secret).sign(id, date, body),
    },
  });
}

Deno.test("auth routes all three actions to configured templates with plain welcome URL", () =>
  withEmailTest(async () => {
    for (
      const [action, id] of [["signup", "signup-id"], ["invite", "invite-id"], [
        "magiclink",
        "login-id",
      ]]
    ) {
      assertEquals(
        buildAuthEmail({
          user: { email: "s@example.com" },
          email_data: { email_action_type: action, token: "123456" },
        }),
        {
          transactionalId: id,
          email: "s@example.com",
          dataVariables: {
            token: "123456",
            welcomeUrl: env.AUTH_EMAIL_WELCOME_URL,
            emailAddress: "s@example.com",
            expiryText: "Use this code soon. Request a new code if it expires.",
            mailingAddress: env.TRANSACTIONAL_MAILING_ADDRESS,
            ...(action === "invite" ? { firstName: "there" } : {}),
          },
        },
      );
    }
    assertThrows(() =>
      buildAuthEmail({ email_data: { email_action_type: "recovery" } })
    );
    assertThrows(() =>
      buildAuthEmail({
        user: { email: "s@example.com" },
        email_data: { email_action_type: "invite", token: "abc" },
      })
    );
  }));

Deno.test("valid hook sends through Loops; invalid signature and tampered body never send", () =>
  withEmailTest(async () => {
    let sends = 0;
    globalThis.fetch = ((_url: unknown, init: RequestInit) => {
      sends++;
      const body = JSON.parse(init.body as string);
      assertEquals(body.addToAudience, false);
      assertEquals(body.dataVariables.token, "123456");
      assertEquals(
        new Headers(init.headers).get("Idempotency-Key"),
        "auth:hook-test-id",
      );
      return Promise.resolve(Response.json({ success: true }));
    }) as typeof fetch;
    assertEquals((await handleAuthEmail(signedRequest())).status, 200);
    assertEquals(
      (await handleAuthEmail(signedRequest("invite", true))).status,
      401,
    );
    assertEquals(
      (await handleAuthEmail(
        new Request("https://example.com", { method: "POST", body: "{}" }),
      )).status,
      401,
    );
    assertEquals(sends, 1);
  }));

Deno.test("hook does not silently acknowledge unsupported actions, missing config or provider failure", () =>
  withEmailTest(async () => {
    globalThis.fetch = (() =>
      Promise.resolve(Response.json({ success: false }))) as typeof fetch;
    assertEquals((await handleAuthEmail(signedRequest())).status, 503);
    assertEquals(
      (await handleAuthEmail(signedRequest("email_change"))).status,
      503,
    );
    Deno.env.delete("LOOPS_INVITE_TRANSACTIONAL_ID");
    assertEquals((await handleAuthEmail(signedRequest())).status, 503);
    Deno.env.delete("SEND_EMAIL_HOOK_SECRET");
    assertEquals((await handleAuthEmail(signedRequest())).status, 503);
  }));

Deno.test("transactional client rejects HTTP errors, missing credentials and network failures", () =>
  withEmailTest(async () => {
    const input = {
      email: "s@example.com",
      transactionalId: "id",
      dataVariables: {},
    };
    globalThis.fetch = (() =>
      Promise.resolve(
        new Response("sensitive body", { status: 429 }),
      )) as typeof fetch;
    await assertRejects(
      () => sendLoopsTransactional(input, "id"),
      Error,
      "loops_transactional_http_429",
    );
    globalThis.fetch = (() =>
      Promise.reject(new Error("network unavailable"))) as typeof fetch;
    await assertRejects(() => sendLoopsTransactional(input, "id"));
    Deno.env.delete("LOOPS_SECRET_KEY");
    await assertRejects(
      () => sendLoopsTransactional(input, "id"),
      Error,
      "missing_email_config",
    );
  }));

Deno.test("parent payment confirmation is addressed to student and dedupes by checkout session", () =>
  withEmailTest(async () => {
    const input = {
      sessionId: "cs_test",
      email: "student@example.com",
      purchaseType: "parent_share",
      subjects: "biology",
      amountTotal: 100,
      currency: "usd",
      studyUrl: "https://example.com/home",
    };
    const parent = buildPaymentEmail(input);
    assertEquals(parent.template_env, "LOOPS_PARENT_PAID_TRANSACTIONAL_ID");
    assertEquals(parent.recipient_email, "student@example.com");
    assertEquals(parent.dedupe_key, "payment:cs_test");
    assertEquals(
      buildPaymentEmail({ ...input, purchaseType: "student_direct" })
        .template_env,
      "LOOPS_PURCHASE_TRANSACTIONAL_ID",
    );
  }));

Deno.test("disabled payment queue makes no database or Auth calls", async () => {
  const old = Deno.env.get("LOOPS_PAYMENT_EMAILS_ENABLED");
  Deno.env.delete("LOOPS_PAYMENT_EMAILS_ENABLED");
  try {
    await enqueuePaymentEmail({} as SupabaseClient, "user", {
      sessionId: "cs",
      purchaseType: "student_direct",
      subjects: "biology",
      amountTotal: 100,
      currency: "usd",
    });
  } finally {
    if (old !== undefined) Deno.env.set("LOOPS_PAYMENT_EMAILS_ENABLED", old);
  }
});

Deno.test("queue retains failed sends, leases updates and quarantines old ambiguous deliveries", () =>
  withEmailTest(async () => {
    const updates: Record<string, unknown>[] = [];
    let sends = 0;
    const rows = [
      {
        id: "row1",
        lease_id: "lease1",
        attempt_count: 1,
        created_at: new Date().toISOString(),
        template_env: "LOOPS_INVITE_TRANSACTIONAL_ID",
        recipient_email: "s@example.com",
        data_variables: {},
      },
      {
        id: "row2",
        lease_id: "lease2",
        attempt_count: 2,
        created_at: "2020-01-01T00:00:00Z",
        template_env: "LOOPS_INVITE_TRANSACTIONAL_ID",
        recipient_email: "s@example.com",
        data_variables: {},
      },
    ];
    const service = {
      schema: () => ({
        rpc: () => Promise.resolve({ data: rows, error: null }),
        from: () => ({
          update: (input: Record<string, unknown>) => {
            updates.push(input);
            return {
              eq: () => ({ eq: () => Promise.resolve({ error: null }) }),
            };
          },
        }),
      }),
    } as unknown as SupabaseClient;
    globalThis.fetch = (() => {
      sends++;
      return Promise.resolve(new Response("", { status: 500 }));
    }) as typeof fetch;
    assertEquals(await deliverPaymentEmails(service), { claimed: 2, sent: 0 });
    assertEquals(sends, 1);
    assertEquals(updates[0].delivered_at, undefined);
    assertEquals(updates[0].leased_until, null);
    assertEquals(updates[1].needs_review, true);
  }));
