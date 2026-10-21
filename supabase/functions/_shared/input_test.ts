import { assertEquals } from "jsr:@std/assert@1";
import { coercedInteger, emailAddress, looseUuid, nonEmptyString, stringOrNull, trimmedNonEmptyString, trimmedStringOrEmpty, trimmedUuidShape, uuidShape } from "./input.ts";
Deno.test("string parser variants retain whitespace, emptiness and non-string differences", () => {
  assertEquals([trimmedNonEmptyString(" x "), nonEmptyString(" x "), stringOrNull(" x "), trimmedStringOrEmpty(" x ")], ["x", " x ", " x ", "x"]);
  assertEquals([trimmedNonEmptyString(" "), nonEmptyString(" "), stringOrNull(" "), trimmedStringOrEmpty(null)], [null, null, " ", ""]);
  assertEquals([stringOrNull(""), stringOrNull(1), trimmedNonEmptyString(false)], ["", null, null]);
});
Deno.test("UUID variants preserve loose compatibility and explicit trimming", () => {
  const valid = "AAAAAAAA-AAAA-4AAA-8AAA-AAAAAAAAAAAA";
  assertEquals(uuidShape(valid), valid);
  assertEquals(uuidShape(` ${valid} `), null);
  assertEquals(trimmedUuidShape(` ${valid} `), valid);
  assertEquals(looseUuid("-".repeat(36)), "-".repeat(36));
  assertEquals(uuidShape("-".repeat(36)), null);
  for (const bad of [null, 1, "", "a".repeat(35), "z".repeat(36)]) assertEquals(looseUuid(bad), null);
});
Deno.test("integer and email extraction preserve legacy coercion and normalization", () => {
  assertEquals([coercedInteger(null), coercedInteger(" "), coercedInteger("12"), coercedInteger("1.2"), coercedInteger(Infinity)], [0, 0, 12, null, null]);
  assertEquals(emailAddress(" Person@EXAMPLE.COM "), "person@example.com");
  for (const bad of [null, "", "bad", "x y@example.com", "a@@b.c"]) assertEquals(emailAddress(bad), null);
});
