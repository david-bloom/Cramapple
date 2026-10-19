import { assertEquals } from "https://deno.land/std@0.224.0/assert/mod.ts";
import {
  deliverTrialNotices,
  type NoticeDeps,
  type NoticeOrder,
  noticeRecipient,
  noticeStillRelevant,
  noticeVariables,
  parentCancelExpiry,
  templateEnvName,
} from "./trial-notices.ts";

// deno-lint-ignore no-explicit-any
type Any = any;

const order: NoticeOrder = {
  id: "order-1",
  status: "trialing",
  purchase_type: "parent_share",
  user_id: "user-1",
  student_email_norm: "kid@example.com",
  student_name: "Sam Lee",
  payer_email: "parent@example.com",
  subject_keys: ["biology", "statistics"],
  charge_amount: 6999,
  trial_ends_at: "2026-10-25T16:00:00Z",
  grace_ends_at: null,
  recovery_expires_at: null,
  next_attempt_at: null,
  cancel_outcome: null,
  payment_method_id: "pm_1",
};
const links = { accountUrl: "https://app/account", cancelUrl: "https://app/trial/cancel/T", recoveryUrl: "https://app/trial/pay/R", termsUrl: "https://site/terms" };

Deno.test("stale notices are skipped by order state", () => {
  assertEquals(noticeStillRelevant("reminder", "trialing"), true);
  assertEquals(noticeStillRelevant("reminder", "converted"), false);
  assertEquals(noticeStillRelevant("payment_failed", "converted"), false);
  assertEquals(noticeStillRelevant("trial_started", "converted"), false);
  assertEquals(noticeStillRelevant("canceled", "canceled"), true);
});

Deno.test("parent copy carries payment links; the student copy never does", () => {
  const payer = noticeVariables({ kind: "payment_failed", recipient_role: "payer" }, order, links, "4242");
  const student = noticeVariables({ kind: "payment_failed", recipient_role: "student" }, order, links, "4242");
  assertEquals([payer.recoveryUrl, payer.cardLast4, payer.cancelUrl], [links.recoveryUrl, "4242", links.cancelUrl]);
  assertEquals([student.recoveryUrl, student.cardLast4, student.cancelUrl], ["", "", links.accountUrl]);
  assertEquals(payer.subjects, "AP Biology, AP Statistics");
  assertEquals(payer.amount, "$69.99");
  assertEquals(payer.chargeDate, "Sunday, October 25, 2026 (Eastern)");
  assertEquals(payer.studentFirstName, "Sam");
});

Deno.test("the cancel outcome line says no charge only when that is known", () => {
  const v = (o: string | null) =>
    noticeVariables({ kind: "canceled", recipient_role: "payer" }, { ...order, cancel_outcome: o }, links, null).cancelOutcomeText;
  assertEquals(v("no_charge"), "You won't be charged.");
  assertEquals(v("refunded"), "The $69.99 charge has been refunded in full. It usually appears within 5 to 10 business days.");
  assertEquals(v("pending"), "");
  assertEquals(v(null), "");
});

Deno.test("recipients: payer email, or the student's current account email", () => {
  assertEquals(noticeRecipient({ recipient_role: "payer" }, order, null), "parent@example.com");
  assertEquals(noticeRecipient({ recipient_role: "student" }, order, "new@example.com"), "new@example.com");
  assertEquals(noticeRecipient({ recipient_role: "student" }, order, null), "kid@example.com");
  assertEquals(templateEnvName("trial_started", "student"), "LOOPS_TRIAL_TRIAL_STARTED_STUDENT_TRANSACTIONAL_ID");
  // A student paying for themselves gets the learner version (how to sign in).
  assertEquals(templateEnvName("trial_started", "payer", "student_direct"), "LOOPS_TRIAL_TRIAL_STARTED_LEARNER_TRANSACTIONAL_ID");
  assertEquals(templateEnvName("trial_started", "payer", "parent_share"), "LOOPS_TRIAL_TRIAL_STARTED_PAYER_TRANSACTIONAL_ID");
  assertEquals(templateEnvName("reminder", "payer", "student_direct"), "LOOPS_TRIAL_REMINDER_PAYER_TRANSACTIONAL_ID");
});

function deps(jobs: Any[], orderRow: Any, templates: Record<string, string>, now = "2026-10-18T16:00:00Z") {
  const rpcs: Any[] = [];
  const sent: Any[] = [];
  const updates: Any[] = [];
  const caps: Any[] = [];
  const service = {
    schema: () => ({
      rpc: (fn: string, args: Any) => {
        rpcs.push([fn, args]);
        return Promise.resolve({ data: fn === "claim_trial_notice_jobs" ? jobs : null, error: null });
      },
      from: (table: string) => {
        const b: Any = {
          select: () => b,
          eq: () => b,
          single: () => Promise.resolve({ data: orderRow, error: null }),
          insert: (row: Any) => { caps.push(row); return Promise.resolve({ error: null }); },
          update: (p: Any) => { updates.push([table, p]); return b; },
          then: (r: Any) => r({ error: null }),
        };
        return b;
      },
    }),
  };
  const d: NoticeDeps = {
    service,
    send: (input, key) => { sent.push([input, key]); return Promise.resolve(); },
    templateId: (name) => templates[name] ?? null,
    retrieveCardLast4: () => Promise.resolve("4242"),
    lookupUserEmail: () => Promise.resolve("kid@example.com"),
    appBaseUrl: "https://app",
    marketingBaseUrl: "https://site",
    mailingAddress: "Test address",
    now: () => new Date(now),
  };
  return { d, sent, updates, caps, rpcs };
}

