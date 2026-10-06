import type { SupabaseClient } from "https://esm.sh/@supabase/supabase-js@2.49.1";
import {
  emailFirstName,
  emailFooter,
  emailSubjects,
  emailUrl,
  parentRequestVariables,
} from "./email-template-data.ts";
import { requireEmailConfig, sendLoopsTransactional } from "./loops-transactional.ts";
import { normalizeShortCode, shortLinkUrl } from "./parent-short-link.ts";

export type ParentSession = {
  id: string;
  status: string | null;
  payment_status: string | null;
  expires_at: number;
  amount_total: number | null;
  currency: string | null;
  metadata: Record<string, string> | null;
};

type RecoveryUrls = { newRequestUrl: string; payYourselfUrl: string };
type ParentContext = {
  id: string;
  checkout_session_id: string;
  parent_email: string;
  short_code: string;
  stripe_expires_at: string;
  student_user_id: string | null;
  student_email: string | null;
  new_request_url: string | null;
  pay_yourself_url: string | null;
};
type LifecycleJob = {
  id: string;
  context_id: string;
  kind: "reminder" | "expired";
  reminder_lead_seconds: number | null;
  lease_id: string;
  attempt_count: number;
  created_at: string;
};

function email(value: unknown): string | null {
  const normalized = typeof value === "string" ? value.trim().toLowerCase() : "";
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(normalized)
    ? normalized
    : null;
}

function checkoutOrigin(): URL {
  const url = new URL(requireEmailConfig("APP_BASE_URL"));
  if (
    url.protocol !== "https:" || url.username || url.password ||
    url.pathname !== "/" || url.search || url.hash
  ) throw new Error("invalid_checkout_origin");
  return url;
}

function subjectKeys(session: ParentSession): string[] {
  const keys = session.metadata?.subject_ids?.split(",").map((key) => key.trim()) ?? [];
  if (
    keys.length < 1 || keys.length > 3 || new Set(keys).size !== keys.length ||
    keys.some((key) => !/^[a-z0-9-]+$/.test(key))
  ) throw new Error("invalid_parent_subject_context");
  return keys;
}

function requireParentSession(session: ParentSession, now: number): void {
  const metadata = session.metadata ?? {};
  if (
    !session.id || (metadata.purchase_type ?? metadata.purchaser_type) !== "parent_share" ||
    !email(metadata.student_email) || !subjectKeys(session).length ||
    !Number.isSafeInteger(session.expires_at) || session.expires_at * 1000 <= now ||
    !Number.isSafeInteger(session.amount_total) || session.amount_total! < 0 ||
    session.currency?.toLowerCase() !== "usd" || session.status !== "open" ||
    session.payment_status !== "unpaid"
  ) throw new Error("invalid_open_parent_session");
}

export function configuredReminderLeadSeconds(): number | null {
  const raw = Deno.env.get("PARENT_REMINDER_LEAD_SECONDS");
  if (!raw) return null;
  if (!/^[1-9]\d*$/.test(raw)) throw new Error("invalid_reminder_lead_seconds");
  const seconds = Number(raw);
  if (!Number.isSafeInteger(seconds)) throw new Error("invalid_reminder_lead_seconds");
  return seconds;
}

export function reminderDueAt(expiresAt: number, sentAt: number, lead: number | null): string | null {
  if (lead === null) return null;
  if (!Number.isSafeInteger(lead) || lead <= 0) throw new Error("invalid_reminder_lead_seconds");
  const due = expiresAt * 1000 - lead * 1000;
  return due > sentAt ? new Date(due).toISOString() : null;
}

export function validateRecoveryUrls(
  urls: RecoveryUrls,
  session: ParentSession,
): RecoveryUrls {
  const origin = checkoutOrigin();
  const keys = subjectKeys(session);
  for (const value of [urls.newRequestUrl, urls.payYourselfUrl]) {
    const url = new URL(value);
    const selected = keys.length === 1
      ? url.searchParams.get("subject")
      : url.searchParams.get("subjects");
    const actual = selected?.split(",") ?? [];
    if (
      url.origin !== origin.origin || url.pathname !== "/checkout" ||
      url.username || url.password || url.hash ||
      url.searchParams.has(keys.length === 1 ? "subjects" : "subject") ||
      actual.length !== keys.length ||
      actual.some((key, index) => key !== keys[index]) ||
      [...url.searchParams.keys()].some((key) =>
        !["subject", "subjects", "ask"].includes(key)
      ) ||
      (url.searchParams.has("ask") && url.searchParams.get("ask") !== "parent")
    ) throw new Error("invalid_parent_recovery_url");
  }
  return urls;
}

