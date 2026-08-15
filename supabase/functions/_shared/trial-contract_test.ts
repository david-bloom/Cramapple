import { assertEquals } from "https://deno.land/std@0.224.0/assert/mod.ts";
import { asString, sanitizeTouch } from "./trial-contract.ts";

Deno.test("trial touch data keeps only bounded attribution fields", () => {
  const result = sanitizeTouch({
    utm_source: " reddit ",
    utm_medium: "paid-social",
    landing_path: "/start-trial",
    reddit_click_id: "rclid_123",
    answer_text: "private student answer",
    email: "student@example.com",
    nested: { unsafe: true },
    utm_campaign: "x".repeat(400),
  });

  assertEquals(result, {
    utm_source: "reddit",
    utm_medium: "paid-social",
    landing_path: "/start-trial",
    reddit_click_id: "rclid_123",
    utm_campaign: "x".repeat(300),
  });
});

Deno.test("trial touch data rejects arrays and non-string values", () => {
  assertEquals(sanitizeTouch(["utm_source"]), {});
  assertEquals(sanitizeTouch(null), {});
  assertEquals(sanitizeTouch({ utm_source: 42, referrer_host: "" }), {});
});

Deno.test("trial asString trims and rejects blank strings", () => {
  assertEquals(asString("  start  "), "start");
  assertEquals(asString(""), null);
  assertEquals(asString("   "), null);
  assertEquals(asString(42), null);
});
