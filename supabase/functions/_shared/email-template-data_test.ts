import {
  assertEquals,
  assertThrows,
} from "https://deno.land/std@0.224.0/assert/mod.ts";
import { buildAuthEmail } from "./auth-email.ts";
import { buildPaymentEmail } from "./payment-email.ts";
import {
  emailAmount,
  emailFirstName,
  emailSubjects,
  emailText,
  emailUrl,
  parentRequestVariables,
} from "./email-template-data.ts";

function withConfig(run: () => void) {
  const values = {
    TRANSACTIONAL_MAILING_ADDRESS: "Test address & suite",
    AUTH_EMAIL_WELCOME_URL: "https://dev.example.com/welcome",
    LOOPS_SIGNUP_TRANSACTIONAL_ID: "signup",
    LOOPS_INVITE_TRANSACTIONAL_ID: "invite",
    LOOPS_MAGICLINK_TRANSACTIONAL_ID: "login",
  };
  const old = Object.fromEntries(
    Object.keys(values).map((key) => [key, Deno.env.get(key)]),
  );
  try {
    for (const [key, value] of Object.entries(values)) Deno.env.set(key, value);
    run();
  } finally {
    for (const [key, value] of Object.entries(old)) {
      if (value === undefined) Deno.env.delete(key);
      else Deno.env.set(key, value);
    }
  }
}

Deno.test("email presentation formats cents without changing payable amounts", () => {
  assertEquals(emailAmount(100, "usd"), "$1.00");
  assertEquals(emailAmount(3999, "USD"), "$39.99");
  assertEquals(emailAmount(0, "usd"), "$0.00");
  for (const amount of [-1, 1.5, NaN, Infinity]) {
    assertThrows(() => emailAmount(amount, "usd"));
  }
  assertThrows(() => emailAmount(100, "jpy"));
});

Deno.test("email personalization is bounded and text-safe", () => {
  assertEquals(emailFirstName("  Micah Example "), "Micah");
  assertEquals(emailFirstName(null), "there");
  assertEquals(emailFirstName(""), "there");
  assertEquals(
    emailFirstName("<img/onerror=alert(1)>"),
    "&lt;img/onerror=alert(1)&gt;",
  );
  assertEquals(emailText("A&B <tag>"), "A&amp;B &lt;tag&gt;");
  assertEquals(
    emailSubjects("biology,statistics"),
    "AP Biology, AP Statistics",
  );
  assertEquals(emailSubjects("<script>"), "&lt;script&gt;");
  assertEquals(
    emailSubjects("ap_physics_1,ap-physics-c-em,ap-precalculus,ap-calculus-ab"),
    "AP Physics 1, AP Physics C: Electricity and Magnetism, AP Precalculus, AP Calculus AB",
  );
  assertEquals(emailFirstName("x".repeat(200)).length, 50);
});

Deno.test("email links reject executable, unencrypted and credential-bearing URLs", () => {
  for (
    const url of [
      "javascript:alert(1)",
      "http://example.com",
      "https://secret@example.com",
      "not a URL",
    ]
  ) {
    assertThrows(() => emailUrl(url));
  }
  assertEquals(
    emailUrl("https://example.com/p/code"),
    "https://example.com/p/code",
  );
});

Deno.test("parent request contract has discounted total, short link and explicit UTC expiry", () =>
  withConfig(() => {
    const variables = parentRequestVariables({
      studentName: "Micah Example",
      subjects: "biology",
      amountTotal: 100,
      currency: "usd",
      checkoutUrl: "https://dev.example.com/p/abcdefgh",
      expiresAt: 1791288000,
      parentEmail: "parent@example.com",
    });
    assertEquals(variables.studentName, "Micah");
    assertEquals(variables.amount, "$1.00");
    assertEquals(variables.paymentUrl, "https://dev.example.com/p/abcdefgh");
    assertEquals(variables.expiresOn.endsWith(" UTC"), true);
    assertEquals(variables.parentEmail, "parent@example.com");
    assertEquals(variables.mailingAddress, "Test address &amp; suite");
  }));

Deno.test("auth personalization never trusts metadata as proof of paid access", () =>
  withConfig(() => {
    const result = buildAuthEmail({
      user: {
        email: "student@example.com",
        user_metadata: {
          first_name: "<script>",
          subjects: "All AP subjects",
          paid_by_parent: true,
        },
      },
      email_data: { email_action_type: "invite", token: "123456" },
    });
    assertEquals(result.dataVariables.firstName, "&lt;script&gt;");
    assertEquals(Object.hasOwn(result.dataVariables, "subjects"), false);
    assertEquals(Object.hasOwn(result.dataVariables, "paymentContext"), false);
    assertEquals(result.dataVariables.emailAddress, "student@example.com");
  }));

Deno.test("bound template builders cover every required imported variable", () =>
  withConfig(() => {
    const manifest = JSON.parse(Deno.readTextFileSync(
      new URL(
        "../../../docs/email/transactional/manifest.json",
        import.meta.url,
      ),
    )) as { file: string; variables: string[] }[];
    function covers(file: string, variables: Record<string, unknown>) {
      const template = manifest.find((entry) => entry.file === file)!;
      for (const variable of template.variables) {
        assertEquals(
          typeof variables[variable],
          "string",
          `${file}: ${variable}`,
        );
      }
    }
    for (
      const [action, file] of [
        ["invite", "01-welcome-verification-code.mjml"],
        ["magiclink", "02-sign-in-code.mjml"],
        ["signup", "03-email-confirmation-code.mjml"],
      ]
    ) {
      covers(
        file,
        buildAuthEmail({
          user: { email: "s@example.com" },
          email_data: { email_action_type: action, token: "123456" },
        }).dataVariables,
      );
    }
    covers(
      "04-parent-payment-request.mjml",
      parentRequestVariables({
        studentName: "Student",
        subjects: "biology",
        amountTotal: 100,
        currency: "usd",
        checkoutUrl: "https://dev.example.com/p/abcdefgh",
        expiresAt: 1791288000,
        parentEmail: "parent@example.com",
      }),
    );
    const payment = {
      sessionId: "cs_test",
      email: "student@example.com",
      subjects: "biology",
      amountTotal: 100,
      currency: "usd",
      studyUrl: "https://dev.example.com/home",
    };
    covers(
      "05-parent-paid-access-unlocked.mjml",
      buildPaymentEmail({ ...payment, purchaseType: "parent_share" })
        .data_variables,
    );
    covers(
      "07-subjects-added.mjml",
      buildPaymentEmail({ ...payment, purchaseType: "student_direct" })
        .data_variables,
    );
  }));

Deno.test("missing footer config fails closed before a provider send", () =>
  withConfig(() => {
    Deno.env.delete("TRANSACTIONAL_MAILING_ADDRESS");
    assertThrows(
      () =>
        buildAuthEmail({
          user: { email: "s@example.com" },
          email_data: { email_action_type: "signup", token: "123456" },
        }),
      Error,
      "missing_email_config:TRANSACTIONAL_MAILING_ADDRESS",
    );
  }));
