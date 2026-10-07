import {
  assertEquals,
  assertThrows,
} from "https://deno.land/std@0.224.0/assert/mod.ts";
import {
  buildPayerReceiptEmail,
  buildPayerRefundEmail,
  type PayerCharge,
} from "./payer-email.ts";

const charge: PayerCharge = {
  id: "ch_test123",
  paid: true,
  captured: true,
  status: "succeeded",
  amount_captured: 3999,
  currency: "usd",
  created: 1791288000,
  billing_details: { email: "payer@example.com" },
  payment_method_details: {
    type: "card",
    card: { brand: "visa", last4: "4242" },
  },
  receipt_url: "https://pay.stripe.com/receipts/test123",
};
const refund = {
  id: "re_test123",
  charge: charge.id,
  status: "succeeded",
  amount: 1000,
  currency: "usd",
};

function configured(run: () => void) {
  const old = Deno.env.get("TRANSACTIONAL_MAILING_ADDRESS");
  Deno.env.set("TRANSACTIONAL_MAILING_ADDRESS", "Test address");
  try {
    run();
  } finally {
    if (old === undefined) Deno.env.delete("TRANSACTIONAL_MAILING_ADDRESS");
    else Deno.env.set("TRANSACTIONAL_MAILING_ADDRESS", old);
  }
}

Deno.test("payer receipts use billing identity, captured cents and published variables", () =>
  configured(() => {
    const receipt = buildPayerReceiptEmail(charge, "biology")!;
    assertEquals(receipt.recipient_email, "payer@example.com");
    assertEquals(receipt.data_variables.total, "$39.99");
    assertEquals(receipt.data_variables.items, "AP Biology");
    const manifest = JSON.parse(
      Deno.readTextFileSync(
        new URL(
          "../../../docs/email/transactional/manifest.json",
          import.meta.url,
        ),
      ),
    );
    for (
      const [file, message] of [
        ["06-payment-receipt.mjml", receipt],
        [
          "10-refund-confirmation.mjml",
          buildPayerRefundEmail(charge, refund, "biology")!,
        ],
      ] as const
    ) {
      for (
        const variable of manifest.find((row: { file: string }) =>
          row.file === file
        ).variables
      ) {
        assertEquals(
          typeof (message.data_variables as Record<string, unknown>)[variable],
          "string",
          `${file}: ${variable}`,
        );
      }
    }
  }));

Deno.test("payer notices skip unsettled charges, missing billing identity and unsupported card design", () =>
  configured(() => {
    assertEquals(
      buildPayerReceiptEmail({ ...charge, paid: false }, "biology"),
      null,
    );
    assertEquals(
      buildPayerReceiptEmail({ ...charge, billing_details: {} }, "biology"),
      null,
    );
    assertEquals(
      buildPayerReceiptEmail({
        ...charge,
        payment_method_details: { type: "paypal" },
      }, "biology"),
      null,
    );
    assertEquals(
      buildPayerRefundEmail(
        charge,
        { ...refund, status: "pending" },
        "biology",
      ),
      null,
    );
  }));

Deno.test("refund notices dedupe individual successful refunds and never claim current access", () =>
  configured(() => {
    const first = buildPayerRefundEmail(charge, refund, "biology")!;
    const second = buildPayerRefundEmail(charge, {
      ...refund,
      id: "re_test456",
      amount: 500,
    }, "biology")!;
    assertEquals(first.data_variables.amount, "$10.00");
    assertEquals(second.data_variables.amount, "$5.00");
    assertEquals(first.dedupe_key === second.dedupe_key, false);
    assertEquals(
      first.data_variables.accessChange.includes("refund only"),
      true,
    );
    assertThrows(() =>
      buildPayerRefundEmail(
        charge,
        { ...refund, charge: "ch_other" },
        "biology",
      )
    );
    assertThrows(() =>
      buildPayerRefundEmail(charge, { ...refund, amount: 4000 }, "biology")
    );
    assertThrows(() =>
      buildPayerReceiptEmail({
        ...charge,
        receipt_url: "https://evil.example/receipts/a",
      }, "biology")
    );
  }));