export async function verifiedStudentOwner(
  service: SupabaseClient,
  bearerToken: string | null | undefined,
  session: ParentSession,
): Promise<{ userId: string; studentEmail: string } | null> {
  if (!bearerToken) return null;
  const { data, error } = await service.auth.getUser(bearerToken);
  const user = data?.user;
  const expected = email(session.metadata?.student_email);
  if (
    error || !user?.id || !user.email_confirmed_at ||
    (user as { is_anonymous?: boolean }).is_anonymous ||
    !expected || email(user.email) !== expected
  ) return null;
  return { userId: user.id, studentEmail: expected };
}

async function emailHash(value: string): Promise<string> {
  const bytes = await crypto.subtle.digest("SHA-256", new TextEncoder().encode(value));
  return [...new Uint8Array(bytes)].map((byte) => byte.toString(16).padStart(2, "0")).join("");
}

/** Call only after the direct parent request was successfully sent. */
export async function recordParentRequestLifecycle(
  service: SupabaseClient,
  input: {
    session: ParentSession;
    sentParentEmail: string;
    studentBearerToken?: string | null;
    recoveryUrls?: RecoveryUrls;
    now?: number;
  },
) {
  const now = input.now ?? Date.now();
  requireParentSession(input.session, now);
  const parentEmail = email(input.sentParentEmail);
  if (!parentEmail) throw new Error("invalid_parent_recipient");
  const lead = configuredReminderLeadSeconds();
  const { data: link, error: linkError } = await service.schema("app")
    .from("parent_payment_links").select("code")
    .eq("checkout_session_id", input.session.id).maybeSingle();
  const code = normalizeShortCode(link?.code);
  if (linkError || !code) throw new Error("parent_short_link_missing");

  const owner = await verifiedStudentOwner(
    service,
    input.studentBearerToken,
    input.session,
  );
  const recovery = owner && input.recoveryUrls
    ? validateRecoveryUrls(input.recoveryUrls, input.session)
    : null;
  const hash = await emailHash(parentEmail);
  const expiresAt = new Date(input.session.expires_at * 1000).toISOString();
  const { error: insertError } = await service.schema("app")
    .from("parent_email_lifecycle_context")
    .upsert({
      checkout_session_id: input.session.id,
      parent_email: parentEmail,
      parent_email_hash: hash,
      short_code: code,
      stripe_expires_at: expiresAt,
      ...(recovery
        ? {
          student_user_id: owner!.userId,
          student_email: owner!.studentEmail,
          new_request_url: recovery.newRequestUrl,
          pay_yourself_url: recovery.payYourselfUrl,
        }
        : {}),
    }, { onConflict: "checkout_session_id,parent_email_hash", ignoreDuplicates: true });
  if (insertError) throw new Error("parent_lifecycle_context_insert_failed");
  let { data: context, error: readError } = await service.schema("app")
    .from("parent_email_lifecycle_context")
    .select("id, parent_email, short_code, student_user_id, student_email, new_request_url, pay_yourself_url")
    .eq("checkout_session_id", input.session.id)
    .eq("parent_email_hash", hash).single();
  if (readError || !context || context.parent_email !== parentEmail || context.short_code !== code) {
    throw new Error("parent_lifecycle_context_read_failed");
  }
  if (recovery && !context.student_user_id) {
    const { error: updateError } = await service.schema("app")
      .from("parent_email_lifecycle_context")
      .update({
        student_user_id: owner!.userId,
        student_email: owner!.studentEmail,
        new_request_url: recovery.newRequestUrl,
        pay_yourself_url: recovery.payYourselfUrl,
      }).eq("id", context.id).is("student_user_id", null);
    if (updateError) throw new Error("parent_lifecycle_owner_update_failed");
    const refreshed = await service.schema("app")
      .from("parent_email_lifecycle_context")
      .select("id, parent_email, short_code, student_user_id, student_email, new_request_url, pay_yourself_url")
      .eq("id", context.id).single();
    if (refreshed.error || !refreshed.data) throw new Error("parent_lifecycle_owner_read_failed");
    context = refreshed.data;
  }
  const due = reminderDueAt(input.session.expires_at, now, lead);
  if (due) {
    await insertJob(service, {
      dedupe_key: `parent-reminder:${input.session.id}:${hash}`,
      context_id: context.id,
      kind: "reminder",
      reminder_lead_seconds: lead,
      due_at: due,
      next_attempt_at: due,
    });
  }
  const expiryEligible = !!recovery &&
    context.student_user_id === owner?.userId &&
    context.student_email === owner?.studentEmail &&
    !!context.new_request_url && !!context.pay_yourself_url;
  if (expiryEligible) {
    await insertJob(service, {
      dedupe_key: `parent-expired:${input.session.id}`,
      context_id: context.id,
      kind: "expired",
      reminder_lead_seconds: null,
      due_at: expiresAt,
      next_attempt_at: expiresAt,
    });
  }
  return { reminderQueued: !!due, expiryQueued: expiryEligible };
}

