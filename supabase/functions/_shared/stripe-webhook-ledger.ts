export type WebhookLedgerStatus =
  | "received"
  | "processing"
  | "processed"
  | "failed";

export type WebhookDeliveryDisposition =
  | "already_processed"
  | "in_progress"
  | "retryable";

export function webhookDeliveryDisposition(input: {
  status: WebhookLedgerStatus | null;
  processedAt: string | null;
}): WebhookDeliveryDisposition {
  if (input.processedAt || input.status === "processed") {
    return "already_processed";
  }
  if (input.status === "processing") return "in_progress";
  return "retryable";
}
