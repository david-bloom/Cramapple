import { webhookDeliveryDisposition } from "./stripe-webhook-ledger.ts";

function assertEquals(actual: unknown, expected: unknown) {
  if (actual !== expected) {
    throw new Error(`Expected ${String(expected)}, received ${String(actual)}`);
  }
}

Deno.test("processed webhook deliveries remain idempotent", () => {
  assertEquals(
    webhookDeliveryDisposition({
      status: "processed",
      processedAt: "2026-09-28T18:00:00Z",
    }),
    "already_processed",
  );
});

Deno.test("failed and received webhook deliveries remain retryable", () => {
  assertEquals(
    webhookDeliveryDisposition({ status: "failed", processedAt: null }),
    "retryable",
  );
  assertEquals(
    webhookDeliveryDisposition({ status: "received", processedAt: null }),
    "retryable",
  );
});

Deno.test("an active webhook attempt is not processed concurrently", () => {
  assertEquals(
    webhookDeliveryDisposition({ status: "processing", processedAt: null }),
    "in_progress",
  );
});
