// TASK-0060 regression guard for parent payment short links.
import {
  assert,
  assertEquals,
  assertMatch,
  assertNotEquals,
} from "https://deno.land/std@0.224.0/assert/mod.ts";
import {
  classifyParentSession,
  generateShortCode,
  normalizeShortCode,
  SHORT_CODE_ALPHABET,
  SHORT_CODE_LENGTH,
  shortLinkUrl,
} from "./parent-short-link.ts";

Deno.test("alphabet has 31 unambiguous characters", () => {
  assertEquals(SHORT_CODE_ALPHABET.length, 31);
  assertEquals(new Set(SHORT_CODE_ALPHABET).size, 31);
  for (const banned of "ilo01") assert(!SHORT_CODE_ALPHABET.includes(banned));
});

Deno.test("generated codes are 8 characters from the alphabet", () => {
  for (let i = 0; i < 200; i++) {
    const code = generateShortCode();
    assertEquals(code.length, SHORT_CODE_LENGTH);
    assertMatch(code, /^[a-hjkmnp-z2-9]{8}$/);
    assertEquals(normalizeShortCode(code), code);
  }
});

Deno.test("generated codes do not repeat across a large sample", () => {
  const seen = new Set<string>();
  for (let i = 0; i < 5000; i++) seen.add(generateShortCode());
  assertEquals(seen.size, 5000);
});

Deno.test("rejection sampling skips biased bytes", () => {
  // 248 and above would skew the modulo, so they must be skipped.
  const bytes = new Uint8Array(16).fill(255);
  bytes.set([0, 1, 2, 3, 4, 5, 6, 7], 8);
  const code = generateShortCode(() => bytes);
  assertEquals(code, SHORT_CODE_ALPHABET.slice(0, 8));
});

Deno.test("normalizeShortCode accepts valid codes case-insensitively and rejects the rest", () => {
  assertEquals(normalizeShortCode(" ABCDEFGH "), "abcdefgh");
  assertEquals(normalizeShortCode("abcdefg"), null);
  assertEquals(normalizeShortCode("abcdefghj"), null);
  assertEquals(normalizeShortCode("abcdefg1"), null);
  assertEquals(normalizeShortCode("abcdefgl"), null);
  assertEquals(normalizeShortCode("abc defg"), null);
  assertEquals(normalizeShortCode(12345678), null);
  assertEquals(normalizeShortCode(null), null);
});

Deno.test("shortLinkUrl joins base and code without double slashes", () => {
  assertEquals(shortLinkUrl("https://cramapple.com", "abcdefgh"), "https://cramapple.com/p/abcdefgh");
  assertEquals(shortLinkUrl("https://cramapple.com/", "abcdefgh"), "https://cramapple.com/p/abcdefgh");
});

const parentMeta = { purchase_type: "parent_share" };

Deno.test("open parent session resolves to its URL", () => {
  assertEquals(
    classifyParentSession({ status: "open", payment_status: "unpaid", url: "https://checkout.example/c/pay/cs_x#frag", metadata: parentMeta }),
    { state: "open", url: "https://checkout.example/c/pay/cs_x#frag" },
  );
});

Deno.test("paid and completed sessions report paid", () => {
  assertEquals(classifyParentSession({ status: "complete", payment_status: "paid", metadata: parentMeta }), { state: "paid" });
  assertEquals(classifyParentSession({ status: "open", payment_status: "paid", url: "u", metadata: parentMeta }), { state: "paid" });
});

Deno.test("expired, missing-url and unknown sessions report expired", () => {
  assertEquals(classifyParentSession({ status: "expired", payment_status: "unpaid", metadata: parentMeta }), { state: "expired" });
  assertEquals(classifyParentSession({ status: "open", payment_status: "unpaid", url: null, metadata: parentMeta }), { state: "expired" });
  assertEquals(classifyParentSession({ status: null, metadata: parentMeta }), { state: "expired" });
});

Deno.test("a student session never resolves through a short link", () => {
  const student = classifyParentSession({ status: "open", payment_status: "unpaid", url: "https://x", metadata: { purchase_type: "student_direct" } });
  assertEquals(student, { state: "expired" });
  assertNotEquals(student.state, "open");
  assertEquals(classifyParentSession({ status: "open", url: "https://x", metadata: null }), { state: "expired" });
});
