import { assertEquals, assertRejects } from "https://deno.land/std@0.224.0/assert/mod.ts";
import { type LearnerAuth, resolveTrialLearner } from "./trial-learner.ts";

// deno-lint-ignore no-explicit-any
type Any = any;

function auth(opts: { existing?: string[]; createError?: Any; raceUser?: string } = {}) {
  const created: Any[] = [];
  const users = new Map((opts.existing ?? []).map((e, i) => [e, `user-${i}`]));
  const a: LearnerAuth = {
    findByEmail: (email) => {
      if (opts.raceUser && created.length > 0) return Promise.resolve({ id: opts.raceUser });
      const id = users.get(email);
      return Promise.resolve(id ? { id } : null);
    },
    createUser: (attrs) => {
      created.push(attrs);
      if (opts.createError) return Promise.resolve({ data: { user: null }, error: opts.createError });
      return Promise.resolve({ data: { user: { id: "user-new" } }, error: null });
    },
  };
  return { a, created };
}

Deno.test("an existing learner is reused and nothing is created", async () => {
  const h = auth({ existing: ["kid@example.com"] });
  assertEquals(await resolveTrialLearner(h.a, "kid@example.com", "Sam"), { userId: "user-0" });
  assertEquals(h.created.length, 0);
});

Deno.test("a new learner is created unconfirmed, with no invite (no email sent)", async () => {
  const h = auth();
  assertEquals(await resolveTrialLearner(h.a, "kid@example.com", "Sam Lee"), { userId: "user-new" });
  assertEquals(h.created, [{ email: "kid@example.com", email_confirm: false, user_metadata: { full_name: "Sam Lee" } }]);
});

Deno.test("a duplicate-email race uses the account the other delivery created", async () => {
  const h = auth({ createError: { code: "email_exists", status: 422 }, raceUser: "user-raced" });
  assertEquals(await resolveTrialLearner(h.a, "kid@example.com", null), { userId: "user-raced" });
});

Deno.test("an address auth rejects is a handled refusal, not a retry loop", async () => {
  for (const code of ["email_address_invalid", "validation_failed"]) {
    const h = auth({ createError: { code, status: 400, message: "invalid" } });
    assertEquals(await resolveTrialLearner(h.a, "bad@", null), { refused: "student_email_invalid" });
  }
});

Deno.test("an auth outage still fails, so Stripe retries the event", async () => {
  const h = auth({ createError: { status: 500, message: "upstream" } });
  await assertRejects(() => resolveTrialLearner(h.a, "kid@example.com", null), Error, "trial_learner_create_failed");
  // The email rate limit no longer applies: nothing here sends mail.
  const limited = auth({ createError: { code: "over_email_send_rate_limit", status: 429 } });
  await assertRejects(() => resolveTrialLearner(limited.a, "kid@example.com", null), Error, "trial_learner_create_failed");
});
