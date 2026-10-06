import type { SupabaseClient } from "https://esm.sh/@supabase/supabase-js@2.49.1";
import {
  emailAmount,
  emailFooter,
  emailSubjects,
  emailText,
  emailUrl,
} from "./email-template-data.ts";

export type PayerCharge = {
  id: string;
  paid: boolean;
  status: string;
  captured: boolean;
  amount_captured: number;
  currency: string;
  created: number;
  billing_details?: { email?: string | null } | null;
  receipt_url?: string | null;
  receipt_number?: string | null;
  payment_method_details?: {
    type: string;
    card?: { brand: string; last4: string } | null;
  } | null;
};

export type PayerRefund = {
  id: string;
  charge: string | { id: string } | null;
  status: string | null;
  amount: number;
  currency: string;
};

export function payerEmailsEnabled() {
  return Deno.env.get("LOOPS_PAYER_EMAILS_ENABLED") === "true";
}

function bounded(value: string, maximum: number) {
  if (value.length > maximum || /[\x00-\x1f\x7f]/.test(value)) {
    throw new Error("invalid_payer_email_text");
  }
  return value;
}

function stripeId(value: string, prefix: string) {
  if (!new RegExp(`^${prefix}_[A-Za-z0-9]{1,200}$`).test(value)) {
    throw new Error("invalid_payer_email_reference");
  }
  return value;
}

function payerEmail(charge: PayerCharge) {
  // Checkout customer_email and Auth describe the learner, not necessarily
  // the payer. Even charge.receipt_email can inherit that checkout address.
  const email = charge.billing_details?.email?.trim();
  if (!email) return null;
  if (email.length > 254 || !/^[^\s<>@]+@[^\s<>@]+\.[^\s<>@]+$/.test(email)) {
    throw new Error("invalid_payer_billing_email");
  }
  return email;
}

function date(seconds: number) {
  if (!Number.isSafeInteger(seconds) || seconds <= 0 || seconds > 253402300799) {
    throw new Error("invalid_payer_payment_date");
  }
  return new Intl.DateTimeFormat("en-US", {
    dateStyle: "medium",
    timeZone: "UTC",
  }).format(new Date(seconds * 1000));
}

function paymentMethod(charge: PayerCharge): { cardBrand: string; cardLast4: string } | null {
  const details = charge.payment_method_details;
  if (details?.type === "card" && details.card) {
    if (!/^\d{4}$/.test(details.card.last4)) {
      throw new Error("invalid_payer_card_suffix");
    }
    return {
      cardBrand: emailText(bounded(details.card.brand, 40)),
      cardLast4: details.card.last4,
    };
  }
  // The supplied receipt/refund design has cardBrand/cardLast4 fields. Do
  // not put a non-card label into a card-shaped slot; defer until a matching
  // design is supplied for that payment method.
  return null;
}

function receiptUrl(charge: PayerCharge) {
  if (!charge.receipt_url) throw new Error("missing_payer_receipt_url");
  const url = new URL(bounded(charge.receipt_url, 2048));
  if (url.hostname !== "pay.stripe.com" || !url.pathname.startsWith("/receipts/")) {
    throw new Error("invalid_payer_receipt_url");
  }
  return emailUrl(url.toString());
}

function settled(charge: PayerCharge) {
  return charge.paid && charge.captured && charge.status === "succeeded";
}

function capturedAmount(charge: PayerCharge) {
  if (charge.amount_captured <= 0) throw new Error("invalid_payer_captured_amount");
  return emailAmount(charge.amount_captured, charge.currency);
}

export function buildPayerReceiptEmail(charge: PayerCharge, subjects: string) {
  if (!settled(charge)) return null;
  const recipient = payerEmail(charge);
  if (!recipient) return null;
  const method = paymentMethod(charge);
  if (!method) return null;
  return {
    dedupe_key: `payer-receipt:${stripeId(charge.id, "ch")}`,
    template_env: "LOOPS_RECEIPT_TRANSACTIONAL_ID",
    recipient_email: recipient,
    data_variables: {
      date: date(charge.created),
      receiptNumber: charge.receipt_number
        ? emailText(bounded(charge.receipt_number, 100))
        : "See Stripe receipt",
      items: emailSubjects(bounded(subjects, 1000)),
      total: capturedAmount(charge),
      ...method,
      receiptUrl: receiptUrl(charge),
      ...emailFooter(),
    },
  };
}

export function buildPayerRefundEmail(
  charge: PayerCharge,
  refund: PayerRefund,
  subjects: string,
) {
  if (refund.status !== "succeeded" || !settled(charge)) return null;
  const chargeId = typeof refund.charge === "string" ? refund.charge : refund.charge?.id;
  if (chargeId !== charge.id || refund.currency !== charge.currency) {
    throw new Error("payer_refund_charge_mismatch");
  }
  capturedAmount(charge);
  if (refund.amount <= 0 || refund.amount > charge.amount_captured) {
    throw new Error("invalid_payer_refund_amount");
  }
  const recipient = payerEmail(charge);
  if (!recipient) return null;
  const method = paymentMethod(charge);
  if (!method) return null;
  return {
    // Refund objects, not webhook events or the charge's cumulative total,
    // distinguish successive partial refunds and collapse created/updated.
    dedupe_key: `payer-refund:${stripeId(refund.id, "re")}`,
    template_env: "LOOPS_REFUND_TRANSACTIONAL_ID",
    recipient_email: recipient,
    data_variables: {
      amount: emailAmount(refund.amount, refund.currency),
      ...method,
      originalDate: date(charge.created),
      subjects: emailSubjects(bounded(subjects, 1000)),
      receiptUrl: receiptUrl(charge),
      // Access revocation is a separate charge.refunded handler and may arrive
      // later. Neither a full nor partial refund proves current access here.
      accessChange: "This notice confirms the refund only. Check Cramapple for current study access.",
      refundTiming: "Your payment provider determines when the refund appears. Timing varies by payment method.",
      ...emailFooter(),
    },
  };
}

export async function enqueuePayerEmail(
  service: SupabaseClient,
  message: ReturnType<typeof buildPayerReceiptEmail> | ReturnType<typeof buildPayerRefundEmail>,
) {
  if (!payerEmailsEnabled()) return;
  if (!message) {
    console.warn("payer_email_skipped_unsettled_or_missing_billing_email");
    return;
  }
  const { error } = await service.schema("app")
    .from("transactional_email_outbox")
    .upsert(message, { onConflict: "dedupe_key", ignoreDuplicates: true });
  if (error) throw new Error("payer_email_enqueue_failed");
}
