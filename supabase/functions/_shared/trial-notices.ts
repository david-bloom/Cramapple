// Card-trial notices (TASK-0077 plan §6.13; DECISION-0126 items 11, 13, 29,
// 30). Jobs are queued in the same transaction as each state change; this
// worker renders and sends them, rechecking the order first so a stale
// "please pay" never reaches a converted or cancelled order. Delivery
// failure never blocks a charge (item 30).

import { easternDate, formatUsd, newCapabilityToken } from "./trial-core.ts";

// deno-lint-ignore no-explicit-any
type Any = any;

export type NoticeKind =
  | "trial_started"
  | "reminder"
  | "payment_failed"
  | "requires_action"
  | "grace_ended"
  | "delayed_charge"
  | "canceled"
  | "converted"
  | "refunded";

export type NoticeJob = {
  id: string;
  dedupe_key: string;
  order_id: string;
  kind: NoticeKind;
  recipient_role: "payer" | "student";
  attempt_count: number;
  lease_id: string | null;
};

export type NoticeOrder = {
  id: string;
  status: string;
  purchase_type: "student_direct" | "parent_share";
  user_id: string | null;
  student_email_norm: string;
  student_name: string | null;
  payer_email: string | null;
  subject_keys: string[];
  charge_amount: number;
  trial_ends_at: string | null;
  grace_ends_at: string | null;
  recovery_expires_at: string | null;
  next_attempt_at: string | null;
  cancel_outcome: string | null;
  payment_method_id: string | null;
};

// Which order states each notice still applies to.
const STILL_RELEVANT: Record<NoticeKind, string[]> = {
  trial_started: ["trialing", "charging", "payment_failed", "requires_action", "delayed_notice", "converted"],
  reminder: ["trialing"],
  payment_failed: ["payment_failed"],
  requires_action: ["requires_action"],
  grace_ended: ["recovery_only"],
  delayed_charge: ["delayed_notice"],
  canceled: ["canceled"],
  converted: ["converted"],
  refunded: ["refunded"],
};

export function noticeStillRelevant(kind: NoticeKind, status: string) {
  return STILL_RELEVANT[kind].includes(status);
}

// Template per kind and recipient role. Missing config is a release-gate
// failure: the job retries and shows in last_error.
export function templateEnvName(kind: NoticeKind, role: "payer" | "student") {
  return `LOOPS_TRIAL_${kind.toUpperCase()}_${role.toUpperCase()}_TRANSACTIONAL_ID`;
}

const SUBJECT_NAMES: Record<string, string> = {
  biology: "AP Biology",
  statistics: "AP Statistics",
};

export function subjectList(keys: string[]) {
  return keys.map((k) => SUBJECT_NAMES[k] ?? k.replace(/[-_]/g, " ")).join(", ");
}

export type NoticeLinks = {
  accountUrl: string;
  cancelUrl: string | null;
  recoveryUrl: string | null;
  termsUrl: string;
};

// Data variables for one notice. Student copies on parent-pay carry no card
// details and no payment link (plan §6.13).
export function noticeVariables(
  job: Pick<NoticeJob, "kind" | "recipient_role">,
  order: NoticeOrder,
  links: NoticeLinks,
  cardLast4: string | null,
): Record<string, string> {
  const parent = order.purchase_type === "parent_share";
  const studentCopy = job.recipient_role === "student";
  const date = (iso: string | null) => (iso ? `${easternDate(new Date(iso))} (Eastern)` : "");
  const vars: Record<string, string> = {
    subjects: subjectList(order.subject_keys),
    amount: formatUsd(order.charge_amount),
    chargeDate: date(order.trial_ends_at),
    graceEndDate: date(order.grace_ends_at),
    recoveryDeadline: date(order.recovery_expires_at),
    delayedChargeDate: date(order.next_attempt_at),
    studentFirstName: order.student_name?.split(/\s+/)[0] ?? "",
    paidByParent: parent ? "yes" : "no",
    cancelOutcome: order.cancel_outcome ?? "",
    accountUrl: links.accountUrl,
    termsUrl: links.termsUrl,
    cancelUrl: (studentCopy ? links.accountUrl : links.cancelUrl ?? links.accountUrl),
    recoveryUrl: studentCopy ? "" : links.recoveryUrl ?? "",
    cardLast4: studentCopy ? "" : cardLast4 ?? "",
  };
  return vars;
}

export function noticeRecipient(job: Pick<NoticeJob, "recipient_role">, order: NoticeOrder, studentAccountEmail: string | null) {
  if (job.recipient_role === "payer") return order.payer_email;
  // The student's current account email; the order email if the account has none.
  return studentAccountEmail ?? order.student_email_norm;
}