async function insertJob(service: SupabaseClient, row: Record<string, unknown>) {
  const { error } = await service.schema("app").from("parent_email_lifecycle_jobs")
    .upsert(row, { onConflict: "dedupe_key", ignoreDuplicates: true });
  if (error) throw new Error("parent_lifecycle_job_insert_failed");
}

type DeliveryDependencies = {
  retrieveSession: (id: string) => Promise<ParentSession>;
  send?: typeof sendLoopsTransactional;
  now?: () => number;
};

async function finishJob(
  service: SupabaseClient,
  job: LifecycleJob,
  update: Record<string, unknown>,
) {
  const { data, error } = await service.schema("app")
    .from("parent_email_lifecycle_jobs")
    .update({ ...update, lease_id: null, leased_until: null })
    .eq("id", job.id).eq("lease_id", job.lease_id).select("id").maybeSingle();
  if (error || !data) throw new Error("parent_lifecycle_lease_update_failed");
}

function retryUpdate(job: LifecycleJob, now: number, message: string) {
  const ambiguous = message === "loops_transactional_http_409" ||
    (job.attempt_count > 1 && now - Date.parse(job.created_at) >= 23 * 60 * 60 * 1000);
  return {
    last_error: message.startsWith("loops_") || message.startsWith("missing_email_config:")
      ? message
      : "delivery_failed",
    needs_review: ambiguous || message.startsWith("missing_email_config:") || job.attempt_count >= 10,
    next_attempt_at: new Date(now + Math.min(3600, 60 * 2 ** Math.min(job.attempt_count, 6)) * 1000).toISOString(),
  };
}

