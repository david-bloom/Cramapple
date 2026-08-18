// Tests for run_pilot.mjs's request-body capture hash (replan 1.2: persist
// a SHA-256 of the outbound request body per call so arm-diff verification
// is possible offline). The script's main body is guarded behind IS_MAIN,
// so importing it here has no side effects (no env, no session file, no
// network).
import { requestBodySha256 } from "./run_pilot.mjs";

Deno.test("request body hash is the SHA-256 of the exact serialized body", () => {
  // Precomputed: echo -n '{"operation":"grade_initial_attempt"}' | shasum -a 256
  const expected =
    "52373815f7c750f9f0c49deb678249a261a4516e8d24edbf643a8a89e5bc50b4";
  const actual = requestBodySha256('{"operation":"grade_initial_attempt"}');
  if (actual !== expected) {
    throw new Error(`hash mismatch: ${actual}`);
  }
});

Deno.test("byte-identical bodies hash identically; any difference changes the hash", () => {
  const a = requestBodySha256('{"arm":"off"}');
  const b = requestBodySha256('{"arm":"off"}');
  const c = requestBodySha256('{"arm":"with_exemplar"}');
  if (a !== b) throw new Error("hash must be deterministic");
  if (a === c) throw new Error("differing bodies must not collide");
});
