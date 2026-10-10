import { assertEquals } from "jsr:@std/assert@1";
import { canonicalPhotoSubject, photoEnabledFor } from "./frq-photo-rollout.ts";

Deno.test("subject keys from both namespaces normalise to one form", () => {
  assertEquals(canonicalPhotoSubject("biology"), "biology");
  assertEquals(canonicalPhotoSubject("ap_biology"), "biology");
  assertEquals(canonicalPhotoSubject("ap-biology"), "biology");
  assertEquals(canonicalPhotoSubject("AP_Statistics"), "statistics");
  assertEquals(canonicalPhotoSubject("ap-calculus-ab"), "calculus-ab");
  assertEquals(canonicalPhotoSubject(""), null);
  assertEquals(canonicalPhotoSubject(null), null);
});

Deno.test("default is dark: admins only", () => {
  assertEquals(photoEnabledFor({ subjectKey: "ap-statistics", configured: undefined, isAdmin: false }), false);
  assertEquals(photoEnabledFor({ subjectKey: "ap-statistics", configured: "", isAdmin: false }), false);
  assertEquals(photoEnabledFor({ subjectKey: "ap-statistics", configured: "none", isAdmin: false }), false);
  assertEquals(photoEnabledFor({ subjectKey: "ap-statistics", configured: undefined, isAdmin: true }), true);
});

Deno.test("a subject list and 'all' widen it", () => {
  const configured = "ap-biology, ap_statistics";
  assertEquals(photoEnabledFor({ subjectKey: "biology", configured, isAdmin: false }), true);
  assertEquals(photoEnabledFor({ subjectKey: "ap-statistics", configured, isAdmin: false }), true);
  assertEquals(photoEnabledFor({ subjectKey: "ap-chemistry", configured, isAdmin: false }), false);
  assertEquals(photoEnabledFor({ subjectKey: "ap-chemistry", configured: "ALL", isAdmin: false }), true);
  assertEquals(photoEnabledFor({ subjectKey: null, configured, isAdmin: false }), false);
});
