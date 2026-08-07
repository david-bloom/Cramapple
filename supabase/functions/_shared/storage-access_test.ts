// TASK-0021 regression guard.
// Task: docs/tasks/TASK-0021-BIOLOGY-PROMPT-VISUAL-STUDENT-DELIVERY.md
//
// TASK-0021 adds a student-facing read path for prompt visuals. It does so
// through student-session-items, which signs per item version with the service
// role -- NOT by widening this predicate. These tests exist so that a future
// change which "just adds student to content-assets" fails loudly: that would
// expose authoring/reviewer-only material in the same bucket.

import { assertEquals, assertFalse } from "https://deno.land/std@0.224.0/assert/mod.ts";
import { canAccessBucket, type StorageMode } from "./storage-access.ts";

const MODES: StorageMode[] = ["sign_upload", "sign_download", "sign_delete"];

Deno.test("student has no content-assets access in any mode", () => {
  for (const mode of MODES) {
    assertFalse(
      canAccessBucket("student", "content-assets", mode),
      `student must not access content-assets via ${mode}`,
    );
  }
});

Deno.test("content-assets remains admin/content_author only", () => {
  for (const mode of MODES) {
    assertEquals(canAccessBucket("admin", "content-assets", mode), true);
    assertEquals(canAccessBucket("content_author", "content-assets", mode), true);

    // Reviewer roles are signed for by review-queue, not by this function.
    for (const role of ["tutor", "reader", "validator", "student", "anon", ""]) {
      assertFalse(
        canAccessBucket(role, "content-assets", mode),
        `${role} must not access content-assets via ${mode}`,
      );
    }
  }
});

Deno.test("other buckets are unchanged by TASK-0021", () => {
  for (const mode of MODES) {
    assertEquals(canAccessBucket("student", "learner-uploads", mode), true);
    assertEquals(canAccessBucket("admin", "learner-uploads", mode), true);
    assertFalse(canAccessBucket("content_author", "learner-uploads", mode));

    assertEquals(canAccessBucket("validator", "validation-artifacts", mode), true);
    assertEquals(canAccessBucket("admin", "validation-artifacts", mode), true);
    assertFalse(canAccessBucket("student", "validation-artifacts", mode));
  }
});

Deno.test("unknown buckets stay closed except admin delete", () => {
  assertFalse(canAccessBucket("admin", "some-other-bucket", "sign_download"));
  assertFalse(canAccessBucket("student", "some-other-bucket", "sign_delete"));
  assertEquals(canAccessBucket("admin", "some-other-bucket", "sign_delete"), true);
});
