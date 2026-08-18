import {
  assertEquals,
  assertFalse,
} from "https://deno.land/std@0.224.0/assert/mod.ts";
import { isSafeStoragePath, ownsLearnerPath } from "./storage-paths.ts";

Deno.test("isSafeStoragePath rejects traversal and absolute paths", () => {
  assertFalse(isSafeStoragePath(""));
  assertFalse(isSafeStoragePath("/abs/path.png"));
  assertFalse(isSafeStoragePath("../escape.png"));
  assertFalse(isSafeStoragePath("a/../../b.png"));
  assertFalse(isSafeStoragePath("a\\b.png"));
  assertFalse(isSafeStoragePath("a//b.png"));
  assertFalse(isSafeStoragePath("a\0b.png"));
});

Deno.test("isSafeStoragePath accepts a normal relative object name", () => {
  assertEquals(
    isSafeStoragePath("11111111-1111-1111-1111-111111111111/captures/abc.jpg"),
    true,
  );
});

Deno.test("ownsLearnerPath requires the first segment to match the user id", () => {
  const uid = "11111111-1111-1111-1111-111111111111";
  assertEquals(ownsLearnerPath(uid, `${uid}/captures/abc.jpg`), true);
  assertFalse(ownsLearnerPath(uid, "someone-else/captures/abc.jpg"));
  assertFalse(ownsLearnerPath(uid, "captures/abc.jpg"));
});
