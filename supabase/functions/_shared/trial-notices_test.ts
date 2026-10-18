import { assertEquals } from "https://deno.land/std@0.224.0/assert/mod.ts";
import {
  deliverTrialNotices,
  type NoticeDeps,
  type NoticeOrder,
  noticeRecipient,
  noticeStillRelevant,
  noticeVariables,
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

Deno.test("recipients: payer email, or the student's current account email", () => {
  assertEquals(noticeRecipient({ recipient_role: "payer" }, order, null), "parent@example.com");
  assertEquals(noticeRecipient({ recipient_role: "student" }, order, "new@example.com"), "new@example.com");
  assertEquals(noticeRecipient({ recipient_role: "student" }, order, null), "kid@example.com");
  assertEquals(templateEnvName("trial_started", "student"), "LOOPS_TRIAL_TRIAL_STARTED_STUDENT_TRANSACTIONAL_ID");
});

function deps(jobs: Any[], orderRow: Any, templates: Record<string, string>) {
  const sent: Any[] = [];
  const updates: Any[] = [];
  const caps: Any[] = [];
  const service = {
    schema: () => ({
      rpc: () => Promise.resolve({ data: jobs, error: null }),
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
    now: () => new Date("2026-10-18T16:00:00Z"),
  };
  return { d, sent, updates, caps };
}

Deno.test("worker: sends with a stable idempotency key and issues a parent cancel token", async () => {
  const job = { id: "j1", dedupe_key: "order-1:trial_started:payer", order_id: "order-1", kind: "trial_started", recipient_role: "payer", attempt_count: 1, lease_id: "L" };
  const h = deps([job], order, { LOOPS_TRIAL_TRIAL_STARTED_PAYER_TRANSACTIONAL_ID: "tx_1" });
  const summary = await deliverTrialNotices(h.d);
  assertEquals(summary.sent, 1);
  assertEquals(h.sent[0][1], "trial:order-1:trial_started:payer");
  assertEquals(h.sent[0][0].email, "parent@example.com");
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