Deno.test("worker: sends with a stable idempotency key and issues a parent cancel token", async () => {
  const job = { id: "j1", dedupe_key: "order-1:trial_started:payer", order_id: "order-1", kind: "trial_started", recipient_role: "payer", attempt_count: 1, lease_id: "L" };
  const h = deps([job], order, { LOOPS_TRIAL_TRIAL_STARTED_PAYER_TRANSACTIONAL_ID: "tx_1" });
  const summary = await deliverTrialNotices(h.d);
  assertEquals(summary.sent, 1);
  assertEquals(h.sent[0][1], "trial:order-1:trial_started:payer");
  assertEquals(h.sent[0][0].email, "parent@example.com");
  assertEquals(h.sent[0][0].dataVariables.mailingAddress, "Test address");
  assertEquals(h.caps[0].purpose, "parent_cancel");
  assertEquals(h.sent[0][0].dataVariables.cancelUrl.startsWith("https://app/trial/cancel/"), true);
  assertEquals(h.updates.some(([t, p]: Any) => t === "trial_notice_jobs" && p.delivered_at), true);
});

Deno.test("worker: a stale notice is cancelled, and missing template config backs off", async () => {
  const stale = { id: "j2", dedupe_key: "k", order_id: "order-1", kind: "reminder", recipient_role: "payer", attempt_count: 1, lease_id: "L" };
  const h = deps([stale], { ...order, status: "canceled" }, {});
  assertEquals((await deliverTrialNotices(h.d)).skipped, 1);
  assertEquals(h.sent.length, 0);

  const live = { ...stale, id: "j3" };
  const h2 = deps([live], order, {});
  assertEquals((await deliverTrialNotices(h2.d)).failed, 1);
  const backoff = h2.updates.find(([t]: Any) => t === "trial_notice_jobs")[1];
  assertEquals(backoff.last_error.startsWith("missing_email_config:"), true);
});

Deno.test("worker: an unsent trial-started notice after conversion sends nothing and issues no cancel token", async () => {
  const job = { id: "stale-start", dedupe_key: "start", order_id: "order-1", kind: "trial_started", recipient_role: "payer", attempt_count: 1, lease_id: "L" };
  const h = deps([job], { ...order, status: "converted" }, { LOOPS_TRIAL_TRIAL_STARTED_PAYER_TRANSACTIONAL_ID: "tx_1" });
  assertEquals((await deliverTrialNotices(h.d)).skipped, 1);
  assertEquals(h.sent.length, 0);
  assertEquals(h.caps.length, 0);
  assertEquals(h.updates.some(([t, p]: Any) => t === "trial_notice_jobs" && p.cancelled_at), true);
});

Deno.test("a parent's cancel link outlives a delayed charge and is never issued already expired", () => {
  // Original trial end Oct 21; an outage moved the charge to Oct 27; issued Oct 25.
  const delayed = { trial_ends_at: "2026-10-21T16:00:00Z", next_attempt_at: "2026-10-27T17:00:00Z" };
  assertEquals(parentCancelExpiry(delayed, new Date("2026-10-25T16:00:00Z")), "2026-10-30T17:00:00.000Z");
  // Issued long after both: still three days from issue.
  assertEquals(
    parentCancelExpiry({ trial_ends_at: "2026-10-21T16:00:00Z", next_attempt_at: null }, new Date("2026-11-01T00:00:00Z")),
    "2026-11-04T00:00:00.000Z",
  );
});

Deno.test("worker: a delayed charge is dated from the payer's sent notice, and its cancel link covers it", async () => {
  const delayedOrder = { ...order, status: "delayed_notice", trial_ends_at: "2026-10-21T16:00:00Z", next_attempt_at: null };
  const job = { id: "j4", dedupe_key: "order-1:delayed_charge:payer:1", order_id: "order-1", kind: "delayed_charge", recipient_role: "payer", attempt_count: 1, lease_id: "L" };
  const h = deps([job], delayedOrder, { LOOPS_TRIAL_DELAYED_CHARGE_PAYER_TRANSACTIONAL_ID: "tx_d" }, "2026-10-25T16:00:00Z");
  assertEquals((await deliverTrialNotices(h.d)).sent, 1);
  const ack = h.rpcs.find(([fn]: Any) => fn === "trial_delayed_notice_sent");
  assertEquals(ack[1], { p_order_id: "order-1", p_next_attempt_at: "2026-10-27T17:00:00.000Z" });
  assertEquals(new Date(h.caps[0].expires_at) > new Date("2026-10-27T17:00:00Z"), true);
});

Deno.test("worker: no acknowledgement when the delayed-charge email fails, so no charge becomes due", async () => {
  const delayedOrder = { ...order, status: "delayed_notice", next_attempt_at: null };
  const job = { id: "j5", dedupe_key: "k5", order_id: "order-1", kind: "delayed_charge", recipient_role: "payer", attempt_count: 1, lease_id: "L" };
  const h = deps([job], delayedOrder, {}); // template missing: the send never happens
  assertEquals((await deliverTrialNotices(h.d)).failed, 1);
  assertEquals(h.rpcs.some(([fn]: Any) => fn === "trial_delayed_notice_sent"), false);
});

Deno.test("worker: the student's delayed-charge copy waits for the payer's, so both name one date", async () => {
  const delayedOrder = { ...order, status: "delayed_notice", next_attempt_at: null };
  const job = { id: "j6", dedupe_key: "k6", order_id: "order-1", kind: "delayed_charge", recipient_role: "student", attempt_count: 1, lease_id: "L" };
  const h = deps([job], delayedOrder, { LOOPS_TRIAL_DELAYED_CHARGE_STUDENT_TRANSACTIONAL_ID: "tx_s" });
  assertEquals((await deliverTrialNotices(h.d)).failed, 1);
  assertEquals(h.sent.length, 0);
});
