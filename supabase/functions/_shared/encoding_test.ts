import { bytesToBase64, sha256Bytes, sha256Text } from "./encoding.ts";
import { assertEquals } from "jsr:@std/assert@1";

Deno.test("SHA-256 preserves known UTF-8 digest and lowercase zero-padded hex", async () => {
  assertEquals(await sha256Text("abc"), "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad");
  assertEquals(await sha256Text(""), "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855");
  assertEquals(await sha256Text("π🙂"), await sha256Bytes(new TextEncoder().encode("π🙂")));
});
Deno.test("Base64 preserves empty, binary, and cross-chunk payloads", () => {
  for (const size of [0, 1, 2, 3, 0x8000, 0x8001, 100000]) {
    const bytes = Uint8Array.from({ length: size }, (_, i) => i % 256);
    const decoded = Uint8Array.from(atob(bytesToBase64(bytes)), c => c.charCodeAt(0));
    assertEquals(decoded, bytes);
  }
});
