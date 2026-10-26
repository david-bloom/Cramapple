import { assertEquals } from "https://deno.land/std@0.224.0/assert/mod.ts";
import {
  asString,
  attributionFromMetadata,
  attributionMetadata,
  sanitizeAdAttribution,
  sanitizeTouch,
} from "./trial-contract.ts";

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

Deno.test("ad attribution keeps allow-listed touch fields and the anonymous id", () => {
  assertEquals(
    sanitizeAdAttribution({
      ad_tracking_allowed: true,
      anon_id: "0190a1b2-c3d4-7e5f-8a9b-0c1d2e3f4a5b",
      first_touch: { utm_source: "reddit", utm_medium: "paid_social", email: "x@y.com" },
      last_touch: { utm_content: "ad-07", gclid: "abc", landing_path: "/ap-biology-prep" },
      email: "student@example.com",
    }),
    {
      ad_tracking_allowed: true,
      anon_id: "0190a1b2-c3d4-7e5f-8a9b-0c1d2e3f4a5b",
      first_touch: { utm_source: "reddit", utm_medium: "paid_social" },
      last_touch: { utm_content: "ad-07", gclid: "abc", landing_path: "/ap-biology-prep" },
    },
  );
});

Deno.test("ad attribution for an opted-out visitor keeps first-party source only", () => {
  assertEquals(
    sanitizeAdAttribution({
      ad_tracking_allowed: false,
      anon_id: "0190a1b2-c3d4-7e5f-8a9b-0c1d2e3f4a5b",
      first_touch: { utm_source: "reddit", gclid: "g1" },
      last_touch: { utm_content: "ad-07", reddit_click_id: "r1", referrer_host: "www.reddit.com" },
    }),
    {
      ad_tracking_allowed: false,
      first_touch: { utm_source: "reddit" },
      last_touch: { utm_content: "ad-07", referrer_host: "www.reddit.com" },
    },
  );
  assertEquals(sanitizeAdAttribution({ utm_source: "reddit" }), { ad_tracking_allowed: false });
});

Deno.test("pay-now metadata round-trips last-touch-else-first source fields", () => {
  const a = sanitizeAdAttribution({
    ad_tracking_allowed: true,
    first_touch: { utm_source: "tiktok", utm_campaign: "c1" },
    last_touch: { utm_source: "reddit", utm_content: "ad-07" },
  });
  const meta = attributionMetadata(a);
  assertEquals(meta, { attr_utm_source: "reddit", attr_utm_campaign: "c1", attr_utm_content: "ad-07" });
  assertEquals(attributionFromMetadata(meta), { utm_source: "reddit", utm_campaign: "c1", utm_content: "ad-07" });
  assertEquals(attributionMetadata(null), {});
});

Deno.test("ad attribution reads the legacy flat reddit click id as last touch", () => {
  assertEquals(sanitizeAdAttribution({ ad_tracking_allowed: true, reddit_click_id: "rclid_9" }), {
    ad_tracking_allowed: true,
    last_touch: { reddit_click_id: "rclid_9" },
  });
});

Deno.test("ad attribution rejects bad shapes and malformed anonymous ids", () => {
  assertEquals(sanitizeAdAttribution(null), null);
  assertEquals(sanitizeAdAttribution(["x"]), null);
  assertEquals(sanitizeAdAttribution("reddit"), null);
  assertEquals(sanitizeAdAttribution({ ad_tracking_allowed: true, anon_id: "has spaces & junk" }), {
    ad_tracking_allowed: true,
  });
});