export async function deliverParentLifecycleEmails(
  service: SupabaseClient,
  deps: DeliveryDependencies,
) {
  if (Deno.env.get("PARENT_EMAIL_LIFECYCLE_ENABLED") !== "true") {
    return { disabled: true, claimed: 0, sent: 0 };
  }
  const { data: jobs, error } = await service.schema("app")
    .rpc("claim_parent_email_lifecycle_jobs", { p_limit: 10 });
  if (error) throw new Error("parent_lifecycle_claim_failed");
  let sent = 0;
  for (const job of (jobs ?? []) as LifecycleJob[]) {
    const now = deps.now?.() ?? Date.now();
    let update: Record<string, unknown>;
    try {
      if (job.attempt_count > 1 && now - Date.parse(job.created_at) >= 23 * 60 * 60 * 1000) {
        update = { needs_review: true, last_error: "loops_ambiguous_delivery_expired" };
      } else {
        const { data: context, error: contextError } = await service.schema("app")
          .from("parent_email_lifecycle_context").select("*")
          .eq("id", job.context_id).single();
        if (contextError || !context) throw new Error("parent_lifecycle_context_missing");
        const row = context as ParentContext;
        const session = await deps.retrieveSession(row.checkout_session_id);
        if (
          session.id !== row.checkout_session_id ||
          (session.metadata?.purchase_type ?? session.metadata?.purchaser_type) !== "parent_share" ||
          !email(session.metadata?.student_email) ||
          !subjectKeys(session).length ||
          !Number.isSafeInteger(session.expires_at) ||
          new Date(session.expires_at * 1000).toISOString() !== row.stripe_expires_at
        ) throw new Error("parent_lifecycle_session_context_mismatch");
        if (session.payment_status === "paid" || session.status === "complete") {
          update = { cancelled_at: new Date(now).toISOString(), last_error: null };
        } else if (session.payment_status !== "unpaid") {
          throw new Error("parent_lifecycle_unknown_payment_state");
        } else if (job.kind === "reminder") {
          if (
            configuredReminderLeadSeconds() !== job.reminder_lead_seconds ||
            !job.reminder_lead_seconds
          ) throw new Error("parent_lifecycle_reminder_policy_missing");
          if (session.status !== "open" || session.expires_at * 1000 <= now) {
            update = { cancelled_at: new Date(now).toISOString(), last_error: null };
          } else {
            const { data: link, error: linkError } = await service.schema("app")
              .from("parent_payment_links").select("checkout_session_id")
              .eq("code", row.short_code).single();
            if (linkError || link?.checkout_session_id !== session.id) {
              throw new Error("parent_lifecycle_short_link_mismatch");
            }
            if (!email(row.parent_email)) throw new Error("parent_lifecycle_recipient_invalid");
            const variables = parentRequestVariables({
              studentName: session.metadata?.student_name ?? "your student",
              subjects: session.metadata!.subject_ids,
              amountTotal: session.amount_total!,
              currency: session.currency!,
              checkoutUrl: shortLinkUrl(checkoutOrigin().origin, row.short_code),
              expiresAt: session.expires_at,
              parentEmail: row.parent_email,
            });
            const { parentEmail: _unused, ...reminderVariables } = variables;
            await (deps.send ?? sendLoopsTransactional)({
              transactionalId: requireEmailConfig("LOOPS_PARENT_REMINDER_TRANSACTIONAL_ID"),
              email: row.parent_email,
              dataVariables: reminderVariables,
            }, job.id);
            update = { delivered_at: new Date(now).toISOString(), last_error: null };
            sent++;
          }
        } else if (job.kind === "expired") {
          if (session.status === "open") {
            update = {
              next_attempt_at: new Date(now + 60_000).toISOString(),
              last_error: "stripe_expiry_pending",
            };
          } else if (session.status !== "expired") {
            update = { cancelled_at: new Date(now).toISOString(), last_error: null };
          } else if (
            !row.student_user_id || !row.student_email ||
            !row.new_request_url || !row.pay_yourself_url ||
            email(session.metadata?.student_email) !== row.student_email
          ) {
            throw new Error("parent_lifecycle_owner_missing");
          } else {
            const { data: owner, error: ownerError } = await service.auth.admin.getUserById(
              row.student_user_id,
            );
            if (ownerError) throw new Error("parent_lifecycle_owner_lookup_failed");
            if (
              !owner.user?.email_confirmed_at ||
              (owner.user as { is_anonymous?: boolean }).is_anonymous ||
              email(owner.user?.email) !== row.student_email
            ) {
              update = { cancelled_at: new Date(now).toISOString(), last_error: "owner_no_longer_verified" };
            } else {
              validateRecoveryUrls({
                newRequestUrl: row.new_request_url,
                payYourselfUrl: row.pay_yourself_url,
              }, session);
              await (deps.send ?? sendLoopsTransactional)({
                transactionalId: requireEmailConfig("LOOPS_PARENT_EXPIRED_TRANSACTIONAL_ID"),
                email: owner.user.email!,
                dataVariables: {
                  firstName: emailFirstName(owner.user.user_metadata?.first_name),
                  subjects: emailSubjects(session.metadata!.subject_ids),
                  newRequestUrl: emailUrl(row.new_request_url),
                  payYourselfUrl: emailUrl(row.pay_yourself_url),
                  ...emailFooter(),
                },
              }, job.id);
              update = { delivered_at: new Date(now).toISOString(), last_error: null };
              sent++;
            }
          }
        } else {
          throw new Error("parent_lifecycle_unknown_job_kind");
        }
      }
    } catch (cause) {
      const message = cause instanceof Error ? cause.message : "delivery_failed";
      const safetyFailure = message.startsWith("parent_lifecycle_") ||
        message === "invalid_parent_recovery_url" || message === "invalid_checkout_origin" ||
        message === "invalid_parent_subject_context" || message === "invalid_email_amount" ||
        message === "unsupported_email_currency" || message === "invalid_email_expiry";
      update = safetyFailure
        ? { needs_review: true, last_error: message }
        : retryUpdate(job, now, message);
    }
    await finishJob(service, job, update);
  }
  return { disabled: false, claimed: jobs?.length ?? 0, sent };
}
