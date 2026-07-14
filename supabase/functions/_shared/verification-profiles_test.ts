import {
  getVerificationProfile,
  formatVerificationProfileSummary,
  summarizeVerificationProfile,
} from "./verification-profiles.ts";

Deno.test("returns the AP Statistics verification profile", () => {
  const profile = getVerificationProfile("ap-statistics");

  if (!profile) throw new Error("expected profile");
  if (profile.subject_key !== "ap-statistics") {
    throw new Error("expected ap-statistics subject key");
  }
  if (profile.key_payload.items_keyed.length !== 3) {
    throw new Error("expected 3 keyed items");
  }
});

Deno.test("returns null for subjects without a profile", () => {
  const profile = getVerificationProfile("ap-biology");
  if (profile !== null) throw new Error("expected null");
});

Deno.test("returns the AP Calculus AB verification profile", () => {
  const profile = getVerificationProfile("ap-calculus-ab");

  if (!profile) throw new Error("expected profile");
  if (profile.subject_key !== "ap-calculus-ab") {
    throw new Error("expected ap-calculus-ab subject key");
  }
  if (profile.key_payload.items_keyed.length !== 8) {
    throw new Error("expected 8 keyed items");
  }
});

Deno.test("returns the AP Chemistry verification profile", () => {
  const profile = getVerificationProfile("ap-chemistry");

  if (!profile) throw new Error("expected profile");
  if (profile.subject_key !== "ap-chemistry") {
    throw new Error("expected ap-chemistry subject key");
  }
  if (profile.key_payload.items_keyed.length !== 8) {
    throw new Error("expected 8 keyed items");
  }
});

Deno.test("summarizes the AP Statistics profile for feedback use", () => {
  const summary = summarizeVerificationProfile(
    getVerificationProfile("ap-statistics"),
  );

  if (!summary) throw new Error("expected summary");
  if (summary.keyed_items.length !== 3) {
    throw new Error("expected 3 keyed items");
  }
  if (summary.required_checks.length !== 4) {
    throw new Error("expected 4 required checks");
  }
});

Deno.test("formats the AP Statistics profile as readable feedback", () => {
  const formatted = formatVerificationProfileSummary(
    getVerificationProfile("ap-statistics"),
  );

  if (!formatted) throw new Error("expected formatted summary");
  if (!formatted.includes("AP Statistics verification profile")) {
    throw new Error("expected display name");
  }
  if (!formatted.includes("Keyed items: APSTAT-MOD3-H001-INV")) {
    throw new Error("expected keyed items");
  }
});
