import {
  assertEquals,
} from "https://deno.land/std@0.224.0/assert/mod.ts";
import { sanitizeGrowthProperties } from "./growth-events.ts";

Deno.test("growth properties retain only coarse allowlisted values", () => {
  assertEquals(
    sanitizeGrowthProperties({
      subject_key: "biology",
      utm_source: "reddit",
      answer_text: "sensitive student response",
      points_earned: 2,
      email: "student@example.com",
      nested: { unsafe: true },
    }),
    {
      subject_key: "biology",
      utm_source: "reddit",
    },
  );
});

Deno.test("growth property strings are bounded", () => {
  const result = sanitizeGrowthProperties({ utm_campaign: "x".repeat(300) });
  assertEquals((result.utm_campaign as string).length, 200);
});
