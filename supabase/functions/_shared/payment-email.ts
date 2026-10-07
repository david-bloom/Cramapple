import type { SupabaseClient } from "https://esm.sh/@supabase/supabase-js@2.49.1";
import { isPayerNotLearner } from "./addon-checkout.ts";
import {
  emailFirstName,
  emailFooter,
  emailSubjects,
  emailUrl,
} from "./email-template-data.ts";
import {
  requireEmailConfig,
  sendLoopsTransactional,
} from "./loops-transactional.ts";

export function buildPaymentEmail(input: {
  sessionId: string;
  email: string;
  purchaseType: string;
  subjects: string;
  amountTotal: number;
  currency: string;
  studyUrl: string;
  firstName?: unknown;
}) {
  return {
    dedupe_key: `payment:${input.sessionId}`,
    template_env: isPayerNotLearner(input.purchaseType)
      ? "LOOPS_PARENT_PAID_TRANSACTIONAL_ID"
      : "LOOPS_PURCHASE_TRANSACTIONAL_ID",
    recipient_email: input.email,
    data_variables: {
      subjects: emailSubjects(input.subjects),
      amountTotal: input.amountTotal,
      currency: input.currency,
      studyUrl: input.studyUrl,
      appUrl: emailUrl(input.studyUrl),
      firstName: emailFirstName(input.firstName),
      ...emailFooter(),
    },
  };
}

export async function enqueuePaymentEmail(
  service: SupabaseClient,
  userId: string,
  input: {
    sessionId: string;
    purchaseType: string;
    subjects: string;
    amountTotal: number;
    currency: string;
  },
) {
  if (Deno.env.get("LOOPS_PAYMENT_EMAILS_ENABLED") !== "true") return;
  const { data, error } = await service.auth.admin.getUserById(userId);
  if (error || !data.user?.email) {
    throw new Error("payment_email_recipient_lookup_failed");
  }
  const message = buildPaymentEmail({
    ...input,
    email: data.user.email,
    firstName: data.user.user_metadata?.first_name,
    studyUrl: requireEmailConfig("TRANSACTIONAL_STUDY_URL"),
  });
  const { error: insertError } = await service.schema("app")
    .from("transactional_email_outbox")
    .upsert(message, { onConflict: "dedupe_key", ignoreDuplicates: true });
  if (insertError) throw new Error("payment_email_enqueue_failed");
}

export async function deliverPaymentEmails(service: SupabaseClient) {
  const { data: rows, error } = await service.schema("app").rpc(
    "claim_transactional_emails",
    { p_limit: 10 },
  );
  if (error) throw new Error("payment_email_claim_failed");
  let sent = 0;
  for (const row of rows ?? []) {
    let update: Record<string, unknown>;
    try {
      if (
        row.attempt_count > 1 &&
        Date.now() - Date.parse(row.created_at) >= 23 * 60 * 60 * 1000
      ) {
        throw new Error("loops_ambiguous_delivery_expired");
      }
      // Freeze the template contract before enabling payments; do not change IDs
      // while ambiguous deliveries are pending.
      await sendLoopsTransactional({
        transactionalId: requireEmailConfig(row.template_env),
        email: row.recipient_email,
        dataVariables: row.data_variables,
      }, row.id);
      update = { delivered_at: new Date().toISOString(), last_error: null };
      sent++;
    } catch (error) {
      const message = error instanceof Error
        ? error.message
        : "delivery_failed";
      const ambiguous = message === "loops_transactional_http_409" ||
        Date.now() - Date.parse(row.created_at) >= 23 * 60 * 60 * 1000;
      update = {
        last_error: message.startsWith("loops_") ||
            message.startsWith("missing_email_config:")
          ? message
          : "delivery_failed",
        next_attempt_at: new Date(
          Date.now() +
            Math.min(3600, 60 * 2 ** Math.min(row.attempt_count, 6)) * 1000,
        ).toISOString(),
        needs_review: ambiguous,
      };
    }
    const { error: updateError } = await service.schema("app").from(
      "transactional_email_outbox",
    )
      .update({ ...update, leased_until: null, lease_id: null })
      .eq("id", row.id).eq("lease_id", row.lease_id);
    if (updateError) throw new Error("payment_email_status_update_failed");
  }
  return { claimed: rows?.length ?? 0, sent };
}
