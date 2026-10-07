import {
  assertEquals,
  assertThrows,
} from "https://deno.land/std@0.224.0/assert/mod.ts";
import {
  configuredReminderLeadSeconds,
  deliverParentLifecycleEmails,
  parentReminderPaymentUrl,
  type ParentSession,
  reminderDueAt,
  validateRecoveryUrls,
  verifiedStudentOwner,
} from "./parent-email-lifecycle.ts";

const now = Date.parse("2026-10-06T12:00:00Z");
const session: ParentSession = {
  id: "cs_test",
  status: "open",
  payment_status: "unpaid",
  expires_at: (now + 3600000) / 1000,
  amount_total: 3999,
  currency: "usd",
  metadata: {
    purchase_type: "parent_share",
    student_email: "student@example.com",
    subject_ids: "biology",
  },
};

async function config(
  values: Record<string, string>,
  run: () => Promise<void> | void,
) {
  const old = Object.fromEntries(
    Object.keys(values).map((key) => [key, Deno.env.get(key)]),
  );
  for (const [key, value] of Object.entries(values)) Deno.env.set(key, value);
  try {
    await run();
  } finally {
    for (const [key, value] of Object.entries(old)) {
      if (value === undefined) Deno.env.delete(key);
      else Deno.env.set(key, value);
    }
  }
}

Deno.test("parent lifecycle disabled mode has no database or Stripe side effects", async () => {
  await config({ PARENT_EMAIL_LIFECYCLE_ENABLED: "false" }, async () => {
    const result = await deliverParentLifecycleEmails({} as never, {
      retrieveSession: () => {
        throw new Error("must not retrieve");
      },
    });
    assertEquals(result, { disabled: true, claimed: 0, sent: 0 });
  });
});

Deno.test("Development reminders use the session URL without crossing short-link databases", async () => {
  await config({ PARENT_EMAIL_USE_SHORT_LINKS: "false" }, () => {
    assertEquals(
      parentReminderPaymentUrl({
        ...session,
        url: "https://checkout.stripe.com/c/pay/cs_test_example",
      }, "abcdefgh"),
      "https://checkout.stripe.com/c/pay/cs_test_example",
    );
    assertThrows(() => parentReminderPaymentUrl(session, "abcdefgh"));
  });
  await config({
    PARENT_EMAIL_USE_SHORT_LINKS: "true",
    APP_BASE_URL: "https://dev.example.com",
  }, () => {
    assertEquals(
      parentReminderPaymentUrl(session, "abcdefgh"),
      "https://dev.example.com/p/abcdefgh",
    );
  });
});

Deno.test("reminder policy rejects malformed timing and cannot schedule after expiry", async () => {
  await config({ PARENT_REMINDER_LEAD_SECONDS: "600" }, () => {
    assertEquals(configuredReminderLeadSeconds(), 600);
    assertEquals(
      reminderDueAt(session.expires_at, now, 600),
      "2026-10-06T12:50:00.000Z",
    );
    assertEquals(reminderDueAt(session.expires_at, now, 7200), null);
    assertEquals(reminderDueAt(session.expires_at, now, null), null);
  });
  await config({ PARENT_REMINDER_LEAD_SECONDS: "-5" }, () => {
    assertThrows(configuredReminderLeadSeconds);
  });
});

Deno.test("expired recovery links preserve subjects and cannot leave checkout origin", async () => {
  await config({ APP_BASE_URL: "https://dev.example.com" }, () => {
    const valid = {
      newRequestUrl:
        "https://dev.example.com/checkout?subject=biology&ask=parent",
      payYourselfUrl: "https://dev.example.com/checkout?subject=biology",
    };
    assertEquals(validateRecoveryUrls(valid, session), valid);
    for (
      const newRequestUrl of [
        "https://evil.example/checkout?subject=biology",
        "https://dev.example.com/checkout?subject=chemistry",
        "https://dev.example.com/checkout?subject=biology&email=someone",
      ]
    ) {
      assertThrows(() =>
        validateRecoveryUrls({ ...valid, newRequestUrl }, session)
      );
    }
  });
});

Deno.test("expiry identity requires verified matching Auth student", async () => {
  for (
    const user of [
      {
        id: "student",
        email: "wrong@example.com",
        email_confirmed_at: "today",
      },
      { id: "student", email: "student@example.com", email_confirmed_at: null },
      {
        id: "student",
        email: "student@example.com",
        email_confirmed_at: "today",
        is_anonymous: true,
      },
    ]
  ) {
    const service = {
      auth: { getUser: () => Promise.resolve({ data: { user }, error: null }) },
    };
    assertEquals(
      await verifiedStudentOwner(service as never, "token", session),
      null,
    );
  }
});

Deno.test("worker cancels paid sessions before any provider delivery", async () => {
  await config({ PARENT_EMAIL_LIFECYCLE_ENABLED: "true" }, async () => {
    let updates: Record<string, unknown>[] = [];
    const chain = {
      select() {
        return this;
      },
      eq() {
        return this;
      },
      update(value: Record<string, unknown>) {
        updates.push(value);
        return this;
      },
      single() {
        return Promise.resolve({
          data: {
            checkout_session_id: session.id,
            stripe_expires_at: new Date(session.expires_at * 1000)
              .toISOString(),
          },
          error: null,
        });
      },
      maybeSingle() {
        return Promise.resolve({ data: { id: "job" }, error: null });
      },
    };
    const service = {
      schema: () => ({
        from: () => chain,
        rpc: () =>
          Promise.resolve({
            data: [{
              id: "job",
              context_id: "context",
              kind: "reminder",
              attempt_count: 1,
              lease_id: "lease",
              created_at: new Date(now).toISOString(),
            }],
            error: null,
          }),
      }),
    };
    const result = await deliverParentLifecycleEmails(service as never, {
      now: () => now,
      retrieveSession: () =>
        Promise.resolve({
          ...session,
          status: "complete",
          payment_status: "paid",
        }),
      send: () => {
        throw new Error("paid sessions must not send");
      },
    });
    assertEquals(result.sent, 0);
    assertEquals(updates[0].cancelled_at, new Date(now).toISOString());
    assertEquals(updates[0].lease_id, null);
  });
});
