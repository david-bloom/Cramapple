// The learner account behind a card trial (TASK-0077, live sandbox QA
// 2026-10-19). Activation must not depend on an email being sent: inviting
// a new student made activation fail on an invalid address or Supabase's
// email rate limit, leaving a saved card with no trial. A new student is
// created unconfirmed and sent nothing here; they sign in with the app's
// email-code sign-in (every account state's template carries a code), and
// the trial-started notice, retried by its own worker, tells them so.

// deno-lint-ignore no-explicit-any
type Any = any;

export type LearnerAuth = {
  findByEmail: (email: string) => Promise<{ id: string } | null>;
  createUser: (attrs: {
    email: string;
    email_confirm: boolean;
    user_metadata: Record<string, string>;
  }) => Promise<{ data: { user: { id: string } | null } | null; error: Any }>;
};

export type LearnerResult = { userId: string } | { refused: "student_email_invalid" };

const EXISTS_CODES = new Set(["email_exists", "user_already_exists"]);
const INVALID_CODES = new Set(["email_address_invalid", "validation_failed"]);

export async function resolveTrialLearner(
  auth: LearnerAuth,
  email: string,
  name: string | null,
): Promise<LearnerResult> {
  const existing = await auth.findByEmail(email);
  if (existing) return { userId: existing.id };

  const { data, error } = await auth.createUser({
    email,
    // Unconfirmed: the student proves the address by signing in with a code.
    email_confirm: false,
    user_metadata: { full_name: name ?? email.split("@")[0] },
  });
  if (!error && data?.user) return { userId: data.user.id };

  const code = typeof error?.code === "string" ? error.code : "";
  if (EXISTS_CODES.has(code) || (error?.status === 422 && /already/i.test(String(error?.message)))) {
    // Another delivery created the account first: use it, never a second one.
    const raced = await auth.findByEmail(email);
    if (raced) return { userId: raced.id };
    throw new Error("trial_learner_not_found_after_conflict");
  }
  if (INVALID_CODES.has(code)) return { refused: "student_email_invalid" };
  // Auth outage or anything unknown: fail so Stripe retries the event.
  throw new Error(`trial_learner_create_failed:${code || error?.status || "no_user"}`);
}