export type NoticeDeps = {
  service: Any;
  send: (input: { transactionalId: string; email: string; dataVariables: Record<string, string> }, key: string) => Promise<void>;
  templateId: (envName: string) => string | null;
  retrieveCardLast4: (paymentMethodId: string) => Promise<string | null>;
  lookupUserEmail: (userId: string) => Promise<string | null>;
  appBaseUrl: string;
  marketingBaseUrl: string;
  now: () => Date;
};

const RECOVERY_KINDS = new Set<NoticeKind>(["payment_failed", "requires_action", "grace_ended"]);
const PARENT_CANCEL_KINDS = new Set<NoticeKind>(["trial_started", "reminder", "delayed_charge"]);

async function issueCapability(deps: NoticeDeps, order: NoticeOrder, purpose: "parent_cancel" | "payer_recovery") {
  const { token, hash } = await newCapabilityToken();
  const expires = purpose === "payer_recovery"
    ? (order.recovery_expires_at ??
      new Date(new Date(order.grace_ends_at ?? deps.now()).getTime() + 30 * 86400000).toISOString())
    : new Date(new Date(order.trial_ends_at ?? deps.now()).getTime() + 3 * 86400000).toISOString();
  const { error } = await deps.service.schema("app").from("trial_capabilities").insert({
    order_id: order.id,
    purpose,
    token_hash: hash,
    expires_at: expires,
  });
  if (error) throw error;
  return purpose === "payer_recovery"
    ? `${deps.appBaseUrl}/trial/pay/${token}`
    : `${deps.appBaseUrl}/trial/cancel/${token}`;
}

export async function deliverTrialNotices(deps: NoticeDeps, limit = 10) {
  const app = deps.service.schema("app");
  const { data: jobs, error } = await app.rpc("claim_trial_notice_jobs", { p_limit: limit });
  if (error) throw error;
  const summary = { claimed: (jobs ?? []).length, sent: 0, skipped: 0, failed: 0 };

  for (const job of (jobs ?? []) as NoticeJob[]) {
    try {
      const { data: order, error: orderError } = await app.from("trial_orders")
        .select("*").eq("id", job.order_id).single();
      if (orderError) throw orderError;
      if (!noticeStillRelevant(job.kind, order.status)) {
        await app.from("trial_notice_jobs").update({ cancelled_at: deps.now().toISOString() })
          .eq("id", job.id).eq("lease_id", job.lease_id);
        summary.skipped++;
        continue;
      }
      const envName = templateEnvName(job.kind, job.recipient_role);
      const transactionalId = deps.templateId(envName);
      if (!transactionalId) throw new Error(`missing_email_config:${envName}`);

      const parent = order.purchase_type === "parent_share";
      const payerCopy = job.recipient_role === "payer";
      const links: NoticeLinks = {
        accountUrl: `${deps.appBaseUrl}/account`,
        termsUrl: `${deps.marketingBaseUrl}/terms`,
        cancelUrl: payerCopy && parent && PARENT_CANCEL_KINDS.has(job.kind)
          ? await issueCapability(deps, order, "parent_cancel")
          : null,
        recoveryUrl: payerCopy && RECOVERY_KINDS.has(job.kind)
          ? await issueCapability(deps, order, "payer_recovery")
          : null,
      };
      const cardLast4 = payerCopy && order.payment_method_id && job.kind === "trial_started"
        ? await deps.retrieveCardLast4(order.payment_method_id)
        : null;
      const studentEmail = order.user_id && !payerCopy ? await deps.lookupUserEmail(order.user_id) : null;
      const email = noticeRecipient(job, order, studentEmail);
      if (!email) throw new Error("trial_notice_missing_recipient");

      await deps.send(
        { transactionalId, email, dataVariables: noticeVariables(job, order, links, cardLast4) },
        `trial:${job.dedupe_key}`.slice(0, 100),
      );
      await app.from("trial_notice_jobs").update({ delivered_at: deps.now().toISOString(), last_error: null })
        .eq("id", job.id).eq("lease_id", job.lease_id);
      summary.sent++;
    } catch (err) {
      summary.failed++;
      const message = err instanceof Error ? err.message : "trial_notice_failed";
      // Back off: 5, 15, 45 minutes … capped at 6 hours; flag after 8 tries.
      const delayMinutes = Math.min(360, 5 * 3 ** Math.max(0, job.attempt_count - 1));
      await app.from("trial_notice_jobs").update({
        last_error: message.slice(0, 300),
        next_attempt_at: new Date(deps.now().getTime() + delayMinutes * 60000).toISOString(),
        needs_review: job.attempt_count >= 8,
      }).eq("id", job.id).eq("lease_id", job.lease_id);
    }
  }
  return summary;
}
