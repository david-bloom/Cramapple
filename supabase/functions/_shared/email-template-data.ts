import { requireEmailConfig } from "./loops-transactional.ts";

export function emailText(value: string): string {
  return value.replace(
    /[&<>"']/g,
    (character) =>
      ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" })[
        character
      ]!,
  );
}

export function emailFirstName(value: unknown, fallback = "there"): string {
  const first = typeof value === "string"
    ? value.trim().split(/\s+/)[0].replace(/[\u0000-\u001f\u007f]/g, "").slice(
      0,
      50,
    )
    : "";
  return emailText(first || fallback);
}

export function emailUrl(value: string): string {
  const url = new URL(value);
  if (url.protocol !== "https:" || url.username || url.password) {
    throw new Error("invalid_email_url");
  }
  return emailText(url.toString());
}

export function emailSubjects(value: string): string {
  const labels: Record<string, string> = {
    biology: "AP Biology",
    "ap-biology": "AP Biology",
    chemistry: "AP Chemistry",
    "ap-chemistry": "AP Chemistry",
    statistics: "AP Statistics",
    "ap-statistics": "AP Statistics",
    "physics-1": "AP Physics 1",
    "ap-physics-1": "AP Physics 1",
    "physics-2": "AP Physics 2",
    "ap-physics-2": "AP Physics 2",
    "physics-c-mechanics": "AP Physics C: Mechanics",
    "ap-physics-c-mechanics": "AP Physics C: Mechanics",
    "ap-physics-c-em": "AP Physics C: Electricity and Magnetism",
    "physics-c-electricity-and-magnetism":
      "AP Physics C: Electricity and Magnetism",
    "calculus-ab": "AP Calculus AB",
    "ap-calculus-ab": "AP Calculus AB",
    "calculus-bc": "AP Calculus BC",
    "ap-calculus-bc": "AP Calculus BC",
    "ap-precalculus": "AP Precalculus",
  };
  return emailText(
    value.split(",").map((key) => {
      const subject = key.trim();
      return labels[subject.replaceAll("_", "-")] ?? subject;
    }).filter(Boolean).join(", ") || "Your purchased subjects",
  );
}

export function emailAmount(amountTotal: number, currency: string): string {
  if (!Number.isSafeInteger(amountTotal) || amountTotal < 0) {
    throw new Error("invalid_email_amount");
  }
  // Checkout's current catalog is USD-only; don't guess other minor-unit scales.
  if (currency.toLowerCase() !== "usd") {
    throw new Error("unsupported_email_currency");
  }
  return new Intl.NumberFormat("en-US", {
    style: "currency",
    currency: "USD",
  }).format(amountTotal / 100);
}

export function emailFooter() {
  return {
    mailingAddress: emailText(
      requireEmailConfig("TRANSACTIONAL_MAILING_ADDRESS"),
    ),
  };
}

export function parentRequestVariables(input: {
  studentName: string;
  subjects: string;
  amountTotal: number;
  currency: string;
  checkoutUrl: string;
  expiresAt: number;
  parentEmail: string;
}) {
  if (!Number.isSafeInteger(input.expiresAt) || input.expiresAt <= 0) {
    throw new Error("invalid_email_expiry");
  }
  return {
    studentName: emailFirstName(input.studentName, "your student"),
    subjects: emailSubjects(input.subjects),
    amount: emailAmount(input.amountTotal, input.currency),
    paymentUrl: emailUrl(input.checkoutUrl),
    expiresOn: new Intl.DateTimeFormat("en-US", {
      dateStyle: "medium",
      timeStyle: "short",
      timeZone: "UTC",
    }).format(new Date(input.expiresAt * 1000)) + " UTC",
    parentEmail: emailText(input.parentEmail),
    ...emailFooter(),
  };
}
